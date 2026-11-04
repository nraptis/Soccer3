#ifndef SOCCER_BIT_PLANE_FARM_HPP_
#define SOCCER_BIT_PLANE_FARM_HPP_

#include "SamplingTriplet.hpp"
#include <array>
#include <cassert>
#include <cstddef>
#include <cstdint>

// One L3/L2/L1 unit, shared by the eventual A/B/C groups of the stack.
// Bank[level][pass][group] stores a bit mask, not a list of row indices.
// Level 0/1/2 = L3/L2/L1; pass 0/1 = a/b; group 0/1/2 = a/b/c.
// Thus [0][0][0] is bits-aaa and [2][1][2] is bits-cbc.
//
// For each pass, both the rows and columns partition all eight bit positions:
//     2 3 3
//     3 2 3
//     3 3 2
// The two masks at every [level][group] must differ. They may overlap.
// All nine comparisons are required: the third group being a complement
// does not imply it differs when the first two groups differ.
class BitPlaneFarm {
public:
    static constexpr std::size_t kLevelCount = 3U;
    static constexpr std::size_t kPassCount = 2U;
    static constexpr std::size_t kGroupCount = 3U;
    static constexpr std::size_t kSeedWordCount = 3U;
    using Bank = std::array<std::array<std::array<std::uint8_t, kGroupCount>, kPassCount>, kLevelCount>;

    // Counts of eligible second grids for the 28 first-grid completions
    // with canonical first row {0,1}, {2,3,4}, {5,6,7}. Completion order is
    // SamplingTriplet::Select's order. An exhaustive independent test checks
    // every count. Weighting by these counts makes valid PAIRS equiprobable,
    // rather than favoring first grids with fewer eligible second grids.
    static constexpr std::array<std::uint16_t, SamplingTriplet::kCompletions> kSecondGridCounts = {
        12726, 12814, 12814, 12814, 12814, 12814, 12814,
        12814, 12814, 12814, 12814, 12814, 12814, 12822,
        12822, 12822, 12814, 12814, 12814, 12814, 12814,
        12814, 12822, 12822, 12822, 12822, 12822, 12822
    };
    static constexpr std::size_t kCanonicalPairCount = [] {
        std::size_t aCount = 0U;
        for (auto aSecondCount : kSecondGridCounts) { aCount += aSecondCount; }
        return aCount;
    }();
    static constexpr std::size_t kPairCount = 560U * kCanonicalPairCount;

    static Bank Select(std::uint64_t pFirstShuffle, std::uint64_t pSecondShuffle,
                       std::uint64_t pPairRank) {
        // Fixed-budget reductions have only the small 64-bit remainder bias.
        // There are no rejection retries, random repairs or omitted pairs.
        pPairRank %= kCanonicalPairCount;
        std::size_t aCompletion = 0U;
        while (pPairRank >= kSecondGridCounts[aCompletion]) {
            pPairRank -= kSecondGridCounts[aCompletion++];
        }
        constexpr std::uint64_t kIdentityShuffle = 40319ULL;
        const auto aFirst = SamplingTriplet::Select(kIdentityShuffle, kIdentityShuffle, aCompletion);
        const auto aSecond = SelectSecondGrid(aFirst, pPairRank);

        std::uint8_t aRows[] = {0U, 1U, 2U, 3U, 4U, 5U, 6U, 7U};
        pFirstShuffle %= 40320ULL;
        pSecondShuffle %= 40320ULL;
        SamplingTriplet::Shuffle(aRows, 8U, pFirstShuffle);
        SamplingTriplet::Shuffle(aRows, 8U, pSecondShuffle);

        // Apply the same bijective relabeling to both grids. Each final pair
        // has exactly 2!*3!*3! canonical preimages, preserving equal weights.
        Bank aResult{};
        for (std::size_t aLevel = 0U; aLevel < kLevelCount; ++aLevel) {
            for (std::size_t aGroup = 0U; aGroup < kGroupCount; ++aGroup) {
                for (unsigned aBit = 0U; aBit < 8U; ++aBit) {
                    if (aFirst[aLevel][aGroup] & (1U << aBit)) {
                        aResult[aLevel][0][aGroup] |= static_cast<std::uint8_t>(1U << aRows[aBit]);
                    }
                    if (aSecond[aLevel][aGroup] & (1U << aBit)) {
                        aResult[aLevel][1][aGroup] |= static_cast<std::uint8_t>(1U << aRows[aBit]);
                    }
                }
            }
        }
        return aResult;
    }

private:
    static SamplingTriplet::Grid SelectSecondGrid(const SamplingTriplet::Grid &pFirst,
                                                   std::uint64_t pRank) {
        // Enumerate only valid second grids (at most 15,680). All loops are
        // bounded, and the only storage is this nine-byte candidate grid.
        SamplingTriplet::Grid aSecond{};
        for (unsigned aTopA = 1U; aTopA < 256U; ++aTopA) {
            if (SamplingTriplet::Count(aTopA) != 2U || aTopA == pFirst[0][0]) { continue; }
            const unsigned aTopRemaining = 255U ^ aTopA;
            for (unsigned aTopB = aTopRemaining; aTopB != 0U; aTopB = (aTopB - 1U) & aTopRemaining) {
                if (SamplingTriplet::Count(aTopB) != 3U || aTopB == pFirst[0][1]) { continue; }
                const unsigned aTopC = 255U ^ (aTopA | aTopB);
                if (aTopC == pFirst[0][2]) { continue; }
                aSecond[0] = {static_cast<std::uint8_t>(aTopA), static_cast<std::uint8_t>(aTopB), static_cast<std::uint8_t>(aTopC)};
                for (unsigned aMiddleA = aTopRemaining; aMiddleA != 0U; aMiddleA = (aMiddleA - 1U) & aTopRemaining) {
                    if (SamplingTriplet::Count(aMiddleA) != 3U || aMiddleA == pFirst[1][0]) { continue; }
                    const unsigned aMiddleChoices = 255U ^ (aTopB | aMiddleA);
                    for (unsigned aMiddleB = aMiddleChoices; aMiddleB != 0U; aMiddleB = (aMiddleB - 1U) & aMiddleChoices) {
                        if (SamplingTriplet::Count(aMiddleB) != 2U || aMiddleB == pFirst[1][1]) { continue; }
                        const unsigned aMiddleC = 255U ^ (aMiddleA | aMiddleB);
                        if ((aMiddleC & aTopC) != 0U || aMiddleC == pFirst[1][2]) { continue; }
                        aSecond[1] = {static_cast<std::uint8_t>(aMiddleA), static_cast<std::uint8_t>(aMiddleB), static_cast<std::uint8_t>(aMiddleC)};
                        bool aDifferent = true;
                        for (std::size_t aGroup = 0U; aGroup < kGroupCount; ++aGroup) {
                            aSecond[2][aGroup] = 255U ^ (aSecond[0][aGroup] | aSecond[1][aGroup]);
                            if (aSecond[2][aGroup] == pFirst[2][aGroup]) { aDifferent = false; }
                        }
                        if (aDifferent && pRank-- == 0U) { return aSecond; }
                    }
                }
            }
        }
        assert(false && "Bit-plane completion count does not match enumeration");
        return {}; // Unreachable for a rank selected from kSecondGridCounts.
    }
};

static_assert(sizeof(BitPlaneFarm::Bank) == 18U);
static_assert(BitPlaneFarm::kCanonicalPairCount == 358776U);
static_assert(BitPlaneFarm::kPairCount == 200914560U);

#endif // SOCCER_BIT_PLANE_FARM_HPP_
