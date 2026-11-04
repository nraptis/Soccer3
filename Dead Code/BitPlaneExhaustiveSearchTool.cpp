#include "BitPlaneExhaustiveSearchTool.hpp"

#include <algorithm>
#include <new>

namespace {

unsigned PairMask(const BitPlanePair &pPair) {
    return (1U << pPair.mBitA) | (1U << pPair.mBitB);
}

BitPlanePair PairFromMask(unsigned pMask) {
    BitPlanePair aPair{};
    bool aFirst = true;
    for (unsigned aBit = 0U; aBit < 8U; ++aBit) {
        if ((pMask & (1U << aBit)) == 0U) continue;
        if (aFirst) aPair.mBitA = static_cast<std::uint8_t>(aBit);
        else aPair.mBitB = static_cast<std::uint8_t>(aBit);
        aFirst = false;
    }
    return aPair;
}

bool Less(const BitPlaneExhaustiveSearchTool::Hashes &pFirst,
          const BitPlaneExhaustiveSearchTool::Hashes &pSecond) {
    return std::lexicographical_compare(pFirst.mColumns, pFirst.mColumns + 4U,
                                        pSecond.mColumns, pSecond.mColumns + 4U);
}

void PrintGrid(std::FILE *pStream, const BitPlane &pPlane, const char *pPrefix) {
    for (std::size_t aRow = 0U; aRow < 4U; ++aRow) {
        std::fprintf(pStream, "%s%c:", pPrefix, static_cast<int>('a' + aRow));
        for (const auto &aColumn : pPlane.mColumns) {
            const auto &aPair = aColumn.mPairs[aRow];
            std::fprintf(pStream, " [%u %u]", static_cast<unsigned>(aPair.mBitA),
                         static_cast<unsigned>(aPair.mBitB));
        }
        std::fputc('\n', pStream);
    }
}

} // namespace

bool BitPlaneExhaustiveSearchTool::IsValid(const BitPlane &pBitPlane) {
    unsigned aRows[4]{};
    for (const auto &aColumn : pBitPlane.mColumns) {
        unsigned aColumnMask = 0U;
        for (std::size_t aRow = 0U; aRow < 4U; ++aRow) {
            const auto &aPair = aColumn.mPairs[aRow];
            if (aPair.mBitA >= 8U || aPair.mBitB >= 8U) return false;
            const unsigned aDistance = (aPair.mBitA + 8U - aPair.mBitB) % 8U;
            if (aDistance < 2U || aDistance > 6U) return false;
            const unsigned aMask = PairMask(aPair);
            if ((aRows[aRow] & aMask) != 0U || (aColumnMask & aMask) != 0U) return false;
            aRows[aRow] |= aMask;
            aColumnMask |= aMask;
        }
        if (aColumnMask != 255U) return false;
    }
    for (const auto aRow : aRows) if (aRow != 255U) return false;
    return true;
}

bool BitPlaneExhaustiveSearchTool::MakeHashes(const BitPlane &pBitPlane, Hashes &pHashes) {
    pHashes = {};
    if (!IsValid(pBitPlane)) return false;
    std::uint8_t aRows[4] = {0U, 1U, 2U, 3U};
    bool aFirst = true;
    do {
        Hashes aHashes{};
        for (std::size_t aColumn = 0U; aColumn < 4U; ++aColumn) {
            for (const auto aRow : aRows) {
                aHashes.mColumns[aColumn] = (aHashes.mColumns[aColumn] << 8U) |
                    PairMask(pBitPlane.mColumns[aColumn].mPairs[aRow]);
            }
        }
        std::sort(aHashes.mColumns, aHashes.mColumns + 4U);
        if (aFirst || Less(aHashes, pHashes)) pHashes = aHashes;
        aFirst = false;
    } while (std::next_permutation(aRows, aRows + 4U));
    return true;
}

bool BitPlaneExhaustiveSearchTool::Run() {
    mComplete = false;
    mBitPlaneCount = 0U;
    mNormalizedPlaneCount = 0U;
    mCandidate = {};
    std::fill(mColumnMasks, mColumnMasks + 4U, 0U);
    std::fill(mAllowedMasks, mAllowedMasks + 256U, false);
    if (!mEntries) mEntries.reset(new (std::nothrow) Entry[kMaximumPlaneCount]);
    if (!mEntries) return false;

    std::size_t aCount = 0U;
    for (unsigned aBitA = 0U; aBitA < 8U; ++aBitA) {
        for (unsigned aBitB = aBitA + 2U; aBitB < 8U; ++aBitB) {
            if (aBitB - aBitA > 6U) continue;
            const unsigned aMask = (1U << aBitA) | (1U << aBitB);
            mPairMasks[aCount++] = static_cast<std::uint8_t>(aMask);
            mAllowedMasks[aMask] = true;
        }
    }
    if (aCount != 20U) return false;
    std::sort(mPairMasks, mPairMasks + 20U);
    mComplete = Visit(0U, 0U);
    return mComplete;
}

bool BitPlaneExhaustiveSearchTool::Visit(std::size_t pCell, unsigned pRowMask) {
    if (pCell == 12U) {
        unsigned aLastRowMask = 0U;
        for (std::size_t aColumn = 0U; aColumn < 4U; ++aColumn) {
            const unsigned aMask = 255U ^ mColumnMasks[aColumn];
            if (!mAllowedMasks[aMask] || (aLastRowMask & aMask) != 0U) return true;
            aLastRowMask |= aMask;
            mCandidate.mColumns[aColumn].mPairs[3U] = PairFromMask(aMask);
        }
        if (aLastRowMask != 255U) return true;
        ++mNormalizedPlaneCount;
        return AddPlane();
    }

    const std::size_t aRow = pCell / 4U;
    const std::size_t aColumn = pCell % 4U;
    if (aColumn == 0U) pRowMask = 0U;
    for (const unsigned aMask : mPairMasks) {
        if ((aMask & pRowMask) != 0U || (aMask & mColumnMasks[aColumn]) != 0U) continue;
        // All top-row pairs differ: sorting them removes exactly 24 column
        // orders without excluding any equivalence class.
        if (aRow == 0U && aColumn > 0U &&
            aMask <= PairMask(mCandidate.mColumns[aColumn - 1U].mPairs[0U])) continue;
        mCandidate.mColumns[aColumn].mPairs[aRow] = PairFromMask(aMask);
        mColumnMasks[aColumn] |= aMask;
        const bool aSuccess = Visit(pCell + 1U, pRowMask | aMask);
        mColumnMasks[aColumn] ^= aMask;
        if (!aSuccess) return false;
    }
    return true;
}

bool BitPlaneExhaustiveSearchTool::AddPlane() {
    Hashes aHashes{};
    if (!MakeHashes(mCandidate, aHashes)) return false;
    Entry *aBegin = mEntries.get();
    Entry *aEnd = aBegin + mBitPlaneCount;
    Entry *aEntry = std::lower_bound(aBegin, aEnd, aHashes,
        [](const Entry &pEntry, const Hashes &pHashes) { return Less(pEntry.mHashes, pHashes); });
    if (aEntry != aEnd && aEntry->mHashes == aHashes) return true;
    if (mBitPlaneCount == kMaximumPlaneCount) return false;
    std::move_backward(aEntry, aEnd, aEnd + 1U);
    aEntry->mHashes = aHashes;
    for (std::size_t aColumn = 0U; aColumn < 4U; ++aColumn) {
        for (std::size_t aRow = 0U; aRow < 4U; ++aRow) {
            const unsigned aMask = (aHashes.mColumns[aColumn] >> (8U * (3U - aRow))) & 255U;
            aEntry->mBitPlane.mColumns[aColumn].mPairs[aRow] = PairFromMask(aMask);
        }
    }
    ++mBitPlaneCount;
    return true;
}

bool BitPlaneExhaustiveSearchTool::Print(std::FILE *pStream) const {
    if (!mComplete || pStream == nullptr) return false;
    std::fprintf(pStream, "BitPlane exhaustive search: %zu labeled grids, %zu unique planes\n"
                         "Rows a-d; columns A-D; each cell is an intact bit pair.\n"
                         "Duplicates removed under global row AND column permutations.\n\n",
                 mNormalizedPlaneCount * 24U, mBitPlaneCount);
    for (std::size_t aIndex = 0U; aIndex < mBitPlaneCount; ++aIndex) {
        const auto &aEntry = mEntries[aIndex];
        std::fprintf(pStream, "BitPlane %zu | column hashes:", aIndex);
        for (const auto aHash : aEntry.mHashes.mColumns) {
            std::fprintf(pStream, " %08X", static_cast<unsigned>(aHash));
        }
        std::fprintf(pStream, "\n       A     B     C     D\n");
        PrintGrid(pStream, aEntry.mBitPlane, "    ");
        std::fputc('\n', pStream);
    }
    return std::ferror(pStream) == 0;
}

bool BitPlaneExhaustiveSearchTool::WriteData(std::FILE *pStream) const {
    if (!mComplete || pStream == nullptr) return false;
    std::fprintf(pStream, "// Generated by BitPlaneExhaustiveSearchTool. Do not edit by hand.\n"
                         "// %zu representatives of %zu labeled grids, modulo global row/column order.\n"
                         "// Bit labels are fixed. Pair members are ascending. Storage is column-first.\n",
                 mBitPlaneCount, mNormalizedPlaneCount * 24U);
    for (std::size_t aIndex = 0U; aIndex < mBitPlaneCount; ++aIndex) {
        const auto &aPlane = mEntries[aIndex].mBitPlane;
        std::fprintf(pStream, "\n// BitPlane %zu\n", aIndex);
        PrintGrid(pStream, aPlane, "// ");
        std::fprintf(pStream, "{ {\n");
        for (std::size_t aColumn = 0U; aColumn < 4U; ++aColumn) {
            std::fprintf(pStream, "    { {");
            for (const auto &aPair : aPlane.mColumns[aColumn].mPairs) {
                std::fprintf(pStream, " {%uU, %uU},", static_cast<unsigned>(aPair.mBitA),
                             static_cast<unsigned>(aPair.mBitB));
            }
            std::fprintf(pStream, " } }, // column %c, rows a-d\n", static_cast<int>('A' + aColumn));
        }
        std::fprintf(pStream, "} },\n");
    }
    return std::ferror(pStream) == 0;
}
