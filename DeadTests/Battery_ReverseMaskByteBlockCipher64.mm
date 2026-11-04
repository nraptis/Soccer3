//
//  Battery_ReverseMaskByteBlockCipher64.m
//  HolyStorms
//
//  Created by icarus black on 7/5/26.
//

#import <XCTest/XCTest.h>
#import "ReverseMaskByteBlockCipher64.hpp"
#import "PrintExamplesHelper.hpp"
#import "CipherGauntlet.hpp"
#include <memory>

@interface Battery_ReverseMaskByteBlockCipher64 : XCTestCase

@end

@implementation Battery_ReverseMaskByteBlockCipher64

- (void)test_gauntlet_ReverseMaskByteBlockCipher64 {
    

    
    static CipherGauntlet aGauntlet;
    
    for (auto &aMask: cMasks) {
        ReverseMaskByteBlockCipher64 aCipher(static_cast<std::uint8_t>(aMask));
        
        if (!aGauntlet.RunCipher(&aCipher,
                                 64,
                                 "ReverseMaskByteBlockCipher64")) {
            XCTFail("[ReverseMaskByteBlockCipher64] test_gauntlet_ReverseMaskByteBlockCipher64 failed.");
            return;
        }
        
    }
}

- (void)test_fixed_64_A_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 0000000000000000000000000000000000000000000000000000000000000000
    // bit1 0000000000000000000000000000000000000000000000000000000000000000
    // bit2 0000000000000000000000000000000000000000000000000000000000000000
    // bit3 0000000000000000000000000000000000000000000000000000000000000000
    // bit4 0000000000000000000000000000000000000000000000000000000000000000
    // bit5 0000000000000000000000000000000000000000000000000000000000000000
    // bit6 0000000000000000000000000000000000000000000000000000000000000000
    // bit7 0000000000000000000000000000000000000000000000000000000000000000
    //
    // After Cipher:
    // bit0 0000000000000000000000000000000000000000000000000000000000000000
    // bit1 0000000000000000000000000000000000000000000000000000000000000000
    // bit2 0000000000000000000000000000000000000000000000000000000000000000
    // bit3 0000000000000000000000000000000000000000000000000000000000000000
    // bit4 0000000000000000000000000000000000000000000000000000000000000000
    // bit5 0000000000000000000000000000000000000000000000000000000000000000
    // bit6 0000000000000000000000000000000000000000000000000000000000000000
    // bit7 0000000000000000000000000000000000000000000000000000000000000000
    //
    // Avalanche:
    // bit0 ................................................................
    // bit1 ................................................................
    // bit2 ................................................................
    // bit3 ................................................................
    // bit4 ................................................................
    // bit5 ................................................................
    // bit6 ................................................................
    // bit7 ................................................................
    // Avalanche: 0.00%

    const std::uint8_t aOriginal[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    std::uint8_t aMaskByte = 0x3E;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_A_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_A_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_A_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_A_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_A_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_A_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_B_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1111111111111111111111111111111111111111111111111111111111111111
    // bit1 1111111111111111111111111111111111111111111111111111111111111111
    // bit2 1111111111111111111111111111111111111111111111111111111111111111
    // bit3 1111111111111111111111111111111111111111111111111111111111111111
    // bit4 1111111111111111111111111111111111111111111111111111111111111111
    // bit5 1111111111111111111111111111111111111111111111111111111111111111
    // bit6 1111111111111111111111111111111111111111111111111111111111111111
    // bit7 1111111111111111111111111111111111111111111111111111111111111111
    //
    // After Cipher:
    // bit0 1111111111111111111111111111111111111111111111111111111111111111
    // bit1 1111111111111111111111111111111111111111111111111111111111111111
    // bit2 1111111111111111111111111111111111111111111111111111111111111111
    // bit3 1111111111111111111111111111111111111111111111111111111111111111
    // bit4 1111111111111111111111111111111111111111111111111111111111111111
    // bit5 1111111111111111111111111111111111111111111111111111111111111111
    // bit6 1111111111111111111111111111111111111111111111111111111111111111
    // bit7 1111111111111111111111111111111111111111111111111111111111111111
    //
    // Avalanche:
    // bit0 ................................................................
    // bit1 ................................................................
    // bit2 ................................................................
    // bit3 ................................................................
    // bit4 ................................................................
    // bit5 ................................................................
    // bit6 ................................................................
    // bit7 ................................................................
    // Avalanche: 0.00%

    const std::uint8_t aOriginal[64] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    std::uint8_t aMaskByte = 0x4C;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_B_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_B_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_B_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_B_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_B_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_B_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_C_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010101010101010101010101010101010101010101010101010101010101010
    // bit2 1010101010101010101010101010101010101010101010101010101010101010
    // bit3 1010101010101010101010101010101010101010101010101010101010101010
    // bit4 0101010101010101010101010101010101010101010101010101010101010101
    // bit5 0101010101010101010101010101010101010101010101010101010101010101
    // bit6 0101010101010101010101010101010101010101010101010101010101010101
    // bit7 0101010101010101010101010101010101010101010101010101010101010101
    //
    // After Cipher:
    // bit0 0101010101010101010101010101010101010101010101010101010101010101
    // bit1 0101010101010101010101010101010101010101010101010101010101010101
    // bit2 1010101010101010101010101010101010101010101010101010101010101010
    // bit3 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 1010101010101010101010101010101010101010101010101010101010101010
    // bit5 1010101010101010101010101010101010101010101010101010101010101010
    // bit6 0101010101010101010101010101010101010101010101010101010101010101
    // bit7 0101010101010101010101010101010101010101010101010101010101010101
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit2 ................................................................
    // bit3 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit6 ................................................................
    // bit7 ................................................................
    // Avalanche: 62.50%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0xDC;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3,
        0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3,
        0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3,
        0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_C_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_C_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_C_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_C_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_C_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_C_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_D_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010101010101010101010101010101010101010101010101010101010101010
    // bit2 0101010101010101010101010101010101010101010101010101010101010101
    // bit3 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 1010101010101010101010101010101010101010101010101010101010101010
    // bit5 1010101010101010101010101010101010101010101010101010101010101010
    // bit6 0101010101010101010101010101010101010101010101010101010101010101
    // bit7 0101010101010101010101010101010101010101010101010101010101010101
    //
    // After Cipher:
    // bit0 0101010101010101010101010101010101010101010101010101010101010101
    // bit1 1010101010101010101010101010101010101010101010101010101010101010
    // bit2 1010101010101010101010101010101010101010101010101010101010101010
    // bit3 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 0101010101010101010101010101010101010101010101010101010101010101
    // bit5 1010101010101010101010101010101010101010101010101010101010101010
    // bit6 1010101010101010101010101010101010101010101010101010101010101010
    // bit7 0101010101010101010101010101010101010101010101010101010101010101
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 ................................................................
    // bit2 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit3 ................................................................
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 ................................................................
    // bit6 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit7 ................................................................
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[64] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0xAA;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99,
        0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99,
        0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99,
        0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_D_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_D_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_D_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_D_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_D_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_D_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_E_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010101010101010101010101010101010101010101010101010101010101010
    // bit2 0101010101010101010101010101010101010101010101010101010101010101
    // bit3 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 0101010101010101010101010101010101010101010101010101010101010101
    // bit5 0101010101010101010101010101010101010101010101010101010101010101
    // bit6 1010101010101010101010101010101010101010101010101010101010101010
    // bit7 1010101010101010101010101010101010101010101010101010101010101010
    //
    // After Cipher:
    // bit0 0101010101010101010101010101010101010101010101010101010101010101
    // bit1 1010101010101010101010101010101010101010101010101010101010101010
    // bit2 1010101010101010101010101010101010101010101010101010101010101010
    // bit3 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 0101010101010101010101010101010101010101010101010101010101010101
    // bit5 1010101010101010101010101010101010101010101010101010101010101010
    // bit6 1010101010101010101010101010101010101010101010101010101010101010
    // bit7 1010101010101010101010101010101010101010101010101010101010101010
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 ................................................................
    // bit2 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit3 ................................................................
    // bit4 ................................................................
    // bit5 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit6 ................................................................
    // bit7 ................................................................
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[64] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0xA4;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98,
        0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98,
        0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98,
        0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_E_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_E_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_E_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_E_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_E_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_E_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_F_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 0101010101010101010101010101010101010101010101010101010101010101
    // bit2 1010101010101010101010101010101010101010101010101010101010101010
    // bit3 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 1010101010101010101010101010101010101010101010101010101010101010
    // bit5 0101010101010101010101010101010101010101010101010101010101010101
    // bit6 1010101010101010101010101010101010101010101010101010101010101010
    // bit7 0101010101010101010101010101010101010101010101010101010101010101
    //
    // After Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010101010101010101010101010101010101010101010101010101010101010
    // bit2 1010101010101010101010101010101010101010101010101010101010101010
    // bit3 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 0101010101010101010101010101010101010101010101010101010101010101
    // bit5 0101010101010101010101010101010101010101010101010101010101010101
    // bit6 1010101010101010101010101010101010101010101010101010101010101010
    // bit7 1010101010101010101010101010101010101010101010101010101010101010
    //
    // Avalanche:
    // bit0 ................................................................
    // bit1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit2 ................................................................
    // bit3 ................................................................
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 ................................................................
    // bit6 ................................................................
    // bit7 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[64] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0x49;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C,
        0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C,
        0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C,
        0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_F_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_F_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_F_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_F_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_F_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_F_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_G_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010100110101010011010101001101010100110101010011010101001101010
    // bit2 1001011010100101101010010110101001011010100101101010010110101001
    // bit3 1001010110100101011010010101101001010110100101011010010101101001
    // bit4 0110011010011001101001100110100110011010011001101001100110100110
    // bit5 0110010110011001011001100101100110010110011001011001100101100110
    // bit6 0101101010010110101001011010100101101010010110101001011010100101
    // bit7 0101100110010110011001011001100101100110010110011001011001100101
    //
    // After Cipher:
    // bit0 0101010101010101010101010101010101010101010101010101010101010101
    // bit1 0101011001010101100101010110010101011001010101100101010110010101
    // bit2 1001010110100101011010010101101001010110100101011010010101101001
    // bit3 1001010110100101011010010101101001010110100101011010010101101001
    // bit4 0110011010011001101001100110100110011010011001101001100110100110
    // bit5 0110011010011001101001100110100110011010011001101001100110100110
    // bit6 0101101010010110101001011010100101101010010110101001011010100101
    // bit7 1010011001101001100110100110011010011001101001100110100110011010
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit2 ......XX........XX........XX........XX........XX........XX......
    // bit3 ................................................................
    // bit4 ................................................................
    // bit5 ......XX........XX........XX........XX........XX........XX......
    // bit6 ................................................................
    // bit7 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 42.19%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F,
        0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55,
        0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0xE5;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x31, 0xCE, 0x0D, 0xF2, 0x02, 0xFD, 0x4F, 0xB0, 0x3E, 0xC1, 0x31, 0xCE, 0x0D, 0xF2, 0x02, 0xFD,
        0x4F, 0xB0, 0x3E, 0xC1, 0x31, 0xCE, 0x0D, 0xF2, 0x02, 0xFD, 0x4F, 0xB0, 0x3E, 0xC1, 0x31, 0xCE,
        0x0D, 0xF2, 0x02, 0xFD, 0x4F, 0xB0, 0x3E, 0xC1, 0x31, 0xCE, 0x0D, 0xF2, 0x02, 0xFD, 0x4F, 0xB0,
        0x3E, 0xC1, 0x31, 0xCE, 0x0D, 0xF2, 0x02, 0xFD, 0x4F, 0xB0, 0x3E, 0xC1, 0x31, 0xCE, 0x0D, 0xF2
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_G_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_G_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_G_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_G_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_G_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_G_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_H_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 0101010101010101010101010101010101010101010101010101010101010101
    // bit1 0110010101011001010101100101010110010101011001010101100101010110
    // bit2 0101101001010110100101011010010101101001010110100101011010010101
    // bit3 0110101001011010100101101010010110101001011010100101101010010110
    // bit4 0101100110010110011001011001100101100110010110011001011001100101
    // bit5 0110100110011010011001101001100110100110011010011001101001100110
    // bit6 0101011010010101101001010110100101011010010101101001010110100101
    // bit7 0110011010011001101001100110100110011010011001101001100110100110
    //
    // After Cipher:
    // bit0 0101010101010101010101010101010101010101010101010101010101010101
    // bit1 0110101010011010101001101010100110101010011010101001101010100110
    // bit2 0101101001010110100101011010010101101001010110100101011010010101
    // bit3 0110100101011010010101101001010110100101011010010101101001010110
    // bit4 0101100110010110011001011001100101100110010110011001011001100101
    // bit5 0110011001011001100101100110010110011001011001100101100110010110
    // bit6 1010010110101001011010100101101010010110101001011010100101101010
    // bit7 0110010110011001011001100101100110010110011001011001100101100110
    //
    // Avalanche:
    // bit0 ................................................................
    // bit1 ....XXXXXX....XXXXXX....XXXXXX....XXXXXX....XXXXXX....XXXXXX....
    // bit2 ................................................................
    // bit3 ......XX........XX........XX........XX........XX........XX......
    // bit4 ................................................................
    // bit5 ....XXXXXX....XXXXXX....XXXXXX....XXXXXX....XXXXXX....XXXXXX....
    // bit6 XXXX..XX..XXXX..XX..XXXX..XX..XXXX..XX..XXXX..XX..XXXX..XX..XXXX
    // bit7 ......XX........XX........XX........XX........XX........XX......
    // Avalanche: 26.56%

    const std::uint8_t aOriginal[64] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF,
        0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC,
        0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA
    };

    std::uint8_t aMaskByte = 0x57;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x02, 0xFD, 0x57, 0xA8, 0x78, 0x87, 0x64, 0x9B, 0x4B, 0xB4, 0x02, 0xFD, 0x57, 0xA8, 0x78, 0x87,
        0x64, 0x9B, 0x4B, 0xB4, 0x02, 0xFD, 0x57, 0xA8, 0x78, 0x87, 0x64, 0x9B, 0x4B, 0xB4, 0x02, 0xFD,
        0x57, 0xA8, 0x78, 0x87, 0x64, 0x9B, 0x4B, 0xB4, 0x02, 0xFD, 0x57, 0xA8, 0x78, 0x87, 0x64, 0x9B,
        0x4B, 0xB4, 0x02, 0xFD, 0x57, 0xA8, 0x78, 0x87, 0x64, 0x9B, 0x4B, 0xB4, 0x02, 0xFD, 0x57, 0xA8
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_H_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_H_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_H_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_H_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_H_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_H_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_I_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1000101011100010101110001010111000101011100010101110001010111000
    // bit2 1110011000111001100011100110001110011000111001100011100110001110
    // bit3 1100011001110001100111000110011100011001110001100111000110011100
    // bit4 0010111100001011110000101111000010111100001011110000101111000010
    // bit5 0000111101000011110100001111010000111101000011110100001111010000
    // bit6 0110001110011000111001100011100110001110011000111001100011100110
    // bit7 0100001111010000111101000011110100001111010000111101000011110100
    //
    // After Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1000101011100010101110001010111000101011100010101110001010111000
    // bit2 0111000110011100011001110001100111000110011100011001110001100111
    // bit3 1100011001110001100111000110011100011001110001100111000110011100
    // bit4 0100001111010000111101000011110100001111010000111101000011110100
    // bit5 0000111101000011110100001111010000111101000011110100001111010000
    // bit6 0110011100011001110001100111000110011100011001110001100111000110
    // bit7 0100001111010000111101000011110100001111010000111101000011110100
    //
    // Avalanche:
    // bit0 ................................................................
    // bit1 ................................................................
    // bit2 X..X.XXXX.X..X.XXXX.X..X.XXXX.X..X.XXXX.X..X.XXXX.X..X.XXXX.X..X
    // bit3 ................................................................
    // bit4 .XX.XX..XX.XX.XX..XX.XX.XX..XX.XX.XX..XX.XX.XX..XX.XX.XX..XX.XX.
    // bit5 ................................................................
    // bit6 .....X..X......X..X......X..X......X..X......X..X......X..X.....
    // bit7 ................................................................
    // Avalanche: 17.19%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33,
        0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F,
        0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00
    };

    std::uint8_t aMaskByte = 0x2A;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xD0, 0x3B, 0xA2, 0x20, 0xC4, 0x16, 0xDF, 0x2F, 0xE9, 0x5D, 0xD0, 0x3B, 0xA2, 0x20, 0xC4, 0x16,
        0xDF, 0x2F, 0xE9, 0x5D, 0xD0, 0x3B, 0xA2, 0x20, 0xC4, 0x16, 0xDF, 0x2F, 0xE9, 0x5D, 0xD0, 0x3B,
        0xA2, 0x20, 0xC4, 0x16, 0xDF, 0x2F, 0xE9, 0x5D, 0xD0, 0x3B, 0xA2, 0x20, 0xC4, 0x16, 0xDF, 0x2F,
        0xE9, 0x5D, 0xD0, 0x3B, 0xA2, 0x20, 0xC4, 0x16, 0xDF, 0x2F, 0xE9, 0x5D, 0xD0, 0x3B, 0xA2, 0x20
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_I_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_I_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_I_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_I_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_I_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_I_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_J_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1111111111111111111111111111111111111111111111111111111111111111
    // bit2 0000000000000000000000000000000000000000000000000000000000000000
    // bit3 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 1010101010101010101010101010101010101010101010101010101010101010
    // bit5 1111111111111111111111111111111111111111111111111111111111111111
    // bit6 0000000000000000000000000000000000000000000000000000000000000000
    // bit7 0101010101010101010101010101010101010101010101010101010101010101
    //
    // After Cipher:
    // bit0 0101010101010101010101010101010101010101010101010101010101010101
    // bit1 1111111111111111111111111111111111111111111111111111111111111111
    // bit2 0000000000000000000000000000000000000000000000000000000000000000
    // bit3 1010101010101010101010101010101010101010101010101010101010101010
    // bit4 1010101010101010101010101010101010101010101010101010101010101010
    // bit5 1111111111111111111111111111111111111111111111111111111111111111
    // bit6 0000000000000000000000000000000000000000000000000000000000000000
    // bit7 0101010101010101010101010101010101010101010101010101010101010101
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 ................................................................
    // bit2 ................................................................
    // bit3 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 ................................................................
    // bit5 ................................................................
    // bit6 ................................................................
    // bit7 ................................................................
    // Avalanche: 25.00%

    const std::uint8_t aOriginal[64] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    std::uint8_t aMaskByte = 0xB0;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5,
        0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5,
        0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5,
        0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_J_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_J_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_J_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_J_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_J_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_J_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_K_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010101010101010101010100101010110101010101010101010101010101010
    // bit2 1010101001010101010101011010101010101010101010100101010101010101
    // bit3 1010101001010101010101010101010110101010101010100101010101010101
    // bit4 0101010110101010010101011010101010101010010101011010101001010101
    // bit5 0101010110101010010101010101010110101010010101011010101001010101
    // bit6 0101010101010101101010101010101010101010010101010101010110101010
    // bit7 0101010101010101101010100101010110101010010101010101010110101010
    //
    // After Cipher:
    // bit0 0101010101010101010101010101010101010101010101010101010101010101
    // bit1 1010101010101010101010100101010110101010101010101010101010101010
    // bit2 1010101001010101010101011010101010101010101010100101010101010101
    // bit3 1010101001010101010101010101010110101010101010100101010101010101
    // bit4 1010101001010101101010100101010101010101101010100101010110101010
    // bit5 1010101001010101101010100101010110101010101010100101010110101010
    // bit6 0101010101010101101010101010101010101010010101010101010110101010
    // bit7 0101010101010101101010100101010110101010010101010101010110101010
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 ................................................................
    // bit2 ................................................................
    // bit3 ................................................................
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 XXXXXXXXXXXXXXXXXXXXXXXX................XXXXXXXXXXXXXXXXXXXXXXXX
    // bit6 ................................................................
    // bit7 ................................................................
    // Avalanche: 34.38%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x8C;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x7C, 0x83, 0x7C, 0x83, 0x7C, 0x83, 0x7C, 0x83, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF,
        0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x22, 0xDD, 0x22, 0xDD, 0x22, 0xDD, 0x22, 0xDD,
        0x77, 0x88, 0x77, 0x88, 0x77, 0x88, 0x77, 0x88, 0x7C, 0x83, 0x7C, 0x83, 0x7C, 0x83, 0x7C, 0x83,
        0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_K_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_K_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_K_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_K_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_K_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_K_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_L_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1000010111101000010111101000010111101000010111101000010111101000
    // bit1 1000010101010101010111101000000010101000010111101010111111101000
    // bit2 1010101010101000010101010111111111101000000000010101010111101010
    // bit3 1010101000010101010101010111101010101000000000010111111111101010
    // bit4 0101000010101000000010101010111111101010111101010101010101010101
    // bit5 0101000000010101000010101010101010101010111101010111111101010101
    // bit6 0111111111101000000000010101010111101010101010101000010101010111
    // bit7 0111111101010101000000010101000010101010101010101010111101010111
    //
    // After Cipher:
    // bit0 0001011110100001011110100001011110100001011110100001011110100001
    // bit1 1000010101010101010111101000000010101000010111101010111111101000
    // bit2 1010101010101000010101010111111111101000000000010101010111101010
    // bit3 1010101000010101010101010111101010101000000000010111111111101010
    // bit4 1010101010101010101011110101011111110101010100000001010100001010
    // bit5 1010101011111110101011110101010101010101010100001010100000001010
    // bit6 0111111111101000000000010101010111101010101010101000010101010111
    // bit7 0111111101010101000000010101000010101010101010101010111101010111
    //
    // Avalanche:
    // bit0 X..X..X..X..X..X..X..X..X..X..X..X..X..X..X..X..X..X..X..X..X..X
    // bit1 ................................................................
    // bit2 ................................................................
    // bit3 ................................................................
    // bit4 XXXXX.X.......X.X.X..X.XXXXXX......XXXXXX.X..X.X.X.......X.XXXXX
    // bit5 XXXXX.X.XXX.X.XXX.X..X.XXXXXXXXXXXXXXXXXX.X..X.XXX.X.XXX.X.XXXXX
    // bit6 ................................................................
    // bit7 ................................................................
    // Avalanche: 19.92%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA,
        0xFF, 0xAA, 0xFF, 0x00, 0xFF, 0x00, 0x0F, 0x00, 0x0F, 0xCC, 0x0F, 0xCC, 0xC3, 0xCC, 0xC3, 0x3C,
        0xC3, 0x3C, 0x55, 0x3C, 0x55, 0xFF, 0x55, 0xFF, 0xF0, 0xFF, 0xF0, 0x0F, 0xF0, 0x0F, 0x33, 0x0F
    };

    std::uint8_t aMaskByte = 0x8C;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x7C, 0x03, 0x3F, 0x83, 0x3F, 0xC3, 0xBF, 0xC3, 0xAE, 0x47, 0xAE, 0x55, 0x2E, 0x55, 0x0C, 0xD1,
        0x0C, 0xF0, 0x8C, 0xF0, 0xCC, 0x7C, 0xCC, 0x3F, 0x40, 0x3F, 0x30, 0xBF, 0x30, 0xAE, 0xB8, 0xAE,
        0xFB, 0x2E, 0xFB, 0x0C, 0x73, 0x0C, 0x03, 0x8C, 0x03, 0xCC, 0x83, 0xCC, 0xC3, 0x40, 0xC3, 0x30,
        0x47, 0x30, 0x55, 0xB8, 0x55, 0xFB, 0xD1, 0xFB, 0xF0, 0x73, 0xF0, 0x03, 0x7C, 0x03, 0x3F, 0x83
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_L_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_L_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_L_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_L_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_L_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_64_L_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_A_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit1 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit2 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit3 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit4 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit5 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit6 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit7 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    //
    // After Cipher:
    // bit0 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit1 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit2 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit3 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit4 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit5 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit6 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit7 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    //
    // Avalanche:
    // bit0 ................................................................ | ................................................................
    // bit1 ................................................................ | ................................................................
    // bit2 ................................................................ | ................................................................
    // bit3 ................................................................ | ................................................................
    // bit4 ................................................................ | ................................................................
    // bit5 ................................................................ | ................................................................
    // bit6 ................................................................ | ................................................................
    // bit7 ................................................................ | ................................................................
    // Avalanche: 0.00%

    const std::uint8_t aOriginal[128] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    std::uint8_t aMaskByte = 0x37;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_A_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_A_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_A_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_A_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_A_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_A_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_B_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit1 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit2 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit3 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit4 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit5 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit6 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit7 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    //
    // After Cipher:
    // bit0 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit1 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit2 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit3 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit4 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit5 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit6 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit7 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    //
    // Avalanche:
    // bit0 ................................................................ | ................................................................
    // bit1 ................................................................ | ................................................................
    // bit2 ................................................................ | ................................................................
    // bit3 ................................................................ | ................................................................
    // bit4 ................................................................ | ................................................................
    // bit5 ................................................................ | ................................................................
    // bit6 ................................................................ | ................................................................
    // bit7 ................................................................ | ................................................................
    // Avalanche: 0.00%

    const std::uint8_t aOriginal[128] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    std::uint8_t aMaskByte = 0xB5;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_B_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_B_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_B_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_B_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_B_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_B_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_C_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit2 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit3 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit4 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit5 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit6 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit7 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    //
    // After Cipher:
    // bit0 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit1 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit2 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit3 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit4 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit5 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit6 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit7 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 ................................................................ | ................................................................
    // bit2 ................................................................ | ................................................................
    // bit3 ................................................................ | ................................................................
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 ................................................................ | ................................................................
    // bit6 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit7 ................................................................ | ................................................................
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[128] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0x8A;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85,
        0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85,
        0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85,
        0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85,
        0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85,
        0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85,
        0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85,
        0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85, 0x7A, 0x85
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_C_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_C_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_C_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_C_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_C_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_C_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_D_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit2 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit3 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit5 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit6 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit7 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    //
    // After Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit2 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit3 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit4 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit5 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit6 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit7 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    //
    // Avalanche:
    // bit0 ................................................................ | ................................................................
    // bit1 ................................................................ | ................................................................
    // bit2 ................................................................ | ................................................................
    // bit3 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 ................................................................ | ................................................................
    // bit5 ................................................................ | ................................................................
    // bit6 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit7 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[128] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x13;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20,
        0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20,
        0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20,
        0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20,
        0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20,
        0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20,
        0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20,
        0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_D_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_D_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_D_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_D_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_D_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_D_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_E_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit2 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit3 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit5 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit6 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit7 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    //
    // After Cipher:
    // bit0 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit1 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit2 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit3 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit5 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit6 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit7 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit2 ................................................................ | ................................................................
    // bit3 ................................................................ | ................................................................
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit6 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit7 ................................................................ | ................................................................
    // Avalanche: 62.50%

    const std::uint8_t aOriginal[128] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0xCE;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2,
        0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2,
        0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2,
        0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2,
        0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2,
        0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2,
        0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2,
        0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2, 0x0D, 0xF2
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_E_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_E_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_E_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_E_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_E_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_E_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_F_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit2 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit3 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit5 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit6 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit7 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    //
    // After Cipher:
    // bit0 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit1 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit2 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit3 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit4 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit5 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit6 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit7 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit2 ................................................................ | ................................................................
    // bit3 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 ................................................................ | ................................................................
    // bit6 ................................................................ | ................................................................
    // bit7 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 62.50%

    const std::uint8_t aOriginal[128] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0xD9;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C,
        0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C,
        0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C,
        0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C,
        0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C,
        0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C,
        0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C,
        0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_F_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_F_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_F_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_F_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_F_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_F_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_G_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010100110101010011010101001101010100110101010011010101001101010 | 1001101010100110101010011010101001101010100110101010011010101001
    // bit2 1001011010100101101010010110101001011010100101101010010110101001 | 0110101001011010100101101010010110101001011010100101101010010110
    // bit3 1001010110100101011010010101101001010110100101011010010101101001 | 0101101001010110100101011010010101101001010110100101011010010101
    // bit4 0110011010011001101001100110100110011010011001101001100110100110 | 0110100110011010011001101001100110100110011010011001101001100110
    // bit5 0110010110011001011001100101100110010110011001011001100101100110 | 0101100110010110011001011001100101100110010110011001011001100101
    // bit6 0101101010010110101001011010100101101010010110101001011010100101 | 1010100101101010010110101001011010100101101010010110101001011010
    // bit7 0101100110010110011001011001100101100110010110011001011001100101 | 1001100101100110010110011001011001100101100110010110011001011001
    //
    // After Cipher:
    // bit0 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit1 0101011001010101100101010110010101011001010101100101010110010101 | 1001010101100101010110010101011001010101100101010110010101011001
    // bit2 1001010110100101011010010101101001010110100101011010010101101001 | 0110100101011010010101101001010110100101011010010101101001010110
    // bit3 1001010110100101011010010101101001010110100101011010010101101001 | 0101101001010110100101011010010101101001010110100101011010010101
    // bit4 0110010110011001011001100101100110010110011001011001100101100110 | 0110011001011001100101100110010110011001011001100101100110010110
    // bit5 0110010110011001011001100101100110010110011001011001100101100110 | 0101100110010110011001011001100101100110010110011001011001100101
    // bit6 1010010101101001010110100101011010010101101001010110100101011010 | 0101101001010110100101011010010101101001010110100101011010010101
    // bit7 0101100110010110011001011001100101100110010110011001011001100101 | 1001100101100110010110011001011001100101100110010110011001011001
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | ....XXXXXX....XXXXXX....XXXXXX....XXXXXX....XXXXXX....XXXXXX....
    // bit2 ......XX........XX........XX........XX........XX........XX...... | ......XX........XX........XX........XX........XX........XX......
    // bit3 ................................................................ | ................................................................
    // bit4 ......XX........XX........XX........XX........XX........XX...... | ....XXXXXX....XXXXXX....XXXXXX....XXXXXX....XXXXXX....XXXXXX....
    // bit5 ................................................................ | ................................................................
    // bit6 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXX..XX..XXXX..XX..XXXX..XX..XXXX..XX..XXXX..XX..XXXX..XX..XXXX
    // bit7 ................................................................ | ................................................................
    // Avalanche: 39.45%

    const std::uint8_t aOriginal[128] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F,
        0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55,
        0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33,
        0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00,
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F,
        0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0xEA;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x32, 0xCD, 0x0E, 0xF1, 0x01, 0xFE, 0x40, 0xBF, 0x3D, 0xC2, 0x32, 0xCD, 0x0E, 0xF1, 0x01, 0xFE,
        0x40, 0xBF, 0x3D, 0xC2, 0x32, 0xCD, 0x0E, 0xF1, 0x01, 0xFE, 0x40, 0xBF, 0x3D, 0xC2, 0x32, 0xCD,
        0x0E, 0xF1, 0x01, 0xFE, 0x40, 0xBF, 0x3D, 0xC2, 0x32, 0xCD, 0x0E, 0xF1, 0x01, 0xFE, 0x40, 0xBF,
        0x3D, 0xC2, 0x32, 0xCD, 0x0E, 0xF1, 0x01, 0xFE, 0x40, 0xBF, 0x3D, 0xC2, 0x32, 0xCD, 0x0E, 0xF1,
        0x41, 0xBE, 0x28, 0xD7, 0x37, 0xC8, 0x1A, 0xE5, 0x04, 0xFB, 0x41, 0xBE, 0x28, 0xD7, 0x37, 0xC8,
        0x1A, 0xE5, 0x04, 0xFB, 0x41, 0xBE, 0x28, 0xD7, 0x37, 0xC8, 0x1A, 0xE5, 0x04, 0xFB, 0x41, 0xBE,
        0x28, 0xD7, 0x37, 0xC8, 0x1A, 0xE5, 0x04, 0xFB, 0x41, 0xBE, 0x28, 0xD7, 0x37, 0xC8, 0x1A, 0xE5,
        0x04, 0xFB, 0x41, 0xBE, 0x28, 0xD7, 0x37, 0xC8, 0x1A, 0xE5, 0x04, 0xFB, 0x41, 0xBE, 0x28, 0xD7
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_G_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_G_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_G_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_G_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_G_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_G_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_H_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit1 0110010101011001010101100101010110010101011001010101100101010110 | 0101010110010101011001010101100101010110010101011001010101100101
    // bit2 0101101001010110100101011010010101101001010110100101011010010101 | 1010010101101001010110100101011010010101101001010110100101011010
    // bit3 0110101001011010100101101010010110101001011010100101101010010110 | 1010010110101001011010100101101010010110101001011010100101101010
    // bit4 0101100110010110011001011001100101100110010110011001011001100101 | 1001100101100110010110011001011001100101100110010110011001011001
    // bit5 0110100110011010011001101001100110100110011010011001101001100110 | 1001100110100110011010011001101001100110100110011010011001101001
    // bit6 0101011010010101101001010110100101011010010101101001010110100101 | 0110100101011010010101101001010110100101011010010101101001010110
    // bit7 0110011010011001101001100110100110011010011001101001100110100110 | 0110100110011010011001101001100110100110011010011001101001100110
    //
    // After Cipher:
    // bit0 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit1 0110101010011010101001101010100110101010011010101001101010100110 | 1010011010101001101010100110101010011010101001101010100110101010
    // bit2 1010100101101010010110101001011010100101101010010110101001011010 | 0101101010010110101001011010100101101010010110101001011010100101
    // bit3 0110100101011010010101101001010110100101011010010101101001010110 | 0101011010010101101001010110100101011010010101101001010110100101
    // bit4 1010011001101001100110100110011010011001101001100110100110011010 | 1001101001100110100110011010011001101001100110100110011010011001
    // bit5 0110100110011010011001101001100110100110011010011001101001100110 | 1001100110100110011010011001101001100110100110011010011001101001
    // bit6 1010010110101001011010100101101010010110101001011010100101101010 | 0110101001011010100101101010010110101001011010100101101010010110
    // bit7 0110011010011001101001100110100110011010011001101001100110100110 | 0110100110011010011001101001100110100110011010011001101001100110
    //
    // Avalanche:
    // bit0 ................................................................ | ................................................................
    // bit1 ....XXXXXX....XXXXXX....XXXXXX....XXXXXX....XXXXXX....XXXXXX.... | XXXX..XX..XXXX..XX..XXXX..XX..XXXX..XX..XXXX..XX..XXXX..XX..XXXX
    // bit2 XXXX..XX..XXXX..XX..XXXX..XX..XXXX..XX..XXXX..XX..XXXX..XX..XXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit3 ......XX........XX........XX........XX........XX........XX...... | XXXX..XX..XXXX..XX..XXXX..XX..XXXX..XX..XXXX..XX..XXXX..XX..XXXX
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | ......XX........XX........XX........XX........XX........XX......
    // bit5 ................................................................ | ................................................................
    // bit6 XXXX..XX..XXXX..XX..XXXX..XX..XXXX..XX..XXXX..XX..XXXX..XX..XXXX | ......XX........XX........XX........XX........XX........XX......
    // bit7 ................................................................ | ................................................................
    // Avalanche: 35.16%

    const std::uint8_t aOriginal[128] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF,
        0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC,
        0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA,
        0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0,
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF,
        0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC
    };

    std::uint8_t aMaskByte = 0x7A;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x2A, 0xD5, 0x7F, 0x80, 0x74, 0x8B, 0x49, 0xB6, 0x47, 0xB8, 0x2A, 0xD5, 0x7F, 0x80, 0x74, 0x8B,
        0x49, 0xB6, 0x47, 0xB8, 0x2A, 0xD5, 0x7F, 0x80, 0x74, 0x8B, 0x49, 0xB6, 0x47, 0xB8, 0x2A, 0xD5,
        0x7F, 0x80, 0x74, 0x8B, 0x49, 0xB6, 0x47, 0xB8, 0x2A, 0xD5, 0x7F, 0x80, 0x74, 0x8B, 0x49, 0xB6,
        0x47, 0xB8, 0x2A, 0xD5, 0x7F, 0x80, 0x74, 0x8B, 0x49, 0xB6, 0x47, 0xB8, 0x2A, 0xD5, 0x7F, 0x80,
        0x4C, 0xB3, 0x43, 0xBC, 0x2F, 0xD0, 0x7A, 0x85, 0x75, 0x8A, 0x4C, 0xB3, 0x43, 0xBC, 0x2F, 0xD0,
        0x7A, 0x85, 0x75, 0x8A, 0x4C, 0xB3, 0x43, 0xBC, 0x2F, 0xD0, 0x7A, 0x85, 0x75, 0x8A, 0x4C, 0xB3,
        0x43, 0xBC, 0x2F, 0xD0, 0x7A, 0x85, 0x75, 0x8A, 0x4C, 0xB3, 0x43, 0xBC, 0x2F, 0xD0, 0x7A, 0x85,
        0x75, 0x8A, 0x4C, 0xB3, 0x43, 0xBC, 0x2F, 0xD0, 0x7A, 0x85, 0x75, 0x8A, 0x4C, 0xB3, 0x43, 0xBC
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_H_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_H_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_H_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_H_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_H_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_H_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_I_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1000101011100010101110001010111000101011100010101110001010111000 | 1010111000101011100010101110001010111000101011100010101110001010
    // bit2 1110011000111001100011100110001110011000111001100011100110001110 | 0110001110011000111001100011100110001110011000111001100011100110
    // bit3 1100011001110001100111000110011100011001110001100111000110011100 | 0110011100011001110001100111000110011100011001110001100111000110
    // bit4 0010111100001011110000101111000010111100001011110000101111000010 | 1111000010111100001011110000101111000010111100001011110000101111
    // bit5 0000111101000011110100001111010000111101000011110100001111010000 | 1111010000111101000011110100001111010000111101000011110100001111
    // bit6 0110001110011000111001100011100110001110011000111001100011100110 | 0011100110001110011000111001100011100110001110011000111001100011
    // bit7 0100001111010000111101000011110100001111010000111101000011110100 | 0011110100001111010000111101000011110100001111010000111101000011
    //
    // After Cipher:
    // bit0 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit1 1000101011100010101110001010111000101011100010101110001010111000 | 1010111000101011100010101110001010111000101011100010101110001010
    // bit2 1110011000111001100011100110001110011000111001100011100110001110 | 0110001110011000111001100011100110001110011000111001100011100110
    // bit3 0011100110001110011000111001100011100110001110011000111001100011 | 0110001110011000111001100011100110001110011000111001100011100110
    // bit4 0100001111010000111101000011110100001111010000111101000011110100 | 1111010000111101000011110100001111010000111101000011110100001111
    // bit5 0000111101000011110100001111010000111101000011110100001111010000 | 1111010000111101000011110100001111010000111101000011110100001111
    // bit6 0110001110011000111001100011100110001110011000111001100011100110 | 0011100110001110011000111001100011100110001110011000111001100011
    // bit7 0100001111010000111101000011110100001111010000111101000011110100 | 0011110100001111010000111101000011110100001111010000111101000011
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 ................................................................ | ................................................................
    // bit2 ................................................................ | ................................................................
    // bit3 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | .....X..X......X..X......X..X......X..X......X..X......X..X.....
    // bit4 .XX.XX..XX.XX.XX..XX.XX.XX..XX.XX.XX..XX.XX.XX..XX.XX.XX..XX.XX. | .....X..X......X..X......X..X......X..X......X..X......X..X.....
    // bit5 ................................................................ | ................................................................
    // bit6 ................................................................ | ................................................................
    // bit7 ................................................................ | ................................................................
    // Avalanche: 24.80%

    const std::uint8_t aOriginal[128] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33,
        0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F,
        0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00,
        0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55,
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33,
        0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F
    };

    std::uint8_t aMaskByte = 0x98;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x60, 0xAB, 0x32, 0x90, 0x54, 0xA4, 0x6F, 0x9F, 0x5B, 0xCD, 0x60, 0xAB, 0x32, 0x90, 0x54, 0xA4,
        0x6F, 0x9F, 0x5B, 0xCD, 0x60, 0xAB, 0x32, 0x90, 0x54, 0xA4, 0x6F, 0x9F, 0x5B, 0xCD, 0x60, 0xAB,
        0x32, 0x90, 0x54, 0xA4, 0x6F, 0x9F, 0x5B, 0xCD, 0x60, 0xAB, 0x32, 0x90, 0x54, 0xA4, 0x6F, 0x9F,
        0x5B, 0xCD, 0x60, 0xAB, 0x32, 0x90, 0x54, 0xA4, 0x6F, 0x9F, 0x5B, 0xCD, 0x60, 0xAB, 0x32, 0x90,
        0x4C, 0xBC, 0x7F, 0x8F, 0x43, 0xCD, 0x70, 0xB3, 0x32, 0x80, 0x4C, 0xBC, 0x7F, 0x8F, 0x43, 0xCD,
        0x70, 0xB3, 0x32, 0x80, 0x4C, 0xBC, 0x7F, 0x8F, 0x43, 0xCD, 0x70, 0xB3, 0x32, 0x80, 0x4C, 0xBC,
        0x7F, 0x8F, 0x43, 0xCD, 0x70, 0xB3, 0x32, 0x80, 0x4C, 0xBC, 0x7F, 0x8F, 0x43, 0xCD, 0x70, 0xB3,
        0x32, 0x80, 0x4C, 0xBC, 0x7F, 0x8F, 0x43, 0xCD, 0x70, 0xB3, 0x32, 0x80, 0x4C, 0xBC, 0x7F, 0x8F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_I_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_I_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_I_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_I_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_I_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_I_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_J_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit2 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit3 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit5 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit6 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit7 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    //
    // After Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit2 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit3 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit4 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit5 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit6 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit7 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    //
    // Avalanche:
    // bit0 ................................................................ | ................................................................
    // bit1 ................................................................ | ................................................................
    // bit2 ................................................................ | ................................................................
    // bit3 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 ................................................................ | ................................................................
    // bit5 ................................................................ | ................................................................
    // bit6 ................................................................ | ................................................................
    // bit7 ................................................................ | ................................................................
    // Avalanche: 12.50%

    const std::uint8_t aOriginal[128] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    std::uint8_t aMaskByte = 0x76;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45,
        0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45,
        0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45,
        0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45,
        0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45,
        0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45,
        0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45,
        0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45, 0xDC, 0x45
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_J_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_J_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_J_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_J_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_J_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_J_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_K_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010101010101010101010100101010110101010101010101010101010101010 | 0101010110101010101010101010101010101010010101011010101010101010
    // bit2 1010101001010101010101011010101010101010101010100101010101010101 | 1010101010101010101010100101010101010101101010101010101010101010
    // bit3 1010101001010101010101010101010110101010101010100101010101010101 | 0101010110101010101010100101010101010101010101011010101010101010
    // bit4 0101010110101010010101011010101010101010010101011010101001010101 | 1010101010101010010101011010101001010101101010101010101001010101
    // bit5 0101010110101010010101010101010110101010010101011010101001010101 | 0101010110101010010101011010101001010101010101011010101001010101
    // bit6 0101010101010101101010101010101010101010010101010101010110101010 | 1010101010101010010101010101010110101010101010101010101001010101
    // bit7 0101010101010101101010100101010110101010010101010101010110101010 | 0101010110101010010101010101010110101010010101011010101001010101
    //
    // After Cipher:
    // bit0 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit1 0101010101010101010101010101010110101010010101010101010101010101 | 0101010101010101101010100101010101010101010101010101010110101010
    // bit2 1010101010101010010101010101010101010101101010101010101001010101 | 0101010101010101010101011010101010101010010101010101010101010101
    // bit3 1010101001010101010101010101010110101010101010100101010101010101 | 0101010110101010101010100101010101010101010101011010101010101010
    // bit4 0101010110101010010101011010101010101010010101011010101001010101 | 1010101010101010010101011010101001010101101010101010101001010101
    // bit5 0101010110101010010101010101010110101010010101011010101001010101 | 0101010110101010010101011010101001010101010101011010101001010101
    // bit6 0101010101010101101010101010101010101010010101010101010110101010 | 1010101010101010010101010101010110101010101010101010101001010101
    // bit7 0101010101010101101010100101010110101010010101010101010110101010 | 0101010110101010010101010101010110101010010101011010101001010101
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 XXXXXXXXXXXXXXXXXXXXXXXX................XXXXXXXXXXXXXXXXXXXXXXXX | ........XXXXXXXX........XXXXXXXXXXXXXXXX........XXXXXXXX........
    // bit2 ........XXXXXXXX........XXXXXXXXXXXXXXXX........XXXXXXXX........ | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit3 ................................................................ | ................................................................
    // bit4 ................................................................ | ................................................................
    // bit5 ................................................................ | ................................................................
    // bit6 ................................................................ | ................................................................
    // bit7 ................................................................ | ................................................................
    // Avalanche: 29.69%

    const std::uint8_t aOriginal[128] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0xE0;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x30, 0xCF, 0x30, 0xCF, 0x30, 0xCF, 0x30, 0xCF, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3,
        0x03, 0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x0A, 0xF5, 0x0A, 0xF5, 0x0A, 0xF5, 0x0A, 0xF5,
        0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x30, 0xCF, 0x30, 0xCF, 0x30, 0xCF, 0x30, 0xCF,
        0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x03, 0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x03, 0xFC,
        0x0A, 0xF5, 0x0A, 0xF5, 0x0A, 0xF5, 0x0A, 0xF5, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0,
        0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3,
        0x23, 0xDC, 0x23, 0xDC, 0x23, 0xDC, 0x23, 0xDC, 0x0A, 0xF5, 0x0A, 0xF5, 0x0A, 0xF5, 0x0A, 0xF5,
        0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_K_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_K_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_K_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_K_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_K_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_K_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_L_ReverseMaskByteBlockCipher64 {

    // Before Cipher:
    // bit0 1000010111101000010111101000010111101000010111101000010111101000 | 0101111010000101111010000101111010000101111010000101111010000101
    // bit1 1000010101010101010111101000000010101000010111101010111111101000 | 0101010101010101111010000000101010000101111010101111111010000101
    // bit2 1010101010101000010101010111111111101000000000010101010111101010 | 1010101010000101010101111111111010000000000101010101111010101010
    // bit3 1010101000010101010101010111101010101000000000010111111111101010 | 1010000101010101010101111010101010000000000101111111111010101010
    // bit4 0101000010101000000010101010111111101010111101010101010101010101 | 0000101010000000101010101111111010101111010101010101010101010000
    // bit5 0101000000010101000010101010101010101010111101010111111101010101 | 0000000101010000101010101010101010101111010101111111010101010000
    // bit6 0111111111101000000000010101010111101010101010101000010101010111 | 1111111010000000000101010101111010101010101010000101010101111111
    // bit7 0111111101010101000000010101000010101010101010101010111101010111 | 1111010101010000000101010000101010101010101010101111010101111111
    //
    // After Cipher:
    // bit0 1000010111101000010111101000010111101000010111101000010111101000 | 0101111010000101111010000101111010000101111010000101111010000101
    // bit1 0001011111110101011110100001010100000001011110101010101010100001 | 1010000101111111010101111010000101010000000101111010101010101010
    // bit2 1010101010101000010101010111111111101000000000010101010111101010 | 1010101010000101010101111111111010000000000101010101111010101010
    // bit3 0101011111111110100000000001010101011110101010101010100001010101 | 0101010101111111111010000000000101010101111010101010101010000101
    // bit4 1010101010101010101011110101011111110101010100000001010100001010 | 0000101010101010101010101111010101111111010101010000000101010000
    // bit5 1010101011111110101011110101010101010101010100001010100000001010 | 0000101010101111111010101111010101010101010101010000101010000000
    // bit6 0111111111101000000000010101010111101010101010101000010101010111 | 1111111010000000000101010101111010101010101010000101010101111111
    // bit7 1110101011110101010101010101010100001010100000001010101011111110 | 1111111010101111010101010101010101010000101010000000101010101111
    //
    // Avalanche:
    // bit0 ................................................................ | ................................................................
    // bit1 X..X..X.X.X.......X..X..X..X.X.XX.X.X..X..X..X.......X.X.X..X..X | XXXX.X....X.X.X.X.XXXXXXX.X.X.XXXX.X.X.XXXXXXX.X.X.X.X....X.XXXX
    // bit2 ................................................................ | ................................................................
    // bit3 XXXXXX.XXXX.X.XXXX.X.X.X.XX.XXXXXXXX.XX.X.X.X.XXXX.X.XXXX.XXXXXX | XXXX.X....X.X.X.X.XXXXXXX.X.X.XXXX.X.X.XXXXXXX.X.X.X.X....X.XXXX
    // bit4 XXXXX.X.......X.X.X..X.XXXXXX......XXXXXX.X..X.X.X.......X.XXXXX | ..........X.X.X.............X.XXXX.X.............X.X.X..........
    // bit5 XXXXX.X.XXX.X.XXX.X..X.XXXXXXXXXXXXXXXXXX.X..X.XXX.X.XXX.X.XXXXX | ....X.XXXXXXXXXX.X.......X.XXXXXXXXXX.X.......X.XXXXXXXXXX.X....
    // bit6 ................................................................ | ................................................................
    // bit7 X..X.X.XX.X......X.X.X.......X.XX.X.......X.X.X......X.XX.X.X..X | ....X.XXXXXXXXXX.X.......X.XXXXXXXXXX.X.......X.XXXXXXXXXX.X....
    // Avalanche: 32.81%

    const std::uint8_t aOriginal[128] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA,
        0xFF, 0xAA, 0xFF, 0x00, 0xFF, 0x00, 0x0F, 0x00, 0x0F, 0xCC, 0x0F, 0xCC, 0xC3, 0xCC, 0xC3, 0x3C,
        0xC3, 0x3C, 0x55, 0x3C, 0x55, 0xFF, 0x55, 0xFF, 0xF0, 0xFF, 0xF0, 0x0F, 0xF0, 0x0F, 0x33, 0x0F,
        0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55, 0x00, 0xF0, 0x00, 0xF0,
        0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA, 0xFF, 0xAA, 0xFF, 0x00,
        0xFF, 0x00, 0x0F, 0x00, 0x0F, 0xCC, 0x0F, 0xCC, 0xC3, 0xCC, 0xC3, 0x3C, 0xC3, 0x3C, 0x55, 0x3C,
        0x55, 0xFF, 0x55, 0xFF, 0xF0, 0xFF, 0xF0, 0x0F, 0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3
    };

    std::uint8_t aMaskByte = 0x5D;

    ReverseMaskByteBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xAD, 0x13, 0x2F, 0x52, 0x2F, 0xD2, 0x7F, 0xD2, 0xFF, 0xD7, 0xFF, 0x55, 0xBE, 0x55, 0x1C, 0x41,
        0x1C, 0xE1, 0x4C, 0xE1, 0xCC, 0xAD, 0xCC, 0x2F, 0x80, 0x2F, 0x20, 0x7F, 0x20, 0xFF, 0x28, 0xFF,
        0xAA, 0xBE, 0xAA, 0x1C, 0xB3, 0x1C, 0x13, 0x4C, 0x13, 0xCC, 0x52, 0xCC, 0xD2, 0x80, 0xD2, 0x20,
        0xD7, 0x20, 0x55, 0x28, 0x55, 0xAA, 0x41, 0xAA, 0xE1, 0xB3, 0xE1, 0x13, 0xAD, 0x13, 0x2F, 0x52,
        0x63, 0x93, 0x63, 0x93, 0xAF, 0x93, 0xAF, 0x50, 0xAF, 0x50, 0x5D, 0x50, 0x5D, 0xF5, 0x5D, 0xF5,
        0x9C, 0xF5, 0x9C, 0x63, 0x9C, 0x63, 0x6C, 0x63, 0x6C, 0xAF, 0x6C, 0xAF, 0xA2, 0xAF, 0xA2, 0x5D,
        0xA2, 0x5D, 0x0A, 0x5D, 0x0A, 0x9C, 0x0A, 0x9C, 0x93, 0x9C, 0x93, 0x6C, 0x93, 0x6C, 0x50, 0x6C,
        0x50, 0xA2, 0x50, 0xA2, 0xF5, 0xA2, 0xF5, 0x0A, 0xF5, 0x0A, 0x63, 0x0A, 0x63, 0x93, 0x63, 0x93
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_L_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_L_ReverseMaskByteBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_L_ReverseMaskByteBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_L_ReverseMaskByteBlockCipher64")) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_L_ReverseMaskByteBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher64] test_fixed_128_L_ReverseMaskByteBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

@end
