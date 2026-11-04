//
//  Battery_RippleMaskBlockCipher32.m
//  HolyStorms
//
//  Created by icarus black on 7/5/26.
//

#import <XCTest/XCTest.h>
#import "RippleMaskBlockCipher32.hpp"
#import "PrintExamplesHelper.hpp"
#import "CipherGauntlet.hpp"
#include <memory>

@interface Battery_RippleMaskBlockCipher32 : XCTestCase

@end

@implementation Battery_RippleMaskBlockCipher32

- (void)test_gauntlet_RippleMaskBlockCipher32 {
    

    
    static CipherGauntlet aGauntlet;
    
    for (auto &aMask: cMasks) {
        RippleMaskBlockCipher32 aCipher(static_cast<std::uint8_t>(aMask));
        
        if (!aGauntlet.RunCipher(&aCipher,
                                 32,
                                 "RippleMaskBlockCipher32")) {
            XCTFail("[RippleMaskBlockCipher32] test_gauntlet_RippleMaskBlockCipher32 failed.");
            return;
        }
        
    }
}

- (void)test_fixed_32_A_RippleMaskBlockCipher32 {

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

    std::uint8_t aMaskByte = 0x0F;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

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
                                                    "test_fixed_32_A_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_A_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_A_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_A_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_A_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_A_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_B_RippleMaskBlockCipher32 {

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

    std::uint8_t aMaskByte = 0xA1;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

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
                                                    "test_fixed_32_B_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_B_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_B_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_B_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_B_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_B_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_C_RippleMaskBlockCipher32 {

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
    // bit0 10101010101010101010101010101010
    // bit1 10101010101010101010101010101010
    // bit2 10101010101010101010101010101010
    // bit3 10101010101010101010101010101010
    // bit4 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101
    // bit6 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101
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
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0x91;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_C_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_C_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_C_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_C_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_C_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_C_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_D_RippleMaskBlockCipher32 {

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
    // bit4 ................................
    // bit5 ................................
    // bit6 ................................
    // bit7 ................................
    // Avalanche: 0.00%

    const std::uint8_t aOriginal[32] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0xF0;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

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
                                                    "test_fixed_32_D_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_D_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_D_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_D_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_D_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_D_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_E_RippleMaskBlockCipher32 {

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
    // bit4 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101
    // bit6 10101010101010101010101010101010
    // bit7 10101010101010101010101010101010
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
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x0F;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_E_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_E_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_E_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_E_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_E_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_E_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_F_RippleMaskBlockCipher32 {

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
    // bit1 01010101010101010101010101010101
    // bit2 10101010101010101010101010101010
    // bit3 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010
    // bit5 01010101010101010101010101010101
    // bit6 10101010101010101010101010101010
    // bit7 01010101010101010101010101010101
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
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0xC2;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_F_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_F_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_F_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_F_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_F_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_F_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_G_RippleMaskBlockCipher32 {

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
    // bit0 10101010101010101010101010101010
    // bit1 10101001101010100110101010011010
    // bit2 10010110101001011010100101101010
    // bit3 10010101101001010110100101011010
    // bit4 01100110100110011010011001101001
    // bit5 01100101100110010110011001011001
    // bit6 01011010100101101010010110101001
    // bit7 01011001100101100110010110011001
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
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0x33;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_G_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_G_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_G_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_G_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_G_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_G_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_H_RippleMaskBlockCipher32 {

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
    // bit1 01100101010110010101011001010101
    // bit2 01011010010101101001010110100101
    // bit3 01101010010110101001011010100101
    // bit4 01011001100101100110010110011001
    // bit5 01101001100110100110011010011001
    // bit6 01010110100101011010010101101001
    // bit7 01100110100110011010011001101001
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
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF
    };

    std::uint8_t aMaskByte = 0x89;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_H_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_H_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_H_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_H_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_H_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_H_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_I_RippleMaskBlockCipher32 {

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
    // bit2 11100110001110011000111001100011
    // bit3 11000110011100011001110001100111
    // bit4 00101111000010111100001011110000
    // bit5 00001111010000111101000011110100
    // bit6 01100011100110001110011000111001
    // bit7 01000011110100001111010000111101
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
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33
    };

    std::uint8_t aMaskByte = 0x38;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_I_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_I_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_I_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_I_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_I_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_I_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_J_RippleMaskBlockCipher32 {

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
    // bit3 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010
    // bit5 11111111111111111111111111111111
    // bit6 00000000000000000000000000000000
    // bit7 01010101010101010101010101010101
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
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    std::uint8_t aMaskByte = 0x69;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_J_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_J_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_J_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_J_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_J_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_J_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_K_RippleMaskBlockCipher32 {

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
    // bit0 10101010101010101010101010101010
    // bit1 10101010101010101010101001010101
    // bit2 10101010010101010101010110101010
    // bit3 10101010010101010101010101010101
    // bit4 01010101101010100101010110101010
    // bit5 01010101101010100101010101010101
    // bit6 01010101010101011010101010101010
    // bit7 01010101010101011010101001010101
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
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0x85;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_K_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_K_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_K_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_K_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_K_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_K_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_L_RippleMaskBlockCipher32 {

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
    // bit0 10000101111010000101111010000101
    // bit1 10000101010101010101111010000000
    // bit2 10101010101010000101010101111111
    // bit3 10101010000101010101010101111010
    // bit4 01010000101010000000101010101111
    // bit5 01010000000101010000101010101010
    // bit6 01111111111010000000000101010101
    // bit7 01111111010101010000000101010000
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
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA
    };

    std::uint8_t aMaskByte = 0x52;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_L_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_L_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_L_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_L_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_L_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_32_L_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_A_RippleMaskBlockCipher32 {

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

    std::uint8_t aMaskByte = 0x43;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

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
                                                    "test_fixed_64_A_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_A_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_A_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_A_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_A_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_A_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_B_RippleMaskBlockCipher32 {

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

    std::uint8_t aMaskByte = 0x2C;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

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
                                                    "test_fixed_64_B_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_B_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_B_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_B_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_B_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_B_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_C_RippleMaskBlockCipher32 {

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
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit3 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101
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
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0x91;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_C_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_C_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_C_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_C_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_C_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_C_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_D_RippleMaskBlockCipher32 {

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
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101
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
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x64;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
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
                                                    "test_fixed_64_D_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_D_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_D_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_D_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_D_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_D_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_E_RippleMaskBlockCipher32 {

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
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit7 10101010101010101010101010101010 | 10101010101010101010101010101010
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
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x98;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_E_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_E_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_E_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_E_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_E_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_E_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_F_RippleMaskBlockCipher32 {

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
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit2 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101
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
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0x96;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_F_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_F_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_F_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_F_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_F_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_F_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_G_RippleMaskBlockCipher32 {

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
    // bit1 10100110101010011010101001101010 | 10101001101010100110101010011010
    // bit2 10010110101001011010100101101010 | 01011010100101101010010110101001
    // bit3 01010110100101011010010101101001 | 10010101101001010110100101011010
    // bit4 01100110100110011010011001101001 | 10011010011001101001100110100110
    // bit5 01100101100110010110011001011001 | 10010110011001011001100101100110
    // bit6 01101010010110101001011010100101 | 01011010100101101010010110101001
    // bit7 01011001100101100110010110011001 | 01100110010110011001011001100101
    //
    // Avalanche:
    // bit0 ................................ | ................................
    // bit1 ....XXXX......XXXX......XXXX.... | ....XXXX......XXXX......XXXX....
    // bit2 ................................ | ................................
    // bit3 XX....XX..XX....XX..XX....XX..XX | XX....XX..XX....XX..XX....XX..XX
    // bit4 ................................ | ................................
    // bit5 ................................ | ................................
    // bit6 ..XX....XX..XX....XX..XX....XX.. | ..XX....XX..XX....XX..XX....XX..
    // bit7 ................................ | ................................
    // Avalanche: 14.84%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F,
        0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55,
        0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x52;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xE0, 0x1F, 0xCE, 0x31, 0x83, 0x7C, 0xFA, 0x05, 0xFD, 0x02, 0xE0, 0x1F, 0xCE, 0x31, 0x83, 0x7C,
        0xFA, 0x05, 0xFD, 0x02, 0xE0, 0x1F, 0xCE, 0x31, 0x83, 0x7C, 0xFA, 0x05, 0xFD, 0x02, 0xE0, 0x1F,
        0xDC, 0x23, 0xC1, 0x3E, 0xEA, 0x15, 0xAF, 0x50, 0xF2, 0x0D, 0xDC, 0x23, 0xC1, 0x3E, 0xEA, 0x15,
        0xAF, 0x50, 0xF2, 0x0D, 0xDC, 0x23, 0xC1, 0x3E, 0xEA, 0x15, 0xAF, 0x50, 0xF2, 0x0D, 0xDC, 0x23
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_G_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_G_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_G_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_G_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_G_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_G_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_H_RippleMaskBlockCipher32 {

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
    // bit2 01101001010110100101011010010101 | 01011010010101101001010110100101
    // bit3 10101001011010100101101010010110 | 01101010010110101001011010100101
    // bit4 01100110010110011001011001100101 | 01011001100101100110010110011001
    // bit5 01101001100110100110011010011001 | 10100110011010011001101001100110
    // bit6 01010110100101011010010101101001 | 01011010010101101001010110100101
    // bit7 01100110100110011010011001101001 | 10011010011001101001100110100110
    //
    // Avalanche:
    // bit0 ................................ | ................................
    // bit1 ................................ | ................................
    // bit2 ..XX..XX....XX..XX....XX..XX.... | ..XX..XX....XX..XX....XX..XX....
    // bit3 XX....XX..XX....XX..XX....XX..XX | XX....XX..XX....XX..XX....XX..XX
    // bit4 ..XXXXXXXX..XXXXXXXX..XXXXXXXX.. | ..XXXXXXXX..XXXXXXXX..XXXXXXXX..
    // bit5 ................................ | ................................
    // bit6 ................................ | ................................
    // bit7 ................................ | ................................
    // Avalanche: 19.53%

    const std::uint8_t aOriginal[64] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF,
        0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC,
        0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA
    };

    std::uint8_t aMaskByte = 0x38;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x10, 0xEF, 0x7D, 0x82, 0x34, 0xCB, 0x0B, 0xF4, 0x07, 0xF8, 0x10, 0xEF, 0x7D, 0x82, 0x34, 0xCB,
        0x0B, 0xF4, 0x07, 0xF8, 0x10, 0xEF, 0x7D, 0x82, 0x34, 0xCB, 0x0B, 0xF4, 0x07, 0xF8, 0x10, 0xEF,
        0x45, 0xBA, 0x14, 0xEB, 0x3B, 0xC4, 0x37, 0xC8, 0x08, 0xF7, 0x45, 0xBA, 0x14, 0xEB, 0x3B, 0xC4,
        0x37, 0xC8, 0x08, 0xF7, 0x45, 0xBA, 0x14, 0xEB, 0x3B, 0xC4, 0x37, 0xC8, 0x08, 0xF7, 0x45, 0xBA
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_H_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_H_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_H_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_H_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_H_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_H_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_I_RippleMaskBlockCipher32 {

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
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10001010111000101011100010101110 | 00101011100010101110001010111000
    // bit2 11100110001110011000111001100011 | 10011000111001100011100110001110
    // bit3 00011001110001100111000110011100 | 11000110011100011001110001100111
    // bit4 10111100001011110000101111000010 | 00101111000010111100001011110000
    // bit5 00111101000011110100001111010000 | 00001111010000111101000011110100
    // bit6 01100011100110001110011000111001 | 10001110011000111001100011100110
    // bit7 01000011110100001111010000111101 | 00001111010000111101000011110100
    //
    // Avalanche:
    // bit0 ................................ | ................................
    // bit1 ................................ | ................................
    // bit2 ................................ | ................................
    // bit3 XX.XXXXXX.XX.XXXXXX.XX.XXXXXX.XX | XX.XXXXXX.XX.XXXXXX.XX.XXXXXX.XX
    // bit4 X..X..XX..X..X..XX..X..X..XX..X. | X..X..XX..X..X..XX..X..X..XX..X.
    // bit5 ..XX..X..X..XX..X..X..XX..X..X.. | ..XX..X..X..XX..X..X..XX..X..X..
    // bit6 ................................ | ................................
    // bit7 ................................ | ................................
    // Avalanche: 19.92%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33,
        0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F,
        0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00
    };

    std::uint8_t aMaskByte = 0x1C;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xE8, 0x23, 0xAE, 0x1C, 0xDC, 0x2C, 0xE3, 0x17, 0xD3, 0x51, 0xE8, 0x23, 0xAE, 0x1C, 0xDC, 0x2C,
        0xE3, 0x17, 0xD3, 0x51, 0xE8, 0x23, 0xAE, 0x1C, 0xDC, 0x2C, 0xE3, 0x17, 0xD3, 0x51, 0xE8, 0x23,
        0xB2, 0x10, 0xC8, 0x20, 0xEF, 0x1F, 0xDF, 0x4D, 0xE0, 0x37, 0xB2, 0x10, 0xC8, 0x20, 0xEF, 0x1F,
        0xDF, 0x4D, 0xE0, 0x37, 0xB2, 0x10, 0xC8, 0x20, 0xEF, 0x1F, 0xDF, 0x4D, 0xE0, 0x37, 0xB2, 0x10
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_I_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_I_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_I_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_I_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_I_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_I_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_J_RippleMaskBlockCipher32 {

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
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit6 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101
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
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    std::uint8_t aMaskByte = 0xA4;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_J_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_J_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_J_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_J_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_J_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_J_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_K_RippleMaskBlockCipher32 {

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
    // bit1 10101010101010101010101001010101 | 10101010101010101010101010101010
    // bit2 10101010010101010101010110101010 | 10101010101010100101010101010101
    // bit3 10101010101010100101010101010101 | 10101010010101010101010101010101
    // bit4 10101010010101011010101001010101 | 01010101101010100101010110101010
    // bit5 01010101101010100101010101010101 | 10101010010101011010101001010101
    // bit6 10101010010101010101010110101010 | 01010101010101011010101010101010
    // bit7 01010101010101011010101001010101 | 10101010010101010101010110101010
    //
    // Avalanche:
    // bit0 ................................ | ................................
    // bit1 ................................ | ................................
    // bit2 ................................ | ................................
    // bit3 ........XXXXXXXX................ | ........XXXXXXXX................
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit5 ................................ | ................................
    // bit6 XXXXXXXX........XXXXXXXX........ | XXXXXXXX........XXXXXXXX........
    // bit7 ................................ | ................................
    // Avalanche: 21.88%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x1A;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xFA, 0x05, 0xFA, 0x05, 0xFA, 0x05, 0xFA, 0x05, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B, 0xD4, 0x2B,
        0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D, 0xA2, 0x5D,
        0xF5, 0x0A, 0xF5, 0x0A, 0xF5, 0x0A, 0xF5, 0x0A, 0xE8, 0x17, 0xE8, 0x17, 0xE8, 0x17, 0xE8, 0x17,
        0xC6, 0x39, 0xC6, 0x39, 0xC6, 0x39, 0xC6, 0x39, 0xCB, 0x34, 0xCB, 0x34, 0xCB, 0x34, 0xCB, 0x34
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_K_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_K_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_K_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_K_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_K_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_K_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_L_RippleMaskBlockCipher32 {

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
    // bit0 11101000010111101000010111101000 | 10000101111010000101111010000101
    // bit1 10000101010101010101111010000000 | 10101000010111101010111111101000
    // bit2 10101010101010000101010101111111 | 11101000000000010101010111101010
    // bit3 10101010000101010101010101111010 | 10101000000000010111111111101010
    // bit4 01010000101010000000101010101111 | 11101010111101010101010101010101
    // bit5 01010000000101010000101010101010 | 10101010111101010111111101010101
    // bit6 11101010101010101000010101010111 | 01111111111010000000000101010101
    // bit7 10101010101010101010111101010111 | 01111111010101010000000101010000
    //
    // Avalanche:
    // bit0 .XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.X | .XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.X
    // bit1 ................................ | ................................
    // bit2 ................................ | ................................
    // bit3 ................................ | ................................
    // bit4 ................................ | ................................
    // bit5 ................................ | ................................
    // bit6 X..X.X.X.X....X.X....X........X. | X..X.X.X.X....X.X....X........X.
    // bit7 XX.X.X.XXXXXXXXXX.X.XXX......XXX | XX.X.X.XXXXXXXXXX.X.XXX......XXX
    // Avalanche: 19.92%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA,
        0xFF, 0xAA, 0xFF, 0x00, 0xFF, 0x00, 0x0F, 0x00, 0x0F, 0xCC, 0x0F, 0xCC, 0xC3, 0xCC, 0xC3, 0x3C,
        0xC3, 0x3C, 0x55, 0x3C, 0x55, 0xFF, 0x55, 0xFF, 0xF0, 0xFF, 0xF0, 0x0F, 0xF0, 0x0F, 0x33, 0x0F
    };

    std::uint8_t aMaskByte = 0x83;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xF3, 0x8E, 0xB3, 0x0C, 0xB3, 0x40, 0x33, 0x40, 0x2B, 0xC0, 0x2B, 0xD4, 0xAB, 0xD4, 0x83, 0x54,
        0x83, 0x70, 0x01, 0x70, 0x4D, 0xF3, 0x4D, 0xB3, 0xCC, 0xB3, 0xBC, 0x33, 0xBC, 0x2B, 0x3F, 0x2B,
        0xFC, 0x2B, 0x7F, 0x03, 0x7F, 0x83, 0x0F, 0x83, 0x8E, 0xCF, 0x8E, 0x4D, 0xC2, 0x4D, 0x40, 0x3D,
        0x40, 0xBC, 0x54, 0xBC, 0xD4, 0xFC, 0xD4, 0x7F, 0xF0, 0x7F, 0x70, 0x0F, 0x70, 0x8E, 0x30, 0x8E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_L_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_L_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_L_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_L_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_L_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_64_L_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_A_RippleMaskBlockCipher32 {

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

    std::uint8_t aMaskByte = 0x55;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

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
                                                    "test_fixed_96_A_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_A_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_A_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_A_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_A_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_A_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_B_RippleMaskBlockCipher32 {

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

    std::uint8_t aMaskByte = 0xAA;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

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
                                                    "test_fixed_96_B_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_B_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_B_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_B_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_B_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_B_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_C_RippleMaskBlockCipher32 {

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
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit3 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
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
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0x83;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_C_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_C_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_C_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_C_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_C_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_C_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_D_RippleMaskBlockCipher32 {

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
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
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
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x2C;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
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
                                                    "test_fixed_96_D_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_D_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_D_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_D_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_D_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_D_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_E_RippleMaskBlockCipher32 {

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
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit7 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
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
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x34;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_E_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_E_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_E_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_E_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_E_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_E_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_F_RippleMaskBlockCipher32 {

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
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit2 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
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
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0x85;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_F_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_F_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_F_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_F_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_F_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_F_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_G_RippleMaskBlockCipher32 {

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
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10100110101010011010101001101010 | 10101001101010100110101010011010 | 10011010101001101010100110101010
    // bit2 01011010100101101010010110101001 | 10010110101001011010100101101010 | 01101010010110101001011010100101
    // bit3 10010101101001010110100101011010 | 01010110100101011010010101101001 | 01011010010101101001010110100101
    // bit4 01100110100110011010011001101001 | 10011010011001101001100110100110 | 01101001100110100110011010011001
    // bit5 01100101100110010110011001011001 | 10010110011001011001100101100110 | 01011001100101100110010110011001
    // bit6 01101010010110101001011010100101 | 01011010100101101010010110101001 | 10101001011010100101101010010110
    // bit7 01011001100101100110010110011001 | 01100110010110011001011001100101 | 10011001011001100101100110010110
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................
    // bit1 ....XXXX......XXXX......XXXX.... | ....XXXX......XXXX......XXXX.... | ................................
    // bit2 XX..XX....XX..XX....XX..XX....XX | XX..XX....XX..XX....XX..XX....XX | ................................
    // bit3 ................................ | ................................ | ................................
    // bit4 ................................ | ................................ | ................................
    // bit5 ................................ | ................................ | ................................
    // bit6 ..XX....XX..XX....XX..XX....XX.. | ..XX....XX..XX....XX..XX....XX.. | ................................
    // bit7 ................................ | ................................ | ................................
    // Avalanche: 9.90%

    const std::uint8_t aOriginal[96] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F,
        0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55,
        0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33,
        0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00,
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x62;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0xD0, 0x2F, 0xCE, 0x31, 0xA3, 0x5C, 0xEA, 0x15, 0xFD, 0x02, 0xD0, 0x2F, 0xCE, 0x31, 0xA3, 0x5C,
        0xEA, 0x15, 0xFD, 0x02, 0xD0, 0x2F, 0xCE, 0x31, 0xA3, 0x5C, 0xEA, 0x15, 0xFD, 0x02, 0xD0, 0x2F,
        0xEC, 0x13, 0xC1, 0x3E, 0xCA, 0x35, 0xBF, 0x40, 0xF2, 0x0D, 0xEC, 0x13, 0xC1, 0x3E, 0xCA, 0x35,
        0xBF, 0x40, 0xF2, 0x0D, 0xEC, 0x13, 0xC1, 0x3E, 0xCA, 0x35, 0xBF, 0x40, 0xF2, 0x0D, 0xEC, 0x13,
        0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00,
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_G_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_G_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_G_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_G_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_G_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_G_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_H_RippleMaskBlockCipher32 {

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
    // bit2 01011010010101101001010110100101 | 01101001010110100101011010010101 | 10100101011010010101101001010110
    // bit3 01101010010110101001011010100101 | 10101001011010100101101010010110 | 10100101101010010110101001011010
    // bit4 01100110010110011001011001100101 | 01011001100101100110010110011001 | 10011001011001100101100110010110
    // bit5 10100110011010011001101001100110 | 01101001100110100110011010011001 | 10011001101001100110100110011010
    // bit6 01011010010101101001010110100101 | 01010110100101011010010101101001 | 01101001010110100101011010010101
    // bit7 10011010011001101001100110100110 | 01100110100110011010011001101001 | 01101001100110100110011010011001
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................
    // bit1 ................................ | ................................ | ................................
    // bit2 ................................ | ................................ | ................................
    // bit3 ................................ | ................................ | ................................
    // bit4 ..XXXXXXXX..XXXXXXXX..XXXXXXXX.. | ..XXXXXXXX..XXXXXXXX..XXXXXXXX.. | ................................
    // bit5 XX..XXXXXXXX..XXXXXXXX..XXXXXXXX | XX..XXXXXXXX..XXXXXXXX..XXXXXXXX | ................................
    // bit6 ....XX..XX....XX..XX....XX..XX.. | ....XX..XX....XX..XX....XX..XX.. | ................................
    // bit7 XXXXXX..XXXXXXXX..XXXXXXXX..XXXX | XXXXXX..XXXXXXXX..XXXXXXXX..XXXX | ................................
    // Avalanche: 22.92%

    const std::uint8_t aOriginal[96] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF,
        0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC,
        0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA,
        0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0,
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3
    };

    std::uint8_t aMaskByte = 0x0F;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0x05, 0xFA, 0x5C, 0xA3, 0x33, 0xCC, 0x3F, 0xC0, 0x00, 0xFF, 0x05, 0xFA, 0x5C, 0xA3, 0x33, 0xCC,
        0x3F, 0xC0, 0x00, 0xFF, 0x05, 0xFA, 0x5C, 0xA3, 0x33, 0xCC, 0x3F, 0xC0, 0x00, 0xFF, 0x05, 0xFA,
        0x50, 0xAF, 0x35, 0xCA, 0x3C, 0xC3, 0x03, 0xFC, 0x0F, 0xF0, 0x50, 0xAF, 0x35, 0xCA, 0x3C, 0xC3,
        0x03, 0xFC, 0x0F, 0xF0, 0x50, 0xAF, 0x35, 0xCA, 0x3C, 0xC3, 0x03, 0xFC, 0x0F, 0xF0, 0x50, 0xAF,
        0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0,
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_H_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_H_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_H_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_H_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_H_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_H_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_I_RippleMaskBlockCipher32 {

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
    // bit2 11100110001110011000111001100011 | 10011000111001100011100110001110 | 01100011100110001110011000111001
    // bit3 00011001110001100111000110011100 | 11000110011100011001110001100111 | 01100111000110011100011001110001
    // bit4 00101111000010111100001011110000 | 10111100001011110000101111000010 | 11110000101111000010111100001011
    // bit5 00111101000011110100001111010000 | 00001111010000111101000011110100 | 11110100001111010000111101000011
    // bit6 10001110011000111001100011100110 | 01100011100110001110011000111001 | 00111001100011100110001110011000
    // bit7 01000011110100001111010000111101 | 00001111010000111101000011110100 | 00111101000011110100001111010000
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................
    // bit1 ................................ | ................................ | ................................
    // bit2 ................................ | ................................ | ................................
    // bit3 XX.XXXXXX.XX.XXXXXX.XX.XXXXXX.XX | XX.XXXXXX.XX.XXXXXX.XX.XXXXXX.XX | ................................
    // bit4 ................................ | ................................ | ................................
    // bit5 ..XX..X..X..XX..X..X..XX..X..X.. | ..XX..X..X..XX..X..X..XX..X..X.. | ................................
    // bit6 XXX.XX.XXXXXX.XX.XXXXXX.XX.XXXXX | XXX.XX.XXXXXX.XX.XXXXXX.XX.XXXXX | ................................
    // bit7 ................................ | ................................ | ................................
    // Avalanche: 16.67%

    const std::uint8_t aOriginal[96] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33,
        0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F,
        0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00,
        0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55,
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C
    };

    std::uint8_t aMaskByte = 0x96;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0xE2, 0x21, 0xAC, 0x14, 0xDE, 0x2E, 0xEB, 0x1D, 0xD1, 0x53, 0xE2, 0x21, 0xAC, 0x14, 0xDE, 0x2E,
        0xEB, 0x1D, 0xD1, 0x53, 0xE2, 0x21, 0xAC, 0x14, 0xDE, 0x2E, 0xEB, 0x1D, 0xD1, 0x53, 0xE2, 0x21,
        0xB8, 0x12, 0xCA, 0x28, 0xED, 0x1D, 0xD7, 0x47, 0xE2, 0x35, 0xB8, 0x12, 0xCA, 0x28, 0xED, 0x1D,
        0xD7, 0x47, 0xE2, 0x35, 0xB8, 0x12, 0xCA, 0x28, 0xED, 0x1D, 0xD7, 0x47, 0xE2, 0x35, 0xB8, 0x12,
        0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55,
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_I_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_I_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_I_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_I_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_I_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_I_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_J_RippleMaskBlockCipher32 {

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
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit2 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit6 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
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
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    std::uint8_t aMaskByte = 0xC1;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_J_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_J_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_J_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_J_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_J_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_J_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_K_RippleMaskBlockCipher32 {

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
    // bit1 10101010101010101010101010101010 | 10101010101010101010101001010101 | 01010101101010101010101010101010
    // bit2 10101010010101010101010110101010 | 10101010101010100101010101010101 | 10101010101010101010101001010101
    // bit3 10101010010101010101010101010101 | 10101010101010100101010101010101 | 01010101101010101010101001010101
    // bit4 10101010010101011010101001010101 | 01010101101010100101010110101010 | 10101010101010100101010110101010
    // bit5 01010101101010100101010101010101 | 10101010010101011010101001010101 | 01010101101010100101010110101010
    // bit6 10101010010101010101010110101010 | 01010101010101011010101010101010 | 10101010101010100101010101010101
    // bit7 01010101010101011010101001010101 | 10101010010101010101010110101010 | 01010101101010100101010101010101
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................
    // bit1 ........................XXXXXXXX | ........................XXXXXXXX | ................................
    // bit2 ................................ | ................................ | ................................
    // bit3 ................................ | ................................ | ................................
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | ................................
    // bit5 ................................ | ................................ | ................................
    // bit6 XXXXXXXX........XXXXXXXX........ | XXXXXXXX........XXXXXXXX........ | ................................
    // bit7 ................................ | ................................ | ................................
    // Avalanche: 14.58%

    const std::uint8_t aOriginal[96] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x4A;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0xFA, 0x05, 0xFA, 0x05, 0xFA, 0x05, 0xFA, 0x05, 0xC4, 0x3B, 0xC4, 0x3B, 0xC4, 0x3B, 0xC4, 0x3B,
        0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xE2, 0x1D, 0xE2, 0x1D, 0xE2, 0x1D, 0xE2, 0x1D,
        0xF5, 0x0A, 0xF5, 0x0A, 0xF5, 0x0A, 0xF5, 0x0A, 0xF8, 0x07, 0xF8, 0x07, 0xF8, 0x07, 0xF8, 0x07,
        0xC6, 0x39, 0xC6, 0x39, 0xC6, 0x39, 0xC6, 0x39, 0x8B, 0x74, 0x8B, 0x74, 0x8B, 0x74, 0x8B, 0x74,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_K_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_K_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_K_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_K_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_K_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_K_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_L_RippleMaskBlockCipher32 {

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
    // bit0 10000101111010000101111010000101 | 11101000010111101000010111101000 | 01011110100001011110100001011110
    // bit1 10101000010111101010111111101000 | 10000101010101010101111010000000 | 01010101010101011110100000001010
    // bit2 11101000000000010101010111101010 | 10101010101010000101010101111111 | 10101010100001010101011111111110
    // bit3 10101010000101010101010101111010 | 10101000000000010111111111101010 | 10100001010101010101011110101010
    // bit4 01010000101010000000101010101111 | 11101010111101010101010101010101 | 00001010100000001010101011111110
    // bit5 01010000000101010000101010101010 | 10101010111101010111111101010101 | 00000001010100001010101010101010
    // bit6 11101010101010101000010101010111 | 01111111111010000000000101010101 | 11111110100000000001010101011110
    // bit7 01111111010101010000000101010000 | 10101010101010101010111101010111 | 11110101010100000001010100001010
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................
    // bit1 ..X.XX.X....X.XXXXXX...X.XX.X... | ..X.XX.X....X.XXXXXX...X.XX.X... | ................................
    // bit2 .X....X.X.X.X..X........X..X.X.X | .X....X.X.X.X..X........X..X.X.X | ................................
    // bit3 ................................ | ................................ | ................................
    // bit4 ................................ | ................................ | ................................
    // bit5 ................................ | ................................ | ................................
    // bit6 X..X.X.X.X....X.X....X........X. | X..X.X.X.X....X.X....X........X. | ................................
    // bit7 ................................ | ................................ | ................................
    // Avalanche: 8.85%

    const std::uint8_t aOriginal[96] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA,
        0xFF, 0xAA, 0xFF, 0x00, 0xFF, 0x00, 0x0F, 0x00, 0x0F, 0xCC, 0x0F, 0xCC, 0xC3, 0xCC, 0xC3, 0x3C,
        0xC3, 0x3C, 0x55, 0x3C, 0x55, 0xFF, 0x55, 0xFF, 0xF0, 0xFF, 0xF0, 0x0F, 0xF0, 0x0F, 0x33, 0x0F,
        0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55, 0x00, 0xF0, 0x00, 0xF0,
        0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA, 0xFF, 0xAA, 0xFF, 0x00
    };

    std::uint8_t aMaskByte = 0x62;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0xF2, 0x2F, 0x73, 0x0D, 0x73, 0x81, 0x13, 0x81, 0x8A, 0xC1, 0x8A, 0x55, 0xCA, 0x55, 0x42, 0x35,
        0x42, 0xB0, 0x40, 0xB0, 0xCC, 0xF2, 0xCC, 0x73, 0xEC, 0x73, 0x7C, 0x13, 0x7C, 0x8A, 0x3E, 0x8A,
        0xFD, 0x8A, 0xBF, 0x02, 0xBF, 0x42, 0x2F, 0x42, 0x2F, 0xCE, 0x2F, 0xCC, 0xA3, 0xCC, 0x81, 0x5C,
        0x81, 0x7C, 0x15, 0x7C, 0x55, 0xFD, 0x55, 0xBF, 0xD0, 0xBF, 0xB0, 0x2F, 0xB0, 0x2F, 0x31, 0x2F,
        0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55, 0x00, 0xF0, 0x00, 0xF0,
        0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA, 0xFF, 0xAA, 0xFF, 0x00
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_L_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_L_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_L_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_L_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_L_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_96_L_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_A_RippleMaskBlockCipher32 {

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

    std::uint8_t aMaskByte = 0xA4;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

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
                                                    "test_fixed_128_A_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_A_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_A_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_A_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_A_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_A_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_B_RippleMaskBlockCipher32 {

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

    std::uint8_t aMaskByte = 0x0F;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

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
                                                    "test_fixed_128_B_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_B_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_B_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_B_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_B_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_B_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_C_RippleMaskBlockCipher32 {

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
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit3 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
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
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0xCC;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_C_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_C_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_C_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_C_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_C_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_C_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_D_RippleMaskBlockCipher32 {

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
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit6 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
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
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x26;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
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
                                                    "test_fixed_128_D_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_D_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_D_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_D_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_D_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_D_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_E_RippleMaskBlockCipher32 {

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
    // bit1 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit2 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit7 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
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
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x38;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_E_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_E_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_E_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_E_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_E_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_E_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_F_RippleMaskBlockCipher32 {

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
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit6 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
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

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_F_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_F_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_F_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_F_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_F_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_F_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_G_RippleMaskBlockCipher32 {

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
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 10100110101010011010101001101010 | 10101001101010100110101010011010 | 01101010100110101010011010101001 | 10011010101001101010100110101010
    // bit2 10010110101001011010100101101010 | 01011010100101101010010110101001 | 01101010010110101001011010100101 | 10101001011010100101101010010110
    // bit3 10010101101001010110100101011010 | 01010110100101011010010101101001 | 01011010010101101001010110100101 | 01101001010110100101011010010101
    // bit4 01100110100110011010011001101001 | 10011010011001101001100110100110 | 01101001100110100110011010011001 | 10100110011010011001101001100110
    // bit5 10010110011001011001100101100110 | 01100101100110010110011001011001 | 01100110010110011001011001100101 | 01011001100101100110010110011001
    // bit6 01101010010110101001011010100101 | 01011010100101101010010110101001 | 10100101101010010110101001011010 | 10101001011010100101101010010110
    // bit7 01011001100101100110010110011001 | 01100110010110011001011001100101 | 10011001011001100101100110010110 | 01100101100110010110011001011001
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................ | ................................
    // bit1 ....XXXX......XXXX......XXXX.... | ....XXXX......XXXX......XXXX.... | XXXX......XXXX......XXXX......XX | XXXX......XXXX......XXXX......XX
    // bit2 ................................ | ................................ | ................................ | ................................
    // bit3 ................................ | ................................ | ................................ | ................................
    // bit4 ................................ | ................................ | ................................ | ................................
    // bit5 XXXX..XXXXXXXX..XXXXXXXX..XXXXXX | XXXX..XXXXXXXX..XXXXXXXX..XXXXXX | ..XXXXXXXX..XXXXXXXX..XXXXXXXX.. | ..XXXXXXXX..XXXXXXXX..XXXXXXXX..
    // bit6 ..XX....XX..XX....XX..XX....XX.. | ..XX....XX..XX....XX..XX....XX.. | ....XX..XX....XX..XX....XX..XX.. | ....XX..XX....XX..XX....XX..XX..
    // bit7 ................................ | ................................ | ................................ | ................................
    // Avalanche: 19.53%

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

    std::uint8_t aMaskByte = 0x46;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xF4, 0x0B, 0xCA, 0x35, 0x83, 0x7C, 0xEE, 0x11, 0xF9, 0x06, 0xF4, 0x0B, 0xCA, 0x35, 0x83, 0x7C,
        0xEE, 0x11, 0xF9, 0x06, 0xF4, 0x0B, 0xCA, 0x35, 0x83, 0x7C, 0xEE, 0x11, 0xF9, 0x06, 0xF4, 0x0B,
        0xC8, 0x37, 0xC5, 0x3A, 0xEA, 0x15, 0xBB, 0x44, 0xF6, 0x09, 0xC8, 0x37, 0xC5, 0x3A, 0xEA, 0x15,
        0xBB, 0x44, 0xF6, 0x09, 0xC8, 0x37, 0xC5, 0x3A, 0xEA, 0x15, 0xBB, 0x44, 0xF6, 0x09, 0xC8, 0x37,
        0x83, 0x7C, 0xEE, 0x11, 0xF9, 0x06, 0xF4, 0x0B, 0xCA, 0x35, 0x83, 0x7C, 0xEE, 0x11, 0xF9, 0x06,
        0xF4, 0x0B, 0xCA, 0x35, 0x83, 0x7C, 0xEE, 0x11, 0xF9, 0x06, 0xF4, 0x0B, 0xCA, 0x35, 0x83, 0x7C,
        0xEA, 0x15, 0xBB, 0x44, 0xF6, 0x09, 0xC8, 0x37, 0xC5, 0x3A, 0xEA, 0x15, 0xBB, 0x44, 0xF6, 0x09,
        0xC8, 0x37, 0xC5, 0x3A, 0xEA, 0x15, 0xBB, 0x44, 0xF6, 0x09, 0xC8, 0x37, 0xC5, 0x3A, 0xEA, 0x15
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_G_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_G_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_G_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_G_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_G_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_G_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_H_RippleMaskBlockCipher32 {

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
    // bit1 01100101010110010101011001010101 | 10010101011001010101100101010110 | 01010101100101010110010101011001 | 01010110010101011001010101100101
    // bit2 01011010010101101001010110100101 | 01101001010110100101011010010101 | 10100101011010010101101001010110 | 10010101101001010110100101011010
    // bit3 01101010010110101001011010100101 | 10101001011010100101101010010110 | 10100101101010010110101001011010 | 10010110101001011010100101101010
    // bit4 01011001100101100110010110011001 | 01100110010110011001011001100101 | 10011001011001100101100110010110 | 01100101100110010110011001011001
    // bit5 01101001100110100110011010011001 | 10100110011010011001101001100110 | 10011001101001100110100110011010 | 01100110100110011010011001101001
    // bit6 01011010010101101001010110100101 | 01010110100101011010010101101001 | 10100101011010010101101001010110 | 01101001010110100101011010010101
    // bit7 10011010011001101001100110100110 | 01100110100110011010011001101001 | 10100110011010011001101001100110 | 01101001100110100110011010011001
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................ | ................................
    // bit1 ................................ | ................................ | ................................ | ................................
    // bit2 ................................ | ................................ | ................................ | ................................
    // bit3 ................................ | ................................ | ................................ | ................................
    // bit4 ................................ | ................................ | ................................ | ................................
    // bit5 ................................ | ................................ | ................................ | ................................
    // bit6 ....XX..XX....XX..XX....XX..XX.. | ....XX..XX....XX..XX....XX..XX.. | XX..XX....XX..XX....XX..XX....XX | XX..XX....XX..XX....XX..XX....XX
    // bit7 XXXXXX..XXXXXXXX..XXXXXXXX..XXXX | XXXXXX..XXXXXXXX..XXXXXXXX..XXXX | XX..XXXXXXXX..XXXXXXXX..XXXXXXXX | XX..XXXXXXXX..XXXXXXXX..XXXXXXXX
    // Avalanche: 15.23%

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

    std::uint8_t aMaskByte = 0x83;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x01, 0xFE, 0x54, 0xAB, 0x3F, 0xC0, 0x33, 0xCC, 0x0C, 0xF3, 0x01, 0xFE, 0x54, 0xAB, 0x3F, 0xC0,
        0x33, 0xCC, 0x0C, 0xF3, 0x01, 0xFE, 0x54, 0xAB, 0x3F, 0xC0, 0x33, 0xCC, 0x0C, 0xF3, 0x01, 0xFE,
        0x54, 0xAB, 0x3D, 0xC2, 0x30, 0xCF, 0x0F, 0xF0, 0x03, 0xFC, 0x54, 0xAB, 0x3D, 0xC2, 0x30, 0xCF,
        0x0F, 0xF0, 0x03, 0xFC, 0x54, 0xAB, 0x3D, 0xC2, 0x30, 0xCF, 0x0F, 0xF0, 0x03, 0xFC, 0x54, 0xAB,
        0x3F, 0xC0, 0x33, 0xCC, 0x0C, 0xF3, 0x01, 0xFE, 0x54, 0xAB, 0x3F, 0xC0, 0x33, 0xCC, 0x0C, 0xF3,
        0x01, 0xFE, 0x54, 0xAB, 0x3F, 0xC0, 0x33, 0xCC, 0x0C, 0xF3, 0x01, 0xFE, 0x54, 0xAB, 0x3F, 0xC0,
        0x30, 0xCF, 0x0F, 0xF0, 0x03, 0xFC, 0x54, 0xAB, 0x3D, 0xC2, 0x30, 0xCF, 0x0F, 0xF0, 0x03, 0xFC,
        0x54, 0xAB, 0x3D, 0xC2, 0x30, 0xCF, 0x0F, 0xF0, 0x03, 0xFC, 0x54, 0xAB, 0x3D, 0xC2, 0x30, 0xCF
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_H_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_H_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_H_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_H_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_H_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_H_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_I_RippleMaskBlockCipher32 {

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
    // bit1 00101011100010101110001010111000 | 10001010111000101011100010101110 | 10111000101011100010101110001010 | 10101110001010111000101011100010
    // bit2 10011000111001100011100110001110 | 11100110001110011000111001100011 | 10001110011000111001100011100110 | 01100011100110001110011000111001
    // bit3 11000110011100011001110001100111 | 00011001110001100111000110011100 | 01100111000110011100011001110001 | 10011100011001110001100111000110
    // bit4 00101111000010111100001011110000 | 10111100001011110000101111000010 | 11110000101111000010111100001011 | 11000010111100001011110000101111
    // bit5 00111101000011110100001111010000 | 00001111010000111101000011110100 | 11010000111101000011110100001111 | 11110100001111010000111101000011
    // bit6 01100011100110001110011000111001 | 10001110011000111001100011100110 | 00111001100011100110001110011000 | 11100110001110011000111001100011
    // bit7 01000011110100001111010000111101 | 00001111010000111101000011110100 | 00111101000011110100001111010000 | 11110100001111010000111101000011
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................ | ................................
    // bit1 X.X....X.XX.X....X.XX.X....X.XX. | X.X....X.XX.X....X.XX.X....X.XX. | ...X.XX.X....X.XX.X....X.XX.X... | ...X.XX.X....X.XX.X....X.XX.X...
    // bit2 .XXXXXX.XX.XXXXXX.XX.XXXXXX.XX.X | .XXXXXX.XX.XXXXXX.XX.XXXXXX.XX.X | XXX.XX.XXXXXX.XX.XXXXXX.XX.XXXXX | XXX.XX.XXXXXX.XX.XXXXXX.XX.XXXXX
    // bit3 ................................ | ................................ | ................................ | ................................
    // bit4 ................................ | ................................ | ................................ | ................................
    // bit5 ..XX..X..X..XX..X..X..XX..X..X.. | ..XX..X..X..XX..X..X..XX..X..X.. | ..X..X..XX..X..X..XX..X..X..XX.. | ..X..X..XX..X..X..XX..X..X..XX..
    // bit6 ................................ | ................................ | ................................ | ................................
    // bit7 ................................ | ................................ | ................................ | ................................
    // Avalanche: 19.53%

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

    std::uint8_t aMaskByte = 0x64;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xB0, 0x13, 0xCE, 0x24, 0xEC, 0x1C, 0xDB, 0x4F, 0xE3, 0x31, 0xB0, 0x13, 0xCE, 0x24, 0xEC, 0x1C,
        0xDB, 0x4F, 0xE3, 0x31, 0xB0, 0x13, 0xCE, 0x24, 0xEC, 0x1C, 0xDB, 0x4F, 0xE3, 0x31, 0xB0, 0x13,
        0xEA, 0x20, 0xA8, 0x18, 0xDF, 0x2F, 0xE7, 0x15, 0xD0, 0x57, 0xEA, 0x20, 0xA8, 0x18, 0xDF, 0x2F,
        0xE7, 0x15, 0xD0, 0x57, 0xEA, 0x20, 0xA8, 0x18, 0xDF, 0x2F, 0xE7, 0x15, 0xD0, 0x57, 0xEA, 0x20,
        0xEC, 0x1C, 0xDB, 0x4F, 0xE3, 0x31, 0xB0, 0x13, 0xCE, 0x24, 0xEC, 0x1C, 0xDB, 0x4F, 0xE3, 0x31,
        0xB0, 0x13, 0xCE, 0x24, 0xEC, 0x1C, 0xDB, 0x4F, 0xE3, 0x31, 0xB0, 0x13, 0xCE, 0x24, 0xEC, 0x1C,
        0xDF, 0x2F, 0xE7, 0x15, 0xD0, 0x57, 0xEA, 0x20, 0xA8, 0x18, 0xDF, 0x2F, 0xE7, 0x15, 0xD0, 0x57,
        0xEA, 0x20, 0xA8, 0x18, 0xDF, 0x2F, 0xE7, 0x15, 0xD0, 0x57, 0xEA, 0x20, 0xA8, 0x18, 0xDF, 0x2F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_I_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_I_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_I_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_I_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_I_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_I_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_J_RippleMaskBlockCipher32 {

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
    // bit0 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit1 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit2 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit3 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
    // bit4 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010 | 10101010101010101010101010101010
    // bit5 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111 | 11111111111111111111111111111111
    // bit6 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000 | 00000000000000000000000000000000
    // bit7 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101 | 01010101010101010101010101010101
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
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    std::uint8_t aMaskByte = 0x69;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_J_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_J_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_J_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_J_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_J_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_J_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_K_RippleMaskBlockCipher32 {

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
    // bit1 10101010101010101010101010101010 | 10101010101010101010101001010101 | 10101010010101011010101010101010 | 01010101101010101010101010101010
    // bit2 10101010010101010101010110101010 | 10101010101010100101010101010101 | 10101010101010101010101001010101 | 01010101101010101010101010101010
    // bit3 10101010010101010101010101010101 | 10101010101010100101010101010101 | 01010101101010101010101001010101 | 01010101010101011010101010101010
    // bit4 10101010010101011010101001010101 | 01010101101010100101010110101010 | 01010101101010101010101001010101 | 10101010101010100101010110101010
    // bit5 10101010010101011010101001010101 | 01010101101010100101010101010101 | 01010101010101011010101001010101 | 01010101101010100101010110101010
    // bit6 01010101010101011010101010101010 | 10101010010101010101010110101010 | 10101010101010100101010101010101 | 10101010101010101010101001010101
    // bit7 01010101010101011010101001010101 | 10101010010101010101010110101010 | 01010101101010100101010101010101 | 10101010010101011010101001010101
    //
    // Avalanche:
    // bit0 ................................ | ................................ | ................................ | ................................
    // bit1 ........................XXXXXXXX | ........................XXXXXXXX | XXXXXXXXXXXXXXXX................ | XXXXXXXXXXXXXXXX................
    // bit2 ................................ | ................................ | ................................ | ................................
    // bit3 ................................ | ................................ | ................................ | ................................
    // bit4 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXX........XXXXXXXXXXXXXXXX | XXXXXXXX........XXXXXXXXXXXXXXXX
    // bit5 XXXXXXXXXXXXXXXXXXXXXXXX........ | XXXXXXXXXXXXXXXXXXXXXXXX........ | ........XXXXXXXXXXXXXXXXXXXXXXXX | ........XXXXXXXXXXXXXXXXXXXXXXXX
    // bit6 ................................ | ................................ | ................................ | ................................
    // bit7 ................................ | ................................ | ................................ | ................................
    // Avalanche: 25.00%

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

    std::uint8_t aMaskByte = 0xCC;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x03, 0xC0, 0x3F, 0xC0, 0x3F, 0xC0, 0x3F, 0xC0, 0x3F,
        0xCF, 0x30, 0xCF, 0x30, 0xCF, 0x30, 0xCF, 0x30, 0xE2, 0x1D, 0xE2, 0x1D, 0xE2, 0x1D, 0xE2, 0x1D,
        0xF3, 0x0C, 0xF3, 0x0C, 0xF3, 0x0C, 0xF3, 0x0C, 0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x03,
        0xC0, 0x3F, 0xC0, 0x3F, 0xC0, 0x3F, 0xC0, 0x3F, 0x8B, 0x74, 0x8B, 0x74, 0x8B, 0x74, 0x8B, 0x74,
        0xE2, 0x1D, 0xE2, 0x1D, 0xE2, 0x1D, 0xE2, 0x1D, 0xBB, 0x44, 0xBB, 0x44, 0xBB, 0x44, 0xBB, 0x44,
        0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x03, 0xC0, 0x3F, 0xC0, 0x3F, 0xC0, 0x3F, 0xC0, 0x3F,
        0x8B, 0x74, 0x8B, 0x74, 0x8B, 0x74, 0x8B, 0x74, 0xEE, 0x11, 0xEE, 0x11, 0xEE, 0x11, 0xEE, 0x11,
        0xF3, 0x0C, 0xF3, 0x0C, 0xF3, 0x0C, 0xF3, 0x0C, 0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x03
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_K_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_K_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_K_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_K_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_K_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_K_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_L_RippleMaskBlockCipher32 {

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
    // bit0 11101000010111101000010111101000 | 10000101111010000101111010000101 | 10000101111010000101111010000101 | 01011110100001011110100001011110
    // bit1 10000101010101010101111010000000 | 10101000010111101010111111101000 | 01010101010101011110100000001010 | 10000101111010101111111010000101
    // bit2 10101010101010000101010101111111 | 11101000000000010101010111101010 | 10101010100001010101011111111110 | 10000000000101010101111010101010
    // bit3 10101000000000010111111111101010 | 10101010000101010101010101111010 | 10000000000101111111111010101010 | 10100001010101010101011110101010
    // bit4 01010000101010000000101010101111 | 11101010111101010101010101010101 | 00001010100000001010101011111110 | 10101111010101010101010101010000
    // bit5 10101010111101010111111101010101 | 01010000000101010000101010101010 | 10101111010101111111010101010000 | 00000001010100001010101010101010
    // bit6 11101010101010101000010101010111 | 01111111111010000000000101010101 | 10101010101010000101010101111111 | 11111110100000000001010101011110
    // bit7 01111111010101010000000101010000 | 10101010101010101010111101010111 | 11110101010100000001010100001010 | 10101010101010101111010101111111
    //
    // Avalanche:
    // bit0 .XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.X | .XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.X | XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX | XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX
    // bit1 ................................ | ................................ | ................................ | ................................
    // bit2 ................................ | ................................ | ................................ | ................................
    // bit3 ......X....X.X....X.X.X.X..X.... | ......X....X.X....X.X.X.X..X.... | ..X....X.X....X.X.X.X..X........ | ..X....X.X....X.X.X.X..X........
    // bit4 ................................ | ................................ | ................................ | ................................
    // bit5 XXXXX.X.XXX......XXX.X.XXXXXXXXX | XXXXX.X.XXX......XXX.X.XXXXXXXXX | X.X.XXX......XXX.X.XXXXXXXXXX.X. | X.X.XXX......XXX.X.XXXXXXXXXX.X.
    // bit6 X..X.X.X.X....X.X....X........X. | X..X.X.X.X....X.X....X........X. | .X.X.X....X.X....X........X....X | .X.X.X....X.X....X........X....X
    // bit7 ................................ | ................................ | ................................ | ................................
    // Avalanche: 23.05%

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

    std::uint8_t aMaskByte = 0x96;

    RippleMaskBlockCipher32 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xF6, 0x8B, 0xB7, 0x09, 0xB7, 0x41, 0x27, 0x41, 0x2E, 0xC5, 0x2E, 0xC5, 0xAA, 0xC5, 0x82, 0x55,
        0x82, 0x74, 0x14, 0x74, 0x5C, 0xF6, 0x5C, 0xB7, 0xD8, 0xB7, 0xB8, 0x27, 0xB8, 0x2E, 0x3A, 0x2E,
        0xF9, 0x2E, 0x7B, 0x06, 0x7B, 0x82, 0x1B, 0x82, 0x8B, 0xCA, 0x8B, 0x5C, 0xC3, 0x5C, 0x41, 0x3C,
        0x41, 0xB8, 0x41, 0xB8, 0xC5, 0xF9, 0xC5, 0x7B, 0xE4, 0x7B, 0x74, 0x1B, 0x74, 0x8B, 0x35, 0x8B,
        0xB7, 0x41, 0x27, 0x41, 0x2E, 0xC5, 0x2E, 0xC5, 0xAA, 0xC5, 0x82, 0x55, 0x82, 0x74, 0x14, 0x74,
        0x5C, 0xF6, 0x5C, 0xB7, 0xD8, 0xB7, 0xB8, 0x27, 0xB8, 0x2E, 0x3A, 0x2E, 0x7B, 0xAA, 0x7B, 0x82,
        0x7B, 0x82, 0x1B, 0x82, 0x8B, 0xCA, 0x8B, 0x5C, 0xC3, 0x5C, 0x41, 0x3C, 0x41, 0xB8, 0x41, 0xB8,
        0xC5, 0xF9, 0xC5, 0x7B, 0xE4, 0x7B, 0x74, 0x1B, 0x74, 0x8B, 0x35, 0x8B, 0xB7, 0xC3, 0xB7, 0x41
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_L_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_L_RippleMaskBlockCipher32 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_L_RippleMaskBlockCipher32 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_L_RippleMaskBlockCipher32")) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_L_RippleMaskBlockCipher32 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher32] test_fixed_128_L_RippleMaskBlockCipher32 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}
@end
