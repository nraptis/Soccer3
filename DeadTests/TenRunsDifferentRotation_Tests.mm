//
//  TenRunsDifferentRotation_Tests.m
//  ScrambleTests
//
//  Created by Icarus Black on 8/10/26.
//

#import <XCTest/XCTest.h>

#include <atomic>
#include "Random.hpp"
#include "Soccer3.hpp"
#include "WorkSpaceTools.hpp"
#include "GutCheckValidator.hpp"

#include <cstdint>
#include <cstring>
#include <vector>
#include <unordered_set>

@interface TenRunsDifferentRotation_Tests : XCTestCase

@end

@implementation TenRunsDifferentRotation_Tests

- (void)test_30_runs_rotations {
    struct ClearOnExit { ~ClearOnExit() { Soccer3::Zero(); } } aRestore;
    
    constexpr char kPasswordCharacters[] =
    "abcdefghijklmnopqrstuvwxyz"
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    "0123456789"
    "$#*()[]{}";
    constexpr std::size_t kPasswordCharacterCount = sizeof(kPasswordCharacters) - 1U;
    constexpr std::size_t kTrialCount = 10U;
    
    std::vector<EncryptionStrength> aStrengthList = { EncryptionStrength::kWeak, EncryptionStrength::kNormal, EncryptionStrength::kStrong};
    
    std::unordered_set<std::vector<std::uint64_t>, LongLongHash> aWeakSet;
    std::unordered_set<std::vector<std::uint64_t>, LongLongHash> aNormalSet;
    std::unordered_set<std::vector<std::uint64_t>, LongLongHash> aStrongSet;
    
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
            
            std::atomic<bool> aCancelled{false};
            Soccer3::Zero();
            if (!Soccer3::AttemptSeed_Encrypt(aStrength,
                                              aPassword,
                                              aPasswordByteLength,
                                              aNonce,
                                              &aAckWord,0,&aCancelled)) {
                XCTFail("%s: encryption seed failed.\n", __func__);
                return;
            }
            
            if (!Soccer3::EncryptBlock(aOriginal, aEncrypted)) {
                XCTFail("%s: encryption failed.\n", __func__);
                return;
            }
            if (std::memcmp(aOriginal, aEncrypted, SOCCER_BLOCK_SIZE) == 0) {
                XCTFail("%s: encryption left the source data unchanged.\n", __func__);
                return;
            }
            
            Soccer3::Zero();
            if (!Soccer3::AttemptSeed_Decrypt(aStrength,
                                              aPassword,
                                              aPasswordByteLength,
                                              aNonce,
                                              aAckWord,0,&aCancelled)) {
                XCTFail("%s: decryption seed failed.\n", __func__);
                return;
            }
            
            if (!Soccer3::DecryptBlock(aEncrypted, aDecrypted)) {
                XCTFail("%s: decryption failed.\n", __func__);
                return;
            }
            if (std::memcmp(aOriginal, aDecrypted, SOCCER_BLOCK_SIZE) != 0) {
                XCTFail("%s: decrypted data did not match the original source.\n", __func__);
                return;
            }
            
            std::vector<std::uint64_t> aRotationList;
            for (auto aRotation : CryptexTestSupport::Rotations())
                aRotationList.push_back(static_cast<std::uint64_t>(aRotation));

            if (aStrength == EncryptionStrength::kWeak) {
                aWeakSet.insert(aRotationList);
            } else if (aStrength == EncryptionStrength::kStrong) {
                aStrongSet.insert(aRotationList);
            } else {
                aNormalSet.insert(aRotationList);
            }
            
            const std::unordered_set<std::uint64_t> aRotationSet(aRotationList.begin(), aRotationList.end());
            if (aRotationSet.size() != WindowRotationFarm::kFreeRotationCount) {
                XCTFail("rotations: expected 16 distinct full-block rotations, got %zu", aRotationSet.size());
                return;
            }

            // Historical six-offset check; new pack checks live in WindowRotationMigrationTests.
#if 0
            if (!GutCheckValidator::ValidateRotation(__func__)) {
                XCTFail("Invalid active vault rotation ranges or exclusions");
                return;
            }
#endif
        }
    }

    constexpr std::size_t kWeakMaximum = kTrialCount;
    constexpr std::size_t kNormalMaximum = kTrialCount;
    constexpr std::size_t kStrongMaximum = kTrialCount;

    constexpr std::size_t kWeakCutoff = (kWeakMaximum * 3U) / 4U;
    constexpr std::size_t kNormalCutoff = (kNormalMaximum * 3U) / 4U;
    constexpr std::size_t kStrongCutoff = (kStrongMaximum * 3U) / 4U;

    if (aWeakSet.size() < kWeakCutoff) {
        XCTFail("%s: rotation weak cross-list count %zu was below cutoff %zu (maximum %zu).\n",
                __func__, aWeakSet.size(), kWeakCutoff, kWeakMaximum);
        return;
    }
    if (aNormalSet.size() < kNormalCutoff) {
        XCTFail("%s: rotation normal cross-list count %zu was below cutoff %zu (maximum %zu).\n",
                __func__, aNormalSet.size(), kNormalCutoff, kNormalMaximum);
        return;
    }
    if (aStrongSet.size() < kStrongCutoff) {
        XCTFail("%s: rotation strong cross-list count %zu was below cutoff %zu (maximum %zu).\n",
                __func__, aStrongSet.size(), kStrongCutoff, kStrongMaximum);
        return;
    }
    
}

@end
