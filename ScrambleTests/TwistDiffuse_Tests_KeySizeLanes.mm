//
//  TwistDiffuse_Tests_KeySizeLanes.mm
//  ScrambleTests
//
//  Created by Icarus Black on 8/24/26.
//

#import <XCTest/XCTest.h>

#include "TwistDiffuse.hpp"
#include "WorkSpaceTools.hpp"
#include "GutCheckValidator.hpp"
#include "Random.hpp"

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <unordered_map>
#include <unordered_set>
#include <vector>

@interface TwistDiffuse_Tests_KeySizeLanes : XCTestCase

@end

@implementation TwistDiffuse_Tests_KeySizeLanes

- (void)test_dispatch_KeyLanes {
    
    constexpr std::size_t kBlockSize = 64U;
    constexpr std::size_t kLaneCount = 4U;
    constexpr std::size_t kTrialCount = 50000U;
    
    constexpr std::size_t kBlocksPerLane =
        W_KEY / kBlockSize;
    
    constexpr std::size_t kTotalBlocks =
        kBlocksPerLane * kLaneCount;
    
    constexpr std::size_t kIndexListCount =
        W_KEY / (2U * kBlockSize);
    
    constexpr std::size_t kExpectedDistribution =
        kBlocksPerLane / kLaneCount;
    
    if ((W_KEY % kBlockSize) != 0U) {
        XCTFail(
            "test_dispatch_KeyLanes: expected W_KEY to be divisible by 64, got %zu",
            static_cast<std::size_t>(W_KEY)
        );
        return;
    }
    
    if (kIndexListCount != 16U) {
        XCTFail(
            "test_dispatch_KeyLanes: expected index list count 16, got %zu",
            kIndexListCount
        );
        return;
    }
    
    if ((kBlocksPerLane % kLaneCount) != 0U) {
        XCTFail(
            "test_dispatch_KeyLanes: expected %zu blocks per lane to be divisible by %zu lanes",
            kBlocksPerLane,
            kLaneCount
        );
        return;
    }
    
    printf(
        "test_dispatch_KeyLanes: %zu blocks total, "
        "%zu blocks per lane, expected distribution %zu each\n",
        kTotalBlocks,
        kBlocksPerLane,
        kExpectedDistribution
    );
    
    std::uint8_t aLaneA[W_KEY];
    std::uint8_t aLaneB[W_KEY];
    std::uint8_t aLaneC[W_KEY];
    std::uint8_t aLaneD[W_KEY];
    
    std::uint8_t aEntropyA[W_KEY];
    std::uint8_t aEntropyB[W_KEY];
    std::uint8_t aEntropyC[W_KEY];
    std::uint8_t aEntropyD[W_KEY];
    
    std::uint8_t aDestA[W_KEY];
    std::uint8_t aDestB[W_KEY];
    std::uint8_t aDestC[W_KEY];
    std::uint8_t aDestD[W_KEY];
    
    std::array<std::size_t, kIndexListCount> aIndexListA;
    std::array<std::size_t, kIndexListCount> aIndexListB;
    std::array<std::size_t, kIndexListCount> aIndexListC;
    std::array<std::size_t, kIndexListCount> aIndexListD;
    
    std::array<std::uint8_t *, kLaneCount> aLanes = {
        aLaneA,
        aLaneB,
        aLaneC,
        aLaneD
    };
    
    std::array<std::uint8_t *, kLaneCount> aDests = {
        aDestA,
        aDestB,
        aDestC,
        aDestD
    };
    
    constexpr std::array<const char *, kLaneCount>
    kLaneNames = {
        "A",
        "B",
        "C",
        "D"
    };
    
    for (std::size_t aTrial = 0U;
         aTrial < kTrialCount;
         aTrial++) {
        
        if ((aTrial % 10000) == 0) {
            printf("test_dispatch_KeyLanes, Trial #%zu\n", aTrial);
        }
        
        WorkSpaceTools::FillBytes(aEntropyA, W_KEY);
        WorkSpaceTools::FillBytes(aEntropyB, W_KEY);
        WorkSpaceTools::FillBytes(aEntropyC, W_KEY);
        WorkSpaceTools::FillBytes(aEntropyD, W_KEY);
        
        std::fill_n(aLaneA, W_KEY, 0U);
        std::fill_n(aLaneB, W_KEY, 0U);
        std::fill_n(aLaneC, W_KEY, 0U);
        std::fill_n(aLaneD, W_KEY, 0U);
        
        std::fill_n(aDestA, W_KEY, 0U);
        std::fill_n(aDestB, W_KEY, 0U);
        std::fill_n(aDestC, W_KEY, 0U);
        std::fill_n(aDestD, W_KEY, 0U);
        
        /*
         * Sorted block keys make the generated blocks unique even
         * when their bytes appear in different orders.
         */
        std::unordered_set<
            std::vector<std::uint8_t>,
            ByteListHash
        > aBlockSet;
        
        aBlockSet.reserve(kTotalBlocks * 2U);
        
        std::vector<std::vector<std::uint8_t>> aBlocks;
        aBlocks.reserve(kTotalBlocks);
        
        while (aBlocks.size() < kTotalBlocks) {
            std::vector<std::uint8_t> aBlock(kBlockSize);
            
            WorkSpaceTools::FillBytes(
                aBlock.data(),
                aBlock.size()
            );
            
            std::vector<std::uint8_t> aBlockKey =
                aBlock;
            
            std::sort(
                aBlockKey.begin(),
                aBlockKey.end()
            );
            
            if (aBlockSet.insert(aBlockKey).second) {
                aBlocks.push_back(std::move(aBlock));
            }
        }
        
        Random::Shuffle(&aBlocks);
        
        std::array<std::size_t, kLaneCount>
        aLaneOffsets{};
        
        std::vector<std::size_t> aSourceLaneForBlock(
            kTotalBlocks,
            0U
        );
        
        std::unordered_map<
            std::vector<std::uint8_t>,
            std::size_t,
            ByteListHash
        > aBlockLookup;
        
        aBlockLookup.reserve(kTotalBlocks * 2U);
        
        /*
         * Distribute the source blocks:
         *
         * A, B, C, D, A, B, C, D...
         */
        for (std::size_t aBlockIndex = 0U;
             aBlockIndex < aBlocks.size();
             aBlockIndex++) {
            
            const std::size_t aLaneIndex =
                aBlockIndex % kLaneCount;
            
            const std::size_t aWriteOffset =
                aLaneOffsets[aLaneIndex];
            
            if ((aWriteOffset > W_KEY) ||
                (kBlockSize >
                 (W_KEY - aWriteOffset))) {
                
                XCTFail(
                    "test_dispatch_KeyLanes: trial %zu, block %zu did not fit in lane %s at offset %zu",
                    aTrial,
                    aBlockIndex,
                    kLaneNames[aLaneIndex],
                    aWriteOffset
                );
                return;
            }
            
            std::vector<std::uint8_t> &aBlock =
                aBlocks[aBlockIndex];
            
            Random::Shuffle(&aBlock);
            
            std::memcpy(
                aLanes[aLaneIndex] + aWriteOffset,
                aBlock.data(),
                kBlockSize
            );
            
            aSourceLaneForBlock[aBlockIndex] =
                aLaneIndex;
            
            std::vector<std::uint8_t> aBlockKey =
                aBlock;
            
            std::sort(
                aBlockKey.begin(),
                aBlockKey.end()
            );
            
            const bool aInserted =
                aBlockLookup.emplace(
                    std::move(aBlockKey),
                    aBlockIndex
                ).second;
            
            if (aInserted == false) {
                XCTFail(
                    "test_dispatch_KeyLanes: trial %zu, block %zu unexpectedly had a duplicate canonical key",
                    aTrial,
                    aBlockIndex
                );
                return;
            }
            
            aLaneOffsets[aLaneIndex] +=
                kBlockSize;
        }
        
        for (std::size_t aLaneIndex = 0U;
             aLaneIndex < kLaneCount;
             aLaneIndex++) {
            
            if (aLaneOffsets[aLaneIndex] != W_KEY) {
                XCTFail(
                    "test_dispatch_KeyLanes: trial %zu, expected lane %s to contain %zu bytes, got %zu",
                    aTrial,
                    kLaneNames[aLaneIndex],
                    static_cast<std::size_t>(W_KEY),
                    aLaneOffsets[aLaneIndex]
                );
                return;
            }
        }
        
        M88 aMatrix;
        
        TwistDiffuse::KeyDiffuseWithDomainWords(
            aEntropyA,
            aEntropyB,
            aEntropyC,
            aEntropyD,
            
            aLaneA,
            aLaneB,
            aLaneC,
            aLaneD,
            
            aDestA,
            aDestB,
            aDestC,
            aDestD,
            
            aIndexListA.data(),
            aIndexListB.data(),
            aIndexListC.data(),
            aIndexListD.data(),
            
            &aMatrix,
            
            Random::Get64(),
            Random::Get64(),
            
            Random::GetByte(),
            Random::GetByte(),
            
            Random::GetByte(),
            Random::GetByte(),
            Random::GetByte(),
            Random::GetByte()
        );
        
        /*
         * aDistribution[source lane][destination lane]
         */
        std::array<
            std::array<std::size_t, kLaneCount>,
            kLaneCount
        > aDistribution{};
        
        std::vector<bool> aBlockFound(
            kTotalBlocks,
            false
        );
        
        std::size_t aFoundCount = 0U;
        
        for (std::size_t aDestLaneIndex = 0U;
             aDestLaneIndex < kLaneCount;
             aDestLaneIndex++) {
            
            for (std::size_t aDestBlockIndex = 0U;
                 aDestBlockIndex < kBlocksPerLane;
                 aDestBlockIndex++) {
                
                const std::size_t aReadOffset =
                    aDestBlockIndex * kBlockSize;
                
                const std::uint8_t *aDestBlock =
                    aDests[aDestLaneIndex] +
                    aReadOffset;
                
                std::vector<std::uint8_t> aBlockKey(
                    aDestBlock,
                    aDestBlock + kBlockSize
                );
                
                std::sort(
                    aBlockKey.begin(),
                    aBlockKey.end()
                );
                
                const auto aFoundIterator =
                    aBlockLookup.find(aBlockKey);
                
                if (aFoundIterator ==
                    aBlockLookup.end()) {
                    
                    XCTFail(
                        "test_dispatch_KeyLanes: trial %zu, destination lane %s block %zu did not match any source block",
                        aTrial,
                        kLaneNames[aDestLaneIndex],
                        aDestBlockIndex
                    );
                    return;
                }
                
                const std::size_t aSourceBlockIndex =
                    aFoundIterator->second;
                
                if (aSourceBlockIndex >=
                    aBlockFound.size()) {
                    
                    XCTFail(
                        "test_dispatch_KeyLanes: trial %zu, destination lane %s block %zu returned invalid source block index %zu",
                        aTrial,
                        kLaneNames[aDestLaneIndex],
                        aDestBlockIndex,
                        aSourceBlockIndex
                    );
                    return;
                }
                
                if (aBlockFound[aSourceBlockIndex]) {
                    XCTFail(
                        "test_dispatch_KeyLanes: trial %zu, source block %zu appeared more than once; duplicate found at destination lane %s block %zu",
                        aTrial,
                        aSourceBlockIndex,
                        kLaneNames[aDestLaneIndex],
                        aDestBlockIndex
                    );
                    return;
                }
                
                aBlockFound[aSourceBlockIndex] = true;
                aFoundCount++;
                
                const std::size_t aSourceLaneIndex =
                    aSourceLaneForBlock[
                        aSourceBlockIndex
                    ];
                
                aDistribution[aSourceLaneIndex]
                             [aDestLaneIndex]++;
            }
        }
        
        if (aFoundCount != kTotalBlocks) {
            XCTFail(
                "test_dispatch_KeyLanes: trial %zu, expected to find %zu blocks, found %zu",
                aTrial,
                kTotalBlocks,
                aFoundCount
            );
            return;
        }
        
        for (std::size_t aBlockIndex = 0U;
             aBlockIndex < aBlockFound.size();
             aBlockIndex++) {
            
            if (aBlockFound[aBlockIndex] == false) {
                XCTFail(
                    "test_dispatch_KeyLanes: trial %zu, source block %zu was missing from the destination lanes",
                    aTrial,
                    aBlockIndex
                );
                return;
            }
        }
        
        for (std::size_t aSourceLaneIndex = 0U;
             aSourceLaneIndex < kLaneCount;
             aSourceLaneIndex++) {
            
            std::size_t aDistributionTotal = 0U;
            
            for (std::size_t aDestLaneIndex = 0U;
                 aDestLaneIndex < kLaneCount;
                 aDestLaneIndex++) {
                
                aDistributionTotal +=
                    aDistribution[aSourceLaneIndex]
                                 [aDestLaneIndex];
            }
            
            if (aDistributionTotal !=
                kBlocksPerLane) {
                
                XCTFail(
                    "test_dispatch_KeyLanes: trial %zu, source lane %s expected %zu distributed blocks, got %zu",
                    aTrial,
                    kLaneNames[aSourceLaneIndex],
                    kBlocksPerLane,
                    aDistributionTotal
                );
                return;
            }
        }
        
        /*
         * Each source lane contains 32 blocks. Equal distribution
         * requires 8 blocks in every destination lane.
         */
        if ((aDistribution[0][0] !=
             kExpectedDistribution) ||
            (aDistribution[0][1] !=
             kExpectedDistribution) ||
            (aDistribution[0][2] !=
             kExpectedDistribution) ||
            (aDistribution[0][3] !=
             kExpectedDistribution)) {
            
            XCTFail(
                "test_dispatch_KeyLanes: trial %zu, LaneA expected Dests[A: %zu, B: %zu, C: %zu, D: %zu], got Dests[A: %zu, B: %zu, C: %zu, D: %zu]",
                aTrial,
                kExpectedDistribution,
                kExpectedDistribution,
                kExpectedDistribution,
                kExpectedDistribution,
                aDistribution[0][0],
                aDistribution[0][1],
                aDistribution[0][2],
                aDistribution[0][3]
            );
            return;
        }
        
        if ((aDistribution[1][0] !=
             kExpectedDistribution) ||
            (aDistribution[1][1] !=
             kExpectedDistribution) ||
            (aDistribution[1][2] !=
             kExpectedDistribution) ||
            (aDistribution[1][3] !=
             kExpectedDistribution)) {
            
            XCTFail(
                "test_dispatch_KeyLanes: trial %zu, LaneB expected Dests[A: %zu, B: %zu, C: %zu, D: %zu], got Dests[A: %zu, B: %zu, C: %zu, D: %zu]",
                aTrial,
                kExpectedDistribution,
                kExpectedDistribution,
                kExpectedDistribution,
                kExpectedDistribution,
                aDistribution[1][0],
                aDistribution[1][1],
                aDistribution[1][2],
                aDistribution[1][3]
            );
            return;
        }
        
        if ((aDistribution[2][0] !=
             kExpectedDistribution) ||
            (aDistribution[2][1] !=
             kExpectedDistribution) ||
            (aDistribution[2][2] !=
             kExpectedDistribution) ||
            (aDistribution[2][3] !=
             kExpectedDistribution)) {
            
            XCTFail(
                "test_dispatch_KeyLanes: trial %zu, LaneC expected Dests[A: %zu, B: %zu, C: %zu, D: %zu], got Dests[A: %zu, B: %zu, C: %zu, D: %zu]",
                aTrial,
                kExpectedDistribution,
                kExpectedDistribution,
                kExpectedDistribution,
                kExpectedDistribution,
                aDistribution[2][0],
                aDistribution[2][1],
                aDistribution[2][2],
                aDistribution[2][3]
            );
            return;
        }
        
        if ((aDistribution[3][0] !=
             kExpectedDistribution) ||
            (aDistribution[3][1] !=
             kExpectedDistribution) ||
            (aDistribution[3][2] !=
             kExpectedDistribution) ||
            (aDistribution[3][3] !=
             kExpectedDistribution)) {
            
            XCTFail(
                "test_dispatch_KeyLanes: trial %zu, LaneD expected Dests[A: %zu, B: %zu, C: %zu, D: %zu], got Dests[A: %zu, B: %zu, C: %zu, D: %zu]",
                aTrial,
                kExpectedDistribution,
                kExpectedDistribution,
                kExpectedDistribution,
                kExpectedDistribution,
                aDistribution[3][0],
                aDistribution[3][1],
                aDistribution[3][2],
                aDistribution[3][3]
            );
            return;
        }
        
        /*
         * Count exact positional byte differences for all 16
         * source/destination combinations.
         */
        std::array<
            std::array<std::size_t, kLaneCount>,
            kLaneCount
        > aDifferenceCounts{};
        
        for (std::size_t aLaneIndex = 0U;
             aLaneIndex < kLaneCount;
             aLaneIndex++) {
            
            for (std::size_t aDestIndex = 0U;
                 aDestIndex < kLaneCount;
                 aDestIndex++) {
                
                for (std::size_t aByteIndex = 0U;
                     aByteIndex < W_KEY;
                     aByteIndex++) {
                    
                    if (aLanes[aLaneIndex][aByteIndex] !=
                        aDests[aDestIndex][aByteIndex]) {
                        
                        aDifferenceCounts[aLaneIndex]
                                         [aDestIndex]++;
                    }
                }
            }
        }
        
        constexpr std::size_t kMinimumDifferenceCount =
            ((W_KEY * 90U) + 99U) / 100U;
        
        
        
        /*
         * All 16 source/destination comparisons must be at least
         * 90 percent positionally different.
         */
        for (std::size_t aLaneIndex = 0U;
             aLaneIndex < kLaneCount;
             aLaneIndex++) {
            
            for (std::size_t aDestIndex = 0U;
                 aDestIndex < kLaneCount;
                 aDestIndex++) {
                
                if (aDifferenceCounts[aLaneIndex]
                                     [aDestIndex] <
                    kMinimumDifferenceCount) {
                    
                    XCTFail(
                        "test_dispatch_KeyLanes: trial %zu, expected dest %s to differ from lane %s by at least %zu bytes, got %zu",
                        aTrial,
                        kLaneNames[aDestIndex],
                        kLaneNames[aLaneIndex],
                        kMinimumDifferenceCount,
                        aDifferenceCounts[aLaneIndex]
                                         [aDestIndex]
                    );
                    return;
                }
            }
        }
    }
}

@end
