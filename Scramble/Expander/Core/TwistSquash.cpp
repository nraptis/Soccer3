//
//  TwistSquash.cpp
//  MeanMachine
//
//  Created by icarus black on 6/23/26.
//

#include "TwistSquash.hpp"
#include "TwistMix32.hpp"

void TwistSquash::SquashA(std::uint8_t *pInputLaneA,
                          std::uint8_t *pInputLaneB,
                          std::uint8_t *pInputLaneC,
                          std::uint8_t *pInputLaneD,
                          std::uint8_t *pOutputLane) {
    for (std::size_t aIndex = 0U; aIndex < static_cast<std::size_t>(S_BLOCK); aIndex += 1U) {
        std::uint32_t aSquash = static_cast<std::uint32_t>(pInputLaneA[aIndex]);
        aSquash |= static_cast<std::uint32_t>(pInputLaneB[aIndex]) << 8U;
        aSquash |= static_cast<std::uint32_t>(pInputLaneC[aIndex]) << 16U;
        aSquash |= static_cast<std::uint32_t>(pInputLaneD[aIndex]) << 24U;
        aSquash ^= aSquash >> 16U;
        aSquash *= 0x85EBCA6BU;
        aSquash ^= aSquash >> 13U;
        aSquash *= 0xC2B2AE35U;
        aSquash ^= aSquash >> 16U;
        pOutputLane[aIndex] = static_cast<std::uint8_t>(aSquash);
    }
}

void TwistSquash::SquashB(std::uint8_t *pInputLaneA,
                          std::uint8_t *pInputLaneB,
                          std::uint8_t *pInputLaneC,
                          std::uint8_t *pInputLaneD,
                          std::uint8_t *pOutputLane) {
    for (std::size_t aIndex = 0U; aIndex < static_cast<std::size_t>(S_BLOCK); aIndex += 1U) {
        std::uint32_t aSquash = static_cast<std::uint32_t>(pInputLaneA[aIndex]);
        aSquash |= static_cast<std::uint32_t>(pInputLaneB[aIndex]) << 8U;
        aSquash |= static_cast<std::uint32_t>(pInputLaneC[aIndex]) << 16U;
        aSquash |= static_cast<std::uint32_t>(pInputLaneD[aIndex]) << 24U;
        aSquash ^= aSquash >> 16U;
        aSquash *= 0x21F0AAADU;
        aSquash ^= aSquash >> 15U;
        aSquash *= 0x735A2D97U;
        aSquash ^= aSquash >> 15U;
        pOutputLane[aIndex] = static_cast<std::uint8_t>(aSquash);
    }
}

void TwistSquash::SquashC(std::uint8_t *pInputLaneA,
                          std::uint8_t *pInputLaneB,
                          std::uint8_t *pInputLaneC,
                          std::uint8_t *pInputLaneD,
                          std::uint8_t *pOutputLane) {
    for (std::size_t aIndex = 0U; aIndex < static_cast<std::size_t>(S_BLOCK); aIndex += 1U) {
        std::uint32_t aSquash = static_cast<std::uint32_t>(pInputLaneA[aIndex]);
        aSquash |= static_cast<std::uint32_t>(pInputLaneB[aIndex]) << 8U;
        aSquash |= static_cast<std::uint32_t>(pInputLaneC[aIndex]) << 16U;
        aSquash |= static_cast<std::uint32_t>(pInputLaneD[aIndex]) << 24U;
        aSquash ^= aSquash >> 16U;
        aSquash *= 0x7FEB352DU;
        aSquash ^= aSquash >> 15U;
        aSquash *= 0x846CA68BU;
        aSquash ^= aSquash >> 16U;
        pOutputLane[aIndex] = static_cast<std::uint8_t>(aSquash);
    }
}

void TwistSquash::SquashKeyA(std::uint8_t *pInputLaneA,
                             std::uint8_t *pInputLaneB,
                             std::uint8_t *pInputLaneC,
                             std::uint8_t *pInputLaneD,
                             std::uint8_t *pOutputKeyRow) {
    for (std::size_t aIndex = 0U;
         aIndex < static_cast<std::size_t>(W_KEY);
         aIndex += 1U) {
        std::uint32_t aSquash =
        static_cast<std::uint32_t>(pInputLaneA[aIndex]);
        aSquash |=
        static_cast<std::uint32_t>(pInputLaneB[aIndex]) << 8U;
        aSquash |=
        static_cast<std::uint32_t>(pInputLaneC[aIndex]) << 16U;
        aSquash |=
        static_cast<std::uint32_t>(pInputLaneD[aIndex]) << 24U;
        aSquash = TwistMix32::DiffuseA(aSquash);
        pOutputKeyRow[aIndex] = static_cast<std::uint8_t>(aSquash);
    }
}
