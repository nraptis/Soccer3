#ifndef SamplingTriplet_hpp
#define SamplingTriplet_hpp

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdint>

// Canonical counts, with levels as rows and parameter banks as columns:
//     2 3 3
//     3 2 3
//     3 3 2
// Each row AND each column partitions the eight bit positions exactly once.
class SamplingTriplet {
public:
    using Grid = std::array<std::array<std::uint8_t, 3>, 3>;
    static constexpr std::size_t kCompletions = 28U;
    static constexpr std::size_t kRowSetGrids = 560U * kCompletions;

    static constexpr unsigned Count(std::uint8_t pMask) {
        unsigned aCount = 0U;
        for (; pMask != 0U; pMask &= static_cast<std::uint8_t>(pMask - 1U)) { ++aCount; }
        return aCount;
    }

    static void Shuffle(std::uint8_t *pRows, unsigned pCount, std::uint64_t &pRank) {
        for (unsigned i = pCount - 1U; i > 0U; --i) {
            const unsigned aSwap = static_cast<unsigned>(pRank % (i + 1U));
            pRank /= i + 1U;
            std::swap(pRows[i], pRows[aSwap]);
        }
    }

    static Grid Select(std::uint64_t pFirstPass, std::uint64_t pSecondPass,
                       std::uint64_t pCompletion) {
        // Uniform ranks give equal weight to all 560 * 28 valid grids.
        // Reducing 64-bit seed words modulo these small counts introduces
        // only the remainder bias of fixed-budget sampling; no retries or
        // greedy repair favor particular completed grids.
        std::uint8_t aRows[] = {0, 1, 2, 3, 4, 5, 6, 7};
        // Two composed Fisher-Yates passes. Each of the 560 first-layer
        // partitions has exactly 2! * 3! * 3! ordered representations.
        pFirstPass %= 40320ULL;
        pSecondPass %= 40320ULL;
        Shuffle(aRows, 8U, pFirstPass);
        Shuffle(aRows, 8U, pSecondPass);
        Grid aGrid{};
        for (unsigned i = 0U; i < 8U; ++i) {
            aGrid[0][i < 2U ? 0U : i < 5U ? 1U : 2U] |= 1U << aRows[i];
        }

        const unsigned aPlanetAvailable = 255U ^ aGrid[0][0];
        const unsigned aMoonAvailable = 255U ^ aGrid[0][1];
        const unsigned aStarAvailable = 255U ^ aGrid[0][2];
        pCompletion %= kCompletions;
        // Enumerate the 28 valid second layers, rather than making greedy
        // choices that can dead-end or bias the remaining families.
        for (unsigned aPlanet = aPlanetAvailable; aPlanet != 0U;
             aPlanet = (aPlanet - 1U) & aPlanetAvailable) {
            if (Count(aPlanet) != 3U) { continue; }
            const unsigned aMoonChoices = aMoonAvailable & (255U ^ aPlanet);
            for (unsigned aMoon = aMoonChoices; aMoon != 0U;
                 aMoon = (aMoon - 1U) & aMoonChoices) {
                if (Count(aMoon) != 2U) { continue; }
                const unsigned aStar = 255U ^ (aPlanet | aMoon);
                if ((aStar & aStarAvailable) != aStar) { continue; }
                if (pCompletion-- != 0U) { continue; }
                aGrid[1] = {static_cast<std::uint8_t>(aPlanet),
                            static_cast<std::uint8_t>(aMoon),
                            static_cast<std::uint8_t>(aStar)};
                for (unsigned aBank = 0U; aBank < 3U; ++aBank) {
                    aGrid[2][aBank] = 255U ^ (aGrid[0][aBank] | aGrid[1][aBank]);
                }
                return aGrid;
            }
        }
        return aGrid; // Unreachable for a valid 2/3/3 first partition.
    }

    // Store only the selected rows. Both Fisher-Yates passes keep the same
    // prefix order as the former eight-entry prefix/suffix permutation.
    static void OrderRows(std::uint8_t pMask, std::uint64_t pFirstPass,
                          std::uint64_t pSecondPass, std::uint8_t *pRows) {
        const unsigned aCount = Count(pMask);
        unsigned aSelected = 0U;
        for (unsigned aRow = 0U; aRow < 8U; ++aRow) {
            if (pMask & (1U << aRow)) { pRows[aSelected++] = aRow; }
        }
        const std::uint64_t aOrders = aCount == 2U ? 2ULL : 6ULL;
        for (auto aRank : {pFirstPass % aOrders, pSecondPass % aOrders}) {
            Shuffle(pRows, aCount, aRank);
        }
    }
};

#endif
