#ifndef SOCCER_BIT_PLANE_FARM_CHECKS_HPP_
#define SOCCER_BIT_PLANE_FARM_CHECKS_HPP_

#include "BitPlaneFarm.hpp"
#include "BitPlaneExhaustiveSearchTool.hpp"
#include "BitPlaneTool.hpp"
#include <algorithm>
#include <array>
#include <map>
#include <limits>
#include <set>
#include <type_traits>

static_assert(std::is_aggregate_v<BitPlane>);
static_assert(std::is_trivially_copyable_v<BitPlane>);

using BitPlaneGridKey = std::array<std::uint8_t, 16U>;

// A literal row-major grid key, with NO row/column normalization. Independent
// of the generator's sorted column hashes; used to compare complete orbits.
inline BitPlaneGridKey BitPlaneGrid(const BitPlane &pPlane) {
    BitPlaneGridKey aKey{};
    for (unsigned aRow = 0U; aRow < 4U; ++aRow) {
        for (unsigned aColumn = 0U; aColumn < 4U; ++aColumn) {
            const auto &aPair = pPlane.mColumns[aColumn].mPairs[aRow];
            aKey[aRow * 4U + aColumn] = static_cast<std::uint8_t>(
                (1U << aPair.mBitA) | (1U << aPair.mBitB));
        }
    }
    return aKey;
}

inline const char *CheckBitPlaneFarmSearch() {
    BitPlaneExhaustiveSearchTool aSearch;
    if (aSearch.Print(nullptr) || aSearch.WriteData(nullptr)) return "unfinished export accepted";
    // Re-run the same object to check all search state is reset.
    for (unsigned aRun = 0U; aRun < 2U; ++aRun) {
        if (!aSearch.Run()) return "exhaustive search failed";
        if (aSearch.mNormalizedPlaneCount != 8808U || aSearch.mBitPlaneCount != 588U ||
            aSearch.mBitPlaneCount != BitPlaneFarm::kBitPlaneCount) return "unexpected exhaustive count";
        for (std::size_t aIndex = 0U; aIndex < aSearch.mBitPlaneCount; ++aIndex) {
            const auto &aEntry = aSearch.mEntries[aIndex];
            if (!(aEntry.mBitPlane == BitPlaneFarm::mBitPlanes[aIndex])) return "generated bank is stale";
            BitPlaneExhaustiveSearchTool::Hashes aHashes{};
            if (!aSearch.MakeHashes(aEntry.mBitPlane, aHashes) || !(aHashes == aEntry.mHashes))
                return "stored canonical hash disagrees with exported grid";
            if (aIndex != 0U && !std::lexicographical_compare(
                aSearch.mEntries[aIndex - 1U].mHashes.mColumns,
                aSearch.mEntries[aIndex - 1U].mHashes.mColumns + 4U,
                aHashes.mColumns, aHashes.mColumns + 4U)) return "hash list is not strictly ordered";
        }
    }
    std::FILE *aOutput = std::tmpfile();
    if (aOutput == nullptr) return "cannot open temporary export";
    const bool aWrote = aSearch.WriteData(aOutput) && aSearch.Print(aOutput);
    const bool aClosed = std::fclose(aOutput) == 0;
    if (!aWrote || !aClosed) return "data/report export failed";
    return nullptr;
}

inline const char *CheckBitPlaneFarmSwaps() {
    const auto aOriginal = BitPlaneFarm::mBitPlanes[0U];
    std::map<BitPlaneGridKey, unsigned> aRowCounts, aColumnCounts;
    for (std::uint64_t aSeed = 0U; aSeed < 24U; ++aSeed) {
        auto aRows = aOriginal, aColumns = aOriginal;
        aRows.SwapRows(aSeed);
        aColumns.SwapColumns(aSeed);
        // Compatibility oracle: the old in-place shuffle, independent of
        // the new destination table and GetRow/SetRow/GetCol/SetCol helpers.
        auto aPreviousRows = aOriginal, aPreviousColumns = aOriginal;
        std::uint64_t aRank = aSeed;
        for (std::size_t aIndex = 3U; aIndex > 0U; --aIndex) {
            const std::size_t aOther = aRank % (aIndex + 1U);
            aRank /= aIndex + 1U;
            for (auto &aColumn : aPreviousRows.mColumns) {
                std::swap(aColumn.mPairs[aIndex], aColumn.mPairs[aOther]);
            }
            std::swap(aPreviousColumns.mColumns[aIndex], aPreviousColumns.mColumns[aOther]);
        }
        if (!(aRows == aPreviousRows) || !(aColumns == aPreviousColumns))
            return "row/column helper refactor changed seed-to-order mapping";
        if (!BitPlaneExhaustiveSearchTool::IsValid(aRows) ||
            !BitPlaneExhaustiveSearchTool::IsValid(aColumns)) return "swap broke pair/coverage invariant";
        ++aRowCounts[BitPlaneGrid(aRows)];
        ++aColumnCounts[BitPlaneGrid(aColumns)];
    }
    if (aRowCounts.size() != 24U || aColumnCounts.size() != 24U) return "missing swap order";
    for (const auto &aCount : aRowCounts) if (aCount.second != 1U) return "repeated row permutation";
    for (const auto &aCount : aColumnCounts) if (aCount.second != 1U) return "repeated column permutation";

    const std::uint64_t aSeeds[] = {65520U, 65535U, 65536U, 1ULL << 32U,
                                  1ULL << 63U, std::numeric_limits<std::uint64_t>::max()};
    for (const auto aSeed : aSeeds) {
        auto aRows = aOriginal, aColumns = aOriginal;
        auto aExpectedRows = aOriginal, aExpectedColumns = aOriginal;
        aRows.SwapRows(aSeed);
        aColumns.SwapColumns(aSeed);
        aExpectedRows.SwapRows(aSeed % 24U);
        aExpectedColumns.SwapColumns(aSeed % 24U);
        if (!(aRows == aExpectedRows) || !(aColumns == aExpectedColumns))
            return "64-bit seed was truncated or rejected";
    }

    BitPlaneExhaustiveSearchTool::Hashes aOriginalHashes{};
    if (!BitPlaneExhaustiveSearchTool::MakeHashes(aOriginal, aOriginalHashes)) return "invalid initial grid";
    for (std::uint64_t aRowSeed = 0U; aRowSeed < 24U; ++aRowSeed) {
        for (std::uint64_t aColumnSeed = 0U; aColumnSeed < 24U; ++aColumnSeed) {
            auto aPlane = aOriginal;
            aPlane.SwapRows(aRowSeed);
            aPlane.SwapColumns(aColumnSeed);
            // Repeated calls must compose, and preserve pair orientation.
            aPlane.SwapRows(11U);
            aPlane.SwapColumns(7U);
            BitPlaneExhaustiveSearchTool::Hashes aHashes{};
            if (!BitPlaneExhaustiveSearchTool::MakeHashes(aPlane, aHashes) || !(aHashes == aOriginalHashes))
                return "equivalent grid has a different hash list";
        }
    }
    return nullptr;
}

inline const char *CheckBitPlaneFarmSelection() {
    BitPlane aResult{};
    for (std::uint64_t aIndex = 0U; aIndex < BitPlaneFarm::kBitPlaneCount; ++aIndex) {
        BitPlaneFarm::Select(aIndex, 23U, 23U, &aResult);
        if (!(aResult == BitPlaneFarm::mBitPlanes[aIndex])) return "identity selection missed bank entry";
    }
    const std::uint64_t aWords[] = {0U, 1U, 23U, 24U, 587U, 588U, 65520U,
                                  1ULL << 32U, 1ULL << 63U,
                                  std::numeric_limits<std::uint64_t>::max()};
    for (const auto aPlaneWord : aWords) {
        for (const auto aRowWord : aWords) {
            for (const auto aColumnWord : aWords) {
                const auto aBase = BitPlaneFarm::mBitPlanes[aPlaneWord % BitPlaneFarm::kBitPlaneCount];
                auto aExpected = aBase;
                aExpected.SwapRows(aRowWord);
                aExpected.SwapColumns(aColumnWord);
                BitPlaneFarm::Select(aPlaneWord, aRowWord, aColumnWord, &aResult);
                if (!(aResult == aExpected) || !BitPlaneExhaustiveSearchTool::IsValid(aResult))
                    return "selection did not apply all three words correctly";
                if (!(BitPlaneFarm::mBitPlanes[aPlaneWord % BitPlaneFarm::kBitPlaneCount] == aBase))
                    return "selection changed bank data";
            }
        }
    }
    BitPlaneFarm::Select(0U, 0U, 0U, nullptr);
    return nullptr;
}

inline const char *CheckBitPlaneFarmCoverage() {
    std::set<BitPlaneGridKey> aAllGrids;
    for (const auto &aPlane : BitPlaneFarm::mBitPlanes) {
        if (!BitPlaneExhaustiveSearchTool::IsValid(aPlane)) return "invalid bank plane";
        // Enumerate permutations independently, without calling Swap or MakeHashes.
        std::set<BitPlaneGridKey> aOrbit;
        unsigned aRows[4] = {0U, 1U, 2U, 3U};
        do {
            unsigned aColumns[4] = {0U, 1U, 2U, 3U};
            do {
                BitPlane aOrdered{};
                for (unsigned aRow = 0U; aRow < 4U; ++aRow) {
                    for (unsigned aColumn = 0U; aColumn < 4U; ++aColumn) {
                        aOrdered.mColumns[aColumn].mPairs[aRow] =
                            aPlane.mColumns[aColumns[aColumn]].mPairs[aRows[aRow]];
                    }
                }
                if (!BitPlaneExhaustiveSearchTool::IsValid(aOrdered)) return "permuted grid invalid";
                aOrbit.insert(BitPlaneGrid(aOrdered));
            } while (std::next_permutation(aColumns, aColumns + 4U));
        } while (std::next_permutation(aRows, aRows + 4U));
        for (const auto &aGrid : aOrbit) {
            if (!aAllGrids.insert(aGrid).second) return "bank contains equivalent representatives";
        }
    }
    if (aAllGrids.size() != 211392U) return "representatives do not expand to all labeled grids";
    // Compare every labeled grid in the existing independently generated bank.
    for (std::uint64_t aBase = 0U; aBase < BitPlaneTool::kBasePlanCount; ++aBase) {
        for (std::uint64_t aOrder = 0U; aOrder < 24U; ++aOrder) {
            const auto aLegacy = BitPlaneTool::Select(aBase, aOrder);
            BitPlaneGridKey aKey{};
            for (unsigned aRow = 0U; aRow < 4U; ++aRow) {
                for (unsigned aColumn = 0U; aColumn < 4U; ++aColumn) {
                    aKey[aRow * 4U + aColumn] = BitPlaneTool::Mask(aLegacy[aRow][aColumn]);
                }
            }
            if (aAllGrids.count(aKey) != 1U) return "existing valid plan missing from new bank";
        }
    }
    return nullptr;
}

inline const char *CheckBitPlaneFarmInvalidAndDistinct() {
    BitPlaneExhaustiveSearchTool::Hashes aHashes{};
    for (const BitPlanePair aPair : {BitPlanePair{0U, 7U}, {0U, 1U}, {7U, 0U},
                                     {2U, 2U}, {8U, 0U}, {255U, 2U}}) {
        auto aPlane = BitPlaneFarm::mBitPlanes[0U];
        aPlane.mColumns[0U].mPairs[0U] = aPair;
        if (BitPlaneExhaustiveSearchTool::IsValid(aPlane) ||
            BitPlaneExhaustiveSearchTool::MakeHashes(aPlane, aHashes)) return "invalid pair accepted";
    }
    auto aPlane = BitPlaneFarm::mBitPlanes[0U];
    aPlane.mColumns[1U] = aPlane.mColumns[0U];
    if (BitPlaneExhaustiveSearchTool::IsValid(aPlane)) return "duplicate column accepted";
    aPlane = BitPlaneFarm::mBitPlanes[0U];
    for (auto &aColumn : aPlane.mColumns) aColumn.mPairs[1U] = aColumn.mPairs[0U];
    if (BitPlaneExhaustiveSearchTool::IsValid(aPlane)) return "duplicate row accepted";

    BitPlaneExhaustiveSearchTool::Hashes aFirst{}, aSecond{};
    BitPlaneExhaustiveSearchTool::MakeHashes(BitPlaneFarm::mBitPlanes[0U], aFirst);
    BitPlaneExhaustiveSearchTool::MakeHashes(BitPlaneFarm::mBitPlanes[1U], aSecond);
    // These have the same unordered pairs in each column, but different grid
    // relationships. Sorting inside each column would falsely merge them.
    if (aFirst == aSecond) return "inequivalent row relationships collapsed";
    aPlane = BitPlaneFarm::mBitPlanes[0U];
    for (auto &aColumn : aPlane.mColumns) {
        for (auto &aPair : aColumn.mPairs) std::swap(aPair.mBitA, aPair.mBitB);
    }
    if (!BitPlaneExhaustiveSearchTool::MakeHashes(aPlane, aHashes) || !(aHashes == aFirst))
        return "unordered pair orientation changed equivalence";
    return nullptr;
}

#endif // SOCCER_BIT_PLANE_FARM_CHECKS_HPP_
