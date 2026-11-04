//
//  ChangePasswordAckWordRejectionTests.m
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


@interface ChangePasswordAckWordRejectionTests : XCTestCase

@end

@implementation ChangePasswordAckWordRejectionTests

- (void)test_pw_reject_weak_100 {
    
    for (std::size_t aTrial=0; aTrial<16; aTrial++) {
        
        std::uint64_t aNonce = Random::Get64();
        
        std::uint8_t aPasswordA[10];
        std::uint8_t aPasswordB[10];
        for (std::size_t aIndex=0; aIndex<10; aIndex++) {
            aPasswordA[aIndex] = Random::GetByte();
        }
        for (std::size_t aIndex=0; aIndex<10; aIndex++) {
            aPasswordB[aIndex] = aPasswordA[aIndex];
        }
        aPasswordB[5] += 1;
        
        std::uint32_t aAckWord = 0xFF00FF00;
        
        std::atomic<bool> aCancelled{false};
        if (!Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kWeak, aPasswordA, 10, aNonce, &aAckWord,0,&aCancelled)) {
            XCTFail("test_pw_reject_weak_100: failed seed encrypt.");
            return;
        }
        
        if (Soccer3::AttemptSeed_Decrypt(EncryptionStrength::kWeak, aPasswordB, 10, aNonce, aAckWord,0,&aCancelled)) {
            XCTFail("test_pw_reject_weak_100: failed reject bad password.");
            return;
        }
        
        if (!Soccer3::AttemptSeed_Decrypt(EncryptionStrength::kWeak, aPasswordA, 10, aNonce, aAckWord,0,&aCancelled)) {
            XCTFail("test_pw_reject_weak_100: failed accept good password.");
            return;
        }
    }

    printf("all nonce trials went fine (weak)\n");
    
}

- (void)test_pw_reject_normal_100 {
    
    for (std::size_t aTrial=0; aTrial<8; aTrial++) {
        
        std::uint64_t aNonce = Random::Get64();
        
        std::uint8_t aPasswordA[10];
        std::uint8_t aPasswordB[10];
        for (std::size_t aIndex=0; aIndex<10; aIndex++) {
            aPasswordA[aIndex] = Random::GetByte();
        }
        for (std::size_t aIndex=0; aIndex<10; aIndex++) {
            aPasswordB[aIndex] = aPasswordA[aIndex];
        }
        aPasswordB[5] += 1;
        
        std::uint32_t aAckWord = 0xFF00FF00;
        
        std::atomic<bool> aCancelled{false};
        if (!Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kNormal, aPasswordA, 10, aNonce, &aAckWord,0,&aCancelled)) {
            XCTFail("test_pw_reject_normal_100: failed seed encrypt.");
            return;
        }
        
        if (Soccer3::AttemptSeed_Decrypt(EncryptionStrength::kNormal, aPasswordB, 10, aNonce, aAckWord,0,&aCancelled)) {
            XCTFail("test_pw_reject_normal_100: failed reject bad nonce.");
            return;
        }
        
        if (!Soccer3::AttemptSeed_Decrypt(EncryptionStrength::kNormal, aPasswordA, 10, aNonce, aAckWord,0,&aCancelled)) {
            XCTFail("test_pw_reject_normal_100: failed accept good nonce.");
            return;
        }
        
    }

    printf("all nonce trials went fine (normal)\n");
    
}

- (void)test_pw_reject_strong_100 {
    
    for (std::size_t aTrial=0; aTrial<6; aTrial++) {
        
        
        std::uint64_t aNonce = Random::Get64();
        
        std::uint8_t aPasswordA[10];
        std::uint8_t aPasswordB[10];
        for (std::size_t aIndex=0; aIndex<10; aIndex++) {
            aPasswordA[aIndex] = Random::GetByte();
        }
        for (std::size_t aIndex=0; aIndex<10; aIndex++) {
            aPasswordB[aIndex] = aPasswordA[aIndex];
        }
        aPasswordB[5] += 1;
        
        std::uint32_t aAckWord = 0xFF00FF00;
        
        std::atomic<bool> aCancelled{false};
        if (!Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kStrong, aPasswordA, 10, aNonce, &aAckWord,0,&aCancelled)) {
            XCTFail("test_pw_reject_strong_100: failed seed encrypt.");
            return;
        }
        
        if (Soccer3::AttemptSeed_Decrypt(EncryptionStrength::kStrong, aPasswordB, 10, aNonce, aAckWord,0,&aCancelled)) {
            XCTFail("test_pw_reject_strong_100: failed reject bad nonce.");
            return;
        }
        
        if (!Soccer3::AttemptSeed_Decrypt(EncryptionStrength::kStrong, aPasswordA, 10, aNonce, aAckWord,0,&aCancelled)) {
            XCTFail("test_pw_reject_strong_100: failed accept good nonce.");
            return;
        }
        
    }

    printf("all nonce trials went fine (strong)\n");
    
}

@end
