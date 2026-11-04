#ifndef SOCCER_BIT_PLANE_ROW_HPP_
#define SOCCER_BIT_PLANE_ROW_HPP_

#include "BitPlanePair.hpp"

struct BitPlaneRow {
    // Left to right: grid columns A, B, C, D. Together these cover bits 0..7.
    BitPlanePair mPairs[4];
    bool operator==(const BitPlaneRow &) const = default;
};

static_assert(sizeof(BitPlaneRow) == 8U);

#endif // SOCCER_BIT_PLANE_ROW_HPP_
