//
//  Battery_CascadeJumpCipher.m
//  HolyStorms
//
//  Created by icarus black on 7/5/26.
//

#import <XCTest/XCTest.h>
#import "CascadeJumpCipher.hpp"
#import "PrintExamplesHelper.hpp"
#import "CipherGauntlet.hpp"
#include <memory>

@interface Battery_CascadeJumpCipher : XCTestCase

@end

@implementation Battery_CascadeJumpCipher

- (void)test_gauntlet_CascadeJumpCipher {
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
            
            CascadeJumpCipher aCipher(aMask,
                                         aMaskJumps);
            if (!aGauntlet.RunCipher(&aCipher,
                                     16,
                                     "CascadeJumpCipher")) {
                XCTFail("[CascadeJumpCipher] test_gauntlet_CascadeJumpCipher failed.");
                return;
            }
        }
    }
}

- (void)test_fixed_16_A_CascadeJumpCipher {

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
    // bit0 00000000  00000000
    // bit1 00000000  00000000
    // bit2 00000000  00000000
    // bit3 00000000  00000000
    // bit4 00000000  00000000
    // bit5 00000000  00000000
    // bit6 00000000  00000000
    // bit7 00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........
    // bit1 ........  ........
    // bit2 ........  ........
    // bit3 ........  ........
    // bit4 ........  ........
    // bit5 ........  ........
    // bit6 ........  ........
    // bit7 ........  ........
    // Avalanche: 0.00%

    const std::uint8_t aOriginal[16] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aMaskBuffer[16] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aMaskJumpBuffer[16] = {
        0x8A, 0xAA, 0xDB, 0xC1, 0x15, 0x7A, 0x66, 0xD1, 0x3C, 0x24, 0x87, 0x16, 0xA5, 0xAD, 0xCA, 0x88
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[16] = {
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
                                                    "test_fixed_16_A_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_A_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_A_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_A_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_A_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_A_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_B_CascadeJumpCipher {

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
    // bit1 00000000  00000000
    // bit2 00000000  00000000
    // bit3 00000000  00000000
    // bit4 00000000  00000000
    // bit5 00000000  00000000
    // bit6 00000000  00000000
    // bit7 00000000  00000000
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX
    // bit1 XXXXXXXX  XXXXXXXX
    // bit2 XXXXXXXX  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX
    // bit5 XXXXXXXX  XXXXXXXX
    // bit6 XXXXXXXX  XXXXXXXX
    // bit7 XXXXXXXX  XXXXXXXX
    // Avalanche: 100.00%

    const std::uint8_t aOriginal[16] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskJumpBuffer[16] = {
        0x70, 0x92, 0xC6, 0x89, 0x52, 0x44, 0xD8, 0x84, 0x9D, 0xE8, 0x3B, 0x60, 0xEF, 0xBE, 0x83, 0x09
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[16] = {
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
                                                    "test_fixed_16_B_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_B_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_B_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_B_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_B_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_B_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_C_CascadeJumpCipher {

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
    // bit0 00000000  00000000
    // bit1 00000000  00000000
    // bit2 00000000  00000000
    // bit3 00000000  00000000
    // bit4 00000000  00000000
    // bit5 00000000  00000000
    // bit6 00000000  00000000
    // bit7 00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.
    // bit2 X.X.X.X.  X.X.X.X.
    // bit3 X.X.X.X.  X.X.X.X.
    // bit4 .X.X.X.X  .X.X.X.X
    // bit5 .X.X.X.X  .X.X.X.X
    // bit6 .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[16] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskJumpBuffer[16] = {
        0xDE, 0x64, 0xA8, 0xC4, 0xCB, 0x28, 0xBF, 0x87, 0x44, 0xD8, 0xA4, 0x76, 0x25, 0xFE, 0xA7, 0xEC
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[16] = {
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
                                                    "test_fixed_16_C_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_C_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_C_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_C_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_C_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_C_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_D_CascadeJumpCipher {

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
    // bit0 00000000  00000000
    // bit1 00000000  00000000
    // bit2 00000000  00000000
    // bit3 00000000  00000000
    // bit4 00000000  00000000
    // bit5 00000000  00000000
    // bit6 00000000  00000000
    // bit7 00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.
    // bit2 .X.X.X.X  .X.X.X.X
    // bit3 .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.
    // bit5 X.X.X.X.  X.X.X.X.
    // bit6 .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[16] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskJumpBuffer[16] = {
        0xDF, 0xC2, 0x87, 0x7E, 0x7A, 0x9B, 0x7F, 0x2D, 0x75, 0x25, 0x4C, 0xC0, 0xCE, 0x5D, 0x95, 0x64
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[16] = {
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
                                                    "test_fixed_16_D_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_D_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_D_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_D_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_D_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_D_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_E_CascadeJumpCipher {

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
    // bit0 00000000  00000000
    // bit1 00000000  00000000
    // bit2 00000000  00000000
    // bit3 00000000  00000000
    // bit4 00000000  00000000
    // bit5 00000000  00000000
    // bit6 00000000  00000000
    // bit7 00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.
    // bit2 .X.X.X.X  .X.X.X.X
    // bit3 .X.X.X.X  .X.X.X.X
    // bit4 .X.X.X.X  .X.X.X.X
    // bit5 .X.X.X.X  .X.X.X.X
    // bit6 X.X.X.X.  X.X.X.X.
    // bit7 X.X.X.X.  X.X.X.X.
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[16] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskJumpBuffer[16] = {
        0xB0, 0xCE, 0x3F, 0xE3, 0x5E, 0xA4, 0x51, 0xB1, 0x52, 0x4E, 0x2B, 0x22, 0xE5, 0x15, 0xF0, 0x4F
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[16] = {
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
                                                    "test_fixed_16_E_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_E_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_E_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_E_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_E_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_E_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_F_CascadeJumpCipher {

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
    // bit0 00000000  00000000
    // bit1 00000000  00000000
    // bit2 00000000  00000000
    // bit3 00000000  00000000
    // bit4 00000000  00000000
    // bit5 00000000  00000000
    // bit6 00000000  00000000
    // bit7 00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.
    // bit1 .X.X.X.X  .X.X.X.X
    // bit2 X.X.X.X.  X.X.X.X.
    // bit3 .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.
    // bit5 .X.X.X.X  .X.X.X.X
    // bit6 X.X.X.X.  X.X.X.X.
    // bit7 .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[16] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[16] = {
        0x96, 0x03, 0xB8, 0x2A, 0x29, 0x5D, 0x9D, 0xB9, 0xFD, 0x5F, 0x90, 0xF8, 0x37, 0xDC, 0xE8, 0x5C
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[16] = {
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
                                                    "test_fixed_16_F_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_F_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_F_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_F_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_F_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_F_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_G_CascadeJumpCipher {

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
    // bit0 00000000  00000000
    // bit1 00000000  00000000
    // bit2 00000000  00000000
    // bit3 00000000  00000000
    // bit4 00000000  00000000
    // bit5 00000000  00000000
    // bit6 00000000  00000000
    // bit7 00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.
    // bit1 X.X.X..X  X.X.X.X.
    // bit2 X..X.XX.  X.X..X.X
    // bit3 X..X.X.X  X.X..X.X
    // bit4 .XX..XX.  X..XX..X
    // bit5 .XX..X.X  X..XX..X
    // bit6 .X.XX.X.  X..X.XX.
    // bit7 .X.XX..X  X..X.XX.
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[16] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C
    };

    const std::uint8_t aMaskJumpBuffer[16] = {
        0xE0, 0x77, 0x06, 0xAF, 0x8E, 0x42, 0x4A, 0xFA, 0x0A, 0x77, 0x0D, 0x28, 0x56, 0xDD, 0x3D, 0x82
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[16] = {
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
                                                    "test_fixed_16_G_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_G_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_G_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_G_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_G_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_G_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_H_CascadeJumpCipher {

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
    // bit0 00000000  00000000
    // bit1 00000000  00000000
    // bit2 00000000  00000000
    // bit3 00000000  00000000
    // bit4 00000000  00000000
    // bit5 00000000  00000000
    // bit6 00000000  00000000
    // bit7 00000000  00000000
    //
    // Avalanche:
    // bit0 .X.X.X.X  .X.X.X.X
    // bit1 .XX..X.X  .X.XX..X
    // bit2 .X.XX.X.  .X.X.XX.
    // bit3 .XX.X.X.  .X.XX.X.
    // bit4 .X.XX..X  X..X.XX.
    // bit5 .XX.X..X  X..XX.X.
    // bit6 .X.X.XX.  X..X.X.X
    // bit7 .XX..XX.  X..XX..X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[16] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3
    };

    const std::uint8_t aMaskBuffer[16] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3
    };

    const std::uint8_t aMaskJumpBuffer[16] = {
        0x32, 0x1D, 0xFD, 0x37, 0xFD, 0x2B, 0xE3, 0x88, 0xE0, 0xF1, 0xE2, 0x8F, 0xC7, 0x83, 0x2D, 0xFB
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[16] = {
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
                                                    "test_fixed_16_H_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_H_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_H_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_H_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_H_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_H_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_I_CascadeJumpCipher {

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
    // bit0 00000000  00000000
    // bit1 00000000  00000000
    // bit2 00000000  00000000
    // bit3 00000000  00000000
    // bit4 00000000  00000000
    // bit5 00000000  00000000
    // bit6 00000000  00000000
    // bit7 00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.
    // bit1 X...X.X.  XXX...X.
    // bit2 XXX..XX.  ..XXX..X
    // bit3 XX...XX.  .XXX...X
    // bit4 ..X.XXXX  ....X.XX
    // bit5 ....XXXX  .X....XX
    // bit6 .XX...XX  X..XX...
    // bit7 .X....XX  XX.X....
    // Avalanche: 46.88%

    const std::uint8_t aOriginal[16] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C
    };

    const std::uint8_t aMaskJumpBuffer[16] = {
        0x13, 0x55, 0x28, 0x01, 0x45, 0x4E, 0x64, 0x21, 0x1C, 0x5E, 0xBE, 0x5C, 0x78, 0xB2, 0x15, 0xC4
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[16] = {
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
                                                    "test_fixed_16_I_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_I_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_I_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_I_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_I_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_I_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_J_CascadeJumpCipher {

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
    // bit0 00000000  00000000
    // bit1 00000000  00000000
    // bit2 00000000  00000000
    // bit3 00000000  00000000
    // bit4 00000000  00000000
    // bit5 00000000  00000000
    // bit6 00000000  00000000
    // bit7 00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.
    // bit1 XXXXXXXX  XXXXXXXX
    // bit2 ........  ........
    // bit3 .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.
    // bit5 XXXXXXXX  XXXXXXXX
    // bit6 ........  ........
    // bit7 .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[16] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[16] = {
        0x5E, 0x5D, 0xEB, 0xA6, 0x84, 0x6B, 0x89, 0xD8, 0x30, 0xBD, 0xE4, 0x0E, 0xBB, 0x72, 0x54, 0x07
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[16] = {
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
                                                    "test_fixed_16_J_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_J_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_J_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_J_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_J_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_J_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_K_CascadeJumpCipher {

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
    // bit0 00000000  00000000
    // bit1 00000000  00000000
    // bit2 00000000  00000000
    // bit3 00000000  00000000
    // bit4 00000000  00000000
    // bit5 00000000  00000000
    // bit6 00000000  00000000
    // bit7 00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.
    // bit2 X.X.X.X.  .X.X.X.X
    // bit3 X.X.X.X.  .X.X.X.X
    // bit4 .X.X.X.X  X.X.X.X.
    // bit5 .X.X.X.X  X.X.X.X.
    // bit6 .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[16] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskJumpBuffer[16] = {
        0x4E, 0xCA, 0xD4, 0xFB, 0x21, 0x76, 0x0F, 0xCC, 0x4C, 0xE0, 0x39, 0x01, 0x5F, 0x5A, 0x06, 0x5E
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[16] = {
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
                                                    "test_fixed_16_K_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_K_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_K_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_K_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_K_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_K_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_L_CascadeJumpCipher {

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
    // bit0 00000000  00000000
    // bit1 00000000  00000000
    // bit2 00000000  00000000
    // bit3 00000000  00000000
    // bit4 00000000  00000000
    // bit5 00000000  00000000
    // bit6 00000000  00000000
    // bit7 00000000  00000000
    //
    // Avalanche:
    // bit0 X....X.X  XXX.X...
    // bit1 X....X.X  .X.X.X.X
    // bit2 X.X.X.X.  X.X.X...
    // bit3 X.X.X.X.  ...X.X.X
    // bit4 .X.X....  X.X.X...
    // bit5 .X.X....  ...X.X.X
    // bit6 .XXXXXXX  XXX.X...
    // bit7 .XXXXXXX  .X.X.X.X
    // Avalanche: 46.88%

    const std::uint8_t aOriginal[16] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[16] = {
        0x7D, 0x65, 0xA4, 0x0D, 0x89, 0xF8, 0x30, 0x84, 0xE5, 0x18, 0x90, 0xC5, 0x0B, 0xE5, 0xB5, 0x32
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[16] = {
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
                                                    "test_fixed_16_L_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_L_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_L_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_L_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_L_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_16_L_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_A_CascadeJumpCipher {

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
        0xC0, 0x65, 0xD8, 0xC5, 0x21, 0xF2, 0x98, 0xD3, 0x94, 0xC2, 0x66, 0x49, 0x07, 0x60, 0x4A, 0x05,
        0xAA, 0x81, 0x86, 0x56, 0x6A, 0x68, 0x2E, 0x2F, 0xB6, 0x69, 0x76, 0xF2, 0x44, 0xEF, 0x69, 0x5B
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_32_A_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_A_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_A_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_A_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_A_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_A_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_B_CascadeJumpCipher {

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
    // bit0 00000000  00000000  11111111  11111111
    // bit1 00000000  00000000  11111111  11111111
    // bit2 00000000  00000000  11111111  11111111
    // bit3 00000000  00000000  11111111  11111111
    // bit4 00000000  00000000  11111111  11111111
    // bit5 00000000  00000000  11111111  11111111
    // bit6 00000000  00000000  11111111  11111111
    // bit7 00000000  00000000  11111111  11111111
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  ........  ........
    // bit2 XXXXXXXX  XXXXXXXX  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  ........  ........
    // bit4 XXXXXXXX  XXXXXXXX  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  ........  ........
    // bit6 XXXXXXXX  XXXXXXXX  ........  ........
    // bit7 XXXXXXXX  XXXXXXXX  ........  ........
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[32] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0xD6, 0x87, 0xAF, 0x54, 0xAA, 0x4A, 0x5F, 0x49, 0x83, 0x28, 0x7C, 0x5C, 0x2F, 0x1D, 0x17, 0x78,
        0xF9, 0xEA, 0x8D, 0xA8, 0xBA, 0x9B, 0x52, 0x31, 0x0E, 0x2C, 0x59, 0x47, 0x40, 0xF1, 0x56, 0x45
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
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
                                                    "test_fixed_32_B_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_B_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_B_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_B_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_B_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_B_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_C_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101
    // bit1 00000000  00000000  01010101  01010101
    // bit2 00000000  00000000  01010101  01010101
    // bit3 00000000  00000000  10101010  10101010
    // bit4 00000000  00000000  10101010  10101010
    // bit5 00000000  00000000  10101010  10101010
    // bit6 00000000  00000000  10101010  10101010
    // bit7 00000000  00000000  10101010  10101010
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit1 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit2 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit3 X.X.X.X.  X.X.X.X.  ........  ........
    // bit4 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit5 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit6 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // Avalanche: 68.75%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x6B, 0x46, 0xBB, 0x3E, 0xE3, 0x3D, 0x8E, 0x8A, 0xAD, 0x20, 0x0E, 0x32, 0xC7, 0xA2, 0x6C, 0xD2,
        0x5D, 0x7B, 0x53, 0xE3, 0xA4, 0xE1, 0x9A, 0x8B, 0xD6, 0x18, 0x82, 0x5D, 0xBE, 0x77, 0x48, 0xD2
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_C_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_C_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_C_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_C_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_C_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_C_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_D_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101
    // bit1 00000000  00000000  10101010  10101010
    // bit2 00000000  00000000  10101010  10101010
    // bit3 00000000  00000000  01010101  01010101
    // bit4 00000000  00000000  01010101  01010101
    // bit5 00000000  00000000  10101010  10101010
    // bit6 00000000  00000000  10101010  10101010
    // bit7 00000000  00000000  10101010  10101010
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit1 X.X.X.X.  X.X.X.X.  ........  ........
    // bit2 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit3 .X.X.X.X  .X.X.X.X  ........  ........
    // bit4 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit5 X.X.X.X.  X.X.X.X.  ........  ........
    // bit6 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // Avalanche: 56.25%

    const std::uint8_t aOriginal[32] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x90, 0xEF, 0x9B, 0x14, 0x74, 0x2D, 0xAB, 0xA2, 0x11, 0xCF, 0xB0, 0xE8, 0x13, 0xAF, 0xAD, 0xE3,
        0x98, 0xA0, 0x0C, 0x9D, 0x94, 0xA3, 0x5A, 0x58, 0x9C, 0xCC, 0x82, 0xC6, 0xE7, 0x50, 0x4B, 0x94
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
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
                                                    "test_fixed_32_D_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_D_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_D_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_D_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_D_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_D_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_E_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101
    // bit1 00000000  00000000  10101010  10101010
    // bit2 00000000  00000000  10101010  10101010
    // bit3 00000000  00000000  10101010  10101010
    // bit4 00000000  00000000  10101010  10101010
    // bit5 00000000  00000000  01010101  01010101
    // bit6 00000000  00000000  01010101  01010101
    // bit7 00000000  00000000  10101010  10101010
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit1 X.X.X.X.  X.X.X.X.  ........  ........
    // bit2 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit3 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit4 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit5 .X.X.X.X  .X.X.X.X  ........  ........
    // bit6 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit7 X.X.X.X.  X.X.X.X.  ........  ........
    // Avalanche: 56.25%

    const std::uint8_t aOriginal[32] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x92, 0x80, 0xAC, 0x56, 0x67, 0x11, 0x44, 0xDF, 0x64, 0x69, 0x44, 0x95, 0x2D, 0x4B, 0x1E, 0xB3,
        0x64, 0x35, 0x52, 0x2A, 0x95, 0x58, 0x95, 0x0E, 0xC7, 0x69, 0x1D, 0x7B, 0x38, 0x39, 0x16, 0xDA
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_E_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_E_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_E_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_E_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_E_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_E_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_F_CascadeJumpCipher {

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
    // bit0 00000000  00000000  10101010  10101010
    // bit1 00000000  00000000  01010101  01010101
    // bit2 00000000  00000000  10101010  10101010
    // bit3 00000000  00000000  01010101  01010101
    // bit4 00000000  00000000  10101010  10101010
    // bit5 00000000  00000000  01010101  01010101
    // bit6 00000000  00000000  10101010  10101010
    // bit7 00000000  00000000  10101010  10101010
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  ........  ........
    // bit1 .X.X.X.X  .X.X.X.X  ........  ........
    // bit2 X.X.X.X.  X.X.X.X.  ........  ........
    // bit3 .X.X.X.X  .X.X.X.X  ........  ........
    // bit4 X.X.X.X.  X.X.X.X.  ........  ........
    // bit5 .X.X.X.X  .X.X.X.X  ........  ........
    // bit6 X.X.X.X.  X.X.X.X.  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // Avalanche: 31.25%

    const std::uint8_t aOriginal[32] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x64, 0xF3, 0x4E, 0x3F, 0x7E, 0x6D, 0x05, 0xA7, 0x6C, 0x8B, 0xB0, 0xC0, 0xE2, 0xDC, 0x44, 0xF4,
        0xD6, 0xD5, 0xD2, 0x87, 0xFF, 0xBF, 0xB3, 0x55, 0xD5, 0xB2, 0x4C, 0x27, 0x9D, 0x2E, 0xCD, 0x62
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_F_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_F_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_F_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_F_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_F_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_F_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_G_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010011  01010101
    // bit1 00000000  00000000  00101101  01001011
    // bit2 00000000  00000000  00101011  01001011
    // bit3 00000000  00000000  11001101  00110010
    // bit4 00000000  00000000  11001011  00110010
    // bit5 00000000  00000000  10110101  00101100
    // bit6 00000000  00000000  10110011  00101100
    // bit7 00000000  00000000  10101010  10101010
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXX..X  XXXXXXXX
    // bit1 X.X.X..X  X.X.X.X.  .X...XXX  XX.X...X
    // bit2 X..X.XX.  X.X..X.X  X.....X.  ..X....X
    // bit3 X..X.X.X  X.X..X.X  X.X..X..  .XX.X...
    // bit4 .XX..XX.  X..XX..X  .XX.XX.X  .X.XX.XX
    // bit5 .XX..X.X  X..XX..X  XX.X..XX  .XXX.X.X
    // bit6 .X.XX.X.  X..X.XX.  ...X.XX.  X....X.X
    // bit7 .X.XX..X  X..X.XX.  XX..XXXX  ..XX..XX
    // Avalanche: 51.56%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x5D, 0xEF, 0xC5, 0x94, 0x49, 0x59, 0x82, 0x03, 0xA7, 0x29, 0x8C, 0x31, 0xEC, 0x57, 0xD6, 0x63,
        0x5A, 0xDB, 0x3C, 0xC2, 0x7A, 0xE4, 0xBB, 0xAE, 0x1F, 0x45, 0x2B, 0xF4, 0x8E, 0x0D, 0x01, 0x61
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x1F, 0x98, 0x67, 0x86, 0x79, 0x54, 0xAB, 0xFE, 0x01, 0xE0, 0x1F, 0x98, 0x67, 0x86, 0x79, 0xE0
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_G_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_G_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_G_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_G_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_G_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_G_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_H_CascadeJumpCipher {

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
    // bit0 00000000  00000000  11001010  10110010
    // bit1 00000000  00000000  10110100  10101100
    // bit2 00000000  00000000  11010100  10110100
    // bit3 00000000  00000000  10110011  00101100
    // bit4 00000000  00000000  11010011  00110100
    // bit5 00000000  00000000  10101101  00101010
    // bit6 00000000  00000000  11001101  00110010
    // bit7 00000000  00000000  01010101  01010101
    //
    // Avalanche:
    // bit0 .X.X.X.X  .X.X.X.X  X..XXXXX  XXX..XXX
    // bit1 .XX..X.X  .X.XX..X  XXX...X.  XXXXX..X
    // bit2 .X.XX.X.  .X.X.XX.  .X.....X  ...X...X
    // bit3 .XX.X.X.  .X.XX.X.  ..X..X.X  X...X..X
    // bit4 .X.XX..X  X..X.XX.  X.XX.XX.  X.X.XX.X
    // bit5 .XX.X..X  X..XX.X.  XX..X.XX  X.XX..XX
    // bit6 .X.X.XX.  X..X.X.X  .XX.X...  .X.XX.XX
    // bit7 .XX..XX.  X..XX..X  XXXX..XX  ..XXXX..
    // Avalanche: 52.34%

    const std::uint8_t aOriginal[32] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF
    };

    const std::uint8_t aMaskBuffer[32] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x59, 0xDA, 0xA0, 0xBB, 0xCC, 0x7E, 0x44, 0xAB, 0x79, 0x34, 0x54, 0x01, 0x83, 0x01, 0x93, 0xCA,
        0x66, 0xBD, 0xC1, 0xE3, 0x89, 0xF9, 0x1F, 0x81, 0xD3, 0x51, 0x63, 0xB7, 0xC2, 0xB6, 0x10, 0x39
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xFE, 0xAB, 0x54, 0x79, 0x86, 0x67, 0x98, 0x1F, 0xE0, 0x01, 0xFE, 0xAB, 0x54, 0x79, 0x86, 0x01
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_H_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_H_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_H_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_H_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_H_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_H_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_I_CascadeJumpCipher {

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
    // bit0 00000000  00000000  00010101  11000101
    // bit1 00000000  00000000  11001100  01110011
    // bit2 00000000  00000000  10001100  11100011
    // bit3 00000000  00000000  01011110  00010110
    // bit4 00000000  00000000  00011110  10000110
    // bit5 00000000  00000000  11000111  00110000
    // bit6 00000000  00000000  10000111  10100000
    // bit7 00000000  00000000  10101010  10101010
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  X.XXXXXX  .XX.XXXX
    // bit1 X...X.X.  XXX...X.  .XXX.X..  XX.XXX.X
    // bit2 XXX..XX.  ..XXX..X  ......X.  X.......
    // bit3 XX...XX.  .XXX...X  XX....X.  .XXX...X
    // bit4 ..X.XXXX  ....X.XX  XX.XXX..  .XXX.XX.
    // bit5 ....XXXX  .X....XX  ...X.XXX  XX...X..
    // bit6 .XX...XX  X..XX...  .XX....X  X..XX..X
    // bit7 .X....XX  XX.X....  .X.XXXX.  X..X.XXX
    // Avalanche: 49.22%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x01, 0xA7, 0x90, 0xDF, 0xC3, 0x03, 0x29, 0x20, 0xA3, 0x1C, 0x71, 0x2E, 0xE1, 0x55, 0x75, 0x4E,
        0x9B, 0x3D, 0x95, 0x4F, 0xC4, 0x95, 0xE1, 0xA3, 0x9D, 0x0F, 0x2F, 0xEC, 0x1C, 0x0E, 0x21, 0x5D
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x67, 0x54, 0x01, 0x98, 0x79, 0xFE, 0x1F, 0x86, 0xAB, 0xE0, 0x67, 0x54, 0x01, 0x98, 0x79, 0xE0
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_I_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_I_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_I_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_I_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_I_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_I_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_J_CascadeJumpCipher {

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
    // bit0 00000000  00000000  11111111  11111111
    // bit1 00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  10101010  10101010
    // bit3 00000000  00000000  01010101  01010101
    // bit4 00000000  00000000  11111111  11111111
    // bit5 00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  10101010  10101010
    // bit7 00000000  00000000  10101010  10101010
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  .X.X.X.X  .X.X.X.X
    // bit1 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  X.X.X.X.  X.X.X.X.
    // bit3 .X.X.X.X  .X.X.X.X  ........  ........
    // bit4 X.X.X.X.  X.X.X.X.  .X.X.X.X  .X.X.X.X
    // bit5 XXXXXXXX  XXXXXXXX  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  X.X.X.X.  X.X.X.X.
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // Avalanche: 56.25%

    const std::uint8_t aOriginal[32] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0xE6, 0xA6, 0x0D, 0x68, 0x99, 0xE9, 0x14, 0x91, 0x5B, 0x71, 0x98, 0x07, 0xD1, 0xDC, 0xBD, 0xBF,
        0x4C, 0x8F, 0x4A, 0xAB, 0xF1, 0xA6, 0x28, 0xB7, 0xEC, 0xE8, 0x9F, 0xD0, 0x81, 0xF3, 0x81, 0xAE
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xAB, 0x98, 0xAB, 0x98, 0xAB, 0x98, 0xAB, 0x98, 0xAB, 0x98, 0xAB, 0x98, 0xAB, 0x98, 0xAB, 0x98
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_J_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_J_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_J_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_J_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_J_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_J_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_K_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101
    // bit1 00000000  00000000  01010100  01010100
    // bit2 00000000  00000000  10101011  01010100
    // bit3 00000000  00000000  01010100  01010100
    // bit4 00000000  00000000  10101011  01010100
    // bit5 00000000  00000000  10101010  01010101
    // bit6 00000000  00000000  01010101  01010101
    // bit7 00000000  00000000  01010101  10101010
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit1 X.X.X.X.  X.X.X.X.  XXXXXXX.  .......X
    // bit2 X.X.X.X.  .X.X.X.X  XXXXXXX.  XXXXXXX.
    // bit3 X.X.X.X.  .X.X.X.X  .......X  .......X
    // bit4 .X.X.X.X  X.X.X.X.  XXXXXXX.  XXXXXXX.
    // bit5 .X.X.X.X  X.X.X.X.  XXXXXXXX  ........
    // bit6 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // Avalanche: 61.72%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0x04, 0x27, 0x97, 0xD1, 0xE7, 0xEB, 0xE2, 0xB0, 0xEE, 0xA5, 0xC9, 0x5F, 0x58, 0x21, 0xEE, 0x5A,
        0xFB, 0xAE, 0x4F, 0xC4, 0xF9, 0x1A, 0x7E, 0x89, 0x50, 0x74, 0xC0, 0xE0, 0x76, 0xC1, 0xDD, 0x5A
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xD3, 0x2C, 0xAB, 0x01, 0xFE, 0x01, 0xFE, 0x01, 0xFE, 0x01, 0x86
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_K_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_K_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_K_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_K_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_K_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_K_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_L_CascadeJumpCipher {

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
    // bit0 00000000  00000000  00001010  10101011
    // bit1 00000000  00000000  01010101  01010001
    // bit2 00000000  00000000  01010100  00101011
    // bit3 00000000  00000000  10100001  01010000
    // bit4 00000000  00000000  10100000  00101010
    // bit5 00000000  00000000  11111111  11010000
    // bit6 00000000  00000000  11111110  10101010
    // bit7 00000000  00000000  10000101  11101000
    //
    // Avalanche:
    // bit0 X....X.X  XXX.X...  .X.X.X..  ..X.XXX.
    // bit1 X....X.X  .X.X.X.X  ....X.XX  XX.X...X
    // bit2 X.X.X.X.  X.X.X...  .......X  .X.X.X..
    // bit3 X.X.X.X.  ...X.X.X  XXXX.X..  ..X.X.X.
    // bit4 .X.X....  X.X.X...  X.X.X.X.  X....X.X
    // bit5 .X.X....  ...X.X.X  XXXX.X.X  .XXXX.X.
    // bit6 .XXXXXXX  XXX.X...  XXXXXXXX  XXXXXXXX
    // bit7 .XXXXXXX  .X.X.X.X  X....X..  X.XXX...
    // Avalanche: 49.22%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA
    };

    const std::uint8_t aMaskJumpBuffer[32] = {
        0xCB, 0x20, 0x00, 0x22, 0x01, 0x33, 0x91, 0xD9, 0x7D, 0x1D, 0x30, 0x60, 0xDF, 0x5A, 0x70, 0x0D,
        0x9D, 0x05, 0x12, 0x13, 0x2F, 0xB9, 0x78, 0x71, 0xC5, 0x35, 0xAC, 0x98, 0x20, 0xEA, 0x09, 0xC6
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x1F, 0x66, 0x1E, 0x66, 0x86, 0x67, 0x86, 0x55, 0x87, 0x55, 0xAB, 0x54, 0xAB, 0x00, 0xAA, 0xE0
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_L_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_L_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_L_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_L_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_L_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_32_L_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_A_CascadeJumpCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........
    // bit3 ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........
    // Avalanche: 0.00%

    const std::uint8_t aOriginal[48] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aMaskBuffer[48] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aMaskJumpBuffer[48] = {
        0x6B, 0x56, 0xD2, 0x6E, 0x93, 0x44, 0x35, 0x94, 0x59, 0x94, 0xF1, 0x22, 0x06, 0x4B, 0x31, 0x12,
        0xD0, 0x17, 0xCB, 0x39, 0xCB, 0xDE, 0xE6, 0x44, 0xE9, 0xFF, 0xEB, 0x22, 0xAC, 0x27, 0x51, 0xA9,
        0xAD, 0x6C, 0x7B, 0x1C, 0x57, 0x61, 0xAF, 0x18, 0x7E, 0xBE, 0xDE, 0xCD, 0x4B, 0xAC, 0x6D, 0x60
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[48] = {
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
                                                    "test_fixed_48_A_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_A_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_A_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_A_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_A_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_A_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_B_CascadeJumpCipher {

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
    // bit0 00000000  00000000  11111111  11111111  00000000  00000000
    // bit1 00000000  00000000  11111111  11111111  00000000  00000000
    // bit2 00000000  00000000  11111111  11111111  00000000  00000000
    // bit3 00000000  00000000  11111111  11111111  00000000  00000000
    // bit4 00000000  00000000  11111111  11111111  00000000  00000000
    // bit5 00000000  00000000  11111111  11111111  00000000  00000000
    // bit6 00000000  00000000  11111111  11111111  00000000  00000000
    // bit7 00000000  00000000  11111111  11111111  00000000  00000000
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit1 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit2 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit5 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit6 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit7 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // Avalanche: 66.67%

    const std::uint8_t aOriginal[48] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskBuffer[48] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskJumpBuffer[48] = {
        0x87, 0x2E, 0xC7, 0x72, 0xE7, 0xC9, 0xBD, 0x73, 0x2E, 0xDC, 0x78, 0x6A, 0x77, 0x08, 0xFE, 0xDC,
        0x47, 0x1F, 0xE6, 0x92, 0xA0, 0xF1, 0x91, 0xC9, 0x21, 0x6B, 0x79, 0x32, 0xDC, 0xC3, 0x2D, 0x04,
        0xA6, 0xC4, 0x3A, 0x9D, 0xC5, 0x78, 0xAC, 0x41, 0x81, 0xB3, 0x67, 0x68, 0xAB, 0x5A, 0x92, 0x77
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[48] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
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
                                                    "test_fixed_48_B_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_B_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_B_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_B_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_B_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_B_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_C_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101  11111111  11111111
    // bit1 00000000  00000000  01010101  01010101  11111111  11111111
    // bit2 00000000  00000000  01010101  01010101  00000000  00000000
    // bit3 00000000  00000000  10101010  10101010  11111111  11111111
    // bit4 00000000  00000000  10101010  10101010  11111111  11111111
    // bit5 00000000  00000000  10101010  10101010  11111111  11111111
    // bit6 00000000  00000000  10101010  10101010  11111111  11111111
    // bit7 00000000  00000000  10101010  10101010  11111111  11111111
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // bit1 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // bit2 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit3 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // bit4 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit5 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit6 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // Avalanche: 62.50%

    const std::uint8_t aOriginal[48] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskBuffer[48] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskJumpBuffer[48] = {
        0x7B, 0x57, 0x2F, 0x5F, 0x6F, 0x92, 0xA8, 0x35, 0x26, 0x91, 0x05, 0x94, 0xA7, 0x84, 0xFD, 0xDD,
        0xA6, 0x57, 0xCD, 0xF0, 0x79, 0xFD, 0xFB, 0x3D, 0x56, 0x83, 0xB2, 0x39, 0xF1, 0x76, 0x29, 0x9E,
        0x1B, 0x1E, 0xD6, 0xD5, 0xD6, 0x8D, 0x3A, 0xA2, 0xB6, 0x4E, 0x6F, 0x53, 0x3D, 0x45, 0xFC, 0x7D
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[48] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0,
        0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_48_C_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_C_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_C_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_C_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_C_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_C_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_D_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101  00000000  00000000
    // bit1 00000000  00000000  10101010  10101010  11111111  11111111
    // bit2 00000000  00000000  10101010  10101010  00000000  00000000
    // bit3 00000000  00000000  01010101  01010101  11111111  11111111
    // bit4 00000000  00000000  01010101  01010101  00000000  00000000
    // bit5 00000000  00000000  10101010  10101010  11111111  11111111
    // bit6 00000000  00000000  10101010  10101010  11111111  11111111
    // bit7 00000000  00000000  10101010  10101010  11111111  11111111
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // bit2 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // bit3 .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.
    // bit4 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit5 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // bit6 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // Avalanche: 54.17%

    const std::uint8_t aOriginal[48] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskBuffer[48] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskJumpBuffer[48] = {
        0x18, 0x16, 0x29, 0x56, 0xC6, 0x7A, 0xAF, 0xCA, 0xD5, 0x46, 0xA1, 0x10, 0xD0, 0x97, 0xED, 0x89,
        0x63, 0xF5, 0x61, 0x69, 0x45, 0xFB, 0x3D, 0x31, 0x79, 0x20, 0x37, 0x29, 0xE7, 0x32, 0x59, 0x74,
        0xA3, 0x63, 0xFD, 0x75, 0x58, 0xB3, 0xCE, 0xAC, 0x77, 0x22, 0x06, 0x3C, 0x8C, 0xDE, 0xAB, 0x92
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[48] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98,
        0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_48_D_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_D_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_D_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_D_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_D_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_D_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_E_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101  00000000  00000000
    // bit1 00000000  00000000  10101010  10101010  11111111  11111111
    // bit2 00000000  00000000  10101010  10101010  11111111  11111111
    // bit3 00000000  00000000  10101010  10101010  11111111  11111111
    // bit4 00000000  00000000  10101010  10101010  00000000  00000000
    // bit5 00000000  00000000  01010101  01010101  11111111  11111111
    // bit6 00000000  00000000  01010101  01010101  00000000  00000000
    // bit7 00000000  00000000  10101010  10101010  11111111  11111111
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // bit2 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit3 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit4 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // bit5 .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.
    // bit6 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit7 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // Avalanche: 54.17%

    const std::uint8_t aOriginal[48] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskBuffer[48] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskJumpBuffer[48] = {
        0xA7, 0xD6, 0x2B, 0xD8, 0xF1, 0x7B, 0x88, 0x3A, 0x0E, 0xEF, 0xA4, 0x6A, 0x86, 0x49, 0xE4, 0x02,
        0xC2, 0x4D, 0x63, 0xEA, 0x0B, 0x0C, 0xC5, 0x9D, 0x68, 0xF3, 0x11, 0x73, 0x97, 0x3E, 0xED, 0xEC,
        0xD0, 0xD6, 0x08, 0x65, 0x94, 0xC3, 0xED, 0x1C, 0x23, 0x6E, 0x7A, 0x98, 0xEB, 0x8C, 0x35, 0xA9
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[48] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86,
        0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_48_E_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_E_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_E_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_E_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_E_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_E_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_F_CascadeJumpCipher {

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
    // bit0 00000000  00000000  10101010  10101010  00000000  00000000
    // bit1 00000000  00000000  01010101  01010101  00000000  00000000
    // bit2 00000000  00000000  10101010  10101010  00000000  00000000
    // bit3 00000000  00000000  01010101  01010101  00000000  00000000
    // bit4 00000000  00000000  10101010  10101010  00000000  00000000
    // bit5 00000000  00000000  01010101  01010101  00000000  00000000
    // bit6 00000000  00000000  10101010  10101010  11111111  11111111
    // bit7 00000000  00000000  10101010  10101010  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.
    // bit1 .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X
    // bit2 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.
    // bit3 .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.
    // bit5 .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X
    // bit6 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[48] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskBuffer[48] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[48] = {
        0x1E, 0xF4, 0xA7, 0x2A, 0x85, 0x7B, 0x97, 0x65, 0x63, 0x54, 0xB4, 0xD9, 0xBD, 0x85, 0xA9, 0x6A,
        0xC8, 0x9E, 0x17, 0x24, 0x9C, 0xF3, 0x98, 0x2F, 0x09, 0x6A, 0xCF, 0xAE, 0xCC, 0xA3, 0x3F, 0x10,
        0xBC, 0x8A, 0x9F, 0xDC, 0x69, 0xB4, 0x24, 0x71, 0xFB, 0x0C, 0x90, 0x87, 0x18, 0xCC, 0xFA, 0x84
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[48] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54,
        0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_48_F_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_F_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_F_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_F_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_F_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_48_F_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_A_CascadeJumpCipher {

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
        0xE5, 0x19, 0xC2, 0xE4, 0x02, 0x5D, 0xE0, 0x4C, 0xEC, 0xE4, 0xD9, 0xE7, 0x7D, 0xC5, 0x7A, 0xF7,
        0x29, 0x02, 0x1C, 0x2B, 0x20, 0x67, 0x13, 0x0D, 0x86, 0xB6, 0xBD, 0x51, 0x70, 0x8A, 0x6F, 0xC6,
        0x76, 0x90, 0x8A, 0xDE, 0xC8, 0x50, 0x28, 0xE2, 0xAC, 0xC4, 0xE8, 0x5F, 0x3B, 0x06, 0x98, 0x24,
        0x7E, 0x24, 0xF2, 0x30, 0x38, 0x75, 0x05, 0x8A, 0x5C, 0x07, 0x3D, 0xE3, 0xBE, 0x3B, 0x54, 0xD5
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_64_A_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_A_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_A_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_A_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_A_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_A_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_B_CascadeJumpCipher {

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
    // bit0 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit1 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit2 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit3 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit4 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit5 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit6 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit7 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit2 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit4 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit6 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit7 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // Avalanche: 50.00%

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
        0x15, 0xA8, 0x9B, 0x46, 0x6F, 0xCE, 0x7E, 0x6F, 0x5F, 0x30, 0x92, 0x32, 0xC7, 0xE4, 0xD3, 0x43,
        0x4D, 0xE8, 0x64, 0xCA, 0x63, 0x44, 0x75, 0x4D, 0xF1, 0x41, 0xA8, 0xED, 0xEA, 0xFD, 0xD7, 0x05,
        0xE0, 0xC9, 0x1D, 0x19, 0x36, 0xD1, 0x10, 0x69, 0xB8, 0x91, 0x87, 0x31, 0xA5, 0x3C, 0x12, 0x00,
        0x89, 0xE9, 0xAA, 0xD1, 0x1B, 0xA3, 0x32, 0xB4, 0x85, 0x8A, 0xF4, 0x0F, 0x8C, 0xAD, 0xD5, 0xBC
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
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
                                                    "test_fixed_64_B_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_B_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_B_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_B_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_B_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_B_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_C_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101  11111111  11111111  10101010  10101010
    // bit1 00000000  00000000  01010101  01010101  11111111  11111111  01010101  01010101
    // bit2 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010
    // bit3 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101
    // bit4 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101
    // bit5 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101
    // bit6 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101
    // bit7 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........
    // bit1 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit2 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit3 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit4 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit5 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit6 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // Avalanche: 53.12%

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
        0xCB, 0x48, 0x44, 0x96, 0x17, 0x3F, 0x88, 0xF7, 0x71, 0x14, 0x95, 0xD5, 0x46, 0x09, 0xD4, 0xE9,
        0x65, 0x50, 0x52, 0x1E, 0x1E, 0x88, 0x9F, 0x4F, 0xFD, 0xCD, 0x84, 0xE3, 0x4C, 0x94, 0x09, 0x91,
        0xCC, 0xAC, 0x88, 0x12, 0x77, 0x9E, 0xF5, 0x63, 0x3E, 0x90, 0xA5, 0x72, 0x0B, 0x66, 0x65, 0x59,
        0x34, 0x21, 0x57, 0x0D, 0x00, 0x92, 0xEA, 0x6E, 0x80, 0xC7, 0xB0, 0x4F, 0x4E, 0xD1, 0xE2, 0x33
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0,
        0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF,
        0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_C_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_C_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_C_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_C_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_C_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_C_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_D_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010
    // bit1 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010
    // bit2 00000000  00000000  10101010  10101010  00000000  00000000  01010101  01010101
    // bit3 00000000  00000000  01010101  01010101  11111111  11111111  01010101  01010101
    // bit4 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010
    // bit5 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101
    // bit6 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101
    // bit7 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit1 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........
    // bit2 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........
    // bit3 .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........
    // bit4 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit5 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit6 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // Avalanche: 46.88%

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
        0xD2, 0x36, 0xD3, 0x48, 0x50, 0xE9, 0xC6, 0x63, 0x55, 0x52, 0x60, 0xF2, 0x1A, 0x89, 0x63, 0x9F,
        0x5B, 0x5A, 0xBB, 0xDC, 0xC7, 0x6D, 0xAC, 0x79, 0x9A, 0xA8, 0x63, 0x92, 0x5C, 0xC7, 0x81, 0x7F,
        0xD9, 0xA0, 0x00, 0xCA, 0xB3, 0x96, 0xA5, 0x8A, 0xD0, 0xCC, 0x28, 0x05, 0x1E, 0xE7, 0x24, 0xB6,
        0xC2, 0x4D, 0xC6, 0xBA, 0x5E, 0x3E, 0xFB, 0x34, 0x4A, 0x62, 0xD8, 0xB8, 0x13, 0x17, 0x05, 0x08
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98,
        0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57,
        0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_D_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_D_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_D_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_D_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_D_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_D_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_E_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010
    // bit1 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101
    // bit2 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101
    // bit3 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010
    // bit4 00000000  00000000  10101010  10101010  00000000  00000000  01010101  01010101
    // bit5 00000000  00000000  01010101  01010101  11111111  11111111  01010101  01010101
    // bit6 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010
    // bit7 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit1 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit2 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit3 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit4 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........
    // bit5 .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........
    // bit6 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit7 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........
    // Avalanche: 46.88%

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
        0xDF, 0xDD, 0x25, 0xD8, 0xB1, 0x9F, 0x72, 0x68, 0x97, 0xB3, 0x5D, 0x5D, 0x9E, 0xF1, 0x52, 0xA6,
        0x5B, 0xFF, 0x7F, 0x19, 0x68, 0xB2, 0x2D, 0xCC, 0xE8, 0xDB, 0x82, 0x0E, 0x92, 0x47, 0x03, 0x4F,
        0x2F, 0x7C, 0xC5, 0x8B, 0xFD, 0x33, 0xCF, 0x03, 0x41, 0xA8, 0x26, 0x9F, 0x6E, 0x69, 0x22, 0x92,
        0x88, 0xE4, 0x09, 0x80, 0xE0, 0x35, 0x83, 0x2D, 0xF5, 0x39, 0x44, 0xC3, 0x1D, 0x72, 0xED, 0x4F
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86,
        0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
        0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_E_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_E_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_E_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_E_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_E_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_E_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_F_CascadeJumpCipher {

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
    // bit0 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010
    // bit1 00000000  00000000  01010101  01010101  00000000  00000000  01010101  01010101
    // bit2 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010
    // bit3 00000000  00000000  01010101  01010101  00000000  00000000  01010101  01010101
    // bit4 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010
    // bit5 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010
    // bit6 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010
    // bit7 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........
    // bit1 .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........
    // bit2 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........
    // bit3 .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........
    // bit4 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........
    // bit5 .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit6 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // Avalanche: 34.38%

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
        0xB3, 0xEB, 0xB4, 0x5A, 0x3F, 0x4A, 0x35, 0xF8, 0xB0, 0xB7, 0xB6, 0x61, 0xB9, 0xB0, 0x07, 0x27,
        0x2B, 0x1C, 0x39, 0x9D, 0xDE, 0x50, 0x81, 0xB6, 0xA8, 0x9F, 0x86, 0x96, 0xA7, 0x71, 0xDD, 0x9D,
        0x50, 0x42, 0x71, 0x68, 0x3A, 0x29, 0xE5, 0x9A, 0xC9, 0xE8, 0x9A, 0xC6, 0xE1, 0x35, 0xAD, 0x26,
        0x69, 0x39, 0xE3, 0xCD, 0x11, 0xA9, 0x02, 0xCB, 0x51, 0x80, 0x28, 0xF5, 0xE7, 0x1C, 0x3A, 0xC3
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[64] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54,
        0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
        0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_F_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_F_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_F_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_F_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_F_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_64_F_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_A_CascadeJumpCipher {

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
    // bit0 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 0.00%

    const std::uint8_t aOriginal[80] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aMaskBuffer[80] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aMaskJumpBuffer[80] = {
        0x7D, 0x99, 0xB4, 0x72, 0x7D, 0xD2, 0xDA, 0x7B, 0x0C, 0x20, 0x4A, 0x69, 0x25, 0x96, 0x91, 0xE3,
        0x79, 0x56, 0xF5, 0x71, 0x86, 0x6F, 0x08, 0x6D, 0x88, 0x30, 0xF0, 0xC0, 0x67, 0x2F, 0x60, 0x5D,
        0xD4, 0x3A, 0x12, 0x1B, 0x7E, 0x48, 0x2C, 0x19, 0x36, 0x48, 0x22, 0xA1, 0x6E, 0xCC, 0x95, 0x9F,
        0xAB, 0x52, 0x26, 0x8D, 0x50, 0x16, 0x11, 0x51, 0x9E, 0x40, 0xC1, 0x3E, 0x37, 0xC3, 0xEC, 0x0E,
        0xE0, 0xDE, 0xB1, 0xC3, 0xB0, 0x36, 0x62, 0xA0, 0x10, 0xB3, 0x1C, 0x67, 0xAB, 0x70, 0x0F, 0xCB
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[80] = {
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
                                                    "test_fixed_80_A_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_A_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_A_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_A_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_A_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_A_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_B_CascadeJumpCipher {

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
    // bit0 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000
    // bit1 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000
    // bit2 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000
    // bit3 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000
    // bit4 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000
    // bit5 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000
    // bit6 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000
    // bit7 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit1 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit2 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit5 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit6 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit7 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // Avalanche: 60.00%

    const std::uint8_t aOriginal[80] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskBuffer[80] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskJumpBuffer[80] = {
        0x52, 0xDD, 0x65, 0x82, 0x1A, 0x5D, 0xA0, 0xC8, 0xDB, 0xFF, 0xB7, 0xBC, 0xF3, 0xFB, 0x69, 0x2D,
        0x16, 0x29, 0x9B, 0xC6, 0x0E, 0x9B, 0x88, 0x0A, 0x51, 0xCB, 0x59, 0x78, 0xF1, 0xEF, 0x1B, 0x37,
        0x86, 0x89, 0x80, 0xC9, 0xD8, 0x29, 0xEA, 0x45, 0x28, 0x67, 0xCE, 0x62, 0xA0, 0xA1, 0x78, 0xB2,
        0x36, 0x75, 0xFF, 0x22, 0x3A, 0x3B, 0x9C, 0xB2, 0x01, 0x02, 0x8C, 0x48, 0x40, 0x26, 0xB1, 0xA9,
        0x8C, 0xC7, 0xBD, 0xB2, 0xA2, 0x09, 0x5F, 0xD8, 0x79, 0x4E, 0x55, 0x79, 0xD9, 0x37, 0x5B, 0xA0
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[80] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
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
                                                    "test_fixed_80_B_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_B_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_B_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_B_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_B_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_B_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_C_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101  11111111  11111111  10101010  10101010  11111111  11111111
    // bit1 00000000  00000000  01010101  01010101  11111111  11111111  01010101  01010101  00000000  00000000
    // bit2 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111
    // bit3 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000
    // bit4 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000
    // bit5 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000
    // bit6 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000
    // bit7 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X
    // bit1 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit2 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // bit3 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit4 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // bit5 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // bit6 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // Avalanche: 52.50%

    const std::uint8_t aOriginal[80] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskBuffer[80] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskJumpBuffer[80] = {
        0x70, 0xAF, 0x03, 0x0F, 0x1E, 0xED, 0x60, 0x51, 0x2E, 0x61, 0x5D, 0x55, 0xB6, 0x0C, 0x2A, 0x84,
        0x37, 0x86, 0x88, 0x7B, 0x2B, 0xD4, 0xCD, 0x9E, 0xC4, 0x09, 0x9D, 0xF1, 0x62, 0x9D, 0x63, 0x31,
        0xA1, 0x9B, 0xB4, 0x48, 0xAA, 0xE6, 0x79, 0x97, 0x71, 0x49, 0x2E, 0xA2, 0x96, 0xD9, 0x19, 0xAB,
        0xBF, 0x0E, 0x3F, 0xD7, 0x75, 0xEB, 0xD3, 0xCD, 0x81, 0x06, 0x2B, 0x16, 0x0F, 0xF2, 0x54, 0x4E,
        0x70, 0x4E, 0xE6, 0x88, 0x05, 0xCA, 0x8C, 0x89, 0x97, 0x61, 0xC8, 0xC2, 0x8D, 0xBB, 0x7A, 0xED
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[80] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0,
        0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF,
        0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F,
        0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_80_C_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_C_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_C_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_C_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_C_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_C_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_D_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  00000000  00000000
    // bit1 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  00000000  00000000
    // bit2 00000000  00000000  10101010  10101010  00000000  00000000  01010101  01010101  00000000  00000000
    // bit3 00000000  00000000  01010101  01010101  11111111  11111111  01010101  01010101  00000000  00000000
    // bit4 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111
    // bit5 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000
    // bit6 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  11111111  11111111
    // bit7 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.
    // bit2 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X
    // bit3 .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // bit5 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit6 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // Avalanche: 47.50%

    const std::uint8_t aOriginal[80] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskBuffer[80] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskJumpBuffer[80] = {
        0x62, 0xF4, 0x43, 0x00, 0xFE, 0xD2, 0xE4, 0xB2, 0xB7, 0x24, 0xC1, 0x91, 0x47, 0x95, 0x81, 0x0A,
        0x82, 0xC7, 0x0A, 0xD5, 0x8F, 0x7E, 0xD1, 0x11, 0x7F, 0xFE, 0x9E, 0xDA, 0x1E, 0xEC, 0xD2, 0xCE,
        0x28, 0x76, 0x9D, 0xA2, 0xD9, 0x92, 0xE0, 0x00, 0x1E, 0xCD, 0x6C, 0x43, 0x70, 0x78, 0xB5, 0xA2,
        0x06, 0xA5, 0x8D, 0x0B, 0x3D, 0xBD, 0xDA, 0x39, 0x98, 0x10, 0xC8, 0x5F, 0x47, 0x47, 0x94, 0x59,
        0x4F, 0x55, 0xB1, 0xBF, 0x80, 0xDC, 0xC2, 0xF8, 0x6C, 0xBF, 0x18, 0x45, 0xC1, 0xC4, 0x15, 0xA7
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[80] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98,
        0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57,
        0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36,
        0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_80_D_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_D_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_D_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_D_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_D_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_D_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_E_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111
    // bit1 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000
    // bit2 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  11111111  11111111
    // bit3 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  00000000  00000000
    // bit4 00000000  00000000  10101010  10101010  00000000  00000000  01010101  01010101  00000000  00000000
    // bit5 00000000  00000000  01010101  01010101  11111111  11111111  01010101  01010101  00000000  00000000
    // bit6 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  00000000  00000000
    // bit7 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // bit1 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit2 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.
    // bit3 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // bit4 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X
    // bit5 .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // bit6 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.
    // bit7 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.
    // Avalanche: 47.50%

    const std::uint8_t aOriginal[80] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskBuffer[80] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskJumpBuffer[80] = {
        0x08, 0x74, 0x20, 0x2B, 0xBA, 0xE7, 0x1B, 0x12, 0x3E, 0xA2, 0xE3, 0x40, 0x36, 0x02, 0xEB, 0xA4,
        0x0C, 0x17, 0x2E, 0x85, 0x27, 0xAB, 0xC7, 0xF7, 0x43, 0xC2, 0x02, 0x68, 0x62, 0x13, 0xF7, 0x74,
        0x51, 0xC5, 0x38, 0x74, 0x39, 0xC4, 0xEA, 0xC6, 0xF3, 0x53, 0xD4, 0x64, 0x3E, 0xFA, 0x59, 0xDE,
        0xE7, 0x5F, 0xA9, 0xF5, 0x0E, 0x2F, 0x4E, 0xAA, 0x67, 0xF3, 0xCA, 0xCC, 0xB5, 0xDB, 0x84, 0x27,
        0xFA, 0xB6, 0x3D, 0xC1, 0x76, 0xB1, 0x7F, 0xCB, 0xDF, 0x37, 0x9C, 0xBA, 0xB2, 0x8E, 0x66, 0x30
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[80] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86,
        0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
        0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C,
        0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_80_E_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_E_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_E_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_E_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_E_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_E_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_F_CascadeJumpCipher {

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
    // bit0 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  00000000  00000000
    // bit1 00000000  00000000  01010101  01010101  00000000  00000000  01010101  01010101  00000000  00000000
    // bit2 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  00000000  00000000
    // bit3 00000000  00000000  01010101  01010101  00000000  00000000  01010101  01010101  00000000  00000000
    // bit4 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  11111111  11111111
    // bit5 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  00000000  00000000
    // bit6 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  11111111  11111111
    // bit7 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.
    // bit1 .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X
    // bit2 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.
    // bit3 .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // bit5 .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // bit6 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[80] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskBuffer[80] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[80] = {
        0x4A, 0xE9, 0x6B, 0x70, 0x27, 0x17, 0xDB, 0x59, 0xA0, 0x7B, 0x99, 0x3F, 0x57, 0x80, 0x22, 0x3A,
        0xF2, 0x7A, 0xBF, 0xEF, 0x4C, 0xEF, 0xBA, 0x01, 0x8F, 0x5A, 0x02, 0x15, 0xDB, 0x69, 0x1F, 0x8E,
        0x9D, 0xC6, 0xA0, 0x5A, 0xAE, 0x6F, 0xEA, 0x42, 0x77, 0x21, 0xB5, 0x35, 0xCC, 0x2F, 0x1C, 0xF4,
        0x0B, 0xEA, 0x8E, 0x18, 0x41, 0xAF, 0x03, 0xC0, 0xA9, 0xEB, 0x10, 0x8C, 0x39, 0x57, 0x0A, 0xFF,
        0xBC, 0xD7, 0xDB, 0x8F, 0x3F, 0xAE, 0x34, 0x50, 0xC1, 0x18, 0xDC, 0x5B, 0x42, 0x8D, 0x95, 0x64
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[80] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54,
        0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
        0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50,
        0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_80_F_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_F_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_F_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_F_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_F_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_80_F_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_A_CascadeJumpCipher {

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
        0xD9, 0x15, 0x54, 0x21, 0x3D, 0x01, 0x83, 0x7A, 0x81, 0x48, 0xD4, 0xA4, 0x60, 0x71, 0x08, 0xB2,
        0x32, 0xDE, 0x70, 0x80, 0x36, 0xAA, 0x6D, 0x33, 0x16, 0xEC, 0xF3, 0xB2, 0xDC, 0x2C, 0x9C, 0xEF,
        0xCB, 0x16, 0x11, 0x9B, 0x84, 0xEF, 0x92, 0x0B, 0x7D, 0x1D, 0x39, 0xFB, 0x38, 0xEC, 0x8B, 0x6C,
        0x76, 0x3C, 0xC8, 0xB7, 0xE6, 0xB7, 0xB1, 0x08, 0x45, 0xA7, 0x63, 0x6F, 0xFD, 0x31, 0x32, 0x82,
        0x4A, 0x8E, 0x85, 0xA0, 0x59, 0x01, 0xE5, 0x68, 0x6E, 0x98, 0xEA, 0x89, 0x58, 0xBB, 0x66, 0x72,
        0x1F, 0xFE, 0xAD, 0xE5, 0x37, 0x6C, 0xB9, 0xD9, 0x84, 0x48, 0xA4, 0xFF, 0x1B, 0x67, 0xC2, 0x41
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_96_A_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_A_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_A_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_A_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_A_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_A_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_B_CascadeJumpCipher {

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
    // bit0 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit1 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit2 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit3 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit4 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit5 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit6 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit7 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit2 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit4 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit6 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit7 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // Avalanche: 50.00%

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
        0x07, 0x11, 0xC9, 0x35, 0xF4, 0x1D, 0xBF, 0xE0, 0x28, 0x28, 0x41, 0x82, 0xD0, 0xBD, 0xE0, 0x2A,
        0xCA, 0xAB, 0x57, 0x6D, 0x5F, 0xB0, 0xE6, 0x14, 0xC0, 0xE5, 0x1D, 0x5F, 0xB7, 0xB7, 0x14, 0xDD,
        0x0C, 0xD1, 0x17, 0x96, 0x04, 0xC8, 0x48, 0xBC, 0x2C, 0x6B, 0x8D, 0x7E, 0xD9, 0xBD, 0xE5, 0x0B,
        0xC0, 0xBF, 0xFC, 0x52, 0x63, 0x06, 0x51, 0x92, 0x36, 0xC8, 0x20, 0x33, 0xD4, 0x41, 0x44, 0xFA,
        0x76, 0x85, 0xEF, 0x7B, 0xF3, 0xB8, 0x03, 0xD8, 0x27, 0xA4, 0x05, 0xFA, 0x33, 0x4F, 0xBC, 0x67,
        0x36, 0xDC, 0x91, 0xBC, 0x13, 0xCF, 0x35, 0x8D, 0x5F, 0x6F, 0x95, 0x14, 0xA3, 0xBD, 0x25, 0xE4
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
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
                                                    "test_fixed_96_B_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_B_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_B_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_B_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_B_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_B_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_C_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101  11111111  11111111  10101010  10101010  11111111  11111111  01010101  01010101
    // bit1 00000000  00000000  01010101  01010101  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010
    // bit2 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101
    // bit3 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010
    // bit4 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010
    // bit5 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010
    // bit6 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010
    // bit7 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  01010101  01010101
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit1 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit2 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit3 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit4 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit5 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit6 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........
    // Avalanche: 54.17%

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
        0x9A, 0x78, 0x39, 0x78, 0x67, 0x7E, 0xAF, 0x3A, 0x0D, 0x91, 0xE6, 0x2F, 0xA7, 0x24, 0x41, 0x96,
        0xCD, 0x35, 0x17, 0xBC, 0xB4, 0xCF, 0xAC, 0x0C, 0x13, 0xB3, 0xF4, 0x32, 0xB7, 0x7D, 0x4F, 0xFE,
        0x8B, 0xE5, 0x18, 0x70, 0x94, 0x1C, 0x38, 0x76, 0x41, 0x5C, 0x0D, 0x30, 0xA6, 0xEA, 0x9F, 0xAC,
        0xE6, 0xBE, 0xFA, 0x1A, 0x0E, 0x4F, 0x4E, 0x86, 0x56, 0x44, 0x9D, 0x7A, 0x89, 0xFF, 0x27, 0xE0,
        0x30, 0x5D, 0x2C, 0xB3, 0x65, 0xA1, 0xE9, 0x42, 0xED, 0x3A, 0x0A, 0x54, 0xC2, 0x47, 0x70, 0x0C,
        0xD3, 0x81, 0x60, 0xE3, 0xB5, 0x01, 0x56, 0xE8, 0xAC, 0x28, 0x06, 0x8C, 0xC1, 0xA8, 0xAD, 0xED
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0,
        0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF,
        0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F,
        0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0,
        0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_C_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_C_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_C_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_C_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_C_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_C_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_D_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  00000000  00000000  01010101  01010101
    // bit1 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  00000000  00000000  10101010  10101010
    // bit2 00000000  00000000  10101010  10101010  00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010
    // bit3 00000000  00000000  01010101  01010101  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010
    // bit4 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101
    // bit5 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  01010101  01010101
    // bit6 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  11111111  11111111  10101010  10101010
    // bit7 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  00000000  00000000  10101010  10101010
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit1 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........
    // bit2 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit3 .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit4 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit5 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit6 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // Avalanche: 54.17%

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
        0x6E, 0xBC, 0xB3, 0xF2, 0xC6, 0xB1, 0x8C, 0x21, 0x89, 0x37, 0x2A, 0xC0, 0xD9, 0x21, 0xBA, 0xF5,
        0x0B, 0xDA, 0xD5, 0x04, 0x53, 0x44, 0x39, 0xBC, 0x8B, 0x2A, 0xE1, 0xC3, 0xE5, 0xDD, 0x67, 0x1B,
        0x12, 0xFB, 0x58, 0x3F, 0x76, 0xE8, 0x02, 0x53, 0x44, 0x8D, 0x0C, 0x4F, 0x88, 0x6A, 0x3E, 0xCD,
        0x76, 0x78, 0xCE, 0x15, 0xF9, 0x7E, 0x44, 0x6A, 0xF3, 0xC4, 0xE4, 0x91, 0x7A, 0x35, 0xAD, 0x55,
        0xA6, 0xAA, 0xF1, 0x46, 0x4B, 0x7D, 0x34, 0x25, 0x65, 0x5F, 0x57, 0x14, 0xE6, 0x3E, 0x15, 0x09,
        0x43, 0x06, 0x3B, 0x80, 0x10, 0x17, 0x71, 0x5B, 0x17, 0xC9, 0x8A, 0xD3, 0x15, 0x31, 0x7C, 0x45
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98,
        0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57,
        0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36,
        0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A,
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
                                                    "test_fixed_96_D_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_D_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_D_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_D_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_D_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_D_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_E_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101
    // bit1 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  01010101  01010101
    // bit2 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  11111111  11111111  10101010  10101010
    // bit3 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  00000000  00000000  10101010  10101010
    // bit4 00000000  00000000  10101010  10101010  00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010
    // bit5 00000000  00000000  01010101  01010101  11111111  11111111  01010101  01010101  00000000  00000000  01010101  01010101
    // bit6 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  00000000  00000000  01010101  01010101
    // bit7 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  00000000  00000000  01010101  01010101
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit1 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit2 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit3 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit4 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit5 .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........
    // bit6 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit7 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // Avalanche: 54.17%

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
        0xE5, 0x5A, 0xFC, 0xD3, 0x6E, 0x92, 0x78, 0x15, 0x24, 0x9C, 0xF2, 0x97, 0xDD, 0x04, 0x0A, 0x76,
        0xA0, 0x38, 0x22, 0x92, 0xE6, 0x52, 0x16, 0x35, 0xE0, 0x4E, 0xB2, 0x88, 0x02, 0xB0, 0x2D, 0xE6,
        0xD4, 0xC8, 0x3A, 0x55, 0x92, 0xBE, 0xDC, 0x4B, 0x79, 0x50, 0xCF, 0x9A, 0xED, 0xCD, 0xAC, 0x53,
        0xBF, 0x43, 0xB9, 0x50, 0x24, 0x4D, 0x4A, 0xCA, 0x67, 0x6D, 0x50, 0xC2, 0xC5, 0xFE, 0x60, 0xB3,
        0x21, 0x9E, 0x6F, 0xB4, 0x59, 0x81, 0x82, 0x1B, 0x1A, 0xEC, 0x54, 0x2C, 0xCD, 0xD6, 0x50, 0xB0,
        0x80, 0x89, 0x3B, 0x97, 0x8C, 0x21, 0x86, 0xD8, 0x87, 0xC4, 0x4E, 0xF3, 0x01, 0x7D, 0xAE, 0xE6
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86,
        0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
        0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C,
        0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0,
        0x38, 0xC7, 0x38, 0xC7, 0x38, 0xC7, 0x38, 0xC7, 0x38, 0xC7, 0x38, 0xC7, 0x38, 0xC7, 0x38, 0xC7
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_E_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_E_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_E_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_E_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_E_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_E_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_F_CascadeJumpCipher {

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
    // bit0 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010
    // bit1 00000000  00000000  01010101  01010101  00000000  00000000  01010101  01010101  00000000  00000000  01010101  01010101
    // bit2 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010
    // bit3 00000000  00000000  01010101  01010101  00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010
    // bit4 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010
    // bit5 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010
    // bit6 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  11111111  11111111  10101010  10101010
    // bit7 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........
    // bit1 .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........
    // bit2 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........
    // bit3 .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit4 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........
    // bit5 .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit6 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // Avalanche: 37.50%

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
        0x0F, 0x4D, 0x56, 0x9D, 0x9E, 0x77, 0x2F, 0xD5, 0xE6, 0xCA, 0x8B, 0x11, 0x9A, 0x4B, 0x80, 0x58,
        0x06, 0x7B, 0xE2, 0x2A, 0x90, 0x96, 0xB0, 0x87, 0x72, 0xB7, 0xB8, 0x43, 0xEC, 0xAF, 0x14, 0x21,
        0x8F, 0xC3, 0xF6, 0x6F, 0xDF, 0x0A, 0xD1, 0x2E, 0xE7, 0x9F, 0x11, 0xF0, 0x7E, 0x54, 0x0A, 0x55,
        0x5B, 0xB1, 0x26, 0x07, 0x05, 0xB7, 0xD1, 0x7D, 0xB4, 0xA9, 0x8A, 0x20, 0xAF, 0x27, 0x99, 0xF0,
        0xE8, 0x95, 0x96, 0x1B, 0x48, 0xEE, 0x66, 0x8C, 0x9A, 0xD6, 0x83, 0xD9, 0xD0, 0xA7, 0x76, 0x46,
        0x71, 0x59, 0xE8, 0x77, 0xB9, 0x65, 0x21, 0x78, 0x78, 0x9E, 0xAB, 0x68, 0x36, 0x32, 0x64, 0x2A
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[96] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54,
        0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
        0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50,
        0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A,
        0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_F_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_F_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_F_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_F_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_F_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_96_F_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_A_CascadeJumpCipher {

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
    // bit1 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit2 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit3 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit4 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit5 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit6 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit1 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit2 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit3 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit4 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit5 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit6 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // bit7 ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........  ........
    // Avalanche: 0.00%

    const std::uint8_t aOriginal[112] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aMaskBuffer[112] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aMaskJumpBuffer[112] = {
        0xFA, 0xB6, 0xB1, 0x07, 0x59, 0xB1, 0xC9, 0xE1, 0x49, 0x3A, 0x62, 0x23, 0x9D, 0x07, 0xC7, 0x52,
        0x54, 0x81, 0x3E, 0xC1, 0x28, 0x10, 0x21, 0xAB, 0x11, 0xCF, 0x1D, 0x77, 0xED, 0x6C, 0x76, 0xC6,
        0x68, 0xE7, 0xA8, 0x39, 0x80, 0xF7, 0x56, 0x30, 0x1A, 0xB4, 0x56, 0xAD, 0xB1, 0x69, 0xFF, 0xA6,
        0x3D, 0x2D, 0xCF, 0x8F, 0x06, 0x1C, 0x7A, 0xAF, 0xF2, 0x0E, 0xF0, 0x61, 0x84, 0x0A, 0x83, 0x44,
        0x1D, 0xA9, 0xB9, 0xAF, 0x86, 0xC0, 0x23, 0x63, 0x19, 0x32, 0x41, 0xBA, 0x40, 0xF2, 0x64, 0xAA,
        0xC9, 0xAA, 0xA9, 0xE7, 0x91, 0xE3, 0xC3, 0xE8, 0x09, 0xED, 0xE8, 0x28, 0xB1, 0x7D, 0xC8, 0x1E,
        0x2E, 0xB8, 0x36, 0xE1, 0xEC, 0xB6, 0x6E, 0xE0, 0x43, 0x9A, 0x52, 0x8C, 0x09, 0xCA, 0x0D, 0x11
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[112] = {
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
                                                    "test_fixed_112_A_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_A_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_A_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_A_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_A_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_A_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_B_CascadeJumpCipher {

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
    // bit0 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000
    // bit1 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000
    // bit2 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000
    // bit3 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000
    // bit4 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000
    // bit5 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000
    // bit6 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000
    // bit7 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit1 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit2 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit3 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit4 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit5 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit6 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit7 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // Avalanche: 57.14%

    const std::uint8_t aOriginal[112] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskBuffer[112] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskJumpBuffer[112] = {
        0xA0, 0x97, 0x6C, 0xDC, 0xA8, 0x17, 0xB4, 0x51, 0x20, 0x3D, 0xC3, 0xE8, 0x12, 0x02, 0xAB, 0xF0,
        0x10, 0xD1, 0xD0, 0x23, 0x6E, 0xA0, 0x20, 0x77, 0x2B, 0x5B, 0x61, 0x07, 0x25, 0x20, 0x5F, 0x99,
        0xDB, 0x50, 0x81, 0xCC, 0x7C, 0x3F, 0x8E, 0x57, 0x14, 0x21, 0xB6, 0x1D, 0xAC, 0x7D, 0xDC, 0x45,
        0xF8, 0x2F, 0x24, 0x7A, 0x50, 0x67, 0xB3, 0xCB, 0xB7, 0x55, 0xA0, 0x01, 0xD5, 0x15, 0x76, 0x44,
        0x64, 0x77, 0x5F, 0xFB, 0xD3, 0xB5, 0xE2, 0xED, 0x69, 0xE5, 0x56, 0xC7, 0x9D, 0x84, 0x72, 0xFE,
        0xB5, 0x04, 0xAA, 0xC4, 0x1F, 0x9A, 0x1E, 0xC4, 0xB4, 0xBE, 0xAE, 0x21, 0xBC, 0xC2, 0x2C, 0x05,
        0x34, 0x0E, 0xE5, 0x7E, 0x7C, 0xCE, 0xE2, 0x9B, 0xC8, 0x5F, 0xF6, 0x6B, 0x9D, 0x3F, 0x1C, 0x09
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[112] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
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
                                                    "test_fixed_112_B_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_B_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_B_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_B_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_B_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_B_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_C_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101  11111111  11111111  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000
    // bit1 00000000  00000000  01010101  01010101  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111
    // bit2 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000
    // bit3 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111
    // bit4 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111
    // bit5 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111
    // bit6 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010  00000000  00000000
    // bit7 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  01010101  01010101  11111111  11111111
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // bit2 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit3 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // bit4 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit5 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit6 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.
    // Avalanche: 53.57%

    const std::uint8_t aOriginal[112] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskBuffer[112] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskJumpBuffer[112] = {
        0xA7, 0x20, 0x0A, 0x60, 0x88, 0xA8, 0x6F, 0xC7, 0xB4, 0x33, 0x84, 0xC9, 0x0A, 0x41, 0xE2, 0xFB,
        0xD8, 0x82, 0x62, 0x5E, 0x83, 0x72, 0xDD, 0x88, 0x22, 0x73, 0x6D, 0x2C, 0x4E, 0xE9, 0xEB, 0x8A,
        0xDE, 0xF5, 0xB4, 0x0F, 0xD7, 0x94, 0x5B, 0xE3, 0x62, 0xD8, 0x64, 0x14, 0xFF, 0x4F, 0xDC, 0x31,
        0xE2, 0x73, 0x81, 0xDE, 0xE1, 0x0C, 0x30, 0xF2, 0x6A, 0x1D, 0xE8, 0x46, 0x17, 0xBC, 0xB2, 0x2E,
        0xCF, 0x89, 0x54, 0xC4, 0x22, 0x4D, 0x34, 0xE6, 0x76, 0x74, 0x1A, 0xAF, 0x16, 0x0D, 0xB1, 0xC8,
        0x00, 0x10, 0xEF, 0xF7, 0x0F, 0x6A, 0xCA, 0x4E, 0x20, 0x4A, 0xD3, 0xE0, 0x32, 0xB0, 0x15, 0xC7,
        0x5E, 0xE8, 0x26, 0xC4, 0xBD, 0x7C, 0x4B, 0xD6, 0x10, 0x6C, 0xF6, 0x53, 0x42, 0x4F, 0xAA, 0x6D
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[112] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0,
        0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF,
        0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F,
        0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0,
        0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1,
        0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_112_C_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_C_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_C_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_C_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_C_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_C_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_D_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  00000000  00000000  01010101  01010101  00000000  00000000
    // bit1 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  00000000  00000000  10101010  10101010  11111111  11111111
    // bit2 00000000  00000000  10101010  10101010  00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111
    // bit3 00000000  00000000  01010101  01010101  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111
    // bit4 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  11111111  11111111
    // bit5 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  01010101  01010101  11111111  11111111
    // bit6 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  11111111  11111111  10101010  10101010  11111111  11111111
    // bit7 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  00000000  00000000  10101010  10101010  11111111  11111111
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit1 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // bit2 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit3 .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit4 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // bit5 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // bit6 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // Avalanche: 53.57%

    const std::uint8_t aOriginal[112] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskBuffer[112] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskJumpBuffer[112] = {
        0xA7, 0x5E, 0x06, 0x09, 0xAF, 0xF1, 0xC7, 0xEC, 0xE4, 0x2B, 0xC1, 0xDE, 0xFA, 0xCD, 0x8D, 0xFF,
        0x6C, 0xD1, 0x59, 0x93, 0x09, 0x72, 0xE8, 0x5F, 0x26, 0xD0, 0x9C, 0x57, 0xDA, 0x0A, 0x8C, 0xED,
        0xC2, 0xC3, 0x08, 0xF4, 0xF5, 0xD0, 0x14, 0x8E, 0xBB, 0x0C, 0x5A, 0x8D, 0x6C, 0xFB, 0xD2, 0xF5,
        0x59, 0x8D, 0xA8, 0x03, 0x7C, 0x83, 0xD0, 0xCB, 0xC9, 0xCB, 0x15, 0x37, 0x5A, 0xF2, 0x62, 0x98,
        0x6A, 0xBB, 0x3E, 0xC9, 0x61, 0xAB, 0xDC, 0x8F, 0x02, 0xDD, 0x04, 0x0D, 0xB3, 0x2E, 0x8C, 0xD8,
        0x4F, 0x8F, 0xF2, 0x8B, 0x81, 0x25, 0xCA, 0x75, 0x28, 0x3C, 0xF2, 0xF2, 0x3C, 0x39, 0xB3, 0xDD,
        0x95, 0xF9, 0x03, 0xB5, 0x6A, 0xBE, 0x5E, 0x38, 0x28, 0xA3, 0x00, 0x00, 0x51, 0xEC, 0xD8, 0x1A
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[112] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98,
        0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57,
        0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36,
        0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A,
        0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C,
        0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_112_D_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_D_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_D_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_D_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_D_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_D_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_E_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  11111111  11111111
    // bit1 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  01010101  01010101  11111111  11111111
    // bit2 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  11111111  11111111  10101010  10101010  11111111  11111111
    // bit3 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  00000000  00000000  10101010  10101010  11111111  11111111
    // bit4 00000000  00000000  10101010  10101010  00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  00000000  00000000
    // bit5 00000000  00000000  01010101  01010101  11111111  11111111  01010101  01010101  00000000  00000000  01010101  01010101  11111111  11111111
    // bit6 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  00000000  00000000  01010101  01010101  11111111  11111111
    // bit7 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  00000000  00000000  01010101  01010101  11111111  11111111
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // bit1 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // bit2 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit3 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.
    // bit4 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // bit5 .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.
    // bit6 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // bit7 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // Avalanche: 53.57%

    const std::uint8_t aOriginal[112] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskBuffer[112] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskJumpBuffer[112] = {
        0xDE, 0x63, 0x9D, 0x68, 0xAA, 0xDE, 0x28, 0xD3, 0x4B, 0x87, 0xC3, 0x18, 0xFB, 0x53, 0xCD, 0xB7,
        0xDA, 0x68, 0x15, 0x48, 0x89, 0x60, 0x94, 0x78, 0x68, 0xD2, 0x4A, 0x4B, 0xF0, 0x4C, 0x55, 0xD6,
        0xFF, 0xF6, 0xFF, 0xF5, 0x27, 0x46, 0x2D, 0x0E, 0x45, 0x5D, 0x37, 0x8B, 0x6D, 0x61, 0x82, 0xCF,
        0x6E, 0x55, 0x7F, 0x01, 0x67, 0x2E, 0x52, 0x7E, 0x61, 0x06, 0x3D, 0x3F, 0xAA, 0x7D, 0xA7, 0x55,
        0xBC, 0x00, 0x53, 0xD6, 0xD9, 0x08, 0xF6, 0x81, 0x9F, 0x98, 0xA2, 0x55, 0x3C, 0x01, 0x31, 0x89,
        0x97, 0x93, 0xDF, 0xD7, 0x88, 0xC9, 0x18, 0x3E, 0x51, 0x51, 0x05, 0x91, 0x83, 0x68, 0x76, 0x2D,
        0x76, 0x64, 0xA0, 0x8D, 0x7F, 0x2B, 0xC3, 0x84, 0xA9, 0x91, 0xDB, 0x4D, 0x29, 0xE6, 0xB5, 0xB7
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[112] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86,
        0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
        0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C,
        0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0,
        0x38, 0xC7, 0x38, 0xC7, 0x38, 0xC7, 0x38, 0xC7, 0x38, 0xC7, 0x38, 0xC7, 0x38, 0xC7, 0x38, 0xC7,
        0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_112_E_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_E_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_E_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_E_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_E_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_E_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_F_CascadeJumpCipher {

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
    // bit0 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  00000000  00000000
    // bit1 00000000  00000000  01010101  01010101  00000000  00000000  01010101  01010101  00000000  00000000  01010101  01010101  00000000  00000000
    // bit2 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  11111111  11111111
    // bit3 00000000  00000000  01010101  01010101  00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  00000000  00000000
    // bit4 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  11111111  11111111
    // bit5 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  00000000  00000000
    // bit6 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  11111111  11111111  10101010  10101010  11111111  11111111
    // bit7 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  00000000  00000000
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.
    // bit1 .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X
    // bit2 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X
    // bit3 .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // bit4 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X
    // bit5 .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // bit6 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X
    // Avalanche: 39.29%

    const std::uint8_t aOriginal[112] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskBuffer[112] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskJumpBuffer[112] = {
        0x8C, 0x50, 0x63, 0x5A, 0xD8, 0x15, 0x5D, 0xE9, 0x2E, 0x4E, 0x41, 0x54, 0x7C, 0x78, 0xA7, 0x94,
        0x5C, 0x7B, 0x31, 0x21, 0xD3, 0x01, 0x6D, 0xFC, 0x4F, 0x7E, 0x0D, 0x93, 0xD5, 0x03, 0xD5, 0x17,
        0x62, 0xF5, 0x1A, 0xF7, 0x87, 0x42, 0x0B, 0x15, 0x23, 0x53, 0xE5, 0x28, 0x98, 0x7F, 0x7F, 0x44,
        0x9F, 0x1D, 0x58, 0x92, 0xE3, 0x27, 0xD3, 0x0B, 0xF0, 0x0D, 0xAF, 0xE6, 0x37, 0x08, 0xAA, 0x4E,
        0x51, 0x47, 0x08, 0xA0, 0xE0, 0x01, 0xE3, 0xB2, 0xE7, 0x13, 0x24, 0xBA, 0x74, 0xEB, 0xC8, 0xEA,
        0xDD, 0xC4, 0x66, 0xAD, 0xE8, 0xD8, 0x3B, 0xCC, 0x0C, 0x45, 0x3F, 0x85, 0x14, 0x2F, 0x71, 0x3F,
        0x2C, 0xD1, 0x9E, 0x35, 0xA4, 0x9C, 0xC6, 0x3A, 0x47, 0x9C, 0x01, 0x1C, 0x95, 0x83, 0x10, 0x7E
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[112] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54,
        0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
        0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50,
        0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A,
        0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40,
        0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_112_F_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_F_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_F_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_F_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_F_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_112_F_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_A_CascadeJumpCipher {

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
        0xE8, 0xB1, 0x44, 0x67, 0x69, 0x41, 0xCE, 0x9D, 0x19, 0xCE, 0xEC, 0x17, 0xE3, 0xAF, 0xCD, 0xA0,
        0xBF, 0x4D, 0x21, 0x49, 0x9C, 0xA0, 0x12, 0x09, 0x15, 0x19, 0xDF, 0xE9, 0x37, 0x08, 0x3E, 0xC2,
        0xA4, 0x6B, 0x5B, 0x25, 0xA9, 0x63, 0xB1, 0x31, 0xBD, 0x42, 0xD3, 0xB9, 0xFA, 0x2C, 0xA3, 0xFD,
        0x75, 0x36, 0x04, 0x5C, 0x0D, 0xEE, 0x50, 0xC5, 0x31, 0x2D, 0x6B, 0x2D, 0x72, 0x88, 0x83, 0x05,
        0xE4, 0x8B, 0xD5, 0x76, 0xB9, 0x17, 0x07, 0x4D, 0x8F, 0xE8, 0x97, 0xA2, 0x1A, 0x87, 0xD0, 0xF1,
        0x1F, 0x9C, 0x45, 0xB8, 0x10, 0xDA, 0x72, 0xFB, 0x65, 0x74, 0xD2, 0xAB, 0xAB, 0x1E, 0x5D, 0x58,
        0x0D, 0x4C, 0x48, 0x86, 0x55, 0xD0, 0x05, 0x0D, 0x7B, 0x77, 0x79, 0xDF, 0xC7, 0xE7, 0x67, 0xC7,
        0xBB, 0x4A, 0x7B, 0xFD, 0x39, 0x32, 0xE9, 0x17, 0xEA, 0xC7, 0x2A, 0x51, 0x8D, 0xEE, 0x81, 0x40
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
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
                                                    "test_fixed_128_A_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_A_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_A_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_A_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_A_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_A_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_B_CascadeJumpCipher {

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
    // bit0 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit1 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit2 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit3 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit4 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit5 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit6 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    // bit7 00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111  00000000  00000000  11111111  11111111
    //
    // Avalanche:
    // bit0 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit1 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit2 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit4 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit5 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit6 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // bit7 XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  ........  ........
    // Avalanche: 50.00%

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
        0xB4, 0xDF, 0x90, 0x41, 0x96, 0x09, 0x78, 0x36, 0x73, 0xEC, 0x5B, 0xCE, 0xFB, 0xF3, 0xF5, 0x95,
        0xA8, 0x65, 0xFF, 0x9E, 0xD7, 0x5C, 0x5C, 0x6A, 0xE4, 0x96, 0x60, 0x1B, 0xB0, 0xC3, 0xEB, 0x50,
        0x1B, 0x9B, 0x07, 0x5E, 0x0B, 0xD2, 0x90, 0x8A, 0x6F, 0x73, 0xBE, 0x10, 0xDF, 0x1D, 0x9E, 0x0C,
        0x56, 0xA2, 0xED, 0x0A, 0xAA, 0xAD, 0x73, 0x6D, 0x0B, 0x63, 0x84, 0x01, 0x98, 0x79, 0x6D, 0x59,
        0x7B, 0x9F, 0xF2, 0x0E, 0x0C, 0x4A, 0xFF, 0xB1, 0x9F, 0xEF, 0x6B, 0x11, 0x7A, 0x38, 0x61, 0xF7,
        0xD4, 0x31, 0xA4, 0xBB, 0xCD, 0xCF, 0x5E, 0x60, 0x57, 0xDB, 0x43, 0xE6, 0x81, 0xA9, 0x16, 0xC9,
        0x54, 0x47, 0xDF, 0xB8, 0x49, 0x91, 0xBD, 0xEB, 0x8C, 0x55, 0x86, 0x52, 0xE9, 0xB5, 0xF1, 0xAE,
        0xB2, 0x38, 0x05, 0x03, 0xA4, 0x1E, 0xB3, 0xAF, 0x3E, 0x1F, 0x39, 0xD4, 0x97, 0x48, 0x82, 0x2F
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
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
                                                    "test_fixed_128_B_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_B_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_B_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_B_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_B_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_B_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_C_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101  11111111  11111111  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010
    // bit1 00000000  00000000  01010101  01010101  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101
    // bit2 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010
    // bit3 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101
    // bit4 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101
    // bit5 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010
    // bit6 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010  00000000  00000000  01010101  01010101
    // bit7 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  01010101  01010101  11111111  11111111  10101010  10101010
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit1 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit2 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit3 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit4 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit5 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit6 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // Avalanche: 53.12%

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
        0x2B, 0x51, 0x06, 0xF5, 0xB0, 0x31, 0x74, 0xB6, 0x0C, 0x17, 0x4D, 0xE0, 0x5F, 0xD4, 0x38, 0x9F,
        0x15, 0xD0, 0xFD, 0xED, 0x54, 0x66, 0x76, 0x91, 0x84, 0xD5, 0x12, 0xDA, 0x1A, 0x15, 0xE9, 0x26,
        0x45, 0x40, 0x49, 0x4A, 0xD8, 0x33, 0xF6, 0x44, 0xE4, 0x6E, 0xF5, 0xF9, 0x8B, 0x72, 0x25, 0xB2,
        0xEE, 0x1B, 0x93, 0xA4, 0xF1, 0x00, 0x4F, 0x90, 0x0A, 0x8E, 0x52, 0x45, 0xE1, 0x70, 0xB7, 0x57,
        0xDF, 0xF3, 0xAC, 0x50, 0x41, 0xA2, 0xD0, 0xF2, 0x1F, 0x62, 0x76, 0xE8, 0x7A, 0x10, 0x49, 0x7E,
        0x5F, 0x9E, 0xAF, 0xB5, 0xB5, 0x95, 0x43, 0x27, 0xBD, 0xF7, 0x74, 0xD5, 0x45, 0xCE, 0xF0, 0x75,
        0x5D, 0xF0, 0x29, 0xF5, 0xBD, 0x22, 0xD2, 0x00, 0xEF, 0x58, 0x09, 0x9B, 0x8C, 0x2F, 0xC5, 0x59,
        0xE6, 0x2F, 0x06, 0x39, 0x74, 0xE4, 0x99, 0x9E, 0x4A, 0x59, 0x4B, 0x53, 0x79, 0xBB, 0xD5, 0x55
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0,
        0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF, 0xDF,
        0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F, 0xA0, 0x5F,
        0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0,
        0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1, 0x5E, 0xA1,
        0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D, 0x5D,
        0xA5, 0x5A, 0xA5, 0x5A, 0xA5, 0x5A, 0xA5, 0x5A, 0xA5, 0x5A, 0xA5, 0x5A, 0xA5, 0x5A, 0xA5, 0x5A
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_C_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_C_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_C_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_C_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_C_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_C_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_D_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010
    // bit1 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101
    // bit2 00000000  00000000  10101010  10101010  00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101
    // bit3 00000000  00000000  01010101  01010101  11111111  11111111  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010
    // bit4 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  11111111  11111111  10101010  10101010
    // bit5 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  01010101  01010101  11111111  11111111  01010101  01010101
    // bit6 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  11111111  11111111  10101010  10101010  11111111  11111111  01010101  01010101
    // bit7 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit1 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit2 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit3 .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit4 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........
    // bit5 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit6 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // Avalanche: 53.12%

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
        0x64, 0x9E, 0x28, 0x59, 0xF0, 0xD1, 0x35, 0x37, 0xF1, 0xA1, 0x6F, 0x77, 0x54, 0x10, 0x8F, 0xB2,
        0x48, 0xA1, 0xF1, 0xB9, 0x01, 0x82, 0xA7, 0x8C, 0x36, 0xE8, 0x05, 0xA0, 0x47, 0x55, 0x4F, 0xC9,
        0xFF, 0x96, 0x2E, 0x7F, 0x34, 0x38, 0xF4, 0x07, 0xF9, 0x50, 0xE5, 0x0D, 0x43, 0x00, 0xB5, 0xE6,
        0x25, 0x87, 0xAF, 0x70, 0x22, 0x19, 0x04, 0x4B, 0x13, 0xF2, 0x2F, 0x06, 0x49, 0xF2, 0xEB, 0x49,
        0xD2, 0xC2, 0x6E, 0x30, 0x7D, 0xA8, 0xFC, 0x0D, 0xB6, 0xA7, 0x93, 0x80, 0x3B, 0x67, 0x8B, 0x14,
        0x82, 0x48, 0x06, 0x1A, 0x5C, 0x05, 0x40, 0x4D, 0x73, 0xB8, 0x12, 0x08, 0x26, 0x23, 0x10, 0xD0,
        0x3C, 0xFA, 0x2A, 0xDF, 0xDF, 0xB9, 0xF6, 0xDD, 0xB0, 0xFE, 0xB2, 0x8C, 0x7D, 0x0C, 0xF2, 0x39,
        0xCC, 0x58, 0x96, 0x96, 0x5D, 0x10, 0xCF, 0x3D, 0x24, 0xAE, 0x70, 0x24, 0x4C, 0xD0, 0x53, 0x52
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98,
        0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57, 0x57,
        0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36, 0xC9, 0x36,
        0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A,
        0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C, 0x73, 0x8C,
        0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F,
        0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66, 0x99, 0x66
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_D_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_D_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_D_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_D_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_D_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_D_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_E_CascadeJumpCipher {

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
    // bit0 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  11111111  11111111  10101010  10101010
    // bit1 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  00000000  00000000  01010101  01010101  11111111  11111111  01010101  01010101
    // bit2 00000000  00000000  10101010  10101010  11111111  11111111  01010101  01010101  11111111  11111111  10101010  10101010  11111111  11111111  01010101  01010101
    // bit3 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010
    // bit4 00000000  00000000  10101010  10101010  00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  00000000  00000000  01010101  01010101
    // bit5 00000000  00000000  01010101  01010101  11111111  11111111  01010101  01010101  00000000  00000000  01010101  01010101  11111111  11111111  10101010  10101010
    // bit6 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  00000000  00000000  01010101  01010101  11111111  11111111  10101010  10101010
    // bit7 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  00000000  00000000  01010101  01010101  11111111  11111111  01010101  01010101
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........
    // bit1 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit2 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........
    // bit3 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit4 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........
    // bit5 .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit6 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  ........  ........
    // bit7 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // Avalanche: 53.12%

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
        0x65, 0x86, 0x35, 0x25, 0xE8, 0xD4, 0x2C, 0x2B, 0x64, 0x26, 0x64, 0x15, 0x77, 0xBC, 0x68, 0x70,
        0x7F, 0x06, 0x94, 0xCB, 0x53, 0xC6, 0x1B, 0x63, 0xC3, 0x80, 0x9E, 0x90, 0x1E, 0x93, 0x00, 0x02,
        0xA0, 0xBA, 0xE9, 0x5C, 0xA1, 0x98, 0x6D, 0x82, 0x42, 0x72, 0x17, 0x45, 0x16, 0xFA, 0x4B, 0x8F,
        0x90, 0xD3, 0x34, 0xF4, 0x9E, 0xC0, 0x48, 0x17, 0xF0, 0x37, 0x27, 0xE6, 0x40, 0xEE, 0x96, 0x05,
        0x6A, 0x7D, 0xBC, 0x82, 0x50, 0x9C, 0x4C, 0x3D, 0x25, 0x87, 0x72, 0x65, 0x64, 0x5B, 0xBA, 0x25,
        0xDC, 0x67, 0x7D, 0x5E, 0x01, 0x8F, 0x90, 0xE0, 0x63, 0xEA, 0x74, 0xB9, 0x69, 0x6B, 0x06, 0x5F,
        0x66, 0x25, 0xF0, 0xC8, 0x56, 0xD3, 0x72, 0x6C, 0xBD, 0xC1, 0xF5, 0xD5, 0x69, 0xC0, 0xC8, 0x20,
        0xC0, 0x5E, 0xEE, 0xDA, 0x5B, 0xEC, 0x67, 0xEC, 0xBB, 0x79, 0x54, 0x57, 0x6A, 0x63, 0x57, 0x67
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86, 0x79, 0x86,
        0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75, 0x75,
        0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C, 0x93, 0x6C,
        0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0, 0xA0,
        0x38, 0xC7, 0x38, 0xC7, 0x38, 0xC7, 0x38, 0xC7, 0x38, 0xC7, 0x38, 0xC7, 0x38, 0xC7, 0x38, 0xC7,
        0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7, 0xF7,
        0x96, 0x69, 0x96, 0x69, 0x96, 0x69, 0x96, 0x69, 0x96, 0x69, 0x96, 0x69, 0x96, 0x69, 0x96, 0x69
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_E_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_E_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_E_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_E_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_E_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_E_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_F_CascadeJumpCipher {

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
    // bit0 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010
    // bit1 00000000  00000000  01010101  01010101  00000000  00000000  01010101  01010101  00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010
    // bit2 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010
    // bit3 00000000  00000000  01010101  01010101  00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010
    // bit4 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  11111111  11111111  10101010  10101010
    // bit5 00000000  00000000  01010101  01010101  00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010
    // bit6 00000000  00000000  10101010  10101010  11111111  11111111  10101010  10101010  11111111  11111111  10101010  10101010  11111111  11111111  10101010  10101010
    // bit7 00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010  00000000  00000000  10101010  10101010
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........
    // bit1 .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit2 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........
    // bit3 .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit4 X.X.X.X.  X.X.X.X.  ........  ........  X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........
    // bit5 .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // bit6 X.X.X.X.  X.X.X.X.  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........  .X.X.X.X  .X.X.X.X  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX  .X.X.X.X  .X.X.X.X  XXXXXXXX  XXXXXXXX
    // Avalanche: 40.62%

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
        0xCF, 0x7B, 0x56, 0xBC, 0x68, 0x4F, 0xDF, 0x6D, 0x00, 0x7C, 0x9E, 0xF0, 0x47, 0xD8, 0x60, 0xFD,
        0xA0, 0x8E, 0x04, 0x40, 0x23, 0x31, 0xB6, 0x9E, 0x0A, 0x48, 0x37, 0xE4, 0x1A, 0x08, 0xE9, 0xFB,
        0xC8, 0x7E, 0xDF, 0x47, 0x2B, 0x78, 0x2F, 0x71, 0x71, 0x8B, 0xBE, 0x18, 0xBD, 0x48, 0x7C, 0xCE,
        0x58, 0xCC, 0x07, 0x65, 0x06, 0xA6, 0x3B, 0xFA, 0x5C, 0xA1, 0x0E, 0x16, 0xFD, 0xB1, 0xE9, 0xCD,
        0x03, 0x60, 0x66, 0x73, 0xF4, 0xFA, 0xD3, 0x39, 0x39, 0x27, 0xB0, 0xB0, 0x49, 0x8A, 0x38, 0x2B,
        0xDC, 0x07, 0x00, 0x68, 0x45, 0xA2, 0x76, 0x67, 0x78, 0xF6, 0xDD, 0x55, 0x2F, 0x16, 0x5F, 0xCA,
        0x15, 0x16, 0x0B, 0x3D, 0x01, 0x2C, 0x5F, 0x55, 0x6D, 0x35, 0x02, 0x7A, 0x3E, 0x12, 0x68, 0x1B,
        0xA9, 0x0C, 0x0B, 0x32, 0xF9, 0xB5, 0xAC, 0x9A, 0x55, 0x9A, 0x4A, 0x49, 0x19, 0xEB, 0xA5, 0x21
    };

    CascadeJumpCipher aCrypt(aMaskBuffer,
        aMaskJumpBuffer);

    const std::uint8_t aExpected[128] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54, 0xAB, 0x54,
        0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
        0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50, 0xAF, 0x50,
        0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A,
        0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40, 0xBF, 0x40,
        0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A,
        0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x00
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_F_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_F_CascadeJumpCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_F_CascadeJumpCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_F_CascadeJumpCipher")) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_F_CascadeJumpCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeJumpCipher] test_fixed_128_F_CascadeJumpCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

@end
