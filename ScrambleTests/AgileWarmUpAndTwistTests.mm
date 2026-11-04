//
//  AgileWarmUpAndTwistTests.m
//  ScrambleTests
//
//  Created by Icarus Black on 8/10/26.
//

#import <XCTest/XCTest.h>
#include "Soccer3.hpp"
#include "WorkSpaceTools.hpp"
#include "LaneTool.hpp"
#include "Random.hpp"
#include <cstdint>
#include <cstring>
#include <string>
#include <unordered_set>

@interface AgileWarmUpAndTwistTests : XCTestCase

@end

@implementation AgileWarmUpAndTwistTests

void FakeTwistRound(std::size_t pBlockIndex, EncryptionStrength pStrength) {
    
    std::size_t aComplexity = 8;
    if (pStrength == EncryptionStrength::kWeak) {
        aComplexity = 4;
    } else if (pStrength == EncryptionStrength::kStrong) {
        aComplexity = 16;
    }
    
    const std::size_t aDestinationByteIndex = pBlockIndex * S_BLOCK;
    for (std::size_t aLaneIndex=0U; aLaneIndex<aComplexity; aLaneIndex++) {
        WorkSpaceTools::FillBytes(&Soccer3::mMaterials[aLaneIndex][aDestinationByteIndex], S_BLOCK);
    }

    for (std::size_t aLaneIndex=0U; aLaneIndex<aComplexity; aLaneIndex++) {
        Soccer3::mSources[aLaneIndex] = &Soccer3::mMaterials[aLaneIndex][aDestinationByteIndex];
    }
    
    WorkSpaceTools::FillBytes(Soccer3::mRandom, S_BLOCK);
    
    Soccer3::Shuffle_CROWSCIMASSORMATEX();
}

bool VerifyPreTwist(std::size_t pBlockIndex, EncryptionStrength pStrength, bool pIsEarlyRound) {
    
    std::size_t aComplexity = 8;
    if (pStrength == EncryptionStrength::kWeak) {
        aComplexity = 4;
    } else if (pStrength == EncryptionStrength::kStrong) {
        aComplexity = 16;
    }
    
    std::size_t aVerified = 0;
    std::size_t aBack1 = 0;
    
    if (pBlockIndex == 0) {
        aBack1 = 31;
    } else {
        aBack1 = pBlockIndex - 1;
    }
    
    std::size_t aBack2 = 0;
    if (aBack1 == 0) {
        aBack2 = 31;
    } else {
        aBack2 = aBack1 - 1;
    }
    
    std::size_t aBack3 = 0;
    if (aBack2 == 0) {
        aBack3 = 31;
    } else {
        aBack3 = aBack2 - 1;
    }
    
    std::size_t aBack4 = 0;
    if (aBack3 == 0) {
        aBack4 = 31;
    } else {
        aBack4 = aBack3 - 1;
    }
    
    std::size_t aBack5 = 0;
    if (aBack4 == 0) {
        aBack5 = 31;
    } else {
        aBack5 = aBack4 - 1;
    }
    
    std::unordered_set<std::uint8_t *> aSourceSet;
    for (std::size_t aLaneIndex=0U; aLaneIndex<aComplexity; aLaneIndex++) {
        if (aSourceSet.contains(Soccer3::mSources[aLaneIndex])) {
            printf("VerifyPreTwist, Fail: Did not expect duplicate source.");
            return false;
        }
        aSourceSet.insert(Soccer3::mSources[aLaneIndex]);
    }
    
    std::size_t aExpectedByte = aBack1 * S_BLOCK;
    
    for (auto aSource : aSourceSet) {
        aVerified++;
        
        bool aIsMaterial = false;
        for (std::size_t aMatIndex=0;aMatIndex<aComplexity;aMatIndex++) {
            if (&Soccer3::mMaterials[aMatIndex][aExpectedByte] == aSource) {
                aIsMaterial = true;
                break;
            }
        }
        
        if (aIsMaterial == false) {
            printf("VerifyPreTwist, Fail: Source was not a material.\n");
            return false;
        }
        
        const std::size_t aByteRichness = LaneTool::ByteRichness(aSource, S_BLOCK);
        if (aByteRichness < 512) {
            printf("VerifyPreTwist, Fail: expected source lane byte richess 512+, got %zu", aByteRichness);
            return false;
        }
    }
    
    constexpr std::size_t aCrossCount = 4U;
    for (std::size_t aLaneIndex=0U; aLaneIndex<aComplexity; aLaneIndex++) {
        std::size_t aCount = Soccer3::mCrossPoolCount[aLaneIndex];
        std::unordered_set<std::size_t> aPermuItems;
        
        for (std::size_t aCrossIndex=0U; aCrossIndex<aCrossCount; aCrossIndex++) {
            const std::size_t aPoolIndex = Soccer3::mCrossPermutations[aLaneIndex][aCrossIndex];
            if (aPoolIndex >= aCount) {
                printf("Fatal: Invalid pool index: %zu / %zu\n", aPoolIndex, aCount);
                exit(0);
            }
            if (aPermuItems.contains(aPoolIndex)) {
                printf("Fatal: Dupe pool index: %zu\n", aPoolIndex);
                exit(0);
            }
            aPermuItems.insert(aPoolIndex);
        }
    }
    for (std::size_t aLaneIndex=0U; aLaneIndex<aComplexity; aLaneIndex++) {
        
        std::unordered_set<std::uint8_t *> aLanez;
        aLanez.insert(Soccer3::mSources[aLaneIndex]);
        
        for (std::size_t aCrossIndex=0U; aCrossIndex<4; aCrossIndex++) {
            std::uint8_t *aCrossLane = Soccer3::mCross[aCrossIndex][aLaneIndex];
            if (aLanez.contains(aCrossLane)) {
                printf("Fatal: Lane %zu has dupe entry.\n", aLaneIndex);
                exit(0);
            }
            aLanez.insert(aCrossLane);
        }
        
        for (auto aLane: aLanez) {
            
            const std::size_t aByteRichness = LaneTool::ByteRichness(aLane, S_BLOCK);
            if (aByteRichness < 512) {
                printf("VerifyPreTwist, Fail: expected cross lane byte richess 512+, got %zu", aByteRichness);
                return false;
            }
        }
    }
    
    for (std::size_t aLaneIndex=0U; aLaneIndex<aComplexity; aLaneIndex++) {
        
        std::size_t aPoolSize = Soccer3::mCrossPoolCount[0];
        
        if (aPoolSize == 4) {
            
        } else if (aPoolSize == 8) {
            
        } else if (aPoolSize == 16) {
            
        } else if (aPoolSize == 32) {
            
        } else if (aPoolSize == 64) {
            
        } else {
            printf("VerifyPreTwist, Fail: bad pool size, %zu", aPoolSize);
            return false;
        }
        
        if (pStrength == EncryptionStrength::kWeak) {
            if (pIsEarlyRound == false) {
                if (aPoolSize != 16) {
                    printf("VerifyPreTwist, Fail: bad pool size (late round, weak), %zu", aPoolSize);
                }
            }
        } else if (pStrength == EncryptionStrength::kStrong) {
            if (pIsEarlyRound == false) {
                if (aPoolSize != 64) {
                    printf("VerifyPreTwist, Fail: bad pool size (late round, strong), %zu", aPoolSize);
                }
            }
        } else {
            if (pIsEarlyRound == false) {
                if (aPoolSize != 32) {
                    printf("VerifyPreTwist, Fail: bad pool size (late round, norma;), %zu", aPoolSize);
                }
            }
        }
        
        std::unordered_set<std::uint8_t *> aCrossSet;
        for (std::size_t aPoolIndex=0U; aPoolIndex<aPoolSize; aPoolIndex++) {
            if (aCrossSet.contains(Soccer3::mCrossPool[aLaneIndex][aPoolIndex])) {
                printf("VerifyPreTwist, Fail: pool contains dupe at %zu|%zu.\n", aLaneIndex, aPoolIndex);
                return false;
            }
            aCrossSet.insert(Soccer3::mCrossPool[aLaneIndex][aPoolIndex]);
        }
        
        for (auto &aCross : aCrossSet) {
            
            bool aIsMaterialB1 = false;
            bool aIsMaterialB2 = false;
            bool aIsMaterialB3 = false;
            bool aIsMaterialB4 = false;
            bool aIsMaterialB5 = false;
            
            bool aIsMaterialPR = false;
            
            for (std::size_t aMaterialIndex=0; aMaterialIndex<aComplexity; aMaterialIndex++) {
                
                if (&Soccer3::mMaterials[aMaterialIndex][aBack1 * S_BLOCK] == aCross) {
                    aIsMaterialB1 = true;
                }
                if (&Soccer3::mMaterials[aMaterialIndex][aBack2 * S_BLOCK] == aCross) {
                    aIsMaterialB2 = true;
                }
                if (&Soccer3::mMaterials[aMaterialIndex][aBack3 * S_BLOCK] == aCross) {
                    aIsMaterialB3 = true;
                }
                if (&Soccer3::mMaterials[aMaterialIndex][aBack4 * S_BLOCK] == aCross) {
                    aIsMaterialB4 = true;
                }
                if (&Soccer3::mMaterials[aMaterialIndex][aBack5 * S_BLOCK] == aCross) {
                    aIsMaterialB5 = true;
                }
                if (Soccer3::SOCCER_PRELUDE_RAND == aCross) {
                    aIsMaterialPR = true;
                }
            }
            
            bool aIsMB = false;
            if (aIsMaterialB1) { aIsMB = true; }
            if (aIsMaterialB2) { aIsMB = true; }
            if (aIsMaterialB3) { aIsMB = true; }
            if (aIsMaterialB4) { aIsMB = true; }
            if (aIsMaterialB5) { aIsMB = true; }
            
            if (pIsEarlyRound) {
                if (aIsMaterialPR || aIsMB) {
                    
                } else {
                    printf("VerifyPreTwist, Fail: Early round material should be back [1, 2, 3, or 4] or pr seed rand.\n");
                    return false;
                }
            } else {
                if (aIsMB) {
                    
                } else {
                    printf("VerifyPreTwist, Fail: Later round material should be back [1, 2, 3, or 4] only.\n");
                    return false;
                }
            }
        }
    }
    
    return true;
}

- (void)test_WarmUpAndTwist {
    
    std::size_t BLOCK_COUNT = 32;
    std::size_t WARM_UP_ROUNDS = 5;
    std::size_t WARM_UP_BLOCKS = WARM_UP_ROUNDS + 1;
    
    std::vector<EncryptionStrength> aStrengthList = { EncryptionStrength::kWeak, EncryptionStrength::kNormal, EncryptionStrength::kStrong};
    
    for (std::size_t aTrial=0; aTrial<128; aTrial++) {
        
        if ((aTrial % 32) == 0) {
            printf("WarmUpAndTwist, Trial #%zu\n", aTrial);
        }
        
        for (auto &aStrength : aStrengthList) {
            
            std::size_t aComplexity = 8;
            if (aStrength == EncryptionStrength::kWeak) {
                aComplexity = 4;
            } else if (aStrength == EncryptionStrength::kStrong) {
                aComplexity = 16;
            }
            
            const std::size_t aWarmUpSeedBlockIndex = BLOCK_COUNT - WARM_UP_BLOCKS;
            const std::size_t aWarmUpSeedByteIndex = aWarmUpSeedBlockIndex * S_BLOCK;
            const std::size_t aWarmUp1ByteIndex = (aWarmUpSeedBlockIndex + 1U) * S_BLOCK;
            const std::size_t aWarmUp2ByteIndex = (aWarmUpSeedBlockIndex + 2U) * S_BLOCK;
            const std::size_t aWarmUp3ByteIndex = (aWarmUpSeedBlockIndex + 3U) * S_BLOCK;
            
            Soccer3::Zero();
            Soccer3::mStrength = aStrength;
            
            const std::size_t aFirstWarmUpBlockIndex = BLOCK_COUNT - WARM_UP_BLOCKS;
            const std::size_t aFirstWarmUpByteIndex = aFirstWarmUpBlockIndex * S_BLOCK;
            if (aStrength == EncryptionStrength::kWeak) {
                for (std::size_t aIndex=0U; aIndex<4; aIndex++) {
                    Soccer3::mSources[aIndex] = &Soccer3::mMaterials[aIndex][aFirstWarmUpByteIndex];
                }
            } else if (aStrength == EncryptionStrength::kStrong) {
                for (std::size_t aIndex=0U; aIndex<16; aIndex++) {
                    Soccer3::mSources[aIndex] = &Soccer3::mMaterials[aIndex][aFirstWarmUpByteIndex];
                }
            } else {
                for (std::size_t aIndex=0U; aIndex<8; aIndex++) {
                    Soccer3::mSources[aIndex] = &Soccer3::mMaterials[aIndex][aFirstWarmUpByteIndex];
                }
            }
            
            {
                for (std::size_t aLaneIndex=0U; aLaneIndex<aComplexity; aLaneIndex++) {
                    WorkSpaceTools::FillBytes(&Soccer3::mMaterials[aLaneIndex][aWarmUpSeedByteIndex], S_BLOCK);
                }
                
                WorkSpaceTools::FillBytes(Soccer3::mRandom, S_BLOCK);
                WorkSpaceTools::FillBytes(Soccer3::mCollapseLaneB, S_BLOCK);
            }
            
            
            Soccer3::Shuffle_CROWSCIMASSORMATEX();
            
            Soccer3::BuildCrossPool_WarmUp1(aComplexity, aWarmUpSeedByteIndex);
            Soccer3::Shuffle_CROPER(Soccer3::mCrossPoolCount[0]);
            Soccer3::ArrangeCrossPool(aComplexity);
            
            if (!VerifyPreTwist(aWarmUpSeedBlockIndex + 1U, aStrength, true)) {
                XCTFail("WarmUpAndTwist: failed pre-twist validation (warm up round 1)");
                return;
            }
            FakeTwistRound(aWarmUpSeedBlockIndex + 1U, aStrength);
            
            
            Soccer3::BuildCrossPool_WarmUp2(aComplexity,
                                            aWarmUpSeedByteIndex,
                                            aWarmUp1ByteIndex);
            Soccer3::Shuffle_CROPER(Soccer3::mCrossPoolCount[0]);
            Soccer3::ArrangeCrossPool(aComplexity);
            if (!VerifyPreTwist(aWarmUpSeedBlockIndex + 2U, aStrength, true)) {
                XCTFail("WarmUpAndTwist: failed pre-twist validation (warm up round 2)");
                return;
            }
            FakeTwistRound(aWarmUpSeedBlockIndex + 2U, aStrength);
            
            Soccer3::BuildCrossPool_WarmUp2(aComplexity,
                                            aWarmUp1ByteIndex,
                                            aWarmUp2ByteIndex);
            Soccer3::Shuffle_CROPER(Soccer3::mCrossPoolCount[0]);
            Soccer3::ArrangeCrossPool(aComplexity);
            if (!VerifyPreTwist(aWarmUpSeedBlockIndex + 3U, aStrength, true)) {
                XCTFail("WarmUpAndTwist: failed pre-twist validation (warm up round 3)");
                return;
            }
            FakeTwistRound(aWarmUpSeedBlockIndex + 3U, aStrength);
            
            Soccer3::BuildCrossPool_WarmUp4(aComplexity,
                                            aWarmUpSeedByteIndex,
                                            aWarmUp1ByteIndex,
                                            aWarmUp2ByteIndex);
            Soccer3::Shuffle_CROPER(Soccer3::mCrossPoolCount[0]);
            Soccer3::ArrangeCrossPool(aComplexity);
            if (!VerifyPreTwist(aWarmUpSeedBlockIndex + 4U, aStrength, true)) {
                XCTFail("WarmUpAndTwist: failed pre-twist validation (warm up round 4)");
                return;
            }
            FakeTwistRound(aWarmUpSeedBlockIndex + 4U, aStrength);
            
            Soccer3::BuildCrossPool_Regular(aComplexity,
                                            aWarmUpSeedByteIndex,
                                            aWarmUp1ByteIndex,
                                            aWarmUp2ByteIndex,
                                            aWarmUp3ByteIndex);
            Soccer3::Shuffle_CROPER(Soccer3::mCrossPoolCount[0]);
            Soccer3::ArrangeCrossPool(aComplexity);
            if (!VerifyPreTwist(aWarmUpSeedBlockIndex + 5U, aStrength, true)) {
                XCTFail("WarmUpAndTwist: failed pre-twist validation (warm up round 5)");
                return;
            }
            FakeTwistRound(aWarmUpSeedBlockIndex + 5U, aStrength);
            
            for (std::size_t aRoundIndex=0U; aRoundIndex<BLOCK_COUNT; aRoundIndex++) {
                const std::size_t aFourRoundsBackBlockIndex = (aRoundIndex + BLOCK_COUNT - 5U) % BLOCK_COUNT;
                const std::size_t aThreeRoundsBackBlockIndex = (aRoundIndex + BLOCK_COUNT - 4U) % BLOCK_COUNT;
                const std::size_t aTwoRoundsBackBlockIndex = (aRoundIndex + BLOCK_COUNT - 3U) % BLOCK_COUNT;
                const std::size_t aOneRoundBackBlockIndex = (aRoundIndex + BLOCK_COUNT - 2U) % BLOCK_COUNT;
                Soccer3::BuildCrossPool_Regular(aComplexity,
                                                aFourRoundsBackBlockIndex * S_BLOCK,
                                                aThreeRoundsBackBlockIndex * S_BLOCK,
                                                aTwoRoundsBackBlockIndex * S_BLOCK,
                                                aOneRoundBackBlockIndex * S_BLOCK);
                Soccer3::Shuffle_CROPER(Soccer3::mCrossPoolCount[0]);
                Soccer3::ArrangeCrossPool(aComplexity);
                if (!VerifyPreTwist(aRoundIndex, aStrength, false)) {
                    XCTFail("WarmUpAndTwist: failed pre-twist validation (warm up round 5)");
                    return;
                }
                FakeTwistRound(aRoundIndex, aStrength);
            }
        }
    }
}

@end
