// Search all 255 nonempty combinations of whole-block bit-plane parities.
// Train only on known plaintext/ciphertext pairs; freeze one predictor per
// plaintext combination before fresh, independent challenge blocks.
#import <XCTest/XCTest.h>
#include "StatisticalRecoveryHarness.hpp"
#include <bit>
using namespace StatisticalRecovery;

namespace PlaneParityRecovery {
constexpr std::size_t kTrainingCount = 256U;
constexpr std::size_t kChallengeCount = 2048U;
constexpr std::size_t kPredictionCount = 255U;
// 255 frozen hypotheses x 3 strengths x 2 fixtures x (real/shuffled labels).
constexpr std::size_t kFamilyHypotheses = kPredictionCount * 3U * 2U * 2U;
struct Observation { std::uint8_t mPlain; std::uint8_t mCipher; };
struct Predictor { std::uint8_t mMask = 0U; unsigned mPolarity = 0U; };
using Model = std::array<Predictor, kPredictionCount>;
using Scores = std::array<std::size_t, kPredictionCount>;

std::uint8_t PlaneParities(const Bytes &pBytes) {
    std::uint8_t aResult = 0U;
    for (auto aByte : pBytes) aResult ^= aByte;
    return aResult;
}
unsigned Parity(unsigned pValue) { return std::popcount(pValue) & 1U; }

Model Train(const std::vector<Observation> &pKnown) {
    Model aModel{};
    for (unsigned aPlainMask = 1U; aPlainMask < 256U; ++aPlainMask) {
        std::size_t aBest = 0U;
        for (unsigned aCipherMask = 1U; aCipherMask < 256U; ++aCipherMask) {
            std::size_t aCorrect = 0U;
            for (const auto &aPair : pKnown)
                aCorrect += Parity(aPair.mPlain & aPlainMask) == Parity(aPair.mCipher & aCipherMask);
            const auto aPolarity = aCorrect < pKnown.size() - aCorrect ? 1U : 0U;
            const auto aOriented = aPolarity ? pKnown.size() - aCorrect : aCorrect;
            if (aOriented > aBest) {
                aBest = aOriented;
                aModel[aPlainMask - 1U] = {static_cast<std::uint8_t>(aCipherMask), aPolarity};
            }
        }
    }
    return aModel;
}

// No plaintext, key, oracle, or challenge-label access in this predictor.
unsigned Predict(const Predictor &pModel, std::uint8_t pCipherParities) {
    return Parity(pCipherParities & pModel.mMask) ^ pModel.mPolarity;
}
Scores Score(const Model &pModel, const std::vector<Observation> &pChallenge,
             const std::vector<std::size_t> *pLabelOrder = nullptr) {
    Scores aScores{};
    for (std::size_t i = 0U; i < pChallenge.size(); ++i) {
        const auto aPlain = pChallenge[pLabelOrder ? (*pLabelOrder)[i] : i].mPlain;
        for (unsigned aMask = 1U; aMask < 256U; ++aMask)
            aScores[aMask - 1U] += Predict(pModel[aMask - 1U], pChallenge[i].mCipher) == Parity(aPlain & aMask);
    }
    return aScores;
}
double Cutoff(std::size_t pCount) {
    return 0.5 + std::sqrt(std::log(double(kFamilyHypotheses) / 1.0e-6) / (2.0*pCount));
}
bool Collect(const Oracle &pOracle, std::size_t pBytes, std::size_t pCount,
             std::uint64_t pSeed, std::vector<Observation> &pResult) {
    pResult.clear(); pResult.reserve(pCount);
    Bytes aPlain(pBytes), aCipher;
    std::mt19937_64 aRandom(pSeed);
    for (std::size_t i = 0U; i < pCount; ++i) {
        Fill(aPlain, aRandom);
        if (!pOracle(aPlain, aCipher) || aCipher.size() != pBytes) return false;
        pResult.push_back({PlaneParities(aPlain), PlaneParities(aCipher)});
    }
    return true;
}
} // namespace PlaneParityRecovery

@interface BitPlaneParityRecoveryTests : XCTestCase
@end
@implementation BitPlaneParityRecoveryTests
- (void)checkStrength:(EncryptionStrength)pStrength {
    namespace Attack = PlaneParityRecovery;
    for (std::size_t aFixture = 0U; aFixture < 2U; ++aFixture) {
        ClearSoccerOnExit aCleanup;
        if (!SeedFixture(pStrength, aFixture)) { XCTFail(@"Plane-parity seeding failed"); return; }
        const Oracle aOracle = [](const Bytes &pPlain, Bytes &pCipher) {
            Bytes aSource = pPlain; pCipher.resize(kBlockBytes);
            return Soccer3::EncryptBlock(aSource.data(), pCipher.data());
        };
        std::vector<Attack::Observation> aTraining, aChallenge;
        if (!Attack::Collect(aOracle, kBlockBytes, Attack::kTrainingCount, 0xF1A0E1113ULL+aFixture, aTraining)) {
            XCTFail(@"Plane-parity training oracle failed"); return;
        }
        const auto aModel = Attack::Train(aTraining);
        if (!Attack::Collect(aOracle, kBlockBytes, Attack::kChallengeCount, 0xF1A0E2213ULL+aFixture, aChallenge)) {
            XCTFail(@"Plane-parity challenge oracle failed"); return;
        }
        const auto aScores = Attack::Score(aModel, aChallenge);
        std::vector<std::size_t> aOrder(aChallenge.size());
        for (std::size_t i = 0U; i < aOrder.size(); ++i) aOrder[i] = i;
        std::mt19937_64 aShuffle(0xF1A0E3313ULL); std::shuffle(aOrder.begin(), aOrder.end(), aShuffle);
        const auto aShuffled = Attack::Score(aModel, aChallenge, &aOrder);
        const auto aCutoff = Attack::Cutoff(aChallenge.size());
        std::size_t aSignificant = 0U, aShuffledSignificant = 0U;
        for (unsigned i = 0U; i < aScores.size(); ++i) {
            if (double(aScores[i])/aChallenge.size() >= aCutoff) {
                ++aSignificant;
                std::printf("Plane-parity finding | plain_mask=0x%02x cipher_mask=0x%02x polarity=%u accuracy=%.4f%%\n",
                    i+1U, unsigned(aModel[i].mMask), aModel[i].mPolarity, 100.0*aScores[i]/aChallenge.size());
            }
            aShuffledSignificant += double(aShuffled[i])/aChallenge.size() >= aCutoff;
        }
        std::printf("Bit-plane parity | flame-toad-vault | strength=%u fixture=%zu | best=%.4f%% cutoff=%.4f%% | significant=%zu/255 shuffled=%zu | %s\n",
            unsigned(pStrength), aFixture, 100.0*(*std::max_element(aScores.begin(),aScores.end()))/aChallenge.size(),
            100.0*aCutoff, aSignificant, aShuffledSignificant, aSignificant || aShuffledSignificant ? "FAIL" : "PASS");
        std::fflush(stdout);
        XCTAssertEqual(aShuffledSignificant, std::size_t{0U}, @"Plane-parity shuffled-label control failed");
        XCTAssertEqual(aSignificant, std::size_t{0U}, @"SECURITY: aggregate bit-plane parity is predictable");
    }
}
- (void)testBitPlaneParityWeak { [self checkStrength:EncryptionStrength::kWeak]; }
- (void)testBitPlaneParityNormal { [self checkStrength:EncryptionStrength::kNormal]; }
- (void)testBitPlaneParityStrong { [self checkStrength:EncryptionStrength::kStrong]; }
- (void)testControlRecoversRotatedPlanesWithFixedOffset {
    namespace Attack = PlaneParityRecovery;
    const Oracle aOracle = [](const Bytes &pPlain, Bytes &pCipher) {
        pCipher = pPlain;
        for (auto &aByte : pCipher) aByte = std::rotl(aByte,3);
        pCipher[0] ^= 0xADU;
        return true;
    };
    std::vector<Attack::Observation> aTrain, aChallenge;
    XCTAssertTrue(Attack::Collect(aOracle,128U,256U,123U,aTrain));
    const auto aModel = Attack::Train(aTrain);
    XCTAssertTrue(Attack::Collect(aOracle,128U,2048U,456U,aChallenge));
    for (auto aCorrect : Attack::Score(aModel,aChallenge)) XCTAssertEqual(aCorrect,aChallenge.size());
}
- (void)testControlRejectsIndependentOutputAndOracleErrors {
    namespace Attack = PlaneParityRecovery;
    std::mt19937_64 aRandom(89123U);
    const Oracle aOracle = [&](const Bytes &pPlain, Bytes &pCipher) {
        pCipher.resize(pPlain.size()); Fill(pCipher,aRandom); return true;
    };
    std::vector<Attack::Observation> aTrain, aChallenge;
    XCTAssertTrue(Attack::Collect(aOracle,128U,256U,123U,aTrain));
    const auto aModel = Attack::Train(aTrain);
    XCTAssertTrue(Attack::Collect(aOracle,128U,2048U,456U,aChallenge));
    for (auto aCorrect : Attack::Score(aModel,aChallenge))
        XCTAssertLessThan(double(aCorrect)/aChallenge.size(),Attack::Cutoff(aChallenge.size()));
    XCTAssertFalse(Attack::Collect([](const Bytes &,Bytes &){return false;},128U,1U,1U,aChallenge));
    XCTAssertFalse(Attack::Collect([](const Bytes &,Bytes &pOut){pOut.clear();return true;},128U,1U,1U,aChallenge));
}
@end
