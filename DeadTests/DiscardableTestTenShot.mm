// Ten reproducible FlameToad vault grids through the full independent 1 MiB API.
// Run this class serially: Soccer owns process-global configuration and state.
// Each strength runs ten word variations and BOTH existing password/nonce fixtures.
// Variation zero uses the real seeded words; later variations add test-only deltas
// after seeding and rebuild the vault with unchanged materials and rotations.
// Sample counts, plaintext layouts, predictors and controls match the original
// StatisticalPlaintextRecoveryTests. Expect several hours for all 60 trials.
// Print only one result line per trial; XCTest supplies its own suite status.

#import <XCTest/XCTest.h>
#include "StatisticalRecoveryHarness.hpp"
#define SOCCER_ENCRYPTION_STRENGTH_DEFINED
#define SOCCER3_DISABLE_COMPAT_ALIAS
#include "../Scramble/Composer/Soccer3.hpp"
#include <chrono>
#include <set>

namespace {
using namespace StatisticalRecovery;
constexpr std::size_t kShotCount = 10U;
constexpr std::size_t kCampaignHypotheses = kShotCount * kHypotheses;
using Selection = std::array<std::uint64_t, 3U>;
using Clock = std::chrono::steady_clock;

const std::array<Selection, kShotCount> &SelectionValues() {
    static const auto aSelections = [] {
        std::array<Selection, kShotCount> aResult{};
        aResult[0] = {0U, 0U, 0U}; // Unmodified production seed.
        // Fixed before observing outcomes; all strengths use the same ten.
        std::mt19937_64 aRandom(0x7E10540B17A5C329ULL);
        for (std::size_t aShot = 1U; aShot < kShotCount; ++aShot) {
            for (auto &aWord : aResult[aShot]) { aWord = aRandom(); }
        }
        return aResult;
    }();
    return aSelections;
}

void ApplyVariation(const Selection &pDelta) {
    Soccer3Internal::mBitPlaneWordA += pDelta[0];
    Soccer3Internal::mBitPlaneWordB += pDelta[1];
    Soccer3Internal::mBitPlaneWordC += pDelta[2];
    Soccer3Internal::SelectBitPlane();
}

const char *StrengthName(EncryptionStrength pStrength) {
    return pStrength == EncryptionStrength::kWeak ? "weak"
         : pStrength == EncryptionStrength::kStrong ? "strong" : "normal";
}

struct TrialSummary {
    bool mCompleted = false;
    bool mHasChallengeResult = false;
    const char *mError = nullptr;
    std::size_t mBestCorrect = 0U;
    std::uint64_t mSignificant = 0U;
    std::uint64_t mConfirmed = 0U;
    std::uint64_t mShuffledSignificant = 0U;
};

bool Passed(const TrialSummary &pSummary) {
    return pSummary.mCompleted && pSummary.mError == nullptr &&
           pSummary.mSignificant == 0U && pSummary.mShuffledSignificant == 0U;
}

void PrintTrial(EncryptionStrength pStrength, std::size_t pShot, std::size_t pFixture,
                const TrialSummary &pSummary, double pSeconds) {
    static const auto aFailCount = [] {
        std::size_t aCorrect = kChallenge / 2U;
        while (aCorrect < kChallenge &&
               AdjustedTailBound(aCorrect, kChallenge, kCampaignHypotheses) >= kFamilyAlpha) { ++aCorrect; }
        return aCorrect;
    }();
    char aAccuracy[112];
    if (pSummary.mHasChallengeResult) {
        std::snprintf(aAccuracy, sizeof(aAccuracy), "best prediction=%.2f%% (chance 50%%; failure cutoff %.4f%%)",
                      100.0 * pSummary.mBestCorrect / kChallenge, 100.0 * aFailCount / kChallenge);
    } else {
        std::snprintf(aAccuracy, sizeof(aAccuracy), "best prediction=N/A");
    }
    char aReason[160];
    if (pSummary.mError != nullptr || !pSummary.mCompleted) {
        std::snprintf(aReason, sizeof(aReason), "%s; trial incomplete",
                      pSummary.mError != nullptr ? pSummary.mError : "missing result");
    } else if (pSummary.mShuffledSignificant != 0U) {
        std::snprintf(aReason, sizeof(aReason), "shuffled-label control failed (%d flags)",
                      __builtin_popcountll(pSummary.mShuffledSignificant));
    } else if (pSummary.mSignificant != 0U) {
        std::snprintf(aReason, sizeof(aReason), "%d/%zu flags predictable; %d confirmed",
                      __builtin_popcountll(pSummary.mSignificant), kFlags,
                      __builtin_popcountll(pSummary.mConfirmed));
    } else {
        std::snprintf(aReason, sizeof(aReason), "no significant recovery");
    }
    std::printf("%s | %s | flame-toad-vault | selection %zu/%zu | fixture %zu/%zu | %s | %s | %.1fs\n",
                Passed(pSummary) ? "PASS" : "FAIL", StrengthName(pStrength),
                pShot + 1U, kShotCount, pFixture + 1U, kFixtures, aAccuracy, aReason, pSeconds);
    std::fflush(stdout);
}
}

@interface DiscardableTestTenShot : XCTestCase
@end

@implementation DiscardableTestTenShot
- (void)checkStrength:(EncryptionStrength)pStrength {
    ClearSoccerOnExit aRestore;
    self.continueAfterFailure = YES;
    const auto aScenario = MakeScenario(kBlockBytes);
    std::size_t aFailedTrials = 0U;
    for (std::size_t aShot = 0U; aShot < kShotCount; ++aShot) {
        for (std::size_t aFixture = 0U; aFixture < kFixtures; ++aFixture) {
            ClearSoccerOnExit aCleanup;
            const auto aTrialStart = Clock::now();
            TrialSummary aSummary;
            // Return from the trial on API/protocol errors, then always print
            // its one result line and continue collecting the remaining shots.
            const auto aRunTrial = [&] {
                const auto &aSelection = SelectionValues()[aShot];
                if (!SeedFixture(pStrength, aFixture)) {
                    aSummary.mError = "seeding failed";
                    return;
                }
                ApplyVariation(aSelection);
                BitPlane aExpectedPlane{};
                BitPlaneFarm::Select(Soccer3Internal::mBitPlaneWordA, Soccer3Internal::mBitPlaneWordB,
                                     Soccer3Internal::mBitPlaneWordC, &aExpectedPlane);
                if (!Soccer3Internal::SeedEpilogue_Regular_D() || Soccer3Internal::mBitPlane != aExpectedPlane) {
                    aSummary.mError = "selected plane did not reach the plan";
                    return;
                }
                for (std::size_t aLayer = 0U; aLayer < 8U; ++aLayer) {
                    if (CryptexTestSupport::Rows()[aLayer % 4U] != aExpectedPlane.GetRow(aLayer % 4U)) {
                        aSummary.mError = "selected rows did not reach the vault";
                        return;
                    }
                }
                const Oracle aVictim = [](const Bytes &pInput, Bytes &pOutput) {
                    if (pInput.size() != kBlockBytes) { return false; }
                    Bytes aSource = pInput;
                    pOutput.resize(kBlockBytes);
                    return Soccer3::EncryptBlock(aSource.data(), pOutput.data());
                };
                constexpr auto kTrainingBudget = 1U + kFlags + kTrain + kValidate;
                std::size_t aAttackerCalls = 0U;
                const Oracle aTrainingOracle = [&](const Bytes &pInput, Bytes &pOutput) {
                    if (aAttackerCalls >= kTrainingBudget) { return false; }
                    ++aAttackerCalls;
                    return aVictim(pInput, pOutput);
                };
                Model aModel;
                if (!Train(aTrainingOracle, aScenario, aModel, false)) {
                    aSummary.mError = "training/API failure";
                    return;
                }
                if (aAttackerCalls != kTrainingBudget || aModel.mQueries != kTrainingBudget) {
                    aSummary.mError = "incorrect training query count";
                    return;
                }
                const Model aFrozen = aModel;
                Result aResult;
                if (!Challenge(aVictim, aScenario, aFrozen, kChallenge,
                               0xFA481C1B83D24E99ULL, aResult, kCampaignHypotheses, false)) {
                    aSummary.mError = "challenge/API failure";
                    return;
                }
                if (aResult.mQueries != kChallenge || aAttackerCalls != kTrainingBudget) {
                    aSummary.mError = "incorrect challenge query count";
                    return;
                }
                aSummary.mHasChallengeResult = true;
                aSummary.mBestCorrect = *std::max_element(aResult.mCorrect.begin(), aResult.mCorrect.end());
                aSummary.mSignificant = aResult.mSignificant;
                aSummary.mShuffledSignificant = aResult.mShuffledSignificant;
                if (aResult.mSignificant != 0U) {
                    Result aConfirmation;
                    if (!Challenge(aVictim, aScenario, aFrozen, kConfirm,
                                   0x90B67FD8A3C1254EULL, aConfirmation, kCampaignHypotheses, false)) {
                        aSummary.mError = "confirmation/API failure";
                        return;
                    }
                    if (aConfirmation.mQueries != kConfirm) {
                        aSummary.mError = "incorrect confirmation query count";
                        return;
                    }
                    aSummary.mConfirmed = aResult.mSignificant & aConfirmation.mSignificant;
                    aSummary.mShuffledSignificant |= aConfirmation.mShuffledSignificant;
                }
                aSummary.mCompleted = true;
            };
            aRunTrial();
            PrintTrial(pStrength, aShot, aFixture, aSummary,
                       std::chrono::duration<double>(Clock::now() - aTrialStart).count());
            aFailedTrials += !Passed(aSummary);
        }
    }
    // An initial finding still fails when confirmation is underpowered.
    // XCTest reports the aggregate failure after all trials have printed.
    XCTAssertEqual(aFailedTrials, std::size_t{0U},
                   @"%zu of %zu ten-shot trials failed for %s; see the trial result lines",
                   aFailedTrials, kShotCount * kFixtures, StrengthName(pStrength));
}

- (void)testStatisticalRecoveryWeak { [self checkStrength:EncryptionStrength::kWeak]; }
- (void)testStatisticalRecoveryNormal { [self checkStrength:EncryptionStrength::kNormal]; }
- (void)testStatisticalRecoveryStrong { [self checkStrength:EncryptionStrength::kStrong]; }

// Fast setup check; this can run without starting the full campaign.
- (void)testTenVariationsProduceDistinctPlanesAndZeroClearsState {
    ClearSoccerOnExit aCleanup;
    std::set<std::array<std::uint8_t, 16U>> aSeen;
    for (const auto &aSelection : SelectionValues()) {
        Soccer3::Zero();
        ApplyVariation(aSelection);
        std::array<std::uint8_t, 16U> aKey{};
        for (unsigned aRow = 0U; aRow < 4U; ++aRow) {
            for (unsigned aColumn = 0U; aColumn < 4U; ++aColumn) {
                const auto &aPair = Soccer3Internal::mBitPlane.mColumns[aColumn].mPairs[aRow];
                aKey[4U * aRow + aColumn] = static_cast<std::uint8_t>((1U << aPair.mBitA) | (1U << aPair.mBitB));
            }
        }
        XCTAssertTrue(Soccer3Internal::mBitPlane.IsValid());
        aSeen.insert(aKey);
    }
    XCTAssertEqual(aSeen.size(), kShotCount);
    Soccer3::Zero();
    XCTAssertEqual(Soccer3Internal::mBitPlaneWordA, std::uint64_t{0U});
    XCTAssertEqual(Soccer3Internal::mBitPlaneWordB, std::uint64_t{0U});
    XCTAssertEqual(Soccer3Internal::mBitPlaneWordC, std::uint64_t{0U});
    const BitPlane aEmpty{};
    XCTAssertTrue(Soccer3Internal::mBitPlane == aEmpty);
}

- (void)testCampaignCorrectionDetectsBiasedControl {
    const auto aScenario = MakeScenario(128U);
    const Oracle aOracle = [&](const Bytes &pInput, Bytes &pOutput) {
        pOutput = pInput;
        const auto aFirst = aScenario.mBits[1], aSecond = aScenario.mBits[2], aTarget = aScenario.mBits[0];
        const auto aGate = ((pInput[aFirst / 8U] >> (aFirst % 8U)) &
                           (pInput[aSecond / 8U] >> (aSecond % 8U))) & 1U;
        pOutput[aTarget / 8U] ^= static_cast<std::uint8_t>(aGate << (aTarget % 8U));
        return true;
    };
    Model aModel;
    XCTAssertTrue(Train(aOracle, aScenario, aModel, false));
    Result aResult;
    XCTAssertTrue(Challenge(aOracle, aScenario, aModel, kChallenge,
                           0xFA481C1B83D24E99ULL, aResult, kCampaignHypotheses, false));
    XCTAssertGreaterThan(aResult.mCorrect[0], 72U * kChallenge / 100U);
    XCTAssertLessThan(aResult.mCorrect[0], 78U * kChallenge / 100U);
    XCTAssertNotEqual(aResult.mSignificant & 1U, std::uint64_t{0U});
    XCTAssertEqual(aResult.mShuffledSignificant, std::uint64_t{0U});
    XCTAssertGreaterThan(AdjustedTailBound(51U * kChallenge / 100U, kChallenge, kCampaignHypotheses), kFamilyAlpha);
}
@end
