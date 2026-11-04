//
//  ChangeNonceAckWordRejectionTests.m
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


@interface ChangeNonceAckWordRejectionTests : XCTestCase

@end

@implementation ChangeNonceAckWordRejectionTests

- (void)test_aw_reject_weak_100 {
    
    for (std::size_t aTrial=0; aTrial<16; aTrial++) {
        
        std::uint64_t aNonceA = Random::Get64();
        std::uint64_t aNonceB = aNonceA + 1;
        
        std::uint8_t aPassword[10];
        for (std::size_t aIndex=0; aIndex<10; aIndex++) {
            aPassword[aIndex] = Random::GetByte();
        }
        
        std::uint32_t aAckWord = 0xFF00FF00;
        std::atomic<bool> aCancelled{false};
        
        if (!Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kWeak, aPassword, 10, aNonceA, &aAckWord,0,&aCancelled)) {
            XCTFail("test_aw_reject_weak_100: failed seed encrypt.");
            return;
        }
        
        if (Soccer3::AttemptSeed_Decrypt(EncryptionStrength::kWeak, aPassword, 10, aNonceB, aAckWord,0,&aCancelled)) {
            XCTFail("test_aw_reject_weak_100: failed reject bad nonce.");
            return;
        }
        
        if (!Soccer3::AttemptSeed_Decrypt(EncryptionStrength::kWeak, aPassword, 10, aNonceA, aAckWord,0,&aCancelled)) {
            XCTFail("test_aw_reject_weak_100: failed accept good nonce.");
            return;
        }
    }

    printf("all nonce trials went fine (weak)\n");
    
}

- (void)test_aw_reject_normal_100 {
    
    for (std::size_t aTrial=0; aTrial<8; aTrial++) {
        
        std::uint64_t aNonceA = Random::Get64();
        std::uint64_t aNonceB = aNonceA + 1;
        
        std::uint8_t aPassword[10];
        for (std::size_t aIndex=0; aIndex<10; aIndex++) {
            aPassword[aIndex] = Random::GetByte();
        }
        
        std::uint32_t aAckWord = 0xFF00FF00;
        std::atomic<bool> aCancelled{false};
        
        if (!Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kNormal, aPassword, 10, aNonceA, &aAckWord,0,&aCancelled)) {
            XCTFail("test_aw_reject_normal_100: failed seed encrypt.");
            return;
        }
        
        if (Soccer3::AttemptSeed_Decrypt(EncryptionStrength::kNormal, aPassword, 10, aNonceB, aAckWord,0,&aCancelled)) {
            XCTFail("test_aw_reject_normal_100: failed reject bad nonce.");
            return;
        }
        
        if (!Soccer3::AttemptSeed_Decrypt(EncryptionStrength::kNormal, aPassword, 10, aNonceA, aAckWord,0,&aCancelled)) {
            XCTFail("test_aw_reject_normal_100: failed accept good nonce.");
            return;
        }
    }

    printf("all nonce trials went fine (normal)\n");
    
}

- (void)test_aw_reject_strong_100 {
    
    for (std::size_t aTrial=0; aTrial<6; aTrial++) {
        
        std::uint64_t aNonceA = Random::Get64();
        std::uint64_t aNonceB = aNonceA + 1;
        
        std::uint8_t aPassword[10];
        for (std::size_t aIndex=0; aIndex<10; aIndex++) {
            aPassword[aIndex] = Random::GetByte();
        }
        
        std::uint32_t aAckWord = 0xFF00FF00;
        std::atomic<bool> aCancelled{false};
        
        if (!Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kStrong, aPassword, 10, aNonceA, &aAckWord,0,&aCancelled)) {
            XCTFail("test_aw_reject_strong_100: failed seed encrypt.");
            return;
        }
        
        if (Soccer3::AttemptSeed_Decrypt(EncryptionStrength::kStrong, aPassword, 10, aNonceB, aAckWord,0,&aCancelled)) {
            XCTFail("test_aw_reject_strong_100: failed reject bad nonce.");
            return;
        }
        
        if (!Soccer3::AttemptSeed_Decrypt(EncryptionStrength::kStrong, aPassword, 10, aNonceA, aAckWord,0,&aCancelled)) {
            XCTFail("test_aw_reject_strong_100: failed accept good nonce.");
            return;
        }
    }
    
    printf("all nonce trials went fine (strong)\n");
    
}

@end
