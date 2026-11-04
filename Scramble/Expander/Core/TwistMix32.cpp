//
//  TwistMix32.cpp
//  MeanMachine
//
//  Created by icarus black on 6/21/26.
//


#include "TwistMix32.hpp"

std::uint32_t TwistMix32::DiffuseA(std::uint32_t pValue) {
    pValue ^= pValue >> 16;
    pValue *= 0x85ebca6b;
    pValue ^= pValue >> 13;
    pValue *= 0xc2b2ae35;
    pValue ^= pValue >> 16;
    return pValue;
}

std::uint32_t TwistMix32::DiffuseB(std::uint32_t pValue) {
    pValue ^= pValue >> 16;
    pValue *= 0x21f0aaad;
    pValue ^= pValue >> 15;
    pValue *= 0x735a2d97;
    pValue ^= pValue >> 15;
    return pValue;
}

std::uint32_t TwistMix32::DiffuseC(std::uint32_t pValue) {
    pValue ^= pValue >> 16;
    pValue *= 0x7feb352d;
    pValue ^= pValue >> 15;
    pValue *= 0x846ca68b;
    pValue ^= pValue >> 16;
    return pValue;
}
