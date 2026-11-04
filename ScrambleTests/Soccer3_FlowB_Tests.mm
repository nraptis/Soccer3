//
//  Soccer3_FlowB_Tests.m
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

namespace {
template <typename T> std::string ToString(T **pList, std::size_t pCount) {
    if (pList == nullptr) {
        return "";
    }
    
    std::string aResult;
    aResult.reserve(pCount * sizeof(std::uintptr_t));
    
    for (std::size_t aIndex=0; aIndex<pCount; aIndex++) {
        const std::uintptr_t aPointer = reinterpret_cast<std::uintptr_t>(pList[aIndex]);
        aResult.append(reinterpret_cast<const char *>(&aPointer), sizeof(aPointer));
    }
    
    return aResult;
}

std::string ToString(const std::uint8_t *pList, std::size_t pCount) {
    if (pList == nullptr) {
        return "";
    }
    
    constexpr char cHex[] = "0123456789ABCDEF";
    
    std::string aResult;
    aResult.reserve(pCount * 2U);
    
    for (std::size_t aIndex=0U; aIndex<pCount; aIndex++) {
        const std::uint8_t aByte = pList[aIndex];
        aResult.push_back(cHex[aByte >> 4U]);
        aResult.push_back(cHex[aByte & 0x0FU]);
    }
    
    return aResult;
}
}

@interface Soccer3_FlowB_Tests : XCTestCase

@end

@implementation Soccer3_FlowB_Tests

- (void)test_Prologue_A_B_Shuffle_Weak {
    
    std::unordered_set<std::string> aHashesMaterials;
    std::unordered_set<std::string> aHashesExpanders;
    std::unordered_set<std::string> aHashesWorkSpaces;
    
    std::atomic<bool> aCancelled{false};
    
    for (std::size_t aTrial=0; aTrial<16; aTrial++) {
        
        
        std::uint64_t aNonce = Random::Get64();
        
        std::uint8_t aPassword[3];
        for (std::size_t aIndex=0; aIndex<3; aIndex++) {
            aPassword[aIndex] = Random::GetByte();
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
        Soccer3::mStrength = EncryptionStrength::kWeak;
        
        Soccer3::SeedPrologue_Regular_A(aPassword, 3, aNonce, ARX_STATE_VARS, &aCancelled);
        
        if (Soccer3::mClaimedExpanderCount != 4) {
            XCTFail("test_Prologue_A_B_Shuffle_Weak: expecting 4 claimed expanders.");
            return;
        }
        if (Soccer3::mClaimedMaterialCount != 4) {
            XCTFail("test_Prologue_A_B_Shuffle_Weak: expecting 4 claimed materials.");
            return;
        }
        if (Soccer3::mClaimedWorkSpaceCount != 4) {
            XCTFail("test_Prologue_A_B_Shuffle_Weak: expecting 4 claimed work spaces.");
            return;
        }
        
        std::unordered_set<TwistExpander *> aClaimedExpanderSet;
        for (std::size_t aExpanderIndex=0; aExpanderIndex<Soccer3::mClaimedExpanderCount; aExpanderIndex++) {
            aClaimedExpanderSet.insert(Soccer3::mClaimedExpanders[aExpanderIndex]);
        }
        
        std::unordered_set<std::uint8_t *> aClaimedMaterialSet;
        const std::size_t aWarmUpStartIndex = (32 - 6) * S_BLOCK;
        for (std::size_t aMaterialIndex=0; aMaterialIndex<Soccer3::mClaimedMaterialCount; aMaterialIndex++) {
            aClaimedMaterialSet.insert(Soccer3::mClaimedMaterials[aMaterialIndex]);
            std::size_t aByteRichness = LaneTool::ByteRichness(&Soccer3::mClaimedMaterials[aMaterialIndex][aWarmUpStartIndex], S_BLOCK);
            if (aByteRichness < 512) {
                XCTFail("test_Prologue_A_B_Shuffle_Weak: expecting claimed material [%zu] early block to be byte rich. (got %zu)", aMaterialIndex, aByteRichness);
                return;
            }
        }
        
        std::unordered_set<TwistWorkSpace *> aClaimedWorkSpaceSet;
        for (std::size_t aWorkSpaceIndex=0; aWorkSpaceIndex<Soccer3::mClaimedWorkSpaceCount; aWorkSpaceIndex++) {
            aClaimedWorkSpaceSet.insert(Soccer3::mClaimedWorkSpaces[aWorkSpaceIndex]);
        }
        
        std::unordered_set<std::uint8_t *> aAllMaterialSet;
        for (std::size_t aOuterMaterialIndex=0; aOuterMaterialIndex<16; aOuterMaterialIndex++) {
            
            aAllMaterialSet.insert(Soccer3::mMaterials[aOuterMaterialIndex]);
            
            if (aClaimedMaterialSet.contains(Soccer3::mMaterials[aOuterMaterialIndex])) {
                for (std::size_t aBlockIndex=0; aBlockIndex<32; aBlockIndex++) {
                    std::size_t aByteRichness = LaneTool::ByteRichness(&Soccer3::mMaterials[aOuterMaterialIndex][S_BLOCK * aBlockIndex], S_BLOCK);
                    
                    if (aBlockIndex == 26) {
                        if (aByteRichness < 512) {
                            XCTFail("test_Prologue_A_B_Shuffle_Weak: expecting claimed material [%zu] block [%zu] to be byte rich. (got %zu)", aOuterMaterialIndex, aBlockIndex, aByteRichness);
                            return;
                        }
                    } else {
                        if (aByteRichness > 64) {
                            XCTFail("test_Prologue_A_B_Shuffle_Weak: expecting claimed material [%zu] block [%zu] to be byte rich. (got %zu)", aOuterMaterialIndex, aBlockIndex, aByteRichness);
                            return;
                        }
                    }
                }
            } else {
                for (std::size_t aBlockIndex=0; aBlockIndex<32; aBlockIndex++) {
                    std::size_t aByteRichness = LaneTool::ByteRichness(&Soccer3::mMaterials[aOuterMaterialIndex][S_BLOCK * aBlockIndex], S_BLOCK);
                    if (aByteRichness > 64) {
                        XCTFail("test_Prologue_A_B_Shuffle_Weak: expecting claimed material [%zu] block [%zu] to be byte rich. (got %zu)", aOuterMaterialIndex, aBlockIndex, aByteRichness);
                        return;
                    }
                }
            }
            
            Soccer3::SeedPrologue_Regular_B();
            
            std::unordered_set<std::string> aShuffleHashesMaterials;
            std::unordered_set<std::string> aShuffleHashesExpanders;
            std::unordered_set<std::string> aShuffleHashesWorkSpaces;
            
            for (std::size_t aShuffleTrialIndex=0; aShuffleTrialIndex<8; aShuffleTrialIndex++) {
                
                std::unordered_set<std::uint8_t *> aCheckedMaterialSet;
                std::unordered_set<TwistExpander *> aCheckedExpanderSet;
                std::unordered_set<TwistWorkSpace *> aCheckedWorkSpaceSet;
                
                aShuffleHashesMaterials.insert(ToString(Soccer3::mMaterials, Soccer3::mClaimedMaterialCount));
                aShuffleHashesExpanders.insert(ToString(Soccer3::mExpanders, Soccer3::mClaimedExpanderCount));
                aShuffleHashesWorkSpaces.insert(ToString(Soccer3::mWorkSpaces, Soccer3::mClaimedWorkSpaceCount));
                
                if (aShuffleTrialIndex == 0) {
                    for (std::size_t aExpanderIndex=0; aExpanderIndex<SOCCER_EXPANDER_COUNT; aExpanderIndex++) {
                        if (aExpanderIndex < Soccer3::mClaimedExpanderCount) {
                            if (!aClaimedExpanderSet.contains(Soccer3::mExpanders[aExpanderIndex])) {
                                XCTFail("test_Prologue_A_B_Shuffle_Weak: expecting claimed expander [%zu], was not claimed. (shuffle #%zu)", aExpanderIndex, aShuffleTrialIndex);
                                return;
                            }
                        }
                        aCheckedExpanderSet.insert(Soccer3::mExpanders[aExpanderIndex]);
                    }
                } else {
                    for (std::size_t aExpanderIndex=0; aExpanderIndex<SOCCER_EXPANDER_COUNT; aExpanderIndex++) {
                        aCheckedExpanderSet.insert(Soccer3::mExpanders[aExpanderIndex]);
                    }
                }
                
                for (std::size_t aMaterialIndex=0; aMaterialIndex<16; aMaterialIndex++) {
                    if (aMaterialIndex < Soccer3::mClaimedMaterialCount) {
                        if (!aClaimedMaterialSet.contains(Soccer3::mMaterials[aMaterialIndex])) {
                            XCTFail("test_Prologue_A_B_Shuffle_Weak: expecting claimed material [%zu], was not claimed. (shuffle #%zu)", aMaterialIndex, aShuffleTrialIndex);
                            return;
                        }
                    }
                    aCheckedMaterialSet.insert(Soccer3::mMaterials[aMaterialIndex]);
                }
                
                for (std::size_t aWorkSpaceIndex=0; aWorkSpaceIndex<16; aWorkSpaceIndex++) {
                    if (aWorkSpaceIndex < Soccer3::mClaimedWorkSpaceCount) {
                        if (!aClaimedWorkSpaceSet.contains(Soccer3::mWorkSpaces[aWorkSpaceIndex])) {
                            XCTFail("test_Prologue_A_B_Shuffle_Weak: expecting claimed work space [%zu], was not claimed. (shuffle #%zu)", aWorkSpaceIndex, aShuffleTrialIndex);
                            return;
                        }
                    }
                    aCheckedWorkSpaceSet.insert(Soccer3::mWorkSpaces[aWorkSpaceIndex]);
                }
                
                if (aCheckedExpanderSet.size() != SOCCER_EXPANDER_COUNT) {
                    XCTFail("test_Prologue_A_B_Shuffle_Weak: expecting %d unique expanders. (shuffle #%zu)", SOCCER_EXPANDER_COUNT, aShuffleTrialIndex);
                    return;
                }
                if (aCheckedMaterialSet.size() != 16) {
                    XCTFail("test_Prologue_A_B_Shuffle_Weak: expecting 16 unique materials. (shuffle #%zu)", aShuffleTrialIndex);
                    return;
                }
                if (aCheckedWorkSpaceSet.size() != 16) {
                    XCTFail("test_Prologue_A_B_Shuffle_Weak: expecting 16 unique work spaces. (shuffle #%zu)", aShuffleTrialIndex);
                    return;
                }
                
                WorkSpaceTools::FillBytes(Soccer3::mRandom, S_BLOCK);
                Soccer3::Shuffle_CROWSCIMASSORMATEX();
            }
            
            if (aShuffleHashesMaterials.size() < 3) {
                XCTFail("test_Prologue_A_B_Shuffle_Weak: expecting 3 unique shuffles for material hashes, got %zu", aShuffleHashesMaterials.size());
                return;
            }
            
            if (aShuffleHashesExpanders.size() < 6) {
                XCTFail("test_Prologue_A_B_Shuffle_Weak: expecting 6 unique shuffles for expanders hashes, got %zu", aShuffleHashesExpanders.size());
                return;
            }
            
            if (aShuffleHashesWorkSpaces.size() < 3) {
                XCTFail("test_Prologue_A_B_Shuffle_Weak: expecting 3 unique shuffles for work space hashes, got %zu", aShuffleHashesWorkSpaces.size());
                return;
            }
        }
        
        aHashesMaterials.insert(ToString(Soccer3::mClaimedMaterials, Soccer3::mClaimedMaterialCount));
        aHashesExpanders.insert(ToString(Soccer3::mClaimedExpanders, Soccer3::mClaimedExpanderCount));
        aHashesWorkSpaces.insert(ToString(Soccer3::mClaimedWorkSpaces, Soccer3::mClaimedWorkSpaceCount));
        
        const std::size_t aFirstSaltSlot = static_cast<std::size_t>(TwistWorkSpaceSlot::kKeyRotateASaltOrbiterAssignA);
        const std::size_t aLastSaltSlot = static_cast<std::size_t>(TwistWorkSpaceSlot::kKeySpawnBSaltWandererUpdateH);
        
        for (std::size_t aWorkSpaceIndex=0U; aWorkSpaceIndex<Soccer3::mClaimedWorkSpaceCount; aWorkSpaceIndex++) {
            for (std::size_t aSaltSlot=aFirstSaltSlot; aSaltSlot<=aLastSaltSlot; aSaltSlot++) {
                std::uint8_t *aSalt = TwistWorkSpace::GetBuffer(Soccer3::mWorkSpaces[aWorkSpaceIndex],
                                                                static_cast<TwistWorkSpaceSlot>(aSaltSlot));
                const std::size_t aByteRichness = LaneTool::ByteRichness(aSalt, S_SALT * sizeof(std::uint64_t));
                const std::size_t aSaltIndex = aSaltSlot - aFirstSaltSlot;
                
                if (aByteRichness < 480U) {
                    XCTFail("test_Prologue_A_B_Shuffle_Weak: expected work space [%zu], salt %zu to have 480 byte richness, got %zu.",
                            aWorkSpaceIndex, aSaltIndex, aByteRichness);
                    return;
                }
            }
        }
    }
    
    if (aHashesMaterials.size() < 12) {
        XCTFail("test_Prologue_A_Weak: expected more unique claimed material configurations");
        return;
    }
    if (aHashesExpanders.size() < 12) {
        XCTFail("test_Prologue_A_Weak: expected more unique claimed expander configurations");
        return;
    }
    if (aHashesWorkSpaces.size() < 12) {
        XCTFail("test_Prologue_A_Weak: expected more unique claimed work space configurations");
        return;
    }
    
}

- (void)test_Prologue_A_B_Shuffle_Normal {
    
    std::unordered_set<std::string> aHashesMaterials;
    std::unordered_set<std::string> aHashesExpanders;
    std::unordered_set<std::string> aHashesWorkSpaces;
    
    std::atomic<bool> aCancelled{false};
    
    for (std::size_t aTrial=0; aTrial<12; aTrial++) {
        
        
        std::uint64_t aNonce = Random::Get64();
        
        std::uint8_t aPassword[3];
        for (std::size_t aIndex=0; aIndex<3; aIndex++) {
            aPassword[aIndex] = Random::GetByte();
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
        Soccer3::mStrength = EncryptionStrength::kNormal;
        
        Soccer3::SeedPrologue_Regular_A(aPassword, 3, aNonce, ARX_STATE_VARS, &aCancelled);
        
        if (Soccer3::mClaimedExpanderCount != 8) {
            XCTFail("test_Prologue_A_B_Shuffle_Normal: expecting 8 claimed expanders.");
            return;
        }
        if (Soccer3::mClaimedMaterialCount != 8) {
            XCTFail("test_Prologue_A_B_Shuffle_Normal: expecting 8 claimed materials.");
            return;
        }
        if (Soccer3::mClaimedWorkSpaceCount != 8) {
            XCTFail("test_Prologue_A_B_Shuffle_Normal: expecting 8 claimed work spaces.");
            return;
        }
        
        
        std::unordered_set<TwistExpander *> aClaimedExpanderSet;
        for (std::size_t aExpanderIndex=0; aExpanderIndex<Soccer3::mClaimedExpanderCount; aExpanderIndex++) {
            aClaimedExpanderSet.insert(Soccer3::mClaimedExpanders[aExpanderIndex]);
        }
        
        std::unordered_set<std::uint8_t *> aClaimedMaterialSet;
        const std::size_t aWarmUpStartIndex = (32 - 6) * S_BLOCK;
        for (std::size_t aMaterialIndex=0; aMaterialIndex<Soccer3::mClaimedMaterialCount; aMaterialIndex++) {
            aClaimedMaterialSet.insert(Soccer3::mClaimedMaterials[aMaterialIndex]);
            std::size_t aByteRichness = LaneTool::ByteRichness(&Soccer3::mClaimedMaterials[aMaterialIndex][aWarmUpStartIndex], S_BLOCK);
            if (aByteRichness < 512) {
                XCTFail("test_Prologue_A_B_Shuffle_Normal: expecting claimed material [%zu] early block to be byte rich. (got %zu)", aMaterialIndex, aByteRichness);
                return;
            }
        }
        
        std::unordered_set<TwistWorkSpace *> aClaimedWorkSpaceSet;
        for (std::size_t aWorkSpaceIndex=0; aWorkSpaceIndex<Soccer3::mClaimedWorkSpaceCount; aWorkSpaceIndex++) {
            aClaimedWorkSpaceSet.insert(Soccer3::mClaimedWorkSpaces[aWorkSpaceIndex]);
        }
        
        std::unordered_set<std::uint8_t *> aAllMaterialSet;
        for (std::size_t aOuterMaterialIndex=0; aOuterMaterialIndex<16; aOuterMaterialIndex++) {
            
            aAllMaterialSet.insert(Soccer3::mMaterials[aOuterMaterialIndex]);
            
            if (aClaimedMaterialSet.contains(Soccer3::mMaterials[aOuterMaterialIndex])) {
                for (std::size_t aBlockIndex=0; aBlockIndex<32; aBlockIndex++) {
                    std::size_t aByteRichness = LaneTool::ByteRichness(&Soccer3::mMaterials[aOuterMaterialIndex][S_BLOCK * aBlockIndex], S_BLOCK);
                    
                    if (aBlockIndex == 26) {
                        if (aByteRichness < 512) {
                            XCTFail("test_Prologue_A_B_Shuffle_Normal: expecting claimed material [%zu] block [%zu] to be byte rich. (got %zu)", aOuterMaterialIndex, aBlockIndex, aByteRichness);
                            return;
                        }
                    } else {
                        if (aByteRichness > 64) {
                            XCTFail("test_Prologue_A_B_Shuffle_Normal: expecting claimed material [%zu] block [%zu] to be byte rich. (got %zu)", aOuterMaterialIndex, aBlockIndex, aByteRichness);
                            return;
                        }
                    }
                }
            } else {
                for (std::size_t aBlockIndex=0; aBlockIndex<32; aBlockIndex++) {
                    std::size_t aByteRichness = LaneTool::ByteRichness(&Soccer3::mMaterials[aOuterMaterialIndex][S_BLOCK * aBlockIndex], S_BLOCK);
                    if (aByteRichness > 64) {
                        XCTFail("test_Prologue_A_B_Shuffle_Normal: expecting claimed material [%zu] block [%zu] to be byte rich. (got %zu)", aOuterMaterialIndex, aBlockIndex, aByteRichness);
                        return;
                    }
                }
            }
            
            Soccer3::SeedPrologue_Regular_B();
            
            std::unordered_set<std::string> aShuffleHashesMaterials;
            std::unordered_set<std::string> aShuffleHashesExpanders;
            std::unordered_set<std::string> aShuffleHashesWorkSpaces;
            
            for (std::size_t aShuffleTrialIndex=0; aShuffleTrialIndex<8; aShuffleTrialIndex++) {
                
                std::unordered_set<std::uint8_t *> aCheckedMaterialSet;
                std::unordered_set<TwistExpander *> aCheckedExpanderSet;
                std::unordered_set<TwistWorkSpace *> aCheckedWorkSpaceSet;
                
                aShuffleHashesMaterials.insert(ToString(Soccer3::mMaterials, Soccer3::mClaimedMaterialCount));
                aShuffleHashesExpanders.insert(ToString(Soccer3::mExpanders, Soccer3::mClaimedExpanderCount));
                aShuffleHashesWorkSpaces.insert(ToString(Soccer3::mWorkSpaces, Soccer3::mClaimedWorkSpaceCount));
                
                if (aShuffleTrialIndex == 0) {
                    for (std::size_t aExpanderIndex=0; aExpanderIndex<SOCCER_EXPANDER_COUNT; aExpanderIndex++) {
                        if (aExpanderIndex < Soccer3::mClaimedExpanderCount) {
                            if (!aClaimedExpanderSet.contains(Soccer3::mExpanders[aExpanderIndex])) {
                                XCTFail("test_Prologue_A_B_Shuffle_Normal: expecting claimed expander [%zu], was not claimed. (shuffle #%zu)", aExpanderIndex, aShuffleTrialIndex);
                                return;
                            }
                        }
                        aCheckedExpanderSet.insert(Soccer3::mExpanders[aExpanderIndex]);
                    }
                } else {
                    for (std::size_t aExpanderIndex=0; aExpanderIndex<SOCCER_EXPANDER_COUNT; aExpanderIndex++) {
                        aCheckedExpanderSet.insert(Soccer3::mExpanders[aExpanderIndex]);
                    }
                }
                
                for (std::size_t aMaterialIndex=0; aMaterialIndex<16; aMaterialIndex++) {
                    if (aMaterialIndex < Soccer3::mClaimedMaterialCount) {
                        if (!aClaimedMaterialSet.contains(Soccer3::mMaterials[aMaterialIndex])) {
                            XCTFail("test_Prologue_A_B_Shuffle_Normal: expecting claimed material [%zu], was not claimed. (shuffle #%zu)", aMaterialIndex, aShuffleTrialIndex);
                            return;
                        }
                    }
                    aCheckedMaterialSet.insert(Soccer3::mMaterials[aMaterialIndex]);
                }
                
                for (std::size_t aWorkSpaceIndex=0; aWorkSpaceIndex<16; aWorkSpaceIndex++) {
                    if (aWorkSpaceIndex < Soccer3::mClaimedWorkSpaceCount) {
                        if (!aClaimedWorkSpaceSet.contains(Soccer3::mWorkSpaces[aWorkSpaceIndex])) {
                            XCTFail("test_Prologue_A_B_Shuffle_Normal: expecting claimed work space [%zu], was not claimed. (shuffle #%zu)", aWorkSpaceIndex, aShuffleTrialIndex);
                            return;
                        }
                    }
                    aCheckedWorkSpaceSet.insert(Soccer3::mWorkSpaces[aWorkSpaceIndex]);
                }
                
                if (aCheckedExpanderSet.size() != SOCCER_EXPANDER_COUNT) {
                    XCTFail("test_Prologue_A_B_Shuffle_Normal: expecting %d unique expanders. (shuffle #%zu)", SOCCER_EXPANDER_COUNT, aShuffleTrialIndex);
                    return;
                }
                if (aCheckedMaterialSet.size() != 16) {
                    XCTFail("test_Prologue_A_B_Shuffle_Normal: expecting 16 unique materials. (shuffle #%zu)", aShuffleTrialIndex);
                    return;
                }
                if (aCheckedWorkSpaceSet.size() != 16) {
                    XCTFail("test_Prologue_A_B_Shuffle_Normal: expecting 16 unique work spaces. (shuffle #%zu)", aShuffleTrialIndex);
                    return;
                }
                
                WorkSpaceTools::FillBytes(Soccer3::mRandom, S_BLOCK);
                Soccer3::Shuffle_CROWSCIMASSORMATEX();
            }
            
            if (aShuffleHashesMaterials.size() < 3) {
                XCTFail("test_Prologue_A_B_Shuffle_Normal: expecting 3 unique shuffles for material hashes, got %zu", aShuffleHashesMaterials.size());
                return;
            }
            
            if (aShuffleHashesExpanders.size() < 6) {
                XCTFail("test_Prologue_A_B_Shuffle_Normal: expecting 6 unique shuffles for expanders hashes, got %zu", aShuffleHashesExpanders.size());
                return;
            }
            
            if (aShuffleHashesWorkSpaces.size() < 3) {
                XCTFail("test_Prologue_A_B_Shuffle_Normal: expecting 3 unique shuffles for work space hashes, got %zu", aShuffleHashesWorkSpaces.size());
                return;
            }
        }
        
        aHashesMaterials.insert(ToString(Soccer3::mClaimedMaterials, Soccer3::mClaimedMaterialCount));
        aHashesExpanders.insert(ToString(Soccer3::mClaimedExpanders, Soccer3::mClaimedExpanderCount));
        aHashesWorkSpaces.insert(ToString(Soccer3::mClaimedWorkSpaces, Soccer3::mClaimedWorkSpaceCount));
        
        const std::size_t aFirstSaltSlot = static_cast<std::size_t>(TwistWorkSpaceSlot::kKeyRotateASaltOrbiterAssignA);
        const std::size_t aLastSaltSlot = static_cast<std::size_t>(TwistWorkSpaceSlot::kKeySpawnBSaltWandererUpdateH);
        
        for (std::size_t aWorkSpaceIndex=0U; aWorkSpaceIndex<Soccer3::mClaimedWorkSpaceCount; aWorkSpaceIndex++) {
            for (std::size_t aSaltSlot=aFirstSaltSlot; aSaltSlot<=aLastSaltSlot; aSaltSlot++) {
                std::uint8_t *aSalt = TwistWorkSpace::GetBuffer(Soccer3::mWorkSpaces[aWorkSpaceIndex],
                                                                static_cast<TwistWorkSpaceSlot>(aSaltSlot));
                const std::size_t aByteRichness = LaneTool::ByteRichness(aSalt, S_SALT * sizeof(std::uint64_t));
                const std::size_t aSaltIndex = aSaltSlot - aFirstSaltSlot;
                
                if (aByteRichness < 480U) {
                    XCTFail("test_Prologue_A_B_Shuffle_Normal: expected work space [%zu], salt %zu to have 480 byte richness, got %zu.",
                            aWorkSpaceIndex, aSaltIndex, aByteRichness);
                    return;
                }
            }
        }
        
    }
    
    if (aHashesMaterials.size() < 8) {
        XCTFail("test_Prologue_A_B_Shuffle_Normal: expected more unique claimed material configurations");
        return;
    }
    if (aHashesExpanders.size() < 8) {
        XCTFail("test_Prologue_A_B_Shuffle_Normal: expected more unique claimed expander configurations");
        return;
    }
    if (aHashesWorkSpaces.size() < 8) {
        XCTFail("test_Prologue_A_B_Shuffle_Normal: expected more unique claimed work space configurations");
        return;
    }
}

- (void)test_Prologue_A_B_Shuffle_Strong {
    
    std::atomic<bool> aCancelled{false};
    
    std::unordered_set<std::string> aHashesMaterials;
    std::unordered_set<std::string> aHashesExpanders;
    std::unordered_set<std::string> aHashesWorkSpaces;
    
    for (std::size_t aTrial=0; aTrial<8; aTrial++) {
        
        
        std::uint64_t aNonce = Random::Get64();
        
        std::uint8_t aPassword[3];
        for (std::size_t aIndex=0; aIndex<3; aIndex++) {
            aPassword[aIndex] = Random::GetByte();
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
        Soccer3::mStrength = EncryptionStrength::kStrong;
        
        Soccer3::SeedPrologue_Regular_A(aPassword, 3, aNonce, ARX_STATE_VARS, &aCancelled);
        
        if (Soccer3::mClaimedExpanderCount != 16) {
            XCTFail("test_Prologue_A_B_Shuffle_Strong: expecting 16 claimed expanders.");
            return;
        }
        if (Soccer3::mClaimedMaterialCount != 16) {
            XCTFail("test_Prologue_A_B_Shuffle_Strong: expecting 16 claimed materials.");
            return;
        }
        if (Soccer3::mClaimedWorkSpaceCount != 16) {
            XCTFail("test_Prologue_A_B_Shuffle_Strong: expecting 16 claimed work spaces.");
            return;
        }
        
        
        std::unordered_set<TwistExpander *> aClaimedExpanderSet;
        for (std::size_t aExpanderIndex=0; aExpanderIndex<Soccer3::mClaimedExpanderCount; aExpanderIndex++) {
            aClaimedExpanderSet.insert(Soccer3::mClaimedExpanders[aExpanderIndex]);
        }
        
        std::unordered_set<std::uint8_t *> aClaimedMaterialSet;
        const std::size_t aWarmUpStartIndex = (32 - 6) * S_BLOCK;
        for (std::size_t aMaterialIndex=0; aMaterialIndex<Soccer3::mClaimedMaterialCount; aMaterialIndex++) {
            aClaimedMaterialSet.insert(Soccer3::mClaimedMaterials[aMaterialIndex]);
            std::size_t aByteRichness = LaneTool::ByteRichness(&Soccer3::mClaimedMaterials[aMaterialIndex][aWarmUpStartIndex], S_BLOCK);
            if (aByteRichness < 512) {
                XCTFail("test_Prologue_A_B_Shuffle_Strong: expecting claimed material [%zu] early block to be byte rich. (got %zu)", aMaterialIndex, aByteRichness);
                return;
            }
        }
        
        std::unordered_set<TwistWorkSpace *> aClaimedWorkSpaceSet;
        for (std::size_t aWorkSpaceIndex=0; aWorkSpaceIndex<Soccer3::mClaimedWorkSpaceCount; aWorkSpaceIndex++) {
            aClaimedWorkSpaceSet.insert(Soccer3::mClaimedWorkSpaces[aWorkSpaceIndex]);
        }
        
        std::unordered_set<std::uint8_t *> aAllMaterialSet;
        for (std::size_t aOuterMaterialIndex=0; aOuterMaterialIndex<16; aOuterMaterialIndex++) {
            
            aAllMaterialSet.insert(Soccer3::mMaterials[aOuterMaterialIndex]);
            
            if (aClaimedMaterialSet.contains(Soccer3::mMaterials[aOuterMaterialIndex])) {
                for (std::size_t aBlockIndex=0; aBlockIndex<32; aBlockIndex++) {
                    std::size_t aByteRichness = LaneTool::ByteRichness(&Soccer3::mMaterials[aOuterMaterialIndex][S_BLOCK * aBlockIndex], S_BLOCK);
                    
                    if (aBlockIndex == 26) {
                        if (aByteRichness < 512) {
                            XCTFail("test_Prologue_A_B_Shuffle_Strong: expecting claimed material [%zu] block [%zu] to be byte rich. (got %zu)", aOuterMaterialIndex, aBlockIndex, aByteRichness);
                            return;
                        }
                    } else {
                        if (aByteRichness > 64) {
                            XCTFail("test_Prologue_A_B_Shuffle_Strong: expecting claimed material [%zu] block [%zu] to be byte rich. (got %zu)", aOuterMaterialIndex, aBlockIndex, aByteRichness);
                            return;
                        }
                    }
                }
            } else {
                for (std::size_t aBlockIndex=0; aBlockIndex<32; aBlockIndex++) {
                    std::size_t aByteRichness = LaneTool::ByteRichness(&Soccer3::mMaterials[aOuterMaterialIndex][S_BLOCK * aBlockIndex], S_BLOCK);
                    if (aByteRichness > 64) {
                        XCTFail("test_Prologue_A_B_Shuffle_Strong: expecting claimed material [%zu] block [%zu] to be byte rich. (got %zu)", aOuterMaterialIndex, aBlockIndex, aByteRichness);
                        return;
                    }
                }
            }
            
            Soccer3::SeedPrologue_Regular_B();
            
            std::unordered_set<std::string> aShuffleHashesMaterials;
            std::unordered_set<std::string> aShuffleHashesExpanders;
            std::unordered_set<std::string> aShuffleHashesWorkSpaces;
            
            for (std::size_t aShuffleTrialIndex=0; aShuffleTrialIndex<8; aShuffleTrialIndex++) {
                
                std::unordered_set<std::uint8_t *> aCheckedMaterialSet;
                std::unordered_set<TwistExpander *> aCheckedExpanderSet;
                std::unordered_set<TwistWorkSpace *> aCheckedWorkSpaceSet;
                
                aShuffleHashesMaterials.insert(ToString(Soccer3::mMaterials, Soccer3::mClaimedMaterialCount));
                aShuffleHashesExpanders.insert(ToString(Soccer3::mExpanders, Soccer3::mClaimedExpanderCount));
                aShuffleHashesWorkSpaces.insert(ToString(Soccer3::mWorkSpaces, Soccer3::mClaimedWorkSpaceCount));
                
                if (aShuffleTrialIndex == 0) {
                    for (std::size_t aExpanderIndex=0; aExpanderIndex<SOCCER_EXPANDER_COUNT; aExpanderIndex++) {
                        if (aExpanderIndex < Soccer3::mClaimedExpanderCount) {
                            if (!aClaimedExpanderSet.contains(Soccer3::mExpanders[aExpanderIndex])) {
                                XCTFail("test_Prologue_A_B_Shuffle_Strong: expecting claimed expander [%zu], was not claimed. (shuffle #%zu)", aExpanderIndex, aShuffleTrialIndex);
                                return;
                            }
                        }
                        aCheckedExpanderSet.insert(Soccer3::mExpanders[aExpanderIndex]);
                    }
                } else {
                    for (std::size_t aExpanderIndex=0; aExpanderIndex<SOCCER_EXPANDER_COUNT; aExpanderIndex++) {
                        aCheckedExpanderSet.insert(Soccer3::mExpanders[aExpanderIndex]);
                    }
                }
                
                for (std::size_t aMaterialIndex=0; aMaterialIndex<16; aMaterialIndex++) {
                    if (aMaterialIndex < Soccer3::mClaimedMaterialCount) {
                        if (!aClaimedMaterialSet.contains(Soccer3::mMaterials[aMaterialIndex])) {
                            XCTFail("test_Prologue_A_B_Shuffle_Strong: expecting claimed material [%zu], was not claimed. (shuffle #%zu)", aMaterialIndex, aShuffleTrialIndex);
                            return;
                        }
                    }
                    aCheckedMaterialSet.insert(Soccer3::mMaterials[aMaterialIndex]);
                }
                
                for (std::size_t aWorkSpaceIndex=0; aWorkSpaceIndex<16; aWorkSpaceIndex++) {
                    if (aWorkSpaceIndex < Soccer3::mClaimedWorkSpaceCount) {
                        if (!aClaimedWorkSpaceSet.contains(Soccer3::mWorkSpaces[aWorkSpaceIndex])) {
                            XCTFail("test_Prologue_A_B_Shuffle_Strong: expecting claimed work space [%zu], was not claimed. (shuffle #%zu)", aWorkSpaceIndex, aShuffleTrialIndex);
                            return;
                        }
                    }
                    aCheckedWorkSpaceSet.insert(Soccer3::mWorkSpaces[aWorkSpaceIndex]);
                }
                
                if (aCheckedExpanderSet.size() != SOCCER_EXPANDER_COUNT) {
                    XCTFail("test_Prologue_A_B_Shuffle_Strong: expecting %d unique expanders. (shuffle #%zu)", SOCCER_EXPANDER_COUNT, aShuffleTrialIndex);
                    return;
                }
                if (aCheckedMaterialSet.size() != 16) {
                    XCTFail("test_Prologue_A_B_Shuffle_Strong: expecting 16 unique materials. (shuffle #%zu)", aShuffleTrialIndex);
                    return;
                }
                if (aCheckedWorkSpaceSet.size() != 16) {
                    XCTFail("test_Prologue_A_B_Shuffle_Strong: expecting 16 unique work spaces. (shuffle #%zu)", aShuffleTrialIndex);
                    return;
                }
                
                WorkSpaceTools::FillBytes(Soccer3::mRandom, S_BLOCK);
                Soccer3::Shuffle_CROWSCIMASSORMATEX();
            }
            
            if (aShuffleHashesMaterials.size() < 3) {
                XCTFail("test_Prologue_A_B_Shuffle_Strong: expecting 3 unique shuffles for material hashes, got %zu", aShuffleHashesMaterials.size());
                return;
            }
            
            if (aShuffleHashesExpanders.size() < 6) {
                XCTFail("test_Prologue_A_B_Shuffle_Strong: expecting 6 unique shuffles for expanders hashes, got %zu", aShuffleHashesExpanders.size());
                return;
            }
            
            if (aShuffleHashesWorkSpaces.size() < 3) {
                XCTFail("test_Prologue_A_B_Shuffle_Strong: expecting 3 unique shuffles for work space hashes, got %zu", aShuffleHashesWorkSpaces.size());
                return;
            }
        }
        
        aHashesMaterials.insert(ToString(Soccer3::mClaimedMaterials, Soccer3::mClaimedMaterialCount));
        aHashesExpanders.insert(ToString(Soccer3::mClaimedExpanders, Soccer3::mClaimedExpanderCount));
        aHashesWorkSpaces.insert(ToString(Soccer3::mClaimedWorkSpaces, Soccer3::mClaimedWorkSpaceCount));

        const std::size_t aFirstSaltSlot = static_cast<std::size_t>(TwistWorkSpaceSlot::kKeyRotateASaltOrbiterAssignA);
        const std::size_t aLastSaltSlot = static_cast<std::size_t>(TwistWorkSpaceSlot::kKeySpawnBSaltWandererUpdateH);

        for (std::size_t aWorkSpaceIndex=0U; aWorkSpaceIndex<Soccer3::mClaimedWorkSpaceCount; aWorkSpaceIndex++) {
            for (std::size_t aSaltSlot=aFirstSaltSlot; aSaltSlot<=aLastSaltSlot; aSaltSlot++) {
                std::uint8_t *aSalt = TwistWorkSpace::GetBuffer(Soccer3::mWorkSpaces[aWorkSpaceIndex],
                                                               static_cast<TwistWorkSpaceSlot>(aSaltSlot));
                const std::size_t aByteRichness = LaneTool::ByteRichness(aSalt, S_SALT * sizeof(std::uint64_t));
                const std::size_t aSaltIndex = aSaltSlot - aFirstSaltSlot;

                if (aByteRichness < 480U) {
                    XCTFail("test_Prologue_A_B_Shuffle_Strong: expected work space [%zu], salt %zu to have 480 byte richness, got %zu.",
                            aWorkSpaceIndex, aSaltIndex, aByteRichness);
                    return;
                }
            }
        }
        
    }
    
    if (aHashesMaterials.size() < 6) {
        XCTFail("test_Prologue_A_B_Shuffle_Strong: expected more unique claimed material configurations");
        return;
    }
    if (aHashesExpanders.size() < 6) {
        XCTFail("test_Prologue_A_B_Shuffle_Strong: expected more unique claimed expander configurations");
        return;
    }
    if (aHashesWorkSpaces.size() < 6) {
        XCTFail("test_Prologue_A_B_Shuffle_Strong: expected more unique claimed work space configurations");
        return;
    }
    
}

@end
