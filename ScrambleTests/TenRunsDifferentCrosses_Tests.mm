//
//  TenRunsDifferentCrosses_Tests.m
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

@interface TenRunsDifferentCrosses_Tests : XCTestCase

@end

@implementation TenRunsDifferentCrosses_Tests



- (void)test_30_runs_crosses {
    
    constexpr char kPasswordCharacters[] =
    "abcdefghijklmnopqrstuvwxyz"
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    "0123456789"
    "$#*()[]{}";
    constexpr std::size_t kPasswordCharacterCount = sizeof(kPasswordCharacters) - 1U;
    constexpr std::size_t kTrialCount = 10U;
    
    std::vector<EncryptionStrength> aStrengthList = { EncryptionStrength::kWeak, EncryptionStrength::kNormal, EncryptionStrength::kStrong};
    
    std::unordered_set<std::vector<std::uint8_t *>, BytePointerListHash> aWeakSet;
    std::unordered_set<std::vector<std::uint8_t *>, BytePointerListHash> aNormalSet;
    std::unordered_set<std::vector<std::uint8_t *>, BytePointerListHash> aStrongSet;
    
    std::unordered_set<std::vector<std::uint8_t *>, BytePointerListHash> aPoolWeakSet;
    std::unordered_set<std::vector<std::uint8_t *>, BytePointerListHash> aPoolNormalSet;
    std::unordered_set<std::vector<std::uint8_t *>, BytePointerListHash> aPoolStrongSet;
    
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
            
            std::size_t aComplexity = 8;
            if (aStrength == EncryptionStrength::kWeak) {
                aComplexity = 4;
            } else if (aStrength == EncryptionStrength::kStrong) {
                aComplexity = 16;
            }
            
            // Chosen Cross Lanes
            for (std::size_t aLaneIndex=0; aLaneIndex<aComplexity; aLaneIndex++) {
                std::vector<std::uint8_t *> aCrossList;
                aCrossList.push_back(Soccer3::mCross[0][aLaneIndex]);
                aCrossList.push_back(Soccer3::mCross[1][aLaneIndex]);
                aCrossList.push_back(Soccer3::mCross[2][aLaneIndex]);
                aCrossList.push_back(Soccer3::mCross[3][aLaneIndex]);
                
                if (aStrength == EncryptionStrength::kWeak) {
                    aWeakSet.insert(aCrossList);
                } else if (aStrength == EncryptionStrength::kStrong) {
                    aStrongSet.insert(aCrossList);
                } else {
                    aNormalSet.insert(aCrossList);
                }
            }
            
            printf("CrossList Counts [%zu %zu %zu]\n", aWeakSet.size(), aNormalSet.size(), aStrongSet.size());
            
            // Pool Cross Lanes
            for (std::size_t aLaneIndex=0U; aLaneIndex<aComplexity; aLaneIndex++) {
                std::vector<std::uint8_t *> aPoolCrossList;
                const std::size_t aPoolCount = Soccer3::mCrossPoolCount[aLaneIndex];
                aPoolCrossList.reserve(aPoolCount);
                for (std::size_t aPoolIndex=0U; aPoolIndex<aPoolCount; aPoolIndex++) {
                    aPoolCrossList.push_back(Soccer3::mCrossPool[aLaneIndex][aPoolIndex]);
                }

                if (aStrength == EncryptionStrength::kWeak) {
                    aPoolWeakSet.insert(aPoolCrossList);
                } else if (aStrength == EncryptionStrength::kStrong) {
                    aPoolStrongSet.insert(aPoolCrossList);
                } else {
                    aPoolNormalSet.insert(aPoolCrossList);
                }
            }

            printf("PoolCrossList Counts [%zu %zu %zu]\n",
                   aPoolWeakSet.size(),
                   aPoolNormalSet.size(),
                   aPoolStrongSet.size());
        }
    }

    constexpr std::size_t kWeakMaximum = kTrialCount * 4U;
    constexpr std::size_t kNormalMaximum = kTrialCount * 8U;
    constexpr std::size_t kStrongMaximum = kTrialCount * 16U;

    constexpr std::size_t kWeakCutoff = (kWeakMaximum * 3U) / 4U;
    constexpr std::size_t kNormalCutoff = (kNormalMaximum * 3U) / 4U;
    constexpr std::size_t kStrongCutoff = (kStrongMaximum * 3U) / 4U;

    if (aWeakSet.size() < kWeakCutoff) {
        XCTFail("%s: weak cross-list count %zu was below cutoff %zu (maximum %zu).\n",
                __func__, aWeakSet.size(), kWeakCutoff, kWeakMaximum);
        return;
    }
    if (aNormalSet.size() < kNormalCutoff) {
        XCTFail("%s: normal cross-list count %zu was below cutoff %zu (maximum %zu).\n",
                __func__, aNormalSet.size(), kNormalCutoff, kNormalMaximum);
        return;
    }
    if (aStrongSet.size() < kStrongCutoff) {
        XCTFail("%s: strong cross-list count %zu was below cutoff %zu (maximum %zu).\n",
                __func__, aStrongSet.size(), kStrongCutoff, kStrongMaximum);
        return;
    }

    if (aPoolWeakSet.size() < kWeakCutoff) {
        XCTFail("%s: weak pool-list count %zu was below cutoff %zu (maximum %zu).\n",
                __func__, aPoolWeakSet.size(), kWeakCutoff, kWeakMaximum);
        return;
    }
    if (aPoolNormalSet.size() < kNormalCutoff) {
        XCTFail("%s: normal pool-list count %zu was below cutoff %zu (maximum %zu).\n",
                __func__, aPoolNormalSet.size(), kNormalCutoff, kNormalMaximum);
        return;
    }
    if (aPoolStrongSet.size() < kStrongCutoff) {
        XCTFail("%s: strong pool-list count %zu was below cutoff %zu (maximum %zu).\n",
                __func__, aPoolStrongSet.size(), kStrongCutoff, kStrongMaximum);
        return;
    }
}

@end
