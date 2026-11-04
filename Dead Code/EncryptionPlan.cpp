// Retired Cryptex plan, retained as source reference. The active vault uses
// EncryptionVaultPlan; the former lane-combination bank has been retired.
#if 0
//
//  EncryptionPlan.cpp
//  Scramble
//
//  Created by Icarus Black on 8/4/26.
//

#include "EncryptionPlan.hpp"
#include "LaneCombinations.hpp"

namespace {

template <std::size_t N>
CipherType RingFetchLane(const CipherType (&pShuffledMutate)[N],
                         std::uint32_t pLaneMask,
                         std::size_t *pIndex,
                         CipherType pDefault) {
    std::size_t aIndex = *pIndex % N;

    for (std::size_t aCount=0U; aCount<N; aCount++) {
        const CipherType aType = pShuffledMutate[aIndex];
        if (((static_cast<std::uint32_t>(aType) & pLaneMask) != 0U) &&
            IS_MUTATE(aType)) {
            *pIndex = (aIndex + 1U) % N;
            return aType;
        }

        aIndex++;
        if (aIndex == N) {
            aIndex = 0U;
        }
    }

    return pDefault;
}

} // namespace

EncryptionPlan EncryptionPlanTool::MakePlan(EncryptionStrength pStrength,
                                            std::uint64_t pLaneSelect,
                                            const CipherType (&pShuffledMutate)[32],
                                            const CipherType (&pShuffledPrimaryMovers)[32],
                                            const CipherType (&pShuffledSecondaryMovers)[32]) {
    if (pStrength == EncryptionStrength::kWeak) {
        return MakePlanWeak(pLaneSelect, pShuffledMutate, pShuffledPrimaryMovers, pShuffledSecondaryMovers);
    }
    if (pStrength == EncryptionStrength::kStrong) {
        return MakePlanStrong(pLaneSelect, pShuffledMutate, pShuffledPrimaryMovers, pShuffledSecondaryMovers);
    }
    return MakePlanNormal(pLaneSelect, pShuffledMutate, pShuffledPrimaryMovers, pShuffledSecondaryMovers);
}

bool EncryptionPlanTool::RotateMasksForPlan(const EncryptionPlan &pPlan,
                                           std::uint8_t *pMasks,
                                           std::size_t pMaskCount) {
    // Allocation order: L3A/B/C, L2A/B/C, L1A/B/C. Mask orientation
    // follows the level (0/3/6), restarting at L3 in each execution group.
    const EncryptionPlanStage *aStages[] = {&pPlan.mL3A, &pPlan.mL3B, &pPlan.mL3C,
        &pPlan.mL2A, &pPlan.mL2B, &pPlan.mL2C, &pPlan.mL1A, &pPlan.mL1B, &pPlan.mL1C};
    std::size_t aRequiredMasks = 0U;
    for (const auto *aStage : aStages) {
        if (aStage->mCount > sizeof(aStage->mType) / sizeof(aStage->mType[0])) { return false; }
        for (std::size_t aCipherIndex = 0U; aCipherIndex < aStage->mCount; ++aCipherIndex) {
            aRequiredMasks += IS_MASKED(aStage->mType[aCipherIndex]) &&
                !IsBitPlaneMaskBank(aStage->mSamplingBank[aCipherIndex]);
        }
    }
    if (aRequiredMasks > pMaskCount || (aRequiredMasks != 0U && pMasks == nullptr)) { return false; }

    std::size_t aMaskIndex = 0U;
    for (std::size_t aStageIndex = 0U; aStageIndex < 9U; ++aStageIndex) {
        const auto &aStage = *aStages[aStageIndex];
        const unsigned aRotation = static_cast<unsigned>(aStageIndex / 3U) * 3U;
        for (std::size_t aCipherIndex = 0U; aCipherIndex < aStage.mCount; ++aCipherIndex) {
            if (!IS_MASKED(aStage.mType[aCipherIndex]) ||
                IsBitPlaneMaskBank(aStage.mSamplingBank[aCipherIndex])) { continue; }
            const std::uint8_t aMask = pMasks[aMaskIndex];
            pMasks[aMaskIndex++] = static_cast<std::uint8_t>(
                (static_cast<unsigned>(aMask) << aRotation) | (static_cast<unsigned>(aMask) >> (8U - aRotation)));
        }
    }
    return true;
}

EncryptionPlan EncryptionPlanTool::MakePlanWeak(std::uint64_t pLaneSelect,
                                                const CipherType (&pShuffledMutate)[32],
                                                const CipherType (&pShuffledPrimaryMovers)[32],
                                                const CipherType (&pShuffledSecondaryMovers)[32]) {
    (void)pShuffledPrimaryMovers; (void)pShuffledSecondaryMovers;
    const auto aLanes = LaneCombinations::PickWeak(pLaneSelect);
    EncryptionPlan aResult{};
    std::size_t aMutateCursor = 0U;
    // L3A: row/mask offset 0; reset to the base masks for this group.
    aResult.mL3A.mCount = 6U;
    aResult.mL3A.mType[0] = CipherType::kFrogTwoCipherA;
    aResult.mL3A.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL3A.mType[1] = CipherType::kFrogThreeCipherB;
    aResult.mL3A.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL3A.mType[2] = CipherType::kFrogThreeCipherA;
    aResult.mL3A.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL3A.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL3[0], &aMutateCursor);
    aResult.mL3A.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL3A.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL3A.mRotationIndex[4] = 0U;
    aResult.mL3A.mType[5] = CipherType::kBitRotationThreeCipher;

    // L2A: row/mask offset 3; follow the preceding bit rotations.
    aResult.mL2A.mCount = 6U;
    aResult.mL2A.mType[0] = CipherType::kFrogThreeCipherB;
    aResult.mL2A.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL2A.mType[1] = CipherType::kFrogTwoCipherA;
    aResult.mL2A.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL2A.mType[2] = CipherType::kFrogThreeCipherB;
    aResult.mL2A.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL2A.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL2[0], &aMutateCursor);
    aResult.mL2A.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL2A.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL2A.mRotationIndex[4] = 0U;
    aResult.mL2A.mType[5] = CipherType::kBitRotationThreeCipher;

    // L1A: row/mask offset 6; follow the preceding bit rotations.
    aResult.mL1A.mCount = 6U;
    aResult.mL1A.mType[0] = CipherType::kFrogThreeCipherA;
    aResult.mL1A.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL1A.mType[1] = CipherType::kFrogThreeCipherB;
    aResult.mL1A.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL1A.mType[2] = CipherType::kFrogTwoCipherA;
    aResult.mL1A.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL1A.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL1[0], &aMutateCursor);
    aResult.mL1A.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL1A.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL1A.mRotationIndex[4] = 0U;
    aResult.mL1A.mType[5] = CipherType::kBitRotationThreeCipher;

    // L3B: row/mask offset 0; reset to the base masks for this group.
    aResult.mL3B.mCount = 6U;
    aResult.mL3B.mType[0] = CipherType::kFrogTwoCipherB;
    aResult.mL3B.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL3B.mType[1] = CipherType::kFrogThreeCipherA;
    aResult.mL3B.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL3B.mType[2] = CipherType::kFrogThreeCipherB;
    aResult.mL3B.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL3B.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL3[1], &aMutateCursor);
    aResult.mL3B.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL3B.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL3B.mRotationIndex[4] = 0U;
    aResult.mL3B.mType[5] = CipherType::kBitRotationThreeCipher;

    // L2B: row/mask offset 3; follow the preceding bit rotations.
    aResult.mL2B.mCount = 5U;
    aResult.mL2B.mType[0] = CipherType::kFrogThreeCipherA;
    aResult.mL2B.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL2B.mType[1] = CipherType::kFrogTwoCipherB;
    aResult.mL2B.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL2B.mType[2] = CipherType::kFrogThreeCipherA;
    aResult.mL2B.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL2B.mType[3] = CipherType::kRotateMaskCipher;
    aResult.mL2B.mSamplingBank[3] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL2B.mRotationIndex[3] = 0U;
    aResult.mL2B.mType[4] = CipherType::kBitRotationThreeCipher;

    // L1B: row/mask offset 6; follow the preceding bit rotations.
    aResult.mL1B.mCount = 5U;
    aResult.mL1B.mType[0] = CipherType::kFrogThreeCipherB;
    aResult.mL1B.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL1B.mType[1] = CipherType::kFrogThreeCipherA;
    aResult.mL1B.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL1B.mType[2] = CipherType::kFrogTwoCipherB;
    aResult.mL1B.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL1B.mType[3] = CipherType::kRotateMaskCipher;
    aResult.mL1B.mSamplingBank[3] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL1B.mRotationIndex[3] = 0U;
    aResult.mL1B.mType[4] = CipherType::kBitRotationThreeCipher;

    // L3C: row/mask offset 0; reset to the base masks for this group.
    aResult.mL3C.mCount = 5U;
    aResult.mL3C.mType[0] = CipherType::kFrogTwoCipherA;
    aResult.mL3C.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL3C.mType[1] = CipherType::kFrogThreeCipherB;
    aResult.mL3C.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL3C.mType[2] = CipherType::kFrogThreeCipherA;
    aResult.mL3C.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL3C.mType[3] = CipherType::kRotateMaskCipher;
    aResult.mL3C.mSamplingBank[3] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL3C.mRotationIndex[3] = 0U;
    aResult.mL3C.mType[4] = CipherType::kBitRotationThreeCipher;

    // L2C: row/mask offset 3; follow the preceding bit rotations.
    aResult.mL2C.mCount = 5U;
    aResult.mL2C.mType[0] = CipherType::kFrogThreeCipherB;
    aResult.mL2C.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL2C.mType[1] = CipherType::kFrogTwoCipherA;
    aResult.mL2C.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL2C.mType[2] = CipherType::kFrogThreeCipherB;
    aResult.mL2C.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL2C.mType[3] = CipherType::kRotateMaskCipher;
    aResult.mL2C.mSamplingBank[3] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL2C.mRotationIndex[3] = 0U;
    aResult.mL2C.mType[4] = CipherType::kBitRotationThreeCipher;

    // L1C: row/mask offset 6; follow the preceding bit rotations.
    // Final layer: omit the bit rotation.
    aResult.mL1C.mCount = 4U;
    aResult.mL1C.mType[0] = CipherType::kFrogThreeCipherA;
    aResult.mL1C.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL1C.mType[1] = CipherType::kFrogThreeCipherB;
    aResult.mL1C.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL1C.mType[2] = CipherType::kFrogTwoCipherA;
    aResult.mL1C.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL1C.mType[3] = CipherType::kRotateMaskCipher;
    aResult.mL1C.mSamplingBank[3] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL1C.mRotationIndex[3] = 0U;

    return aResult;
}

EncryptionPlan EncryptionPlanTool::MakePlanNormal(std::uint64_t pLaneSelect,
                                                const CipherType (&pShuffledMutate)[32],
                                                const CipherType (&pShuffledPrimaryMovers)[32],
                                                const CipherType (&pShuffledSecondaryMovers)[32]) {
    (void)pShuffledPrimaryMovers; (void)pShuffledSecondaryMovers;
    const auto aLanes = LaneCombinations::PickNormal(pLaneSelect);
    EncryptionPlan aResult{};
    std::size_t aMutateCursor = 0U;
    // L3A: row/mask offset 0; reset to the base masks for this group.
    aResult.mL3A.mCount = 6U;
    aResult.mL3A.mType[0] = CipherType::kFrogTwoCipherA;
    aResult.mL3A.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL3A.mType[1] = CipherType::kFrogThreeCipherB;
    aResult.mL3A.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL3A.mType[2] = CipherType::kFrogThreeCipherA;
    aResult.mL3A.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL3A.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL3[0], &aMutateCursor);
    aResult.mL3A.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL3A.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL3A.mRotationIndex[4] = 0U;
    aResult.mL3A.mType[5] = CipherType::kBitRotationThreeCipher;

    // L2A: row/mask offset 3; follow the preceding bit rotations.
    aResult.mL2A.mCount = 6U;
    aResult.mL2A.mType[0] = CipherType::kFrogThreeCipherB;
    aResult.mL2A.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL2A.mType[1] = CipherType::kFrogTwoCipherA;
    aResult.mL2A.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL2A.mType[2] = CipherType::kFrogThreeCipherB;
    aResult.mL2A.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL2A.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL2[0], &aMutateCursor);
    aResult.mL2A.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL2A.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL2A.mRotationIndex[4] = 0U;
    aResult.mL2A.mType[5] = CipherType::kBitRotationThreeCipher;

    // L1A: row/mask offset 6; follow the preceding bit rotations.
    aResult.mL1A.mCount = 6U;
    aResult.mL1A.mType[0] = CipherType::kFrogThreeCipherA;
    aResult.mL1A.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL1A.mType[1] = CipherType::kFrogThreeCipherB;
    aResult.mL1A.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL1A.mType[2] = CipherType::kFrogTwoCipherA;
    aResult.mL1A.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL1A.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL1[0], &aMutateCursor);
    aResult.mL1A.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL1A.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL1A.mRotationIndex[4] = 0U;
    aResult.mL1A.mType[5] = CipherType::kBitRotationThreeCipher;

    // L3B: row/mask offset 0; reset to the base masks for this group.
    aResult.mL3B.mCount = 6U;
    aResult.mL3B.mType[0] = CipherType::kFrogTwoCipherB;
    aResult.mL3B.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL3B.mType[1] = CipherType::kFrogThreeCipherA;
    aResult.mL3B.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL3B.mType[2] = CipherType::kFrogThreeCipherB;
    aResult.mL3B.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL3B.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL3[1], &aMutateCursor);
    aResult.mL3B.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL3B.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL3B.mRotationIndex[4] = 0U;
    aResult.mL3B.mType[5] = CipherType::kBitRotationThreeCipher;

    // L2B: row/mask offset 3; follow the preceding bit rotations.
    aResult.mL2B.mCount = 5U;
    aResult.mL2B.mType[0] = CipherType::kFrogThreeCipherA;
    aResult.mL2B.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL2B.mType[1] = CipherType::kFrogTwoCipherB;
    aResult.mL2B.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL2B.mType[2] = CipherType::kFrogThreeCipherA;
    aResult.mL2B.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL2B.mType[3] = CipherType::kRotateMaskCipher;
    aResult.mL2B.mSamplingBank[3] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL2B.mRotationIndex[3] = 0U;
    aResult.mL2B.mType[4] = CipherType::kBitRotationThreeCipher;

    // L1B: row/mask offset 6; follow the preceding bit rotations.
    aResult.mL1B.mCount = 5U;
    aResult.mL1B.mType[0] = CipherType::kFrogThreeCipherB;
    aResult.mL1B.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL1B.mType[1] = CipherType::kFrogThreeCipherA;
    aResult.mL1B.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL1B.mType[2] = CipherType::kFrogTwoCipherB;
    aResult.mL1B.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL1B.mType[3] = CipherType::kRotateMaskCipher;
    aResult.mL1B.mSamplingBank[3] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL1B.mRotationIndex[3] = 0U;
    aResult.mL1B.mType[4] = CipherType::kBitRotationThreeCipher;

    // L3C: row/mask offset 0; reset to the base masks for this group.
    aResult.mL3C.mCount = 6U;
    aResult.mL3C.mType[0] = CipherType::kFrogTwoCipherA;
    aResult.mL3C.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL3C.mType[1] = CipherType::kFrogThreeCipherB;
    aResult.mL3C.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL3C.mType[2] = CipherType::kFrogThreeCipherA;
    aResult.mL3C.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL3C.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL3[2], &aMutateCursor);
    aResult.mL3C.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL3C.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL3C.mRotationIndex[4] = 0U;
    aResult.mL3C.mType[5] = CipherType::kBitRotationThreeCipher;

    // L2C: row/mask offset 3; follow the preceding bit rotations.
    aResult.mL2C.mCount = 6U;
    aResult.mL2C.mType[0] = CipherType::kFrogThreeCipherB;
    aResult.mL2C.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL2C.mType[1] = CipherType::kFrogTwoCipherA;
    aResult.mL2C.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL2C.mType[2] = CipherType::kFrogThreeCipherB;
    aResult.mL2C.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL2C.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL2[1], &aMutateCursor);
    aResult.mL2C.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL2C.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL2C.mRotationIndex[4] = 0U;
    aResult.mL2C.mType[5] = CipherType::kBitRotationThreeCipher;

    // L1C: row/mask offset 6; follow the preceding bit rotations.
    // Final layer: omit the bit rotation.
    aResult.mL1C.mCount = 5U;
    aResult.mL1C.mType[0] = CipherType::kFrogThreeCipherA;
    aResult.mL1C.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL1C.mType[1] = CipherType::kFrogThreeCipherB;
    aResult.mL1C.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL1C.mType[2] = CipherType::kFrogTwoCipherA;
    aResult.mL1C.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL1C.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL1[1], &aMutateCursor);
    aResult.mL1C.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL1C.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL1C.mRotationIndex[4] = 0U;

    return aResult;
}

EncryptionPlan EncryptionPlanTool::MakePlanStrong(std::uint64_t pLaneSelect,
                                                const CipherType (&pShuffledMutate)[32],
                                                const CipherType (&pShuffledPrimaryMovers)[32],
                                                const CipherType (&pShuffledSecondaryMovers)[32]) {
    (void)pShuffledPrimaryMovers; (void)pShuffledSecondaryMovers;
    const auto aLanes = LaneCombinations::PickStrong(pLaneSelect);
    EncryptionPlan aResult{};
    std::size_t aMutateCursor = 0U;
    // L3A: row/mask offset 0; reset to the base masks for this group.
    aResult.mL3A.mCount = 7U;
    aResult.mL3A.mType[0] = CipherType::kFrogTwoCipherA;
    aResult.mL3A.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL3A.mType[1] = CipherType::kFrogThreeCipherB;
    aResult.mL3A.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL3A.mType[2] = CipherType::kFrogThreeCipherA;
    aResult.mL3A.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL3A.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL3[0], &aMutateCursor);
    aResult.mL3A.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL3A.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL3A.mRotationIndex[4] = 0U;
    aResult.mL3A.mType[5] = CipherType::kBitRotationThreeCipher;
    aResult.mL3A.mType[6] = RingFetchMutate(pShuffledMutate, aLanes.mL3[1], &aMutateCursor);

    // L2A: row/mask offset 3; follow the preceding bit rotations.
    aResult.mL2A.mCount = 7U;
    aResult.mL2A.mType[0] = CipherType::kFrogThreeCipherB;
    aResult.mL2A.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL2A.mType[1] = CipherType::kFrogTwoCipherA;
    aResult.mL2A.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL2A.mType[2] = CipherType::kFrogThreeCipherB;
    aResult.mL2A.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL2A.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL2[0], &aMutateCursor);
    aResult.mL2A.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL2A.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL2A.mRotationIndex[4] = 0U;
    aResult.mL2A.mType[5] = CipherType::kBitRotationThreeCipher;
    aResult.mL2A.mType[6] = RingFetchMutate(pShuffledMutate, aLanes.mL2[1], &aMutateCursor);

    // L1A: row/mask offset 6; follow the preceding bit rotations.
    aResult.mL1A.mCount = 7U;
    aResult.mL1A.mType[0] = CipherType::kFrogThreeCipherA;
    aResult.mL1A.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL1A.mType[1] = CipherType::kFrogThreeCipherB;
    aResult.mL1A.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL1A.mType[2] = CipherType::kFrogTwoCipherA;
    aResult.mL1A.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL1A.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL1[0], &aMutateCursor);
    aResult.mL1A.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL1A.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL1A.mRotationIndex[4] = 0U;
    aResult.mL1A.mType[5] = CipherType::kBitRotationThreeCipher;
    aResult.mL1A.mType[6] = RingFetchMutate(pShuffledMutate, aLanes.mL1[1], &aMutateCursor);

    // L3B: row/mask offset 0; reset to the base masks for this group.
    aResult.mL3B.mCount = 7U;
    aResult.mL3B.mType[0] = CipherType::kFrogTwoCipherB;
    aResult.mL3B.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL3B.mType[1] = CipherType::kFrogThreeCipherA;
    aResult.mL3B.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL3B.mType[2] = CipherType::kFrogThreeCipherB;
    aResult.mL3B.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL3B.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL3[2], &aMutateCursor);
    aResult.mL3B.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL3B.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL3B.mRotationIndex[4] = 0U;
    aResult.mL3B.mType[5] = CipherType::kBitRotationThreeCipher;
    aResult.mL3B.mType[6] = RingFetchMutate(pShuffledMutate, aLanes.mL3[3], &aMutateCursor);

    // L2B: row/mask offset 3; follow the preceding bit rotations.
    aResult.mL2B.mCount = 6U;
    aResult.mL2B.mType[0] = CipherType::kFrogThreeCipherA;
    aResult.mL2B.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL2B.mType[1] = CipherType::kFrogTwoCipherB;
    aResult.mL2B.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL2B.mType[2] = CipherType::kFrogThreeCipherA;
    aResult.mL2B.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL2B.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL2[2], &aMutateCursor);
    aResult.mL2B.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL2B.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL2B.mRotationIndex[4] = 0U;
    aResult.mL2B.mType[5] = CipherType::kBitRotationThreeCipher;

    // L1B: row/mask offset 6; follow the preceding bit rotations.
    aResult.mL1B.mCount = 6U;
    aResult.mL1B.mType[0] = CipherType::kFrogThreeCipherB;
    aResult.mL1B.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL1B.mType[1] = CipherType::kFrogThreeCipherA;
    aResult.mL1B.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL1B.mType[2] = CipherType::kFrogTwoCipherB;
    aResult.mL1B.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL1B.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL1[2], &aMutateCursor);
    aResult.mL1B.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL1B.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL1B.mRotationIndex[4] = 0U;
    aResult.mL1B.mType[5] = CipherType::kBitRotationThreeCipher;

    // L3C: row/mask offset 0; reset to the base masks for this group.
    aResult.mL3C.mCount = 7U;
    aResult.mL3C.mType[0] = CipherType::kFrogTwoCipherA;
    aResult.mL3C.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL3C.mType[1] = CipherType::kFrogThreeCipherB;
    aResult.mL3C.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL3C.mType[2] = CipherType::kFrogThreeCipherA;
    aResult.mL3C.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL3C.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL3[4], &aMutateCursor);
    aResult.mL3C.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL3C.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL3C.mRotationIndex[4] = 0U;
    aResult.mL3C.mType[5] = CipherType::kBitRotationThreeCipher;
    aResult.mL3C.mType[6] = RingFetchMutate(pShuffledMutate, aLanes.mL3[5], &aMutateCursor);

    // L2C: row/mask offset 3; follow the preceding bit rotations.
    aResult.mL2C.mCount = 6U;
    aResult.mL2C.mType[0] = CipherType::kFrogThreeCipherB;
    aResult.mL2C.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL2C.mType[1] = CipherType::kFrogTwoCipherA;
    aResult.mL2C.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL2C.mType[2] = CipherType::kFrogThreeCipherB;
    aResult.mL2C.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL2C.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL2[3], &aMutateCursor);
    aResult.mL2C.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL2C.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL2C.mRotationIndex[4] = 0U;
    aResult.mL2C.mType[5] = CipherType::kBitRotationThreeCipher;

    // L1C: row/mask offset 6; follow the preceding bit rotations.
    // Final layer: omit the bit rotation.
    aResult.mL1C.mCount = 5U;
    aResult.mL1C.mType[0] = CipherType::kFrogThreeCipherA;
    aResult.mL1C.mSamplingBank[0] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL1C.mType[1] = CipherType::kFrogThreeCipherB;
    aResult.mL1C.mSamplingBank[1] = CipherSamplingBank::kBitPlaneFirstB;
    aResult.mL1C.mType[2] = CipherType::kFrogTwoCipherA;
    aResult.mL1C.mSamplingBank[2] = CipherSamplingBank::kBitPlaneFirstC;
    aResult.mL1C.mType[3] = RingFetchMutate(pShuffledMutate, aLanes.mL1[3], &aMutateCursor);
    aResult.mL1C.mType[4] = CipherType::kRotateMaskCipher;
    aResult.mL1C.mSamplingBank[4] = CipherSamplingBank::kBitPlaneFirstA;
    aResult.mL1C.mRotationIndex[4] = 0U;

    return aResult;
}

CipherType EncryptionPlanTool::RingFetchMutate(const CipherType (&pShuffledMutate)[32],
                                                std::uint8_t pLaneCount,
                                                std::size_t *pIndex) {
    std::uint32_t aLaneMask = CIPHER_MASK_LANE_COUNT_1;
    CipherType aDefault = CipherType::kPasswordXORCipher;

    if (pLaneCount == 2U) {
        aLaneMask = CIPHER_MASK_LANE_COUNT_2;
        aDefault = CipherType::kPasswordJumpXORCipher;
    } else if (pLaneCount == 3U) {
        aLaneMask = CIPHER_MASK_LANE_COUNT_3;
        aDefault = CipherType::kPepperJumpNoiseXORCipher;
    } else if (pLaneCount == 4U) {
        aLaneMask = CIPHER_MASK_LANE_COUNT_4;
        aDefault = CipherType::kPepperDualJumpNoiseXORCipher;
    }

    return RingFetchLane(pShuffledMutate,
                         aLaneMask,
                         pIndex,
                         aDefault);
}

#endif // Historical Cryptex plan
