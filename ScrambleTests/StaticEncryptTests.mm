//
//  StaticEncryptTests.m
//  ScrambleTests
//
//  Created by Icarus Black on 8/9/26.
//

#import <XCTest/XCTest.h>

#include "Random.hpp"
#include "Soccer3.hpp"
#include "WorkSpaceTools.hpp"
#include "GutCheckValidator.hpp"

#include <cstdint>
#include <cstring>
#include <vector>

@interface StaticEncryptTests : XCTestCase

@end

@implementation StaticEncryptTests

- (void)test_encryptDecryptWeakA {
    
    std::uint8_t aPassword[32U];
    aPassword[0] = 'S';
    aPassword[1] = 'o';
    aPassword[2] = 'c';
    aPassword[3] = 'c';
    aPassword[4] = 'e';
    aPassword[5] = 'r';
    aPassword[6] = 'A';
    constexpr std::size_t aPasswordByteLength = 7U;
    constexpr std::uint64_t aNonce = 1;
    
    if (!GutCheckValidator::Validate(__func__,
                                     EncryptionStrength::kWeak,
                                     aPassword,
                                     aPasswordByteLength, aNonce)) {
        XCTFail("test_encryptDecryptWeakA: failed gut check, died.");
        return;
    }
}

- (void)test_encryptDecryptWeakB {
    
    std::uint8_t aPassword[32U];
    aPassword[0] = 'S';
    aPassword[1] = 'o';
    aPassword[2] = 'c';
    aPassword[3] = 'c';
    aPassword[4] = 'e';
    aPassword[5] = 'r';
    aPassword[6] = 'B';
    constexpr std::size_t aPasswordByteLength = 7U;
    constexpr std::uint64_t aNonce = 1;
    
    if (!GutCheckValidator::Validate(__func__,
                                     EncryptionStrength::kWeak,
                                     aPassword,
                                     aPasswordByteLength, aNonce)) {
        XCTFail("test_encryptDecryptWeakB: failed gut check, died.");
        return;
    }
}

- (void)test_encryptDecryptWeakC {
    
    std::uint8_t aPassword[32U];
    aPassword[0] = 'S';
    aPassword[1] = 'o';
    aPassword[2] = 'c';
    aPassword[3] = 'c';
    aPassword[4] = 'e';
    aPassword[5] = 'r';
    aPassword[6] = 'C';
    constexpr std::size_t aPasswordByteLength = 7U;
    constexpr std::uint64_t aNonce = 1;
    
    if (!GutCheckValidator::Validate(__func__,
                                     EncryptionStrength::kWeak,
                                     aPassword,
                                     aPasswordByteLength, aNonce)) {
        XCTFail("test_encryptDecryptWeakC: failed gut check, died.");
        return;
    }
}

- (void)test_encryptDecryptWeakD {
    
    std::uint8_t aPassword[32U];
    aPassword[0] = 'S';
    aPassword[1] = 'o';
    aPassword[2] = 'c';
    aPassword[3] = 'c';
    aPassword[4] = 'e';
    aPassword[5] = 'r';
    aPassword[6] = 'C';
    constexpr std::size_t aPasswordByteLength = 7U;
    constexpr std::uint64_t aNonce = 1;
    
    if (!GutCheckValidator::Validate(__func__,
                                     EncryptionStrength::kWeak,
                                     aPassword,
                                     aPasswordByteLength, aNonce)) {
        XCTFail("test_encryptDecryptWeakD: failed gut check, died.");
        return;
    }
}


- (void)test_encryptDecryptWeakE {
    
    std::uint8_t aPassword[32U];
    aPassword[0] = 'S';
    aPassword[1] = 'o';
    aPassword[2] = 'c';
    aPassword[3] = 'c';
    aPassword[4] = 'e';
    aPassword[5] = 'r';
    aPassword[6] = 'A';
    constexpr std::size_t aPasswordByteLength = 7U;
    constexpr std::uint64_t aNonce = 2;
    
    if (!GutCheckValidator::Validate(__func__,
                                     EncryptionStrength::kWeak,
                                     aPassword,
                                     aPasswordByteLength, aNonce)) {
        XCTFail("test_encryptDecryptWeakA: failed gut check, died.");
        return;
    }
}

- (void)test_encryptDecryptWeakF {
    
    std::uint8_t aPassword[32U];
    aPassword[0] = 'S';
    aPassword[1] = 'o';
    aPassword[2] = 'c';
    aPassword[3] = 'c';
    aPassword[4] = 'e';
    aPassword[5] = 'r';
    aPassword[6] = 'B';
    constexpr std::size_t aPasswordByteLength = 7U;
    constexpr std::uint64_t aNonce = 2;
    
    if (!GutCheckValidator::Validate(__func__,
                                     EncryptionStrength::kWeak,
                                     aPassword,
                                     aPasswordByteLength, aNonce)) {
        XCTFail("test_encryptDecryptWeakB: failed gut check, died.");
        return;
    }
}

- (void)test_encryptDecryptWeakG {
    
    std::uint8_t aPassword[32U];
    aPassword[0] = 'S';
    aPassword[1] = 'o';
    aPassword[2] = 'c';
    aPassword[3] = 'c';
    aPassword[4] = 'e';
    aPassword[5] = 'r';
    aPassword[6] = 'C';
    constexpr std::size_t aPasswordByteLength = 7U;
    constexpr std::uint64_t aNonce = 2;
    
    if (!GutCheckValidator::Validate(__func__,
                                     EncryptionStrength::kWeak,
                                     aPassword,
                                     aPasswordByteLength, aNonce)) {
        XCTFail("test_encryptDecryptWeakC: failed gut check, died.");
        return;
    }
}

- (void)test_encryptDecryptWeakH {
    
    std::uint8_t aPassword[32U];
    aPassword[0] = 'S';
    aPassword[1] = 'o';
    aPassword[2] = 'c';
    aPassword[3] = 'c';
    aPassword[4] = 'e';
    aPassword[5] = 'r';
    aPassword[6] = 'C';
    constexpr std::size_t aPasswordByteLength = 7U;
    constexpr std::uint64_t aNonce = 2;
    
    if (!GutCheckValidator::Validate(__func__,
                                     EncryptionStrength::kWeak,
                                     aPassword,
                                     aPasswordByteLength, aNonce)) {
        XCTFail("test_encryptDecryptWeakD: failed gut check, died.");
        return;
    }
}

- (void)test_encryptDecryptNormalA {
    
    std::uint8_t aPassword[32U];
    aPassword[0] = 'S';
    aPassword[1] = 'o';
    aPassword[2] = 'c';
    aPassword[3] = 'c';
    aPassword[4] = 'e';
    aPassword[5] = 'r';
    aPassword[6] = 'A';
    constexpr std::size_t aPasswordByteLength = 7U;
    constexpr std::uint64_t aNonce = 1;
    
    if (!GutCheckValidator::Validate(__func__,
                                     EncryptionStrength::kNormal,
                                     aPassword,
                                     aPasswordByteLength, aNonce)) {
        XCTFail("test_encryptDecryptNormalA: failed gut check, died.");
        return;
    }
}

- (void)test_encryptDecryptNormalB {
    
    std::uint8_t aPassword[32U];
    aPassword[0] = 'S';
    aPassword[1] = 'o';
    aPassword[2] = 'c';
    aPassword[3] = 'c';
    aPassword[4] = 'e';
    aPassword[5] = 'r';
    aPassword[6] = 'B';
    constexpr std::size_t aPasswordByteLength = 7U;
    constexpr std::uint64_t aNonce = 1;
    
    if (!GutCheckValidator::Validate(__func__,
                                     EncryptionStrength::kNormal,
                                     aPassword,
                                     aPasswordByteLength, aNonce)) {
        XCTFail("test_encryptDecryptNormalB: failed gut check, died.");
        return;
    }
}

- (void)test_encryptDecryptNormalC {
    
    std::uint8_t aPassword[32U];
    aPassword[0] = 'S';
    aPassword[1] = 'o';
    aPassword[2] = 'c';
    aPassword[3] = 'c';
    aPassword[4] = 'e';
    aPassword[5] = 'r';
    aPassword[6] = 'C';
    constexpr std::size_t aPasswordByteLength = 7U;
    constexpr std::uint64_t aNonce = 1;
    
    if (!GutCheckValidator::Validate(__func__,
                                     EncryptionStrength::kNormal,
                                     aPassword,
                                     aPasswordByteLength, aNonce)) {
        XCTFail("test_encryptDecryptNormalC: failed gut check, died.");
        return;
    }
}

- (void)test_encryptDecryptNormalE {
    
    std::uint8_t aPassword[32U];
    aPassword[0] = 'S';
    aPassword[1] = 'o';
    aPassword[2] = 'c';
    aPassword[3] = 'c';
    aPassword[4] = 'e';
    aPassword[5] = 'r';
    aPassword[6] = 'A';
    constexpr std::size_t aPasswordByteLength = 7U;
    constexpr std::uint64_t aNonce = 2;
    
    if (!GutCheckValidator::Validate(__func__,
                                     EncryptionStrength::kNormal,
                                     aPassword,
                                     aPasswordByteLength, aNonce)) {
        XCTFail("test_encryptDecryptNormalA: failed gut check, died.");
        return;
    }
}

- (void)test_encryptDecryptNormalF {
    
    std::uint8_t aPassword[32U];
    aPassword[0] = 'S';
    aPassword[1] = 'o';
    aPassword[2] = 'c';
    aPassword[3] = 'c';
    aPassword[4] = 'e';
    aPassword[5] = 'r';
    aPassword[6] = 'B';
    constexpr std::size_t aPasswordByteLength = 7U;
    constexpr std::uint64_t aNonce = 2;
    
    if (!GutCheckValidator::Validate(__func__,
                                     EncryptionStrength::kNormal,
                                     aPassword,
                                     aPasswordByteLength, aNonce)) {
        XCTFail("test_encryptDecryptNormalB: failed gut check, died.");
        return;
    }
}

- (void)test_encryptDecryptNormalG {
    
    std::uint8_t aPassword[32U];
    aPassword[0] = 'S';
    aPassword[1] = 'o';
    aPassword[2] = 'c';
    aPassword[3] = 'c';
    aPassword[4] = 'e';
    aPassword[5] = 'r';
    aPassword[6] = 'C';
    constexpr std::size_t aPasswordByteLength = 7U;
    constexpr std::uint64_t aNonce = 2;
    
    if (!GutCheckValidator::Validate(__func__,
                                     EncryptionStrength::kNormal,
                                     aPassword,
                                     aPasswordByteLength, aNonce)) {
        XCTFail("test_encryptDecryptNormalC: failed gut check, died.");
        return;
    }
}

- (void)test_encryptDecryptStrongA {
    
    std::uint8_t aPassword[32U];
    aPassword[0] = 'S';
    aPassword[1] = 'o';
    aPassword[2] = 'c';
    aPassword[3] = 'c';
    aPassword[4] = 'e';
    aPassword[5] = 'r';
    aPassword[6] = 'A';
    constexpr std::size_t aPasswordByteLength = 7U;
    constexpr std::uint64_t aNonce = 1;
    
    if (!GutCheckValidator::Validate(__func__,
                                     EncryptionStrength::kStrong,
                                     aPassword,
                                     aPasswordByteLength, aNonce)) {
        XCTFail("test_encryptDecryptStrongA: failed gut check, died.");
        return;
    }
}

- (void)test_encryptDecryptStrongB {
    
    std::uint8_t aPassword[32U];
    aPassword[0] = 'S';
    aPassword[1] = 'o';
    aPassword[2] = 'c';
    aPassword[3] = 'c';
    aPassword[4] = 'e';
    aPassword[5] = 'r';
    aPassword[6] = 'B';
    constexpr std::size_t aPasswordByteLength = 7U;
    constexpr std::uint64_t aNonce = 1;
    
    if (!GutCheckValidator::Validate(__func__,
                                     EncryptionStrength::kStrong,
                                     aPassword,
                                     aPasswordByteLength, aNonce)) {
        XCTFail("test_encryptDecryptStrongB: failed gut check, died.");
        return;
    }
}

- (void)test_encryptDecryptStrongE {
    
    std::uint8_t aPassword[32U];
    aPassword[0] = 'S';
    aPassword[1] = 'o';
    aPassword[2] = 'c';
    aPassword[3] = 'c';
    aPassword[4] = 'e';
    aPassword[5] = 'r';
    aPassword[6] = 'A';
    constexpr std::size_t aPasswordByteLength = 7U;
    constexpr std::uint64_t aNonce = 2;
    
    if (!GutCheckValidator::Validate(__func__,
                                     EncryptionStrength::kStrong,
                                     aPassword,
                                     aPasswordByteLength, aNonce)) {
        XCTFail("test_encryptDecryptStrongA: failed gut check, died.");
        return;
    }
}

- (void)test_encryptDecryptStrongF {
    
    std::uint8_t aPassword[32U];
    aPassword[0] = 'S';
    aPassword[1] = 'o';
    aPassword[2] = 'c';
    aPassword[3] = 'c';
    aPassword[4] = 'e';
    aPassword[5] = 'r';
    aPassword[6] = 'B';
    constexpr std::size_t aPasswordByteLength = 7U;
    constexpr std::uint64_t aNonce = 2;
    
    if (!GutCheckValidator::Validate(__func__,
                                     EncryptionStrength::kStrong,
                                     aPassword,
                                     aPasswordByteLength, aNonce)) {
        XCTFail("test_encryptDecryptStrongB: failed gut check, died.");
        return;
    }
}

@end
