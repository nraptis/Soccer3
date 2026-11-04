//
//  TwistBlockTests.m
//  ScrambleTests
//
//  Created by Icarus Black on 8/6/26.
//

#import <XCTest/XCTest.h>
#include <atomic>
#include "Soccer3.hpp"
#include "WorkSpaceTools.hpp"
#include "LaneTool.hpp"
#include "Random.hpp"
#include <cstdint>
#include <cstring>
#include <string>
#include <unordered_set>

@interface AgileTwistRoundTests : XCTestCase

@end

@implementation AgileTwistRoundTests

- (void)test_TwistRound_Weak {
    
    std::size_t aLaneCount = 4;
    EncryptionStrength aEncryptionStrength = EncryptionStrength::kWeak;
    
    std::uint8_t aSources_A[16][S_BLOCK];
    std::uint8_t aCrosses_A_A[16][S_BLOCK];
    std::uint8_t aCrosses_B_A[16][S_BLOCK];
    std::uint8_t aCrosses_C_A[16][S_BLOCK];
    std::uint8_t aCrosses_D_A[16][S_BLOCK];
    
    std::uint8_t aSources_B[16][S_BLOCK];
    std::uint8_t aCrosses_A_B[16][S_BLOCK];
    std::uint8_t aCrosses_B_B[16][S_BLOCK];
    std::uint8_t aCrosses_C_B[16][S_BLOCK];
    std::uint8_t aCrosses_D_B[16][S_BLOCK];
    
    std::uint8_t aExpectation_A[16][S_BLOCK];
    std::uint8_t aExpectation_B[16][S_BLOCK];
    
    std::size_t aBlockIndexList[6];
    aBlockIndexList[0] = 0;
    aBlockIndexList[1] = 1;
    aBlockIndexList[2] = 6;
    aBlockIndexList[3] = 7;
    aBlockIndexList[4] = 12;
    aBlockIndexList[5] = 13;
    
    for (std::size_t aTrial=0; aTrial<16; aTrial++) {
        for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
            std::memset(aSources_A[aLaneIndex], 0, S_BLOCK);
            std::memset(aCrosses_A_A[aLaneIndex], 0, S_BLOCK);
            std::memset(aCrosses_B_A[aLaneIndex], 0, S_BLOCK);
            std::memset(aCrosses_C_A[aLaneIndex], 0, S_BLOCK);
            std::memset(aCrosses_D_A[aLaneIndex], 0, S_BLOCK);
            
            WorkSpaceTools::FillBytes(aSources_B[aLaneIndex], S_BLOCK);
            WorkSpaceTools::FillBytes(aCrosses_A_B[aLaneIndex], S_BLOCK);
            WorkSpaceTools::FillBytes(aCrosses_B_B[aLaneIndex], S_BLOCK);
            WorkSpaceTools::FillBytes(aCrosses_C_B[aLaneIndex], S_BLOCK);
            WorkSpaceTools::FillBytes(aCrosses_D_B[aLaneIndex], S_BLOCK);
        }
        
        std::uint64_t aIngress = 0xE025CAEA83AB99CFULL;
        std::uint64_t aCarry = 0x6530BC4A53A443B8ULL;
        std::uint64_t aWandererA = 0x4E06885276D20E3DULL;
        std::uint64_t aWandererB = 0xEBF1E1AB6DF26920ULL;
        std::uint64_t aWandererC = 0x99478E05E833FBB1ULL;
        std::uint64_t aWandererD = 0x73A9F7B5B01778B2ULL;
        std::uint64_t aWandererE = 0xB9AB363EA936D1EDULL;
        std::uint64_t aWandererF = 0x847430D62AD62F79ULL;
        std::uint64_t aWandererG = 0x0D6FE89E3169B0E1ULL;
        std::uint64_t aWandererH = 0xD22934C37E3EE9B7ULL;
        std::uint64_t aWandererI = 0x648E293C4DCD6ED1ULL;
        std::uint64_t aWandererJ = 0xA31C40A884CAD927ULL;
        std::uint64_t aWandererK = 0x183169CC43C8BCE3ULL;
        Soccer3::Zero();
        Soccer3::mStrength = aEncryptionStrength;

        for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
            Soccer3::mSources[aLaneIndex] = aSources_A[aLaneIndex];
            Soccer3::mCross[0][aLaneIndex] = aCrosses_A_A[aLaneIndex];
            Soccer3::mCross[1][aLaneIndex] = aCrosses_B_A[aLaneIndex];
            Soccer3::mCross[2][aLaneIndex] = aCrosses_C_A[aLaneIndex];
            Soccer3::mCross[3][aLaneIndex] = aCrosses_D_A[aLaneIndex];
        }
        
        std::atomic<bool> aCancelled{false};
        Soccer3::TwistRound(0, false, ARX_STATE_VARS,&aCancelled);
        for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
            const std::size_t aByteRichness = LaneTool::ByteRichness(Soccer3::mMaterials[aLaneIndex], S_BLOCK);
            if (aByteRichness < 512) {
                XCTFail("test_TwistRound_Weak: for zeros, at lane %zu, expected byte richess 512+, got %zu", aLaneIndex, aByteRichness);
                return;
            }
            std::memcpy(aExpectation_A[aLaneIndex], Soccer3::mMaterials[aLaneIndex], S_BLOCK);
        }
        
        for (std::size_t aFirstIndex=1; aFirstIndex<aLaneCount; aFirstIndex++) {
            for (std::size_t aSecondIndex=0; aSecondIndex<aFirstIndex; aSecondIndex++) {
                if (std::memcmp(Soccer3::mMaterials[aFirstIndex], Soccer3::mMaterials[aSecondIndex], S_BLOCK) == 0) {
                    XCTFail("test_TwistRound_Weak: lanes at %zu and %zu were identical for zeros, should not happen", aFirstIndex, aSecondIndex);
                    return;
                }
            }
        }
        
        aIngress = 0xE025CAEA83AB99CFULL;
        aCarry = 0x6530BC4A53A443B8ULL;
        aWandererA = 0x4E06885276D20E3DULL;
        aWandererB = 0xEBF1E1AB6DF26920ULL;
        aWandererC = 0x99478E05E833FBB1ULL;
        aWandererD = 0x73A9F7B5B01778B2ULL;
        aWandererE = 0xB9AB363EA936D1EDULL;
        aWandererF = 0x847430D62AD62F79ULL;
        aWandererG = 0x0D6FE89E3169B0E1ULL;
        aWandererH = 0xD22934C37E3EE9B7ULL;
        aWandererI = 0x648E293C4DCD6ED1ULL;
        aWandererJ = 0xA31C40A884CAD927ULL;
        aWandererK = 0x183169CC43C8BCE3ULL;
        Soccer3::Zero();
        Soccer3::mStrength = aEncryptionStrength;
        
        for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
            Soccer3::mSources[aLaneIndex] = aSources_B[aLaneIndex];
            Soccer3::mCross[0][aLaneIndex] = aCrosses_A_B[aLaneIndex];
            Soccer3::mCross[1][aLaneIndex] = aCrosses_B_B[aLaneIndex];
            Soccer3::mCross[2][aLaneIndex] = aCrosses_C_B[aLaneIndex];
            Soccer3::mCross[3][aLaneIndex] = aCrosses_D_B[aLaneIndex];
        }
        
        Soccer3::TwistRound(0, false, ARX_STATE_VARS,&aCancelled);
        for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
            const std::size_t aByteRichness = LaneTool::ByteRichness(Soccer3::mMaterials[aLaneIndex], S_BLOCK);
            if (aByteRichness < 512) {
                XCTFail("test_TwistRound_Weak: for randoms, at lane %zu, expected byte richess 512+, got %zu", aLaneIndex, aByteRichness);
                return;
            }
            std::memcpy(aExpectation_B[aLaneIndex], Soccer3::mMaterials[aLaneIndex], S_BLOCK);
        }
        
        for (std::size_t aFirstIndex=1; aFirstIndex<aLaneCount; aFirstIndex++) {
            for (std::size_t aSecondIndex=0; aSecondIndex<aFirstIndex; aSecondIndex++) {
                if (std::memcmp(Soccer3::mMaterials[aFirstIndex], Soccer3::mMaterials[aSecondIndex], S_BLOCK) == 0) {
                    XCTFail("test_TwistRound_Weak: lanes at %zu and %zu were identical for randoms, should not happen", aFirstIndex, aSecondIndex);
                    return;
                }
            }
        }
        
        for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
            if (std::memcmp(aExpectation_A[aLaneIndex], aExpectation_B[aLaneIndex], S_BLOCK) == 0) {
                XCTFail("test_TwistRound_Weak: for compare zeros and randoms, at lane %zu, we had identical output. impossible.", aLaneIndex);
                return;
            }
        }
        
        
        for (std::size_t aBlockIndexIndex=0; aBlockIndexIndex<6; aBlockIndexIndex++) {
            
            std::size_t aBlockIndex = aBlockIndexList[aBlockIndexIndex];
            
            aIngress = 0xE025CAEA83AB99CFULL;
            aCarry = 0x6530BC4A53A443B8ULL;
            aWandererA = 0x4E06885276D20E3DULL;
            aWandererB = 0xEBF1E1AB6DF26920ULL;
            aWandererC = 0x99478E05E833FBB1ULL;
            aWandererD = 0x73A9F7B5B01778B2ULL;
            aWandererE = 0xB9AB363EA936D1EDULL;
            aWandererF = 0x847430D62AD62F79ULL;
            aWandererG = 0x0D6FE89E3169B0E1ULL;
            aWandererH = 0xD22934C37E3EE9B7ULL;
            aWandererI = 0x648E293C4DCD6ED1ULL;
            aWandererJ = 0xA31C40A884CAD927ULL;
            aWandererK = 0x183169CC43C8BCE3ULL;
            Soccer3::Zero();
            Soccer3::mStrength = aEncryptionStrength;
            
            for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
                Soccer3::mSources[aLaneIndex] = aSources_A[aLaneIndex];
                Soccer3::mCross[0][aLaneIndex] = aCrosses_A_A[aLaneIndex];
                Soccer3::mCross[1][aLaneIndex] = aCrosses_B_A[aLaneIndex];
                Soccer3::mCross[2][aLaneIndex] = aCrosses_C_A[aLaneIndex];
                Soccer3::mCross[3][aLaneIndex] = aCrosses_D_A[aLaneIndex];
            }
            
            Soccer3::TwistRound(aBlockIndex, false, ARX_STATE_VARS,&aCancelled);
            for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
                if (std::memcmp(&Soccer3::mMaterials[aLaneIndex][aBlockIndex * S_BLOCK],
                                aExpectation_A[aLaneIndex], S_BLOCK) != 0) {
                    XCTFail("test_TwistRound_Weak: at block %zu lane %zu, we did not get equal to expectation", aBlockIndex, aLaneIndex);
                    return;
                }
            }
            
            printf("test_TwistRound_Weak trial %zu finished block %zu (zero)\n", aTrial, aBlockIndex);
        }
        
        for (std::size_t aBlockIndexIndex=0; aBlockIndexIndex<6; aBlockIndexIndex++) {
            
            std::size_t aBlockIndex = aBlockIndexList[aBlockIndexIndex];
            
            
            aIngress = 0xE025CAEA83AB99CFULL;
            aCarry = 0x6530BC4A53A443B8ULL;
            aWandererA = 0x4E06885276D20E3DULL;
            aWandererB = 0xEBF1E1AB6DF26920ULL;
            aWandererC = 0x99478E05E833FBB1ULL;
            aWandererD = 0x73A9F7B5B01778B2ULL;
            aWandererE = 0xB9AB363EA936D1EDULL;
            aWandererF = 0x847430D62AD62F79ULL;
            aWandererG = 0x0D6FE89E3169B0E1ULL;
            aWandererH = 0xD22934C37E3EE9B7ULL;
            aWandererI = 0x648E293C4DCD6ED1ULL;
            aWandererJ = 0xA31C40A884CAD927ULL;
            aWandererK = 0x183169CC43C8BCE3ULL;
            Soccer3::Zero();
            Soccer3::mStrength = aEncryptionStrength;
            
            for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
                Soccer3::mSources[aLaneIndex] = aSources_B[aLaneIndex];
                Soccer3::mCross[0][aLaneIndex] = aCrosses_A_B[aLaneIndex];
                Soccer3::mCross[1][aLaneIndex] = aCrosses_B_B[aLaneIndex];
                Soccer3::mCross[2][aLaneIndex] = aCrosses_C_B[aLaneIndex];
                Soccer3::mCross[3][aLaneIndex] = aCrosses_D_B[aLaneIndex];
            }
            
            Soccer3::TwistRound(aBlockIndex, false, ARX_STATE_VARS,&aCancelled);
            for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
                if (std::memcmp(&Soccer3::mMaterials[aLaneIndex][aBlockIndex * S_BLOCK],
                                aExpectation_B[aLaneIndex], S_BLOCK) != 0) {
                    XCTFail("test_TwistRound_Weak: at block %zu lane %zu, we did not get equal to expectation", aBlockIndex, aLaneIndex);
                    return;
                }
            }
            
            printf("test_TwistRound_Weak trial %zu finished block %zu (randoms)\n", aTrial, aBlockIndex);
        }
    }
}

- (void)test_TwistRound_Normal {
    
    std::size_t aLaneCount = 8;
    EncryptionStrength aEncryptionStrength = EncryptionStrength::kNormal;
    
    std::uint8_t aSources_A[16][S_BLOCK];
    std::uint8_t aCrosses_A_A[16][S_BLOCK];
    std::uint8_t aCrosses_B_A[16][S_BLOCK];
    std::uint8_t aCrosses_C_A[16][S_BLOCK];
    std::uint8_t aCrosses_D_A[16][S_BLOCK];
    
    std::uint8_t aSources_B[16][S_BLOCK];
    std::uint8_t aCrosses_A_B[16][S_BLOCK];
    std::uint8_t aCrosses_B_B[16][S_BLOCK];
    std::uint8_t aCrosses_C_B[16][S_BLOCK];
    std::uint8_t aCrosses_D_B[16][S_BLOCK];
    
    std::uint8_t aExpectation_A[16][S_BLOCK];
    std::uint8_t aExpectation_B[16][S_BLOCK];
    
    std::size_t aBlockIndexList[6];
    aBlockIndexList[0] = 0;
    aBlockIndexList[1] = 1;
    aBlockIndexList[2] = 6;
    aBlockIndexList[3] = 7;
    aBlockIndexList[4] = 12;
    aBlockIndexList[5] = 13;
    
    for (std::size_t aTrial=0; aTrial<12; aTrial++) {
        
        for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
            std::memset(aSources_A[aLaneIndex], 0, S_BLOCK);
            std::memset(aCrosses_A_A[aLaneIndex], 0, S_BLOCK);
            std::memset(aCrosses_B_A[aLaneIndex], 0, S_BLOCK);
            std::memset(aCrosses_C_A[aLaneIndex], 0, S_BLOCK);
            std::memset(aCrosses_D_A[aLaneIndex], 0, S_BLOCK);
            
            WorkSpaceTools::FillBytes(aSources_B[aLaneIndex], S_BLOCK);
            WorkSpaceTools::FillBytes(aCrosses_A_B[aLaneIndex], S_BLOCK);
            WorkSpaceTools::FillBytes(aCrosses_B_B[aLaneIndex], S_BLOCK);
            WorkSpaceTools::FillBytes(aCrosses_C_B[aLaneIndex], S_BLOCK);
            WorkSpaceTools::FillBytes(aCrosses_D_B[aLaneIndex], S_BLOCK);
            
        }
        
        std::uint64_t aIngress = 0xE025CAEA83AB99CFULL;
        std::uint64_t aCarry = 0x6530BC4A53A443B8ULL;
        std::uint64_t aWandererA = 0x4E06885276D20E3DULL;
        std::uint64_t aWandererB = 0xEBF1E1AB6DF26920ULL;
        std::uint64_t aWandererC = 0x99478E05E833FBB1ULL;
        std::uint64_t aWandererD = 0x73A9F7B5B01778B2ULL;
        std::uint64_t aWandererE = 0xB9AB363EA936D1EDULL;
        std::uint64_t aWandererF = 0x847430D62AD62F79ULL;
        std::uint64_t aWandererG = 0x0D6FE89E3169B0E1ULL;
        std::uint64_t aWandererH = 0xD22934C37E3EE9B7ULL;
        std::uint64_t aWandererI = 0x648E293C4DCD6ED1ULL;
        std::uint64_t aWandererJ = 0xA31C40A884CAD927ULL;
        std::uint64_t aWandererK = 0x183169CC43C8BCE3ULL;
        Soccer3::Zero();
        Soccer3::mStrength = aEncryptionStrength;
        
        for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
            Soccer3::mSources[aLaneIndex] = aSources_A[aLaneIndex];
            Soccer3::mCross[0][aLaneIndex] = aCrosses_A_A[aLaneIndex];
            Soccer3::mCross[1][aLaneIndex] = aCrosses_B_A[aLaneIndex];
            Soccer3::mCross[2][aLaneIndex] = aCrosses_C_A[aLaneIndex];
            Soccer3::mCross[3][aLaneIndex] = aCrosses_D_A[aLaneIndex];
        }
        
        std::atomic<bool> aCancelled{false};
        Soccer3::TwistRound(0, false, ARX_STATE_VARS,&aCancelled);
        for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
            const std::size_t aByteRichness = LaneTool::ByteRichness(Soccer3::mMaterials[aLaneIndex], S_BLOCK);
            if (aByteRichness < 512) {
                XCTFail("test_TwistRound_Normal: for zeros, at lane %zu, expected byte richess 512+, got %zu", aLaneIndex, aByteRichness);
                return;
            }
            std::memcpy(aExpectation_A[aLaneIndex], Soccer3::mMaterials[aLaneIndex], S_BLOCK);
        }
        
        for (std::size_t aFirstIndex=1; aFirstIndex<aLaneCount; aFirstIndex++) {
            for (std::size_t aSecondIndex=0; aSecondIndex<aFirstIndex; aSecondIndex++) {
                if (std::memcmp(Soccer3::mMaterials[aFirstIndex], Soccer3::mMaterials[aSecondIndex], S_BLOCK) == 0) {
                    XCTFail("test_TwistRound_Normal: lanes at %zu and %zu were identical for zeros, should not happen", aFirstIndex, aSecondIndex);
                    return;
                }
            }
        }
        
        aIngress = 0xE025CAEA83AB99CFULL;
        aCarry = 0x6530BC4A53A443B8ULL;
        aWandererA = 0x4E06885276D20E3DULL;
        aWandererB = 0xEBF1E1AB6DF26920ULL;
        aWandererC = 0x99478E05E833FBB1ULL;
        aWandererD = 0x73A9F7B5B01778B2ULL;
        aWandererE = 0xB9AB363EA936D1EDULL;
        aWandererF = 0x847430D62AD62F79ULL;
        aWandererG = 0x0D6FE89E3169B0E1ULL;
        aWandererH = 0xD22934C37E3EE9B7ULL;
        aWandererI = 0x648E293C4DCD6ED1ULL;
        aWandererJ = 0xA31C40A884CAD927ULL;
        aWandererK = 0x183169CC43C8BCE3ULL;
        Soccer3::Zero();
        Soccer3::mStrength = aEncryptionStrength;
        
        for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
            Soccer3::mSources[aLaneIndex] = aSources_B[aLaneIndex];
            Soccer3::mCross[0][aLaneIndex] = aCrosses_A_B[aLaneIndex];
            Soccer3::mCross[1][aLaneIndex] = aCrosses_B_B[aLaneIndex];
            Soccer3::mCross[2][aLaneIndex] = aCrosses_C_B[aLaneIndex];
            Soccer3::mCross[3][aLaneIndex] = aCrosses_D_B[aLaneIndex];
        }
        
        Soccer3::TwistRound(0, false, ARX_STATE_VARS,&aCancelled);
        for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
            const std::size_t aByteRichness = LaneTool::ByteRichness(Soccer3::mMaterials[aLaneIndex], S_BLOCK);
            if (aByteRichness < 512) {
                XCTFail("test_TwistRound_Normal: for randoms, at lane %zu, expected byte richess 512+, got %zu", aLaneIndex, aByteRichness);
                return;
            }
            std::memcpy(aExpectation_B[aLaneIndex], Soccer3::mMaterials[aLaneIndex], S_BLOCK);
        }
        
        for (std::size_t aFirstIndex=1; aFirstIndex<aLaneCount; aFirstIndex++) {
            for (std::size_t aSecondIndex=0; aSecondIndex<aFirstIndex; aSecondIndex++) {
                if (std::memcmp(Soccer3::mMaterials[aFirstIndex], Soccer3::mMaterials[aSecondIndex], S_BLOCK) == 0) {
                    XCTFail("test_TwistRound_Normal: lanes at %zu and %zu were identical for randoms, should not happen", aFirstIndex, aSecondIndex);
                    return;
                }
            }
        }
        
        for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
            if (std::memcmp(aExpectation_A[aLaneIndex], aExpectation_B[aLaneIndex], S_BLOCK) == 0) {
                XCTFail("test_TwistRound_Normal: for compare zeros and randoms, at lane %zu, we had identical output. impossible.", aLaneIndex);
                return;
            }
        }
        
        
        for (std::size_t aBlockIndexIndex=0; aBlockIndexIndex<6; aBlockIndexIndex++) {
            
            std::size_t aBlockIndex = aBlockIndexList[aBlockIndexIndex];
            
            aIngress = 0xE025CAEA83AB99CFULL;
            aCarry = 0x6530BC4A53A443B8ULL;
            aWandererA = 0x4E06885276D20E3DULL;
            aWandererB = 0xEBF1E1AB6DF26920ULL;
            aWandererC = 0x99478E05E833FBB1ULL;
            aWandererD = 0x73A9F7B5B01778B2ULL;
            aWandererE = 0xB9AB363EA936D1EDULL;
            aWandererF = 0x847430D62AD62F79ULL;
            aWandererG = 0x0D6FE89E3169B0E1ULL;
            aWandererH = 0xD22934C37E3EE9B7ULL;
            aWandererI = 0x648E293C4DCD6ED1ULL;
            aWandererJ = 0xA31C40A884CAD927ULL;
            aWandererK = 0x183169CC43C8BCE3ULL;
            Soccer3::Zero();
            Soccer3::mStrength = aEncryptionStrength;
            
            for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
                Soccer3::mSources[aLaneIndex] = aSources_A[aLaneIndex];
                Soccer3::mCross[0][aLaneIndex] = aCrosses_A_A[aLaneIndex];
                Soccer3::mCross[1][aLaneIndex] = aCrosses_B_A[aLaneIndex];
                Soccer3::mCross[2][aLaneIndex] = aCrosses_C_A[aLaneIndex];
                Soccer3::mCross[3][aLaneIndex] = aCrosses_D_A[aLaneIndex];
            }
            
            Soccer3::TwistRound(aBlockIndex, false, ARX_STATE_VARS,&aCancelled);
            for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
                if (std::memcmp(&Soccer3::mMaterials[aLaneIndex][aBlockIndex * S_BLOCK],
                                aExpectation_A[aLaneIndex], S_BLOCK) != 0) {
                    XCTFail("test_TwistRound_Normal: at block %zu lane %zu, we did not get equal to expectation", aBlockIndex, aLaneIndex);
                    return;
                }
            }
            
            printf("test_TwistRound_Normal trial %zu finished block %zu (zero)\n", aTrial, aBlockIndex);
        }
        
        for (std::size_t aBlockIndexIndex=0; aBlockIndexIndex<6; aBlockIndexIndex++) {
            
            std::size_t aBlockIndex = aBlockIndexList[aBlockIndexIndex];
            
            aIngress = 0xE025CAEA83AB99CFULL;
            aCarry = 0x6530BC4A53A443B8ULL;
            aWandererA = 0x4E06885276D20E3DULL;
            aWandererB = 0xEBF1E1AB6DF26920ULL;
            aWandererC = 0x99478E05E833FBB1ULL;
            aWandererD = 0x73A9F7B5B01778B2ULL;
            aWandererE = 0xB9AB363EA936D1EDULL;
            aWandererF = 0x847430D62AD62F79ULL;
            aWandererG = 0x0D6FE89E3169B0E1ULL;
            aWandererH = 0xD22934C37E3EE9B7ULL;
            aWandererI = 0x648E293C4DCD6ED1ULL;
            aWandererJ = 0xA31C40A884CAD927ULL;
            aWandererK = 0x183169CC43C8BCE3ULL;
            Soccer3::Zero();
            Soccer3::mStrength = aEncryptionStrength;
            
            for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
                Soccer3::mSources[aLaneIndex] = aSources_B[aLaneIndex];
                Soccer3::mCross[0][aLaneIndex] = aCrosses_A_B[aLaneIndex];
                Soccer3::mCross[1][aLaneIndex] = aCrosses_B_B[aLaneIndex];
                Soccer3::mCross[2][aLaneIndex] = aCrosses_C_B[aLaneIndex];
                Soccer3::mCross[3][aLaneIndex] = aCrosses_D_B[aLaneIndex];
            }
            
            Soccer3::TwistRound(aBlockIndex, false, ARX_STATE_VARS,&aCancelled);
            for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
                if (std::memcmp(&Soccer3::mMaterials[aLaneIndex][aBlockIndex * S_BLOCK],
                                aExpectation_B[aLaneIndex], S_BLOCK) != 0) {
                    XCTFail("test_TwistRound_Normal: at block %zu lane %zu, we did not get equal to expectation", aBlockIndex, aLaneIndex);
                    return;
                }
            }
            
            printf("test_TwistRound_Normal trial %zu finished block %zu (randoms)\n", aTrial, aBlockIndex);
        }
    }
}

- (void)test_TwistRound_Strong {
    
    std::size_t aLaneCount = 16;
    EncryptionStrength aEncryptionStrength = EncryptionStrength::kStrong;
    
    std::uint8_t aSources_A[16][S_BLOCK];
    std::uint8_t aCrosses_A_A[16][S_BLOCK];
    std::uint8_t aCrosses_B_A[16][S_BLOCK];
    std::uint8_t aCrosses_C_A[16][S_BLOCK];
    std::uint8_t aCrosses_D_A[16][S_BLOCK];
    
    std::uint8_t aSources_B[16][S_BLOCK];
    std::uint8_t aCrosses_A_B[16][S_BLOCK];
    std::uint8_t aCrosses_B_B[16][S_BLOCK];
    std::uint8_t aCrosses_C_B[16][S_BLOCK];
    std::uint8_t aCrosses_D_B[16][S_BLOCK];
    
    std::uint8_t aExpectation_A[16][S_BLOCK];
    std::uint8_t aExpectation_B[16][S_BLOCK];
    
    std::size_t aBlockIndexList[6];
    aBlockIndexList[0] = 0;
    aBlockIndexList[1] = 1;
    aBlockIndexList[2] = 6;
    aBlockIndexList[3] = 7;
    aBlockIndexList[4] = 12;
    aBlockIndexList[5] = 13;
    
    for (std::size_t aTrial=0; aTrial<8; aTrial++) {
        
        for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
            std::memset(aSources_A[aLaneIndex], 0, S_BLOCK);
            std::memset(aCrosses_A_A[aLaneIndex], 0, S_BLOCK);
            std::memset(aCrosses_B_A[aLaneIndex], 0, S_BLOCK);
            std::memset(aCrosses_C_A[aLaneIndex], 0, S_BLOCK);
            std::memset(aCrosses_D_A[aLaneIndex], 0, S_BLOCK);
            
            WorkSpaceTools::FillBytes(aSources_B[aLaneIndex], S_BLOCK);
            WorkSpaceTools::FillBytes(aCrosses_A_B[aLaneIndex], S_BLOCK);
            WorkSpaceTools::FillBytes(aCrosses_B_B[aLaneIndex], S_BLOCK);
            WorkSpaceTools::FillBytes(aCrosses_C_B[aLaneIndex], S_BLOCK);
            WorkSpaceTools::FillBytes(aCrosses_D_B[aLaneIndex], S_BLOCK);
            
        }
        
        std::uint64_t aIngress = 0xE025CAEA83AB99CFULL;
        std::uint64_t aCarry = 0x6530BC4A53A443B8ULL;
        std::uint64_t aWandererA = 0x4E06885276D20E3DULL;
        std::uint64_t aWandererB = 0xEBF1E1AB6DF26920ULL;
        std::uint64_t aWandererC = 0x99478E05E833FBB1ULL;
        std::uint64_t aWandererD = 0x73A9F7B5B01778B2ULL;
        std::uint64_t aWandererE = 0xB9AB363EA936D1EDULL;
        std::uint64_t aWandererF = 0x847430D62AD62F79ULL;
        std::uint64_t aWandererG = 0x0D6FE89E3169B0E1ULL;
        std::uint64_t aWandererH = 0xD22934C37E3EE9B7ULL;
        std::uint64_t aWandererI = 0x648E293C4DCD6ED1ULL;
        std::uint64_t aWandererJ = 0xA31C40A884CAD927ULL;
        std::uint64_t aWandererK = 0x183169CC43C8BCE3ULL;
        Soccer3::Zero();
        Soccer3::mStrength = aEncryptionStrength;
        
        for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
            Soccer3::mSources[aLaneIndex] = aSources_A[aLaneIndex];
            Soccer3::mCross[0][aLaneIndex] = aCrosses_A_A[aLaneIndex];
            Soccer3::mCross[1][aLaneIndex] = aCrosses_B_A[aLaneIndex];
            Soccer3::mCross[2][aLaneIndex] = aCrosses_C_A[aLaneIndex];
            Soccer3::mCross[3][aLaneIndex] = aCrosses_D_A[aLaneIndex];
        }
        
        std::atomic<bool> aCancelled{false};
        Soccer3::TwistRound(0, false, ARX_STATE_VARS,&aCancelled);
        for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
            const std::size_t aByteRichness = LaneTool::ByteRichness(Soccer3::mMaterials[aLaneIndex], S_BLOCK);
            if (aByteRichness < 512) {
                XCTFail("test_TwistRound_Strong: for zeros, at lane %zu, expected byte richess 512+, got %zu", aLaneIndex, aByteRichness);
                return;
            }
            std::memcpy(aExpectation_A[aLaneIndex], Soccer3::mMaterials[aLaneIndex], S_BLOCK);
        }
        
        for (std::size_t aFirstIndex=1; aFirstIndex<aLaneCount; aFirstIndex++) {
            for (std::size_t aSecondIndex=0; aSecondIndex<aFirstIndex; aSecondIndex++) {
                if (std::memcmp(Soccer3::mMaterials[aFirstIndex], Soccer3::mMaterials[aSecondIndex], S_BLOCK) == 0) {
                    XCTFail("test_TwistRound_Strong: lanes at %zu and %zu were identical for zeros, should not happen", aFirstIndex, aSecondIndex);
                    return;
                }
            }
        }
        
        aIngress = 0xE025CAEA83AB99CFULL;
        aCarry = 0x6530BC4A53A443B8ULL;
        aWandererA = 0x4E06885276D20E3DULL;
        aWandererB = 0xEBF1E1AB6DF26920ULL;
        aWandererC = 0x99478E05E833FBB1ULL;
        aWandererD = 0x73A9F7B5B01778B2ULL;
        aWandererE = 0xB9AB363EA936D1EDULL;
        aWandererF = 0x847430D62AD62F79ULL;
        aWandererG = 0x0D6FE89E3169B0E1ULL;
        aWandererH = 0xD22934C37E3EE9B7ULL;
        aWandererI = 0x648E293C4DCD6ED1ULL;
        aWandererJ = 0xA31C40A884CAD927ULL;
        aWandererK = 0x183169CC43C8BCE3ULL;
        Soccer3::Zero();
        Soccer3::mStrength = aEncryptionStrength;
        
        for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
            Soccer3::mSources[aLaneIndex] = aSources_B[aLaneIndex];
            Soccer3::mCross[0][aLaneIndex] = aCrosses_A_B[aLaneIndex];
            Soccer3::mCross[1][aLaneIndex] = aCrosses_B_B[aLaneIndex];
            Soccer3::mCross[2][aLaneIndex] = aCrosses_C_B[aLaneIndex];
            Soccer3::mCross[3][aLaneIndex] = aCrosses_D_B[aLaneIndex];
        }
        
        Soccer3::TwistRound(0, false, ARX_STATE_VARS,&aCancelled);
        for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
            const std::size_t aByteRichness = LaneTool::ByteRichness(Soccer3::mMaterials[aLaneIndex], S_BLOCK);
            if (aByteRichness < 512) {
                XCTFail("test_TwistRound_Strong: for randoms, at lane %zu, expected byte richess 512+, got %zu", aLaneIndex, aByteRichness);
                return;
            }
            std::memcpy(aExpectation_B[aLaneIndex], Soccer3::mMaterials[aLaneIndex], S_BLOCK);
        }
        
        for (std::size_t aFirstIndex=1; aFirstIndex<aLaneCount; aFirstIndex++) {
            for (std::size_t aSecondIndex=0; aSecondIndex<aFirstIndex; aSecondIndex++) {
                if (std::memcmp(Soccer3::mMaterials[aFirstIndex], Soccer3::mMaterials[aSecondIndex], S_BLOCK) == 0) {
                    XCTFail("test_TwistRound_Strong: lanes at %zu and %zu were identical for randoms, should not happen", aFirstIndex, aSecondIndex);
                    return;
                }
            }
        }
        
        for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
            if (std::memcmp(aExpectation_A[aLaneIndex], aExpectation_B[aLaneIndex], S_BLOCK) == 0) {
                XCTFail("test_TwistRound_Strong: for compare zeros and randoms, at lane %zu, we had identical output. impossible.", aLaneIndex);
                return;
            }
        }
        
        
        for (std::size_t aBlockIndexIndex=0; aBlockIndexIndex<6; aBlockIndexIndex++) {
            
            std::size_t aBlockIndex = aBlockIndexList[aBlockIndexIndex];
            
            aIngress = 0xE025CAEA83AB99CFULL;
            aCarry = 0x6530BC4A53A443B8ULL;
            aWandererA = 0x4E06885276D20E3DULL;
            aWandererB = 0xEBF1E1AB6DF26920ULL;
            aWandererC = 0x99478E05E833FBB1ULL;
            aWandererD = 0x73A9F7B5B01778B2ULL;
            aWandererE = 0xB9AB363EA936D1EDULL;
            aWandererF = 0x847430D62AD62F79ULL;
            aWandererG = 0x0D6FE89E3169B0E1ULL;
            aWandererH = 0xD22934C37E3EE9B7ULL;
            aWandererI = 0x648E293C4DCD6ED1ULL;
            aWandererJ = 0xA31C40A884CAD927ULL;
            aWandererK = 0x183169CC43C8BCE3ULL;
            Soccer3::Zero();
            Soccer3::mStrength = aEncryptionStrength;
            
            for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
                Soccer3::mSources[aLaneIndex] = aSources_A[aLaneIndex];
                Soccer3::mCross[0][aLaneIndex] = aCrosses_A_A[aLaneIndex];
                Soccer3::mCross[1][aLaneIndex] = aCrosses_B_A[aLaneIndex];
                Soccer3::mCross[2][aLaneIndex] = aCrosses_C_A[aLaneIndex];
                Soccer3::mCross[3][aLaneIndex] = aCrosses_D_A[aLaneIndex];
            }
            
            Soccer3::TwistRound(aBlockIndex, false, ARX_STATE_VARS,&aCancelled);
            for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
                if (std::memcmp(&Soccer3::mMaterials[aLaneIndex][aBlockIndex * S_BLOCK],
                                aExpectation_A[aLaneIndex], S_BLOCK) != 0) {
                    XCTFail("test_TwistRound_Strong: at block %zu lane %zu, we did not get equal to expectation", aBlockIndex, aLaneIndex);
                    return;
                }
            }
            
            printf("test_TwistRound_Strong trial %zu finished block %zu (zero)\n", aTrial, aBlockIndex);
        }
        
        for (std::size_t aBlockIndexIndex=0; aBlockIndexIndex<6; aBlockIndexIndex++) {
            
            std::size_t aBlockIndex = aBlockIndexList[aBlockIndexIndex];
            
            aIngress = 0xE025CAEA83AB99CFULL;
            aCarry = 0x6530BC4A53A443B8ULL;
            aWandererA = 0x4E06885276D20E3DULL;
            aWandererB = 0xEBF1E1AB6DF26920ULL;
            aWandererC = 0x99478E05E833FBB1ULL;
            aWandererD = 0x73A9F7B5B01778B2ULL;
            aWandererE = 0xB9AB363EA936D1EDULL;
            aWandererF = 0x847430D62AD62F79ULL;
            aWandererG = 0x0D6FE89E3169B0E1ULL;
            aWandererH = 0xD22934C37E3EE9B7ULL;
            aWandererI = 0x648E293C4DCD6ED1ULL;
            aWandererJ = 0xA31C40A884CAD927ULL;
            aWandererK = 0x183169CC43C8BCE3ULL;
            Soccer3::Zero();
            Soccer3::mStrength = aEncryptionStrength;
            
            for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
                Soccer3::mSources[aLaneIndex] = aSources_B[aLaneIndex];
                Soccer3::mCross[0][aLaneIndex] = aCrosses_A_B[aLaneIndex];
                Soccer3::mCross[1][aLaneIndex] = aCrosses_B_B[aLaneIndex];
                Soccer3::mCross[2][aLaneIndex] = aCrosses_C_B[aLaneIndex];
                Soccer3::mCross[3][aLaneIndex] = aCrosses_D_B[aLaneIndex];
            }
            
            Soccer3::TwistRound(aBlockIndex, false, ARX_STATE_VARS,&aCancelled);
            for (std::size_t aLaneIndex=0; aLaneIndex<aLaneCount; aLaneIndex++) {
                if (std::memcmp(&Soccer3::mMaterials[aLaneIndex][aBlockIndex * S_BLOCK],
                                aExpectation_B[aLaneIndex], S_BLOCK) != 0) {
                    XCTFail("test_TwistRound_Strong: at block %zu lane %zu, we did not get equal to expectation", aBlockIndex, aLaneIndex);
                    return;
                }
            }
            
            printf("test_TwistRound_Strong trial %zu finished block %zu (randoms)\n", aTrial, aBlockIndex);
        }
        
    }
}

@end
