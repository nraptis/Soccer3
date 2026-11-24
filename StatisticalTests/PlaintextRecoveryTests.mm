// Chosen-plaintext recovery against the FULL repeated 1 MiB encryption API.
// Run serially: Soccer3 has process-global mutable state.
// Threat model: the attacker knows the template except for 64 bit-7 flags and
// can obtain encryptions under the victim's same fixed plan. This is not an
// arbitrary-file, ciphertext-only attack or password/ARX-state recovery.

#import <XCTest/XCTest.h>
#include "../Scramble/Public/Soccer3.hpp"

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <functional>
#include <random>
#include <utility>
#include <vector>
#include <stdlib.h>

namespace {

using Bytes = std::vector<std::uint8_t>;
using Words = std::vector<std::uint64_t>;
using Oracle = std::function<bool(const Bytes &, Bytes &)>;
constexpr std::size_t kFlagCount = 64U;
constexpr std::size_t kTrainingQueries = kFlagCount + 1U;
constexpr std::size_t kChallenges = 64U;
constexpr std::size_t kBlockBytes = SOCCER_BLOCK_SIZE;
using FlagPositions = std::array<std::size_t, kFlagCount>;
static_assert(kBlockBytes == (1U << 20U));

// ---------------- Attacker: no Soccer3, password, or decryption access. ----

struct BasisColumn {
    Words mDifference;
    std::uint64_t mInputCombination;
    std::size_t mPivotBit;
};

struct RecoveryModel {
    Bytes mKnownTemplate;
    FlagPositions mPositions{};
    Words mBaseCiphertext;
    std::vector<BasisColumn> mBasis;
    std::size_t mQueries = 0U;
    bool mTrained = false;
};

Words ToWords(const Bytes &pBytes) {
    Words result(pBytes.size() / sizeof(std::uint64_t));
    std::memcpy(result.data(), pBytes.data(), pBytes.size());
    return result;
}

void XorWords(Words &pDestination, const Words &pSource) {
    for (std::size_t i = 0U; i < pDestination.size(); ++i) {
        pDestination[i] ^= pSource[i];
    }
}

bool HasBit(const Words &pWords, std::size_t pBit) {
    return ((pWords[pBit / 64U] >> (pBit % 64U)) & 1U) != 0U;
}

std::size_t FirstBit(const Words &pWords) {
    for (std::size_t i = 0U; i < pWords.size(); ++i) {
        if (pWords[i]) { return i * 64U + __builtin_ctzll(pWords[i]); }
    }
    return pWords.size() * 64U;
}

Bytes WithFlags(const Bytes &pTemplate, const FlagPositions &pPositions,
                std::uint64_t pFlags) {
    Bytes result = pTemplate;
    for (std::size_t bit = 0U; bit < kFlagCount; ++bit) {
        result[pPositions[bit]] = (result[pPositions[bit]] & 0x7FU)
                               | (((pFlags >> bit) & 1U) << 7U);
    }
    return result;
}

bool Train(const Oracle &pEncrypt, const Bytes &pTemplate,
           const FlagPositions &pPositions, RecoveryModel &pModel) {
    pModel = {};
    if (pTemplate.size() < kFlagCount || pTemplate.size() % 8U != 0U) { return false; }
    auto sorted = pPositions;
    std::sort(sorted.begin(), sorted.end());
    if (sorted.back() >= pTemplate.size() ||
        std::adjacent_find(sorted.begin(), sorted.end()) != sorted.end()) { return false; }
    for (auto position : sorted) {
        if ((pTemplate[position] & 0x80U) != 0U) { return false; }
    }
    pModel.mKnownTemplate = pTemplate;
    pModel.mPositions = pPositions;
    pModel.mBasis.reserve(kFlagCount);
    Bytes output;
    if (!pEncrypt(pTemplate, output) || output.size() != pTemplate.size()) { return false; }
    ++pModel.mQueries;
    pModel.mBaseCiphertext = ToWords(output);
    for (std::size_t bit = 0U; bit < kFlagCount; ++bit) {
        const auto input = WithFlags(pTemplate, pPositions, std::uint64_t{1U} << bit);
        if (!pEncrypt(input, output) || output.size() != pTemplate.size()) { return false; }
        ++pModel.mQueries;
        auto difference = ToWords(output);
        XorWords(difference, pModel.mBaseCiphertext);
        std::uint64_t combination = std::uint64_t{1U} << bit;
        // Gaussian elimination over GF(2). Each column also records which
        // original input flips it represents. Later columns have zeros at
        // every earlier pivot, so insertion order is the reduction order.
        for (const auto &column : pModel.mBasis) {
            if (HasBit(difference, column.mPivotBit)) {
                XorWords(difference, column.mDifference);
                combination ^= column.mInputCombination;
            }
        }
        const auto pivot = FirstBit(difference);
        if (pivot < pTemplate.size() * 8U) {
            pModel.mBasis.push_back({std::move(difference), combination, pivot});
        }
    }
    pModel.mTrained = true;
    return true;
}

struct Prediction {
    bool mAvailable = false;
    std::uint64_t mFlags = 0U;
    Bytes mPlaintext;
    std::size_t mResidualBits = 0U;
};

// Only the frozen learned model and target ciphertext enter this function.
// It has no oracle, target plaintext, secret flags, RNG, key, or plan argument.
Prediction Recover(const RecoveryModel &pModel, const Bytes &pCiphertext) {
    Prediction result;
    if (!pModel.mTrained || pModel.mBasis.size() != kFlagCount ||
        pCiphertext.size() != pModel.mKnownTemplate.size()) { return result; }
    auto residual = ToWords(pCiphertext);
    XorWords(residual, pModel.mBaseCiphertext);
    for (const auto &column : pModel.mBasis) {
        if (HasBit(residual, column.mPivotBit)) {
            XorWords(residual, column.mDifference);
            result.mFlags ^= column.mInputCombination;
        }
    }
    for (auto word : residual) { result.mResidualBits += __builtin_popcountll(word); }
    result.mAvailable = true;
    result.mPlaintext = WithFlags(pModel.mKnownTemplate, pModel.mPositions, result.mFlags);
    // A nonzero residual means the full affine model did not fit. Still grade
    // the predicted plaintext: a projection can leak flags despite that.
    // Conversely, zero residual alone is NOT proof that plaintext is correct.
    return result;
}

// ---------------- Victim / grader: secrets stay on this side. -------------

FlagPositions MakePositions(std::size_t pBytes, bool pDistributed) {
    FlagPositions result;
    const auto stride = pBytes / kFlagCount;
    for (std::size_t i = 0U; i < kFlagCount; ++i) {
        result[i] = pDistributed ? i * stride + ((i * 37U) % stride) : i;
    }
    return result;
}

Bytes MakeTemplate(std::size_t pBytes, const FlagPositions &pPositions) {
    std::mt19937_64 random(0x8DB31FCA795260E4ULL);
    Bytes result(pBytes);
    for (std::size_t i = 0U; i < pBytes; i += 8U) {
        const auto word = random();
        std::memcpy(result.data() + i, &word, std::min(std::size_t{8U}, pBytes - i));
    }
    for (auto position : pPositions) { result[position] &= 0x7FU; }
    return result;
}

struct ChallengeResult {
    std::size_t mChallenges = 0U;
    std::size_t mPredictions = 0U;
    std::size_t mExactPlaintexts = 0U;
    std::size_t mCorrectFlagBits = 0U;
    std::size_t mPerfectFlags = 0U;
    std::size_t mExactLinearFits = 0U;
    std::size_t mMinimumResidualBits = 0U;
    std::size_t mMaximumResidualBits = 0U;
    std::uint64_t mExampleSecret = 0U;
    std::uint64_t mExamplePrediction = 0U;
    std::uint64_t mPerfectFlagMask = 0U;
};

bool Challenge(const Oracle &pVictimEncrypt, const RecoveryModel &pFrozenModel,
               std::size_t pCount, ChallengeResult &pResult) {
    pResult = {};
    pResult.mMinimumResidualBits = pFrozenModel.mKnownTemplate.size() * 8U;
    std::array<std::size_t, kFlagCount> correctByFlag{};
    std::vector<std::uint64_t> usedSecrets;
    for (std::size_t trial = 0U; trial < pCount; ++trial) {
        std::uint64_t secret;
        do {
            // Fresh OS randomness, generated AFTER training. No shared seed
            // or PRNG state is available to the attacker. Exclude all 65
            // training plaintexts and repeated challenge plaintexts.
            arc4random_buf(&secret, sizeof(secret));
        } while (__builtin_popcountll(secret) < 2 ||
                 std::find(usedSecrets.begin(), usedSecrets.end(), secret) != usedSecrets.end());
        usedSecrets.push_back(secret);
        const auto plaintext = WithFlags(pFrozenModel.mKnownTemplate, pFrozenModel.mPositions, secret);
        Bytes ciphertext;
        if (!pVictimEncrypt(plaintext, ciphertext) || ciphertext.size() != plaintext.size()) { return false; }
        ++pResult.mChallenges;

        // The prediction is finished before the grader reads the secret.
        const auto prediction = Recover(pFrozenModel, ciphertext);
        if (!prediction.mAvailable) { continue; }
        ++pResult.mPredictions;
        const auto wrong = prediction.mFlags ^ secret;
        pResult.mCorrectFlagBits += kFlagCount - __builtin_popcountll(wrong);
        pResult.mExactPlaintexts += (wrong == 0U && prediction.mPlaintext == plaintext);
        for (std::size_t bit = 0U; bit < kFlagCount; ++bit) {
            correctByFlag[bit] += ((wrong >> bit) & 1U) == 0U;
        }
        pResult.mExactLinearFits += prediction.mResidualBits == 0U;
        pResult.mMinimumResidualBits = std::min(pResult.mMinimumResidualBits, prediction.mResidualBits);
        pResult.mMaximumResidualBits = std::max(pResult.mMaximumResidualBits, prediction.mResidualBits);
        if (trial == 0U) {
            pResult.mExampleSecret = secret;
            pResult.mExamplePrediction = prediction.mFlags;
        }
    }
    if (pCount != 0U && pResult.mPredictions == pCount) {
        for (std::size_t bit = 0U; bit < kFlagCount; ++bit) {
            if (correctByFlag[bit] == pCount) {
                ++pResult.mPerfectFlags;
                pResult.mPerfectFlagMask |= std::uint64_t{1U} << bit;
            }
        }
    }
    return true;
}

enum class Control { kAffine, kNonlinearExtraBit, kNonlinearFlag, kRankDeficient };

Oracle ControlOracle(Control pControl) {
    return [pControl](const Bytes &input, Bytes &output) {
        Bytes mixed = input;
        if (pControl == Control::kNonlinearExtraBit) {
            mixed.back() ^= ((input[0] >> 7U) & (input[1] >> 7U));
        } else if (pControl == Control::kNonlinearFlag) {
            // Reversible Toffoli gate. Individual training flips miss the
            // interaction, but a challenge with flags 0 and 2 set triggers it.
            mixed[1] ^= (input[0] & input[2] & 0x80U);
        } else if (pControl == Control::kRankDeficient) {
            mixed[63] &= 0x7FU;
        }
        const auto half = input.size() / 2U;
        for (std::size_t i = 0U; i < half; ++i) {
            mixed[half + i] ^= mixed[i] ^ mixed[(i + 1U) % half];
        }
        output.resize(input.size());
        for (std::size_t j = 0U; j < input.size(); ++j) {
            const auto x = mixed[(j * 73U + 19U) % input.size()];
            const auto rotation = j % 7U + 1U;
            output[j] = static_cast<std::uint8_t>((x << rotation) | (x >> (8U - rotation)))
                      ^ static_cast<std::uint8_t>(j * 37U + 11U);
        }
        return true;
    };
}

struct ClearSoccerOnExit { ~ClearSoccerOnExit() { Soccer3::Zero(); } };

bool SeedFixture(EncryptionStrength pStrength, std::size_t pFixture) {
    constexpr const char *kPasswords[] = {"review-fixture", "second-fixture"};
    constexpr std::uint64_t kNonces[] = {0x2026103001234567ULL, 0xD3B91C764E2085AFULL};
    std::array<std::uint8_t, 14U> password{};
    std::memcpy(password.data(), kPasswords[pFixture], password.size());
    std::uint32_t ack = 0U;
    Soccer3::Zero();
    return Soccer3::AttemptSeed_Encrypt(pStrength, password.data(), password.size(),
                                       kNonces[pFixture], &ack, 0U, nullptr);
}

} // namespace

@interface PlaintextRecoveryTests : XCTestCase
@end

@implementation PlaintextRecoveryTests

- (void)checkStrength:(EncryptionStrength)pStrength {
    for (std::size_t fixture = 0U; fixture < 2U; ++fixture) {
        ClearSoccerOnExit cleanup;
        if (!SeedFixture(pStrength, fixture)) { XCTFail(@"Recovery fixture failed to seed"); return; }
        const Oracle victim = [](const Bytes &input, Bytes &output) {
            if (input.size() != kBlockBytes) { return false; }
            Bytes source = input;
            output.resize(kBlockBytes);
            return Soccer3::EncryptBlock(source.data(), output.data());
        };
        for (bool distributed : {false, true}) {
            const auto positions = MakePositions(kBlockBytes, distributed);
            const auto knownTemplate = MakeTemplate(kBlockBytes, positions);
            std::size_t trainingCalls = 0U;
            const Oracle trainingOracle = [&](const Bytes &input, Bytes &output) {
                if (trainingCalls >= kTrainingQueries) { return false; }
                ++trainingCalls;
                return victim(input, output);
            };
            RecoveryModel model;
            if (!Train(trainingOracle, knownTemplate, positions, model)) {
                XCTFail(@"Recovery training/API failure"); return;
            }
            XCTAssertEqual(trainingCalls, kTrainingQueries);
            XCTAssertEqual(model.mQueries, kTrainingQueries);
            // A deficient rank makes this particular full-recovery attempt
            // inconclusive. Report a setup failure instead of a security pass.
            XCTAssertEqual(model.mBasis.size(), kFlagCount, @"Recovery basis is not full rank; inconclusive");
            const RecoveryModel frozen = std::move(model);
            ChallengeResult result;
            if (!Challenge(victim, frozen, kChallenges, result)) {
                XCTFail(@"Recovery challenge/API failure"); return;
            }
            XCTAssertEqual(trainingCalls, kTrainingQueries); // No extra attacker queries.
            XCTAssertEqual(result.mChallenges, kChallenges);
            XCTAssertEqual(result.mPredictions, kChallenges);
            const char *layout = distributed ? "distributed" : "clustered";
            std::printf("Plaintext recovery: strength=%u fixture=%zu layout=%s unknown_bits=64 "
                        "training_queries=%zu rank=%zu challenges=%zu predictions=%zu "
                        "exact_plaintexts=%zu/%zu correct_flag_bits=%zu/%zu perfect_flags=%zu/64 "
                        "linear_fits=%zu/%zu residual_bits=%zu..%zu\n",
                        static_cast<unsigned>(pStrength), fixture, layout, frozen.mQueries,
                        frozen.mBasis.size(), result.mChallenges, result.mPredictions,
                        result.mExactPlaintexts, result.mChallenges, result.mCorrectFlagBits,
                        result.mPredictions * kFlagCount, result.mPerfectFlags, result.mExactLinearFits,
                        result.mPredictions, result.mMinimumResidualBits, result.mMaximumResidualBits);
            std::printf("Recovery example (grader only): hidden_flags=0x%016llx predicted_flags=0x%016llx "
                        "perfect_flag_mask=0x%016llx\n",
                        static_cast<unsigned long long>(result.mExampleSecret),
                        static_cast<unsigned long long>(result.mExamplePrediction),
                        static_cast<unsigned long long>(result.mPerfectFlagMask));
            // Grade actual held-out plaintext, not ciphertext superposition.
            // Also expose fixed flag positions recovered across ALL challenges,
            // even when other flags are wrong. This is a bounded recovery test,
            // not a claim of arbitrary-file decryption or a security proof.
            XCTAssertEqual(result.mExactPlaintexts, std::size_t{0U},
                           @"SECURITY: recovered all 64 unknown plaintext flags in %zu/%zu unseen blocks; "
                            "strength=%u fixture=%zu layout=%s",
                           result.mExactPlaintexts, kChallenges, static_cast<unsigned>(pStrength), fixture, layout);
            XCTAssertEqual(result.mPerfectFlags, std::size_t{0U},
                           @"SECURITY: %zu plaintext flag positions recovered perfectly across all %zu unseen blocks; "
                            "strength=%u fixture=%zu layout=%s",
                           result.mPerfectFlags, kChallenges, static_cast<unsigned>(pStrength), fixture, layout);
        }
    }
}

- (void)testControlRecoversUnseenPlaintexts {
    for (bool distributed : {false, true}) {
        const auto positions = MakePositions(256U, distributed);
        const auto knownTemplate = MakeTemplate(256U, positions);
        const auto oracle = ControlOracle(Control::kAffine);
        RecoveryModel model;
        XCTAssertTrue(Train(oracle, knownTemplate, positions, model));
        XCTAssertEqual(model.mQueries, kTrainingQueries);
        XCTAssertEqual(model.mBasis.size(), kFlagCount);
        ChallengeResult result;
        XCTAssertTrue(Challenge(oracle, model, kChallenges, result));
        XCTAssertEqual(result.mExactPlaintexts, kChallenges);
        XCTAssertEqual(result.mPerfectFlags, kFlagCount);
        XCTAssertEqual(result.mExactLinearFits, kChallenges);
    }
}

- (void)testControlRecoversFlagsDespiteNonlinearResidual {
    const auto positions = MakePositions(256U, false);
    const auto knownTemplate = MakeTemplate(256U, positions);
    const auto oracle = ControlOracle(Control::kNonlinearExtraBit);
    RecoveryModel model;
    XCTAssertTrue(Train(oracle, knownTemplate, positions, model));
    const auto plaintext = WithFlags(knownTemplate, positions, 0xA19C625EB04D83F3ULL);
    Bytes ciphertext;
    XCTAssertTrue(oracle(plaintext, ciphertext));
    const auto prediction = Recover(model, ciphertext);
    XCTAssertTrue(prediction.mAvailable);
    XCTAssertGreaterThan(prediction.mResidualBits, std::size_t{0U});
    XCTAssertTrue(prediction.mPlaintext == plaintext);
}

- (void)testControlLinearFitDoesNotProvePlaintextRecovery {
    const auto positions = MakePositions(256U, false);
    const auto knownTemplate = MakeTemplate(256U, positions);
    const auto oracle = ControlOracle(Control::kNonlinearFlag);
    RecoveryModel model;
    XCTAssertTrue(Train(oracle, knownTemplate, positions, model));
    const auto plaintext = WithFlags(knownTemplate, positions, 5U);
    Bytes ciphertext;
    XCTAssertTrue(oracle(plaintext, ciphertext));
    const auto prediction = Recover(model, ciphertext);
    XCTAssertTrue(prediction.mAvailable);
    XCTAssertEqual(prediction.mResidualBits, std::size_t{0U});
    XCTAssertEqual(prediction.mFlags, std::uint64_t{7U});
    XCTAssertTrue(prediction.mPlaintext != plaintext);
}

- (void)testControlRejectsRankDeficiencyAndInvalidInputs {
    auto positions = MakePositions(256U, false);
    const auto knownTemplate = MakeTemplate(256U, positions);
    const auto oracle = ControlOracle(Control::kRankDeficient);
    RecoveryModel model;
    XCTAssertTrue(Train(oracle, knownTemplate, positions, model));
    XCTAssertEqual(model.mBasis.size(), std::size_t{63U});
    Bytes ciphertext;
    XCTAssertTrue(oracle(knownTemplate, ciphertext));
    XCTAssertFalse(Recover(model, ciphertext).mAvailable);
    positions[63] = positions[0];
    XCTAssertFalse(Train(oracle, knownTemplate, positions, model));
    XCTAssertFalse(Recover(model, ciphertext).mAvailable);
    positions[63] = 256U;
    XCTAssertFalse(Train(oracle, knownTemplate, positions, model));
}

- (void)testControlReportsOracleErrors {
    const auto positions = MakePositions(256U, false);
    const auto knownTemplate = MakeTemplate(256U, positions);
    for (std::size_t failAt : {std::size_t{0U}, std::size_t{1U}, kTrainingQueries - 1U}) {
        std::size_t calls = 0U;
        const Oracle oracle = [&](const Bytes &input, Bytes &output) {
            if (calls++ == failAt) { return false; }
            output = input; return true;
        };
        RecoveryModel model;
        XCTAssertFalse(Train(oracle, knownTemplate, positions, model));
        XCTAssertEqual(calls, failAt + 1U);
        XCTAssertFalse(model.mTrained);
    }
    RecoveryModel model;
    const Oracle wrongSize = [](const Bytes &, Bytes &output) { output.clear(); return true; };
    XCTAssertFalse(Train(wrongSize, knownTemplate, positions, model));
    XCTAssertTrue(Train(ControlOracle(Control::kAffine), knownTemplate, positions, model));
    XCTAssertFalse(Recover(model, Bytes{}).mAvailable);
    ChallengeResult result;
    XCTAssertFalse(Challenge(wrongSize, model, 1U, result));
}

- (void)testPlaintextRecovery_Weak { [self checkStrength:EncryptionStrength::kWeak]; }
- (void)testPlaintextRecovery_Normal { [self checkStrength:EncryptionStrength::kNormal]; }
- (void)testPlaintextRecovery_Strong { [self checkStrength:EncryptionStrength::kStrong]; }

@end
