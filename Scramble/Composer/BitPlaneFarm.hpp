#ifndef SOCCER_BIT_PLANE_DATA_FARM_HPP_
#define SOCCER_BIT_PLANE_DATA_FARM_HPP_

#include "BitPlane.hpp"
#include <cstddef>

// The exhaustive tool writes the bank. Selection copies a representative
// and independently permutes its rows and columns using the supplied words.
struct BitPlaneFarm {
    inline static constexpr BitPlane mBitPlanes[] = {
#include "BitPlaneFarmData.inc"
    };
    static constexpr std::size_t kBitPlaneCount = sizeof(mBitPlanes) / sizeof(mBitPlanes[0]);
    
    // mBitPlanes[pPlaneSelectWord % kBitPlaneCount]
    // row permutation: pRowWord % 24
    // column permutation: pColumnWord % 24
    // Requires a valid result pointer. The bank itself is never modified.
    static void                 Select(std::uint64_t pPlaneSelectWord,
                                       std::uint64_t pRowWord,
                                       std::uint64_t pColumnWord,
                                       BitPlane *pResultBitPlane);
    
};

#endif // SOCCER_BIT_PLANE_DATA_FARM_HPP_
