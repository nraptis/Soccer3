//
//  TwistFarm.cpp
//  MeanMachine
//
//  Created by nicholas on 5/23/26.
//

#include "TwistFarm.hpp"

#include "TwistFunctional.hpp"
#include "TwistMix32.hpp"
#include "TwistMix64.hpp"

#include <cstring>

static_assert(S_BLOCK == 32768,
              "TwistFarm::Farm requires S_BLOCK to be exactly 32768 bytes.");
static_assert(sizeof(TwistDomainSeedRoundMaterial) == S_BLOCK,
              "One farm lane must exactly fill one salt round material.");

void TwistFarm::Farm(const std::uint8_t *pSaltLaneA,
                     const std::uint8_t *pSaltLaneB,
                     const std::uint8_t *pSaltLaneC,
                     const std::uint8_t *pConstantLane,
                     std::uint8_t *pFoldLaneA,
                     std::uint8_t *pFoldLaneB,
                     std::uint8_t *pFoldLaneC,
                     TwistDomainSaltSet *pSaltSet,
                     TwistDomainConstants *pConstants) {
    if ((pSaltLaneA == nullptr) ||
        (pSaltLaneB == nullptr) ||
        (pSaltLaneC == nullptr) ||
        (pConstantLane == nullptr) ||
        (pFoldLaneA == nullptr) ||
        (pFoldLaneB == nullptr) ||
        (pFoldLaneC == nullptr) ||
        (pSaltSet == nullptr) ||
        (pConstants == nullptr)) {
        return;
    }

    FarmSalts(pSaltLaneA,
              pSaltLaneB,
              pSaltLaneC,
              pSaltSet);
    FarmConstants(pConstantLane,
                  pFoldLaneA,
                  pFoldLaneB,
                  pFoldLaneC,
                  pConstants);
}

void TwistFarm::FarmSalts(const std::uint8_t *pSourceLaneA,
                          const std::uint8_t *pSourceLaneB,
                          const std::uint8_t *pSourceLaneC,
                          TwistDomainSaltSet *pSaltSet) {
    if ((pSourceLaneA == nullptr) ||
        (pSourceLaneB == nullptr) ||
        (pSourceLaneC == nullptr) ||
        (pSaltSet == nullptr)) {
        return;
    }

    std::memcpy(&pSaltSet->mOrbiterAssign,
                pSourceLaneA,
                sizeof(pSaltSet->mOrbiterAssign));
    std::memcpy(&pSaltSet->mOrbiterUpdate,
                pSourceLaneB,
                sizeof(pSaltSet->mOrbiterUpdate));
    std::memcpy(&pSaltSet->mWandererUpdate,
                pSourceLaneC,
                sizeof(pSaltSet->mWandererUpdate));
}

void TwistFarm::FarmConstants(const std::uint8_t *pSource,
                              std::uint8_t *pFoldLaneA,
                              std::uint8_t *pFoldLaneB,
                              std::uint8_t *pFoldLaneC,
                              TwistDomainConstants *pConstants) {
    if ((pSource == nullptr) ||
        (pFoldLaneA == nullptr) ||
        (pFoldLaneB == nullptr) ||
        (pFoldLaneC == nullptr) ||
        (pConstants == nullptr)) {
        return;
    }
    if ((pSource == pFoldLaneA) ||
        (pSource == pFoldLaneB) ||
        (pSource == pFoldLaneC) ||
        (pFoldLaneA == pFoldLaneB) ||
        (pFoldLaneA == pFoldLaneC) ||
        (pFoldLaneB == pFoldLaneC)) {
        return;
    }

    //
    // Fold eight 4,096-byte pieces into 512 64-bit words.
    //
    for (std::size_t aIndex = 0U; aIndex < 512U; aIndex += 1U) {
        std::uint64_t aFold = 0ULL;
        aFold = TwistMix64::DiffuseA(aFold ^ Load64LE(pSource + ((aIndex + 0U) * 8U)));
        aFold = TwistMix64::DiffuseA(aFold ^ Load64LE(pSource + ((aIndex + 512U) * 8U)));
        aFold = TwistMix64::DiffuseA(aFold ^ Load64LE(pSource + ((aIndex + 1024U) * 8U)));
        aFold = TwistMix64::DiffuseA(aFold ^ Load64LE(pSource + ((aIndex + 1536U) * 8U)));
        aFold = TwistMix64::DiffuseA(aFold ^ Load64LE(pSource + ((aIndex + 2048U) * 8U)));
        aFold = TwistMix64::DiffuseA(aFold ^ Load64LE(pSource + ((aIndex + 2560U) * 8U)));
        aFold = TwistMix64::DiffuseA(aFold ^ Load64LE(pSource + ((aIndex + 3072U) * 8U)));
        aFold = TwistMix64::DiffuseA(aFold ^ Load64LE(pSource + ((aIndex + 3584U) * 8U)));
        Store64LE(pFoldLaneA + (aIndex * 8U), aFold);
    }

    //
    // Fold eight 512-byte pieces into 64 64-bit words.
    //
    for (std::size_t aIndex = 0U; aIndex < 64U; aIndex += 1U) {
        std::uint64_t aFold = 0ULL;
        aFold = TwistMix64::DiffuseA(aFold ^ Load64LE(pFoldLaneA + ((aIndex + 0U) * 8U)));
        aFold = TwistMix64::DiffuseA(aFold ^ Load64LE(pFoldLaneA + ((aIndex + 64U) * 8U)));
        aFold = TwistMix64::DiffuseA(aFold ^ Load64LE(pFoldLaneA + ((aIndex + 128U) * 8U)));
        aFold = TwistMix64::DiffuseA(aFold ^ Load64LE(pFoldLaneA + ((aIndex + 192U) * 8U)));
        aFold = TwistMix64::DiffuseA(aFold ^ Load64LE(pFoldLaneA + ((aIndex + 256U) * 8U)));
        aFold = TwistMix64::DiffuseA(aFold ^ Load64LE(pFoldLaneA + ((aIndex + 320U) * 8U)));
        aFold = TwistMix64::DiffuseA(aFold ^ Load64LE(pFoldLaneA + ((aIndex + 384U) * 8U)));
        aFold = TwistMix64::DiffuseA(aFold ^ Load64LE(pFoldLaneA + ((aIndex + 448U) * 8U)));
        Store64LE(pFoldLaneB + (aIndex * 8U), aFold);
    }

    //
    // Fold four 128-byte pieces into 16 64-bit words.
    //
    // The low and high halves are folded independently with TwistMix32.
    //
    for (std::size_t aIndex = 0U; aIndex < 16U; aIndex += 1U) {
        const std::uint8_t *aPieceA = pFoldLaneB + ((aIndex + 0U) * 8U);
        const std::uint8_t *aPieceB = pFoldLaneB + ((aIndex + 16U) * 8U);
        const std::uint8_t *aPieceC = pFoldLaneB + ((aIndex + 32U) * 8U);
        const std::uint8_t *aPieceD = pFoldLaneB + ((aIndex + 48U) * 8U);

        std::uint32_t aFoldLow = 0U;
        aFoldLow = TwistMix32::DiffuseA(aFoldLow ^ Load32LE(aPieceA));
        aFoldLow = TwistMix32::DiffuseA(aFoldLow ^ Load32LE(aPieceB));
        aFoldLow = TwistMix32::DiffuseA(aFoldLow ^ Load32LE(aPieceC));
        aFoldLow = TwistMix32::DiffuseA(aFoldLow ^ Load32LE(aPieceD));

        std::uint32_t aFoldHigh = 0U;
        aFoldHigh = TwistMix32::DiffuseA(aFoldHigh ^ Load32LE(aPieceA + 4U));
        aFoldHigh = TwistMix32::DiffuseA(aFoldHigh ^ Load32LE(aPieceB + 4U));
        aFoldHigh = TwistMix32::DiffuseA(aFoldHigh ^ Load32LE(aPieceC + 4U));
        aFoldHigh = TwistMix32::DiffuseA(aFoldHigh ^ Load32LE(aPieceD + 4U));

        Store32LE(pFoldLaneC + (aIndex * 8U), aFoldLow);
        Store32LE(pFoldLaneC + (aIndex * 8U) + 4U, aFoldHigh);
    }

    //
    // The final lane contains sixteen 64-bit words. Use the first eleven.
    //
    std::uint64_t aIngress = Load64LE(pFoldLaneC + (0U * 8U));
    std::uint64_t aScatter = Load64LE(pFoldLaneC + (1U * 8U));
    std::uint64_t aCross = Load64LE(pFoldLaneC + (2U * 8U));
    std::uint64_t aMatrixSelectA = Load64LE(pFoldLaneC + (3U * 8U));
    std::uint64_t aMatrixSelectB = Load64LE(pFoldLaneC + (4U * 8U));
    std::uint64_t aMatrixUnrollA = Load64LE(pFoldLaneC + (5U * 8U));
    std::uint64_t aMatrixUnrollB = Load64LE(pFoldLaneC + (6U * 8U));
    std::uint64_t aMatrixArgA = Load64LE(pFoldLaneC + (7U * 8U));
    std::uint64_t aMatrixArgB = Load64LE(pFoldLaneC + (8U * 8U));
    std::uint64_t aMatrixArgC = Load64LE(pFoldLaneC + (9U * 8U));
    std::uint64_t aMatrixArgD = Load64LE(pFoldLaneC + (10U * 8U));

    //
    // Fold each 64-bit small constant down to eight bits.
    //
    aMatrixUnrollA = TwistMix64::DiffuseA(aMatrixUnrollA);
    aMatrixUnrollA ^= aMatrixUnrollA >> 32U;
    aMatrixUnrollA ^= aMatrixUnrollA >> 16U;
    aMatrixUnrollA ^= aMatrixUnrollA >> 8U;

    aMatrixUnrollB = TwistMix64::DiffuseA(aMatrixUnrollB);
    aMatrixUnrollB ^= aMatrixUnrollB >> 32U;
    aMatrixUnrollB ^= aMatrixUnrollB >> 16U;
    aMatrixUnrollB ^= aMatrixUnrollB >> 8U;

    aMatrixArgA = TwistMix64::DiffuseA(aMatrixArgA);
    aMatrixArgA ^= aMatrixArgA >> 32U;
    aMatrixArgA ^= aMatrixArgA >> 16U;
    aMatrixArgA ^= aMatrixArgA >> 8U;

    aMatrixArgB = TwistMix64::DiffuseA(aMatrixArgB);
    aMatrixArgB ^= aMatrixArgB >> 32U;
    aMatrixArgB ^= aMatrixArgB >> 16U;
    aMatrixArgB ^= aMatrixArgB >> 8U;

    aMatrixArgC = TwistMix64::DiffuseA(aMatrixArgC);
    aMatrixArgC ^= aMatrixArgC >> 32U;
    aMatrixArgC ^= aMatrixArgC >> 16U;
    aMatrixArgC ^= aMatrixArgC >> 8U;

    aMatrixArgD = TwistMix64::DiffuseA(aMatrixArgD);
    aMatrixArgD ^= aMatrixArgD >> 32U;
    aMatrixArgD ^= aMatrixArgD >> 16U;
    aMatrixArgD ^= aMatrixArgD >> 8U;

    pConstants->mIngress = aIngress;
    pConstants->mScatter = aScatter;
    pConstants->mCross = aCross;
    pConstants->mMatrixSelectA = aMatrixSelectA;
    pConstants->mMatrixSelectB = aMatrixSelectB;
    pConstants->mMatrixUnrollA =
        static_cast<std::uint8_t>(aMatrixUnrollA);
    pConstants->mMatrixUnrollB =
        static_cast<std::uint8_t>(aMatrixUnrollB);
    pConstants->mMatrixArgA =
        static_cast<std::uint8_t>(aMatrixArgA);
    pConstants->mMatrixArgB =
        static_cast<std::uint8_t>(aMatrixArgB);
    pConstants->mMatrixArgC =
        static_cast<std::uint8_t>(aMatrixArgC);
    pConstants->mMatrixArgD =
        static_cast<std::uint8_t>(aMatrixArgD);
}
