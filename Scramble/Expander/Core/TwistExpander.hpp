//
//  TwistExpander.hpp
//  MeanMachine
//

#ifndef TwistExpander_hpp
#define TwistExpander_hpp

#include "TwistWorkSpace.hpp"
#include "TwistMix16.hpp"

#include <cstddef>
#include <cstdint>
#include <string>
#include <vector>
#include "M88.hpp"

#define MUTABLE_PARAMS \
    std::uint64_t *pIngress, \
    std::uint64_t *pCarry, \
    std::uint64_t *pWandererA, \
    std::uint64_t *pWandererB, \
    std::uint64_t *pWandererC, \
    std::uint64_t *pWandererD, \
    std::uint64_t *pWandererE, \
    std::uint64_t *pWandererF, \
    std::uint64_t *pWandererG, \
    std::uint64_t *pWandererH, \
    std::uint64_t *pWandererI, \
    std::uint64_t *pWandererJ, \
    std::uint64_t *pWandererK

#define MUTABLE_PARAMS_PASSED \
    pIngress, \
    pCarry, \
    pWandererA, \
    pWandererB, \
    pWandererC, \
    pWandererD, \
    pWandererE, \
    pWandererF, \
    pWandererG, \
    pWandererH, \
    pWandererI, \
    pWandererJ, \
    pWandererK

#define MUTABLE_PARAMS_ARE_NULL \
    ((pIngress == nullptr) || \
     (pCarry == nullptr) || \
     (pWandererA == nullptr) || \
     (pWandererB == nullptr) || \
     (pWandererC == nullptr) || \
     (pWandererD == nullptr) || \
     (pWandererE == nullptr) || \
     (pWandererF == nullptr) || \
     (pWandererG == nullptr) || \
     (pWandererH == nullptr) || \
     (pWandererI == nullptr) || \
     (pWandererJ == nullptr) || \
     (pWandererK == nullptr))

#define ARX_STATE_VARS \
    &aIngress, \
    &aCarry, \
    &aWandererA, \
    &aWandererB, \
    &aWandererC, \
    &aWandererD, \
    &aWandererE, \
    &aWandererF, \
    &aWandererG, \
    &aWandererH, \
    &aWandererI, \
    &aWandererJ, \
    &aWandererK

#define PARAMS_KDF \
    pWorkSpace, \
    pNonce, \
    pConstants, \
    pDomainSaltSet, \
    MUTABLE_PARAMS_PASSED

#define PARAMS_SEED \
    pWorkSpace, \
    pNonce, \
    ARX_STATE_VARS

#define PARAMS_TWIST \
    pWorkSpace, \
    pSource, \
    pCrossLaneA, \
    pCrossLaneB, \
    pCrossLaneC, \
    pCrossLaneD, \
    ARX_STATE_VARS

#define PARAMS_GROW \
    pWorkSpace, \
    MUTABLE_PARAMS_PASSED

#define PARAMS_GROW_CROSS \
    pWorkSpace, \
    pCrossLaneA, \
    pCrossLaneB, \
    MUTABLE_PARAMS_PASSED

#define READ_IN_MUTABLE_PARAMS \
    std::uint64_t aPrevious = 0U; \
    std::uint64_t aIngress = *pIngress; \
    std::uint64_t aCarry = *pCarry; \
    std::uint64_t aWandererA = *pWandererA; \
    std::uint64_t aWandererB = *pWandererB; \
    std::uint64_t aWandererC = *pWandererC; \
    std::uint64_t aWandererD = *pWandererD; \
    std::uint64_t aWandererE = *pWandererE; \
    std::uint64_t aWandererF = *pWandererF; \
    std::uint64_t aWandererG = *pWandererG; \
    std::uint64_t aWandererH = *pWandererH; \
    std::uint64_t aWandererI = *pWandererI; \
    std::uint64_t aWandererJ = *pWandererJ; \
    std::uint64_t aWandererK = *pWandererK

#define WRITE_OUT_MUTABLE_PARAMS \
    *pIngress = aIngress; \
    *pCarry = aCarry; \
    *pWandererA = aWandererA; \
    *pWandererB = aWandererB; \
    *pWandererC = aWandererC; \
    *pWandererD = aWandererD; \
    *pWandererE = aWandererE; \
    *pWandererF = aWandererF; \
    *pWandererG = aWandererG; \
    *pWandererH = aWandererH; \
    *pWandererI = aWandererI; \
    *pWandererJ = aWandererJ; \
    *pWandererK = aWandererK

inline void TwistKeyFoldBlock(const std::uint8_t *pSourceLaneA,
                              const std::size_t pSourceBlockA,
                              const std::size_t pSourceOffsetA,
                              const std::uint8_t *pSourceLaneB,
                              const std::size_t pSourceBlockB,
                              const std::size_t pSourceOffsetB,
                              std::uint8_t *pDestinationLane,
                              const std::size_t pDestinationBlock) {
    constexpr std::size_t kKeyFoldBlockSize = 512U;
    static_assert((kKeyFoldBlockSize & (kKeyFoldBlockSize - 1U)) == 0U,
                  "Key fold block size must be a power of two.");
    const std::uint8_t *aSourceA =
        pSourceLaneA + (pSourceBlockA * kKeyFoldBlockSize);
    const std::uint8_t *aSourceB =
        pSourceLaneB + (pSourceBlockB * kKeyFoldBlockSize);
    std::uint8_t *aDestination =
        pDestinationLane + (pDestinationBlock * kKeyFoldBlockSize);
    for (std::size_t aIndex = 0U;
         aIndex < kKeyFoldBlockSize;
         ++aIndex) {
        const std::size_t aSourceIndexA =
            (aIndex + pSourceOffsetA) & (kKeyFoldBlockSize - 1U);
        const std::size_t aSourceIndexB =
            (aIndex + pSourceOffsetB) & (kKeyFoldBlockSize - 1U);
        std::uint16_t aFoldValue =
            static_cast<std::uint16_t>(aSourceA[aSourceIndexA]);
        aFoldValue |=
            static_cast<std::uint16_t>(aSourceB[aSourceIndexB]) << 8U;
        aFoldValue = TwistMix16::DiffuseA(aFoldValue);
        aDestination[aIndex] = static_cast<std::uint8_t>(aFoldValue);
    }
}

#define KEY_FOLD_BLOCK(pSourceLaneA, pSourceBlockA, pSourceOffsetA, \
                       pSourceLaneB, pSourceBlockB, pSourceOffsetB, \
                       pDestinationLane, pDestinationBlock) \
    TwistKeyFoldBlock((pSourceLaneA), (pSourceBlockA), (pSourceOffsetA), \
                      (pSourceLaneB), (pSourceBlockB), (pSourceOffsetB), \
                      (pDestinationLane), (pDestinationBlock))



class TwistExpander {
public:
    
    TwistExpander();
    
    virtual ~TwistExpander();
    
    static void                             UnrollPassword(std::uint8_t *pSourceLane,
                                                           std::uint8_t *pPassword,
                                                           std::size_t pPasswordByteLength);
    static void                             UnrollPassword(std::uint8_t *pSourceLane,
                                                           std::uint8_t *pPassword,
                                                           std::size_t pPasswordByteLength,
                                                           std::size_t pSourceLaneByteLength);
    static void                             UnrollNonce(std::uint8_t *pNonceLane,
                                                        std::uint64_t pNonce);
    
    virtual void                            KDF(std::uint64_t pNonce,
                                                TwistDomainConstants *pDomainConstants,
                                                TwistDomainSaltSet *pDomainSaltSet);
    
    virtual void                            Seed(TwistWorkSpace *pWorkSpace,
                                                 std::uint64_t pNonce,
                                                 std::uint8_t *pPassword,
                                                 std::size_t pPasswordByteLength,
                                                 std::uint8_t *pDestination,
                                                 MUTABLE_PARAMS);

    virtual void                            TwistBlock(TwistWorkSpace *pWorkSpace,
                                                       std::uint8_t *pSource,
                                                       std::uint8_t *pCrossLaneA,
                                                       std::uint8_t *pCrossLaneB,
                                                       std::uint8_t *pCrossLaneC,
                                                       std::uint8_t *pCrossLaneD,
                                                       std::uint8_t *pDestination,
                                                       bool pStifleKey,
                                                       MUTABLE_PARAMS);

    virtual void                            GrowKeyA(TwistWorkSpace *pWorkSpace,
                                                     std::uint8_t *pCrossLaneA,
                                                     std::uint8_t *pCrossLaneB,
                                                     MUTABLE_PARAMS);
    virtual void                            GrowKeyB(TwistWorkSpace *pWorkSpace,
                                                     std::uint8_t *pCrossLaneA,
                                                     std::uint8_t *pCrossLaneB,
                                                     MUTABLE_PARAMS);
    
    
    // this is not virtual, it calls TwistBlock on every block
    void                                    Twist(TwistWorkSpace *pWorkSpace,
                                                  std::uint8_t *pSource,
                                                  std::uint8_t *pCrossLaneA,
                                                  std::uint8_t *pCrossLaneB,
                                                  std::uint8_t *pCrossLaneC,
                                                  std::uint8_t *pCrossLaneD,
                                                  std::uint8_t *pDestination,
                                                  std::size_t pDestinationByteLength,
                                                  MUTABLE_PARAMS);
    
    void                                    AutoSeedThenTwist(TwistWorkSpace *pWorkSpace,
                                                              std::uint64_t pNonce,
                                                              std::uint8_t *pPassword,
                                                              std::size_t pPasswordByteLength,
                                                              std::uint8_t *pCrossLaneA,
                                                              std::uint8_t *pCrossLaneB,
                                                              std::uint8_t *pCrossLaneC,
                                                              std::uint8_t *pCrossLaneD,
                                                              std::uint8_t *pDestination,
                                                              std::size_t pDestinationByteLength,
                                                              MUTABLE_PARAMS);
    
    // Assumes the work space is seeded...
    // Assumes pSource has at least S_BLOCK bytes...
    void                                    AutoTwist(TwistWorkSpace *pWorkSpace,
                                                      std::uint8_t *pSource,
                                                      std::uint8_t *pCrossLaneA,
                                                      std::uint8_t *pCrossLaneB,
                                                      std::uint8_t *pCrossLaneC,
                                                      std::uint8_t *pCrossLaneD,
                                                      std::uint8_t *pDestination,
                                                      std::size_t pDestinationByteLength,
                                                      MUTABLE_PARAMS);
    
    M88                                     mMatrix;
    
    TwistDomainBundle                       *GetDomainBundleInbuilt() {
        return &mDomainBundleInbuilt;
    }
    const TwistDomainBundle                 *GetDomainBundleInbuilt() const {
        return &mDomainBundleInbuilt;
    }
    TwistDomainBundle                       *GetDomainBundleEphemeralA() {
        return &mDomainBundleEphemeralA;
    }
    const TwistDomainBundle                 *GetDomainBundleEphemeralA() const {
        return &mDomainBundleEphemeralA;
    }
    TwistDomainBundle                       *GetDomainBundleEphemeralB() {
        return &mDomainBundleEphemeralB;
    }
    const TwistDomainBundle                 *GetDomainBundleEphemeralB() const {
        return &mDomainBundleEphemeralB;
    }
    
    void                                    Zero_PostSeed();
    
    void                                    Zero();
    
protected:
    
    TwistDomainBundle                       mDomainBundleInbuilt;
    TwistDomainBundle                       mDomainBundleEphemeralA;
    TwistDomainBundle                       mDomainBundleEphemeralB;
    
};


#endif /* TwistExpander_hpp */
