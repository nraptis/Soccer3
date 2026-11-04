#ifndef SOCCER_BIT_PLANE_COLUMN_HPP_
#define SOCCER_BIT_PLANE_COLUMN_HPP_

#include "BitPlanePair.hpp"

struct BitPlaneColumn {
    // Top to bottom: grid rows a, b, c, d. Together these cover bits 0..7.
    BitPlanePair mPairs[4];
    bool operator==(const BitPlaneColumn &) const = default;
};

static_assert(sizeof(BitPlaneColumn) == 8U);

#endif // SOCCER_BIT_PLANE_COLUMN_HPP_
