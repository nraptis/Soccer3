//
//  TwistFarm.hpp
//  MeanMachine
//
//  Created by nicholas on 5/23/26.
//

#ifndef TwistFarm_hpp
#define TwistFarm_hpp

#include <cstdint>
#include "TwistWorkSpace.hpp"

class TwistFarm {
public:
    static void                 Farm(const std::uint8_t *pSaltLaneA,
                                     const std::uint8_t *pSaltLaneB,
                                     const std::uint8_t *pSaltLaneC,
                                     const std::uint8_t *pConstantLane,
                                     std::uint8_t *pFoldLaneA,
                                     std::uint8_t *pFoldLaneB,
                                     std::uint8_t *pFoldLaneC,
                                     TwistDomainSaltSet *pSaltSet,
                                     TwistDomainConstants *pConstants);

private:
    static void                 FarmSalts(const std::uint8_t *pSourceLaneA,
                                          const std::uint8_t *pSourceLaneB,
                                          const std::uint8_t *pSourceLaneC,
                                          TwistDomainSaltSet *pSaltSet);

    static void                 FarmConstants(const std::uint8_t *pSource,
                                              std::uint8_t *pFoldLaneA,
                                              std::uint8_t *pFoldLaneB,
                                              std::uint8_t *pFoldLaneC,
                                              TwistDomainConstants *pConstants);
};

#endif /* TwistFarm_hpp */
