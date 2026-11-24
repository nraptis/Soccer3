#import <XCTest/XCTest.h>
#include "../Scramble/Composer/Soccer3.hpp"
#include "EightRotationValidator.hpp"
#include <algorithm>
#include <cstring>
#include <bit>
#include <vector>
#include "Kernel.hpp"
#include "FourToadKernel.hpp"
#include "PasswordXORKernel.hpp"
#include "BitReverseKernel.hpp"

namespace {
constexpr std::size_t kWindowCount = Soccer3::kRotationWindowCount;
constexpr std::size_t kListCount = Soccer3::kRotationListCount;
constexpr std::size_t kListSize = Soccer3::kRotationsPerList;

// Independent scalar reference for moving one masked set of bit planes.
// Keep this local to the test instead of using the Crow/Raven being checked.
// Forward: output[i] takes masked bits from input[(i - rotation) mod length].
// Inverse: read input[(i + rotation) mod length]. Other bits stay at position i.
class ReferenceMaskedShiftKernel final : public Kernel {
public:
    ReferenceMaskedShiftKernel(std::uint8_t pMask, std::size_t pRotation)
        : Kernel(KernelType::kNone), mMask(pMask), mRotation(pRotation) {}

    bool SealData(const std::uint8_t *pSource, std::uint8_t *,
                  std::uint8_t *pDestination, std::size_t pLength,
                  KernelErrorCode *pErrorCode) const override {
        return Apply(false, pSource, pDestination, pLength, pErrorCode);
    }

    bool UnsealData(const std::uint8_t *pSource, std::uint8_t *,
                    std::uint8_t *pDestination, std::size_t pLength,
                    KernelErrorCode *pErrorCode) const override {
        return Apply(true, pSource, pDestination, pLength, pErrorCode);
    }

private:
    bool Apply(bool pInverse, const std::uint8_t *pSource,
               std::uint8_t *pDestination, std::size_t pLength,
               KernelErrorCode *pErrorCode) const {
        if (pLength == 0U) {
            SetKernelErrorCode(pErrorCode, KernelErrorCode::kNone);
            return true;
        }
        if (pLength % 16U != 0U) {
            SetKernelErrorCode(pErrorCode, KernelErrorCode::kInvalidLength);
            return false;
        }
        if (!pSource || !pDestination) {
            SetKernelErrorCode(pErrorCode, KernelErrorCode::kNullBuffer);
            return false;
        }
        if (pSource == pDestination) {
            SetKernelErrorCode(pErrorCode, KernelErrorCode::kAliasedBuffer);
            return false;
        }

        const auto aRotation = mRotation % pLength;
        auto aSample = pInverse || aRotation == 0U ? aRotation : pLength - aRotation;
        const auto aKeepMask = static_cast<std::uint8_t>(~mMask);
        for (std::size_t i = 0U; i < pLength; ++i) {
            pDestination[i] = static_cast<std::uint8_t>(
                (pSource[i] & aKeepMask) | (pSource[aSample] & mMask));
            if (++aSample == pLength) aSample = 0U;
        }
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kNone);
        return true;
    }

    std::uint8_t mMask;
    std::size_t mRotation;
};

void SelectLists(const std::uint16_t *pBase, std::size_t pAvailable,
                 const std::uint64_t (&pWords)[kListSize],
                 std::uint16_t (&pChosen)[kListCount][kListSize]) {
    for (std::size_t aList = 0U; aList < kListCount; ++aList) {
        const bool aMasked = aList < 2U;
        Soccer3::SelectEightRotations(pBase, pAvailable, pChosen[aList],
                                     aMasked ? pWords : nullptr);
    }
}

bool ValidSelections(const std::uint16_t (&pChosen)[kListCount][kListSize],
                     const std::uint64_t (&pWords)[kListSize]) {
    bool aBlocked[kWindowCount] = {};
    aBlocked[0U] = true;
    aBlocked[kWindowCount / 2U] = true;
    for (std::size_t aList = 0U; aList < kListCount; ++aList) {
        const bool aMasked = aList < 2U;
        std::size_t aWindows[kListSize];
        std::uint32_t aBytes[kListSize] = {};
        for (std::size_t aIndex = 0U; aIndex < kListSize; ++aIndex) {
            const std::size_t aWindow = pChosen[aList][aIndex];
            if (aWindow >= kWindowCount || aBlocked[aWindow]) return false;
            aBlocked[aWindow] = true;
            aBlocked[kWindowCount - aWindow] = true;
            aWindows[aIndex] = aWindow;
            if (aMasked) {
                aBlocked[kWindowCount - 1U - aWindow] = true;
                const auto aWord = pWords[aIndex];
                // Independent byte conversion, not the production helper.
                const auto aOffset = 1U + 2U * (aWord % 32U);
                aBytes[aIndex] = static_cast<std::uint32_t>(64U * aWindow + aOffset);
            }
        }
        if (!EightRotationValidator::Valid(aWindows, kListSize)) return false;
        if (aMasked) {
            std::uint32_t aSums[256U] = {};
            for (std::size_t aSubset = 0U; aSubset < 256U; ++aSubset) {
                for (std::size_t aIndex = 0U; aIndex < kListSize; ++aIndex)
                    if (aSubset & (1U << aIndex)) aSums[aSubset] += aBytes[aIndex];
                aSums[aSubset] %= SOCCER_BLOCK_SIZE;
                for (std::size_t aPrevious = 0U; aPrevious < aSubset; ++aPrevious)
                    if (aSums[aSubset] == aSums[aPrevious]) return false;
            }
        }
    }
    return true;
}
} // namespace

@interface Soccer3RotationSelectionTests : XCTestCase
@end

@implementation Soccer3RotationSelectionTests

- (void)tearDown {
    Soccer3::Zero();
    [super tearDown];
}

- (void)test_ExhaustedPrefixUsesTailAndReplays {
    std::uint16_t aBase[kWindowCount];
    for (std::size_t aIndex = 0U; aIndex < kWindowCount; ++aIndex) aBase[aIndex] = aIndex;
    std::swap(aBase[1U], aBase[kWindowCount / 2U]);
    const std::uint64_t aWords[kListSize] = {61U, 62U, 63U, 64U, UINT64_MAX, 0U, 31U, 32U};
    std::uint16_t aFirst[kListCount][kListSize], aSecond[kListCount][kListSize];
    Soccer3::Zero();
    SelectLists(aBase, 2U, aWords, aFirst);
    XCTAssertTrue(ValidSelections(aFirst, aWords));
    XCTAssertGreaterThan(Soccer3::mRotationFallbackCandidatesRead, std::size_t{0U});
    XCTAssertLessThanOrEqual(Soccer3::mRotationCandidatesRead, kWindowCount * kListCount);
    Soccer3::Zero();
    SelectLists(aBase, 2U, aWords, aSecond);
    XCTAssertEqual(std::memcmp(aFirst, aSecond, sizeof(aFirst)), 0);
}

- (void)test_MissingAndMalformedListsUseNumericCandidates {
    std::uint16_t aBase[kWindowCount];
    const std::uint64_t aWords[kListSize] = {};
    std::uint16_t aChosen[kListCount][kListSize];
    for (std::size_t aCase = 0U; aCase < 3U; ++aCase) {
        Soccer3::Zero();
        std::fill_n(aBase, kWindowCount, aCase == 2U ? UINT16_MAX : 0U);
        SelectLists(aCase == 0U ? nullptr : aBase, kWindowCount + 100U, aWords, aChosen);
        XCTAssertTrue(ValidSelections(aChosen, aWords), "Numeric fallback case %zu", aCase);
        XCTAssertGreaterThan(Soccer3::mRotationFallbackCandidatesRead, std::size_t{0U});
    }
}

- (void)test_TailFallbackRejectsActualByteCarryCollision {
    Soccer3::Zero();
    std::uint16_t aBase[kWindowCount];
    for (std::size_t aIndex = 0U; aIndex < kWindowCount; ++aIndex) aBase[aIndex] = aIndex;
    std::swap(aBase[0U], aBase[1U]);
    std::swap(aBase[1U], aBase[2U]);
    std::swap(aBase[kWindowCount - 1U], aBase[4U]);
    std::swap(aBase[kWindowCount - 2U], aBase[9U]);
    std::swap(aBase[kWindowCount - 3U], aBase[16U]);
    const std::uint64_t aWords[kListSize] = {31U, 31U, 1U, 0U};
    std::uint16_t aChosen[kListCount][kListSize];
    SelectLists(aBase, 2U, aWords, aChosen);
    // Windows 1 + 2 + 4 differ from 9, but byte shifts 127 + 191 + 259 equal 577 (64*9+1).
    // The fourth selection must skip window 9 and use 16 from the tail.
    XCTAssertEqual(aChosen[0U][0U], 1U);
    XCTAssertEqual(aChosen[0U][1U], 2U);
    XCTAssertEqual(aChosen[0U][2U], 4U);
    XCTAssertEqual(aChosen[0U][3U], 16U);
    XCTAssertTrue(ValidSelections(aChosen, aWords));
}

- (void)test_ValidationRejectsChangedCipherInputs {
    std::uint8_t aPassword[] = "FlatRows";
    std::uint32_t aAck = 0U;
    if (!Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kWeak, aPassword, 8U,
                                     0x19F07D3E89442160ULL, &aAck, 0U, nullptr)) {
        XCTFail("Seed failed before validation checks");
        return;
    }
    XCTAssertTrue(Soccer3::ValidateCryptexInputs(EncryptionStrength::kWeak));
    const auto aWindow = Soccer3::mToadCipherRotationAALeftA;
    Soccer3::mToadCipherRotationAALeftA = Soccer3::mToadCipherRotationAARightA;
    XCTAssertFalse(Soccer3::ValidateCryptexInputs(EncryptionStrength::kWeak));
    Soccer3::mToadCipherRotationAALeftA = aWindow;
    // The first and last layers belong to the same active shift pool.
    const auto aLast = Soccer3::mPlaneShiftBDLeft.mRotation;
    Soccer3::mPlaneShiftBDLeft.mRotation = Soccer3::mPlaneShiftAALeft.mRotation;
    XCTAssertFalse(Soccer3::ValidateCryptexInputs(EncryptionStrength::kWeak));
    Soccer3::mPlaneShiftBDLeft.mRotation = aLast & ~1;
    XCTAssertFalse(Soccer3::ValidateCryptexInputs(EncryptionStrength::kWeak));
    Soccer3::mPlaneShiftBDLeft.mRotation = aLast;
    XCTAssertTrue(Soccer3::ValidateCryptexInputs(EncryptionStrength::kWeak));
    const auto aRight = Soccer3::mPlaneShiftBDRight;
    Soccer3::mPlaneShiftBDRight.mRotation = Soccer3::mPlaneShiftAARight.mRotation;
    XCTAssertFalse(Soccer3::ValidateCryptexInputs(EncryptionStrength::kWeak));
    Soccer3::mPlaneShiftBDRight = aRight;
    Soccer3::mPlaneShiftBDRight.mMask = Soccer3::mPlaneShiftBDLeft.mMask;
    XCTAssertFalse(Soccer3::ValidateCryptexInputs(EncryptionStrength::kWeak));
    Soccer3::mPlaneShiftBDRight = aRight;
    XCTAssertTrue(Soccer3::ValidateCryptexInputs(EncryptionStrength::kWeak));
}

- (void)test_CorvidScheduleAndReferenceAtEveryStrength {
    std::uint8_t aPassword[] = "PoolRows";
    std::uint32_t aAck = 0U;
    // Strong prepares all sixteen materials, enough to inspect any of the three schedules.
    if (!Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kStrong, aPassword, 8U,
                                     0x21CE739A16BBD581ULL, &aAck, 0U, nullptr)) {
        XCTFail("Strong seed failed");
        return;
    }
    const Soccer3::PlaneShift aShifts[8][2] = {
        {Soccer3::mPlaneShiftAALeft, Soccer3::mPlaneShiftAARight},
        {Soccer3::mPlaneShiftABLeft, Soccer3::mPlaneShiftABRight},
        {Soccer3::mPlaneShiftACLeft, Soccer3::mPlaneShiftACRight},
        {Soccer3::mPlaneShiftADLeft, Soccer3::mPlaneShiftADRight},
        {Soccer3::mPlaneShiftBALeft, Soccer3::mPlaneShiftBARight},
        {Soccer3::mPlaneShiftBBLeft, Soccer3::mPlaneShiftBBRight},
        {Soccer3::mPlaneShiftBCLeft, Soccer3::mPlaneShiftBCRight},
        {Soccer3::mPlaneShiftBDLeft, Soccer3::mPlaneShiftBDRight},
    };
    unsigned aUses[8]{};
    bool aSeenMasks[256]{};
    const auto aRow = Soccer3::mBitPlane.GetRow(0U);
    std::uint8_t aRows[8];
    for (std::size_t aPair = 0U; aPair < 4U; ++aPair) {
        aRows[2U * aPair] = aRow.mPairs[aPair].mBitA;
        aRows[2U * aPair + 1U] = aRow.mPairs[aPair].mBitB;
    }
    const char *aPairs[8] = {"aceg", "bdfh", "aecg", "bfdh", "adeh", "bcfg", "afch", "bedg"};
    for (std::size_t aLayer = 0U; aLayer < 8U; ++aLayer) {
        XCTAssertEqual(aShifts[aLayer][0].mMask & aShifts[aLayer][1].mMask, 0U);
        for (std::size_t aSide = 0U; aSide < 2U; ++aSide) {
            const auto aMask = aShifts[aLayer][aSide].mMask;
            const auto aExpectedMask = (1U << aRows[aPairs[aLayer][2U * aSide] - 'a']) |
                (1U << aRows[aPairs[aLayer][2U * aSide + 1U] - 'a']);
            XCTAssertEqual(aMask, aExpectedMask);
            XCTAssertEqual(std::popcount(aMask), 2);
            XCTAssertFalse(aSeenMasks[aMask]);
            aSeenMasks[aMask] = true;
            for (unsigned aBit = 0U; aBit < 8U; ++aBit) aUses[aBit] += (aMask >> aBit) & 1U;
            const auto aWindow = aSide == 0U ? Soccer3::mShiftMaskedRotationListChosenA[aLayer]
                                            : Soccer3::mShiftMaskedRotationListChosenB[aLayer];
            XCTAssertEqual(aShifts[aLayer][aSide].mRotation / 64U, aWindow);
        }
        if (aLayer % 2U == 1U) {
            XCTAssertEqual(aShifts[aLayer - 1U][0].mMask | aShifts[aLayer - 1U][1].mMask |
                           aShifts[aLayer][0].mMask | aShifts[aLayer][1].mMask, 0xFFU);
        }
    }
    for (auto aCount : aUses) XCTAssertEqual(aCount, 4U);
    const std::uint16_t *aWindows[8][2] = {
        {Soccer3::mFlameToadRotationListChosenAALeft, Soccer3::mFlameToadRotationListChosenAARight},
        {Soccer3::mFlameToadRotationListChosenABLeft, Soccer3::mFlameToadRotationListChosenABRight},
        {Soccer3::mFlameToadRotationListChosenACLeft, Soccer3::mFlameToadRotationListChosenACRight},
        {Soccer3::mFlameToadRotationListChosenADLeft, Soccer3::mFlameToadRotationListChosenADRight},
        {Soccer3::mFlameToadRotationListChosenBALeft, Soccer3::mFlameToadRotationListChosenBARight},
        {Soccer3::mFlameToadRotationListChosenBBLeft, Soccer3::mFlameToadRotationListChosenBBRight},
        {Soccer3::mFlameToadRotationListChosenBCLeft, Soccer3::mFlameToadRotationListChosenBCRight},
        {Soccer3::mFlameToadRotationListChosenBDLeft, Soccer3::mFlameToadRotationListChosenBDRight},
    };
    const std::uint8_t *aMaterials[] = {
        Soccer3::mMutateMaterialA, Soccer3::mMutateMaterialB, Soccer3::mMutateMaterialC, Soccer3::mMutateMaterialD,
        Soccer3::mMutateMaterialE, Soccer3::mMutateMaterialF, Soccer3::mMutateMaterialG, Soccer3::mMutateMaterialH,
        Soccer3::mMutateMaterialI, Soccer3::mMutateMaterialJ, Soccer3::mMutateMaterialK, Soccer3::mMutateMaterialL,
        Soccer3::mMutateMaterialM, Soccer3::mMutateMaterialN, Soccer3::mMutateMaterialO, Soccer3::mMutateMaterialP,
    };
    std::vector<std::uint8_t> aSource(SOCCER_BLOCK_SIZE), aOutput(SOCCER_BLOCK_SIZE);
    std::vector<std::uint8_t> aExpected(SOCCER_BLOCK_SIZE), aRestored(SOCCER_BLOCK_SIZE);
    std::vector<std::uint8_t> aWorkerA(SOCCER_BLOCK_SIZE), aWorkerB(SOCCER_BLOCK_SIZE);
    for (std::size_t aIndex = 0U; aIndex < aSource.size(); ++aIndex)
        aSource[aIndex] = static_cast<std::uint8_t>((aIndex * 197U) ^ (aIndex >> 8U) ^ (aIndex >> 17U));
    for (const auto aStrength : {EncryptionStrength::kWeak, EncryptionStrength::kNormal, EncryptionStrength::kStrong}) {
        Cryptex aPlan, aReference;
        XCTAssertTrue(aPlan.Build(aStrength));
        const CryptexLayer *aLayers[] = {&aPlan.mLayerAA, &aPlan.mLayerAB, &aPlan.mLayerAC, &aPlan.mLayerAD,
                                       &aPlan.mLayerBA, &aPlan.mLayerBB, &aPlan.mLayerBC, &aPlan.mLayerBD};
        CryptexLayer *aReferenceLayers[] = {&aReference.mLayerAA, &aReference.mLayerAB, &aReference.mLayerAC, &aReference.mLayerAD,
                                          &aReference.mLayerBA, &aReference.mLayerBB, &aReference.mLayerBC, &aReference.mLayerBD};
        const bool aStrong = aStrength == EncryptionStrength::kStrong;
        const bool aWeak = aStrength == EncryptionStrength::kWeak;
        std::size_t aMaterial = 0U;
        for (std::size_t aLayerIndex = 0U; aLayerIndex < Cryptex::kLayerCount; ++aLayerIndex) {
            const auto &aLayer = *aLayers[aLayerIndex];
            auto &aReferenceLayer = *aReferenceLayers[aLayerIndex];
            std::size_t aCipherIndex = 0U;
            if (aStrong) {
                XCTAssertTrue(aLayer.GetKernelType(aCipherIndex++) == KernelType::kPasswordXORKernel);
                aReferenceLayer.Add(new PasswordXORKernel(aMaterials[aMaterial++]));
            }
            XCTAssertTrue(aLayer.GetKernelType(aCipherIndex++) == KernelType::kFourToadKernel);
            const auto aToadRow = Soccer3::mBitPlane.GetRow(aLayerIndex % 4U);
            FourToadKernel::Stage aStages[4];
            for (std::size_t aStage = 0U; aStage < 4U; ++aStage) {
                aStages[aStage].mRowA = aToadRow.mPairs[aStage].mBitA;
                aStages[aStage].mRowB = aToadRow.mPairs[aStage].mBitB;
                const auto *aRotation = aWindows[aLayerIndex][aStage / 2U] + 4U * (aStage % 2U);
                std::copy_n(aRotation, 4U, aStages[aStage].mWindowRotations.begin());
            }
            aReferenceLayer.Add(new FourToadKernel(aStages[0], aStages[1], aStages[2], aStages[3],
                {Soccer3::mPackedRows, Soccer3::mPackedRowLength}));
            for (const auto aShift : aShifts[aLayerIndex])
                aReferenceLayer.Add(new ReferenceMaskedShiftKernel(aShift.mMask, aShift.mRotation));
            const bool aMutate = !aWeak || aLayerIndex % 2U == 1U;
            XCTAssertTrue(aLayer.GetKernelType(aCipherIndex++) == (aMutate ? KernelType::kFourRavenKernel : KernelType::kFourCrowKernel));
            if (aMutate) aReferenceLayer.Add(new PasswordXORKernel(aMaterials[aMaterial++]));
            if (aLayerIndex == 3U) {
                XCTAssertTrue(aLayer.GetKernelType(aCipherIndex++) == KernelType::kBitReverseKernel);
                aReferenceLayer.Add(new BitReverseKernel{});
            }
            XCTAssertEqual(aLayer.GetKernelCount(), aCipherIndex);
        }
        XCTAssertEqual(aPlan.GetMaterialCount(), aMaterial);
        XCTAssertEqual(aMaterial, aWeak ? 4U : aStrong ? 16U : 8U);
        XCTAssertTrue(aPlan.SealData(aSource.data(), aWorkerA.data(), aWorkerB.data(), aOutput.data(), aSource.size(), nullptr));
        XCTAssertTrue(aReference.SealData(aSource.data(), aWorkerA.data(), aWorkerB.data(), aExpected.data(), aSource.size(), nullptr));
        XCTAssertTrue(aOutput == aExpected, @"strength=%u reference ciphertext", unsigned(aStrength));
        XCTAssertTrue(aPlan.UnsealData(aExpected.data(), aWorkerA.data(), aWorkerB.data(), aRestored.data(), aSource.size(), nullptr));
        XCTAssertTrue(aRestored == aSource, @"strength=%u reference inverse", unsigned(aStrength));
    }
}
@end
