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

    // L3A: FrogTwo -> mutate -> ToadThree -> rotate -> primary -> NewtThree
    aResult.mL3A.mCount = 6U;
    aResult.mL3A.mType[0] = CipherType::kFrogTwoCipherA;
    aResult.mL3A.mSamplingBank[0] = CipherSamplingBank::kPlanet;
    aResult.mL3A.mType[1] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[0], &aMutateCursor);
    aResult.mL3A.mType[2] = CipherType::kToadThreeCipherA;
    aResult.mL3A.mSamplingBank[2] = CipherSamplingBank::kMoon;
    aResult.mL3A.mType[3] = CipherType::kRotateCipher;
    aResult.mL3A.mType[4] = pShuffledPrimaryMovers[0];
    aResult.mL3A.mType[5] = CipherType::kNewtThreeCipherA;
    aResult.mL3A.mSamplingBank[5] = CipherSamplingBank::kStar;

    // L2A: ToadTwo -> rotate -> NewtThree -> primary -> mutate -> FrogThree
    aResult.mL2A.mCount = 6U;
    aResult.mL2A.mType[0] = CipherType::kToadTwoCipherA;
    aResult.mL2A.mSamplingBank[0] = CipherSamplingBank::kMoon;
    aResult.mL2A.mType[1] = CipherType::kRotateCipher;
    aResult.mL2A.mType[2] = CipherType::kNewtThreeCipherA;
    aResult.mL2A.mSamplingBank[2] = CipherSamplingBank::kStar;
    aResult.mL2A.mType[3] = pShuffledPrimaryMovers[1];
    aResult.mL2A.mType[4] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL2[0], &aMutateCursor);
    aResult.mL2A.mType[5] = CipherType::kFrogThreeCipherA;
    aResult.mL2A.mSamplingBank[5] = CipherSamplingBank::kPlanet;

    // L1A: NewtTwo -> mutate -> rotate -> FrogThree -> secondary -> ToadThree
    aResult.mL1A.mCount = 6U;
    aResult.mL1A.mType[0] = CipherType::kNewtTwoCipherA;
    aResult.mL1A.mSamplingBank[0] = CipherSamplingBank::kStar;
    aResult.mL1A.mType[1] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL1[0], &aMutateCursor);
    aResult.mL1A.mType[2] = CipherType::kRotateCipher;
    aResult.mL1A.mType[3] = CipherType::kFrogThreeCipherA;
    aResult.mL1A.mSamplingBank[3] = CipherSamplingBank::kPlanet;
    aResult.mL1A.mType[4] = pShuffledSecondaryMovers[0];
    aResult.mL1A.mType[5] = CipherType::kToadThreeCipherA;
    aResult.mL1A.mSamplingBank[5] = CipherSamplingBank::kMoon;

    // L3B: FrogThree -> primary -> NewtThree -> rotate -> mutate -> ToadTwo
    aResult.mL3B.mCount = 6U;
    aResult.mL3B.mType[0] = CipherType::kFrogThreeCipherA;
    aResult.mL3B.mSamplingBank[0] = CipherSamplingBank::kPlanet;
    aResult.mL3B.mType[1] = pShuffledPrimaryMovers[2];
    aResult.mL3B.mType[2] = CipherType::kNewtThreeCipherA;
    aResult.mL3B.mSamplingBank[2] = CipherSamplingBank::kStar;
    aResult.mL3B.mType[3] = CipherType::kRotateCipher;
    aResult.mL3B.mType[4] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[1], &aMutateCursor);
    aResult.mL3B.mType[5] = CipherType::kToadTwoCipherA;
    aResult.mL3B.mSamplingBank[5] = CipherSamplingBank::kMoon;

    // L2B: ToadThree -> rotate -> FrogThree -> primary -> NewtTwo
    aResult.mL2B.mCount = 5U;
    aResult.mL2B.mType[0] = CipherType::kToadThreeCipherA;
    aResult.mL2B.mSamplingBank[0] = CipherSamplingBank::kMoon;
    aResult.mL2B.mType[1] = CipherType::kRotateCipher;
    aResult.mL2B.mType[2] = CipherType::kFrogThreeCipherA;
    aResult.mL2B.mSamplingBank[2] = CipherSamplingBank::kPlanet;
    aResult.mL2B.mType[3] = pShuffledPrimaryMovers[3];
    aResult.mL2B.mType[4] = CipherType::kNewtTwoCipherA;
    aResult.mL2B.mSamplingBank[4] = CipherSamplingBank::kStar;

    // L1B: NewtThree -> secondary -> ToadThree -> rotate -> FrogTwo
    aResult.mL1B.mCount = 5U;
    aResult.mL1B.mType[0] = CipherType::kNewtThreeCipherA;
    aResult.mL1B.mSamplingBank[0] = CipherSamplingBank::kStar;
    aResult.mL1B.mType[1] = pShuffledSecondaryMovers[1];
    aResult.mL1B.mType[2] = CipherType::kToadThreeCipherA;
    aResult.mL1B.mSamplingBank[2] = CipherSamplingBank::kMoon;
    aResult.mL1B.mType[3] = CipherType::kRotateCipher;
    aResult.mL1B.mType[4] = CipherType::kFrogTwoCipherA;
    aResult.mL1B.mSamplingBank[4] = CipherSamplingBank::kPlanet;

    // L3C: NewtTwo -> rotate -> ToadThree -> primary -> FrogThree
    aResult.mL3C.mCount = 5U;
    aResult.mL3C.mType[0] = CipherType::kNewtTwoCipherA;
    aResult.mL3C.mSamplingBank[0] = CipherSamplingBank::kStar;
    aResult.mL3C.mType[1] = CipherType::kRotateCipher;
    aResult.mL3C.mType[2] = CipherType::kToadThreeCipherA;
    aResult.mL3C.mSamplingBank[2] = CipherSamplingBank::kMoon;
    aResult.mL3C.mType[3] = pShuffledPrimaryMovers[4];
    aResult.mL3C.mType[4] = CipherType::kFrogThreeCipherA;
    aResult.mL3C.mSamplingBank[4] = CipherSamplingBank::kPlanet;

    // L2C: FrogTwo -> primary -> NewtThree -> rotate -> ToadThree
    aResult.mL2C.mCount = 5U;
    aResult.mL2C.mType[0] = CipherType::kFrogTwoCipherA;
    aResult.mL2C.mSamplingBank[0] = CipherSamplingBank::kPlanet;
    aResult.mL2C.mType[1] = pShuffledPrimaryMovers[5];
    aResult.mL2C.mType[2] = CipherType::kNewtThreeCipherA;
    aResult.mL2C.mSamplingBank[2] = CipherSamplingBank::kStar;
    aResult.mL2C.mType[3] = CipherType::kRotateCipher;
    aResult.mL2C.mType[4] = CipherType::kToadThreeCipherA;
    aResult.mL2C.mSamplingBank[4] = CipherSamplingBank::kMoon;

    // L1C: ToadTwo -> rotate -> FrogThree -> secondary -> NewtThree
    aResult.mL1C.mCount = 5U;
    aResult.mL1C.mType[0] = CipherType::kToadTwoCipherA;
    aResult.mL1C.mSamplingBank[0] = CipherSamplingBank::kMoon;
    aResult.mL1C.mType[1] = CipherType::kRotateCipher;
    aResult.mL1C.mType[2] = CipherType::kFrogThreeCipherA;
    aResult.mL1C.mSamplingBank[2] = CipherSamplingBank::kPlanet;
    aResult.mL1C.mType[3] = pShuffledSecondaryMovers[2];
    aResult.mL1C.mType[4] = CipherType::kNewtThreeCipherA;
    aResult.mL1C.mSamplingBank[4] = CipherSamplingBank::kStar;

    return aResult;
}

EncryptionPlan EncryptionPlanTool::MakePlanNormal(std::uint64_t pLaneSelect,
                                                const CipherType (&pShuffledMutate)[32],
                                                const CipherType (&pShuffledPrimaryMovers)[32],
                                                const CipherType (&pShuffledSecondaryMovers)[32]) {
    EncryptionPlan aResult{};
    const NormalLaneCombination aLaneCombination = LaneCombinations::PickNormal(pLaneSelect);
    std::size_t aMutateCursor = 0U;

    // L3A: FrogTwo -> mutate -> ToadThree -> rotate -> primary -> NewtThree
    aResult.mL3A.mCount = 6U;
    aResult.mL3A.mType[0] = CipherType::kFrogTwoCipherA;
    aResult.mL3A.mSamplingBank[0] = CipherSamplingBank::kPlanet;
    aResult.mL3A.mType[1] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[0], &aMutateCursor);
    aResult.mL3A.mType[2] = CipherType::kToadThreeCipherA;
    aResult.mL3A.mSamplingBank[2] = CipherSamplingBank::kMoon;
    aResult.mL3A.mType[3] = CipherType::kRotateCipher;
    aResult.mL3A.mType[4] = pShuffledPrimaryMovers[0];
    aResult.mL3A.mType[5] = CipherType::kNewtThreeCipherA;
    aResult.mL3A.mSamplingBank[5] = CipherSamplingBank::kStar;

    // L2A: ToadTwo -> rotate -> NewtThree -> primary -> mutate -> FrogThree
    aResult.mL2A.mCount = 6U;
    aResult.mL2A.mType[0] = CipherType::kToadTwoCipherA;
    aResult.mL2A.mSamplingBank[0] = CipherSamplingBank::kMoon;
    aResult.mL2A.mType[1] = CipherType::kRotateCipher;
    aResult.mL2A.mType[2] = CipherType::kNewtThreeCipherA;
    aResult.mL2A.mSamplingBank[2] = CipherSamplingBank::kStar;
    aResult.mL2A.mType[3] = pShuffledPrimaryMovers[1];
    aResult.mL2A.mType[4] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL2[0], &aMutateCursor);
    aResult.mL2A.mType[5] = CipherType::kFrogThreeCipherA;
    aResult.mL2A.mSamplingBank[5] = CipherSamplingBank::kPlanet;

    // L1A: NewtTwo -> mutate -> rotate -> FrogThree -> secondary -> ToadThree
    aResult.mL1A.mCount = 6U;
    aResult.mL1A.mType[0] = CipherType::kNewtTwoCipherA;
    aResult.mL1A.mSamplingBank[0] = CipherSamplingBank::kStar;
    aResult.mL1A.mType[1] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL1[0], &aMutateCursor);
    aResult.mL1A.mType[2] = CipherType::kRotateCipher;
    aResult.mL1A.mType[3] = CipherType::kFrogThreeCipherA;
    aResult.mL1A.mSamplingBank[3] = CipherSamplingBank::kPlanet;
    aResult.mL1A.mType[4] = pShuffledSecondaryMovers[0];
    aResult.mL1A.mType[5] = CipherType::kToadThreeCipherA;
    aResult.mL1A.mSamplingBank[5] = CipherSamplingBank::kMoon;

    // L3B: FrogThree -> primary -> NewtThree -> rotate -> mutate -> ToadTwo
    aResult.mL3B.mCount = 6U;
    aResult.mL3B.mType[0] = CipherType::kFrogThreeCipherA;
    aResult.mL3B.mSamplingBank[0] = CipherSamplingBank::kPlanet;
    aResult.mL3B.mType[1] = pShuffledPrimaryMovers[2];
    aResult.mL3B.mType[2] = CipherType::kNewtThreeCipherA;
    aResult.mL3B.mSamplingBank[2] = CipherSamplingBank::kStar;
    aResult.mL3B.mType[3] = CipherType::kRotateCipher;
    aResult.mL3B.mType[4] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[1], &aMutateCursor);
    aResult.mL3B.mType[5] = CipherType::kToadTwoCipherA;
    aResult.mL3B.mSamplingBank[5] = CipherSamplingBank::kMoon;

    // L2B: ToadThree -> rotate -> FrogThree -> primary -> NewtTwo
    aResult.mL2B.mCount = 5U;
    aResult.mL2B.mType[0] = CipherType::kToadThreeCipherA;
    aResult.mL2B.mSamplingBank[0] = CipherSamplingBank::kMoon;
    aResult.mL2B.mType[1] = CipherType::kRotateCipher;
    aResult.mL2B.mType[2] = CipherType::kFrogThreeCipherA;
    aResult.mL2B.mSamplingBank[2] = CipherSamplingBank::kPlanet;
    aResult.mL2B.mType[3] = pShuffledPrimaryMovers[3];
    aResult.mL2B.mType[4] = CipherType::kNewtTwoCipherA;
    aResult.mL2B.mSamplingBank[4] = CipherSamplingBank::kStar;

    // L1B: NewtThree -> secondary -> ToadThree -> rotate -> FrogTwo
    aResult.mL1B.mCount = 5U;
    aResult.mL1B.mType[0] = CipherType::kNewtThreeCipherA;
    aResult.mL1B.mSamplingBank[0] = CipherSamplingBank::kStar;
    aResult.mL1B.mType[1] = pShuffledSecondaryMovers[1];
    aResult.mL1B.mType[2] = CipherType::kToadThreeCipherA;
    aResult.mL1B.mSamplingBank[2] = CipherSamplingBank::kMoon;
    aResult.mL1B.mType[3] = CipherType::kRotateCipher;
    aResult.mL1B.mType[4] = CipherType::kFrogTwoCipherA;
    aResult.mL1B.mSamplingBank[4] = CipherSamplingBank::kPlanet;

    // L3C: NewtTwo -> primary -> rotate -> ToadThree -> mutate -> primary -> FrogThree
    aResult.mL3C.mCount = 7U;
    aResult.mL3C.mType[0] = CipherType::kNewtTwoCipherA;
    aResult.mL3C.mSamplingBank[0] = CipherSamplingBank::kStar;
    aResult.mL3C.mType[1] = pShuffledPrimaryMovers[4];
    aResult.mL3C.mType[2] = CipherType::kRotateCipher;
    aResult.mL3C.mType[3] = CipherType::kToadThreeCipherA;
    aResult.mL3C.mSamplingBank[3] = CipherSamplingBank::kMoon;
    aResult.mL3C.mType[4] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[2], &aMutateCursor);
    aResult.mL3C.mType[5] = pShuffledPrimaryMovers[5];
    aResult.mL3C.mType[6] = CipherType::kFrogThreeCipherA;
    aResult.mL3C.mSamplingBank[6] = CipherSamplingBank::kPlanet;

    // L2C: FrogTwo -> primary -> NewtThree -> rotate -> mutate -> secondary -> ToadThree
    aResult.mL2C.mCount = 7U;
    aResult.mL2C.mType[0] = CipherType::kFrogTwoCipherA;
    aResult.mL2C.mSamplingBank[0] = CipherSamplingBank::kPlanet;
    aResult.mL2C.mType[1] = pShuffledPrimaryMovers[6];
    aResult.mL2C.mType[2] = CipherType::kNewtThreeCipherA;
    aResult.mL2C.mSamplingBank[2] = CipherSamplingBank::kStar;
    aResult.mL2C.mType[3] = CipherType::kRotateCipher;
    aResult.mL2C.mType[4] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL2[1], &aMutateCursor);
    aResult.mL2C.mType[5] = pShuffledSecondaryMovers[2];
    aResult.mL2C.mType[6] = CipherType::kToadThreeCipherA;
    aResult.mL2C.mSamplingBank[6] = CipherSamplingBank::kMoon;

    // L1C: ToadTwo -> secondary -> rotate -> FrogThree -> mutate -> secondary -> NewtThree
    aResult.mL1C.mCount = 7U;
    aResult.mL1C.mType[0] = CipherType::kToadTwoCipherA;
    aResult.mL1C.mSamplingBank[0] = CipherSamplingBank::kMoon;
    aResult.mL1C.mType[1] = pShuffledSecondaryMovers[3];
    aResult.mL1C.mType[2] = CipherType::kRotateCipher;
    aResult.mL1C.mType[3] = CipherType::kFrogThreeCipherA;
    aResult.mL1C.mSamplingBank[3] = CipherSamplingBank::kPlanet;
    aResult.mL1C.mType[4] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL1[1], &aMutateCursor);
    aResult.mL1C.mType[5] = pShuffledSecondaryMovers[4];
    aResult.mL1C.mType[6] = CipherType::kNewtThreeCipherA;
    aResult.mL1C.mSamplingBank[6] = CipherSamplingBank::kStar;

    return aResult;
}

EncryptionPlan EncryptionPlanTool::MakePlanStrong(std::uint64_t pLaneSelect,
                                                  const CipherType (&pShuffledMutate)[32],
                                                  const CipherType (&pShuffledPrimaryMovers)[32],
                                                  const CipherType (&pShuffledSecondaryMovers)[32]) {
    EncryptionPlan aResult{};
    const StrongLaneCombination aLaneCombination = LaneCombinations::PickStrong(pLaneSelect);
    std::size_t aMutateCursor = 0U;

    // L3A: FrogTwo -> ToadThree -> NewtThree
    aResult.mL3A.mCount = 7U;
    aResult.mL3A.mType[0] = CipherType::kRotateMaskCipher;
    aResult.mL3A.mType[1] = CipherType::kFrogTwoCipherA;
    aResult.mL3A.mSamplingBank[1] = CipherSamplingBank::kPlanet;
    aResult.mL3A.mType[2] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[0], &aMutateCursor);
    aResult.mL3A.mType[3] = CipherType::kToadThreeCipherA;
    aResult.mL3A.mSamplingBank[3] = CipherSamplingBank::kMoon;
    aResult.mL3A.mType[4] = pShuffledPrimaryMovers[0];
    aResult.mL3A.mType[5] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[1], &aMutateCursor);
    aResult.mL3A.mType[6] = CipherType::kNewtThreeCipherA;
    aResult.mL3A.mSamplingBank[6] = CipherSamplingBank::kStar;

    // L2A: ToadTwo -> NewtThree -> FrogThree
    aResult.mL2A.mCount = 7U;
    aResult.mL2A.mType[0] = CipherType::kRotateMaskCipher;
    aResult.mL2A.mType[1] = CipherType::kToadTwoCipherA;
    aResult.mL2A.mSamplingBank[1] = CipherSamplingBank::kMoon;
    aResult.mL2A.mType[2] = pShuffledPrimaryMovers[1];
    aResult.mL2A.mType[3] = CipherType::kNewtThreeCipherA;
    aResult.mL2A.mSamplingBank[3] = CipherSamplingBank::kStar;
    aResult.mL2A.mType[4] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL2[0], &aMutateCursor);
    aResult.mL2A.mType[5] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL2[1], &aMutateCursor);
    aResult.mL2A.mType[6] = CipherType::kFrogThreeCipherA;
    aResult.mL2A.mSamplingBank[6] = CipherSamplingBank::kPlanet;

    // L1A: NewtTwo -> FrogThree -> ToadThree
    aResult.mL1A.mCount = 7U;
    aResult.mL1A.mType[0] = CipherType::kRotateMaskCipher;
    aResult.mL1A.mType[1] = CipherType::kNewtTwoCipherA;
    aResult.mL1A.mSamplingBank[1] = CipherSamplingBank::kStar;
    aResult.mL1A.mType[2] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL1[0], &aMutateCursor);
    aResult.mL1A.mType[3] = CipherType::kFrogThreeCipherA;
    aResult.mL1A.mSamplingBank[3] = CipherSamplingBank::kPlanet;
    aResult.mL1A.mType[4] = pShuffledPrimaryMovers[2];
    aResult.mL1A.mType[5] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL1[1], &aMutateCursor);
    aResult.mL1A.mType[6] = CipherType::kToadThreeCipherA;
    aResult.mL1A.mSamplingBank[6] = CipherSamplingBank::kMoon;

    // L3B: FrogThree -> NewtThree -> ToadTwo
    aResult.mL3B.mCount = 7U;
    aResult.mL3B.mType[0] = CipherType::kRotateMaskCipher;
    aResult.mL3B.mType[1] = CipherType::kFrogThreeCipherA;
    aResult.mL3B.mSamplingBank[1] = CipherSamplingBank::kPlanet;
    aResult.mL3B.mType[2] = pShuffledPrimaryMovers[3];
    aResult.mL3B.mType[3] = CipherType::kNewtThreeCipherA;
    aResult.mL3B.mSamplingBank[3] = CipherSamplingBank::kStar;
    aResult.mL3B.mType[4] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[2], &aMutateCursor);
    aResult.mL3B.mType[5] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[3], &aMutateCursor);
    aResult.mL3B.mType[6] = CipherType::kToadTwoCipherA;
    aResult.mL3B.mSamplingBank[6] = CipherSamplingBank::kMoon;

    // L2B: ToadThree -> FrogThree -> NewtTwo
    aResult.mL2B.mCount = 6U;
    aResult.mL2B.mType[0] = CipherType::kRotateCipher;
    aResult.mL2B.mType[1] = CipherType::kToadThreeCipherA;
    aResult.mL2B.mSamplingBank[1] = CipherSamplingBank::kMoon;
    aResult.mL2B.mType[2] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL2[2], &aMutateCursor);
    aResult.mL2B.mType[3] = CipherType::kFrogThreeCipherA;
    aResult.mL2B.mSamplingBank[3] = CipherSamplingBank::kPlanet;
    aResult.mL2B.mType[4] = pShuffledPrimaryMovers[4];
    aResult.mL2B.mType[5] = CipherType::kNewtTwoCipherA;
    aResult.mL2B.mSamplingBank[5] = CipherSamplingBank::kStar;

    // L1B: NewtThree -> ToadThree -> FrogTwo
    aResult.mL1B.mCount = 6U;
    aResult.mL1B.mType[0] = CipherType::kRotateCipher;
    aResult.mL1B.mType[1] = CipherType::kNewtThreeCipherA;
    aResult.mL1B.mSamplingBank[1] = CipherSamplingBank::kStar;
    aResult.mL1B.mType[2] = pShuffledPrimaryMovers[5];
    aResult.mL1B.mType[3] = CipherType::kToadThreeCipherA;
    aResult.mL1B.mSamplingBank[3] = CipherSamplingBank::kMoon;
    aResult.mL1B.mType[4] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL1[2], &aMutateCursor);
    aResult.mL1B.mType[5] = CipherType::kFrogTwoCipherA;
    aResult.mL1B.mSamplingBank[5] = CipherSamplingBank::kPlanet;

    // L3C: NewtTwo -> ToadThree -> FrogThree
    aResult.mL3C.mCount = 7U;
    aResult.mL3C.mType[0] = CipherType::kRotateCipher;
    aResult.mL3C.mType[1] = CipherType::kNewtTwoCipherA;
    aResult.mL3C.mSamplingBank[1] = CipherSamplingBank::kStar;
    aResult.mL3C.mType[2] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[4], &aMutateCursor);
    aResult.mL3C.mType[3] = CipherType::kToadThreeCipherA;
    aResult.mL3C.mSamplingBank[3] = CipherSamplingBank::kMoon;
    aResult.mL3C.mType[4] = pShuffledPrimaryMovers[6];
    aResult.mL3C.mType[5] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL3[5], &aMutateCursor);
    aResult.mL3C.mType[6] = CipherType::kFrogThreeCipherA;
    aResult.mL3C.mSamplingBank[6] = CipherSamplingBank::kPlanet;

    // L2C: FrogTwo -> NewtThree -> ToadThree
    aResult.mL2C.mCount = 6U;
    aResult.mL2C.mType[0] = CipherType::kRotateCipher;
    aResult.mL2C.mType[1] = CipherType::kFrogTwoCipherA;
    aResult.mL2C.mSamplingBank[1] = CipherSamplingBank::kPlanet;
    aResult.mL2C.mType[2] = pShuffledPrimaryMovers[7];
    aResult.mL2C.mType[3] = CipherType::kNewtThreeCipherA;
    aResult.mL2C.mSamplingBank[3] = CipherSamplingBank::kStar;
    aResult.mL2C.mType[4] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL2[3], &aMutateCursor);
    aResult.mL2C.mType[5] = CipherType::kToadThreeCipherA;
    aResult.mL2C.mSamplingBank[5] = CipherSamplingBank::kMoon;

    // L1C: ToadTwo -> FrogThree -> NewtThree
    aResult.mL1C.mCount = 6U;
    aResult.mL1C.mType[0] = CipherType::kRotateCipher;
    aResult.mL1C.mType[1] = CipherType::kToadTwoCipherA;
    aResult.mL1C.mSamplingBank[1] = CipherSamplingBank::kMoon;
    aResult.mL1C.mType[2] = RingFetchMutate(pShuffledMutate, aLaneCombination.mL1[3], &aMutateCursor);
    aResult.mL1C.mType[3] = CipherType::kFrogThreeCipherA;
    aResult.mL1C.mSamplingBank[3] = CipherSamplingBank::kPlanet;
    aResult.mL1C.mType[4] = pShuffledSecondaryMovers[0];
    aResult.mL1C.mType[5] = CipherType::kNewtThreeCipherA;
    aResult.mL1C.mSamplingBank[5] = CipherSamplingBank::kStar;

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
