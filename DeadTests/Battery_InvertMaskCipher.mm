//
//  Battery_PasswordAddCipher.m
//  HolyStorms
//
//  Created by Icarus Black on 7/31/26.
//

#import <XCTest/XCTest.h>
#import "InvertMaskCipher.hpp"
#import "PrintExamplesHelper.hpp"
#import "CipherGauntlet.hpp"
#include <memory>

@interface Battery_InvertMaskCipher : XCTestCase

@end

@implementation Battery_InvertMaskCipher

- (void)test_gauntlet_InvertMaskCipher {
    

    
    static CipherGauntlet aGauntlet;
    
    for (auto &aMask: cMasks) {
        InvertMaskCipher aCipher(static_cast<std::uint8_t>(aMask));
        
        if (!aGauntlet.RunCipher(&aCipher,
                                 16,
                                 "InvertMaskCipher")) {
            XCTFail("[InvertMaskCipher] test_gauntlet_InvertMaskCipher failed.");
            return;
        }
        
    }
}

- (void)test_fixed_16_A_InvertMaskCipher {

    // Before Cipher:
    // bit0 00000000  00000000
    // bit1 00000000  00000000
    // bit2 00000000  00000000
    // bit3 00000000  00000000
    // bit4 00000000  00000000
    // bit5 00000000  00000000
    // bit6 00000000  00000000
    // bit7 00000000  00000000
    //
    // After Cipher:
    // bit0 11111111  11111111
    // bit1 00000000  00000000
    // bit2 00000000  00000000
    // bit3 11111111  11111111
    // bit4 00000000  00000000
    // bit5 00000000  00000000
    // bit6 00000000  00000000
    // bit7 11111111  11111111
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX
    // bit1 ........  ........
    // bit2 ........  ........
    // bit3 XXXXXXXX  XXXXXXXX
    // bit4 ........  ........
    // bit5 ........  ........
    // bit6 ........  ........
    // bit7 XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[16] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    std::uint8_t aMaskByte = 0x91;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[16] = {
        0x91, 0x91, 0x91, 0x91, 0x91, 0x91, 0x91, 0x91, 0x91, 0x91, 0x91, 0x91, 0x91, 0x91, 0x91, 0x91
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_A_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_A_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_A_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_A_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_A_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_A_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_B_InvertMaskCipher {

    // Before Cipher:
    // bit0 11111111  11111111
    // bit1 11111111  11111111
    // bit2 11111111  11111111
    // bit3 11111111  11111111
    // bit4 11111111  11111111
    // bit5 11111111  11111111
    // bit6 11111111  11111111
    // bit7 11111111  11111111
    //
    // After Cipher:
    // bit0 00000000  00000000
    // bit1 11111111  11111111
    // bit2 11111111  11111111
    // bit3 11111111  11111111
    // bit4 11111111  11111111
    // bit5 00000000  00000000
    // bit6 11111111  11111111
    // bit7 00000000  00000000
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX
    // bit1 ........  ........
    // bit2 ........  ........
    // bit3 ........  ........
    // bit4 ........  ........
    // bit5 XXXXXXXX  XXXXXXXX
    // bit6 ........  ........
    // bit7 XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[16] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    std::uint8_t aMaskByte = 0x85;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[16] = {
        0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_B_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_B_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_B_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_B_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_B_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_B_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_C_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010
    // bit1 10101010  10101010
    // bit2 10101010  10101010
    // bit3 10101010  10101010
    // bit4 01010101  01010101
    // bit5 01010101  01010101
    // bit6 01010101  01010101
    // bit7 01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010
    // bit1 10101010  10101010
    // bit2 01010101  01010101
    // bit3 10101010  10101010
    // bit4 01010101  01010101
    // bit5 10101010  10101010
    // bit6 10101010  10101010
    // bit7 01010101  01010101
    //
    // Avalanche:
    // bit0 ........  ........
    // bit1 ........  ........
    // bit2 XXXXXXXX  XXXXXXXX
    // bit3 ........  ........
    // bit4 ........  ........
    // bit5 XXXXXXXX  XXXXXXXX
    // bit6 XXXXXXXX  XXXXXXXX
    // bit7 ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[16] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0x26;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[16] = {
        0xD6, 0x29, 0xD6, 0x29, 0xD6, 0x29, 0xD6, 0x29, 0xD6, 0x29, 0xD6, 0x29, 0xD6, 0x29, 0xD6, 0x29
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_C_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_C_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_C_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_C_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_C_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_C_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_D_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010
    // bit1 10101010  10101010
    // bit2 01010101  01010101
    // bit3 01010101  01010101
    // bit4 10101010  10101010
    // bit5 10101010  10101010
    // bit6 01010101  01010101
    // bit7 01010101  01010101
    //
    // After Cipher:
    // bit0 01010101  01010101
    // bit1 10101010  10101010
    // bit2 01010101  01010101
    // bit3 01010101  01010101
    // bit4 10101010  10101010
    // bit5 10101010  10101010
    // bit6 10101010  10101010
    // bit7 10101010  10101010
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX
    // bit1 ........  ........
    // bit2 ........  ........
    // bit3 ........  ........
    // bit4 ........  ........
    // bit5 ........  ........
    // bit6 XXXXXXXX  XXXXXXXX
    // bit7 XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[16] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x83;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[16] = {
        0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0, 0x4F, 0xB0
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_D_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_D_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_D_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_D_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_D_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_D_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_E_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010
    // bit1 10101010  10101010
    // bit2 01010101  01010101
    // bit3 01010101  01010101
    // bit4 01010101  01010101
    // bit5 01010101  01010101
    // bit6 10101010  10101010
    // bit7 10101010  10101010
    //
    // After Cipher:
    // bit0 10101010  10101010
    // bit1 10101010  10101010
    // bit2 10101010  10101010
    // bit3 10101010  10101010
    // bit4 01010101  01010101
    // bit5 01010101  01010101
    // bit6 01010101  01010101
    // bit7 01010101  01010101
    //
    // Avalanche:
    // bit0 ........  ........
    // bit1 ........  ........
    // bit2 XXXXXXXX  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX
    // bit4 ........  ........
    // bit5 ........  ........
    // bit6 XXXXXXXX  XXXXXXXX
    // bit7 XXXXXXXX  XXXXXXXX
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[16] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x33;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[16] = {
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
                                                    "test_fixed_16_E_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_E_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_E_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_E_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_E_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_E_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_F_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010
    // bit1 01010101  01010101
    // bit2 10101010  10101010
    // bit3 01010101  01010101
    // bit4 10101010  10101010
    // bit5 01010101  01010101
    // bit6 10101010  10101010
    // bit7 01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010
    // bit1 01010101  01010101
    // bit2 01010101  01010101
    // bit3 01010101  01010101
    // bit4 10101010  10101010
    // bit5 10101010  10101010
    // bit6 01010101  01010101
    // bit7 01010101  01010101
    //
    // Avalanche:
    // bit0 ........  ........
    // bit1 ........  ........
    // bit2 XXXXXXXX  XXXXXXXX
    // bit3 ........  ........
    // bit4 ........  ........
    // bit5 XXXXXXXX  XXXXXXXX
    // bit6 XXXXXXXX  XXXXXXXX
    // bit7 ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[16] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0x26;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[16] = {
        0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_F_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_F_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_F_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_F_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_F_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_F_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_G_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010
    // bit1 10101001  10101010
    // bit2 10010110  10100101
    // bit3 10010101  10100101
    // bit4 01100110  10011001
    // bit5 01100101  10011001
    // bit6 01011010  10010110
    // bit7 01011001  10010110
    //
    // After Cipher:
    // bit0 10101010  10101010
    // bit1 01010110  01010101
    // bit2 01101001  01011010
    // bit3 10010101  10100101
    // bit4 01100110  10011001
    // bit5 01100101  10011001
    // bit6 10100101  01101001
    // bit7 01011001  10010110
    //
    // Avalanche:
    // bit0 ........  ........
    // bit1 XXXXXXXX  XXXXXXXX
    // bit2 XXXXXXXX  XXXXXXXX
    // bit3 ........  ........
    // bit4 ........  ........
    // bit5 ........  ........
    // bit6 XXXXXXXX  XXXXXXXX
    // bit7 ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[16] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x62;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[16] = {
        0x92, 0x6D, 0xAE, 0x51, 0xA1, 0x5E, 0xC8, 0x37, 0x9D, 0x62, 0x92, 0x6D, 0xAE, 0x51, 0xA1, 0x5E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_G_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_G_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_G_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_G_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_G_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_G_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_H_InvertMaskCipher {

    // Before Cipher:
    // bit0 01010101  01010101
    // bit1 01100101  01011001
    // bit2 01011010  01010110
    // bit3 01101010  01011010
    // bit4 01011001  10010110
    // bit5 01101001  10011010
    // bit6 01010110  10010101
    // bit7 01100110  10011001
    //
    // After Cipher:
    // bit0 01010101  01010101
    // bit1 01100101  01011001
    // bit2 01011010  01010110
    // bit3 10010101  10100101
    // bit4 10100110  01101001
    // bit5 01101001  10011010
    // bit6 01010110  10010101
    // bit7 10011001  01100110
    //
    // Avalanche:
    // bit0 ........  ........
    // bit1 ........  ........
    // bit2 ........  ........
    // bit3 XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX
    // bit5 ........  ........
    // bit6 ........  ........
    // bit7 XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[16] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3
    };

    std::uint8_t aMaskByte = 0x19;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[16] = {
        0x19, 0xE6, 0x4C, 0xB3, 0x25, 0xDA, 0x2A, 0xD5, 0x16, 0xE9, 0x19, 0xE6, 0x4C, 0xB3, 0x25, 0xDA
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_H_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_H_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_H_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_H_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_H_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_H_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_I_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010
    // bit1 10001010  11100010
    // bit2 11100110  00111001
    // bit3 11000110  01110001
    // bit4 00101111  00001011
    // bit5 00001111  01000011
    // bit6 01100011  10011000
    // bit7 01000011  11010000
    //
    // After Cipher:
    // bit0 01010101  01010101
    // bit1 01110101  00011101
    // bit2 00011001  11000110
    // bit3 00111001  10001110
    // bit4 00101111  00001011
    // bit5 00001111  01000011
    // bit6 01100011  10011000
    // bit7 01000011  11010000
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX
    // bit1 XXXXXXXX  XXXXXXXX
    // bit2 XXXXXXXX  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX
    // bit4 ........  ........
    // bit5 ........  ........
    // bit6 ........  ........
    // bit7 ........  ........
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[16] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C
    };

    std::uint8_t aMaskByte = 0xF0;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[16] = {
        0x00, 0xC3, 0x5A, 0xF0, 0x3C, 0xCC, 0x0F, 0xFF, 0x33, 0xA5, 0x00, 0xC3, 0x5A, 0xF0, 0x3C, 0xCC
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_I_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_I_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_I_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_I_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_I_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_I_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_J_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010
    // bit1 11111111  11111111
    // bit2 00000000  00000000
    // bit3 01010101  01010101
    // bit4 10101010  10101010
    // bit5 11111111  11111111
    // bit6 00000000  00000000
    // bit7 01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010
    // bit1 11111111  11111111
    // bit2 11111111  11111111
    // bit3 10101010  10101010
    // bit4 10101010  10101010
    // bit5 11111111  11111111
    // bit6 11111111  11111111
    // bit7 10101010  10101010
    //
    // Avalanche:
    // bit0 ........  ........
    // bit1 ........  ........
    // bit2 XXXXXXXX  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX
    // bit4 ........  ........
    // bit5 ........  ........
    // bit6 XXXXXXXX  XXXXXXXX
    // bit7 XXXXXXXX  XXXXXXXX
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[16] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    std::uint8_t aMaskByte = 0x33;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[16] = {
        0xFF, 0x66, 0xFF, 0x66, 0xFF, 0x66, 0xFF, 0x66, 0xFF, 0x66, 0xFF, 0x66, 0xFF, 0x66, 0xFF, 0x66
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_J_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_J_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_J_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_J_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_J_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_J_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_K_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010
    // bit1 10101010  10101010
    // bit2 10101010  01010101
    // bit3 10101010  01010101
    // bit4 01010101  10101010
    // bit5 01010101  10101010
    // bit6 01010101  01010101
    // bit7 01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010
    // bit1 10101010  10101010
    // bit2 01010101  10101010
    // bit3 10101010  01010101
    // bit4 01010101  10101010
    // bit5 10101010  01010101
    // bit6 01010101  01010101
    // bit7 10101010  10101010
    //
    // Avalanche:
    // bit0 ........  ........
    // bit1 ........  ........
    // bit2 XXXXXXXX  XXXXXXXX
    // bit3 ........  ........
    // bit4 ........  ........
    // bit5 XXXXXXXX  XXXXXXXX
    // bit6 ........  ........
    // bit7 XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[16] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x25;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[16] = {
        0xD5, 0x2A, 0xD5, 0x2A, 0xD5, 0x2A, 0xD5, 0x2A, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_K_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_K_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_K_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_K_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_K_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_K_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_L_InvertMaskCipher {

    // Before Cipher:
    // bit0 10000101  11101000
    // bit1 10000101  01010101
    // bit2 10101010  10101000
    // bit3 10101010  00010101
    // bit4 01010000  10101000
    // bit5 01010000  00010101
    // bit6 01111111  11101000
    // bit7 01111111  01010101
    //
    // After Cipher:
    // bit0 10000101  11101000
    // bit1 01111010  10101010
    // bit2 01010101  01010111
    // bit3 10101010  00010101
    // bit4 01010000  10101000
    // bit5 10101111  11101010
    // bit6 01111111  11101000
    // bit7 01111111  01010101
    //
    // Avalanche:
    // bit0 ........  ........
    // bit1 XXXXXXXX  XXXXXXXX
    // bit2 XXXXXXXX  XXXXXXXX
    // bit3 ........  ........
    // bit4 ........  ........
    // bit5 XXXXXXXX  XXXXXXXX
    // bit6 ........  ........
    // bit7 ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[16] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55
    };

    std::uint8_t aMaskByte = 0x64;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[16] = {
        0x94, 0x6B, 0x57, 0x6B, 0x57, 0xA7, 0x57, 0xA7, 0xCE, 0xA7, 0xCE, 0x31, 0xCE, 0x31, 0x64, 0x31
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_L_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_L_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_L_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_L_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_16_L_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_16_L_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_A_InvertMaskCipher {

    // Before Cipher:
    // bit0 00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000
    //
    // After Cipher:
    // bit0 00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000
    // bit2 11111111  11111111  11111111  11111111
    // bit3 11111111  11111111  11111111  11111111
    // bit4 00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000
    // bit6 11111111  11111111  11111111  11111111
    // bit7 11111111  11111111  11111111  11111111
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........
    // bit1 ........  ........  ........  ........
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........
    // bit5 ........  ........  ........  ........
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    std::uint8_t aMaskByte = 0x33;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33,
        0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_A_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_A_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_A_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_A_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_A_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_A_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_B_InvertMaskCipher {

    // Before Cipher:
    // bit0 11111111  11111111  11111111  11111111
    // bit1 11111111  11111111  11111111  11111111
    // bit2 11111111  11111111  11111111  11111111
    // bit3 11111111  11111111  11111111  11111111
    // bit4 11111111  11111111  11111111  11111111
    // bit5 11111111  11111111  11111111  11111111
    // bit6 11111111  11111111  11111111  11111111
    // bit7 11111111  11111111  11111111  11111111
    //
    // After Cipher:
    // bit0 00000000  00000000  00000000  00000000
    // bit1 11111111  11111111  11111111  11111111
    // bit2 00000000  00000000  00000000  00000000
    // bit3 11111111  11111111  11111111  11111111
    // bit4 11111111  11111111  11111111  11111111
    // bit5 11111111  11111111  11111111  11111111
    // bit6 11111111  11111111  11111111  11111111
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 ........  ........  ........  ........
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 ........  ........  ........  ........
    // bit4 ........  ........  ........  ........
    // bit5 ........  ........  ........  ........
    // bit6 ........  ........  ........  ........
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[32] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    std::uint8_t aMaskByte = 0xA1;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E,
        0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E, 0x5E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_B_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_B_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_B_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_B_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_B_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_B_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_C_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010
    // bit3 10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101
    // bit2 10101010  10101010  10101010  10101010
    // bit3 10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010
    // bit7 10101010  10101010  10101010  10101010
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........
    // bit3 ........  ........  ........  ........
    // bit4 ........  ........  ........  ........
    // bit5 ........  ........  ........  ........
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0x43;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xB3, 0x4C, 0xB3, 0x4C, 0xB3, 0x4C, 0xB3, 0x4C, 0xB3, 0x4C, 0xB3, 0x4C, 0xB3, 0x4C, 0xB3, 0x4C,
        0xB3, 0x4C, 0xB3, 0x4C, 0xB3, 0x4C, 0xB3, 0x4C, 0xB3, 0x4C, 0xB3, 0x4C, 0xB3, 0x4C, 0xB3, 0x4C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_C_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_C_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_C_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_C_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_C_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_C_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_D_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010
    // bit5 10101010  10101010  10101010  10101010
    // bit6 01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010
    // bit5 01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010
    // bit7 01010101  01010101  01010101  01010101
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........
    // bit1 ........  ........  ........  ........
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 ........  ........  ........  ........
    // bit4 ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[32] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x26;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15,
        0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_D_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_D_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_D_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_D_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_D_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_D_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_E_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010
    // bit7 10101010  10101010  10101010  10101010
    //
    // After Cipher:
    // bit0 01010101  01010101  01010101  01010101
    // bit1 01010101  01010101  01010101  01010101
    // bit2 01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010
    // bit7 01010101  01010101  01010101  01010101
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........
    // bit3 ........  ........  ........  ........
    // bit4 ........  ........  ........  ........
    // bit5 ........  ........  ........  ........
    // bit6 ........  ........  ........  ........
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[32] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0xC1;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0x02, 0xFD, 0x02, 0xFD, 0x02, 0xFD, 0x02, 0xFD, 0x02, 0xFD, 0x02, 0xFD, 0x02, 0xFD, 0x02, 0xFD,
        0x02, 0xFD, 0x02, 0xFD, 0x02, 0xFD, 0x02, 0xFD, 0x02, 0xFD, 0x02, 0xFD, 0x02, 0xFD, 0x02, 0xFD
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_E_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_E_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_E_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_E_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_E_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_E_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_F_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101
    // bit2 10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010
    // bit5 01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010
    // bit7 01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010
    // bit7 10101010  10101010  10101010  10101010
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 ........  ........  ........  ........
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 ........  ........  ........  ........
    // bit6 ........  ........  ........  ........
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[32] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0x69;

    InvertMaskCipher aCrypt(aMaskByte);

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
                                                    "test_fixed_32_F_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_F_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_F_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_F_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_F_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_F_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_G_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010
    // bit1 10101001  10101010  01101010  10011010
    // bit2 10010110  10100101  10101001  01101010
    // bit3 10010101  10100101  01101001  01011010
    // bit4 01100110  10011001  10100110  01101001
    // bit5 01100101  10011001  01100110  01011001
    // bit6 01011010  10010110  10100101  10101001
    // bit7 01011001  10010110  01100101  10011001
    //
    // After Cipher:
    // bit0 01010101  01010101  01010101  01010101
    // bit1 10101001  10101010  01101010  10011010
    // bit2 10010110  10100101  10101001  01101010
    // bit3 10010101  10100101  01101001  01011010
    // bit4 01100110  10011001  10100110  01101001
    // bit5 01100101  10011001  01100110  01011001
    // bit6 10100101  01101001  01011010  01010110
    // bit7 10100110  01101001  10011010  01100110
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 ........  ........  ........  ........
    // bit2 ........  ........  ........  ........
    // bit3 ........  ........  ........  ........
    // bit4 ........  ........  ........  ........
    // bit5 ........  ........  ........  ........
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0x83;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0x73, 0x8C, 0x4F, 0xB0, 0x40, 0xBF, 0x29, 0xD6, 0x7C, 0x83, 0x73, 0x8C, 0x4F, 0xB0, 0x40, 0xBF,
        0x29, 0xD6, 0x7C, 0x83, 0x73, 0x8C, 0x4F, 0xB0, 0x40, 0xBF, 0x29, 0xD6, 0x7C, 0x83, 0x73, 0x8C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_G_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_G_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_G_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_G_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_G_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_G_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_H_InvertMaskCipher {

    // Before Cipher:
    // bit0 01010101  01010101  01010101  01010101
    // bit1 01100101  01011001  01010110  01010101
    // bit2 01011010  01010110  10010101  10100101
    // bit3 01101010  01011010  10010110  10100101
    // bit4 01011001  10010110  01100101  10011001
    // bit5 01101001  10011010  01100110  10011001
    // bit6 01010110  10010101  10100101  01101001
    // bit7 01100110  10011001  10100110  01101001
    //
    // After Cipher:
    // bit0 01010101  01010101  01010101  01010101
    // bit1 01100101  01011001  01010110  01010101
    // bit2 10100101  10101001  01101010  01011010
    // bit3 01101010  01011010  10010110  10100101
    // bit4 10100110  01101001  10011010  01100110
    // bit5 10010110  01100101  10011001  01100110
    // bit6 01010110  10010101  10100101  01101001
    // bit7 01100110  10011001  10100110  01101001
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........
    // bit1 ........  ........  ........  ........
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 ........  ........  ........  ........
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........
    // bit7 ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[32] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF
    };

    std::uint8_t aMaskByte = 0x2C;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0x2C, 0xD3, 0x79, 0x86, 0x10, 0xEF, 0x1F, 0xE0, 0x23, 0xDC, 0x2C, 0xD3, 0x79, 0x86, 0x10, 0xEF,
        0x1F, 0xE0, 0x23, 0xDC, 0x2C, 0xD3, 0x79, 0x86, 0x10, 0xEF, 0x1F, 0xE0, 0x23, 0xDC, 0x2C, 0xD3
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_H_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_H_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_H_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_H_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_H_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_H_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_I_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010
    // bit1 10001010  11100010  10111000  10101110
    // bit2 11100110  00111001  10001110  01100011
    // bit3 11000110  01110001  10011100  01100111
    // bit4 00101111  00001011  11000010  11110000
    // bit5 00001111  01000011  11010000  11110100
    // bit6 01100011  10011000  11100110  00111001
    // bit7 01000011  11010000  11110100  00111101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010
    // bit1 01110101  00011101  01000111  01010001
    // bit2 11100110  00111001  10001110  01100011
    // bit3 00111001  10001110  01100011  10011000
    // bit4 00101111  00001011  11000010  11110000
    // bit5 00001111  01000011  11010000  11110100
    // bit6 10011100  01100111  00011001  11000110
    // bit7 01000011  11010000  11110100  00111101
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........
    // bit5 ........  ........  ........  ........
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33
    };

    std::uint8_t aMaskByte = 0x52;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xA2, 0x61, 0xF8, 0x52, 0x9E, 0x6E, 0xAD, 0x5D, 0x91, 0x07, 0xA2, 0x61, 0xF8, 0x52, 0x9E, 0x6E,
        0xAD, 0x5D, 0x91, 0x07, 0xA2, 0x61, 0xF8, 0x52, 0x9E, 0x6E, 0xAD, 0x5D, 0x91, 0x07, 0xA2, 0x61
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_I_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_I_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_I_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_I_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_I_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_I_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_J_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010
    // bit1 11111111  11111111  11111111  11111111
    // bit2 00000000  00000000  00000000  00000000
    // bit3 01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010
    // bit5 11111111  11111111  11111111  11111111
    // bit6 00000000  00000000  00000000  00000000
    // bit7 01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010
    // bit1 11111111  11111111  11111111  11111111
    // bit2 11111111  11111111  11111111  11111111
    // bit3 01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010
    // bit5 00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000
    // bit7 10101010  10101010  10101010  10101010
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........
    // bit1 ........  ........  ........  ........
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 ........  ........  ........  ........
    // bit4 ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[32] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    std::uint8_t aMaskByte = 0x25;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xE9, 0x70, 0xE9, 0x70, 0xE9, 0x70, 0xE9, 0x70, 0xE9, 0x70, 0xE9, 0x70, 0xE9, 0x70, 0xE9, 0x70,
        0xE9, 0x70, 0xE9, 0x70, 0xE9, 0x70, 0xE9, 0x70, 0xE9, 0x70, 0xE9, 0x70, 0xE9, 0x70, 0xE9, 0x70
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_J_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_J_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_J_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_J_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_J_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_J_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_K_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  01010101
    // bit2 10101010  01010101  01010101  10101010
    // bit3 10101010  01010101  01010101  01010101
    // bit4 01010101  10101010  01010101  10101010
    // bit5 01010101  10101010  01010101  01010101
    // bit6 01010101  01010101  10101010  10101010
    // bit7 01010101  01010101  10101010  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  01010101
    // bit2 10101010  01010101  01010101  10101010
    // bit3 01010101  10101010  10101010  10101010
    // bit4 10101010  01010101  10101010  01010101
    // bit5 10101010  01010101  10101010  10101010
    // bit6 01010101  01010101  10101010  10101010
    // bit7 01010101  01010101  10101010  01010101
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........
    // bit1 ........  ........  ........  ........
    // bit2 ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........
    // bit7 ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0x1C;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xD0, 0x2F, 0xD0, 0x2F, 0xD0, 0x2F, 0xD0, 0x2F,
        0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xDF, 0x20, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49, 0xB6, 0x49
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_K_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_K_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_K_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_K_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_K_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_K_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_L_InvertMaskCipher {

    // Before Cipher:
    // bit0 10000101  11101000  01011110  10000101
    // bit1 10000101  01010101  01011110  10000000
    // bit2 10101010  10101000  01010101  01111111
    // bit3 10101010  00010101  01010101  01111010
    // bit4 01010000  10101000  00001010  10101111
    // bit5 01010000  00010101  00001010  10101010
    // bit6 01111111  11101000  00000001  01010101
    // bit7 01111111  01010101  00000001  01010000
    //
    // After Cipher:
    // bit0 10000101  11101000  01011110  10000101
    // bit1 01111010  10101010  10100001  01111111
    // bit2 10101010  10101000  01010101  01111111
    // bit3 01010101  11101010  10101010  10000101
    // bit4 01010000  10101000  00001010  10101111
    // bit5 10101111  11101010  11110101  01010101
    // bit6 01111111  11101000  00000001  01010101
    // bit7 10000000  10101010  11111110  10101111
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA
    };

    std::uint8_t aMaskByte = 0x55;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[32] = {
        0xA5, 0x5A, 0x66, 0x5A, 0x66, 0x96, 0x66, 0x96, 0xFF, 0x96, 0xFF, 0x00, 0xFF, 0x00, 0x55, 0x00,
        0x55, 0xA5, 0x55, 0xA5, 0x99, 0xA5, 0x99, 0x66, 0x99, 0x66, 0x69, 0x66, 0x69, 0xFF, 0x69, 0xFF
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_L_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_L_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_L_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_L_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_32_L_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_32_L_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_A_InvertMaskCipher {

    // Before Cipher:
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000
    //
    // After Cipher:
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 11111111  11111111  11111111  11111111  11111111  11111111
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[48] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    std::uint8_t aMaskByte = 0x98;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[48] = {
        0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98,
        0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98,
        0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98, 0x98
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_48_A_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_48_A_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_48_A_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_A_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_48_A_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_48_A_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_B_InvertMaskCipher {

    // Before Cipher:
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 11111111  11111111  11111111  11111111  11111111  11111111
    // bit2 11111111  11111111  11111111  11111111  11111111  11111111
    // bit3 11111111  11111111  11111111  11111111  11111111  11111111
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 11111111  11111111  11111111  11111111  11111111  11111111
    // bit6 11111111  11111111  11111111  11111111  11111111  11111111
    // bit7 11111111  11111111  11111111  11111111  11111111  11111111
    //
    // After Cipher:
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 11111111  11111111  11111111  11111111  11111111  11111111
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 11111111  11111111  11111111  11111111  11111111  11111111
    // bit7 11111111  11111111  11111111  11111111  11111111  11111111
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[48] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    std::uint8_t aMaskByte = 0x34;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[48] = {
        0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB,
        0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB,
        0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB, 0xCB
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_48_B_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_48_B_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_48_B_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_B_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_48_B_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_48_B_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_C_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 01010101  01010101  01010101  01010101  01010101  01010101
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 10101010  10101010  10101010  10101010  10101010  10101010
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[48] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0x91;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[48] = {
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
                                                    "test_fixed_48_C_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_48_C_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_48_C_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_C_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_48_C_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_48_C_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_D_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[48] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x58;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[48] = {
        0x94, 0x6B, 0x94, 0x6B, 0x94, 0x6B, 0x94, 0x6B, 0x94, 0x6B, 0x94, 0x6B, 0x94, 0x6B, 0x94, 0x6B,
        0x94, 0x6B, 0x94, 0x6B, 0x94, 0x6B, 0x94, 0x6B, 0x94, 0x6B, 0x94, 0x6B, 0x94, 0x6B, 0x94, 0x6B,
        0x94, 0x6B, 0x94, 0x6B, 0x94, 0x6B, 0x94, 0x6B, 0x94, 0x6B, 0x94, 0x6B, 0x94, 0x6B, 0x94, 0x6B
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_48_D_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_48_D_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_48_D_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_D_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_48_D_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_48_D_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_E_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 10101010  10101010  10101010  10101010  10101010  10101010
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 10101010  10101010  10101010  10101010  10101010  10101010
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[48] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x58;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[48] = {
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
                                                    "test_fixed_48_E_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_48_E_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_48_E_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_E_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_48_E_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_48_E_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_F_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 10101010  10101010  10101010  10101010  10101010  10101010
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[48] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0x25;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[48] = {
        0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70,
        0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70,
        0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70, 0x8F, 0x70
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_48_F_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_48_F_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_48_F_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_F_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_48_F_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_48_F_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_A_InvertMaskCipher {

    // Before Cipher:
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // After Cipher:
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit2 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    std::uint8_t aMaskByte = 0x62;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62,
        0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62,
        0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62,
        0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_A_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_64_A_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_64_A_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_A_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_64_A_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_64_A_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_B_InvertMaskCipher {

    // Before Cipher:
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit2 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit3 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit6 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit7 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    //
    // After Cipher:
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit2 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit3 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[64] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    std::uint8_t aMaskByte = 0x85;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A,
        0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A,
        0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A,
        0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_B_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_64_B_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_64_B_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_B_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_64_B_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_64_B_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_C_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0x33;

    InvertMaskCipher aCrypt(aMaskByte);

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
                                                    "test_fixed_64_C_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_64_C_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_64_C_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_C_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_64_C_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_64_C_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_D_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[64] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x91;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
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
                                                    "test_fixed_64_D_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_64_D_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_64_D_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_D_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_64_D_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_64_D_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_E_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[64] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x25;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19,
        0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19,
        0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19,
        0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19, 0xE6, 0x19
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_E_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_64_E_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_64_E_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_E_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_64_E_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_64_E_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_F_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[64] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0x38;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[64] = {
        0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D,
        0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D,
        0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D,
        0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_F_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_64_F_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_64_F_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_F_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_64_F_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_64_F_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_A_InvertMaskCipher {

    // Before Cipher:
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // After Cipher:
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit6 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[80] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    std::uint8_t aMaskByte = 0x96;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[80] = {
        0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96,
        0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96,
        0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96,
        0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96,
        0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_80_A_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_80_A_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_80_A_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_A_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_80_A_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_80_A_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_B_InvertMaskCipher {

    // Before Cipher:
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit2 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit3 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit6 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit7 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    //
    // After Cipher:
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[80] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    std::uint8_t aMaskByte = 0x52;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[80] = {
        0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD,
        0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD,
        0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD,
        0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD,
        0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD, 0xAD
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_80_B_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_80_B_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_80_B_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_B_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_80_B_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_80_B_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_C_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[80] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0x1C;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[80] = {
        0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13,
        0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13,
        0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13,
        0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13,
        0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13, 0xEC, 0x13
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_80_C_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_80_C_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_80_C_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_C_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_80_C_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_80_C_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_D_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[80] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x38;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[80] = {
        0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B,
        0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B,
        0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B,
        0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B,
        0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B, 0xF4, 0x0B
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_80_D_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_80_D_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_80_D_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_D_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_80_D_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_80_D_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_E_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    //
    // After Cipher:
    // bit0 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[80] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x91;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[80] = {
        0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD,
        0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD,
        0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD,
        0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD,
        0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD, 0x52, 0xAD
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_80_E_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_80_E_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_80_E_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_E_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_80_E_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_80_E_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_F_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[80] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0x4A;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[80] = {
        0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F,
        0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F,
        0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F,
        0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F,
        0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_80_F_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_80_F_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_80_F_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_F_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_80_F_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_80_F_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_A_InvertMaskCipher {

    // Before Cipher:
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // After Cipher:
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    std::uint8_t aMaskByte = 0xC1;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1,
        0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1,
        0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1,
        0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1,
        0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1,
        0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1, 0xC1
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_A_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_96_A_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_96_A_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_A_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_96_A_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_96_A_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_B_InvertMaskCipher {

    // Before Cipher:
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit2 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit3 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit6 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit7 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    //
    // After Cipher:
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit7 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[96] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    std::uint8_t aMaskByte = 0x64;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B,
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B,
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B,
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B,
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B,
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_B_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_96_B_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_96_B_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_B_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_96_B_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_96_B_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_C_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[96] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0xC1;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE,
        0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE,
        0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE,
        0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE,
        0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE,
        0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE, 0x31, 0xCE
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_C_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_96_C_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_96_C_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_C_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_96_C_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_96_C_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_D_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[96] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x25;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16,
        0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16,
        0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16,
        0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16,
        0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16,
        0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16, 0xE9, 0x16
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_D_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_96_D_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_96_D_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_D_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_96_D_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_96_D_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_E_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[96] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x62;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E,
        0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E,
        0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E,
        0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E,
        0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E,
        0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_E_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_96_E_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_96_E_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_E_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_96_E_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_96_E_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_F_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[96] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0x38;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[96] = {
        0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D,
        0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D,
        0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D,
        0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D,
        0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D,
        0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D, 0x92, 0x6D
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_F_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_96_F_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_96_F_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_F_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_96_F_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_96_F_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_A_InvertMaskCipher {

    // Before Cipher:
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // After Cipher:
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit2 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[112] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    std::uint8_t aMaskByte = 0x64;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[112] = {
        0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64,
        0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64,
        0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64,
        0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64,
        0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64,
        0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64,
        0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64, 0x64
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_112_A_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_112_A_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_112_A_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_A_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_112_A_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_112_A_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_B_InvertMaskCipher {

    // Before Cipher:
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit2 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit3 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit6 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit7 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    //
    // After Cipher:
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit7 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[112] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    std::uint8_t aMaskByte = 0x64;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[112] = {
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B,
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B,
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B,
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B,
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B,
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B,
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_112_B_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_112_B_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_112_B_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_B_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_112_B_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_112_B_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_C_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[112] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    std::uint8_t aMaskByte = 0x1A;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[112] = {
        0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15,
        0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15,
        0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15,
        0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15,
        0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15,
        0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15,
        0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15, 0xEA, 0x15
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_112_C_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_112_C_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_112_C_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_C_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_112_C_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_112_C_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_D_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[112] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    std::uint8_t aMaskByte = 0x46;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[112] = {
        0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75,
        0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75,
        0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75,
        0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75,
        0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75,
        0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75,
        0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75, 0x8A, 0x75
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_112_D_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_112_D_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_112_D_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_D_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_112_D_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_112_D_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_E_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[112] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    std::uint8_t aMaskByte = 0x58;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[112] = {
        0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64, 0x9B, 0x64,
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
                                                    "test_fixed_112_E_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_112_E_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_112_E_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_E_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_112_E_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_112_E_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_F_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[112] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    std::uint8_t aMaskByte = 0x1C;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[112] = {
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
                                                    "test_fixed_112_F_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_112_F_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_112_F_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_F_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_112_F_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_112_F_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_A_InvertMaskCipher {

    // Before Cipher:
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // After Cipher:
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit6 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 50.00%

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

    std::uint8_t aMaskByte = 0x96;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96,
        0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96,
        0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96,
        0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96,
        0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96,
        0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96,
        0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96,
        0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_A_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_128_A_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_128_A_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_A_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_128_A_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_128_A_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_B_InvertMaskCipher {

    // Before Cipher:
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit2 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit3 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit6 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit7 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    //
    // After Cipher:
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit7 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 37.50%

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

    std::uint8_t aMaskByte = 0x64;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B,
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B,
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B,
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B,
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B,
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B,
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B,
        0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B, 0x9B
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_B_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_128_B_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_128_B_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_B_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_128_B_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_128_B_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_C_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 50.00%

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

    std::uint8_t aMaskByte = 0x96;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99,
        0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99,
        0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99,
        0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99,
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
                                                    "test_fixed_128_C_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_128_C_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_128_C_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_C_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_128_C_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_128_C_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_D_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
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

    std::uint8_t aMaskByte = 0x52;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61,
        0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61,
        0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61,
        0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61,
        0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61,
        0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61,
        0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61,
        0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61, 0x9E, 0x61
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_D_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_128_D_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_128_D_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_D_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_128_D_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_128_D_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_E_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    //
    // After Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
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

    std::uint8_t aMaskByte = 0x4A;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76,
        0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76,
        0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76,
        0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76,
        0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76,
        0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76,
        0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76,
        0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76, 0x89, 0x76
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_E_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_128_E_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_128_E_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_E_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_128_E_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_128_E_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_F_InvertMaskCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
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

    std::uint8_t aMaskByte = 0xC2;

    InvertMaskCipher aCrypt(aMaskByte);

    const std::uint8_t aExpected[128] = {
        0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97,
        0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97,
        0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97,
        0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97,
        0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97,
        0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97, 0x68, 0x97,
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
                                                    "test_fixed_128_F_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_128_F_InvertMaskCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[InvertMaskCipher] test_fixed_128_F_InvertMaskCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_F_InvertMaskCipher")) {
        XCTFail("[InvertMaskCipher] test_fixed_128_F_InvertMaskCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[InvertMaskCipher] test_fixed_128_F_InvertMaskCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

@end
