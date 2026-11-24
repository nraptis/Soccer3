#include "ParitySniffTestCommon.hpp"

#include <algorithm>
#include <array>
#include <bit>
#include <chrono>
#include <cmath>
#include <condition_variable>
#include <cstdarg>
#include <cstdio>
#include <cstring>
#include <functional>
#include <limits>
#include <mutex>
#include <numeric>
#include <random>
#include <set>
#include <sstream>
#include <stdexcept>
#include <thread>
#include <tuple>
#include <vector>

namespace {
using Config = ParitySniffTest::Config;
using Bytes = std::vector<std::uint8_t>;
using Clock = std::chrono::steady_clock;
using Oracle = std::function<bool(const Bytes &, Bytes &)>;

std::uint64_t Mix(std::uint64_t x) {
    x += 0x9E3779B97F4A7C15ULL;
    x = (x ^ (x >> 30U)) * 0xBF58476D1CE4E5B9ULL;
    x = (x ^ (x >> 27U)) * 0x94D049BB133111EBULL;
    return x ^ (x >> 31U);
}

std::uint64_t CampaignSeed() {
    static const auto seed = [] {
        if (ParitySniffTest::kCampaignSeed != 0U) return ParitySniffTest::kCampaignSeed;
        std::random_device random;
        return ((std::uint64_t{random()} << 32U) ^ random()) | std::uint64_t{1U};
    }();
    return seed;
}

const char *StrengthName() {
    switch (ParitySniffTest::kEncryptionStrength) {
        case EncryptionStrength::kWeak: return "Weak";
        case EncryptionStrength::kNormal: return "Normal";
        case EncryptionStrength::kStrong: return "Strong";
        default: return "unsupported";
    }
}

class Log {
public:
    explicit Log(const char *name) : mName(name), mStart(Clock::now()), mLast(mStart) {}
    double Seconds() const { return std::chrono::duration<double>(Clock::now() - mStart).count(); }

    void Line(const char *format, ...) const {
        char text[2048];
        va_list args;
        va_start(args, format);
        std::vsnprintf(text, sizeof(text), format, args);
        va_end(args);
        const std::lock_guard lock(mMutex);
        std::printf("PARITY | %s | %8.1fs | %s\n", mName, Seconds(), text);
        std::fflush(stdout);
    }

    void Progress(const char *phase, std::size_t done, std::size_t total, std::size_t interval) {
        const auto now = Clock::now();
        const auto elapsed = std::chrono::duration<double>(now - mLast).count();
        if (done == total || elapsed >= ParitySniffTest::kProgressSeconds ||
            (done % interval == 0U && elapsed >= ParitySniffTest::kProgressSeconds / 2.0)) {
            Line("%s: %zu/%zu (%.1f%%)", phase, done, total, 100.0 * done / total);
            mLast = now;
        }
    }

private:
    const char *mName;
    Clock::time_point mStart;
    Clock::time_point mLast;
    mutable std::mutex mMutex;
};

// Seeding can stay inside one API call for a long time. This thread only
// prints elapsed time; it never reads or modifies Soccer's shared state.
class SeedHeartbeat {
public:
    explicit SeedHeartbeat(Log &log) : mThread([this, &log](std::stop_token stop) {
        std::unique_lock lock(mMutex);
        while (!stop.stop_requested()) {
            mWake.wait_for(lock, stop, std::chrono::duration<double>(ParitySniffTest::kProgressSeconds),
                           [] { return false; });
            if (!stop.stop_requested()) log.Line("seeding: still working");
        }
    }) {}
    ~SeedHeartbeat() { mThread.request_stop(); mWake.notify_all(); }
private:
    std::mutex mMutex;
    std::condition_variable_any mWake;
    std::jthread mThread;
};

void Require(bool ok, const char *message) {
    if (!ok) throw std::runtime_error(message);
}

void Fill(Bytes &data, std::mt19937_64 &random) {
    std::size_t i = 0U;
    for (; data.size() - i >= sizeof(std::uint64_t); i += sizeof(std::uint64_t)) {
        const auto word = random();
        std::memcpy(data.data() + i, &word, sizeof(word));
    }
    for (; i < data.size(); ++i) data[i] = static_cast<std::uint8_t>(random());
}

std::uint8_t RowParities(const Bytes &data) {
    std::uint8_t result = 0U;
    for (auto byte : data) result ^= byte;
    return result; // bit r is the XOR of physical bit r across the entire block.
}

std::size_t Combinations(std::size_t n, unsigned order, std::size_t cap) {
    if (order > n) return 0U;
    long double value = 1.0L;
    for (unsigned i = 1U; i <= order; ++i) {
        value *= static_cast<long double>(n - i + 1U) / i;
        if (value >= cap) return cap;
    }
    return static_cast<std::size_t>(std::llround(value));
}

std::size_t ParityChoices(std::size_t n, unsigned maxOrder, std::size_t cap) {
    std::size_t total = 0U;
    for (unsigned order = 2U; order <= maxOrder; ++order) {
        total += Combinations(n, order, cap - total);
        if (total >= cap) return cap;
    }
    return total;
}

void Validate(const Config &c) {
    Require(c.mName && c.mTrials > 0U, "profile needs a name and at least one trial");
    Require(c.mPlaintextBits >= 8U && c.mPlaintextBits <= 64U, "plaintext bit count must be 8..64");
    Require(c.mProbeRepeats > 0U && c.mProbeCipherBits > 0U, "discovery budgets must be nonzero");
    Require(c.mMaxParityBits >= 2U && c.mMaxParityBits <= 8U, "sparse parity width must be 2..8");
    Require(c.mTrainingSamples > 0U && c.mTrainingSamples % 64U == 0U,
            "training sample count must be a positive multiple of 64");
    Require(c.mScreenSamples > 0U && c.mConfirmationSamples > 0U && c.mProgressEveryQueries > 0U,
            "screen, confirmation and progress counts must be nonzero");
    Require(ParityChoices(c.mPlaintextBits, c.mMaxParityBits, c.mInputParityChecks) >= c.mInputParityChecks,
            "too many distinct input parity checks for the chosen bit count/width");
}

std::size_t ModelCount(const Config &c) {
    return c.mPlaintextBits + c.mInputParityChecks + (ParitySniffTest::kCheckWholeBlockParities ? 255U : 0U);
}

double Hypotheses() {
    // Four families: real/control labels, each screened and confirmed. Training
    // may search freely: only ONE frozen predictor per target sees these labels.
    double models = 0.0;
    for (const auto &c : {ParitySniffTest::kWeak, ParitySniffTest::kNormal, ParitySniffTest::kRigorous})
        models += static_cast<double>(c.mTrials) * ModelCount(c);
    if (ParitySniffTest::kRunPositiveControl) models += 3.0 * ModelCount(ParitySniffTest::kPositiveControl);
    if (ParitySniffTest::kRunBiasedPositiveControl) models += 3.0 * ModelCount(ParitySniffTest::kBiasedControl);
    return 4.0 * models;
}

double TailBound(std::size_t hits, std::size_t n) {
    if (n == 0U || hits <= n / 2U) return 1.0;
    const double deviation = static_cast<double>(hits) / n - 0.5;
    const double logBound = std::log(Hypotheses()) - 2.0 * n * deviation * deviation;
    return std::exp(std::max(std::log(std::numeric_limits<double>::min()), std::min(0.0, logBound)));
}

double Cutoff(std::size_t n) {
    return 0.5 + std::sqrt(std::log(Hypotheses() / ParitySniffTest::kFamilyAlpha) / (2.0 * n));
}

struct Scenario {
    Bytes mTemplate;
    std::vector<std::uint32_t> mBits;
    bool mFreshBackground;
};

Scenario MakeScenario(std::size_t bytes, const Config &c, std::uint64_t seed, bool fresh) {
    std::mt19937_64 random(seed);
    Scenario s{Bytes(bytes), {}, fresh};
    Fill(s.mTemplate, random);
    const std::size_t cluster = random() % bytes;
    for (std::size_t i = 0U; i < c.mPlaintextBits; ++i) {
        std::uint32_t bit;
        do {
            const auto byte = i < c.mPlaintextBits / 2U ? (cluster + i / 8U) % bytes : random() % bytes;
            bit = static_cast<std::uint32_t>(byte * 8U + i % 8U);
        } while (std::find(s.mBits.begin(), s.mBits.end(), bit) != s.mBits.end());
        s.mBits.push_back(bit);
    }
    return s;
}

std::uint64_t PrepareInput(const Scenario &s, std::mt19937_64 &random, Bytes &input) {
    if (s.mFreshBackground) Fill(input, random);
    else input = s.mTemplate;
    const auto flags = random();
    for (std::size_t i = 0U; i < s.mBits.size(); ++i) {
        const auto bit = s.mBits[i];
        const auto mask = static_cast<std::uint8_t>(1U << (bit % 8U));
        input[bit / 8U] = static_cast<std::uint8_t>((input[bit / 8U] & ~mask) |
            (((flags >> i) & 1U) ? mask : 0U));
    }
    return flags;
}

struct Target {
    std::uint64_t mFlagMask = 0U;
    std::uint8_t mRowMask = 0U;
    unsigned Label(std::uint64_t flags, std::uint8_t rows) const {
        return mRowMask ? std::popcount(static_cast<unsigned>(rows & mRowMask)) & 1U
                        : std::popcount(flags & mFlagMask) & 1U;
    }
};

std::vector<Target> MakeTargets(const Config &c, std::uint64_t seed) {
    std::vector<Target> targets;
    for (std::size_t i = 0U; i < c.mPlaintextBits; ++i) targets.push_back({std::uint64_t{1U} << i, 0U});
    std::mt19937_64 random(seed);
    std::set<std::uint64_t> masks;
    while (masks.size() < c.mInputParityChecks) {
        const unsigned order = 2U + static_cast<unsigned>(random() % (c.mMaxParityBits - 1U));
        std::uint64_t mask = 0U;
        while (static_cast<unsigned>(std::popcount(mask)) < order)
            mask |= std::uint64_t{1U} << (random() % c.mPlaintextBits);
        masks.insert(mask);
    }
    for (auto mask : masks) targets.push_back({mask, 0U});
    if (ParitySniffTest::kCheckWholeBlockParities)
        for (unsigned mask = 1U; mask < 256U; ++mask) targets.push_back({0U, static_cast<std::uint8_t>(mask)});
    return targets;
}

std::vector<std::uint32_t> ChangedBits(const Bytes &a, const Bytes &b, std::size_t keep,
                                      std::mt19937_64 &random, std::size_t &changed) {
    changed = 0U;
    for (std::size_t i = 0U; i < a.size(); ++i) changed += std::popcount(static_cast<unsigned>(a[i] ^ b[i]));
    keep = std::min(keep, changed);
    std::vector<std::size_t> ranks;
    for (std::size_t i = 0U; i < keep; ++i) {
        const auto lo = i * changed / keep, hi = (i + 1U) * changed / keep;
        ranks.push_back(lo + random() % (hi - lo));
    }
    std::vector<std::uint32_t> bits;
    std::size_t seen = 0U, next = 0U;
    for (std::size_t byte = 0U; byte < a.size() && next < ranks.size(); ++byte) {
        const unsigned difference = a[byte] ^ b[byte];
        const auto count = std::popcount(difference);
        while (next < ranks.size() && ranks[next] < seen + count) {
            auto remaining = ranks[next] - seen;
            unsigned bit = 0U;
            for (; bit < 8U; ++bit) if (difference & (1U << bit)) {
                if (remaining == 0U) break;
                --remaining;
            }
            bits.push_back(static_cast<std::uint32_t>(byte * 8U + bit));
            ++next;
        }
        seen += count;
    }
    return bits;
}

struct Feature {
    std::array<std::uint32_t, 8U> mColumns{};
    unsigned mCount = 0U;
    std::uint8_t mRowMask = 0U;
    auto Key() const { return std::tie(mRowMask, mCount, mColumns); }
    bool operator<(const Feature &other) const { return Key() < other.Key(); }
};

struct Search {
    std::vector<std::uint32_t> mBits;
    std::vector<Feature> mFeatures;
    std::vector<Target> mTargets;
    std::size_t mDiscoveryQueries = 0U;
};

Search Discover(const Oracle &oracle, const Scenario &s, const Config &c, std::uint64_t seed, Log &log) {
    Search search;
    search.mTargets = MakeTargets(c, Mix(seed));
    std::mt19937_64 random(seed);
    std::vector<std::vector<std::uint32_t>> groups;
    for (auto bit : s.mBits) groups.push_back({bit}); // Public coordinates are also useful anchors.
    Bytes input(s.mTemplate.size()), baseline, output;
    for (std::size_t repeat = 0U; repeat < c.mProbeRepeats; ++repeat) {
        PrepareInput(s, random, input);
        Require(oracle(input, baseline) && baseline.size() == input.size(), "discovery baseline encryption failed");
        ++search.mDiscoveryQueries;
        for (std::size_t i = 0U; i < s.mBits.size(); ++i) {
            const auto bit = s.mBits[i];
            input[bit / 8U] ^= static_cast<std::uint8_t>(1U << (bit % 8U));
            Require(oracle(input, output) && output.size() == input.size(), "bit-flip discovery encryption failed");
            input[bit / 8U] ^= static_cast<std::uint8_t>(1U << (bit % 8U));
            ++search.mDiscoveryQueries;
            std::size_t changed = 0U;
            const auto bits = ChangedBits(baseline, output, c.mProbeCipherBits, random, changed);
            groups[i].insert(groups[i].end(), bits.begin(), bits.end());
            if ((i + 1U) % ParitySniffTest::kDiscoveryLogEveryBits == 0U || i + 1U == s.mBits.size())
                log.Line("discovery probe=%zu/%zu input=%zu/%zu byte.bit=%u.%u changed_cipher_bits=%zu/%zu",
                         repeat + 1U, c.mProbeRepeats, i + 1U, s.mBits.size(), bit / 8U, bit % 8U,
                         changed, input.size() * 8U);
        }
    }
    for (auto &group : groups) {
        std::sort(group.begin(), group.end());
        group.erase(std::unique(group.begin(), group.end()), group.end());
        search.mBits.insert(search.mBits.end(), group.begin(), group.end());
    }
    for (std::size_t i = 0U; i < c.mUniformCipherBits; ++i)
        search.mBits.push_back(static_cast<std::uint32_t>(random() % (input.size() * 8U)));
    std::sort(search.mBits.begin(), search.mBits.end());
    search.mBits.erase(std::unique(search.mBits.begin(), search.mBits.end()), search.mBits.end());
    std::set<Feature> features;
    for (std::size_t i = 0U; i < search.mBits.size(); ++i) features.insert({{static_cast<std::uint32_t>(i)}, 1U, 0U});
    for (const auto &group : groups) {
        std::vector<Feature> pairs;
        for (std::size_t a = 0U; a < group.size(); ++a) for (std::size_t b = a + 1U; b < group.size(); ++b) {
            const auto ca = static_cast<std::uint32_t>(std::lower_bound(search.mBits.begin(), search.mBits.end(), group[a]) - search.mBits.begin());
            const auto cb = static_cast<std::uint32_t>(std::lower_bound(search.mBits.begin(), search.mBits.end(), group[b]) - search.mBits.begin());
            pairs.push_back({{ca, cb}, 2U, 0U});
        }
        std::shuffle(pairs.begin(), pairs.end(), random);
        features.insert(pairs.begin(), pairs.begin() + std::min(c.mPairsPerInput, pairs.size()));
    }
    const auto budget = ParityChoices(search.mBits.size(), c.mMaxParityBits, c.mRandomParities);
    std::set<Feature> randomFeatures;
    while (randomFeatures.size() < budget) {
        Feature f;
        f.mCount = 2U + static_cast<unsigned>(random() % (std::min<std::size_t>(c.mMaxParityBits, search.mBits.size()) - 1U));
        std::set<std::uint32_t> columns;
        while (columns.size() < f.mCount) columns.insert(static_cast<std::uint32_t>(random() % search.mBits.size()));
        std::copy(columns.begin(), columns.end(), f.mColumns.begin());
        randomFeatures.insert(f);
    }
    features.insert(randomFeatures.begin(), randomFeatures.end());
    if (ParitySniffTest::kCheckWholeBlockParities) for (unsigned mask = 1U; mask < 256U; ++mask) {
        Feature f;
        f.mRowMask = static_cast<std::uint8_t>(mask);
        for (unsigned row = 0U; row < 8U; ++row)
            if (mask & (1U << row)) f.mColumns[f.mCount++] = static_cast<std::uint32_t>(search.mBits.size() + row);
        features.insert(f);
    }
    search.mFeatures.assign(features.begin(), features.end());
    log.Line("discovery complete: queries=%zu sampled_cipher_bits=%zu XOR_candidates=%zu targets=%zu",
             search.mDiscoveryQueries, search.mBits.size(), search.mFeatures.size(), search.mTargets.size());
    return search;
}

struct Prediction {
    Feature mFeature;
    bool mInvert = false;
    std::size_t mTrainingCorrect = 0U;
};

std::vector<unsigned> Columns(const Search &search, const Bytes &ciphertext) {
    std::vector<unsigned> values(search.mBits.size() + 8U);
    for (std::size_t i = 0U; i < search.mBits.size(); ++i) {
        const auto bit = search.mBits[i];
        values[i] = (ciphertext[bit / 8U] >> (bit % 8U)) & 1U;
    }
    if (ParitySniffTest::kCheckWholeBlockParities) {
        const auto rows = RowParities(ciphertext);
        for (unsigned row = 0U; row < 8U; ++row) values[search.mBits.size() + row] = (rows >> row) & 1U;
    }
    return values;
}

std::vector<Prediction> Train(const Oracle &oracle, const Scenario &s, const Config &c,
                              const Search &search, std::uint64_t seed, Log &log) {
    const auto words = c.mTrainingSamples / 64U;
    std::vector<std::uint64_t> columns((search.mBits.size() + 8U) * words);
    std::vector<std::uint64_t> labels(search.mTargets.size() * words);
    std::mt19937_64 random(seed);
    Bytes input(s.mTemplate.size()), output;
    log.Line("training: collecting %zu samples; models are not graded on these samples", c.mTrainingSamples);
    for (std::size_t q = 0U; q < c.mTrainingSamples; ++q) {
        const auto flags = PrepareInput(s, random, input);
        const auto rows = RowParities(input);
        Require(oracle(input, output) && output.size() == input.size(), "training encryption failed");
        const auto values = Columns(search, output);
        for (std::size_t i = 0U; i < values.size(); ++i)
            columns[i * words + q / 64U] |= std::uint64_t{values[i]} << (q % 64U);
        for (std::size_t i = 0U; i < search.mTargets.size(); ++i)
            labels[i * words + q / 64U] |= std::uint64_t{search.mTargets[i].Label(flags, rows)} << (q % 64U);
        log.Progress("training samples", q + 1U, c.mTrainingSamples, c.mProgressEveryQueries);
    }
    std::vector<Prediction> models(search.mTargets.size());
    std::vector<std::uint64_t> signature(words);
    log.Line("training search: %zu candidates; global-row targets search only global-row XOR features", search.mFeatures.size());
    for (std::size_t f = 0U; f < search.mFeatures.size(); ++f) {
        const auto &feature = search.mFeatures[f];
        std::fill(signature.begin(), signature.end(), 0U);
        for (unsigned j = 0U; j < feature.mCount; ++j) {
            const auto *column = columns.data() + feature.mColumns[j] * words;
            for (std::size_t w = 0U; w < words; ++w) signature[w] ^= column[w];
        }
        for (std::size_t t = 0U; t < search.mTargets.size(); ++t) {
            if (search.mTargets[t].mRowMask && !feature.mRowMask) continue;
            std::size_t errors = 0U;
            for (std::size_t w = 0U; w < words; ++w) errors += std::popcount(signature[w] ^ labels[t * words + w]);
            const auto hits = c.mTrainingSamples - errors;
            const auto best = std::max(hits, errors);
            if (best > models[t].mTrainingCorrect) models[t] = {feature, errors > hits, best};
        }
        log.Progress("training candidate search", f + 1U, search.mFeatures.size(), ParitySniffTest::kSearchLogEveryFeatures);
    }
    log.Line("models frozen: %zu predictors; no oracle, password, labels or RNG are used by prediction", models.size());
    return models;
}

unsigned Predict(const Prediction &model, const std::vector<unsigned> &cipherColumns) {
    unsigned value = model.mInvert;
    for (unsigned i = 0U; i < model.mFeature.mCount; ++i) value ^= cipherColumns[model.mFeature.mColumns[i]];
    return value;
}

struct Scores {
    std::vector<std::size_t> mHits, mControlHits;
    std::vector<bool> mFlags, mControlFlags;
    std::size_t mSamples;
};

Scores Challenge(const Oracle &oracle, const Scenario &s, const Config &c, const Search &search,
                 const std::vector<Prediction> &frozen, std::size_t samples, std::uint64_t seed,
                 const char *phase, Log &log) {
    Scores scores{std::vector<std::size_t>(frozen.size()), std::vector<std::size_t>(frozen.size()), {}, {}, samples};
    std::mt19937_64 random(seed), control(Mix(seed));
    Bytes input(s.mTemplate.size()), output;
    log.Line("%s: %zu fresh samples; corrected chance cutoff > %.4f%%", phase, samples, 100.0 * Cutoff(samples));
    for (std::size_t q = 0U; q < samples; ++q) {
        const auto flags = PrepareInput(s, random, input);
        const auto rows = RowParities(input);
        Require(oracle(input, output) && output.size() == input.size(), "held-out encryption failed");
        const auto values = Columns(search, output);
        // These independent fair labels never influence discovery/model selection.
        std::uint64_t nullLabels = 0U;
        for (std::size_t t = 0U; t < frozen.size(); ++t) {
            if (t % 64U == 0U) nullLabels = control();
            const auto prediction = Predict(frozen[t], values);
            scores.mHits[t] += prediction == search.mTargets[t].Label(flags, rows);
            scores.mControlHits[t] += prediction == ((nullLabels >> (t % 64U)) & 1U);
        }
        log.Progress(phase, q + 1U, samples, c.mProgressEveryQueries);
    }
    for (std::size_t t = 0U; t < frozen.size(); ++t) {
        scores.mFlags.push_back(TailBound(scores.mHits[t], samples) < ParitySniffTest::kFamilyAlpha);
        scores.mControlFlags.push_back(TailBound(scores.mControlHits[t], samples) < ParitySniffTest::kFamilyAlpha);
    }
    return scores;
}

std::string TargetText(const Target &target, const Scenario &s) {
    std::ostringstream text;
    if (target.mRowMask) text << "whole-block plaintext row-mask=0x" << std::hex << unsigned(target.mRowMask);
    else {
        text << "plaintext XOR(";
        bool first = true;
        for (std::size_t i = 0U; i < s.mBits.size(); ++i) if (target.mFlagMask & (std::uint64_t{1U} << i)) {
            if (!first) text << ',';
            text << s.mBits[i] / 8U << '.' << s.mBits[i] % 8U;
            first = false;
        }
        text << ')';
    }
    return text.str();
}

std::string FeatureText(const Prediction &model, const Search &search) {
    std::ostringstream text;
    if (model.mFeature.mRowMask)
        text << "whole-block ciphertext row-mask=0x" << std::hex << unsigned(model.mFeature.mRowMask);
    else {
        text << "ciphertext XOR(";
        for (unsigned i = 0U; i < model.mFeature.mCount; ++i) {
            if (i) text << ',';
            const auto bit = search.mBits[model.mFeature.mColumns[i]];
            text << bit / 8U << '.' << bit % 8U;
        }
        text << ')';
    }
    text << " xor " << unsigned(model.mInvert);
    return text.str();
}

std::size_t FlagCount(const std::vector<bool> &flags) { return std::count(flags.begin(), flags.end(), true); }

void PrintScores(const char *phase, const Scores &scores, const Scenario &s, const Search &search,
                 const std::vector<Prediction> &models, Log &log) {
    std::vector<std::size_t> order(models.size());
    std::iota(order.begin(), order.end(), 0U);
    std::stable_sort(order.begin(), order.end(), [&](auto a, auto b) { return scores.mHits[a] > scores.mHits[b]; });
    const auto controlBest = *std::max_element(scores.mControlHits.begin(), scores.mControlHits.end());
    log.Line("%s SUMMARY: targets=%zu flags=%zu random-label-flags=%zu best=%.4f%% null-best=%.4f%% cutoff=%.4f%%",
             phase, models.size(), FlagCount(scores.mFlags), FlagCount(scores.mControlFlags),
             100.0 * scores.mHits[order[0]] / scores.mSamples, 100.0 * controlBest / scores.mSamples,
             100.0 * Cutoff(scores.mSamples));
    std::size_t printed = 0U;
    for (auto t : order) {
        if (printed >= ParitySniffTest::kTopFindingsToPrint && !ParitySniffTest::kPrintAllFindings) break;
        log.Line("%s %s: %s <- %s | %zu/%zu (%.4f%%) adjusted_bound<=%.3g",
                 phase, scores.mFlags[t] ? "FLAG" : "top", TargetText(search.mTargets[t], s).c_str(),
                 FeatureText(models[t], search).c_str(), scores.mHits[t], scores.mSamples,
                 100.0 * scores.mHits[t] / scores.mSamples, TailBound(scores.mHits[t], scores.mSamples));
        ++printed;
    }
    if (printed < order.size()) log.Line("%s: %zu more target details omitted; kPrintAllFindings prints every target", phase, order.size() - printed);
}

struct TrialResult {
    std::size_t mScreen = 0U, mConfirmed = 0U, mControl = 0U;
    bool mPerfectControl = false;
    double mFirstScreenAccuracy = 0.0, mFirstConfirmationAccuracy = 0.0;
};

TrialResult Inspect(const Oracle &oracle, const Scenario &s, const Config &c,
                    std::uint64_t seed, bool positiveControl, Log &log) {
    const auto search = Discover(oracle, s, c, Mix(seed ^ 1U), log);
    const auto frozen = Train(oracle, s, c, search, Mix(seed ^ 2U), log);
    const auto screen = Challenge(oracle, s, c, search, frozen, c.mScreenSamples, Mix(seed ^ 3U), "screen", log);
    PrintScores(positiveControl ? "CONTROL screen" : "screen", screen, s, search, frozen, log);
    TrialResult result;
    result.mScreen = FlagCount(screen.mFlags);
    result.mControl = FlagCount(screen.mControlFlags);
    result.mFirstScreenAccuracy = static_cast<double>(screen.mHits[0]) / screen.mSamples;
    result.mPerfectControl = std::all_of(screen.mHits.begin(), screen.mHits.end(), [&](auto n) { return n == screen.mSamples; });
    if (result.mScreen || result.mControl) {
        const auto confirm = Challenge(oracle, s, c, search, frozen, c.mConfirmationSamples,
                                       Mix(seed ^ 4U), "confirmation", log);
        PrintScores(positiveControl ? "CONTROL confirmation" : "confirmation", confirm, s, search, frozen, log);
        result.mControl += FlagCount(confirm.mControlFlags);
        result.mFirstConfirmationAccuracy = static_cast<double>(confirm.mHits[0]) / confirm.mSamples;
        result.mPerfectControl &= std::all_of(confirm.mHits.begin(), confirm.mHits.end(), [&](auto n) { return n == confirm.mSamples; });
        for (std::size_t t = 0U; t < frozen.size(); ++t) if (screen.mFlags[t] && confirm.mFlags[t]) {
            ++result.mConfirmed;
            if (!positiveControl && (ParitySniffTest::kPrintAllFindings || result.mConfirmed <= ParitySniffTest::kTopFindingsToPrint))
                log.Line("CONFIRMED: %s <- %s | screen %.4f%%, confirmation %.4f%%",
                         TargetText(search.mTargets[t], s).c_str(), FeatureText(frozen[t], search).c_str(),
                         100.0 * screen.mHits[t] / screen.mSamples, 100.0 * confirm.mHits[t] / confirm.mSamples);
        }
    } else log.Line("confirmation skipped: no held-out or random-label flags");
    return result;
}

void PositiveControl(std::uint64_t seed, Log &log) {
    const auto &c = ParitySniffTest::kPositiveControl;
    Validate(c);
    Require(ParitySniffTest::kControlBytes >= 8U && ParitySniffTest::kControlBytes * 8U >= c.mPlaintextBits,
            "positive control block is too small for its selected bits");
    auto scenario = MakeScenario(ParitySniffTest::kControlBytes, c, seed, true);
    const Oracle oracle = [](const Bytes &input, Bytes &output) {
        output.resize(input.size());
        for (std::size_t i = 0U; i < input.size(); ++i)
            output[i] = std::rotl(input[(i + ParitySniffTest::kControlByteRotation) % input.size()],
                                  static_cast<int>(ParitySniffTest::kControlBitRotation));
        output[0] ^= ParitySniffTest::kControlXorMask;
        return true;
    };
    log.Line("POSITIVE CONTROL: known affine byte/bit permutation; real parity recovery should be 100%%");
    const auto result = Inspect(oracle, scenario, c, Mix(seed), true, log);
    Require(result.mPerfectControl && result.mConfirmed == ModelCount(c), "positive affine control did not recover every expected parity");
    Require(result.mControl == 0U, "random-label control flagged during positive calibration");
    log.Line("POSITIVE CONTROL PASSED: %zu confirmed affine relations; random-label control clean", result.mConfirmed);
}

void BiasedControl(std::uint64_t seed, Log &log) {
    const auto &c = ParitySniffTest::kBiasedControl;
    Validate(c);
    Require(ParitySniffTest::kControlBytes >= 8U && ParitySniffTest::kControlBytes * 8U >= c.mPlaintextBits,
            "biased control block is too small for its selected bits");
    auto scenario = MakeScenario(ParitySniffTest::kControlBytes, c, seed, true);
    const Oracle oracle = [&](const Bytes &input, Bytes &output) {
        output = input;
        const auto target = scenario.mBits[0], a = scenario.mBits[1], b = scenario.mBits[2];
        const auto gate = ((input[a / 8U] >> (a % 8U)) & (input[b / 8U] >> (b % 8U))) & 1U;
        output[target / 8U] ^= static_cast<std::uint8_t>(gate << (target % 8U));
        return true;
    };
    log.Line("BIASED CONTROL: C0=P0 XOR (P1 AND P2); target 0 should predict at approximately 75%%, not 100%%");
    const auto result = Inspect(oracle, scenario, c, Mix(seed), true, log);
    const auto inRange = [](double accuracy) {
        return accuracy >= ParitySniffTest::kBiasedControlMinAccuracy &&
               accuracy <= ParitySniffTest::kBiasedControlMaxAccuracy;
    };
    Require(result.mConfirmed == ModelCount(c) && inRange(result.mFirstScreenAccuracy) &&
            inRange(result.mFirstConfirmationAccuracy), "biased control was not recovered at its expected accuracy");
    Require(result.mControl == 0U, "random-label control flagged during biased calibration");
    log.Line("BIASED CONTROL PASSED: target 0 screen=%.4f%% confirmation=%.4f%%; random-label control clean",
             100.0 * result.mFirstScreenAccuracy, 100.0 * result.mFirstConfirmationAccuracy);
}

struct ClearSoccerOnExit { ~ClearSoccerOnExit() { Soccer3::Zero(); } };
} // namespace

ParitySniffTest::Result ParitySniffTest::Run(const Config &config) {
    static std::mutex serial;
    const std::lock_guard lock(serial);
    Result result;
    Log log(config.mName ? config.mName : "invalid profile");
    try {
        Validate(config);
        Require(kFamilyAlpha > 0.0 && kFamilyAlpha < 1.0 && kProgressSeconds > 0.0,
                "invalid significance/progress settings");
        Require(kDiscoveryLogEveryBits > 0U && kSearchLogEveryFeatures > 0U && kPasswordBytes > 0U,
                "logging/password settings must be nonzero");
        Require(kEncryptionStrength == EncryptionStrength::kWeak || kEncryptionStrength == EncryptionStrength::kNormal ||
                kEncryptionStrength == EncryptionStrength::kStrong, "select Weak, Normal or Strong encryption strength in Common");
        result.mCampaignSeed = CampaignSeed();
        log.Line("START: encryption=%s (shared Common setting), campaign_seed=0x%016llx",
                 StrengthName(), static_cast<unsigned long long>(result.mCampaignSeed));
        log.Line("CONFIG: trials=%zu plaintext_bits=%zu input_parity_checks=%zu whole-block_masks=%u train=%zu screen=%zu confirm=%zu",
                 config.mTrials, config.mPlaintextBits, config.mInputParityChecks, kCheckWholeBlockParities ? 255U : 0U,
                 config.mTrainingSamples, config.mScreenSamples, config.mConfirmationSamples);
        log.Line("SEARCH: probes=%zu changed_bits/input/probe=%zu extra_cipher_bits=%zu pairs/input=%zu random_XORs=%zu sparse_width<=%u",
                 config.mProbeRepeats, config.mProbeCipherBits, config.mUniformCipherBits, config.mPairsPerInput,
                 config.mRandomParities, config.mMaxParityBits);
        log.Line("STATISTICS: family_alpha=%.3g hypotheses=%.0f (all three profiles, targets, stages and controls); screen cutoff=%.4f%%",
                 kFamilyAlpha, Hypotheses(), 100.0 * Cutoff(config.mScreenSamples));
        log.Line("Protocol: training selects feature/polarity; screen/confirmation never retrain or flip it. Screen flags remain alerts even if not repeated.");
        if (kRunPositiveControl) PositiveControl(Mix(result.mCampaignSeed), log);
        if (kRunBiasedPositiveControl) BiasedControl(Mix(result.mCampaignSeed ^ 0x424941534544ULL), log);

        ClearSoccerOnExit cleanup;
        for (std::size_t trial = 0U; trial < config.mTrials; ++trial) {
            const auto start = Clock::now();
            const auto seed = Mix(result.mCampaignSeed ^ Mix(trial + 1U));
            std::mt19937_64 random(seed);
            Bytes password(kPasswordBytes);
            Fill(password, random);
            const auto nonce = random();
            const bool fresh = kAlternateBackgrounds && trial % 2U != 0U;
            auto scenario = MakeScenario(SOCCER_BLOCK_SIZE, config, Mix(seed), fresh);
            log.Line("TRIAL %zu/%zu: encryption=%s background=%s fixture_seed=0x%016llx nonce=0x%016llx",
                     trial + 1U, config.mTrials, StrengthName(), fresh ? "fully random" : "fixed outside selected bits",
                     static_cast<unsigned long long>(seed), static_cast<unsigned long long>(nonce));
            std::ostringstream positions;
            for (auto bit : scenario.mBits) positions << bit / 8U << '.' << bit % 8U << ' ';
            log.Line("plaintext bit coordinates: %s", positions.str().c_str());
            log.Line("seeding: starting fresh full-size encryption plan");
            std::uint32_t ack = 0U;
            {
                SeedHeartbeat heartbeat(log);
                Require(Soccer3::AttemptSeed_Encrypt(kEncryptionStrength, password.data(), password.size(), nonce,
                                                    &ack, kProtocolVersion, nullptr), "Soccer fixture seeding failed");
            }
            log.Line("seeding complete: ack=0x%08x; checking one round trip", ack);
            Bytes source(SOCCER_BLOCK_SIZE);
            const Oracle oracle = [&](const Bytes &input, Bytes &output) {
                if (input.size() != SOCCER_BLOCK_SIZE) return false;
                source = input;
                output.resize(SOCCER_BLOCK_SIZE);
                return Soccer3::EncryptBlock(source.data(), output.data());
            };
            Bytes cipher, restored(SOCCER_BLOCK_SIZE);
            Require(oracle(scenario.mTemplate, cipher), "round-trip encryption failed");
            Require(Soccer3::DecryptBlock(cipher.data(), restored.data()) && restored == scenario.mTemplate,
                    "round-trip verification failed before parity search");
            const auto observation = Inspect(oracle, scenario, config, Mix(seed ^ 0x504152495459ULL), false, log);
            ++result.mTrialsCompleted;
            result.mScreenFindings += observation.mScreen;
            result.mConfirmedFindings += observation.mConfirmed;
            result.mControlAlerts += observation.mControl;
            const auto seconds = std::chrono::duration<double>(Clock::now() - start).count();
            log.Line("TRIAL %zu/%zu DONE: screen=%zu confirmed=%zu null-flags=%zu time=%.1fs | campaign completed=%zu/%zu",
                     trial + 1U, config.mTrials, observation.mScreen, observation.mConfirmed, observation.mControl,
                     seconds, result.mTrialsCompleted, config.mTrials);
            Soccer3::Zero();
        }
        result.mCompleted = true;
        log.Line("FINISHED: encryption=%s trials=%zu/%zu screen_flags=%zu confirmed=%zu null_flags=%zu seed=0x%016llx",
                 StrengthName(), result.mTrialsCompleted, config.mTrials, result.mScreenFindings,
                 result.mConfirmedFindings, result.mControlAlerts, static_cast<unsigned long long>(result.mCampaignSeed));
        log.Line("%s: bounded sampled-XOR and whole-block-row search; no general security conclusion.",
                 result.mScreenFindings || result.mControlAlerts ? "FINDINGS REQUIRE REVIEW" : "NO PARITY SIGNAL FOUND IN THIS RUN");
    } catch (const std::exception &error) {
        result.mError = error.what();
        log.Line("ERROR after %zu/%zu completed trials: %s", result.mTrialsCompleted, config.mTrials, error.what());
    }
    return result;
}
