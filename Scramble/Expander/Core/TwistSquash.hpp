//
//  TwistSquash.hpp
//  MeanMachine
//
//  Created by icarus black on 6/23/26.
//

#ifndef TwistSquash_hpp
#define TwistSquash_hpp

#include <cstdint>
#include "TwistWorkSpace.hpp"

class TwistSquash {
    
public:
    
    static void             SquashA(std::uint8_t *pInputLaneA,
                                    std::uint8_t *pInputLaneB,
                                    std::uint8_t *pInputLaneC,
                                    std::uint8_t *pInputLaneD,
                                    std::uint8_t *pOutputLane);
    static void             SquashB(std::uint8_t *pInputLaneA,
                                    std::uint8_t *pInputLaneB,
                                    std::uint8_t *pInputLaneC,
                                    std::uint8_t *pInputLaneD,
                                    std::uint8_t *pOutputLane);
    static void             SquashC(std::uint8_t *pInputLaneA,
                                    std::uint8_t *pInputLaneB,
                                    std::uint8_t *pInputLaneC,
                                    std::uint8_t *pInputLaneD,
                                    std::uint8_t *pOutputLane);

    static void             SquashKeyA(std::uint8_t *pInputLaneA,
                                       std::uint8_t *pInputLaneB,
                                       std::uint8_t *pInputLaneC,
                                       std::uint8_t *pInputLaneD,
                                       std::uint8_t *pOutputKeyRow);
    
};


#endif /* TwistSquash_hpp */
