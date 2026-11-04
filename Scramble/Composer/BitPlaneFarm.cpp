#include "BitPlaneFarm.hpp"

void BitPlaneFarm::Select(std::uint64_t pPlaneSelectWord,
                          std::uint64_t pRowWord,
                          std::uint64_t pColumnWord,
                          BitPlane *pResultBitPlane) {
    *pResultBitPlane = mBitPlanes[pPlaneSelectWord % kBitPlaneCount];
    pResultBitPlane->SwapRows(pRowWord);
    pResultBitPlane->SwapColumns(pColumnWord);
}
