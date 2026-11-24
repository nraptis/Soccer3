//
//  BitPlaneBaselineTests.mm
//  ScrambleTests
//
//  Created by Icarus Black on 11/4/26.
//

#import <XCTest/XCTest.h>
#include "BitPlaneFarm.hpp"
#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <unordered_map>

namespace {

std::size_t BitDistance(std::size_t pBitA, std::size_t pBitB) {
    if (pBitA >= 8U || pBitB >= 8U) { return 0U; }
    const std::size_t aDistance = pBitA > pBitB ? pBitA - pBitB : pBitB - pBitA;
    // Bits 0 and 7 are adjacent too.
    return aDistance <= 4U ? aDistance : 8U - aDistance;
}

bool AllEight(std::size_t pBitA,
              std::size_t pBitB,
              std::size_t pBitC,
              std::size_t pBitD,
              std::size_t pBitE,
              std::size_t pBitF,
              std::size_t pBitG,
              std::size_t pBitH) {
    const std::size_t aBits[8] = {pBitA, pBitB, pBitC, pBitD, pBitE, pBitF, pBitG, pBitH};
    bool aExists[8] = {};
    for (std::size_t aIndex=0U; aIndex<8U; aIndex++) {
        const std::size_t aBit = aBits[aIndex];
        if (aBit >= 8U || aExists[aBit]) { return false; }
        aExists[aBit] = true;
    }
    return true;
}

struct BitPlaneKey {
    std::size_t mBitA = 0U;
    std::size_t mBitB = 0U;
    std::size_t mBitC = 0U;
    std::size_t mBitD = 0U;
    std::size_t mBitE = 0U;
    std::size_t mBitF = 0U;
    std::size_t mBitG = 0U;
    std::size_t mBitH = 0U;

    std::uint64_t Hash() const {
        // One decimal digit per bit value (1...8): no collisions for valid rows/columns.
        return (mBitA + 1U)
             + (mBitB + 1U) * 10ULL
             + (mBitC + 1U) * 100ULL
             + (mBitD + 1U) * 1000ULL
             + (mBitE + 1U) * 10000ULL
             + (mBitF + 1U) * 100000ULL
             + (mBitG + 1U) * 1000000ULL
             + (mBitH + 1U) * 10000000ULL;
    }
};

std::uint64_t HashPairs(const BitPlanePair (&pPairs)[4]) {
    const BitPlaneKey aKey = {
        pPairs[0].mBitA, pPairs[0].mBitB,
        pPairs[1].mBitA, pPairs[1].mBitB,
        pPairs[2].mBitA, pPairs[2].mBitB,
        pPairs[3].mBitA, pPairs[3].mBitB
    };
    return aKey.Hash();
}

struct BitPlaneHashList {
    std::uint64_t mHashes[4] = {};

    void Sort() {
        std::sort(mHashes, mHashes + 4U);
    }

    std::uint64_t Hash() const {
        std::uint64_t aHash = 14695981039346656037ULL;
        for (std::size_t aIndex=0U; aIndex<4U; aIndex++) {
            aHash ^= mHashes[aIndex];
            aHash *= 1099511628211ULL;
        }
        return aHash;
    }

    bool operator==(const BitPlaneHashList &pOther) const {
        // Compare all four hashes, even if the combined hash collides.
        for (std::size_t aIndex=0U; aIndex<4U; aIndex++) {
            if (mHashes[aIndex] != pOther.mHashes[aIndex]) { return false; }
        }
        return true;
    }
};

struct BitPlaneHashListHasher {
    std::size_t operator()(const BitPlaneHashList &pList) const {
        return static_cast<std::size_t>(pList.Hash());
    }
};

} // namespace

@interface BitPlaneBaselineTests : XCTestCase
@end

@implementation BitPlaneBaselineTests

- (void)test_AllValid {
    
    if (BitPlaneFarm::kBitPlaneCount <= 0) {
        XCTFail("Bit plane pack is empty.");
        return;
    }
    
    for (std::size_t aIndex=0U; aIndex<BitPlaneFarm::kBitPlaneCount; aIndex++) {
        const BitPlane &aBitPlane = BitPlaneFarm::mBitPlanes[aIndex];
        
        for (std::size_t aRowIndex=0U; aRowIndex<4U; aRowIndex++) {
            const BitPlaneRow aRow = aBitPlane.GetRow(aRowIndex);
            
            for (std::size_t aColumnIndex=0U; aColumnIndex<4U; aColumnIndex++) {
                const BitPlanePair &aPair = aRow.mPairs[aColumnIndex];
                if (aPair.mBitA >= 8U || aPair.mBitB >= 8U) {
                    XCTFail("Bit plane %zu, row %zu, column %zu: bits [%u, %u] are outside 0...7.",
                            aIndex, aRowIndex, aColumnIndex,
                            static_cast<unsigned>(aPair.mBitA), static_cast<unsigned>(aPair.mBitB));
                    return;
                }
                if (BitDistance(aPair.mBitA, aPair.mBitB) < 2U) {
                    XCTFail("Bit plane %zu, row %zu, column %zu: bits [%u, %u] are equal or adjacent.",
                            aIndex, aRowIndex, aColumnIndex,
                            static_cast<unsigned>(aPair.mBitA), static_cast<unsigned>(aPair.mBitB));
                    return;
                }
            }
            
            if (AllEight(aRow.mPairs[0].mBitA, aRow.mPairs[0].mBitB,
                         aRow.mPairs[1].mBitA, aRow.mPairs[1].mBitB,
                         aRow.mPairs[2].mBitA, aRow.mPairs[2].mBitB,
                         aRow.mPairs[3].mBitA, aRow.mPairs[3].mBitB) == false) {
                XCTFail("Bit plane %zu, row %zu: must contain each bit 0...7 exactly once.", aIndex, aRowIndex);
                return;
            }
        }
        
        for (std::size_t aColumnIndex=0U; aColumnIndex<4U; aColumnIndex++) {
            const BitPlaneColumn &aColumn = aBitPlane.mColumns[aColumnIndex];
            if (AllEight(aColumn.mPairs[0].mBitA, aColumn.mPairs[0].mBitB,
                         aColumn.mPairs[1].mBitA, aColumn.mPairs[1].mBitB,
                         aColumn.mPairs[2].mBitA, aColumn.mPairs[2].mBitB,
                         aColumn.mPairs[3].mBitA, aColumn.mPairs[3].mBitB) == false) {
                XCTFail("Bit plane %zu, column %zu: must contain each bit 0...7 exactly once.", aIndex, aColumnIndex);
                return;
            }
        }
    }
}

- (void)test_AllUniqueRows {
    // The value records the first plane index for a useful duplicate report.
    std::unordered_map<BitPlaneHashList, std::size_t, BitPlaneHashListHasher> aBag;

    for (std::size_t aIndex=0U; aIndex<BitPlaneFarm::kBitPlaneCount; aIndex++) {
        const BitPlane &aBitPlane = BitPlaneFarm::mBitPlanes[aIndex];
        BitPlaneHashList aRowHashes;
        for (std::size_t aRowIndex=0U; aRowIndex<4U; aRowIndex++) {
            const BitPlaneRow aRow = aBitPlane.GetRow(aRowIndex);
            aRowHashes.mHashes[aRowIndex] = HashPairs(aRow.mPairs);
        }
        aRowHashes.Sort();

        const auto aResult = aBag.emplace(aRowHashes, aIndex);
        if (aResult.second == false) {
            XCTFail("Bit planes %zu and %zu have all four rows in common, ignoring row order.",
                    aResult.first->second, aIndex);
            return;
        }
    }
}

- (void)test_AllUniqueCols {
    std::unordered_map<BitPlaneHashList, std::size_t, BitPlaneHashListHasher> aBag;

    for (std::size_t aIndex=0U; aIndex<BitPlaneFarm::kBitPlaneCount; aIndex++) {
        const BitPlane &aBitPlane = BitPlaneFarm::mBitPlanes[aIndex];
        BitPlaneHashList aColumnHashes;
        for (std::size_t aColumnIndex=0U; aColumnIndex<4U; aColumnIndex++) {
            aColumnHashes.mHashes[aColumnIndex] = HashPairs(aBitPlane.mColumns[aColumnIndex].mPairs);
        }
        aColumnHashes.Sort();

        const auto aResult = aBag.emplace(aColumnHashes, aIndex);
        if (aResult.second == false) {
            XCTFail("Bit planes %zu and %zu have all four columns in common, ignoring column order.",
                    aResult.first->second, aIndex);
            return;
        }
    }
}

@end
