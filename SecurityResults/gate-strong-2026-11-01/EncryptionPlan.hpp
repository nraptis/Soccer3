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
     All strengths use all nine Cryptex9 layers. Every layer has two Gates
     with at least one existing mover between them. The first and last former
     samplers become Gates; the middle sampler is removed. All mutator choices,
     mover choices, rotations and their relative ordering are preserved.
     Strong retains its leading rotation on every layer.

     Weak:   18 Gates, 9 rotations,  4 mutations,  9 movers = 40 slots.
     Normal: 18 Gates, 9 rotations,  7 mutations, 12 movers = 46 slots.
     Strong: 18 Gates, 9 rotations, 14 mutations,  9 movers = 50 slots.
     Mask budgets remain 9/12/13; material budgets remain 4/8/16 MiB.
     Gate uses no material or bank mask. Sampling factories and the seed layout
     are retained for comparisons; these plans do not use the sampling banks.
     */

    // Movers use fixed slots in their shuffled pools. Only mutate selection
    // advances a ring cursor; rotations and Gates use fixed IDs.
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
