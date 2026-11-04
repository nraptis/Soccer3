// Serial: these checks configure Soccer's shared material and plan state.
#import <XCTest/XCTest.h>
#include "Soccer2.hpp"
#include "EncryptionVaultPlan.hpp"
#include "SeedMaterialTestSupport.hpp"
#include "GutCheckValidator.hpp"
#include "FlameToadCipherChecks.hpp"
#include <algorithm>
#include <array>
#include <cstring>
#include <vector>

namespace {
using Bytes = std::vector<std::uint8_t>;
constexpr EncryptionStrength kStrengths[] = {EncryptionStrength::kWeak, EncryptionStrength::kNormal, EncryptionStrength::kStrong};
struct Cleanup { ~Cleanup() { Soccer2::Zero(); } };

std::array<WindowRotationPackChunk *, 8U> Chunks(WindowRotationPack &pPack) {
    return {&pPack.mPlaneA.mChunkA, &pPack.mPlaneA.mChunkB, &pPack.mPlaneA.mChunkC, &pPack.mPlaneA.mChunkD,
            &pPack.mPlaneB.mChunkA, &pPack.mPlaneB.mChunkB, &pPack.mPlaneB.mChunkC, &pPack.mPlaneB.mChunkD};
}
std::array<std::uint16_t *, 16U> Windows(WindowRotationPackChunk &pChunk) {
    return {&pChunk.mWindowA, &pChunk.mWindowB, &pChunk.mWindowC, &pChunk.mWindowD,
            &pChunk.mWindowE, &pChunk.mWindowF, &pChunk.mWindowG, &pChunk.mWindowH,
            &pChunk.mWindowI, &pChunk.mWindowJ, &pChunk.mWindowK, &pChunk.mWindowL,
            &pChunk.mWindowM, &pChunk.mWindowN, &pChunk.mWindowO, &pChunk.mWindowP};
}
std::size_t Budget(EncryptionStrength pStrength) {
    return pStrength == EncryptionStrength::kWeak ? 4U : pStrength == EncryptionStrength::kNormal ? 8U : 16U;
}
void Prepare(EncryptionStrength pStrength) {
    Soccer2::Zero();
    Soccer2::mStrength = pStrength;
    SeedMaterialTestSupport::Prepare(0x20261103ULL);
    std::uint8_t *aMaterials[] = {Soccer2::mMaterialA, Soccer2::mMaterialB, Soccer2::mMaterialC, Soccer2::mMaterialD,
        Soccer2::mMaterialE, Soccer2::mMaterialF, Soccer2::mMaterialG, Soccer2::mMaterialH,
        Soccer2::mMaterialI, Soccer2::mMaterialJ, Soccer2::mMaterialK, Soccer2::mMaterialL,
        Soccer2::mMaterialM, Soccer2::mMaterialN, Soccer2::mMaterialO, Soccer2::mMaterialP};
    for (std::size_t aLane = 0U; aLane < Budget(pStrength); ++aLane) {
        Soccer2::mMaterials[aLane] = aMaterials[aLane];
        for (std::size_t aByte = 0U; aByte < SOCCER_BLOCK_SIZE; ++aByte)
            aMaterials[aLane][aByte] = static_cast<std::uint8_t>((aByte * (17U + 2U * aLane)) ^ (aByte >> 11U) ^ (aLane * 71U));
    }
    Soccer2::SeedEpilogue_Regular_C();
}

// Independent literal implementation of the requested sequence. In particular,
// it places the only bit reversal AFTER l3's trailing XOR, not inside each layer.
Bytes Reference(Bytes pBytes, EncryptionStrength pStrength, const BitPlane &pRows,
                WindowRotationPack pRotations,
                std::uint8_t *const *pMaterials) {
    std::size_t aMaterial = 0U;
    Bytes aMoved(pBytes.size());
    auto aXOR = [&] {
        for (std::size_t aByte = 0U; aByte < pBytes.size(); ++aByte) pBytes[aByte] ^= pMaterials[aMaterial][aByte];
        ++aMaterial;
    };
    for (unsigned aLayer = 0U; aLayer < 8U; ++aLayer) {
        auto &aChunk = *Chunks(pRotations)[aLayer];
        const auto aWindows = Windows(aChunk);
        for (std::size_t aFrog = 0U; aFrog < 4U; ++aFrog) {
            const auto &aPair = pRows.mColumns[aFrog].mPairs[aLayer % 4U];
            const auto *aRotations = aWindows.data() + 4U*aFrog;
            pBytes = FlameToadChecks::Reference(pBytes, aPair.mBitA, aPair.mBitB,
                {*aRotations[0],*aRotations[1],*aRotations[2],*aRotations[3]});
        }
        if (pStrength == EncryptionStrength::kStrong) aXOR();
        for (unsigned aRotation = 0U; aRotation < 2U; ++aRotation) {
            unsigned aMask = 0U;
            for (const auto &aPair : pRows.GetRow(aLayer % 4U).mPairs)
                aMask |= 1U << (aRotation == 0U ? aPair.mBitA : aPair.mBitB);
            const auto aShift = static_cast<std::size_t>(aRotation == 0U ? aChunk.mFreeA : aChunk.mFreeB);
            for (std::size_t aByte = 0U; aByte < pBytes.size(); ++aByte)
                aMoved[aByte] = static_cast<std::uint8_t>((pBytes[aByte] & (255U ^ aMask)) |
                    (pBytes[(aByte + pBytes.size() - aShift) % pBytes.size()] & aMask));
            pBytes.swap(aMoved);
        }
        if (pStrength != EncryptionStrength::kWeak || aLayer % 4U >= 2U) aXOR();
        if (aLayer == 3U) for (auto &aByte : pBytes) {
            unsigned aReversed = 0U;
            for (unsigned aBit = 0U; aBit < 8U; ++aBit)
                aReversed |= ((aByte >> aBit) & 1U) << (7U - aBit);
            aByte = static_cast<std::uint8_t>(aReversed);
        }
    }
    return pBytes;
}
}

@interface EncryptionVaultPlanTests : XCTestCase
@end
@implementation EncryptionVaultPlanTests
- (void)testExactRowsMasksRotationsAndMaterialSchedule {
    Cleanup aCleanup;
    for (auto aStrength : kStrengths) {
        Prepare(aStrength);
        XCTAssertTrue(Soccer2::SeedEpilogue_Regular_D());
        XCTAssertTrue(Soccer2::mEncryptionReady);
        const auto &aPlan = Soccer2::mEncryptionVaultPlan;
        XCTAssertEqual(aPlan.mMaterialCount, Budget(aStrength));
        XCTAssertEqual(Soccer2::mMaterialIndex, Budget(aStrength));
        XCTAssertTrue(GutCheckValidator::ValidateMask("FlameToad vault"));
        // Old GutCheck rotation check retired; dedicated WindowRotation tests cover the new grouping.
        BitPlane aExpectedPlane{};
        BitPlaneFarm::Select(Soccer2::mBitPlaneWordA, Soccer2::mBitPlaneWordB,
                             Soccer2::mBitPlaneWordC, &aExpectedPlane);
        XCTAssertTrue(Soccer2::mBitPlane == aExpectedPlane);
        constexpr unsigned kWeakAfter[] = {255U,255U,0U,1U,255U,255U,2U,3U};
        for (unsigned aLayer = 0U; aLayer < 8U; ++aLayer) {
            const auto &aEntry = aPlan.mLayers[aLayer];
            XCTAssertTrue(aEntry.mRow == Soccer2::mBitPlane.GetRow(aLayer % 4U));
            XCTAssertEqual(aEntry.mMasks[0U] & aEntry.mMasks[1U], 0);
            XCTAssertEqual(aEntry.mMasks[0U] | aEntry.mMasks[1U], 255);
            XCTAssertEqual(__builtin_popcount(aEntry.mMasks[0U]), 4);
            XCTAssertEqual(__builtin_popcount(aEntry.mMasks[1U]), 4);
            XCTAssertEqual(aEntry.mRotations[0U], Chunks(Soccer2::mWindowRotationPack)[aLayer]->mFreeA);
            XCTAssertEqual(aEntry.mRotations[1U], Chunks(Soccer2::mWindowRotationPack)[aLayer]->mFreeB);
            XCTAssertEqual(unsigned(aEntry.mMaterialBeforeRotations), aStrength == EncryptionStrength::kStrong ? 2U * aLayer : 255U);
            XCTAssertEqual(unsigned(aEntry.mMaterialAfterRotations), aStrength == EncryptionStrength::kWeak ? kWeakAfter[aLayer]
                : aStrength == EncryptionStrength::kNormal ? aLayer : 2U * aLayer + 1U);
        }
    }
}

- (void)testFullMiBCiphertextMatchesLiteralReferenceForEveryStrength {
    Cleanup aCleanup;
    Bytes aPlain(SOCCER_BLOCK_SIZE), aEncrypted(aPlain.size()), aRestored(aPlain.size()), aRepeat(aPlain.size());
    for (std::size_t aByte = 0U; aByte < aPlain.size(); ++aByte) aPlain[aByte] = static_cast<std::uint8_t>((aByte * 37U) ^ (aByte >> 7U));
    for (auto aStrength : kStrengths) {
        Prepare(aStrength);
        const auto aExpected = Reference(aPlain, aStrength, Soccer2::mBitPlane, Soccer2::mWindowRotationPack, Soccer2::mMaterials);
        XCTAssertTrue(Soccer2::SeedEpilogue_Regular_D());
        XCTAssertTrue(Soccer2::EncryptBlock(aPlain.data(), aEncrypted.data()));
        XCTAssertTrue(aEncrypted == aExpected);
        std::fill_n(Soccer2::mCollapseLaneC, SOCCER_BLOCK_SIZE/4U, std::uint8_t{0x37U});
        XCTAssertTrue(Soccer2::DecryptBlock(aEncrypted.data(), aRestored.data()));
        XCTAssertTrue(aRestored == aPlain);
        // Building again must replace, not append, the cipher stack.
        XCTAssertTrue(Soccer2::SeedEpilogue_Regular_D());
        XCTAssertTrue(Soccer2::EncryptBlock(aPlain.data(), aRepeat.data()));
        XCTAssertTrue(aRepeat == aEncrypted);
    }
}

- (void)testThreeSelectionWordsAll144RotationsAndAllStrongMaterialsReachTheVault {
    Cleanup aCleanup;
    Prepare(EncryptionStrength::kStrong);
    Bytes aPlain(SOCCER_BLOCK_SIZE), aBaseline(SOCCER_BLOCK_SIZE), aChanged(SOCCER_BLOCK_SIZE);
    std::mt19937_64 aRandom(0xA11C1F3EULL);
    for (auto &aByte : aPlain) aByte = static_cast<std::uint8_t>(aRandom());
    auto aEncrypt = [&] {
        return Soccer2::SeedEpilogue_Regular_D() && Soccer2::EncryptBlock(aPlain.data(), aChanged.data());
    };
    XCTAssertTrue(aEncrypt()); aBaseline = aChanged;
    for (unsigned aIndex = 0U; aIndex < 16U; ++aIndex) {
        std::swap(Chunks(Soccer2::mWindowRotationPack)[aIndex / 2U]->mFreeA, Chunks(Soccer2::mWindowRotationPack)[aIndex / 2U]->mFreeB);
        XCTAssertTrue(aEncrypt()); XCTAssertTrue(aChanged != aBaseline, @"Rotation %u is unused", aIndex);
        std::swap(Chunks(Soccer2::mWindowRotationPack)[aIndex / 2U]->mFreeA, Chunks(Soccer2::mWindowRotationPack)[aIndex / 2U]->mFreeB);
        auto &aMaterialByte = Soccer2::mMaterials[aIndex][997U * aIndex];
        aMaterialByte ^= 1U;
        XCTAssertTrue(aEncrypt()); XCTAssertTrue(aChanged != aBaseline, @"Material %u is unused", aIndex);
        aMaterialByte ^= 1U;
    }
    std::uint64_t *aWords[] = {&Soccer2::mBitPlaneWordA, &Soccer2::mBitPlaneWordB, &Soccer2::mBitPlaneWordC};
    for (unsigned aIndex = 0U; aIndex < 3U; ++aIndex) {
        ++*aWords[aIndex];
        Soccer2::SelectBitPlane();
        XCTAssertTrue(aEncrypt()); XCTAssertTrue(aChanged != aBaseline, @"Bit-plane selector %u is unused", aIndex);
        --*aWords[aIndex];
    }
    Soccer2::SelectBitPlane();
    for (unsigned aIndex=0U; aIndex<128U; ++aIndex) {
        auto aWindows = Windows(*Chunks(Soccer2::mWindowRotationPack)[aIndex / 16U]);
        const auto aLocal = aIndex % 16U;
        const auto aOther = (aLocal / 4U) * 4U + (aLocal + 1U) % 4U;
        std::swap(*aWindows[aLocal], *aWindows[aOther]);
        XCTAssertTrue(aEncrypt()); XCTAssertTrue(aChanged != aBaseline, @"Sampling rotation %u is unused",aIndex);
        std::swap(*aWindows[aLocal], *aWindows[aOther]);
    }

}

- (void)testRejectsInvalidPlansMissingMaterialsAndFailedConfiguration {
    Cleanup aCleanup;
    Prepare(EncryptionStrength::kStrong);
    XCTAssertTrue(Soccer2::SeedEpilogue_Regular_D());
    EncryptionVault aVault;
    const auto aValid = Soccer2::mEncryptionVaultPlan;
    std::array<std::uint8_t,16U> aSmallCache{};
    XCTAssertFalse(EncryptionVaultPlanTool::Build(aVault,aValid,Soccer2::mMaterials,16U,aSmallCache));
    XCTAssertFalse(EncryptionVaultPlanTool::Build(aVault,aValid,Soccer2::mMaterials,16U,
        std::span<std::uint8_t>{Soccer2::mMaterials[0],SOCCER_BLOCK_SIZE/4U}));
    XCTAssertFalse(EncryptionVaultPlanTool::Build(aVault, aValid, Soccer2::mMaterials, 15U));
    auto aInvalid = aValid;
    aInvalid.mLayers[0U].mMasks[0U] ^= 0x84U;
    XCTAssertFalse(EncryptionVaultPlanTool::Build(aVault, aInvalid, Soccer2::mMaterials, 16U));
    aInvalid = aValid; aInvalid.mLayers[7U].mMaterialAfterRotations = 16U;
    XCTAssertFalse(EncryptionVaultPlanTool::Build(aVault, aInvalid, Soccer2::mMaterials, 16U));
    aInvalid = aValid; aInvalid.mLayers[7U].mRotations[1U] = aInvalid.mLayers[0U].mRotations[0U];
    XCTAssertFalse(EncryptionVaultPlanTool::Build(aVault, aInvalid, Soccer2::mMaterials, 16U));
    aInvalid = aValid; std::swap(aInvalid.mLayers[4U].mRow.mPairs[0U], aInvalid.mLayers[4U].mRow.mPairs[1U]);
    XCTAssertFalse(EncryptionVaultPlanTool::Build(aVault, aInvalid, Soccer2::mMaterials, 16U));
    EncryptionVaultPlan aResult;
    XCTAssertFalse(EncryptionVaultPlanTool::MakePlan(EncryptionStrength::kTest, Soccer2::mBitPlane,
        Soccer2::mWindowRotationPack, aResult));
    auto aInvalidRotations = Soccer2::mWindowRotationPack;
    aInvalidRotations.mPlaneA.mChunkA.mWindowA = 0U;
    XCTAssertFalse(EncryptionVaultPlanTool::MakePlan(EncryptionStrength::kStrong, Soccer2::mBitPlane,
        aInvalidRotations, aResult));
    Soccer2::mMaterials[15U] = nullptr;
    XCTAssertFalse(Soccer2::SeedEpilogue_Regular_D());
    XCTAssertFalse(Soccer2::mEncryptionReady);
    Bytes aPlain(SOCCER_BLOCK_SIZE), aOutput(SOCCER_BLOCK_SIZE, 0xA5U);
    XCTAssertFalse(Soccer2::EncryptBlock(aPlain.data(), aOutput.data()));
    XCTAssertTrue(std::all_of(aOutput.begin(), aOutput.end(), [](auto pByte) { return pByte == 0xA5U; }));
}

// Whole-block parity recovery now lives in WholeBlockParityRecoveryTests.mm.
- (void)testRealSeedRepeatsIndependentBlocksAndReconstructsVaultForDecryption {
    Cleanup aCleanup;
    constexpr std::uint64_t kNonce = 0x2026103001234567ULL;
    std::array<std::uint8_t, 14U> aPassword{};
    std::memcpy(aPassword.data(), "review-fixture", aPassword.size());
    Bytes aPlain(SOCCER_BLOCK_SIZE), aOther(SOCCER_BLOCK_SIZE), aFirst(SOCCER_BLOCK_SIZE),
          aSecond(SOCCER_BLOCK_SIZE), aRepeat(SOCCER_BLOCK_SIZE), aRestored(SOCCER_BLOCK_SIZE);
    for (std::size_t aByte = 0U; aByte < aPlain.size(); ++aByte) {
        aPlain[aByte] = static_cast<std::uint8_t>((aByte * 37U) ^ (aByte >> 8U));
        aOther[aByte] = aPlain[aByte] ^ (aByte % 997U == 0U ? 0xA5U : 0U);
    }
    for (auto aStrength : kStrengths) {
        Soccer2::Zero();
        std::uint32_t aAcknowledgement = 0U;
        if (!Soccer2::AttemptSeed_Encrypt(aStrength, aPassword.data(), aPassword.size(), kNonce, &aAcknowledgement, 0U, nullptr)) {
            XCTFail(@"vault seeding failed"); return;
        }
        XCTAssertTrue(Soccer2::mEncryptionReady);
        const auto aPlan = Soccer2::mEncryptionVaultPlan;
        const auto aPlane = Soccer2::mBitPlane;
        std::uint64_t aFreeWords[16];
        std::int32_t aFreeRotations[16];
        for (std::size_t aIndex = 0U; aIndex < 16U; ++aIndex) {
            aFreeWords[aIndex] = *SeedMaterialTestSupport::FreeRotationWords()[aIndex];
            aFreeRotations[aIndex] = *SeedMaterialTestSupport::FreeRotations()[aIndex];
        }
        const std::uint64_t aWords[] = {Soccer2::mBitPlaneWordA, Soccer2::mBitPlaneWordB, Soccer2::mBitPlaneWordC};
        XCTAssertTrue(aPlane.IsValid());
        XCTAssertTrue((aWords[0] | aWords[1] | aWords[2]) != 0U);
        XCTAssertEqual(Soccer2::mMaterialIndex, Budget(aStrength));
        XCTAssertTrue(Soccer2::EncryptBlock(aPlain.data(), aFirst.data()));
        XCTAssertTrue(Soccer2::EncryptBlock(aOther.data(), aSecond.data()));
        XCTAssertTrue(Soccer2::EncryptBlock(aPlain.data(), aRepeat.data()));
        XCTAssertTrue(aFirst == aRepeat && aFirst != aSecond);
        Soccer2::Zero();
        XCTAssertFalse(Soccer2::mEncryptionReady);
        // Decryption must reset its own accumulators, even without a clean start.
        Soccer2::mBitPlaneWordA = 999U;
        Soccer2::mBitPlaneWordB = 888U;
        Soccer2::mBitPlaneWordC = 777U;
        for (auto *aWord : SeedMaterialTestSupport::FreeRotationWords()) *aWord = 666U;
        for (auto *aRotation : SeedMaterialTestSupport::FreeRotations()) *aRotation = 555;
        if (!Soccer2::AttemptSeed_Decrypt(aStrength, aPassword.data(), aPassword.size(), kNonce, aAcknowledgement, 0U, nullptr)) {
            XCTFail(@"vault decrypt seeding failed"); return;
        }
        for (std::size_t aIndex = 0U; aIndex < 16U; ++aIndex) {
            XCTAssertEqual(*SeedMaterialTestSupport::FreeRotationWords()[aIndex], aFreeWords[aIndex]);
            XCTAssertEqual(*SeedMaterialTestSupport::FreeRotations()[aIndex], aFreeRotations[aIndex]);
        }
        XCTAssertTrue(Soccer2::mEncryptionVaultPlan == aPlan);
        XCTAssertTrue(Soccer2::mBitPlane == aPlane);
        XCTAssertEqual(Soccer2::mBitPlaneWordA, aWords[0]);
        XCTAssertEqual(Soccer2::mBitPlaneWordB, aWords[1]);
        XCTAssertEqual(Soccer2::mBitPlaneWordC, aWords[2]);
        XCTAssertTrue(Soccer2::DecryptBlock(aSecond.data(), aRestored.data())); XCTAssertTrue(aRestored == aOther);
        XCTAssertTrue(Soccer2::DecryptBlock(aFirst.data(), aRestored.data())); XCTAssertTrue(aRestored == aPlain);
    }
}
@end
