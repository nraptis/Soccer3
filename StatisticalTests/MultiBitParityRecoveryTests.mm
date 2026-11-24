// Exact affine-parity recovery against the FULL repeated 1 MiB encryption API.
// Run serially: Soccer3 has process-global mutable state.
// This bounded search covers all multi-bit masks within sampled bytes and
// selected cross-byte pairs. It does not exhaust dense global parities or
// search for merely biased approximations. Passing is not a security proof.

#import <XCTest/XCTest.h>
#include "../Scramble/Public/Soccer3.hpp"

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <functional>
#include <limits>
#include <numeric>
#include <random>
#include <tuple>
#include <vector>

namespace {

using Bytes = std::vector<std::uint8_t>;
using Oracle = std::function<bool(const Bytes &, Bytes &)>;
constexpr std::size_t kBlockBytes = SOCCER_BLOCK_SIZE;
constexpr std::size_t kTrainingQueries = 128U;
constexpr std::size_t kValidationQueries = 64U;
constexpr std::size_t kChallengeBlocks = 64U;
constexpr std::size_t kMaximumRelations = 4096U;
constexpr std::size_t kAnchorCount = 2048U;
static_assert(kBlockBytes == (1U << 20U));

struct ClearSoccerOnExit {
    ~ClearSoccerOnExit() { Soccer3::Zero(); }
};

bool SeedFixture(EncryptionStrength pStrength, std::size_t pFixture) {
    constexpr const char *kPasswords[] = {"review-fixture", "second-fixture"};
    constexpr std::uint64_t kNonces[] = {0x2026103001234567ULL, 0xD3B91C764E2085AFULL};
    std::array<std::uint8_t, 14U> aPassword{};
    std::memcpy(aPassword.data(), kPasswords[pFixture], aPassword.size());
    std::uint32_t aAckWord = 0U;
    Soccer3::Zero();
    return Soccer3::AttemptSeed_Encrypt(pStrength, aPassword.data(), aPassword.size(),
                                       kNonces[pFixture], &aAckWord, 0U, nullptr);
}

void Fill(Bytes &pBytes, std::mt19937_64 &pRandom) {
    // Reproducible fixture data, not cryptographic randomness.
    for (std::size_t i = 0U; i < pBytes.size(); i += 8U) {
        const std::uint64_t aWord = pRandom();
        std::memcpy(pBytes.data() + i, &aWord, std::min(std::size_t{8U}, pBytes.size() - i));
    }
}

struct ParityFeature {
    std::uint32_t mFirstByte;
    std::uint32_t mSecondByte;
    std::uint8_t mFirstMask;
    std::uint8_t mSecondMask;

    auto Key() const { return std::tie(mFirstByte, mSecondByte, mFirstMask, mSecondMask); }
    bool operator<(const ParityFeature &other) const { return Key() < other.Key(); }
    bool operator==(const ParityFeature &other) const { return Key() == other.Key(); }
};

std::uint8_t Parity(const Bytes &pBytes, const ParityFeature &pFeature) {
    return static_cast<std::uint8_t>(
        __builtin_parity(static_cast<unsigned>(pBytes[pFeature.mFirstByte] & pFeature.mFirstMask)) ^
        __builtin_parity(static_cast<unsigned>(pBytes[pFeature.mSecondByte] & pFeature.mSecondMask)));
}

std::vector<ParityFeature> MakeFeatures(std::size_t pBytes) {
    std::vector<std::uint32_t> anchors;
    const auto count = std::min(kAnchorCount, pBytes);
    const auto stride = pBytes / count;
    std::mt19937_64 random(0xE84B7923D51A60CFULL);
    for (std::size_t i = 0U; i < count; ++i) {
        // Vary the low address bits; do not sample only byte offsets 0 mod 8.
        anchors.push_back(static_cast<std::uint32_t>(i * stride + random() % stride));
    }
    for (std::size_t quarter = 0U; quarter <= 4U; ++quarter) {
        const auto edge = static_cast<std::int64_t>(quarter * pBytes / 4U);
        for (std::int64_t delta = -32; delta < 32; ++delta) {
            if (edge + delta >= 0 && edge + delta < static_cast<std::int64_t>(pBytes)) {
                anchors.push_back(static_cast<std::uint32_t>(edge + delta));
            }
        }
    }
    std::sort(anchors.begin(), anchors.end());
    anchors.erase(std::unique(anchors.begin(), anchors.end()), anchors.end());
    std::vector<std::size_t> distances = {1U, 8U, 32U, 64U, pBytes / 4U, pBytes / 2U};
    std::sort(distances.begin(), distances.end());
    distances.erase(std::unique(distances.begin(), distances.end()), distances.end());
    std::vector<ParityFeature> features;
    features.reserve(anchors.size() * 355U);
    auto addPair = [&](std::uint32_t a, std::uint32_t b, std::uint8_t ma, std::uint8_t mb) {
        if (a > b) { std::swap(a, b); std::swap(ma, mb); }
        features.push_back({a, b, ma, mb});
    };
    for (auto a : anchors) {
        // All 247 byte masks of weight 2..8; single-bit relations are excluded.
        for (unsigned mask = 1U; mask < 256U; ++mask) {
            if (__builtin_popcount(mask) >= 2) {
                features.push_back({a, a, static_cast<std::uint8_t>(mask), 0U});
            }
        }
        for (auto distance : distances) {
            if (distance == 0U || distance >= pBytes) { continue; }
            const auto b = a ^ static_cast<std::uint32_t>(distance);
            for (unsigned bit = 0U; bit < 8U; ++bit) {
                addPair(a, b, 1U << bit, 1U << bit);
                addPair(a, b, 1U << bit, 1U << ((bit + 3U) & 7U));
            }
            addPair(a, b, 0xFFU, 0xFFU);
            addPair(a, b, 0x0FU, 0xF0U);
        }
    }
    std::sort(features.begin(), features.end());
    features.erase(std::unique(features.begin(), features.end()), features.end());
    return features;
}

struct Signature {
    std::uint64_t mLow = 0U;
    std::uint64_t mHigh = 0U;
    bool operator<(const Signature &other) const {
        return std::tie(mHigh, mLow) < std::tie(other.mHigh, other.mLow);
    }
    bool operator==(const Signature &other) const {
        return mLow == other.mLow && mHigh == other.mHigh;
    }
    std::uint8_t Normalize() {
        const auto polarity = static_cast<std::uint8_t>(mLow & 1U);
        if (polarity) { mLow = ~mLow; mHigh = ~mHigh; }
        return polarity;
    }
};

Signature FeatureSignature(const ParityFeature &feature, const std::vector<Signature> &columns,
                           const std::vector<std::uint32_t> &index) {
    Signature result;
    for (unsigned bit = 0U; bit < 8U; ++bit) {
        if (feature.mFirstMask & (1U << bit)) {
            const auto &s = columns[index[feature.mFirstByte] * 8U + bit];
            result.mLow ^= s.mLow; result.mHigh ^= s.mHigh;
        }
        if (feature.mSecondMask & (1U << bit)) {
            const auto &s = columns[index[feature.mSecondByte] * 8U + bit];
            result.mLow ^= s.mLow; result.mHigh ^= s.mHigh;
        }
    }
    return result;
}

struct Relation {
    ParityFeature mPlaintext;
    ParityFeature mCiphertext;
    std::uint8_t mPolarity;
};

struct ParityModel {
    std::vector<Relation> mRelations;
    std::size_t mFeatureCount = 0U;
    std::size_t mSampledBytes = 0U;
    std::size_t mOutputFeaturesSearched = 0U;
    std::size_t mTrainingQueries = 0U;
    std::size_t mValidationQueries = 0U;
    std::size_t mTrainingMatches = 0U;
};

// Prediction receives ciphertext and a frozen relation only, never the
// plaintext, seed, password, encryption plan, or an encryption oracle.
std::uint8_t Predict(const Relation &pRelation, const Bytes &pCiphertext) {
    return Parity(pCiphertext, pRelation.mCiphertext) ^ pRelation.mPolarity;
}

// Learn P[mask] = C[mask] XOR constant from chosen-plaintext samples.
// Both masks always contain multiple bits. Signatures contain 128 observations;
// normalization removes one polarity bit, leaving 127 matching bits. Then 64
// NEW random queries filter coincidences. Hold-out challenges are not used here.
bool LearnParities(const Oracle &pEncrypt, std::size_t pBytes, ParityModel &pModel) {
    pModel = {};
    if (pBytes < 8U || pBytes > kBlockBytes || (pBytes & (pBytes - 1U)) != 0U) { return false; }
    const auto features = MakeFeatures(pBytes);
    pModel.mFeatureCount = features.size();
    constexpr auto invalid = std::numeric_limits<std::uint32_t>::max();
    std::vector<std::uint32_t> index(pBytes, invalid), addresses;
    for (const auto &f : features) { index[f.mFirstByte] = 0U; index[f.mSecondByte] = 0U; }
    for (std::size_t i = 0U; i < pBytes; ++i) {
        if (index[i] != invalid) {
            index[i] = static_cast<std::uint32_t>(addresses.size());
            addresses.push_back(static_cast<std::uint32_t>(i));
        }
    }
    pModel.mSampledBytes = addresses.size();
    std::vector<Signature> plainColumns(addresses.size() * 8U), cipherColumns(plainColumns.size());
    std::mt19937_64 random(0x7692D40F1BA3C58EULL);
    Bytes plaintext(pBytes), ciphertext;
    for (std::size_t query = 0U; query < kTrainingQueries; ++query) {
        Fill(plaintext, random);
        if (!pEncrypt(plaintext, ciphertext) || ciphertext.size() != pBytes) { return false; }
        ++pModel.mTrainingQueries;
        for (std::size_t i = 0U; i < addresses.size(); ++i) {
            const auto p = plaintext[addresses[i]], c = ciphertext[addresses[i]];
            for (unsigned bit = 0U; bit < 8U; ++bit) {
                auto &ps = plainColumns[i * 8U + bit];
                auto &cs = cipherColumns[i * 8U + bit];
                auto &pw = query < 64U ? ps.mLow : ps.mHigh;
                auto &cw = query < 64U ? cs.mLow : cs.mHigh;
                pw |= static_cast<std::uint64_t>((p >> bit) & 1U) << (query & 63U);
                cw |= static_cast<std::uint64_t>((c >> bit) & 1U) << (query & 63U);
            }
        }
    }
    struct Candidate { Signature mKey; std::uint32_t mFeature; std::uint8_t mPolarity; };
    std::vector<Candidate> candidates;
    candidates.reserve(features.size());
    for (std::size_t i = 0U; i < features.size(); ++i) {
        auto key = FeatureSignature(features[i], plainColumns, index);
        const auto polarity = key.Normalize();
        candidates.push_back({key, static_cast<std::uint32_t>(i), polarity});
    }
    std::sort(candidates.begin(), candidates.end(), [](const auto &a, const auto &b) {
        if (a.mKey == b.mKey) { return a.mFeature < b.mFeature; }
        return a.mKey < b.mKey;
    });
    std::vector<bool> seenPlaintext(features.size(), false);
    for (const auto &f : features) {
        ++pModel.mOutputFeaturesSearched;
        auto key = FeatureSignature(f, cipherColumns, index);
        const auto polarity = key.Normalize();
        const auto found = std::lower_bound(candidates.begin(), candidates.end(), key,
            [](const Candidate &a, const Signature &b) { return a.mKey < b; });
        if (found != candidates.end() && found->mKey == key && !seenPlaintext[found->mFeature]) {
            seenPlaintext[found->mFeature] = true;
            pModel.mRelations.push_back({features[found->mFeature], f,
                                         static_cast<std::uint8_t>(polarity ^ found->mPolarity)});
            if (pModel.mRelations.size() == kMaximumRelations) { break; }
        }
    }
    pModel.mTrainingMatches = pModel.mRelations.size();
    std::mt19937_64 validationRandom(0xAC38E761D0942BF5ULL);
    for (std::size_t query = 0U; query < kValidationQueries; ++query) {
        Fill(plaintext, validationRandom);
        if (!pEncrypt(plaintext, ciphertext) || ciphertext.size() != pBytes) { return false; }
        ++pModel.mValidationQueries;
        std::erase_if(pModel.mRelations, [&](const Relation &relation) {
            return Predict(relation, ciphertext) != Parity(plaintext, relation.mPlaintext);
        });
    }
    return true;
}

struct RecoveryResult {
    std::size_t mQueries = 0U;
    std::size_t mPredictions = 0U;
    std::size_t mCorrect = 0U;
    std::size_t mPerfectRelations = 0U;
};

bool Challenge(const Oracle &pEncrypt, std::size_t pBytes, const ParityModel &pFrozenModel,
               RecoveryResult &pResult) {
    pResult = {};
    std::vector<std::size_t> correct(pFrozenModel.mRelations.size(), 0U);
    std::mt19937_64 random(0xF07D349C8A2BE651ULL);
    Bytes plaintext(pBytes), ciphertext;
    for (std::size_t query = 0U; query < kChallengeBlocks; ++query) {
        Fill(plaintext, random);
        if (!pEncrypt(plaintext, ciphertext) || ciphertext.size() != pBytes) { return false; }
        ++pResult.mQueries;
        for (std::size_t i = 0U; i < correct.size(); ++i) {
            // The truth is used only for grading AFTER prediction.
            const auto prediction = Predict(pFrozenModel.mRelations[i], ciphertext);
            const bool success = prediction == Parity(plaintext, pFrozenModel.mRelations[i].mPlaintext);
            correct[i] += success;
            pResult.mCorrect += success;
            ++pResult.mPredictions;
        }
    }
    pResult.mPerfectRelations = std::count(correct.begin(), correct.end(), kChallengeBlocks);
    return true;
}

Oracle ControlOracle(std::size_t pLinearPrefixBytes) {
    std::array<std::uint8_t, 256U> substitution;
    std::iota(substitution.begin(), substitution.end(), std::uint8_t{0U});
    std::mt19937_64 random(0x7AB13E6D29C4508FULL);
    std::shuffle(substitution.begin(), substitution.end(), random);
    return [substitution, pLinearPrefixBytes](const Bytes &input, Bytes &output) {
        output.resize(input.size());
        for (std::size_t j = 0U; j < input.size(); ++j) {
            const auto source = (j * 73U + 19U) % input.size();
            const auto x = input[source];
            // Invertible linear byte map; each output bit uses THREE input
            // bits, so a one-input/one-output-bit recovery test misses it.
            const auto r1 = static_cast<std::uint8_t>((x << 1U) | (x >> 7U));
            const auto r2 = static_cast<std::uint8_t>((x << 2U) | (x >> 6U));
            const auto mixed = static_cast<std::uint8_t>(x ^ r1 ^ r2);
            output[j] = (source < pLinearPrefixBytes ? mixed : substitution[x])
                      ^ static_cast<std::uint8_t>(j * 37U + 11U);
        }
        return true;
    };
}

} // namespace

@interface MultiBitParityRecoveryTests : XCTestCase
@end

@implementation MultiBitParityRecoveryTests

- (void)checkStrength:(EncryptionStrength)pStrength {
    for (std::size_t fixture = 0U; fixture < 2U; ++fixture) {
        ClearSoccerOnExit aCleanup;
        if (!SeedFixture(pStrength, fixture)) {
            XCTFail(@"Parity fixture %zu failed to seed", fixture); return;
        }
        const Oracle oracle = [](const Bytes &input, Bytes &output) {
            if (input.size() != kBlockBytes) { return false; }
            Bytes source = input;
            output.resize(kBlockBytes);
            return Soccer3::EncryptBlock(source.data(), output.data());
        };
        std::mt19937_64 random(0x65A82CF4E70D193BULL ^ fixture);
        Bytes plaintext(kBlockBytes), encrypted, repeated, restored(kBlockBytes);
        Fill(plaintext, random);
        if (!oracle(plaintext, encrypted) || !oracle(plaintext, repeated) ||
            !Soccer3::DecryptBlock(encrypted.data(), restored.data())) {
            XCTFail(@"Parity baseline API failure"); return;
        }
        if (encrypted != repeated || plaintext != restored) {
            XCTFail(@"Parity recovery requires deterministic encryption and a valid inverse"); return;
        }
        ParityModel model;
        if (!LearnParities(oracle, kBlockBytes, model)) {
            XCTFail(@"Parity training/validation oracle failure"); return;
        }
        XCTAssertEqual(model.mTrainingQueries, kTrainingQueries);
        XCTAssertEqual(model.mValidationQueries, kValidationQueries);
        RecoveryResult result;
        if (!Challenge(oracle, kBlockBytes, model, result)) {
            XCTFail(@"Parity held-out challenge oracle failure"); return;
        }
        XCTAssertEqual(result.mQueries, kChallengeBlocks);
        // Relations can be linearly dependent. Counts are not independent
        // plaintext bits, and this does not claim password or ARX-state recovery.
        std::printf("Multi-bit parity: strength=%u fixture=%zu sampled_bytes=%zu features=%zu "
                    "output_features_searched=%zu training_queries=%zu validation_queries=%zu "
                    "training_matches=%zu validated=%zu challenge_queries=%zu "
                    "correct=%zu/%zu perfect_relations=%zu\n",
                    static_cast<unsigned>(pStrength), fixture, model.mSampledBytes, model.mFeatureCount,
                    model.mOutputFeaturesSearched, model.mTrainingQueries, model.mValidationQueries,
                    model.mTrainingMatches, model.mRelations.size(), result.mQueries,
                    result.mCorrect, result.mPredictions, result.mPerfectRelations);
        if (!model.mRelations.empty()) {
            const auto &r = model.mRelations.front();
            std::printf("Parity example: P[%u]&0x%02x XOR P[%u]&0x%02x parity = "
                        "C[%u]&0x%02x XOR C[%u]&0x%02x parity XOR %u\n",
                        r.mPlaintext.mFirstByte, r.mPlaintext.mFirstMask,
                        r.mPlaintext.mSecondByte, r.mPlaintext.mSecondMask,
                        r.mCiphertext.mFirstByte, r.mCiphertext.mFirstMask,
                        r.mCiphertext.mSecondByte, r.mCiphertext.mSecondMask, r.mPolarity);
        }
        XCTAssertEqual(result.mPerfectRelations, std::size_t{0U},
                       @"SECURITY: %zu preselected multi-bit plaintext parities were recovered "
                        "perfectly across %zu unseen blocks; strength=%u fixture=%zu",
                       result.mPerfectRelations, kChallengeBlocks, static_cast<unsigned>(pStrength), fixture);
    }
}

- (void)checkControlPrefix:(std::size_t)pPrefix {
    const auto oracle = ControlOracle(pPrefix);
    ParityModel model;
    XCTAssertTrue(LearnParities(oracle, 128U, model));
    if (pPrefix == 0U) {
        XCTAssertEqual(model.mRelations.size(), std::size_t{0U});
    } else {
        XCTAssertGreaterThan(model.mRelations.size(), std::size_t{128U});
    }
    RecoveryResult result;
    XCTAssertTrue(Challenge(oracle, 128U, model, result));
    XCTAssertEqual(result.mQueries, kChallengeBlocks);
    XCTAssertEqual(result.mCorrect, result.mPredictions);
    XCTAssertEqual(result.mPerfectRelations, model.mRelations.size());
    for (const auto &r : model.mRelations) {
        XCTAssertGreaterThanOrEqual(__builtin_popcount(r.mPlaintext.mFirstMask) +
                                   __builtin_popcount(r.mPlaintext.mSecondMask), 2);
        XCTAssertGreaterThanOrEqual(__builtin_popcount(r.mCiphertext.mFirstMask) +
                                   __builtin_popcount(r.mCiphertext.mSecondMask), 2);
    }
}

- (void)testControlRecoversMultiBitRelationsAcrossPermutedBytes { [self checkControlPrefix:128U]; }
- (void)testControlRecoversPartialLeakage { [self checkControlPrefix:16U]; }
- (void)testControlRejectsNonlinearByteSubstitution { [self checkControlPrefix:0U]; }

- (void)testControlReportsOracleErrors {
    for (std::size_t failAt : {std::size_t{0U}, kTrainingQueries - 1U, kTrainingQueries, kTrainingQueries + 7U}) {
        std::size_t calls = 0U;
        const Oracle oracle = [&](const Bytes &input, Bytes &output) {
            if (calls++ == failAt) { return false; }
            output = input; return true;
        };
        ParityModel model;
        XCTAssertFalse(LearnParities(oracle, 16U, model));
        XCTAssertEqual(calls, failAt + 1U);
    }
    ParityModel model;
    const Oracle wrongSize = [](const Bytes &, Bytes &output) { output.clear(); return true; };
    XCTAssertFalse(LearnParities(wrongSize, 16U, model));
    RecoveryResult result;
    XCTAssertFalse(Challenge(wrongSize, 16U, model, result));
}

- (void)testMultiBitParityRecovery_Weak { [self checkStrength:EncryptionStrength::kWeak]; }
- (void)testMultiBitParityRecovery_Normal { [self checkStrength:EncryptionStrength::kNormal]; }
- (void)testMultiBitParityRecovery_Strong { [self checkStrength:EncryptionStrength::kStrong]; }

@end
