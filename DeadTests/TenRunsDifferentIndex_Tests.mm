// Retired with FlameToad: historical Cryptex / premium-seed plumbing. Source retained.
#if 0
//
//  TenRunsDifferentIndex_Tests.m
//  ScrambleTests
//
//  Created by Icarus Black on 8/10/26.
//

#import <XCTest/XCTest.h>

#include <atomic>
#include "Random.hpp"
#include "Soccer2.hpp"
#include "WorkSpaceTools.hpp"
#include "GutCheckValidator.hpp"

#include <cstdint>
#include <cstring>
#include <vector>
#include <unordered_set>

@interface TenRunsDifferentIndex_Tests : XCTestCase

@end

@implementation TenRunsDifferentIndex_Tests

- (void)test_30_runs_rotations {
    
    constexpr char kPasswordCharacters[] =
    "abcdefghijklmnopqrstuvwxyz"
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    "0123456789"
    "$#*()[]{}";
    constexpr std::size_t kPasswordCharacterCount = sizeof(kPasswordCharacters) - 1U;
    constexpr std::size_t kTrialCount = 10U;
    
    std::vector<EncryptionStrength> aStrengthList = { EncryptionStrength::kWeak, EncryptionStrength::kNormal, EncryptionStrength::kStrong};
    
    std::unordered_set<std::vector<std::size_t>, SizeHash> aWeakSet;
    std::unordered_set<std::vector<std::size_t>, SizeHash> aNormalSet;
    std::unordered_set<std::vector<std::size_t>, SizeHash> aStrongSet;
    
    for (std::size_t aTrial=0U; aTrial<kTrialCount; aTrial++) {
        std::uint8_t aPassword[32U];
        std::size_t aPasswordByteLength = 1 + Random::Get(4);
        for (std::size_t aIndex=0; aIndex<aPasswordByteLength; aIndex++) {
            const std::size_t aCharacterIndex = static_cast<std::size_t>(Random::Get(static_cast<int>(kPasswordCharacterCount)));
            aPassword[aIndex] = static_cast<std::uint8_t>(kPasswordCharacters[aCharacterIndex]);
        }
        std::uint64_t aNonce = Random::Get64();
        
        for (auto &aStrength : aStrengthList) {
            
            printf("Trial[%zu], Strength {%d}, Password {%.*s}, Nonce {0x%016llX}, Passed!!!\n",
                   aTrial,
                   (int)aStrength,
                   static_cast<int>(aPasswordByteLength),
                   reinterpret_cast<const char *>(aPassword),
                   static_cast<unsigned long long>(aNonce));
            
            static std::uint8_t aOriginal[SOCCER_BLOCK_SIZE];
            static std::uint8_t aEncrypted[SOCCER_BLOCK_SIZE];
            static std::uint8_t aDecrypted[SOCCER_BLOCK_SIZE];
            
            WorkSpaceTools::FillBytes(aOriginal, SOCCER_BLOCK_SIZE);
            
            std::uint32_t aAckWord = 0U;
            
            Soccer2::Zero();
            
            std::atomic<bool> aCancelled{false};
            if (!Soccer2::AttemptSeed_Encrypt(aStrength,
                                              aPassword,
                                              aPasswordByteLength,
                                              aNonce,
                                              &aAckWord,0,&aCancelled)) {
                XCTFail("%s: encryption seed failed.\n", __func__);
                return;
            }
            
            if (!Soccer2::EncryptBlock(aOriginal, aEncrypted)) {
                XCTFail("%s: encryption failed.\n", __func__);
                return;
            }
            if (std::memcmp(aOriginal, aEncrypted, SOCCER_BLOCK_SIZE) == 0) {
                XCTFail("%s: encryption left the source data unchanged.\n", __func__);
                return;
            }
            
            Soccer2::Zero();
            if (!Soccer2::AttemptSeed_Decrypt(aStrength,
                                              aPassword,
                                              aPasswordByteLength,
                                              aNonce,
                                              aAckWord,0,&aCancelled)) {
                XCTFail("%s: decryption seed failed.\n", __func__);
                return;
            }
            
            if (!Soccer2::DecryptBlock(aEncrypted, aDecrypted)) {
                XCTFail("%s: decryption failed.\n", __func__);
                return;
            }
            if (std::memcmp(aOriginal, aDecrypted, SOCCER_BLOCK_SIZE) != 0) {
                XCTFail("%s: decrypted data did not match the original source.\n", __func__);
                return;
            }
            
            std::vector<std::size_t> aIndexListA;
            std::vector<std::size_t> aIndexListB;
            for (std::size_t aIndex=0; aIndex<Soccer2::kSeedIndexCount; aIndex++) {
                aIndexListA.push_back(Soccer2::mIndexListA[aIndex]);
                aIndexListB.push_back(Soccer2::mIndexListB[aIndex]);
            }
            
            if (aStrength == EncryptionStrength::kWeak) {
                aWeakSet.insert(aIndexListA);
                aWeakSet.insert(aIndexListB);
            } else if (aStrength == EncryptionStrength::kStrong) {
                aStrongSet.insert(aIndexListA);
                aStrongSet.insert(aIndexListB);
            } else {
                aNormalSet.insert(aIndexListA);
                aNormalSet.insert(aIndexListB);
            }
            
            std::unordered_set<std::uint64_t> aIndexSetA;
            std::unordered_set<std::uint64_t> aIndexSetB;
            for (std::size_t aIndex=0; aIndex<Soccer2::kSeedIndexCount; aIndex++) {
                aIndexSetA.insert(Soccer2::mIndexListA[aIndex]);
                aIndexSetB.insert(Soccer2::mIndexListB[aIndex]);
            }
            
            for (std::size_t aIndex=0; aIndex<Soccer2::kSeedIndexCount; aIndex++) {
                if (aIndexSetA.contains(aIndex) == false) {
                    XCTFail("indices: expected the complete seed index range and missed %zu", aIndex);
                    return;
                }
                if (aIndexSetB.contains(aIndex) == false) {
                    XCTFail("indices: expected the complete seed index range and missed %zu", aIndex);
                    return;
                }
            }
        }
    }

    constexpr std::size_t kWeakMaximum = kTrialCount + kTrialCount;
    constexpr std::size_t kNormalMaximum = kTrialCount + kTrialCount;
    constexpr std::size_t kStrongMaximum = kTrialCount + kTrialCount;

    constexpr std::size_t kWeakCutoff = (kWeakMaximum * 3U) / 4U;
    constexpr std::size_t kNormalCutoff = (kNormalMaximum * 3U) / 4U;
    constexpr std::size_t kStrongCutoff = (kStrongMaximum * 3U) / 4U;

    if (aWeakSet.size() < kWeakCutoff) {
        XCTFail("%s: index weak cross-list count %zu was below cutoff %zu (maximum %zu).\n",
                __func__, aWeakSet.size(), kWeakCutoff, kWeakMaximum);
        return;
    }
    if (aNormalSet.size() < kNormalCutoff) {
        XCTFail("%s: index normal cross-list count %zu was below cutoff %zu (maximum %zu).\n",
                __func__, aNormalSet.size(), kNormalCutoff, kNormalMaximum);
        return;
    }
    if (aStrongSet.size() < kStrongCutoff) {
        XCTFail("%s: index strong cross-list count %zu was below cutoff %zu (maximum %zu).\n",
                __func__, aStrongSet.size(), kStrongCutoff, kStrongMaximum);
        return;
    }
    
}

@end

#endif
#import <XCTest/XCTest.h>
@interface TenRunsDifferentIndex_Tests : XCTestCase
@end
@implementation TenRunsDifferentIndex_Tests
- (void)testRetiredConstruction { XCTSkip(@"Historical Cryptex / premium-seed test; replaced by FlameToad vault checks."); }
@end
