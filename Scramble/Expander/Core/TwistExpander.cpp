//
//  TwistExpander.cpp
//  MeanMachine
//

#include "TwistExpander.hpp"
#include "TwistMix64.hpp"

#include <cstring>

TwistExpander::TwistExpander() {
    std::memset(&mDomainBundleInbuilt, 0, sizeof(mDomainBundleInbuilt));
    std::memset(&mDomainBundleEphemeralA, 0, sizeof(mDomainBundleEphemeralA));
    std::memset(&mDomainBundleEphemeralB, 0, sizeof(mDomainBundleEphemeralB));
}

TwistExpander::~TwistExpander() {
    
}

void TwistExpander::KDF(std::uint64_t pNonce,
                        TwistDomainConstants *pDomainConstants,
                        TwistDomainSaltSet *pDomainSaltSet) {
    (void)pNonce;
    (void)pDomainConstants;
    (void)pDomainSaltSet;
}

void TwistExpander::Seed(TwistWorkSpace *pWorkSpace,
                         std::uint64_t pNonce,
                         std::uint8_t *pPassword,
                         std::size_t pPasswordByteLength,
                         std::uint8_t *pDestination,
                         MUTABLE_PARAMS) {
    if (pWorkSpace == nullptr) {

        return;
    }
    if (pDestination == nullptr) {

        return;
    }
    if (MUTABLE_PARAMS_ARE_NULL) {

        return;
    }
    UnrollPassword(pWorkSpace->mSourceLane, pPassword, pPasswordByteLength);
    UnrollNonce(pWorkSpace->mNonceLane, pNonce);
    mDomainBundleEphemeralA.Zero();
    mDomainBundleEphemeralB.Zero();
    pWorkSpace->mDomainBundle.Zero();
}

void TwistExpander::TwistBlock(TwistWorkSpace *pWorkSpace,
                               std::uint8_t *pSource,
                               std::uint8_t *pCrossLaneA,
                               std::uint8_t *pCrossLaneB,
                               std::uint8_t *pCrossLaneC,
                               std::uint8_t *pCrossLaneD,
                               std::uint8_t *pDestination,
                               const bool pStifleKey,
                               MUTABLE_PARAMS) {
    if ((pWorkSpace == nullptr) ||
        (pSource == nullptr) ||
        (pCrossLaneA == nullptr) ||
        (pCrossLaneB == nullptr) ||
        (pCrossLaneC == nullptr) ||
        (pCrossLaneD == nullptr) ||
        (pDestination == nullptr) ||
        MUTABLE_PARAMS_ARE_NULL) {
        return;
    }

    (void)pStifleKey;

}

void TwistExpander::GrowKeyA(TwistWorkSpace *pWorkSpace,
                             std::uint8_t *pCrossLaneA,
                             std::uint8_t *pCrossLaneB,
                             MUTABLE_PARAMS) {
    (void)pWorkSpace;
    (void)pCrossLaneA;
    (void)pCrossLaneB;
    (void)pIngress;
    (void)pCarry;
    (void)pWandererA;
    (void)pWandererB;
    (void)pWandererC;
    (void)pWandererD;
    (void)pWandererE;
    (void)pWandererF;
    (void)pWandererG;
    (void)pWandererH;
    (void)pWandererI;
    (void)pWandererJ;
    (void)pWandererK;
}

void TwistExpander::GrowKeyB(TwistWorkSpace *pWorkSpace,
                             std::uint8_t *pCrossLaneA,
                             std::uint8_t *pCrossLaneB,
                             MUTABLE_PARAMS) {
    (void)pWorkSpace;
    (void)pCrossLaneA;
    (void)pCrossLaneB;
    (void)pIngress;
    (void)pCarry;
    (void)pWandererA;
    (void)pWandererB;
    (void)pWandererC;
    (void)pWandererD;
    (void)pWandererE;
    (void)pWandererF;
    (void)pWandererG;
    (void)pWandererH;
    (void)pWandererI;
    (void)pWandererJ;
    (void)pWandererK;
}

void TwistExpander::Twist(TwistWorkSpace *pWorkSpace,
                          std::uint8_t *pSource,
                          std::uint8_t *pCrossLaneA,
                          std::uint8_t *pCrossLaneB,
                          std::uint8_t *pCrossLaneC,
                          std::uint8_t *pCrossLaneD,
                          std::uint8_t *pDestination,
                          std::size_t pDestinationByteLength,
                          MUTABLE_PARAMS) {
    if ((pWorkSpace == nullptr) ||
        (pSource == nullptr) ||
        (pCrossLaneA == nullptr) ||
        (pCrossLaneB == nullptr) ||
        (pCrossLaneC == nullptr) ||
        (pCrossLaneD == nullptr) ||
        (pDestination == nullptr)) {

        return;
    }
    if ((pDestinationByteLength % S_BLOCK) != 0U) {

        return;
    }
    
    for (std::size_t aStartByte = 0U;
         aStartByte < pDestinationByteLength;
         aStartByte += static_cast<std::size_t>(S_BLOCK)) {
        TwistBlock(pWorkSpace,
                   pSource + aStartByte,
                   pCrossLaneA,
                   pCrossLaneB,
                   pCrossLaneC,
                   pCrossLaneD,
                   pDestination + aStartByte,
                   false,
                   MUTABLE_PARAMS_PASSED);
    }
    
}

void TwistExpander::AutoSeedThenTwist(TwistWorkSpace *pWorkSpace,
                                      std::uint64_t pNonce,
                                      std::uint8_t *pPassword,
                                      std::size_t pPasswordByteLength,
                                      std::uint8_t *pCrossLaneA,
                                      std::uint8_t *pCrossLaneB,
                                      std::uint8_t *pCrossLaneC,
                                      std::uint8_t *pCrossLaneD,
                                      std::uint8_t *pDestination,
                                      std::size_t pDestinationByteLength,
                                      MUTABLE_PARAMS) {
    
    if ((pDestinationByteLength % S_BLOCK) != 0U) {

        return;
    }
    
    Seed(pWorkSpace,
         pNonce,
         pPassword, // password
         pPasswordByteLength, // password length
         pDestination,
         MUTABLE_PARAMS_PASSED);
    
    std::size_t aDestinationIndex = S_BLOCK;
    while (aDestinationIndex < pDestinationByteLength) {
        TwistBlock(pWorkSpace,
                   &pDestination[aDestinationIndex - S_BLOCK], // source
                   pCrossLaneA,
                   pCrossLaneB,
                   pCrossLaneC,
                   pCrossLaneD,
                   &pDestination[aDestinationIndex], // dest
                   false,
                   MUTABLE_PARAMS_PASSED);
        aDestinationIndex += S_BLOCK;
    }
    
}

// Assumes the work space is seeded...
void TwistExpander::AutoTwist(TwistWorkSpace *pWorkSpace,
                              std::uint8_t *pSource,
                              std::uint8_t *pCrossLaneA,
                              std::uint8_t *pCrossLaneB,
                              std::uint8_t *pCrossLaneC,
                              std::uint8_t *pCrossLaneD,
                              std::uint8_t *pDestination,
                              std::size_t pDestinationByteLength,
                              MUTABLE_PARAMS) {
    
    TwistBlock(pWorkSpace,
               pSource,
               pCrossLaneA,
               pCrossLaneB,
               pCrossLaneC,
               pCrossLaneD,
               pDestination, // dest
               false,
               MUTABLE_PARAMS_PASSED);
    
    std::size_t aDestinationIndex = S_BLOCK;
    while (aDestinationIndex < pDestinationByteLength) {
        TwistBlock(pWorkSpace,
                   &pDestination[aDestinationIndex - S_BLOCK], // source
                   pCrossLaneA,
                   pCrossLaneB,
                   pCrossLaneC,
                   pCrossLaneD,
                   &pDestination[aDestinationIndex], // dest
                   false,
                   MUTABLE_PARAMS_PASSED);
        aDestinationIndex += S_BLOCK;
    }
    
}

void TwistExpander::UnrollPassword(std::uint8_t *pSourceLane,
                                   std::uint8_t *pPassword,
                                   std::size_t pPasswordByteLength) {
    if (pSourceLane == nullptr) {
        return;
    }

    std::memset(pSourceLane, 0, static_cast<std::size_t>(S_BLOCK));
    if ((pPassword == nullptr) || (pPasswordByteLength == 0U)) {
        return;
    }

    std::size_t aInitialCopy = pPasswordByteLength;
    if (aInitialCopy > static_cast<std::size_t>(S_BLOCK)) {
        aInitialCopy = static_cast<std::size_t>(S_BLOCK);
    }

    std::memcpy(pSourceLane, pPassword, static_cast<std::size_t>(aInitialCopy));
    if (aInitialCopy < static_cast<std::size_t>(S_BLOCK)) {
        pSourceLane[aInitialCopy++] = 0;
    }
    if (aInitialCopy < static_cast<std::size_t>(S_BLOCK)) {
        pSourceLane[aInitialCopy++] = 0;
    }

    std::size_t aFilled = aInitialCopy;
    while (aFilled < static_cast<std::size_t>(S_BLOCK)) {
        std::size_t aChunk = aFilled;
        if ((aFilled + aChunk) > static_cast<std::size_t>(S_BLOCK)) {
            aChunk = static_cast<std::size_t>(S_BLOCK) - aFilled;
        }
        std::memcpy(pSourceLane + aFilled,
                    pSourceLane,
                    static_cast<std::size_t>(aChunk));
        aFilled += aChunk;
    }
}

void TwistExpander::UnrollPassword(std::uint8_t *pSourceLane,
                                   std::uint8_t *pPassword,
                                   std::size_t pPasswordByteLength,
                                   std::size_t pSourceLaneByteLength) {
    if (pSourceLane == nullptr) {
        return;
    }

    if (pSourceLaneByteLength == 0U) {
        return;
    }

    std::memset(pSourceLane, 0, static_cast<std::size_t>(pSourceLaneByteLength));

    if ((pPassword == nullptr) || (pPasswordByteLength == 0U)) {
        return;
    }

    std::size_t aInitialCopy = pPasswordByteLength;
    if (aInitialCopy > pSourceLaneByteLength) {
        aInitialCopy = pSourceLaneByteLength;
    }

    std::memcpy(pSourceLane, pPassword, static_cast<std::size_t>(aInitialCopy));

    if (aInitialCopy < pSourceLaneByteLength) {
        pSourceLane[aInitialCopy++] = 0;
    }

    if (aInitialCopy < pSourceLaneByteLength) {
        pSourceLane[aInitialCopy++] = 0;
    }

    std::size_t aFilled = aInitialCopy;

    while (aFilled < pSourceLaneByteLength) {
        std::size_t aChunk = aFilled;

        if (aChunk == 0U) {
            break;
        }

        if ((aFilled + aChunk) > pSourceLaneByteLength) {
            aChunk = pSourceLaneByteLength - aFilled;
        }

        std::memcpy(pSourceLane + aFilled,
                    pSourceLane,
                    static_cast<std::size_t>(aChunk));

        aFilled += aChunk;
    }
}

void TwistExpander::UnrollNonce(std::uint8_t *pNonceLane,
                                std::uint64_t pNonce) {
    if (pNonceLane == nullptr) {
        return;
    }

    const std::uint64_t aNonceWordA = TwistMix64::DiffuseA(pNonce);
    const std::uint64_t aNonceWordB = TwistMix64::DiffuseB(pNonce);
    const std::uint64_t aNonceWordC = TwistMix64::DiffuseC(pNonce);

    const std::uint8_t aNonceBytes[24] = {
        static_cast<std::uint8_t>(aNonceWordA >>  0U),
        static_cast<std::uint8_t>(aNonceWordA >>  8U),
        static_cast<std::uint8_t>(aNonceWordA >> 16U),
        static_cast<std::uint8_t>(aNonceWordA >> 24U),
        static_cast<std::uint8_t>(aNonceWordA >> 32U),
        static_cast<std::uint8_t>(aNonceWordA >> 40U),
        static_cast<std::uint8_t>(aNonceWordA >> 48U),
        static_cast<std::uint8_t>(aNonceWordA >> 56U),

        static_cast<std::uint8_t>(aNonceWordB >>  0U),
        static_cast<std::uint8_t>(aNonceWordB >>  8U),
        static_cast<std::uint8_t>(aNonceWordB >> 16U),
        static_cast<std::uint8_t>(aNonceWordB >> 24U),
        static_cast<std::uint8_t>(aNonceWordB >> 32U),
        static_cast<std::uint8_t>(aNonceWordB >> 40U),
        static_cast<std::uint8_t>(aNonceWordB >> 48U),
        static_cast<std::uint8_t>(aNonceWordB >> 56U),

        static_cast<std::uint8_t>(aNonceWordC >>  0U),
        static_cast<std::uint8_t>(aNonceWordC >>  8U),
        static_cast<std::uint8_t>(aNonceWordC >> 16U),
        static_cast<std::uint8_t>(aNonceWordC >> 24U),
        static_cast<std::uint8_t>(aNonceWordC >> 32U),
        static_cast<std::uint8_t>(aNonceWordC >> 40U),
        static_cast<std::uint8_t>(aNonceWordC >> 48U),
        static_cast<std::uint8_t>(aNonceWordC >> 56U),
    };

    std::memcpy(pNonceLane, aNonceBytes, sizeof(aNonceBytes));

    std::size_t aFilled = sizeof(aNonceBytes);
    while (aFilled < static_cast<std::size_t>(S_BLOCK)) {
        std::size_t aChunk = aFilled;
        if ((aFilled + aChunk) > static_cast<std::size_t>(S_BLOCK)) {
            aChunk = static_cast<std::size_t>(S_BLOCK) - aFilled;
        }
        std::memcpy(pNonceLane + aFilled,
                    pNonceLane,
                    aChunk);
        aFilled += aChunk;
    }
}

void TwistExpander::Zero() {
    Zero_PostSeed();
    mDomainBundleInbuilt.Zero();
}

void TwistExpander::Zero_PostSeed() {
    mDomainBundleEphemeralA.Zero();
    mDomainBundleEphemeralB.Zero();
    std::memset(mMatrix.mData, 0, sizeof(mMatrix.mData));
    std::memset(mMatrix.mPermute, 0, sizeof(mMatrix.mPermute));
    std::memset(mMatrix.mPermuteData, 0, sizeof(mMatrix.mPermuteData));
    std::memset(mMatrix.mPermuteTemp, 0, sizeof(mMatrix.mPermuteTemp));
}
