#ifndef SOCCER_BIT_PLANE_EXHAUSTIVE_SEARCH_TOOL_HPP_
#define SOCCER_BIT_PLANE_EXHAUSTIVE_SEARCH_TOOL_HPP_

#include "BitPlane.hpp"
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <memory>

// Offline generator. No seed selection or dependency on the existing bank.
// Equivalence allows any GLOBAL row and column permutation, simultaneously.
// Pair orientation is ignored; bit labels and the two grid axes are NOT renamed.
class BitPlaneExhaustiveSearchTool {
public:
    struct Hashes {
        // Four exact 32-bit encodings, not probabilistic hashes. Each byte is
        // a pair's bit mask, top row first. See MakeHashes for canonicalization.
        std::uint32_t mColumns[4];
        bool operator==(const Hashes &) const = default;
    };
    struct Entry {
        BitPlane mBitPlane;
        Hashes mHashes;
    };

    // There are 8,808 grids after sorting the top row's pairs. This bounds
    // storage before row deduplication; Run fails rather than truncating.
    static constexpr std::size_t kMaximumPlaneCount = 8808U;
    std::unique_ptr<Entry[]> mEntries;
    std::size_t mBitPlaneCount = 0U;
    std::size_t mNormalizedPlaneCount = 0U;

    bool Run();
    bool Print(std::FILE *pStream = stdout) const;
    bool WriteData(std::FILE *pStream) const;

    static bool IsValid(const BitPlane &pBitPlane);
    // For each of 24 global row orders: pack four columns, sort their hashes.
    // Keep the lexicographically smallest list. Equal lists mean exactly the
    // same grid up to row/column swaps; independent per-column sorting would
    // incorrectly discard the relationship between rows.
    static bool MakeHashes(const BitPlane &pBitPlane, Hashes &pHashes);

private:
    bool Visit(std::size_t pCell, unsigned pRowMask);
    bool AddPlane();
    BitPlane mCandidate{};
    unsigned mColumnMasks[4]{};
    std::uint8_t mPairMasks[20]{};
    bool mAllowedMasks[256]{};
    bool mComplete = false;
};

#endif // SOCCER_BIT_PLANE_EXHAUSTIVE_SEARCH_TOOL_HPP_
