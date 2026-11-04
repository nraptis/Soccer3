//
//  TenRunsDifferentMask_Tests.m
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
#include <array>
#include <cstring>
#include <vector>
#include <unordered_set>

@interface TenRunsDifferentMask_Tests : XCTestCase

@end

@implementation TenRunsDifferentMask_Tests

// The active row grid is deliberately fixed across passwords for now.
// This checks the vault masks, not the unused randomized legacy mask bank.
- (void)test_30_runs_masks {
    struct ClearOnExit { ~ClearOnExit() { Soccer2::Zero(); } } aRestore;
    
    constexpr char kPasswordCharacters[] =
    "abcdefghijklmnopqrstuvwxyz"
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    "0123456789"
    "$#*()[]{}";
    constexpr std::size_t kPasswordCharacterCount = sizeof(kPasswordCharacters) - 1U;
    constexpr std::size_t kTrialCount = 10U;
    
    std::vector<EncryptionStrength> aStrengthList = { EncryptionStrength::kWeak, EncryptionStrength::kNormal, EncryptionStrength::kStrong};
    
    std::unordered_set<std::vector<std::uint8_t>, ByteListHash> aWeakSet;
    std::unordered_set<std::vector<std::uint8_t>, ByteListHash> aNormalSet;
    std::unordered_set<std::vector<std::uint8_t>, ByteListHash> aStrongSet;
    
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
            
            if (!GutCheckValidator::ValidateMask(__func__)) {
                XCTFail("Invalid active vault masks");
                return;
            }
            std::vector<std::uint8_t> aMaskList;
            for (const auto &aLayer : Soccer2::mEncryptionVaultPlan.mLayers)
                for (auto aMask : aLayer.mMasks) aMaskList.push_back(aMask);

            if (aStrength == EncryptionStrength::kWeak) {
                aWeakSet.insert(aMaskList);
            } else if (aStrength == EncryptionStrength::kStrong) {
                aStrongSet.insert(aMaskList);
            } else {
                aNormalSet.insert(aMaskList);
            }
        }
    }

    XCTAssertEqual(aWeakSet.size(), std::size_t{1U}, @"Weak's fixed row selection unexpectedly changed");
    XCTAssertEqual(aNormalSet.size(), std::size_t{1U}, @"Normal's fixed row selection unexpectedly changed");
    XCTAssertEqual(aStrongSet.size(), std::size_t{1U}, @"Strong's fixed row selection unexpectedly changed");
    XCTAssertTrue(aWeakSet == aNormalSet && aNormalSet == aStrongSet);

}

@end
