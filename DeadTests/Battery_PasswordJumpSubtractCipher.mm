//
//  Battery_PasswordJumpSubtractCipher.m
//  HolyStorms
//
//  Created by icarus black on 7/5/26.
//

#import <XCTest/XCTest.h>
#import "PasswordJumpSubtractCipher.hpp"
#import "PrintExamplesHelper.hpp"
#import "CipherGauntlet.hpp"
#include <memory>

@interface Battery_PasswordJumpSubtractCipher : XCTestCase

@end

@implementation Battery_PasswordJumpSubtractCipher

- (void)test_gauntlet_PasswordJumpSubtractCipher {
    static std::uint8_t aAllZero[SOCCER_BLOCK_SIZE];
    static std::uint8_t aAllOne[SOCCER_BLOCK_SIZE];
    static std::uint8_t aRandA[SOCCER_BLOCK_SIZE];
    static std::uint8_t aRandB[SOCCER_BLOCK_SIZE];
    static std::uint8_t aRandC[SOCCER_BLOCK_SIZE];
    static std::uint8_t aRandD[SOCCER_BLOCK_SIZE];
    static std::uint8_t aRandE[SOCCER_BLOCK_SIZE];
    static std::uint8_t aRandF[SOCCER_BLOCK_SIZE];
    static std::uint8_t aRandG[SOCCER_BLOCK_SIZE];
    static std::uint8_t aRandH[SOCCER_BLOCK_SIZE];
    
    
    CipherGauntlet::ArrayZero(aAllZero, SOCCER_BLOCK_SIZE);
    CipherGauntlet::ArrayOne(aAllOne, SOCCER_BLOCK_SIZE);
    CipherGauntlet::ArrayRandomize(aRandA, SOCCER_BLOCK_SIZE);
    CipherGauntlet::ArrayRandomize(aRandB, SOCCER_BLOCK_SIZE);
    CipherGauntlet::ArrayRandomize(aRandC, SOCCER_BLOCK_SIZE);
    CipherGauntlet::ArrayRandomize(aRandD, SOCCER_BLOCK_SIZE);
    CipherGauntlet::ArrayRandomize(aRandE, SOCCER_BLOCK_SIZE);
    CipherGauntlet::ArrayRandomize(aRandF, SOCCER_BLOCK_SIZE);
    CipherGauntlet::ArrayRandomize(aRandG, SOCCER_BLOCK_SIZE);
    CipherGauntlet::ArrayRandomize(aRandH, SOCCER_BLOCK_SIZE);
    
    std::vector<std::uint8_t *> aListMask;
    std::vector<std::uint8_t *> aListMaskJumps;
    
    aListMask.push_back(aRandA); aListMask.push_back(aRandB); aListMask.push_back(aRandC); aListMask.push_back(aRandD);
    aListMask.push_back(aRandE); aListMask.push_back(aRandF); aListMask.push_back(aRandG); aListMask.push_back(aRandH);
    aListMask.push_back(aAllZero); aListMask.push_back(aAllOne);
    
    aListMaskJumps.push_back(aRandA); aListMaskJumps.push_back(aRandB); aListMaskJumps.push_back(aRandC); aListMaskJumps.push_back(aRandD);
    aListMaskJumps.push_back(aRandE); aListMaskJumps.push_back(aRandF); aListMaskJumps.push_back(aRandG); aListMaskJumps.push_back(aRandH);
    aListMaskJumps.push_back(aAllZero); aListMaskJumps.push_back(aAllOne);
    
    static CipherGauntlet aGauntlet;
    
    for (std::size_t aIndexA=0; aIndexA<aListMask.size(); aIndexA++) {
        std::uint8_t *aMask = aListMask[aIndexA];
        
        for (std::size_t aIndexC=0; aIndexC<aListMaskJumps.size(); aIndexC++) {
            std::uint8_t *aMaskJumps = aListMaskJumps[aIndexC];
            
            PasswordJumpSubtractCipher aCipher(aMask,
                                         aMaskJumps);
            if (!aGauntlet.RunCipher(&aCipher,
                                     32,
                                     "PasswordJumpSubtractCipher")) {
                XCTFail("[PasswordJumpSubtractCipher] test_gauntlet_PasswordJumpSubtractCipher failed.");
                return;
            }
        }
    }
}

- (void)test_fixed_32_A_PasswordJumpSubtractCipher {

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
    // bit2 00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........
    // bit1 ........  ........  ........  ........
    // bit2 ........  ........  ........  ........
    // bit3 ........  ........  ........  ........
    // bit4 ........  ........  ........  ........
    // bit5 ........  ........  ........  ........
    // bit6 ........  ........  ........  ........
    // bit7 ........  ........  ........  ........
    // Avalanche: 0.00%

    const std::uint8_t aOriginal[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aMaskBuffer[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x1B, 0x9D, 0xFC, 0x08, 0xE8, 0x27, 0x75, 0x49, 0xB4, 0x6C, 0x62, 0x30, 0xE7, 0x81, 0x53, 0x1B,
        0xA6, 0x19, 0xC0, 0x29, 0x8E, 0xD9, 0xF0, 0x47, 0x56, 0x90, 0xEA, 0xC3, 0x73, 0x6E, 0x07, 0xDE
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_32_A_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_A_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_A_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_A_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_A_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_A_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_B_PasswordJumpSubtractCipher {

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
    // bit1 00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 100.00%

    const std::uint8_t aOriginal[32] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0xFE, 0x7F, 0x95, 0x6A, 0xDC, 0x49, 0xA3, 0xC2, 0x08, 0x7A, 0xB9, 0xE1, 0x1C, 0x0C, 0xD1, 0x3D,
        0xEA, 0x58, 0x5D, 0x3E, 0xF7, 0xE0, 0xD4, 0x17, 0x74, 0x5B, 0x11, 0x1A, 0x29, 0xA1, 0x2F, 0xF5
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_32_B_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_B_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_B_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_B_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_B_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_B_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_C_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit2 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit3 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit4 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit5 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit6 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x67, 0x02, 0xC4, 0xBF, 0xD9, 0xEB, 0xD0, 0x23, 0xBA, 0xB7, 0x40, 0x11, 0x4E, 0x95, 0xB2, 0x35,
        0x59, 0xF4, 0xA9, 0xDC, 0xF0, 0x22, 0x6E, 0x9E, 0x20, 0xF5, 0x55, 0xDE, 0xDC, 0x5B, 0x91, 0x10
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_32_C_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_C_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_C_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_C_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_C_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_C_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_D_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit2 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit3 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit5 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit6 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[32] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x6E, 0xB4, 0xA2, 0xF4, 0xE9, 0xC6, 0xC4, 0x37, 0x1C, 0xE1, 0xEB, 0x83, 0x3C, 0x5D, 0x7E, 0x2F,
        0xD3, 0x3E, 0xB2, 0x2A, 0x0E, 0x62, 0xB2, 0x30, 0x1C, 0x9A, 0xED, 0x8B, 0xE0, 0x4B, 0xA0, 0x39
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_32_D_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_D_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_D_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_D_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_D_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_D_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_E_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit2 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit3 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit4 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit5 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit6 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit7 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[32] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x4A, 0xFF, 0x21, 0xC7, 0xC1, 0x20, 0x4E, 0xA3, 0xB1, 0xB2, 0x92, 0xBF, 0x84, 0x13, 0x61, 0x1C,
        0xBE, 0xB0, 0x92, 0x50, 0x63, 0xE4, 0x2C, 0x26, 0xC5, 0x09, 0x1F, 0xCF, 0x44, 0x45, 0x8A, 0x79
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_32_E_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_E_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_E_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_E_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_E_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_E_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_F_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit2 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit3 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit5 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit6 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[32] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x4B, 0x45, 0xE2, 0x10, 0xEC, 0xA3, 0x7C, 0x41, 0x27, 0x81, 0x47, 0x96, 0x67, 0x2A, 0x62, 0x38,
        0x82, 0x7B, 0x05, 0xA3, 0xAA, 0x19, 0x6A, 0x3B, 0x81, 0x09, 0x82, 0x91, 0x45, 0xC1, 0xF0, 0x03
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_32_F_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_F_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_F_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_F_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_F_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_F_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_G_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X..X  X.X.X.X.  .XX.X.X.  X..XX.X.
    // bit2 X..X.XX.  X.X..X.X  X.X.X..X  .XX.X.X.
    // bit3 X..X.X.X  X.X..X.X  .XX.X..X  .X.XX.X.
    // bit4 .XX..XX.  X..XX..X  X.X..XX.  .XX.X..X
    // bit5 .XX..X.X  X..XX..X  .XX..XX.  .X.XX..X
    // bit6 .X.XX.X.  X..X.XX.  X.X..X.X  X.X.X..X
    // bit7 .X.XX..X  X..X.XX.  .XX..X.X  X..XX..X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x87, 0x07, 0xEF, 0xDB, 0x3C, 0x08, 0x65, 0x07, 0x7B, 0xCC, 0x6A, 0xB8, 0x86, 0x5C, 0xA2, 0x07,
        0x90, 0xB7, 0x8C, 0x92, 0x33, 0xA6, 0x31, 0x5B, 0x31, 0xFF, 0x21, 0xAF, 0x20, 0xCA, 0x09, 0x0A
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_32_G_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_G_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_G_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_G_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_G_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_G_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_H_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  01101001  01011010
    // bit1 00000000  00000000  01011001  01010110
    // bit2 00000000  00000000  10100110  10101001
    // bit3 00000000  00000000  10100101  01101001
    // bit4 00000000  00000000  01100101  10011001
    // bit5 00000000  00000000  01011101  10010111
    // bit6 00000000  00000000  10110011  01101100
    // bit7 00000000  00000000  11000000  11110000
    //
    // Avalanche:
    // bit0 .X.X.X.X  .X.X.X.X  ..XXXX..  ....XXXX
    // bit1 .XX..X.X  .X.XX..X  ....XXXX  ......XX
    // bit2 .X.XX.X.  .X.X.XX.  ..XX..XX  ....XX..
    // bit3 .XX.X.X.  .X.XX.X.  ..XX..XX  XX..XX..
    // bit4 .X.XX..X  X..X.XX.  ........  ........
    // bit5 .XX.X..X  X..XX.X.  ..XXX.XX  ....XXX.
    // bit6 .X.X.XX.  X..X.X.X  ...X.XX.  .....X.X
    // bit7 .XX..XX.  X..XX..X  .XX..XX.  X..XX..X
    // Avalanche: 44.14%

    const std::uint8_t aOriginal[32] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF
    };

    const std::uint8_t aMaskBuffer[32] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x96, 0x0F, 0xFD, 0x5C, 0x88, 0xF0, 0x8C, 0x00, 0xC0, 0xA6, 0x91, 0xCC, 0x9F, 0x25, 0x72, 0xE8,
        0x1C, 0x96, 0xF8, 0x86, 0x4A, 0xE8, 0x5D, 0x01, 0x20, 0x1D, 0x5B, 0x21, 0xFD, 0x26, 0x1A, 0x96
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x33, 0xCD, 0xBA, 0x46, 0xC4, 0x3C, 0x22, 0xDE, 0x2D, 0xD3, 0x33, 0xCD, 0xBA, 0x46, 0xC4, 0x3C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_H_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_H_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_H_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_H_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_H_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_H_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_I_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  01000111  01010001
    // bit1 00000000  00000000  01010101  01010101
    // bit2 00000000  00000000  00001111  01000011
    // bit3 00000000  00000000  01110101  00011101
    // bit4 00000000  00000000  11100010  10111000
    // bit5 00000000  00000000  11011100  01110111
    // bit6 00000000  00000000  10000110  01100001
    // bit7 00000000  00000000  10110111  11101101
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXX.XX.X  XXXXX.XX
    // bit1 X...X.X.  XXX...X.  XXX.XX.X  XXXXX.XX
    // bit2 XXX..XX.  ..XXX..X  X......X  ..X.....
    // bit3 XX...XX.  .XXX...X  XXX.X..X  .XXXX.X.
    // bit4 ..X.XXXX  ....X.XX  ..X.....  .X..X...
    // bit5 ....XXXX  .X....XX  ....XX..  X.....XX
    // bit6 .XX...XX  X..XX...  .XX.....  .X.XX...
    // bit7 .X....XX  XX.X....  .X....XX  XX.X....
    // Avalanche: 46.09%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x58, 0xC4, 0x49, 0x79, 0xF7, 0x08, 0x0D, 0x97, 0x89, 0x8C, 0xAD, 0x6A, 0xD4, 0xA2, 0xC9, 0xD5,
        0xE9, 0x75, 0x3F, 0x43, 0x9A, 0x41, 0xCE, 0x2F, 0x4F, 0xAF, 0x2E, 0x9D, 0x83, 0x5B, 0x1C, 0xBA
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x0F, 0xDC, 0x19, 0x55, 0x24, 0xF7, 0xAB, 0xF1, 0x09, 0xE7, 0x0F, 0xDC, 0x19, 0x55, 0x24, 0xF7
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_I_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_I_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_I_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_I_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_I_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_I_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_J_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........
    // bit3 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[32] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x1B, 0xC5, 0x8D, 0x6A, 0x51, 0xC2, 0x9C, 0xF6, 0x7A, 0x9F, 0xB4, 0x84, 0x2E, 0x1D, 0x5D, 0x84,
        0x34, 0x41, 0x44, 0x8B, 0xE2, 0x4A, 0x57, 0xC6, 0x4D, 0xEA, 0xA4, 0x71, 0x6A, 0x69, 0xBD, 0x45
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_32_J_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_J_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_J_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_J_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_J_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_J_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_K_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  X.X.X.X.  .X.X.X.X
    // bit2 X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.
    // bit3 X.X.X.X.  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit4 .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.
    // bit5 .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X
    // bit6 .X.X.X.X  .X.X.X.X  X.X.X.X.  X.X.X.X.
    // bit7 .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0xDB, 0x2D, 0xFD, 0x00, 0x66, 0x6B, 0x43, 0xDC, 0x1E, 0x92, 0x08, 0xD6, 0x18, 0x7A, 0x2A, 0x6B,
        0x18, 0x81, 0x94, 0xC2, 0xD7, 0xC6, 0x54, 0x5E, 0xE0, 0xF9, 0x0E, 0xEB, 0x04, 0xF5, 0x5E, 0xF2
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_32_K_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_K_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_K_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_K_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_K_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_K_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_L_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X....X.X  XXX.X...  .X.XXXX.  X....X.X
    // bit1 X....X.X  .X.X.X.X  .X.XXXX.  X.......
    // bit2 X.X.X.X.  X.X.X...  .X.X.X.X  .XXXXXXX
    // bit3 X.X.X.X.  ...X.X.X  .X.X.X.X  .XXXX.X.
    // bit4 .X.X....  X.X.X...  ....X.X.  X.X.XXXX
    // bit5 .X.X....  ...X.X.X  ....X.X.  X.X.X.X.
    // bit6 .XXXXXXX  XXX.X...  .......X  .X.X.X.X
    // bit7 .XXXXXXX  .X.X.X.X  .......X  .X.X....
    // Avalanche: 45.31%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x73, 0x44, 0x0B, 0x13, 0x16, 0x4D, 0xA7, 0x02, 0x65, 0xA1, 0x9C, 0x24, 0x57, 0xCD, 0xD1, 0xEA,
        0x0D, 0xDD, 0xED, 0xC1, 0x3C, 0xD3, 0x12, 0x20, 0x6F, 0xF8, 0x1C, 0xB7, 0x65, 0x29, 0x4D, 0x91
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_32_L_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_L_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_L_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_L_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_L_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_32_L_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_A_PasswordJumpSubtractCipher {

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
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 0.00%

    const std::uint8_t aOriginal[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aMaskBuffer[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aMaskJumpBuffer[64] = {
        0x22, 0x76, 0x8E, 0x0E, 0x61, 0x7E, 0x15, 0x82, 0xCF, 0xA7, 0x5C, 0xB5, 0xEA, 0xBB, 0x81, 0xCB,
        0xAB, 0x05, 0xE7, 0x4A, 0xF8, 0x91, 0xDC, 0x36, 0x93, 0x37, 0x69, 0xC6, 0xA2, 0xDE, 0x79, 0x53,
        0xE2, 0xCB, 0x14, 0x30, 0x04, 0x49, 0x59, 0x43, 0xEC, 0x4E, 0x83, 0x1C, 0x24, 0x54, 0xAE, 0xED,
        0xAA, 0x4D, 0xE1, 0xD8, 0xE9, 0x5B, 0x01, 0x27, 0xB0, 0x74, 0x54, 0xA5, 0xB5, 0x9D, 0x59, 0x46
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_64_A_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_A_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_A_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_A_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_A_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_A_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_B_PasswordJumpSubtractCipher {

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
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 100.00%

    const std::uint8_t aOriginal[64] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskBuffer[64] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskJumpBuffer[64] = {
        0x75, 0xE7, 0xA0, 0x3E, 0x76, 0x6A, 0x49, 0x5A, 0x9D, 0xFE, 0xD3, 0x53, 0xF4, 0x51, 0xE0, 0xDC,
        0xD7, 0x92, 0xB8, 0x45, 0x86, 0xAA, 0xF9, 0xF8, 0x0D, 0xA1, 0x68, 0xD5, 0x7D, 0xDD, 0x0B, 0x3D,
        0xA2, 0x36, 0xFE, 0x86, 0xDA, 0x82, 0x43, 0xE9, 0xCC, 0x47, 0xEA, 0x50, 0xC2, 0x12, 0x45, 0xBC,
        0x1F, 0x8B, 0xF7, 0x83, 0x58, 0x00, 0xC3, 0xAD, 0x9A, 0xC6, 0x7B, 0xD5, 0x0E, 0x94, 0x56, 0x22
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_64_B_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_B_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_B_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_B_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_B_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_B_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_C_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit2 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit3 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit4 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit5 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit6 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskBuffer[64] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskJumpBuffer[64] = {
        0x1C, 0x59, 0x95, 0xE8, 0x1C, 0x6B, 0x7A, 0xB4, 0x45, 0x84, 0xFB, 0xDD, 0x9E, 0x85, 0xD7, 0xF7,
        0x46, 0x33, 0x35, 0x29, 0x57, 0x42, 0x17, 0x5C, 0x44, 0xA9, 0x36, 0x4E, 0xC7, 0x71, 0x0A, 0xA0,
        0x42, 0xFF, 0x9E, 0xEE, 0xE1, 0x18, 0xE0, 0xE0, 0x6A, 0x50, 0x89, 0xAC, 0x9B, 0x84, 0x0E, 0x31,
        0x0C, 0x0E, 0x6B, 0x29, 0xEA, 0xFC, 0x9D, 0x31, 0x2A, 0x98, 0x4B, 0xD2, 0x45, 0x50, 0xAA, 0xD2
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_64_C_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_C_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_C_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_C_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_C_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_C_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_D_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit2 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit3 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit5 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit6 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[64] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskBuffer[64] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskJumpBuffer[64] = {
        0x95, 0x0F, 0xE0, 0xE0, 0x15, 0xFA, 0x77, 0x60, 0x0F, 0x5D, 0xFD, 0x3F, 0x2B, 0xAA, 0x49, 0x2C,
        0xCE, 0xFA, 0x79, 0x66, 0x78, 0x53, 0x5E, 0x97, 0xE6, 0xB6, 0xDD, 0x51, 0xDE, 0x31, 0xC7, 0x7A,
        0x63, 0x52, 0xFC, 0x96, 0xF2, 0xD9, 0xF4, 0xF2, 0xD6, 0xC5, 0x11, 0x6E, 0xE5, 0x8B, 0x4F, 0xE0,
        0x0B, 0x90, 0xDC, 0x00, 0xFC, 0xDE, 0x44, 0x53, 0x13, 0x48, 0x60, 0x04, 0x59, 0xF9, 0xF0, 0xE2
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_64_D_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_D_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_D_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_D_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_D_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_D_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_E_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit2 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit3 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit4 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit5 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit6 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit7 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[64] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskBuffer[64] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskJumpBuffer[64] = {
        0xC7, 0x5B, 0x4A, 0xA6, 0x95, 0xE5, 0x1C, 0xF0, 0x50, 0xE5, 0xA2, 0xD2, 0xE5, 0xC7, 0x5E, 0xDA,
        0xC0, 0x0C, 0xF0, 0xFB, 0x0E, 0x6B, 0x69, 0xEC, 0x56, 0x8E, 0xE2, 0x90, 0x1B, 0xAA, 0xB2, 0xF5,
        0xFB, 0x03, 0xF0, 0x04, 0x50, 0x0B, 0x61, 0xF9, 0xC3, 0x1E, 0xFE, 0x35, 0xB5, 0x3F, 0xC6, 0xF0,
        0x5C, 0xB3, 0xB3, 0xC3, 0x2C, 0xB9, 0xD6, 0xA4, 0x7F, 0xC9, 0x37, 0x7F, 0x3E, 0xC9, 0x2C, 0x7F
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_64_E_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_E_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_E_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_E_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_E_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_E_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_F_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit2 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit3 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit5 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit6 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[64] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskBuffer[64] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[64] = {
        0xB7, 0x97, 0xFB, 0x70, 0xAA, 0x9A, 0x82, 0x4C, 0x91, 0x77, 0x73, 0xA8, 0xFC, 0x64, 0x5C, 0x7E,
        0x23, 0x12, 0xCD, 0xCA, 0x32, 0x6A, 0x01, 0x09, 0xEB, 0xF9, 0x41, 0xD5, 0x79, 0xEC, 0x02, 0x31,
        0x79, 0xE6, 0x05, 0xE3, 0xAB, 0xF8, 0x13, 0xB8, 0x77, 0x9A, 0x30, 0x79, 0x2D, 0x9E, 0x8C, 0xBC,
        0x47, 0xF8, 0x60, 0x55, 0xC1, 0x3A, 0x1E, 0x57, 0x47, 0x3E, 0x1E, 0x7A, 0xA5, 0x88, 0x37, 0xFB
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_64_F_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_F_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_F_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_F_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_F_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_F_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_G_PasswordJumpSubtractCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101001  10101010  01101010  10011010  10100110  10101001  10101010  01101010
    // bit2 10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001
    // bit3 10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001
    // bit4 01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110
    // bit5 01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110
    // bit6 01011010  10010110  10100101  10101001  01101010  01011010  10010110  10100101
    // bit7 01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101
    //
    // After Cipher:
    // bit0 00000000  00000000  10010101  01100101  01101001  01011010  01010101  10010101
    // bit1 00000000  00000000  01010101  01010101  01100101  01011001  01010101  01010101
    // bit2 00000000  00000000  10011001  01100110  10011010  10100110  01100101  10011001
    // bit3 00000000  00000000  01010101  10010101  01011010  01010110  01010110  01010101
    // bit4 00000000  00000000  10100110  10101001  01011001  10010110  10011010  10100110
    // bit5 00000000  00000000  01101101  01011011  01110101  10011101  10110101  01101101
    // bit6 00000000  00000000  10100001  01101000  11001110  01110011  10000101  10100001
    // bit7 00000000  00000000  11110011  11111100  00000011  11000000  11001111  11110011
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  ..XXXXXX  XX..XXXX  XX....XX  XXXX....  XXXXXXXX  ..XXXXXX
    // bit1 X.X.X..X  X.X.X.X.  ..XXXXXX  XX..XXXX  XX....XX  XXXX....  XXXXXXXX  ..XXXXXX
    // bit2 X..X.XX.  X.X..X.X  ..XX....  ....XX..  XX......  ..XX....  XX......  ..XX....
    // bit3 X..X.X.X  X.X..X.X  ..XXXX..  XX..XXXX  ....XX..  XX....XX  XXXX..XX  ..XXXX..
    // bit4 .XX..XX.  X..XX..X  ........  XX......  XX....XX  XXXX....  ......XX  ........
    // bit5 .XX..X.X  X..XX..X  ....X.XX  ......X.  XXX...XX  XXXXX...  ..X.XX..  ....X.XX
    // bit6 .X.XX.X.  X..X.XX.  .....X..  XX.....X  X.X..X..  ..X.X..X  ...X..XX  .....X..
    // bit7 .X.XX..X  X..X.XX.  X..X.XX.  .XX..X.X  .XX..X.X  X..XX..X  .X.XX..X  X..X.XX.
    // Avalanche: 46.88%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F,
        0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55,
        0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33
    };

    const std::uint8_t aMaskBuffer[64] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F,
        0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55,
        0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33
    };

    const std::uint8_t aMaskJumpBuffer[64] = {
        0xC3, 0x7E, 0xC3, 0xCF, 0xFD, 0x56, 0xB6, 0xE7, 0x5B, 0xD7, 0x9A, 0xC9, 0xC9, 0xDA, 0x62, 0x0D,
        0x63, 0xD8, 0xD3, 0x5A, 0xCB, 0xED, 0xE1, 0xD2, 0xAD, 0x08, 0x27, 0x11, 0xAA, 0x0F, 0x80, 0x24,
        0x87, 0xB3, 0x1E, 0x75, 0x53, 0x28, 0x62, 0x84, 0x8A, 0x16, 0x6D, 0xE9, 0x55, 0xD4, 0xB7, 0x61,
        0x9F, 0xD7, 0x35, 0x48, 0x32, 0x44, 0x81, 0x8D, 0x8A, 0x01, 0x31, 0x27, 0x38, 0x5C, 0x6D, 0x1E
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xAB, 0x55, 0x0F, 0xF1, 0x24, 0xDC, 0x09, 0xF7, 0x19, 0xE7, 0xAB, 0x55, 0x0F, 0xF1, 0x24, 0xDC,
        0x22, 0xDE, 0xC4, 0x3C, 0xBA, 0x46, 0x33, 0xCD, 0x2D, 0xD3, 0x22, 0xDE, 0xC4, 0x3C, 0xBA, 0x46,
        0x0F, 0xF1, 0x24, 0xDC, 0x09, 0xF7, 0x19, 0xE7, 0xAB, 0x55, 0x0F, 0xF1, 0x24, 0xDC, 0x09, 0xF7
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_G_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_G_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_G_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_G_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_G_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_G_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_H_PasswordJumpSubtractCipher {

    // Before Cipher:
    // bit0 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit1 01100101  01011001  01010110  01010101  10010101  01100101  01011001  01010110
    // bit2 01011010  01010110  10010101  10100101  01101001  01011010  01010110  10010101
    // bit3 01101010  01011010  10010110  10100101  10101001  01101010  01011010  10010110
    // bit4 01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101
    // bit5 01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110
    // bit6 01010110  10010101  10100101  01101001  01011010  01010110  10010101  10100101
    // bit7 01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110
    //
    // After Cipher:
    // bit0 00000000  00000000  00000000  00000000  01101010  10011010  10100101  01101001
    // bit1 00000000  00000000  00000000  00000000  10101010  10101010  01100101  01011001
    // bit2 00000000  00000000  00000000  00000000  01101001  10011010  10011010  10100110
    // bit3 00000000  00000000  00000000  00000000  10011010  10100110  10010101  10100101
    // bit4 00000000  00000000  00000000  00000000  01010110  01010101  10010110  01100101
    // bit5 00000000  00000000  00000000  00000000  10101011  01101010  01110110  01011101
    // bit6 00000000  00000000  00000000  00000000  01101000  01011010  11001101  10110011
    // bit7 00000000  00000000  00000000  00000000  11111100  11111111  00000011  11000000
    //
    // Avalanche:
    // bit0 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  ..XXXXXX  XX..XXXX  XXXX....  ..XXXX..
    // bit1 .XX..X.X  .X.XX..X  .X.X.XX.  .X.X.X.X  ..XXXXXX  XX..XXXX  ..XXXX..  ....XXXX
    // bit2 .X.XX.X.  .X.X.XX.  X..X.X.X  X.X..X.X  ........  XX......  XX..XX..  ..XX..XX
    // bit3 .XX.X.X.  .X.XX.X.  X..X.XX.  X.X..X.X  ..XX..XX  XX..XX..  XX..XXXX  ..XX..XX
    // bit4 .X.XX..X  X..X.XX.  .XX..X.X  X..XX..X  ..XX....  ....XX..  ........  ........
    // bit5 .XX.X..X  X..XX.X.  .XX..XX.  X..XX..X  ....XX.X  ......XX  XXX.XX..  ..XXX.XX
    // bit6 .X.X.XX.  X..X.X.X  X.X..X.X  .XX.X..X  ..XX..X.  ....XX..  .X.XX...  ...X.XX.
    // bit7 .XX..XX.  X..XX..X  X.X..XX.  .XX.X..X  .XX..XX.  X..XX..X  X..XX.X.  .XX..XX.
    // Avalanche: 47.27%

    const std::uint8_t aOriginal[64] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF,
        0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC,
        0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA
    };

    const std::uint8_t aMaskBuffer[64] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF,
        0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC,
        0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA
    };

    const std::uint8_t aMaskJumpBuffer[64] = {
        0x0D, 0x97, 0xCE, 0xC7, 0x5F, 0x55, 0xAA, 0xA9, 0xD9, 0xBC, 0xC8, 0xAE, 0x9B, 0x59, 0xDA, 0x60,
        0xA5, 0xCA, 0xBB, 0x21, 0xE8, 0xA0, 0x3B, 0xA7, 0xAC, 0x2F, 0x27, 0xA5, 0xAA, 0x8F, 0x24, 0xFD,
        0x31, 0x46, 0xB2, 0xB3, 0x5F, 0x21, 0x2C, 0x6C, 0xB5, 0x4B, 0xFD, 0xBE, 0x77, 0xA9, 0x7A, 0x6E,
        0x65, 0x8B, 0x95, 0x5D, 0xF5, 0xD8, 0xC2, 0xED, 0x6E, 0x12, 0x21, 0xC4, 0xAF, 0xEA, 0x09, 0x69
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x55, 0xAB, 0xE7, 0x19, 0xF7, 0x09, 0xDC, 0x24, 0xF1, 0x0F, 0x55, 0xAB, 0xE7, 0x19, 0xF7, 0x09,
        0xBA, 0x46, 0xC4, 0x3C, 0x22, 0xDE, 0x2D, 0xD3, 0x33, 0xCD, 0xBA, 0x46, 0xC4, 0x3C, 0x22, 0xDE
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_H_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_H_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_H_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_H_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_H_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_H_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_I_PasswordJumpSubtractCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10001010  11100010  10111000  10101110  00101011  10001010  11100010  10111000
    // bit2 11100110  00111001  10001110  01100011  10011000  11100110  00111001  10001110
    // bit3 11000110  01110001  10011100  01100111  00011001  11000110  01110001  10011100
    // bit4 00101111  00001011  11000010  11110000  10111100  00101111  00001011  11000010
    // bit5 00001111  01000011  11010000  11110100  00111101  00001111  01000011  11010000
    // bit6 01100011  10011000  11100110  00111001  10001110  01100011  10011000  11100110
    // bit7 01000011  11010000  11110100  00111101  00001111  01000011  11010000  11110100
    //
    // After Cipher:
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  10011100  01100111
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  11010100  01110101
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00101011  10001010
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00011001  11000110
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00111101  00001111
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  11110101  00111101
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  01011010  11010110
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00100100  11001001
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  ..XX.XX.  XX..XX.X
    // bit1 X...X.X.  XXX...X.  X.XXX...  X.X.XXX.  ..X.X.XX  X...X.X.  ..XX.XX.  XX..XX.X
    // bit2 XXX..XX.  ..XXX..X  X...XXX.  .XX...XX  X..XX...  XXX..XX.  ...X..X.  .....X..
    // bit3 XX...XX.  .XXX...X  X..XXX..  .XX..XXX  ...XX..X  XX...XX.  .XX.X...  .X.XX.X.
    // bit4 ..X.XXXX  ....X.XX  XX....X.  XXXX....  X.XXXX..  ..X.XXXX  ..XX.XX.  XX..XX.X
    // bit5 ....XXXX  .X....XX  XX.X....  XXXX.X..  ..XXXX.X  ....XXXX  X.XX.XX.  XXX.XX.X
    // bit6 .XX...XX  X..XX...  XXX..XX.  ..XXX..X  X...XXX.  .XX...XX  XX....X.  ..XX....
    // bit7 .X....XX  XX.X....  XXXX.X..  ..XXXX.X  ....XXXX  .X....XX  XXXX.X..  ..XXXX.X
    // Avalanche: 49.80%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33,
        0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F,
        0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00
    };

    const std::uint8_t aMaskBuffer[64] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33,
        0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F,
        0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00
    };

    const std::uint8_t aMaskJumpBuffer[64] = {
        0x35, 0xD1, 0x33, 0x6B, 0x71, 0xD5, 0x16, 0xD7, 0xD7, 0x16, 0x53, 0xFC, 0xD8, 0x65, 0x10, 0x56,
        0x93, 0xF7, 0xE3, 0x59, 0x08, 0xB7, 0x85, 0x78, 0x61, 0x23, 0xBF, 0xE6, 0xD0, 0x18, 0xCF, 0x8A,
        0x69, 0xD0, 0x4F, 0x6A, 0xAD, 0xF3, 0x6A, 0x5A, 0xAE, 0x6A, 0x2F, 0x32, 0xCB, 0x8B, 0xB4, 0xB0,
        0xA2, 0xEE, 0x89, 0x32, 0x71, 0xF8, 0xEA, 0x91, 0xE6, 0x6A, 0xA2, 0x2A, 0x36, 0x8E, 0xCB, 0x9B
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xC4, 0x46, 0x2D, 0xDE, 0xBA, 0xCD, 0x22, 0x3C, 0x33, 0xD3, 0xC4, 0x46, 0x2D, 0xDE, 0xBA, 0xCD
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_I_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_I_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_I_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_I_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_I_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_I_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_J_PasswordJumpSubtractCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[64] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    const std::uint8_t aMaskBuffer[64] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[64] = {
        0x5C, 0xE6, 0xDF, 0xD3, 0x05, 0x4E, 0xBC, 0x66, 0x28, 0xED, 0x30, 0xA0, 0xBF, 0x41, 0xD5, 0xA3,
        0xFC, 0x87, 0xF3, 0x9B, 0x09, 0xBF, 0x61, 0x21, 0x18, 0x46, 0x4C, 0x38, 0x97, 0xEF, 0x4F, 0x98,
        0xB1, 0x47, 0x4A, 0x60, 0x8F, 0xBD, 0x61, 0x9E, 0x2F, 0x0B, 0x16, 0xB9, 0x52, 0x55, 0x6C, 0x91,
        0x1B, 0x95, 0xC3, 0xA6, 0x71, 0xC0, 0x7F, 0x77, 0xFB, 0x87, 0x7E, 0x50, 0xC0, 0xDD, 0x93, 0xBF
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_64_J_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_J_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_J_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_J_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_J_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_J_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_K_PasswordJumpSubtractCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  01010101  10101010  10101010  10101010  10101010
    // bit2 10101010  01010101  01010101  10101010  10101010  10101010  01010101  01010101
    // bit3 10101010  01010101  01010101  01010101  10101010  10101010  01010101  01010101
    // bit4 01010101  10101010  01010101  10101010  10101010  01010101  10101010  01010101
    // bit5 01010101  10101010  01010101  01010101  10101010  01010101  10101010  01010101
    // bit6 01010101  01010101  10101010  10101010  10101010  01010101  01010101  10101010
    // bit7 01010101  01010101  10101010  01010101  10101010  01010101  01010101  10101010
    //
    // After Cipher:
    // bit0 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010
    // bit1 00000000  00000000  10101010  01010101  00000000  00000000  10101010  10101010
    // bit2 00000000  00000000  01010101  10101010  00000000  00000000  01010101  01010101
    // bit3 00000000  00000000  01010101  10101010  00000000  00000000  01010101  10101010
    // bit4 00000000  00000000  01010101  10101010  00000000  00000000  10101010  01010101
    // bit5 00000000  00000000  11111111  01010101  00000000  00000000  10101010  01010101
    // bit6 00000000  00000000  00000000  11111111  00000000  00000000  01010101  10101010
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  11111111  11111111
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........
    // bit1 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........
    // bit2 X.X.X.X.  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........
    // bit3 X.X.X.X.  .X.X.X.X  ........  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  XXXXXXXX
    // bit4 .X.X.X.X  X.X.X.X.  ........  ........  X.X.X.X.  .X.X.X.X  ........  ........
    // bit5 .X.X.X.X  X.X.X.X.  X.X.X.X.  ........  X.X.X.X.  .X.X.X.X  ........  ........
    // bit6 .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X
    // Avalanche: 33.59%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskBuffer[64] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskJumpBuffer[64] = {
        0x2E, 0x84, 0x18, 0xD7, 0xFC, 0x68, 0x49, 0xF1, 0x96, 0x6F, 0xD5, 0x16, 0x4E, 0xC0, 0xA4, 0x1C,
        0xC9, 0x65, 0x77, 0x29, 0x4E, 0x5D, 0x80, 0x4F, 0x1D, 0x51, 0xC7, 0xDE, 0x02, 0xE0, 0x18, 0x24,
        0xFF, 0xD9, 0x22, 0xC1, 0x55, 0xDE, 0x7A, 0x05, 0x33, 0xFD, 0xD4, 0x9C, 0xEB, 0xFB, 0x18, 0xDB,
        0x75, 0x59, 0x17, 0xD7, 0x2F, 0x3F, 0x1D, 0x93, 0x36, 0x3E, 0xD2, 0xF4, 0x1C, 0xB8, 0xC6, 0xD7
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xC4, 0x3C, 0xC4, 0x3C, 0xC4, 0x3C, 0xC4, 0x3C, 0xBA, 0x46, 0xBA, 0x46, 0xBA, 0x46, 0xBA, 0x46,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xCD, 0x33, 0xCD, 0x33, 0xCD, 0x33, 0xCD, 0x33, 0xD3, 0x2D, 0xD3, 0x2D, 0xD3, 0x2D, 0xD3, 0x2D
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_K_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_K_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_K_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_K_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_K_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_K_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_L_PasswordJumpSubtractCipher {

    // Before Cipher:
    // bit0 10000101  11101000  01011110  10000101  11101000  01011110  10000101  11101000
    // bit1 10000101  01010101  01011110  10000000  10101000  01011110  10101111  11101000
    // bit2 10101010  10101000  01010101  01111111  11101000  00000001  01010101  11101010
    // bit3 10101010  00010101  01010101  01111010  10101000  00000001  01111111  11101010
    // bit4 01010000  10101000  00001010  10101111  11101010  11110101  01010101  01010101
    // bit5 01010000  00010101  00001010  10101010  10101010  11110101  01111111  01010101
    // bit6 01111111  11101000  00000001  01010101  11101010  10101010  10000101  01010111
    // bit7 01111111  01010101  00000001  01010000  10101010  10101010  10101111  01010111
    //
    // After Cipher:
    // bit0 00000000  00000000  01110100  10000101  00111010  01011110  10001011  01111010
    // bit1 00000000  00000000  00001110  10101000  01010000  01001000  11110001  01010111
    // bit2 00000000  00000000  11111111  01010000  11101010  00010101  00000000  10101111
    // bit3 00000000  00000000  11011111  11000101  10000010  10111110  00100000  00111010
    // bit4 00000000  00000000  10100000  10101111  11101010  11110101  01011111  01010000
    // bit5 00000000  00000000  11011011  11111000  11010000  11110101  01110101  11111111
    // bit6 00000000  00000000  00101010  00000101  01101010  10101000  10000100  00000010
    // bit7 00000000  00000000  10101110  00000111  00000101  11111101  10101110  00000111
    //
    // Avalanche:
    // bit0 X....X.X  XXX.X...  ..X.X.X.  ........  XX.X..X.  ........  ....XXX.  X..X..X.
    // bit1 X....X.X  .X.X.X.X  .X.X....  ..X.X...  XXXXX...  ...X.XX.  .X.XXXX.  X.XXXXXX
    // bit2 X.X.X.X.  X.X.X...  X.X.X.X.  ..X.XXXX  ......X.  ...X.X..  .X.X.X.X  .X...X.X
    // bit3 X.X.X.X.  ...X.X.X  X...X.X.  X.XXXXXX  ..X.X.X.  X.XXXXXX  .X.XXXXX  XX.X....
    // bit4 .X.X....  X.X.X...  X.X.X.X.  ........  ........  ........  ....X.X.  .....X.X
    // bit5 .X.X....  ...X.X.X  XX.X...X  .X.X..X.  .XXXX.X.  ........  ....X.X.  X.X.X.X.
    // bit6 .XXXXXXX  XXX.X...  ..X.X.XX  .X.X....  X.......  ......X.  .......X  .X.X.X.X
    // bit7 .XXXXXXX  .X.X.X.X  X.X.XXXX  .X.X.XXX  X.X.XXXX  .X.X.XXX  .......X  .X.X....
    // Avalanche: 40.82%

    const std::uint8_t aOriginal[64] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA,
        0xFF, 0xAA, 0xFF, 0x00, 0xFF, 0x00, 0x0F, 0x00, 0x0F, 0xCC, 0x0F, 0xCC, 0xC3, 0xCC, 0xC3, 0x3C,
        0xC3, 0x3C, 0x55, 0x3C, 0x55, 0xFF, 0x55, 0xFF, 0xF0, 0xFF, 0xF0, 0x0F, 0xF0, 0x0F, 0x33, 0x0F
    };

    const std::uint8_t aMaskBuffer[64] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA,
        0xFF, 0xAA, 0xFF, 0x00, 0xFF, 0x00, 0x0F, 0x00, 0x0F, 0xCC, 0x0F, 0xCC, 0xC3, 0xCC, 0xC3, 0x3C,
        0xC3, 0x3C, 0x55, 0x3C, 0x55, 0xFF, 0x55, 0xFF, 0xF0, 0xFF, 0xF0, 0x0F, 0xF0, 0x0F, 0x33, 0x0F
    };

    const std::uint8_t aMaskJumpBuffer[64] = {
        0x0B, 0xB8, 0x42, 0xFF, 0x04, 0x38, 0xB7, 0x59, 0x6C, 0x9A, 0x2C, 0xE2, 0x39, 0xC8, 0xFF, 0x6E,
        0xA5, 0x57, 0x2F, 0x95, 0xF1, 0x07, 0xE7, 0x26, 0x8D, 0x6D, 0x60, 0xCD, 0xA9, 0x1C, 0x73, 0xD6,
        0xB5, 0x4C, 0xF0, 0x25, 0xBE, 0x3C, 0xB3, 0x95, 0xF3, 0xA6, 0x34, 0x70, 0x36, 0x8D, 0x89, 0x55,
        0xC3, 0x7C, 0x9C, 0xC4, 0x74, 0xE3, 0x51, 0xF2, 0x7B, 0xB5, 0x4D, 0x04, 0x71, 0xCC, 0x4A, 0x90
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x3D, 0xB4, 0xAB, 0xB4, 0x77, 0xF1, 0x77, 0x34, 0xDC, 0x34, 0x4C, 0x24, 0x4C, 0x9B, 0x09, 0x9B,
        0x3C, 0x6E, 0xAA, 0xC4, 0xAA, 0x01, 0xBA, 0x01, 0x1F, 0xCD, 0x1F, 0xBD, 0xD3, 0xBD, 0x90, 0x2D,
        0xC3, 0x4C, 0x55, 0x4C, 0x89, 0x0F, 0x89, 0xCC, 0x24, 0xCC, 0xB4, 0xDC, 0xB4, 0x65, 0xF7, 0x65
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_L_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_L_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_L_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_L_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_L_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_64_L_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_A_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 0.00%

    const std::uint8_t aOriginal[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aMaskBuffer[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aMaskJumpBuffer[96] = {
        0xED, 0xF3, 0x79, 0xDD, 0x91, 0xBB, 0xD9, 0x78, 0x56, 0x5F, 0x66, 0xE9, 0xDA, 0xFB, 0x34, 0x1D,
        0x43, 0x8C, 0x74, 0xE3, 0xBD, 0x24, 0xCC, 0xCF, 0x7F, 0x06, 0x91, 0xB6, 0x1F, 0x31, 0x6E, 0x63,
        0x87, 0x3A, 0x70, 0x91, 0xD2, 0x1B, 0x93, 0xE0, 0xF8, 0x6F, 0x8C, 0x2E, 0x19, 0xB0, 0x2A, 0x0E,
        0x49, 0xE0, 0x28, 0x0D, 0x46, 0x00, 0x96, 0x59, 0xC9, 0x94, 0x7F, 0xBA, 0x79, 0x3F, 0x4C, 0x7F,
        0xA1, 0xC5, 0x5E, 0x2C, 0x07, 0x16, 0x00, 0xF1, 0x4A, 0x01, 0x7C, 0xCD, 0x33, 0xC5, 0x3F, 0x89,
        0x2F, 0x93, 0x61, 0x1A, 0x04, 0x6F, 0xA2, 0x91, 0xA0, 0x7B, 0x0F, 0x0F, 0x1C, 0x04, 0x1A, 0xB9
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_96_A_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_A_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_A_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_A_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_A_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_A_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_B_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 100.00%

    const std::uint8_t aOriginal[96] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskBuffer[96] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskJumpBuffer[96] = {
        0x94, 0x35, 0xA3, 0x76, 0xA9, 0xF6, 0x41, 0x09, 0xF7, 0xA6, 0xB7, 0xA8, 0x73, 0x0D, 0xCD, 0x47,
        0x03, 0xCD, 0xA6, 0xD4, 0xFD, 0x23, 0xB1, 0xB3, 0x8A, 0x14, 0x5D, 0x7B, 0x97, 0x66, 0x96, 0xB2,
        0x9A, 0x4E, 0xDF, 0x50, 0x87, 0x3C, 0x2E, 0x70, 0x59, 0x00, 0xF7, 0x7F, 0x70, 0xFA, 0x56, 0x31,
        0x52, 0xBC, 0x9D, 0x76, 0x43, 0x2A, 0x48, 0x40, 0x93, 0x9E, 0x8A, 0x8B, 0x13, 0x76, 0x34, 0x5F,
        0xB7, 0xD7, 0x6B, 0xAF, 0xFA, 0x39, 0x1D, 0xAD, 0x0E, 0x57, 0xE9, 0x69, 0x17, 0xD4, 0x47, 0x27,
        0x71, 0xD2, 0xF8, 0xDA, 0x0F, 0x61, 0x31, 0x5E, 0x30, 0x1D, 0xEB, 0x69, 0x6C, 0x6C, 0xFC, 0x39
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_96_B_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_B_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_B_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_B_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_B_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_B_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_C_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit2 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit3 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit4 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit5 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit6 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[96] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskBuffer[96] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskJumpBuffer[96] = {
        0x29, 0x08, 0x37, 0xB6, 0xCE, 0x50, 0x3F, 0x83, 0x2C, 0x22, 0xF8, 0x6A, 0x58, 0x33, 0xB9, 0x47,
        0x5C, 0x7D, 0x5D, 0x51, 0xDC, 0x58, 0x81, 0xE7, 0xA2, 0xBF, 0x3D, 0x53, 0x1A, 0x2B, 0x1D, 0xDE,
        0x53, 0x40, 0x94, 0x45, 0x0F, 0xBF, 0xFA, 0xDB, 0xE0, 0xAE, 0xCC, 0x20, 0xEE, 0x24, 0xAD, 0xFE,
        0xE5, 0x05, 0xD5, 0xB9, 0xC9, 0xCC, 0xA1, 0x25, 0x6E, 0xBD, 0x0C, 0x09, 0x12, 0x7D, 0x0D, 0xAD,
        0x49, 0x3E, 0x01, 0x26, 0xC3, 0x54, 0x6C, 0x50, 0xB6, 0xB1, 0xD8, 0x33, 0x7D, 0xC3, 0xB1, 0x68,
        0xBC, 0x18, 0x43, 0x88, 0x04, 0x5B, 0xF8, 0x52, 0xC6, 0x5E, 0x85, 0x2B, 0x1B, 0xBB, 0x78, 0xFB
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_96_C_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_C_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_C_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_C_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_C_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_C_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_D_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit2 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit3 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit5 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit6 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[96] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskBuffer[96] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskJumpBuffer[96] = {
        0x7C, 0xE7, 0x20, 0x7A, 0x73, 0x78, 0x67, 0x25, 0xB5, 0x6E, 0xF1, 0x9C, 0x10, 0x25, 0x5F, 0xD1,
        0xEB, 0x5B, 0x16, 0xAB, 0x1E, 0xF8, 0x65, 0x9D, 0xD3, 0x30, 0x2E, 0x99, 0x2F, 0x2A, 0x01, 0xB2,
        0xC3, 0xA5, 0xC5, 0x04, 0xA5, 0x53, 0x36, 0x56, 0xC4, 0x67, 0x0B, 0x11, 0x4C, 0x71, 0x48, 0x4C,
        0xC4, 0xD4, 0xB0, 0xC7, 0x52, 0x90, 0x65, 0x5E, 0x3B, 0x1F, 0x47, 0x8C, 0x34, 0x41, 0x69, 0x3B,
        0x0F, 0xB1, 0x9F, 0x73, 0x5B, 0x1F, 0x4E, 0x9B, 0x8B, 0xCE, 0x20, 0xA7, 0xA5, 0x44, 0x59, 0xC1,
        0x66, 0xF2, 0xD4, 0x92, 0x75, 0xE4, 0x8D, 0xEB, 0x4B, 0xEA, 0xDA, 0xF5, 0xBF, 0x67, 0x3D, 0x5C
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_96_D_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_D_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_D_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_D_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_D_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_D_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_E_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit2 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit3 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit4 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit5 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit6 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit7 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[96] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskBuffer[96] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskJumpBuffer[96] = {
        0x11, 0x22, 0x96, 0xD8, 0x7E, 0x27, 0x94, 0x13, 0xF4, 0xF2, 0xFC, 0x4C, 0x27, 0xED, 0xD5, 0xA0,
        0xA3, 0xBF, 0xFF, 0xDE, 0x95, 0x7F, 0x73, 0xEE, 0x7B, 0x86, 0xA2, 0x16, 0xAC, 0x80, 0x3B, 0xD4,
        0x12, 0x29, 0xB2, 0x60, 0x58, 0x44, 0x41, 0x4C, 0xE3, 0x38, 0x69, 0xD5, 0x7F, 0x63, 0x80, 0x41,
        0x4C, 0x98, 0x04, 0xF8, 0x1F, 0xA0, 0x19, 0x21, 0x6F, 0x45, 0x86, 0x2C, 0x67, 0xCB, 0xE6, 0x55,
        0x66, 0xF6, 0x7E, 0x1B, 0xC7, 0xC2, 0x1E, 0x3D, 0x71, 0xC0, 0x70, 0xA8, 0xAC, 0x57, 0x70, 0xF5,
        0x32, 0x06, 0x4C, 0x3F, 0xE2, 0x8F, 0xEE, 0x3E, 0x3D, 0x04, 0xFA, 0xAE, 0x50, 0x39, 0xB4, 0x81
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_96_E_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_E_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_E_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_E_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_E_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_E_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_F_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit2 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit3 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit5 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit6 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[96] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskBuffer[96] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[96] = {
        0x81, 0xFB, 0x79, 0xB3, 0xFA, 0x16, 0x31, 0xBA, 0x8C, 0x3B, 0x6E, 0x8B, 0x5E, 0xA4, 0x4F, 0xE1,
        0xA9, 0x36, 0x95, 0x58, 0xBD, 0xA9, 0x3D, 0x68, 0x34, 0x30, 0xEA, 0x84, 0xB6, 0x11, 0xAB, 0x3C,
        0xFB, 0x47, 0xB3, 0xC1, 0x1E, 0x75, 0x12, 0x73, 0xF3, 0x7D, 0x2C, 0x8A, 0xBD, 0xF4, 0x0A, 0xE3,
        0x6C, 0xFF, 0xD8, 0xCD, 0x6F, 0xB6, 0x04, 0x03, 0xA9, 0xD7, 0x44, 0xB4, 0xE1, 0x1D, 0x87, 0x85,
        0xD7, 0x56, 0xEF, 0xF2, 0xB4, 0xCA, 0x7D, 0xE0, 0x4D, 0xF6, 0xB9, 0xD0, 0x7A, 0xA9, 0xB8, 0x21,
        0x7C, 0xC4, 0x88, 0x95, 0xC7, 0x8B, 0x1C, 0xF7, 0x01, 0xFE, 0xF0, 0xDA, 0x41, 0x13, 0x2F, 0x5D
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_96_F_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_F_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_F_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_F_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_F_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_F_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_G_PasswordJumpSubtractCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101001  10101010  01101010  10011010  10100110  10101001  10101010  01101010  10011010  10100110  10101001  10101010
    // bit2 10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001  01101010  01011010  10010110  10100101
    // bit3 10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001  01011010  01010110  10010101  10100101
    // bit4 01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110  10011001
    // bit5 01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101  10011001
    // bit6 01011010  10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001  01101010  01011010  10010110
    // bit7 01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110  01011001  10010110
    //
    // After Cipher:
    // bit0 00000000  00000000  10010101  01100101  00000000  00000000  01010101  10010101  10100101  10101001  00000000  00000000
    // bit1 00000000  00000000  01010101  01010101  00000000  00000000  01010101  01010101  10100110  10101001  00000000  00000000
    // bit2 00000000  00000000  10011001  01100110  00000000  00000000  01100101  10011001  01011001  01010110  00000000  00000000
    // bit3 00000000  00000000  01010101  10010101  00000000  00000000  01010110  01010101  10101001  01101010  00000000  00000000
    // bit4 00000000  00000000  10100110  10101001  00000000  00000000  10011010  10100110  01101001  10011010  00000000  00000000
    // bit5 00000000  00000000  01101101  01011011  00000000  00000000  10110101  01101101  01101110  10011011  00000000  00000000
    // bit6 00000000  00000000  10100001  01101000  00000000  00000000  10000101  10100001  10110011  01101100  00000000  00000000
    // bit7 00000000  00000000  11110011  11111100  00000000  00000000  11001111  11110011  11000000  11110000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  ..XXXXXX  XX..XXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  ..XXXXXX  ....XXXX  ......XX  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X..X  X.X.X.X.  ..XXXXXX  XX..XXXX  X.X..XX.  X.X.X..X  XXXXXXXX  ..XXXXXX  ..XXXX..  ....XXXX  X.X.X..X  X.X.X.X.
    // bit2 X..X.XX.  X.X..X.X  ..XX....  ....XX..  .X.XX.X.  X..X.XX.  XX......  ..XX....  ..XX..XX  ....XX..  X..X.XX.  X.X..X.X
    // bit3 X..X.X.X  X.X..X.X  ..XXXX..  XX..XXXX  .X.X.XX.  X..X.X.X  XXXX..XX  ..XXXX..  XXXX..XX  ..XXXX..  X..X.X.X  X.X..X.X
    // bit4 .XX..XX.  X..XX..X  ........  XX......  X..XX.X.  .XX..XX.  ......XX  ........  ........  ........  .XX..XX.  X..XX..X
    // bit5 .XX..X.X  X..XX..X  ....X.XX  ......X.  X..X.XX.  .XX..X.X  ..X.XX..  ....X.XX  ..XX.XXX  ....XX.X  .XX..X.X  X..XX..X
    // bit6 .X.XX.X.  X..X.XX.  .....X..  XX.....X  .XX.X.X.  .X.XX.X.  ...X..XX  .....X..  ...XX.X.  .....XX.  .X.XX.X.  X..X.XX.
    // bit7 .X.XX..X  X..X.XX.  X..X.XX.  .XX..X.X  .XX..XX.  .X.XX..X  .X.XX..X  X..X.XX.  .X.XX..X  X..X.XX.  .X.XX..X  X..X.XX.
    // Avalanche: 47.01%

    const std::uint8_t aOriginal[96] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F,
        0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55,
        0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33,
        0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00,
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C
    };

    const std::uint8_t aMaskBuffer[96] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F,
        0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55,
        0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33,
        0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00,
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C
    };

    const std::uint8_t aMaskJumpBuffer[96] = {
        0x51, 0xD1, 0xE1, 0xC1, 0xB3, 0x24, 0x6E, 0x75, 0xBF, 0xE9, 0x98, 0x3E, 0xDD, 0x6F, 0x32, 0x5C,
        0x6A, 0x3F, 0x60, 0x9A, 0xF1, 0x27, 0x8A, 0x8E, 0x6C, 0x31, 0xE9, 0x3C, 0xBD, 0xBD, 0x13, 0xFE,
        0xC3, 0x12, 0x31, 0x91, 0x1D, 0xE5, 0xC3, 0xD5, 0xFD, 0x77, 0xDC, 0xC6, 0x5D, 0x29, 0x2F, 0x8C,
        0x35, 0x19, 0x70, 0x42, 0xAD, 0x1E, 0xE3, 0x8D, 0x66, 0xE5, 0x99, 0xB6, 0x85, 0x9B, 0x96, 0xB6,
        0xFA, 0xCE, 0xCD, 0x67, 0xEF, 0xBB, 0x6D, 0xD6, 0xBF, 0x80, 0x5D, 0xAA, 0x61, 0x23, 0x06, 0xD4,
        0x5F, 0x78, 0xD0, 0x85, 0xC1, 0x90, 0x51, 0x13, 0xC4, 0x31, 0x05, 0xD2, 0x38, 0x75, 0x79, 0x5D
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xAB, 0x55, 0x0F, 0xF1, 0x24, 0xDC, 0x09, 0xF7, 0x19, 0xE7, 0xAB, 0x55, 0x0F, 0xF1, 0x24, 0xDC,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x0F, 0xF1, 0x24, 0xDC, 0x09, 0xF7, 0x19, 0xE7, 0xAB, 0x55, 0x0F, 0xF1, 0x24, 0xDC, 0x09, 0xF7,
        0xD3, 0x2D, 0xDE, 0x22, 0x3C, 0xC4, 0x46, 0xBA, 0xCD, 0x33, 0xD3, 0x2D, 0xDE, 0x22, 0x3C, 0xC4,
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
                                                    "test_fixed_96_G_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_G_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_G_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_G_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_G_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_G_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_H_PasswordJumpSubtractCipher {

    // Before Cipher:
    // bit0 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit1 01100101  01011001  01010110  01010101  10010101  01100101  01011001  01010110  01010101  10010101  01100101  01011001
    // bit2 01011010  01010110  10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001  01011010  01010110
    // bit3 01101010  01011010  10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001  01101010  01011010
    // bit4 01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110  01011001  10010110
    // bit5 01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110  01101001  10011010
    // bit6 01010110  10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001  01011010  01010110  10010101
    // bit7 01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110  10011001
    //
    // After Cipher:
    // bit0 00000000  00000000  10101001  10101010  01010110  10010101  10100110  10101001  01101010  01011010  10011010  10100110
    // bit1 00000000  00000000  10101010  10101010  01010101  10010101  10101010  10101010  01101010  10011010  10101010  10101010
    // bit2 00000000  00000000  10011001  10100110  10101010  01101010  01100110  10011001  10010101  01100101  10011010  01100110
    // bit3 00000000  00000000  10101010  01101010  01011010  01010110  10101001  10101010  10101001  01101010  10100110  10101001
    // bit4 00000000  00000000  01100101  01011001  01100110  01011001  10010101  01100101  10100110  01101001  01010101  10010101
    // bit5 00000000  00000000  10110110  10101101  01100101  11011001  11011010  10110110  11100110  10111001  01101010  11011010
    // bit6 00000000  00000000  10000101  10100001  11011011  00110110  00010110  10000101  00111001  11001110  01011010  00010110
    // bit7 00000000  00000000  11001111  11110011  00111100  00001111  00111111  11001111  00001111  00000011  11111111  00111111
    //
    // Avalanche:
    // bit0 .X.X.X.X  .X.X.X.X  XXXXXX..  XXXXXXXX  ......XX  XX......  XXXX..XX  XXXXXX..  ..XXXXXX  ....XXXX  XX..XXXX  XXXX..XX
    // bit1 .XX..X.X  .X.XX..X  XXXXXX..  XXXXXXXX  XX......  XXXX....  XXXX..XX  XXXXXX..  ..XXXXXX  ....XXXX  XX..XXXX  XXXX..XX
    // bit2 .X.XX.X.  .X.X.XX.  ....XX..  ......XX  XX....XX  ..XX....  ..XX....  ....XX..  ..XX....  ....XX..  XX......  ..XX....
    // bit3 .XX.X.X.  .X.XX.X.  ..XXXX..  XX..XXXX  XXXX..XX  ..XXXX..  XXXX..XX  ..XXXX..  ....XX..  XX....XX  XX..XX..  XXXX..XX
    // bit4 .X.XX..X  X..X.XX.  ........  XX......  ........  ........  ......XX  ........  ..XXXXXX  ....XXXX  ....XX..  ......XX
    // bit5 .XX.X..X  X..XX.X.  XX.X....  ..XX.X..  XX....XX  X.XX....  .X......  XX.X....  .XXXXXXX  ...XXXXX  ......XX  .X......
    // bit6 .X.X.XX.  X..X.X.X  ..X.....  XX..X...  X......X  .XX.....  X.....XX  ..X.....  .X.X....  X..X.X..  ....XX..  X.....XX
    // bit7 .XX..XX.  X..XX..X  .XX.X..X  X..XX.X.  X.X..XX.  .XX.X..X  X.X..XX.  .XX.X..X  .XX..XX.  X..XX..X  X..XX..X  X.X..XX.
    // Avalanche: 45.57%

    const std::uint8_t aOriginal[96] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF,
        0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC,
        0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA,
        0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0,
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3
    };

    const std::uint8_t aMaskBuffer[96] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF,
        0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC,
        0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA,
        0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0,
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3
    };

    const std::uint8_t aMaskJumpBuffer[96] = {
        0x76, 0x7B, 0x4E, 0x83, 0xE1, 0x8D, 0xA4, 0x46, 0x92, 0x8C, 0xA6, 0x5C, 0x03, 0xA4, 0x30, 0xAC,
        0xB2, 0x22, 0x4B, 0x27, 0x96, 0x97, 0x97, 0x50, 0xDE, 0x4F, 0x16, 0xAF, 0xEA, 0xAB, 0xEF, 0xBB,
        0x36, 0xAA, 0x6C, 0x1C, 0xD9, 0xF2, 0x4D, 0x4A, 0x7D, 0x0A, 0x75, 0x11, 0xDC, 0x1D, 0x39, 0xA3,
        0x9F, 0x48, 0xD1, 0x53, 0xD3, 0x6A, 0xDB, 0xA9, 0xBC, 0x8B, 0x86, 0x6C, 0x32, 0x7D, 0x32, 0xEB,
        0x85, 0x9C, 0xDF, 0x6B, 0xC4, 0x9E, 0x2A, 0xA0, 0x3F, 0xF9, 0x0A, 0xE9, 0xC1, 0x2A, 0x46, 0xCB,
        0x51, 0x08, 0x03, 0x79, 0x66, 0xB6, 0xBD, 0x6A, 0xD5, 0x12, 0xAF, 0x3D, 0xA0, 0x19, 0xAF, 0x52
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xF7, 0x09, 0xDC, 0x24, 0xF1, 0x0F, 0x55, 0xAB, 0xE7, 0x19, 0xF7, 0x09, 0xDC, 0x24, 0xF1, 0x0F,
        0x22, 0xDE, 0x2D, 0xD3, 0x33, 0xCD, 0xBA, 0x46, 0xC4, 0x3C, 0x22, 0xDE, 0x2D, 0xD3, 0x33, 0xCD,
        0xDC, 0x24, 0xF1, 0x0F, 0x55, 0xAB, 0xE7, 0x19, 0xF7, 0x09, 0xDC, 0x24, 0xF1, 0x0F, 0x55, 0xAB,
        0x3C, 0xC4, 0xDE, 0x22, 0xD3, 0x2D, 0xCD, 0x33, 0x46, 0xBA, 0x3C, 0xC4, 0xDE, 0x22, 0xD3, 0x2D,
        0xF1, 0x0F, 0x55, 0xAB, 0xE7, 0x19, 0xF7, 0x09, 0xDC, 0x24, 0xF1, 0x0F, 0x55, 0xAB, 0xE7, 0x19
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_H_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_H_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_H_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_H_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_H_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_H_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_I_PasswordJumpSubtractCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10001010  11100010  10111000  10101110  00101011  10001010  11100010  10111000  10101110  00101011  10001010  11100010
    // bit2 11100110  00111001  10001110  01100011  10011000  11100110  00111001  10001110  01100011  10011000  11100110  00111001
    // bit3 11000110  01110001  10011100  01100111  00011001  11000110  01110001  10011100  01100111  00011001  11000110  01110001
    // bit4 00101111  00001011  11000010  11110000  10111100  00101111  00001011  11000010  11110000  10111100  00101111  00001011
    // bit5 00001111  01000011  11010000  11110100  00111101  00001111  01000011  11010000  11110100  00111101  00001111  01000011
    // bit6 01100011  10011000  11100110  00111001  10001110  01100011  10011000  11100110  00111001  10001110  01100011  10011000
    // bit7 01000011  11010000  11110100  00111101  00001111  01000011  11010000  11110100  00111101  00001111  01000011  11010000
    //
    // After Cipher:
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00011101  01000111  10011000  11100110  10111000  10101110
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  01010101  01010101  10001010  11100010  10101010  10101010
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00111101  00001111  01110101  00011101  11110000  10111100
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  11010100  01110101  00111001  10001110  10001010  11100010
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  10001010  11100010  11110000  10111100  00011101  01000111
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  01110001  11011100  11100010  11111000  01101011  10011010
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00011001  10000110  00011111  10000111  00110001  10001100
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  11011111  10110111  11001001  00110010  10110111  11101101
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.XX.XXX  XXX.XX.X  ..XX..X.  .X..XX..  ...X..X.  .....X..
    // bit1 X...X.X.  XXX...X.  X.XXX...  X.X.XXX.  ..X.X.XX  X...X.X.  X.XX.XXX  XXX.XX.X  ..X..X..  XX..X..X  ..X.....  .X..X...
    // bit2 XXX..XX.  ..XXX..X  X...XXX.  .XX...XX  X..XX...  XXX..XX.  .....X..  X......X  ...X.XX.  X....X.X  ...X.XX.  X....X.X
    // bit3 XX...XX.  .XXX...X  X..XXX..  .XX..XXX  ...XX..X  XX...XX.  X.X..X.X  XXX.X..X  .X.XXXX.  X..X.XXX  .X..XX..  X..X..XX
    // bit4 ..X.XXXX  ....X.XX  XX....X.  XXXX....  X.XXXX..  ..X.XXXX  X......X  ..X.....  ........  ........  ..XX..X.  .X..XX..
    // bit5 ....XXXX  .X....XX  XX.X....  XXXX.X..  ..XXXX.X  ....XXXX  ..XX..X.  ....XX..  ...X.XX.  XX...X.X  .XX..X..  XX.XX..X
    // bit6 .XX...XX  X..XX...  XXX..XX.  ..XXX..X  X...XXX.  .XX...XX  X......X  .XX.....  ..X..XX.  ....X..X  .X.X..X.  ...X.X..
    // bit7 .X....XX  XX.X....  XXXX.X..  ..XXXX.X  ....XXXX  .X....XX  ....XXXX  .X....XX  XXXX.X..  ..XXXX.X  XXXX.X..  ..XXXX.X
    // Avalanche: 44.92%

    const std::uint8_t aOriginal[96] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33,
        0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F,
        0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00,
        0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55,
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C
    };

    const std::uint8_t aMaskBuffer[96] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33,
        0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F,
        0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00,
        0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55,
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C
    };

    const std::uint8_t aMaskJumpBuffer[96] = {
        0x85, 0x25, 0xFC, 0x29, 0x7E, 0x67, 0xC9, 0x4C, 0xAD, 0xF4, 0x66, 0xF6, 0x59, 0xBE, 0x42, 0x2D,
        0xC5, 0x00, 0xC8, 0x4D, 0xD8, 0x2B, 0xC8, 0x0B, 0x37, 0x3C, 0xB5, 0xB9, 0x55, 0x5E, 0x2D, 0x60,
        0xBC, 0x1C, 0x94, 0x65, 0x1C, 0x53, 0xB5, 0x33, 0x80, 0xCA, 0x95, 0xAF, 0x72, 0x0E, 0x12, 0xA0,
        0x7A, 0xB6, 0xC2, 0x4E, 0x87, 0x50, 0xE3, 0x31, 0x71, 0x4A, 0xF4, 0xE2, 0x00, 0x1F, 0xAB, 0x3D,
        0x59, 0x4E, 0xA6, 0x8D, 0xBD, 0xF8, 0x30, 0x8C, 0x30, 0x4A, 0x24, 0x53, 0xE4, 0x69, 0xAE, 0xD8,
        0x94, 0x9C, 0xC3, 0xC4, 0x81, 0xE8, 0x10, 0x75, 0x47, 0x71, 0x77, 0x0E, 0x1F, 0xB0, 0x3D, 0xDB
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x19, 0x55, 0x24, 0xF7, 0xAB, 0xF1, 0x09, 0xE7, 0x0F, 0xDC, 0x19, 0x55, 0x24, 0xF7, 0xAB, 0xF1,
        0xCD, 0x2D, 0x3C, 0xBA, 0xD3, 0x22, 0x46, 0x33, 0xDE, 0xC4, 0xCD, 0x2D, 0x3C, 0xBA, 0xD3, 0x22,
        0xF1, 0x24, 0xE7, 0xAB, 0xDC, 0x09, 0x55, 0x0F, 0xF7, 0x19, 0xF1, 0x24, 0xE7, 0xAB, 0xDC, 0x09
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_I_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_I_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_I_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_I_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_I_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_I_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_J_PasswordJumpSubtractCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[96] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    const std::uint8_t aMaskBuffer[96] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[96] = {
        0x6E, 0x29, 0x8A, 0x59, 0x35, 0x8C, 0x4A, 0x89, 0xDD, 0xFF, 0x5D, 0x0E, 0x69, 0x51, 0x8C, 0x84,
        0x8C, 0x3F, 0xCD, 0x92, 0xC8, 0x42, 0x1D, 0xE3, 0x9D, 0x0A, 0xF1, 0xA5, 0x85, 0xCE, 0xE5, 0xD5,
        0x75, 0xD1, 0xD3, 0xAC, 0x48, 0x86, 0x00, 0xBA, 0xB0, 0x95, 0x8F, 0xA4, 0x17, 0x2F, 0xEA, 0x1C,
        0xAD, 0x30, 0x4E, 0xAC, 0xE8, 0xE9, 0x2D, 0xB9, 0xAA, 0x70, 0xBA, 0xDC, 0xC7, 0xAD, 0x4C, 0x08,
        0xF5, 0x3C, 0xE6, 0x95, 0x45, 0xB4, 0x5C, 0xB8, 0x6C, 0x5B, 0x65, 0xCD, 0x51, 0x86, 0x81, 0xDC,
        0xA7, 0x7B, 0xAF, 0xB6, 0x03, 0x03, 0x3C, 0x7C, 0x0B, 0x12, 0x31, 0xE8, 0xD4, 0x5F, 0xCB, 0xBA
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_96_J_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_J_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_J_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_J_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_J_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_J_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_K_PasswordJumpSubtractCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  01010101  10101010  10101010  10101010  10101010  01010101  10101010  10101010  10101010
    // bit2 10101010  01010101  01010101  10101010  10101010  10101010  01010101  01010101  10101010  10101010  10101010  01010101
    // bit3 10101010  01010101  01010101  01010101  10101010  10101010  01010101  01010101  01010101  10101010  10101010  01010101
    // bit4 01010101  10101010  01010101  10101010  10101010  01010101  10101010  01010101  10101010  10101010  01010101  10101010
    // bit5 01010101  10101010  01010101  01010101  10101010  01010101  10101010  01010101  01010101  10101010  01010101  10101010
    // bit6 01010101  01010101  10101010  10101010  10101010  01010101  01010101  10101010  10101010  10101010  01010101  01010101
    // bit7 01010101  01010101  10101010  01010101  10101010  01010101  01010101  10101010  01010101  10101010  01010101  01010101
    //
    // After Cipher:
    // bit0 00000000  00000000  10101010  10101010  01010101  01010101  10101010  10101010  10101010  01010101  01010101  01010101
    // bit1 00000000  00000000  10101010  10101010  01010101  01010101  10101010  10101010  01010101  01010101  01010101  01010101
    // bit2 00000000  00000000  01010101  01010101  10101010  10101010  01010101  10101010  10101010  10101010  10101010  01010101
    // bit3 00000000  00000000  10101010  10101010  10101010  01010101  10101010  10101010  10101010  10101010  01010101  01010101
    // bit4 00000000  00000000  01010101  10101010  01010101  10101010  10101010  01010101  10101010  01010101  01010101  10101010
    // bit5 00000000  00000000  01010101  10101010  01010101  10101010  11111111  10101010  01010101  01010101  11111111  01010101
    // bit6 00000000  00000000  10101010  11111111  10101010  01010101  00000000  10101010  11111111  10101010  00000000  01010101
    // bit7 00000000  00000000  11111111  00000000  11111111  11111111  00000000  11111111  00000000  11111111  00000000  11111111
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 X.X.X.X.  X.X.X.X.  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  ........  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 X.X.X.X.  .X.X.X.X  ........  XXXXXXXX  ........  ........  ........  XXXXXXXX  ........  ........  ........  ........
    // bit3 X.X.X.X.  .X.X.X.X  XXXXXXXX  XXXXXXXX  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  XXXXXXXX  ........
    // bit4 .X.X.X.X  X.X.X.X.  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  ........  XXXXXXXX  ........  ........
    // bit5 .X.X.X.X  X.X.X.X.  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  .X.X.X.X  XXXXXXXX  ........  XXXXXXXX  X.X.X.X.  XXXXXXXX
    // bit6 .X.X.X.X  .X.X.X.X  ........  .X.X.X.X  ........  ........  .X.X.X.X  ........  .X.X.X.X  ........  .X.X.X.X  ........
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  X.X.X.X.
    // Avalanche: 46.88%

    const std::uint8_t aOriginal[96] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskBuffer[96] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskJumpBuffer[96] = {
        0x7D, 0x1C, 0xF9, 0x8A, 0xB1, 0x8D, 0x19, 0x1D, 0xA1, 0x31, 0xB1, 0x29, 0x68, 0x31, 0xE0, 0xCE,
        0x83, 0xCF, 0x05, 0xCD, 0x53, 0x3D, 0x27, 0xB5, 0xC6, 0x06, 0xD0, 0xCC, 0x91, 0x89, 0x41, 0x9B,
        0x15, 0x97, 0x0D, 0x5C, 0xEC, 0xB3, 0xA0, 0x1F, 0x91, 0xB2, 0xE9, 0xBB, 0x8B, 0xC4, 0xA3, 0xCF,
        0x08, 0xFB, 0xE2, 0x57, 0xC8, 0x79, 0xC0, 0x3E, 0x5F, 0xE0, 0x14, 0x00, 0xFA, 0x58, 0xAE, 0x34,
        0xC3, 0xB6, 0x31, 0x05, 0xD0, 0x97, 0xA1, 0x8C, 0xEE, 0xBB, 0x7D, 0xD3, 0x22, 0xD8, 0xC9, 0x2C,
        0x05, 0x27, 0x16, 0x12, 0xCE, 0xB9, 0x26, 0x77, 0xDA, 0xC6, 0xD6, 0x5F, 0x47, 0x63, 0x9A, 0x7C
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xD3, 0x2D, 0xD3, 0x2D, 0xD3, 0x2D, 0xD3, 0x2D, 0xDE, 0x22, 0xDE, 0x22, 0xDE, 0x22, 0xDE, 0x22,
        0x33, 0xCD, 0x33, 0xCD, 0x33, 0xCD, 0x33, 0xCD, 0x2D, 0xD3, 0x2D, 0xD3, 0x2D, 0xD3, 0x2D, 0xD3,
        0xDC, 0x24, 0xDC, 0x24, 0xDC, 0x24, 0xDC, 0x24, 0xF7, 0x09, 0xF7, 0x09, 0xF7, 0x09, 0xF7, 0x09,
        0xBA, 0x46, 0xBA, 0x46, 0xBA, 0x46, 0xBA, 0x46, 0x33, 0xCD, 0x33, 0xCD, 0x33, 0xCD, 0x33, 0xCD,
        0x24, 0xDC, 0x24, 0xDC, 0x24, 0xDC, 0x24, 0xDC, 0x09, 0xF7, 0x09, 0xF7, 0x09, 0xF7, 0x09, 0xF7
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_K_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_K_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_K_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_K_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_K_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_K_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_L_PasswordJumpSubtractCipher {

    // Before Cipher:
    // bit0 10000101  11101000  01011110  10000101  11101000  01011110  10000101  11101000  01011110  10000101  11101000  01011110
    // bit1 10000101  01010101  01011110  10000000  10101000  01011110  10101111  11101000  01010101  01010101  11101000  00001010
    // bit2 10101010  10101000  01010101  01111111  11101000  00000001  01010101  11101010  10101010  10000101  01010111  11111110
    // bit3 10101010  00010101  01010101  01111010  10101000  00000001  01111111  11101010  10100001  01010101  01010111  10101010
    // bit4 01010000  10101000  00001010  10101111  11101010  11110101  01010101  01010101  00001010  10000000  10101010  11111110
    // bit5 01010000  00010101  00001010  10101010  10101010  11110101  01111111  01010101  00000001  01010000  10101010  10101010
    // bit6 01111111  11101000  00000001  01010101  11101010  10101010  10000101  01010111  11111110  10000000  00010101  01011110
    // bit7 01111111  01010101  00000001  01010000  10101010  10101010  10101111  01010111  11110101  01010000  00010101  00001010
    //
    // After Cipher:
    // bit0 00000000  00000000  10100001  01010101  01111010  00000011  00000000  00000000  00000000  00000000  10100011  10001110
    // bit1 00000000  00000000  10100001  01010000  00111010  10110111  00000000  00000000  00000000  00000000  00010101  01011010
    // bit2 00000000  00000000  01011110  10101111  00010101  10110101  00000000  00000000  00000000  00000000  01011100  00101110
    // bit3 00000000  00000000  00000001  01111111  01010111  00011100  00000000  00000000  00000000  00000000  10110111  11111111
    // bit4 00000000  00000000  11110101  01111111  11101111  01001000  00000000  00000000  00000000  00000000  11100001  00101110
    // bit5 00000000  00000000  11110101  01111010  10101111  10110101  00000000  00000000  00000000  00000000  01000001  01111010
    // bit6 00000000  00000000  00001011  11010101  11000000  00010111  00000000  00000000  00000000  00000000  00001011  10001110
    // bit7 00000000  00000000  11110100  00000000  11010101  11111111  00000000  00000000  00000000  00000000  11100000  01011010
    //
    // Avalanche:
    // bit0 X....X.X  XXX.X...  XXXXXXXX  XX.X....  X..X..X.  .X.XXX.X  X....X.X  XXX.X...  .X.XXXX.  X....X.X  .X..X.XX  XX.X....
    // bit1 X....X.X  .X.X.X.X  XXXXXXXX  XX.X....  X..X..X.  XXX.X..X  X.X.XXXX  XXX.X...  .X.X.X.X  .X.X.X.X  XXXXXX.X  .X.X....
    // bit2 X.X.X.X.  X.X.X...  ....X.XX  XX.X....  XXXXXX.X  X.XX.X..  .X.X.X.X  XXX.X.X.  X.X.X.X.  X....X.X  ....X.XX  XX.X....
    // bit3 X.X.X.X.  ...X.X.X  .X.X.X..  .....X.X  XXXXXXXX  ...XXX.X  .XXXXXXX  XXX.X.X.  X.X....X  .X.X.X.X  XXX.....  .X.X.X.X
    // bit4 .X.X....  X.X.X...  XXXXXXXX  XX.X....  .....X.X  X.XXXX.X  .X.X.X.X  .X.X.X.X  ....X.X.  X.......  .X..X.XX  XX.X....
    // bit5 .X.X....  ...X.X.X  XXXXXXXX  XX.X....  .....X.X  .X......  .XXXXXXX  .X.X.X.X  .......X  .X.X....  XXX.X.XX  XX.X....
    // bit6 .XXXXXXX  XXX.X...  ....X.X.  X.......  ..X.X.X.  X.XXXX.X  X....X.X  .X.X.XXX  XXXXXXX.  X.......  ...XXXX.  XX.X....
    // bit7 .XXXXXXX  .X.X.X.X  XXXX.X.X  .X.X....  .XXXXXXX  .X.X.X.X  X.X.XXXX  .X.X.XXX  XXXX.X.X  .X.X....  XXXX.X.X  .X.X....
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[96] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA,
        0xFF, 0xAA, 0xFF, 0x00, 0xFF, 0x00, 0x0F, 0x00, 0x0F, 0xCC, 0x0F, 0xCC, 0xC3, 0xCC, 0xC3, 0x3C,
        0xC3, 0x3C, 0x55, 0x3C, 0x55, 0xFF, 0x55, 0xFF, 0xF0, 0xFF, 0xF0, 0x0F, 0xF0, 0x0F, 0x33, 0x0F,
        0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55, 0x00, 0xF0, 0x00, 0xF0,
        0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA, 0xFF, 0xAA, 0xFF, 0x00
    };

    const std::uint8_t aMaskBuffer[96] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA,
        0xFF, 0xAA, 0xFF, 0x00, 0xFF, 0x00, 0x0F, 0x00, 0x0F, 0xCC, 0x0F, 0xCC, 0xC3, 0xCC, 0xC3, 0x3C,
        0xC3, 0x3C, 0x55, 0x3C, 0x55, 0xFF, 0x55, 0xFF, 0xF0, 0xFF, 0xF0, 0x0F, 0xF0, 0x0F, 0x33, 0x0F,
        0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55, 0x00, 0xF0, 0x00, 0xF0,
        0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA, 0xFF, 0xAA, 0xFF, 0x00
    };

    const std::uint8_t aMaskJumpBuffer[96] = {
        0xB8, 0x56, 0x45, 0x4F, 0xB4, 0x6E, 0x53, 0xDC, 0x9D, 0xFB, 0x1B, 0x18, 0xAA, 0x75, 0x3D, 0x59,
        0x9B, 0x22, 0x11, 0xF5, 0x69, 0x3C, 0xEA, 0x2F, 0xC6, 0x92, 0x51, 0x1D, 0x70, 0xF4, 0x51, 0x40,
        0xCB, 0x52, 0x9A, 0x1B, 0x23, 0x4D, 0xC6, 0xE5, 0xCD, 0x79, 0xF7, 0x90, 0x6D, 0xCD, 0x96, 0x2B,
        0xDE, 0x6B, 0x30, 0xCF, 0x87, 0x95, 0x6E, 0xF9, 0x2E, 0x41, 0x72, 0x8C, 0xBE, 0xE5, 0x3D, 0x4A,
        0x0D, 0x01, 0xFD, 0xA8, 0x82, 0x98, 0x34, 0xF7, 0x8B, 0x54, 0xFF, 0x7C, 0xA9, 0x17, 0xE2, 0x2E,
        0xE1, 0x67, 0x40, 0x8C, 0x89, 0xDF, 0x2E, 0xCA, 0xA7, 0xEF, 0xF7, 0x80, 0x74, 0xF1, 0x5A, 0x6D
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xCD, 0x2D, 0xCD, 0x2D, 0x22, 0x2D, 0x22, 0xDE, 0x22, 0xDE, 0x3C, 0xDE, 0x3C, 0xBA, 0x3C, 0xBA,
        0x0F, 0x9B, 0xCC, 0xF1, 0xCC, 0x3D, 0xDC, 0x3D, 0x65, 0x09, 0x65, 0x77, 0x19, 0x77, 0xC3, 0xE7,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x99, 0x2D, 0x99, 0x70, 0x22, 0x70, 0x92, 0xDE, 0x92, 0x55, 0x3C, 0x55, 0xFF, 0xBA, 0xFF, 0x10
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_L_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_L_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_L_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_L_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_L_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_96_L_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_A_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
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

    const std::uint8_t aMaskBuffer[128] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aMaskJumpBuffer[128] = {
        0x54, 0xF7, 0xFC, 0xC1, 0xDA, 0xD7, 0xE7, 0xBB, 0x4A, 0x8D, 0xDC, 0x91, 0x51, 0x68, 0x0A, 0x3B,
        0x4F, 0x45, 0x6C, 0xA4, 0xAA, 0xA8, 0x96, 0x18, 0x23, 0xF8, 0x76, 0x0F, 0x14, 0x2F, 0x6A, 0xCC,
        0x3E, 0x83, 0x21, 0xC9, 0x28, 0x15, 0x88, 0x9D, 0xE5, 0x01, 0xA6, 0x18, 0xF9, 0x4B, 0x20, 0x49,
        0x37, 0x65, 0x6D, 0xA9, 0x1E, 0xD9, 0x16, 0x3C, 0xF4, 0x1C, 0xE7, 0x8F, 0x80, 0x15, 0x03, 0xA7,
        0xB7, 0x63, 0xA8, 0xA2, 0x50, 0x97, 0xC8, 0x15, 0x08, 0x8E, 0xAA, 0x72, 0xF4, 0xEF, 0x43, 0x7C,
        0x18, 0x4C, 0xA2, 0x22, 0xC6, 0x53, 0xE2, 0x91, 0x62, 0x7D, 0xAE, 0xFB, 0xDF, 0xBA, 0xA2, 0x95,
        0x61, 0x0D, 0x21, 0xD7, 0x08, 0x88, 0xCE, 0xC9, 0xA0, 0x9E, 0x61, 0x20, 0xB1, 0x28, 0xA6, 0xC6,
        0x43, 0xB5, 0x89, 0x51, 0xC7, 0x02, 0x59, 0x3B, 0x32, 0xC8, 0x12, 0x29, 0x20, 0xB7, 0x6B, 0x3F
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_128_A_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_A_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_A_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_A_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_A_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_A_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_B_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 100.00%

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

    const std::uint8_t aMaskBuffer[128] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskJumpBuffer[128] = {
        0x1E, 0x5B, 0x79, 0x38, 0xF6, 0xAE, 0xDF, 0x98, 0x21, 0xA1, 0x99, 0x9F, 0xE1, 0xC3, 0x0C, 0x5E,
        0xDD, 0xE2, 0x2E, 0xD0, 0x90, 0x1F, 0x36, 0x34, 0x53, 0x1F, 0x4B, 0xBA, 0xD0, 0x68, 0x8E, 0x8B,
        0xC5, 0xFD, 0x4F, 0x09, 0x76, 0xD7, 0xEE, 0xFF, 0xE0, 0x24, 0x80, 0x82, 0x7E, 0xE0, 0x1F, 0x73,
        0xB0, 0x37, 0xF1, 0x73, 0x76, 0x69, 0x49, 0x76, 0xC5, 0x80, 0xCE, 0xD8, 0x51, 0xA4, 0xD1, 0x0F,
        0x57, 0xFB, 0x6A, 0x60, 0x66, 0x59, 0x2B, 0x1E, 0xCB, 0x71, 0x95, 0xCF, 0x18, 0xB6, 0x96, 0x74,
        0xBF, 0xC3, 0xB2, 0x4E, 0xF2, 0x0C, 0x8A, 0x59, 0x4E, 0x10, 0x62, 0x8C, 0x8E, 0x24, 0x66, 0x4C,
        0x2F, 0x31, 0xE2, 0xD6, 0x65, 0xFF, 0xC2, 0x56, 0x99, 0x6E, 0x6E, 0x0F, 0xB4, 0x9A, 0x53, 0x20,
        0xD3, 0xAC, 0x32, 0x53, 0x4F, 0x57, 0xC7, 0x43, 0x97, 0xB5, 0x0C, 0x64, 0x96, 0xB0, 0xDD, 0x80
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_128_B_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_B_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_B_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_B_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_B_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_B_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_C_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit2 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit3 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit4 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit5 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit6 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
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

    const std::uint8_t aMaskBuffer[128] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskJumpBuffer[128] = {
        0x9F, 0x2F, 0x55, 0xEF, 0xD6, 0xBA, 0xFD, 0xF6, 0x6C, 0xBC, 0x6E, 0xCA, 0xCD, 0xF2, 0xEF, 0x09,
        0x6E, 0x31, 0x27, 0xD5, 0x5B, 0x44, 0x58, 0x44, 0x6A, 0x86, 0xA1, 0x4F, 0xAA, 0x3B, 0x47, 0x1A,
        0xCB, 0x73, 0x7C, 0x27, 0x67, 0xBE, 0x8E, 0xB2, 0x09, 0xA4, 0xEE, 0x87, 0x34, 0x07, 0xBB, 0xDF,
        0xD2, 0xFD, 0x13, 0xF6, 0xAB, 0xE0, 0xEF, 0xE3, 0x55, 0x51, 0xC7, 0x28, 0x6B, 0xE2, 0xDE, 0x77,
        0xFF, 0x9F, 0x49, 0xE8, 0xA7, 0x50, 0x8A, 0x14, 0xBF, 0x83, 0xC9, 0xA4, 0xE5, 0xB0, 0x1E, 0xEC,
        0x8A, 0x54, 0x8C, 0x1E, 0x82, 0x95, 0x14, 0x48, 0x18, 0xDA, 0x72, 0x5A, 0x8C, 0x18, 0x96, 0x99,
        0x77, 0x26, 0x0E, 0x20, 0x0B, 0x62, 0x49, 0x4C, 0x60, 0xAF, 0x8F, 0xA6, 0xEC, 0x99, 0x90, 0x7A,
        0x67, 0xAD, 0x10, 0x7C, 0xD5, 0x48, 0xCA, 0x92, 0xA7, 0x8A, 0x09, 0x6A, 0x50, 0xA7, 0x1B, 0x52
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_128_C_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_C_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_C_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_C_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_C_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_C_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_D_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit2 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit3 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit5 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit6 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

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

    const std::uint8_t aMaskBuffer[128] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskJumpBuffer[128] = {
        0xFF, 0xB5, 0x02, 0x44, 0x98, 0x6E, 0x2D, 0x78, 0x4D, 0xBF, 0x5D, 0x82, 0x43, 0x49, 0x21, 0x5C,
        0x07, 0xDD, 0xFD, 0x31, 0xE4, 0x0F, 0xC1, 0x07, 0x36, 0x27, 0x9D, 0xFA, 0xAA, 0x9A, 0xAF, 0xB7,
        0xB8, 0xC9, 0xE8, 0xEE, 0xC5, 0x42, 0x90, 0xD5, 0xB6, 0xE3, 0xC2, 0x5C, 0xB9, 0x36, 0x08, 0x8F,
        0x30, 0xB0, 0x6C, 0x1F, 0xA5, 0xD6, 0x6F, 0xF7, 0x3E, 0x46, 0x1C, 0xE4, 0x9D, 0x0C, 0x11, 0x91,
        0x4D, 0x3E, 0x15, 0x4D, 0xFD, 0xFD, 0x20, 0x95, 0xA8, 0x1E, 0x7F, 0x30, 0xFA, 0x64, 0x67, 0xB3,
        0x91, 0x2A, 0xFC, 0xC6, 0x06, 0xA6, 0xB9, 0xA1, 0xBB, 0x7D, 0x85, 0x3D, 0x1D, 0x3B, 0x47, 0xF8,
        0x54, 0x9E, 0xF8, 0x84, 0x0A, 0xED, 0xFB, 0xFB, 0x7D, 0xAE, 0xCA, 0x23, 0x06, 0x42, 0xA9, 0xE6,
        0xD8, 0x92, 0x37, 0x85, 0x03, 0x25, 0xCA, 0xBB, 0xA5, 0xF2, 0x90, 0x56, 0xA6, 0x58, 0x29, 0xE4
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_128_D_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_D_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_D_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_D_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_D_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_D_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_E_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit2 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit3 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit4 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit5 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit6 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit7 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // Avalanche: 50.00%

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

    const std::uint8_t aMaskBuffer[128] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskJumpBuffer[128] = {
        0x4A, 0x7A, 0x79, 0x26, 0xA5, 0xE6, 0x94, 0xC2, 0x6B, 0xC7, 0x1B, 0x07, 0x2B, 0x26, 0x63, 0x3A,
        0xFC, 0x7D, 0x81, 0xBE, 0x21, 0x27, 0x3D, 0x2C, 0x58, 0xA4, 0x84, 0x99, 0xEE, 0x79, 0x68, 0x19,
        0xBC, 0xBF, 0xCD, 0x62, 0x5E, 0x00, 0x08, 0xE0, 0xBA, 0xA3, 0x4E, 0x33, 0x7A, 0x59, 0x99, 0x32,
        0x90, 0x77, 0x0A, 0x95, 0xBA, 0xC1, 0x9A, 0x57, 0x58, 0x95, 0x4D, 0xA3, 0xA6, 0xBE, 0x22, 0x00,
        0xD2, 0x19, 0xB0, 0x58, 0xDF, 0x4F, 0x61, 0xE3, 0xBE, 0x16, 0x4E, 0x0F, 0xD0, 0x19, 0xB9, 0x0B,
        0x14, 0x42, 0xAB, 0xD9, 0x18, 0x30, 0xD9, 0x4F, 0x62, 0xE5, 0x5F, 0x8A, 0x9A, 0x5D, 0xFE, 0xFB,
        0x4F, 0xD8, 0x1F, 0x4A, 0x90, 0xE7, 0x6F, 0xE6, 0xAF, 0x77, 0x30, 0x8A, 0xCB, 0xD4, 0x43, 0x15,
        0x9D, 0xFB, 0x03, 0x9C, 0xC0, 0x52, 0xE4, 0x14, 0x6D, 0x36, 0xA9, 0x37, 0xC2, 0x05, 0xD6, 0x67
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_128_E_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_E_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_E_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_E_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_E_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_E_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_F_PasswordJumpSubtractCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit2 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit3 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit5 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit6 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

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

    const std::uint8_t aMaskBuffer[128] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[128] = {
        0xE5, 0xCF, 0xF2, 0x60, 0x6F, 0x84, 0x3C, 0x26, 0x68, 0x30, 0xD6, 0x37, 0x5F, 0xC2, 0x60, 0x0D,
        0x65, 0x6A, 0xF2, 0xDA, 0x33, 0x47, 0x65, 0x88, 0xFF, 0x88, 0xEB, 0x8F, 0x10, 0x66, 0xA7, 0xAD,
        0x1A, 0x44, 0xEE, 0xBB, 0x4C, 0x44, 0x57, 0xD1, 0xB2, 0x0E, 0xA8, 0x1A, 0x24, 0x5E, 0x8D, 0xFC,
        0x0B, 0xC9, 0xE7, 0x91, 0xCB, 0x05, 0x1A, 0x0F, 0x79, 0x80, 0x4F, 0x6E, 0x1B, 0x9D, 0x16, 0x1F,
        0x5F, 0x6F, 0x4E, 0x7E, 0x0B, 0xFA, 0x04, 0x2F, 0xD6, 0x93, 0xD4, 0x85, 0xB5, 0x80, 0x74, 0xA2,
        0xC6, 0x9E, 0xD6, 0x45, 0x88, 0x4C, 0x00, 0x24, 0x66, 0x5B, 0x51, 0x15, 0x12, 0xA9, 0x10, 0x8F,
        0x3B, 0x67, 0xCD, 0x67, 0x51, 0xEB, 0x5D, 0xA4, 0xDF, 0xE6, 0xB2, 0x49, 0x8C, 0xE4, 0x4E, 0xB3,
        0xD4, 0x25, 0xEA, 0x41, 0x60, 0xCE, 0xB6, 0x8D, 0xF0, 0x91, 0xA6, 0xEA, 0x52, 0x70, 0xFF, 0x67
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_128_F_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_F_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_F_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_F_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_F_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_F_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_G_PasswordJumpSubtractCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101001  10101010  01101010  10011010  10100110  10101001  10101010  01101010  10011010  10100110  10101001  10101010  01101010  10011010  10100110  10101001
    // bit2 10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001  01101010  01011010  10010110
    // bit3 10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001  01011010  01010110  10010101
    // bit4 01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110
    // bit5 01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101
    // bit6 01011010  10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001  01101010  01011010
    // bit7 01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110  01011001
    //
    // After Cipher:
    // bit0 00000000  00000000  10011010  10100110  10101001  10101010  01010110  10010101  00000000  00000000  01010110  01010101  10010101  01100101  01101001  01011010
    // bit1 00000000  00000000  10101010  10101010  10101010  10101010  01010110  01010101  00000000  00000000  01010101  01010101  01010101  01010101  01100101  01011001
    // bit2 00000000  00000000  10011001  10100110  01101001  10011010  10101001  10101010  00000000  00000000  10010110  01100101  10011001  01100110  10011010  10100110
    // bit3 00000000  00000000  01101010  10011010  10100110  10101001  10010101  10100101  00000000  00000000  01011001  01010110  01010101  10010101  01011010  01010110
    // bit4 00000000  00000000  01010110  01010101  10010101  01100101  01100101  10011001  00000000  00000000  01101010  10011010  10100110  10101001  01011001  10010110
    // bit5 00000000  00000000  10100111  10101001  11101010  01111010  01100111  01011001  00000000  00000000  11010101  10110101  01101101  01011011  01110101  10011101
    // bit6 00000000  00000000  10010100  10100101  00101001  01001010  10011100  11100111  00000000  00000000  00010110  10000101  10100001  01101000  11001110  01110011
    // bit7 00000000  00000000  11111100  11111111  00111111  11001111  11110000  00111100  00000000  00000000  00111111  11001111  11110011  11111100  00000011  11000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  ..XX....  ....XX..  ......XX  ........  XXXXXX..  ..XXXXXX  X.X.X.X.  X.X.X.X.  XXXXXX..  XXXXXXXX  ..XXXXXX  XX..XXXX  XX....XX  XXXX....
    // bit1 X.X.X..X  X.X.X.X.  XX......  ..XX....  ....XX..  ......XX  XXXXXX..  ..XXXXXX  X..XX.X.  X.X..XX.  XXXXXX..  XXXXXXXX  ..XXXXXX  XX..XXXX  XX....XX  XXXX....
    // bit2 X..X.XX.  X.X..X.X  ..XX....  XX..XX..  ..XX..XX  ....XX..  ....XX..  ......XX  .XX.X.X.  .X.XX.X.  ........  XX......  ..XX....  ....XX..  XX......  ..XX....
    // bit3 X..X.X.X  X.X..X.X  ......XX  XX......  XXXX....  ..XXXX..  ..XX....  XX..XX..  .X.XX.X.  .X.X.XX.  XX..XX..  XXXX..XX  ..XXXX..  XX..XXXX  ....XX..  XX....XX
    // bit4 .XX..XX.  X..XX..X  XXXX....  ..XXXX..  ....XXXX  ......XX  XXXXXX..  ..XXXXXX  .XX.X..X  X..XX.X.  ....XX..  ......XX  ........  XX......  XX....XX  XXXX....
    // bit5 .XX..X.X  X..XX..X  XX.....X  XXXX....  .XXXXX..  ...XXXXX  XXXXXXX.  ..XXXXXX  .X.XX..X  X..X.XX.  X.XX....  ..X.XX..  ....X.XX  ......X.  XXX...XX  XXXXX...
    // bit6 .X.XX.X.  X..X.XX.  ..XX...X  ....XX..  .X....XX  ...X....  ....X.X.  .X....X.  X.X.X..X  .XX.X.X.  .X..XX..  ...X..XX  .....X..  XX.....X  X.X..X..  ..X.X..X
    // bit7 .X.XX..X  X..X.XX.  X..XX..X  .XX..XX.  .X.XX..X  X..X.XX.  .XX..XX.  .X.XX..X  X..XX..X  .XX..XX.  .XX..XX.  .X.XX..X  X..X.XX.  .XX..X.X  .XX..X.X  X..XX..X
    // Avalanche: 46.00%

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

    const std::uint8_t aMaskBuffer[128] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F,
        0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55,
        0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33,
        0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00,
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F,
        0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[128] = {
        0x84, 0xFC, 0x97, 0x75, 0x66, 0x99, 0x1E, 0xB6, 0x71, 0xDD, 0xDB, 0x4F, 0xE0, 0x55, 0x99, 0x63,
        0x0D, 0xE4, 0x28, 0x7A, 0xFC, 0x8D, 0x61, 0x71, 0xCB, 0xF7, 0xCE, 0xD0, 0x81, 0xD1, 0xCF, 0x88,
        0xDA, 0xBD, 0x8F, 0x84, 0x05, 0x12, 0x5F, 0x24, 0x50, 0x35, 0x65, 0xA0, 0x9B, 0x1C, 0x63, 0x95,
        0xE5, 0xE0, 0x3D, 0x8E, 0x2A, 0x42, 0x22, 0x74, 0x90, 0x52, 0x97, 0x25, 0xCA, 0x27, 0xF8, 0x2F,
        0xF5, 0xC8, 0x05, 0x66, 0xC7, 0x6D, 0x83, 0x78, 0x8D, 0x96, 0x80, 0x21, 0x82, 0x7A, 0xA1, 0x1B,
        0x2E, 0x72, 0x7A, 0x19, 0xBB, 0x9A, 0x42, 0xC0, 0x31, 0x38, 0xB1, 0xB6, 0xB1, 0x56, 0x67, 0xAC,
        0xBE, 0x02, 0x25, 0xA2, 0x22, 0x7C, 0x41, 0xA4, 0x87, 0xEE, 0xFA, 0xBD, 0xFA, 0x14, 0x21, 0xF0,
        0xF9, 0xDB, 0xE6, 0x17, 0xAE, 0xC9, 0xF3, 0x1F, 0x8D, 0x76, 0xAC, 0x9E, 0x65, 0xDC, 0x40, 0xA9
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xE7, 0x19, 0x55, 0xAB, 0xF1, 0x0F, 0xDC, 0x24, 0xF7, 0x09, 0xE7, 0x19, 0x55, 0xAB, 0xF1, 0x0F,
        0xDC, 0x24, 0xF7, 0x09, 0xE7, 0x19, 0x55, 0xAB, 0xF1, 0x0F, 0xDC, 0x24, 0xF7, 0x09, 0xE7, 0x19,
        0x33, 0xCD, 0x2D, 0xD3, 0x22, 0xDE, 0xC4, 0x3C, 0xBA, 0x46, 0x33, 0xCD, 0x2D, 0xD3, 0x22, 0xDE,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x24, 0xDC, 0x09, 0xF7, 0x19, 0xE7, 0xAB, 0x55, 0x0F, 0xF1, 0x24, 0xDC, 0x09, 0xF7, 0x19, 0xE7,
        0xAB, 0x55, 0x0F, 0xF1, 0x24, 0xDC, 0x09, 0xF7, 0x19, 0xE7, 0xAB, 0x55, 0x0F, 0xF1, 0x24, 0xDC,
        0x22, 0xDE, 0xC4, 0x3C, 0xBA, 0x46, 0x33, 0xCD, 0x2D, 0xD3, 0x22, 0xDE, 0xC4, 0x3C, 0xBA, 0x46
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_G_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_G_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_G_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_G_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_G_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_G_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_H_PasswordJumpSubtractCipher {

    // Before Cipher:
    // bit0 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit1 01100101  01011001  01010110  01010101  10010101  01100101  01011001  01010110  01010101  10010101  01100101  01011001  01010110  01010101  10010101  01100101
    // bit2 01011010  01010110  10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001  01011010
    // bit3 01101010  01011010  10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001  01101010
    // bit4 01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110  01011001
    // bit5 01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110  01101001
    // bit6 01010110  10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001  01011010  01010110
    // bit7 01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110
    //
    // After Cipher:
    // bit0 00000000  00000000  10101001  01101010  00000000  00000000  00000000  00000000  01011010  01010110  10010101  01100101  10101001  01101010  00000000  00000000
    // bit1 00000000  00000000  10101010  01101010  00000000  00000000  00000000  00000000  01010110  01010101  01010101  01010101  10101010  01101010  00000000  00000000
    // bit2 00000000  00000000  01010101  10010101  00000000  00000000  00000000  00000000  10101001  10101010  10010110  01100101  01010101  10010101  00000000  00000000
    // bit3 00000000  00000000  10100101  10101001  00000000  00000000  00000000  00000000  01101001  01011010  01100101  01011001  10100101  10101001  00000000  00000000
    // bit4 00000000  00000000  10011001  10100110  00000000  00000000  00000000  00000000  10011001  01100110  10101001  10101010  10011001  10100110  00000000  00000000
    // bit5 00000000  00000000  10011010  11100110  00000000  00000000  00000000  00000000  10010111  01100101  01010111  10010101  10011010  11100110  00000000  00000000
    // bit6 00000000  00000000  11100111  00111001  00000000  00000000  00000000  00000000  01101100  11011011  10010100  10100101  11100111  00111001  00000000  00000000
    // bit7 00000000  00000000  00111100  00001111  00000000  00000000  00000000  00000000  11110000  00111100  11111100  11111111  00111100  00001111  00000000  00000000
    //
    // Avalanche:
    // bit0 .X.X.X.X  .X.X.X.X  XXXXXX..  ..XXXXXX  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  ....XXXX  ......XX  XX......  ..XX....  XXXXXX..  ..XXXXXX  .X.X.X.X  .X.X.X.X
    // bit1 .XX..X.X  .X.XX..X  XXXXXX..  ..XXXXXX  X..X.X.X  .XX..X.X  .X.XX..X  .X.X.XX.  ......XX  XX......  ..XX....  ....XX..  XXXXXX..  ..XXXXXX  X..X.X.X  .XX..X.X
    // bit2 .X.XX.X.  .X.X.XX.  XX......  ..XX....  .XX.X..X  .X.XX.X.  .X.X.XX.  X..X.X.X  ....XX..  XX....XX  XX..XX..  ..XX..XX  XX......  ..XX....  .XX.X..X  .X.XX.X.
    // bit3 .XX.X.X.  .X.XX.X.  ..XX..XX  ....XX..  X.X.X..X  .XX.X.X.  .X.XX.X.  X..X.XX.  XX..XX..  XXXX..XX  ....XXXX  ......XX  ..XX..XX  ....XX..  X.X.X..X  .XX.X.X.
    // bit4 .X.XX..X  X..X.XX.  XXXXXX..  ..XXXXXX  .XX..XX.  .X.XX..X  X..X.XX.  .XX..X.X  ........  ........  XXXX....  ..XXXX..  XXXXXX..  ..XXXXXX  .XX..XX.  .X.XX..X
    // bit5 .XX.X..X  X..XX.X.  XXXXXX..  .XXXXXXX  X.X..XX.  .XX.X..X  X..XX.X.  .XX..XX.  ....XXX.  XX....XX  ..XXXXX.  ....XXXX  XXXXXX..  .XXXXXXX  X.X..XX.  .XX.X..X
    // bit6 .X.X.XX.  X..X.X.X  .X....X.  .X.X....  .X.XX.X.  .X.X.XX.  X..X.X.X  X.X..X.X  .....X.X  X......X  XX....X.  ..XX....  .X....X.  .X.X....  .X.XX.X.  .X.X.XX.
    // bit7 .XX..XX.  X..XX..X  X..XX.X.  .XX..XX.  X..XX.X.  .XX..XX.  X..XX..X  X.X..XX.  X..XX..X  X.X..XX.  X..XX.X.  .XX..XX.  X..XX.X.  .XX..XX.  X..XX.X.  .XX..XX.
    // Avalanche: 48.34%

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

    const std::uint8_t aMaskBuffer[128] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF,
        0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC,
        0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA,
        0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0,
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF,
        0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC
    };

    const std::uint8_t aMaskJumpBuffer[128] = {
        0x32, 0xC8, 0xD9, 0xF8, 0x4F, 0xF0, 0x60, 0x7C, 0xAB, 0xD8, 0x05, 0x52, 0xEB, 0x3A, 0x16, 0x3B,
        0x81, 0x32, 0x8E, 0xA8, 0x19, 0x95, 0x00, 0x41, 0x81, 0xA0, 0xC6, 0xB9, 0x9A, 0xA3, 0x1E, 0x5E,
        0x41, 0x71, 0xD9, 0x95, 0x97, 0xB6, 0x6D, 0x6B, 0x4C, 0x1D, 0x94, 0x9D, 0x18, 0xDC, 0x0D, 0x24,
        0xCB, 0x3F, 0x32, 0x51, 0x52, 0x05, 0x41, 0x9C, 0x96, 0x19, 0x56, 0xAA, 0x7D, 0x03, 0xD6, 0xFB,
        0xBA, 0xE9, 0xFE, 0xC2, 0xEE, 0x0A, 0xE4, 0xC8, 0x8E, 0x67, 0xF5, 0xC4, 0x91, 0xEA, 0x1A, 0x72,
        0xE2, 0x5D, 0x71, 0x17, 0x67, 0xFF, 0x36, 0x99, 0xD6, 0xA8, 0xA1, 0x89, 0xCE, 0x5F, 0x51, 0xD9,
        0x16, 0xAB, 0xE6, 0xBB, 0x2C, 0x79, 0x96, 0xA3, 0x81, 0xE1, 0x0A, 0x82, 0x6E, 0x27, 0x02, 0xED,
        0xF3, 0x6A, 0x89, 0x8C, 0x00, 0xD4, 0x61, 0xAA, 0xBC, 0xAB, 0xBD, 0xF2, 0x10, 0xEE, 0x5F, 0x04
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xDE, 0x22, 0xD3, 0x2D, 0xCD, 0x33, 0x46, 0xBA, 0x3C, 0xC4, 0xDE, 0x22, 0xD3, 0x2D, 0xCD, 0x33,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x2D, 0xD3, 0x33, 0xCD, 0xBA, 0x46, 0xC4, 0x3C, 0x22, 0xDE, 0x2D, 0xD3, 0x33, 0xCD, 0xBA, 0x46,
        0xAB, 0x55, 0x19, 0xE7, 0x09, 0xF7, 0x24, 0xDC, 0x0F, 0xF1, 0xAB, 0x55, 0x19, 0xE7, 0x09, 0xF7,
        0xDE, 0x22, 0xD3, 0x2D, 0xCD, 0x33, 0x46, 0xBA, 0x3C, 0xC4, 0xDE, 0x22, 0xD3, 0x2D, 0xCD, 0x33,
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
                                                    "test_fixed_128_H_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_H_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_H_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_H_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_H_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_H_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_I_PasswordJumpSubtractCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10001010  11100010  10111000  10101110  00101011  10001010  11100010  10111000  10101110  00101011  10001010  11100010  10111000  10101110  00101011  10001010
    // bit2 11100110  00111001  10001110  01100011  10011000  11100110  00111001  10001110  01100011  10011000  11100110  00111001  10001110  01100011  10011000  11100110
    // bit3 11000110  01110001  10011100  01100111  00011001  11000110  01110001  10011100  01100111  00011001  11000110  01110001  10011100  01100111  00011001  11000110
    // bit4 00101111  00001011  11000010  11110000  10111100  00101111  00001011  11000010  11110000  10111100  00101111  00001011  11000010  11110000  10111100  00101111
    // bit5 00001111  01000011  11010000  11110100  00111101  00001111  01000011  11010000  11110100  00111101  00001111  01000011  11010000  11110100  00111101  00001111
    // bit6 01100011  10011000  11100110  00111001  10001110  01100011  10011000  11100110  00111001  10001110  01100011  10011000  11100110  00111001  10001110  01100011
    // bit7 01000011  11010000  11110100  00111101  00001111  01000011  11010000  11110100  00111101  00001111  01000011  11010000  11110100  00111101  00001111  01000011
    //
    // After Cipher:
    // bit0 00000000  00000000  00000000  00000000  11100110  00111001  10101110  00101011  01010001  11010100  01110001  10011100  01100011  10011000  11100110  00111001
    // bit1 00000000  00000000  00000000  00000000  11100010  10111000  10101010  10101010  01010101  01010101  01010001  11010100  00101011  10001010  11100010  10111000
    // bit2 00000000  00000000  00000000  00000000  00011101  01000111  10111100  00101111  01000011  11010000  10101110  00101011  11010100  01110101  00011101  01000111
    // bit3 00000000  00000000  00000000  00000000  10001110  01100011  11100010  10111000  00011101  01000111  01100111  00011001  11100110  00111001  10001110  01100011
    // bit4 00000000  00000000  00000000  00000000  10111100  00101111  01000111  01010001  10111000  10101110  11110100  00111101  11000010  11110000  10111100  00101111
    // bit5 00000000  00000000  00000000  00000000  11111000  10111110  10011010  11100110  01110111  00011101  11010100  11110101  10001011  11100010  11111000  10111110
    // bit6 00000000  00000000  00000000  00000000  10000111  11100001  10001100  01100011  01100001  10011000  01101011  01011010  01111110  00011111  10000111  11100001
    // bit7 00000000  00000000  00000000  00000000  00110010  01001100  11101101  11111011  11101101  11111011  10010011  00100100  00100100  11001001  00110010  01001100
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  .X..XX..  X..X..XX  .....X..  X......X  XXXXX.XX  .XXXXXX.  XX.XX.XX  ..XX.XX.  XX..X..X  ..XX..X.  .X..XX..  X..X..XX
    // bit1 X...X.X.  XXX...X.  X.XXX...  X.X.XXX.  XX..X..X  ..XX..X.  .X..X...  ...X..X.  XXXXX.XX  .XXXXXX.  XX.XX.XX  ..XX.XX.  X..X..XX  ..X..X..  XX..X..X  ..XX..X.
    // bit2 XXX..XX.  ..XXX..X  X...XXX.  .XX...XX  X....X.X  X.X....X  X....X.X  X.X....X  ..X.....  .X..X...  .X..X...  ...X..X.  .X.XX.X.  ...X.XX.  X....X.X  X.X....X
    // bit3 XX...XX.  .XXX...X  X..XXX..  .XX..XXX  X..X.XXX  X.X..X.X  X..X..XX  ..X..X..  .XXXX.X.  .X.XXXX.  X.X....X  .XX.X...  .XXXX.X.  .X.XXXX.  X..X.XXX  X.X..X.X
    // bit4 ..X.XXXX  ....X.XX  XX....X.  XXXX....  ........  ........  .X..XX..  X..X..XX  .X..X...  ...X..X.  XX.XX.XX  ..XX.XX.  ........  ........  ........  ........
    // bit5 ....XXXX  .X....XX  XX.X....  XXXX.X..  XX...X.X  X.XX...X  XX.XX..X  ..XX.XX.  X.....XX  ..X.....  XX.XX.XX  X.XX.XX.  .X.XX.XX  ...X.XX.  XX...X.X  X.XX...X
    // bit6 .XX...XX  X..XX...  XXX..XX.  ..XXX..X  ....X..X  X.....X.  ...X.X..  X....X.X  .X.XX...  ...X.XX.  ....X...  XX....X.  X..XX...  ..X..XX.  ....X..X  X.....X.
    // bit7 .X....XX  XX.X....  XXXX.X..  ..XXXX.X  ..XXXX.X  ....XXXX  ..XXXX.X  ....XXXX  XX.X....  XXXX.X..  XX.X....  XXXX.X..  XX.X....  XXXX.X..  ..XXXX.X  ....XXXX
    // Avalanche: 44.24%

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

    const std::uint8_t aMaskBuffer[128] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33,
        0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F,
        0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00,
        0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55,
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33,
        0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F
    };

    const std::uint8_t aMaskJumpBuffer[128] = {
        0x96, 0xBE, 0x08, 0x47, 0x28, 0x10, 0xE9, 0x56, 0x21, 0x94, 0x1B, 0x10, 0x91, 0x14, 0x17, 0x1D,
        0xD2, 0x62, 0x77, 0x3E, 0xD8, 0xD6, 0x93, 0xF5, 0x80, 0xD8, 0x21, 0x60, 0xB2, 0x28, 0xE6, 0x1E,
        0x43, 0x48, 0x81, 0x02, 0x9A, 0xCE, 0xEE, 0x87, 0x1F, 0x61, 0xBD, 0x38, 0x18, 0x37, 0x08, 0xB2,
        0xDE, 0x16, 0x2E, 0xA2, 0xC0, 0xC4, 0x9B, 0xDF, 0xE9, 0xBA, 0xC9, 0x14, 0xE7, 0x0B, 0xB0, 0xD6,
        0x62, 0x2F, 0xD4, 0xF7, 0xB7, 0x7A, 0x3D, 0x2A, 0xB6, 0xB9, 0x1B, 0x45, 0xC6, 0xA5, 0xBB, 0x26,
        0xCA, 0x18, 0xF6, 0xAD, 0x04, 0xA7, 0xD5, 0x62, 0xE0, 0x84, 0x97, 0x4B, 0xAC, 0x42, 0x8C, 0x1A,
        0x9E, 0x8C, 0x17, 0x21, 0xF3, 0x53, 0xBD, 0xDB, 0x8B, 0x34, 0xB7, 0x95, 0xF3, 0x91, 0x89, 0x17,
        0x84, 0xDF, 0x2A, 0x6E, 0x22, 0x56, 0x96, 0x0C, 0x11, 0x74, 0x2F, 0xC2, 0xE8, 0x51, 0xA9, 0xCE
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xDE, 0xC4, 0xCD, 0x2D, 0x3C, 0xBA, 0xD3, 0x22, 0x46, 0x33, 0xDE, 0xC4, 0xCD, 0x2D, 0x3C, 0xBA,
        0xF7, 0x19, 0xF1, 0x24, 0xE7, 0xAB, 0xDC, 0x09, 0x55, 0x0F, 0xF7, 0x19, 0xF1, 0x24, 0xE7, 0xAB,
        0x09, 0xE7, 0x0F, 0xDC, 0x19, 0x55, 0x24, 0xF7, 0xAB, 0xF1, 0x09, 0xE7, 0x0F, 0xDC, 0x19, 0x55,
        0x2D, 0xDE, 0xBA, 0xCD, 0x22, 0x3C, 0x33, 0xD3, 0xC4, 0x46, 0x2D, 0xDE, 0xBA, 0xCD, 0x22, 0x3C,
        0x3C, 0xBA, 0xD3, 0x22, 0x46, 0x33, 0xDE, 0xC4, 0xCD, 0x2D, 0x3C, 0xBA, 0xD3, 0x22, 0x46, 0x33,
        0xDE, 0xC4, 0xCD, 0x2D, 0x3C, 0xBA, 0xD3, 0x22, 0x46, 0x33, 0xDE, 0xC4, 0xCD, 0x2D, 0x3C, 0xBA
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_I_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_I_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_I_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_I_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_I_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_I_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_J_PasswordJumpSubtractCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    //
    // After Cipher:
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

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

    const std::uint8_t aMaskBuffer[128] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[128] = {
        0xE9, 0x11, 0x8E, 0x66, 0xAC, 0x08, 0x88, 0x46, 0x07, 0x66, 0xC3, 0x07, 0x32, 0xF3, 0x2C, 0xC3,
        0x99, 0x0E, 0xF5, 0x38, 0xEA, 0x4D, 0x62, 0x15, 0xAD, 0xE5, 0xE5, 0x07, 0x4C, 0xEF, 0x45, 0xE8,
        0xBF, 0x4A, 0x4C, 0x31, 0xBF, 0x14, 0x72, 0x84, 0x11, 0x20, 0x7E, 0x4B, 0xDD, 0x62, 0xA4, 0x78,
        0x6A, 0xB6, 0x05, 0x57, 0x57, 0x11, 0xDF, 0x17, 0xAE, 0x97, 0xD0, 0xAB, 0x88, 0x99, 0x34, 0x26,
        0xFA, 0x91, 0x26, 0x24, 0x6B, 0x02, 0x79, 0xC1, 0x3B, 0x53, 0x8C, 0xF2, 0xC6, 0x7D, 0x6D, 0x85,
        0xAD, 0x57, 0x05, 0x29, 0xBF, 0xE7, 0xA8, 0xD6, 0x78, 0x84, 0xA2, 0xAE, 0xFD, 0xBD, 0x34, 0x5F,
        0xA9, 0xE4, 0xAA, 0x95, 0xFD, 0x64, 0x69, 0xDB, 0xA3, 0x02, 0x9E, 0x9A, 0x10, 0x9C, 0x8E, 0xDB,
        0x37, 0x8A, 0xB0, 0x40, 0x30, 0xE0, 0x63, 0xA6, 0x88, 0xF3, 0x89, 0x9F, 0x91, 0xAA, 0x65, 0xA5
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

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
                                                    "test_fixed_128_J_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_J_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_J_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_J_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_J_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_J_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_K_PasswordJumpSubtractCipher {

    // Before Cipher:
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  01010101  10101010  10101010  10101010  10101010  01010101  10101010  10101010  10101010  10101010  01010101  10101010  10101010
    // bit2 10101010  01010101  01010101  10101010  10101010  10101010  01010101  01010101  10101010  10101010  10101010  01010101  01010101  10101010  10101010  10101010
    // bit3 10101010  01010101  01010101  01010101  10101010  10101010  01010101  01010101  01010101  10101010  10101010  01010101  01010101  01010101  10101010  10101010
    // bit4 01010101  10101010  01010101  10101010  10101010  01010101  10101010  01010101  10101010  10101010  01010101  10101010  01010101  10101010  10101010  01010101
    // bit5 01010101  10101010  01010101  01010101  10101010  01010101  10101010  01010101  01010101  10101010  01010101  10101010  01010101  01010101  10101010  01010101
    // bit6 01010101  01010101  10101010  10101010  10101010  01010101  01010101  10101010  10101010  10101010  01010101  01010101  10101010  10101010  10101010  01010101
    // bit7 01010101  01010101  10101010  01010101  10101010  01010101  01010101  10101010  01010101  10101010  01010101  01010101  10101010  01010101  10101010  01010101
    //
    // After Cipher:
    // bit0 00000000  00000000  10101010  10101010  01010101  01010101  01010101  01010101  00000000  00000000  10101010  10101010  10101010  10101010  01010101  01010101
    // bit1 00000000  00000000  10101010  01010101  01010101  01010101  01010101  01010101  00000000  00000000  10101010  10101010  10101010  10101010  01010101  01010101
    // bit2 00000000  00000000  01010101  10101010  10101010  10101010  01010101  01010101  00000000  00000000  10101010  01010101  10101010  10101010  10101010  10101010
    // bit3 00000000  00000000  01010101  10101010  10101010  01010101  01010101  10101010  00000000  00000000  10101010  10101010  10101010  01010101  10101010  01010101
    // bit4 00000000  00000000  01010101  10101010  01010101  10101010  10101010  10101010  00000000  00000000  01010101  10101010  01010101  01010101  01010101  10101010
    // bit5 00000000  00000000  11111111  01010101  01010101  10101010  01010101  01010101  00000000  00000000  01010101  11111111  10101010  10101010  01010101  10101010
    // bit6 00000000  00000000  00000000  11111111  10101010  01010101  01010101  01010101  00000000  00000000  01010101  00000000  10101010  10101010  10101010  01010101
    // bit7 00000000  00000000  00000000  00000000  11111111  11111111  11111111  11111111  00000000  00000000  11111111  00000000  11111111  11111111  11111111  11111111
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  ........  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  ........  ........  XXXXXXXX  XXXXXXXX
    // bit1 X.X.X.X.  X.X.X.X.  ........  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  .X.X.X.X  X.X.X.X.  ........  ........  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 X.X.X.X.  .X.X.X.X  ........  ........  ........  ........  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  XXXXXXXX  ........  ........  ........
    // bit3 X.X.X.X.  .X.X.X.X  ........  XXXXXXXX  ........  XXXXXXXX  ........  XXXXXXXX  .X.X.X.X  X.X.X.X.  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX
    // bit4 .X.X.X.X  X.X.X.X.  ........  ........  XXXXXXXX  XXXXXXXX  ........  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit5 .X.X.X.X  X.X.X.X.  X.X.X.X.  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  .X.X.X.X  X.X.X.X.  ........  .X.X.X.X  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  ........  ........  ........  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  .X.X.X.X  ........  ........  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.  X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.  X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.
    // Avalanche: 45.70%

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

    const std::uint8_t aMaskBuffer[128] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskJumpBuffer[128] = {
        0xAA, 0xB1, 0xAE, 0x43, 0x13, 0x64, 0x68, 0xBA, 0x6F, 0x66, 0x28, 0x1D, 0xE1, 0x5F, 0xCB, 0x14,
        0x58, 0x87, 0x53, 0x8A, 0x64, 0x7A, 0xFC, 0x14, 0xE1, 0x47, 0xFD, 0x8B, 0x2D, 0x7A, 0xC7, 0x15,
        0xC9, 0x56, 0xD7, 0xED, 0x8B, 0x68, 0xF4, 0x37, 0x36, 0x90, 0x0D, 0xEF, 0xD0, 0x0F, 0xBA, 0xD9,
        0x1D, 0x0D, 0x33, 0x8F, 0xAE, 0x46, 0x87, 0xF8, 0x11, 0xB6, 0xAC, 0x39, 0x3E, 0xD0, 0xB5, 0xE4,
        0xC0, 0x6B, 0xAE, 0x05, 0x7A, 0x0E, 0xD0, 0x16, 0xB0, 0x36, 0xD4, 0x63, 0x01, 0xEC, 0xB0, 0x49,
        0xE9, 0x44, 0xC5, 0x36, 0x49, 0x6B, 0xBB, 0xD8, 0x69, 0x9E, 0x3E, 0xA2, 0x59, 0x99, 0x1E, 0xE7,
        0x57, 0x16, 0xB1, 0xD9, 0xA0, 0xB9, 0x87, 0x63, 0xBE, 0x49, 0xD7, 0x0A, 0xAE, 0x53, 0xA4, 0x73,
        0x3D, 0x97, 0x95, 0x86, 0x22, 0x5B, 0x64, 0x10, 0xC7, 0x1E, 0x8C, 0x44, 0x9D, 0x27, 0x6E, 0x55
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xC4, 0x3C, 0xC4, 0x3C, 0xC4, 0x3C, 0xC4, 0x3C, 0xBA, 0x46, 0xBA, 0x46, 0xBA, 0x46, 0xBA, 0x46,
        0x33, 0xCD, 0x33, 0xCD, 0x33, 0xCD, 0x33, 0xCD, 0x2D, 0xD3, 0x2D, 0xD3, 0x2D, 0xD3, 0x2D, 0xD3,
        0x09, 0xF7, 0x09, 0xF7, 0x09, 0xF7, 0x09, 0xF7, 0x19, 0xE7, 0x19, 0xE7, 0x19, 0xE7, 0x19, 0xE7,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xF1, 0x0F, 0xF1, 0x0F, 0xF1, 0x0F, 0xF1, 0x0F, 0xDC, 0x24, 0xDC, 0x24, 0xDC, 0x24, 0xDC, 0x24,
        0xF7, 0x09, 0xF7, 0x09, 0xF7, 0x09, 0xF7, 0x09, 0xE7, 0x19, 0xE7, 0x19, 0xE7, 0x19, 0xE7, 0x19,
        0x33, 0xCD, 0x33, 0xCD, 0x33, 0xCD, 0x33, 0xCD, 0x2D, 0xD3, 0x2D, 0xD3, 0x2D, 0xD3, 0x2D, 0xD3
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_K_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_K_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_K_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_K_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_K_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_K_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_L_PasswordJumpSubtractCipher {

    // Before Cipher:
    // bit0 10000101  11101000  01011110  10000101  11101000  01011110  10000101  11101000  01011110  10000101  11101000  01011110  10000101  11101000  01011110  10000101
    // bit1 10000101  01010101  01011110  10000000  10101000  01011110  10101111  11101000  01010101  01010101  11101000  00001010  10000101  11101010  11111110  10000101
    // bit2 10101010  10101000  01010101  01111111  11101000  00000001  01010101  11101010  10101010  10000101  01010111  11111110  10000000  00010101  01011110  10101010
    // bit3 10101010  00010101  01010101  01111010  10101000  00000001  01111111  11101010  10100001  01010101  01010111  10101010  10000000  00010111  11111110  10101010
    // bit4 01010000  10101000  00001010  10101111  11101010  11110101  01010101  01010101  00001010  10000000  10101010  11111110  10101111  01010101  01010101  01010000
    // bit5 01010000  00010101  00001010  10101010  10101010  11110101  01111111  01010101  00000001  01010000  10101010  10101010  10101111  01010111  11110101  01010000
    // bit6 01111111  11101000  00000001  01010101  11101010  10101010  10000101  01010111  11111110  10000000  00010101  01011110  10101010  10101000  01010101  01111111
    // bit7 01111111  01010101  00000001  01010000  10101010  10101010  10101111  01010111  11110101  01010000  00010101  00001010  10101010  10101010  11110101  01111111
    //
    // After Cipher:
    // bit0 00000000  00000000  01111010  00111000  00000000  00000000  10001011  01111010  11111110  10101010  11101000  01000011  00000101  10100010  00000001  01111010
    // bit1 00000000  00000000  01110001  01010101  00000000  00000000  11110001  01010111  11110101  01111010  11000101  11110101  01000101  00010100  10100001  01111010
    // bit2 00000000  00000000  01010101  11000010  00000000  00000000  00000000  10101111  00001010  10000101  01111111  10111110  00000000  10110100  00001010  10101010
    // bit3 00000000  00000000  10001011  01111111  00000000  00000000  00100000  00111010  10101010  10000000  01111000  11101000  01101000  10110110  10100001  01111111
    // bit4 00000000  00000000  00101110  00010010  00000000  00000000  01011111  01010000  10101010  10101111  10101010  11111110  00000101  00000000  01010101  01010101
    // bit5 00000000  00000000  00100100  00010111  00000000  00000000  01110101  11111111  11110101  01111111  10101111  01011101  01000101  10100000  11111111  11111010
    // bit6 00000000  00000000  00000000  10111000  00000000  00000000  10000100  00000010  10101011  11010000  00010101  01010110  01000000  00000010  01010100  00101010
    // bit7 00000000  00000000  01111110  00000101  00000000  00000000  10101110  00000111  00000000  00101111  10111111  10100000  00000000  00000000  11110100  00101111
    //
    // Avalanche:
    // bit0 X....X.X  XXX.X...  ..X..X..  X.XXXX.X  XXX.X...  .X.XXXX.  ....XXX.  X..X..X.  X.X.....  ..X.XXXX  ........  ...XXX.X  X.......  .X..X.X.  .X.XXXXX  XXXXXXXX
    // bit1 X....X.X  .X.X.X.X  ..X.XXXX  XX.X.X.X  X.X.X...  .X.XXXX.  .X.XXXX.  X.XXXXXX  X.X.....  ..X.XXXX  ..X.XX.X  XXXXXXXX  XX......  XXXXXXX.  .X.XXXXX  XXXXXXXX
    // bit2 X.X.X.X.  X.X.X...  ........  X.XXXX.X  XXX.X...  .......X  .X.X.X.X  .X...X.X  X.X.....  ........  ..X.X...  .X......  X.......  X.X....X  .X.X.X..  ........
    // bit3 X.X.X.X.  ...X.X.X  XX.XXXX.  .....X.X  X.X.X...  .......X  .X.XXXXX  XX.X....  ....X.XX  XX.X.X.X  ..X.XXXX  .X....X.  XXX.X...  X.X....X  .X.XXXXX  XX.X.X.X
    // bit4 .X.X....  X.X.X...  ..X..X..  X.XXXX.X  XXX.X.X.  XXXX.X.X  ....X.X.  .....X.X  X.X.....  ..X.XXXX  ........  ........  X.X.X.X.  .X.X.X.X  ........  .....X.X
    // bit5 .X.X....  ...X.X.X  ..X.XXX.  X.XXXX.X  X.X.X.X.  XXXX.X.X  ....X.X.  X.X.X.X.  XXXX.X..  ..X.XXXX  .....X.X  XXXX.XXX  XXX.X.X.  XXXX.XXX  ....X.X.  X.X.X.X.
    // bit6 .XXXXXXX  XXX.X...  .......X  XXX.XX.X  XXX.X.X.  X.X.X.X.  .......X  .X.X.X.X  .X.X.X.X  .X.X....  ........  ....X...  XXX.X.X.  X.X.X.X.  .......X  .X.X.X.X
    // bit7 .XXXXXXX  .X.X.X.X  .XXXXXXX  .X.X.X.X  X.X.X.X.  X.X.X.X.  .......X  .X.X....  XXXX.X.X  .XXXXXXX  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  .......X  .X.X....
    // Avalanche: 45.61%

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

    const std::uint8_t aMaskBuffer[128] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA,
        0xFF, 0xAA, 0xFF, 0x00, 0xFF, 0x00, 0x0F, 0x00, 0x0F, 0xCC, 0x0F, 0xCC, 0xC3, 0xCC, 0xC3, 0x3C,
        0xC3, 0x3C, 0x55, 0x3C, 0x55, 0xFF, 0x55, 0xFF, 0xF0, 0xFF, 0xF0, 0x0F, 0xF0, 0x0F, 0x33, 0x0F,
        0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55, 0x00, 0xF0, 0x00, 0xF0,
        0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA, 0xFF, 0xAA, 0xFF, 0x00,
        0xFF, 0x00, 0x0F, 0x00, 0x0F, 0xCC, 0x0F, 0xCC, 0xC3, 0xCC, 0xC3, 0x3C, 0xC3, 0x3C, 0x55, 0x3C,
        0x55, 0xFF, 0x55, 0xFF, 0xF0, 0xFF, 0xF0, 0x0F, 0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3
    };

    const std::uint8_t aMaskJumpBuffer[128] = {
        0xB0, 0xE2, 0x2F, 0xC6, 0x2F, 0xE4, 0x9F, 0xD6, 0xB0, 0x42, 0x82, 0xA5, 0xE5, 0x71, 0xA1, 0x4F,
        0x73, 0x36, 0xCF, 0xAE, 0x02, 0x07, 0x24, 0x43, 0x5F, 0xEF, 0x46, 0xB2, 0x9B, 0x2B, 0xAE, 0xA7,
        0xCB, 0x0C, 0x99, 0x4E, 0xD5, 0x36, 0x75, 0x9D, 0x70, 0x82, 0x00, 0xEC, 0x5D, 0x5F, 0xCD, 0x61,
        0x02, 0x5A, 0xDC, 0xE6, 0x68, 0x7D, 0x17, 0x38, 0x47, 0x5A, 0x72, 0x74, 0x1B, 0xE5, 0xF6, 0x43,
        0x77, 0xF9, 0x2F, 0x5C, 0xD8, 0x04, 0xB2, 0x42, 0x68, 0xEF, 0xA6, 0x76, 0xA8, 0x5B, 0xEC, 0x44,
        0xFA, 0xDB, 0xFB, 0xE1, 0xA4, 0x76, 0x34, 0x13, 0xE0, 0xC4, 0xAB, 0x8F, 0x66, 0x41, 0xBF, 0xBC,
        0xCE, 0x81, 0x8B, 0xA1, 0xF1, 0xBA, 0x80, 0x1F, 0xC9, 0x7B, 0x37, 0x68, 0x1A, 0x80, 0x48, 0x48,
        0x12, 0xA8, 0xEF, 0x5D, 0xED, 0xF6, 0xD9, 0x41, 0xAC, 0xC3, 0x53, 0xA0, 0xBC, 0x18, 0x43, 0x3F
    };

    PasswordJumpSubtractCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x10, 0xE1, 0xCD, 0xE1, 0x99, 0x2D, 0x99, 0x70, 0x22, 0x70, 0x92, 0xDE, 0x92, 0x55, 0x3C, 0x55,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xC3, 0x4C, 0x55, 0x4C, 0x89, 0x0F, 0x89, 0xCC, 0x24, 0xCC, 0xB4, 0xDC, 0xB4, 0x65, 0xF7, 0x65,
        0xDE, 0xC4, 0xDE, 0xC4, 0xBA, 0xC4, 0xBA, 0x46, 0xBA, 0x46, 0xCD, 0x46, 0xCD, 0x2D, 0xCD, 0x2D,
        0xCD, 0xF0, 0xBD, 0x33, 0xBD, 0x67, 0x2D, 0x67, 0x79, 0xDE, 0x79, 0x6E, 0x3C, 0x6E, 0xAA, 0xC4,
        0x00, 0x56, 0x10, 0x00, 0x10, 0xCC, 0x00, 0xCC, 0xB4, 0x00, 0xB4, 0x70, 0x00, 0x70, 0x92, 0x00,
        0x55, 0x0F, 0x55, 0x0F, 0x24, 0x0F, 0x24, 0xDC, 0x24, 0xDC, 0xF7, 0xDC, 0xF7, 0x19, 0xF7, 0x19
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_L_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_L_PasswordJumpSubtractCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_L_PasswordJumpSubtractCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_L_PasswordJumpSubtractCipher")) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_L_PasswordJumpSubtractCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpSubtractCipher] test_fixed_128_L_PasswordJumpSubtractCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

@end
