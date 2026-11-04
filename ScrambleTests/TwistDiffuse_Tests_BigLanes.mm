//
//  TwistDiffuse_Tests_BigLanes.mm
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

@interface TwistDiffuse_Tests_BigLanes : XCTestCase

@end

@implementation TwistDiffuse_Tests_BigLanes

- (void)test_dispatch_BigLanes {
    
    constexpr std::size_t kBlockSize = 64U;
    constexpr std::size_t kLaneCount = 4U;
    constexpr std::size_t kTrialCount = 7001U;
    constexpr std::size_t kBlocksPerLane = S_BLOCK / kBlockSize;
    constexpr std::size_t kTotalBlocks =
    kBlocksPerLane * kLaneCount;
    
    if ((S_BLOCK % kBlockSize) != 0U) {
        XCTFail(
                "test_dispatch_BigLanes: expected S_BLOCK to be divisible by 64, got %zu",
                static_cast<std::size_t>(S_BLOCK)
                );
        return;
    }
    
    printf(
           "test_dispatch_BigLanes: %zu blocks total, "
           "%zu blocks per lane\n",
           kTotalBlocks,
           kBlocksPerLane
           );
    
    std::uint8_t aLaneA[S_BLOCK];
    std::uint8_t aLaneB[S_BLOCK];
    std::uint8_t aLaneC[S_BLOCK];
    std::uint8_t aLaneD[S_BLOCK];
    
    std::uint8_t aEntropyA[S_BLOCK];
    std::uint8_t aEntropyB[S_BLOCK];
    std::uint8_t aEntropyC[S_BLOCK];
    std::uint8_t aEntropyD[S_BLOCK];
    
    std::uint8_t aDestA[S_BLOCK];
    std::uint8_t aDestB[S_BLOCK];
    std::uint8_t aDestC[S_BLOCK];
    std::uint8_t aDestD[S_BLOCK];
    
    std::array<std::size_t, kBlocksPerLane> aIndexListA;
    std::array<std::size_t, kBlocksPerLane> aIndexListB;
    std::array<std::size_t, kBlocksPerLane> aIndexListC;
    std::array<std::size_t, kBlocksPerLane> aIndexListD;
    
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
    
    constexpr std::array<const char *, kLaneCount> kLaneNames = {
        "A",
        "B",
        "C",
        "D"
    };
    
    for (std::size_t aTrial = 0U;
         aTrial < kTrialCount;
         aTrial++) {
        
        if ((aTrial % 1000) == 0) {
            printf("test_dispatch_BigLanes, Trial #%zu\n", aTrial);
        }
        
        
        WorkSpaceTools::FillBytes(aEntropyA, S_BLOCK);
        WorkSpaceTools::FillBytes(aEntropyB, S_BLOCK);
        WorkSpaceTools::FillBytes(aEntropyC, S_BLOCK);
        WorkSpaceTools::FillBytes(aEntropyD, S_BLOCK);
        
        std::fill_n(aLaneA, S_BLOCK, 0U);
        std::fill_n(aLaneB, S_BLOCK, 0U);
        std::fill_n(aLaneC, S_BLOCK, 0U);
        std::fill_n(aLaneD, S_BLOCK, 0U);
        
        std::fill_n(aDestA, S_BLOCK, 0U);
        std::fill_n(aDestB, S_BLOCK, 0U);
        std::fill_n(aDestC, S_BLOCK, 0U);
        std::fill_n(aDestD, S_BLOCK, 0U);
        
        /*
         * The set contains sorted copies of the blocks. This makes
         * blocks unique regardless of their internal byte order.
         */
        std::unordered_set<std::vector<std::uint8_t>, ByteListHash> aBlockSet;
        
        aBlockSet.reserve(kTotalBlocks * 2U);
        
        std::vector<std::vector<std::uint8_t>> aBlocks;
        aBlocks.reserve(kTotalBlocks);
        
        while (aBlocks.size() < kTotalBlocks) {
            std::vector<std::uint8_t> aBlock(kBlockSize);
            
            WorkSpaceTools::FillBytes(aBlock.data(), aBlock.size());
            
            std::vector<std::uint8_t> aBlockKey = aBlock;
            
            std::sort(aBlockKey.begin(), aBlockKey.end());
            
            if (aBlockSet.insert(aBlockKey).second) {
                aBlocks.push_back(std::move(aBlock));
            }
        }
        
        /*
         * Randomize which unique block goes into which source lane
         * and source position.
         */
        Random::Shuffle(&aBlocks);
        
        std::array<std::size_t, kLaneCount> aLaneOffsets{};
        
        /*
         * Records the source lane for each block. This lets us print
         * the source-lane-to-destination-lane distribution later.
         */
        std::vector<std::size_t> aSourceLaneForBlock(kTotalBlocks, 0U);
        
        /*
         * Maps a canonical sorted block to its index in aBlocks.
         * Destination lookup is approximately O(1) per block.
         */
        std::unordered_map<
        std::vector<std::uint8_t>,
        std::size_t,
        ByteListHash
        > aBlockLookup;
        
        aBlockLookup.reserve(kTotalBlocks * 2U);
        
        for (std::size_t aBlockIndex = 0U;
             aBlockIndex < aBlocks.size();
             aBlockIndex++) {
            
            const std::size_t aLaneIndex =
            aBlockIndex % kLaneCount;
            
            const std::size_t aWriteOffset =
            aLaneOffsets[aLaneIndex];
            
            if ((aWriteOffset > S_BLOCK) ||
                (kBlockSize > (S_BLOCK - aWriteOffset))) {
                
                XCTFail(
                        "test_dispatch_BigLanes: trial %zu, block %zu did not fit in lane %s at offset %zu",
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
                        "test_dispatch_BigLanes: trial %zu, block %zu unexpectedly had a duplicate canonical key",
                        aTrial,
                        aBlockIndex
                        );
                return;
            }
            
            aLaneOffsets[aLaneIndex] += kBlockSize;
        }
        
        for (std::size_t aLaneIndex = 0U;
             aLaneIndex < kLaneCount;
             aLaneIndex++) {
            
            if (aLaneOffsets[aLaneIndex] != S_BLOCK) {
                XCTFail(
                        "test_dispatch_BigLanes: trial %zu, expected lane %s to contain %zu bytes, got %zu",
                        aTrial,
                        kLaneNames[aLaneIndex],
                        static_cast<std::size_t>(S_BLOCK),
                        aLaneOffsets[aLaneIndex]
                        );
                return;
            }
        }
        
        M88 aMatrix;
        
        TwistDiffuse::DiffuseWithDomainWords(
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
                aDests[aDestLaneIndex] + aReadOffset;
                
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
                            "test_dispatch_BigLanes: trial %zu, destination lane %s block %zu did not match any source block",
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
                            "test_dispatch_BigLanes: trial %zu, destination lane %s block %zu returned invalid source block index %zu",
                            aTrial,
                            kLaneNames[aDestLaneIndex],
                            aDestBlockIndex,
                            aSourceBlockIndex
                            );
                    return;
                }
                
                if (aBlockFound[aSourceBlockIndex]) {
                    XCTFail(
                            "test_dispatch_BigLanes: trial %zu, source block %zu appeared more than once; duplicate found at destination lane %s block %zu",
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
                aSourceLaneForBlock[aSourceBlockIndex];
                
                aDistribution[aSourceLaneIndex]
                [aDestLaneIndex]++;
            }
        }
        
        if (aFoundCount != kTotalBlocks) {
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, expected to find %zu blocks, found %zu",
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
                        "test_dispatch_BigLanes: trial %zu, source block %zu was missing from the destination lanes",
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
                        "test_dispatch_BigLanes: trial %zu, source lane %s expected %zu distributed blocks, got %zu",
                        aTrial,
                        kLaneNames[aSourceLaneIndex],
                        kBlocksPerLane,
                        aDistributionTotal
                        );
                return;
            }
        }
        
        
        if ((aDistribution[0][0] != 128U) ||
            (aDistribution[0][1] != 128U) ||
            (aDistribution[0][2] != 128U) ||
            (aDistribution[0][3] != 128U)) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, LaneA expected Dests[A: 128, B: 128, C: 128, D: 128], got Dests[A: %zu, B: %zu, C: %zu, D: %zu]",
                    aTrial,
                    aDistribution[0][0],
                    aDistribution[0][1],
                    aDistribution[0][2],
                    aDistribution[0][3]
                    );
            return;
        }
        
        if ((aDistribution[1][0] != 128U) ||
            (aDistribution[1][1] != 128U) ||
            (aDistribution[1][2] != 128U) ||
            (aDistribution[1][3] != 128U)) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, LaneB expected Dests[A: 128, B: 128, C: 128, D: 128], got Dests[A: %zu, B: %zu, C: %zu, D: %zu]",
                    aTrial,
                    aDistribution[1][0],
                    aDistribution[1][1],
                    aDistribution[1][2],
                    aDistribution[1][3]
                    );
            return;
        }
        
        if ((aDistribution[2][0] != 128U) ||
            (aDistribution[2][1] != 128U) ||
            (aDistribution[2][2] != 128U) ||
            (aDistribution[2][3] != 128U)) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, LaneC expected Dests[A: 128, B: 128, C: 128, D: 128], got Dests[A: %zu, B: %zu, C: %zu, D: %zu]",
                    aTrial,
                    aDistribution[2][0],
                    aDistribution[2][1],
                    aDistribution[2][2],
                    aDistribution[2][3]
                    );
            return;
        }
        
        if ((aDistribution[3][0] != 128U) ||
            (aDistribution[3][1] != 128U) ||
            (aDistribution[3][2] != 128U) ||
            (aDistribution[3][3] != 128U)) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, LaneD expected Dests[A: 128, B: 128, C: 128, D: 128], got Dests[A: %zu, B: %zu, C: %zu, D: %zu]",
                    aTrial,
                    aDistribution[3][0],
                    aDistribution[3][1],
                    aDistribution[3][2],
                    aDistribution[3][3]
                    );
            return;
        }
        
        /*
         * Positional byte differences between every source lane and
         * every destination lane.
         *
         * A byte is different only when:
         *
         *     source[aIndex] != destination[aIndex]
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
                     aByteIndex < S_BLOCK;
                     aByteIndex++) {
                    
                    if (aLanes[aLaneIndex][aByteIndex] !=
                        aDests[aDestIndex][aByteIndex]) {
                        
                        aDifferenceCounts[aLaneIndex]
                        [aDestIndex]++;
                    }
                }
            }
        }
        
        /*
         * Round upward so "at least 90%" is enforced even when the
         * lane size is not evenly divisible by 100.
         */
        constexpr std::size_t kMinimumDifferenceCount =
        ((S_BLOCK * 90U) + 99U) / 100U;
        
        if (aDifferenceCounts[0][0] <
            kMinimumDifferenceCount) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, expected dest A to differ from lane A at least %zu bytes, got %zu",
                    aTrial,
                    kMinimumDifferenceCount,
                    aDifferenceCounts[0][0]
                    );
            return;
        }
        
        if (aDifferenceCounts[0][1] <
            kMinimumDifferenceCount) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, expected dest B to differ from lane A at least %zu bytes, got %zu",
                    aTrial,
                    kMinimumDifferenceCount,
                    aDifferenceCounts[0][1]
                    );
            return;
        }
        
        if (aDifferenceCounts[0][2] <
            kMinimumDifferenceCount) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, expected dest C to differ from lane A at least %zu bytes, got %zu",
                    aTrial,
                    kMinimumDifferenceCount,
                    aDifferenceCounts[0][2]
                    );
            return;
        }
        
        if (aDifferenceCounts[0][3] <
            kMinimumDifferenceCount) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, expected dest D to differ from lane A at least %zu bytes, got %zu",
                    aTrial,
                    kMinimumDifferenceCount,
                    aDifferenceCounts[0][3]
                    );
            return;
        }
        
        if (aDifferenceCounts[1][0] <
            kMinimumDifferenceCount) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, expected dest A to differ from lane B at least %zu bytes, got %zu",
                    aTrial,
                    kMinimumDifferenceCount,
                    aDifferenceCounts[1][0]
                    );
            return;
        }
        
        if (aDifferenceCounts[1][1] <
            kMinimumDifferenceCount) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, expected dest B to differ from lane B at least %zu bytes, got %zu",
                    aTrial,
                    kMinimumDifferenceCount,
                    aDifferenceCounts[1][1]
                    );
            return;
        }
        
        if (aDifferenceCounts[1][2] <
            kMinimumDifferenceCount) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, expected dest C to differ from lane B at least %zu bytes, got %zu",
                    aTrial,
                    kMinimumDifferenceCount,
                    aDifferenceCounts[1][2]
                    );
            return;
        }
        
        if (aDifferenceCounts[1][3] <
            kMinimumDifferenceCount) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, expected dest D to differ from lane B at least %zu bytes, got %zu",
                    aTrial,
                    kMinimumDifferenceCount,
                    aDifferenceCounts[1][3]
                    );
            return;
        }
        
        if (aDifferenceCounts[2][0] <
            kMinimumDifferenceCount) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, expected dest A to differ from lane C at least %zu bytes, got %zu",
                    aTrial,
                    kMinimumDifferenceCount,
                    aDifferenceCounts[2][0]
                    );
            return;
        }
        
        if (aDifferenceCounts[2][1] <
            kMinimumDifferenceCount) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, expected dest B to differ from lane C at least %zu bytes, got %zu",
                    aTrial,
                    kMinimumDifferenceCount,
                    aDifferenceCounts[2][1]
                    );
            return;
        }
        
        if (aDifferenceCounts[2][2] <
            kMinimumDifferenceCount) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, expected dest C to differ from lane C at least %zu bytes, got %zu",
                    aTrial,
                    kMinimumDifferenceCount,
                    aDifferenceCounts[2][2]
                    );
            return;
        }
        
        if (aDifferenceCounts[2][3] <
            kMinimumDifferenceCount) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, expected dest D to differ from lane C at least %zu bytes, got %zu",
                    aTrial,
                    kMinimumDifferenceCount,
                    aDifferenceCounts[2][3]
                    );
            return;
        }
        
        if (aDifferenceCounts[3][0] <
            kMinimumDifferenceCount) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, expected dest A to differ from lane D at least %zu bytes, got %zu",
                    aTrial,
                    kMinimumDifferenceCount,
                    aDifferenceCounts[3][0]
                    );
            return;
        }
        
        if (aDifferenceCounts[3][1] <
            kMinimumDifferenceCount) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, expected dest B to differ from lane D at least %zu bytes, got %zu",
                    aTrial,
                    kMinimumDifferenceCount,
                    aDifferenceCounts[3][1]
                    );
            return;
        }
        
        if (aDifferenceCounts[3][2] <
            kMinimumDifferenceCount) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, expected dest C to differ from lane D at least %zu bytes, got %zu",
                    aTrial,
                    kMinimumDifferenceCount,
                    aDifferenceCounts[3][2]
                    );
            return;
        }
        
        if (aDifferenceCounts[3][3] <
            kMinimumDifferenceCount) {
            
            XCTFail(
                    "test_dispatch_BigLanes: trial %zu, expected dest D to differ from lane D at least %zu bytes, got %zu",
                    aTrial,
                    kMinimumDifferenceCount,
                    aDifferenceCounts[3][3]
                    );
            return;
        }
        
    }
}

@end
