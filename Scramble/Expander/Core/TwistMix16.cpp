//
//  TwistMix16.cpp
//  MeanMachine
//
//  Created by icarus black on 8/6/26.
//

#include "TwistMix16.hpp"

std::uint16_t TwistMix16::DiffuseA(std::uint16_t pValue) {
    pValue ^= pValue >> 8U;
    pValue *= 0xD255U;
    pValue ^= pValue >> 5U;
    pValue *= 0xED45U;
    pValue ^= pValue >> 8U;
    return pValue;
}
