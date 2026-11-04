//
//  Battery_ReverseMaskByteBlockCipher32.m
//  HolyStorms
//
//  Created by icarus black on 7/5/26.
//

#import <XCTest/XCTest.h>
#import "ReverseMaskByteBlockCipher32.hpp"
#import "PrintExamplesHelper.hpp"
#import "CipherGauntlet.hpp"
#include <memory>

@interface Battery_ReverseMaskByteBlockCipher32 : XCTestCase

@end

@implementation Battery_ReverseMaskByteBlockCipher32

- (void)test_gauntlet_ReverseMaskByteBlockCipher32 {
    

    
    static CipherGauntlet aGauntlet;
    
    for (auto &aMask: cMasks) {
        ReverseMaskByteBlockCipher32 aCipher(static_cast<std::uint8_t>(aMask));
        
        if (!aGauntlet.RunCipher(&aCipher,
                                 32,
                                 "ReverseMaskByteBlockCipher32")) {
            XCTFail("[ReverseMaskByteBlockCipher32] test_gauntlet_ReverseMaskByteBlockCipher32 failed.");
            return;
        }
        
    }
}

- (void)test_fixed_32_A_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 00000000000000000000000000000000
    // bit1 00000000000000000000000000000000
    // bit2 00000000000000000000000000000000
    // bit3 00000000000000000000000000000000
    // bit4 00000000000000000000000000000000
    // bit5 00000000000000000000000000000000
    // bit6 00000000000000000000000000000000
    // bit7 00000000000000000000000000000000
    //
    // After Cipher:
    // bit0 00000000000000000000000000000000
    // bit1 00000000000000000000000000000000
    // bit2 00000000000000000000000000000000
    // bit3 00000000000000000000000000000000
    // bit4 00000000000000000000000000000000
    // bit5 00000000000000000000000000000000
    // bit6 00000000000000000000000000000000
    // bit7 00000000000000000000000000000000
    //
    // Avalanche:
    // bit0 ................................
    // bit1 ................................
    // bit2 ................................
    // bit3 ................................
    // bit4 ................................
    // bit5 ................................
    // bit6 ................................
    // bit7 ................................
    // Avalanche: 0.00%

    const std::uint8_t aOriginal[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    std::uint8_t aMaskByte = 0x64;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
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
                                                    "test_fixed_32_A_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_A_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_A_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_A_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_A_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_A_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_B_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 11111111111111111111111111111111
    // bit1 11111111111111111111111111111111
    // bit2 11111111111111111111111111111111
    // bit3 11111111111111111111111111111111
    // bit4 11111111111111111111111111111111
    // bit5 11111111111111111111111111111111
    // bit6 11111111111111111111111111111111
    // bit7 11111111111111111111111111111111
    //
    // After Cipher:
    // bit0 11111111111111111111111111111111
    // bit1 11111111111111111111111111111111
    // bit2 11111111111111111111111111111111
    // bit3 11111111111111111111111111111111
    // bit4 11111111111111111111111111111111
    // bit5 11111111111111111111111111111111
    // bit6 11111111111111111111111111111111
    // bit7 11111111111111111111111111111111
    //
    // Avalanche:
    // bit0 ................................
    // bit1 ................................
    // bit2 ................................
    // bit3 ................................
    // bit4 ................................
    // bit5 ................................
    // bit6 ................................
    // bit7 ................................
    // Avalanche: 0.00%

    const std::uint8_t aOriginal[32] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    std::uint8_t aMaskByte = 0x99;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
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
                                                    "test_fixed_32_B_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_B_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_B_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_B_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_B_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_B_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_C_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010
    // bit1 10101010101010101010101010101010
    // bit2 10101010101010101010101010101010
    // bit3 10101010101010101010101010101010
    // bit4 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101
    // bit6 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101
    //
    // After Cipher:
    // bit0 01010101010101010101010101010101
    // bit1 10101010101010101010101010101010
    // bit2 10101010101010101010101010101010
    // bit3 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010
    // bit5 01010101010101010101010101010101
    // bit6 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 ................................
    // bit2 ................................
    // bit3 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 ................................
    // bit6 ................................
    // bit7 ................................
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0x98;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97,
        0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_C_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_C_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_C_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_C_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_C_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_C_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_D_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010
    // bit1 10101010101010101010101010101010
    // bit2 01010101010101010101010101010101
    // bit3 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010
    // bit5 10101010101010101010101010101010
    // bit6 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010
    // bit1 10101010101010101010101010101010
    // bit2 10101010101010101010101010101010
    // bit3 10101010101010101010101010101010
    // bit4 01010101010101010101010101010101
    // bit5 10101010101010101010101010101010
    // bit6 10101010101010101010101010101010
    // bit7 10101010101010101010101010101010
    //
    // Avalanche:
    // bit0 ................................
    // bit1 ................................
    // bit2 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit3 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 ................................
    // bit6 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit7 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 62.50%

    const std::uint8_t aOriginal[32] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x3B;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xF7, 0x08, 0xF7, 0x08, 0xF7, 0x08, 0xF7, 0x08, 0xF7, 0x08, 0xF7, 0x08, 0xF7, 0x08, 0xF7, 0x08,
        0xF7, 0x08, 0xF7, 0x08, 0xF7, 0x08, 0xF7, 0x08, 0xF7, 0x08, 0xF7, 0x08, 0xF7, 0x08, 0xF7, 0x08
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_D_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_D_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_D_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_D_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_D_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_D_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_E_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010
    // bit1 10101010101010101010101010101010
    // bit2 01010101010101010101010101010101
    // bit3 01010101010101010101010101010101
    // bit4 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101
    // bit6 10101010101010101010101010101010
    // bit7 10101010101010101010101010101010
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010
    // bit1 10101010101010101010101010101010
    // bit2 01010101010101010101010101010101
    // bit3 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010
    // bit5 10101010101010101010101010101010
    // bit6 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101
    //
    // Avalanche:
    // bit0 ................................
    // bit1 ................................
    // bit2 ................................
    // bit3 ................................
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit6 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit7 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[32] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x0F;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_E_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_E_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_E_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_E_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_E_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_E_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_F_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010
    // bit1 01010101010101010101010101010101
    // bit2 10101010101010101010101010101010
    // bit3 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010
    // bit5 01010101010101010101010101010101
    // bit6 10101010101010101010101010101010
    // bit7 01010101010101010101010101010101
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010
    // bit1 10101010101010101010101010101010
    // bit2 10101010101010101010101010101010
    // bit3 10101010101010101010101010101010
    // bit4 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101
    // bit6 01010101010101010101010101010101
    // bit7 10101010101010101010101010101010
    //
    // Avalanche:
    // bit0 ................................
    // bit1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit2 ................................
    // bit3 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 ................................
    // bit6 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit7 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 62.50%

    const std::uint8_t aOriginal[32] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0x5B;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xF1, 0x0E, 0xF1, 0x0E, 0xF1, 0x0E, 0xF1, 0x0E, 0xF1, 0x0E, 0xF1, 0x0E, 0xF1, 0x0E, 0xF1, 0x0E,
        0xF1, 0x0E, 0xF1, 0x0E, 0xF1, 0x0E, 0xF1, 0x0E, 0xF1, 0x0E, 0xF1, 0x0E, 0xF1, 0x0E, 0xF1, 0x0E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_F_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_F_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_F_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_F_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_F_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_F_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_G_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010
    // bit1 10101001101010100110101010011010
    // bit2 10010110101001011010100101101010
    // bit3 10010101101001010110100101011010
    // bit4 01100110100110011010011001101001
    // bit5 01100101100110010110011001011001
    // bit6 01011010100101101010010110101001
    // bit7 01011001100101100110010110011001
    //
    // After Cipher:
    // bit0 01010101010101010101010101010101
    // bit1 10101001101010100110101010011010
    // bit2 01010110100101011010010101101001
    // bit3 01011010100101101010010110101001
    // bit4 01100110100110011010011001101001
    // bit5 10011010011001101001100110100110
    // bit6 10010101101001010110100101011010
    // bit7 01011001100101100110010110011001
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 ................................
    // bit2 XX........XX........XX........XX
    // bit3 XX..XXXX..XX..XXXX..XX..XXXX..XX
    // bit4 ................................
    // bit5 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit6 XX..XXXX..XX..XXXX..XX..XXXX..XX
    // bit7 ................................
    // Avalanche: 43.75%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0xB6;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0x46, 0xB9, 0x48, 0xB7, 0x55, 0xAA, 0x3C, 0xC3, 0x7B, 0x84, 0x46, 0xB9, 0x48, 0xB7, 0x55, 0xAA,
        0x3C, 0xC3, 0x7B, 0x84, 0x46, 0xB9, 0x48, 0xB7, 0x55, 0xAA, 0x3C, 0xC3, 0x7B, 0x84, 0x46, 0xB9
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_G_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_G_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_G_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_G_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_G_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_G_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_H_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 01010101010101010101010101010101
    // bit1 01100101010110010101011001010101
    // bit2 01011010010101101001010110100101
    // bit3 01101010010110101001011010100101
    // bit4 01011001100101100110010110011001
    // bit5 01101001100110100110011010011001
    // bit6 01010110100101011010010101101001
    // bit7 01100110100110011010011001101001
    //
    // After Cipher:
    // bit0 01010101010101010101010101010101
    // bit1 10101010011010101001101010100110
    // bit2 10100101101010010110101001011010
    // bit3 10100101011010010101101001010110
    // bit4 01011001100101100110010110011001
    // bit5 10011001011001100101100110010110
    // bit6 01010110100101011010010101101001
    // bit7 10010110011001011001100101100110
    //
    // Avalanche:
    // bit0 ................................
    // bit1 XX..XXXX..XX..XXXX..XX..XXXX..XX
    // bit2 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit3 XX..XXXX..XX..XXXX..XX..XXXX..XX
    // bit4 ................................
    // bit5 XXXX....XXXXXX....XXXXXX....XXXX
    // bit6 ................................
    // bit7 XXXX....XXXXXX....XXXXXX....XXXX
    // Avalanche: 43.75%

    const std::uint8_t aOriginal[32] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF
    };

    std::uint8_t aMaskByte = 0x75;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0x75, 0x8A, 0x70, 0x8F, 0x4C, 0xB3, 0x43, 0xBC, 0x2A, 0xD5, 0x75, 0x8A, 0x70, 0x8F, 0x4C, 0xB3,
        0x43, 0xBC, 0x2A, 0xD5, 0x75, 0x8A, 0x70, 0x8F, 0x4C, 0xB3, 0x43, 0xBC, 0x2A, 0xD5, 0x75, 0x8A
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_H_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_H_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_H_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_H_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_H_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_H_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_I_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010
    // bit1 10001010111000101011100010101110
    // bit2 11100110001110011000111001100011
    // bit3 11000110011100011001110001100111
    // bit4 00101111000010111100001011110000
    // bit5 00001111010000111101000011110100
    // bit6 01100011100110001110011000111001
    // bit7 01000011110100001111010000111101
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010
    // bit1 10001010111000101011100010101110
    // bit2 11000110011100011001110001100111
    // bit3 11100110001110011000111001100011
    // bit4 00101111000010111100001011110000
    // bit5 00101111000010111100001011110000
    // bit6 01100011100110001110011000111001
    // bit7 01000011110100001111010000111101
    //
    // Avalanche:
    // bit0 ................................
    // bit1 ................................
    // bit2 ..X......X..X......X..X......X..
    // bit3 ..X......X..X......X..X......X..
    // bit4 ................................
    // bit5 ..X......X..X......X..X......X..
    // bit6 ................................
    // bit7 ................................
    // Avalanche: 7.03%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33
    };

    std::uint8_t aMaskByte = 0x34;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xF0, 0x33, 0x9E, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x61, 0xF0, 0x33, 0x9E, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x61, 0xF0, 0x33, 0x9E, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x61, 0xF0, 0x33
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_I_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_I_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_I_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_I_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_I_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_I_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_J_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010
    // bit1 11111111111111111111111111111111
    // bit2 00000000000000000000000000000000
    // bit3 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010
    // bit5 11111111111111111111111111111111
    // bit6 00000000000000000000000000000000
    // bit7 01010101010101010101010101010101
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010
    // bit1 11111111111111111111111111111111
    // bit2 00000000000000000000000000000000
    // bit3 10101010101010101010101010101010
    // bit4 01010101010101010101010101010101
    // bit5 11111111111111111111111111111111
    // bit6 00000000000000000000000000000000
    // bit7 10101010101010101010101010101010
    //
    // Avalanche:
    // bit0 ................................
    // bit1 ................................
    // bit2 ................................
    // bit3 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 ................................
    // bit6 ................................
    // bit7 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[32] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    std::uint8_t aMaskByte = 0x5B;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xD5, 0x4C, 0xD5, 0x4C, 0xD5, 0x4C, 0xD5, 0x4C, 0xD5, 0x4C, 0xD5, 0x4C, 0xD5, 0x4C, 0xD5, 0x4C,
        0xD5, 0x4C, 0xD5, 0x4C, 0xD5, 0x4C, 0xD5, 0x4C, 0xD5, 0x4C, 0xD5, 0x4C, 0xD5, 0x4C, 0xD5, 0x4C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_J_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_J_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_J_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_J_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_J_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_J_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_K_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010
    // bit1 10101010101010101010101001010101
    // bit2 10101010010101010101010110101010
    // bit3 10101010010101010101010101010101
    // bit4 01010101101010100101010110101010
    // bit5 01010101101010100101010101010101
    // bit6 01010101010101011010101010101010
    // bit7 01010101010101011010101001010101
    //
    // After Cipher:
    // bit0 01010101010101010101010101010101
    // bit1 10101010010101010101010101010101
    // bit2 10101010010101010101010110101010
    // bit3 10101010010101010101010101010101
    // bit4 01010101101010100101010110101010
    // bit5 10101010101010100101010110101010
    // bit6 01010101010101011010101010101010
    // bit7 01010101010101011010101001010101
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 ........XXXXXXXXXXXXXXXX........
    // bit2 ................................
    // bit3 ................................
    // bit4 ................................
    // bit5 XXXXXXXX................XXXXXXXX
    // bit6 ................................
    // bit7 ................................
    // Avalanche: 25.00%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0xC4;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0x74, 0x8B, 0x74, 0x8B, 0x74, 0x8B, 0x74, 0x8B, 0x0C, 0xF3, 0x0C, 0xF3, 0x0C, 0xF3, 0x0C, 0xF3,
        0x03, 0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x2E, 0xD1, 0x2E, 0xD1, 0x2E, 0xD1, 0x2E, 0xD1
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_K_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_K_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_K_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_K_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_K_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_K_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_L_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10000101111010000101111010000101
    // bit1 10000101010101010101111010000000
    // bit2 10101010101010000101010101111111
    // bit3 10101010000101010101010101111010
    // bit4 01010000101010000000101010101111
    // bit5 01010000000101010000101010101010
    // bit6 01111111111010000000000101010101
    // bit7 01111111010101010000000101010000
    //
    // After Cipher:
    // bit0 10100001011110100001011110100001
    // bit1 00000001011110101010101010100001
    // bit2 10101010101010000101010101111111
    // bit3 10101010000101010101010101111010
    // bit4 01010000101010000000101010101111
    // bit5 01010101010100001010100000001010
    // bit6 10101010100000000001011111111110
    // bit7 00001010100000001010101011111110
    //
    // Avalanche:
    // bit0 ..X..X..X..X..X..X..X..X..X..X..
    // bit1 X....X....X.XXXXXXXX.X....X....X
    // bit2 ................................
    // bit3 ................................
    // bit4 ................................
    // bit5 .....X.X.X...X.XX.X...X.X.X.....
    // bit6 XX.X.X.X.XX.X......X.XX.X.X.X.XX
    // bit7 .XXX.X.XXX.X.X.XX.X.X.XXX.X.XXX.
    // Avalanche: 27.34%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA
    };

    std::uint8_t aMaskByte = 0xC7;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xB2, 0x0C, 0xB2, 0x0C, 0x33, 0x04, 0x33, 0xC4, 0x2B, 0xC4, 0xE8, 0xD4, 0xE8, 0x10, 0xC0, 0x10,
        0x45, 0x30, 0x45, 0xB2, 0x4D, 0xB2, 0xCB, 0xB2, 0xCB, 0x33, 0xFB, 0x33, 0x3F, 0x2B, 0x3F, 0xE8
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_L_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_L_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_L_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_L_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_L_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_32_L_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_A_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit1 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit2 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit3 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit4 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit5 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit6 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit7 00000000000000000000000000000000 | 00000000000000000000000000000000
    //
    // After Cipher:
    // bit0 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit1 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit2 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit3 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit4 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit5 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit6 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit7 00000000000000000000000000000000 | 00000000000000000000000000000000
    //
    // Avalanche:
    // bit0 ................................ | ................................
    // bit1 ................................ | ................................
    // bit2 ................................ | ................................
    // bit3 ................................ | ................................
    // bit4 ................................ | ................................
    // bit5 ................................ | ................................
    // bit6 ................................ | ................................
    // bit7 ................................ | ................................
    // Avalanche: 0.00%

    const std::uint8_t aOriginal[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    std::uint8_t aMaskByte = 0x54;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

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
                                                    "test_fixed_64_A_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_A_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_A_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_A_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_A_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_A_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_B_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit1 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit2 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit3 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit4 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit5 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit6 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit7 11111111111111111111111111111111 | 11111111111111111111111111111111
    //
    // After Cipher:
    // bit0 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit1 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit2 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit3 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit4 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit5 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit6 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit7 11111111111111111111111111111111 | 11111111111111111111111111111111
    //
    // Avalanche:
    // bit0 ................................ | ................................
    // bit1 ................................ | ................................
    // bit2 ................................ | ................................
    // bit3 ................................ | ................................
    // bit4 ................................ | ................................
    // bit5 ................................ | ................................
    // bit6 ................................ | ................................
    // bit7 ................................ | ................................
    // Avalanche: 0.00%

    const std::uint8_t aOriginal[64] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    std::uint8_t aMaskByte = 0xA1;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

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
                                                    "test_fixed_64_B_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_B_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_B_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_B_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_B_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_B_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_C_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit3 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 10101010101010101010101010101010 | 10101010101010101010101010101010
    //
    // Avalanche:
    // bit0 ................................ | ................................
    // bit1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit2 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit3 ................................ | ................................
    // bit4 ................................ | ................................
    // bit5 ................................ | ................................
    // bit6 ................................ | ................................
    // bit7 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0x61;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E,
        0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E,
        0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E,
        0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E, 0x91, 0x6E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_C_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_C_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_C_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_C_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_C_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_C_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_D_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // Avalanche:
    // bit0 ................................ | ................................
    // bit1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit2 ................................ | ................................
    // bit3 ................................ | ................................
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit6 ................................ | ................................
    // bit7 ................................ | ................................
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[64] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x4C;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F,
        0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F,
        0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F,
        0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_D_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_D_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_D_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_D_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_D_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_D_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_E_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit7 10101010101010101010101010101010 | 10101010101010101010101010101010
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // Avalanche:
    // bit0 ................................ | ................................
    // bit1 ................................ | ................................
    // bit2 ................................ | ................................
    // bit3 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 ................................ | ................................
    // bit5 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit6 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit7 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[64] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x17;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B,
        0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B,
        0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B,
        0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_E_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_E_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_E_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_E_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_E_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_E_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_F_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit2 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // After Cipher:
    // bit0 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit7 10101010101010101010101010101010 | 10101010101010101010101010101010
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit2 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit3 ................................ | ................................
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 ................................ | ................................
    // bit6 ................................ | ................................
    // bit7 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 62.50%

    const std::uint8_t aOriginal[64] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0xE9;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC,
        0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC,
        0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC,
        0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_F_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_F_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_F_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_F_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_F_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_F_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_G_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101001101010100110101010011010 | 10100110101010011010101001101010
    // bit2 10010110101001011010100101101010 | 01011010100101101010010110101001
    // bit3 10010101101001010110100101011010 | 01010110100101011010010101101001
    // bit4 01100110100110011010011001101001 | 10011010011001101001100110100110
    // bit5 01100101100110010110011001011001 | 10010110011001011001100101100110
    // bit6 01011010100101101010010110101001 | 01101010010110101001011010100101
    // bit7 01011001100101100110010110011001 | 01100110010110011001011001100101
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 01011001010101100101010110010101 | 01010110010101011001010101100101
    // bit2 01010110100101011010010101101001 | 10010101101001010110100101011010
    // bit3 01011010100101101010010110101001 | 10010110101001011010100101101010
    // bit4 10010110011001011001100101100110 | 01100101100110010110011001011001
    // bit5 01100101100110010110011001011001 | 10010110011001011001100101100110
    // bit6 01011010100101101010010110101001 | 01101010010110101001011010100101
    // bit7 10011001101001100110100110011010 | 10100110011010011001101001100110
    //
    // Avalanche:
    // bit0 ................................ | ................................
    // bit1 XXXX....XXXXXX....XXXXXX....XXXX | XXXX....XXXXXX....XXXXXX....XXXX
    // bit2 XX........XX........XX........XX | XX..XXXX..XX..XXXX..XX..XXXX..XX
    // bit3 XX..XXXX..XX..XXXX..XX..XXXX..XX | XX........XX........XX........XX
    // bit4 XXXX....XXXXXX....XXXXXX....XXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 ................................ | ................................
    // bit6 ................................ | ................................
    // bit7 XX........XX........XX........XX | XX........XX........XX........XX
    // Avalanche: 32.03%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F,
        0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55,
        0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x79;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x89, 0x76, 0x84, 0x7B, 0xD3, 0x2C, 0xBA, 0x45, 0xB7, 0x48, 0x89, 0x76, 0x84, 0x7B, 0xD3, 0x2C,
        0xBA, 0x45, 0xB7, 0x48, 0x89, 0x76, 0x84, 0x7B, 0xD3, 0x2C, 0xBA, 0x45, 0xB7, 0x48, 0x89, 0x76,
        0xB5, 0x4A, 0x8B, 0x74, 0x82, 0x7D, 0xD7, 0x28, 0xB8, 0x47, 0xB5, 0x4A, 0x8B, 0x74, 0x82, 0x7D,
        0xD7, 0x28, 0xB8, 0x47, 0xB5, 0x4A, 0x8B, 0x74, 0x82, 0x7D, 0xD7, 0x28, 0xB8, 0x47, 0xB5, 0x4A
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_G_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_G_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_G_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_G_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_G_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_G_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_H_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit1 01100101010110010101011001010101 | 10010101011001010101100101010110
    // bit2 01011010010101101001010110100101 | 01101001010110100101011010010101
    // bit3 01101010010110101001011010100101 | 10101001011010100101101010010110
    // bit4 01011001100101100110010110011001 | 01100110010110011001011001100101
    // bit5 01101001100110100110011010011001 | 10100110011010011001101001100110
    // bit6 01010110100101011010010101101001 | 01011010010101101001010110100101
    // bit7 01100110100110011010011001101001 | 10011010011001101001100110100110
    //
    // After Cipher:
    // bit0 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit1 01100101010110010101011001010101 | 10010101011001010101100101010110
    // bit2 01011010010101101001010110100101 | 01101001010110100101011010010101
    // bit3 01101010010110101001011010100101 | 10101001011010100101101010010110
    // bit4 10011001101001100110100110011010 | 10100110011010011001101001100110
    // bit5 10011001011001100101100110010110 | 01100110010110011001011001100101
    // bit6 01010110100101011010010101101001 | 01011010010101101001010110100101
    // bit7 10010110011001011001100101100110 | 01100101100110010110011001011001
    //
    // Avalanche:
    // bit0 ................................ | ................................
    // bit1 ................................ | ................................
    // bit2 ................................ | ................................
    // bit3 ................................ | ................................
    // bit4 XX........XX........XX........XX | XX........XX........XX........XX
    // bit5 XXXX....XXXXXX....XXXXXX....XXXX | XX........XX........XX........XX
    // bit6 ................................ | ................................
    // bit7 XXXX....XXXXXX....XXXXXX....XXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 18.75%

    const std::uint8_t aOriginal[64] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF,
        0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC,
        0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA
    };

    std::uint8_t aMaskByte = 0x0D;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x0D, 0xF2, 0x50, 0xAF, 0x3C, 0xC3, 0x33, 0xCC, 0x0A, 0xF5, 0x0D, 0xF2, 0x50, 0xAF, 0x3C, 0xC3,
        0x33, 0xCC, 0x0A, 0xF5, 0x0D, 0xF2, 0x50, 0xAF, 0x3C, 0xC3, 0x33, 0xCC, 0x0A, 0xF5, 0x0D, 0xF2,
        0x58, 0xA7, 0x3D, 0xC2, 0x32, 0xCD, 0x0E, 0xF1, 0x01, 0xFE, 0x58, 0xA7, 0x3D, 0xC2, 0x32, 0xCD,
        0x0E, 0xF1, 0x01, 0xFE, 0x58, 0xA7, 0x3D, 0xC2, 0x32, 0xCD, 0x0E, 0xF1, 0x01, 0xFE, 0x58, 0xA7
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_H_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_H_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_H_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_H_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_H_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_H_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_I_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10001010111000101011100010101110 | 00101011100010101110001010111000
    // bit2 11100110001110011000111001100011 | 10011000111001100011100110001110
    // bit3 11000110011100011001110001100111 | 00011001110001100111000110011100
    // bit4 00101111000010111100001011110000 | 10111100001011110000101111000010
    // bit5 00001111010000111101000011110100 | 00111101000011110100001111010000
    // bit6 01100011100110001110011000111001 | 10001110011000111001100011100110
    // bit7 01000011110100001111010000111101 | 00001111010000111101000011110100
    //
    // After Cipher:
    // bit0 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit1 10001010111000101011100010101110 | 00101011100010101110001010111000
    // bit2 11000110011100011001110001100111 | 01110001100111000110011100011001
    // bit3 11000110011100011001110001100111 | 00011001110001100111000110011100
    // bit4 00101111000010111100001011110000 | 10111100001011110000101111000010
    // bit5 00101111000010111100001011110000 | 00001011110000101111000010111100
    // bit6 01100011100110001110011000111001 | 10001110011000111001100011100110
    // bit7 01000011110100001111010000111101 | 00001111010000111101000011110100
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 ................................ | ................................
    // bit2 ..X......X..X......X..X......X.. | XXX.X..X.XXXX.X..X.XXXX.X..X.XXX
    // bit3 ................................ | ................................
    // bit4 ................................ | ................................
    // bit5 ..X......X..X......X..X......X.. | ..XX.XX.XX..XX.XX.XX..XX.XX.XX..
    // bit6 ................................ | ................................
    // bit7 ................................ | ................................
    // Avalanche: 22.27%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33,
        0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F,
        0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00
    };

    std::uint8_t aMaskByte = 0xA4;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x70, 0xB3, 0x0E, 0x80, 0x4C, 0xBC, 0x7F, 0x8F, 0x43, 0xF1, 0x70, 0xB3, 0x0E, 0x80, 0x4C, 0xBC,
        0x7F, 0x8F, 0x43, 0xF1, 0x70, 0xB3, 0x0E, 0x80, 0x4C, 0xBC, 0x7F, 0x8F, 0x43, 0xF1, 0x70, 0xB3,
        0x0A, 0xA0, 0x68, 0xB8, 0x5F, 0x8B, 0x47, 0xF5, 0x74, 0x97, 0x0A, 0xA0, 0x68, 0xB8, 0x5F, 0x8B,
        0x47, 0xF5, 0x74, 0x97, 0x0A, 0xA0, 0x68, 0xB8, 0x5F, 0x8B, 0x47, 0xF5, 0x74, 0x97, 0x0A, 0xA0
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_I_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_I_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_I_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_I_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_I_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_I_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_J_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit2 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit6 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit2 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit3 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit6 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // Avalanche:
    // bit0 ................................ | ................................
    // bit1 ................................ | ................................
    // bit2 ................................ | ................................
    // bit3 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 ................................ | ................................
    // bit5 ................................ | ................................
    // bit6 ................................ | ................................
    // bit7 ................................ | ................................
    // Avalanche: 12.50%

    const std::uint8_t aOriginal[64] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    std::uint8_t aMaskByte = 0x54;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
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
                                                    "test_fixed_64_J_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_J_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_J_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_J_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_J_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_J_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_K_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101010101010101010101001010101 | 10101010101010101010101010101010
    // bit2 10101010010101010101010110101010 | 10101010101010100101010101010101
    // bit3 10101010010101010101010101010101 | 10101010101010100101010101010101
    // bit4 01010101101010100101010110101010 | 10101010010101011010101001010101
    // bit5 01010101101010100101010101010101 | 10101010010101011010101001010101
    // bit6 01010101010101011010101010101010 | 10101010010101010101010110101010
    // bit7 01010101010101011010101001010101 | 10101010010101010101010110101010
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101010010101010101010101010101 | 01010101010101010101010101010101
    // bit2 10101010010101010101010110101010 | 10101010101010100101010101010101
    // bit3 10101010101010101010101001010101 | 10101010101010100101010101010101
    // bit4 01010101101010100101010110101010 | 10101010010101011010101001010101
    // bit5 01010101101010100101010101010101 | 10101010010101011010101001010101
    // bit6 01010101010101011010101010101010 | 10101010010101010101010110101010
    // bit7 01010101010101011010101001010101 | 10101010010101010101010110101010
    //
    // Avalanche:
    // bit0 ................................ | ................................
    // bit1 ........XXXXXXXXXXXXXXXX........ | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit2 ................................ | ................................
    // bit3 ........XXXXXXXXXXXXXXXX........ | ................................
    // bit4 ................................ | ................................
    // bit5 ................................ | ................................
    // bit6 ................................ | ................................
    // bit7 ................................ | ................................
    // Avalanche: 12.50%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x58;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0x9C, 0x63, 0x9C, 0x63, 0x9C, 0x63, 0x9C, 0x63,
        0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F,
        0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x83, 0x7C, 0x83, 0x7C, 0x83, 0x7C, 0x83, 0x7C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_K_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_K_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_K_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_K_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_K_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_K_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_L_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10000101111010000101111010000101 | 11101000010111101000010111101000
    // bit1 10000101010101010101111010000000 | 10101000010111101010111111101000
    // bit2 10101010101010000101010101111111 | 11101000000000010101010111101010
    // bit3 10101010000101010101010101111010 | 10101000000000010111111111101010
    // bit4 01010000101010000000101010101111 | 11101010111101010101010101010101
    // bit5 01010000000101010000101010101010 | 10101010111101010111111101010101
    // bit6 01111111111010000000000101010101 | 11101010101010101000010101010111
    // bit7 01111111010101010000000101010000 | 10101010101010101010111101010111
    //
    // After Cipher:
    // bit0 10100001011110100001011110100001 | 00010111101000010111101000010111
    // bit1 10000101010101010101111010000000 | 10101000010111101010111111101000
    // bit2 11111110101010100001010101010101 | 01010111101010101000000000010111
    // bit3 01011110101010101010100001010101 | 01010111111111101000000000010101
    // bit4 11110101010100000001010100001010 | 10101010101010101010111101010111
    // bit5 01010000000101010000101010101010 | 10101010111101010111111101010101
    // bit6 10101010100000000001011111111110 | 11101010101000010101010101010111
    // bit7 01111111010101010000000101010000 | 10101010101010101010111101010111
    //
    // Avalanche:
    // bit0 ..X..X..X..X..X..X..X..X..X..X.. | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 ................................ | ................................
    // bit2 .X.X.X........X..X........X.X.X. | X.XXXXXXX.X.X.XXXX.X.X.XXXXXXX.X
    // bit3 XXXX.X..X.XXXXXXXXXXXX.X..X.XXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 X.X..X.XXXXXX......XXXXXX.X..X.X | .X.......X.XXXXXXXXXX.X.......X.
    // bit5 ................................ | ................................
    // bit6 XX.X.X.X.XX.X......X.XX.X.X.X.XX | ............X.XXXX.X............
    // bit7 ................................ | ................................
    // Avalanche: 35.94%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA,
        0xFF, 0xAA, 0xFF, 0x00, 0xFF, 0x00, 0x0F, 0x00, 0x0F, 0xCC, 0x0F, 0xCC, 0xC3, 0xCC, 0xC3, 0x3C,
        0xC3, 0x3C, 0x55, 0x3C, 0x55, 0xFF, 0x55, 0xFF, 0xF0, 0xFF, 0xF0, 0x0F, 0xF0, 0x0F, 0x33, 0x0F
    };

    std::uint8_t aMaskByte = 0xBA;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xEA, 0x3D, 0xAB, 0x3D, 0x33, 0x79, 0x33, 0xC9, 0x32, 0xC9, 0xB0, 0xCD, 0xB0, 0x45, 0xB0, 0x45,
        0x10, 0x40, 0x10, 0xEA, 0x54, 0xEA, 0xC6, 0xAB, 0xC6, 0x33, 0x86, 0x33, 0x0E, 0x32, 0x0E, 0xB0,
        0x4F, 0x32, 0x4F, 0xB0, 0x4F, 0xB0, 0xBF, 0xB0, 0xBF, 0x54, 0xBF, 0x54, 0x79, 0x54, 0x79, 0x86,
        0x79, 0x86, 0xCD, 0x86, 0xCD, 0x4F, 0xCD, 0x4F, 0x40, 0x4F, 0x40, 0xBF, 0x40, 0xBF, 0xAB, 0xBF
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_L_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_L_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_L_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_L_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_L_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_64_L_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_A_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit1 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit2 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit3 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit4 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit5 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit6 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit7 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    //
    // After Cipher:
    // bit0 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit1 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit2 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit3 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit4 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit5 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit6 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit7 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................
    // bit1 ................................ | ................................ | ................................
    // bit2 ................................ | ................................ | ................................
    // bit3 ................................ | ................................ | ................................
    // bit4 ................................ | ................................ | ................................
    // bit5 ................................ | ................................ | ................................
    // bit6 ................................ | ................................ | ................................
    // bit7 ................................ | ................................ | ................................
    // Avalanche: 0.00%

    const std::uint8_t aOriginal[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    std::uint8_t aMaskByte = 0x1F;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
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
                                                    "test_fixed_96_A_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_A_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_A_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_A_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_A_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_A_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_B_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit1 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit2 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit3 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit4 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit5 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit6 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit7 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    //
    // After Cipher:
    // bit0 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit1 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit2 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit3 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit4 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit5 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit6 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit7 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................
    // bit1 ................................ | ................................ | ................................
    // bit2 ................................ | ................................ | ................................
    // bit3 ................................ | ................................ | ................................
    // bit4 ................................ | ................................ | ................................
    // bit5 ................................ | ................................ | ................................
    // bit6 ................................ | ................................ | ................................
    // bit7 ................................ | ................................ | ................................
    // Avalanche: 0.00%

    const std::uint8_t aOriginal[96] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    std::uint8_t aMaskByte = 0x0F;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
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
                                                    "test_fixed_96_B_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_B_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_B_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_B_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_B_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_B_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_C_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit3 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit7 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................
    // bit1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit2 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit3 ................................ | ................................ | ................................
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 ................................ | ................................ | ................................
    // bit6 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit7 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 62.50%

    const std::uint8_t aOriginal[96] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0x6B;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64,
        0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64,
        0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64,
        0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64,
        0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64,
        0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_C_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_C_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_C_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_C_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_C_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_C_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_D_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit6 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................
    // bit1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit2 ................................ | ................................ | ................................
    // bit3 ................................ | ................................ | ................................
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 ................................ | ................................ | ................................
    // bit6 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit7 ................................ | ................................ | ................................
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[96] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x4A;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79,
        0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79,
        0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79,
        0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79,
        0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79,
        0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_D_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_D_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_D_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_D_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_D_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_D_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_E_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit7 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................
    // bit1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit2 ................................ | ................................ | ................................
    // bit3 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 ................................ | ................................ | ................................
    // bit6 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit7 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 62.50%

    const std::uint8_t aOriginal[96] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x5B;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67,
        0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67,
        0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67,
        0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67,
        0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67,
        0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_E_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_E_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_E_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_E_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_E_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_E_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_F_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit2 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // After Cipher:
    // bit0 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit2 ................................ | ................................ | ................................
    // bit3 ................................ | ................................ | ................................
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 ................................ | ................................ | ................................
    // bit6 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit7 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 62.50%

    const std::uint8_t aOriginal[96] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0xCB;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E,
        0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E,
        0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E,
        0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E,
        0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E,
        0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_F_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_F_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_F_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_F_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_F_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_F_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_G_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101001101010100110101010011010 | 10100110101010011010101001101010 | 10011010101001101010100110101010
    // bit2 10010110101001011010100101101010 | 01011010100101101010010110101001 | 01101010010110101001011010100101
    // bit3 10010101101001010110100101011010 | 01010110100101011010010101101001 | 01011010010101101001010110100101
    // bit4 01100110100110011010011001101001 | 10011010011001101001100110100110 | 01101001100110100110011010011001
    // bit5 01100101100110010110011001011001 | 10010110011001011001100101100110 | 01011001100101100110010110011001
    // bit6 01011010100101101010010110101001 | 01101010010110101001011010100101 | 10101001011010100101101010010110
    // bit7 01011001100101100110010110011001 | 01100110010110011001011001100101 | 10011001011001100101100110010110
    //
    // After Cipher:
    // bit0 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit1 10101001101010100110101010011010 | 10100110101010011010101001101010 | 10011010101001101010100110101010
    // bit2 10010110101001011010100101101010 | 01011010100101101010010110101001 | 01101010010110101001011010100101
    // bit3 10010101101001010110100101011010 | 01010110100101011010010101101001 | 01011010010101101001010110100101
    // bit4 01100110100110011010011001101001 | 10011010011001101001100110100110 | 01101001100110100110011010011001
    // bit5 01100101100110010110011001011001 | 10010110011001011001100101100110 | 01011001100101100110010110011001
    // bit6 10010101101001010110100101011010 | 10100101011010010101101001010110 | 01101001010110100101011010010101
    // bit7 10011001101001100110100110011010 | 10100110011010011001101001100110 | 01101001100110100110011010011001
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 ................................ | ................................ | ................................
    // bit2 ................................ | ................................ | ................................
    // bit3 ................................ | ................................ | ................................
    // bit4 ................................ | ................................ | ................................
    // bit5 ................................ | ................................ | ................................
    // bit6 XX..XXXX..XX..XXXX..XX..XXXX..XX | XX..XXXX..XX..XXXX..XX..XXXX..XX | XX........XX........XX........XX
    // bit7 XX........XX........XX........XX | XX........XX........XX........XX | XXXX....XXXXXX....XXXXXX....XXXX
    // Avalanche: 23.44%

    const std::uint8_t aOriginal[96] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F,
        0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55,
        0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33,
        0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00,
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x83;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0x73, 0x8C, 0x4C, 0xB3, 0x41, 0xBE, 0x28, 0xD7, 0x7F, 0x80, 0x73, 0x8C, 0x4C, 0xB3, 0x41, 0xBE,
        0x28, 0xD7, 0x7F, 0x80, 0x73, 0x8C, 0x4C, 0xB3, 0x41, 0xBE, 0x28, 0xD7, 0x7F, 0x80, 0x73, 0x8C,
        0x4F, 0xB0, 0x43, 0xBC, 0x28, 0xD7, 0x7D, 0x82, 0x70, 0x8F, 0x4F, 0xB0, 0x43, 0xBC, 0x28, 0xD7,
        0x7D, 0x82, 0x70, 0x8F, 0x4F, 0xB0, 0x43, 0xBC, 0x28, 0xD7, 0x7D, 0x82, 0x70, 0x8F, 0x4F, 0xB0,
        0x40, 0xBF, 0x2B, 0xD4, 0x7F, 0x80, 0x70, 0x8F, 0x4D, 0xB2, 0x40, 0xBF, 0x2B, 0xD4, 0x7F, 0x80,
        0x70, 0x8F, 0x4D, 0xB2, 0x40, 0xBF, 0x2B, 0xD4, 0x7F, 0x80, 0x70, 0x8F, 0x4D, 0xB2, 0x40, 0xBF
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_G_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_G_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_G_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_G_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_G_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_G_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_H_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit1 01100101010110010101011001010101 | 10010101011001010101100101010110 | 01010101100101010110010101011001
    // bit2 01011010010101101001010110100101 | 01101001010110100101011010010101 | 10100101011010010101101001010110
    // bit3 01101010010110101001011010100101 | 10101001011010100101101010010110 | 10100101101010010110101001011010
    // bit4 01011001100101100110010110011001 | 01100110010110011001011001100101 | 10011001011001100101100110010110
    // bit5 01101001100110100110011010011001 | 10100110011010011001101001100110 | 10011001101001100110100110011010
    // bit6 01010110100101011010010101101001 | 01011010010101101001010110100101 | 01101001010110100101011010010101
    // bit7 01100110100110011010011001101001 | 10011010011001101001100110100110 | 01101001100110100110011010011001
    //
    // After Cipher:
    // bit0 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit1 01100101010110010101011001010101 | 10010101011001010101100101010110 | 01010101100101010110010101011001
    // bit2 10100101101010010110101001011010 | 10101001011010100101101010010110 | 01101010010110101001011010100101
    // bit3 10100101011010010101101001010110 | 01101001010110100101011010010101 | 01011010010101101001010110100101
    // bit4 01011001100101100110010110011001 | 01100110010110011001011001100101 | 10011001011001100101100110010110
    // bit5 10011001011001100101100110010110 | 01100110010110011001011001100101 | 01011001100101100110010110011001
    // bit6 01010110100101011010010101101001 | 01011010010101101001010110100101 | 01101001010110100101011010010101
    // bit7 01100110100110011010011001101001 | 10011010011001101001100110100110 | 01101001100110100110011010011001
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................
    // bit1 ................................ | ................................ | ................................
    // bit2 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XX........XX........XX........XX | XX..XXXX..XX..XXXX..XX..XXXX..XX
    // bit3 XX..XXXX..XX..XXXX..XX..XXXX..XX | XX........XX........XX........XX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 ................................ | ................................ | ................................
    // bit5 XXXX....XXXXXX....XXXXXX....XXXX | XX........XX........XX........XX | XX........XX........XX........XX
    // bit6 ................................ | ................................ | ................................
    // bit7 ................................ | ................................ | ................................
    // Avalanche: 20.31%

    const std::uint8_t aOriginal[96] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF,
        0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC,
        0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA,
        0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0,
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3
    };

    std::uint8_t aMaskByte = 0x34;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0x34, 0xCB, 0x71, 0x8E, 0x0C, 0xF3, 0x03, 0xFC, 0x2B, 0xD4, 0x34, 0xCB, 0x71, 0x8E, 0x0C, 0xF3,
        0x03, 0xFC, 0x2B, 0xD4, 0x34, 0xCB, 0x71, 0x8E, 0x0C, 0xF3, 0x03, 0xFC, 0x2B, 0xD4, 0x34, 0xCB,
        0x61, 0x9E, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x61, 0x9E, 0x3C, 0xC3, 0x33, 0xCC,
        0x0F, 0xF0, 0x00, 0xFF, 0x61, 0x9E, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x61, 0x9E,
        0x08, 0xF7, 0x23, 0xDC, 0x3F, 0xC0, 0x30, 0xCF, 0x45, 0xBA, 0x08, 0xF7, 0x23, 0xDC, 0x3F, 0xC0,
        0x30, 0xCF, 0x45, 0xBA, 0x08, 0xF7, 0x23, 0xDC, 0x3F, 0xC0, 0x30, 0xCF, 0x45, 0xBA, 0x08, 0xF7
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_H_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_H_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_H_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_H_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_H_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_H_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_I_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10001010111000101011100010101110 | 00101011100010101110001010111000 | 10101110001010111000101011100010
    // bit2 11100110001110011000111001100011 | 10011000111001100011100110001110 | 01100011100110001110011000111001
    // bit3 11000110011100011001110001100111 | 00011001110001100111000110011100 | 01100111000110011100011001110001
    // bit4 00101111000010111100001011110000 | 10111100001011110000101111000010 | 11110000101111000010111100001011
    // bit5 00001111010000111101000011110100 | 00111101000011110100001111010000 | 11110100001111010000111101000011
    // bit6 01100011100110001110011000111001 | 10001110011000111001100011100110 | 00111001100011100110001110011000
    // bit7 01000011110100001111010000111101 | 00001111010000111101000011110100 | 00111101000011110100001111010000
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10001010111000101011100010101110 | 00101011100010101110001010111000 | 10101110001010111000101011100010
    // bit2 11000110011100011001110001100111 | 01110001100111000110011100011001 | 10011100011001110001100111000110
    // bit3 11100110001110011000111001100011 | 00111001100011100110001110011000 | 10001110011000111001100011100110
    // bit4 00101111000010111100001011110000 | 10111100001011110000101111000010 | 11110000101111000010111100001011
    // bit5 00001111010000111101000011110100 | 00111101000011110100001111010000 | 11110100001111010000111101000011
    // bit6 10011100011001110001100111000110 | 01100111000110011100011001110001 | 00011001110001100111000110011100
    // bit7 01000011110100001111010000111101 | 00001111010000111101000011110100 | 00111101000011110100001111010000
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................
    // bit1 ................................ | ................................ | ................................
    // bit2 ..X......X..X......X..X......X.. | XXX.X..X.XXXX.X..X.XXXX.X..X.XXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit3 ..X......X..X......X..X......X.. | ..X......X..X......X..X......X.. | XXX.X..X.XXXX.X..X.XXXX.X..X.XXX
    // bit4 ................................ | ................................ | ................................
    // bit5 ................................ | ................................ | ................................
    // bit6 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXX.X..X.XXXX.X..X.XXXX.X..X.XXX | ..X......X..X......X..X......X..
    // bit7 ................................ | ................................ | ................................
    // Avalanche: 19.27%

    const std::uint8_t aOriginal[96] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33,
        0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F,
        0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00,
        0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55,
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C
    };

    std::uint8_t aMaskByte = 0x32;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0xF2, 0x31, 0x98, 0x02, 0xCE, 0x3E, 0xFD, 0x0D, 0xC1, 0x67, 0xF2, 0x31, 0x98, 0x02, 0xCE, 0x3E,
        0xFD, 0x0D, 0xC1, 0x67, 0xF2, 0x31, 0x98, 0x02, 0xCE, 0x3E, 0xFD, 0x0D, 0xC1, 0x67, 0xF2, 0x31,
        0x88, 0x22, 0xFE, 0x3C, 0xDD, 0x0F, 0xC3, 0x77, 0xF0, 0x01, 0x88, 0x22, 0xFE, 0x3C, 0xDD, 0x0F,
        0xC3, 0x77, 0xF0, 0x01, 0x88, 0x22, 0xFE, 0x3C, 0xDD, 0x0F, 0xC3, 0x77, 0xF0, 0x01, 0x88, 0x22,
        0xFC, 0x0C, 0xCD, 0x2F, 0xF3, 0x75, 0xD0, 0x03, 0x8A, 0x32, 0xFC, 0x0C, 0xCD, 0x2F, 0xF3, 0x75,
        0xD0, 0x03, 0x8A, 0x32, 0xFC, 0x0C, 0xCD, 0x2F, 0xF3, 0x75, 0xD0, 0x03, 0x8A, 0x32, 0xFC, 0x0C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_I_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_I_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_I_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_I_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_I_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_I_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_J_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit2 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit6 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // After Cipher:
    // bit0 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit1 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit2 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit3 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit6 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit7 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 ................................ | ................................ | ................................
    // bit2 ................................ | ................................ | ................................
    // bit3 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 ................................ | ................................ | ................................
    // bit6 ................................ | ................................ | ................................
    // bit7 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[96] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    std::uint8_t aMaskByte = 0x9B;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC,
        0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC,
        0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC,
        0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC,
        0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC,
        0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_J_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_J_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_J_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_J_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_J_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_J_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_K_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101010101010101010101001010101 | 10101010101010101010101010101010 | 01010101101010101010101010101010
    // bit2 10101010010101010101010110101010 | 10101010101010100101010101010101 | 10101010101010101010101001010101
    // bit3 10101010010101010101010101010101 | 10101010101010100101010101010101 | 01010101101010101010101001010101
    // bit4 01010101101010100101010110101010 | 10101010010101011010101001010101 | 10101010101010100101010110101010
    // bit5 01010101101010100101010101010101 | 10101010010101011010101001010101 | 01010101101010100101010110101010
    // bit6 01010101010101011010101010101010 | 10101010010101010101010110101010 | 10101010101010100101010101010101
    // bit7 01010101010101011010101001010101 | 10101010010101010101010110101010 | 01010101101010100101010101010101
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101010010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010110101010
    // bit2 10101010010101010101010110101010 | 10101010101010100101010101010101 | 10101010101010101010101001010101
    // bit3 10101010010101010101010101010101 | 10101010101010100101010101010101 | 01010101101010101010101001010101
    // bit4 01010101101010100101010110101010 | 10101010010101011010101001010101 | 01010101101010100101010101010101
    // bit5 10101010101010100101010110101010 | 10101010010101011010101001010101 | 01010101101010100101010110101010
    // bit6 01010101010101011010101010101010 | 01010101101010101010101001010101 | 10101010101010100101010101010101
    // bit7 10101010010101011010101010101010 | 01010101101010101010101001010101 | 10101010101010100101010110101010
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................
    // bit1 ........XXXXXXXXXXXXXXXX........ | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | ........XXXXXXXXXXXXXXXX........
    // bit2 ................................ | ................................ | ................................
    // bit3 ................................ | ................................ | ................................
    // bit4 ................................ | ................................ | XXXXXXXX................XXXXXXXX
    // bit5 XXXXXXXX................XXXXXXXX | ................................ | ................................
    // bit6 ................................ | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | ................................
    // bit7 XXXXXXXX................XXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXX................XXXXXXXX
    // Avalanche: 25.00%

    const std::uint8_t aOriginal[96] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x4F;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0xF5, 0x0A, 0xF5, 0x0A, 0xF5, 0x0A, 0xF5, 0x0A, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73,
        0x83, 0x7C, 0x83, 0x7C, 0x83, 0x7C, 0x83, 0x7C, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50,
        0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xBC, 0x43, 0xB3, 0x4C, 0xB3, 0x4C, 0xB3, 0x4C, 0xB3, 0x4C,
        0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F, 0x80, 0x7F,
        0xA3, 0x5C, 0xA3, 0x5C, 0xA3, 0x5C, 0xA3, 0x5C, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40,
        0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xC5, 0x3A, 0xC5, 0x3A, 0xC5, 0x3A, 0xC5, 0x3A
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_K_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_K_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_K_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_K_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_K_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_K_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_L_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10000101111010000101111010000101 | 11101000010111101000010111101000 | 01011110100001011110100001011110
    // bit1 10000101010101010101111010000000 | 10101000010111101010111111101000 | 01010101010101011110100000001010
    // bit2 10101010101010000101010101111111 | 11101000000000010101010111101010 | 10101010100001010101011111111110
    // bit3 10101010000101010101010101111010 | 10101000000000010111111111101010 | 10100001010101010101011110101010
    // bit4 01010000101010000000101010101111 | 11101010111101010101010101010101 | 00001010100000001010101011111110
    // bit5 01010000000101010000101010101010 | 10101010111101010111111101010101 | 00000001010100001010101010101010
    // bit6 01111111111010000000000101010101 | 11101010101010101000010101010111 | 11111110100000000001010101011110
    // bit7 01111111010101010000000101010000 | 10101010101010101010111101010111 | 11110101010100000001010100001010
    //
    // After Cipher:
    // bit0 10100001011110100001011110100001 | 00010111101000010111101000010111 | 01111010000101111010000101111010
    // bit1 10000101010101010101111010000000 | 10101000010111101010111111101000 | 01010101010101011110100000001010
    // bit2 11111110101010100001010101010101 | 01010111101010101000000000010111 | 01111111111010101010000101010101
    // bit3 01011110101010101010100001010101 | 01010111111111101000000000010101 | 01010101111010101010101010000101
    // bit4 11110101010100000001010100001010 | 10101010101010101010111101010111 | 01111111010101010000000101010000
    // bit5 01010101010100001010100000001010 | 10101010111111101010111101010101 | 01010101010101010000101010000000
    // bit6 01111111111010000000000101010101 | 11101010101010101000010101010111 | 11111110100000000001010101011110
    // bit7 01111111010101010000000101010000 | 10101010101010101010111101010111 | 11110101010100000001010100001010
    //
    // Avalanche:
    // bit0 ..X..X..X..X..X..X..X..X..X..X.. | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | ..X..X..X..X..X..X..X..X..X..X..
    // bit1 ................................ | ................................ | ................................
    // bit2 .X.X.X........X..X........X.X.X. | X.XXXXXXX.X.X.XXXX.X.X.XXXXXXX.X | XX.X.X.X.XX.XXXXXXXX.XX.X.X.X.XX
    // bit3 XXXX.X..X.XXXXXXXXXXXX.X..X.XXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXX.X..X.XXXXXXXXXXXX.X..X.XXXX
    // bit4 X.X..X.XXXXXX......XXXXXX.X..X.X | .X.......X.XXXXXXXXXX.X.......X. | .XXX.X.XXX.X.X.XX.X.X.XXX.X.XXX.
    // bit5 .....X.X.X...X.XX.X...X.X.X..... | ............X.XXXX.X............ | .X.X.X.......X.XX.X.......X.X.X.
    // bit6 ................................ | ................................ | ................................
    // bit7 ................................ | ................................ | ................................
    // Avalanche: 34.38%

    const std::uint8_t aOriginal[96] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA,
        0xFF, 0xAA, 0xFF, 0x00, 0xFF, 0x00, 0x0F, 0x00, 0x0F, 0xCC, 0x0F, 0xCC, 0xC3, 0xCC, 0xC3, 0x3C,
        0xC3, 0x3C, 0x55, 0x3C, 0x55, 0xFF, 0x55, 0xFF, 0xF0, 0xFF, 0xF0, 0x0F, 0xF0, 0x0F, 0x33, 0x0F,
        0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55, 0x00, 0xF0, 0x00, 0xF0,
        0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA, 0xFF, 0xAA, 0xFF, 0x00
    };

    std::uint8_t aMaskByte = 0xBC;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0xE8, 0x3F, 0xAB, 0x3F, 0x33, 0x7F, 0x33, 0xCF, 0x32, 0xCF, 0xB2, 0xCD, 0xB2, 0x41, 0xB0, 0x41,
        0x14, 0x40, 0x14, 0xE8, 0x54, 0xE8, 0xC0, 0xAB, 0xC0, 0x33, 0x80, 0x33, 0x0C, 0x32, 0x0C, 0xB2,
        0x4F, 0x32, 0x4F, 0xB0, 0x4F, 0xB0, 0xBF, 0xB0, 0xBF, 0x54, 0xBF, 0x54, 0x7F, 0x54, 0x7F, 0x80,
        0x7F, 0x80, 0xCD, 0x80, 0xCD, 0x4F, 0xCD, 0x4F, 0x40, 0x4F, 0x40, 0xBF, 0x40, 0xBF, 0xAB, 0xBF,
        0x03, 0xFF, 0xAB, 0xFF, 0xAA, 0x7F, 0xAA, 0x7D, 0x32, 0x7D, 0x30, 0xCD, 0x30, 0xCC, 0xB0, 0xCC,
        0xF0, 0x40, 0xF0, 0x03, 0x54, 0x03, 0x14, 0xAB, 0x14, 0xAA, 0x80, 0xAA, 0xC3, 0x32, 0xC3, 0x30
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_L_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_L_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_L_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_L_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_L_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_96_L_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_A_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit1 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit2 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit3 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit4 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit5 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit6 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit7 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    //
    // After Cipher:
    // bit0 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit1 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit2 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit3 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit4 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit5 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit6 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit7 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................ | ................................
    // bit1 ................................ | ................................ | ................................ | ................................
    // bit2 ................................ | ................................ | ................................ | ................................
    // bit3 ................................ | ................................ | ................................ | ................................
    // bit4 ................................ | ................................ | ................................ | ................................
    // bit5 ................................ | ................................ | ................................ | ................................
    // bit6 ................................ | ................................ | ................................ | ................................
    // bit7 ................................ | ................................ | ................................ | ................................
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

    std::uint8_t aMaskByte = 0x2A;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

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
                                                    "test_fixed_128_A_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_A_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_A_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_A_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_A_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_A_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_B_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit1 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit2 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit3 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit4 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit5 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit6 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit7 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    //
    // After Cipher:
    // bit0 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit1 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit2 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit3 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit4 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit5 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit6 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit7 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................ | ................................
    // bit1 ................................ | ................................ | ................................ | ................................
    // bit2 ................................ | ................................ | ................................ | ................................
    // bit3 ................................ | ................................ | ................................ | ................................
    // bit4 ................................ | ................................ | ................................ | ................................
    // bit5 ................................ | ................................ | ................................ | ................................
    // bit6 ................................ | ................................ | ................................ | ................................
    // bit7 ................................ | ................................ | ................................ | ................................
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

    std::uint8_t aMaskByte = 0x75;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

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
                                                    "test_fixed_128_B_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_B_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_B_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_B_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_B_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_B_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_C_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit3 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // After Cipher:
    // bit0 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 ................................ | ................................ | ................................ | ................................
    // bit2 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit3 ................................ | ................................ | ................................ | ................................
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit6 ................................ | ................................ | ................................ | ................................
    // bit7 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 62.50%

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

    std::uint8_t aMaskByte = 0xAD;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2,
        0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2,
        0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2,
        0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2,
        0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2,
        0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2,
        0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2,
        0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_C_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_C_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_C_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_C_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_C_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_C_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_D_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit2 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit3 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................ | ................................
    // bit1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit2 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit3 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit6 ................................ | ................................ | ................................ | ................................
    // bit7 ................................ | ................................ | ................................ | ................................
    // Avalanche: 62.50%

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

    std::uint8_t aMaskByte = 0x7C;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F,
        0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F,
        0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F,
        0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F,
        0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F,
        0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F,
        0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F,
        0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_D_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_D_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_D_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_D_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_D_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_D_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_E_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit7 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit6 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................ | ................................
    // bit1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit2 ................................ | ................................ | ................................ | ................................
    // bit3 ................................ | ................................ | ................................ | ................................
    // bit4 ................................ | ................................ | ................................ | ................................
    // bit5 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit6 ................................ | ................................ | ................................ | ................................
    // bit7 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 37.50%

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

    std::uint8_t aMaskByte = 0x45;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79,
        0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79,
        0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79,
        0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79,
        0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79,
        0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79,
        0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79,
        0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_E_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_E_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_E_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_E_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_E_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_E_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_F_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit2 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit2 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit3 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit6 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................ | ................................
    // bit1 ................................ | ................................ | ................................ | ................................
    // bit2 ................................ | ................................ | ................................ | ................................
    // bit3 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit6 ................................ | ................................ | ................................ | ................................
    // bit7 ................................ | ................................ | ................................ | ................................
    // Avalanche: 37.50%

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

    std::uint8_t aMaskByte = 0x1C;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49,
        0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49,
        0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49,
        0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49,
        0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49,
        0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49,
        0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49,
        0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_F_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_F_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_F_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_F_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_F_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_F_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_G_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101001101010100110101010011010 | 10100110101010011010101001101010 | 10011010101001101010100110101010 | 01101010100110101010011010101001
    // bit2 10010110101001011010100101101010 | 01011010100101101010010110101001 | 01101010010110101001011010100101 | 10101001011010100101101010010110
    // bit3 10010101101001010110100101011010 | 01010110100101011010010101101001 | 01011010010101101001010110100101 | 01101001010110100101011010010101
    // bit4 01100110100110011010011001101001 | 10011010011001101001100110100110 | 01101001100110100110011010011001 | 10100110011010011001101001100110
    // bit5 01100101100110010110011001011001 | 10010110011001011001100101100110 | 01011001100101100110010110011001 | 01100110010110011001011001100101
    // bit6 01011010100101101010010110101001 | 01101010010110101001011010100101 | 10101001011010100101101010010110 | 10100101101010010110101001011010
    // bit7 01011001100101100110010110011001 | 01100110010110011001011001100101 | 10011001011001100101100110010110 | 01100101100110010110011001011001
    //
    // After Cipher:
    // bit0 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit1 01011001010101100101010110010101 | 01010110010101011001010101100101 | 01010101100101010110010101011001 | 10010101011001010101100101010110
    // bit2 10010110101001011010100101101010 | 01011010100101101010010110101001 | 01101010010110101001011010100101 | 10101001011010100101101010010110
    // bit3 10010101101001010110100101011010 | 01010110100101011010010101101001 | 01011010010101101001010110100101 | 01101001010110100101011010010101
    // bit4 10010110011001011001100101100110 | 01100101100110010110011001011001 | 10011001011001100101100110010110 | 01100110010110011001011001100101
    // bit5 01100101100110010110011001011001 | 10010110011001011001100101100110 | 01011001100101100110010110011001 | 01100110010110011001011001100101
    // bit6 10010101101001010110100101011010 | 10100101011010010101101001010110 | 01101001010110100101011010010101 | 01011010010101101001010110100101
    // bit7 10011001101001100110100110011010 | 10100110011010011001101001100110 | 01101001100110100110011010011001 | 10011010011001101001100110100110
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 XXXX....XXXXXX....XXXXXX....XXXX | XXXX....XXXXXX....XXXXXX....XXXX | XX..XXXX..XX..XXXX..XX..XXXX..XX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit2 ................................ | ................................ | ................................ | ................................
    // bit3 ................................ | ................................ | ................................ | ................................
    // bit4 XXXX....XXXXXX....XXXXXX....XXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXX....XXXXXX....XXXXXX....XXXX | XX........XX........XX........XX
    // bit5 ................................ | ................................ | ................................ | ................................
    // bit6 XX..XXXX..XX..XXXX..XX..XXXX..XX | XX..XXXX..XX..XXXX..XX..XXXX..XX | XX........XX........XX........XX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit7 XX........XX........XX........XX | XX........XX........XX........XX | XXXX....XXXXXX....XXXXXX....XXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // Avalanche: 43.75%

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

    std::uint8_t aMaskByte = 0xCB;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x3B, 0xC4, 0x04, 0xFB, 0x41, 0xBE, 0x28, 0xD7, 0x37, 0xC8, 0x3B, 0xC4, 0x04, 0xFB, 0x41, 0xBE,
        0x28, 0xD7, 0x37, 0xC8, 0x3B, 0xC4, 0x04, 0xFB, 0x41, 0xBE, 0x28, 0xD7, 0x37, 0xC8, 0x3B, 0xC4,
        0x07, 0xF8, 0x0B, 0xF4, 0x20, 0xDF, 0x75, 0x8A, 0x38, 0xC7, 0x07, 0xF8, 0x0B, 0xF4, 0x20, 0xDF,
        0x75, 0x8A, 0x38, 0xC7, 0x07, 0xF8, 0x0B, 0xF4, 0x20, 0xDF, 0x75, 0x8A, 0x38, 0xC7, 0x07, 0xF8,
        0x08, 0xF7, 0x23, 0xDC, 0x3F, 0xC0, 0x30, 0xCF, 0x45, 0xBA, 0x08, 0xF7, 0x23, 0xDC, 0x3F, 0xC0,
        0x30, 0xCF, 0x45, 0xBA, 0x08, 0xF7, 0x23, 0xDC, 0x3F, 0xC0, 0x30, 0xCF, 0x45, 0xBA, 0x08, 0xF7,
        0x61, 0x9E, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x61, 0x9E, 0x3C, 0xC3, 0x33, 0xCC,
        0x0F, 0xF0, 0x00, 0xFF, 0x61, 0x9E, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x61, 0x9E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_G_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_G_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_G_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_G_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_G_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_G_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_H_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit1 01100101010110010101011001010101 | 10010101011001010101100101010110 | 01010101100101010110010101011001 | 01010110010101011001010101100101
    // bit2 01011010010101101001010110100101 | 01101001010110100101011010010101 | 10100101011010010101101001010110 | 10010101101001010110100101011010
    // bit3 01101010010110101001011010100101 | 10101001011010100101101010010110 | 10100101101010010110101001011010 | 10010110101001011010100101101010
    // bit4 01011001100101100110010110011001 | 01100110010110011001011001100101 | 10011001011001100101100110010110 | 01100101100110010110011001011001
    // bit5 01101001100110100110011010011001 | 10100110011010011001101001100110 | 10011001101001100110100110011010 | 01100110100110011010011001101001
    // bit6 01010110100101011010010101101001 | 01011010010101101001010110100101 | 01101001010110100101011010010101 | 10100101011010010101101001010110
    // bit7 01100110100110011010011001101001 | 10011010011001101001100110100110 | 01101001100110100110011010011001 | 10100110011010011001101001100110
    //
    // After Cipher:
    // bit0 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit1 10101010011010101001101010100110 | 01101010100110101010011010101001 | 10011010101001101010100110101010 | 10100110101010011010101001101010
    // bit2 10100101101010010110101001011010 | 10101001011010100101101010010110 | 01101010010110101001011010100101 | 01011010100101101010010110101001
    // bit3 01101010010110101001011010100101 | 10101001011010100101101010010110 | 10100101101010010110101001011010 | 10010110101001011010100101101010
    // bit4 01011001100101100110010110011001 | 01100110010110011001011001100101 | 10011001011001100101100110010110 | 01100101100110010110011001011001
    // bit5 10011001011001100101100110010110 | 01100110010110011001011001100101 | 01011001100101100110010110011001 | 10010110011001011001100101100110
    // bit6 01010110100101011010010101101001 | 01011010010101101001010110100101 | 01101001010110100101011010010101 | 10100101011010010101101001010110
    // bit7 01100110100110011010011001101001 | 10011010011001101001100110100110 | 01101001100110100110011010011001 | 10100110011010011001101001100110
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................ | ................................
    // bit1 XX..XXXX..XX..XXXX..XX..XXXX..XX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XX..XXXX..XX..XXXX..XX..XXXX..XX | XXXX....XXXXXX....XXXXXX....XXXX
    // bit2 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XX........XX........XX........XX | XX..XXXX..XX..XXXX..XX..XXXX..XX | XX..XXXX..XX..XXXX..XX..XXXX..XX
    // bit3 ................................ | ................................ | ................................ | ................................
    // bit4 ................................ | ................................ | ................................ | ................................
    // bit5 XXXX....XXXXXX....XXXXXX....XXXX | XX........XX........XX........XX | XX........XX........XX........XX | XXXX....XXXXXX....XXXXXX....XXXX
    // bit6 ................................ | ................................ | ................................ | ................................
    // bit7 ................................ | ................................ | ................................ | ................................
    // Avalanche: 22.27%

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

    std::uint8_t aMaskByte = 0x64;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x64, 0x9B, 0x71, 0x8E, 0x5C, 0xA3, 0x53, 0xAC, 0x2B, 0xD4, 0x64, 0x9B, 0x71, 0x8E, 0x5C, 0xA3,
        0x53, 0xAC, 0x2B, 0xD4, 0x64, 0x9B, 0x71, 0x8E, 0x5C, 0xA3, 0x53, 0xAC, 0x2B, 0xD4, 0x64, 0x9B,
        0x31, 0xCE, 0x7C, 0x83, 0x73, 0x8C, 0x4F, 0xB0, 0x40, 0xBF, 0x31, 0xCE, 0x7C, 0x83, 0x73, 0x8C,
        0x4F, 0xB0, 0x40, 0xBF, 0x31, 0xCE, 0x7C, 0x83, 0x73, 0x8C, 0x4F, 0xB0, 0x40, 0xBF, 0x31, 0xCE,
        0x58, 0xA7, 0x33, 0xCC, 0x6F, 0x90, 0x60, 0x9F, 0x55, 0xAA, 0x58, 0xA7, 0x33, 0xCC, 0x6F, 0x90,
        0x60, 0x9F, 0x55, 0xAA, 0x58, 0xA7, 0x33, 0xCC, 0x6F, 0x90, 0x60, 0x9F, 0x55, 0xAA, 0x58, 0xA7,
        0x57, 0xA8, 0x4B, 0xB4, 0x20, 0xDF, 0x75, 0x8A, 0x78, 0x87, 0x57, 0xA8, 0x4B, 0xB4, 0x20, 0xDF,
        0x75, 0x8A, 0x78, 0x87, 0x57, 0xA8, 0x4B, 0xB4, 0x20, 0xDF, 0x75, 0x8A, 0x78, 0x87, 0x57, 0xA8
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_H_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_H_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_H_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_H_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_H_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_H_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_I_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10001010111000101011100010101110 | 00101011100010101110001010111000 | 10101110001010111000101011100010 | 10111000101011100010101110001010
    // bit2 11100110001110011000111001100011 | 10011000111001100011100110001110 | 01100011100110001110011000111001 | 10001110011000111001100011100110
    // bit3 11000110011100011001110001100111 | 00011001110001100111000110011100 | 01100111000110011100011001110001 | 10011100011001110001100111000110
    // bit4 00101111000010111100001011110000 | 10111100001011110000101111000010 | 11110000101111000010111100001011 | 11000010111100001011110000101111
    // bit5 00001111010000111101000011110100 | 00111101000011110100001111010000 | 11110100001111010000111101000011 | 11010000111101000011110100001111
    // bit6 01100011100110001110011000111001 | 10001110011000111001100011100110 | 00111001100011100110001110011000 | 11100110001110011000111001100011
    // bit7 01000011110100001111010000111101 | 00001111010000111101000011110100 | 00111101000011110100001111010000 | 11110100001111010000111101000011
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 01110101000111010100011101010001 | 00011101010001110101000111010100 | 01000111010100011101010001110101 | 01010001110101000111010100011101
    // bit2 11000110011100011001110001100111 | 01110001100111000110011100011001 | 10011100011001110001100111000110 | 01100111000110011100011001110001
    // bit3 11100110001110011000111001100011 | 00111001100011100110001110011000 | 10001110011000111001100011100110 | 01100011100110001110011000111001
    // bit4 00101111000010111100001011110000 | 10111100001011110000101111000010 | 11110000101111000010111100001011 | 11000010111100001011110000101111
    // bit5 00001111010000111101000011110100 | 00111101000011110100001111010000 | 11110100001111010000111101000011 | 11010000111101000011110100001111
    // bit6 01100011100110001110011000111001 | 10001110011000111001100011100110 | 00111001100011100110001110011000 | 11100110001110011000111001100011
    // bit7 01000011110100001111010000111101 | 00001111010000111101000011110100 | 00111101000011110100001111010000 | 11110100001111010000111101000011
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................ | ................................
    // bit1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | ..XX.XX.XX..XX.XX.XX..XX.XX.XX.. | XXX.X..X.XXXX.X..X.XXXX.X..X.XXX | XXX.X..X.XXXX.X..X.XXXX.X..X.XXX
    // bit2 ..X......X..X......X..X......X.. | XXX.X..X.XXXX.X..X.XXXX.X..X.XXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXX.X..X.XXXX.X..X.XXXX.X..X.XXX
    // bit3 ..X......X..X......X..X......X.. | ..X......X..X......X..X......X.. | XXX.X..X.XXXX.X..X.XXXX.X..X.XXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 ................................ | ................................ | ................................ | ................................
    // bit5 ................................ | ................................ | ................................ | ................................
    // bit6 ................................ | ................................ | ................................ | ................................
    // bit7 ................................ | ................................ | ................................ | ................................
    // Avalanche: 22.66%

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

    std::uint8_t aMaskByte = 0x70;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xB0, 0x73, 0xDA, 0x40, 0x8C, 0x7C, 0xBF, 0x4F, 0x83, 0x25, 0xB0, 0x73, 0xDA, 0x40, 0x8C, 0x7C,
        0xBF, 0x4F, 0x83, 0x25, 0xB0, 0x73, 0xDA, 0x40, 0x8C, 0x7C, 0xBF, 0x4F, 0x83, 0x25, 0xB0, 0x73,
        0x8A, 0x20, 0xBC, 0x7C, 0xDF, 0x4F, 0x83, 0x75, 0xB0, 0x43, 0x8A, 0x20, 0xBC, 0x7C, 0xDF, 0x4F,
        0x83, 0x75, 0xB0, 0x43, 0x8A, 0x20, 0xBC, 0x7C, 0xDF, 0x4F, 0x83, 0x75, 0xB0, 0x43, 0x8A, 0x20,
        0xBC, 0x4C, 0x8F, 0x2F, 0xB3, 0x75, 0xD0, 0x43, 0x8A, 0x70, 0xBC, 0x4C, 0x8F, 0x2F, 0xB3, 0x75,
        0xD0, 0x43, 0x8A, 0x70, 0xBC, 0x4C, 0x8F, 0x2F, 0xB3, 0x75, 0xD0, 0x43, 0x8A, 0x70, 0xBC, 0x4C,
        0x8F, 0x7F, 0xB3, 0x45, 0x80, 0x23, 0xBA, 0x70, 0xDC, 0x4C, 0x8F, 0x7F, 0xB3, 0x45, 0x80, 0x23,
        0xBA, 0x70, 0xDC, 0x4C, 0x8F, 0x7F, 0xB3, 0x45, 0x80, 0x23, 0xBA, 0x70, 0xDC, 0x4C, 0x8F, 0x7F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_I_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_I_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_I_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_I_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_I_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_I_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_J_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit2 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit6 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // After Cipher:
    // bit0 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit1 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit2 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit3 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit6 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    //
    // Avalanche:
    // bit0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit1 ................................ | ................................ | ................................ | ................................
    // bit2 ................................ | ................................ | ................................ | ................................
    // bit3 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 ................................ | ................................ | ................................ | ................................
    // bit5 ................................ | ................................ | ................................ | ................................
    // bit6 ................................ | ................................ | ................................ | ................................
    // bit7 ................................ | ................................ | ................................ | ................................
    // Avalanche: 25.00%

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

    std::uint8_t aMaskByte = 0xB6;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5,
        0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5,
        0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5,
        0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5, 0x5C, 0xC5,
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
                                                    "test_fixed_128_J_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_J_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_J_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_J_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_J_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_J_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_K_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101010101010101010101001010101 | 10101010101010101010101010101010 | 01010101101010101010101010101010 | 10101010010101011010101010101010
    // bit2 10101010010101010101010110101010 | 10101010101010100101010101010101 | 10101010101010101010101001010101 | 01010101101010101010101010101010
    // bit3 10101010010101010101010101010101 | 10101010101010100101010101010101 | 01010101101010101010101001010101 | 01010101010101011010101010101010
    // bit4 01010101101010100101010110101010 | 10101010010101011010101001010101 | 10101010101010100101010110101010 | 01010101101010101010101001010101
    // bit5 01010101101010100101010101010101 | 10101010010101011010101001010101 | 01010101101010100101010110101010 | 01010101010101011010101001010101
    // bit6 01010101010101011010101010101010 | 10101010010101010101010110101010 | 10101010101010100101010101010101 | 10101010101010101010101001010101
    // bit7 01010101010101011010101001010101 | 10101010010101010101010110101010 | 01010101101010100101010101010101 | 10101010010101011010101001010101
    //
    // After Cipher:
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101010101010101010101001010101 | 10101010101010101010101010101010 | 01010101101010101010101010101010 | 10101010010101011010101010101010
    // bit2 01010101101010101010101001010101 | 10101010101010100101010101010101 | 10101010010101010101010101010101 | 01010101010101010101010110101010
    // bit3 10101010010101010101010101010101 | 10101010101010100101010101010101 | 01010101101010101010101001010101 | 01010101010101011010101010101010
    // bit4 01010101101010100101010110101010 | 10101010010101011010101001010101 | 10101010101010100101010110101010 | 01010101101010101010101001010101
    // bit5 01010101101010100101010101010101 | 10101010010101011010101001010101 | 01010101101010100101010110101010 | 01010101010101011010101001010101
    // bit6 01010101010101011010101010101010 | 01010101101010101010101001010101 | 10101010101010100101010101010101 | 10101010010101010101010101010101
    // bit7 10101010010101011010101010101010 | 01010101101010101010101001010101 | 10101010101010100101010110101010 | 10101010010101011010101001010101
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................ | ................................
    // bit1 ................................ | ................................ | ................................ | ................................
    // bit2 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | ................................ | ........XXXXXXXXXXXXXXXX........ | ........XXXXXXXXXXXXXXXX........
    // bit3 ................................ | ................................ | ................................ | ................................
    // bit4 ................................ | ................................ | ................................ | ................................
    // bit5 ................................ | ................................ | ................................ | ................................
    // bit6 ................................ | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | ................................ | ........XXXXXXXXXXXXXXXX........
    // bit7 XXXXXXXX................XXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXX................XXXXXXXX | ................................
    // Avalanche: 17.19%

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

    std::uint8_t aMaskByte = 0x23;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xD1, 0x2E, 0xD1, 0x2E, 0xD1, 0x2E, 0xD1, 0x2E, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13,
        0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0xE3, 0x1C, 0x8B, 0x74, 0x8B, 0x74, 0x8B, 0x74, 0x8B, 0x74,
        0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x03, 0xF3, 0x0C, 0xF3, 0x0C, 0xF3, 0x0C, 0xF3, 0x0C,
        0xCF, 0x30, 0xCF, 0x30, 0xCF, 0x30, 0xCF, 0x30, 0xC0, 0x3F, 0xC0, 0x3F, 0xC0, 0x3F, 0xC0, 0x3F,
        0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20,
        0xD0, 0x2F, 0xD0, 0x2F, 0xD0, 0x2F, 0xD0, 0x2F, 0xCD, 0x32, 0xCD, 0x32, 0xCD, 0x32, 0xCD, 0x32,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0x88, 0x77, 0x88, 0x77, 0x88, 0x77, 0x88, 0x77,
        0xDD, 0x22, 0xDD, 0x22, 0xDD, 0x22, 0xDD, 0x22, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_K_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_K_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_K_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_K_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_K_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_K_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_L_ReverseMaskByteBlockCipher32 {

    // Before Cipher:
    // bit0 10000101111010000101111010000101 | 11101000010111101000010111101000 | 01011110100001011110100001011110 | 10000101111010000101111010000101
    // bit1 10000101010101010101111010000000 | 10101000010111101010111111101000 | 01010101010101011110100000001010 | 10000101111010101111111010000101
    // bit2 10101010101010000101010101111111 | 11101000000000010101010111101010 | 10101010100001010101011111111110 | 10000000000101010101111010101010
    // bit3 10101010000101010101010101111010 | 10101000000000010111111111101010 | 10100001010101010101011110101010 | 10000000000101111111111010101010
    // bit4 01010000101010000000101010101111 | 11101010111101010101010101010101 | 00001010100000001010101011111110 | 10101111010101010101010101010000
    // bit5 01010000000101010000101010101010 | 10101010111101010111111101010101 | 00000001010100001010101010101010 | 10101111010101111111010101010000
    // bit6 01111111111010000000000101010101 | 11101010101010101000010101010111 | 11111110100000000001010101011110 | 10101010101010000101010101111111
    // bit7 01111111010101010000000101010000 | 10101010101010101010111101010111 | 11110101010100000001010100001010 | 10101010101010101111010101111111
    //
    // After Cipher:
    // bit0 10000101111010000101111010000101 | 11101000010111101000010111101000 | 01011110100001011110100001011110 | 10000101111010000101111010000101
    // bit1 00000001011110101010101010100001 | 00010111111101010111101000010101 | 01010000000101111010101010101010 | 10100001011111110101011110100001
    // bit2 11111110101010100001010101010101 | 01010111101010101000000000010111 | 01111111111010101010000101010101 | 01010101011110101010100000000001
    // bit3 10101010000101010101010101111010 | 10101000000000010111111111101010 | 10100001010101010101011110101010 | 10000000000101111111111010101010
    // bit4 01010000101010000000101010101111 | 11101010111101010101010101010101 | 00001010100000001010101011111110 | 10101111010101010101010101010000
    // bit5 01010000000101010000101010101010 | 10101010111101010111111101010101 | 00000001010100001010101010101010 | 10101111010101111111010101010000
    // bit6 01111111111010000000000101010101 | 11101010101010101000010101010111 | 11111110100000000001010101011110 | 10101010101010000101010101111111
    // bit7 00001010100000001010101011111110 | 11101010111101010101010101010101 | 01010000101010000000101010101111 | 11111110101011110101010101010101
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................ | ................................
    // bit1 X....X....X.XXXXXXXX.X....X....X | X.XXXXXXX.X.X.XXXX.X.X.XXXXXXX.X | .....X.X.X....X..X....X.X.X..... | ..X..X..X..X.X.XX.X.X..X..X..X..
    // bit2 .X.X.X........X..X........X.X.X. | X.XXXXXXX.X.X.XXXX.X.X.XXXXXXX.X | XX.X.X.X.XX.XXXXXXXX.XX.X.X.X.XX | XX.X.X.X.XX.XXXXXXXX.XX.X.X.X.XX
    // bit3 ................................ | ................................ | ................................ | ................................
    // bit4 ................................ | ................................ | ................................ | ................................
    // bit5 ................................ | ................................ | ................................ | ................................
    // bit6 ................................ | ................................ | ................................ | ................................
    // bit7 .XXX.X.XXX.X.X.XX.X.X.XXX.X.XXX. | .X.......X.XXXXXXXXXX.X.......X. | X.X..X.XXXXXX......XXXXXX.X..X.X | .X.X.X.......X.XX.X.......X.X.X.
    // Avalanche: 19.14%

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

    std::uint8_t aMaskByte = 0x61;

    ReverseMaskByteBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xB0, 0x2E, 0x32, 0x2E, 0x33, 0xA2, 0x33, 0xC2, 0xAB, 0xC2, 0xEA, 0x54, 0xEA, 0x14, 0x60, 0x14,
        0x41, 0x90, 0x41, 0xB0, 0xCD, 0xB0, 0xCD, 0x32, 0xCD, 0x33, 0x5D, 0x33, 0x1D, 0xAB, 0x1D, 0xEA,
        0x9F, 0xAB, 0x9F, 0x60, 0x9F, 0x60, 0x6F, 0x60, 0x6F, 0xCD, 0x6F, 0xCD, 0xA2, 0xCD, 0xA2, 0x5D,
        0xA2, 0x5D, 0x54, 0x5D, 0x54, 0x9F, 0x54, 0x9F, 0x90, 0x9F, 0x90, 0x6F, 0x90, 0x6F, 0x32, 0x6F,
        0x12, 0xE3, 0x32, 0xE3, 0xAA, 0xA2, 0xAA, 0x34, 0xAB, 0x34, 0x21, 0x54, 0x21, 0xD0, 0x60, 0xD0,
        0xEC, 0x90, 0xEC, 0x12, 0xCD, 0x12, 0x5D, 0x32, 0x5D, 0xAA, 0x5D, 0xAA, 0xDF, 0xAB, 0xDF, 0x21,
        0xDF, 0x21, 0x4F, 0x21, 0x0F, 0xAD, 0x0F, 0xEC, 0x83, 0xEC, 0xE3, 0x7C, 0xE3, 0x5D, 0x75, 0x5D,
        0x34, 0xDF, 0x34, 0xDF, 0xB0, 0xDF, 0xD0, 0x4F, 0xD0, 0x0F, 0x52, 0x0F, 0x12, 0x83, 0x12, 0xE3
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_L_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_L_ReverseMaskByteBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_L_ReverseMaskByteBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_L_ReverseMaskByteBlockCipher32")) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_L_ReverseMaskByteBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[ReverseMaskByteBlockCipher32] test_fixed_128_L_ReverseMaskByteBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

@end
