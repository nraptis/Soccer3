#include "BitPlane.hpp"

#include <cstddef>
#include <cassert>

bool BitPlane::IsValid() const {
    unsigned aRowMasks[4]{};
    for (const auto &aColumn : mColumns) {
        unsigned aColumnMask = 0U;
        for (std::size_t aRow = 0U; aRow < 4U; ++aRow) {
            const auto &aPair = aColumn.mPairs[aRow];
            if (aPair.mBitA >= 8U || aPair.mBitB >= 8U) return false;
            const unsigned aDistance = (aPair.mBitA + 8U - aPair.mBitB) % 8U;
            if (aDistance < 2U || aDistance > 6U) return false;
            const unsigned aMask = (1U << aPair.mBitA) | (1U << aPair.mBitB);
            if ((aRowMasks[aRow] & aMask) != 0U || (aColumnMask & aMask) != 0U) return false;
            aRowMasks[aRow] |= aMask;
            aColumnMask |= aMask;
        }
        if (aColumnMask != 255U) return false;
    }
    for (const auto aMask : aRowMasks) if (aMask != 255U) return false;
    return true;
}

void BitPlane::SwapRows(std::uint64_t pSeed) {
    
    std::size_t aPermutation[4];
    SelectPermutation(aPermutation, pSeed);
    
    BitPlaneRow aRowA = GetRow(0);
    BitPlaneRow aRowB = GetRow(1);
    BitPlaneRow aRowC = GetRow(2);
    BitPlaneRow aRowD = GetRow(3);
    
    SetRow(aPermutation[0], aRowA);
    SetRow(aPermutation[1], aRowB);
    SetRow(aPermutation[2], aRowC);
    SetRow(aPermutation[3], aRowD);
}

void BitPlane::SwapColumns(std::uint64_t pSeed) {
    
    std::size_t aPermutation[4];
    SelectPermutation(aPermutation, pSeed);
    
    BitPlaneColumn aColA = GetCol(0);
    BitPlaneColumn aColB = GetCol(1);
    BitPlaneColumn aColC = GetCol(2);
    BitPlaneColumn aColD = GetCol(3);
    
    SetCol(aPermutation[0], aColA);
    SetCol(aPermutation[1], aColB);
    SetCol(aPermutation[2], aColC);
    SetCol(aPermutation[3], aColD);
}

BitPlaneRow BitPlane::GetRow(std::size_t pRowIndex) const {
    assert(pRowIndex < 4U);
    BitPlaneRow aResult;
    aResult.mPairs[0] = mColumns[0].mPairs[pRowIndex];
    aResult.mPairs[1] = mColumns[1].mPairs[pRowIndex];
    aResult.mPairs[2] = mColumns[2].mPairs[pRowIndex];
    aResult.mPairs[3] = mColumns[3].mPairs[pRowIndex];
    return aResult;
}

void BitPlane::SetRow(std::size_t pRowIndex, const BitPlaneRow &pRow) {
    assert(pRowIndex < 4U);
    mColumns[0].mPairs[pRowIndex] = pRow.mPairs[0];
    mColumns[1].mPairs[pRowIndex] = pRow.mPairs[1];
    mColumns[2].mPairs[pRowIndex] = pRow.mPairs[2];
    mColumns[3].mPairs[pRowIndex] = pRow.mPairs[3];
}

BitPlaneColumn BitPlane::GetCol(std::size_t pColumnIndex) const {
    assert(pColumnIndex < 4U);
    return mColumns[pColumnIndex];
}

void BitPlane::SetCol(std::size_t pColumnIndex, const BitPlaneColumn &pColumn) {
    assert(pColumnIndex < 4U);
    mColumns[pColumnIndex] = pColumn;
}

void BitPlane::SelectPermutation(std::size_t pPermutation[4], std::uint64_t pSeed) {
    assert(pPermutation != nullptr);
    // Destination indices for original A, B, C, D. These preserve the
    // previous seed-to-order mapping, including identity at rank 23.
    static constexpr std::uint8_t kPermutations[24][4] = {
        {3U, 0U, 1U, 2U}, // 0
        {2U, 3U, 1U, 0U}, // 1
        {2U, 0U, 3U, 1U}, // 2
        {2U, 0U, 1U, 3U}, // 3
        {3U, 2U, 0U, 1U}, // 4
        {1U, 3U, 0U, 2U}, // 5
        {1U, 2U, 3U, 0U}, // 6
        {1U, 2U, 0U, 3U}, // 7
        {3U, 0U, 2U, 1U}, // 8
        {1U, 3U, 2U, 0U}, // 9
        {1U, 0U, 3U, 2U}, // 10
        {1U, 0U, 2U, 3U}, // 11
        {3U, 1U, 0U, 2U}, // 12
        {2U, 3U, 0U, 1U}, // 13
        {2U, 1U, 3U, 0U}, // 14
        {2U, 1U, 0U, 3U}, // 15
        {3U, 2U, 1U, 0U}, // 16
        {0U, 3U, 1U, 2U}, // 17
        {0U, 2U, 3U, 1U}, // 18
        {0U, 2U, 1U, 3U}, // 19
        {3U, 1U, 2U, 0U}, // 20
        {0U, 3U, 2U, 1U}, // 21
        {0U, 1U, 3U, 2U}, // 22
        {0U, 1U, 2U, 3U}, // 23
    };
    const auto &aPermutation = kPermutations[pSeed % 24U];
    pPermutation[0] = aPermutation[0];
    pPermutation[1] = aPermutation[1];
    pPermutation[2] = aPermutation[2];
    pPermutation[3] = aPermutation[3];
}
