//
//  LongEncryptionTests.m
//  ScrambleTests
//
//  Created by Icarus Black on 8/10/26.
//

#import <XCTest/XCTest.h>

#include "Random.hpp"
#include "Soccer3.hpp"
#include "WorkSpaceTools.hpp"
#include "GutCheckValidator.hpp"

#include <cstdint>
#include <cstring>
#include <vector>

@interface LongEncryptionTests : XCTestCase

@end

@implementation LongEncryptionTests

- (void)test_32 {

    constexpr char kPasswordCharacters[] =
        "abcdefghijklmnopqrstuvwxyz"
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        "0123456789"
        "$#*()[]{}";
    constexpr std::size_t kPasswordCharacterCount =
        sizeof(kPasswordCharacters) - 1U;

    std::uint8_t aPassword[32U];
    for (std::size_t aTrial=0; aTrial<8; aTrial++) {
        
        std::size_t aPasswordByteLength = Random::Get(7) + 1;
        for (std::size_t aIndex=0; aIndex<aPasswordByteLength; aIndex++) {
            const std::size_t aCharacterIndex = static_cast<std::size_t>(
                Random::Get(static_cast<int>(kPasswordCharacterCount)));
            aPassword[aIndex] = static_cast<std::uint8_t>(
                kPasswordCharacters[aCharacterIndex]);
        }
        
        std::uint64_t aNonce = Random::Get64();
        
        if (!GutCheckValidator::Validate(__func__,
                                         EncryptionStrength::kWeak,
                                         aPassword,
                                         aPasswordByteLength,
                                         aNonce)) {
            XCTFail("LongEncryptionTests: (kWeak) failed gut check, died.");
            return;
        }
        
        printf("Trial[%zu], Strength {Weak}, Password {%.*s}, Nonce {0x%016llX}, Passed!!!\n",
               aTrial,
               static_cast<int>(aPasswordByteLength),
               reinterpret_cast<const char *>(aPassword),
               static_cast<unsigned long long>(aNonce));
        
        if (!GutCheckValidator::Validate(__func__,
                                         EncryptionStrength::kNormal,
                                         aPassword,
                                         aPasswordByteLength,
                                         aNonce)) {
            XCTFail("LongEncryptionTests: (kNormal) failed gut check, died.");
            return;
        }
        
        printf("Trial[%zu], Strength {Normal}, Password {%.*s}, Nonce {0x%016llX}, Passed!!!\n",
               aTrial,
               static_cast<int>(aPasswordByteLength),
               reinterpret_cast<const char *>(aPassword),
               static_cast<unsigned long long>(aNonce));
        
        if (!GutCheckValidator::Validate(__func__,
                                         EncryptionStrength::kStrong,
                                         aPassword,
                                         aPasswordByteLength,
                                         aNonce)) {
            XCTFail("LongEncryptionTests: (kStrong) failed gut check, died.");
            return;
        }
        
        printf("Trial[%zu], Strength {Strong}, Password {%.*s}, Nonce {0x%016llX}, Passed!!!\n",
               aTrial,
               static_cast<int>(aPasswordByteLength),
               reinterpret_cast<const char *>(aPassword),
               static_cast<unsigned long long>(aNonce));
    }
}

@end
