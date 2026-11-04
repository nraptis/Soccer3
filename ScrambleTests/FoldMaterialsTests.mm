//
//  FoldMaterialsTests.m
//  ScrambleTests
//
//  Created by Icarus Black on 8/6/26.
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

@interface FoldMaterialsTests : XCTestCase

@end

@implementation FoldMaterialsTests

- (void)test_Fold4 {
    
    Soccer3::Zero();
    
    std::uint8_t aOutputA[S_BLOCK];
    
    Soccer3::FoldMaterialsIntoRandomForBlock_4(0);
    std::memcpy(aOutputA, Soccer3::mRandom, S_BLOCK);
    
    std::size_t aBlockIndexList[6];
    aBlockIndexList[0] = 0;
    aBlockIndexList[1] = 1;
    aBlockIndexList[2] = 14;
    aBlockIndexList[3] = 15;
    aBlockIndexList[4] = 30;
    aBlockIndexList[5] = 31;
    
    for (std::size_t aBlockIndexIndex=0; aBlockIndexIndex<6; aBlockIndexIndex++) {
        
        std::size_t aBlockIndex = aBlockIndexList[aBlockIndexIndex];
        
        std::size_t aStartByte = aBlockIndex * S_BLOCK;
        
        for (std::size_t aLaneIndex=0; aLaneIndex<4; aLaneIndex++) {
            
            for (std::size_t aByteIndex=0; aByteIndex<S_BLOCK; aByteIndex++) {
                
                // Check 1: Without mutation, this is the same as aOutputA
                Soccer3::FoldMaterialsIntoRandomForBlock_4(aBlockIndex);
                if (std::memcmp(Soccer3::mRandom, aOutputA, S_BLOCK) != 0) {
                    XCTFail("test_Fold4: expecting control case to be same as output a. (block = %zu, lane = %zu, byte = %zu)", aBlockIndex, aLaneIndex, aByteIndex);
                    return;
                }
                
                bool aDidInfluence = false;
                for (std::size_t aByteValue=1; ((aByteValue<256) && (aDidInfluence == false)); aByteValue++) {
                    Soccer3::mMaterials[aLaneIndex][aByteIndex + aStartByte] = aByteValue;
                    Soccer3::FoldMaterialsIntoRandomForBlock_4(aBlockIndex);
                    if (std::memcmp(Soccer3::mRandom, aOutputA, S_BLOCK) != 0) {
                        aDidInfluence = true;
                    }
                }
                
                if (aDidInfluence == false) {
                    XCTFail("test_Fold4: expecting mutated case to have influences final array. (block = %zu, lane = %zu, byte = %zu)", aBlockIndex, aLaneIndex, aByteIndex);
                    return;
                }
                
                // Back to 0...
                Soccer3::mMaterials[aLaneIndex][aByteIndex + aStartByte] = 0;
                
            }
            
        }
        printf("test_Fold4 finished block %zu\n", aBlockIndex);
        
    }
}

- (void)test_Fold8 {
    
    Soccer3::Zero();
    
    std::uint8_t aOutputA[S_BLOCK];
    
    Soccer3::FoldMaterialsIntoRandomForBlock_8(0);
    std::memcpy(aOutputA, Soccer3::mRandom, S_BLOCK);
    
    std::size_t aBlockIndexList[6];
    aBlockIndexList[0] = 0;
    aBlockIndexList[1] = 1;
    aBlockIndexList[2] = 14;
    aBlockIndexList[3] = 15;
    aBlockIndexList[4] = 30;
    aBlockIndexList[5] = 31;
    
    for (std::size_t aBlockIndexIndex=0; aBlockIndexIndex<6; aBlockIndexIndex++) {
        
        std::size_t aBlockIndex = aBlockIndexList[aBlockIndexIndex];
        
        std::size_t aStartByte = aBlockIndex * S_BLOCK;
        
        for (std::size_t aLaneIndex=0; aLaneIndex<8; aLaneIndex++) {
            
            for (std::size_t aByteIndex=0; aByteIndex<S_BLOCK; aByteIndex++) {
                
                // Check 1: Without mutation, this is the same as aOutputA
                Soccer3::FoldMaterialsIntoRandomForBlock_8(aBlockIndex);
                if (std::memcmp(Soccer3::mRandom, aOutputA, S_BLOCK) != 0) {
                    XCTFail("test_Fold8: expecting control case to be same as output a. (block = %zu, lane = %zu, byte = %zu)", aBlockIndex, aLaneIndex, aByteIndex);
                    return;
                }
                
                bool aDidInfluence = false;
                for (std::size_t aByteValue=1; ((aByteValue<256) && (aDidInfluence == false)); aByteValue++) {
                    Soccer3::mMaterials[aLaneIndex][aByteIndex + aStartByte] = aByteValue;
                    Soccer3::FoldMaterialsIntoRandomForBlock_8(aBlockIndex);
                    if (std::memcmp(Soccer3::mRandom, aOutputA, S_BLOCK) != 0) {
                        aDidInfluence = true;
                    }
                }
                
                if (aDidInfluence == false) {
                    XCTFail("test_Fold8: expecting mutated case to have influences final array. (block = %zu, lane = %zu, byte = %zu)", aBlockIndex, aLaneIndex, aByteIndex);
                    return;
                }
                
                // Back to 0...
                Soccer3::mMaterials[aLaneIndex][aByteIndex + aStartByte] = 0;
                
            }
            
        }
        printf("test_Fold8 finished block %zu\n", aBlockIndex);
        
    }
}

- (void)test_Fold16 {
    
    Soccer3::Zero();
    
    std::uint8_t aOutputA[S_BLOCK];
    
    Soccer3::FoldMaterialsIntoRandomForBlock_16(0);
    std::memcpy(aOutputA, Soccer3::mRandom, S_BLOCK);
    
    std::size_t aBlockIndexList[6];
    aBlockIndexList[0] = 0;
    aBlockIndexList[1] = 1;
    aBlockIndexList[2] = 14;
    aBlockIndexList[3] = 15;
    aBlockIndexList[4] = 30;
    aBlockIndexList[5] = 31;
    
    for (std::size_t aBlockIndexIndex=0; aBlockIndexIndex<6; aBlockIndexIndex++) {
        
        std::size_t aBlockIndex = aBlockIndexList[aBlockIndexIndex];
        
        std::size_t aStartByte = aBlockIndex * S_BLOCK;
        
        for (std::size_t aLaneIndex=0; aLaneIndex<16; aLaneIndex++) {
            
            for (std::size_t aByteIndex=0; aByteIndex<S_BLOCK; aByteIndex++) {
                
                // Check 1: Without mutation, this is the same as aOutputA
                Soccer3::FoldMaterialsIntoRandomForBlock_16(aBlockIndex);
                if (std::memcmp(Soccer3::mRandom, aOutputA, S_BLOCK) != 0) {
                    XCTFail("test_Fold16: expecting control case to be same as output a. (block = %zu, lane = %zu, byte = %zu)", aBlockIndex, aLaneIndex, aByteIndex);
                    return;
                }
                
                bool aDidInfluence = false;
                for (std::size_t aByteValue=1; ((aByteValue<256) && (aDidInfluence == false)); aByteValue++) {
                    Soccer3::mMaterials[aLaneIndex][aByteIndex + aStartByte] = aByteValue;
                    Soccer3::FoldMaterialsIntoRandomForBlock_16(aBlockIndex);
                    if (std::memcmp(Soccer3::mRandom, aOutputA, S_BLOCK) != 0) {
                        aDidInfluence = true;
                    }
                }
                
                if (aDidInfluence == false) {
                    XCTFail("test_Fold16: expecting mutated case to have influences final array. (block = %zu, lane = %zu, byte = %zu)", aBlockIndex, aLaneIndex, aByteIndex);
                    return;
                }
                
                // Back to 0...
                Soccer3::mMaterials[aLaneIndex][aByteIndex + aStartByte] = 0;
                
            }
            
        }
        printf("test_Fold16 finished block %zu\n", aBlockIndex);
        
    }
}

@end
