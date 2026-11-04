//
//  TwistMix32.hpp
//  MeanMachine
//
//  Created by icarus black on 6/21/26.
//

#ifndef TwistMix32_hpp
#define TwistMix32_hpp

#include "TwistWorkSpace.hpp"
#include "TwistFunctional.hpp"

class TwistMix32 {

public:
    static std::uint32_t                        DiffuseA(std::uint32_t pValue);
    static std::uint32_t                        DiffuseB(std::uint32_t pValue);
    static std::uint32_t                        DiffuseC(std::uint32_t pValue);
    
};

#endif
