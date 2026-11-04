// Serial: these checks configure Soccer's shared material and plan state.
#import <XCTest/XCTest.h>
#include "Soccer3.hpp"
#include "Cryptex.hpp"
#include "CryptexTestSupport.hpp"
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
struct Cleanup { ~Cleanup() { Soccer3::Zero(); } };

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
    Soccer3::Zero();
    Soccer3::mStrength = pStrength;
    SeedMaterialTestSupport::Prepare(0x20261103ULL);
    std::uint8_t *aMaterials[] = {Soccer3::mMaterialA, Soccer3::mMaterialB, Soccer3::mMaterialC, Soccer3::mMaterialD,
        Soccer3::mMaterialE, Soccer3::mMaterialF, Soccer3::mMaterialG, Soccer3::mMaterialH,
        Soccer3::mMaterialI, Soccer3::mMaterialJ, Soccer3::mMaterialK, Soccer3::mMaterialL,
        Soccer3::mMaterialM, Soccer3::mMaterialN, Soccer3::mMaterialO, Soccer3::mMaterialP};
    for (std::size_t aLane = 0U; aLane < Budget(pStrength); ++aLane) {
        Soccer3::mMaterials[aLane] = aMaterials[aLane];
        for (std::size_t aByte = 0U; aByte < SOCCER_BLOCK_SIZE; ++aByte)
            aMaterials[aLane][aByte] = static_cast<std::uint8_t>((aByte * (17U + 2U * aLane)) ^ (aByte >> 11U) ^ (aLane * 71U));
    }
    Soccer3::SeedEpilogue_Regular_C();
}

// Independent literal implementation of the requested sequence. In particular,
// it places the only bit reversal AFTER l3's trailing XOR, not inside each layer.
Bytes Reference(Bytes pBytes, EncryptionStrength pStrength, const BitPlane &pRows,
                WindowRotationPack pRotations,
                std::uint8_t *const *pMaterials) {
    const auto aWords = SeedMaterialTestSupport::FreeRotationWords();
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
        const auto aFirstOffset = 1U + *aWords[2U * aLayer] % 63U;
        const auto aSecondWord = *aWords[2U * aLayer + 1U];
        const auto aSecondOffset = (aFirstOffset & 1U) == 0U ?
            1U + 2U * (aSecondWord % 32U) : 1U + aSecondWord % 63U;
        for (unsigned aRotation = 0U; aRotation < 2U; ++aRotation) {
            unsigned aMask = 0U;
            for (const auto &aPair : pRows.GetRow(aLayer % 4U).mPairs)
                aMask |= 1U << (aRotation == 0U ? aPair.mBitA : aPair.mBitB);
            const auto aShift = static_cast<std::size_t>(aRotation == 0U ? 64U * aChunk.mWindowFreeA + aFirstOffset : 64U * aChunk.mWindowFreeB + aSecondOffset);
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

@interface CryptexBuildTests : XCTestCase
@end
@implementation CryptexBuildTests
- (void)testExactRowsMasksRotationsAndMaterialSchedule {
    Cleanup aCleanup;
    for (auto aStrength : kStrengths) {
        Prepare(aStrength);
        XCTAssertTrue(Soccer3::SeedEpilogue_Regular_D());
        XCTAssertTrue(Soccer3::mEncryptionReady);
        XCTAssertEqual(Soccer3::mCryptex.GetMaterialCount(), Budget(aStrength));
        XCTAssertEqual(Soccer3::mMaterialIndex, Budget(aStrength));
        XCTAssertTrue(GutCheckValidator::ValidateMask("FlameToad Cryptex"));
        const auto aRows = CryptexTestSupport::Rows();
        const auto aMasks = CryptexTestSupport::Masks();
        const auto aRotations = CryptexTestSupport::Rotations();
        const auto aLayers = CryptexTestSupport::Layers(Soccer3::mCryptex);
        for (unsigned aLayer = 0U; aLayer < 8U; ++aLayer) {
            XCTAssertTrue(aRows[aLayer % 4U] == Soccer3::mBitPlane.GetRow(aLayer % 4U));
            XCTAssertEqual(aMasks[2U*aLayer] & aMasks[2U*aLayer+1U], 0);
            XCTAssertEqual(aMasks[2U*aLayer] | aMasks[2U*aLayer+1U], 255);
            XCTAssertEqual(aRotations[2U*aLayer] / 64, Chunks(Soccer3::mWindowRotationPack)[aLayer]->mWindowFreeA);
            XCTAssertEqual(aRotations[2U*aLayer+1U] / 64, Chunks(Soccer3::mWindowRotationPack)[aLayer]->mWindowFreeB);
            std::vector<CipherType> aExpected(4U, CipherType::kFlameToadCipher);
            if (aStrength == EncryptionStrength::kStrong) aExpected.push_back(CipherType::kPasswordXORCipher);
            aExpected.push_back(CipherType::kShiftMaskedCipher);
            aExpected.push_back(CipherType::kShiftMaskedCipher);
            if (aStrength != EncryptionStrength::kWeak || aLayer % 4U >= 2U)
                aExpected.push_back(CipherType::kPasswordXORCipher);
            if (aLayer == 3U) aExpected.push_back(CipherType::kBitReverseCipher);
            XCTAssertEqual(aLayers[aLayer]->GetCipherCount(), aExpected.size());
            for (std::size_t aCipher = 0U; aCipher < aExpected.size(); ++aCipher)
                XCTAssertEqual(aLayers[aLayer]->GetCipherType(aCipher), aExpected[aCipher]);
        }
    }
}

- (void)testFullMiBCiphertextMatchesLiteralReferenceForEveryStrength {
    Cleanup aCleanup;
    Bytes aPlain(SOCCER_BLOCK_SIZE), aEncrypted(aPlain.size()), aRestored(aPlain.size()), aRepeat(aPlain.size());
    for (std::size_t aByte = 0U; aByte < aPlain.size(); ++aByte) aPlain[aByte] = static_cast<std::uint8_t>((aByte * 37U) ^ (aByte >> 7U));
    for (auto aStrength : kStrengths) {
        Prepare(aStrength);
        const auto aExpected = Reference(aPlain, aStrength, Soccer3::mBitPlane, Soccer3::mWindowRotationPack, Soccer3::mMaterials);
        XCTAssertTrue(Soccer3::SeedEpilogue_Regular_D());
        XCTAssertTrue(Soccer3::EncryptBlock(aPlain.data(), aEncrypted.data()));
        XCTAssertTrue(aEncrypted == aExpected);
        std::fill_n(Soccer3::mCollapseLaneC, SOCCER_BLOCK_SIZE/4U, std::uint8_t{0x37U});
        XCTAssertTrue(Soccer3::DecryptBlock(aEncrypted.data(), aRestored.data()));
        XCTAssertTrue(aRestored == aPlain);
        // Building again must replace, not append, the cipher stack.
        XCTAssertTrue(Soccer3::SeedEpilogue_Regular_D());
        XCTAssertTrue(Soccer3::EncryptBlock(aPlain.data(), aRepeat.data()));
        XCTAssertTrue(aRepeat == aEncrypted);
    }
}

- (void)testThreeSelectionWordsAll144RotationsAndAllStrongMaterialsReachCryptex {
    Cleanup aCleanup;
    Prepare(EncryptionStrength::kStrong);
    Bytes aPlain(SOCCER_BLOCK_SIZE), aBaseline(SOCCER_BLOCK_SIZE), aChanged(SOCCER_BLOCK_SIZE);
    std::mt19937_64 aRandom(0xA11C1F3EULL);
    for (auto &aByte : aPlain) aByte = static_cast<std::uint8_t>(aRandom());
    auto aEncrypt = [&] {
        return Soccer3::SeedEpilogue_Regular_D() && Soccer3::EncryptBlock(aPlain.data(), aChanged.data());
    };
    XCTAssertTrue(aEncrypt()); aBaseline = aChanged;
    for (unsigned aIndex = 0U; aIndex < 16U; ++aIndex) {
        auto *aWord = SeedMaterialTestSupport::FreeRotationWords()[aIndex];
        const auto aOriginalWord = *aWord;
        ++*aWord;
        XCTAssertTrue(aEncrypt()); XCTAssertTrue(aChanged != aBaseline, @"Rotation %u is unused", aIndex);
        *aWord = aOriginalWord;
        auto &aMaterialByte = Soccer3::mMaterials[aIndex][997U * aIndex];
        aMaterialByte ^= 1U;
        XCTAssertTrue(aEncrypt()); XCTAssertTrue(aChanged != aBaseline, @"Material %u is unused", aIndex);
        aMaterialByte ^= 1U;
    }
    std::uint64_t *aWords[] = {&Soccer3::mBitPlaneWordA, &Soccer3::mBitPlaneWordB, &Soccer3::mBitPlaneWordC};
    for (unsigned aIndex = 0U; aIndex < 3U; ++aIndex) {
        ++*aWords[aIndex];
        Soccer3::SelectBitPlane();
        XCTAssertTrue(aEncrypt()); XCTAssertTrue(aChanged != aBaseline, @"Bit-plane selector %u is unused", aIndex);
        --*aWords[aIndex];
    }
    Soccer3::SelectBitPlane();
    for (unsigned aIndex=0U; aIndex<128U; ++aIndex) {
        auto aWindows = Windows(*Chunks(Soccer3::mWindowRotationPack)[aIndex / 16U]);
        const auto aLocal = aIndex % 16U;
        const auto aOther = (aLocal / 4U) * 4U + (aLocal + 1U) % 4U;
        std::swap(*aWindows[aLocal], *aWindows[aOther]);
        XCTAssertTrue(aEncrypt()); XCTAssertTrue(aChanged != aBaseline, @"Sampling rotation %u is unused",aIndex);
        std::swap(*aWindows[aLocal], *aWindows[aOther]);
    }

}

- (void)testBuildClearsOldCiphersAndRejectsInvalidInputs {
    Cleanup aCleanup;
    Prepare(EncryptionStrength::kStrong);
    XCTAssertTrue(Soccer3::SeedEpilogue_Regular_D());
    auto &aCryptex = Soccer3::mCryptex;
    const auto aRebuild = [&] {
        XCTAssertTrue(Soccer3::PrepareCryptexInputs());
        XCTAssertTrue(aCryptex.Build(EncryptionStrength::kStrong));
    };
    const auto aReject = [&] {
        XCTAssertFalse(aCryptex.Build(EncryptionStrength::kStrong));
        XCTAssertFalse(aCryptex.IsBuilt());
        for (auto *aLayer : CryptexTestSupport::Layers(aCryptex)) XCTAssertEqual(aLayer->GetCipherCount(), 0U);
    };
    Soccer3::mPackedRowLength = 16U; aReject(); aRebuild();
    Soccer3::mPackedRows = Soccer3::mMaterials[0U]; aReject(); aRebuild();
    Soccer3::mRotationMaskA ^= 0x84U; aReject(); aRebuild();
    Soccer3::mShiftMaskedCipherRotationBH = Soccer3::mShiftMaskedCipherRotationAA; aReject(); aRebuild();
    Soccer3::mFlameToadCipherRotationAAA = 0U; aReject(); aRebuild();
    Soccer3::mBitRowAA = 8U; aReject(); aRebuild();
    Soccer3::mMutateMaterialP = nullptr; aReject(); aRebuild();
    Soccer3::mMaterials[15U] = nullptr;
    XCTAssertFalse(Soccer3::SeedEpilogue_Regular_D());
    XCTAssertFalse(Soccer3::mEncryptionReady);
    Bytes aPlain(SOCCER_BLOCK_SIZE), aOutput(SOCCER_BLOCK_SIZE, 0xA5U);
    XCTAssertFalse(Soccer3::EncryptBlock(aPlain.data(), aOutput.data()));
    XCTAssertTrue(std::all_of(aOutput.begin(), aOutput.end(), [](auto pByte) { return pByte == 0xA5U; }));
}

- (void)testOtherStrengthValuesBuildTheNormalSchedule {
    Cleanup aCleanup;
    Prepare(EncryptionStrength::kNormal);
    XCTAssertTrue(Soccer3::PrepareCryptexInputs());
    Bytes aPlain(SOCCER_BLOCK_SIZE, 0x5AU), aExpected(SOCCER_BLOCK_SIZE), aActual(SOCCER_BLOCK_SIZE);
    auto &aCryptex = Soccer3::mCryptex;
    XCTAssertTrue(aCryptex.Build(EncryptionStrength::kNormal));
    XCTAssertTrue(aCryptex.SealData(aPlain.data(), Soccer3::mCollapseLaneB, Soccer3::mCollapseLaneD,
                                  aExpected.data(), aPlain.size(), nullptr));
    for (auto aStrength : {EncryptionStrength::kTest, static_cast<EncryptionStrength>(255U)}) {
        XCTAssertTrue(aCryptex.Build(aStrength));
        XCTAssertEqual(aCryptex.GetStrength(), EncryptionStrength::kNormal);
        XCTAssertEqual(aCryptex.GetMaterialCount(), 8U);
        XCTAssertTrue(aCryptex.SealData(aPlain.data(), Soccer3::mCollapseLaneB, Soccer3::mCollapseLaneD,
                                      aActual.data(), aPlain.size(), nullptr));
        XCTAssertTrue(aActual == aExpected);
    }
    aCryptex.Clear(); aCryptex.Clear();
    XCTAssertFalse(aCryptex.IsBuilt());
    for (auto *aLayer : CryptexTestSupport::Layers(aCryptex)) XCTAssertEqual(aLayer->GetCipherCount(), 0U);
}

// Whole-block parity recovery now lives in WholeBlockParityRecoveryTests.mm.
- (void)testRealSeedRepeatsIndependentBlocksAndReconstructsCryptexForDecryption {
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
        Soccer3::Zero();
        std::uint32_t aAcknowledgement = 0U;
        if (!Soccer3::AttemptSeed_Encrypt(aStrength, aPassword.data(), aPassword.size(), kNonce, &aAcknowledgement, 0U, nullptr)) {
            XCTFail(@"vault seeding failed"); return;
        }
        XCTAssertTrue(Soccer3::mEncryptionReady);
        const auto aRotations = CryptexTestSupport::Rotations();
        const auto aSamples = CryptexTestSupport::SamplingRotations();
        const auto aMasks = CryptexTestSupport::Masks();
        const auto aPlane = Soccer3::mBitPlane;
        std::uint64_t aFreeWords[16];
        std::int32_t aFreeRotations[16];
        for (std::size_t aIndex = 0U; aIndex < 16U; ++aIndex) {
            aFreeWords[aIndex] = *SeedMaterialTestSupport::FreeRotationWords()[aIndex];
            aFreeRotations[aIndex] = *SeedMaterialTestSupport::FreeRotations()[aIndex];
        }
        const std::uint64_t aWords[] = {Soccer3::mBitPlaneWordA, Soccer3::mBitPlaneWordB, Soccer3::mBitPlaneWordC};
        XCTAssertTrue(aPlane.IsValid());
        XCTAssertTrue((aWords[0] | aWords[1] | aWords[2]) != 0U);
        XCTAssertEqual(Soccer3::mMaterialIndex, Budget(aStrength));
        XCTAssertTrue(Soccer3::EncryptBlock(aPlain.data(), aFirst.data()));
        XCTAssertTrue(Soccer3::EncryptBlock(aOther.data(), aSecond.data()));
        XCTAssertTrue(Soccer3::EncryptBlock(aPlain.data(), aRepeat.data()));
        XCTAssertTrue(aFirst == aRepeat && aFirst != aSecond);
        Soccer3::Zero();
        XCTAssertFalse(Soccer3::mEncryptionReady);
        // Decryption must reset its own accumulators, even without a clean start.
        Soccer3::mBitPlaneWordA = 999U;
        Soccer3::mBitPlaneWordB = 888U;
        Soccer3::mBitPlaneWordC = 777U;
        for (auto *aWord : SeedMaterialTestSupport::FreeRotationWords()) *aWord = 666U;
        for (auto *aRotation : SeedMaterialTestSupport::FreeRotations()) *aRotation = 555;
        if (!Soccer3::AttemptSeed_Decrypt(aStrength, aPassword.data(), aPassword.size(), kNonce, aAcknowledgement, 0U, nullptr)) {
            XCTFail(@"vault decrypt seeding failed"); return;
        }
        for (std::size_t aIndex = 0U; aIndex < 16U; ++aIndex) {
            XCTAssertEqual(*SeedMaterialTestSupport::FreeRotationWords()[aIndex], aFreeWords[aIndex]);
            XCTAssertEqual(*SeedMaterialTestSupport::FreeRotations()[aIndex], aFreeRotations[aIndex]);
        }
        XCTAssertTrue(CryptexTestSupport::Rotations() == aRotations);
        XCTAssertTrue(CryptexTestSupport::SamplingRotations() == aSamples);
        XCTAssertTrue(CryptexTestSupport::Masks() == aMasks);
        XCTAssertTrue(Soccer3::mBitPlane == aPlane);
        XCTAssertEqual(Soccer3::mBitPlaneWordA, aWords[0]);
        XCTAssertEqual(Soccer3::mBitPlaneWordB, aWords[1]);
        XCTAssertEqual(Soccer3::mBitPlaneWordC, aWords[2]);
        XCTAssertTrue(Soccer3::DecryptBlock(aSecond.data(), aRestored.data())); XCTAssertTrue(aRestored == aOther);
        XCTAssertTrue(Soccer3::DecryptBlock(aFirst.data(), aRestored.data())); XCTAssertTrue(aRestored == aPlain);
    }
}
@end
