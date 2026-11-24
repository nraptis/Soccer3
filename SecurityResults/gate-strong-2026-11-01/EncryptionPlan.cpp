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

EncryptionPlan EncryptionPlanTool::MakePlanWeak(std::uint64_t pLaneSelect,
                                                const CipherType (&pShuffledMutate)[32],
                                                const CipherType (&pShuffledPrimaryMovers)[32],
                                                const CipherType (&pShuffledSecondaryMovers)[32]) {
    EncryptionPlan aResult{};
    const WeakLaneCombination aLaneCombination = LaneCombinations::PickWeak(pLaneSelect);
    std::size_t aMutateCursor = 0U;

    // L3A: Gate -> mutate -> rotate -> primary -> Gate
    aResult.mL3A.mCount = 5U;
    aResult.mL3A.mType[0] = CipherType::kGateCipher;
    aResult.mL3A.mType[1] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[0], &aMutateCursor);
    aResult.mL3A.mType[2] = CipherType::kRotateCipher;
    aResult.mL3A.mType[3] = pShuffledPrimaryMovers[0];
    aResult.mL3A.mType[4] = CipherType::kGateCipher;

    // L2A: Gate -> rotate -> primary -> mutate -> Gate
    aResult.mL2A.mCount = 5U;
    aResult.mL2A.mType[0] = CipherType::kGateCipher;
    aResult.mL2A.mType[1] = CipherType::kRotateCipher;
    aResult.mL2A.mType[2] = pShuffledPrimaryMovers[1];
    aResult.mL2A.mType[3] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL2[0], &aMutateCursor);
    aResult.mL2A.mType[4] = CipherType::kGateCipher;

    // L1A: Gate -> mutate -> rotate -> secondary -> Gate
    aResult.mL1A.mCount = 5U;
    aResult.mL1A.mType[0] = CipherType::kGateCipher;
    aResult.mL1A.mType[1] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL1[0], &aMutateCursor);
    aResult.mL1A.mType[2] = CipherType::kRotateCipher;
    aResult.mL1A.mType[3] = pShuffledSecondaryMovers[0];
    aResult.mL1A.mType[4] = CipherType::kGateCipher;

    // L3B: Gate -> primary -> rotate -> mutate -> Gate
    aResult.mL3B.mCount = 5U;
    aResult.mL3B.mType[0] = CipherType::kGateCipher;
    aResult.mL3B.mType[1] = pShuffledPrimaryMovers[2];
    aResult.mL3B.mType[2] = CipherType::kRotateCipher;
    aResult.mL3B.mType[3] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[1], &aMutateCursor);
    aResult.mL3B.mType[4] = CipherType::kGateCipher;

    // L2B: Gate -> rotate -> primary -> Gate
    aResult.mL2B.mCount = 4U;
    aResult.mL2B.mType[0] = CipherType::kGateCipher;
    aResult.mL2B.mType[1] = CipherType::kRotateCipher;
    aResult.mL2B.mType[2] = pShuffledPrimaryMovers[3];
    aResult.mL2B.mType[3] = CipherType::kGateCipher;

    // L1B: Gate -> secondary -> rotate -> Gate
    aResult.mL1B.mCount = 4U;
    aResult.mL1B.mType[0] = CipherType::kGateCipher;
    aResult.mL1B.mType[1] = pShuffledSecondaryMovers[1];
    aResult.mL1B.mType[2] = CipherType::kRotateCipher;
    aResult.mL1B.mType[3] = CipherType::kGateCipher;

    // L3C: Gate -> rotate -> primary -> Gate
    aResult.mL3C.mCount = 4U;
    aResult.mL3C.mType[0] = CipherType::kGateCipher;
    aResult.mL3C.mType[1] = CipherType::kRotateCipher;
    aResult.mL3C.mType[2] = pShuffledPrimaryMovers[4];
    aResult.mL3C.mType[3] = CipherType::kGateCipher;

    // L2C: Gate -> primary -> rotate -> Gate
    aResult.mL2C.mCount = 4U;
    aResult.mL2C.mType[0] = CipherType::kGateCipher;
    aResult.mL2C.mType[1] = pShuffledPrimaryMovers[5];
    aResult.mL2C.mType[2] = CipherType::kRotateCipher;
    aResult.mL2C.mType[3] = CipherType::kGateCipher;

    // L1C: Gate -> rotate -> secondary -> Gate
    aResult.mL1C.mCount = 4U;
    aResult.mL1C.mType[0] = CipherType::kGateCipher;
    aResult.mL1C.mType[1] = CipherType::kRotateCipher;
    aResult.mL1C.mType[2] = pShuffledSecondaryMovers[2];
    aResult.mL1C.mType[3] = CipherType::kGateCipher;

    return aResult;
}

EncryptionPlan EncryptionPlanTool::MakePlanNormal(std::uint64_t pLaneSelect,
                                                const CipherType (&pShuffledMutate)[32],
                                                const CipherType (&pShuffledPrimaryMovers)[32],
                                                const CipherType (&pShuffledSecondaryMovers)[32]) {
    EncryptionPlan aResult{};
    const NormalLaneCombination aLaneCombination = LaneCombinations::PickNormal(pLaneSelect);
    std::size_t aMutateCursor = 0U;

    // L3A: Gate -> mutate -> rotate -> primary -> Gate
    aResult.mL3A.mCount = 5U;
    aResult.mL3A.mType[0] = CipherType::kGateCipher;
    aResult.mL3A.mType[1] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[0], &aMutateCursor);
    aResult.mL3A.mType[2] = CipherType::kRotateCipher;
    aResult.mL3A.mType[3] = pShuffledPrimaryMovers[0];
    aResult.mL3A.mType[4] = CipherType::kGateCipher;

    // L2A: Gate -> rotate -> primary -> mutate -> Gate
    aResult.mL2A.mCount = 5U;
    aResult.mL2A.mType[0] = CipherType::kGateCipher;
    aResult.mL2A.mType[1] = CipherType::kRotateCipher;
    aResult.mL2A.mType[2] = pShuffledPrimaryMovers[1];
    aResult.mL2A.mType[3] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL2[0], &aMutateCursor);
    aResult.mL2A.mType[4] = CipherType::kGateCipher;

    // L1A: Gate -> mutate -> rotate -> secondary -> Gate
    aResult.mL1A.mCount = 5U;
    aResult.mL1A.mType[0] = CipherType::kGateCipher;
    aResult.mL1A.mType[1] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL1[0], &aMutateCursor);
    aResult.mL1A.mType[2] = CipherType::kRotateCipher;
    aResult.mL1A.mType[3] = pShuffledSecondaryMovers[0];
    aResult.mL1A.mType[4] = CipherType::kGateCipher;

    // L3B: Gate -> primary -> rotate -> mutate -> Gate
    aResult.mL3B.mCount = 5U;
    aResult.mL3B.mType[0] = CipherType::kGateCipher;
    aResult.mL3B.mType[1] = pShuffledPrimaryMovers[2];
    aResult.mL3B.mType[2] = CipherType::kRotateCipher;
    aResult.mL3B.mType[3] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[1], &aMutateCursor);
    aResult.mL3B.mType[4] = CipherType::kGateCipher;

    // L2B: Gate -> rotate -> primary -> Gate
    aResult.mL2B.mCount = 4U;
    aResult.mL2B.mType[0] = CipherType::kGateCipher;
    aResult.mL2B.mType[1] = CipherType::kRotateCipher;
    aResult.mL2B.mType[2] = pShuffledPrimaryMovers[3];
    aResult.mL2B.mType[3] = CipherType::kGateCipher;

    // L1B: Gate -> secondary -> rotate -> Gate
    aResult.mL1B.mCount = 4U;
    aResult.mL1B.mType[0] = CipherType::kGateCipher;
    aResult.mL1B.mType[1] = pShuffledSecondaryMovers[1];
    aResult.mL1B.mType[2] = CipherType::kRotateCipher;
    aResult.mL1B.mType[3] = CipherType::kGateCipher;

    // L3C: Gate -> primary -> rotate -> mutate -> primary -> Gate
    aResult.mL3C.mCount = 6U;
    aResult.mL3C.mType[0] = CipherType::kGateCipher;
    aResult.mL3C.mType[1] = pShuffledPrimaryMovers[4];
    aResult.mL3C.mType[2] = CipherType::kRotateCipher;
    aResult.mL3C.mType[3] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[2], &aMutateCursor);
    aResult.mL3C.mType[4] = pShuffledPrimaryMovers[5];
    aResult.mL3C.mType[5] = CipherType::kGateCipher;

    // L2C: Gate -> primary -> rotate -> mutate -> secondary -> Gate
    aResult.mL2C.mCount = 6U;
    aResult.mL2C.mType[0] = CipherType::kGateCipher;
    aResult.mL2C.mType[1] = pShuffledPrimaryMovers[6];
    aResult.mL2C.mType[2] = CipherType::kRotateCipher;
    aResult.mL2C.mType[3] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL2[1], &aMutateCursor);
    aResult.mL2C.mType[4] = pShuffledSecondaryMovers[2];
    aResult.mL2C.mType[5] = CipherType::kGateCipher;

    // L1C: Gate -> secondary -> rotate -> mutate -> secondary -> Gate
    aResult.mL1C.mCount = 6U;
    aResult.mL1C.mType[0] = CipherType::kGateCipher;
    aResult.mL1C.mType[1] = pShuffledSecondaryMovers[3];
    aResult.mL1C.mType[2] = CipherType::kRotateCipher;
    aResult.mL1C.mType[3] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL1[1], &aMutateCursor);
    aResult.mL1C.mType[4] = pShuffledSecondaryMovers[4];
    aResult.mL1C.mType[5] = CipherType::kGateCipher;

    return aResult;
}

EncryptionPlan EncryptionPlanTool::MakePlanStrong(std::uint64_t pLaneSelect,
                                                  const CipherType (&pShuffledMutate)[32],
                                                  const CipherType (&pShuffledPrimaryMovers)[32],
                                                  const CipherType (&pShuffledSecondaryMovers)[32]) {
    EncryptionPlan aResult{};
    const StrongLaneCombination aLaneCombination = LaneCombinations::PickStrong(pLaneSelect);
    std::size_t aMutateCursor = 0U;

    // L3A: rotate-mask -> Gate -> mutate -> primary -> mutate -> Gate
    aResult.mL3A.mCount = 6U;
    aResult.mL3A.mType[0] = CipherType::kRotateMaskCipher;
    aResult.mL3A.mType[1] = CipherType::kGateCipher;
    aResult.mL3A.mType[2] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[0], &aMutateCursor);
    aResult.mL3A.mType[3] = pShuffledPrimaryMovers[0];
    aResult.mL3A.mType[4] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[1], &aMutateCursor);
    aResult.mL3A.mType[5] = CipherType::kGateCipher;

    // L2A: rotate-mask -> Gate -> primary -> mutate -> mutate -> Gate
    aResult.mL2A.mCount = 6U;
    aResult.mL2A.mType[0] = CipherType::kRotateMaskCipher;
    aResult.mL2A.mType[1] = CipherType::kGateCipher;
    aResult.mL2A.mType[2] = pShuffledPrimaryMovers[1];
    aResult.mL2A.mType[3] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL2[0], &aMutateCursor);
    aResult.mL2A.mType[4] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL2[1], &aMutateCursor);
    aResult.mL2A.mType[5] = CipherType::kGateCipher;

    // L1A: rotate-mask -> Gate -> mutate -> primary -> mutate -> Gate
    aResult.mL1A.mCount = 6U;
    aResult.mL1A.mType[0] = CipherType::kRotateMaskCipher;
    aResult.mL1A.mType[1] = CipherType::kGateCipher;
    aResult.mL1A.mType[2] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL1[0], &aMutateCursor);
    aResult.mL1A.mType[3] = pShuffledPrimaryMovers[2];
    aResult.mL1A.mType[4] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL1[1], &aMutateCursor);
    aResult.mL1A.mType[5] = CipherType::kGateCipher;

    // L3B: rotate-mask -> Gate -> primary -> mutate -> mutate -> Gate
    aResult.mL3B.mCount = 6U;
    aResult.mL3B.mType[0] = CipherType::kRotateMaskCipher;
    aResult.mL3B.mType[1] = CipherType::kGateCipher;
    aResult.mL3B.mType[2] = pShuffledPrimaryMovers[3];
    aResult.mL3B.mType[3] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[2], &aMutateCursor);
    aResult.mL3B.mType[4] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[3], &aMutateCursor);
    aResult.mL3B.mType[5] = CipherType::kGateCipher;

    // L2B: rotate -> Gate -> mutate -> primary -> Gate
    aResult.mL2B.mCount = 5U;
    aResult.mL2B.mType[0] = CipherType::kRotateCipher;
    aResult.mL2B.mType[1] = CipherType::kGateCipher;
    aResult.mL2B.mType[2] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL2[2], &aMutateCursor);
    aResult.mL2B.mType[3] = pShuffledPrimaryMovers[4];
    aResult.mL2B.mType[4] = CipherType::kGateCipher;

    // L1B: rotate -> Gate -> primary -> mutate -> Gate
    aResult.mL1B.mCount = 5U;
    aResult.mL1B.mType[0] = CipherType::kRotateCipher;
    aResult.mL1B.mType[1] = CipherType::kGateCipher;
    aResult.mL1B.mType[2] = pShuffledPrimaryMovers[5];
    aResult.mL1B.mType[3] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL1[2], &aMutateCursor);
    aResult.mL1B.mType[4] = CipherType::kGateCipher;

    // L3C: rotate -> Gate -> mutate -> primary -> mutate -> Gate
    aResult.mL3C.mCount = 6U;
    aResult.mL3C.mType[0] = CipherType::kRotateCipher;
    aResult.mL3C.mType[1] = CipherType::kGateCipher;
    aResult.mL3C.mType[2] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[4], &aMutateCursor);
    aResult.mL3C.mType[3] = pShuffledPrimaryMovers[6];
    aResult.mL3C.mType[4] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[5], &aMutateCursor);
    aResult.mL3C.mType[5] = CipherType::kGateCipher;

    // L2C: rotate -> Gate -> primary -> mutate -> Gate
    aResult.mL2C.mCount = 5U;
    aResult.mL2C.mType[0] = CipherType::kRotateCipher;
    aResult.mL2C.mType[1] = CipherType::kGateCipher;
    aResult.mL2C.mType[2] = pShuffledPrimaryMovers[7];
    aResult.mL2C.mType[3] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL2[3], &aMutateCursor);
    aResult.mL2C.mType[4] = CipherType::kGateCipher;

    // L1C: rotate -> Gate -> mutate -> secondary -> Gate
    aResult.mL1C.mCount = 5U;
    aResult.mL1C.mType[0] = CipherType::kRotateCipher;
    aResult.mL1C.mType[1] = CipherType::kGateCipher;
    aResult.mL1C.mType[2] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL1[3], &aMutateCursor);
    aResult.mL1C.mType[3] = pShuffledSecondaryMovers[0];
    aResult.mL1C.mType[4] = CipherType::kGateCipher;

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
