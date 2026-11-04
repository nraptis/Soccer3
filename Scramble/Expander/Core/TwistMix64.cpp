//
//  TwistMix64.cpp
//  MeanMachine
//
//  Created by Icarus Black on 5/1/26.
//

#include "TwistMix64.hpp"

std::uint64_t TwistMix64::DiffuseA(std::uint64_t pValue) {
    pValue ^= (pValue >> 30);
    pValue *= 0xBF58476D1CE4E5B9ULL;
    pValue ^= (pValue >> 27);
    pValue *= 0x94D049BB133111EBULL;
    pValue ^= (pValue >> 31);
    return pValue;
}

std::uint64_t TwistMix64::DiffuseB(std::uint64_t pValue) {
    pValue ^= pValue >> 33;
    pValue *= 0xFF51AFD7ED558CCDULL;
    pValue ^= pValue >> 33;
    pValue *= 0xC4CEB9FE1A85EC53ULL;
    pValue ^= pValue >> 33;
    return pValue;
}

std::uint64_t TwistMix64::DiffuseC(std::uint64_t pValue) {
    pValue ^= pValue >> 33;
    pValue *= 0x62A9D9ED799705F5ULL;
    pValue ^= pValue >> 28;
    pValue *= 0xCB24D0A5C88C35B3ULL;
    pValue ^= pValue >> 32;
    return pValue;
}
