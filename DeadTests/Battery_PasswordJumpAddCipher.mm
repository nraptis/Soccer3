//
//  Battery_PasswordJumpAddCipher.m
//  HolyStorms
//
//  Created by icarus black on 7/5/26.
//

#import <XCTest/XCTest.h>
#import "PasswordJumpAddCipher.hpp"
#import "PrintExamplesHelper.hpp"
#import "CipherGauntlet.hpp"
#include <memory>

@interface Battery_PasswordJumpAddCipher : XCTestCase

@end

@implementation Battery_PasswordJumpAddCipher

- (void)test_gauntlet_PasswordJumpAddCipher {
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
            
            PasswordJumpAddCipher aCipher(aMask,
                                         aMaskJumps);
            if (!aGauntlet.RunCipher(&aCipher,
                                     32,
                                     "PasswordJumpAddCipher")) {
                XCTFail("[PasswordJumpAddCipher] test_gauntlet_PasswordJumpAddCipher failed.");
                return;
            }
        }
    }
}

- (void)test_fixed_32_A_PasswordJumpAddCipher {

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
        0x4D, 0x68, 0xE5, 0x45, 0xE1, 0x3D, 0xED, 0x5C, 0xAA, 0x33, 0x42, 0x78, 0xF3, 0x26, 0x8E, 0x7A,
        0xC7, 0xB0, 0x5B, 0x55, 0xD3, 0xFF, 0xD8, 0xE4, 0xF8, 0x27, 0xF9, 0x5D, 0x94, 0x3C, 0x56, 0x80
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_32_A_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_A_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_A_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_A_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_A_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_A_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_B_PasswordJumpAddCipher {

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
    // bit0 11111111  11111111  11111111  11111111
    // bit1 11111111  11111111  11111111  11111111
    // bit2 11111111  11111111  11111111  11111111
    // bit3 11111111  11111111  11111111  11111111
    // bit4 11111111  11111111  11111111  11111111
    // bit5 11111111  11111111  11111111  11111111
    // bit6 11111111  11111111  11111111  11111111
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
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 12.50%

    const std::uint8_t aOriginal[32] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x0E, 0xDD, 0x68, 0x4A, 0x25, 0x19, 0x01, 0x28, 0xBB, 0x90, 0xEB, 0xC2, 0x13, 0xC0, 0xA1, 0x3D,
        0xC7, 0x4A, 0x39, 0xF1, 0x64, 0xB9, 0xD0, 0x5C, 0xF7, 0x8E, 0xCB, 0x73, 0x14, 0xDB, 0xC3, 0x04
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE,
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_B_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_B_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_B_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_B_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_B_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_B_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_C_PasswordJumpAddCipher {

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
    // bit1 10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........
    // bit1 ........  ........  ........  ........
    // bit2 ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........
    // bit5 ........  ........  ........  ........
    // bit6 ........  ........  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 18.75%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x3F, 0x67, 0xF2, 0x6B, 0xFF, 0x3D, 0x94, 0xC3, 0x0E, 0x6A, 0xC9, 0xCF, 0xE9, 0xAC, 0x45, 0x8E,
        0x50, 0x6D, 0xB0, 0x1F, 0x77, 0xC0, 0x08, 0x66, 0x7B, 0xBE, 0x62, 0xF6, 0xE9, 0xAF, 0xD0, 0xD7
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_C_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_C_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_C_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_C_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_C_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_C_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_D_PasswordJumpAddCipher {

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
    // bit1 01010101  01010101  01010101  01010101
    // bit2 01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010
    // bit4 10101010  10101010  10101010  10101010
    // bit5 01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 43.75%

    const std::uint8_t aOriginal[32] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x72, 0x61, 0x99, 0x72, 0x41, 0x3C, 0x8D, 0x75, 0x8E, 0x77, 0x62, 0x60, 0x71, 0xD0, 0xD1, 0xF8,
        0xFA, 0x72, 0xDB, 0x45, 0x35, 0x3D, 0xB4, 0xF3, 0x86, 0x19, 0xD7, 0x15, 0x7C, 0x62, 0x7E, 0x08
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_D_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_D_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_D_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_D_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_D_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_D_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_E_PasswordJumpAddCipher {

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
    // bit0 10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101
    // bit2 01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101
    // bit5 10101010  10101010  10101010  10101010
    // bit6 10101010  10101010  10101010  10101010
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........
    // bit3 ........  ........  ........  ........
    // bit4 ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........
    // bit7 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // Avalanche: 31.25%

    const std::uint8_t aOriginal[32] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x95, 0x1E, 0x95, 0xA7, 0x46, 0xDC, 0x7A, 0x51, 0xDC, 0xEE, 0x8E, 0x19, 0x7B, 0x76, 0x71, 0x04,
        0xA7, 0xA4, 0x4C, 0x90, 0xF9, 0x06, 0xBB, 0xF6, 0x29, 0xFB, 0x8E, 0x1F, 0x07, 0xED, 0x65, 0x04
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_E_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_E_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_E_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_E_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_E_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_E_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_F_PasswordJumpAddCipher {

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
    // bit0 01010101  01010101  01010101  01010101
    // bit1 10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101
    // bit5 10101010  10101010  10101010  10101010
    // bit6 01010101  01010101  01010101  01010101
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
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 93.75%

    const std::uint8_t aOriginal[32] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0xDD, 0x74, 0x2C, 0x09, 0xEC, 0xD5, 0x80, 0xF2, 0x0C, 0x84, 0xAE, 0x01, 0x40, 0x49, 0x5C, 0xBC,
        0xBD, 0x52, 0xE1, 0x45, 0xDD, 0x81, 0x6C, 0x22, 0x9F, 0x2A, 0xE6, 0x54, 0xD2, 0xFC, 0x7E, 0x40
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_F_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_F_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_F_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_F_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_F_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_F_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_G_PasswordJumpAddCipher {

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
    // bit0 10101001  10101010  01101010  10011010
    // bit1 10010110  10100101  10101001  01101010
    // bit2 10010101  10100101  01101001  01011010
    // bit3 01100110  10011001  10100110  01101001
    // bit4 01100101  10011001  01100110  01011001
    // bit5 01011010  10010110  10100101  10101001
    // bit6 01011001  10010110  01100101  10011001
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ......XX  ........  XX......  ..XX....
    // bit1 ..XXXXXX  ....XXXX  XX....XX  XXXX....
    // bit2 ......XX  ........  XX......  ..XX....
    // bit3 XXXX..XX  ..XXXX..  XX..XXXX  ..XX..XX
    // bit4 ......XX  ........  XX......  ..XX....
    // bit5 ..XXXXXX  ....XXXX  XX....XX  XXXX....
    // bit6 ......XX  ........  XX......  ..XX....
    // bit7 .X.XX..X  X..X.XX.  .XX..X.X  X..XX..X
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0xE5, 0xB4, 0xB5, 0x42, 0x77, 0xA0, 0x9F, 0x58, 0xF4, 0xC2, 0xEF, 0x41, 0x23, 0x97, 0x34, 0xB2,
        0x72, 0x33, 0x6E, 0x72, 0xA8, 0xB2, 0x24, 0x30, 0xB3, 0x5C, 0xBA, 0x9F, 0x49, 0xFE, 0x29, 0x1C
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78,
        0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_G_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_G_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_G_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_G_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_G_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_G_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_H_PasswordJumpAddCipher {

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
    // bit0 01100101  01011001  01010110  01010101
    // bit1 01011010  01010110  10010101  10100101
    // bit2 01101010  01011010  10010110  10100101
    // bit3 01011001  10010110  01100101  10011001
    // bit4 01101001  10011010  01100110  10011001
    // bit5 01010110  10010101  10100101  01101001
    // bit6 01100110  10011001  10100110  01101001
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ..XX....  ....XX..  ......XX  ........
    // bit1 ..XXXXXX  ....XXXX  XX....XX  XXXX....
    // bit2 ..XX....  ....XX..  ......XX  ........
    // bit3 ..XX..XX  XX..XX..  XXXX..XX  ..XXXX..
    // bit4 ..XX....  ....XX..  ......XX  ........
    // bit5 ..XXXXXX  ....XXXX  XX....XX  XXXX....
    // bit6 ..XX....  ....XX..  ......XX  ........
    // bit7 .XX..XX.  X..XX..X  X.X..XX.  .XX.X..X
    // Avalanche: 36.72%

    const std::uint8_t aOriginal[32] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF
    };

    const std::uint8_t aMaskBuffer[32] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0xF1, 0x50, 0x2C, 0x79, 0xAC, 0x97, 0x31, 0x8D, 0x75, 0x3E, 0x30, 0x81, 0xEF, 0xE3, 0x90, 0x7C,
        0x27, 0x34, 0x51, 0x38, 0x24, 0x8E, 0x04, 0x3D, 0x1C, 0xE8, 0x88, 0x1A, 0x69, 0x2F, 0xAA, 0x59
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86,
        0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_H_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_H_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_H_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_H_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_H_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_H_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_I_PasswordJumpAddCipher {

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
    // bit0 10001010  11100010  10111000  10101110
    // bit1 11100110  00111001  10001110  01100011
    // bit2 11000110  01110001  10011100  01100111
    // bit3 00101111  00001011  11000010  11110000
    // bit4 00001111  01000011  11010000  11110100
    // bit5 01100011  10011000  11100110  00111001
    // bit6 01000011  11010000  11110100  00111101
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ..X.....  .X..X...  ...X..X.  .....X..
    // bit1 .XX.XX..  XX.XX.XX  ..XX.XX.  XX..XX.X
    // bit2 ..X.....  .X..X...  ...X..X.  .....X..
    // bit3 XXX.X..X  .XXXX.X.  .X.XXXX.  X..X.XXX
    // bit4 ..X.....  .X..X...  ...X..X.  .....X..
    // bit5 .XX.XX..  XX.XX.XX  ..XX.XX.  XX..XX.X
    // bit6 ..X.....  .X..X...  ...X..X.  .....X..
    // bit7 .X....XX  XX.X....  XXXX.X..  ..XXXX.X
    // Avalanche: 38.28%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0xA7, 0xA0, 0x17, 0x09, 0x2A, 0xE4, 0x4A, 0xBE, 0xB5, 0xB1, 0xD3, 0x1B, 0x3C, 0xF5, 0xD8, 0x11,
        0xEF, 0xF6, 0xAE, 0x12, 0xDB, 0x71, 0x73, 0x9C, 0xC1, 0x40, 0x5E, 0x44, 0x0B, 0x70, 0x5F, 0x3E
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78,
        0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_I_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_I_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_I_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_I_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_I_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_I_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_J_PasswordJumpAddCipher {

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
    // bit0 11111111  11111111  11111111  11111111
    // bit1 00000000  00000000  00000000  00000000
    // bit2 01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010
    // bit4 11111111  11111111  11111111  11111111
    // bit5 00000000  00000000  00000000  00000000
    // bit6 01010101  01010101  01010101  01010101
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 68.75%

    const std::uint8_t aOriginal[32] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x8D, 0x3F, 0xCB, 0x68, 0x55, 0x40, 0x33, 0x47, 0x55, 0x4C, 0x9A, 0x77, 0x4E, 0x58, 0x61, 0x08,
        0xE7, 0x99, 0x7D, 0x71, 0xA0, 0x92, 0x11, 0xD9, 0x1A, 0x48, 0x4C, 0x51, 0x98, 0xED, 0xBB, 0x99
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA,
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_J_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_J_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_J_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_J_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_J_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_J_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_K_PasswordJumpAddCipher {

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
    // bit0 10101010  10101010  10101010  01010101
    // bit1 10101010  01010101  01010101  10101010
    // bit2 10101010  01010101  01010101  01010101
    // bit3 01010101  10101010  01010101  10101010
    // bit4 01010101  10101010  01010101  01010101
    // bit5 01010101  01010101  10101010  10101010
    // bit6 01010101  01010101  10101010  01010101
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  XXXXXXXX
    // bit1 ........  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX  ........  XXXXXXXX
    // bit4 ........  ........  ........  XXXXXXXX
    // bit5 ........  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  XXXXXXXX
    // bit7 .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X
    // Avalanche: 46.88%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x1D, 0x29, 0xDA, 0x5D, 0x0F, 0x18, 0xEC, 0xA8, 0xD1, 0x31, 0x59, 0x7A, 0xF7, 0x81, 0x89, 0x9B,
        0x64, 0x2E, 0x01, 0x99, 0xD1, 0x95, 0x43, 0xE8, 0xD4, 0x68, 0xD7, 0x1E, 0x5C, 0x23, 0xF2, 0xD2
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_K_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_K_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_K_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_K_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_K_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_K_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_L_PasswordJumpAddCipher {

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
    // bit0 10000101  01010101  01011110  10000000
    // bit1 10101010  10101000  01010101  01111111
    // bit2 10101010  00010101  01010101  01111010
    // bit3 01010000  10101000  00001010  10101111
    // bit4 01010000  00010101  00001010  10101010
    // bit5 01111111  11101000  00000001  01010101
    // bit6 01111111  01010101  00000001  01010000
    // bit7 00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  X.XXXX.X  ........  .....X.X
    // bit1 ..X.XXXX  XXXXXX.X  ....X.XX  XXXXXXXX
    // bit2 ........  X.XXXX.X  ........  .....X.X
    // bit3 XXXXX.X.  X.XXXX.X  .X.XXXXX  XX.X.X.X
    // bit4 ........  X.XXXX.X  ........  .....X.X
    // bit5 ..X.XXXX  XXXXXX.X  ....X.XX  XXXXXXXX
    // bit6 ........  X.XXXX.X  ........  .....X.X
    // bit7 .XXXXXXX  .X.X.X.X  .......X  .X.X....
    // Avalanche: 44.92%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0xB9, 0x8C, 0x92, 0x27, 0x26, 0x7E, 0x44, 0x18, 0x8E, 0x37, 0xA3, 0x46, 0x47, 0x34, 0x53, 0x95,
        0xEC, 0x69, 0x68, 0x79, 0x3A, 0xE9, 0xC3, 0x8B, 0xB0, 0x88, 0x90, 0x74, 0xC6, 0x20, 0x9C, 0xE7
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0xE0, 0x1E, 0x66, 0x1E, 0x66, 0x86, 0x66, 0x86, 0x54, 0x86, 0x54, 0xAA, 0x54, 0xAA, 0x00, 0xAA,
        0x00, 0xE0, 0x00, 0xE0, 0x98, 0xE0, 0x98, 0x66, 0x98, 0x66, 0x78, 0x66, 0x78, 0x54, 0x78, 0x54
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_L_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_L_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_L_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_L_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_L_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_32_L_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_A_PasswordJumpAddCipher {

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
        0x99, 0xA0, 0xA9, 0x5D, 0x46, 0x28, 0x93, 0x47, 0xB8, 0x1A, 0xDC, 0xC9, 0xDF, 0x77, 0xE2, 0xFA,
        0x68, 0xB4, 0x3B, 0xFF, 0x44, 0x49, 0x22, 0x69, 0x2C, 0x8C, 0xF5, 0x72, 0xE8, 0x2E, 0xA3, 0xF0,
        0xA8, 0xAB, 0xE9, 0x9A, 0xDC, 0x5F, 0xF3, 0xF2, 0x78, 0xBF, 0xC1, 0x8B, 0xCC, 0xCD, 0x73, 0xFD,
        0x46, 0xCE, 0xA6, 0xE3, 0xA2, 0x5E, 0xE3, 0x3E, 0x11, 0x8C, 0x08, 0xF3, 0xF1, 0x89, 0x8D, 0x13
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_64_A_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_A_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_A_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_A_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_A_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_A_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_B_PasswordJumpAddCipher {

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
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit2 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit3 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit6 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
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
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 12.50%

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
        0x50, 0x85, 0x55, 0x96, 0xCE, 0x23, 0x98, 0xC3, 0x78, 0x77, 0x98, 0x6D, 0x0F, 0x9F, 0xC9, 0xB7,
        0x27, 0x25, 0x6A, 0x1A, 0xD4, 0x8E, 0x17, 0x6B, 0x1A, 0x7F, 0x4B, 0x32, 0x8F, 0x4D, 0x06, 0x79,
        0xA3, 0xAC, 0x6F, 0x36, 0xA4, 0x36, 0x63, 0xCB, 0x87, 0x4B, 0x6E, 0x59, 0xB7, 0x61, 0x06, 0x3F,
        0x97, 0x32, 0x1C, 0xC3, 0xF3, 0x26, 0xC5, 0x68, 0x7A, 0x31, 0x8C, 0x1C, 0x2B, 0x7A, 0x3D, 0x88
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE,
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE,
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE,
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_B_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_B_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_B_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_B_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_B_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_B_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_C_PasswordJumpAddCipher {

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
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 18.75%

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
        0xEB, 0x3B, 0x3A, 0x8B, 0x5D, 0x4A, 0x9A, 0x95, 0xD7, 0x58, 0x78, 0x23, 0x46, 0xF2, 0xF1, 0x06,
        0xE6, 0x10, 0x64, 0xAF, 0xFB, 0xFF, 0x78, 0xB5, 0xD5, 0xCB, 0x90, 0xF5, 0x15, 0x61, 0x3A, 0x33,
        0xA6, 0x03, 0x8A, 0x11, 0x1B, 0xD0, 0x9A, 0x74, 0xF4, 0x64, 0xE0, 0x6A, 0x8F, 0x2D, 0xCF, 0xC8,
        0xE3, 0xD0, 0xE0, 0x30, 0x75, 0x02, 0x76, 0x91, 0xED, 0x44, 0xCB, 0x16, 0x18, 0xFF, 0x70, 0xF9
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_C_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_C_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_C_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_C_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_C_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_C_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_D_PasswordJumpAddCipher {

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
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 43.75%

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
        0x1C, 0x43, 0xA4, 0x5C, 0x6B, 0x24, 0x8C, 0xB1, 0xF3, 0x81, 0xEF, 0xD9, 0x75, 0x39, 0xAF, 0x75,
        0xFA, 0x8F, 0x92, 0x66, 0xC7, 0x15, 0x35, 0x3E, 0xD3, 0xF8, 0x2F, 0xFF, 0x34, 0x0C, 0xC0, 0x82,
        0x60, 0x53, 0x48, 0x72, 0x47, 0x4C, 0xB9, 0x7F, 0xBD, 0x1D, 0xC0, 0xD1, 0xAF, 0x54, 0xA8, 0x1C,
        0x2A, 0x7C, 0xE6, 0xF6, 0x5B, 0xFF, 0xE9, 0xB8, 0x7D, 0xE8, 0xCA, 0x0D, 0x07, 0x14, 0x2A, 0x1D
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_D_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_D_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_D_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_D_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_D_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_D_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_E_PasswordJumpAddCipher {

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
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // Avalanche: 31.25%

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
        0x8A, 0xB7, 0x81, 0xC4, 0x1D, 0x85, 0xCD, 0xB0, 0xFB, 0xA8, 0xBA, 0xD8, 0x38, 0xBC, 0x1E, 0x21,
        0x4E, 0x63, 0xAD, 0xEC, 0xD9, 0x5A, 0xDE, 0x2D, 0x7F, 0xCB, 0xCC, 0x13, 0x05, 0x2D, 0xDE, 0x99,
        0xEB, 0x08, 0x9B, 0x5D, 0xCA, 0xB9, 0xFA, 0xDE, 0x79, 0xDD, 0x7C, 0xC5, 0xED, 0x30, 0xED, 0x83,
        0x6E, 0x20, 0xBD, 0xA9, 0x68, 0x26, 0xCE, 0x1D, 0xD7, 0xDC, 0x10, 0x84, 0x4F, 0x1C, 0x56, 0x28
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_E_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_E_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_E_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_E_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_E_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_E_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_F_PasswordJumpAddCipher {

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
    // bit0 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
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
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 93.75%

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
        0xF2, 0xF6, 0xC5, 0x75, 0x61, 0xAF, 0xD1, 0x52, 0xF4, 0xF9, 0xE1, 0xF9, 0xEB, 0xDA, 0x82, 0x16,
        0x7A, 0x43, 0x09, 0x66, 0x02, 0xE7, 0x86, 0x62, 0xD1, 0xB9, 0x75, 0x8C, 0xC0, 0x4F, 0x0B, 0x31,
        0x8F, 0xE5, 0x2E, 0x12, 0x0A, 0xF3, 0x51, 0x73, 0x2D, 0xE8, 0xB1, 0x2D, 0xA3, 0xC0, 0x84, 0xE7,
        0x36, 0x70, 0xA1, 0xD1, 0x58, 0x80, 0x85, 0x97, 0x6A, 0x10, 0xAE, 0x00, 0x1B, 0xAB, 0x47, 0x49
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_F_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_F_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_F_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_F_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_F_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_F_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_G_PasswordJumpAddCipher {

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
    // bit0 10101001  10101010  10101010  01101010  10100110  10101001  10101010  01101010
    // bit1 10010110  10100101  01100101  10011001  01011010  10010110  01100101  10011001
    // bit2 10010101  10100101  10101001  10101010  01010110  10010101  10101001  10101010
    // bit3 01100110  10011001  01001000  01010010  10011010  01100110  01001000  01010010
    // bit4 01100101  10011001  10111011  10101110  10010110  01100101  10111011  10101110
    // bit5 01011010  10010110  01111011  10011110  01101010  01011010  01111011  10011110
    // bit6 01011001  10010110  00110111  00001101  01100110  01011001  00110111  00001101
    // bit7 00000000  00000000  11110011  11111100  00000000  00000000  11110011  11111100
    //
    // Avalanche:
    // bit0 ......XX  ........  ........  XX......  ....XX..  ......XX  ........  XX......
    // bit1 ..XXXXXX  ....XXXX  ....XXXX  ......XX  XXXXXX..  ..XXXXXX  XX..XXXX  XXXX..XX
    // bit2 ......XX  ........  ........  XX......  ....XX..  ......XX  ....XX..  ......XX
    // bit3 XXXX..XX  ..XXXX..  ..X....X  ....X...  XX..XX..  XXXX..XX  XXX.XX.X  ..XXX.XX
    // bit4 ......XX  ........  ...XXX.X  XX...XXX  ....XX..  ......XX  ..X...X.  ....X...
    // bit5 ..XXXXXX  ....XXXX  ...XXX.X  XX...XXX  XXXXXX..  ..XXXXXX  XXX...X.  XXXXX...
    // bit6 ......XX  ........  X..X..X.  X.X..X..  ....XX..  ......XX  X.X....X  X.X.X...
    // bit7 .X.XX..X  X..X.XX.  X..X.XX.  .XX..X.X  .XX..XX.  .X.XX..X  .XX..X.X  X..XX..X
    // Avalanche: 39.84%

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
        0x3B, 0x4F, 0xB7, 0x78, 0x6F, 0x0A, 0xEF, 0x9E, 0x47, 0x85, 0x6B, 0xF5, 0xAF, 0xC0, 0x02, 0x90,
        0x8D, 0xBB, 0x45, 0xBA, 0x1D, 0x9D, 0xF0, 0xB1, 0x8B, 0xBF, 0x2E, 0x59, 0xCE, 0xD6, 0x18, 0xAD,
        0xB9, 0xB7, 0x6C, 0x13, 0xB1, 0xBB, 0x00, 0x3E, 0xA2, 0x36, 0x1F, 0x28, 0x0F, 0x5D, 0x3D, 0xAF,
        0xC5, 0x0B, 0x19, 0xFE, 0x70, 0x38, 0x4D, 0xB6, 0x64, 0xA5, 0xC5, 0xC5, 0x1A, 0x69, 0xBB, 0x5D
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78,
        0xA9, 0x55, 0xEF, 0x0F, 0xBC, 0x42, 0x8F, 0x6F, 0x6D, 0x91, 0xA9, 0x55, 0xEF, 0x0F, 0xBC, 0x42,
        0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA,
        0xA9, 0x55, 0xEF, 0x0F, 0xBC, 0x42, 0x8F, 0x6F, 0x6D, 0x91, 0xA9, 0x55, 0xEF, 0x0F, 0xBC, 0x42
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_G_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_G_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_G_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_G_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_G_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_G_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_H_PasswordJumpAddCipher {

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
    // bit0 01100101  01011001  10010101  01100101  10010101  01100101  01011001  01010110
    // bit1 01011010  01010110  01100110  01011001  01100110  01011001  10010110  01100101
    // bit2 01101010  01011010  01011010  10010110  01011010  10010110  10100101  10101001
    // bit3 01011001  10010110  01011001  10010110  01011001  10010110  01100101  10011001
    // bit4 01101001  10011010  10100101  10101001  10100101  10101001  01101010  01011010
    // bit5 01010110  10010101  01000010  10010000  01000010  10010000  10100100  00101001
    // bit6 01100110  10011001  01111101  01011111  01111101  01011111  01010111  11010101
    // bit7 00000000  00000000  00111100  00001111  00111100  00001111  00000011  11000000
    //
    // Avalanche:
    // bit0 ..XX....  ....XX..  XX......  ..XX....  XX......  ..XX....  ....XX..  ......XX
    // bit1 ..XXXXXX  ....XXXX  ..XX....  ....XX..  XXXX..XX  ..XXXX..  XX..XXXX  ..XX..XX
    // bit2 ..XX....  ....XX..  XX..XXXX  ..XX..XX  ..XX..XX  XX..XX..  XXXX..XX  ..XXXX..
    // bit3 ..XX..XX  XX..XX..  XX..XXXX  ..XX..XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX
    // bit4 ..XX....  ....XX..  XX......  ..XX....  XX....XX  XXXX....  XXXXXX..  ..XXXXXX
    // bit5 ..XXXXXX  ....XXXX  ..X..X..  ....X..X  XXX..X..  XXXXX..X  ..XXXXX.  .X..XXXX
    // bit6 ..XX....  ....XX..  XX.XX...  ..XX.XX.  ..X..XXX  ....X..X  XX....X.  .XXX....
    // bit7 .XX..XX.  X..XX..X  X..XX.X.  .XX..XX.  X.X..XX.  .XX.X..X  X..XX.X.  .XX..XX.
    // Avalanche: 46.48%

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
        0x5A, 0xC3, 0x91, 0xA7, 0x2E, 0xC9, 0x22, 0x2F, 0x0F, 0x41, 0x25, 0xFA, 0x2A, 0xD6, 0x12, 0xC7,
        0xC4, 0xEC, 0x42, 0x59, 0xCC, 0xB3, 0x6D, 0xDC, 0x8E, 0x13, 0xFB, 0xE3, 0xA9, 0x01, 0x97, 0x2A,
        0xC5, 0x0D, 0xB6, 0xF0, 0x87, 0x08, 0xC6, 0x7B, 0x4E, 0x48, 0xE6, 0x02, 0x4E, 0x50, 0xA9, 0xDF,
        0x37, 0x93, 0xB8, 0xD8, 0xAF, 0x68, 0x6B, 0x4B, 0xA7, 0xE1, 0x2C, 0x51, 0x09, 0x4E, 0x05, 0x62
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86,
        0x88, 0x76, 0x4B, 0xB3, 0x33, 0xCB, 0x64, 0x9A, 0x3C, 0xC2, 0x88, 0x76, 0x4B, 0xB3, 0x33, 0xCB,
        0x88, 0x76, 0x4B, 0xB3, 0x33, 0xCB, 0x64, 0x9A, 0x3C, 0xC2, 0x88, 0x76, 0x4B, 0xB3, 0x33, 0xCB,
        0x64, 0x9A, 0x3C, 0xC2, 0x88, 0x76, 0x4B, 0xB3, 0x33, 0xCB, 0x64, 0x9A, 0x3C, 0xC2, 0x88, 0x76
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_H_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_H_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_H_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_H_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_H_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_H_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_I_PasswordJumpAddCipher {

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
    // bit0 10001010  11100010  10111000  10101110  10001010  11100010  11100010  10111000
    // bit1 11100110  00111001  00001111  01000011  00101111  00001011  00001011  11000010
    // bit2 11000110  01110001  10001010  11100010  01110001  10011100  10011100  01100111
    // bit3 00101111  00001011  00010001  10000100  11110000  10111100  10111100  00101111
    // bit4 00001111  01000011  11101010  11111010  10011100  01100111  01100111  00011001
    // bit5 01100011  10011000  01101011  11011010  00110001  00001100  00001100  01000011
    // bit6 01000011  11010000  01101100  01011011  11101110  10111011  10111011  10101110
    // bit7 00000000  00000000  11111011  01111110  01001100  10010011  10010011  00100100
    //
    // Avalanche:
    // bit0 ..X.....  .X..X...  ...X..X.  .....X..  ..X.....  .X..X...  .X..X...  ...X..X.
    // bit1 .XX.XX..  XX.XX.XX  X.XX.XXX  XXX.XX.X  .....X..  X......X  XXX.X..X  .XXXX.X.
    // bit2 ..X.....  .X..X...  .....X..  X......X  XXX.X..X  .XXXX.X.  X.X..X.X  XXX.X..X
    // bit3 XXX.X..X  .XXXX.X.  X...XX.X  XXX...XX  XXX.X..X  .XXXX.X.  XX..XX.X  X.XX..XX
    // bit4 ..X.....  .X..X...  ..X.X...  ....X.X.  ..X.....  .X..X...  .XX.XX..  XX.XX.XX
    // bit5 .XX.XX..  XX.XX.XX  X.XXX.XX  ..X.XXX.  ....XX..  ......XX  .X..XXXX  X..X..XX
    // bit6 ..X.....  .X..X...  X...X.X.  .XX...X.  .XX.....  XX.XX...  ..X...XX  .X..X...
    // bit7 .X....XX  XX.X....  ....XXXX  .X....XX  .X....XX  XX.X....  .X....XX  XX.X....
    // Avalanche: 41.02%

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
        0x06, 0x36, 0x5C, 0xAA, 0x2F, 0x42, 0x1A, 0xF0, 0x95, 0x23, 0xA8, 0x70, 0x17, 0x8D, 0x98, 0x2F,
        0xEC, 0xA6, 0x00, 0xA6, 0x90, 0xC2, 0xE5, 0x4F, 0xA5, 0x94, 0x14, 0xF2, 0x8C, 0xE9, 0xD8, 0xD1,
        0x09, 0xE7, 0x47, 0x15, 0x72, 0xDF, 0x56, 0xC1, 0xF2, 0xD4, 0x93, 0x77, 0xF7, 0xE0, 0x1D, 0x80,
        0x48, 0xCF, 0x46, 0x91, 0x02, 0xC0, 0x1F, 0x76, 0x09, 0x00, 0x3A, 0xCE, 0xAC, 0x11, 0x9E, 0x82
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78,
        0xA9, 0x0F, 0x8F, 0x91, 0xEF, 0x42, 0x6D, 0x55, 0xBC, 0x6F, 0xA9, 0x0F, 0x8F, 0x91, 0xEF, 0x42,
        0x9A, 0x33, 0x76, 0x3C, 0xCB, 0x4B, 0xC2, 0x64, 0xB3, 0x88, 0x9A, 0x33, 0x76, 0x3C, 0xCB, 0x4B,
        0xB3, 0x88, 0x9A, 0x33, 0x76, 0x3C, 0xCB, 0x4B, 0xC2, 0x64, 0xB3, 0x88, 0x9A, 0x33, 0x76, 0x3C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_I_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_I_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_I_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_I_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_I_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_I_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_J_PasswordJumpAddCipher {

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
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 68.75%

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
        0xBD, 0x14, 0xC1, 0xD9, 0xAB, 0x81, 0xC4, 0xDC, 0x3C, 0x07, 0x50, 0xF3, 0x4E, 0xBE, 0xB8, 0xFF,
        0xD2, 0x25, 0x28, 0x73, 0x06, 0x9A, 0x47, 0x08, 0x8C, 0x43, 0x19, 0xCA, 0x70, 0x1D, 0x4A, 0xBE,
        0xEF, 0xA5, 0x44, 0x06, 0x80, 0x51, 0xB8, 0xC6, 0xA6, 0xFD, 0x8E, 0xDF, 0x61, 0x0A, 0x3B, 0xED,
        0x20, 0x29, 0x2D, 0x48, 0x89, 0x0D, 0x8B, 0xE3, 0x9A, 0xBF, 0x07, 0xAA, 0xC7, 0x50, 0xD2, 0x82
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA,
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA,
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA,
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_J_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_J_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_J_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_J_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_J_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_J_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_K_PasswordJumpAddCipher {

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
    // bit0 10101010  10101010  10101010  01010101  10101010  10101010  10101010  10101010
    // bit1 10101010  01010101  01010101  10101010  10101010  01010101  01010101  01010101
    // bit2 10101010  01010101  01010101  10101010  10101010  10101010  10101010  01010101
    // bit3 01010101  10101010  00000000  01010101  00000000  10101010  10101010  00000000
    // bit4 01010101  10101010  11111111  10101010  11111111  10101010  10101010  11111111
    // bit5 01010101  01010101  11111111  10101010  11111111  10101010  10101010  11111111
    // bit6 01010101  01010101  11111111  00000000  11111111  01010101  01010101  11111111
    // bit7 00000000  00000000  11111111  11111111  11111111  00000000  00000000  11111111
    //
    // Avalanche:
    // bit0 ........  ........  ........  XXXXXXXX  ........  ........  ........  ........
    // bit1 ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  XXXXXXXX  ........
    // bit3 XXXXXXXX  XXXXXXXX  .X.X.X.X  ........  X.X.X.X.  ........  XXXXXXXX  .X.X.X.X
    // bit4 ........  ........  X.X.X.X.  ........  .X.X.X.X  XXXXXXXX  ........  X.X.X.X.
    // bit5 ........  XXXXXXXX  X.X.X.X.  XXXXXXXX  .X.X.X.X  XXXXXXXX  ........  X.X.X.X.
    // bit6 ........  ........  .X.X.X.X  X.X.X.X.  .X.X.X.X  ........  ........  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 39.84%

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
        0x07, 0x09, 0xC0, 0xE3, 0xD4, 0x1C, 0x73, 0xF4, 0x9D, 0xF3, 0x6A, 0xEC, 0xF1, 0x64, 0x99, 0x1D,
        0x7E, 0x15, 0x43, 0x0D, 0x27, 0xCB, 0xD4, 0xD3, 0x6C, 0xCC, 0x46, 0x84, 0xE0, 0x33, 0x14, 0x87,
        0x47, 0xE8, 0x2D, 0xAD, 0xE9, 0xF1, 0x12, 0x1B, 0xF9, 0xC8, 0xCC, 0x0B, 0x1B, 0xC0, 0xA2, 0x0A,
        0x54, 0x7C, 0xD9, 0xF0, 0x21, 0x07, 0x45, 0xF7, 0xA0, 0x4A, 0xEB, 0xBB, 0x05, 0x0A, 0x02, 0x6D
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x8F, 0x6F, 0x8F, 0x6F, 0x8F, 0x6F, 0x8F, 0x6F, 0x6D, 0x91, 0x6D, 0x91, 0x6D, 0x91, 0x6D, 0x91,
        0xEF, 0x0F, 0xEF, 0x0F, 0xEF, 0x0F, 0xEF, 0x0F, 0xBC, 0x42, 0xBC, 0x42, 0xBC, 0x42, 0xBC, 0x42,
        0xBC, 0x42, 0xBC, 0x42, 0xBC, 0x42, 0xBC, 0x42, 0x8F, 0x6F, 0x8F, 0x6F, 0x8F, 0x6F, 0x8F, 0x6F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_K_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_K_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_K_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_K_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_K_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_K_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_L_PasswordJumpAddCipher {

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
    // bit0 10000101  01010101  11111110  11011011  10101000  01011110  10000100  10000101
    // bit1 10101010  10101000  10111110  11111111  11101000  00000001  10100100  00010010
    // bit2 10101010  00010101  10110101  01011111  10101000  00000001  01011111  11101111
    // bit3 01010000  10101000  11110111  11011110  11101010  11110101  00100001  11000101
    // bit4 01010000  00010101  11101010  11111010  10101010  11110101  01010100  10101111
    // bit5 01111111  11101000  10100000  01011111  11101010  10101010  01110100  10101010
    // bit6 01111111  01010101  11101011  11111111  10101010  10101010  10000101  01010010
    // bit7 00000000  00000000  10101011  11111010  00000000  00000000  10101110  00000111
    //
    // Avalanche:
    // bit0 ........  X.XXXX.X  X.X.....  .X.XXXX.  .X......  ........  .......X  .XX.XX.X
    // bit1 ..X.XXXX  XXXXXX.X  XXX.....  .XXXXXXX  .X......  .X.XXXXX  ....X.XX  XXXXX.X.
    // bit2 ........  X.XXXX.X  XXX.....  ..X.....  .X......  ........  ....X.X.  .....X.X
    // bit3 XXXXX.X.  X.XXXX.X  X.X...X.  X.X..X..  .X....X.  XXXX.X..  .X.XXXX.  ..X.XXXX
    // bit4 ........  X.XXXX.X  XXX.....  .X.X.X.X  .X......  ........  .......X  XXXXX.X.
    // bit5 ..X.XXXX  XXXXXX.X  X.X.X.X.  XXXX.X.X  .X......  .X.XXXXX  ....X.XX  XXXXXXXX
    // bit6 ........  X.XXXX.X  XXX.X.X.  X.X.X.X.  .X......  ........  ........  .....X.X
    // bit7 .XXXXXXX  .X.X.X.X  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  .......X  .X.X....
    // Avalanche: 42.38%

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
        0x22, 0xA0, 0x03, 0x69, 0x51, 0x0A, 0x2E, 0xED, 0xE8, 0x52, 0x3D, 0xB0, 0xC8, 0xA5, 0xD8, 0xCB,
        0x3D, 0xEC, 0xED, 0xE7, 0x22, 0x5E, 0x41, 0x63, 0x1A, 0x1A, 0xB9, 0xAA, 0xAE, 0x64, 0x06, 0x0D,
        0xC6, 0xDF, 0xA3, 0x79, 0x43, 0x66, 0xA6, 0xA8, 0x3D, 0x45, 0xCB, 0xCF, 0x64, 0xC2, 0x0B, 0x3F,
        0xC2, 0xD0, 0xD2, 0xD0, 0x6E, 0x2F, 0x74, 0x86, 0x0C, 0x84, 0x96, 0x68, 0x1C, 0x11, 0x2E, 0x34
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0xE0, 0x1E, 0x66, 0x1E, 0x66, 0x86, 0x66, 0x86, 0x54, 0x86, 0x54, 0xAA, 0x54, 0xAA, 0x00, 0xAA,
        0xFF, 0x9A, 0xFF, 0xF0, 0xCB, 0xF0, 0xDB, 0x33, 0xDB, 0xFF, 0x4B, 0xFF, 0xFF, 0x76, 0xFF, 0xE6,
        0xFE, 0x54, 0xFE, 0x00, 0xFE, 0x00, 0x1E, 0x00, 0x1E, 0x98, 0x1E, 0x98, 0x86, 0x98, 0x86, 0x78,
        0xC3, 0x2C, 0x55, 0x2C, 0x21, 0xEF, 0x21, 0x32, 0xBC, 0x32, 0x2C, 0x42, 0x2C, 0xB9, 0x6F, 0xB9
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_L_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_L_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_L_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_L_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_L_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_64_L_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_A_PasswordJumpAddCipher {

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
        0xF9, 0x11, 0x1C, 0x04, 0xF4, 0xAE, 0x30, 0xF6, 0x52, 0x92, 0x9D, 0x3C, 0xD5, 0x9E, 0x77, 0x7B,
        0xD0, 0xF3, 0x44, 0x0E, 0x8D, 0x33, 0xDD, 0x69, 0x61, 0x8E, 0x98, 0x72, 0xDA, 0x98, 0x9F, 0x90,
        0x2D, 0xDF, 0x0B, 0x3A, 0x78, 0x3B, 0xAD, 0x0F, 0x5E, 0x86, 0x0D, 0xAE, 0xD2, 0xA2, 0xE5, 0xEC,
        0x9D, 0xE6, 0x01, 0xDE, 0xC1, 0xA7, 0x9B, 0x92, 0x2D, 0x7F, 0x4E, 0x4F, 0x87, 0x69, 0x09, 0xC9,
        0xBE, 0xB6, 0x63, 0xF9, 0xBB, 0xE7, 0x62, 0xC2, 0x61, 0x06, 0xD9, 0x22, 0x33, 0xC0, 0x8D, 0x28,
        0x6A, 0x1C, 0x12, 0x43, 0x5A, 0xFA, 0xB7, 0xA4, 0xBF, 0xEA, 0x43, 0x38, 0x1E, 0x20, 0x1B, 0x9E
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_96_A_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_A_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_A_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_A_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_A_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_A_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_B_PasswordJumpAddCipher {

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
    // bit1 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit2 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit3 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit6 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
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
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 12.50%

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
        0xFC, 0xA6, 0x9C, 0xFD, 0x53, 0x56, 0x01, 0x98, 0x66, 0xAA, 0x6A, 0x5E, 0xB9, 0x87, 0xD9, 0xAF,
        0x18, 0x65, 0xDE, 0x71, 0x4C, 0x53, 0x91, 0x60, 0x03, 0x1D, 0x06, 0xC7, 0x65, 0x6A, 0x38, 0x6A,
        0x59, 0xB5, 0x1A, 0xED, 0xF1, 0x4B, 0xF0, 0xA1, 0x89, 0x4B, 0x26, 0x88, 0x95, 0x46, 0xE8, 0x69,
        0x40, 0x6A, 0xE9, 0x16, 0x63, 0xC8, 0x11, 0x99, 0xDC, 0x76, 0x71, 0x2B, 0xC7, 0xE1, 0x43, 0xD1,
        0x62, 0x4D, 0xD9, 0xB1, 0x74, 0xB5, 0x68, 0xD1, 0xBB, 0x4E, 0x05, 0x0A, 0xCB, 0x0E, 0xB0, 0x67,
        0xB6, 0x37, 0x6D, 0x17, 0x6C, 0xE9, 0xA0, 0x98, 0xA5, 0x57, 0x4D, 0x37, 0x1A, 0x68, 0xE1, 0x05
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE,
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE,
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE,
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE,
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE,
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_B_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_B_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_B_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_B_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_B_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_B_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_C_PasswordJumpAddCipher {

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
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 18.75%

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
        0x15, 0xD6, 0xDA, 0x51, 0x73, 0x2C, 0x1D, 0x3A, 0x1A, 0x1E, 0xC9, 0x6B, 0xD9, 0xD9, 0x70, 0xEF,
        0x39, 0xA4, 0x8C, 0x65, 0x05, 0x19, 0xE5, 0xC3, 0xD7, 0x1B, 0x30, 0x80, 0x6D, 0xB9, 0xB4, 0xFD,
        0xF6, 0x55, 0xFB, 0xDA, 0xC4, 0x11, 0x8B, 0x6F, 0x8E, 0x3A, 0x40, 0xB9, 0x62, 0x33, 0x4D, 0xED,
        0xBA, 0xB8, 0x87, 0x98, 0xFF, 0x79, 0xD0, 0xC6, 0xB8, 0xE5, 0x77, 0x01, 0x5C, 0x44, 0x38, 0xC6,
        0xEE, 0x96, 0x93, 0xF3, 0x9E, 0x89, 0xD2, 0x0A, 0x06, 0xE5, 0x4F, 0x98, 0x1B, 0x81, 0xEA, 0xA8,
        0xD6, 0xB0, 0x22, 0xFB, 0x10, 0x78, 0x50, 0x5F, 0x2E, 0xA0, 0x71, 0xBE, 0x02, 0x07, 0x71, 0xEE
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_C_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_C_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_C_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_C_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_C_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_C_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_D_PasswordJumpAddCipher {

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
    // bit1 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 43.75%

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
        0x69, 0x5F, 0x21, 0xB2, 0x76, 0x5E, 0x50, 0xC8, 0x23, 0xF8, 0x7F, 0x1A, 0xE1, 0x06, 0x10, 0xCD,
        0x1A, 0x14, 0x19, 0x6D, 0x1F, 0xC4, 0x01, 0x71, 0xC9, 0x15, 0x1E, 0xCD, 0x1F, 0x90, 0x34, 0x06,
        0x2B, 0xC9, 0xD1, 0x7B, 0xD2, 0x5D, 0xF8, 0xF1, 0x6E, 0x54, 0xB0, 0x40, 0xE9, 0x88, 0xC0, 0x0F,
        0xC3, 0x14, 0xDE, 0x2E, 0xE3, 0x4F, 0xC3, 0x25, 0xB1, 0x0B, 0x56, 0x50, 0xBE, 0x29, 0x08, 0x24,
        0x34, 0x85, 0x5D, 0x0E, 0xFB, 0x47, 0xC3, 0x57, 0x42, 0xE7, 0x55, 0x19, 0xB3, 0x89, 0xD8, 0x41,
        0x42, 0x9F, 0x98, 0xE5, 0x00, 0x9C, 0x1E, 0xA4, 0x04, 0x1F, 0x1E, 0x4C, 0x99, 0xC3, 0x71, 0x78
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_D_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_D_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_D_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_D_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_D_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_D_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_E_PasswordJumpAddCipher {

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
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // Avalanche: 31.25%

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
        0x50, 0x1A, 0x78, 0x2E, 0x92, 0x88, 0xF7, 0x8C, 0xBC, 0xDE, 0x86, 0xE8, 0xBA, 0xA8, 0xEE, 0x57,
        0xB3, 0xE6, 0x3C, 0xEE, 0x13, 0x3D, 0x5E, 0xA1, 0x33, 0x52, 0xD6, 0x8B, 0x27, 0xCA, 0x84, 0x60,
        0x88, 0xF0, 0x4C, 0x9C, 0x49, 0x05, 0x8D, 0xD3, 0x5D, 0x1F, 0x9F, 0x6E, 0x52, 0xB9, 0x9E, 0xBD,
        0x6A, 0xD5, 0x0D, 0xB7, 0xE6, 0x80, 0x39, 0xBB, 0x51, 0x24, 0xF1, 0xD0, 0xF4, 0xBD, 0x2F, 0x16,
        0x56, 0x31, 0x14, 0x49, 0x3D, 0x83, 0xE2, 0x27, 0xFE, 0xA4, 0x52, 0xBE, 0x8B, 0x80, 0xCB, 0x86,
        0x13, 0x19, 0x71, 0x91, 0xD9, 0xEB, 0xC4, 0xE9, 0x19, 0x56, 0xB5, 0xD5, 0xF0, 0x70, 0x12, 0x2F
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_E_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_E_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_E_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_E_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_E_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_E_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_F_PasswordJumpAddCipher {

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
    // bit0 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
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
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 93.75%

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
        0x65, 0x86, 0xBA, 0x94, 0xC7, 0x59, 0xB0, 0x5B, 0x74, 0x1A, 0xDC, 0x58, 0x80, 0x3B, 0xA7, 0xEF,
        0x9A, 0x3A, 0x7E, 0xB2, 0x41, 0x09, 0x80, 0x96, 0x21, 0x37, 0xB1, 0xE9, 0xAA, 0x57, 0x1D, 0x61,
        0xAB, 0x4F, 0x11, 0xEC, 0xFF, 0xC4, 0x8A, 0x9F, 0x25, 0x3E, 0x54, 0x92, 0x2E, 0x2D, 0xDA, 0x96,
        0x94, 0x32, 0x03, 0xD0, 0x82, 0x0A, 0x51, 0x95, 0x52, 0x8D, 0x0A, 0x30, 0x77, 0xFA, 0xBF, 0x48,
        0x36, 0xEE, 0x59, 0x03, 0x0F, 0xB7, 0x99, 0x34, 0x09, 0x72, 0x59, 0x67, 0xED, 0x7A, 0x59, 0xA5,
        0xBF, 0x27, 0x19, 0xE5, 0xB4, 0x7F, 0xA1, 0x5A, 0xDE, 0x5F, 0x8A, 0x5A, 0xDD, 0xAD, 0x6D, 0x78
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_F_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_F_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_F_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_F_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_F_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_F_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_G_PasswordJumpAddCipher {

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
    // bit0 10101001  10101010  10101001  10101010  10100110  10101001  10101010  01101010  01101010  10011010  10101001  10101010
    // bit1 10010110  10100101  01100110  10011001  01011001  10010110  10011001  10100110  10011001  01100110  01100110  10011001
    // bit2 10010101  10100101  01011010  01010110  10011010  10100110  01010110  10010101  10101010  01101010  01011010  01010110
    // bit3 01100110  10011001  10011010  01100110  10000101  00100001  01100110  10011001  01010010  00010100  10011010  01100110
    // bit4 01100101  10011001  10100101  01101001  10111010  11101110  01101001  01011010  10101110  11101011  10100101  01101001
    // bit5 01011010  10010110  01000010  01010000  10111001  11101110  01010000  10010100  10011110  11100111  01000010  01010000
    // bit6 01011001  10010110  10111110  10101111  01110000  11011100  10101111  10101011  00001101  11000011  10111110  10101111
    // bit7 00000000  00000000  00111100  00001111  00111111  11001111  00001111  00000011  11111100  11111111  00111100  00001111
    //
    // Avalanche:
    // bit0 ......XX  ........  ......XX  ........  ....XX..  ......XX  ........  XX......  XX......  ..XX....  ......XX  ........
    // bit1 ..XXXXXX  ....XXXX  ....XX..  ......XX  XXXXXXXX  ..XXXXXX  ..XX..XX  XX..XX..  ......XX  XX......  XX..XXXX  ..XX..XX
    // bit2 ......XX  ........  XXXX..XX  ..XXXX..  XX......  ..XX....  XXXX..XX  ..XXXX..  XX......  ..XX....  XX..XX..  XXXX..XX
    // bit3 XXXX..XX  ..XXXX..  XXXX..XX  ..XXXX..  XX.X..XX  X.XX.X..  XX....XX  XXXX....  ....X...  .X....X.  ....XXXX  XX....XX
    // bit4 ......XX  ........  ......XX  ........  ..X.....  X...X...  XXXX....  XXXXXX..  XX...XXX  .XXX...X  XX....XX  XXXX....
    // bit5 ..XXXXXX  ....XXXX  ..X..X..  ....X..X  ..X.XXXX  X...X.XX  XX..X..X  XXXX..X.  XX...XXX  .XXX...X  ..X..XXX  XX..X..X
    // bit6 ......XX  ........  ...XX.XX  .....XX.  ...XX.X.  X....XX.  ..XXX..X  ....XXX.  X.X..X..  X.X.X..X  XXX..X..  ..XXX..X
    // bit7 .X.XX..X  X..X.XX.  .X.XX..X  X..X.XX.  .X.XX..X  X..X.XX.  X..XX..X  .XX..XX.  .XX..X.X  X..XX..X  .XX..X.X  X..XX..X
    // Avalanche: 41.80%

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
        0x42, 0x84, 0x2E, 0x51, 0xD2, 0xC5, 0x5D, 0x7C, 0x2B, 0x89, 0x16, 0x2B, 0x15, 0x54, 0xBE, 0xCC,
        0x54, 0xC3, 0xE0, 0x7D, 0x3F, 0x00, 0xBC, 0x7F, 0xC2, 0x1E, 0xE3, 0xAB, 0x30, 0x77, 0x0D, 0x06,
        0x3B, 0x38, 0x71, 0xD9, 0xFD, 0x52, 0xAA, 0x6E, 0xB1, 0xCD, 0x9B, 0x61, 0xFE, 0x51, 0x94, 0x4C,
        0xDC, 0x14, 0x9F, 0x7F, 0x37, 0x66, 0x47, 0x4C, 0x71, 0xD1, 0x78, 0x66, 0x86, 0xB2, 0x28, 0x11,
        0xEA, 0xAF, 0x90, 0x1F, 0x05, 0xCB, 0x45, 0x5B, 0xF9, 0x62, 0xF3, 0xD8, 0xC6, 0x47, 0x9B, 0x3F,
        0x4B, 0xF5, 0x73, 0xD8, 0xBD, 0x0C, 0x29, 0xE5, 0x74, 0xAC, 0xFD, 0x86, 0x30, 0xD1, 0x73, 0x93
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78,
        0x9A, 0x64, 0xCB, 0x33, 0xB3, 0x4B, 0x76, 0x88, 0xC2, 0x3C, 0x9A, 0x64, 0xCB, 0x33, 0xB3, 0x4B,
        0xBC, 0x42, 0x8F, 0x6F, 0x6D, 0x91, 0xA9, 0x55, 0xEF, 0x0F, 0xBC, 0x42, 0x8F, 0x6F, 0x6D, 0x91,
        0xC2, 0x3C, 0x9A, 0x64, 0xCB, 0x33, 0xB3, 0x4B, 0x76, 0x88, 0xC2, 0x3C, 0x9A, 0x64, 0xCB, 0x33,
        0x6D, 0x91, 0xA9, 0x55, 0xEF, 0x0F, 0xBC, 0x42, 0x8F, 0x6F, 0x6D, 0x91, 0xA9, 0x55, 0xEF, 0x0F,
        0x9A, 0x64, 0xCB, 0x33, 0xB3, 0x4B, 0x76, 0x88, 0xC2, 0x3C, 0x9A, 0x64, 0xCB, 0x33, 0xB3, 0x4B
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_G_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_G_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_G_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_G_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_G_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_G_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_H_PasswordJumpAddCipher {

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
    // bit0 01100101  01011001  01010110  01010101  10010101  01100101  01010101  10010101  01100101  01011001  01100101  01011001
    // bit1 01011010  01010110  01100101  10011001  01101001  10011010  10011001  01100110  01011001  10010110  01011010  01010110
    // bit2 01101010  01011010  10101001  01101010  01100101  01011001  01101010  01011010  10010110  10100101  01101010  01011010
    // bit3 01011001  10010110  10011001  01100110  10000100  10100001  01100110  01011001  10010110  01100101  01011001  10010110
    // bit4 01101001  10011010  01011010  10010110  01110111  01011101  10010110  10100101  10101001  01101010  01101001  10011010
    // bit5 01010110  10010101  00101001  00001010  01110111  10011101  00001010  01000010  10010000  10100100  01010110  10010101
    // bit6 01100110  10011001  11010101  11110101  00111011  00001110  11110101  01111101  01011111  01010111  01100110  10011001
    // bit7 00000000  00000000  11000000  11110000  11110011  11111100  11110000  00111100  00001111  00000011  00000000  00000000
    //
    // Avalanche:
    // bit0 ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ........  XX......  ..XX....  ....XX..  ..XX....  ....XX..
    // bit1 ..XXXXXX  ....XXXX  ..XX..XX  XX..XX..  XXXXXX..  XXXXXXXX  XX......  ..XX....  ....XX..  ......XX  ..XXXXXX  ....XXXX
    // bit2 ..XX....  ....XX..  ..XXXX..  XX..XXXX  ....XX..  ......XX  ..XXXX..  XX..XXXX  ..XX..XX  XX..XX..  ..XX....  ....XX..
    // bit3 ..XX..XX  XX..XX..  ....XXXX  XX....XX  ..X.XX.X  XX..X.XX  ..XXXX..  XX..XXXX  ..XX..XX  XX..XX..  ..XX..XX  XX..XX..
    // bit4 ..XX....  ....XX..  ..XXXXXX  ....XXXX  ...X...X  .....X..  ........  XX......  ..XX....  ....XX..  ..XX....  ....XX..
    // bit5 ..XXXXXX  ....XXXX  .X..XXXX  X..X..XX  XX.X...X  XXXX.X..  X..X....  ..X..X..  ....X..X  ......X.  ..XXXXXX  ....XXXX
    // bit6 ..XX....  ....XX..  .XXX....  X..XXX..  .XX....X  .X.XX...  .XX.....  XX.XX...  ..XX.XX.  ....XX.X  ..XX....  ....XX..
    // bit7 .XX..XX.  X..XX..X  .XX..XX.  X..XX..X  .XX.X..X  X..XX.X.  .XX.X..X  X..XX.X.  .XX..XX.  X..XX..X  .XX..XX.  X..XX..X
    // Avalanche: 41.02%

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
        0xFC, 0xCA, 0xD2, 0xB6, 0x05, 0xEE, 0x1F, 0xDC, 0x78, 0x80, 0xD9, 0x8F, 0x4D, 0xC7, 0x88, 0x7C,
        0xB2, 0xB3, 0x53, 0xD3, 0x07, 0x77, 0x2C, 0x0A, 0x1E, 0xA2, 0x1A, 0x66, 0x42, 0x54, 0x3B, 0x25,
        0xAF, 0xD8, 0xBB, 0xB9, 0x2B, 0x9D, 0x4F, 0x40, 0x6C, 0xB5, 0x92, 0x4A, 0xEA, 0x61, 0xDC, 0x37,
        0x67, 0x18, 0xD8, 0xD6, 0xEC, 0x44, 0x28, 0xF9, 0x37, 0x82, 0x36, 0x76, 0xD3, 0x94, 0x49, 0xB8,
        0xA5, 0x70, 0x24, 0x2E, 0x15, 0x8A, 0x4B, 0x39, 0x3E, 0x84, 0x41, 0x80, 0xFB, 0xC7, 0x6E, 0xFD,
        0x5D, 0x03, 0xAC, 0x90, 0x46, 0x23, 0x58, 0x5F, 0x5F, 0xCC, 0x51, 0xFA, 0x66, 0x6A, 0xF3, 0x23
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86,
        0x33, 0xCB, 0x64, 0x9A, 0x3C, 0xC2, 0x88, 0x76, 0x4B, 0xB3, 0x33, 0xCB, 0x64, 0x9A, 0x3C, 0xC2,
        0x91, 0x6D, 0x6F, 0x8F, 0x42, 0xBC, 0x0F, 0xEF, 0x55, 0xA9, 0x91, 0x6D, 0x6F, 0x8F, 0x42, 0xBC,
        0x4B, 0xB3, 0x33, 0xCB, 0x64, 0x9A, 0x3C, 0xC2, 0x88, 0x76, 0x4B, 0xB3, 0x33, 0xCB, 0x64, 0x9A,
        0x3C, 0xC2, 0x88, 0x76, 0x4B, 0xB3, 0x33, 0xCB, 0x64, 0x9A, 0x3C, 0xC2, 0x88, 0x76, 0x4B, 0xB3,
        0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_H_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_H_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_H_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_H_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_H_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_H_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_I_PasswordJumpAddCipher {

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
    // bit0 10001010  11100010  10111000  10101110  00101011  10001010  11100010  10111000  10101110  00101011  10001010  11100010
    // bit1 11100110  00111001  11000010  11110000  10111100  00101111  00001011  11000010  01000011  11010000  11110100  00111101
    // bit2 11000110  01110001  01100111  00011001  11000110  01110001  10011100  01100111  11100010  10111000  10101110  00101011
    // bit3 00101111  00001011  00101111  00001011  11000010  11110000  10111100  00101111  10000100  01100001  00011000  01000110
    // bit4 00001111  01000011  00011001  11000110  01110001  10011100  01100111  00011001  11111010  10111110  10101111  10101011
    // bit5 01100011  10011000  01000011  00010000  11000100  00110001  00001100  01000011  11011010  11110110  10111101  10101111
    // bit6 01000011  11010000  10101110  11101011  10111010  11101110  10111011  10101110  01011011  00010110  11000101  10110001
    // bit7 00000000  00000000  00100100  11001001  00110010  01001100  10010011  00100100  01111110  11011111  10110111  11101101
    //
    // Avalanche:
    // bit0 ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...
    // bit1 .XX.XX..  XX.XX.XX  .XXXX.X.  .X.XXXX.  X..X.XXX  X.X..X.X  XXX.X..X  .XXXX.X.  XXX.XX.X  XXXXX.XX  .XXXXXX.  XX.XXXXX
    // bit2 ..X.....  .X..X...  XXX.X..X  .XXXX.X.  .X.XXXX.  X..X.XXX  X.X..X.X  XXX.X..X  X......X  ..X.....  .X..X...  ...X..X.
    // bit3 XXX.X..X  .XXXX.X.  X.XX..XX  .XX.XX..  XX.XX.XX  ..XX.XX.  XX..XX.X  X.XX..XX  XXX...XX  .XXXX...  XX.XXXX.  ..XX.XXX
    // bit4 ..X.....  .X..X...  XX.XX.XX  ..XX.XX.  XX..XX.X  X.XX..XX  .XX.XX..  XX.XX.XX  ....X.X.  ......X.  X.......  X.X.....
    // bit5 .XX.XX..  XX.XX.XX  X..X..XX  XXX..X..  XXXXX..X  ..XXXXX.  .X..XXXX  X..X..XX  ..X.XXX.  XX..X.XX  X.XX..X.  XXX.XX..
    // bit6 ..X.....  .X..X...  .X..X...  XX.X..X.  ..XX.X..  X...XX.X  ..X...XX  .X..X...  .XX...X.  X..XX...  X.X..XX.  ..X.X..X
    // bit7 .X....XX  XX.X....  XX.X....  XXXX.X..  ..XXXX.X  ....XXXX  .X....XX  XX.X....  .X....XX  XX.X....  XXXX.X..  ..XXXX.X
    // Avalanche: 46.35%

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
        0xA5, 0xA9, 0x79, 0x1F, 0x37, 0xC3, 0x1B, 0xFA, 0x19, 0xB1, 0x8E, 0xCD, 0xFA, 0x0D, 0x53, 0x62,
        0x8C, 0x56, 0x0D, 0xC5, 0xA1, 0xA3, 0x74, 0x70, 0xCA, 0x90, 0x6E, 0x15, 0xFB, 0xB1, 0xCB, 0x15,
        0x6C, 0xF7, 0x28, 0x37, 0x67, 0x79, 0xC0, 0xD7, 0x44, 0xDF, 0x16, 0x00, 0x1C, 0xCB, 0x95, 0xBC,
        0x7D, 0x0A, 0xE9, 0x7D, 0x0C, 0xC2, 0x0A, 0xE7, 0xB1, 0x9B, 0x50, 0x0E, 0x3C, 0x82, 0x76, 0x61,
        0x70, 0x84, 0x9E, 0x70, 0x66, 0xE7, 0xC3, 0xBD, 0x9A, 0xEF, 0xB8, 0xE9, 0x10, 0x0C, 0x33, 0x60,
        0x1B, 0x3C, 0x05, 0x25, 0xA8, 0x29, 0xA2, 0x27, 0xB0, 0xC8, 0x66, 0xA6, 0xA8, 0x32, 0x80, 0x30
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78,
        0xC2, 0x64, 0xB3, 0x88, 0x9A, 0x33, 0x76, 0x3C, 0xCB, 0x4B, 0xC2, 0x64, 0xB3, 0x88, 0x9A, 0x33,
        0x76, 0x3C, 0xCB, 0x4B, 0xC2, 0x64, 0xB3, 0x88, 0x9A, 0x33, 0x76, 0x3C, 0xCB, 0x4B, 0xC2, 0x64,
        0xB3, 0x88, 0x9A, 0x33, 0x76, 0x3C, 0xCB, 0x4B, 0xC2, 0x64, 0xB3, 0x88, 0x9A, 0x33, 0x76, 0x3C,
        0xBC, 0x6F, 0xA9, 0x0F, 0x8F, 0x91, 0xEF, 0x42, 0x6D, 0x55, 0xBC, 0x6F, 0xA9, 0x0F, 0x8F, 0x91,
        0xEF, 0x42, 0x6D, 0x55, 0xBC, 0x6F, 0xA9, 0x0F, 0x8F, 0x91, 0xEF, 0x42, 0x6D, 0x55, 0xBC, 0x6F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_I_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_I_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_I_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_I_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_I_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_I_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_J_PasswordJumpAddCipher {

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
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 68.75%

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
        0xAE, 0xD1, 0x1A, 0x36, 0x08, 0x54, 0xB7, 0x3D, 0xE5, 0xD8, 0xF6, 0x78, 0x72, 0x0D, 0x38, 0x2D,
        0xDD, 0x9D, 0xEE, 0x92, 0x48, 0xAE, 0xA4, 0xE4, 0xFB, 0x0E, 0x5D, 0x48, 0x34, 0xC4, 0xE0, 0x54,
        0x76, 0x1B, 0xE6, 0xC8, 0x3F, 0x1B, 0x12, 0xFD, 0x1A, 0x1D, 0x1C, 0x86, 0xC8, 0xAF, 0xD6, 0x34,
        0xF5, 0xD4, 0xED, 0x69, 0x68, 0x3A, 0x0E, 0xF6, 0x4B, 0xAD, 0x98, 0x3B, 0x16, 0x1C, 0x8A, 0xD0,
        0x12, 0x36, 0x35, 0x97, 0x51, 0x5B, 0x60, 0x68, 0xDC, 0x73, 0xE7, 0x25, 0xC6, 0xF9, 0xEA, 0xB6,
        0xE5, 0x7E, 0x5B, 0xE7, 0xD2, 0xF7, 0x4F, 0x25, 0x50, 0xD1, 0xB8, 0xB3, 0xC9, 0xCA, 0x96, 0x9F
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA,
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA,
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA,
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA,
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA,
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_J_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_J_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_J_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_J_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_J_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_J_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_K_PasswordJumpAddCipher {

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
    // bit0 10101010  10101010  10101010  01010101  10101010  10101010  10101010  01010101  01010101  10101010  10101010  01010101
    // bit1 10101010  01010101  01010101  10101010  10101010  01010101  01010101  10101010  10101010  10101010  01010101  10101010
    // bit2 10101010  01010101  01010101  10101010  10101010  10101010  01010101  10101010  10101010  01010101  10101010  10101010
    // bit3 01010101  10101010  00000000  01010101  00000000  10101010  00000000  01010101  10101010  01010101  10101010  10101010
    // bit4 01010101  10101010  11111111  10101010  11111111  10101010  11111111  10101010  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  11111111  10101010  11111111  10101010  11111111  10101010  10101010  01010101  00000000  10101010
    // bit6 01010101  01010101  11111111  00000000  11111111  01010101  11111111  00000000  10101010  10101010  11111111  10101010
    // bit7 00000000  00000000  11111111  11111111  11111111  00000000  11111111  11111111  00000000  00000000  11111111  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  XXXXXXXX  ........  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX
    // bit1 ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  XXXXXXXX  XXXXXXXX  ........  XXXXXXXX  ........  XXXXXXXX  ........
    // bit2 ........  ........  ........  ........  ........  ........  ........  XXXXXXXX  ........  XXXXXXXX  ........  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX  .X.X.X.X  ........  X.X.X.X.  ........  .X.X.X.X  ........  XXXXXXXX  XXXXXXXX  ........  XXXXXXXX
    // bit4 ........  ........  X.X.X.X.  ........  .X.X.X.X  XXXXXXXX  .X.X.X.X  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  XXXXXXXX
    // bit5 ........  XXXXXXXX  X.X.X.X.  XXXXXXXX  .X.X.X.X  XXXXXXXX  .X.X.X.X  XXXXXXXX  XXXXXXXX  XXXXXXXX  .X.X.X.X  ........
    // bit6 ........  ........  .X.X.X.X  X.X.X.X.  .X.X.X.X  ........  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  XXXXXXXX
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.  X.X.X.X.  .X.X.X.X
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
        0xE7, 0x5D, 0xE5, 0xBC, 0x2E, 0x59, 0xE9, 0x1F, 0x8A, 0x9D, 0xF7, 0xEE, 0x0E, 0x73, 0x0C, 0x02,
        0xAC, 0x18, 0x2A, 0xE7, 0x5B, 0xB1, 0x68, 0xD6, 0x50, 0x20, 0x53, 0x3D, 0x9C, 0x23, 0x7E, 0x86,
        0xE6, 0x3E, 0x6F, 0xAC, 0xF3, 0xB9, 0x98, 0x86, 0x6D, 0x9C, 0xDA, 0xC4, 0x8E, 0xBD, 0x0F, 0x12,
        0x8D, 0x41, 0x6E, 0xB3, 0x74, 0x7A, 0x05, 0x93, 0xAE, 0x7E, 0x68, 0xE1, 0xDB, 0xD0, 0x4A, 0x65,
        0x57, 0x0E, 0x94, 0xBC, 0x4F, 0x7D, 0x4E, 0x51, 0x3E, 0x46, 0x4E, 0x62, 0xF3, 0x79, 0xFF, 0xF4,
        0x29, 0x48, 0xFE, 0x88, 0xFE, 0x08, 0xF8, 0x35, 0x96, 0x25, 0x27, 0x52, 0x01, 0x2D, 0x72, 0xE9
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x8F, 0x6F, 0x8F, 0x6F, 0x8F, 0x6F, 0x8F, 0x6F, 0x6D, 0x91, 0x6D, 0x91, 0x6D, 0x91, 0x6D, 0x91,
        0xEF, 0x0F, 0xEF, 0x0F, 0xEF, 0x0F, 0xEF, 0x0F, 0xBC, 0x42, 0xBC, 0x42, 0xBC, 0x42, 0xBC, 0x42,
        0x8F, 0x6F, 0x8F, 0x6F, 0x8F, 0x6F, 0x8F, 0x6F, 0x6D, 0x91, 0x6D, 0x91, 0x6D, 0x91, 0x6D, 0x91,
        0x76, 0x88, 0x76, 0x88, 0x76, 0x88, 0x76, 0x88, 0xC2, 0x3C, 0xC2, 0x3C, 0xC2, 0x3C, 0xC2, 0x3C,
        0xB3, 0x4B, 0xB3, 0x4B, 0xB3, 0x4B, 0xB3, 0x4B, 0x76, 0x88, 0x76, 0x88, 0x76, 0x88, 0x76, 0x88
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_K_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_K_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_K_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_K_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_K_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_K_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_L_PasswordJumpAddCipher {

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
    // bit0 10000101  01010101  01011110  10000000  11111110  11011011  10000100  10000101  00011110  10001110  10000010  01011100
    // bit1 10101010  10101000  01010101  01111111  10111110  11111111  10100100  00010010  01010101  00001010  00010000  00001000
    // bit2 10101010  00010101  01010101  01111010  10110101  01011111  01011111  11101111  11101010  11010101  01111101  11111110
    // bit3 01010000  10101000  00001010  10101111  11110111  11011110  00100001  11000101  10100011  10000100  00000111  00010110
    // bit4 01010000  00010101  00001010  10101010  11101010  11111010  01010100  10101111  01001010  10100101  11010000  11111101
    // bit5 01111111  11101000  00000001  01010101  10100000  01011111  01110100  10101010  01000001  00100101  11010000  10101001
    // bit6 01111111  01010101  00000001  01010000  11101011  11111111  10000101  01010010  10110100  00101010  10010101  00001011
    // bit7 00000000  00000000  00000000  00000000  10101011  11111010  10101110  00000111  01011111  11111010  10111010  01011101
    //
    // Avalanche:
    // bit0 ........  X.XXXX.X  ........  .....X.X  ...X.XX.  X....X.X  .......X  .XX.XX.X  .X......  ....X.XX  .XX.X.X.  ......X.
    // bit1 ..X.XXXX  XXXXXX.X  ....X.XX  XXXXXXXX  ...X.XX.  X.X....X  ....X.XX  XXXXX.X.  ........  .X.XXXXX  XXXXX...  ......X.
    // bit2 ........  X.XXXX.X  ........  .....X.X  .X.XXX.X  .X.XXXX.  ....X.X.  .....X.X  .X......  .X.X....  ..X.X.X.  ........
    // bit3 XXXXX.X.  X.XXXX.X  .X.XXXXX  XX.X.X.X  .X.XXXXX  XX.XXXXX  .X.XXXX.  ..X.XXXX  ......X.  XX.X...X  .X.X....  X.XXXX..
    // bit4 ........  X.XXXX.X  ........  .....X.X  ........  ....XXXX  .......X  XXXXX.X.  .X......  ..X..X.X  .XXXX.X.  ......XX
    // bit5 ..X.XXXX  XXXXXX.X  ....X.XX  XXXXXXXX  ....X.X.  X.X.X.X.  ....X.XX  XXXXXXXX  .X......  .XXX.X.X  .XXXX.X.  ......XX
    // bit6 ........  X.XXXX.X  ........  .....X.X  .......X  .X.X.X.X  ........  .....X.X  .X..X.X.  X.X.X.X.  X.......  .X.X.X.X
    // bit7 .XXXXXXX  .X.X.X.X  .......X  .X.X....  .......X  .X.X....  .......X  .X.X....  X.X.X.X.  X.X.X.X.  X.X.XXXX  .X.X.XXX
    // Avalanche: 40.89%

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
        0x79, 0xEA, 0x54, 0x2B, 0xC1, 0x3E, 0x19, 0x2B, 0x51, 0xB4, 0x55, 0x99, 0xE8, 0x46, 0xC3, 0x8C,
        0x9E, 0x7A, 0x8C, 0x74, 0xD1, 0xF9, 0x89, 0x7D, 0xB8, 0x81, 0x0C, 0x3C, 0x01, 0x74, 0x5A, 0x19,
        0xF3, 0x8C, 0xE9, 0xD1, 0x4C, 0x74, 0x4A, 0x4F, 0x8B, 0xF3, 0x4D, 0xBF, 0x1F, 0x69, 0xA9, 0xB1,
        0x32, 0x0F, 0x73, 0xCA, 0xE8, 0x2C, 0x06, 0xF6, 0x54, 0xC1, 0xFB, 0x9B, 0x90, 0x18, 0x76, 0xB8,
        0xEF, 0xC6, 0xC9, 0xC1, 0xA9, 0x68, 0x5C, 0x19, 0x0E, 0x6E, 0xEC, 0xCB, 0xBC, 0x23, 0x0F, 0x2D,
        0x94, 0xF9, 0x5D, 0xD9, 0xF7, 0xF1, 0x31, 0xD5, 0x31, 0x97, 0x06, 0x4D, 0xE3, 0xFC, 0x1D, 0x0D
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0xE0, 0x1E, 0x66, 0x1E, 0x66, 0x86, 0x66, 0x86, 0x54, 0x86, 0x54, 0xAA, 0x54, 0xAA, 0x00, 0xAA,
        0x00, 0xE0, 0x00, 0xE0, 0x98, 0xE0, 0x98, 0x66, 0x98, 0x66, 0x78, 0x66, 0x78, 0x54, 0x78, 0x54,
        0xFF, 0x9A, 0xFF, 0xF0, 0xCB, 0xF0, 0xDB, 0x33, 0xDB, 0xFF, 0x4B, 0xFF, 0xFF, 0x76, 0xFF, 0xE6,
        0xC3, 0x2C, 0x55, 0x2C, 0x21, 0xEF, 0x21, 0x32, 0xBC, 0x32, 0x2C, 0x42, 0x2C, 0xB9, 0x6F, 0xB9,
        0x32, 0x6D, 0x32, 0xC3, 0xA9, 0xC3, 0xB9, 0x55, 0xB9, 0x21, 0x0F, 0x21, 0xC3, 0xBC, 0xC3, 0x2C,
        0x8F, 0x2C, 0x21, 0x6F, 0x21, 0x32, 0x91, 0x32, 0x2C, 0xA9, 0x2C, 0xB9, 0xEF, 0xB9, 0x32, 0x0F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_L_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_L_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_L_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_L_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_L_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_96_L_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_A_PasswordJumpAddCipher {

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
        0xF2, 0x5A, 0x38, 0x2B, 0x34, 0x1E, 0x90, 0x0D, 0x52, 0x45, 0xC2, 0x27, 0xF9, 0xC6, 0x70, 0xE6,
        0xC4, 0x6C, 0x0D, 0x3B, 0x98, 0x66, 0xEA, 0x2F, 0x5B, 0xD9, 0x93, 0x0B, 0xA5, 0x16, 0xCB, 0x45,
        0x02, 0x12, 0xC5, 0xB3, 0x80, 0x90, 0x3C, 0xA5, 0xD0, 0xB9, 0x59, 0x65, 0x1A, 0xF1, 0x61, 0x2F,
        0x06, 0x9E, 0xA4, 0xF5, 0xA0, 0xF7, 0x51, 0x5A, 0x96, 0x9F, 0x46, 0x78, 0xF7, 0x24, 0x2B, 0xFC,
        0xFD, 0xDE, 0xE2, 0x2D, 0x25, 0xB6, 0xB7, 0x47, 0xE9, 0x0A, 0xDC, 0x66, 0x45, 0xDC, 0x6A, 0x4C,
        0x5A, 0xE4, 0x96, 0x10, 0x27, 0x1A, 0xFA, 0xCB, 0xBD, 0xC9, 0x15, 0xE5, 0xAF, 0x68, 0xBF, 0x5E,
        0x65, 0x40, 0xAE, 0x6D, 0x38, 0xA4, 0xCD, 0xAE, 0xBC, 0xF7, 0x69, 0x50, 0xB2, 0x24, 0x82, 0x3E,
        0x1B, 0x35, 0xAB, 0x5B, 0xBC, 0xD5, 0x39, 0xFB, 0x0B, 0xEB, 0x5E, 0x8E, 0xE1, 0x06, 0x27, 0xF2
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_128_A_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_A_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_A_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_A_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_A_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_A_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_B_PasswordJumpAddCipher {

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
    // bit1 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit2 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit3 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit6 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
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
    // bit7 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // Avalanche: 12.50%

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
        0x68, 0x87, 0x6D, 0x0C, 0xE9, 0xCA, 0xC5, 0xB3, 0x0F, 0x65, 0x9C, 0x91, 0x97, 0x04, 0x9A, 0x11,
        0xB9, 0xC9, 0xFC, 0x8D, 0x60, 0x3B, 0xF8, 0x80, 0x52, 0x8B, 0xFF, 0x1F, 0xEF, 0x66, 0x1C, 0x85,
        0x19, 0x9A, 0x46, 0x29, 0xEC, 0xB1, 0x79, 0xE7, 0x45, 0x8F, 0x3E, 0xFE, 0xE8, 0xBC, 0x9B, 0xC3,
        0x6B, 0xDE, 0x5B, 0x4D, 0xDC, 0x86, 0xC0, 0x3A, 0x88, 0x2F, 0x37, 0x93, 0xE5, 0x8B, 0x6F, 0x90,
        0xB4, 0x52, 0x6F, 0xA7, 0x5B, 0x8D, 0x02, 0x77, 0x96, 0xFC, 0xF4, 0xE8, 0x51, 0xF4, 0x70, 0xFC,
        0x7F, 0x25, 0x14, 0x4C, 0xD7, 0xE3, 0x05, 0x19, 0x01, 0x22, 0xD0, 0xA3, 0x86, 0xA8, 0x87, 0xA6,
        0xCD, 0xDA, 0x35, 0x10, 0x86, 0x41, 0x51, 0x55, 0x27, 0xAC, 0xB2, 0x3E, 0x8A, 0x54, 0x37, 0xB7,
        0xF6, 0xC3, 0xBE, 0x24, 0x06, 0xFA, 0x85, 0xF4, 0x48, 0xBD, 0xB9, 0x71, 0x8B, 0xBD, 0x91, 0x17
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE,
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE,
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE,
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE,
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE,
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE,
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE,
        0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_B_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_B_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_B_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_B_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_B_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_B_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_C_PasswordJumpAddCipher {

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
    // bit0 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit1 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit2 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit3 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 18.75%

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
        0xA7, 0x5B, 0x8C, 0x88, 0x28, 0xCB, 0xD7, 0x95, 0xFA, 0x98, 0xAA, 0x6C, 0xBA, 0x4C, 0xF2, 0xD8,
        0x75, 0xF1, 0x4D, 0xE8, 0x03, 0x7A, 0x76, 0xA0, 0x59, 0x11, 0xD7, 0x7B, 0x8F, 0xD7, 0xB2, 0x4B,
        0xB1, 0xC5, 0xCF, 0xB9, 0x7F, 0xFC, 0x0B, 0x46, 0x4F, 0x82, 0xD9, 0xD4, 0x67, 0x9F, 0x92, 0x50,
        0xCB, 0xC9, 0x4D, 0xB1, 0xF9, 0xE2, 0x00, 0x84, 0x2F, 0x6E, 0x82, 0xBF, 0x4D, 0x0F, 0x2E, 0xBE,
        0x5E, 0xA1, 0x7F, 0x0E, 0x67, 0x07, 0x88, 0xAF, 0xFA, 0xE5, 0x20, 0xB1, 0x83, 0xFA, 0x42, 0x63,
        0x1E, 0x2A, 0x0B, 0x4F, 0x19, 0xCB, 0x3F, 0xB3, 0x5A, 0x24, 0xF2, 0x27, 0x39, 0xA7, 0x15, 0xEF,
        0xAD, 0x00, 0xF1, 0xEC, 0xB1, 0x92, 0x60, 0xC0, 0x3C, 0x68, 0x68, 0x35, 0x53, 0xFC, 0x76, 0xEC,
        0xE3, 0xE5, 0x83, 0x30, 0xCB, 0x16, 0xB3, 0x64, 0xC8, 0xAD, 0x16, 0xE8, 0x05, 0xB4, 0x3A, 0x66
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_C_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_C_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_C_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_C_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_C_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_C_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_D_PasswordJumpAddCipher {

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
    // bit5 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 43.75%

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
        0xCC, 0x02, 0x18, 0x7B, 0x35, 0x5B, 0x02, 0x67, 0xF7, 0xE6, 0x79, 0x65, 0xA5, 0x43, 0x69, 0x23,
        0xBB, 0x4B, 0xB3, 0xB7, 0x64, 0x7B, 0x83, 0x28, 0x37, 0x7F, 0x45, 0x9A, 0xBA, 0x41, 0x24, 0xA7,
        0xCA, 0x7E, 0x00, 0xD6, 0x75, 0x6B, 0x9E, 0x1B, 0xC7, 0xAF, 0x61, 0x78, 0x8F, 0x19, 0x65, 0x48,
        0xBE, 0x97, 0xB4, 0xAC, 0xF7, 0x88, 0xCD, 0xA8, 0x41, 0x3C, 0xA6, 0x08, 0x91, 0x34, 0x8F, 0x3A,
        0x06, 0x16, 0x54, 0x79, 0xC8, 0x51, 0xEA, 0xF5, 0xA0, 0xD0, 0x3D, 0xBC, 0x7C, 0x8D, 0xCE, 0x59,
        0x44, 0x69, 0x2C, 0xA2, 0x94, 0x88, 0xC0, 0x5E, 0x60, 0x03, 0x24, 0x3D, 0xB9, 0x9F, 0xBC, 0x64,
        0x2C, 0x9D, 0x9F, 0xD6, 0x2E, 0x87, 0x15, 0x77, 0xF3, 0x87, 0x0B, 0x25, 0x9F, 0x18, 0x92, 0xD2,
        0x64, 0x6D, 0xDB, 0x0E, 0x32, 0x1C, 0xAB, 0xED, 0x70, 0x79, 0x1B, 0xB3, 0xA7, 0x13, 0x48, 0xF3
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_D_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_D_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_D_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_D_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_D_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_D_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_E_PasswordJumpAddCipher {

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
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.  X.X.X.X.
    // Avalanche: 31.25%

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
        0x5A, 0x84, 0x27, 0x3C, 0xB2, 0x90, 0x64, 0x6B, 0x8C, 0x1A, 0xA9, 0x29, 0x9B, 0x0F, 0x53, 0x09,
        0x59, 0xC7, 0x89, 0xE7, 0x22, 0x2C, 0x0A, 0xA1, 0x85, 0x19, 0xA1, 0x77, 0x98, 0x36, 0x0B, 0x56,
        0x45, 0xA9, 0xA1, 0x92, 0x13, 0xCC, 0xBD, 0xCA, 0x48, 0x2B, 0xD4, 0xA2, 0x49, 0x5E, 0xC7, 0xEE,
        0x1A, 0x2F, 0x11, 0x77, 0x1F, 0x56, 0x03, 0xB6, 0x8F, 0x71, 0xC3, 0x5B, 0xA7, 0x7A, 0xF7, 0x60,
        0x6F, 0xB6, 0x92, 0x53, 0xCB, 0x64, 0x7A, 0x5C, 0x03, 0xF5, 0x72, 0xD0, 0x9A, 0x20, 0xCA, 0x56,
        0x19, 0xCC, 0xEC, 0x27, 0xEB, 0x0E, 0x88, 0xAB, 0x20, 0xC5, 0x16, 0xE2, 0x77, 0xF1, 0x9A, 0xCF,
        0x97, 0x06, 0xE3, 0x39, 0xA4, 0x83, 0x7C, 0x49, 0x6F, 0xA2, 0x27, 0x24, 0x49, 0xC0, 0x80, 0x41,
        0xF8, 0x82, 0x99, 0x7D, 0xF8, 0xEB, 0x9B, 0x1B, 0xAC, 0xC3, 0x1A, 0xA3, 0x72, 0x1A, 0x6B, 0x50
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_E_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_E_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_E_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_E_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_E_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_E_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_F_PasswordJumpAddCipher {

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
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit5 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
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
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 93.75%

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
        0x18, 0x62, 0xAE, 0xDF, 0x4B, 0xBB, 0x78, 0x13, 0x24, 0xC3, 0x02, 0x2B, 0xEA, 0x6A, 0x0B, 0x9F,
        0xEB, 0x72, 0x65, 0x7B, 0x78, 0xB4, 0xA0, 0xD7, 0xBC, 0x70, 0xDF, 0x3E, 0x08, 0xD1, 0x6A, 0x6C,
        0xC2, 0x0B, 0x65, 0xBD, 0x9C, 0x10, 0x48, 0xEC, 0x4F, 0x04, 0x09, 0x1D, 0x17, 0x89, 0x8B, 0x59,
        0x1B, 0xE5, 0x4C, 0x74, 0xC3, 0x81, 0xC7, 0x6C, 0xB5, 0xD7, 0xAB, 0xAD, 0xB2, 0x14, 0x18, 0xBE,
        0x81, 0x77, 0x51, 0x13, 0xB1, 0xC2, 0x6B, 0x2E, 0xBA, 0x7A, 0x72, 0x97, 0x17, 0x1F, 0x04, 0xA2,
        0x0F, 0xFA, 0xA8, 0x94, 0x00, 0xDD, 0x75, 0x25, 0x7F, 0xB8, 0x1A, 0x19, 0x24, 0x6B, 0x04, 0x6A,
        0xA0, 0xD0, 0x0C, 0x18, 0xD3, 0x7E, 0xE6, 0xA3, 0x8E, 0x18, 0x42, 0x85, 0x74, 0xFC, 0x03, 0x08,
        0xD5, 0xD2, 0x61, 0x66, 0x8D, 0x69, 0x19, 0x23, 0x06, 0xE6, 0x91, 0x1E, 0x45, 0xB8, 0xF5, 0x07
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_F_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_F_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_F_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_F_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_F_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_F_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_G_PasswordJumpAddCipher {

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
    // bit0 10101001  10101010  10101001  10101010  10100110  10101001  10101010  01101010  10011010  10100110  10101001  10101010  10101001  10101010  10100110  10101001
    // bit1 10010110  10100101  01100110  10011001  01011010  10010110  10100101  10101001  01100110  01011001  10010110  10100101  01100110  10011001  01011010  10010110
    // bit2 10010101  10100101  01011010  01010110  01010110  10010101  10100101  01101001  01101010  10011010  10010101  10100101  01011010  01010110  01010110  10010101
    // bit3 01100110  10011001  10011010  01100110  10011010  01100110  10011001  10100110  00010100  10000101  01100110  10011001  10011010  01100110  10011010  01100110
    // bit4 01100101  10011001  10100101  01101001  10010110  01100101  10011001  01100110  11101011  10111010  01100101  10011001  10100101  01101001  10010110  01100101
    // bit5 01011010  10010110  01000010  01010000  01101010  01011010  10010110  10100101  11100111  10111001  01011010  10010110  01000010  01010000  01101010  01011010
    // bit6 01011001  10010110  10111110  10101111  01100110  01011001  10010110  01100101  11000011  01110000  01011001  10010110  10111110  10101111  01100110  01011001
    // bit7 00000000  00000000  00111100  00001111  00000000  00000000  00000000  00000000  11111111  00111111  00000000  00000000  00111100  00001111  00000000  00000000
    //
    // Avalanche:
    // bit0 ......XX  ........  ......XX  ........  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  ......XX  ........  ....XX..  ......XX
    // bit1 ..XXXXXX  ....XXXX  ....XX..  ......XX  XXXXXX..  ..XXXXXX  ....XXXX  XX....XX  XXXXXX..  XXXXXXXX  ..XXXXXX  ....XXXX  ....XX..  ......XX  XXXXXX..  ..XXXXXX
    // bit2 ......XX  ........  XXXX..XX  ..XXXX..  ....XX..  ......XX  ........  XX......  ........  XX......  ......XX  ........  XXXX..XX  ..XXXX..  ....XX..  ......XX
    // bit3 XXXX..XX  ..XXXX..  XXXX..XX  ..XXXX..  XX..XX..  XXXX..XX  ..XXXX..  XX..XXXX  .X..XXX.  XX.X..XX  XXXX..XX  ..XXXX..  XXXX..XX  ..XXXX..  XX..XX..  XXXX..XX
    // bit4 ......XX  ........  ......XX  ........  ....XX..  ......XX  ........  XX......  X.....X.  ..X.....  ......XX  ........  ......XX  ........  ....XX..  ......XX
    // bit5 ..XXXXXX  ....XXXX  ..X..X..  ....X..X  XXXXXX..  ..XXXXXX  ....XXXX  XX....XX  X.XXXXX.  ..X.XXXX  ..XXXXXX  ....XXXX  ..X..X..  ....X..X  XXXXXX..  ..XXXXXX
    // bit6 ......XX  ........  ...XX.XX  .....XX.  ....XX..  ......XX  ........  XX......  .XX.X.X.  ...XX.X.  ......XX  ........  ...XX.XX  .....XX.  ....XX..  ......XX
    // bit7 .X.XX..X  X..X.XX.  .X.XX..X  X..X.XX.  .XX..XX.  .X.XX..X  X..X.XX.  .XX..X.X  .XX..XX.  .X.XX..X  .X.XX..X  X..X.XX.  .X.XX..X  X..X.XX.  .XX..XX.  .X.XX..X
    // Avalanche: 39.06%

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
        0xED, 0x6D, 0x09, 0xE7, 0x2B, 0x30, 0xCA, 0x15, 0x25, 0x56, 0x81, 0xBC, 0x93, 0xED, 0x71, 0x78,
        0x1D, 0x45, 0xD0, 0x03, 0x3D, 0x1A, 0xE9, 0xF4, 0x95, 0x12, 0xA4, 0xDD, 0xD2, 0xB9, 0x6B, 0xEF,
        0x2E, 0x0C, 0x75, 0xCC, 0xBD, 0x2A, 0xFC, 0xDA, 0x3B, 0xE1, 0xD8, 0x88, 0x5B, 0x5A, 0x14, 0x2A,
        0x59, 0xD7, 0x3D, 0x59, 0x20, 0xD6, 0x20, 0x58, 0x91, 0x17, 0x0D, 0x94, 0x97, 0x61, 0x6B, 0x50,
        0xA6, 0x72, 0x53, 0xAE, 0x10, 0xBE, 0xD6, 0x5E, 0xA2, 0x49, 0x92, 0xA6, 0x3B, 0xB6, 0x3F, 0xEF,
        0xF6, 0x77, 0x91, 0x76, 0x0E, 0x50, 0xA1, 0x77, 0x68, 0x14, 0xDA, 0x07, 0x5F, 0x24, 0xC2, 0x47,
        0x6B, 0x43, 0xFD, 0x54, 0xBA, 0xD7, 0xA7, 0x7F, 0x7E, 0x6E, 0x95, 0x82, 0xE9, 0xC6, 0x63, 0x1D,
        0x3C, 0x72, 0xC3, 0xFD, 0xE9, 0xA4, 0x78, 0x50, 0xC0, 0xDF, 0x33, 0x72, 0xA3, 0x06, 0x8A, 0xCD
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78,
        0x9A, 0x64, 0xCB, 0x33, 0xB3, 0x4B, 0x76, 0x88, 0xC2, 0x3C, 0x9A, 0x64, 0xCB, 0x33, 0xB3, 0x4B,
        0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA,
        0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66,
        0x8F, 0x6F, 0x6D, 0x91, 0xA9, 0x55, 0xEF, 0x0F, 0xBC, 0x42, 0x8F, 0x6F, 0x6D, 0x91, 0xA9, 0x55,
        0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78,
        0x9A, 0x64, 0xCB, 0x33, 0xB3, 0x4B, 0x76, 0x88, 0xC2, 0x3C, 0x9A, 0x64, 0xCB, 0x33, 0xB3, 0x4B,
        0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_G_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_G_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_G_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_G_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_G_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_G_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_H_PasswordJumpAddCipher {

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
    // bit0 01100101  01011001  01010110  01010101  01011001  01010110  01011001  01010110  01100101  01011001  01100101  01011001  01010110  01010101  10010101  01100101
    // bit1 01011010  01010110  10010101  10100101  10010110  01100101  10010110  01100101  01011001  10010110  01011010  01010110  10011001  10100110  01100110  01011001
    // bit2 01101010  01011010  10010110  10100101  10100101  10101001  10100101  10101001  10010110  10100101  01101010  01011010  01010101  10010101  01011010  10010110
    // bit3 01011001  10010110  01100101  10011001  01100101  10011001  01100101  10011001  10010110  01100101  01011001  10010110  01001010  00010010  01011001  10010110
    // bit4 01101001  10011010  01100110  10011001  01101010  01011010  01101010  01011010  10101001  01101010  01101001  10011010  01110101  11011101  10100101  10101001
    // bit5 01010110  10010101  10100101  01101001  10100100  00101001  10100100  00101001  10010000  10100100  01010110  10010101  01111001  11011110  01000010  10010000
    // bit6 01100110  10011001  10100110  01101001  01010111  11010101  01010111  11010101  01011111  01010111  01100110  10011001  10110000  11101100  01111101  01011111
    // bit7 00000000  00000000  00000000  00000000  00000011  11000000  00000011  11000000  00001111  00000011  00000000  00000000  00111111  11001111  00111100  00001111
    //
    // Avalanche:
    // bit0 ..XX....  ....XX..  ......XX  ........  ....XX..  ......XX  ....XX..  ......XX  ..XX....  ....XX..  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....
    // bit1 ..XXXXXX  ....XXXX  XX....XX  XXXX....  ......XX  ........  XX..XXXX  ..XX..XX  ....XX..  ......XX  ..XXXXXX  ....XXXX  XX..XXXX  XXXX..XX  XXXX..XX  ..XXXX..
    // bit2 ..XX....  ....XX..  ......XX  ........  XX..XX..  XXXX..XX  XXXX..XX  ..XXXX..  ..XX..XX  XX..XX..  ..XX....  ....XX..  XX......  ..XX....  ..XX..XX  XX..XX..
    // bit3 ..XX..XX  XX..XX..  XXXX..XX  ..XXXX..  XX..XX..  XXXX..XX  ..XXXXXX  ....XXXX  ..XX..XX  XX..XX..  ..XX..XX  XX..XX..  XX.XXX..  X.XX.XXX  XXXX....  XXXXXX..
    // bit4 ..XX....  ....XX..  ......XX  ........  ....XX..  ......XX  XXXXXX..  ..XXXXXX  ..XX....  ....XX..  ..XX....  ....XX..  ...X....  .X...X..  XX....XX  XXXX....
    // bit5 ..XXXXXX  ....XXXX  XX....XX  XXXX....  ......X.  .X......  ..XXXXX.  .X..XXXX  ....X..X  ......X.  ..XXXXXX  ....XXXX  ...XXXXX  .X...XXX  XXX..X..  XXXXX..X
    // bit6 ..XX....  ....XX..  ......XX  ........  ....XX.X  X.....XX  XX....X.  .XXX....  ..XX.XX.  ....XX.X  ..XX....  ....XX..  ...X.X.X  X....X.X  ..X..XXX  ....X..X
    // bit7 .XX..XX.  X..XX..X  X.X..XX.  .XX.X..X  X..XX..X  X.X..XX.  X..XX.X.  .XX..XX.  .XX..XX.  X..XX..X  .XX..XX.  X..XX..X  X..XX..X  X.X..XX.  X.X..XX.  .XX.X..X
    // Avalanche: 41.70%

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
        0x81, 0xFA, 0x1F, 0xDB, 0xAB, 0x23, 0xBB, 0xB9, 0xFF, 0x14, 0x33, 0x22, 0x0D, 0xEA, 0x58, 0x13,
        0x41, 0xDB, 0x8C, 0x30, 0xBA, 0x15, 0xA4, 0xFD, 0x9E, 0x5B, 0xC4, 0xA0, 0x5C, 0x51, 0x42, 0x5B,
        0x26, 0x95, 0x2B, 0x14, 0x06, 0xC1, 0x2F, 0xD3, 0xA9, 0x8A, 0xE7, 0x92, 0x86, 0xDC, 0xC6, 0xF7,
        0xB5, 0x3B, 0x47, 0xFB, 0x67, 0xBB, 0x57, 0xEA, 0x60, 0x30, 0xFE, 0x4F, 0x47, 0xE5, 0x85, 0xE3,
        0x77, 0xB0, 0xD9, 0xF4, 0xE7, 0x2F, 0x95, 0x60, 0x72, 0x47, 0x70, 0x7D, 0xBE, 0xC0, 0x6F, 0x47,
        0xCE, 0xED, 0x1F, 0xFB, 0x9A, 0x09, 0x3F, 0x2C, 0x2F, 0x0B, 0x79, 0x02, 0x05, 0x69, 0x23, 0x6B,
        0x70, 0xF6, 0x8D, 0x6C, 0xF2, 0xBD, 0xC7, 0xAB, 0xF1, 0x4A, 0xC2, 0x88, 0xB0, 0xCA, 0xBC, 0x14,
        0xEC, 0xDA, 0x47, 0x23, 0x90, 0x70, 0x3B, 0x79, 0x6E, 0xDE, 0xD4, 0x60, 0xED, 0xD3, 0xCB, 0xB6
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86,
        0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE,
        0x64, 0x9A, 0x3C, 0xC2, 0x88, 0x76, 0x4B, 0xB3, 0x33, 0xCB, 0x64, 0x9A, 0x3C, 0xC2, 0x88, 0x76,
        0x64, 0x9A, 0x3C, 0xC2, 0x88, 0x76, 0x4B, 0xB3, 0x33, 0xCB, 0x64, 0x9A, 0x3C, 0xC2, 0x88, 0x76,
        0x3C, 0xC2, 0x88, 0x76, 0x4B, 0xB3, 0x33, 0xCB, 0x64, 0x9A, 0x3C, 0xC2, 0x88, 0x76, 0x4B, 0xB3,
        0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86,
        0x42, 0xBC, 0x0F, 0xEF, 0x55, 0xA9, 0x91, 0x6D, 0x6F, 0x8F, 0x42, 0xBC, 0x0F, 0xEF, 0x55, 0xA9,
        0x88, 0x76, 0x4B, 0xB3, 0x33, 0xCB, 0x64, 0x9A, 0x3C, 0xC2, 0x88, 0x76, 0x4B, 0xB3, 0x33, 0xCB
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_H_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_H_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_H_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_H_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_H_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_H_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_I_PasswordJumpAddCipher {

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
    // bit0 10001010  11100010  10101110  00101011  00101011  10001010  10111000  10101110  00101011  10001010  10001010  11100010  10111000  10101110  10111000  10101110
    // bit1 11100110  00111001  11110000  10111100  10111100  00101111  11000010  11110000  10111100  00101111  11100110  00111001  11000010  11110000  00001111  01000011
    // bit2 11000110  01110001  00011001  11000110  11000110  01110001  01100111  00011001  11000110  01110001  11000110  01110001  01100111  00011001  10001010  11100010
    // bit3 00101111  00001011  00001011  11000010  11000010  11110000  00101111  00001011  11000010  11110000  00101111  00001011  00101111  00001011  00010001  10000100
    // bit4 00001111  01000011  11000110  01110001  01110001  10011100  00011001  11000110  01110001  10011100  00001111  01000011  00011001  11000110  11101010  11111010
    // bit5 01100011  10011000  00010000  11000100  11000100  00110001  01000011  00010000  11000100  00110001  01100011  10011000  01000011  00010000  01101011  11011010
    // bit6 01000011  11010000  11101011  10111010  10111010  11101110  10101110  11101011  10111010  11101110  01000011  11010000  10101110  11101011  01101100  01011011
    // bit7 00000000  00000000  11001001  00110010  00110010  01001100  00100100  11001001  00110010  01001100  00000000  00000000  00100100  11001001  11111011  01111110
    //
    // Avalanche:
    // bit0 ..X.....  .X..X...  .....X..  X......X  X......X  ..X.....  ...X..X.  .....X..  X......X  ..X.....  ..X.....  .X..X...  ...X..X.  .....X..  ...X..X.  .....X..
    // bit1 .XX.XX..  XX.XX.XX  .X..X...  ...X..X.  X..X.XXX  X.X..X.X  ..X.....  .X..X...  ...X..X.  .....X..  .XX.XX..  XX.XX.XX  .XXXX.X.  .X.XXXX.  ..X..X..  XX..X..X
    // bit2 ..X.....  .X..X...  X..X.XXX  X.X..X.X  .X.XXXX.  X..X.XXX  .X.XXXX.  X..X.XXX  X.X..X.X  XXX.X..X  ..X.....  .X..X...  XXX.X..X  .XXXX.X.  ...X..X.  .....X..
    // bit3 XXX.X..X  .XXXX.X.  X..X.XXX  X.X..X.X  XX.XX.XX  ..XX.XX.  .X.XXXX.  X..X.XXX  X.X..X.X  XXX.X..X  XXX.X..X  .XXXX.X.  X.XX..XX  .XX.XX..  ....X...  .X....X.
    // bit4 ..X.....  .X..X...  .....X..  X......X  XX..XX.X  X.XX..XX  ...X..X.  .....X..  X......X  ..X.....  ..X.....  .X..X...  XX.XX.XX  ..XX.XX.  .X.X.XX.  XX.X.X.X
    // bit5 .XX.XX..  XX.XX.XX  XX......  ..XX....  XXXXX..X  ..XXXXX.  ........  XX......  ..XX....  ....XX..  .XX.XX..  XX.XX.XX  X..X..XX  XXX..X..  .X.X.XX.  XX.X.X.X
    // bit6 ..X.....  .X..X...  ....XX.X  X.....XX  ..XX.X..  X...XX.X  ..XX.XX.  ....XX.X  X.....XX  .XX.....  ..X.....  .X..X...  .X..X...  XX.X..X.  XXX...X.  ..XXX...
    // bit7 .X....XX  XX.X....  ..XXXX.X  ....XXXX  ..XXXX.X  ....XXXX  XXXX.X..  ..XXXX.X  ....XXXX  .X....XX  .X....XX  XX.X....  XX.X....  XXXX.X..  XXXX.X..  ..XXXX.X
    // Avalanche: 40.72%

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
        0x94, 0x08, 0x92, 0x19, 0x0E, 0xDE, 0x36, 0xCA, 0x68, 0xE6, 0x19, 0xE4, 0xF5, 0x7E, 0x4A, 0xBE,
        0xC1, 0x48, 0x66, 0xEC, 0x37, 0x0D, 0x26, 0x5F, 0xC0, 0xA9, 0x08, 0x5D, 0x6C, 0xE9, 0x29, 0x1F,
        0x0F, 0xD7, 0x16, 0x3D, 0x19, 0xDF, 0x8F, 0x0C, 0x37, 0x02, 0x89, 0xA8, 0x0A, 0xA0, 0xD6, 0xF2,
        0x05, 0x66, 0x08, 0xE8, 0xEB, 0xEF, 0x68, 0xF3, 0x8C, 0x2B, 0xF1, 0xDC, 0xAE, 0x03, 0x14, 0xF1,
        0x07, 0xDD, 0xE6, 0x8F, 0x3D, 0xBB, 0x56, 0x0E, 0xE1, 0xAB, 0x4E, 0xF2, 0xA2, 0x24, 0x82, 0xC4,
        0x92, 0x18, 0x75, 0x3B, 0x08, 0x43, 0xCE, 0xD6, 0x9B, 0x95, 0xBC, 0xC6, 0x87, 0x2C, 0x4C, 0xD0,
        0x8F, 0x62, 0x9B, 0xAA, 0x2A, 0x96, 0x11, 0xB8, 0x07, 0x97, 0x45, 0x75, 0x2C, 0x1E, 0x50, 0xB8,
        0xE7, 0x2E, 0x46, 0x1F, 0x7D, 0x1B, 0x8F, 0x1A, 0xC4, 0xE8, 0x8F, 0x1A, 0xAD, 0x1C, 0x3F, 0xE2
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78,
        0xCB, 0x4B, 0xC2, 0x64, 0xB3, 0x88, 0x9A, 0x33, 0x76, 0x3C, 0xCB, 0x4B, 0xC2, 0x64, 0xB3, 0x88,
        0x76, 0x3C, 0xCB, 0x4B, 0xC2, 0x64, 0xB3, 0x88, 0x9A, 0x33, 0x76, 0x3C, 0xCB, 0x4B, 0xC2, 0x64,
        0xC2, 0x64, 0xB3, 0x88, 0x9A, 0x33, 0x76, 0x3C, 0xCB, 0x4B, 0xC2, 0x64, 0xB3, 0x88, 0x9A, 0x33,
        0x76, 0x3C, 0xCB, 0x4B, 0xC2, 0x64, 0xB3, 0x88, 0x9A, 0x33, 0x76, 0x3C, 0xCB, 0x4B, 0xC2, 0x64,
        0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78,
        0xC2, 0x64, 0xB3, 0x88, 0x9A, 0x33, 0x76, 0x3C, 0xCB, 0x4B, 0xC2, 0x64, 0xB3, 0x88, 0x9A, 0x33,
        0xA9, 0x0F, 0x8F, 0x91, 0xEF, 0x42, 0x6D, 0x55, 0xBC, 0x6F, 0xA9, 0x0F, 0x8F, 0x91, 0xEF, 0x42
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_I_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_I_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_I_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_I_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_I_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_I_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_J_PasswordJumpAddCipher {

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
    // bit0 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit3 10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010
    // bit4 11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111  11111111
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101  01010101
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit4 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X
    // Avalanche: 68.75%

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
        0xE1, 0xAB, 0xFC, 0x85, 0x19, 0xA7, 0xB8, 0xBB, 0xF1, 0xF6, 0x56, 0x37, 0x82, 0xD6, 0x10, 0x99,
        0x55, 0x5D, 0xA0, 0xCC, 0xA2, 0xA0, 0x38, 0xB8, 0x17, 0xCA, 0x3A, 0x67, 0xB4, 0x23, 0xDC, 0x90,
        0x64, 0x5F, 0xC8, 0xA7, 0x82, 0x35, 0x77, 0x5D, 0x55, 0x35, 0xAE, 0xB9, 0xBF, 0x4F, 0xAA, 0xCE,
        0xCE, 0xFF, 0xFA, 0xAA, 0x3D, 0x77, 0xAD, 0x7E, 0x63, 0x9A, 0x93, 0x0D, 0x16, 0x7C, 0x70, 0xAB,
        0xD9, 0xC7, 0x33, 0xAC, 0x91, 0x48, 0x8C, 0xB3, 0x01, 0x74, 0x08, 0x38, 0x9D, 0x0A, 0xBD, 0x9E,
        0x07, 0x3D, 0xAB, 0xBB, 0x96, 0xE3, 0x44, 0xDB, 0xBD, 0xF2, 0xDD, 0x4B, 0xB6, 0xCF, 0xA8, 0xE0,
        0xFF, 0x07, 0x6D, 0x3C, 0x36, 0xA7, 0xB9, 0x31, 0x30, 0x8D, 0x07, 0x04, 0x90, 0x13, 0xB3, 0xF6,
        0x16, 0x57, 0x4C, 0xA7, 0xB2, 0x92, 0xDC, 0xFD, 0x44, 0x58, 0x18, 0x62, 0xA3, 0x58, 0x89, 0x77
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA,
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA,
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA,
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA,
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA,
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA,
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA,
        0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA, 0x98, 0xAA
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_J_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_J_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_J_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_J_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_J_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_J_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_K_PasswordJumpAddCipher {

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
    // bit0 10101010  10101010  10101010  01010101  10101010  10101010  10101010  10101010  10101010  10101010  10101010  10101010  01010101  10101010  10101010  10101010
    // bit1 10101010  01010101  01010101  10101010  10101010  01010101  01010101  01010101  01010101  10101010  01010101  10101010  10101010  01010101  10101010  10101010
    // bit2 10101010  01010101  10101010  10101010  10101010  10101010  01010101  01010101  01010101  01010101  01010101  01010101  10101010  10101010  10101010  10101010
    // bit3 01010101  10101010  10101010  10101010  00000000  10101010  10101010  01010101  10101010  01010101  10101010  01010101  01010101  01010101  10101010  01010101
    // bit4 01010101  10101010  01010101  01010101  11111111  10101010  10101010  01010101  10101010  10101010  10101010  10101010  10101010  10101010  10101010  01010101
    // bit5 01010101  01010101  00000000  10101010  11111111  10101010  01010101  10101010  01010101  00000000  01010101  00000000  10101010  01010101  10101010  01010101
    // bit6 01010101  01010101  11111111  10101010  11111111  01010101  01010101  10101010  10101010  11111111  10101010  11111111  00000000  00000000  10101010  01010101
    // bit7 00000000  00000000  11111111  00000000  11111111  00000000  00000000  00000000  00000000  11111111  00000000  11111111  11111111  11111111  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  XXXXXXXX  ........  ........  ........  ........  ........  ........  ........  ........  XXXXXXXX  ........  ........  ........
    // bit1 ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  ........  ........  ........  ........  ........
    // bit2 ........  ........  XXXXXXXX  ........  ........  ........  ........  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  XXXXXXXX  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX  X.X.X.X.  ........  XXXXXXXX  ........  XXXXXXXX  XXXXXXXX  ........  ........  ........  ........  ........  XXXXXXXX
    // bit4 ........  ........  ........  XXXXXXXX  .X.X.X.X  XXXXXXXX  ........  ........  ........  ........  XXXXXXXX  ........  XXXXXXXX  ........  ........  ........
    // bit5 ........  XXXXXXXX  .X.X.X.X  XXXXXXXX  .X.X.X.X  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  X.X.X.X.  ........  X.X.X.X.  XXXXXXXX  ........  ........  ........
    // bit6 ........  ........  .X.X.X.X  ........  .X.X.X.X  ........  ........  ........  ........  .X.X.X.X  XXXXXXXX  X.X.X.X.  X.X.X.X.  X.X.X.X.  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  X.X.X.X.  .X.X.X.X
    // Avalanche: 36.72%

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
        0xC5, 0x68, 0x0E, 0x65, 0xF4, 0x58, 0xB6, 0xD1, 0x7B, 0x80, 0x83, 0x66, 0xF6, 0x74, 0x26, 0x6B,
        0xF2, 0x22, 0x12, 0x82, 0x76, 0xC1, 0x91, 0xB9, 0x70, 0xD5, 0xE5, 0x82, 0xD4, 0x82, 0x9C, 0x84,
        0x40, 0x59, 0xCB, 0x81, 0xC6, 0x7D, 0xF6, 0x8A, 0xF4, 0xB7, 0xA2, 0x6D, 0x1B, 0x25, 0x3D, 0x30,
        0x74, 0x92, 0x9F, 0xD9, 0x9F, 0x13, 0x8B, 0x20, 0xDC, 0xFB, 0x2D, 0x05, 0xF7, 0x7B, 0x8C, 0xE8,
        0x32, 0x60, 0x62, 0x5E, 0x99, 0x7A, 0xE1, 0xDE, 0x40, 0xAD, 0x71, 0x93, 0x91, 0x2D, 0xA3, 0xC3,
        0x9E, 0x2B, 0x04, 0xD3, 0xD7, 0x8A, 0x3D, 0x64, 0x4B, 0x8C, 0xA0, 0x6E, 0xA8, 0x33, 0x32, 0xF2,
        0x1D, 0x2A, 0xFD, 0x60, 0x89, 0xF8, 0x8F, 0x1C, 0x08, 0x4B, 0x3E, 0xFE, 0x6A, 0xBF, 0xE0, 0x48,
        0x65, 0x32, 0xEC, 0x0A, 0x2D, 0x26, 0xFA, 0xCF, 0xDB, 0x68, 0x46, 0xFD, 0x21, 0x8A, 0xE7, 0x7D
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0xB3, 0x4B, 0xB3, 0x4B, 0xB3, 0x4B, 0xB3, 0x4B, 0x76, 0x88, 0x76, 0x88, 0x76, 0x88, 0x76, 0x88,
        0xEF, 0x0F, 0xEF, 0x0F, 0xEF, 0x0F, 0xEF, 0x0F, 0xBC, 0x42, 0xBC, 0x42, 0xBC, 0x42, 0xBC, 0x42,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x9A, 0x64, 0x9A, 0x64, 0x9A, 0x64, 0x9A, 0x64, 0xCB, 0x33, 0xCB, 0x33, 0xCB, 0x33, 0xCB, 0x33,
        0x9A, 0x64, 0x9A, 0x64, 0x9A, 0x64, 0x9A, 0x64, 0xCB, 0x33, 0xCB, 0x33, 0xCB, 0x33, 0xCB, 0x33,
        0x6D, 0x91, 0x6D, 0x91, 0x6D, 0x91, 0x6D, 0x91, 0xA9, 0x55, 0xA9, 0x55, 0xA9, 0x55, 0xA9, 0x55,
        0xFE, 0x00, 0xFE, 0x00, 0xFE, 0x00, 0xFE, 0x00, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_K_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_K_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_K_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_K_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_K_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_K_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_L_PasswordJumpAddCipher {

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
    // bit0 10000101  01010101  11011111  01111101  11111110  11011011  10000101  11101010  11110111  11011111  01001000  01010001  01011111  11101111  01011110  11011111
    // bit1 10101010  10101000  11011011  11101101  10111110  11111111  10101111  01010101  10111110  11011011  01000001  00100101  11111111  01111101  10111110  11111011
    // bit2 10101010  00010101  11111111  11101111  10110101  01011111  01111010  10101000  11111110  11111011  11111110  11111110  01111010  10101101  01011110  10001011
    // bit3 01010000  10101000  11111111  11000111  11110111  11011110  01010000  10101000  11111100  01111111  00011100  01011010  11011011  11101101  10110110  11011011
    // bit4 01010000  00010101  01011010  00010111  11101010  11111010  01010101  01010111  10100001  01111110  01001010  11110100  01011111  01010111  01011111  11010101
    // bit5 01111111  11101000  01011011  11101111  10100000  01011111  01111010  00000000  10111110  11111010  01001010  10100100  11111010  00101101  10111111  10001111
    // bit6 01111111  01010101  01111111  11101101  11101011  11111111  10000101  11111101  11111110  11011110  01010101  00101011  01011111  11111101  00011111  11111111
    // bit7 00000000  00000000  01111110  00000101  10101011  11111010  00000101  11111101  11100000  01011010  11100000  01110101  01011111  11010101  01011111  11010101
    //
    // Avalanche:
    // bit0 ........  X.XXXX.X  X......X  XXXXX...  ...X.XX.  X....X.X  ........  ......X.  X.X.X..X  .X.XX.X.  X.X.....  ....XXXX  XX.XX.X.  .....XXX  ........  .X.XX.X.
    // bit1 ..X.XXXX  XXXXXX.X  X....X.X  .XX.XX.X  ...X.XX.  X.X....X  ........  X.XXXX.X  XXX.X.XX  X...XXX.  X.X.X..X  ..X.XXXX  .XXXX.X.  X..X.XXX  .X......  .XXXXXX.
    // bit2 ........  X.XXXX.X  X.X.X.X.  X..X....  .X.XXX.X  .X.XXXX.  ..X.XXXX  .X....X.  .X.X.X..  .XXXXXX.  X.X.X..X  ........  XXXXX.X.  X.XXX...  ........  ..X....X
    // bit3 XXXXX.X.  X.XXXX.X  X.X.X.X.  X.XXXX.X  .X.XXXXX  XX.XXXXX  ..X.XXXX  .X....X.  .X.XXX.X  ..X.X.X.  .X..X.XX  XXXX....  .X.XX.XX  XXXXX.X.  .X..X...  .XXX...X
    // bit4 ........  X.XXXX.X  .X.X....  X.XXX...  ........  ....XXXX  ........  ......X.  X.X.X.XX  XXXXXXX.  XXX.....  ....X.X.  XXXX....  ......X.  ....X.X.  X....X.X
    // bit5 ..X.XXXX  XXXXXX.X  .X.X...X  .X...X.X  ....X.X.  X.X.X.X.  .....X.X  .X.X.X.X  X.XXXXXX  X.X.X.X.  XXX.....  ....XXX.  .X.X.X.X  .XXXX.X.  .X..X.X.  XX.XXXXX
    // bit6 ........  X.XXXX.X  .XXXXXX.  X.XXX...  .......X  .X.X.X.X  ........  X.X.X.X.  ........  .X.XXXX.  .X......  .XXX.X.X  XXXX.X.X  .X.X.X.X  .X..X.X.  X.......
    // bit7 .XXXXXXX  .X.X.X.X  .XXXXXXX  .X.X.X.X  .......X  .X.X....  X.X.X.X.  X.X.X.X.  ...X.X.X  ....X.X.  XXXX.X.X  .XXXXXXX  XXXX.X.X  .XXXXXXX  X.X.X.X.  X.X.X.X.
    // Avalanche: 46.39%

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
        0xC8, 0x29, 0x85, 0x8F, 0x4A, 0x48, 0x9B, 0x27, 0xAA, 0x8B, 0xFC, 0x40, 0xCD, 0x54, 0x88, 0xB6,
        0x6B, 0x8D, 0x9B, 0xB2, 0xD7, 0x72, 0x28, 0x1B, 0x89, 0x81, 0x4C, 0x7E, 0xA4, 0x37, 0x6D, 0xE7,
        0x3D, 0x80, 0xA3, 0x04, 0xD7, 0x41, 0x1B, 0xD8, 0x3B, 0xE9, 0x74, 0x45, 0xC1, 0x4D, 0x1E, 0xFA,
        0x9D, 0x10, 0x82, 0x1E, 0x34, 0x17, 0x78, 0xFF, 0x62, 0x6D, 0xBF, 0x79, 0x34, 0x01, 0x60, 0xC6,
        0x1B, 0x64, 0x1D, 0x8F, 0x80, 0x8C, 0xEF, 0x16, 0x85, 0xDB, 0x90, 0x7C, 0xCC, 0xBA, 0x4B, 0xD1,
        0x48, 0x87, 0x00, 0x23, 0x79, 0x87, 0x7A, 0xE1, 0xC2, 0xF8, 0x95, 0x26, 0x2C, 0xCA, 0x14, 0xEF,
        0xB9, 0x65, 0x50, 0x87, 0x1F, 0xE3, 0x82, 0x0C, 0xEB, 0x5F, 0x10, 0x09, 0xAC, 0x9A, 0x47, 0xEA,
        0x02, 0xF7, 0x71, 0x3D, 0xAA, 0x09, 0xC2, 0x68, 0xE8, 0xF1, 0x80, 0x01, 0xA3, 0xF3, 0x9E, 0x53
    };

    PasswordJumpAddCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0xE0, 0x1E, 0x66, 0x1E, 0x66, 0x86, 0x66, 0x86, 0x54, 0x86, 0x54, 0xAA, 0x54, 0xAA, 0x00, 0xAA,
        0xF0, 0xFF, 0x33, 0xFF, 0xFF, 0xB3, 0xFF, 0xF6, 0x76, 0xF6, 0xE6, 0x88, 0xE6, 0xFF, 0x3C, 0xFF,
        0xFF, 0x9A, 0xFF, 0xF0, 0xCB, 0xF0, 0xDB, 0x33, 0xDB, 0xFF, 0x4B, 0xFF, 0xFF, 0x76, 0xFF, 0xE6,
        0xC2, 0x3C, 0x64, 0x3C, 0x64, 0xCB, 0x64, 0xCB, 0xB3, 0xCB, 0xB3, 0x4B, 0xB3, 0x4B, 0x88, 0x4B,
        0xFF, 0xB3, 0xFF, 0xF6, 0x76, 0xF6, 0xE6, 0x88, 0xE6, 0xFF, 0x3C, 0xFF, 0xFF, 0x9A, 0xFF, 0xF0,
        0x21, 0xEF, 0x21, 0x32, 0xBC, 0x32, 0x2C, 0x42, 0x2C, 0xB9, 0x6F, 0xB9, 0x32, 0x6D, 0x32, 0xC3,
        0x54, 0xFF, 0x64, 0xFF, 0xFF, 0xCB, 0xFF, 0xDB, 0xB3, 0xDB, 0xF6, 0x4B, 0xF6, 0xFF, 0x88, 0xFF,
        0x54, 0xA9, 0x54, 0xFF, 0xEF, 0xFF, 0xFF, 0x0F, 0xFF, 0xDB, 0x42, 0xDB, 0xF6, 0x8F, 0xF6, 0xFF
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_L_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_L_PasswordJumpAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_L_PasswordJumpAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_L_PasswordJumpAddCipher")) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_L_PasswordJumpAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordJumpAddCipher] test_fixed_128_L_PasswordJumpAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

@end
