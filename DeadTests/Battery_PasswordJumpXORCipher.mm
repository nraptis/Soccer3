//
//  Battery_PasswordJumpXORCipher.m
//  HolyStorms
//
//  Created by icarus black on 7/5/26.
//

#import <XCTest/XCTest.h>
#import "PasswordJumpXORCipher.hpp"
#import "PrintExamplesHelper.hpp"
#import "CipherGauntlet.hpp"
#include <memory>

@interface Battery_PasswordJumpXORCipher : XCTestCase

@end

@implementation Battery_PasswordJumpXORCipher

- (void)test_gauntlet_PasswordJumpXORCipher {
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
            
            PasswordJumpXORCipher aCipher(aMask,
                                         aMaskJumps);
            if (!aGauntlet.RunCipher(&aCipher,
                                     32,
                                     "PasswordJumpXORCipher")) {
                XCTFail("[PasswordJumpXORCipher] test_gauntlet_PasswordJumpXORCipher failed.");
                return;
            }
        }
    }
}

- (void)test_fixed_32_A_PasswordJumpXORCipher {

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
        0x64, 0xE1, 0x7F, 0xED, 0x81, 0xFB, 0x4B, 0x61, 0x4C, 0xF0, 0x54, 0xB5, 0xD6, 0xF6, 0x59, 0xE1,
        0xFC, 0x8D, 0xBA, 0xB7, 0x9C, 0x46, 0xA5, 0x5F, 0xAA, 0x4D, 0xEF, 0xBB, 0x03, 0x72, 0x40, 0xA7
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_32_A_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_A_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_A_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_A_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_A_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_A_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_B_PasswordJumpXORCipher {

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
        0x6B, 0x61, 0x27, 0x86, 0x74, 0xDD, 0xFC, 0x4B, 0x8D, 0x1E, 0x8F, 0xDD, 0x75, 0x9C, 0xFB, 0x2A,
        0xAA, 0x50, 0x75, 0x97, 0xD7, 0x9A, 0x8C, 0x3F, 0x74, 0xEB, 0xFE, 0x51, 0x84, 0xE5, 0x4A, 0x54
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_32_B_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_B_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_B_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_B_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_B_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_B_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_C_PasswordJumpXORCipher {

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
        0x9E, 0xE2, 0x50, 0x04, 0xCB, 0x17, 0x91, 0x09, 0xEF, 0x71, 0x16, 0xAD, 0x57, 0xEA, 0x3E, 0xFF,
        0x19, 0x4F, 0xE1, 0x1C, 0x5C, 0xA4, 0x00, 0x2E, 0x81, 0x06, 0x2B, 0x28, 0xFA, 0xB0, 0x82, 0xE6
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_32_C_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_C_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_C_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_C_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_C_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_C_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_D_PasswordJumpXORCipher {

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
        0xBB, 0x47, 0xF7, 0x33, 0x4F, 0x73, 0xB7, 0xD3, 0xFF, 0x29, 0x18, 0x18, 0x5A, 0xA6, 0xAE, 0x60,
        0x04, 0x09, 0x56, 0xEB, 0x9A, 0x67, 0x8D, 0x73, 0x42, 0xAB, 0x54, 0x98, 0x23, 0xC8, 0xDF, 0x4A
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_32_D_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_D_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_D_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_D_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_D_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_D_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_E_PasswordJumpXORCipher {

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
        0x9E, 0x9B, 0x26, 0xAD, 0x04, 0x9F, 0xD1, 0xB8, 0xA1, 0xFA, 0x56, 0x3F, 0x29, 0x4B, 0xB4, 0xD2,
        0x9C, 0xB8, 0x28, 0xA4, 0xBB, 0x6E, 0xF3, 0x61, 0x7A, 0x3D, 0x72, 0x36, 0x2B, 0x3A, 0xEE, 0x00
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_32_E_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_E_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_E_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_E_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_E_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_E_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_F_PasswordJumpXORCipher {

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
        0xD6, 0x20, 0x01, 0x5E, 0x7A, 0x3F, 0xCB, 0x95, 0xF8, 0x8F, 0x9C, 0x21, 0x8F, 0x94, 0x63, 0x8E,
        0x4C, 0x53, 0xEC, 0x81, 0x05, 0x1A, 0xCC, 0x31, 0xBE, 0x55, 0x1E, 0x19, 0xD4, 0x85, 0x96, 0xE6
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_32_F_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_F_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_F_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_F_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_F_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_F_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_G_PasswordJumpXORCipher {

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
        0xC5, 0xB0, 0x81, 0x34, 0x9E, 0xD9, 0xB1, 0xDA, 0x12, 0xB0, 0xFC, 0xF9, 0x8D, 0x5F, 0x67, 0x97,
        0x31, 0xEF, 0x24, 0xC0, 0xFD, 0x39, 0x59, 0xA5, 0xE6, 0xA8, 0xD6, 0x21, 0x66, 0x58, 0x72, 0xFF
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_32_G_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_G_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_G_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_G_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_G_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_G_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_H_PasswordJumpXORCipher {

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
    // bit0 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit1 .XX..X.X  .X.XX..X  .X.X.XX.  .X.X.X.X
    // bit2 .X.XX.X.  .X.X.XX.  X..X.X.X  X.X..X.X
    // bit3 .XX.X.X.  .X.XX.X.  X..X.XX.  X.X..X.X
    // bit4 .X.XX..X  X..X.XX.  .XX..X.X  X..XX..X
    // bit5 .XX.X..X  X..XX.X.  .XX..XX.  X..XX..X
    // bit6 .X.X.XX.  X..X.X.X  X.X..X.X  .XX.X..X
    // bit7 .XX..XX.  X..XX..X  X.X..XX.  .XX.X..X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[32] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF
    };

    const std::uint8_t aMaskBuffer[32] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x35, 0xDA, 0x59, 0xBC, 0xA4, 0xC9, 0x3B, 0xA3, 0xFD, 0x93, 0xED, 0x74, 0xF3, 0x16, 0x08, 0x29,
        0xB7, 0x99, 0x94, 0xD7, 0x9A, 0xD3, 0xF5, 0x65, 0x74, 0x6D, 0xC1, 0x71, 0x80, 0x79, 0x2B, 0x1D
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_32_H_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_H_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_H_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_H_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_H_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_H_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_I_PasswordJumpXORCipher {

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
    // bit0 00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00110010  01001100
    // bit2 00000000  00000000  01101000  01011010
    // bit3 00000000  00000000  01011010  00010110
    // bit4 00000000  00000000  11101101  11111011
    // bit5 00000000  00000000  11011111  10110111
    // bit6 00000000  00000000  10000101  10100001
    // bit7 00000000  00000000  10110111  11101101
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X...X.X.  XXX...X.  X...X.X.  XXX...X.
    // bit2 XXX..XX.  ..XXX..X  XXX..XX.  ..XXX..X
    // bit3 XX...XX.  .XXX...X  XX...XX.  .XXX...X
    // bit4 ..X.XXXX  ....X.XX  ..X.XXXX  ....X.XX
    // bit5 ....XXXX  .X....XX  ....XXXX  .X....XX
    // bit6 .XX...XX  X..XX...  .XX...XX  X..XX...
    // bit7 .X....XX  XX.X....  .X....XX  XX.X....
    // Avalanche: 46.88%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x20, 0x3B, 0xDE, 0x60, 0xA6, 0x2F, 0x7C, 0x11, 0x9A, 0xCC, 0x31, 0x5E, 0x60, 0x1D, 0x31, 0x26,
        0xA8, 0x4F, 0x93, 0xCF, 0x28, 0x5C, 0xB8, 0x85, 0x2A, 0xD4, 0xE8, 0x16, 0xD7, 0x16, 0x63, 0x46
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x0F, 0x3C, 0x69, 0x55, 0x3C, 0x0F, 0x55, 0x0F, 0x0F, 0x69, 0x0F, 0x3C, 0x69, 0x55, 0x3C, 0x0F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_I_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_I_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_I_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_I_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_I_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_I_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_J_PasswordJumpXORCipher {

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
        0xD6, 0x99, 0xA6, 0x37, 0xDA, 0xA6, 0x51, 0xC5, 0x67, 0xF3, 0xF0, 0xDC, 0x47, 0xB8, 0x67, 0xA0,
        0xCA, 0x04, 0xF9, 0x06, 0x36, 0x19, 0x43, 0x29, 0x31, 0x96, 0x5D, 0xE8, 0x00, 0xFA, 0x1D, 0x04
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_32_J_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_J_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_J_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_J_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_J_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_J_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_K_PasswordJumpXORCipher {

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
        0x07, 0xC3, 0x02, 0xB9, 0xAE, 0x2C, 0xC6, 0xA9, 0x19, 0xA0, 0x97, 0xDD, 0xF7, 0x3E, 0xEB, 0xFA,
        0x24, 0x4C, 0x69, 0xD6, 0x5D, 0xD3, 0x6B, 0xC4, 0x7D, 0xF9, 0x59, 0x46, 0x4F, 0x6D, 0x9E, 0x01
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_32_K_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_K_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_K_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_K_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_K_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_K_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_L_PasswordJumpXORCipher {

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
    // bit0 00000000  00000000  11011011  01101101
    // bit1 00000000  00000000  11011011  11010101
    // bit2 00000000  00000000  11111111  11010111
    // bit3 00000000  00000000  11111111  01101111
    // bit4 00000000  00000000  01011010  00000111
    // bit5 00000000  00000000  01011010  10111111
    // bit6 00000000  00000000  01111110  10111101
    // bit7 00000000  00000000  01111110  00000101
    //
    // Avalanche:
    // bit0 X....X.X  XXX.X...  X....X.X  XXX.X...
    // bit1 X....X.X  .X.X.X.X  X....X.X  .X.X.X.X
    // bit2 X.X.X.X.  X.X.X...  X.X.X.X.  X.X.X...
    // bit3 X.X.X.X.  ...X.X.X  X.X.X.X.  ...X.X.X
    // bit4 .X.X....  X.X.X...  .X.X....  X.X.X...
    // bit5 .X.X....  ...X.X.X  .X.X....  ...X.X.X
    // bit6 .XXXXXXX  XXX.X...  .XXXXXXX  XXX.X...
    // bit7 .XXXXXXX  .X.X.X.X  .XXXXXXX  .X.X.X.X
    // Avalanche: 46.88%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0xC6, 0xF8, 0x80, 0x22, 0x5C, 0x66, 0x41, 0x62, 0x82, 0x00, 0xBF, 0x40, 0x6B, 0xC5, 0x10, 0x70,
        0x5C, 0x27, 0x6A, 0xEA, 0xEB, 0x47, 0x39, 0xA9, 0x04, 0x5F, 0x19, 0x73, 0x23, 0x8D, 0xB5, 0x81
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xF0, 0xFF, 0x33, 0xFF, 0xFF, 0x33, 0xFF, 0xF0, 0x66, 0xF0, 0x96, 0x66, 0x96, 0xFF, 0x3C, 0xFF
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_L_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_L_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_L_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_L_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_L_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_32_L_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_A_PasswordJumpXORCipher {

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
        0x87, 0x26, 0x7D, 0x71, 0x9F, 0x13, 0xF0, 0xD2, 0x25, 0x3E, 0xA9, 0x60, 0x67, 0x30, 0x9C, 0x48,
        0xAB, 0xB5, 0x00, 0x11, 0xA7, 0x45, 0x4E, 0x3D, 0x49, 0x79, 0x36, 0x6A, 0xAB, 0x1B, 0xE8, 0x03,
        0x3E, 0x9E, 0x32, 0x29, 0x38, 0x94, 0xDC, 0x0D, 0x9F, 0x18, 0xDA, 0xEC, 0x3E, 0xF6, 0x88, 0xA1,
        0x63, 0x7E, 0xB0, 0xBA, 0x0A, 0x82, 0xFE, 0xF8, 0x36, 0x3F, 0x3E, 0xD5, 0x6F, 0x1C, 0x14, 0x4A
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_64_A_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_A_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_A_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_A_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_A_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_A_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_B_PasswordJumpXORCipher {

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
        0x46, 0x6A, 0x2A, 0xB9, 0xAF, 0x6E, 0x6F, 0x92, 0xEE, 0xDA, 0x74, 0x7A, 0xC2, 0xC6, 0x86, 0xD1,
        0xDF, 0xE7, 0xD0, 0xD7, 0x6F, 0xFC, 0x5D, 0x0A, 0xDC, 0x62, 0xBA, 0x6F, 0x2B, 0x81, 0xC1, 0xB0,
        0x0D, 0x1B, 0xE2, 0x7E, 0xD8, 0xB6, 0x5E, 0xF9, 0x2E, 0x2D, 0x46, 0xC2, 0xEE, 0x0F, 0x48, 0x97,
        0x25, 0x73, 0xF7, 0x4A, 0xB1, 0x8B, 0x4E, 0x6A, 0xB8, 0x23, 0x8B, 0x81, 0x3F, 0x5D, 0xCB, 0x03
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_64_B_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_B_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_B_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_B_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_B_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_B_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_C_PasswordJumpXORCipher {

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
        0xE7, 0x03, 0xF8, 0x15, 0x7F, 0xEA, 0x7D, 0x64, 0x0F, 0x3D, 0xED, 0x13, 0x03, 0x41, 0xB3, 0x7E,
        0x1A, 0x67, 0x08, 0x03, 0x9A, 0xF1, 0xA3, 0x67, 0x90, 0x1B, 0x68, 0xD7, 0x2E, 0x07, 0xEA, 0xB4,
        0xE5, 0x33, 0x2F, 0x15, 0x2D, 0xD0, 0x61, 0x66, 0xD2, 0x40, 0x44, 0x4D, 0x4B, 0x24, 0xFA, 0xC9,
        0xF0, 0xB2, 0x02, 0xE6, 0x50, 0x7E, 0x90, 0x87, 0x48, 0xC3, 0x4D, 0x6E, 0x2A, 0x00, 0xA2, 0xE6
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_64_C_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_C_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_C_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_C_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_C_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_C_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_D_PasswordJumpXORCipher {

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
        0x1F, 0x38, 0xE3, 0x50, 0x28, 0x04, 0xCE, 0x5E, 0x48, 0xD6, 0xDB, 0x6F, 0xFF, 0x40, 0xBC, 0x0F,
        0x42, 0xD2, 0x37, 0xF1, 0x10, 0xF0, 0x90, 0x32, 0x3D, 0xBD, 0x9B, 0xD2, 0x74, 0x8B, 0x5B, 0xC9,
        0xB6, 0xAB, 0xF3, 0x64, 0x50, 0x1D, 0x59, 0x9A, 0x18, 0xAC, 0x08, 0x17, 0x5D, 0x3C, 0xDA, 0xF5,
        0x9E, 0x11, 0xC7, 0x69, 0xF4, 0x7A, 0x18, 0x6C, 0xAD, 0x6E, 0xEC, 0xE2, 0xEB, 0x67, 0x15, 0xED
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_64_D_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_D_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_D_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_D_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_D_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_D_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_E_PasswordJumpXORCipher {

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
        0x77, 0xCD, 0x48, 0xBC, 0x53, 0xCF, 0x5B, 0x8F, 0xA1, 0x93, 0x7D, 0xD1, 0x4C, 0x79, 0xCE, 0x5E,
        0x99, 0x46, 0xD5, 0x12, 0xCD, 0x8B, 0x3A, 0x8B, 0xA5, 0x56, 0xE0, 0xD4, 0x45, 0x71, 0x40, 0x0C,
        0x63, 0x90, 0xD3, 0x43, 0x04, 0x08, 0x76, 0x3F, 0x6C, 0x92, 0x39, 0x22, 0xC8, 0x40, 0x49, 0xFD,
        0x21, 0x33, 0x15, 0xAD, 0x17, 0xE4, 0x0E, 0x45, 0x3A, 0xC9, 0x89, 0xD7, 0x93, 0xD6, 0xF6, 0x1D
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_64_E_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_E_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_E_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_E_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_E_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_E_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_F_PasswordJumpXORCipher {

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
        0x5F, 0xCA, 0x60, 0x68, 0xAC, 0x18, 0x37, 0xC2, 0x6D, 0x28, 0x17, 0xA8, 0x90, 0xAD, 0xFA, 0xE2,
        0x02, 0xBA, 0x2B, 0x01, 0xF0, 0x5B, 0x25, 0x14, 0x3C, 0xB3, 0x98, 0x62, 0x27, 0x61, 0x12, 0x0B,
        0x2C, 0x95, 0xA7, 0xC0, 0x31, 0x17, 0x1C, 0x04, 0xBB, 0x0F, 0xA1, 0x6E, 0x0C, 0xE6, 0x45, 0xB6,
        0x5B, 0x41, 0xD5, 0x59, 0x69, 0x08, 0x00, 0x86, 0x58, 0x93, 0x4A, 0x16, 0x75, 0x91, 0x39, 0xE0
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_64_F_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_F_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_F_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_F_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_F_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_F_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_G_PasswordJumpXORCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  11000011  00110000  00000000  00000000  00001100  11000011
    // bit2 00000000  00000000  00111111  11001111  00000000  00000000  11111111  00111111
    // bit3 00000000  00000000  11111100  11111111  00000000  00000000  11110011  11111100
    // bit4 00000000  00000000  11000000  11110000  00000000  00000000  00000011  11000000
    // bit5 00000000  00000000  00000011  11000000  00000000  00000000  00001111  00000011
    // bit6 00000000  00000000  11111111  00111111  00000000  00000000  11111100  11111111
    // bit7 00000000  00000000  00111100  00001111  00000000  00000000  11110000  00111100
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X..X  X.X.X.X.  X.X.X..X  X.X.X.X.  X.X..XX.  X.X.X..X  X.X..XX.  X.X.X..X
    // bit2 X..X.XX.  X.X..X.X  X..X.XX.  X.X..X.X  .X.XX.X.  X..X.XX.  .X.XX.X.  X..X.XX.
    // bit3 X..X.X.X  X.X..X.X  X..X.X.X  X.X..X.X  .X.X.XX.  X..X.X.X  .X.X.XX.  X..X.X.X
    // bit4 .XX..XX.  X..XX..X  .XX..XX.  X..XX..X  X..XX.X.  .XX..XX.  X..XX.X.  .XX..XX.
    // bit5 .XX..X.X  X..XX..X  .XX..X.X  X..XX..X  X..X.XX.  .XX..X.X  X..X.XX.  .XX..X.X
    // bit6 .X.XX.X.  X..X.XX.  .X.XX.X.  X..X.XX.  .XX.X.X.  .X.XX.X.  .XX.X.X.  .X.XX.X.
    // bit7 .X.XX..X  X..X.XX.  .X.XX..X  X..X.XX.  .XX..XX.  .X.XX..X  .XX..XX.  .X.XX..X
    // Avalanche: 50.00%

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
        0x00, 0x86, 0x88, 0xEC, 0x07, 0x80, 0x49, 0xAB, 0x3A, 0x7D, 0x30, 0x3B, 0xF0, 0xA8, 0xD2, 0x83,
        0xEE, 0x08, 0x4B, 0x50, 0xBF, 0x52, 0xA9, 0x8B, 0x4E, 0x48, 0x72, 0x15, 0x18, 0x04, 0xFC, 0xE1,
        0x5A, 0x40, 0x0C, 0x4C, 0xC2, 0xE5, 0x42, 0x49, 0x22, 0x0B, 0x14, 0x02, 0xD6, 0x93, 0xAB, 0x03,
        0xAC, 0xE0, 0x55, 0x78, 0xCB, 0xE9, 0x36, 0x43, 0x07, 0x42, 0xB7, 0x93, 0x67, 0x07, 0x9A, 0x65
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x5A, 0x5A, 0x33, 0x33, 0x33, 0x33, 0x66, 0x66, 0x3C, 0x3C, 0x5A, 0x5A, 0x33, 0x33, 0x33, 0x33,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x33, 0x33, 0x33, 0x33, 0x66, 0x66, 0x3C, 0x3C, 0x5A, 0x5A, 0x33, 0x33, 0x33, 0x33, 0x66, 0x66
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_G_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_G_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_G_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_G_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_G_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_G_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_H_PasswordJumpXORCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  11000011  00110000  11001100  00110011
    // bit2 00000000  00000000  00000000  00000000  11111100  11111111  00111111  11001111
    // bit3 00000000  00000000  00000000  00000000  00111111  11001111  11110011  11111100
    // bit4 00000000  00000000  00000000  00000000  00000011  11000000  11110000  00111100
    // bit5 00000000  00000000  00000000  00000000  11000000  11110000  00111100  00001111
    // bit6 00000000  00000000  00000000  00000000  11111111  00111111  11001111  11110011
    // bit7 00000000  00000000  00000000  00000000  00111100  00001111  00000011  11000000
    //
    // Avalanche:
    // bit0 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit1 .XX..X.X  .X.XX..X  .X.X.XX.  .X.X.X.X  .X.X.XX.  .X.X.X.X  X..X.X.X  .XX..X.X
    // bit2 .X.XX.X.  .X.X.XX.  X..X.X.X  X.X..X.X  X..X.X.X  X.X..X.X  .XX.X..X  .X.XX.X.
    // bit3 .XX.X.X.  .X.XX.X.  X..X.XX.  X.X..X.X  X..X.XX.  X.X..X.X  X.X.X..X  .XX.X.X.
    // bit4 .X.XX..X  X..X.XX.  .XX..X.X  X..XX..X  .XX..X.X  X..XX..X  .XX..XX.  .X.XX..X
    // bit5 .XX.X..X  X..XX.X.  .XX..XX.  X..XX..X  .XX..XX.  X..XX..X  X.X..XX.  .XX.X..X
    // bit6 .X.X.XX.  X..X.X.X  X.X..X.X  .XX.X..X  X.X..X.X  .XX.X..X  .X.XX.X.  .X.X.XX.
    // bit7 .XX..XX.  X..XX..X  X.X..XX.  .XX.X..X  X.X..XX.  .XX.X..X  X..XX.X.  .XX..XX.
    // Avalanche: 50.00%

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
        0x31, 0x88, 0xA1, 0x5B, 0x99, 0x57, 0xE6, 0x3C, 0xFB, 0xFE, 0x6C, 0xE0, 0x5D, 0x09, 0x83, 0xAC,
        0xD7, 0x3E, 0xF9, 0xFF, 0x67, 0xAD, 0xED, 0x92, 0x94, 0x87, 0xC7, 0xEF, 0xE1, 0x79, 0xA7, 0x06,
        0x72, 0xBC, 0x64, 0xA5, 0x59, 0xB5, 0xE6, 0x4D, 0x49, 0xDE, 0x8C, 0xB5, 0x8D, 0xF2, 0x3C, 0xA2,
        0x47, 0xE4, 0x90, 0x8E, 0x41, 0x15, 0x5F, 0xE6, 0xD0, 0x92, 0xBE, 0x56, 0x00, 0x62, 0x64, 0xCD
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x66, 0x66, 0x33, 0x33, 0x33, 0x33, 0x5A, 0x5A, 0x3C, 0x3C, 0x66, 0x66, 0x33, 0x33, 0x33, 0x33,
        0x5A, 0x5A, 0x3C, 0x3C, 0x66, 0x66, 0x33, 0x33, 0x33, 0x33, 0x5A, 0x5A, 0x3C, 0x3C, 0x66, 0x66
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_H_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_H_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_H_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_H_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_H_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_H_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_I_PasswordJumpXORCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  10010011  00100100  01011010  00010110
    // bit2 00000000  00000000  00000000  00000000  00010110  10000101  10110111  11101101
    // bit3 00000000  00000000  00000000  00000000  10000101  10100001  11101101  11111011
    // bit4 00000000  00000000  00000000  00000000  01111110  11011111  11001001  00110010
    // bit5 00000000  00000000  00000000  00000000  11101101  11111011  10010011  00100100
    // bit6 00000000  00000000  00000000  00000000  01101000  01011010  01111110  11011111
    // bit7 00000000  00000000  00000000  00000000  11111011  01111110  00100100  11001001
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X...X.X.  XXX...X.  X.XXX...  X.X.XXX.  X.XXX...  X.X.XXX.  X.XXX...  X.X.XXX.
    // bit2 XXX..XX.  ..XXX..X  X...XXX.  .XX...XX  X...XXX.  .XX...XX  X...XXX.  .XX...XX
    // bit3 XX...XX.  .XXX...X  X..XXX..  .XX..XXX  X..XXX..  .XX..XXX  X..XXX..  .XX..XXX
    // bit4 ..X.XXXX  ....X.XX  XX....X.  XXXX....  XX....X.  XXXX....  XX....X.  XXXX....
    // bit5 ....XXXX  .X....XX  XX.X....  XXXX.X..  XX.X....  XXXX.X..  XX.X....  XXXX.X..
    // bit6 .XX...XX  X..XX...  XXX..XX.  ..XXX..X  XXX..XX.  ..XXX..X  XXX..XX.  ..XXX..X
    // bit7 .X....XX  XX.X....  XXXX.X..  ..XXXX.X  XXXX.X..  ..XXXX.X  XXXX.X..  ..XXXX.X
    // Avalanche: 51.56%

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
        0xA5, 0x1C, 0x38, 0x3D, 0xD6, 0xB3, 0x86, 0x1B, 0x73, 0x83, 0xC7, 0x74, 0x28, 0x43, 0x7A, 0x27,
        0x8D, 0x47, 0xD0, 0x1A, 0x50, 0xBA, 0xE8, 0x08, 0x3B, 0xEA, 0xEC, 0x3F, 0x7B, 0x87, 0x08, 0x8C,
        0xDB, 0x9D, 0xC3, 0x38, 0xA9, 0x6D, 0x92, 0x9A, 0xEF, 0x54, 0x99, 0x55, 0x92, 0x0F, 0x32, 0x6F,
        0x95, 0x0D, 0x3C, 0x81, 0xA3, 0xC4, 0xF1, 0xC6, 0x51, 0xFA, 0x0E, 0x6D, 0x30, 0xF6, 0x41, 0x75
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x55, 0x0F, 0x0F, 0x69, 0x0F, 0x3C, 0x69, 0x55, 0x3C, 0x0F, 0x55, 0x0F, 0x0F, 0x69, 0x0F, 0x3C,
        0x3C, 0x5A, 0x33, 0x66, 0x5A, 0x33, 0x66, 0x3C, 0x33, 0x33, 0x3C, 0x5A, 0x33, 0x66, 0x5A, 0x33
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_I_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_I_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_I_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_I_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_I_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_I_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_J_PasswordJumpXORCipher {

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
        0xC0, 0x6D, 0x92, 0xE7, 0x90, 0x30, 0x31, 0xC3, 0x9A, 0x1B, 0x22, 0xA3, 0x8B, 0x83, 0x85, 0x23,
        0x6A, 0x47, 0x6A, 0x92, 0xEA, 0x8D, 0xE7, 0xE3, 0x4E, 0x6F, 0x15, 0x69, 0x27, 0x66, 0x51, 0xA8,
        0xFC, 0x3D, 0x0E, 0xE5, 0x03, 0x23, 0x11, 0xE1, 0x43, 0x73, 0x71, 0x0F, 0xD3, 0x0A, 0xB4, 0x64,
        0xC0, 0xB9, 0x7E, 0xB1, 0xC0, 0x0A, 0x17, 0xC1, 0x90, 0xCC, 0x99, 0x1C, 0x4D, 0x81, 0xE7, 0x42
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_64_J_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_J_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_J_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_J_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_J_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_J_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_K_PasswordJumpXORCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  11111111  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  11111111  11111111  11111111  11111111  11111111  00000000
    // bit3 00000000  00000000  11111111  00000000  11111111  11111111  11111111  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  11111111  11111111
    // bit5 00000000  00000000  00000000  11111111  00000000  00000000  11111111  11111111
    // bit6 00000000  00000000  11111111  11111111  11111111  11111111  00000000  11111111
    // bit7 00000000  00000000  11111111  00000000  11111111  11111111  00000000  11111111
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit2 X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X
    // bit3 X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X
    // bit4 .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.
    // bit5 .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.
    // bit6 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

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
        0xC0, 0x2B, 0xB5, 0xCD, 0xCC, 0xAF, 0x26, 0x82, 0x34, 0xB0, 0x2E, 0x04, 0x0E, 0xDF, 0x82, 0x52,
        0x67, 0x13, 0xEA, 0x56, 0x74, 0x19, 0x9A, 0x57, 0xCA, 0xCA, 0xDC, 0xF0, 0xB9, 0xAB, 0xE0, 0x68,
        0x22, 0x2A, 0x6B, 0x52, 0x68, 0xEE, 0x1C, 0x21, 0xC2, 0xA2, 0xB3, 0xFA, 0x97, 0x73, 0x7C, 0xEC,
        0x10, 0x09, 0x27, 0x03, 0x38, 0xA6, 0x86, 0x24, 0xE9, 0x04, 0x65, 0x62, 0x5F, 0x62, 0xBB, 0xE5
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66,
        0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33,
        0x3C, 0x3C, 0x3C, 0x3C, 0x3C, 0x3C, 0x3C, 0x3C, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_K_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_K_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_K_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_K_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_K_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_K_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_L_PasswordJumpXORCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  01101101  10110110
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000111  10110110
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  10111101  11101011
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  11010111  11101011
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  10111111  10100000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  11010101  10100000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  01101111  11111101
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000101  11111101
    //
    // Avalanche:
    // bit0 X....X.X  XXX.X...  .X.XXXX.  X....X.X  XXX.X...  .X.XXXX.  XXX.X...  .X.XXXX.
    // bit1 X....X.X  .X.X.X.X  .X.XXXX.  X.......  X.X.X...  .X.XXXX.  X.X.X...  .X.XXXX.
    // bit2 X.X.X.X.  X.X.X...  .X.X.X.X  .XXXXXXX  XXX.X...  .......X  XXX.X...  .......X
    // bit3 X.X.X.X.  ...X.X.X  .X.X.X.X  .XXXX.X.  X.X.X...  .......X  X.X.X...  .......X
    // bit4 .X.X....  X.X.X...  ....X.X.  X.X.XXXX  XXX.X.X.  XXXX.X.X  XXX.X.X.  XXXX.X.X
    // bit5 .X.X....  ...X.X.X  ....X.X.  X.X.X.X.  X.X.X.X.  XXXX.X.X  X.X.X.X.  XXXX.X.X
    // bit6 .XXXXXXX  XXX.X...  .......X  .X.X.X.X  XXX.X.X.  X.X.X.X.  XXX.X.X.  X.X.X.X.
    // bit7 .XXXXXXX  .X.X.X.X  .......X  .X.X....  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // Avalanche: 47.66%

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
        0xF9, 0x8D, 0x64, 0x26, 0x37, 0x8A, 0xBE, 0x0D, 0x61, 0x3B, 0x76, 0x4A, 0xAF, 0xCB, 0x11, 0xBC,
        0x63, 0x76, 0x91, 0x11, 0x02, 0x64, 0x96, 0xD7, 0x81, 0x40, 0x4D, 0x77, 0xF9, 0xDE, 0x9B, 0x8C,
        0xB7, 0x9D, 0x50, 0xA9, 0x12, 0xD1, 0x37, 0x2E, 0x5F, 0x4C, 0x07, 0x6C, 0x33, 0xEA, 0xD2, 0xF7,
        0x8B, 0x2C, 0xC8, 0x1B, 0xFA, 0x41, 0xEA, 0x57, 0xE2, 0x5E, 0xBD, 0x37, 0x83, 0x27, 0x1B, 0x24
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x3C, 0x96, 0xAA, 0x3C, 0xAA, 0xFF, 0x5A, 0xFF, 0xFF, 0x33, 0xFF, 0xC3, 0x33, 0xC3, 0xF0, 0x33
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_L_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_L_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_L_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_L_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_L_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_64_L_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_A_PasswordJumpXORCipher {

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
        0x73, 0xFD, 0xD8, 0xF2, 0xEC, 0x28, 0x81, 0xF5, 0xAA, 0xE2, 0xF5, 0x53, 0xE4, 0x0B, 0xE5, 0x3C,
        0xFF, 0x56, 0xEE, 0xA2, 0xC6, 0x2F, 0xDB, 0x53, 0xD1, 0x4D, 0x01, 0x96, 0xDA, 0xC2, 0x47, 0xC5,
        0x07, 0x1C, 0xBB, 0x3D, 0x11, 0xA9, 0x00, 0x17, 0x9A, 0xC7, 0x68, 0x99, 0x39, 0x4F, 0x80, 0xEF,
        0xDA, 0x41, 0xC4, 0x7D, 0xE3, 0x10, 0x9C, 0x52, 0x69, 0xD6, 0xB5, 0x69, 0x52, 0x11, 0x3D, 0x02,
        0x8D, 0xB5, 0x5F, 0xE5, 0x43, 0x7F, 0xB3, 0x5E, 0xB0, 0x85, 0x01, 0x0D, 0x58, 0x2C, 0x8C, 0x59,
        0x70, 0x36, 0x0D, 0x39, 0x85, 0x42, 0xE4, 0x4A, 0x93, 0xDC, 0x25, 0x76, 0x5B, 0xDF, 0x5F, 0x3C
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_96_A_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_A_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_A_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_A_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_A_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_A_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_B_PasswordJumpXORCipher {

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
        0xCC, 0x3F, 0x80, 0x3D, 0x81, 0xDD, 0xC2, 0x2D, 0x2F, 0x55, 0x33, 0xB4, 0xE9, 0xB7, 0xEE, 0xE4,
        0xC8, 0x4A, 0xCC, 0x83, 0xE5, 0x93, 0x6F, 0xF3, 0x83, 0xBF, 0x3F, 0x65, 0x19, 0x7A, 0x81, 0x1D,
        0x66, 0xA1, 0x87, 0x7F, 0x7D, 0x84, 0x3B, 0xCA, 0x0C, 0xF5, 0x17, 0xB1, 0x4C, 0x9D, 0xDA, 0x92,
        0x6F, 0x8F, 0x9A, 0x02, 0xDA, 0x50, 0xFB, 0x4F, 0xC4, 0x10, 0x5F, 0x01, 0xB5, 0x7E, 0xE1, 0x41,
        0x3D, 0xDC, 0x46, 0xF0, 0x46, 0x38, 0x5A, 0xA3, 0xC0, 0x97, 0x65, 0x52, 0x52, 0x82, 0xC9, 0x04,
        0xF4, 0x11, 0x63, 0x81, 0x59, 0x11, 0xD2, 0x97, 0x9D, 0xB4, 0x8B, 0x69, 0x7A, 0x8D, 0x54, 0x87
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_96_B_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_B_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_B_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_B_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_B_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_B_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_C_PasswordJumpXORCipher {

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
        0xE5, 0xCF, 0x89, 0x20, 0x03, 0x40, 0x9E, 0x4F, 0x3E, 0x8D, 0x33, 0xAA, 0x32, 0x1C, 0xBF, 0xDC,
        0x93, 0x6B, 0x9C, 0xA2, 0x4C, 0x61, 0xAB, 0xE1, 0x70, 0xB2, 0xA5, 0x0B, 0x98, 0x2F, 0xDE, 0x31,
        0x3D, 0x2D, 0xF9, 0x7D, 0xCC, 0x3F, 0x00, 0xFC, 0x7A, 0x7C, 0x5A, 0xDD, 0x5B, 0xA7, 0xFC, 0xD9,
        0x6E, 0x6D, 0x74, 0x04, 0xA8, 0xF0, 0xD6, 0x52, 0x94, 0x5A, 0x19, 0x8B, 0x3A, 0xB6, 0x98, 0x8B,
        0xB9, 0xF1, 0xDA, 0x5E, 0xDA, 0x42, 0x7D, 0x59, 0x2E, 0xC8, 0x90, 0xAC, 0x75, 0x7B, 0x6E, 0xBC,
        0x55, 0xD5, 0x74, 0x9C, 0xB5, 0x49, 0x85, 0x17, 0x76, 0x48, 0x35, 0xF2, 0x36, 0xB6, 0xC9, 0xA4
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_96_C_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_C_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_C_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_C_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_C_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_C_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_D_PasswordJumpXORCipher {

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
        0x0C, 0xAF, 0xA8, 0x7B, 0x72, 0x77, 0xFC, 0xFE, 0x83, 0x8E, 0xE0, 0x6B, 0x68, 0x46, 0xEC, 0x8B,
        0x98, 0xB4, 0xD2, 0x35, 0x18, 0xAB, 0x6D, 0x92, 0x74, 0x66, 0x3F, 0x5D, 0xFE, 0x3A, 0x41, 0x1C,
        0xA6, 0x19, 0xC1, 0x36, 0x4C, 0x7A, 0x50, 0x06, 0x15, 0xBB, 0xCF, 0x28, 0x38, 0x84, 0x8A, 0xD9,
        0x1F, 0x22, 0xD3, 0xA3, 0x2A, 0xFE, 0xAA, 0x70, 0x71, 0x49, 0xD3, 0xD6, 0x99, 0x9B, 0xC0, 0xE7,
        0x39, 0x77, 0x30, 0x8B, 0x42, 0x28, 0xF8, 0x43, 0xD8, 0x43, 0x50, 0x48, 0x61, 0xF9, 0x4F, 0xF0,
        0xB9, 0x6C, 0x00, 0xA1, 0x43, 0x7E, 0xB4, 0x2C, 0x23, 0x8E, 0x61, 0x0F, 0xBE, 0xB6, 0x45, 0xFA
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_96_D_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_D_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_D_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_D_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_D_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_D_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_E_PasswordJumpXORCipher {

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
        0xD1, 0x0E, 0xC7, 0x76, 0x7E, 0xC6, 0x30, 0x04, 0xA1, 0x04, 0x5A, 0x8D, 0xEF, 0x77, 0x35, 0xCF,
        0x06, 0x1C, 0x4B, 0xF2, 0x0C, 0x56, 0x1B, 0x89, 0x4D, 0xC9, 0xCC, 0xAE, 0x18, 0xB8, 0x0C, 0x79,
        0xEB, 0xE9, 0x21, 0xF9, 0xAD, 0x94, 0x26, 0x5F, 0xE5, 0x94, 0xA2, 0x8A, 0xB3, 0xBF, 0x93, 0x8F,
        0xF8, 0x2A, 0x69, 0x02, 0x03, 0xD7, 0x4D, 0x7E, 0x92, 0xB3, 0x9C, 0x0C, 0x10, 0x20, 0x14, 0xB2,
        0xD5, 0xCD, 0x7D, 0xEC, 0x73, 0xD7, 0x51, 0x21, 0xC1, 0x6E, 0x87, 0xCF, 0xFF, 0xE1, 0xA4, 0x12,
        0x48, 0xD3, 0xDF, 0xCA, 0x6F, 0x18, 0x28, 0x05, 0x82, 0x76, 0xAE, 0x32, 0x95, 0xAB, 0x5B, 0xB0
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_96_E_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_E_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_E_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_E_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_E_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_E_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_F_PasswordJumpXORCipher {

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
        0x45, 0x6B, 0xED, 0xEB, 0xFB, 0x3E, 0x3E, 0x0E, 0x3F, 0xEE, 0xB9, 0xC1, 0x97, 0x74, 0xD5, 0x20,
        0x67, 0x9F, 0xEF, 0x58, 0x5F, 0x61, 0x9D, 0x8B, 0xA8, 0xD8, 0x74, 0x0C, 0x08, 0x44, 0x5A, 0x99,
        0x66, 0xC0, 0x51, 0xB4, 0x4D, 0x30, 0x42, 0x99, 0xAA, 0xDC, 0x04, 0xDA, 0x56, 0x34, 0xB9, 0xA4,
        0x62, 0xC5, 0xBC, 0x97, 0x37, 0x46, 0xE4, 0x3E, 0xF7, 0x73, 0x1F, 0x01, 0x77, 0x28, 0x47, 0x8F,
        0x02, 0xBF, 0x65, 0x13, 0x71, 0xDC, 0xC8, 0x09, 0xFE, 0xBD, 0xEE, 0x9B, 0xF6, 0x98, 0xC3, 0x05,
        0xC9, 0xC7, 0x25, 0x71, 0xDF, 0x83, 0x7E, 0x06, 0x90, 0xF2, 0xCF, 0xC3, 0xA0, 0x72, 0x1C, 0xCF
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_96_F_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_F_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_F_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_F_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_F_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_F_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_G_PasswordJumpXORCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  11001100  00110011  00111100  00001111  00000011  11000000  00110011  00001100  00000000  00000000
    // bit2 00000000  00000000  11110011  11111100  00110000  11001100  00110011  00001100  11111100  11111111  00000000  00000000
    // bit3 00000000  00000000  00111111  11001111  00001100  11000011  00110000  11001100  11001111  11110011  00000000  00000000
    // bit4 00000000  00000000  00111100  00001111  11110011  11111100  11111111  00111111  00001111  00000011  00000000  00000000
    // bit5 00000000  00000000  11110000  00111100  11001111  11110011  11111100  11111111  00111100  00001111  00000000  00000000
    // bit6 00000000  00000000  11001111  11110011  11000011  00110000  11001100  00110011  11110011  11111100  00000000  00000000
    // bit7 00000000  00000000  00000011  11000000  11111111  00111111  11001111  11110011  11000000  11110000  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X..X  X.X.X.X.  X.X..XX.  X.X.X..X  X..XX.X.  X.X..XX.  X.X.X..X  X.X.X.X.  X.X.X..X  X.X.X.X.  X.X.X..X  X.X.X.X.
    // bit2 X..X.XX.  X.X..X.X  .X.XX.X.  X..X.XX.  .XX.X.X.  .X.XX.X.  X..X.XX.  X.X..X.X  X..X.XX.  X.X..X.X  X..X.XX.  X.X..X.X
    // bit3 X..X.X.X  X.X..X.X  .X.X.XX.  X..X.X.X  .X.XX.X.  .X.X.XX.  X..X.X.X  X.X..X.X  X..X.X.X  X.X..X.X  X..X.X.X  X.X..X.X
    // bit4 .XX..XX.  X..XX..X  X..XX.X.  .XX..XX.  .XX.X..X  X..XX.X.  .XX..XX.  X..XX..X  .XX..XX.  X..XX..X  .XX..XX.  X..XX..X
    // bit5 .XX..X.X  X..XX..X  X..X.XX.  .XX..X.X  .X.XX..X  X..X.XX.  .XX..X.X  X..XX..X  .XX..X.X  X..XX..X  .XX..X.X  X..XX..X
    // bit6 .X.XX.X.  X..X.XX.  .XX.X.X.  .X.XX.X.  X.X.X..X  .XX.X.X.  .X.XX.X.  X..X.XX.  .X.XX.X.  X..X.XX.  .X.XX.X.  X..X.XX.
    // bit7 .X.XX..X  X..X.XX.  .XX..XX.  .X.XX..X  X..XX..X  .XX..XX.  .X.XX..X  X..X.XX.  .X.XX..X  X..X.XX.  .X.XX..X  X..X.XX.
    // Avalanche: 50.00%

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
        0x08, 0xE0, 0x2B, 0xC0, 0x55, 0xCB, 0xC9, 0x49, 0xCE, 0xF0, 0x46, 0xA3, 0x92, 0x64, 0xFB, 0x74,
        0x85, 0xC3, 0xFC, 0xB6, 0xDB, 0xB5, 0xD3, 0xD8, 0x69, 0xE1, 0xD4, 0x0C, 0x88, 0x52, 0x0F, 0xE4,
        0x92, 0x0B, 0xD9, 0xC5, 0x2F, 0x61, 0xA3, 0x03, 0x0D, 0x82, 0x69, 0x9C, 0xC0, 0xD1, 0x1E, 0x33,
        0xC0, 0xA1, 0xBA, 0x84, 0xA9, 0x33, 0x8A, 0x3E, 0x4B, 0x03, 0xCD, 0x7E, 0x5C, 0xBE, 0x3A, 0x05,
        0x05, 0xB3, 0x34, 0xCA, 0xD2, 0xA9, 0x0F, 0xFB, 0x01, 0x05, 0xC0, 0x88, 0x4C, 0xEE, 0x85, 0x42,
        0x62, 0x33, 0xB6, 0x78, 0x95, 0x0C, 0xEB, 0xE8, 0xB8, 0x46, 0x3B, 0xA0, 0x8E, 0x2D, 0xAE, 0xD7
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x66, 0x66, 0x3C, 0x3C, 0x5A, 0x5A, 0x33, 0x33, 0x33, 0x33, 0x66, 0x66, 0x3C, 0x3C, 0x5A, 0x5A,
        0x0F, 0x0F, 0x69, 0x69, 0x55, 0x55, 0x0F, 0x0F, 0x3C, 0x3C, 0x0F, 0x0F, 0x69, 0x69, 0x55, 0x55,
        0x0F, 0x0F, 0x3C, 0x3C, 0x0F, 0x0F, 0x69, 0x69, 0x55, 0x55, 0x0F, 0x0F, 0x3C, 0x3C, 0x0F, 0x0F,
        0x33, 0x33, 0x66, 0x66, 0x3C, 0x3C, 0x5A, 0x5A, 0x33, 0x33, 0x33, 0x33, 0x66, 0x66, 0x3C, 0x3C,
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
                                                    "test_fixed_96_G_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_G_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_G_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_G_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_G_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_G_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_H_PasswordJumpXORCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  11000011  00110000  11000000  11110000  00000000  00000000  00000011  11000000  11110000  00111100
    // bit2 00000000  00000000  11111100  11111111  11001100  00110011  00000000  00000000  00110000  11001100  00110011  00001100
    // bit3 00000000  00000000  00111111  11001111  00001100  11000011  00000000  00000000  00110011  00001100  11000011  00110000
    // bit4 00000000  00000000  00000011  11000000  11111111  00111111  00000000  00000000  11111100  11111111  00111111  11001111
    // bit5 00000000  00000000  11000000  11110000  00111111  11001111  00000000  00000000  11111111  00111111  11001111  11110011
    // bit6 00000000  00000000  11111111  00111111  00110011  00001100  00000000  00000000  11001100  00110011  00001100  11000011
    // bit7 00000000  00000000  00111100  00001111  11110011  11111100  00000000  00000000  11001111  11110011  11111100  11111111
    //
    // Avalanche:
    // bit0 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit1 .XX..X.X  .X.XX..X  X..X.X.X  .XX..X.X  .X.X.X.X  X..X.X.X  .X.XX..X  .X.X.XX.  .X.X.XX.  .X.X.X.X  X..X.X.X  .XX..X.X
    // bit2 .X.XX.X.  .X.X.XX.  .XX.X..X  .X.XX.X.  X.X..X.X  .XX.X..X  .X.X.XX.  X..X.X.X  X..X.X.X  X.X..X.X  .XX.X..X  .X.XX.X.
    // bit3 .XX.X.X.  .X.XX.X.  X.X.X..X  .XX.X.X.  X.X..X.X  X.X.X..X  .X.XX.X.  X..X.XX.  X..X.XX.  X.X..X.X  X.X.X..X  .XX.X.X.
    // bit4 .X.XX..X  X..X.XX.  .XX..XX.  .X.XX..X  X..XX..X  .XX..XX.  X..X.XX.  .XX..X.X  .XX..X.X  X..XX..X  .XX..XX.  .X.XX..X
    // bit5 .XX.X..X  X..XX.X.  X.X..XX.  .XX.X..X  X..XX..X  X.X..XX.  X..XX.X.  .XX..XX.  .XX..XX.  X..XX..X  X.X..XX.  .XX.X..X
    // bit6 .X.X.XX.  X..X.X.X  .X.XX.X.  .X.X.XX.  .XX.X..X  .X.XX.X.  X..X.X.X  X.X..X.X  X.X..X.X  .XX.X..X  .X.XX.X.  .X.X.XX.
    // bit7 .XX..XX.  X..XX..X  X..XX.X.  .XX..XX.  .XX.X..X  X..XX.X.  X..XX..X  X.X..XX.  X.X..XX.  .XX.X..X  X..XX.X.  .XX..XX.
    // Avalanche: 50.00%

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
        0xCE, 0xC2, 0xF5, 0x40, 0x5B, 0x21, 0xFA, 0xEA, 0x21, 0xC6, 0x9A, 0x01, 0x60, 0x53, 0xE9, 0x94,
        0x1D, 0x44, 0x4B, 0xBB, 0xE7, 0x82, 0x2F, 0x17, 0xF4, 0x59, 0x74, 0x0D, 0x0C, 0x9A, 0x83, 0x6D,
        0x4F, 0x61, 0x3C, 0x01, 0x0F, 0xFE, 0x55, 0xC7, 0x18, 0x29, 0x8C, 0x34, 0x53, 0x18, 0x6E, 0x8E,
        0x98, 0xDE, 0x73, 0x83, 0x23, 0x27, 0x91, 0x3F, 0xBA, 0xC5, 0x22, 0xD1, 0xD6, 0x93, 0xC7, 0x47,
        0xCB, 0x23, 0xE5, 0xF4, 0xB1, 0x55, 0xC9, 0xA3, 0x8B, 0x56, 0x54, 0x31, 0xC6, 0x70, 0xA3, 0x4B,
        0x95, 0x5A, 0x4C, 0x62, 0x7F, 0xEE, 0xDF, 0xCC, 0x8A, 0x6E, 0xD0, 0x1F, 0xD0, 0x08, 0xB4, 0x9B
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x66, 0x66, 0x33, 0x33, 0x33, 0x33, 0x5A, 0x5A, 0x3C, 0x3C, 0x66, 0x66, 0x33, 0x33, 0x33, 0x33,
        0x69, 0x69, 0x0F, 0x0F, 0x3C, 0x3C, 0x0F, 0x0F, 0x55, 0x55, 0x69, 0x69, 0x0F, 0x0F, 0x3C, 0x3C,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x0F, 0x0F, 0x3C, 0x3C, 0x0F, 0x0F, 0x55, 0x55, 0x69, 0x69, 0x0F, 0x0F, 0x3C, 0x3C, 0x0F, 0x0F,
        0x55, 0x55, 0x69, 0x69, 0x0F, 0x0F, 0x3C, 0x3C, 0x0F, 0x0F, 0x55, 0x55, 0x69, 0x69, 0x0F, 0x0F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_H_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_H_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_H_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_H_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_H_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_H_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_I_PasswordJumpXORCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00110010  01001100  10000101  10100001  01101000  01011010  10000101  10100001  00100100  11001001
    // bit2 00000000  00000000  01101000  01011010  11111011  01111110  11011111  10110111  11111011  01111110  10000101  10100001
    // bit3 00000000  00000000  01011010  00010110  01111110  11011111  10110111  11101101  01111110  11011111  10100001  01101000
    // bit4 00000000  00000000  11101101  11111011  01001100  10010011  00100100  11001001  01001100  10010011  11011111  10110111
    // bit5 00000000  00000000  11011111  10110111  11001001  00110010  01001100  10010011  11001001  00110010  11111011  01111110
    // bit6 00000000  00000000  10000101  10100001  10110111  11101101  11111011  01111110  10110111  11101101  01011010  00010110
    // bit7 00000000  00000000  10110111  11101101  00110010  01001100  10010011  00100100  00110010  01001100  01111110  11011111
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X...X.X.  XXX...X.  X...X.X.  XXX...X.  X.X.XXX.  ..X.X.XX  X...X.X.  XXX...X.  ..X.X.XX  X...X.X.  X.X.XXX.  ..X.X.XX
    // bit2 XXX..XX.  ..XXX..X  XXX..XX.  ..XXX..X  .XX...XX  X..XX...  XXX..XX.  ..XXX..X  X..XX...  XXX..XX.  .XX...XX  X..XX...
    // bit3 XX...XX.  .XXX...X  XX...XX.  .XXX...X  .XX..XXX  ...XX..X  XX...XX.  .XXX...X  ...XX..X  XX...XX.  .XX..XXX  ...XX..X
    // bit4 ..X.XXXX  ....X.XX  ..X.XXXX  ....X.XX  XXXX....  X.XXXX..  ..X.XXXX  ....X.XX  X.XXXX..  ..X.XXXX  XXXX....  X.XXXX..
    // bit5 ....XXXX  .X....XX  ....XXXX  .X....XX  XXXX.X..  ..XXXX.X  ....XXXX  .X....XX  ..XXXX.X  ....XXXX  XXXX.X..  ..XXXX.X
    // bit6 .XX...XX  X..XX...  .XX...XX  X..XX...  ..XXX..X  X...XXX.  .XX...XX  X..XX...  X...XXX.  .XX...XX  ..XXX..X  X...XXX.
    // bit7 .X....XX  XX.X....  .X....XX  XX.X....  ..XXXX.X  ....XXXX  .X....XX  XX.X....  ....XXXX  .X....XX  ..XXXX.X  ....XXXX
    // Avalanche: 49.48%

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
        0x23, 0xEF, 0x7F, 0x45, 0xC8, 0x02, 0xEB, 0x38, 0x31, 0xDA, 0x87, 0x60, 0x07, 0x8F, 0x84, 0x2A,
        0xAC, 0x36, 0x45, 0x2F, 0x31, 0xA8, 0xBC, 0xFE, 0x45, 0x09, 0x7B, 0x16, 0x46, 0xE3, 0x6F, 0x07,
        0xF5, 0x53, 0xBF, 0xB3, 0xC3, 0xEC, 0x7B, 0xC0, 0xB2, 0x5D, 0xE1, 0x61, 0x09, 0xEE, 0x30, 0x28,
        0x9C, 0xE6, 0xD3, 0xC0, 0xAD, 0x61, 0x8F, 0xB2, 0x10, 0xEB, 0xDF, 0x34, 0x21, 0x16, 0xA7, 0x79,
        0xEB, 0x0E, 0xB2, 0xF6, 0xDE, 0x11, 0xDD, 0x45, 0xA6, 0x2A, 0x97, 0x7E, 0xB7, 0xE3, 0x15, 0xBF,
        0xF6, 0xBA, 0x6E, 0x56, 0x14, 0x90, 0xD7, 0x8C, 0xEE, 0x1F, 0x5D, 0x4C, 0xEB, 0x3A, 0xCF, 0x34
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x0F, 0x3C, 0x69, 0x55, 0x3C, 0x0F, 0x55, 0x0F, 0x0F, 0x69, 0x0F, 0x3C, 0x69, 0x55, 0x3C, 0x0F,
        0x66, 0x3C, 0x33, 0x33, 0x3C, 0x5A, 0x33, 0x66, 0x5A, 0x33, 0x66, 0x3C, 0x33, 0x33, 0x3C, 0x5A,
        0x33, 0x66, 0x5A, 0x33, 0x66, 0x3C, 0x33, 0x33, 0x3C, 0x5A, 0x33, 0x66, 0x5A, 0x33, 0x66, 0x3C,
        0x66, 0x3C, 0x33, 0x33, 0x3C, 0x5A, 0x33, 0x66, 0x5A, 0x33, 0x66, 0x3C, 0x33, 0x33, 0x3C, 0x5A,
        0x3C, 0x0F, 0x55, 0x0F, 0x0F, 0x69, 0x0F, 0x3C, 0x69, 0x55, 0x3C, 0x0F, 0x55, 0x0F, 0x0F, 0x69
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_I_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_I_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_I_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_I_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_I_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_I_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_J_PasswordJumpXORCipher {

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
        0xC7, 0x28, 0xD5, 0xB4, 0xF9, 0xBA, 0x2B, 0x0E, 0x65, 0x87, 0x80, 0x17, 0xEE, 0xA8, 0x15, 0xED,
        0x1F, 0xE9, 0x28, 0x0A, 0x3A, 0xCB, 0x9A, 0xF9, 0xB0, 0xA9, 0xFB, 0x44, 0x2F, 0xDF, 0x5E, 0x5D,
        0xD3, 0x04, 0x17, 0xF5, 0x49, 0xFC, 0x42, 0x0E, 0xAE, 0x7B, 0x06, 0xDC, 0xCB, 0xA0, 0xD4, 0x58,
        0x89, 0xDE, 0xF9, 0x58, 0xE1, 0x1B, 0xA1, 0xEA, 0x12, 0x17, 0x6E, 0x06, 0x5D, 0xAE, 0xA9, 0x19,
        0x2F, 0x1B, 0x02, 0x2F, 0xEC, 0xEA, 0x5F, 0x40, 0x03, 0xEC, 0x98, 0x9F, 0xA7, 0xB8, 0xD2, 0xFD,
        0x3F, 0x3F, 0x8C, 0x87, 0xD3, 0x0F, 0x39, 0xD6, 0xE0, 0x3E, 0x21, 0xEC, 0x13, 0xD2, 0x25, 0xEC
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_96_J_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_J_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_J_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_J_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_J_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_J_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_K_PasswordJumpXORCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  11111111  11111111  00000000  11111111  00000000  11111111  00000000  00000000  00000000
    // bit2 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  00000000  11111111
    // bit3 00000000  00000000  11111111  00000000  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111
    // bit4 00000000  00000000  00000000  00000000  00000000  11111111  00000000  11111111  00000000  11111111  11111111  11111111
    // bit5 00000000  00000000  00000000  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit6 00000000  00000000  11111111  11111111  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000
    // bit7 00000000  00000000  11111111  00000000  11111111  11111111  00000000  00000000  11111111  11111111  11111111  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit2 X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit3 X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit4 .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X
    // bit5 .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X
    // bit6 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X
    // Avalanche: 50.00%

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
        0x17, 0x5F, 0x84, 0x0A, 0xD2, 0x70, 0xED, 0x1C, 0x4E, 0xB3, 0x52, 0xF1, 0x88, 0xD3, 0x12, 0x96,
        0xF6, 0xCE, 0x85, 0x18, 0x1F, 0xD1, 0x0B, 0x33, 0xC2, 0xD7, 0x9C, 0xD7, 0xA8, 0xFB, 0xC1, 0xB1,
        0xA4, 0x3E, 0x47, 0x74, 0x6B, 0x7F, 0x1A, 0x69, 0x68, 0xA0, 0x7D, 0x16, 0xBE, 0x2B, 0x6A, 0x3D,
        0xE9, 0x96, 0x05, 0x03, 0xF1, 0x8E, 0x7F, 0xE7, 0x54, 0x2F, 0x10, 0xE7, 0x16, 0x75, 0xCA, 0x9B,
        0xFD, 0x46, 0xFA, 0x41, 0xE0, 0x73, 0x02, 0x54, 0x75, 0xED, 0x57, 0x2E, 0x6B, 0x9F, 0x49, 0x2C,
        0xDA, 0xBF, 0xF8, 0x2E, 0x35, 0x5A, 0xF5, 0x36, 0x57, 0x31, 0x95, 0xF7, 0x02, 0x44, 0xA2, 0xF7
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66,
        0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F,
        0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x66, 0x3C, 0x3C, 0x3C, 0x3C, 0x3C, 0x3C, 0x3C, 0x3C,
        0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F,
        0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x3C, 0x3C, 0x3C, 0x3C, 0x3C, 0x3C, 0x3C, 0x3C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_K_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_K_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_K_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_K_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_K_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_K_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_L_PasswordJumpXORCipher {

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
    // bit0 00000000  00000000  10110110  11011011  10110110  11011011  01101101  10110110  00000000  00000000  01101101  10110110
    // bit1 00000000  00000000  11110110  11011110  11111101  00001011  00000111  10110110  00000000  00000000  01101101  01011111
    // bit2 00000000  00000000  10111101  01111110  01000010  10000100  10111101  11101011  00000000  00000000  11111101  01010110
    // bit3 00000000  00000000  11111101  01111011  00001001  01010100  11010111  11101011  00000000  00000000  11111101  10111111
    // bit4 00000000  00000000  11100000  01011010  11100000  01110101  10111111  10100000  00000000  00000000  11111010  01010110
    // bit5 00000000  00000000  10100000  01011111  10101011  10100101  11010101  10100000  00000000  00000000  11111010  10111111
    // bit6 00000000  00000000  11101011  11111111  00010100  00101010  01101111  11111101  00000000  00000000  01101010  10110110
    // bit7 00000000  00000000  10101011  11111010  01011111  11111010  00000101  11111101  00000000  00000000  01101010  01011111
    //
    // Avalanche:
    // bit0 X....X.X  XXX.X...  XXX.X...  .X.XXXX.  .X.XXXX.  X....X.X  XXX.X...  .X.XXXX.  .X.XXXX.  X....X.X  X....X.X  XXX.X...
    // bit1 X....X.X  .X.X.X.X  X.X.X...  .X.XXXX.  .X.X.X.X  .X.X.X.X  X.X.X...  .X.XXXX.  .X.X.X.X  .X.X.X.X  X....X.X  .X.X.X.X
    // bit2 X.X.X.X.  X.X.X...  XXX.X...  .......X  X.X.X.X.  X....X.X  XXX.X...  .......X  X.X.X.X.  X....X.X  X.X.X.X.  X.X.X...
    // bit3 X.X.X.X.  ...X.X.X  X.X.X...  .......X  X.X....X  .X.X.X.X  X.X.X...  .......X  X.X....X  .X.X.X.X  X.X.X.X.  ...X.X.X
    // bit4 .X.X....  X.X.X...  XXX.X.X.  XXXX.X.X  ....X.X.  X.......  XXX.X.X.  XXXX.X.X  ....X.X.  X.......  .X.X....  X.X.X...
    // bit5 .X.X....  ...X.X.X  X.X.X.X.  XXXX.X.X  .......X  .X.X....  X.X.X.X.  XXXX.X.X  .......X  .X.X....  .X.X....  ...X.X.X
    // bit6 .XXXXXXX  XXX.X...  XXX.X.X.  X.X.X.X.  XXXXXXX.  X.......  XXX.X.X.  X.X.X.X.  XXXXXXX.  X.......  .XXXXXXX  XXX.X...
    // bit7 .XXXXXXX  .X.X.X.X  X.X.X.X.  X.X.X.X.  XXXX.X.X  .X.X....  X.X.X.X.  X.X.X.X.  XXXX.X.X  .X.X....  .XXXXXXX  .X.X.X.X
    // Avalanche: 45.83%

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
        0x80, 0x74, 0xAC, 0x92, 0xA4, 0xAC, 0xF0, 0x06, 0x46, 0x5E, 0x34, 0x51, 0x8C, 0x7E, 0x1B, 0x62,
        0x8B, 0x3B, 0x87, 0xC3, 0xBE, 0xFF, 0xF7, 0xE9, 0x8B, 0xD5, 0x54, 0xA5, 0x6E, 0xCD, 0x21, 0x58,
        0x57, 0xEB, 0x6D, 0x3F, 0x75, 0x4F, 0x4A, 0x32, 0xA0, 0x49, 0xFD, 0x04, 0xAA, 0x12, 0x69, 0x69,
        0x64, 0x4C, 0x06, 0x30, 0xEA, 0x8C, 0x20, 0x24, 0x52, 0x41, 0xFE, 0xD6, 0x31, 0x63, 0x28, 0x0A,
        0x9E, 0x66, 0xD1, 0x2F, 0x09, 0xFA, 0x55, 0x4E, 0x00, 0x87, 0x02, 0x69, 0x6E, 0xC4, 0x6F, 0x30,
        0x91, 0x7A, 0x6F, 0x56, 0xDF, 0x4B, 0x8F, 0xE4, 0x48, 0x0C, 0x16, 0x3F, 0xE9, 0x6E, 0x14, 0xA4
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xFF, 0x5A, 0xFF, 0xF0, 0x33, 0xF0, 0xC3, 0x33, 0xC3, 0xFF, 0x33, 0xFF, 0xFF, 0x66, 0xFF, 0x96,
        0xCC, 0x69, 0xCC, 0xC3, 0x55, 0xC3, 0xA5, 0x55, 0xA5, 0x99, 0x0F, 0x99, 0xC3, 0x3C, 0xC3, 0xCC,
        0x3C, 0x96, 0xAA, 0x3C, 0xAA, 0xFF, 0x5A, 0xFF, 0xFF, 0x33, 0xFF, 0xC3, 0x33, 0xC3, 0xF0, 0x33,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x3C, 0xFF, 0xFF, 0x3C, 0xFF, 0xF0, 0x0F, 0xF0, 0x96, 0x69, 0x96, 0xFF, 0x55, 0xFF, 0xFF, 0x55
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_L_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_L_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_L_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_L_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_L_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_96_L_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_A_PasswordJumpXORCipher {

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
        0x11, 0xAB, 0x4A, 0x40, 0x8B, 0x77, 0xC8, 0x47, 0xF1, 0x77, 0x54, 0x4C, 0xE7, 0xBC, 0x28, 0x63,
        0x0C, 0xC7, 0xB7, 0x21, 0x02, 0x6A, 0x24, 0xCC, 0x3E, 0x19, 0x7F, 0x40, 0x13, 0x05, 0x90, 0x63,
        0x3B, 0x21, 0xDD, 0x3E, 0xDD, 0x58, 0x6F, 0xEA, 0x1E, 0x10, 0xEA, 0x1C, 0x85, 0x1C, 0xDB, 0xF8,
        0x5F, 0xD4, 0x82, 0xE8, 0x6F, 0x41, 0xE8, 0xEC, 0x93, 0xF7, 0xEC, 0xFE, 0x02, 0x7D, 0x5E, 0xB9,
        0x63, 0x5C, 0x17, 0x57, 0x4A, 0x85, 0x14, 0xFD, 0x02, 0xDF, 0x7A, 0x78, 0x87, 0x13, 0xCD, 0xB6,
        0x6C, 0x9D, 0xB2, 0xD7, 0x84, 0xB6, 0xB5, 0x10, 0xE9, 0x2A, 0x38, 0x79, 0x8F, 0x58, 0xC7, 0xF6,
        0x9A, 0x03, 0xD7, 0x33, 0x8B, 0xF0, 0xED, 0x2C, 0x0F, 0x79, 0xD9, 0xE7, 0xEE, 0xAE, 0x36, 0x65,
        0xCB, 0xE8, 0x2E, 0xE1, 0xAD, 0xD2, 0x33, 0x2B, 0xE5, 0x3C, 0x0C, 0xB7, 0xA3, 0x84, 0x64, 0x73
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_128_A_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_A_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_A_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_A_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_A_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_A_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_B_PasswordJumpXORCipher {

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
        0x22, 0xEE, 0x6F, 0x15, 0x06, 0xEE, 0x6D, 0xC3, 0x9C, 0x7D, 0xA6, 0x26, 0x0C, 0x68, 0xAC, 0x4C,
        0x08, 0x63, 0x70, 0x91, 0x00, 0x52, 0x79, 0x52, 0x43, 0x4A, 0x10, 0xE0, 0x80, 0x04, 0xE5, 0x57,
        0x22, 0x1C, 0x3D, 0xAE, 0x34, 0xEB, 0x62, 0xD0, 0xCF, 0x39, 0x26, 0x38, 0xE2, 0x17, 0x99, 0x10,
        0xA4, 0x5E, 0x53, 0x1D, 0x12, 0x63, 0xE4, 0xE9, 0x53, 0x13, 0x40, 0x40, 0xA1, 0x21, 0xC3, 0xDE,
        0x71, 0x88, 0x45, 0xBD, 0x7A, 0xC5, 0xD9, 0xE7, 0xAF, 0x46, 0x42, 0x64, 0x68, 0x2F, 0xE4, 0x15,
        0x1A, 0x48, 0x56, 0x04, 0xA0, 0x1E, 0xE5, 0x50, 0x36, 0xF0, 0xBF, 0xE8, 0x24, 0xEB, 0xDC, 0x51,
        0xB5, 0x8C, 0x56, 0x31, 0x33, 0x37, 0x73, 0xA1, 0xE3, 0x11, 0xA0, 0xD5, 0xA8, 0x70, 0xA1, 0x46,
        0x5F, 0xE2, 0x3F, 0x6A, 0x72, 0xCF, 0xAC, 0xD0, 0x27, 0x82, 0xFC, 0x41, 0xB3, 0x54, 0x25, 0x87
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_128_B_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_B_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_B_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_B_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_B_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_B_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_C_PasswordJumpXORCipher {

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
        0x52, 0xFC, 0x3D, 0x27, 0xF5, 0xF9, 0xD1, 0x0D, 0x72, 0x02, 0x29, 0x18, 0x92, 0x89, 0x49, 0x49,
        0xAB, 0xF0, 0xB6, 0x94, 0xF3, 0xE4, 0x6F, 0x49, 0x6D, 0x49, 0x3F, 0x66, 0x91, 0xD2, 0x82, 0xDB,
        0xA3, 0x2A, 0xB2, 0x44, 0xAD, 0x4D, 0xEC, 0x77, 0xF1, 0xB2, 0x88, 0x31, 0x5E, 0x46, 0x92, 0x1F,
        0xF3, 0x23, 0x80, 0x00, 0x27, 0xAE, 0xB8, 0xF4, 0xC4, 0xD4, 0x38, 0xCE, 0xAD, 0xED, 0x8E, 0xC9,
        0x8C, 0x3F, 0x61, 0x67, 0x33, 0xF1, 0x0B, 0x73, 0xFE, 0x97, 0x95, 0x41, 0x59, 0x1B, 0xE9, 0xC6,
        0xC5, 0x04, 0x33, 0x70, 0x4E, 0xAD, 0xB9, 0x9C, 0x18, 0xAF, 0x5C, 0x3D, 0x62, 0x30, 0xE4, 0x81,
        0x4B, 0x7B, 0x11, 0x15, 0x83, 0x94, 0x68, 0x48, 0x37, 0x61, 0xA3, 0x7A, 0x11, 0x32, 0x78, 0xEF,
        0x54, 0xF8, 0xCE, 0xD3, 0xDC, 0xAA, 0x96, 0xE6, 0x70, 0x44, 0x1C, 0x67, 0xDB, 0x0E, 0x4F, 0xC4
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_128_C_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_C_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_C_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_C_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_C_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_C_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_D_PasswordJumpXORCipher {

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
        0x8F, 0x50, 0x7C, 0x59, 0x52, 0x45, 0x23, 0x98, 0xA9, 0xDE, 0xAE, 0xE9, 0x68, 0xDF, 0xFA, 0xF2,
        0xB2, 0xBD, 0x6C, 0xEE, 0x44, 0xB5, 0x00, 0x8C, 0x39, 0x3F, 0x09, 0x35, 0x34, 0x11, 0x36, 0x0D,
        0xAA, 0x63, 0xD3, 0x9D, 0x3F, 0xDB, 0xA6, 0x7F, 0x63, 0xFA, 0x1B, 0xEA, 0xFC, 0xB1, 0x5E, 0x58,
        0xED, 0xF7, 0xED, 0xCB, 0x75, 0x78, 0xF8, 0x83, 0xF4, 0x2A, 0xB6, 0x07, 0x8E, 0xC5, 0x0C, 0xBC,
        0xFF, 0x96, 0xB8, 0x9D, 0x54, 0x29, 0xFC, 0xF5, 0xD8, 0xF5, 0x9B, 0xC1, 0xDA, 0xB0, 0x2E, 0xC1,
        0x2E, 0xD8, 0x66, 0x8E, 0xE8, 0xFC, 0x44, 0x36, 0x77, 0xC2, 0x3D, 0x0E, 0xED, 0x80, 0x8B, 0x40,
        0x7A, 0x16, 0xA1, 0xFF, 0x63, 0x25, 0x36, 0xF4, 0xC7, 0x26, 0x1E, 0xE7, 0x64, 0x21, 0x61, 0x96,
        0xBA, 0x16, 0x37, 0xA5, 0xA6, 0x63, 0x78, 0xE7, 0xA9, 0x13, 0x9F, 0x61, 0xE2, 0x71, 0xFA, 0xFC
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_128_D_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_D_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_D_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_D_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_D_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_D_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_E_PasswordJumpXORCipher {

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
        0x68, 0x20, 0xBA, 0xBA, 0xD8, 0xF3, 0x2F, 0x0B, 0x11, 0x66, 0x0A, 0x2C, 0xA4, 0x5C, 0x8F, 0x1E,
        0x4A, 0x1C, 0x96, 0x0D, 0x37, 0x2C, 0x84, 0xC1, 0x7D, 0x18, 0xCC, 0x48, 0x65, 0x73, 0xD2, 0xBC,
        0xFE, 0x3F, 0x38, 0x1A, 0xA2, 0x17, 0xB2, 0xA1, 0x8B, 0x80, 0xDC, 0x83, 0xD0, 0x6A, 0x7B, 0x4C,
        0x0E, 0xCC, 0x9A, 0x1B, 0x9D, 0x8D, 0xE3, 0x48, 0x8B, 0x28, 0xE2, 0x7D, 0x6E, 0xF2, 0x3B, 0xCB,
        0x0B, 0x78, 0x0C, 0xB4, 0x58, 0x38, 0xD4, 0x80, 0xC4, 0x00, 0xA0, 0xAC, 0xAB, 0xC3, 0xD9, 0xC8,
        0x2F, 0x80, 0x45, 0xEB, 0x18, 0x66, 0x90, 0x76, 0x58, 0xDB, 0x36, 0x2C, 0xED, 0x50, 0xBF, 0xE9,
        0xAA, 0xC3, 0xCC, 0xF4, 0x92, 0x3B, 0xDA, 0xEC, 0x86, 0xEB, 0x4A, 0x8E, 0xA2, 0xFF, 0x2F, 0xC4,
        0xCC, 0xED, 0x6E, 0xB3, 0x75, 0x4D, 0x39, 0xD2, 0x6D, 0xA7, 0x5E, 0x11, 0xA8, 0x21, 0xC0, 0x49
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_128_E_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_E_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_E_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_E_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_E_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_E_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_F_PasswordJumpXORCipher {

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
        0xA8, 0x72, 0xCD, 0x5F, 0x61, 0x5F, 0x5C, 0x06, 0x90, 0xED, 0x77, 0xCF, 0xA8, 0xDC, 0x0F, 0xA2,
        0xC2, 0x5D, 0x35, 0x4A, 0x3A, 0xB2, 0x62, 0xF1, 0x22, 0x63, 0xC5, 0x53, 0x23, 0xCA, 0x54, 0xDC,
        0xEB, 0x8A, 0xE3, 0xF0, 0xA1, 0xD3, 0xA7, 0x70, 0x1A, 0x69, 0x84, 0x93, 0x07, 0x3E, 0x2E, 0x13,
        0xC2, 0x7E, 0xCE, 0xC3, 0x9D, 0x2C, 0x9F, 0x7A, 0x4D, 0x6F, 0x86, 0x62, 0x49, 0x21, 0xE5, 0x8D,
        0x53, 0x30, 0xB5, 0x03, 0x98, 0x42, 0x1C, 0xBD, 0x96, 0xCA, 0xFE, 0x2D, 0xDB, 0x89, 0xDD, 0x6F,
        0xA4, 0xB0, 0x33, 0x2F, 0x4E, 0xA0, 0x60, 0x79, 0x48, 0xBB, 0x2C, 0x7B, 0xCA, 0x1F, 0x75, 0x35,
        0xE5, 0x43, 0x9F, 0xAD, 0xD4, 0xEB, 0x2A, 0x31, 0x5C, 0x8E, 0x7B, 0x57, 0x59, 0xE4, 0xF5, 0x0A,
        0xBE, 0xC5, 0x7E, 0x53, 0xB5, 0x2D, 0x57, 0x4A, 0x14, 0x14, 0x4A, 0x24, 0xF2, 0x32, 0x1C, 0xC6
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_128_F_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_F_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_F_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_F_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_F_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_F_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_G_PasswordJumpXORCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  11000011  00110000  11001100  00110011  11000000  11110000  00110011  00001100  00000000  00000000  11000011  00110000  00001111  00000011
    // bit2 00000000  00000000  00111111  11001111  11110011  11111100  00001100  11000011  11111100  11111111  00000000  00000000  00111111  11001111  11001100  00110011
    // bit3 00000000  00000000  11111100  11111111  00111111  11001111  11001100  00110011  11001111  11110011  00000000  00000000  11111100  11111111  11000011  00110000
    // bit4 00000000  00000000  11000000  11110000  00111100  00001111  00111111  11001111  00001111  00000011  00000000  00000000  11000000  11110000  11111100  11111111
    // bit5 00000000  00000000  00000011  11000000  11110000  00111100  11111111  00111111  00111100  00001111  00000000  00000000  00000011  11000000  11110011  11111100
    // bit6 00000000  00000000  11111111  00111111  11001111  11110011  00110011  00001100  11110011  11111100  00000000  00000000  11111111  00111111  00110000  11001100
    // bit7 00000000  00000000  00111100  00001111  00000011  11000000  11110011  11111100  11000000  11110000  00000000  00000000  00111100  00001111  00111111  11001111
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X..X  X.X.X.X.  X.X.X..X  X.X.X.X.  .XX.X.X.  X..XX.X.  .XX.X.X.  X..XX.X.  X.X.X..X  X.X.X.X.  X.X.X..X  X.X.X.X.  X.X.X..X  X.X.X.X.  X.X.X..X  X.X.X.X.
    // bit2 X..X.XX.  X.X..X.X  X..X.XX.  X.X..X.X  X.X.X..X  .XX.X.X.  X.X.X..X  .XX.X.X.  X..X.XX.  X.X..X.X  X..X.XX.  X.X..X.X  X..X.XX.  X.X..X.X  X..X.XX.  X.X..X.X
    // bit3 X..X.X.X  X.X..X.X  X..X.X.X  X.X..X.X  .XX.X..X  .X.XX.X.  .XX.X..X  .X.XX.X.  X..X.X.X  X.X..X.X  X..X.X.X  X.X..X.X  X..X.X.X  X.X..X.X  X..X.X.X  X.X..X.X
    // bit4 .XX..XX.  X..XX..X  .XX..XX.  X..XX..X  X.X..XX.  .XX.X..X  X.X..XX.  .XX.X..X  .XX..XX.  X..XX..X  .XX..XX.  X..XX..X  .XX..XX.  X..XX..X  .XX..XX.  X..XX..X
    // bit5 .XX..X.X  X..XX..X  .XX..X.X  X..XX..X  .XX..XX.  .X.XX..X  .XX..XX.  .X.XX..X  .XX..X.X  X..XX..X  .XX..X.X  X..XX..X  .XX..X.X  X..XX..X  .XX..X.X  X..XX..X
    // bit6 .X.XX.X.  X..X.XX.  .X.XX.X.  X..X.XX.  X.X..X.X  X.X.X..X  X.X..X.X  X.X.X..X  .X.XX.X.  X..X.XX.  .X.XX.X.  X..X.XX.  .X.XX.X.  X..X.XX.  .X.XX.X.  X..X.XX.
    // bit7 .X.XX..X  X..X.XX.  .X.XX..X  X..X.XX.  .XX..X.X  X..XX..X  .XX..X.X  X..XX..X  .X.XX..X  X..X.XX.  .X.XX..X  X..X.XX.  .X.XX..X  X..X.XX.  .X.XX..X  X..X.XX.
    // Avalanche: 50.00%

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
        0x80, 0x56, 0x10, 0x52, 0xD8, 0x58, 0x00, 0xD0, 0xD0, 0x0D, 0xF2, 0x4E, 0x55, 0x9E, 0xCE, 0x3E,
        0x4B, 0x15, 0x91, 0x75, 0xC8, 0x9F, 0x7D, 0xAE, 0xC0, 0x1B, 0x9D, 0x94, 0x60, 0x5E, 0x82, 0x5B,
        0xFC, 0xF5, 0xEF, 0xE6, 0x04, 0x72, 0xE7, 0xF0, 0x58, 0xF3, 0x22, 0x51, 0x9A, 0x8F, 0x25, 0x7E,
        0xD3, 0x4E, 0x2B, 0x62, 0xA3, 0xCC, 0x1D, 0x35, 0x0D, 0xBC, 0xD0, 0xE2, 0x0B, 0x79, 0x23, 0x73,
        0x28, 0xC4, 0xB1, 0x3B, 0x63, 0x82, 0xF7, 0xA7, 0x38, 0xB0, 0x66, 0x4B, 0xBA, 0x10, 0x8E, 0xCF,
        0x57, 0x94, 0x56, 0x38, 0xFB, 0xB8, 0x1A, 0x56, 0x81, 0x08, 0x8C, 0xF3, 0xF1, 0x31, 0x5F, 0x8E,
        0xCD, 0xFD, 0x77, 0x5F, 0xDF, 0x03, 0xF8, 0xCA, 0x1F, 0x03, 0x0F, 0xA7, 0x9F, 0xDE, 0x3D, 0x40,
        0x79, 0x4E, 0x06, 0x5F, 0xA2, 0x49, 0xAF, 0x64, 0x60, 0xDE, 0x76, 0x87, 0xF6, 0x2C, 0x86, 0xF9
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x5A, 0x5A, 0x33, 0x33, 0x33, 0x33, 0x66, 0x66, 0x3C, 0x3C, 0x5A, 0x5A, 0x33, 0x33, 0x33, 0x33,
        0x66, 0x66, 0x3C, 0x3C, 0x5A, 0x5A, 0x33, 0x33, 0x33, 0x33, 0x66, 0x66, 0x3C, 0x3C, 0x5A, 0x5A,
        0x55, 0x55, 0x0F, 0x0F, 0x3C, 0x3C, 0x0F, 0x0F, 0x69, 0x69, 0x55, 0x55, 0x0F, 0x0F, 0x3C, 0x3C,
        0x33, 0x33, 0x66, 0x66, 0x3C, 0x3C, 0x5A, 0x5A, 0x33, 0x33, 0x33, 0x33, 0x66, 0x66, 0x3C, 0x3C,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x5A, 0x5A, 0x33, 0x33, 0x33, 0x33, 0x66, 0x66, 0x3C, 0x3C, 0x5A, 0x5A, 0x33, 0x33, 0x33, 0x33,
        0x3C, 0x3C, 0x0F, 0x0F, 0x69, 0x69, 0x55, 0x55, 0x0F, 0x0F, 0x3C, 0x3C, 0x0F, 0x0F, 0x69, 0x69
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_G_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_G_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_G_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_G_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_G_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_G_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_H_PasswordJumpXORCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  11001100  00110011  00110000  11001100  00000000  00000000  00000000  00000000  11000000  11110000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00111111  11001111  11111111  00111111  00000000  00000000  00000000  00000000  11001100  00110011
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  11110011  11111100  11001111  11110011  00000000  00000000  00000000  00000000  00001100  11000011
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  11110000  00111100  11000000  11110000  00000000  00000000  00000000  00000000  11111111  00111111
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00111100  00001111  11110000  00111100  00000000  00000000  00000000  00000000  00111111  11001111
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  11001111  11110011  00111111  11001111  00000000  00000000  00000000  00000000  00110011  00001100
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000011  11000000  00001111  00000011  00000000  00000000  00000000  00000000  11110011  11111100
    //
    // Avalanche:
    // bit0 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit1 .XX..X.X  .X.XX..X  .X.X.XX.  .X.X.X.X  X..X.X.X  .XX..X.X  X..X.X.X  .XX..X.X  .XX..X.X  .X.XX..X  .XX..X.X  .X.XX..X  .X.X.XX.  .X.X.X.X  .X.X.X.X  X..X.X.X
    // bit2 .X.XX.X.  .X.X.XX.  X..X.X.X  X.X..X.X  .XX.X..X  .X.XX.X.  .XX.X..X  .X.XX.X.  .X.XX.X.  .X.X.XX.  .X.XX.X.  .X.X.XX.  X..X.X.X  X.X..X.X  X.X..X.X  .XX.X..X
    // bit3 .XX.X.X.  .X.XX.X.  X..X.XX.  X.X..X.X  X.X.X..X  .XX.X.X.  X.X.X..X  .XX.X.X.  .XX.X.X.  .X.XX.X.  .XX.X.X.  .X.XX.X.  X..X.XX.  X.X..X.X  X.X..X.X  X.X.X..X
    // bit4 .X.XX..X  X..X.XX.  .XX..X.X  X..XX..X  .XX..XX.  .X.XX..X  .XX..XX.  .X.XX..X  .X.XX..X  X..X.XX.  .X.XX..X  X..X.XX.  .XX..X.X  X..XX..X  X..XX..X  .XX..XX.
    // bit5 .XX.X..X  X..XX.X.  .XX..XX.  X..XX..X  X.X..XX.  .XX.X..X  X.X..XX.  .XX.X..X  .XX.X..X  X..XX.X.  .XX.X..X  X..XX.X.  .XX..XX.  X..XX..X  X..XX..X  X.X..XX.
    // bit6 .X.X.XX.  X..X.X.X  X.X..X.X  .XX.X..X  .X.XX.X.  .X.X.XX.  .X.XX.X.  .X.X.XX.  .X.X.XX.  X..X.X.X  .X.X.XX.  X..X.X.X  X.X..X.X  .XX.X..X  .XX.X..X  .X.XX.X.
    // bit7 .XX..XX.  X..XX..X  X.X..XX.  .XX.X..X  X..XX.X.  .XX..XX.  X..XX.X.  .XX..XX.  .XX..XX.  X..XX..X  .XX..XX.  X..XX..X  X.X..XX.  .XX.X..X  .XX.X..X  X..XX.X.
    // Avalanche: 50.00%

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
        0x61, 0xD1, 0x98, 0xBE, 0x1D, 0x29, 0xCE, 0xE6, 0x66, 0xD9, 0x66, 0x63, 0x3D, 0x7C, 0xB4, 0x04,
        0x27, 0xFF, 0xC5, 0x30, 0x35, 0xB3, 0x0D, 0x43, 0xBA, 0xC5, 0x03, 0x68, 0x6F, 0x77, 0xE9, 0x8F,
        0x65, 0x5B, 0xC1, 0x70, 0xFA, 0x51, 0xD0, 0x00, 0x76, 0x14, 0x93, 0x2F, 0x20, 0xE9, 0x25, 0x32,
        0x5C, 0x09, 0x2B, 0x5F, 0x04, 0x84, 0xF7, 0xDF, 0x1B, 0x2F, 0xD5, 0x1F, 0xD3, 0x05, 0xAC, 0x0A,
        0xF9, 0x4A, 0x51, 0x78, 0xF3, 0xAE, 0x94, 0xEB, 0xE6, 0xBE, 0xC6, 0x93, 0x4E, 0xD0, 0x3F, 0x2C,
        0x69, 0xE8, 0x3B, 0x89, 0xBE, 0xCD, 0x96, 0xB1, 0xFF, 0xAB, 0x45, 0x5F, 0x79, 0x0D, 0xA8, 0xB4,
        0xE3, 0x02, 0x0C, 0xAD, 0x27, 0x6E, 0xC6, 0xBE, 0x0F, 0x65, 0x21, 0x33, 0xF0, 0x7C, 0xC5, 0xB3,
        0x9A, 0xBD, 0x4E, 0x25, 0x0F, 0xF8, 0x0C, 0xDC, 0xBE, 0x39, 0xC6, 0xAE, 0x3F, 0x35, 0xD8, 0x61
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x5A, 0x5A, 0x3C, 0x3C, 0x66, 0x66, 0x33, 0x33, 0x33, 0x33, 0x5A, 0x5A, 0x3C, 0x3C, 0x66, 0x66,
        0x3C, 0x3C, 0x66, 0x66, 0x33, 0x33, 0x33, 0x33, 0x5A, 0x5A, 0x3C, 0x3C, 0x66, 0x66, 0x33, 0x33,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x69, 0x69, 0x0F, 0x0F, 0x3C, 0x3C, 0x0F, 0x0F, 0x55, 0x55, 0x69, 0x69, 0x0F, 0x0F, 0x3C, 0x3C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_H_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_H_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_H_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_H_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_H_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_H_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_I_PasswordJumpXORCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  01001100  10010011  10000101  10100001  10100001  01101000  00000000  00000000  10010011  00100100
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  01011010  00010110  11111011  01111110  01111110  11011111  00000000  00000000  00010110  10000101
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00010110  10000101  01111110  11011111  11011111  10110111  00000000  00000000  10000101  10100001
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  11111011  01111110  01001100  10010011  10010011  00100100  00000000  00000000  01111110  11011111
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  10110111  11101101  11001001  00110010  00110010  01001100  00000000  00000000  11101101  11111011
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  10100001  01101000  10110111  11101101  11101101  11111011  00000000  00000000  01101000  01011010
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  11101101  11111011  00110010  01001100  01001100  10010011  00000000  00000000  11111011  01111110
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X...X.X.  XXX...X.  X.XXX...  X.X.XXX.  ..X.X.XX  X...X.X.  X.X.XXX.  ..X.X.XX  ..X.X.XX  X...X.X.  ..X.X.XX  X...X.X.  X.XXX...  X.X.XXX.  X.XXX...  X.X.XXX.
    // bit2 XXX..XX.  ..XXX..X  X...XXX.  .XX...XX  X..XX...  XXX..XX.  .XX...XX  X..XX...  X..XX...  XXX..XX.  X..XX...  XXX..XX.  X...XXX.  .XX...XX  X...XXX.  .XX...XX
    // bit3 XX...XX.  .XXX...X  X..XXX..  .XX..XXX  ...XX..X  XX...XX.  .XX..XXX  ...XX..X  ...XX..X  XX...XX.  ...XX..X  XX...XX.  X..XXX..  .XX..XXX  X..XXX..  .XX..XXX
    // bit4 ..X.XXXX  ....X.XX  XX....X.  XXXX....  X.XXXX..  ..X.XXXX  XXXX....  X.XXXX..  X.XXXX..  ..X.XXXX  X.XXXX..  ..X.XXXX  XX....X.  XXXX....  XX....X.  XXXX....
    // bit5 ....XXXX  .X....XX  XX.X....  XXXX.X..  ..XXXX.X  ....XXXX  XXXX.X..  ..XXXX.X  ..XXXX.X  ....XXXX  ..XXXX.X  ....XXXX  XX.X....  XXXX.X..  XX.X....  XXXX.X..
    // bit6 .XX...XX  X..XX...  XXX..XX.  ..XXX..X  X...XXX.  .XX...XX  ..XXX..X  X...XXX.  X...XXX.  .XX...XX  X...XXX.  .XX...XX  XXX..XX.  ..XXX..X  XXX..XX.  ..XXX..X
    // bit7 .X....XX  XX.X....  XXXX.X..  ..XXXX.X  ....XXXX  .X....XX  ..XXXX.X  ....XXXX  ....XXXX  .X....XX  ....XXXX  .X....XX  XXXX.X..  ..XXXX.X  XXXX.X..  ..XXXX.X
    // Avalanche: 51.17%

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
        0xFE, 0xA9, 0xE5, 0xA6, 0xE8, 0x64, 0x70, 0xD9, 0x8A, 0x85, 0x78, 0x7F, 0xE0, 0xC7, 0x7B, 0x8E,
        0xFE, 0x99, 0x15, 0x35, 0xAD, 0x34, 0x44, 0x7A, 0x3C, 0x01, 0x48, 0xC6, 0x73, 0x88, 0x6E, 0xB0,
        0x4C, 0x65, 0x6E, 0xA7, 0xCD, 0xE8, 0xD9, 0xC0, 0xC0, 0x1A, 0xA5, 0x4F, 0xED, 0x6A, 0xD6, 0xA4,
        0x93, 0x43, 0x78, 0xB5, 0x4F, 0x4E, 0x6E, 0x25, 0x28, 0x7D, 0x4A, 0x20, 0xED, 0x10, 0x9A, 0x0A,
        0xCA, 0x27, 0xAF, 0x08, 0xC9, 0xF9, 0xBC, 0xEB, 0xCA, 0xD1, 0x24, 0xFB, 0x07, 0x7C, 0xCB, 0xAB,
        0xE6, 0xE3, 0x43, 0x6A, 0x39, 0x1A, 0xC5, 0x0F, 0x8A, 0x1D, 0xF7, 0xF4, 0xDC, 0x96, 0x3E, 0x71,
        0x97, 0xD3, 0x9F, 0x32, 0x0E, 0x56, 0xBD, 0x46, 0x23, 0x35, 0x7E, 0xC3, 0xA9, 0x0E, 0xF7, 0xCC,
        0x3D, 0xBD, 0x1A, 0xD1, 0x4C, 0xE8, 0x18, 0xB8, 0x93, 0x90, 0x96, 0xF7, 0xC3, 0x95, 0x7C, 0x06
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x0F, 0x69, 0x0F, 0x3C, 0x69, 0x55, 0x3C, 0x0F, 0x55, 0x0F, 0x0F, 0x69, 0x0F, 0x3C, 0x69, 0x55,
        0x66, 0x3C, 0x33, 0x33, 0x3C, 0x5A, 0x33, 0x66, 0x5A, 0x33, 0x66, 0x3C, 0x33, 0x33, 0x3C, 0x5A,
        0x5A, 0x33, 0x66, 0x3C, 0x33, 0x33, 0x3C, 0x5A, 0x33, 0x66, 0x5A, 0x33, 0x66, 0x3C, 0x33, 0x33,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x55, 0x0F, 0x0F, 0x69, 0x0F, 0x3C, 0x69, 0x55, 0x3C, 0x0F, 0x55, 0x0F, 0x0F, 0x69, 0x0F, 0x3C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_I_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_I_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_I_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_I_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_I_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_I_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_J_PasswordJumpXORCipher {

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
        0xBA, 0x07, 0x75, 0x1F, 0xA3, 0xD8, 0xE1, 0xFA, 0x3A, 0x44, 0xD9, 0xF8, 0x41, 0x76, 0x36, 0xD0,
        0xEB, 0x12, 0xBD, 0x6F, 0x57, 0xDF, 0x1F, 0xCF, 0xBC, 0xB1, 0x65, 0x52, 0x20, 0x74, 0x14, 0x6E,
        0x52, 0xD7, 0x40, 0xBD, 0x86, 0x23, 0x15, 0xE0, 0x04, 0x30, 0x23, 0x6D, 0xAC, 0x4F, 0xF8, 0x2F,
        0x90, 0x09, 0x4B, 0x39, 0xAA, 0xED, 0x89, 0xDF, 0xF4, 0xF3, 0x1C, 0x40, 0xE8, 0xB8, 0xF5, 0x89,
        0x9F, 0x8E, 0x54, 0x26, 0xD5, 0x7B, 0x78, 0xEC, 0xB3, 0x93, 0xD8, 0x80, 0x43, 0x3A, 0xAF, 0xC7,
        0x82, 0x17, 0xEA, 0x29, 0xDE, 0x77, 0x9B, 0xB8, 0x5F, 0x07, 0xA0, 0x46, 0x87, 0xA1, 0x77, 0x99,
        0xD9, 0x14, 0x87, 0xA7, 0xEE, 0x99, 0xEB, 0x95, 0xEF, 0x8D, 0xCB, 0x07, 0x4A, 0x8B, 0xA0, 0x56,
        0x24, 0xF4, 0xAB, 0x8B, 0x8A, 0x86, 0x08, 0x7E, 0x27, 0xD3, 0x73, 0x04, 0x6B, 0x4A, 0x71, 0x9D
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_128_J_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_J_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_J_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_J_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_J_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_J_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_K_PasswordJumpXORCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  11111111  00000000  00000000  11111111  11111111  00000000  00000000  00000000  00000000  11111111  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  11111111  00000000  00000000  00000000  00000000  00000000  11111111  11111111  11111111
    // bit3 00000000  00000000  00000000  00000000  11111111  00000000  00000000  00000000  11111111  00000000  00000000  00000000  00000000  00000000  11111111  11111111
    // bit4 00000000  00000000  00000000  00000000  00000000  11111111  11111111  11111111  00000000  11111111  00000000  00000000  11111111  11111111  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  11111111  11111111  11111111  00000000  11111111  11111111  00000000  00000000  11111111  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  11111111  11111111  00000000  00000000  11111111  00000000  00000000  11111111  00000000  11111111  11111111
    // bit7 00000000  00000000  00000000  00000000  11111111  11111111  11111111  11111111  11111111  11111111  00000000  00000000  11111111  11111111  11111111  11111111
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.  X.X.X.X.  .X.X.X.X  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // bit2 X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.  X.X.X.X.  X.X.X.X.  .X.X.X.X  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit3 X.X.X.X.  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.  X.X.X.X.  X.X.X.X.  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit4 .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  X.X.X.X.  X.X.X.X.  .X.X.X.X  X.X.X.X.  X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X
    // bit5 .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X
    // bit6 .X.X.X.X  .X.X.X.X  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.
    // bit7 .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.
    // Avalanche: 50.00%

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
        0xC9, 0xC3, 0x22, 0x7C, 0x93, 0x5E, 0x68, 0x26, 0xDC, 0x30, 0x23, 0x3F, 0x1E, 0xF9, 0xE0, 0x11,
        0xA8, 0xF3, 0x74, 0x5C, 0xF0, 0x0F, 0xB2, 0xEE, 0x45, 0xAF, 0x6B, 0x78, 0xB0, 0x59, 0x4A, 0xD5,
        0xAF, 0x0A, 0x4F, 0x42, 0x5E, 0xEA, 0x13, 0x36, 0x74, 0x36, 0xDF, 0x59, 0x16, 0x2C, 0x38, 0x01,
        0x54, 0xFC, 0x4D, 0x1A, 0xE5, 0xEB, 0x3B, 0x5B, 0x16, 0x59, 0x66, 0x7E, 0x04, 0x51, 0xCC, 0x06,
        0x1E, 0xF4, 0xB6, 0x55, 0xF0, 0x4A, 0xDE, 0xA7, 0x5B, 0x49, 0x54, 0x98, 0xEB, 0xDC, 0x8A, 0xE6,
        0x46, 0x20, 0xA4, 0xF9, 0x0B, 0x6B, 0xF4, 0x74, 0x9B, 0xCA, 0x6A, 0x56, 0x9C, 0x3B, 0xBD, 0xD3,
        0xD0, 0x52, 0x01, 0x5B, 0x8B, 0xC5, 0x6D, 0xCE, 0xD1, 0xA3, 0x16, 0x0D, 0xD3, 0x36, 0x27, 0xD7,
        0x94, 0xDA, 0xF5, 0xAE, 0xB9, 0x22, 0xE1, 0x34, 0xA6, 0xD7, 0x30, 0x85, 0x69, 0xFD, 0x87, 0xA0
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F,
        0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x69, 0x69, 0x69, 0x69, 0x69, 0x69, 0x69, 0x69,
        0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x55, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x0F, 0x69, 0x69, 0x69, 0x69, 0x69, 0x69, 0x69, 0x69,
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
                                                    "test_fixed_128_K_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_K_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_K_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_K_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_K_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_K_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_L_PasswordJumpXORCipher {

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
    // bit0 00000000  00000000  11011011  01101101  00000000  00000000  00000000  00000000  10110110  11011011  01101101  10110110  00000000  00000000  10110110  11011011
    // bit1 00000000  00000000  11110001  01101000  00000000  00000000  00101010  00000010  10111101  01011111  01101101  11100000  00000000  00000000  01010110  11011011
    // bit2 00000000  00000000  00000000  10010101  00000000  00000000  11010101  11111111  11111101  01111011  11010111  11101011  00000000  00000000  10110110  10101011
    // bit3 00000000  00000000  00101010  10010000  00000000  00000000  11111111  11111101  11110110  11111111  11010111  10111101  00000000  00000000  01010110  10101011
    // bit4 00000000  00000000  01011111  11111010  00000000  00000000  11111010  00000000  10100000  01111110  00000101  10101011  00000000  00000000  10111111  10100101
    // bit5 00000000  00000000  01110101  11111111  00000000  00000000  11010000  00000010  10101011  11111010  00000101  11111101  00000000  00000000  01011111  10100101
    // bit6 00000000  00000000  10000100  00000010  00000000  00000000  00101111  11111111  11101011  11011110  10111111  11110110  00000000  00000000  10111111  11010101
    // bit7 00000000  00000000  10101110  00000111  00000000  00000000  00000101  11111101  11100000  01011010  10111111  10100000  00000000  00000000  01011111  11010101
    //
    // Avalanche:
    // bit0 X....X.X  XXX.X...  X....X.X  XXX.X...  XXX.X...  .X.XXXX.  X....X.X  XXX.X...  XXX.X...  .X.XXXX.  X....X.X  XXX.X...  X....X.X  XXX.X...  XXX.X...  .X.XXXX.
    // bit1 X....X.X  .X.X.X.X  X.X.XXXX  XXX.X...  X.X.X...  .X.XXXX.  X....X.X  XXX.X.X.  XXX.X...  ....X.X.  X....X.X  XXX.X.X.  X....X.X  XXX.X.X.  X.X.X...  .X.XXXX.
    // bit2 X.X.X.X.  X.X.X...  .X.X.X.X  XXX.X.X.  XXX.X...  .......X  X.......  ...X.X.X  .X.X.XXX  XXXXXXX.  X.......  ...X.X.X  X.......  ...X.X.X  XXX.X...  .......X
    // bit3 X.X.X.X.  ...X.X.X  .XXXXXXX  XXX.X.X.  X.X.X...  .......X  X.......  ...X.XXX  .X.X.XXX  X.X.X.X.  X.......  ...X.XXX  X.......  ...X.XXX  X.X.X...  .......X
    // bit4 .X.X....  X.X.X...  .X.X.X.X  .X.X.X.X  XXX.X.X.  XXXX.X.X  X.X.XXXX  .X.X.X.X  X.X.X.X.  XXXXXXX.  X.X.XXXX  .X.X.X.X  X.X.XXXX  .X.X.X.X  XXX.X.X.  XXXX.X.X
    // bit5 .X.X....  ...X.X.X  .XXXXXXX  .X.X.X.X  X.X.X.X.  XXXX.X.X  X.X.XXXX  .X.X.XXX  X.X.X.X.  X.X.X.X.  X.X.XXXX  .X.X.XXX  X.X.XXXX  .X.X.XXX  X.X.X.X.  XXXX.X.X
    // bit6 .XXXXXXX  XXX.X...  X....X.X  .X.X.XXX  XXX.X.X.  X.X.X.X.  X.X.X.X.  X.X.X...  ...X.X.X  .X.XXXX.  X.X.X.X.  X.X.X...  X.X.X.X.  X.X.X...  XXX.X.X.  X.X.X.X.
    // bit7 .XXXXXXX  .X.X.X.X  X.X.XXXX  .X.X.XXX  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  ...X.X.X  ....X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // Avalanche: 50.00%

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
        0xBB, 0xB7, 0x1C, 0xC7, 0xE9, 0x30, 0x84, 0xC5, 0x86, 0xCD, 0x4F, 0x80, 0xC8, 0x77, 0xFA, 0x49,
        0xCF, 0x83, 0x9E, 0x99, 0x36, 0xDD, 0x32, 0x7E, 0xB7, 0x1D, 0x57, 0xA6, 0x92, 0x70, 0xBF, 0xDB,
        0x66, 0xED, 0x24, 0x09, 0x50, 0x02, 0xAF, 0x42, 0xDB, 0xD6, 0xE5, 0x0D, 0x63, 0xAA, 0x44, 0xC5,
        0xF3, 0x95, 0x54, 0xD2, 0xF2, 0xF3, 0xBE, 0x47, 0x9C, 0x06, 0x74, 0x90, 0xD1, 0xD6, 0x86, 0x29,
        0x6A, 0xFE, 0x21, 0xD7, 0x74, 0x86, 0x07, 0x30, 0x77, 0xDF, 0xC5, 0x52, 0x8E, 0x57, 0xA3, 0xA6,
        0x1C, 0xDB, 0x71, 0xB9, 0xAA, 0xFA, 0x94, 0x7B, 0x9F, 0xA5, 0xC0, 0x71, 0x82, 0x67, 0x85, 0x73,
        0xDD, 0x80, 0xF6, 0x1E, 0x46, 0xC8, 0x84, 0xB7, 0x4E, 0x41, 0x2F, 0x34, 0xC2, 0x5B, 0x5D, 0xB8,
        0x6C, 0xA9, 0x7F, 0xEC, 0x83, 0x4D, 0xCD, 0x2E, 0x1D, 0xA1, 0x8C, 0x5F, 0x6B, 0xE4, 0x59, 0x5B
    };

    PasswordJumpXORCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xC3, 0xCC, 0x55, 0xCC, 0x99, 0x0F, 0x99, 0xCC, 0x3C, 0xCC, 0xCC, 0x3C, 0xCC, 0xA5, 0x0F, 0xA5,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x3C, 0x3C, 0x5A, 0x3C, 0x5A, 0x33, 0x5A, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x66, 0x33,
        0xFF, 0x33, 0xFF, 0xF0, 0x66, 0xF0, 0x96, 0x66, 0x96, 0xFF, 0x3C, 0xFF, 0xFF, 0x5A, 0xFF, 0xF0,
        0x33, 0xF0, 0xC3, 0x33, 0xC3, 0xFF, 0x33, 0xFF, 0xFF, 0x66, 0xFF, 0x96, 0x3C, 0x96, 0xAA, 0x3C,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xAA, 0x55, 0xAA, 0xFF, 0x0F, 0xFF, 0xFF, 0x0F, 0xFF, 0xC3, 0x3C, 0xC3, 0xF0, 0x0F, 0xF0, 0xFF
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_L_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_L_PasswordJumpXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_L_PasswordJumpXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_L_PasswordJumpXORCipher")) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_L_PasswordJumpXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpXORCipher] test_fixed_128_L_PasswordJumpXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

@end
