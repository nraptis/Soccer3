//
//  Battery_RippleMaskBlockCipher64.m
//  HolyStorms
//
//  Created by icarus black on 7/5/26.
//

#import <XCTest/XCTest.h>
#import "RippleMaskBlockCipher64.hpp"
#import "PrintExamplesHelper.hpp"
#import "CipherGauntlet.hpp"
#include <memory>

@interface Battery_RippleMaskBlockCipher64 : XCTestCase

@end

@implementation Battery_RippleMaskBlockCipher64

- (void)test_gauntlet_RippleMaskBlockCipher64 {
    

    
    static CipherGauntlet aGauntlet;
    
    for (auto &aMask: cMasks) {
        RippleMaskBlockCipher64 aCipher(static_cast<std::uint8_t>(aMask));
        
        if (!aGauntlet.RunCipher(&aCipher,
                                 64,
                                 "RippleMaskBlockCipher64")) {
            XCTFail("[RippleMaskBlockCipher64] test_gauntlet_RippleMaskBlockCipher64 failed.");
            return;
        }
        
    }
}

- (void)test_fixed_64_A_RippleMaskBlockCipher64 {

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

    std::uint8_t aMaskByte = 0x1A;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

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
                                                    "test_fixed_64_A_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_A_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_A_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_A_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_A_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_A_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_B_RippleMaskBlockCipher64 {

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

    std::uint8_t aMaskByte = 0xC1;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

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
                                                    "test_fixed_64_B_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_B_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_B_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_B_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_B_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_B_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_C_RippleMaskBlockCipher64 {

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
    // bit0 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010101010101010101010101010101010101010101010101010101010101010
    // bit2 1010101010101010101010101010101010101010101010101010101010101010
    // bit3 1010101010101010101010101010101010101010101010101010101010101010
    // bit4 0101010101010101010101010101010101010101010101010101010101010101
    // bit5 0101010101010101010101010101010101010101010101010101010101010101
    // bit6 0101010101010101010101010101010101010101010101010101010101010101
    // bit7 0101010101010101010101010101010101010101010101010101010101010101
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
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0x91;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

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
                                                    "test_fixed_64_C_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_C_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_C_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_C_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_C_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_C_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_D_RippleMaskBlockCipher64 {

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
    // bit0 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010101010101010101010101010101010101010101010101010101010101010
    // bit2 0101010101010101010101010101010101010101010101010101010101010101
    // bit3 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 1010101010101010101010101010101010101010101010101010101010101010
    // bit5 1010101010101010101010101010101010101010101010101010101010101010
    // bit6 0101010101010101010101010101010101010101010101010101010101010101
    // bit7 0101010101010101010101010101010101010101010101010101010101010101
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
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x83;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

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
                                                    "test_fixed_64_D_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_D_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_D_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_D_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_D_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_D_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_E_RippleMaskBlockCipher64 {

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
    // bit0 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010101010101010101010101010101010101010101010101010101010101010
    // bit2 0101010101010101010101010101010101010101010101010101010101010101
    // bit3 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 0101010101010101010101010101010101010101010101010101010101010101
    // bit5 0101010101010101010101010101010101010101010101010101010101010101
    // bit6 1010101010101010101010101010101010101010101010101010101010101010
    // bit7 1010101010101010101010101010101010101010101010101010101010101010
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
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x91;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

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
                                                    "test_fixed_64_E_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_E_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_E_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_E_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_E_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_E_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_F_RippleMaskBlockCipher64 {

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
    // bit1 0101010101010101010101010101010101010101010101010101010101010101
    // bit2 1010101010101010101010101010101010101010101010101010101010101010
    // bit3 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 1010101010101010101010101010101010101010101010101010101010101010
    // bit5 0101010101010101010101010101010101010101010101010101010101010101
    // bit6 1010101010101010101010101010101010101010101010101010101010101010
    // bit7 0101010101010101010101010101010101010101010101010101010101010101
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
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0x2C;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

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
                                                    "test_fixed_64_F_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_F_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_F_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_F_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_F_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_F_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_G_RippleMaskBlockCipher64 {

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
    // bit0 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010100110101010011010101001101010100110101010011010101001101010
    // bit2 1001011010100101101010010110101001011010100101101010010110101001
    // bit3 1001010110100101011010010101101001010110100101011010010101101001
    // bit4 0110011010011001101001100110100110011010011001101001100110100110
    // bit5 0110010110011001011001100101100110010110011001011001100101100110
    // bit6 0101101010010110101001011010100101101010010110101001011010100101
    // bit7 0101100110010110011001011001100101100110010110011001011001100101
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
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F,
        0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55,
        0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x85;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F,
        0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55,
        0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_G_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_G_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_G_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_G_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_G_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_G_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_H_RippleMaskBlockCipher64 {

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
    // bit1 0110010101011001010101100101010110010101011001010101100101010110
    // bit2 0101101001010110100101011010010101101001010110100101011010010101
    // bit3 0110101001011010100101101010010110101001011010100101101010010110
    // bit4 0101100110010110011001011001100101100110010110011001011001100101
    // bit5 0110100110011010011001101001100110100110011010011001101001100110
    // bit6 0101011010010101101001010110100101011010010101101001010110100101
    // bit7 0110011010011001101001100110100110011010011001101001100110100110
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
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF,
        0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC,
        0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA
    };

    std::uint8_t aMaskByte = 0x52;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF,
        0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC,
        0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_H_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_H_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_H_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_H_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_H_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_H_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_I_RippleMaskBlockCipher64 {

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
    // bit2 1110011000111001100011100110001110011000111001100011100110001110
    // bit3 1100011001110001100111000110011100011001110001100111000110011100
    // bit4 0010111100001011110000101111000010111100001011110000101111000010
    // bit5 0000111101000011110100001111010000111101000011110100001111010000
    // bit6 0110001110011000111001100011100110001110011000111001100011100110
    // bit7 0100001111010000111101000011110100001111010000111101000011110100
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
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33,
        0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F,
        0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00
    };

    std::uint8_t aMaskByte = 0x69;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33,
        0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F,
        0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_I_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_I_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_I_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_I_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_I_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_I_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_J_RippleMaskBlockCipher64 {

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
    // bit0 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1111111111111111111111111111111111111111111111111111111111111111
    // bit2 0000000000000000000000000000000000000000000000000000000000000000
    // bit3 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 1010101010101010101010101010101010101010101010101010101010101010
    // bit5 1111111111111111111111111111111111111111111111111111111111111111
    // bit6 0000000000000000000000000000000000000000000000000000000000000000
    // bit7 0101010101010101010101010101010101010101010101010101010101010101
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
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    std::uint8_t aMaskByte = 0x0F;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

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
                                                    "test_fixed_64_J_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_J_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_J_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_J_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_J_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_J_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_K_RippleMaskBlockCipher64 {

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
    // bit0 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010101010101010101010100101010110101010101010101010101010101010
    // bit2 1010101001010101010101011010101010101010101010100101010101010101
    // bit3 1010101001010101010101010101010110101010101010100101010101010101
    // bit4 0101010110101010010101011010101010101010010101011010101001010101
    // bit5 0101010110101010010101010101010110101010010101011010101001010101
    // bit6 0101010101010101101010101010101010101010010101010101010110101010
    // bit7 0101010101010101101010100101010110101010010101010101010110101010
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
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0xAA;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_K_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_K_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_K_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_K_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_K_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_K_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_L_RippleMaskBlockCipher64 {

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
    // bit0 1000010111101000010111101000010111101000010111101000010111101000
    // bit1 1000010101010101010111101000000010101000010111101010111111101000
    // bit2 1010101010101000010101010111111111101000000000010101010111101010
    // bit3 1010101000010101010101010111101010101000000000010111111111101010
    // bit4 0101000010101000000010101010111111101010111101010101010101010101
    // bit5 0101000000010101000010101010101010101010111101010111111101010101
    // bit6 0111111111101000000000010101010111101010101010101000010101010111
    // bit7 0111111101010101000000010101000010101010101010101010111101010111
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
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA,
        0xFF, 0xAA, 0xFF, 0x00, 0xFF, 0x00, 0x0F, 0x00, 0x0F, 0xCC, 0x0F, 0xCC, 0xC3, 0xCC, 0xC3, 0x3C,
        0xC3, 0x3C, 0x55, 0x3C, 0x55, 0xFF, 0x55, 0xFF, 0xF0, 0xFF, 0xF0, 0x0F, 0xF0, 0x0F, 0x33, 0x0F
    };

    std::uint8_t aMaskByte = 0x89;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA,
        0xFF, 0xAA, 0xFF, 0x00, 0xFF, 0x00, 0x0F, 0x00, 0x0F, 0xCC, 0x0F, 0xCC, 0xC3, 0xCC, 0xC3, 0x3C,
        0xC3, 0x3C, 0x55, 0x3C, 0x55, 0xFF, 0x55, 0xFF, 0xF0, 0xFF, 0xF0, 0x0F, 0xF0, 0x0F, 0x33, 0x0F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_L_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_L_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_L_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_L_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_L_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_64_L_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_A_RippleMaskBlockCipher64 {

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

    std::uint8_t aMaskByte = 0x33;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

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
                                                    "test_fixed_128_A_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_A_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_A_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_A_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_A_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_A_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_B_RippleMaskBlockCipher64 {

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

    std::uint8_t aMaskByte = 0x4A;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

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
                                                    "test_fixed_128_B_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_B_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_B_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_B_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_B_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_B_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_C_RippleMaskBlockCipher64 {

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
    // bit0 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit2 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit3 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit4 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit5 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit6 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit7 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
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
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0x91;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

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
                                                    "test_fixed_128_C_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_C_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_C_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_C_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_C_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_C_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_D_RippleMaskBlockCipher64 {

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
    // bit3 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit5 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit6 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit7 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
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
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x25;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

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
                                                    "test_fixed_128_D_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_D_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_D_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_D_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_D_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_D_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_E_RippleMaskBlockCipher64 {

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
    // bit0 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit2 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit3 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit5 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit6 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit7 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
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
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x55;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

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
                                                    "test_fixed_128_E_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_E_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_E_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_E_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_E_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_E_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_F_RippleMaskBlockCipher64 {

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
    // bit0 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit2 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit3 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit5 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit6 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit7 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
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
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0x98;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

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
                                                    "test_fixed_128_F_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_F_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_F_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_F_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_F_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_F_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_G_RippleMaskBlockCipher64 {

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
    // bit0 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1001101010100110101010011010101001101010100110101010011010101001 | 1010100110101010011010101001101010100110101010011010101001101010
    // bit2 1001011010100101101010010110101001011010100101101010010110101001 | 0110101001011010100101101010010110101001011010100101101010010110
    // bit3 1001010110100101011010010101101001010110100101011010010101101001 | 0101101001010110100101011010010101101001010110100101011010010101
    // bit4 0110011010011001101001100110100110011010011001101001100110100110 | 0110100110011010011001101001100110100110011010011001101001100110
    // bit5 0110010110011001011001100101100110010110011001011001100101100110 | 0101100110010110011001011001100101100110010110011001011001100101
    // bit6 0101101010010110101001011010100101101010010110101001011010100101 | 1010100101101010010110101001011010100101101010010110101001011010
    // bit7 1001100101100110010110011001011001100101100110010110011001011001 | 0101100110010110011001011001100101100110010110011001011001100101
    //
    // Avalanche:
    // bit0 ................................................................ | ................................................................
    // bit1 ..XX..XX....XX..XX....XX..XX....XX..XX....XX..XX....XX..XX....XX | ..XX..XX....XX..XX....XX..XX....XX..XX....XX..XX....XX..XX....XX
    // bit2 ................................................................ | ................................................................
    // bit3 ................................................................ | ................................................................
    // bit4 ................................................................ | ................................................................
    // bit5 ................................................................ | ................................................................
    // bit6 ................................................................ | ................................................................
    // bit7 XX......XXXX......XXXX......XXXX......XXXX......XXXX......XXXX.. | XX......XXXX......XXXX......XXXX......XXXX......XXXX......XXXX..
    // Avalanche: 10.16%

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

    std::uint8_t aMaskByte = 0xC1;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xF1, 0x0E, 0x8C, 0x73, 0xC3, 0x3C, 0xEA, 0x15, 0xFE, 0x01, 0xF1, 0x0E, 0x8C, 0x73, 0xC3, 0x3C,
        0xEA, 0x15, 0xFE, 0x01, 0xF1, 0x0E, 0x8C, 0x73, 0xC3, 0x3C, 0xEA, 0x15, 0xFE, 0x01, 0xF1, 0x0E,
        0x8C, 0x73, 0xC3, 0x3C, 0xEA, 0x15, 0xFE, 0x01, 0xF1, 0x0E, 0x8C, 0x73, 0xC3, 0x3C, 0xEA, 0x15,
        0xFE, 0x01, 0xF1, 0x0E, 0x8C, 0x73, 0xC3, 0x3C, 0xEA, 0x15, 0xFE, 0x01, 0xF1, 0x0E, 0x8C, 0x73,
        0xC2, 0x3D, 0xEA, 0x15, 0xFF, 0x00, 0xB0, 0x4F, 0xCD, 0x32, 0xC2, 0x3D, 0xEA, 0x15, 0xFF, 0x00,
        0xB0, 0x4F, 0xCD, 0x32, 0xC2, 0x3D, 0xEA, 0x15, 0xFF, 0x00, 0xB0, 0x4F, 0xCD, 0x32, 0xC2, 0x3D,
        0xEA, 0x15, 0xFF, 0x00, 0xB0, 0x4F, 0xCD, 0x32, 0xC2, 0x3D, 0xEA, 0x15, 0xFF, 0x00, 0xB0, 0x4F,
        0xCD, 0x32, 0xC2, 0x3D, 0xEA, 0x15, 0xFF, 0x00, 0xB0, 0x4F, 0xCD, 0x32, 0xC2, 0x3D, 0xEA, 0x15
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_G_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_G_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_G_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_G_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_G_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_G_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_H_RippleMaskBlockCipher64 {

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
    // bit1 0110010101011001010101100101010110010101011001010101100101010110 | 0101010110010101011001010101100101010110010101011001010101100101
    // bit2 1010010101101001010110100101011010010101101001010110100101011010 | 0101101001010110100101011010010101101001010110100101011010010101
    // bit3 0110101001011010100101101010010110101001011010100101101010010110 | 1010010110101001011010100101101010010110101001011010100101101010
    // bit4 0101100110010110011001011001100101100110010110011001011001100101 | 1001100101100110010110011001011001100101100110010110011001011001
    // bit5 1001100110100110011010011001101001100110100110011010011001101001 | 0110100110011010011001101001100110100110011010011001101001100110
    // bit6 0110100101011010010101101001010110100101011010010101101001010110 | 0101011010010101101001010110100101011010010101101001010110100101
    // bit7 0110011010011001101001100110100110011010011001101001100110100110 | 0110100110011010011001101001100110100110011010011001101001100110
    //
    // Avalanche:
    // bit0 ................................................................ | ................................................................
    // bit1 ................................................................ | ................................................................
    // bit2 XXXXXXXX..XXXXXXXX..XXXXXXXX..XXXXXXXX..XXXXXXXX..XXXXXXXX..XXXX | XXXXXXXX..XXXXXXXX..XXXXXXXX..XXXXXXXX..XXXXXXXX..XXXXXXXX..XXXX
    // bit3 ................................................................ | ................................................................
    // bit4 ................................................................ | ................................................................
    // bit5 XXXX......XXXX......XXXX......XXXX......XXXX......XXXX......XXXX | XXXX......XXXX......XXXX......XXXX......XXXX......XXXX......XXXX
    // bit6 ..XXXXXXXX..XXXXXXXX..XXXXXXXX..XXXXXXXX..XXXXXXXX..XXXXXXXX..XX | ..XXXXXXXX..XXXXXXXX..XXXXXXXX..XXXXXXXX..XXXXXXXX..XXXXXXXX..XX
    // bit7 ................................................................ | ................................................................
    // Avalanche: 25.39%

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

    std::uint8_t aMaskByte = 0x26;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x24, 0xDB, 0x73, 0x8C, 0x1E, 0xE1, 0x11, 0xEE, 0x0D, 0xF2, 0x24, 0xDB, 0x73, 0x8C, 0x1E, 0xE1,
        0x11, 0xEE, 0x0D, 0xF2, 0x24, 0xDB, 0x73, 0x8C, 0x1E, 0xE1, 0x11, 0xEE, 0x0D, 0xF2, 0x24, 0xDB,
        0x73, 0x8C, 0x1E, 0xE1, 0x11, 0xEE, 0x0D, 0xF2, 0x24, 0xDB, 0x73, 0x8C, 0x1E, 0xE1, 0x11, 0xEE,
        0x0D, 0xF2, 0x24, 0xDB, 0x73, 0x8C, 0x1E, 0xE1, 0x11, 0xEE, 0x0D, 0xF2, 0x24, 0xDB, 0x73, 0x8C,
        0x18, 0xE7, 0x15, 0xEA, 0x2D, 0xD2, 0x22, 0xDD, 0x57, 0xA8, 0x18, 0xE7, 0x15, 0xEA, 0x2D, 0xD2,
        0x22, 0xDD, 0x57, 0xA8, 0x18, 0xE7, 0x15, 0xEA, 0x2D, 0xD2, 0x22, 0xDD, 0x57, 0xA8, 0x18, 0xE7,
        0x15, 0xEA, 0x2D, 0xD2, 0x22, 0xDD, 0x57, 0xA8, 0x18, 0xE7, 0x15, 0xEA, 0x2D, 0xD2, 0x22, 0xDD,
        0x57, 0xA8, 0x18, 0xE7, 0x15, 0xEA, 0x2D, 0xD2, 0x22, 0xDD, 0x57, 0xA8, 0x18, 0xE7, 0x15, 0xEA
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_H_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_H_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_H_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_H_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_H_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_H_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_I_RippleMaskBlockCipher64 {

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
    // bit0 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 1010111000101011100010101110001010111000101011100010101110001010 | 1000101011100010101110001010111000101011100010101110001010111000
    // bit2 1110011000111001100011100110001110011000111001100011100110001110 | 0110001110011000111001100011100110001110011000111001100011100110
    // bit3 1100011001110001100111000110011100011001110001100111000110011100 | 0110011100011001110001100111000110011100011001110001100111000110
    // bit4 0010111100001011110000101111000010111100001011110000101111000010 | 1111000010111100001011110000101111000010111100001011110000101111
    // bit5 1111010000111101000011110100001111010000111101000011110100001111 | 0000111101000011110100001111010000111101000011110100001111010000
    // bit6 0011100110001110011000111001100011100110001110011000111001100011 | 0110001110011000111001100011100110001110011000111001100011100110
    // bit7 0100001111010000111101000011110100001111010000111101000011110100 | 0011110100001111010000111101000011110100001111010000111101000011
    //
    // Avalanche:
    // bit0 ................................................................ | ................................................................
    // bit1 ..X..X..XX..X..X..XX..X..X..XX..X..X..XX..X..X..XX..X..X..XX..X. | ..X..X..XX..X..X..XX..X..X..XX..X..X..XX..X..X..XX..X..X..XX..X.
    // bit2 ................................................................ | ................................................................
    // bit3 ................................................................ | ................................................................
    // bit4 ................................................................ | ................................................................
    // bit5 XXXXX.XX.XXXXXX.XX.XXXXXX.XX.XXXXXX.XX.XXXXXX.XX.XXXXXX.XX.XXXXX | XXXXX.XX.XXXXXX.XX.XXXXXX.XX.XXXXXX.XX.XXXXXX.XX.XXXXXX.XX.XXXXX
    // bit6 .X.XX.X....X.XX.X....X.XX.X....X.XX.X....X.XX.X....X.XX.X....X.X | .X.XX.X....X.XX.X....X.XX.X....X.XX.X....X.XX.X....X.XX.X....X.X
    // bit7 ................................................................ | ................................................................
    // Avalanche: 20.12%

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

    std::uint8_t aMaskByte = 0x46;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xF4, 0x35, 0xEE, 0x06, 0xCA, 0x7C, 0xF9, 0x0B, 0x83, 0x11, 0xF4, 0x35, 0xEE, 0x06, 0xCA, 0x7C,
        0xF9, 0x0B, 0x83, 0x11, 0xF4, 0x35, 0xEE, 0x06, 0xCA, 0x7C, 0xF9, 0x0B, 0x83, 0x11, 0xF4, 0x35,
        0xEE, 0x06, 0xCA, 0x7C, 0xF9, 0x0B, 0x83, 0x11, 0xF4, 0x35, 0xEE, 0x06, 0xCA, 0x7C, 0xF9, 0x0B,
        0x83, 0x11, 0xF4, 0x35, 0xEE, 0x06, 0xCA, 0x7C, 0xF9, 0x0B, 0x83, 0x11, 0xF4, 0x35, 0xEE, 0x06,
        0xC8, 0x3A, 0xBB, 0x09, 0xC5, 0x15, 0xF6, 0x37, 0xEA, 0x44, 0xC8, 0x3A, 0xBB, 0x09, 0xC5, 0x15,
        0xF6, 0x37, 0xEA, 0x44, 0xC8, 0x3A, 0xBB, 0x09, 0xC5, 0x15, 0xF6, 0x37, 0xEA, 0x44, 0xC8, 0x3A,
        0xBB, 0x09, 0xC5, 0x15, 0xF6, 0x37, 0xEA, 0x44, 0xC8, 0x3A, 0xBB, 0x09, 0xC5, 0x15, 0xF6, 0x37,
        0xEA, 0x44, 0xC8, 0x3A, 0xBB, 0x09, 0xC5, 0x15, 0xF6, 0x37, 0xEA, 0x44, 0xC8, 0x3A, 0xBB, 0x09
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_I_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_I_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_I_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_I_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_I_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_I_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_J_RippleMaskBlockCipher64 {

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
    // bit3 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
    // bit4 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit5 1111111111111111111111111111111111111111111111111111111111111111 | 1111111111111111111111111111111111111111111111111111111111111111
    // bit6 0000000000000000000000000000000000000000000000000000000000000000 | 0000000000000000000000000000000000000000000000000000000000000000
    // bit7 0101010101010101010101010101010101010101010101010101010101010101 | 0101010101010101010101010101010101010101010101010101010101010101
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
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    std::uint8_t aMaskByte = 0x89;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

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
                                                    "test_fixed_128_J_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_J_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_J_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_J_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_J_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_J_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_K_RippleMaskBlockCipher64 {

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
    // bit0 1010101010101010101010101010101010101010101010101010101010101010 | 1010101010101010101010101010101010101010101010101010101010101010
    // bit1 0101010110101010101010101010101010101010010101011010101010101010 | 1010101010101010101010100101010110101010101010101010101010101010
    // bit2 1010101010101010101010100101010101010101101010101010101010101010 | 1010101001010101010101011010101010101010101010100101010101010101
    // bit3 0101010110101010101010100101010101010101010101011010101010101010 | 1010101001010101010101010101010110101010101010100101010101010101
    // bit4 0101010110101010010101011010101010101010010101011010101001010101 | 1010101010101010010101011010101001010101101010101010101001010101
    // bit5 0101010110101010010101010101010110101010010101011010101001010101 | 0101010110101010010101011010101001010101010101011010101001010101
    // bit6 0101010101010101101010101010101010101010010101010101010110101010 | 1010101010101010010101010101010110101010101010101010101001010101
    // bit7 0101010101010101101010100101010110101010010101010101010110101010 | 0101010110101010010101010101010110101010010101011010101001010101
    //
    // Avalanche:
    // bit0 ................................................................ | ................................................................
    // bit1 XXXXXXXX................XXXXXXXX........XXXXXXXX................ | XXXXXXXX................XXXXXXXX........XXXXXXXX................
    // bit2 ........XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX........XXXXXXXXXXXXXXXX | ........XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX........XXXXXXXXXXXXXXXX
    // bit3 XXXXXXXXXXXXXXXXXXXXXXXX........XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX | XXXXXXXXXXXXXXXXXXXXXXXX........XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    // bit4 ................................................................ | ................................................................
    // bit5 ................................................................ | ................................................................
    // bit6 ................................................................ | ................................................................
    // bit7 ................................................................ | ................................................................
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

    std::uint8_t aMaskByte = 0xF0;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x03,
        0xF3, 0x0C, 0xF3, 0x0C, 0xF3, 0x0C, 0xF3, 0x0C, 0xCA, 0x35, 0xCA, 0x35, 0xCA, 0x35, 0xCA, 0x35,
        0xCF, 0x30, 0xCF, 0x30, 0xCF, 0x30, 0xCF, 0x30, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F,
        0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x03, 0xFC, 0x03, 0xF3, 0x0C, 0xF3, 0x0C, 0xF3, 0x0C, 0xF3, 0x0C,
        0xFA, 0x05, 0xFA, 0x05, 0xFA, 0x05, 0xFA, 0x05, 0xCF, 0x30, 0xCF, 0x30, 0xCF, 0x30, 0xCF, 0x30,
        0xC0, 0x3F, 0xC0, 0x3F, 0xC0, 0x3F, 0xC0, 0x3F, 0xAC, 0x53, 0xAC, 0x53, 0xAC, 0x53, 0xAC, 0x53,
        0xF3, 0x0C, 0xF3, 0x0C, 0xF3, 0x0C, 0xF3, 0x0C, 0xFA, 0x05, 0xFA, 0x05, 0xFA, 0x05, 0xFA, 0x05,
        0xCF, 0x30, 0xCF, 0x30, 0xCF, 0x30, 0xCF, 0x30, 0xC0, 0x3F, 0xC0, 0x3F, 0xC0, 0x3F, 0xC0, 0x3F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_K_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_K_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_K_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_K_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_K_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_K_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_L_RippleMaskBlockCipher64 {

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
    // bit0 0101111010000101111010000101111010000101111010000101111010000101 | 1000010111101000010111101000010111101000010111101000010111101000
    // bit1 0101010101010101111010000000101010000101111010101111111010000101 | 1000010101010101010111101000000010101000010111101010111111101000
    // bit2 1010101010101000010101010111111111101000000000010101010111101010 | 1010101010000101010101111111111010000000000101010101111010101010
    // bit3 1010101000010101010101010111101010101000000000010111111111101010 | 1010000101010101010101111010101010000000000101111111111010101010
    // bit4 0101000010101000000010101010111111101010111101010101010101010101 | 0000101010000000101010101111111010101111010101010101010101010000
    // bit5 0101000000010101000010101010101010101010111101010111111101010101 | 0000000101010000101010101010101010101111010101111111010101010000
    // bit6 1111111010000000000101010101111010101010101010000101010101111111 | 0111111111101000000000010101010111101010101010101000010101010111
    // bit7 0111111101010101000000010101000010101010101010101010111101010111 | 1111010101010000000101010000101010101010101010101111010101111111
    //
    // Avalanche:
    // bit0 XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.X | XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.XX.X
    // bit1 XX.X............X.XX.XX.X...X.X...X.XX.XX.XX.X...X.X...X.XX.XX.X | XX.X............X.XX.XX.X...X.X...X.XX.XX.XX.X...X.X...X.XX.XX.X
    // bit2 ................................................................ | ................................................................
    // bit3 ................................................................ | ................................................................
    // bit4 ................................................................ | ................................................................
    // bit5 ................................................................ | ................................................................
    // bit6 X......X.XX.X......X.X......X.XX.X............X.XX.X......X.X... | X......X.XX.X......X.X......X.XX.X............X.XX.X......X.X...
    // bit7 ................................................................ | ................................................................
    // Avalanche: 16.99%

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

    std::uint8_t aMaskByte = 0xC2;

    RippleMaskBlockCipher64 aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x32, 0xCF, 0x33, 0xCF, 0xB3, 0xC3, 0xB3, 0x41, 0xAA, 0x41, 0x28, 0x55, 0x28, 0xD5, 0x00, 0xD5,
        0xC0, 0xF0, 0xC0, 0x32, 0xCC, 0x32, 0x0C, 0x33, 0x0C, 0xB3, 0x3C, 0xB3, 0xFE, 0xAA, 0xFE, 0x28,
        0xFF, 0x28, 0x3F, 0x00, 0x3F, 0xC0, 0x0F, 0xC0, 0xCF, 0xCC, 0xCF, 0x0C, 0xC3, 0x0C, 0x41, 0x3C,
        0x41, 0xFE, 0x55, 0xFE, 0xD5, 0xFF, 0xD5, 0x3F, 0xF0, 0x3F, 0x32, 0x0F, 0x32, 0xCF, 0x33, 0xCF,
        0xF1, 0x03, 0x33, 0x03, 0x2A, 0xC3, 0x2A, 0xD7, 0xAA, 0xD7, 0x82, 0x55, 0x82, 0x70, 0x00, 0x70,
        0x0C, 0xF0, 0x0C, 0xF1, 0xCC, 0xF1, 0xFC, 0x33, 0xFC, 0x2A, 0x3C, 0x2A, 0x3D, 0xAA, 0x3D, 0x82,
        0xFF, 0x82, 0xCF, 0x00, 0xCF, 0x0C, 0x0F, 0x0C, 0x03, 0xCC, 0x03, 0xFC, 0xC3, 0xFC, 0xD7, 0x3C,
        0xD7, 0x3D, 0x55, 0x3D, 0x70, 0xFF, 0x70, 0xCF, 0xF0, 0xCF, 0xF1, 0x0F, 0xF1, 0x03, 0x33, 0x03
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_L_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_L_RippleMaskBlockCipher64 failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_L_RippleMaskBlockCipher64 failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_L_RippleMaskBlockCipher64")) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_L_RippleMaskBlockCipher64 failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[RippleMaskBlockCipher64] test_fixed_128_L_RippleMaskBlockCipher64 failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

@end
