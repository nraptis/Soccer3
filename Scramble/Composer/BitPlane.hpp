#ifndef SOCCER_BIT_PLANE_HPP_
#define SOCCER_BIT_PLANE_HPP_

#include "BitPlaneColumn.hpp"
#include "BitPlaneRow.hpp"
#include <cstddef>

struct BitPlane {
    // Left to right: columns A, B, C, D. A grid cell is mColumns[column].mPairs[row].
    // Every complete row AND column covers bits 0..7 exactly once.
    BitPlaneColumn mColumns[4];

    // Indices are 0..3. Getters return copies, so all four rows/columns can
    // be saved before writing them back in a different order.
    BitPlaneRow GetRow(std::size_t pRowIndex) const;
    void SetRow(std::size_t pRowIndex, const BitPlaneRow &pRow);
    BitPlaneColumn GetCol(std::size_t pColumnIndex) const;
    void SetCol(std::size_t pColumnIndex, const BitPlaneColumn &pColumn);

    // Output entry i is the DESTINATION of original row/column i.
    // pPermutation must point to four writable entries.
    static void SelectPermutation(std::size_t pPermutation[4], std::uint64_t pSeed);

    // pSeed % 24 chooses a permutation (23 is identity). Every 64-bit value
    // is accepted; modulo reduction has a tiny remainder bias. These operate
    // on the current ordering, so repeated calls compose. Pairs stay intact.
    void SwapRows(std::uint64_t pSeed);
    void SwapColumns(std::uint64_t pSeed);

    bool IsValid() const;

    bool operator==(const BitPlane &) const = default;
};

static_assert(sizeof(BitPlane) == 32U);

#endif // SOCCER_BIT_PLANE_HPP_
