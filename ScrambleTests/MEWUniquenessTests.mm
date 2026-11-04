//
//  MEWUniquenessTests.m
//  ScrambleTests
//
//  Created by Icarus Black on 8/5/26.
//


#import <XCTest/XCTest.h>
#include <atomic>
#include "Soccer3.hpp"
#include "Random.hpp"
#include <cstdint>
#include <cstring>
#include <string>
#include <unordered_set>


@interface MEWUniquenessTests : XCTestCase

@end

@implementation MEWUniquenessTests

template <typename T>
std::string ToString(T **pList, std::size_t pCount) {
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

- (void)test_MEW_weak_100 {
    
    
    std::unordered_set<std::string> aMaterialHashes;
    std::unordered_set<std::string> aExpanderHashes;
    std::unordered_set<std::string> aWorkSpaceHashes;
    
    
    for (std::size_t aTrial=0; aTrial<16; aTrial++) {
        
        
        std::uint64_t aNonce = Random::Get64();
        
        std::uint8_t aPassword[10];
        for (std::size_t aIndex=0; aIndex<10; aIndex++) {
            aPassword[aIndex] = Random::GetByte();
        }
        
        
        std::uint32_t aAckWord = 0xFF00FF00;
        
        std::atomic<bool> aCancelled{false};
        if (!Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kWeak, aPassword, 10, aNonce, &aAckWord,0,&aCancelled)) {
            XCTFail("test_MEW_weak_100: failed seed encrypt.");
            return;
        }
        
        static std::uint8_t *aMaterials[16];
        static TwistExpander *aExpanders[SOCCER_EXPANDER_COUNT];
        static TwistWorkSpace *aWorkSpaces[16];
        
        for (std::size_t aIndex=0; aIndex<4; aIndex++) {
            aMaterials[aIndex] = Soccer3::mMaterials[aIndex];
            aExpanders[aIndex] = Soccer3::mExpanders[aIndex];
            aWorkSpaces[aIndex] = Soccer3::mWorkSpaces[aIndex];
        }
        
        for (int aIndexA=1; aIndexA<4; aIndexA++) {
            for (int aIndexB=(aIndexA - 1); aIndexB>=0; aIndexB--) {
                if (aMaterials[aIndexA] == aMaterials[aIndexB]) {
                    XCTFail("test_MEW_weak_100: failed duplicate material.");
                    return;
                }
                if (aExpanders[aIndexA] == aExpanders[aIndexB]) {
                    XCTFail("test_MEW_weak_100: failed duplicate expander.");
                    return;
                }
                if (aWorkSpaces[aIndexA] == aWorkSpaces[aIndexB]) {
                    XCTFail("test_MEW_weak_100: failed duplicate work spaces.");
                    return;
                }
            }
            
        }
        
        aMaterialHashes.insert(ToString(aMaterials, 4));
        aExpanderHashes.insert(ToString(aExpanders, 4));
        aWorkSpaceHashes.insert(ToString(aWorkSpaces, 4));
    }
    
    if (aMaterialHashes.size() < 10) {
        XCTFail("test_MEW_weak_100: expected more unique material permutations.");
        return;
    }
    if (aExpanderHashes.size() < 10) {
        XCTFail("test_MEW_weak_100: expected more unique expander permutations.");
        return;
    }
    if (aWorkSpaceHashes.size() < 10) {
        XCTFail("test_MEW_weak_100: expected more unique work space permutations.");
        return;
    }
    
    printf("weak material permutations: %zu\n", aMaterialHashes.size());
    printf("weak expander permutations: %zu\n", aExpanderHashes.size());
    printf("weak work space permutations: %zu\n", aWorkSpaceHashes.size());
    
}

- (void)test_MEW_normal_100 {
    
    
    std::unordered_set<std::string> aMaterialHashes;
    std::unordered_set<std::string> aExpanderHashes;
    std::unordered_set<std::string> aWorkSpaceHashes;
    
    
    for (std::size_t aTrial=0; aTrial<8; aTrial++) {
        
        
        std::uint64_t aNonce = Random::Get64();
        
        std::uint8_t aPassword[10];
        for (std::size_t aIndex=0; aIndex<10; aIndex++) {
            aPassword[aIndex] = Random::GetByte();
        }
        
        
        std::uint32_t aAckWord = 0xFF00FF00;
        
        std::atomic<bool> aCancelled{false};
        if (!Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kNormal, aPassword, 10, aNonce, &aAckWord,0,&aCancelled)) {
            XCTFail("test_MEW_normal_100: failed seed encrypt.");
            return;
        }
        
        static std::uint8_t *aMaterials[16];
        static TwistExpander *aExpanders[SOCCER_EXPANDER_COUNT];
        static TwistWorkSpace *aWorkSpaces[16];
        
        for (std::size_t aIndex=0; aIndex<8; aIndex++) {
            aMaterials[aIndex] = Soccer3::mMaterials[aIndex];
            aExpanders[aIndex] = Soccer3::mExpanders[aIndex];
            aWorkSpaces[aIndex] = Soccer3::mWorkSpaces[aIndex];
        }
        
        for (int aIndexA=1; aIndexA<8; aIndexA++) {
            for (int aIndexB=(aIndexA - 1); aIndexB>=0; aIndexB--) {
                if (aMaterials[aIndexA] == aMaterials[aIndexB]) {
                    XCTFail("test_MEW_normal_100: failed duplicate material.");
                    return;
                }
                if (aExpanders[aIndexA] == aExpanders[aIndexB]) {
                    XCTFail("test_MEW_normal_100: failed duplicate expander.");
                    return;
                }
                if (aWorkSpaces[aIndexA] == aWorkSpaces[aIndexB]) {
                    XCTFail("test_MEW_normal_100: failed duplicate work spaces.");
                    return;
                }
            }
            
        }
        
        aMaterialHashes.insert(ToString(aMaterials, 8));
        aExpanderHashes.insert(ToString(aExpanders, 8));
        aWorkSpaceHashes.insert(ToString(aWorkSpaces, 8));
    }
    
    if (aMaterialHashes.size() < 5) {
        XCTFail("test_MEW_normal_100: expected more unique material permutations.");
        return;
    }
    if (aExpanderHashes.size() < 5) {
        XCTFail("test_MEW_normal_100: expected more unique expander permutations.");
        return;
    }
    if (aWorkSpaceHashes.size() < 5) {
        XCTFail("test_MEW_normal_100: expected more unique work space permutations.");
        return;
    }
    
    printf("medium material permutations: %zu\n", aMaterialHashes.size());
    printf("medium expander permutations: %zu\n", aExpanderHashes.size());
    printf("medium work space permutations: %zu\n", aWorkSpaceHashes.size());
    
}

- (void)test_MEW_strong_100 {
    
    
    std::unordered_set<std::string> aMaterialHashes;
    std::unordered_set<std::string> aExpanderHashes;
    std::unordered_set<std::string> aWorkSpaceHashes;
    
    
    for (std::size_t aTrial=0; aTrial<6; aTrial++) {
        
        
        std::uint64_t aNonce = Random::Get64();
        
        std::uint8_t aPassword[10];
        for (std::size_t aIndex=0; aIndex<10; aIndex++) {
            aPassword[aIndex] = Random::GetByte();
        }
        
        std::uint32_t aAckWord = 0xFF00FF00;
        
        std::atomic<bool> aCancelled{false};
        if (!Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kNormal, aPassword, 10, aNonce, &aAckWord,0,&aCancelled)) {
            XCTFail("test_MEW_strong_100: failed seed encrypt.");
            return;
        }
        
        static std::uint8_t *aMaterials[16];
        static TwistExpander *aExpanders[SOCCER_EXPANDER_COUNT];
        static TwistWorkSpace *aWorkSpaces[16];
        
        for (std::size_t aIndex=0; aIndex<16; aIndex++) {
            aMaterials[aIndex] = Soccer3::mMaterials[aIndex];
            aExpanders[aIndex] = Soccer3::mExpanders[aIndex];
            aWorkSpaces[aIndex] = Soccer3::mWorkSpaces[aIndex];
        }
        
        for (int aIndexA=1; aIndexA<16; aIndexA++) {
            for (int aIndexB=(aIndexA - 1); aIndexB>=0; aIndexB--) {
                if (aMaterials[aIndexA] == aMaterials[aIndexB]) {
                    XCTFail("test_MEW_strong_100: failed duplicate material.");
                    return;
                }
                if (aExpanders[aIndexA] == aExpanders[aIndexB]) {
                    XCTFail("test_MEW_strong_100: failed duplicate expander.");
                    return;
                }
                if (aWorkSpaces[aIndexA] == aWorkSpaces[aIndexB]) {
                    XCTFail("test_MEW_strong_100: failed duplicate work spaces.");
                    return;
                }
            }
            
        }
        
        aMaterialHashes.insert(ToString(aMaterials, 16));
        aExpanderHashes.insert(ToString(aExpanders, 16));
        aWorkSpaceHashes.insert(ToString(aWorkSpaces, 16));
    }
    
    if (aMaterialHashes.size() < 3) {
        XCTFail("test_MEW_strong_100: expected more unique material permutations.");
        return;
    }
    if (aExpanderHashes.size() < 3) {
        XCTFail("test_MEW_strong_100: expected more unique expander permutations.");
        return;
    }
    if (aWorkSpaceHashes.size() < 3) {
        XCTFail("test_MEW_strong_100: expected more unique work space permutations.");
        return;
    }
    
    printf("strong unique material permutations: %zu\n", aMaterialHashes.size());
    printf("strong unique expander permutations: %zu\n", aExpanderHashes.size());
    printf("strong unique work space permutations: %zu\n", aWorkSpaceHashes.size());
    
}

@end
