#pragma once
// Shared bounded attacker. Defaults preserve the original XCTest protocol.
#include "../Scramble/Public/Soccer3.hpp"

#include <algorithm>
#include <array>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <functional>
#include <limits>
#include <random>
#include <tuple>
#include <utility>
#include <vector>

namespace StatisticalRecovery { namespace {
using Bytes = std::vector<std::uint8_t>;
using Oracle = std::function<bool(const Bytes &, Bytes &)>;
constexpr std::size_t kFlags = 64U;
constexpr std::size_t kFixtures = 2U;
constexpr std::size_t kTrain = 4096U;
constexpr std::size_t kValidate = 4096U;
constexpr std::size_t kChallenge = 16384U;
constexpr std::size_t kConfirm = 8192U;
constexpr std::size_t kShortlist = 16U;
constexpr std::size_t kAnchors = 1024U;
constexpr std::size_t kProbeAnchorsPerFlag = 8U;
constexpr std::size_t kBlockBytes = SOCCER_BLOCK_SIZE;
constexpr std::uint32_t kNoBit = std::numeric_limits<std::uint32_t>::max();
// Bonferroni over the frozen prediction for every flag in all six full-plan
// scenarios. Discovery/validation may examine many candidates, but neither
// sees challenge labels. Dependence BETWEEN flags does not invalidate this.
constexpr std::size_t kHypotheses = 3U * kFixtures * kFlags;
constexpr double kFamilyAlpha = 1.0e-6;
static_assert(kBlockBytes == (1U << 20U));
static_assert(kTrain % 64U == 0U);

struct Scenario {
    Bytes mTemplate;
    std::array<std::uint32_t, kFlags> mBits{};
};

void Fill(Bytes &bytes, std::mt19937_64 &random) {
    for (std::size_t i = 0U; i < bytes.size(); i += 8U) {
        const auto word = random();
        std::memcpy(bytes.data() + i, &word, std::min(std::size_t{8U}, bytes.size() - i));
    }
}

Scenario MakeScenario(std::size_t bytes) {
    Scenario s;
    s.mTemplate.resize(bytes);
    std::mt19937_64 random(0x838A9159A7EF3D61ULL);
    Fill(s.mTemplate, random);
    for (std::size_t i = 0U; i < kFlags; ++i) {
        // First 32 bytes form the cluster; remaining flags span the whole
        // block, including different offsets inside 64-byte windows.
        const auto position = i < 32U ? i : 32U + (i - 32U) * (bytes - 32U) / 32U;
        const auto row = i % 8U;
        s.mBits[i] = static_cast<std::uint32_t>(position * 8U + row);
        s.mTemplate[position] &= static_cast<std::uint8_t>(~(1U << row));
    }
    return s;
}

Bytes WithFlags(const Scenario &s, std::uint64_t flags) {
    Bytes input = s.mTemplate;
    for (std::size_t i = 0U; i < kFlags; ++i) {
        const auto bit = s.mBits[i];
        input[bit / 8U] |= static_cast<std::uint8_t>(((flags >> i) & 1U) << (bit % 8U));
    }
    return input;
}

bool ValidScenario(const Scenario &s) {
    if (s.mTemplate.size() < 64U) { return false; }
    auto bits = s.mBits;
    std::sort(bits.begin(), bits.end());
    if (bits.back() >= s.mTemplate.size() * 8U ||
        std::adjacent_find(bits.begin(), bits.end()) != bits.end()) { return false; }
    for (auto bit : bits) {
        if (s.mTemplate[bit / 8U] & (1U << (bit % 8U))) { return false; }
    }
    return true;
}

struct Feature {
    std::uint32_t mA = kNoBit;
    std::uint32_t mB = kNoBit;
    bool operator<(const Feature &other) const {
        return std::tie(mA, mB) < std::tie(other.mA, other.mB);
    }
    bool operator==(const Feature &other) const { return mA == other.mA && mB == other.mB; }
};

unsigned Evaluate(const Feature &f, const Bytes &ciphertext) {
    const auto first = (ciphertext[f.mA / 8U] >> (f.mA % 8U)) & 1U;
    return f.mB == kNoBit ? first : first ^ ((ciphertext[f.mB / 8U] >> (f.mB % 8U)) & 1U);
}

struct Candidate {
    Feature mFeature;
    std::size_t mTrainingCorrect = 0U;
    unsigned mPolarity = 0U;
};
struct Model {
    std::array<Candidate, kFlags> mPredictions{};
    std::size_t mBytes = 0U;
    std::size_t mFeatures = 0U;
    std::size_t mSampledBytes = 0U;
    std::size_t mQueries = 0U;
    bool mReady = false;
};

// Prediction has no oracle, plaintext, labels, PRNG, password, or plan access.
bool Predict(const Model &model, const Bytes &ciphertext, std::uint64_t &flags) {
    if (!model.mReady || ciphertext.size() != model.mBytes) { return false; }
    flags = 0U;
    for (std::size_t i = 0U; i < kFlags; ++i) {
        const auto &c = model.mPredictions[i];
        flags |= static_cast<std::uint64_t>(Evaluate(c.mFeature, ciphertext) ^ c.mPolarity) << i;
    }
    return true;
}

// 65 public chosen-plaintext probes locate additional candidate BYTES. They
// reveal no internal mapping: sample bytes changed by each isolated flag flip.
// This makes the bounded search less dependent on randomly hitting a sparse
// output path. Probe labels are never re-used for training or challenges.
bool Discover(const Oracle &encrypt, const Scenario &s, std::vector<Feature> &features,
              std::size_t &queries) {
    std::vector<std::uint32_t> anchors;
    const auto bytes = s.mTemplate.size();
    const auto count = std::min(kAnchors, bytes);
    std::mt19937_64 random(0x77AD1B4E3C42B023ULL);
    for (std::size_t i = 0U; i < count; ++i) {
        const auto lo = i * bytes / count, hi = (i + 1U) * bytes / count;
        anchors.push_back(static_cast<std::uint32_t>(lo + random() % (hi - lo)));
    }
    for (auto bit : s.mBits) { anchors.push_back(bit / 8U); }
    Bytes baseline, output;
    if (!encrypt(s.mTemplate, baseline) || baseline.size() != bytes) { return false; }
    ++queries;
    for (std::size_t flag = 0U; flag < kFlags; ++flag) {
        if (!encrypt(WithFlags(s, std::uint64_t{1U} << flag), output) || output.size() != bytes) { return false; }
        ++queries;
        std::vector<std::uint32_t> reservoir;
        std::size_t seen = 0U;
        for (std::size_t byte = 0U; byte < bytes; ++byte) {
            if (baseline[byte] == output[byte]) { continue; }
            ++seen;
            if (reservoir.size() < kProbeAnchorsPerFlag) {
                reservoir.push_back(static_cast<std::uint32_t>(byte));
            } else {
                const auto index = random() % seen;
                if (index < reservoir.size()) { reservoir[index] = static_cast<std::uint32_t>(byte); }
            }
        }
        anchors.insert(anchors.end(), reservoir.begin(), reservoir.end());
    }
    std::sort(anchors.begin(), anchors.end());
    anchors.erase(std::unique(anchors.begin(), anchors.end()), anchors.end());
    auto add = [&](std::uint32_t a, std::uint32_t b = kNoBit) {
        if (b != kNoBit && a > b) { std::swap(a, b); }
        if (a != b) { features.push_back({a, b}); }
    };
    for (auto byte : anchors) {
        for (unsigned a = 0U; a < 8U; ++a) {
            add(byte * 8U + a);
            for (unsigned b = a + 1U; b < 8U; ++b) { add(byte * 8U + a, byte * 8U + b); }
            for (auto distance : {1U, 8U, 32U, 64U,
                                   static_cast<unsigned>(bytes / 4U), static_cast<unsigned>(bytes / 2U)}) {
                const auto other = static_cast<std::uint32_t>((byte + distance) % bytes);
                add(byte * 8U + a, other * 8U + a);
                add(byte * 8U + a, other * 8U + ((a + 3U) % 8U));
            }
        }
    }
    std::sort(features.begin(), features.end());
    features.erase(std::unique(features.begin(), features.end()), features.end());
    return !features.empty();
}

// Store just sampled ciphertext bit columns, packed across queries. The large
// candidate search uses all 4096 training observations, including polarity
// choice. Keep 16 survivors per flag for independent validation.
bool Train(const Oracle &encrypt, const Scenario &s, Model &model, bool printProgress = true) {
    model = {};
    if (!ValidScenario(s)) { return false; }
    model.mBytes = s.mTemplate.size();
    std::vector<Feature> features;
    if (!Discover(encrypt, s, features, model.mQueries)) { return false; }
    model.mFeatures = features.size();
    std::vector<std::uint32_t> addresses;
    for (const auto &f : features) {
        addresses.push_back(f.mA / 8U);
        if (f.mB != kNoBit) { addresses.push_back(f.mB / 8U); }
    }
    std::sort(addresses.begin(), addresses.end());
    addresses.erase(std::unique(addresses.begin(), addresses.end()), addresses.end());
    model.mSampledBytes = addresses.size();
    constexpr auto words = kTrain / 64U;
    std::vector<std::size_t> index(model.mBytes);
    for (std::size_t i = 0U; i < addresses.size(); ++i) { index[addresses[i]] = i * 8U; }
    std::vector<std::uint64_t> columns(addresses.size() * 8U * words);
    std::array<std::array<std::uint64_t, words>, kFlags> labels{};
    std::mt19937_64 random(0xC7EA929B4D5F3120ULL);
    Bytes output;
    for (std::size_t q = 0U; q < kTrain; ++q) {
        const auto flags = random();
        if (!encrypt(WithFlags(s, flags), output) || output.size() != model.mBytes) { return false; }
        ++model.mQueries;
        const auto word = q / 64U, shift = q % 64U;
        for (std::size_t i = 0U; i < addresses.size(); ++i) {
            for (unsigned bit = 0U; bit < 8U; ++bit) {
                columns[(i * 8U + bit) * words + word] |=
                    static_cast<std::uint64_t>((output[addresses[i]] >> bit) & 1U) << shift;
            }
        }
        for (std::size_t flag = 0U; flag < kFlags; ++flag) {
            labels[flag][word] |= ((flags >> flag) & 1U) << shift;
        }
    }
    auto column = [&](std::uint32_t bit) {
        return columns.data() + (index[bit / 8U] + bit % 8U) * words;
    };
    auto correct = [&](const Feature &f, std::size_t flag, std::size_t n) {
        const auto *a = column(f.mA);
        const auto *b = f.mB == kNoBit ? nullptr : column(f.mB);
        std::size_t errors = 0U;
        for (std::size_t w = 0U; w < n / 64U; ++w) {
            errors += __builtin_popcountll(a[w] ^ (b ? b[w] : 0U) ^ labels[flag][w]);
        }
        return n - errors;
    };
    std::array<std::vector<Candidate>, kFlags> shortlist;
    for (const auto &f : features) {
        for (std::size_t flag = 0U; flag < kFlags; ++flag) {
            const auto hits = correct(f, flag, kTrain);
            const auto score = std::max(hits, kTrain - hits);
            auto &list = shortlist[flag];
            if (list.size() == kShortlist && score <= list.back().mTrainingCorrect) { continue; }
            list.push_back({f, score, static_cast<unsigned>(hits < kTrain / 2U)});
            std::stable_sort(list.begin(), list.end(), [](const auto &a, const auto &b) {
                return a.mTrainingCorrect > b.mTrainingCorrect;
            });
            if (list.size() > kShortlist) { list.pop_back(); }
        }
    }
    // Separate labels choose one predictor per flag; no challenge feedback.
    std::array<std::array<std::size_t, kShortlist>, kFlags> validation{};
    std::mt19937_64 validationRandom(0x5A8C1B704E93D226ULL);
    for (std::size_t q = 0U; q < kValidate; ++q) {
        const auto flags = validationRandom();
        if (!encrypt(WithFlags(s, flags), output) || output.size() != model.mBytes) { return false; }
        ++model.mQueries;
        for (std::size_t flag = 0U; flag < kFlags; ++flag) {
            for (std::size_t i = 0U; i < shortlist[flag].size(); ++i) {
                const auto &c = shortlist[flag][i];
                validation[flag][i] += (Evaluate(c.mFeature, output) ^ c.mPolarity) == ((flags >> flag) & 1U);
            }
        }
    }
    for (std::size_t flag = 0U; flag < kFlags; ++flag) {
        const auto count = shortlist[flag].size();
        if (count == 0U) { return false; }
        const auto best = std::max_element(validation[flag].begin(), validation[flag].begin() + count);
        model.mPredictions[flag] = shortlist[flag][best - validation[flag].begin()];
    }
    model.mReady = true;
    if (printProgress && model.mBytes == kBlockBytes) {
        std::printf("Statistical recovery training complete: queries=%zu features=%zu sampled_bytes=%zu\n",
                    model.mQueries, model.mFeatures, model.mSampledBytes);
        std::fflush(stdout);
    }
    return true;
}

// One-sided Hoeffding bound for a fixed predictor on fresh fair labels, then
// Bonferroni. Conservative, not an exact binomial p-value. Polarity is frozen;
// do NOT flip below-chance predictions after inspecting challenge labels.
double AdjustedTailBound(std::size_t correct, std::size_t n, std::size_t hypotheses = kHypotheses) {
    if (n == 0U || correct <= n / 2U) { return 1.0; }
    const double deviation = static_cast<double>(correct) / n - 0.5;
    return std::min(1.0, hypotheses * std::exp(-2.0 * n * deviation * deviation));
}
struct Result {
    std::array<std::size_t, kFlags> mCorrect{};
    std::array<std::size_t, kFlags> mShuffledCorrect{};
    std::size_t mQueries = 0U;
    std::size_t mExactPlaintexts = 0U;
    std::uint64_t mSignificant = 0U;
    std::uint64_t mShuffledSignificant = 0U;
};

// Victim/grader owns hidden labels. Only ciphertext crosses into Predict.
bool Challenge(const Oracle &encrypt, const Scenario &s, const Model &model,
               std::size_t count, std::uint64_t seed, Result &result, std::size_t hypotheses = kHypotheses,
               bool printProgress = true) {
    result = {};
    std::mt19937_64 random(seed);
    std::vector<std::uint64_t> secrets, predictions;
    Bytes output;
    for (std::size_t q = 0U; q < count; ++q) {
        const auto secret = random();
        if (!encrypt(WithFlags(s, secret), output)) { return false; }
        ++result.mQueries;
        std::uint64_t prediction = 0U;
        if (!Predict(model, output, prediction)) { return false; }
        secrets.push_back(secret); predictions.push_back(prediction);
        result.mExactPlaintexts += secret == prediction;
        for (std::size_t flag = 0U; flag < kFlags; ++flag) {
            result.mCorrect[flag] += ((secret ^ prediction) & (std::uint64_t{1U} << flag)) == 0U;
        }
        if (printProgress && model.mBytes == kBlockBytes && (q + 1U) % 4096U == 0U) {
            std::printf("Statistical recovery challenge progress: %zu/%zu\n", q + 1U, count);
            std::fflush(stdout);
        }
    }
    // Negative control: break plaintext/ciphertext associations after freezing
    // predictions. Do not use these control labels for training or selection.
    std::mt19937_64 shuffleRandom(seed ^ 0x8CE12AA74359B06FULL);
    std::shuffle(secrets.begin(), secrets.end(), shuffleRandom);
    for (std::size_t q = 0U; q < count; ++q) {
        for (std::size_t flag = 0U; flag < kFlags; ++flag) {
            result.mShuffledCorrect[flag] += ((secrets[q] ^ predictions[q]) & (std::uint64_t{1U} << flag)) == 0U;
        }
    }
    for (std::size_t flag = 0U; flag < kFlags; ++flag) {
        if (AdjustedTailBound(result.mCorrect[flag], count, hypotheses) < kFamilyAlpha) {
            result.mSignificant |= std::uint64_t{1U} << flag;
        }
        if (AdjustedTailBound(result.mShuffledCorrect[flag], count, hypotheses) < kFamilyAlpha) {
            result.mShuffledSignificant |= std::uint64_t{1U} << flag;
        }
    }
    return true;
}

void PrintResult(const char *phase, EncryptionStrength strength, std::size_t fixture,
                 const Scenario &s, const Model &model, const Result &result,
                 std::size_t hypotheses = kHypotheses) {
    const auto best = std::max_element(result.mCorrect.begin(), result.mCorrect.end());
    const auto flag = static_cast<std::size_t>(best - result.mCorrect.begin());
    std::printf("Statistical recovery %s: strength=%u fixture=%zu queries=%zu "
                "features=%zu sampled_bytes=%zu best_flag=%zu accuracy=%zu/%zu (%.4f%%) "
                "adjusted_tail_bound=%.6g significant=0x%016llx shuffled_significant=0x%016llx exact_plaintexts=%zu\n",
                phase, static_cast<unsigned>(strength), fixture, result.mQueries, model.mFeatures,
                model.mSampledBytes, flag, *best, result.mQueries, 100.0 * *best / result.mQueries,
                AdjustedTailBound(*best, result.mQueries, hypotheses),
                static_cast<unsigned long long>(result.mSignificant),
                static_cast<unsigned long long>(result.mShuffledSignificant), result.mExactPlaintexts);
    for (std::size_t layout = 0U; layout < 2U; ++layout) {
        for (std::size_t row = 0U; row < 8U; ++row) {
            std::size_t hits = 0U;
            for (std::size_t i = layout * 32U + row; i < (layout + 1U) * 32U; i += 8U) {
                hits += result.mCorrect[i];
            }
            std::printf("  %s row=%zu correct=%zu/%zu (%.4f%%)\n", layout ? "distributed" : "clustered",
                        row, hits, 4U * result.mQueries, 100.0 * hits / (4U * result.mQueries));
        }
    }
    for (std::size_t i = 0U; i < kFlags; ++i) {
        if (!(result.mSignificant & (std::uint64_t{1U} << i))) { continue; }
        const auto &c = model.mPredictions[i];
        std::printf("  leaked flag=%zu plaintext_byte=%u row=%u ciphertext_bits=(%u,%u) xor=%u "
                    "correct=%zu/%zu adjusted_tail_bound=%.6g (second bit %u means single-bit feature)\n",
                    i, s.mBits[i] / 8U, s.mBits[i] % 8U, c.mFeature.mA, c.mFeature.mB, c.mPolarity,
                    result.mCorrect[i], result.mQueries, AdjustedTailBound(result.mCorrect[i], result.mQueries, hypotheses), kNoBit);
    }
    std::fflush(stdout);
}

struct ClearSoccerOnExit { ~ClearSoccerOnExit() { Soccer3::Zero(); } };
bool SeedFixture(EncryptionStrength strength, std::size_t fixture) {
    constexpr const char *passwords[] = {"review-fixture", "second-fixture"};
    constexpr std::uint64_t nonces[] = {0x2026103001234567ULL, 0xD3B91C764E2085AFULL};
    std::array<std::uint8_t, 14U> password{};
    std::memcpy(password.data(), passwords[fixture], password.size());
    std::uint32_t ack = 0U;
    Soccer3::Zero();
    return Soccer3::AttemptSeed_Encrypt(strength, password.data(), password.size(), nonces[fixture], &ack, 0U, nullptr);
}
} } // namespace StatisticalRecovery

