//
//  RepeatRandomTests.m
//  ScrambleTests
//
//  Created by Icarus Black on 8/15/26.
//

#import <XCTest/XCTest.h>

#include <atomic>
#include "Random.hpp"
#include "../Scramble/Composer/Soccer3.hpp"
#include "../ScrambleTests/WorkSpaceTools.hpp"

#include <cstdint>
#include <cstring>
#include <vector>
#include <unordered_set>

@interface RepeatRandomTests : XCTestCase

@end

@implementation RepeatRandomTests

- (void)test_repeatRandom {
    
    constexpr char kPasswordCharacters[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    constexpr std::size_t kPasswordCharacterCount = sizeof(kPasswordCharacters) - 1U;
    constexpr std::size_t kTrialCount = 10U;
    
    std::vector<EncryptionStrength> aStrengthList = { EncryptionStrength::kWeak, EncryptionStrength::kNormal, EncryptionStrength::kStrong};
    
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
            static std::uint8_t aEncryptedA[SOCCER_BLOCK_SIZE];
            static std::uint8_t aEncryptedB[SOCCER_BLOCK_SIZE];
            static std::uint8_t aDecryptedA[SOCCER_BLOCK_SIZE];
            static std::uint8_t aDecryptedB[SOCCER_BLOCK_SIZE];
            
            WorkSpaceTools::FillBytes(aOriginal, SOCCER_BLOCK_SIZE);
            
            std::uint32_t aAckWord = 0U;
            
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceA);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceB);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceC);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceD);
            
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceE);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceF);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceG);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceH);
            
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceI);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceJ);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceK);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceL);
            
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceM);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceN);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceO);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceP);
            
            std::atomic<bool> aCancelled{false};
            if (!Soccer3::AttemptSeed_Encrypt(aStrength,
                                              aPassword,
                                              aPasswordByteLength,
                                              aNonce,
                                              &aAckWord,0,&aCancelled)) {
                XCTFail("%s: encryption seed failed.\n", __func__);
                return;
            }
            
            if (!Soccer3::EncryptBlock(aOriginal, aEncryptedA)) {
                XCTFail("%s: encryption failed.\n", __func__);
                return;
            }
            if (std::memcmp(aOriginal, aEncryptedA, SOCCER_BLOCK_SIZE) == 0) {
                XCTFail("%s: encryption left the source data unchanged.\n", __func__);
                return;
            }
            
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceA);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceB);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceC);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceD);
            
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceE);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceF);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceG);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceH);
            
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceI);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceJ);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceK);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceL);
            
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceM);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceN);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceO);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceP);
            
            if (!Soccer3::AttemptSeed_Decrypt(aStrength,
                                              aPassword,
                                              aPasswordByteLength,
                                              aNonce,
                                              aAckWord,0,&aCancelled)) {
                XCTFail("%s: decryption seed failed.\n", __func__);
                return;
            }
            
            if (!Soccer3::DecryptBlock(aEncryptedA, aDecryptedA)) {
                XCTFail("%s: decryption failed.\n", __func__);
                return;
            }
            if (std::memcmp(aOriginal, aDecryptedA, SOCCER_BLOCK_SIZE) != 0) {
                XCTFail("%s: decrypted data did not match the original source.\n", __func__);
                return;
            }
            
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceA);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceB);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceC);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceD);
            
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceE);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceF);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceG);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceH);
            
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceI);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceJ);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceK);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceL);
            
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceM);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceN);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceO);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceP);
            
            if (!Soccer3::AttemptSeed_Encrypt(aStrength,
                                              aPassword,
                                              aPasswordByteLength,
                                              aNonce,
                                              &aAckWord,0,&aCancelled)) {
                XCTFail("%s: encryption seed failed.\n", __func__);
                return;
            }
            
            if (!Soccer3::EncryptBlock(aOriginal, aEncryptedB)) {
                XCTFail("%s: encryption failed.\n", __func__);
                return;
            }
            if (std::memcmp(aOriginal, aEncryptedB, SOCCER_BLOCK_SIZE) == 0) {
                XCTFail("%s: encryption left the source data unchanged.\n", __func__);
                return;
            }
            
            if (std::memcmp(aEncryptedA, aEncryptedB, SOCCER_BLOCK_SIZE) != 0) {
                XCTFail("%s: encrypted first pass did not match sedond.\n", __func__);
                return;
            }
            
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceA);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceB);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceC);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceD);
            
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceE);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceF);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceG);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceH);
            
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceI);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceJ);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceK);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceL);
            
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceM);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceN);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceO);
            WorkSpaceTools::FillWorkSpace(&Soccer3::mWorkSpaceP);
            
            if (!Soccer3::AttemptSeed_Decrypt(aStrength,
                                              aPassword,
                                              aPasswordByteLength,
                                              aNonce,
                                              aAckWord,0,&aCancelled)) {
                XCTFail("%s: decryption seed failed.\n", __func__);
                return;
            }
            
            if (!Soccer3::DecryptBlock(aEncryptedB, aDecryptedB)) {
                XCTFail("%s: decryption failed.\n", __func__);
                return;
            }
            
            if (std::memcmp(aOriginal, aDecryptedB, SOCCER_BLOCK_SIZE) != 0) {
                XCTFail("%s: decrypted data did not match the original source.\n", __func__);
                return;
            }
            
        }
    }
}

@end
