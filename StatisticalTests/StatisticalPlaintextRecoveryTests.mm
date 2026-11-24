// Statistical chosen-plaintext recovery through the FULL repeated 1 MiB API.
// Active FlameToad vault. Run serially: Soccer3 has process-global mutable state.
// A public template has 64 unknown flags: 32 clustered, 32 distributed, with
// four flags per bit plane in each layout. Each fixture keeps one fixed plan.
// This bounded attack searches single ciphertext bits and two-bit parities;
// it is not an exhaustive linear attack, key recovery, or a security proof.

#import <XCTest/XCTest.h>
#include "StatisticalRecoveryHarness.hpp"
#define SOCCER_ENCRYPTION_STRENGTH_DEFINED
#define SOCCER3_DISABLE_COMPAT_ALIAS
#include "../Scramble/Composer/Soccer3.hpp"
#include <chrono>
using namespace StatisticalRecovery;

@interface StatisticalPlaintextRecoveryTests : XCTestCase
@end

@implementation StatisticalPlaintextRecoveryTests

- (void)checkStrength:(EncryptionStrength)strength {
    const auto scenario = MakeScenario(kBlockBytes);
    for (std::size_t fixture = 0U; fixture < kFixtures; ++fixture) {
        ClearSoccerOnExit cleanup;
        const auto aStart=std::chrono::steady_clock::now();
        if (!SeedFixture(strength, fixture)) { XCTFail(@"Statistical fixture failed to seed"); return; }
        XCTAssertTrue(Soccer3Internal::mEncryptionReady);
        // Old fixture check (new eight-value groups are validated during seeding):
        // XCTAssertTrue(RotationSelection::IsValid(Soccer3Internal::mRotationWindow,128U,Soccer3Internal::mRotationsByte,16U));
        Bytes aRoundTripInput=scenario.mTemplate,aRoundTripCipher(kBlockBytes),aRoundTripRestored(kBlockBytes);
        if(!Soccer3::EncryptBlock(aRoundTripInput.data(),aRoundTripCipher.data()) ||
           !Soccer3::DecryptBlock(aRoundTripCipher.data(),aRoundTripRestored.data()) || aRoundTripInput!=aRoundTripRestored) {
            XCTFail(@"FlameToad victim roundtrip failed before attacker training");return;
        }

        std::printf("CONFIG | flame-toad-vault | strength=%u fixture=%zu bit_plane_words=%llu,%llu,%llu bit_plane_policy=seeded-word-sums-v1 rotation_policy=flat-window-lists-forward-units-v4 rotation_candidates=%zu shuffle_bytes=%zu\n",
            unsigned(strength),fixture,
            static_cast<unsigned long long>(Soccer3Internal::mBitPlaneWordA),
            static_cast<unsigned long long>(Soccer3Internal::mBitPlaneWordB),
            static_cast<unsigned long long>(Soccer3Internal::mBitPlaneWordC),
            Soccer3Internal::mRotationCandidatesRead,
            Soccer3Internal::mRotationShuffleBytesRead);
        const Oracle victim = [](const Bytes &input, Bytes &output) {
            if (input.size() != kBlockBytes) { return false; }
            Bytes source = input;
            output.resize(kBlockBytes);
            return Soccer3::EncryptBlock(source.data(), output.data());
        };
        constexpr auto trainingBudget = 1U + kFlags + kTrain + kValidate;
        std::size_t attackerCalls = 0U;
        const Oracle trainingOracle = [&](const Bytes &input, Bytes &output) {
            if (attackerCalls >= trainingBudget) { return false; }
            ++attackerCalls;
            return victim(input, output);
        };
        std::printf("Statistical recovery training: strength=%u fixture=%zu budget=%zu\n",
                    static_cast<unsigned>(strength), fixture, trainingBudget);
        std::fflush(stdout);
        Model model;
        if (!Train(trainingOracle, scenario, model)) { XCTFail(@"Statistical training/API failure"); return; }
        XCTAssertEqual(attackerCalls, trainingBudget);
        XCTAssertEqual(model.mQueries, trainingBudget);
        const Model frozen = model;
        Result result;
        if (!Challenge(victim, scenario, frozen, kChallenge, 0xFA481C1B83D24E99ULL, result)) {
            XCTFail(@"Statistical challenge/API failure"); return;
        }
        XCTAssertEqual(result.mQueries, kChallenge);
        XCTAssertEqual(attackerCalls, trainingBudget); // Frozen attacker cannot query the oracle.
        PrintResult("challenge", strength, fixture, scenario, frozen, result);
        XCTAssertEqual(result.mShuffledSignificant, std::uint64_t{0U}, @"Shuffled-label control failed");
        std::uint64_t aConfirmed=0U;
        if (result.mSignificant != 0U) {
            Result confirmation;
            if (!Challenge(victim, scenario, frozen, kConfirm, 0x90B67FD8A3C1254EULL, confirmation)) {
                XCTFail(@"Statistical confirmation/API failure"); return;
            }
            PrintResult("confirmation", strength, fixture, scenario, frozen, confirmation);
            aConfirmed=result.mSignificant & confirmation.mSignificant;
            XCTAssertEqual(confirmation.mShuffledSignificant, std::uint64_t{0U});
            std::printf("Statistical confirmed flags: strength=%u fixture=%zu mask=0x%016llx\n",
                        static_cast<unsigned>(strength), fixture,
                        static_cast<unsigned long long>(result.mSignificant & confirmation.mSignificant));
        }
        const auto aBest=*std::max_element(result.mCorrect.begin(),result.mCorrect.end());
        const auto aSeconds=std::chrono::duration<double>(std::chrono::steady_clock::now()-aStart).count();
        std::printf("%s | flame-toad-vault | strength=%u fixture=%zu | best prediction=%.4f%% | significant=%u/64 confirmed=%u/64 | %.1fs\n",
            result.mSignificant==0U && result.mShuffledSignificant==0U?"PASS":"FAIL",unsigned(strength),fixture,
            100.0*aBest/result.mQueries,unsigned(__builtin_popcountll(result.mSignificant)),
            unsigned(__builtin_popcountll(aConfirmed)),aSeconds);
        std::fflush(stdout);
        // A first-stage significant finding is reported even if confirmation
        // is underpowered. Never silently turn it into a security pass.
        XCTAssertEqual(result.mSignificant, std::uint64_t{0U},
                       @"SECURITY: held-out plaintext prediction above chance; strength=%u fixture=%zu mask=0x%016llx",
                       static_cast<unsigned>(strength), fixture, static_cast<unsigned long long>(result.mSignificant));
    }
}

- (void)testStatisticalRecoveryWeak { [self checkStrength:EncryptionStrength::kWeak]; }
- (void)testStatisticalRecoveryNormal { [self checkStrength:EncryptionStrength::kNormal]; }
- (void)testStatisticalRecoveryStrong { [self checkStrength:EncryptionStrength::kStrong]; }

- (void)testBiasedNonlinearControlIsRecoveredWithoutPerfectAccuracy {
    const auto scenario = MakeScenario(128U);
    // Reversible toy: C0 = P0 XOR (P1 AND P2), other bits unchanged. The
    // strongest single/two-bit linear predictor for flag 0 is 75%, not 100%.
    const Oracle oracle = [&](const Bytes &input, Bytes &output) {
        output = input;
        const auto a = scenario.mBits[1], b = scenario.mBits[2], target = scenario.mBits[0];
        const auto gate = ((input[a / 8U] >> (a % 8U)) & (input[b / 8U] >> (b % 8U))) & 1U;
        output[target / 8U] ^= static_cast<std::uint8_t>(gate << (target % 8U));
        return true;
    };
    Model model;
    XCTAssertTrue(Train(oracle, scenario, model));
    Result result;
    XCTAssertTrue(Challenge(oracle, scenario, model, kChallenge, 0xFA481C1B83D24E99ULL, result));
    XCTAssertGreaterThan(result.mCorrect[0], 72U * kChallenge / 100U);
    XCTAssertLessThan(result.mCorrect[0], 78U * kChallenge / 100U);
    XCTAssertNotEqual(result.mSignificant & 1U, std::uint64_t{0U});
    XCTAssertEqual(result.mShuffledSignificant, std::uint64_t{0U});
}

- (void)testTwoBitParityControl {
    const auto scenario = MakeScenario(128U);
    const Oracle oracle = [&](const Bytes &input, Bytes &output) {
        output = input;
        const auto other = scenario.mBits[8], target = scenario.mBits[0];
        output[target / 8U] ^= static_cast<std::uint8_t>(((input[other / 8U] >> (other % 8U)) & 1U) << (target % 8U));
        return true;
    };
    Model model;
    XCTAssertTrue(Train(oracle, scenario, model));
    Result result;
    XCTAssertTrue(Challenge(oracle, scenario, model, kChallenge, 0xFA481C1B83D24E99ULL, result));
    XCTAssertEqual(result.mCorrect[0], kChallenge);
    XCTAssertNotEqual(model.mPredictions[0].mFeature.mB, kNoBit);
    XCTAssertEqual(result.mShuffledSignificant, std::uint64_t{0U});
}

- (void)testIndependentOutputControl {
    const auto scenario = MakeScenario(128U);
    // Simulated null oracle, not a proposed cipher/security reference.
    std::mt19937_64 random(0x12E799B86A40D537ULL);
    const Oracle oracle = [&](const Bytes &input, Bytes &output) {
        output.resize(input.size()); Fill(output, random); return true;
    };
    Model model;
    XCTAssertTrue(Train(oracle, scenario, model));
    Result result;
    XCTAssertTrue(Challenge(oracle, scenario, model, kChallenge, 0xFA481C1B83D24E99ULL, result));
    XCTAssertEqual(result.mSignificant, std::uint64_t{0U});
    XCTAssertEqual(result.mShuffledSignificant, std::uint64_t{0U});
}

- (void)testConservativeThresholdAndScenarioCoverage {
    XCTAssertEqual(AdjustedTailBound(kChallenge / 2U, kChallenge), 1.0);
    XCTAssertGreaterThan(AdjustedTailBound(51U * kChallenge / 100U, kChallenge), kFamilyAlpha);
    XCTAssertLessThan(AdjustedTailBound(55U * kChallenge / 100U, kChallenge), kFamilyAlpha);
    const auto s = MakeScenario(kBlockBytes);
    XCTAssertTrue(ValidScenario(s));
    for (std::size_t layout = 0U; layout < 2U; ++layout) {
        std::array<unsigned, 8U> counts{};
        for (std::size_t i = layout * 32U; i < (layout + 1U) * 32U; ++i) { ++counts[s.mBits[i] % 8U]; }
        for (auto n : counts) { XCTAssertEqual(n, 4U); }
    }
}

- (void)testFailuresAreNotSecurityPasses {
    auto scenario = MakeScenario(128U);
    for (std::size_t failAt : std::array<std::size_t, 4U>{0U, 64U, 65U, 65U + kTrain}) {
        std::size_t calls = 0U;
        const Oracle oracle = [&](const Bytes &input, Bytes &output) {
            if (calls++ == failAt) { return false; }
            output = input; return true;
        };
        Model model;
        XCTAssertFalse(Train(oracle, scenario, model));
        XCTAssertFalse(model.mReady);
        XCTAssertEqual(calls, failAt + 1U);
    }
    const Oracle wrongSize = [](const Bytes &, Bytes &output) { output.clear(); return true; };
    Model model;
    XCTAssertFalse(Train(wrongSize, scenario, model));
    const Oracle identity = [](const Bytes &input, Bytes &output) { output = input; return true; };
    XCTAssertTrue(Train(identity, scenario, model));
    Result result;
    XCTAssertFalse(Challenge(wrongSize, scenario, model, 1U, 42U, result));
    std::uint64_t flags = 0U;
    XCTAssertFalse(Predict(model, Bytes{}, flags));
    scenario.mBits[1] = scenario.mBits[0];
    XCTAssertFalse(Train(identity, scenario, model));
    XCTAssertFalse(model.mReady);
}
@end
