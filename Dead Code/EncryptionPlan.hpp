//
//  EncryptionPlan.hpp
//  Scramble
//
//  Created by Icarus Black on 8/4/26.
//

#ifndef EncryptionPlan_hpp
#define EncryptionPlan_hpp

#include "SoccerTypes.hpp"
#include <cstddef>
#include <cstdint>

struct EncryptionPlanStage {
    CipherType          mType[12];
    CipherSamplingBank  mSamplingBank[12] = {};
    std::uint8_t        mRotationIndex[12] = {}; // Fixed per-layer rotation slot 0 or 1.
    std::size_t         mCount = 0;
};

struct EncryptionPlan {
    
    EncryptionPlanStage             mL3A;
    EncryptionPlanStage             mL2A;
    EncryptionPlanStage             mL1A;
    
    EncryptionPlanStage             mL3B;
    EncryptionPlanStage             mL2B;
    EncryptionPlanStage             mL1B;
    
    EncryptionPlanStage             mL3C;
    EncryptionPlanStage             mL2C;
    EncryptionPlanStage             mL1C;

};

class EncryptionPlanTool {
    
public:
    /*
     Plans are spelled out per layer and strength in EncryptionPlan.cpp.
     Each layer: Frog triplet -> optional mutate -> masked rotation ->
     BitRotationThreeCipher -> optional second mutate. L1C omits the bit rotation.
     The triplet alternates A/B/A and B/A/B on successive layers and partitions
     all eight rows. The masked rotation uses the first Frog's protected rows.
     Across L3/L2/L1 those base masks partition all eight rows as well.
     Farmed rows/masks rotate by 0/3/6 within each group; reset the mask offset
     at L3B and L3C without undoing the data's accumulated bit rotations.

     All strengths: 27 Frogs, 9 masked rotations, 8 full-byte bit rotations.
     Weak/normal/strong add 4/7/14 mutations (48/51/58 ciphers in total),
     with the existing 4/8/16 MiB material budgets. No legacy mask entries used.
     */

    // Mover arguments are retained for callers of the previous plan API.
    static EncryptionPlan               MakePlan(EncryptionStrength pStrength,
                                                  std::uint64_t pLaneSelect,
                                                  const CipherType (&pShuffledMutate)[32],
                                                  const CipherType (&pShuffledPrimaryMovers)[32],
                                                  const CipherType (&pShuffledSecondaryMovers)[32]);

    // Legacy mask-bank support. Derived bit-plane masks do not consume or
    // rotate these entries. Reject invalid counts before modifying masks.
    static bool                         RotateMasksForPlan(const EncryptionPlan &pPlan,
                                                            std::uint8_t *pMasks,
                                                            std::size_t pMaskCount);

    static EncryptionPlan               MakePlanWeak(std::uint64_t pLaneSelect,
                                                     const CipherType (&pShuffledMutate)[32],
                                                     const CipherType (&pShuffledPrimaryMovers)[32],
                                                     const CipherType (&pShuffledSecondaryMovers)[32]);
    static EncryptionPlan               MakePlanNormal(std::uint64_t pLaneSelect,
                                                       const CipherType (&pShuffledMutate)[32],
                                                       const CipherType (&pShuffledPrimaryMovers)[32],
                                                       const CipherType (&pShuffledSecondaryMovers)[32]);
    static EncryptionPlan               MakePlanStrong(std::uint64_t pLaneSelect,
                                                       const CipherType (&pShuffledMutate)[32],
                                                       const CipherType (&pShuffledPrimaryMovers)[32],
                                                       const CipherType (&pShuffledSecondaryMovers)[32]);

private:
    // Scan the single mutate pool by lane count, advancing the shared cursor.
    // A missing lane count uses that budget's deterministic fallback cipher.
    static CipherType RingFetchMutate(const CipherType (&pShuffledMutate)[32],
                                     std::uint8_t pLaneCount,
                                     std::size_t *pIndex);
};

#endif /* EncryptionPlan_hpp */
