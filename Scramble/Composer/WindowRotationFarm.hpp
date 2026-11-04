#ifndef SOCCER_WINDOW_ROTATION_FARM_HPP_
#define SOCCER_WINDOW_ROTATION_FARM_HPP_

#include <cstddef>
#include <cstdint>
#include "WindowRotationPack.hpp"

namespace WindowRotationFarm {
inline constexpr std::size_t kWindowCount = 16384U;
inline constexpr std::size_t kWindowBytes = 64U;
inline constexpr std::size_t kBlockBytes = kWindowCount * kWindowBytes;
inline constexpr std::size_t kRotationsPerJob = 8U;
inline constexpr std::size_t kJobsPerPlane = 9U;
inline constexpr std::size_t kJobCount = 2U * kJobsPerPlane;
inline constexpr std::size_t kSamplingRotationCount = 8U * 16U;
inline constexpr std::size_t kFreeRotationCount = 8U * 2U;

// The same conversion is used while farming and when assembling Cryptex's
// final byte shifts. An even first shift requires an odd second shift.
inline constexpr std::uint32_t FreeByteOffset(std::uint64_t pWord, bool pRequireOdd) {
    return static_cast<std::uint32_t>(pRequireOdd ? 1U + 2U * (pWord % 32U) : 1U + pWord % 63U);
}

// Caller-owned scratch, separate from the data-only result. Value-initialize
// Buffers{} before a standalone sequence of at most kJobCount FarmEight calls;
// FarmPack/FarmPreparedPack clear it themselves. Do not externally fill the block maps.
// The same base is initialized and shuffled afresh for all eighteen jobs.
struct Buffers {
    std::uint16_t mWindowRotationBase[kWindowCount];
    bool mWindowRotationBlocked[kWindowCount];       // This job's combinations.
    std::uint16_t mWindowRotation[kRotationsPerJob]; // This job's selected windows.
    bool mWindowRotationSingleBlocked[kWindowCount]; // Singles across all jobs.
};

struct Source {
    const std::uint8_t *mBytes;
    std::size_t mByteCount;
};

// Prefer positions fixed by the final partial Fisher-Yates pass. On exhaustion,
// scan the remaining positions from the opposite end; they need not be uniformly
// shuffled. A non-null mWindows points to a full kWindowCount-element list.
struct PreparedSource {
    const std::uint16_t *mWindows;
    std::size_t mAvailable;
    bool mBackwards;
    const std::uint64_t *mOffsetWords; // Eight accumulated words for a free job; null otherwise.
    std::size_t mShuffleBytesRead;
};

struct Statistics {
    std::size_t mShuffleBytesRead;
    std::size_t mEntropyBytesRead;
    std::size_t mBaseReadCount;
    std::size_t mFallbackReadCount; // Tail/default candidate attempts, including rejections.
};

// All 256 subset sums (including the empty sum) must differ modulo 16384.
// For free rotations, also require distinct sums of actual BYTE offsets
// modulo 1048576. Each rotation occurs at most once in a subset.
// Singles/complements persist between jobs; combination blocks do not.
// Free values have offsets 1..63, with at least one odd value per adjacent
// pair. Whole-window results are returned in window units.
// Always fills eight values: use the shuffled prefix, then the opposite tail,
// then numeric window candidates if needed. All exclusion checks still apply.
// Missing/rejected offset entropy defaults to byte offset 1. The list is read
// at most once; numeric fallback candidates are counted separately.
void FarmEight(const Source &pSource, bool pFreeRotations, Buffers &pBuffers,
               std::int32_t (&pResult)[kRotationsPerJob], Statistics &pStatistics);

// Source/job order for EACH plane:
//   a: all free rotations, chunk A.A/A.B, B.A/B.B, C.A/C.B, D.A/D.B
//   b,c: chunk A windows A..H / I..P
//   d,e: chunk B windows A..H / I..P
//   f,g: chunk C windows A..H / I..P
//   h,i: chunk D windows A..H / I..P
// Eighteen separately supplied entropy slices; no global random generator.
// Pack fields retain window indices only, including mWindowFreeA/B.
// Actual byte offsets are checked during farming but not stored in the pack.
// Always fills all eighteen jobs, using the same deterministic fallbacks.
void FarmPack(const Source (&pSources)[kJobCount], Buffers &pBuffers,
              WindowRotationPack &pResult, Statistics (&pStatistics)[kJobCount]);

// Production path: select from the eighteen already-shuffled lists, without
// another shuffle. Runs the same exclusion rules as FarmPack. Each free
// offset uses one accumulated word: 1 + word % 63, or 1 + 2*(word % 32)
// when the second rotation of a layer must be odd. All words, including
// zero, are valid. Missing words use offset 1. Unavailable candidates fall
// back to the remaining list or numeric windows, with collision checks intact.
void FarmPreparedPack(const PreparedSource (&pSources)[kJobCount], Buffers &pBuffers,
                      WindowRotationPack &pResult, Statistics (&pStatistics)[kJobCount]);

// Validate window data independently of the farming scratch: ranges, global
// single exclusions in farming order, and all eighteen subset groups.
bool IsValid(const WindowRotationPack &pPack);

// Also validate the assembled byte shifts: matching windows, nonzero offsets,
// odd free pairs, and distinct actual byte sums (including carry/wraparound).
// Order is plane A then B, chunk A..D, first/second shift in each chunk.
bool IsValid(const WindowRotationPack &pPack,
             const std::int32_t (&pFreeRotations)[kFreeRotationCount]);
} // namespace WindowRotationFarm

#endif // SOCCER_WINDOW_ROTATION_FARM_HPP_
