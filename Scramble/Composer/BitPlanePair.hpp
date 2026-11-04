#ifndef SOCCER_BIT_PLANE_PAIR_HPP_
#define SOCCER_BIT_PLANE_PAIR_HPP_

#include <cstdint>

// Bit positions in a byte, not grid coordinates. Farmed pairs are ascending
// and have circular distance >= 2; {0,7} and other adjacent pairs are forbidden.
struct BitPlanePair {
    std::uint8_t mBitA;
    std::uint8_t mBitB;
    bool operator==(const BitPlanePair &) const = default;
};

static_assert(sizeof(BitPlanePair) == 2U);

#endif // SOCCER_BIT_PLANE_PAIR_HPP_
