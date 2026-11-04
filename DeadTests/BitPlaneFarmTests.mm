#import <XCTest/XCTest.h>
#include "BitPlaneFarm.hpp"
#include <algorithm>
#include <array>
#include <functional>
#include <limits>
#include <random>
#include <set>
#include <vector>

namespace {
using Grid = SamplingTriplet::Grid;
using Bank = BitPlaneFarm::Bank;

bool IsValid(const Bank &pBank) {
    for (unsigned aPass = 0U; aPass < 2U; ++aPass) {
        for (unsigned i = 0U; i < 3U; ++i) {
            unsigned aRow = 0U, aColumn = 0U;
            for (unsigned j = 0U; j < 3U; ++j) {
                const unsigned aRowMask = pBank[i][aPass][j];
                const unsigned aColumnMask = pBank[j][aPass][i];
                if (__builtin_popcount(aRowMask) != (i == j ? 2 : 3)) { return false; }
                if ((aRow & aRowMask) || (aColumn & aColumnMask)) { return false; }
                aRow |= aRowMask; aColumn |= aColumnMask;
            }
            if (aRow != 255U || aColumn != 255U) { return false; }
        }
    }
    for (unsigned aLevel = 0U; aLevel < 3U; ++aLevel) {
        for (unsigned aGroup = 0U; aGroup < 3U; ++aGroup) {
            if (pBank[aLevel][0][aGroup] == pBank[aLevel][1][aGroup]) { return false; }
        }
    }
    return true;
}

// Independent oracle: each bit chooses one of the six bijections between
// levels and groups. Cell capacities restrict each grid to the 2/3/3 scheme.
std::vector<Grid> EnumerateGrids() {
    constexpr unsigned kPermutations[][3] = {{0,1,2},{0,2,1},{1,0,2},{1,2,0},{2,0,1},{2,1,0}};
    Grid aGrid{};
    unsigned aRemaining[3][3] = {{2,3,3},{3,2,3},{3,3,2}};
    std::vector<Grid> aGrids;
    std::function<void(unsigned)> aVisit = [&](unsigned pBit) {
        if (pBit == 8U) { aGrids.push_back(aGrid); return; }
        for (const auto &aPermutation : kPermutations) {
            if (!aRemaining[0][aPermutation[0]] || !aRemaining[1][aPermutation[1]] ||
                !aRemaining[2][aPermutation[2]]) { continue; }
            for (unsigned aLevel = 0U; aLevel < 3U; ++aLevel) {
                --aRemaining[aLevel][aPermutation[aLevel]];
                aGrid[aLevel][aPermutation[aLevel]] |= 1U << pBit;
            }
            aVisit(pBit + 1U);
            for (unsigned aLevel = 0U; aLevel < 3U; ++aLevel) {
                ++aRemaining[aLevel][aPermutation[aLevel]];
                aGrid[aLevel][aPermutation[aLevel]] ^= 1U << pBit;
            }
        }
    };
    aVisit(0U);
    // These four masks uniquely determine the entire grid. Sort the oracle
    // into production's unranking order without using its enumeration code.
    const auto aKey = [](const Grid &pGrid) {
        return std::array<int,4>{pGrid[0][0], -pGrid[0][1], -pGrid[1][0], -pGrid[1][1]};
    };
    std::sort(aGrids.begin(), aGrids.end(), [&](const Grid &pA, const Grid &pB) { return aKey(pA) < aKey(pB); });
    return aGrids;
}

bool Different(const Grid &pA, const Grid &pB) {
    for (unsigned aLevel = 0U; aLevel < 3U; ++aLevel)
        for (unsigned aGroup = 0U; aGroup < 3U; ++aGroup)
            if (pA[aLevel][aGroup] == pB[aLevel][aGroup]) { return false; }
    return true;
}
}

@interface BitPlaneFarmTests : XCTestCase
@end
@implementation BitPlaneFarmTests
- (void)testExhaustiveCompletionCountsAndPairRankBoundaries {
    const auto aGrids = EnumerateGrids();
    XCTAssertEqual(aGrids.size(), std::size_t{15680U});
    XCTAssertEqual(std::set<Grid>(aGrids.begin(), aGrids.end()).size(), aGrids.size());
    std::size_t aStart = 0U, aCompletion = 0U;
    const std::array<std::uint8_t,3> aCanonicalTop = {3U, 28U, 224U};
    for (const auto &aFirst : aGrids) {
        if (aFirst[0] != aCanonicalTop) { continue; }
        std::vector<Grid> aEligible;
        for (const auto &aSecond : aGrids) {
            if (Different(aFirst, aSecond)) { aEligible.push_back(aSecond); }
        }
        XCTAssertEqual(aEligible.size(), std::size_t{BitPlaneFarm::kSecondGridCounts[aCompletion]});
        XCTAssertTrue(aFirst == SamplingTriplet::Select(40319U, 40319U, aCompletion));
        // Check both ends and interior ranks in every weighted interval.
        for (std::size_t aPart = 0U; aPart <= 32U; ++aPart) {
            const auto aRank = aPart * (aEligible.size() - 1U) / 32U;
            const auto aBank = BitPlaneFarm::Select(40319U, 40319U, aStart + aRank);
            XCTAssertTrue(IsValid(aBank));
            for (unsigned aLevel = 0U; aLevel < 3U; ++aLevel) {
                XCTAssertTrue(aBank[aLevel][0] == aFirst[aLevel]);
                XCTAssertTrue(aBank[aLevel][1] == aEligible[aRank][aLevel]);
            }
        }
        aStart += aEligible.size();
        ++aCompletion;
    }
    XCTAssertEqual(aCompletion, std::size_t{28U});
    XCTAssertEqual(aStart, BitPlaneFarm::kCanonicalPairCount);
    XCTAssertEqual(560U * aStart, BitPlaneFarm::kPairCount);
}

- (void)testAllConstraintsForExtremeAndRandomSeedWords {
    const auto aMaximum = std::numeric_limits<std::uint64_t>::max();
    for (std::uint64_t aFirst : {0ULL, 1ULL, 40319ULL, aMaximum})
        for (std::uint64_t aSecond : {0ULL, 1ULL, 40319ULL, aMaximum})
            for (std::uint64_t aRank : {0ULL, 1ULL, 358775ULL, 358776ULL, aMaximum})
                XCTAssertTrue(IsValid(BitPlaneFarm::Select(aFirst, aSecond, aRank)));
    std::mt19937_64 aRandom(0xB17A1A9EULL);
    for (unsigned i = 0U; i < 512U; ++i) {
        const auto aFirst = aRandom(), aSecond = aRandom(), aRank = aRandom();
        const auto aBank = BitPlaneFarm::Select(aFirst, aSecond, aRank);
        XCTAssertTrue(IsValid(aBank));
        XCTAssertTrue(aBank == BitPlaneFarm::Select(aFirst, aSecond, aRank));
    }
}

- (void)testBothShufflePassesRelabelTheWholeBankWithoutChangingConstraints {
    const auto aBase = BitPlaneFarm::Select(40319U, 40319U, 0U);
    const auto aOnce = BitPlaneFarm::Select(0U, 40319U, 0U);
    const auto aTwice = BitPlaneFarm::Select(0U, 0U, 0U);
    // Rank zero maps row labels 0..7 to 1..7,0. Two passes compose.
    for (unsigned aLevel = 0U; aLevel < 3U; ++aLevel)
        for (unsigned aPass = 0U; aPass < 2U; ++aPass)
            for (unsigned aGroup = 0U; aGroup < 3U; ++aGroup) {
                const unsigned aMask = aBase[aLevel][aPass][aGroup];
                XCTAssertEqual(aOnce[aLevel][aPass][aGroup], std::uint8_t((aMask << 1U) | (aMask >> 7U)));
                XCTAssertEqual(aTwice[aLevel][aPass][aGroup], std::uint8_t((aMask << 2U) | (aMask >> 6U)));
            }
    XCTAssertTrue(IsValid(aOnce));
    XCTAssertTrue(IsValid(aTwice));
}
@end
