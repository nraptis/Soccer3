//
//  TwistMix64.hpp
//  MeanMachine
//
//  Created by Icarus Black on 5/1/26.
//

#ifndef TwistMix64_hpp
#define TwistMix64_hpp

#include <cstdint>

class TwistMix64 {
public:
    static std::uint64_t                        DiffuseA(std::uint64_t pValue);
    static std::uint64_t                        DiffuseB(std::uint64_t pValue);
    static std::uint64_t                        DiffuseC(std::uint64_t pValue);
};

#endif /* TwistMix64_hpp */
