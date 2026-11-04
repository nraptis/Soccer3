//
//  Battery_PepperNoiseXORCipher.m
//  HolyStorms
//
//  Created by icarus black on 7/5/26.
//

#import <XCTest/XCTest.h>
#import "PepperNoiseXORCipher.hpp"
#import "PrintExamplesHelper.hpp"
#import "CipherGauntlet.hpp"
#include <memory>

@interface Battery_PepperNoiseXORCipher : XCTestCase

@end

@implementation Battery_PepperNoiseXORCipher

- (void)test_gauntlet_PepperNoiseXORCipher {
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
    std::vector<std::uint8_t *> aListNoise;
    
    aListMask.push_back(aRandA); aListMask.push_back(aRandB); aListMask.push_back(aRandC); aListMask.push_back(aRandD);
    aListMask.push_back(aRandE); aListMask.push_back(aRandF); aListMask.push_back(aRandG); aListMask.push_back(aRandH);
    aListMask.push_back(aAllZero); aListMask.push_back(aAllOne);
    
    aListNoise.push_back(aRandA); aListNoise.push_back(aRandB); aListNoise.push_back(aRandC); aListNoise.push_back(aRandD);
    aListNoise.push_back(aRandE); aListNoise.push_back(aRandF); aListNoise.push_back(aRandG); aListNoise.push_back(aRandH);
    aListNoise.push_back(aAllZero); aListNoise.push_back(aAllOne);
    
    static CipherGauntlet aGauntlet;
    
    for (std::size_t aIndexA=0; aIndexA<aListMask.size(); aIndexA++) {
        std::uint8_t *aMask = aListMask[aIndexA];
        for (std::size_t aIndexB=0; aIndexB<aListNoise.size(); aIndexB++) {
            std::uint8_t *aNoise = aListNoise[aIndexB];
            PepperNoiseXORCipher aCipher(aMask,
                                         aNoise);
            if (!aGauntlet.RunCipher(&aCipher,
                                     16,
                                     "PepperNoiseXORCipher")) {
                XCTFail("[PepperNoiseXORCipher] test_gauntlet_PepperNoiseXORCipher failed.");
                return;
            }
        }
    }
}

- (void)test_fixed_16_A_PepperNoiseXORCipher {

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
    // bit0 11110101  10011001
    // bit1 10101001  01001001
    // bit2 01100010  10011001
    // bit3 01111010  11011100
    // bit4 00100111  10101101
    // bit5 10011011  00001100
    // bit6 00000101  10111011
    // bit7 00001101  11010100
    //
    // Avalanche:
    // bit0 XXXX.X.X  X..XX..X
    // bit1 X.X.X..X  .X..X..X
    // bit2 .XX...X.  X..XX..X
    // bit3 .XXXX.X.  XX.XXX..
    // bit4 ..X..XXX  X.X.XX.X
    // bit5 X..XX.XX  ....XX..
    // bit6 .....X.X  X.XXX.XX
    // bit7 ....XX.X  XX.X.X..
    // Avalanche: 50.78%

    const std::uint8_t aOriginal[16] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aMaskBuffer[16] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aNoiseBuffer[16] = {
        0xC4, 0xB0, 0xF8, 0x94, 0x55, 0x8B, 0x3C, 0xCF, 0xBB, 0x51, 0x0A, 0xB3, 0xFE, 0x1D, 0x02, 0xEA
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[16] = {
        0xC4, 0xB0, 0xF8, 0x94, 0x55, 0x8B, 0x3C, 0xCF, 0xBB, 0x51, 0x0A, 0xB3, 0xFE, 0x1D, 0x02, 0xEA
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_A_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_A_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_A_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_A_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_A_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_A_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_B_PepperNoiseXORCipher {

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
    // bit0 11100001  10100011
    // bit1 11000010  00011110
    // bit2 10001111  10001111
    // bit3 01110000  11001000
    // bit4 00000000  00101011
    // bit5 01000001  01001101
    // bit6 11000111  10001100
    // bit7 01001111  10001000
    //
    // Avalanche:
    // bit0 ...XXXX.  .X.XXX..
    // bit1 ..XXXX.X  XXX....X
    // bit2 .XXX....  .XXX....
    // bit3 X...XXXX  ..XX.XXX
    // bit4 XXXXXXXX  XX.X.X..
    // bit5 X.XXXXX.  X.XX..X.
    // bit6 ..XXX...  .XXX..XX
    // bit7 X.XX....  .XXX.XXX
    // Avalanche: 56.25%

    const std::uint8_t aOriginal[16] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aNoiseBuffer[16] = {
        0xE2, 0xD7, 0x90, 0x10, 0x21, 0x23, 0x63, 0xA7, 0xB3, 0x14, 0x88, 0x40, 0x7F, 0x66, 0xE8, 0xAC
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[16] = {
        0xE2, 0xD7, 0x90, 0x10, 0x21, 0x23, 0x63, 0xA7, 0xB3, 0x14, 0x88, 0x40, 0x7F, 0x66, 0xE8, 0xAC
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_B_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_B_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_B_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_B_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_B_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_B_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_C_PepperNoiseXORCipher {

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
    // bit0 10000011  10101110
    // bit1 01111000  11001001
    // bit2 01101011  11100010
    // bit3 00011111  10001000
    // bit4 01111111  00010001
    // bit5 11010110  00011100
    // bit6 00000111  00100101
    // bit7 10000101  00100111
    //
    // Avalanche:
    // bit0 ..X.X..X  .....X..
    // bit1 XX.X..X.  .XX...XX
    // bit2 XX.....X  .X..X...
    // bit3 X.XX.X.X  ..X...X.
    // bit4 ..X.X.X.  .X...X..
    // bit5 X.....XX  .X..X..X
    // bit6 .X.X..X.  .XXX....
    // bit7 XX.X....  .XXX..X.
    // Avalanche: 37.50%

    const std::uint8_t aOriginal[16] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aNoiseBuffer[16] = {
        0x85, 0x6C, 0x68, 0x5C, 0x78, 0x1F, 0xBE, 0xBB, 0xF0, 0x60, 0xA3, 0x0C, 0xD4, 0x87, 0xA1, 0x4B
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[16] = {
        0x85, 0x6C, 0x68, 0x5C, 0x78, 0x1F, 0xBE, 0xBB, 0xF0, 0x60, 0xA3, 0x0C, 0xD4, 0x87, 0xA1, 0x4B
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_C_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_C_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_C_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_C_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_C_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_C_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_D_PepperNoiseXORCipher {

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
    // bit0 01011011  01100000
    // bit1 00000011  10110100
    // bit2 00100111  01001001
    // bit3 10101011  01010110
    // bit4 11011011  00100100
    // bit5 01000100  01001001
    // bit6 10011010  01010101
    // bit7 01000111  11010000
    //
    // Avalanche:
    // bit0 XXXX...X  XX..X.X.
    // bit1 X.X.X..X  ...XXXX.
    // bit2 .XXX..X.  ...XXX..
    // bit3 XXXXXXX.  ......XX
    // bit4 .XXX...X  X...XXX.
    // bit5 XXX.XXX.  XXX...XX
    // bit6 XX..XXXX  ........
    // bit7 ...X..X.  X....X.X
    // Avalanche: 49.22%

    const std::uint8_t aOriginal[16] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aNoiseBuffer[16] = {
        0x1A, 0x8D, 0x30, 0x8A, 0x9A, 0x25, 0xFB, 0xF9, 0x41, 0xB7, 0xC8, 0x53, 0x24, 0x5A, 0x10, 0x26
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[16] = {
        0x1A, 0x8D, 0x30, 0x8A, 0x9A, 0x25, 0xFB, 0xF9, 0x41, 0xB7, 0xC8, 0x53, 0x24, 0x5A, 0x10, 0x26
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_D_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_D_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_D_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_D_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_D_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_D_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_E_PepperNoiseXORCipher {

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
    // bit0 01001000  00010011
    // bit1 01111110  01011001
    // bit2 01101110  10000110
    // bit3 00001100  01000010
    // bit4 10110101  11100100
    // bit5 11010110  10110001
    // bit6 01101001  11011010
    // bit7 10010010  10001011
    //
    // Avalanche:
    // bit0 XXX...X.  X.XXX..X
    // bit1 XX.X.X..  XXXX..XX
    // bit2 ..XXX.XX  XX.X..XX
    // bit3 .X.XX..X  ...X.XXX
    // bit4 XXX.....  X.XX...X
    // bit5 X.....XX  XXX..X..
    // bit6 XX....XX  .XXX....
    // bit7 ..XXX...  ..X....X
    // Avalanche: 49.22%

    const std::uint8_t aOriginal[16] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aNoiseBuffer[16] = {
        0x0D, 0xE6, 0x6A, 0x4D, 0xF2, 0x7C, 0x65, 0x0A, 0x2F, 0x5A, 0x0C, 0xC6, 0x43, 0x28, 0xB3, 0xC5
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[16] = {
        0x0D, 0xE6, 0x6A, 0x4D, 0xF2, 0x7C, 0x65, 0x0A, 0x2F, 0x5A, 0x0C, 0xC6, 0x43, 0x28, 0xB3, 0xC5
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_E_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_E_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_E_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_E_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_E_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_E_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_F_PepperNoiseXORCipher {

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
    // bit0 00101001  00110000
    // bit1 10101101  11111110
    // bit2 00001111  10111001
    // bit3 00101010  01011001
    // bit4 10010001  00111000
    // bit5 01100011  00000000
    // bit6 11001101  10000100
    // bit7 10110000  10000000
    //
    // Avalanche:
    // bit0 X.....XX  X..XX.X.
    // bit1 XXXXX...  X.X.X.XX
    // bit2 X.X..X.X  ...X..XX
    // bit3 .XXXXXXX  ....XX..
    // bit4 ..XXX.XX  X..X..X.
    // bit5 ..XX.XX.  .X.X.X.X
    // bit6 .XX..XXX  ..X.XXX.
    // bit7 XXX..X.X  XX.X.X.X
    // Avalanche: 53.12%

    const std::uint8_t aOriginal[16] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aNoiseBuffer[16] = {
        0x4B, 0x06, 0xD5, 0x09, 0xF2, 0x62, 0x34, 0xEE, 0x63, 0x50, 0xE8, 0xF8, 0x78, 0x42, 0x40, 0x30
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[16] = {
        0x4B, 0x06, 0xD5, 0x09, 0xF2, 0x62, 0x34, 0xEE, 0x63, 0x50, 0xE8, 0xF8, 0x78, 0x42, 0x40, 0x30
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_F_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_F_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_F_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_F_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_F_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_F_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_G_PepperNoiseXORCipher {

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
    // bit0 00001000  10001111
    // bit1 11100010  11101001
    // bit2 11001000  11111010
    // bit3 11001110  00000100
    // bit4 11111010  01010101
    // bit5 10101010  01101101
    // bit6 11111110  00110111
    // bit7 10010011  11100110
    //
    // Avalanche:
    // bit0 X.X...X.  ..X..X.X
    // bit1 .X..X.XX  .X....XX
    // bit2 .X.XXXX.  .X.XXXXX
    // bit3 .X.XX.XX  X.X....X
    // bit4 X..XXX..  XX..XX..
    // bit5 XX..XXXX  XXXX.X..
    // bit6 X.X..X..  X.X....X
    // bit7 XX..X.X.  .XXX....
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[16] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C
    };

    const std::uint8_t aNoiseBuffer[16] = {
        0x7F, 0x7A, 0x4E, 0x0B, 0xBE, 0x12, 0x5F, 0x01, 0xE1, 0x6D, 0x67, 0x2A, 0xE4, 0x9F, 0xA3, 0xCE
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[16] = {
        0x7F, 0x7A, 0x4E, 0x0B, 0xBE, 0x12, 0x5F, 0x01, 0xE1, 0x6D, 0x67, 0x2A, 0xE4, 0x9F, 0xA3, 0xCE
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_G_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_G_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_G_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_G_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_G_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_G_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_H_PepperNoiseXORCipher {

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
    // bit0 11111000  01010011
    // bit1 00110000  00100101
    // bit2 00101011  00110111
    // bit3 10101000  00111000
    // bit4 11000010  01011010
    // bit5 01001001  11100101
    // bit6 10101010  00110011
    // bit7 10010101  01011000
    //
    // Avalanche:
    // bit0 X.X.XX.X  .....XX.
    // bit1 .X.X.X.X  .XXXXX..
    // bit2 .XXX...X  .XX....X
    // bit3 XX....X.  .XX...X.
    // bit4 X..XX.XX  XX..XX..
    // bit5 ..X.....  .XXXXXXX
    // bit6 XXXXXX..  X.X..XX.
    // bit7 XXXX..XX  XX.....X
    // Avalanche: 50.78%

    const std::uint8_t aOriginal[16] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3
    };

    const std::uint8_t aMaskBuffer[16] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3
    };

    const std::uint8_t aNoiseBuffer[16] = {
        0x9B, 0x8C, 0xF2, 0xC1, 0xB6, 0x01, 0x2A, 0x25, 0x04, 0x8D, 0x76, 0xBB, 0x19, 0x64, 0xAA, 0xE6
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[16] = {
        0x9B, 0x8C, 0xF2, 0xC1, 0xB6, 0x01, 0x2A, 0x25, 0x04, 0x8D, 0x76, 0xBB, 0x19, 0x64, 0xAA, 0xE6
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_H_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_H_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_H_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_H_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_H_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_H_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_I_PepperNoiseXORCipher {

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
    // bit0 01101111  00111000
    // bit1 00101111  11110000
    // bit2 00001011  11000111
    // bit3 10101111  01101110
    // bit4 00010000  10011110
    // bit5 01001110  01111010
    // bit6 01100000  01000101
    // bit7 01110011  01100000
    //
    // Avalanche:
    // bit0 XX...X.X  X..X..X.
    // bit1 X.X..X.X  ...X..X.
    // bit2 XXX.XX.X  XXXXXXX.
    // bit3 .XX.X..X  ...XXXXX
    // bit4 ..XXXXXX  X..X.X.X
    // bit5 .X.....X  ..XXX..X
    // bit6 ......XX  XX.XXX.X
    // bit7 ..XX....  X.XX....
    // Avalanche: 50.00%

    const std::uint8_t aOriginal[16] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C
    };

    const std::uint8_t aNoiseBuffer[16] = {
        0x10, 0x87, 0xD3, 0x09, 0xF4, 0xD4, 0xF5, 0xF1, 0x68, 0x77, 0xD5, 0xCC, 0x9C, 0x3A, 0x3C, 0x22
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[16] = {
        0x10, 0x87, 0xD3, 0x09, 0xF4, 0xD4, 0xF5, 0xF1, 0x68, 0x77, 0xD5, 0xCC, 0x9C, 0x3A, 0x3C, 0x22
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_I_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_I_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_I_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_I_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_I_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_I_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_J_PepperNoiseXORCipher {

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
    // bit0 00100011  11011100
    // bit1 01110010  11000101
    // bit2 10111000  00101010
    // bit3 10101100  10011011
    // bit4 00110000  01101011
    // bit5 00000000  01010010
    // bit6 11000001  00000000
    // bit7 01110010  10000111
    //
    // Avalanche:
    // bit0 X...X..X  .XXX.XX.
    // bit1 X...XX.X  ..XXX.X.
    // bit2 X.XXX...  ..X.X.X.
    // bit3 XXXXX..X  XX..XXX.
    // bit4 X..XX.X.  XX.....X
    // bit5 XXXXXXXX  X.X.XX.X
    // bit6 XX.....X  ........
    // bit7 ..X..XXX  XX.X..X.
    // Avalanche: 50.78%

    const std::uint8_t aOriginal[16] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    const std::uint8_t aNoiseBuffer[16] = {
        0x32, 0x43, 0xF9, 0x69, 0x30, 0x10, 0xC1, 0x82, 0xD1, 0xCC, 0x28, 0x94, 0xB8, 0xC1, 0x3D, 0x59
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[16] = {
        0x32, 0x43, 0xF9, 0x69, 0x30, 0x10, 0xC1, 0x82, 0xD1, 0xCC, 0x28, 0x94, 0xB8, 0xC1, 0x3D, 0x59
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_J_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_J_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_J_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_J_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_J_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_J_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_K_PepperNoiseXORCipher {

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
    // bit0 10101101  10110000
    // bit1 00100110  11110010
    // bit2 01010011  00001100
    // bit3 10111011  01101001
    // bit4 11101100  01101011
    // bit5 11110110  00000101
    // bit6 01000010  10110000
    // bit7 00100101  00101111
    //
    // Avalanche:
    // bit0 .....XXX  ...XX.X.
    // bit1 X...XX..  .X.XX...
    // bit2 XXXXX..X  .X.XX..X
    // bit3 ...X...X  ..XXXX..
    // bit4 X.XXX..X  XX.....X
    // bit5 X.X...XX  X.X.XXXX
    // bit6 ...X.XXX  XXX..X.X
    // bit7 .XXX....  .XXXX.X.
    // Avalanche: 49.22%

    const std::uint8_t aOriginal[16] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aNoiseBuffer[16] = {
        0x9C, 0x2E, 0xDD, 0x34, 0x98, 0xCD, 0x76, 0xB1, 0xC2, 0x58, 0xDB, 0xC2, 0x39, 0x25, 0x49, 0x1D
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[16] = {
        0x9C, 0x2E, 0xDD, 0x34, 0x98, 0xCD, 0x76, 0xB1, 0xC2, 0x58, 0xDB, 0xC2, 0x39, 0x25, 0x49, 0x1D
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_K_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_K_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_K_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_K_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_K_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_K_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_L_PepperNoiseXORCipher {

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
    // bit0 11101110  10111101
    // bit1 01001011  10010110
    // bit2 10100001  00100011
    // bit3 00110000  10011100
    // bit4 11110000  01000010
    // bit5 00110001  01000011
    // bit6 10010010  10010100
    // bit7 00101110  11100101
    //
    // Avalanche:
    // bit0 .XX.X.XX  .X.X.X.X
    // bit1 XX..XXX.  XX....XX
    // bit2 ....X.XX  X...X.XX
    // bit3 X..XX.X.  X...X..X
    // bit4 X.X.....  XXX.X.X.
    // bit5 .XX....X  .X.X.XX.
    // bit6 XXX.XX.X  .XXXXX..
    // bit7 .X.X...X  X.XX....
    // Avalanche: 49.22%

    const std::uint8_t aOriginal[16] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55
    };

    const std::uint8_t aMaskBuffer[16] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55
    };

    const std::uint8_t aNoiseBuffer[16] = {
        0xAA, 0xC8, 0xBD, 0x1E, 0xC1, 0x81, 0xC3, 0x64, 0xD3, 0x0D, 0xA1, 0xD2, 0x90, 0xD3, 0x6C, 0xA5
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[16] = {
        0xAA, 0xC8, 0xBD, 0x1E, 0xC1, 0x81, 0xC3, 0x64, 0xD3, 0x0D, 0xA1, 0xD2, 0x90, 0xD3, 0x6C, 0xA5
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_16_L_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_L_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_L_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_L_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_L_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_16_L_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_A_PepperNoiseXORCipher {

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
    // bit0 10011010  10001011  10000101  11111000
    // bit1 01011001  00000101  00000110  11110100
    // bit2 10000000  10111010  11011100  11011001
    // bit3 11010101  10000100  10001111  01100100
    // bit4 01000100  11100100  10110010  10101111
    // bit5 00101010  00001001  00010000  01000010
    // bit6 11010010  10111110  00101001  10101001
    // bit7 01100100  10110101  01101110  00100100
    //
    // Avalanche:
    // bit0 X..XX.X.  X...X.XX  X....X.X  XXXXX...
    // bit1 .X.XX..X  .....X.X  .....XX.  XXXX.X..
    // bit2 X.......  X.XXX.X.  XX.XXX..  XX.XX..X
    // bit3 XX.X.X.X  X....X..  X...XXXX  .XX..X..
    // bit4 .X...X..  XXX..X..  X.XX..X.  X.X.XXXX
    // bit5 ..X.X.X.  ....X..X  ...X....  .X....X.
    // bit6 XX.X..X.  X.XXXXX.  ..X.X..X  X.X.X..X
    // bit7 .XX..X..  X.XX.X.X  .XX.XXX.  ..X..X..
    // Avalanche: 45.31%

    const std::uint8_t aOriginal[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aMaskBuffer[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    };

    const std::uint8_t aNoiseBuffer[32] = {
        0xB2, 0x5B, 0x05, 0xD2, 0xC4, 0x19, 0x86, 0x50, 0xBB, 0x08, 0x2B, 0x23, 0xA6, 0x5B, 0xA2, 0xC5,
        0xB8, 0x21, 0x0B, 0x2C, 0x33, 0xF1, 0x59, 0x92, 0xEA, 0xF4, 0xDB, 0xE0, 0xAA, 0x59, 0x0C, 0x2A
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[32] = {
        0xB2, 0x5B, 0x05, 0xD2, 0xC4, 0x19, 0x86, 0x50, 0xBB, 0x08, 0x2B, 0x23, 0xA6, 0x5B, 0xA2, 0xC5,
        0xB8, 0x21, 0x0B, 0x2C, 0x33, 0xF1, 0x59, 0x92, 0xEA, 0xF4, 0xDB, 0xE0, 0xAA, 0x59, 0x0C, 0x2A
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_A_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_A_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_A_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_A_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_A_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_A_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_B_PepperNoiseXORCipher {

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
    // bit0 10001111  00100000  10010010  00000010
    // bit1 01111100  11011001  10011111  00100101
    // bit2 11110011  10111010  10011111  00101100
    // bit3 11001110  11000111  11100000  11010010
    // bit4 00000010  00001111  11010010  01101101
    // bit5 11100011  10100000  00111011  00010011
    // bit6 11111001  10011011  01011111  11011011
    // bit7 11110001  01101011  10000001  11111111
    //
    // Avalanche:
    // bit0 .XXX....  XX.XXXXX  .XX.XX.X  XXXXXX.X
    // bit1 X.....XX  ..X..XX.  .XX.....  XX.XX.X.
    // bit2 ....XX..  .X...X.X  .XX.....  XX.X..XX
    // bit3 ..XX...X  ..XXX...  ...XXXXX  ..X.XX.X
    // bit4 XXXXXX.X  XXXX....  ..X.XX.X  X..X..X.
    // bit5 ...XXX..  .X.XXXXX  XX...X..  XXX.XX..
    // bit6 .....XX.  .XX..X..  X.X.....  ..X..X..
    // bit7 ....XXX.  X..X.X..  .XXXXXX.  ........
    // Avalanche: 46.09%

    const std::uint8_t aOriginal[32] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
    };

    const std::uint8_t aNoiseBuffer[32] = {
        0xB7, 0x77, 0x67, 0x63, 0xD2, 0xD0, 0xBC, 0xA7, 0x76, 0x51, 0xA5, 0x62, 0x6B, 0x18, 0x3B, 0x5B,
        0xF9, 0x1A, 0x14, 0xEE, 0x66, 0x62, 0xEE, 0x67, 0x13, 0x1B, 0x69, 0x17, 0x2B, 0x69, 0x97, 0x4F
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[32] = {
        0xB7, 0x77, 0x67, 0x63, 0xD2, 0xD0, 0xBC, 0xA7, 0x76, 0x51, 0xA5, 0x62, 0x6B, 0x18, 0x3B, 0x5B,
        0xF9, 0x1A, 0x14, 0xEE, 0x66, 0x62, 0xEE, 0x67, 0x13, 0x1B, 0x69, 0x17, 0x2B, 0x69, 0x97, 0x4F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_B_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_B_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_B_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_B_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_B_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_B_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_C_PepperNoiseXORCipher {

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
    // bit0 00100100  00111000  11111110  01001001
    // bit1 01010010  01011001  00111110  00010101
    // bit2 10011100  01101001  01001110  00011010
    // bit3 01111111  00010110  11010100  11010011
    // bit4 01111101  10001001  11011001  11101100
    // bit5 11010111  01111111  01011111  11011111
    // bit6 10101000  01001111  00111110  01101010
    // bit7 10110111  01011000  10100101  01101011
    //
    // Avalanche:
    // bit0 X...XXX.  X..X..X.  .X.X.X..  XXX...XX
    // bit1 XXXXX...  XXXX..XX  X..X.X..  X.XXXXXX
    // bit2 ..XX.XX.  XX....XX  XXX..X..  X.XX....
    // bit3 XX.X.X.X  X.XXXX..  .XXXXXX.  .XXXX..X
    // bit4 ..X.X...  XX.XXX..  X...XX..  X.XXX..X
    // bit5 X.....X.  ..X.X.X.  ....X.X.  X...X.X.
    // bit6 XXXXXX.X  ...XX.X.  .XX.X.XX  ..XXXXXX
    // bit7 XXX...X.  ....XX.X  XXXX....  ..XXXXX.
    // Avalanche: 52.34%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F,
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F
    };

    const std::uint8_t aNoiseBuffer[32] = {
        0x27, 0x5C, 0x9B, 0x7D, 0x3A, 0xBD, 0x55, 0x1D, 0x08, 0x67, 0xA4, 0xD5, 0xEF, 0x16, 0x16, 0x6E,
        0x99, 0xBC, 0xC3, 0xDE, 0xEE, 0xF7, 0xE6, 0x0D, 0x1C, 0x9F, 0x0B, 0x74, 0xAF, 0x4C, 0x37, 0xD5
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[32] = {
        0x27, 0x5C, 0x9B, 0x7D, 0x3A, 0xBD, 0x55, 0x1D, 0x08, 0x67, 0xA4, 0xD5, 0xEF, 0x16, 0x16, 0x6E,
        0x99, 0xBC, 0xC3, 0xDE, 0xEE, 0xF7, 0xE6, 0x0D, 0x1C, 0x9F, 0x0B, 0x74, 0xAF, 0x4C, 0x37, 0xD5
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_C_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_C_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_C_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_C_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_C_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_C_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_D_PepperNoiseXORCipher {

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
    // bit0 01000101  00001110  00010011  01000111
    // bit1 00000110  11011100  10011000  11101010
    // bit2 11001110  11110100  00011000  00001111
    // bit3 11100111  01000111  01001111  11100111
    // bit4 11010000  01000001  10111000  01000101
    // bit5 00110010  10011100  00011101  11010111
    // bit6 11101111  11100000  01000001  11001001
    // bit7 00110101  00011011  11111111  00000000
    //
    // Avalanche:
    // bit0 XXX.XXXX  X.X..X..  X.XXX..X  XXX.XX.X
    // bit1 X.X.XX..  .XXX.XX.  ..XX..X.  .X......
    // bit2 X..XX.XX  X.X....X  .X..XX.X  .X.XX.X.
    // bit3 X.XX..X.  ...X..X.  ...XX.X.  X.XX..X.
    // bit4 .XXXX.X.  XXX.X.XX  ...X..X.  XXX.XXXX
    // bit5 X..XX...  ..XX.XX.  X.XX.XXX  .XXXXX.X
    // bit6 X.XXX.X.  X.XX.X.X  ...X.X..  X..XXX..
    // bit7 .XX.....  .X..XXX.  X.X.X.X.  .X.X.X.X
    // Avalanche: 51.56%

    const std::uint8_t aOriginal[32] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33
    };

    const std::uint8_t aNoiseBuffer[32] = {
        0x3A, 0xBA, 0x17, 0x0D, 0x22, 0xF3, 0x76, 0x93, 0x66, 0x7A, 0x22, 0x65, 0xC5, 0xF4, 0x91, 0x19,
        0x49, 0x13, 0x09, 0xED, 0x7D, 0x15, 0x91, 0x97, 0x56, 0xDE, 0x50, 0x04, 0x62, 0xBC, 0xF4, 0xBE
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[32] = {
        0x3A, 0xBA, 0x17, 0x0D, 0x22, 0xF3, 0x76, 0x93, 0x66, 0x7A, 0x22, 0x65, 0xC5, 0xF4, 0x91, 0x19,
        0x49, 0x13, 0x09, 0xED, 0x7D, 0x15, 0x91, 0x97, 0x56, 0xDE, 0x50, 0x04, 0x62, 0xBC, 0xF4, 0xBE
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_D_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_D_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_D_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_D_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_D_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_D_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_E_PepperNoiseXORCipher {

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
    // bit0 01101011  10001100  11011000  11011100
    // bit1 11000101  00001101  01001011  11110100
    // bit2 00110100  10101110  01101110  11010111
    // bit3 01000100  01111101  10011100  10111100
    // bit4 01010101  10110111  01011000  00110100
    // bit5 00001100  00111111  01001001  10101101
    // bit6 01010011  11100011  10110110  11100010
    // bit7 00000110  01110011  00011110  10101001
    //
    // Avalanche:
    // bit0 XX.....X  ..X..XX.  .XXX..X.  .XXX.XX.
    // bit1 .XX.XXXX  X.X..XXX  XXX....X  .X.XXXX.
    // bit2 .XX....X  XXXXX.XX  ..XXX.XX  X.....X.
    // bit3 ...X...X  ..X.X...  XX..X..X  XXX.X..X
    // bit4 ........  XXX...X.  ....XX.X  .XX....X
    // bit5 .X.XX..X  .XX.X.X.  ...XXX..  XXXXX...
    // bit6 XXXXX..X  .X..X..X  ...XXX..  .X..X...
    // bit7 X.X.XX..  XX.XX..X  X.XX.X..  ......XX
    // Avalanche: 46.88%

    const std::uint8_t aOriginal[32] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C
    };

    const std::uint8_t aNoiseBuffer[32] = {
        0x40, 0xDA, 0xA0, 0x2A, 0x84, 0x7D, 0x83, 0xCA, 0xAA, 0x13, 0x3F, 0x1D, 0xF4, 0xFC, 0x2F, 0x5F,
        0x92, 0xEC, 0x22, 0x9B, 0xFD, 0x33, 0x63, 0x44, 0xF7, 0xE2, 0x5F, 0xF8, 0x95, 0xFC, 0x22, 0x25
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[32] = {
        0x40, 0xDA, 0xA0, 0x2A, 0x84, 0x7D, 0x83, 0xCA, 0xAA, 0x13, 0x3F, 0x1D, 0xF4, 0xFC, 0x2F, 0x5F,
        0x92, 0xEC, 0x22, 0x9B, 0xFD, 0x33, 0x63, 0x44, 0xF7, 0xE2, 0x5F, 0xF8, 0x95, 0xFC, 0x22, 0x25
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_E_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_E_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_E_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_E_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_E_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_E_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_F_PepperNoiseXORCipher {

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
    // bit0 01100001  10011101  11011001  01110001
    // bit1 10000011  11011001  11110110  00001111
    // bit2 00110001  00111010  01100111  01011010
    // bit3 11010011  10011011  00000000  11000101
    // bit4 00011001  01001111  01011110  11100000
    // bit5 00111010  01111111  01100001  00100110
    // bit6 00001101  00011110  10000011  01001000
    // bit7 01110110  11100011  00100100  00111100
    //
    // Avalanche:
    // bit0 XX..X.XX  ..XX.XXX  .XXX..XX  XX.XX.XX
    // bit1 XX.X.XX.  X...XX..  X.X...XX  .X.XX.X.
    // bit2 X..XX.XX  X..X....  XX..XX.X  XXXX....
    // bit3 X....XX.  XX..XXX.  .X.X.X.X  X..X....
    // bit4 X.XX..XX  XXX..X.X  XXXX.X..  .X..X.X.
    // bit5 .XX.XXXX  ..X.X.X.  ..XX.X..  .XXX..XX
    // bit6 X.X..XXX  X.XX.X..  ..X.X..X  XXX...X.
    // bit7 ..X...XX  X.XX.XX.  .XXX...X  .XX.X..X
    // Avalanche: 52.34%

    const std::uint8_t aOriginal[32] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55,
        0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aNoiseBuffer[32] = {
        0x50, 0x91, 0xA5, 0x3D, 0x0E, 0x03, 0x55, 0xFA, 0xD1, 0x4D, 0x25, 0xF6, 0xFE, 0x8E, 0x3F, 0xDD,
        0xC2, 0xEC, 0x65, 0xC8, 0x88, 0x69, 0x6A, 0xA6, 0x18, 0xBA, 0x8D, 0xA1, 0x63, 0x55, 0x64, 0xD0
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[32] = {
        0x50, 0x91, 0xA5, 0x3D, 0x0E, 0x03, 0x55, 0xFA, 0xD1, 0x4D, 0x25, 0xF6, 0xFE, 0x8E, 0x3F, 0xDD,
        0xC2, 0xEC, 0x65, 0xC8, 0x88, 0x69, 0x6A, 0xA6, 0x18, 0xBA, 0x8D, 0xA1, 0x63, 0x55, 0x64, 0xD0
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_F_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_F_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_F_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_F_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_F_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_F_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_G_PepperNoiseXORCipher {

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
    // bit0 01101010  01101000  00100110  11100001
    // bit1 10001100  00111101  01110010  10001111
    // bit2 11110001  10001101  11011001  11110100
    // bit3 10000111  01101100  11000011  10111100
    // bit4 11101111  11111100  11010111  00110001
    // bit5 11101000  01110011  00110100  11101110
    // bit6 10010011  11111001  00100011  01110101
    // bit7 00110010  01011001  00010100  01101101
    //
    // Avalanche:
    // bit0 XX......  XX....X.  X...XX..  .X..X.XX
    // bit1 ..X..X.X  X..X.XXX  ...XX...  ...X.X.X
    // bit2 .XX..XXX  ..X.X...  .XXX....  X..XXXX.
    // bit3 ...X..X.  XX..X..X  X.X.X.X.  XXX..XX.
    // bit4 X...X..X  .XX..X.X  .XXX...X  .X.XX...
    // bit5 X...XX.X  XXX.X.X.  .X.X..X.  X.XX.XXX
    // bit6 XX..X..X  .XX.XXXX  X....XX.  XX.XXX..
    // bit7 .XX.X.XX  XX..XXXX  .XXX...X  XXXX.X..
    // Avalanche: 48.83%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C,
        0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F, 0xCC, 0x33, 0xC3, 0x3C, 0xAA, 0x55, 0xFF, 0x00, 0xF0, 0x0F
    };

    const std::uint8_t aNoiseBuffer[32] = {
        0x7E, 0xAC, 0xAD, 0x23, 0xCC, 0x58, 0x9B, 0x3A, 0x2A, 0x9F, 0xDE, 0x4F, 0xFB, 0x78, 0x04, 0x67,
        0x38, 0x78, 0xC6, 0x6D, 0x20, 0x8D, 0xDA, 0x3A, 0xF4, 0xA7, 0xBF, 0x3A, 0x55, 0x77, 0x44, 0xCB
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[32] = {
        0x7E, 0xAC, 0xAD, 0x23, 0xCC, 0x58, 0x9B, 0x3A, 0x2A, 0x9F, 0xDE, 0x4F, 0xFB, 0x78, 0x04, 0x67,
        0x38, 0x78, 0xC6, 0x6D, 0x20, 0x8D, 0xDA, 0x3A, 0xF4, 0xA7, 0xBF, 0x3A, 0x55, 0x77, 0x44, 0xCB
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_G_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_G_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_G_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_G_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_G_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_G_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_H_PepperNoiseXORCipher {

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
    // bit0 11101010  10101011  11100011  01001100
    // bit1 11001110  10101011  11100110  01000101
    // bit2 10000010  10110011  10100110  10111110
    // bit3 10000101  00101100  01011001  11101010
    // bit4 11001000  10101100  00010000  11101011
    // bit5 01100011  00001111  11101110  01100101
    // bit6 11111001  10100101  00101100  11011001
    // bit7 10011011  11010011  01100110  01001111
    //
    // Avalanche:
    // bit0 X.XXXXXX  XXXXXXX.  X.XX.XX.  ...XX..X
    // bit1 X.X.X.XX  XXXX..X.  X.XX....  ...X....
    // bit2 XX.XX...  XXX..X.X  ..XX..XX  ...XX.XX
    // bit3 XXX.XXXX  .XXX.XX.  XX..XXXX  .X..XXXX
    // bit4 X..X...X  ..XXX.X.  .XXX.X.X  .XXX..X.
    // bit5 ....X.X.  X..X.X.X  X...X...  XXXXXX..
    // bit6 X.X.XXXX  ..XX....  X...X..X  X.XX....
    // bit7 XXXXXX.X  .X..X.X.  XX......  ..X..XX.
    // Avalanche: 52.73%

    const std::uint8_t aOriginal[32] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF
    };

    const std::uint8_t aMaskBuffer[32] = {
        0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3,
        0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF, 0x55, 0xAA, 0x3C, 0xC3, 0x33, 0xCC, 0x0F, 0xF0, 0x00, 0xFF
    };

    const std::uint8_t aNoiseBuffer[32] = {
        0xFB, 0xCE, 0x86, 0x03, 0xCB, 0x50, 0xE5, 0x17, 0xEB, 0x01, 0xFA, 0x21, 0xDC, 0x1E, 0xE5, 0xE7,
        0xE4, 0xD5, 0xE7, 0x18, 0x16, 0x67, 0xE5, 0x90, 0x3A, 0xDF, 0x3C, 0x22, 0xBB, 0xE5, 0x39, 0x4F
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[32] = {
        0xFB, 0xCE, 0x86, 0x03, 0xCB, 0x50, 0xE5, 0x17, 0xEB, 0x01, 0xFA, 0x21, 0xDC, 0x1E, 0xE5, 0xE7,
        0xE4, 0xD5, 0xE7, 0x18, 0x16, 0x67, 0xE5, 0x90, 0x3A, 0xDF, 0x3C, 0x22, 0xBB, 0xE5, 0x39, 0x4F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_H_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_H_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_H_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_H_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_H_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_H_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_I_PepperNoiseXORCipher {

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
    // bit0 00111101  01101000  11011100  10000110
    // bit1 11010010  00011101  00101000  10011010
    // bit2 00101101  01011111  00111000  11000001
    // bit3 00110010  00111100  01101111  11100110
    // bit4 00110101  01111011  10100111  11001110
    // bit5 00100101  10011010  01110101  01110101
    // bit6 00000001  00101110  10101011  00000100
    // bit7 10100010  10100111  10011011  11101001
    //
    // Avalanche:
    // bit0 X..X.XXX  XX....X.  .XXX.XX.  ..X.XX..
    // bit1 .X.XX...  XXXXXXXX  X..X....  ..XX.X..
    // bit2 XX..X.XX  .XX..XX.  X.XX.XX.  X.X...X.
    // bit3 XXXX.X..  .X..XX.X  XXXX..XX  X......X
    // bit4 ...XX.X.  .XXX....  .XX..X.X  ..XXXXX.
    // bit5 ..X.X.X.  XX.XX..X  X.X..X.X  X......X
    // bit6 .XX...X.  X.XX.XX.  .X..XX.X  ..XXXX.X
    // bit7 XXX....X  .XXX.XXX  .XX.XXXX  XX.X.X..
    // Avalanche: 51.56%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C,
        0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33, 0xAA, 0x00, 0xCC, 0x3C, 0xFF, 0x0F, 0xC3, 0x55, 0xF0, 0x33
    };

    const std::uint8_t aNoiseBuffer[32] = {
        0x41, 0x40, 0xBD, 0xD8, 0xA0, 0xAC, 0x51, 0xAE, 0x05, 0xA8, 0x9B, 0x7C, 0xFE, 0x73, 0x2F, 0x69,
        0x8B, 0x94, 0x7E, 0xA5, 0xF3, 0x9C, 0x1B, 0x1F, 0xF9, 0x3D, 0x15, 0x44, 0x49, 0x9E, 0xD8, 0x25
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[32] = {
        0x41, 0x40, 0xBD, 0xD8, 0xA0, 0xAC, 0x51, 0xAE, 0x05, 0xA8, 0x9B, 0x7C, 0xFE, 0x73, 0x2F, 0x69,
        0x8B, 0x94, 0x7E, 0xA5, 0xF3, 0x9C, 0x1B, 0x1F, 0xF9, 0x3D, 0x15, 0x44, 0x49, 0x9E, 0xD8, 0x25
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_I_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_I_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_I_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_I_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_I_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_I_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_J_PepperNoiseXORCipher {

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
    // bit0 10000001  00111101  01101010  00001001
    // bit1 01010110  00001111  00011100  00011010
    // bit2 11110101  00000000  11011010  01101101
    // bit3 11111010  11011100  00000100  01110010
    // bit4 11010110  10111101  00011100  11101010
    // bit5 11011100  00001100  11110001  11111000
    // bit6 01010011  00110011  01110001  11100000
    // bit7 01101100  00000000  10000111  11100111
    //
    // Avalanche:
    // bit0 ..X.X.XX  X..X.XXX  XX......  X.X...XX
    // bit1 X.X.X..X  XXXX....  XXX...XX  XXX..X.X
    // bit2 XXXX.X.X  ........  XX.XX.X.  .XX.XX.X
    // bit3 X.X.XXXX  X...X..X  .X.X...X  ..X..XXX
    // bit4 .XXXXX..  ...X.XXX  X.XX.XX.  .X......
    // bit5 ..X...XX  XXXX..XX  ....XXX.  .....XXX
    // bit6 .X.X..XX  ..XX..XX  .XXX...X  XXX.....
    // bit7 ..XXX..X  .X.X.X.X  XX.X..X.  X.XX..X.
    // Avalanche: 49.22%

    const std::uint8_t aOriginal[32] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55,
        0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55, 0xCC, 0x55
    };

    const std::uint8_t aNoiseBuffer[32] = {
        0xBC, 0x7F, 0x31, 0x7E, 0x15, 0x6D, 0x5A, 0xA2, 0x18, 0x10, 0x8A, 0x9A, 0xDC, 0xDC, 0x42, 0xCA,
        0x25, 0xA6, 0x86, 0x6E, 0xE8, 0x59, 0xA1, 0x07, 0x0F, 0x3F, 0x3F, 0x54, 0xEC, 0x21, 0x59, 0xA1
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[32] = {
        0xBC, 0x7F, 0x31, 0x7E, 0x15, 0x6D, 0x5A, 0xA2, 0x18, 0x10, 0x8A, 0x9A, 0xDC, 0xDC, 0x42, 0xCA,
        0x25, 0xA6, 0x86, 0x6E, 0xE8, 0x59, 0xA1, 0x07, 0x0F, 0x3F, 0x3F, 0x54, 0xEC, 0x21, 0x59, 0xA1
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_J_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_J_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_J_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_J_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_J_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_J_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_K_PepperNoiseXORCipher {

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
    // bit0 10001111  10100000  01111000  00001110
    // bit1 11111011  10001111  00001010  01010110
    // bit2 10010000  11010011  00001010  10000110
    // bit3 01101101  11110010  10001010  10010010
    // bit4 01010110  11011110  00001111  11110000
    // bit5 01000001  11010100  00011100  00111110
    // bit6 01000111  00100011  01110011  00011110
    // bit7 01001101  00000100  01111000  10111100
    //
    // Avalanche:
    // bit0 ..X..X.X  ....X.X.  XX.X..X.  X.X..X..
    // bit1 .X.X...X  ..X..X.X  X.X.....  ......XX
    // bit2 ..XXX.X.  X....XX.  .X.XXXXX  ..X.XX..
    // bit3 XX...XXX  X.X..XXX  XX.XXXXX  XX...XXX
    // bit4 ......XX  .XXX.X..  .X.XX.X.  .X.XX.X.
    // bit5 ...X.X..  .XXXXXX.  .X..X..X  .XX.X.XX
    // bit6 ...X..X.  .XXX.XX.  XX.XX..X  X.XX.X..
    // bit7 ...XX...  .X.X...X  XX.X..X.  XXX.X..X
    // Avalanche: 46.88%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aNoiseBuffer[32] = {
        0xE0, 0x5F, 0x50, 0x68, 0xD1, 0x9B, 0xCA, 0xD7, 0xFC, 0x3C, 0x92, 0x3C, 0x48, 0x4D, 0x7A, 0x62,
        0x10, 0x83, 0x83, 0x87, 0xFD, 0x0C, 0x7A, 0x0A, 0x39, 0x48, 0x0D, 0x5F, 0x87, 0xE7, 0xF6, 0x00
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[32] = {
        0xE0, 0x5F, 0x50, 0x68, 0xD1, 0x9B, 0xCA, 0xD7, 0xFC, 0x3C, 0x92, 0x3C, 0x48, 0x4D, 0x7A, 0x62,
        0x10, 0x83, 0x83, 0x87, 0xFD, 0x0C, 0x7A, 0x0A, 0x39, 0x48, 0x0D, 0x5F, 0x87, 0xE7, 0xF6, 0x00
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_K_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_K_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_K_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_K_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_K_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_K_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_L_PepperNoiseXORCipher {

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
    // bit0 10011110  00001011  01011011  00001100
    // bit1 00110010  11011010  10010100  00101101
    // bit2 11100100  00011000  11001101  00101101
    // bit3 00000010  10011111  01011010  01010100
    // bit4 10010110  01111010  00101010  10011000
    // bit5 11101011  11101011  00001111  01010001
    // bit6 11100011  00101001  11010000  10001001
    // bit7 10111010  01100011  00101011  11011100
    //
    // Avalanche:
    // bit0 ...XX.XX  XXX...XX  .....X.X  X...X..X
    // bit1 X.XX.XXX  X...XXXX  XX..X.X.  X.X.XX.X
    // bit2 .X..XXX.  X.XX....  X..XX...  .X.X..X.
    // bit3 X.X.X...  X...X.X.  ....XXXX  ..X.XXX.
    // bit4 XX...XX.  XX.X..X.  ..X.....  ..XX.XXX
    // bit5 X.XXX.XX  XXXXXXX.  .....X.X  XXXXX.XX
    // bit6 X..XXX..  XX.....X  XX.X...X  XX.XXX..
    // bit7 XX...X.X  ..XX.XX.  ..X.X.X.  X...XX..
    // Avalanche: 49.61%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x0F, 0x33, 0x0F, 0x33, 0xC3, 0x33, 0xC3, 0xAA, 0xC3, 0xAA, 0x55, 0xAA, 0x55, 0x00, 0x55,
        0x00, 0xF0, 0x00, 0xF0, 0xCC, 0xF0, 0xCC, 0x33, 0xCC, 0x33, 0x3C, 0x33, 0x3C, 0xAA, 0x3C, 0xAA
    };

    const std::uint8_t aNoiseBuffer[32] = {
        0xAF, 0x26, 0x67, 0xC9, 0x85, 0xA8, 0xDF, 0x06, 0x54, 0x4D, 0x0F, 0x78, 0xFE, 0x10, 0xDD, 0x97,
        0x62, 0xB2, 0x09, 0xD2, 0xBD, 0x64, 0x9D, 0xA5, 0x0B, 0x15, 0x60, 0x1D, 0xEB, 0xF1, 0x00, 0x66
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[32] = {
        0xAF, 0x26, 0x67, 0xC9, 0x85, 0xA8, 0xDF, 0x06, 0x54, 0x4D, 0x0F, 0x78, 0xFE, 0x10, 0xDD, 0x97,
        0x62, 0xB2, 0x09, 0xD2, 0xBD, 0x64, 0x9D, 0xA5, 0x0B, 0x15, 0x60, 0x1D, 0xEB, 0xF1, 0x00, 0x66
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_L_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_L_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_L_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_L_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_L_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_32_L_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_A_PepperNoiseXORCipher {

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
    // bit0 11111101  01100110  10000001  10000100  10001110  11010101
    // bit1 11100011  01101011  10000010  11101100  10111111  11001000
    // bit2 00010001  11010011  11111010  11110000  11110000  01000100
    // bit3 10010100  01001011  11010110  10110101  01000111  01010000
    // bit4 00110001  00010001  10001101  11011101  11000110  10111100
    // bit5 11110001  01011011  10100101  00101101  11110100  01101110
    // bit6 01010110  01000100  10111001  10101010  00101010  10110100
    // bit7 01111001  11101011  00111010  10010001  10101010  00000101
    //
    // Avalanche:
    // bit0 XXXXXX.X  .XX..XX.  X......X  X....X..  X...XXX.  XX.X.X.X
    // bit1 XXX...XX  .XX.X.XX  X.....X.  XXX.XX..  X.XXXXXX  XX..X...
    // bit2 ...X...X  XX.X..XX  XXXXX.X.  XXXX....  XXXX....  .X...X..
    // bit3 X..X.X..  .X..X.XX  XX.X.XX.  X.XX.X.X  .X...XXX  .X.X....
    // bit4 ..XX...X  ...X...X  X...XX.X  XX.XXX.X  XX...XX.  X.XXXX..
    // bit5 XXXX...X  .X.XX.XX  X.X..X.X  ..X.XX.X  XXXX.X..  .XX.XXX.
    // bit6 .X.X.XX.  .X...X..  X.XXX..X  X.X.X.X.  ..X.X.X.  X.XX.X..
    // bit7 .XXXX..X  XXX.X.XX  ..XXX.X.  X..X...X  X.X.X.X.  .....X.X
    // Avalanche: 50.78%

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

    const std::uint8_t aNoiseBuffer[48] = {
        0xD4, 0xC7, 0xCD, 0xBF, 0x81, 0x92, 0x42, 0xED, 0x21, 0xF7, 0xC1, 0x2C, 0x55, 0x82, 0xF5, 0x7D,
        0xFE, 0x30, 0x27, 0x33, 0x2B, 0x1C, 0x71, 0x8E, 0xFB, 0x68, 0x76, 0x39, 0x4E, 0xDC, 0x02, 0x1D,
        0xED, 0x3C, 0x67, 0x64, 0xC3, 0xDC, 0xDB, 0x50, 0xCA, 0xF4, 0x0E, 0x9A, 0x4C, 0xAF, 0x04, 0x81
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[48] = {
        0xD4, 0xC7, 0xCD, 0xBF, 0x81, 0x92, 0x42, 0xED, 0x21, 0xF7, 0xC1, 0x2C, 0x55, 0x82, 0xF5, 0x7D,
        0xFE, 0x30, 0x27, 0x33, 0x2B, 0x1C, 0x71, 0x8E, 0xFB, 0x68, 0x76, 0x39, 0x4E, 0xDC, 0x02, 0x1D,
        0xED, 0x3C, 0x67, 0x64, 0xC3, 0xDC, 0xDB, 0x50, 0xCA, 0xF4, 0x0E, 0x9A, 0x4C, 0xAF, 0x04, 0x81
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_48_A_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_A_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_A_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_A_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_A_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_A_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_B_PepperNoiseXORCipher {

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
    // bit0 11110101  10010110  00000111  11010101  01000001  10011110
    // bit1 11101010  01110000  11011001  10101111  10000010  01110000
    // bit2 11010110  01011111  10011000  01100100  00001001  01001100
    // bit3 11110001  01100010  10100101  00101010  10011010  11101000
    // bit4 00000010  01000100  01110111  10001000  10101111  10010000
    // bit5 10110111  00110000  10111110  11011010  00101101  01010110
    // bit6 01010011  00100100  10111010  01010101  00110101  11011110
    // bit7 10000011  00001011  10111101  00001010  11110100  11100010
    //
    // Avalanche:
    // bit0 ....X.X.  .XX.X..X  XXXXX...  ..X.X.X.  X.XXXXX.  .XX....X
    // bit1 ...X.X.X  X...XXXX  ..X..XX.  .X.X....  .XXXXX.X  X...XXXX
    // bit2 ..X.X..X  X.X.....  .XX..XXX  X..XX.XX  XXXX.XX.  X.XX..XX
    // bit3 ....XXX.  X..XXX.X  .X.XX.X.  XX.X.X.X  .XX..X.X  ...X.XXX
    // bit4 XXXXXX.X  X.XXX.XX  X...X...  .XXX.XXX  .X.X....  .XX.XXXX
    // bit5 .X..X...  XX..XXXX  .X.....X  ..X..X.X  XX.X..X.  X.X.X..X
    // bit6 X.X.XX..  XX.XX.XX  .X...X.X  X.X.X.X.  XX..X.X.  ..X....X
    // bit7 .XXXXX..  XXXX.X..  .X....X.  XXXX.X.X  ....X.XX  ...XXX.X
    // Avalanche: 51.04%

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

    const std::uint8_t aNoiseBuffer[48] = {
        0xF5, 0xF2, 0xD4, 0xB6, 0x40, 0xA4, 0x6F, 0x97, 0x80, 0x78, 0x56, 0xE4, 0x21, 0xAA, 0xB1, 0x21,
        0x77, 0x48, 0x1F, 0x6F, 0x67, 0x9D, 0x8E, 0xD9, 0xCC, 0xA6, 0x70, 0x86, 0x5D, 0xE2, 0x55, 0xC2,
        0x59, 0x81, 0x0F, 0x13, 0x3C, 0x0F, 0x58, 0xAE, 0x9B, 0x77, 0x51, 0xCE, 0xB2, 0xA6, 0x87, 0x00
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[48] = {
        0xF5, 0xF2, 0xD4, 0xB6, 0x40, 0xA4, 0x6F, 0x97, 0x80, 0x78, 0x56, 0xE4, 0x21, 0xAA, 0xB1, 0x21,
        0x77, 0x48, 0x1F, 0x6F, 0x67, 0x9D, 0x8E, 0xD9, 0xCC, 0xA6, 0x70, 0x86, 0x5D, 0xE2, 0x55, 0xC2,
        0x59, 0x81, 0x0F, 0x13, 0x3C, 0x0F, 0x58, 0xAE, 0x9B, 0x77, 0x51, 0xCE, 0xB2, 0xA6, 0x87, 0x00
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_48_B_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_B_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_B_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_B_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_B_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_B_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_C_PepperNoiseXORCipher {

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
    // bit0 10000101  11100000  00001101  10000000  00011101  01101001
    // bit1 01101010  11100000  00000001  10100111  11101010  00011100
    // bit2 10001001  10000110  10100011  00101011  00101001  00001001
    // bit3 00111110  01000000  11111001  00011000  01110001  01101110
    // bit4 11111110  00101010  10000010  10110100  00000001  00100011
    // bit5 00000010  10010111  01010100  00011100  01111000  01111110
    // bit6 01100010  11101010  00001111  00001101  00111110  01100110
    // bit7 00100110  11000100  10001001  10110001  01001000  00011010
    //
    // Avalanche:
    // bit0 ..X.XXXX  .X..X.X.  X.X..XXX  ..X.X.X.  X.XX.XXX  XX....XX
    // bit1 XX......  .X..X.X.  X.X.X.XX  ....XX.X  .X......  X.XX.XX.
    // bit2 ..X...XX  ..X.XX..  ....X..X  X......X  X.....XX  X.X...XX
    // bit3 X..X.X..  XXX.X.X.  .X.X..XX  X.XX..X.  XX.XX.XX  XX...X..
    // bit4 X.X.X.XX  .XXXXXXX  XX.X.XXX  XXX....X  .X.X.X..  .XXX.XX.
    // bit5 .X.X.XXX  XX....X.  .......X  .X..X..X  ..X.XX.X  ..X.X.XX
    // bit6 ..XX.XXX  X.XXXXXX  .X.XX.X.  .X.XX...  .XX.X.XX  ..XX..XX
    // bit7 .XXX..XX  X..X...X  XX.XXX..  XXX..X..  ...XXX.X  .X..XXXX
    // Avalanche: 49.74%

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

    const std::uint8_t aNoiseBuffer[48] = {
        0xA8, 0x4A, 0x5B, 0x18, 0x78, 0x99, 0x5F, 0xA0, 0xE7, 0xD3, 0xCA, 0x04, 0x0A, 0x25, 0x2E, 0x04,
        0x39, 0x14, 0x30, 0x14, 0x93, 0x86, 0x2A, 0xF3, 0xC9, 0x00, 0x69, 0x1D, 0x36, 0x4E, 0x60, 0x63,
        0x40, 0x55, 0x76, 0x96, 0xE7, 0x82, 0x42, 0xB8, 0x00, 0x96, 0x9E, 0x45, 0xF5, 0x56, 0x1F, 0xA8
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[48] = {
        0xA8, 0x4A, 0x5B, 0x18, 0x78, 0x99, 0x5F, 0xA0, 0xE7, 0xD3, 0xCA, 0x04, 0x0A, 0x25, 0x2E, 0x04,
        0x39, 0x14, 0x30, 0x14, 0x93, 0x86, 0x2A, 0xF3, 0xC9, 0x00, 0x69, 0x1D, 0x36, 0x4E, 0x60, 0x63,
        0x40, 0x55, 0x76, 0x96, 0xE7, 0x82, 0x42, 0xB8, 0x00, 0x96, 0x9E, 0x45, 0xF5, 0x56, 0x1F, 0xA8
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_48_C_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_C_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_C_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_C_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_C_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_C_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_D_PepperNoiseXORCipher {

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
    // bit0 10100100  00101011  01001001  11010001  00100101  11100101
    // bit1 00110001  00111010  01010111  10110010  01001100  01010001
    // bit2 10000010  01010110  10000010  01000110  10000010  10001101
    // bit3 11100000  01000011  01101010  01100010  00011000  10000011
    // bit4 10001100  11000000  10001100  10001111  01001000  01110111
    // bit5 11001100  10100000  10110000  11001111  00110100  01101000
    // bit6 11001111  01100111  10101011  10100011  11010000  10111100
    // bit7 10101100  10011010  11001000  01001111  10010100  00011001
    //
    // Avalanche:
    // bit0 ....XXX.  X......X  XXX...XX  .XXXX.XX  X...XXXX  .X..XXXX
    // bit1 X..XX.XX  X..X....  XXXXXX.X  ...XX...  XXX..XX.  XXXXX.XX
    // bit2 XX.X.XXX  ......XX  XX.X.XXX  ...X..XX  XX.X.XXX  XX.XX...
    // bit3 X.XX.X.X  ...X.XX.  ..XXXXXX  ..XX.XXX  .X..XX.X  XX.X.XX.
    // bit4 ..X..XX.  .XX.X.X.  ..X..XX.  ..X..X.X  XXX...X.  XX.XXX.X
    // bit5 .XX..XX.  ....X.X.  ...XX.X.  .XX..X.X  X..XXXX.  XX....X.
    // bit6 X..XX.X.  ..XX..X.  XXXXXXX.  XXXX.XX.  X....X.X  XXX.X..X
    // bit7 XXXXX..X  XX..XXXX  X..XXX.X  ...XX.X.  XX.....X  .X..XX..
    // Avalanche: 53.91%

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

    const std::uint8_t aNoiseBuffer[48] = {
        0xBF, 0x16, 0xD1, 0x40, 0x0F, 0x8F, 0x22, 0x42, 0x0D, 0x3A, 0xC6, 0x61, 0xC1, 0x22, 0xF3, 0x92,
        0x2F, 0xD1, 0x16, 0x44, 0x9B, 0x48, 0x72, 0xC2, 0xCE, 0xB5, 0x52, 0xC0, 0x0D, 0x2D, 0x7F, 0x8F,
        0x23, 0x4A, 0x84, 0x17, 0x58, 0xC5, 0x20, 0x80, 0xB2, 0xCC, 0x8E, 0x4B, 0x27, 0xAA, 0x18, 0xF9
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[48] = {
        0xBF, 0x16, 0xD1, 0x40, 0x0F, 0x8F, 0x22, 0x42, 0x0D, 0x3A, 0xC6, 0x61, 0xC1, 0x22, 0xF3, 0x92,
        0x2F, 0xD1, 0x16, 0x44, 0x9B, 0x48, 0x72, 0xC2, 0xCE, 0xB5, 0x52, 0xC0, 0x0D, 0x2D, 0x7F, 0x8F,
        0x23, 0x4A, 0x84, 0x17, 0x58, 0xC5, 0x20, 0x80, 0xB2, 0xCC, 0x8E, 0x4B, 0x27, 0xAA, 0x18, 0xF9
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_48_D_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_D_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_D_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_D_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_D_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_D_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_E_PepperNoiseXORCipher {

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
    // bit0 01101101  00001011  01100010  10101100  01101111  00010111
    // bit1 10010001  00011101  00100111  00011110  10001010  01100110
    // bit2 00001111  00100000  11111111  01011001  01011100  00001101
    // bit3 01111100  10110101  10001111  11010101  00100100  11011101
    // bit4 10011011  10001110  10011101  10111111  01000110  10000001
    // bit5 11100100  11011010  00010001  11110111  01001101  10011001
    // bit6 11000111  00010010  10011000  00111100  10010110  10001101
    // bit7 01110000  10011011  10110011  00010111  00010011  00111110
    //
    // Avalanche:
    // bit0 XX...XXX  X.X....X  XX..X...  .....XX.  XX...X.X  X.XXXX.X
    // bit1 ..XXX.XX  X.XX.XXX  X...XX.X  X.XX.X..  ..X.....  XX..XX..
    // bit2 .X.XX.X.  .XXX.X.X  X.X.X.X.  ....XX..  ....X..X  .X.XX...
    // bit3 ..X.X..X  XXX.....  XX.XX.X.  X.......  .XXX...X  X...X...
    // bit4 XX..XXX.  XX.XX.XX  XX..X...  XXX.X.X.  ...X..XX  XX.X.X..
    // bit5 X.XX...X  X...XXXX  .X...X..  X.X...X.  ...XX...  XX..XX..
    // bit6 .XX.XX.X  X.XXX...  ..XX..X.  X..X.XX.  ..XXXX..  ..X..XXX
    // bit7 XX.XX.X.  ..XX...X  ...XX..X  X.XXXX.X  X.XXX..X  X..X.X..
    // Avalanche: 46.88%

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

    const std::uint8_t aNoiseBuffer[48] = {
        0x4E, 0x97, 0x95, 0x59, 0xB8, 0xB6, 0x2A, 0xEA, 0x1D, 0x04, 0x30, 0x57, 0xCD, 0x58, 0x8F, 0xD1,
        0x3B, 0xA0, 0xE1, 0x2F, 0x3A, 0x78, 0xF1, 0x7D, 0x9C, 0x34, 0x8E, 0x7F, 0xEA, 0xDF, 0x4D, 0x3D,
        0x42, 0xAC, 0x90, 0x23, 0xE4, 0xBE, 0xCB, 0x85, 0x1E, 0x50, 0x41, 0x95, 0x37, 0xF3, 0xC1, 0xBE
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[48] = {
        0x4E, 0x97, 0x95, 0x59, 0xB8, 0xB6, 0x2A, 0xEA, 0x1D, 0x04, 0x30, 0x57, 0xCD, 0x58, 0x8F, 0xD1,
        0x3B, 0xA0, 0xE1, 0x2F, 0x3A, 0x78, 0xF1, 0x7D, 0x9C, 0x34, 0x8E, 0x7F, 0xEA, 0xDF, 0x4D, 0x3D,
        0x42, 0xAC, 0x90, 0x23, 0xE4, 0xBE, 0xCB, 0x85, 0x1E, 0x50, 0x41, 0x95, 0x37, 0xF3, 0xC1, 0xBE
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_48_E_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_E_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_E_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_E_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_E_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_E_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_F_PepperNoiseXORCipher {

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
    // bit0 01001110  11010010  10000001  00000101  11101100  00010010
    // bit1 11101001  10110011  00011010  00000000  11011111  11010000
    // bit2 10011101  00001101  11101011  00000001  10011111  11011010
    // bit3 01001011  00111010  00110010  11010110  01110001  01000000
    // bit4 01100110  00101110  10010110  11101100  10011000  10001101
    // bit5 11011101  11010011  11101111  10101101  01000101  00100001
    // bit6 00001101  00011011  01000111  01011100  00110101  10011000
    // bit7 11111101  10000111  10000100  11000011  10011101  00011001
    //
    // Avalanche:
    // bit0 XXX..X..  .XXXX...  ..X.X.XX  X.X.XXXX  .X...XX.  X.XXX...
    // bit1 X.XXXX..  XXX..XX.  .X..XXXX  .X.X.X.X  X...X.X.  X....X.X
    // bit2 ..XX.XXX  X.X..XXX  .X.....X  X.X.X.XX  ..XX.X.X  .XXX....
    // bit3 ...XXXX.  .XX.XXXX  .XX..XXX  X.....XX  ..X..X..  ...X.X.X
    // bit4 XX..XX..  X....X..  ..XXXX..  .X...XX.  ..XX..X.  ..X..XXX
    // bit5 X...X...  X....XX.  X.XXX.X.  XXXXX...  ...X....  .XXX.X..
    // bit6 X.X..XXX  X.XX...X  XXX.XX.X  XXXX.XX.  X..XXXXX  ..XX..X.
    // bit7 X.X.X...  XX.X..X.  XX.X...X  X..X.XX.  XX..X...  .X..XX..
    // Avalanche: 48.96%

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

    const std::uint8_t aNoiseBuffer[48] = {
        0x65, 0xDD, 0x49, 0x25, 0xF7, 0xAF, 0x98, 0x77, 0xC5, 0x84, 0x58, 0xD6, 0x3A, 0x29, 0xDF, 0x67,
        0xAD, 0x26, 0x34, 0x58, 0x64, 0x0F, 0x7E, 0xA6, 0x1D, 0x1B, 0x0C, 0x12, 0x0E, 0x9E, 0x11, 0xA5,
        0xE9, 0xD4, 0x92, 0x7B, 0xE9, 0xE7, 0x60, 0x77, 0x6A, 0x70, 0x04, 0xE3, 0x2B, 0x08, 0xA0, 0x0D
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[48] = {
        0x65, 0xDD, 0x49, 0x25, 0xF7, 0xAF, 0x98, 0x77, 0xC5, 0x84, 0x58, 0xD6, 0x3A, 0x29, 0xDF, 0x67,
        0xAD, 0x26, 0x34, 0x58, 0x64, 0x0F, 0x7E, 0xA6, 0x1D, 0x1B, 0x0C, 0x12, 0x0E, 0x9E, 0x11, 0xA5,
        0xE9, 0xD4, 0x92, 0x7B, 0xE9, 0xE7, 0x60, 0x77, 0x6A, 0x70, 0x04, 0xE3, 0x2B, 0x08, 0xA0, 0x0D
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_48_F_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_F_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_F_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_F_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_F_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_48_F_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_A_PepperNoiseXORCipher {

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
    // bit0 11100110  10001011  11101000  11001101  10110001  00101011  10100011  01001010
    // bit1 11100110  01010110  01001111  01000001  11110000  00100111  00011011  00000100
    // bit2 00100001  10100010  10110101  11001001  00110101  11110001  01001111  00010100
    // bit3 11111101  10100110  11100111  01000011  01011100  00011100  10011101  00000000
    // bit4 10010000  01001100  01100001  00101001  10101011  01111111  10011110  00010101
    // bit5 10111100  00010110  10010101  01100011  11000110  11111110  10100100  11001001
    // bit6 00110000  00100110  11010110  00101011  00100100  11000100  11100110  11111100
    // bit7 10101110  01011000  00011111  00101001  11011110  01001100  10010011  10100111
    //
    // Avalanche:
    // bit0 XXX..XX.  X...X.XX  XXX.X...  XX..XX.X  X.XX...X  ..X.X.XX  X.X...XX  .X..X.X.
    // bit1 XXX..XX.  .X.X.XX.  .X..XXXX  .X.....X  XXXX....  ..X..XXX  ...XX.XX  .....X..
    // bit2 ..X....X  X.X...X.  X.XX.X.X  XX..X..X  ..XX.X.X  XXXX...X  .X..XXXX  ...X.X..
    // bit3 XXXXXX.X  X.X..XX.  XXX..XXX  .X....XX  .X.XXX..  ...XXX..  X..XXX.X  ........
    // bit4 X..X....  .X..XX..  .XX....X  ..X.X..X  X.X.X.XX  .XXXXXXX  X..XXXX.  ...X.X.X
    // bit5 X.XXXX..  ...X.XX.  X..X.X.X  .XX...XX  XX...XX.  XXXXXXX.  X.X..X..  XX..X..X
    // bit6 ..XX....  ..X..XX.  XX.X.XX.  ..X.X.XX  ..X..X..  XX...X..  XXX..XX.  XXXXXX..
    // bit7 X.X.XXX.  .X.XX...  ...XXXXX  ..X.X..X  XX.XXXX.  .X..XX..  X..X..XX  X.X..XXX
    // Avalanche: 49.41%

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

    const std::uint8_t aNoiseBuffer[64] = {
        0xDD, 0xD0, 0xF7, 0x1E, 0x15, 0xD5, 0xC1, 0x30, 0xB0, 0x49, 0x32, 0x45, 0x89, 0x5E, 0xF6, 0x80,
        0xB6, 0xDA, 0xB8, 0x27, 0xC1, 0x77, 0x53, 0x7D, 0xA0, 0xF4, 0x0F, 0x00, 0xAB, 0x80, 0x16, 0xFF,
        0xCD, 0x55, 0xEA, 0xF1, 0x19, 0x37, 0x0D, 0xA8, 0x26, 0x2F, 0xEC, 0x3C, 0x9D, 0x5F, 0xCC, 0xE8,
        0x9F, 0x22, 0x86, 0x59, 0x78, 0x3E, 0xEB, 0xF1, 0x07, 0x86, 0x03, 0x2A, 0x86, 0x6B, 0x81, 0x0D
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[64] = {
        0xDD, 0xD0, 0xF7, 0x1E, 0x15, 0xD5, 0xC1, 0x30, 0xB0, 0x49, 0x32, 0x45, 0x89, 0x5E, 0xF6, 0x80,
        0xB6, 0xDA, 0xB8, 0x27, 0xC1, 0x77, 0x53, 0x7D, 0xA0, 0xF4, 0x0F, 0x00, 0xAB, 0x80, 0x16, 0xFF,
        0xCD, 0x55, 0xEA, 0xF1, 0x19, 0x37, 0x0D, 0xA8, 0x26, 0x2F, 0xEC, 0x3C, 0x9D, 0x5F, 0xCC, 0xE8,
        0x9F, 0x22, 0x86, 0x59, 0x78, 0x3E, 0xEB, 0xF1, 0x07, 0x86, 0x03, 0x2A, 0x86, 0x6B, 0x81, 0x0D
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_A_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_A_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_A_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_A_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_A_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_A_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_B_PepperNoiseXORCipher {

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
    // bit0 01010000  00011101  00111011  00101010  10000011  11111011  00100101  01100100
    // bit1 00101000  00100110  00000011  11101001  01100110  00111001  01101000  00110000
    // bit2 00000100  01010001  01101000  11011110  00001010  11111101  00000000  00111110
    // bit3 10100001  10101100  11010100  10010100  11110010  01011101  00101011  10001010
    // bit4 00011111  01000010  01111111  01101110  01110011  00000101  00101100  00001001
    // bit5 10010010  11110110  11101110  01000011  01000100  00101110  11011001  10010100
    // bit6 11000100  11000000  00111001  10101000  01010001  00111111  11100110  01000011
    // bit7 01010111  01100011  10110011  11011100  10110111  11101101  11001100  00100001
    //
    // Avalanche:
    // bit0 X.X.XXXX  XXX...X.  XX...X..  XX.X.X.X  .XXXXX..  .....X..  XX.XX.X.  X..XX.XX
    // bit1 XX.X.XXX  XX.XX..X  XXXXXX..  ...X.XX.  X..XX..X  XX...XX.  X..X.XXX  XX..XXXX
    // bit2 XXXXX.XX  X.X.XXX.  X..X.XXX  ..X....X  XXXX.X.X  ......X.  XXXXXXXX  XX.....X
    // bit3 .X.XXXX.  .X.X..XX  ..X.X.XX  .XX.X.XX  ....XX.X  X.X...X.  XX.X.X..  .XXX.X.X
    // bit4 XXX.....  X.XXXX.X  X.......  X..X...X  X...XX..  XXXXX.X.  XX.X..XX  XXXX.XX.
    // bit5 .XX.XX.X  ....X..X  ...X...X  X.XXXX..  X.XXX.XX  XX.X...X  ..X..XX.  .XX.X.XX
    // bit6 ..XXX.XX  ..XXXXXX  XX...XX.  .X.X.XXX  X.X.XXX.  XX......  ...XX..X  X.XXXX..
    // bit7 X.X.X...  X..XXX..  .X..XX..  ..X...XX  .X..X...  ...X..X.  ..XX..XX  XX.XXXX.
    // Avalanche: 52.73%

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

    const std::uint8_t aNoiseBuffer[64] = {
        0x16, 0x83, 0x50, 0x8D, 0x48, 0x2B, 0x0D, 0x19, 0x16, 0x2F, 0x55, 0xA4, 0x90, 0xD4, 0x4D, 0xA1,
        0x15, 0x3C, 0xAF, 0x9B, 0xAE, 0x1C, 0xCD, 0xCB, 0x73, 0x6D, 0xCA, 0x31, 0xEB, 0x39, 0xAC, 0x44,
        0x91, 0x5E, 0x59, 0x1B, 0x20, 0x45, 0xF9, 0x8B, 0xA1, 0xB1, 0xE7, 0xF2, 0xF7, 0x3F, 0x86, 0xFB,
        0x07, 0x47, 0xDA, 0x04, 0x5D, 0x8B, 0x12, 0x94, 0x14, 0x82, 0xE1, 0x64, 0x38, 0xA4, 0x32, 0x0B
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[64] = {
        0x16, 0x83, 0x50, 0x8D, 0x48, 0x2B, 0x0D, 0x19, 0x16, 0x2F, 0x55, 0xA4, 0x90, 0xD4, 0x4D, 0xA1,
        0x15, 0x3C, 0xAF, 0x9B, 0xAE, 0x1C, 0xCD, 0xCB, 0x73, 0x6D, 0xCA, 0x31, 0xEB, 0x39, 0xAC, 0x44,
        0x91, 0x5E, 0x59, 0x1B, 0x20, 0x45, 0xF9, 0x8B, 0xA1, 0xB1, 0xE7, 0xF2, 0xF7, 0x3F, 0x86, 0xFB,
        0x07, 0x47, 0xDA, 0x04, 0x5D, 0x8B, 0x12, 0x94, 0x14, 0x82, 0xE1, 0x64, 0x38, 0xA4, 0x32, 0x0B
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_B_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_B_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_B_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_B_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_B_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_B_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_C_PepperNoiseXORCipher {

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
    // bit0 01101001  00100000  01100100  10010001  00011101  11100100  10110010  00011010
    // bit1 01000000  01010001  11111010  00011000  10100001  10011011  11011010  00111101
    // bit2 11001010  01010100  10010011  10100110  00000111  00101110  11110001  10100010
    // bit3 10001011  01100001  11001111  01111111  01011110  00100111  00111111  11111011
    // bit4 01010100  01001000  00101000  10101101  11110011  10110100  00011000  10100001
    // bit5 11000001  11001110  01111110  01001110  11100011  00110001  00111000  00100110
    // bit6 11100000  10110001  01100010  01100110  01101100  11011111  10010011  10011010
    // bit7 11000001  11011001  10001111  01011100  00101111  11011011  10011111  01000101
    //
    // Avalanche:
    // bit0 XX....XX  X...X.X.  XX..XXX.  ..XXX.XX  X.XX.XXX  .X..XXX.  ...XX...  X.XX....
    // bit1 XXX.X.X.  XXXXX.XX  .X.X....  X.XX..X.  ....X.XX  ..XX...X  .XXX....  X..X.XXX
    // bit2 .XX.....  XXXXXXX.  ..XXX..X  ....XX..  X.X.XX.X  X....X..  .X.XX.XX  ....X...
    // bit3 ..X....X  XX..X.XX  .XX..X.X  XX.X.X.X  XXXX.X..  X...XX.X  X..X.X.X  .X.X...X
    // bit4 .......X  ...XXX.X  .XXXXX.X  XXXXX...  X.X..XX.  XXX....X  .X..XX.X  XXXX.X..
    // bit5 X..X.X..  X..XX.XX  ..X.X.XX  ...XX.XX  X.XX.XX.  .XX..X..  .XX.XX.X  .XXX..XX
    // bit6 X.XX.X.X  XXX..X..  ..XX.XXX  ..XX..XX  ..XXX..X  X...X.X.  XX...XX.  XX..XXXX
    // bit7 X..X.X..  X...XX..  XX.XX.X.  ....X..X  .XXXX.X.  X...XXX.  XX..X.X.  ...X....
    // Avalanche: 49.41%

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

    const std::uint8_t aNoiseBuffer[64] = {
        0x37, 0xEF, 0x82, 0x08, 0xB0, 0x08, 0x30, 0x95, 0x07, 0x7D, 0x92, 0x63, 0x0D, 0x24, 0x04, 0x53,
        0x71, 0xD6, 0xCE, 0x64, 0x5D, 0x95, 0x77, 0x31, 0xA8, 0x17, 0x3A, 0xD1, 0x5D, 0x3F, 0x36, 0x98,
        0x4C, 0x1E, 0x4F, 0x98, 0x93, 0xB3, 0x3D, 0xED, 0xCB, 0x83, 0xBC, 0x4F, 0x63, 0xBA, 0x73, 0x57,
        0xE3, 0x60, 0xB4, 0xFF, 0x5D, 0x11, 0xD3, 0x33, 0x3A, 0x11, 0x7C, 0xD2, 0xD2, 0x45, 0xB6, 0x59
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[64] = {
        0x37, 0xEF, 0x82, 0x08, 0xB0, 0x08, 0x30, 0x95, 0x07, 0x7D, 0x92, 0x63, 0x0D, 0x24, 0x04, 0x53,
        0x71, 0xD6, 0xCE, 0x64, 0x5D, 0x95, 0x77, 0x31, 0xA8, 0x17, 0x3A, 0xD1, 0x5D, 0x3F, 0x36, 0x98,
        0x4C, 0x1E, 0x4F, 0x98, 0x93, 0xB3, 0x3D, 0xED, 0xCB, 0x83, 0xBC, 0x4F, 0x63, 0xBA, 0x73, 0x57,
        0xE3, 0x60, 0xB4, 0xFF, 0x5D, 0x11, 0xD3, 0x33, 0x3A, 0x11, 0x7C, 0xD2, 0xD2, 0x45, 0xB6, 0x59
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_C_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_C_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_C_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_C_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_C_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_C_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_D_PepperNoiseXORCipher {

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
    // bit0 10111011  10011001  11010000  01100101  10100101  11001100  10000000  00010000
    // bit1 00111011  01101001  10000111  11001100  11111101  01111100  10001001  01101110
    // bit2 00001100  00001000  11000111  11011111  11110001  10100100  10000001  01110100
    // bit3 11010100  00101111  00111110  11101100  00010001  01011000  11101111  11101001
    // bit4 11001111  01011011  00101111  11001000  11101101  01100110  10001111  10011100
    // bit5 10001011  11100010  11101000  10100111  11110001  01110011  01001010  11101111
    // bit6 01100000  11110100  11000000  11111010  10011111  11100011  01110011  00011100
    // bit7 11000101  00010110  10110101  00001110  11000111  10110010  10010101  00110011
    //
    // Avalanche:
    // bit0 ...X...X  ..XX..XX  .XXXX.X.  XX..XXXX  ....XXXX  .XX..XX.  ..X.X.X.  X.XXX.X.
    // bit1 X..X...X  XX....XX  ..X.XX.X  .XX..XX.  .X.X.XXX  XX.X.XX.  ..X...XX  XX...X..
    // bit2 .X.XX..X  .X.XXX.X  X..X..X.  X...X.X.  X.X..X..  XXXX...X  XX.X.X..  ..X....X
    // bit3 X......X  .XXXX.X.  .XX.X.XX  X.XXX..X  .X...X..  ....XX.X  X.XXX.X.  X.XXXX..
    // bit4 .XX..X.X  XXXX...X  X....X.X  .XX...X.  .X...XXX  XX..XX..  ..X..X.X  ..XX.XX.
    // bit5 ..X....X  .X..X...  .X....X.  ....XX.X  .X.XX.XX  XX.XX..X  XXX.....  .X...X.X
    // bit6 ..XX.X.X  X.X....X  X..X.X.X  X.X.XXXX  XX..X.X.  X.XX.XX.  ..X..XX.  .X..X..X
    // bit7 X..X....  .X....XX  XXX.....  .X.XX.XX  X..X..X.  XXX..XXX  XX......  .XX..XX.
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

    const std::uint8_t aNoiseBuffer[64] = {
        0x9D, 0x1B, 0xC2, 0xD0, 0xEC, 0x39, 0xCC, 0xCD, 0x86, 0x4E, 0x56, 0x8B, 0xF8, 0x13, 0x1D, 0xD8,
        0xE7, 0xA6, 0x1D, 0x91, 0x1C, 0x79, 0x78, 0x69, 0x7E, 0xFA, 0x96, 0x22, 0x7B, 0xF5, 0x27, 0xA4,
        0xEF, 0x6D, 0xEC, 0x76, 0x4A, 0xCB, 0x03, 0xFF, 0xA3, 0xDE, 0x6F, 0x55, 0xD0, 0xE8, 0x0F, 0x06,
        0xF9, 0x16, 0x12, 0x03, 0x5C, 0x19, 0x1E, 0x7B, 0x1C, 0x74, 0x75, 0xAB, 0x5E, 0x6E, 0x45, 0x15
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[64] = {
        0x9D, 0x1B, 0xC2, 0xD0, 0xEC, 0x39, 0xCC, 0xCD, 0x86, 0x4E, 0x56, 0x8B, 0xF8, 0x13, 0x1D, 0xD8,
        0xE7, 0xA6, 0x1D, 0x91, 0x1C, 0x79, 0x78, 0x69, 0x7E, 0xFA, 0x96, 0x22, 0x7B, 0xF5, 0x27, 0xA4,
        0xEF, 0x6D, 0xEC, 0x76, 0x4A, 0xCB, 0x03, 0xFF, 0xA3, 0xDE, 0x6F, 0x55, 0xD0, 0xE8, 0x0F, 0x06,
        0xF9, 0x16, 0x12, 0x03, 0x5C, 0x19, 0x1E, 0x7B, 0x1C, 0x74, 0x75, 0xAB, 0x5E, 0x6E, 0x45, 0x15
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_D_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_D_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_D_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_D_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_D_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_D_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_E_PepperNoiseXORCipher {

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
    // bit0 01101110  00101001  10011011  00100110  11111000  01110000  10010010  10100100
    // bit1 00000000  11001101  11010101  00110101  10010010  00110000  10001111  11011101
    // bit2 00000110  10000010  11011100  10010100  11000111  10111101  01100100  11010111
    // bit3 10011001  00010100  10011011  01011001  11101110  01100011  10000101  10100011
    // bit4 11100110  10101000  10101001  10000000  00011100  11010111  00100101  01101010
    // bit5 10111011  00000011  00110111  00000000  10101010  11000010  01011010  11000100
    // bit6 01000101  00101101  10010000  00011110  00111010  11000011  10000111  00000100
    // bit7 01110000  01100110  11000011  10011101  01000111  11000111  10011100  11100101
    //
    // Avalanche:
    // bit0 XX...X..  X.....XX  ..XX...X  X...XX..  .X.X..X.  XX.XX.X.  ..XXX...  ....XXX.
    // bit1 X.X.X.X.  .XX..XXX  .XXXXXXX  X..XXXXX  ..XXX...  X..XX.X.  ..X..X.X  .XXX.XXX
    // bit2 .X.X..XX  XX.X.XXX  X...X..X  XX.....X  X..X..X.  XXX.X...  ..XX...X  X.....X.
    // bit3 XX..XX..  .X.....X  XX..XXX.  ....XX..  X.XXX.XX  ..XX.XX.  XX.X....  XXXX.XX.
    // bit4 X.XX..XX  XXXXXX.X  XXXXXX..  XX.X.X.X  .X..X..X  X.....X.  .XXX....  ..XXXXXX
    // bit5 XXX.XXX.  .X.X.XX.  .XX...X.  .X.X.X.X  XXXXXXXX  X..X.XXX  ....XXXX  X..X...X
    // bit6 XXX.XXXX  X....XXX  ..XXX.X.  X.XX.X..  X..X....  .XX.X..X  ..X.XX.X  X.X.XXX.
    // bit7 XX.XX.X.  XX..XX..  .XX.X..X  ..XX.XXX  XXX.XX.X  .XX.XX.X  ..XX.XX.  .X..XXXX
    // Avalanche: 52.73%

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

    const std::uint8_t aNoiseBuffer[64] = {
        0x1C, 0x8B, 0x8D, 0x15, 0x94, 0xAA, 0xAC, 0x16, 0x68, 0x41, 0x8B, 0x10, 0xCA, 0x53, 0x25, 0xC6,
        0xFB, 0x61, 0x0C, 0xF6, 0xB8, 0x64, 0x95, 0xDD, 0x29, 0x10, 0xC0, 0x73, 0x13, 0xE3, 0x82, 0x51,
        0xF4, 0xB1, 0x96, 0xCA, 0x9E, 0x39, 0x77, 0x21, 0x2F, 0x9F, 0xF0, 0xE8, 0x20, 0x29, 0x1F, 0x3B,
        0xD3, 0x24, 0x28, 0x85, 0x45, 0x7B, 0xC6, 0x5A, 0xF5, 0x6D, 0x99, 0x60, 0x48, 0xE7, 0x38, 0x71
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[64] = {
        0x1C, 0x8B, 0x8D, 0x15, 0x94, 0xAA, 0xAC, 0x16, 0x68, 0x41, 0x8B, 0x10, 0xCA, 0x53, 0x25, 0xC6,
        0xFB, 0x61, 0x0C, 0xF6, 0xB8, 0x64, 0x95, 0xDD, 0x29, 0x10, 0xC0, 0x73, 0x13, 0xE3, 0x82, 0x51,
        0xF4, 0xB1, 0x96, 0xCA, 0x9E, 0x39, 0x77, 0x21, 0x2F, 0x9F, 0xF0, 0xE8, 0x20, 0x29, 0x1F, 0x3B,
        0xD3, 0x24, 0x28, 0x85, 0x45, 0x7B, 0xC6, 0x5A, 0xF5, 0x6D, 0x99, 0x60, 0x48, 0xE7, 0x38, 0x71
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_E_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_E_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_E_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_E_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_E_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_E_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_F_PepperNoiseXORCipher {

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
    // bit0 11111111  11010100  10001101  00010001  01011011  10111100  10101110  10101100
    // bit1 00110000  00010011  00011001  00100100  10111000  11000000  10001101  10100011
    // bit2 00111001  01001011  11101110  01010011  01111101  11010011  00111011  11111001
    // bit3 00110000  01000000  11111110  11101011  00010111  11110000  11010001  11110101
    // bit4 00001110  01000101  00110010  10000011  01101111  11110000  10011011  11110011
    // bit5 11001111  10101111  00111001  01011010  01100001  01111111  01001110  01011111
    // bit6 10101010  00010000  01101000  11010011  00111110  10100010  11000011  10010011
    // bit7 01111010  01011101  00111001  10101010  00100110  00000000  10100111  11000100
    //
    // Avalanche:
    // bit0 .X.X.X.X  .XXXXXX.  ..X..XXX  X.XXX.XX  XXXX...X  ...X.XX.  .....X..  .....XX.
    // bit1 .XX..X.X  .X...XX.  .X..XX..  .XXX...X  XXX.XX.X  X..X.X.X  XX.XX...  XXXX.XX.
    // bit2 X..X..XX  XXX....X  .X...X..  XXXXX..X  XX.X.XXX  .XXXX..X  X..X...X  .X.X..XX
    // bit3 .XX..X.X  ...X.X.X  X.X.X.XX  X.XXXXX.  .X....X.  X.X..X.X  X....X..  X.X.....
    // bit4 X.X..X..  XXX.XXXX  X..XX...  ..X.X..X  XX...X.X  .X.XX.X.  ..XX...X  .X.XX..X
    // bit5 X..XX.X.  XXXXX.X.  .XX.XX..  ....XXXX  ..XX.X..  ..X.X.X.  ...XX.XX  ....X.X.
    // bit6 ........  X.XXX.X.  XX....X.  .XXXX..X  X..X.X..  ....X...  .XX.X..X  ..XXX..X
    // bit7 ..X.XXXX  ....X...  .XX.XX..  XXXXXXXX  .XXX..XX  .X.X.X.X  XXXX..X.  X..X...X
    // Avalanche: 48.44%

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

    const std::uint8_t aNoiseBuffer[64] = {
        0x86, 0x85, 0xF3, 0xF1, 0xAF, 0x8C, 0x8F, 0xA4, 0x84, 0xB9, 0x04, 0xC3, 0x25, 0x8D, 0x64, 0x6D,
        0xB0, 0x32, 0x3F, 0x5D, 0xF7, 0xB0, 0x38, 0xC5, 0x1B, 0x36, 0x51, 0xA6, 0x15, 0x40, 0x3F, 0xBA,
        0x40, 0xAC, 0x6F, 0xF2, 0xEA, 0x3B, 0x9B, 0xBC, 0xFA, 0x7C, 0x9E, 0xBC, 0x84, 0x84, 0x26, 0x24,
        0xDB, 0x16, 0xA1, 0x38, 0xEC, 0xC5, 0xAF, 0x7B, 0xFB, 0x3D, 0xF8, 0x3E, 0xA4, 0x95, 0x4E, 0x7E
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[64] = {
        0x86, 0x85, 0xF3, 0xF1, 0xAF, 0x8C, 0x8F, 0xA4, 0x84, 0xB9, 0x04, 0xC3, 0x25, 0x8D, 0x64, 0x6D,
        0xB0, 0x32, 0x3F, 0x5D, 0xF7, 0xB0, 0x38, 0xC5, 0x1B, 0x36, 0x51, 0xA6, 0x15, 0x40, 0x3F, 0xBA,
        0x40, 0xAC, 0x6F, 0xF2, 0xEA, 0x3B, 0x9B, 0xBC, 0xFA, 0x7C, 0x9E, 0xBC, 0x84, 0x84, 0x26, 0x24,
        0xDB, 0x16, 0xA1, 0x38, 0xEC, 0xC5, 0xAF, 0x7B, 0xFB, 0x3D, 0xF8, 0x3E, 0xA4, 0x95, 0x4E, 0x7E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_F_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_F_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_F_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_F_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_F_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_64_F_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_A_PepperNoiseXORCipher {

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
    // bit0 00010100  10010010  11010100  10110000  10100111  00110111  01101001  01001100  00110001  00110001
    // bit1 10110011  01101100  11100110  10100111  01011101  01111000  10000011  10000111  01100110  00001000
    // bit2 11000100  11101000  10001001  11000000  11000001  01001000  01001001  00000000  01011110  00000001
    // bit3 11001010  01110110  10110101  11001100  01001100  00001111  01011101  00001100  10010010  11101110
    // bit4 10011001  10010011  01111101  11000010  00111000  11000111  11000101  01000101  01101000  01101100
    // bit5 11000111  10110011  01101010  10011010  11011001  11010110  10000001  11110001  11000001  01000011
    // bit6 00010101  11011010  10000000  00101001  10011110  01100101  11011000  11110110  10010000  11110110
    // bit7 10001001  11011111  10101011  00001110  01010110  00000011  10100111  01010011  01011000  11010101
    //
    // Avalanche:
    // bit0 ...X.X..  X..X..X.  XX.X.X..  X.XX....  X.X..XXX  ..XX.XXX  .XX.X..X  .X..XX..  ..XX...X  ..XX...X
    // bit1 X.XX..XX  .XX.XX..  XXX..XX.  X.X..XXX  .X.XXX.X  .XXXX...  X.....XX  X....XXX  .XX..XX.  ....X...
    // bit2 XX...X..  XXX.X...  X...X..X  XX......  XX.....X  .X..X...  .X..X..X  ........  .X.XXXX.  .......X
    // bit3 XX..X.X.  .XXX.XX.  X.XX.X.X  XX..XX..  .X..XX..  ....XXXX  .X.XXX.X  ....XX..  X..X..X.  XXX.XXX.
    // bit4 X..XX..X  X..X..XX  .XXXXX.X  XX....X.  ..XXX...  XX...XXX  XX...X.X  .X...X.X  .XX.X...  .XX.XX..
    // bit5 XX...XXX  X.XX..XX  .XX.X.X.  X..XX.X.  XX.XX..X  XX.X.XX.  X......X  XXXX...X  XX.....X  .X....XX
    // bit6 ...X.X.X  XX.XX.X.  X.......  ..X.X..X  X..XXXX.  .XX..X.X  XX.XX...  XXXX.XX.  X..X....  XXXX.XX.
    // bit7 X...X..X  XX.XXXXX  X.X.X.XX  ....XXX.  .X.X.XX.  ......XX  X.X..XXX  .X.X..XX  .X.XX...  XX.X.X.X
    // Avalanche: 47.19%

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

    const std::uint8_t aNoiseBuffer[80] = {
        0x7D, 0x34, 0x40, 0xCA, 0x19, 0xA6, 0x54, 0x4F, 0xAF, 0x73, 0x74, 0x9F, 0x63, 0x51, 0x9F, 0x0D,
        0xF3, 0xCC, 0x5D, 0x98, 0x2D, 0xD8, 0x45, 0x39, 0xFC, 0x38, 0xC2, 0x84, 0x17, 0x51, 0x4D, 0x42,
        0xA6, 0x75, 0x88, 0x4F, 0x5E, 0xD3, 0x83, 0xE4, 0x0C, 0x6E, 0xC2, 0xC4, 0x70, 0x9E, 0x9D, 0x9B,
        0x4F, 0xBA, 0x81, 0x12, 0xB2, 0x19, 0x41, 0xFD, 0x46, 0x8F, 0x06, 0x07, 0x90, 0xDA, 0x43, 0x4D,
        0x16, 0x6D, 0xC8, 0xB3, 0x29, 0x60, 0x70, 0x84, 0x13, 0x1F, 0x9A, 0x83, 0x58, 0x1B, 0x16, 0xA5
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[80] = {
        0x7D, 0x34, 0x40, 0xCA, 0x19, 0xA6, 0x54, 0x4F, 0xAF, 0x73, 0x74, 0x9F, 0x63, 0x51, 0x9F, 0x0D,
        0xF3, 0xCC, 0x5D, 0x98, 0x2D, 0xD8, 0x45, 0x39, 0xFC, 0x38, 0xC2, 0x84, 0x17, 0x51, 0x4D, 0x42,
        0xA6, 0x75, 0x88, 0x4F, 0x5E, 0xD3, 0x83, 0xE4, 0x0C, 0x6E, 0xC2, 0xC4, 0x70, 0x9E, 0x9D, 0x9B,
        0x4F, 0xBA, 0x81, 0x12, 0xB2, 0x19, 0x41, 0xFD, 0x46, 0x8F, 0x06, 0x07, 0x90, 0xDA, 0x43, 0x4D,
        0x16, 0x6D, 0xC8, 0xB3, 0x29, 0x60, 0x70, 0x84, 0x13, 0x1F, 0x9A, 0x83, 0x58, 0x1B, 0x16, 0xA5
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_80_A_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_A_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_A_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_A_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_A_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_A_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_B_PepperNoiseXORCipher {

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
    // bit0 00110000  00100000  10110011  01010001  10011000  01100001  00000101  10000101  01000011  10001011
    // bit1 00110001  00010011  00100001  11101011  00111110  00001111  00001110  00111111  00111111  11010111
    // bit2 00110101  11101000  00001001  00110100  11110101  10010010  01100000  10101110  11011101  01111000
    // bit3 01011100  11000101  10111101  10111001  10001010  11000011  00010011  00110001  00101010  00010001
    // bit4 00000000  01111110  11010011  00111111  00101110  10010010  00100100  11100101  00111010  10111000
    // bit5 01101100  00101111  01111010  01101000  11011101  11001001  00010110  00000110  01100101  01100100
    // bit6 00101010  11011101  10110100  11011101  11000111  11011100  01101110  01011011  10011000  10100111
    // bit7 11000101  00010110  11110010  01110000  10100011  11001011  00011100  10000111  10110110  00010011
    //
    // Avalanche:
    // bit0 XX..XXXX  XX.XXXXX  .X..XX..  X.X.XXX.  .XX..XXX  X..XXXX.  XXXXX.X.  .XXXX.X.  X.XXXX..  .XXX.X..
    // bit1 XX..XXX.  XXX.XX..  XX.XXXX.  ...X.X..  XX.....X  XXXX....  XXXX...X  XX......  XX......  ..X.X...
    // bit2 XX..X.X.  ...X.XXX  XXXX.XX.  XX..X.XX  ....X.X.  .XX.XX.X  X..XXXXX  .X.X...X  ..X...X.  X....XXX
    // bit3 X.X...XX  ..XXX.X.  .X....X.  .X...XX.  .XXX.X.X  ..XXXX..  XXX.XX..  XX..XXX.  XX.X.X.X  XXX.XXX.
    // bit4 XXXXXXXX  X......X  ..X.XX..  XX......  XX.X...X  .XX.XX.X  XX.XX.XX  ...XX.X.  XX...X.X  .X...XXX
    // bit5 X..X..XX  XX.X....  X....X.X  X..X.XXX  ..X...X.  ..XX.XX.  XXX.X..X  XXXXX..X  X..XX.X.  X..XX.XX
    // bit6 XX.X.X.X  ..X...X.  .X..X.XX  ..X...X.  ..XXX...  ..X...XX  X..X...X  X.X..X..  .XX..XXX  .X.XX...
    // bit7 ..XXX.X.  XXX.X..X  ....XX.X  X...XXXX  .X.XXX..  ..XX.X..  XXX...XX  .XXXX...  .X..X..X  XXX.XX..
    // Avalanche: 51.09%

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

    const std::uint8_t aNoiseBuffer[80] = {
        0x01, 0x15, 0xE6, 0xF0, 0x16, 0x35, 0x02, 0x61, 0x32, 0x3A, 0xAC, 0x4B, 0x2E, 0x1F, 0x4D, 0x56,
        0x9B, 0x0D, 0xD7, 0x9F, 0x34, 0x12, 0x8D, 0xF8, 0x52, 0xC7, 0x7D, 0xBB, 0x5E, 0x2A, 0x48, 0xDA,
        0xB7, 0x26, 0x69, 0xE4, 0xDC, 0x6E, 0x5B, 0x27, 0x3F, 0x97, 0x80, 0x2A, 0x47, 0x42, 0x79, 0xD5,
        0x00, 0x22, 0x2A, 0x15, 0x43, 0xCF, 0x56, 0x90, 0xA9, 0x0A, 0x78, 0x52, 0x62, 0xED, 0x67, 0xDB,
        0x23, 0xA4, 0x5D, 0x6B, 0x7A, 0x65, 0xD9, 0xE4, 0xCA, 0x64, 0x2E, 0x79, 0xA8, 0x46, 0xC3, 0xD3
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[80] = {
        0x01, 0x15, 0xE6, 0xF0, 0x16, 0x35, 0x02, 0x61, 0x32, 0x3A, 0xAC, 0x4B, 0x2E, 0x1F, 0x4D, 0x56,
        0x9B, 0x0D, 0xD7, 0x9F, 0x34, 0x12, 0x8D, 0xF8, 0x52, 0xC7, 0x7D, 0xBB, 0x5E, 0x2A, 0x48, 0xDA,
        0xB7, 0x26, 0x69, 0xE4, 0xDC, 0x6E, 0x5B, 0x27, 0x3F, 0x97, 0x80, 0x2A, 0x47, 0x42, 0x79, 0xD5,
        0x00, 0x22, 0x2A, 0x15, 0x43, 0xCF, 0x56, 0x90, 0xA9, 0x0A, 0x78, 0x52, 0x62, 0xED, 0x67, 0xDB,
        0x23, 0xA4, 0x5D, 0x6B, 0x7A, 0x65, 0xD9, 0xE4, 0xCA, 0x64, 0x2E, 0x79, 0xA8, 0x46, 0xC3, 0xD3
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_80_B_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_B_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_B_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_B_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_B_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_B_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_C_PepperNoiseXORCipher {

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
    // bit0 11011001  10101001  00110011  11001000  10100110  10100101  01111000  00100100  11100101  01000011
    // bit1 10100101  11110110  11110100  00000101  01101100  10111000  10100101  00100010  11010100  11110000
    // bit2 10110101  11110101  01101000  10101000  11100011  01111101  11010110  11110010  01110011  11100010
    // bit3 00000010  01101111  10010000  00010101  10010110  11011010  11100100  01111010  01101101  11010111
    // bit4 10101101  01010111  11100110  10000101  00110000  01111000  11010000  01000011  00111101  11111010
    // bit5 01101001  01010100  11001011  10110000  10010110  10110000  11010101  01000000  01101001  11000101
    // bit6 10011001  01111100  00011100  01000000  00101001  00100000  00011101  01110101  01010001  00110101
    // bit7 11110100  11001001  00001000  11001001  00100011  01110001  01100000  01111101  01001000  00001111
    //
    // Avalanche:
    // bit0 .XXX..XX  ......XX  X..XX..X  .XX...X.  ....XX..  ....XXXX  XX.X..X.  X...XXX.  .X..XXXX  XXX.X..X
    // bit1 ....XXXX  .X.XXX..  .X.XXXX.  X.X.XXXX  XX...XX.  ...X..X.  ....XXXX  X...X...  .XXXXXX.  .X.XX.X.
    // bit2 ...XXXXX  .X.XXXXX  XX....X.  ......X.  .X..X..X  XX.X.XXX  .XXXXX..  .X.XX...  XX.XX..X  .X..X...
    // bit3 X.X.X...  XX...X.X  ..XXX.X.  X.XXXXXX  ..XXXX..  .XXX....  .X..XXX.  XX.X....  XX...XXX  .XXXXX.X
    // bit4 XXXXX...  ......X.  X.XX..XX  XX.X....  .XX..X.X  ..X.XX.X  X....X.X  ...X.XX.  .XX.X...  X.X.XXXX
    // bit5 ..XXXX..  .......X  X..XXXX.  XXX..X.X  XX....XX  XXX..X.X  X.......  ...X.X.X  ..XXXX..  X..X....
    // bit6 XX..XX..  ..X.X..X  .X..X..X  ...X.X.X  .XXXXX..  .XXX.X.X  .X..X...  ..X.....  .....X..  .XX.....
    // bit7 X.X....X  X..XXX..  .X.XXX.X  X..XXX..  .XXX.XX.  ..X..X..  ..XX.X.X  ..X.X...  ...XXX.X  .X.XX.X.
    // Avalanche: 46.56%

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

    const std::uint8_t aNoiseBuffer[80] = {
        0xEB, 0x85, 0x6D, 0xA3, 0x8E, 0x69, 0x10, 0xEE, 0xE1, 0x7F, 0xF2, 0x6E, 0x93, 0x7E, 0x58, 0xB9,
        0x5C, 0x6C, 0xE8, 0xD2, 0x27, 0x4A, 0x8C, 0x84, 0xAD, 0x83, 0x24, 0x14, 0xA1, 0x58, 0x00, 0x59,
        0xB4, 0x60, 0xEB, 0x1C, 0x42, 0xD4, 0xB5, 0x23, 0xD4, 0x39, 0xEF, 0x7D, 0x78, 0xA0, 0x10, 0xA1,
        0x7C, 0xBD, 0xD1, 0xAE, 0x82, 0x76, 0x20, 0x46, 0x20, 0x3F, 0xF3, 0x33, 0x11, 0x83, 0x78, 0x0B,
        0xC0, 0xF7, 0xBC, 0x6A, 0x1D, 0xD8, 0x20, 0xBE, 0x7C, 0xFC, 0x6A, 0x5A, 0x09, 0x17, 0xB9, 0x97
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[80] = {
        0xEB, 0x85, 0x6D, 0xA3, 0x8E, 0x69, 0x10, 0xEE, 0xE1, 0x7F, 0xF2, 0x6E, 0x93, 0x7E, 0x58, 0xB9,
        0x5C, 0x6C, 0xE8, 0xD2, 0x27, 0x4A, 0x8C, 0x84, 0xAD, 0x83, 0x24, 0x14, 0xA1, 0x58, 0x00, 0x59,
        0xB4, 0x60, 0xEB, 0x1C, 0x42, 0xD4, 0xB5, 0x23, 0xD4, 0x39, 0xEF, 0x7D, 0x78, 0xA0, 0x10, 0xA1,
        0x7C, 0xBD, 0xD1, 0xAE, 0x82, 0x76, 0x20, 0x46, 0x20, 0x3F, 0xF3, 0x33, 0x11, 0x83, 0x78, 0x0B,
        0xC0, 0xF7, 0xBC, 0x6A, 0x1D, 0xD8, 0x20, 0xBE, 0x7C, 0xFC, 0x6A, 0x5A, 0x09, 0x17, 0xB9, 0x97
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_80_C_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_C_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_C_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_C_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_C_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_C_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_D_PepperNoiseXORCipher {

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
    // bit0 10010111  11100010  10101000  00010011  10110011  01001011  11010111  10110100  10111111  01101001
    // bit1 11010110  10001000  00100001  01001111  01011110  01001101  01001000  00010011  11100110  00000101
    // bit2 10100101  01111010  00011110  11111001  01110101  11011010  00101011  01011111  11001101  01001101
    // bit3 10010010  01010000  00111110  10001110  00111100  11001110  01011000  10010001  00011001  11111101
    // bit4 10001010  11001011  11110000  01110100  11100110  01100010  01000111  11100101  01101100  10100000
    // bit5 00000001  11001010  11110001  10011010  11000001  00001100  01011101  01001110  01101111  11100111
    // bit6 10011101  01010001  01001011  01101011  11000111  10010001  10111111  11101001  00000110  01100111
    // bit7 01101010  01001000  10111001  10011000  00111101  01111110  11100000  10000110  01111101  10100111
    //
    // Avalanche:
    // bit0 ..XXXX.X  .X..X...  ......X.  X.XXX..X  ...XX..X  XXX....X  .XXXXX.X  ...XXXX.  ...X.X.X  XX....XX
    // bit1 .XXXXX..  ..X...X.  X...X.XX  XXX..X.X  XXXX.X..  XXX..XXX  XXX...X.  X.XXX..X  .X..XX..  X.X.XXXX
    // bit2 XXXX....  ..X.XXXX  .X..X.XX  X.X.XX..  ..X.....  X...XXXX  .XXXXXX.  ....X.X.  X..XX...  ...XX...
    // bit3 XX...XXX  .....X.X  .XX.X.XX  XX.XX.XX  .XX.X..X  X..XX.XX  ....XX.X  XX...X..  .X..XX..  X.X.X...
    // bit4 ..X.....  .XX....X  .X.XX.X.  XX.XXXX.  .X..XX..  XX..X...  XXX.XX.X  .X..XXXX  XX...XX.  ....X.X.
    // bit5 X.X.X.XX  .XX.....  .X.XX.XX  ..XX....  .XX.X.XX  X.X..XX.  XXXX.XXX  XXX..X..  XX...X.X  .X..XX.X
    // bit6 XX..X...  .....X..  ...XXXX.  ..XXXXX.  X..X..X.  XX...X..  XXX.X.X.  X.XXXX..  .X.X..XX  ..XX..X.
    // bit7 ..XXXXXX  ...XXX.X  XXX.XX..  XX..XX.X  .XX.X...  ..X.X.XX  X.XX.X.X  XX.X..XX  ..X.X...  XXXX..X.
    // Avalanche: 49.38%

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

    const std::uint8_t aNoiseBuffer[80] = {
        0xFA, 0x41, 0x21, 0xD2, 0x0B, 0xE2, 0xD9, 0xA6, 0xCC, 0xBF, 0xA0, 0x32, 0x6D, 0x00, 0xAC, 0x0A,
        0x8D, 0x0E, 0xDD, 0x3D, 0xB3, 0x30, 0x32, 0x47, 0x35, 0x6A, 0x2A, 0xAD, 0x77, 0x58, 0xD6, 0xE2,
        0x8E, 0x6E, 0xB9, 0xF1, 0x51, 0x7B, 0xCA, 0xA7, 0x32, 0xF9, 0x09, 0x23, 0xF5, 0x55, 0xB9, 0xC2,
        0x83, 0xDD, 0x23, 0x96, 0x76, 0x8E, 0xAA, 0xAE, 0x9B, 0x2E, 0x8A, 0xF0, 0x26, 0xAD, 0x65, 0x7A,
        0xE0, 0x6D, 0xCD, 0x91, 0xBD, 0xEF, 0xC6, 0xB5, 0x1D, 0xB6, 0x9F, 0x10, 0xB0, 0x77, 0x07, 0xF7
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[80] = {
        0xFA, 0x41, 0x21, 0xD2, 0x0B, 0xE2, 0xD9, 0xA6, 0xCC, 0xBF, 0xA0, 0x32, 0x6D, 0x00, 0xAC, 0x0A,
        0x8D, 0x0E, 0xDD, 0x3D, 0xB3, 0x30, 0x32, 0x47, 0x35, 0x6A, 0x2A, 0xAD, 0x77, 0x58, 0xD6, 0xE2,
        0x8E, 0x6E, 0xB9, 0xF1, 0x51, 0x7B, 0xCA, 0xA7, 0x32, 0xF9, 0x09, 0x23, 0xF5, 0x55, 0xB9, 0xC2,
        0x83, 0xDD, 0x23, 0x96, 0x76, 0x8E, 0xAA, 0xAE, 0x9B, 0x2E, 0x8A, 0xF0, 0x26, 0xAD, 0x65, 0x7A,
        0xE0, 0x6D, 0xCD, 0x91, 0xBD, 0xEF, 0xC6, 0xB5, 0x1D, 0xB6, 0x9F, 0x10, 0xB0, 0x77, 0x07, 0xF7
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_80_D_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_D_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_D_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_D_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_D_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_D_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_E_PepperNoiseXORCipher {

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
    // bit0 01110011  01111001  00010101  10111110  10101011  00101011  00101100  11110110  00001000  11111110
    // bit1 01110111  11000111  11001100  00011010  11000001  10111011  11011010  11111011  00100011  00111010
    // bit2 11111001  11101010  00100100  01000111  11111111  11000110  01101100  01001111  01000110  01000100
    // bit3 10001011  10100011  10011010  01111111  01010010  01000110  11010000  10101001  01100010  10010010
    // bit4 00010001  11001001  01111101  10011011  01011011  11111110  01011110  10001100  11111111  00100101
    // bit5 01101110  00101000  11001000  11110101  11010000  10110100  01101100  11001111  11110010  10110001
    // bit6 10000011  10000000  01000010  11010110  01011100  00101111  01100001  11001000  11100111  01010111
    // bit7 00000111  01110111  11101000  11110000  11110110  01011001  00110100  11101111  10011011  00011101
    //
    // Avalanche:
    // bit0 XX.XX..X  XX.X..XX  X.XXXXXX  ...X.X..  .......X  X......X  X....XX.  .X.XXX..  X.X...X.  .X.X.X..
    // bit1 XX.XXX.X  .XX.XX.X  .XX..XX.  X.XX....  .XX.X.XX  ...X...X  .XXX....  .X.X...X  X...X..X  X..X....
    // bit2 X.X.XX..  X.XXXXXX  .XXX...X  ...X..X.  X.X.X.X.  X..X..XX  ..XXX..X  ...XX.X.  ...X..XX  ...X...X
    // bit3 XX.XXXX.  XXXX.XX.  XX..XXXX  ..X.X.X.  .....XXX  ...X..XX  X....X.X  XXXXXX..  ..XX.XXX  XX...XXX
    // bit4 .X...X..  X..XXX..  ..X.X...  XX..XXX.  ....XXX.  X.X.X.XX  ....X.XX  XX.XX..X  X.X.X.X.  .XXX....
    // bit5 ..XXX.XX  .XXXXX.X  X..XXX.X  X.X.....  X....X.X  XXX....X  ..XXX..X  X..XX.X.  X.X..XXX  XXX..X..
    // bit6 ..X.X..X  ..X.X.X.  XXX.X...  .XXXXX..  XXXX.XX.  X....X.X  XX..X.XX  .XX...X.  .X..XX.X  XXXXXX.X
    // bit7 X.X.XX.X  XX.XXX.X  .X....X.  .X.XX.X.  .X.XXX..  XXXX..XX  X..XXXX.  .X...X.X  ..XX...X  X.XX.XXX
    // Avalanche: 49.84%

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

    const std::uint8_t aNoiseBuffer[80] = {
        0x32, 0xE4, 0xE4, 0xE8, 0x34, 0x45, 0xD7, 0xFB, 0x7A, 0xE9, 0xB5, 0x81, 0xAC, 0x41, 0x71, 0xD9,
        0x55, 0x4F, 0x29, 0x98, 0x5D, 0xE8, 0x12, 0x88, 0x8F, 0x37, 0x95, 0xDF, 0xD8, 0xB6, 0xFA, 0x3C,
        0xE5, 0x7F, 0xA1, 0x3F, 0xAA, 0x23, 0xB9, 0xE8, 0x6C, 0x39, 0xCE, 0x4D, 0xCB, 0x3E, 0xFA, 0xC3,
        0x50, 0x7E, 0xA7, 0x59, 0xEC, 0xAD, 0x48, 0x02, 0xDF, 0xE7, 0xD1, 0xC0, 0x7F, 0xAD, 0xE5, 0x75,
        0x0F, 0x3E, 0x5E, 0x0D, 0x89, 0x2A, 0x7F, 0x4B, 0x94, 0xA2, 0xCC, 0xD7, 0xC1, 0xAB, 0xD2, 0x0F
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[80] = {
        0x32, 0xE4, 0xE4, 0xE8, 0x34, 0x45, 0xD7, 0xFB, 0x7A, 0xE9, 0xB5, 0x81, 0xAC, 0x41, 0x71, 0xD9,
        0x55, 0x4F, 0x29, 0x98, 0x5D, 0xE8, 0x12, 0x88, 0x8F, 0x37, 0x95, 0xDF, 0xD8, 0xB6, 0xFA, 0x3C,
        0xE5, 0x7F, 0xA1, 0x3F, 0xAA, 0x23, 0xB9, 0xE8, 0x6C, 0x39, 0xCE, 0x4D, 0xCB, 0x3E, 0xFA, 0xC3,
        0x50, 0x7E, 0xA7, 0x59, 0xEC, 0xAD, 0x48, 0x02, 0xDF, 0xE7, 0xD1, 0xC0, 0x7F, 0xAD, 0xE5, 0x75,
        0x0F, 0x3E, 0x5E, 0x0D, 0x89, 0x2A, 0x7F, 0x4B, 0x94, 0xA2, 0xCC, 0xD7, 0xC1, 0xAB, 0xD2, 0x0F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_80_E_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_E_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_E_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_E_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_E_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_E_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_F_PepperNoiseXORCipher {

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
    // bit0 00000001  01100111  10000001  11110000  10000000  01100001  11111111  11101001  00011001  11101010
    // bit1 10100001  00010001  10011010  00110111  00110011  10101101  00101101  11111010  01001000  11101111
    // bit2 11001100  11111111  01011010  11001000  11001101  00011111  00001100  01000001  00111010  10011000
    // bit3 01101101  00111001  11111101  11001100  01110101  01000000  00110011  01000111  10000010  00100000
    // bit4 10111110  11010110  10011110  00000110  01100011  00101111  01001011  01110011  10000110  01001011
    // bit5 00101000  01100100  11110010  00010111  00100111  10100101  00100110  01110110  10110100  11110001
    // bit6 00101100  01111101  01100100  01100110  01010000  11101100  01100111  11110100  10110111  01011111
    // bit7 01111110  10100011  01101111  11111000  01100110  11001010  01011000  00000001  01111010  11110001
    //
    // Avalanche:
    // bit0 X.X.X.XX  XX..XX.X  ..X.X.XX  .X.XX.X.  ..X.X.X.  XX..X.XX  .X.X.X.X  .X....XX  X.XX..XX  .X......
    // bit1 XXXX.X..  .X...X..  XX..XXXX  .XX...X.  .XX..XX.  XXXXX...  .XXXX...  X.X.XXXX  ...XXX.X  X.XXX.X.
    // bit2 .XX..XX.  .X.X.X.X  XXXX....  .XX...X.  .XX..XXX  X.XX.X.X  X.X..XX.  XXX.X.XX  X..X....  ..XX..X.
    // bit3 ..XXX...  .XX.XX..  X.X.X...  X..XX..X  ..X.....  ...X.X.X  .XX..XX.  ...X..X.  XX.X.XXX  .XXX.X.X
    // bit4 ...X.X..  .XXXXX..  ..XX.X..  X.X.XX..  XX..X..X  X....X.X  XXX....X  XX.XX..X  ..X.XX..  XXX....X
    // bit5 .XXXXX.X  ..XX...X  X.X..XXX  .X....X.  .XXX..X.  XXXX....  .XXX..XX  ..X...XX  XXX....X  X.X..X..
    // bit6 X....XX.  XX.X.XXX  XX..XXX.  XX..XX..  XXXXX.X.  .X...XX.  XX..XX.X  .X.XXXX.  ...XXX.X  XXXX.X.X
    // bit7 ..X.X.XX  XXXX.XX.  ..XXX.X.  X.X.XX.X  ..XX..XX  X..XXXXX  ....XX.X  .X.X.X..  ..X.XXXX  X.X..X..
    // Avalanche: 50.62%

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

    const std::uint8_t aNoiseBuffer[80] = {
        0x68, 0x31, 0x5F, 0x09, 0x3F, 0x3B, 0x09, 0xD0, 0x29, 0xAE, 0xB7, 0x7A, 0x32, 0xAE, 0xA9, 0xF3,
        0xDC, 0x37, 0x17, 0x7C, 0x79, 0x1B, 0x6D, 0x91, 0xB1, 0xB3, 0xC3, 0xC5, 0x31, 0x5E, 0x4E, 0x44,
        0xA0, 0x3B, 0x5D, 0x52, 0x20, 0x35, 0x4D, 0x7C, 0x47, 0x93, 0xCE, 0x20, 0x6B, 0x6E, 0x29, 0xEC,
        0x80, 0x8B, 0xD6, 0x91, 0xE9, 0xE6, 0x9E, 0xDA, 0xC2, 0xFE, 0xCE, 0x4E, 0xC0, 0x16, 0x5C, 0xB9,
        0x1E, 0x41, 0x27, 0xA7, 0xE1, 0x0E, 0x3B, 0x82, 0xE5, 0xCF, 0xD5, 0x27, 0xEA, 0x42, 0xCA, 0x4F
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[80] = {
        0x68, 0x31, 0x5F, 0x09, 0x3F, 0x3B, 0x09, 0xD0, 0x29, 0xAE, 0xB7, 0x7A, 0x32, 0xAE, 0xA9, 0xF3,
        0xDC, 0x37, 0x17, 0x7C, 0x79, 0x1B, 0x6D, 0x91, 0xB1, 0xB3, 0xC3, 0xC5, 0x31, 0x5E, 0x4E, 0x44,
        0xA0, 0x3B, 0x5D, 0x52, 0x20, 0x35, 0x4D, 0x7C, 0x47, 0x93, 0xCE, 0x20, 0x6B, 0x6E, 0x29, 0xEC,
        0x80, 0x8B, 0xD6, 0x91, 0xE9, 0xE6, 0x9E, 0xDA, 0xC2, 0xFE, 0xCE, 0x4E, 0xC0, 0x16, 0x5C, 0xB9,
        0x1E, 0x41, 0x27, 0xA7, 0xE1, 0x0E, 0x3B, 0x82, 0xE5, 0xCF, 0xD5, 0x27, 0xEA, 0x42, 0xCA, 0x4F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_80_F_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_F_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_F_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_F_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_F_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_80_F_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_A_PepperNoiseXORCipher {

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
    // bit0 01110111  11011111  00010101  01111101  01010000  00000100  11110110  10111100  11000101  11000010  10111110  01101001
    // bit1 11111111  01011010  00101001  00011000  01000011  00011001  11000001  10001111  01101011  01111110  01011101  10110001
    // bit2 01101111  00100011  10000101  01001110  00000101  01010110  11001101  00000000  11111111  11111110  01100010  00101100
    // bit3 01010001  00001100  10100011  11111100  11111000  10001101  01000001  01111101  10000111  11011001  00011001  01101111
    // bit4 11000100  00001111  11110111  10010111  01111110  10001011  00111101  10001110  00100101  10011011  00111111  00011000
    // bit5 01101100  00011101  11100100  00101010  11111010  01001000  10010000  00101110  10000011  01101101  01110110  10101001
    // bit6 11011000  11000011  10100110  11010000  01001000  10110011  01001101  10111001  10000001  00110011  10111110  00001111
    // bit7 10110001  11100011  10101111  01011100  01011000  11001000  00000101  00111111  00010110  01000110  10110010  11010000
    //
    // Avalanche:
    // bit0 .XXX.XXX  XX.XXXXX  ...X.X.X  .XXXXX.X  .X.X....  .....X..  XXXX.XX.  X.XXXX..  XX...X.X  XX....X.  X.XXXXX.  .XX.X..X
    // bit1 XXXXXXXX  .X.XX.X.  ..X.X..X  ...XX...  .X....XX  ...XX..X  XX.....X  X...XXXX  .XX.X.XX  .XXXXXX.  .X.XXX.X  X.XX...X
    // bit2 .XX.XXXX  ..X...XX  X....X.X  .X..XXX.  .....X.X  .X.X.XX.  XX..XX.X  ........  XXXXXXXX  XXXXXXX.  .XX...X.  ..X.XX..
    // bit3 .X.X...X  ....XX..  X.X...XX  XXXXXX..  XXXXX...  X...XX.X  .X.....X  .XXXXX.X  X....XXX  XX.XX..X  ...XX..X  .XX.XXXX
    // bit4 XX...X..  ....XXXX  XXXX.XXX  X..X.XXX  .XXXXXX.  X...X.XX  ..XXXX.X  X...XXX.  ..X..X.X  X..XX.XX  ..XXXXXX  ...XX...
    // bit5 .XX.XX..  ...XXX.X  XXX..X..  ..X.X.X.  XXXXX.X.  .X..X...  X..X....  ..X.XXX.  X.....XX  .XX.XX.X  .XXX.XX.  X.X.X..X
    // bit6 XX.XX...  XX....XX  X.X..XX.  XX.X....  .X..X...  X.XX..XX  .X..XX.X  X.XXX..X  X......X  ..XX..XX  X.XXXXX.  ....XXXX
    // bit7 X.XX...X  XXX...XX  X.X.XXXX  .X.XXX..  .X.XX...  XX..X...  .....X.X  ..XXXXXX  ...X.XX.  .X...XX.  X.XX..X.  XX.X....
    // Avalanche: 51.43%

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

    const std::uint8_t aNoiseBuffer[96] = {
        0x4B, 0xFE, 0xE5, 0xD3, 0x66, 0xEC, 0xE0, 0xF1, 0x83, 0xC3, 0x21, 0xC4, 0xDC, 0x9C, 0xEB, 0xAF,
        0x3F, 0x0C, 0x5F, 0x88, 0x41, 0xAF, 0x1B, 0xF9, 0x1A, 0xB3, 0x94, 0xDB, 0xF5, 0xB9, 0x2C, 0x88,
        0x14, 0xDF, 0x1C, 0x9D, 0x1F, 0x28, 0x4C, 0x60, 0x1B, 0x25, 0x02, 0x62, 0x5D, 0xB0, 0x2A, 0x5A,
        0xE4, 0xF2, 0x88, 0x8C, 0x2A, 0xAB, 0x80, 0x7B, 0xCA, 0x10, 0x97, 0x93, 0xDF, 0xDD, 0x4D, 0x53,
        0xB6, 0xE0, 0x68, 0x21, 0x60, 0xB9, 0x75, 0xFE, 0xB8, 0xF5, 0x66, 0x7A, 0x7C, 0x65, 0xEB, 0x1E,
        0x83, 0x64, 0xAF, 0xDF, 0xDA, 0xCE, 0xAF, 0x58, 0x45, 0x91, 0xF4, 0x49, 0xBE, 0x32, 0x12, 0xD6
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[96] = {
        0x4B, 0xFE, 0xE5, 0xD3, 0x66, 0xEC, 0xE0, 0xF1, 0x83, 0xC3, 0x21, 0xC4, 0xDC, 0x9C, 0xEB, 0xAF,
        0x3F, 0x0C, 0x5F, 0x88, 0x41, 0xAF, 0x1B, 0xF9, 0x1A, 0xB3, 0x94, 0xDB, 0xF5, 0xB9, 0x2C, 0x88,
        0x14, 0xDF, 0x1C, 0x9D, 0x1F, 0x28, 0x4C, 0x60, 0x1B, 0x25, 0x02, 0x62, 0x5D, 0xB0, 0x2A, 0x5A,
        0xE4, 0xF2, 0x88, 0x8C, 0x2A, 0xAB, 0x80, 0x7B, 0xCA, 0x10, 0x97, 0x93, 0xDF, 0xDD, 0x4D, 0x53,
        0xB6, 0xE0, 0x68, 0x21, 0x60, 0xB9, 0x75, 0xFE, 0xB8, 0xF5, 0x66, 0x7A, 0x7C, 0x65, 0xEB, 0x1E,
        0x83, 0x64, 0xAF, 0xDF, 0xDA, 0xCE, 0xAF, 0x58, 0x45, 0x91, 0xF4, 0x49, 0xBE, 0x32, 0x12, 0xD6
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_A_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_A_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_A_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_A_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_A_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_A_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_B_PepperNoiseXORCipher {

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
    // bit0 11110100  01011101  01010011  10010111  00101101  00010100  11010001  01110101  00101010  11101111  10001011  10111001
    // bit1 11111011  00101001  00111101  01110000  01001110  11110011  01111000  00110100  00000110  10110100  00011111  01010011
    // bit2 11011110  11011011  11101010  01001011  01000110  01101110  10100001  10001111  10101111  01101100  10011100  10011111
    // bit3 10000101  00111101  01001110  11000110  11100000  01010101  11100110  10010001  11110111  00000111  11000011  11100011
    // bit4 11011011  01011010  00101100  11100000  01100100  00000101  00011011  11010110  01001100  10001001  00100111  00101000
    // bit5 11001010  01110011  10100001  11110100  11001000  01010110  11010110  00000000  10100000  00011111  10100001  11110100
    // bit6 00000100  11010000  10100110  00001000  10000111  10100101  01111101  00110011  00001100  00110011  00101000  00101001
    // bit7 00101010  10011100  00111111  10101011  00011011  11111011  11110010  11110011  11100011  01001111  10011100  10111111
    //
    // Avalanche:
    // bit0 ....X.XX  X.X...X.  X.X.XX..  .XX.X...  XX.X..X.  XXX.X.XX  ..X.XXX.  X...X.X.  XX.X.X.X  ...X....  .XXX.X..  .X...XX.
    // bit1 .....X..  XX.X.XX.  XX....X.  X...XXXX  X.XX...X  ....XX..  X....XXX  XX..X.XX  XXXXX..X  .X..X.XX  XXX.....  X.X.XX..
    // bit2 ..X....X  ..X..X..  ...X.X.X  X.XX.X..  X.XXX..X  X..X...X  .X.XXXX.  .XXX....  .X.X....  X..X..XX  .XX...XX  .XX.....
    // bit3 .XXXX.X.  XX....X.  X.XX...X  ..XXX..X  ...XXXXX  X.X.X.X.  ...XX..X  .XX.XXX.  ....X...  XXXXX...  ..XXXX..  ...XXX..
    // bit4 ..X..X..  X.X..X.X  XX.X..XX  ...XXXXX  X..XX.XX  XXXXX.X.  XXX..X..  ..X.X..X  X.XX..XX  .XXX.XX.  XX.XX...  XX.X.XXX
    // bit5 ..XX.X.X  X...XX..  .X.XXXX.  ....X.XX  ..XX.XXX  X.X.X..X  ..X.X..X  XXXXXXXX  .X.XXXXX  XXX.....  .X.XXXX.  ....X.XX
    // bit6 XXXXX.XX  ..X.XXXX  .X.XX..X  XXXX.XXX  .XXXX...  .X.XX.X.  X.....X.  XX..XX..  XXXX..XX  XX..XX..  XX.X.XXX  XX.X.XX.
    // bit7 XX.X.X.X  .XX...XX  XX......  .X.X.X..  XXX..X..  .....X..  ....XX.X  ....XX..  ...XXX..  X.XX....  .XX...XX  .X......
    // Avalanche: 48.57%

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

    const std::uint8_t aNoiseBuffer[96] = {
        0xFC, 0xEC, 0xC1, 0xE8, 0x6D, 0xB2, 0x6D, 0x58, 0x23, 0xAE, 0x54, 0xBF, 0xF9, 0x91, 0x2C, 0xF4,
        0x26, 0xB0, 0x6F, 0xC1, 0x79, 0x5B, 0xB3, 0xC5, 0x9D, 0x7C, 0x4D, 0xC4, 0x23, 0x94, 0xB1, 0xA1,
        0x16, 0x7C, 0x98, 0x01, 0xC5, 0xEA, 0x63, 0x83, 0x43, 0x75, 0x63, 0xD5, 0x21, 0xBE, 0x65, 0x5B,
        0xB5, 0xD7, 0x73, 0xCF, 0x4A, 0x16, 0x1D, 0xAA, 0x39, 0x89, 0xC3, 0xDB, 0x20, 0xE8, 0x2B, 0xB3,
        0x35, 0x19, 0xB5, 0x10, 0xAA, 0x7A, 0xF1, 0x31, 0xC8, 0xA1, 0xE2, 0x46, 0xAD, 0xF5, 0x97, 0x9F,
        0xB5, 0x10, 0x0E, 0x61, 0xE3, 0x69, 0xD8, 0xDC, 0xB5, 0x54, 0x9F, 0xE5, 0xAB, 0x25, 0x71, 0xF3
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[96] = {
        0xFC, 0xEC, 0xC1, 0xE8, 0x6D, 0xB2, 0x6D, 0x58, 0x23, 0xAE, 0x54, 0xBF, 0xF9, 0x91, 0x2C, 0xF4,
        0x26, 0xB0, 0x6F, 0xC1, 0x79, 0x5B, 0xB3, 0xC5, 0x9D, 0x7C, 0x4D, 0xC4, 0x23, 0x94, 0xB1, 0xA1,
        0x16, 0x7C, 0x98, 0x01, 0xC5, 0xEA, 0x63, 0x83, 0x43, 0x75, 0x63, 0xD5, 0x21, 0xBE, 0x65, 0x5B,
        0xB5, 0xD7, 0x73, 0xCF, 0x4A, 0x16, 0x1D, 0xAA, 0x39, 0x89, 0xC3, 0xDB, 0x20, 0xE8, 0x2B, 0xB3,
        0x35, 0x19, 0xB5, 0x10, 0xAA, 0x7A, 0xF1, 0x31, 0xC8, 0xA1, 0xE2, 0x46, 0xAD, 0xF5, 0x97, 0x9F,
        0xB5, 0x10, 0x0E, 0x61, 0xE3, 0x69, 0xD8, 0xDC, 0xB5, 0x54, 0x9F, 0xE5, 0xAB, 0x25, 0x71, 0xF3
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_B_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_B_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_B_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_B_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_B_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_B_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_C_PepperNoiseXORCipher {

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
    // bit0 11101000  01101110  01101101  11011111  00111011  10111110  10011111  10011111  11110011  00111010  00100011  00011010
    // bit1 10010111  11001111  10110011  10101111  11010011  01010001  00110010  00101101  11110110  11100110  00101101  00000101
    // bit2 11011000  11110011  01101110  11011000  10100110  00100001  11111001  00101010  11111100  11111101  00111110  00111001
    // bit3 01010101  00001111  00011110  00010111  01001001  10101001  10111011  10100110  01001101  10111000  10100001  10101010
    // bit4 11110000  00010001  11111000  00000000  10001110  00110110  00011100  10001110  10111111  01100001  01101000  10000011
    // bit5 11001000  10011100  01011001  10110010  01101010  01010111  00101000  10101101  01110110  10100100  10111100  10110111
    // bit6 10001111  11000101  01011111  11011001  00000100  10110110  10000011  00001100  00010101  10010100  01001001  01101101
    // bit7 11010101  01000111  00110101  11101110  01110001  00100001  01000001  10001011  10101011  00011001  11100010  11111000
    //
    // Avalanche:
    // bit0 .X....X.  XX...X..  XX...XXX  .XXX.X.X  X..X...X  ...X.X..  ..XX.X.X  ..XX.X.X  .X.XX..X  X..X....  X...X..X  X.XX....
    // bit1 ..XXXX.X  .XX..X.X  ...XX..X  .....X.X  .XXXX..X  XXXXX.XX  X..XX...  X....XXX  .X.XXX..  .X..XX..  X....XXX  X.X.XXXX
    // bit2 .XXX..X.  .X.XX..X  XX...X..  .XXX..X.  ....XX..  X...X.XX  .X.X..XX  X.......  .X.X.XX.  .X.X.XXX  X..X.X..  X..X..XX
    // bit3 XXXXXXXX  X.X..X.X  X.XX.X..  X.XXXX.X  XXX...XX  ......XX  ...X...X  ....XX..  XXX..XXX  ...X..X.  ....X.XX  ........
    // bit4 X.X..X.X  .X...X..  X.X.XX.X  .X.X.X.X  XX.XX.XX  .XX...XX  .X..X..X  XX.XX.XX  XXX.X.X.  ..XX.X..  ..XXXX.X  XX.X.XX.
    // bit5 X..XXX.X  XX..X..X  ....XX..  XXX..XXX  ..XXXXXX  ......X.  .XXXXX.X  XXXXX...  ..X...XX  XXXX...X  XXX.X..X  XXX...X.
    // bit6 XX.XX.X.  X..X....  ....X.X.  X...XX..  .X.X...X  XXX...XX  XX.X.XX.  .X.XX..X  .X......  XX.....X  ...XXX..  ..XXX...
    // bit7 X.......  ...X..X.  .XX.....  X.XXX.XX  ..X..X..  .XXX.X..  ...X.X..  XX.XXXX.  XXXXXXX.  .X..XX..  X.XX.XXX  X.X.XX.X
    // Avalanche: 47.53%

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

    const std::uint8_t aNoiseBuffer[96] = {
        0xEF, 0xBD, 0x88, 0x79, 0xA6, 0x53, 0x42, 0x53, 0x66, 0xE3, 0xA0, 0x2C, 0xD4, 0xD7, 0xF1, 0x7B,
        0x48, 0xAE, 0xE9, 0x5F, 0xBE, 0xB3, 0x72, 0xC7, 0xE7, 0xA3, 0x45, 0xB6, 0xE3, 0xD1, 0xD5, 0xD2,
        0x68, 0x55, 0xA5, 0xC1, 0x9C, 0x2A, 0xEC, 0xD1, 0x92, 0x44, 0xBB, 0xCE, 0x90, 0x8E, 0x8E, 0x75,
        0xB2, 0x21, 0x74, 0xF8, 0xBC, 0x88, 0xD2, 0xB3, 0x9D, 0x00, 0x74, 0x80, 0xEF, 0xDE, 0xB9, 0xC5,
        0xE9, 0xF4, 0xED, 0xEE, 0x39, 0x7E, 0xCD, 0x9B, 0x76, 0x68, 0xFC, 0xB3, 0xB1, 0x66, 0xC0, 0x29,
        0x15, 0x0B, 0xFD, 0x24, 0x6E, 0x64, 0xA1, 0xD2, 0x1D, 0x03, 0x37, 0xA5, 0xB3, 0x46, 0x9C, 0x6E
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[96] = {
        0xEF, 0xBD, 0x88, 0x79, 0xA6, 0x53, 0x42, 0x53, 0x66, 0xE3, 0xA0, 0x2C, 0xD4, 0xD7, 0xF1, 0x7B,
        0x48, 0xAE, 0xE9, 0x5F, 0xBE, 0xB3, 0x72, 0xC7, 0xE7, 0xA3, 0x45, 0xB6, 0xE3, 0xD1, 0xD5, 0xD2,
        0x68, 0x55, 0xA5, 0xC1, 0x9C, 0x2A, 0xEC, 0xD1, 0x92, 0x44, 0xBB, 0xCE, 0x90, 0x8E, 0x8E, 0x75,
        0xB2, 0x21, 0x74, 0xF8, 0xBC, 0x88, 0xD2, 0xB3, 0x9D, 0x00, 0x74, 0x80, 0xEF, 0xDE, 0xB9, 0xC5,
        0xE9, 0xF4, 0xED, 0xEE, 0x39, 0x7E, 0xCD, 0x9B, 0x76, 0x68, 0xFC, 0xB3, 0xB1, 0x66, 0xC0, 0x29,
        0x15, 0x0B, 0xFD, 0x24, 0x6E, 0x64, 0xA1, 0xD2, 0x1D, 0x03, 0x37, 0xA5, 0xB3, 0x46, 0x9C, 0x6E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_C_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_C_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_C_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_C_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_C_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_C_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_D_PepperNoiseXORCipher {

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
    // bit0 10001001  11100110  01001000  10101011  00101101  11111101  00000111  00111000  11111001  01100111  00110000  00011100
    // bit1 00000100  11001000  00101001  01111011  10110001  10001001  11101000  01110101  01101011  01001000  01101001  01100000
    // bit2 00110110  01100100  00000011  11000011  11011011  10101011  01100011  11010111  00100111  10101111  00110011  11101110
    // bit3 01000011  11010100  10110000  10010110  11110000  01111101  11010110  10010110  00100011  10110000  00001011  00111001
    // bit4 00010001  00001100  11100111  10101011  10001011  11100101  01111010  10010001  11010001  11111000  01011001  10111001
    // bit5 10101010  00000100  11110111  10010011  11011101  11111001  10000101  00111110  11100110  01111110  10001101  01101110
    // bit6 11101101  11110110  00100110  10010000  01101110  01001101  10010110  00111101  10110100  00111101  00000111  01011110
    // bit7 11101100  11000000  01010111  01000001  01000010  10001001  00101011  10101000  10100100  11110011  00011010  10010011
    //
    // Avalanche:
    // bit0 ..X...XX  .X..XX..  XXX...X.  .......X  X....XXX  .X.X.XXX  X.X.XX.X  X..X..X.  .X.X..XX  XX..XX.X  X..XX.X.  X.XX.XX.
    // bit1 X.X.XXX.  .XX...X.  X.....XX  XX.X...X  ...XX.XX  ..X...XX  .X....X.  XX.XXXXX  XX.....X  XXX...X.  XX....XX  XX..X.X.
    // bit2 .XX...XX  ..XX...X  .X.X.XX.  X..X.XX.  X...XXX.  XXXXXXX.  ..XX.XX.  X.....X.  .XXX..X.  XXXXX.X.  .XX..XX.  X.XXX.XX
    // bit3 ...X.XX.  X......X  XXX..X.X  XX....XX  X.X..X.X  ..X.X...  X.....XX  XX....XX  .XXX.XX.  XXX..X.X  .X.XXXX.  .XX.XX..
    // bit4 X.XXX.XX  X.X..XX.  .X..XX.X  .......X  ..X....X  .X..XXXX  XX.X....  ..XXX.XX  .XXXX.XX  .X.X..X.  XXXX..XX  ...X..XX
    // bit5 ........  X.X.XXX.  .X.XXX.X  ..XXX..X  .XXX.XXX  .X.X..XX  ..X.XXXX  X..X.X..  .X..XX..  XX.X.X..  ..X..XXX  XX...X..
    // bit6 X.XXX...  X.X...XX  .XXX..XX  XX...X.X  ..XXX.XX  ...XX...  XX....XX  .XX.X...  XXX....X  .XX.X...  .X.X..X.  ....X.XX
    // bit7 X.XXX..X  X..X.X.X  ......X.  ...X.X..  ...X.XXX  XX.XXX..  .XXXXXX.  XXXXXX.X  XXXX...X  X.X..XX.  .X..XXXX  XX...XX.
    // Avalanche: 49.48%

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

    const std::uint8_t aNoiseBuffer[96] = {
        0x87, 0x13, 0x27, 0x28, 0x87, 0x63, 0x34, 0x9A, 0xD3, 0xF3, 0xA2, 0x12, 0x48, 0xBE, 0x82, 0x00,
        0x1C, 0x8D, 0x5E, 0x15, 0xC0, 0x0F, 0x2F, 0x6D, 0xBE, 0x61, 0xC8, 0x56, 0xC8, 0x10, 0xFC, 0xED,
        0x7C, 0x37, 0xD2, 0x74, 0xAE, 0x86, 0x2B, 0xEC, 0xED, 0x9E, 0xBC, 0x94, 0xF7, 0x9A, 0x20, 0xFF,
        0x56, 0x78, 0x69, 0x1A, 0x49, 0x96, 0xBB, 0xA5, 0x39, 0x60, 0xC7, 0xFE, 0x87, 0x76, 0x34, 0x6A,
        0x8F, 0xCC, 0xF7, 0x8A, 0xC0, 0x27, 0x74, 0xF8, 0x39, 0xCD, 0xBF, 0x1F, 0x6E, 0xA6, 0xA5, 0xA3,
        0x04, 0x48, 0xE0, 0xA9, 0x5D, 0x06, 0x33, 0x7E, 0x29, 0x66, 0x7C, 0x9B, 0xBE, 0xA6, 0x27, 0x19
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[96] = {
        0x87, 0x13, 0x27, 0x28, 0x87, 0x63, 0x34, 0x9A, 0xD3, 0xF3, 0xA2, 0x12, 0x48, 0xBE, 0x82, 0x00,
        0x1C, 0x8D, 0x5E, 0x15, 0xC0, 0x0F, 0x2F, 0x6D, 0xBE, 0x61, 0xC8, 0x56, 0xC8, 0x10, 0xFC, 0xED,
        0x7C, 0x37, 0xD2, 0x74, 0xAE, 0x86, 0x2B, 0xEC, 0xED, 0x9E, 0xBC, 0x94, 0xF7, 0x9A, 0x20, 0xFF,
        0x56, 0x78, 0x69, 0x1A, 0x49, 0x96, 0xBB, 0xA5, 0x39, 0x60, 0xC7, 0xFE, 0x87, 0x76, 0x34, 0x6A,
        0x8F, 0xCC, 0xF7, 0x8A, 0xC0, 0x27, 0x74, 0xF8, 0x39, 0xCD, 0xBF, 0x1F, 0x6E, 0xA6, 0xA5, 0xA3,
        0x04, 0x48, 0xE0, 0xA9, 0x5D, 0x06, 0x33, 0x7E, 0x29, 0x66, 0x7C, 0x9B, 0xBE, 0xA6, 0x27, 0x19
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_D_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_D_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_D_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_D_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_D_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_D_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_E_PepperNoiseXORCipher {

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
    // bit0 01110001  01011000  10011011  10010110  10111110  11110111  10111100  10010001  10011000  00101110  10001110  00110000
    // bit1 00011001  11111100  01011100  11000110  11000011  10100010  01010001  01011000  00111001  11000110  00010101  11000110
    // bit2 11110101  11100001  00011001  01001001  11101011  10101011  00100000  11100011  00101101  00111111  00011100  11000000
    // bit3 01001000  01011111  00101111  11000101  10000000  00011110  10101001  10100101  01111001  01110001  01100110  10110110
    // bit4 10100111  01000001  10000001  01100000  01101111  01001101  01101100  01010100  10110000  01011000  10111111  00001011
    // bit5 00101111  10110001  01100010  00100100  10100010  00010110  11011001  00101100  01101110  01011010  01111110  11000110
    // bit6 00010100  01001010  01001011  01101010  01100000  11001000  10011101  10110110  11101111  01110111  10110100  01011000
    // bit7 11010111  11010110  10100111  00010000  10100111  00001010  01111010  01110010  01110011  11000111  01110100  01111111
    //
    // Avalanche:
    // bit0 XX.XX.XX  XXXX..X.  ..XX...X  ..XXXX..  ...X.X..  .X.XXX.X  ...X.XX.  ..XXX.XX  ..XX..X.  X....X..  ..X..X..  X..XX.X.
    // bit1 X.XX..XX  .X.X.XX.  XXXX.XX.  .XX.XX..  .XX.X..X  ....X...  XXXXX.XX  XXXX..X.  X..X..XX  .XX.XX..  X.XXXXXX  .XX.XX..
    // bit2 X.X.....  X.XX.X..  .X..XX..  ...XXX..  X.XXXXX.  XXXXXXX.  .XXX.X.X  X.XX.XX.  .XXXX...  .XX.X.X.  .X..X..X  X..X.X.X
    // bit3 ...XXX.X  ....X.X.  .XXXX.X.  X..X....  XX.X.X.X  .X..X.XX  XXXXXX..  XXXX....  ..X.XX..  ..X..X..  ..XX..XX  XXX...XX
    // bit4 XXXX..X.  ...X.X..  XX.X.X..  ..XX.X.X  ..XXX.X.  ...XX...  ..XXX..X  .......X  XXX..X.X  ....XX.X  XXX.X.X.  .X.XXXX.
    // bit5 .XXXX.X.  XXX..X..  ..XX.XXX  .XXX...X  XXXX.XXX  .X....XX  X...XX..  .XXXX..X  ..XXX.XX  ....XXXX  ..X.X.XX  X..X..XX
    // bit6 X.XXXXX.  XXX.....  XXX....X  XX......  XX..X.X.  .XX...X.  ..XX.XXX  ...XXX..  .X...X.X  XX.XXX.X  ...XXXX.  XXXX..X.
    // bit7 .XXXXX.X  .XXXXX..  ....XX.X  X.XXX.X.  ....XX.X  X.X.....  XX.X....  XX.XX...  XX.XX..X  .XX.XX.X  XX.XXXX.  XX.X.X.X
    // Avalanche: 51.04%

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

    const std::uint8_t aNoiseBuffer[96] = {
        0x29, 0xB1, 0xAC, 0xE3, 0x54, 0x2F, 0x0D, 0xED, 0x65, 0xFB, 0x64, 0xD5, 0xD2, 0x51, 0x13, 0x3C,
        0x89, 0x46, 0x15, 0xE0, 0xF2, 0x51, 0x97, 0xBB, 0xD0, 0x7A, 0x0E, 0x81, 0x22, 0xD4, 0xC2, 0x30,
        0xF5, 0x6A, 0xAF, 0x80, 0xA8, 0x89, 0xED, 0x69, 0xE2, 0x8A, 0xE0, 0x94, 0x3B, 0x9C, 0xF5, 0xA8,
        0x96, 0x4D, 0xB9, 0xC7, 0x9F, 0x8A, 0x01, 0x56, 0xB2, 0x69, 0x37, 0xCB, 0x44, 0x1E, 0x23, 0xB0,
        0x8A, 0x17, 0x7F, 0xD9, 0xF6, 0x26, 0x07, 0x73, 0x41, 0x5F, 0xB2, 0x3E, 0xAC, 0xE3, 0xE7, 0x33,
        0x8A, 0x15, 0x1F, 0x6F, 0xAC, 0xFF, 0x9C, 0x48, 0x74, 0x67, 0x91, 0x93, 0x0B, 0x55, 0x5D, 0x09
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[96] = {
        0x29, 0xB1, 0xAC, 0xE3, 0x54, 0x2F, 0x0D, 0xED, 0x65, 0xFB, 0x64, 0xD5, 0xD2, 0x51, 0x13, 0x3C,
        0x89, 0x46, 0x15, 0xE0, 0xF2, 0x51, 0x97, 0xBB, 0xD0, 0x7A, 0x0E, 0x81, 0x22, 0xD4, 0xC2, 0x30,
        0xF5, 0x6A, 0xAF, 0x80, 0xA8, 0x89, 0xED, 0x69, 0xE2, 0x8A, 0xE0, 0x94, 0x3B, 0x9C, 0xF5, 0xA8,
        0x96, 0x4D, 0xB9, 0xC7, 0x9F, 0x8A, 0x01, 0x56, 0xB2, 0x69, 0x37, 0xCB, 0x44, 0x1E, 0x23, 0xB0,
        0x8A, 0x17, 0x7F, 0xD9, 0xF6, 0x26, 0x07, 0x73, 0x41, 0x5F, 0xB2, 0x3E, 0xAC, 0xE3, 0xE7, 0x33,
        0x8A, 0x15, 0x1F, 0x6F, 0xAC, 0xFF, 0x9C, 0x48, 0x74, 0x67, 0x91, 0x93, 0x0B, 0x55, 0x5D, 0x09
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_E_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_E_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_E_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_E_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_E_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_E_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_F_PepperNoiseXORCipher {

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
    // bit0 11011101  00110101  10001000  00000011  00101010  10111100  01001111  01001111  11101111  00010111  11010111  00110101
    // bit1 10111111  00000100  00111101  01010010  00101001  10111111  01001000  11110000  00111000  01000101  01100000  10000011
    // bit2 11001101  10000000  01011001  01100010  11100111  01110101  01011000  10011110  11010000  01110110  00101011  00001011
    // bit3 01100100  10101010  01101010  01110010  01101000  11010011  10001101  00100011  00111001  00010000  01001001  00101111
    // bit4 01000111  10101000  10111010  11010110  11011110  11110101  01111101  11000111  00000010  11001101  01111010  01011011
    // bit5 00111011  01010001  11101010  01100001  10001101  00010100  10110110  01011010  10010001  11110101  11101001  00100000
    // bit6 01101101  00111100  11101011  01010011  11001010  11010101  11110111  10000011  10001010  00011110  11011001  11101100
    // bit7 11010001  01111001  11101100  10100010  11001000  10111110  00011110  11101110  01010010  00111000  01010110  00010100
    //
    // Avalanche:
    // bit0 .XXX.XXX  X..XXXXX  ..X...X.  X.X.X..X  X.......  ...X.XX.  XXX..X.X  XXX..X.X  .X...X.X  X.XXXX.X  .XXXXX.X  X..XXXXX
    // bit1 XXX.X.X.  .X.X...X  .XX.X...  .....XXX  .XXXXX..  XXX.X.X.  ...XXX.X  X.X..X.X  .XX.XX.X  ...X....  ..XX.X.X  XX.X.XX.
    // bit2 .XX..XXX  ..X.X.X.  XXXX..XX  XX..X...  .X..XX.X  XX.XXXXX  XXXX..X.  ..XX.X..  .XXXX.X.  XX.XXX..  X......X  X.X....X
    // bit3 ..XX...X  XXXXXXXX  ..XXXXXX  ..X..XXX  ..XXXX.X  X....XX.  XX.XX...  .XXX.XX.  .XX.XX..  .X...X.X  ...XXX..  .XXXX.X.
    // bit4 XXX.XX.X  ......X.  ...X....  .XXXXX..  .XXX.X..  .X.XXXXX  XX.X.XXX  .XX.XX.X  X.X.X...  .XX..XXX  XX.X....  XXXX...X
    // bit5 .XX.XXX.  .....X..  X.XXXXXX  ..XX.X..  XX.XX...  .X.....X  XXX...XX  ....XXXX  XX...X..  X.X.....  X.XXXX..  .XXX.X.X
    // bit6 XX...XXX  X..X.XX.  .X.....X  XXXXX..X  .XX.....  .XXXXXXX  .X.XXX.X  ..X.X..X  ..X.....  X.XX.X..  .XXX..XX  .X...XX.
    // bit7 X....X..  ..X.XX..  X.XXX..X  XXXX.XXX  X..XXX.X  XXX.X.XX  .X..X.XX  X.XXX.XX  .....XXX  .XX.XX.X  ......XX  .X.....X
    // Avalanche: 51.69%

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

    const std::uint8_t aNoiseBuffer[96] = {
        0xE1, 0xBB, 0x56, 0xC5, 0xE6, 0xFA, 0x4C, 0xEF, 0x38, 0x05, 0x9B, 0x87, 0x1B, 0xC2, 0x10, 0x85,
        0x8F, 0x37, 0x5F, 0x68, 0xFF, 0x41, 0x1E, 0x62, 0x09, 0x7E, 0x35, 0x5A, 0x00, 0x08, 0xFB, 0x86,
        0x2F, 0x3B, 0xF0, 0x08, 0xDF, 0x2C, 0xAA, 0x64, 0xDB, 0x3A, 0xE9, 0xFF, 0xC1, 0xEF, 0x51, 0x7A,
        0x16, 0xEA, 0x0E, 0x2F, 0xF9, 0x9F, 0x87, 0x9A, 0x6B, 0xCD, 0x51, 0x64, 0xA5, 0xA9, 0xBF, 0x9A,
        0xA6, 0xA1, 0xD0, 0x75, 0xD2, 0x80, 0x8B, 0x94, 0x0C, 0x6C, 0x25, 0xB7, 0x0B, 0xEE, 0xA2, 0xCC,
        0x86, 0xDF, 0x6C, 0x8B, 0x3E, 0x81, 0xA9, 0xB6, 0x42, 0x0A, 0x96, 0x89, 0x3A, 0x93, 0x78, 0xF8
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[96] = {
        0xE1, 0xBB, 0x56, 0xC5, 0xE6, 0xFA, 0x4C, 0xEF, 0x38, 0x05, 0x9B, 0x87, 0x1B, 0xC2, 0x10, 0x85,
        0x8F, 0x37, 0x5F, 0x68, 0xFF, 0x41, 0x1E, 0x62, 0x09, 0x7E, 0x35, 0x5A, 0x00, 0x08, 0xFB, 0x86,
        0x2F, 0x3B, 0xF0, 0x08, 0xDF, 0x2C, 0xAA, 0x64, 0xDB, 0x3A, 0xE9, 0xFF, 0xC1, 0xEF, 0x51, 0x7A,
        0x16, 0xEA, 0x0E, 0x2F, 0xF9, 0x9F, 0x87, 0x9A, 0x6B, 0xCD, 0x51, 0x64, 0xA5, 0xA9, 0xBF, 0x9A,
        0xA6, 0xA1, 0xD0, 0x75, 0xD2, 0x80, 0x8B, 0x94, 0x0C, 0x6C, 0x25, 0xB7, 0x0B, 0xEE, 0xA2, 0xCC,
        0x86, 0xDF, 0x6C, 0x8B, 0x3E, 0x81, 0xA9, 0xB6, 0x42, 0x0A, 0x96, 0x89, 0x3A, 0x93, 0x78, 0xF8
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_F_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_F_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_F_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_F_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_F_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_96_F_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_A_PepperNoiseXORCipher {

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
    // bit0 11100111  11100010  01010101  00011110  00000111  01010000  01001100  00000000  00000010  00000100  01000111  10110010  01110001  10011011
    // bit1 00110111  11100001  00100100  10000100  01100111  10111010  11011101  00111110  01000100  00110101  00100010  11000000  10010101  11111111
    // bit2 01001101  00000011  10000111  01110111  01010110  10001110  11111101  11011110  10100101  00110000  11100110  11010111  11100010  11101110
    // bit3 01100100  11000101  00011110  11100111  00010101  01101011  00101110  01101010  01111110  01110111  10111111  11000101  01110100  01000001
    // bit4 11000011  11011001  10000011  00101000  00100101  00100100  00111011  10000110  10101010  11000000  10010010  01111110  00001110  01110110
    // bit5 11101011  01010111  10000000  10000101  00101101  11111110  01010010  10001001  10110000  01101101  00111000  11101000  11000111  10000101
    // bit6 11101010  11111010  01110111  10111111  00011011  00101100  10011000  01111011  10001100  11110110  11000001  10000111  00010001  11001110
    // bit7 10111100  11111011  01110111  01010010  01101100  00010011  00111000  00100011  10011110  01011101  11001110  11110000  11001101  11001011
    //
    // Avalanche:
    // bit0 XXX..XXX  XXX...X.  .X.X.X.X  ...XXXX.  .....XXX  .X.X....  .X..XX..  ........  ......X.  .....X..  .X...XXX  X.XX..X.  .XXX...X  X..XX.XX
    // bit1 ..XX.XXX  XXX....X  ..X..X..  X....X..  .XX..XXX  X.XXX.X.  XX.XXX.X  ..XXXXX.  .X...X..  ..XX.X.X  ..X...X.  XX......  X..X.X.X  XXXXXXXX
    // bit2 .X..XX.X  ......XX  X....XXX  .XXX.XXX  .X.X.XX.  X...XXX.  XXXXXX.X  XX.XXXX.  X.X..X.X  ..XX....  XXX..XX.  XX.X.XXX  XXX...X.  XXX.XXX.
    // bit3 .XX..X..  XX...X.X  ...XXXX.  XXX..XXX  ...X.X.X  .XX.X.XX  ..X.XXX.  .XX.X.X.  .XXXXXX.  .XXX.XXX  X.XXXXXX  XX...X.X  .XXX.X..  .X.....X
    // bit4 XX....XX  XX.XX..X  X.....XX  ..X.X...  ..X..X.X  ..X..X..  ..XXX.XX  X....XX.  X.X.X.X.  XX......  X..X..X.  .XXXXXX.  ....XXX.  .XXX.XX.
    // bit5 XXX.X.XX  .X.X.XXX  X.......  X....X.X  ..X.XX.X  XXXXXXX.  .X.X..X.  X...X..X  X.XX....  .XX.XX.X  ..XXX...  XXX.X...  XX...XXX  X....X.X
    // bit6 XXX.X.X.  XXXXX.X.  .XXX.XXX  X.XXXXXX  ...XX.XX  ..X.XX..  X..XX...  .XXXX.XX  X...XX..  XXXX.XX.  XX.....X  X....XXX  ...X...X  XX..XXX.
    // bit7 X.XXXX..  XXXXX.XX  .XXX.XXX  .X.X..X.  .XX.XX..  ...X..XX  ..XXX...  ..X...XX  X..XXXX.  .X.XXX.X  XX..XXX.  XXXX....  XX..XX.X  XX..X.XX
    // Avalanche: 51.12%

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

    const std::uint8_t aNoiseBuffer[112] = {
        0x8F, 0xBE, 0xD7, 0x41, 0x27, 0xF1, 0xCE, 0xEC, 0xDB, 0xDF, 0xC3, 0x0F, 0x0B, 0x14, 0xA7, 0x7D,
        0x2C, 0x83, 0x43, 0x93, 0x10, 0xF3, 0x3B, 0xAB, 0x56, 0x31, 0x3A, 0xA3, 0x8A, 0xF6, 0xB3, 0x36,
        0x00, 0x61, 0x4D, 0x32, 0x07, 0xFD, 0xE2, 0xDE, 0x64, 0x94, 0x5E, 0xC5, 0x76, 0x2E, 0x75, 0x11,
        0x62, 0xE4, 0x39, 0x6F, 0xFB, 0xF0, 0x1C, 0x68, 0x2C, 0x32, 0x53, 0x62, 0x76, 0x68, 0x7B, 0x07,
        0x2F, 0x50, 0x3C, 0x15, 0x1B, 0x73, 0x99, 0x20, 0x0A, 0x1F, 0x76, 0x73, 0x05, 0xD7, 0x12, 0x55,
        0x3B, 0xA3, 0x74, 0x1C, 0x15, 0xB1, 0xF9, 0x92, 0xF7, 0x7D, 0x8D, 0xA9, 0x0C, 0x3A, 0xAA, 0x32,
        0x65, 0xB5, 0xB0, 0xD2, 0x09, 0x5D, 0x2C, 0xC7, 0xE7, 0x7B, 0x68, 0xC8, 0xE3, 0x6E, 0xEB, 0xD5
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[112] = {
        0x8F, 0xBE, 0xD7, 0x41, 0x27, 0xF1, 0xCE, 0xEC, 0xDB, 0xDF, 0xC3, 0x0F, 0x0B, 0x14, 0xA7, 0x7D,
        0x2C, 0x83, 0x43, 0x93, 0x10, 0xF3, 0x3B, 0xAB, 0x56, 0x31, 0x3A, 0xA3, 0x8A, 0xF6, 0xB3, 0x36,
        0x00, 0x61, 0x4D, 0x32, 0x07, 0xFD, 0xE2, 0xDE, 0x64, 0x94, 0x5E, 0xC5, 0x76, 0x2E, 0x75, 0x11,
        0x62, 0xE4, 0x39, 0x6F, 0xFB, 0xF0, 0x1C, 0x68, 0x2C, 0x32, 0x53, 0x62, 0x76, 0x68, 0x7B, 0x07,
        0x2F, 0x50, 0x3C, 0x15, 0x1B, 0x73, 0x99, 0x20, 0x0A, 0x1F, 0x76, 0x73, 0x05, 0xD7, 0x12, 0x55,
        0x3B, 0xA3, 0x74, 0x1C, 0x15, 0xB1, 0xF9, 0x92, 0xF7, 0x7D, 0x8D, 0xA9, 0x0C, 0x3A, 0xAA, 0x32,
        0x65, 0xB5, 0xB0, 0xD2, 0x09, 0x5D, 0x2C, 0xC7, 0xE7, 0x7B, 0x68, 0xC8, 0xE3, 0x6E, 0xEB, 0xD5
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_112_A_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_A_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_A_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_A_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_A_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_A_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_B_PepperNoiseXORCipher {

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
    // bit0 01000010  11111100  11111100  11110111  10110110  10011100  00010110  10010110  10111000  11110011  00001111  11011101  01110110  11111101
    // bit1 11110010  01011010  00011101  10010110  01011101  11011101  11011111  01100110  10001001  01010000  01111110  10001110  11011110  10000110
    // bit2 00111110  00010111  11100101  11001011  00110101  11101101  10011100  11100000  01100001  00111111  11101101  10001111  00101001  01111010
    // bit3 11110001  01110111  00001111  10011111  00010111  00001000  01001001  01110001  01110111  00100001  10011001  10010000  01000000  01101010
    // bit4 10000100  00110110  01011011  11001110  01111000  00101010  11010100  10010001  01110100  01100100  01011010  00001100  01011100  10010010
    // bit5 11000101  10000101  10100000  11001011  11011010  00100001  00001000  01000100  11010110  01010000  00100010  00111110  11010010  01001110
    // bit6 01010110  01110101  10000110  00010000  00010001  01110111  00000110  00100011  11011110  00111011  10001110  01010011  11000010  11111101
    // bit7 00001001  00000001  10100100  00001011  11101000  00011000  11111011  11011100  00100000  10011110  00001111  00101011  11011111  10111101
    //
    // Avalanche:
    // bit0 X.XXXX.X  ......XX  ......XX  ....X...  .X..X..X  .XX...XX  XXX.X..X  .XX.X..X  .X...XXX  ....XX..  XXXX....  ..X...X.  X...X..X  ......X.
    // bit1 ....XX.X  X.X..X.X  XXX...X.  .XX.X..X  X.X...X.  ..X...X.  ..X.....  X..XX..X  .XXX.XX.  X.X.XXXX  X......X  .XXX...X  ..X....X  .XXXX..X
    // bit2 XX.....X  XXX.X...  ...XX.X.  ..XX.X..  XX..X.X.  ...X..X.  .XX...XX  ...XXXXX  X..XXXX.  XX......  ...X..X.  .XXX....  XX.X.XX.  X....X.X
    // bit3 ....XXX.  X...X...  XXXX....  .XX.....  XXX.X...  XXXX.XXX  X.XX.XX.  X...XXX.  X...X...  XX.XXXX.  .XX..XX.  .XX.XXXX  X.XXXXXX  X..X.X.X
    // bit4 .XXXX.XX  XX..X..X  X.X..X..  ..XX...X  X....XXX  XX.X.X.X  ..X.X.XX  .XX.XXX.  X...X.XX  X..XX.XX  X.X..X.X  XXXX..XX  X.X...XX  .XX.XX.X
    // bit5 ..XXX.X.  .XXXX.X.  .X.XXXXX  ..XX.X..  ..X..X.X  XX.XXXX.  XXXX.XXX  X.XXX.XX  ..X.X..X  X.X.XXXX  XX.XXX.X  XX.....X  ..X.XX.X  X.XX...X
    // bit6 X.X.X..X  X...X.X.  .XXXX..X  XXX.XXXX  XXX.XXX.  X...X...  XXXXX..X  XX.XXX..  ..X....X  XX...X..  .XXX...X  X.X.XX..  ..XXXX.X  ......X.
    // bit7 XXXX.XX.  XXXXXXX.  .X.XX.XX  XXXX.X..  ...X.XXX  XXX..XXX  .....X..  ..X...XX  XX.XXXXX  .XX....X  XXXX....  XX.X.X..  ..X.....  .X....X.
    // Avalanche: 49.44%

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

    const std::uint8_t aNoiseBuffer[112] = {
        0x5C, 0xD6, 0x70, 0x72, 0x21, 0x2E, 0xE2, 0x15, 0x84, 0xD2, 0x9A, 0xFA, 0xC0, 0xBE, 0x78, 0x37,
        0xA7, 0xA8, 0xA5, 0xC8, 0xD8, 0xF3, 0x1A, 0x78, 0xFC, 0xAC, 0x80, 0xD2, 0x3D, 0xD8, 0xFD, 0xB5,
        0x85, 0x4D, 0xA9, 0xFE, 0x4D, 0xF0, 0x94, 0x72, 0xE0, 0x62, 0x2E, 0xC3, 0xF9, 0xE2, 0x0A, 0x66,
        0x69, 0x59, 0x01, 0xE9, 0x75, 0xEA, 0xC3, 0x51, 0xA9, 0x75, 0x72, 0x99, 0x01, 0xC5, 0xC2, 0x1A,
        0xC6, 0x3E, 0xB9, 0x9E, 0xC2, 0x1E, 0x16, 0x70, 0x81, 0xCC, 0xBA, 0xE7, 0x23, 0x29, 0xA3, 0xB2,
        0x32, 0x68, 0x64, 0x58, 0xFB, 0xE3, 0xCF, 0xB1, 0xF0, 0x82, 0x05, 0x96, 0xED, 0xEC, 0x67, 0xA3,
        0x47, 0xDF, 0xA0, 0xCD, 0x69, 0xC9, 0xC7, 0x21, 0xCB, 0xB6, 0xB3, 0xAB, 0xB7, 0xC7, 0x7C, 0x83
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[112] = {
        0x5C, 0xD6, 0x70, 0x72, 0x21, 0x2E, 0xE2, 0x15, 0x84, 0xD2, 0x9A, 0xFA, 0xC0, 0xBE, 0x78, 0x37,
        0xA7, 0xA8, 0xA5, 0xC8, 0xD8, 0xF3, 0x1A, 0x78, 0xFC, 0xAC, 0x80, 0xD2, 0x3D, 0xD8, 0xFD, 0xB5,
        0x85, 0x4D, 0xA9, 0xFE, 0x4D, 0xF0, 0x94, 0x72, 0xE0, 0x62, 0x2E, 0xC3, 0xF9, 0xE2, 0x0A, 0x66,
        0x69, 0x59, 0x01, 0xE9, 0x75, 0xEA, 0xC3, 0x51, 0xA9, 0x75, 0x72, 0x99, 0x01, 0xC5, 0xC2, 0x1A,
        0xC6, 0x3E, 0xB9, 0x9E, 0xC2, 0x1E, 0x16, 0x70, 0x81, 0xCC, 0xBA, 0xE7, 0x23, 0x29, 0xA3, 0xB2,
        0x32, 0x68, 0x64, 0x58, 0xFB, 0xE3, 0xCF, 0xB1, 0xF0, 0x82, 0x05, 0x96, 0xED, 0xEC, 0x67, 0xA3,
        0x47, 0xDF, 0xA0, 0xCD, 0x69, 0xC9, 0xC7, 0x21, 0xCB, 0xB6, 0xB3, 0xAB, 0xB7, 0xC7, 0x7C, 0x83
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_112_B_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_B_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_B_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_B_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_B_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_B_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_C_PepperNoiseXORCipher {

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
    // bit0 11011100  01110111  01011111  00100011  00010100  00100011  10010000  10101100  00101101  11100000  00011000  01111111  01110001  11000110
    // bit1 11110010  00111110  11000100  11101001  10001110  10010100  01110010  10000110  10111001  11100011  11100010  01110010  01000000  01000000
    // bit2 00011000  01101110  11111111  00110110  11011010  00010111  00101011  11000100  01001111  01110110  11110100  01010100  00100001  10110100
    // bit3 01111101  10011010  10111001  00100111  10101010  10010101  00111100  00100011  11110110  01011111  00001000  00010000  00010000  11000101
    // bit4 11111100  01010100  11011010  01001101  01001101  01111101  10010100  00101000  01101100  10000100  11010010  11100110  01001010  01110110
    // bit5 10100111  11110100  01101001  11100000  01100111  00011111  01011100  00001011  11100011  01010011  10110111  10101110  00000110  00010101
    // bit6 10000111  01010110  01001101  01110010  10001010  00110111  01000000  00001011  11011111  11011011  00100001  00001001  01000011  11010001
    // bit7 10011000  11101110  11100111  01011101  11100000  11001001  00010001  00100010  11010110  11010001  00100000  00010111  10111100  10101001
    //
    // Avalanche:
    // bit0 .XXX.XX.  XX.XXX.X  XXXX.X.X  X...X..X  X.XXXXX.  X...X..X  ..XXX.X.  .....XX.  X....XXX  .X..X.X.  X.XX..X.  XX.X.X.X  XX.XX.XX  .XX.XX..
    // bit1 .X.XX...  X..X.X..  .XX.XXX.  .X....XX  ..X..X..  ..XXXXX.  XX.XX...  ..X.XX..  ...X..XX  .X..X..X  .X..X...  XX.XX...  XXX.X.X.  XXX.X.X.
    // bit2 X.XX..X.  XX...X..  .X.X.X.X  X..XXX..  .XXX....  X.XXXX.X  X......X  .XX.XXX.  XXX..X.X  XX.XXX..  .X.XXXX.  XXXXXXX.  X...X.XX  ...XXXX.
    // bit3 XX.X.XXX  ..XX....  ...X..XX  X...XX.X  ........  ..XXXXXX  X..X.XX.  X...X..X  .X.XXX..  XXXX.X.X  X.X...X.  X.XXX.X.  X.XXX.X.  .XX.XXXX
    // bit4 X.X.X..X  .......X  X...XXXX  ...XX...  ...XX...  ..X.X...  XX.....X  .XXXXX.X  ..XXX..X  XX.X...X  X....XXX  X.XX..XX  ...XXXXX  ..X...XX
    // bit5 XXXX..X.  X.X....X  ..XXXX..  X.XX.X.X  ..XX..X.  .X..X.X.  ....X..X  .X.XXXX.  X.XX.XX.  .....XX.  XXX...X.  XXXXX.XX  .X.X..XX  .X......
    // bit6 XX.X..X.  ......XX  ...XX...  ..X..XXX  XX.XXXXX  .XX...X.  ...X.X.X  .X.XXXX.  X...X.X.  X...XXX.  .XXX.X..  .X.XXX..  ...X.XX.  X....X..
    // bit7 XX..XX.X  X.XXX.XX  X.XX..X.  ....X...  X.XX.X.X  X..XXX..  .X...X..  .XXX.XXX  X.....XX  X....X..  .XXX.X.X  .X....X.  XXX.X..X  XXXXXX..
    // Avalanche: 48.88%

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

    const std::uint8_t aNoiseBuffer[112] = {
        0xCF, 0xD8, 0x5C, 0xF9, 0xB9, 0x9E, 0x46, 0x16, 0x15, 0xAF, 0xE5, 0xDE, 0x71, 0xEF, 0xF3, 0x80,
        0x79, 0xEF, 0x35, 0xB8, 0xBE, 0xE3, 0xA9, 0xB7, 0x44, 0x4F, 0xF6, 0x23, 0x49, 0x39, 0xB2, 0xD9,
        0x73, 0x2D, 0x15, 0xA0, 0x7A, 0xCC, 0x76, 0x0C, 0x51, 0x09, 0x8A, 0x7E, 0x0D, 0x7E, 0xA6, 0xBF,
        0x88, 0x46, 0x70, 0xDD, 0x34, 0x1C, 0x60, 0x21, 0xE0, 0x20, 0x99, 0x00, 0x8E, 0xE0, 0x57, 0x16,
        0x57, 0x3F, 0xDC, 0x53, 0xEA, 0xBB, 0x37, 0xE6, 0xCB, 0xF7, 0xE0, 0x37, 0x12, 0x38, 0x76, 0x57,
        0x6C, 0x68, 0x67, 0xAC, 0x90, 0x24, 0x4C, 0x06, 0x0C, 0xE8, 0xCC, 0xF1, 0x86, 0xAD, 0xCD, 0x83,
        0x01, 0xCA, 0xA1, 0x91, 0x09, 0x05, 0x0E, 0xA2, 0xB3, 0xDA, 0x29, 0x2E, 0x01, 0xBC, 0x88, 0x17
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[112] = {
        0xCF, 0xD8, 0x5C, 0xF9, 0xB9, 0x9E, 0x46, 0x16, 0x15, 0xAF, 0xE5, 0xDE, 0x71, 0xEF, 0xF3, 0x80,
        0x79, 0xEF, 0x35, 0xB8, 0xBE, 0xE3, 0xA9, 0xB7, 0x44, 0x4F, 0xF6, 0x23, 0x49, 0x39, 0xB2, 0xD9,
        0x73, 0x2D, 0x15, 0xA0, 0x7A, 0xCC, 0x76, 0x0C, 0x51, 0x09, 0x8A, 0x7E, 0x0D, 0x7E, 0xA6, 0xBF,
        0x88, 0x46, 0x70, 0xDD, 0x34, 0x1C, 0x60, 0x21, 0xE0, 0x20, 0x99, 0x00, 0x8E, 0xE0, 0x57, 0x16,
        0x57, 0x3F, 0xDC, 0x53, 0xEA, 0xBB, 0x37, 0xE6, 0xCB, 0xF7, 0xE0, 0x37, 0x12, 0x38, 0x76, 0x57,
        0x6C, 0x68, 0x67, 0xAC, 0x90, 0x24, 0x4C, 0x06, 0x0C, 0xE8, 0xCC, 0xF1, 0x86, 0xAD, 0xCD, 0x83,
        0x01, 0xCA, 0xA1, 0x91, 0x09, 0x05, 0x0E, 0xA2, 0xB3, 0xDA, 0x29, 0x2E, 0x01, 0xBC, 0x88, 0x17
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_112_C_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_C_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_C_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_C_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_C_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_C_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_D_PepperNoiseXORCipher {

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
    // bit0 00110001  01000101  01001101  11100111  10101010  10001100  00111010  11100000  10101010  01110010  11111100  01110110  11011100  01011110
    // bit1 11100111  01110000  11001101  10000100  00111010  11011111  00000001  11101111  10000111  10000011  10010100  01010010  10110001  00011010
    // bit2 11000111  10010001  00100110  01111011  01000010  11010011  00101101  00000000  00100010  11101101  00111101  00011000  11001100  10110111
    // bit3 01100001  00001011  10110011  00101001  11000100  00000101  01000110  00101000  01100111  01110011  00111110  11011001  00010000  01011000
    // bit4 10011110  11100001  10101011  00011100  11100100  10110001  01011001  01110100  01011100  11000110  11110110  00011110  10011001  00100001
    // bit5 11010001  10100001  00100010  01010000  01100010  10111111  10011000  01100110  11001100  10011111  00100101  01000011  10111011  10001011
    // bit6 10011111  01101000  10111100  10110111  01000101  10010111  11101010  00100101  00100110  01101001  10100111  11111010  10001111  00000001
    // bit7 10001010  10110010  11100101  11000111  01111000  01100010  10111110  00100100  01100001  10100001  10101010  01110111  11010000  10001000
    //
    // Avalanche:
    // bit0 X..XX.XX  XXX.XXXX  XXX..XXX  .X..XX.X  ........  ..X..XX.  X..X....  .X..X.X.  ........  XX.XX...  .X.X.XX.  XX.XXX..  .XXX.XX.  XXXX.X..
    // bit1 .X..XX.X  XX.XX.X.  .XX..XXX  ..X.XXX.  X..X....  .XXX.X.X  X.X.X.XX  .X...X.X  ..X.XX.X  ..X.X..X  ..XXXXX.  XXXXX...  ...XX.XX  X.XX....
    // bit2 X..X..X.  XX...X..  .XXX..XX  ..X.XXX.  ...X.XXX  X....XX.  .XXXX...  .X.X.X.X  .XXX.XXX  X.XXX...  .XX.X...  .X..XX.X  X..XX..X  XXX...X.
    // bit3 ..XX.X..  .X.XXXX.  XXX..XX.  .XXXXX..  X..X...X  .X.X....  ...X..XX  .XXXXX.X  ..XX..X.  ..X..XX.  .XX.X.XX  X...XX..  .X...X.X  ....XX.X
    // bit4 ..XX.X..  .X..X.XX  .......X  X.XX.XX.  .X..XXX.  ...XX.XX  XXXX..XX  XX.XXXX.  XXXX.XX.  .XX.XX..  .X.XXX..  X.XX.X..  ..XX..XX  X...X.XX
    // bit5 .XXXX.XX  ....X.XX  X...X...  XXXXX.X.  XX..X...  ...X.X.X  ..XX..X.  XX..XX..  .XX..XX.  ..XX.X.X  X...XXXX  XXX.X..X  ...X...X  ..X....X
    // bit6 XX..X.X.  ..XXXX.X  XXX.X..X  XXX...X.  ...X....  XX....X.  X.XXXXXX  .XXX....  .XXX..XX  ..XXXX..  XXXX..X.  X.X.XXXX  XX.XX.X.  .X.X.X..
    // bit7 XX.XXXXX  XXX..XXX  X.XX....  X..X..X.  ..X.XX.X  ..XX.XXX  XXX.X.XX  .XXX...X  ..XX.X..  XXXX.X..  XXXXXXXX  ..X...X.  X....X.X  XX.XXX.X
    // Avalanche: 50.56%

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

    const std::uint8_t aNoiseBuffer[112] = {
        0x6F, 0x74, 0xD0, 0x8E, 0x0B, 0x6A, 0x6B, 0xF6, 0x2D, 0xCA, 0x4F, 0x61, 0x12, 0x80, 0x11, 0xBC,
        0x5B, 0xC1, 0x3F, 0x12, 0xCA, 0xE3, 0x3C, 0xD9, 0xC3, 0xA5, 0xB2, 0x2E, 0x38, 0xCB, 0xA3, 0xB3,
        0x98, 0x3F, 0xCD, 0x41, 0xC1, 0x1A, 0xE4, 0x02, 0xEE, 0x61, 0x0D, 0x6E, 0xC4, 0xD6, 0x67, 0x7E,
        0x07, 0x1A, 0xA3, 0x8D, 0xAF, 0x31, 0x93, 0x68, 0xC0, 0xCC, 0xDF, 0x08, 0x50, 0x4F, 0x44, 0x42,
        0xC4, 0x1D, 0xB3, 0x08, 0x8C, 0x5E, 0xF2, 0x51, 0x6D, 0xBA, 0xB3, 0x94, 0x26, 0x2C, 0xDC, 0x77,
        0xCB, 0x88, 0xBF, 0xF8, 0xB1, 0xFE, 0x1B, 0x26, 0x12, 0xD7, 0x83, 0xFB, 0x3A, 0x89, 0xCF, 0x15,
        0xEF, 0xA1, 0x44, 0xDD, 0xAE, 0xA2, 0x06, 0x4E, 0x25, 0x90, 0x28, 0xF0, 0xD5, 0xA0, 0xE4, 0x2E
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[112] = {
        0x6F, 0x74, 0xD0, 0x8E, 0x0B, 0x6A, 0x6B, 0xF6, 0x2D, 0xCA, 0x4F, 0x61, 0x12, 0x80, 0x11, 0xBC,
        0x5B, 0xC1, 0x3F, 0x12, 0xCA, 0xE3, 0x3C, 0xD9, 0xC3, 0xA5, 0xB2, 0x2E, 0x38, 0xCB, 0xA3, 0xB3,
        0x98, 0x3F, 0xCD, 0x41, 0xC1, 0x1A, 0xE4, 0x02, 0xEE, 0x61, 0x0D, 0x6E, 0xC4, 0xD6, 0x67, 0x7E,
        0x07, 0x1A, 0xA3, 0x8D, 0xAF, 0x31, 0x93, 0x68, 0xC0, 0xCC, 0xDF, 0x08, 0x50, 0x4F, 0x44, 0x42,
        0xC4, 0x1D, 0xB3, 0x08, 0x8C, 0x5E, 0xF2, 0x51, 0x6D, 0xBA, 0xB3, 0x94, 0x26, 0x2C, 0xDC, 0x77,
        0xCB, 0x88, 0xBF, 0xF8, 0xB1, 0xFE, 0x1B, 0x26, 0x12, 0xD7, 0x83, 0xFB, 0x3A, 0x89, 0xCF, 0x15,
        0xEF, 0xA1, 0x44, 0xDD, 0xAE, 0xA2, 0x06, 0x4E, 0x25, 0x90, 0x28, 0xF0, 0xD5, 0xA0, 0xE4, 0x2E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_112_D_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_D_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_D_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_D_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_D_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_D_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_E_PepperNoiseXORCipher {

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
    // bit0 11001000  00101001  00100011  10111000  10000011  11100000  01100000  11111101  11010100  11011110  10011110  01000100  01101001  01100101
    // bit1 11010110  01011111  01110001  11100111  01101000  10010101  11011101  01000001  10111111  00110000  01101100  00110010  11010001  00001001
    // bit2 00100100  01001000  00110101  11111010  01000101  01010011  10111001  00101100  11100010  01001110  01010001  01011010  00010010  10000011
    // bit3 11011001  01011110  10110101  11011011  00001111  11100010  10001101  00101101  10101111  11111001  01111101  00001101  10010111  01110111
    // bit4 10110000  00100101  01011110  10100110  00001011  00011001  10111101  00101010  00111100  11010001  01010001  00110010  11011101  00110110
    // bit5 01001101  01111100  10100100  11000101  01011011  10001011  11001110  01011101  01101100  00101100  11000100  00011000  11101001  11001011
    // bit6 11011011  01111000  10001110  10011011  10010101  01000110  11001000  11000010  11010001  10101001  00100001  01011101  00101010  11111100
    // bit7 10000110  11011110  11111000  10010110  00001000  10111111  00011010  10111100  00110011  01011111  11100101  10001000  11110100  10110001
    //
    // Avalanche:
    // bit0 .XX...X.  X.....XX  X...X..X  ...X..X.  ..X.X..X  .X..X.X.  XX..X.X.  .X.X.XXX  .XXXXXX.  .XXX.X..  ..XX.X..  XXX.XXX.  XX....XX  XX..XXXX
    // bit1 .XXXXX..  XXXX.X.X  XX.XX.XX  .X..XX.X  XX....X.  ..XXXXXX  .XXX.XXX  XXX.X.XX  ...X.X.X  X..XX.X.  XX...XX.  X..XX...  .XXXX.XX  X.X...XX
    // bit2 .XXX...X  ...XXX.X  .XX.....  X.X.XXXX  ...X....  .....XX.  XXX.XX..  .XXXX..X  X.XX.XXX  ...XX.XX  .....X..  ....XXXX  .X...XXX  XX.X.XX.
    // bit3 X...XX..  ....X.XX  XXX.....  X...XXX.  .X.XX.X.  X.XX.XXX  XX.XX...  .XXXX...  XXXXX.X.  X.X.XX..  ..X.X...  .X.XX...  XX....X.  ..X...X.
    // bit4 XXX..X.X  .XXX....  ....X.XX  XXXX..XX  .X.XXXX.  .X..XX..  XXX.X...  .XXXXXXX  .XX.X..X  X....X..  .....X..  .XX..XXX  X...X...  .XX...XX
    // bit5 ...XX...  ..X.X..X  XXXX...X  X..X....  ....XXX.  XX.XXXX.  X..XX.XX  ....X...  ..XXX..X  .XXXX..X  X..X...X  .X..XX.X  X.XXXX..  X..XXXX.
    // bit6 .XXX...X  XX.X..X.  ..X..X..  ..XX...X  ..XXXXXX  XXX.XX..  .XX...X.  .XX.X...  .XXXX.XX  ......XX  X...X.XX  XXXX.XXX  X.......  .X.X.XX.
    // bit7 ..X.XX..  .XXX.X..  .X.X..X.  ..XXXX..  X.X...X.  ...X.X.X  X.XX....  ...X.XX.  X..XX..X  XXXX.X.X  .X..XXXX  ..X...X.  .X.XXXX.  ...XX.XX
    // Avalanche: 48.88%

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

    const std::uint8_t aNoiseBuffer[112] = {
        0xDB, 0xD6, 0x28, 0x5A, 0x96, 0x65, 0x43, 0x16, 0x01, 0x77, 0x8E, 0x57, 0xF7, 0x5D, 0x51, 0xC8,
        0x17, 0x49, 0xF5, 0x79, 0x0B, 0x3E, 0x8A, 0xF0, 0xFF, 0x74, 0xE8, 0xB3, 0xB2, 0x4D, 0x7B, 0x56,
        0x82, 0x64, 0x40, 0x06, 0x5D, 0x32, 0x9C, 0xBE, 0xD5, 0xB2, 0x91, 0x69, 0x0D, 0x43, 0x37, 0x6D,
        0x7E, 0xC6, 0xA8, 0x69, 0x7F, 0x5C, 0x05, 0x78, 0x83, 0xC6, 0xB9, 0x85, 0xBD, 0xB5, 0x0A, 0xD4,
        0xF2, 0xA6, 0x7D, 0xCB, 0x5C, 0xDC, 0x71, 0x53, 0x9A, 0xB9, 0x56, 0xD9, 0xB7, 0xA5, 0xA1, 0x1B,
        0x85, 0x7D, 0x53, 0xB8, 0xD0, 0xD5, 0x80, 0x3B, 0x01, 0xA2, 0x48, 0x6E, 0x37, 0x92, 0x68, 0x12,
        0x5D, 0xCD, 0x87, 0x79, 0x8E, 0x19, 0x32, 0xDC, 0x27, 0x96, 0x9B, 0x1B, 0x46, 0x9A, 0x3C, 0xF5
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[112] = {
        0xDB, 0xD6, 0x28, 0x5A, 0x96, 0x65, 0x43, 0x16, 0x01, 0x77, 0x8E, 0x57, 0xF7, 0x5D, 0x51, 0xC8,
        0x17, 0x49, 0xF5, 0x79, 0x0B, 0x3E, 0x8A, 0xF0, 0xFF, 0x74, 0xE8, 0xB3, 0xB2, 0x4D, 0x7B, 0x56,
        0x82, 0x64, 0x40, 0x06, 0x5D, 0x32, 0x9C, 0xBE, 0xD5, 0xB2, 0x91, 0x69, 0x0D, 0x43, 0x37, 0x6D,
        0x7E, 0xC6, 0xA8, 0x69, 0x7F, 0x5C, 0x05, 0x78, 0x83, 0xC6, 0xB9, 0x85, 0xBD, 0xB5, 0x0A, 0xD4,
        0xF2, 0xA6, 0x7D, 0xCB, 0x5C, 0xDC, 0x71, 0x53, 0x9A, 0xB9, 0x56, 0xD9, 0xB7, 0xA5, 0xA1, 0x1B,
        0x85, 0x7D, 0x53, 0xB8, 0xD0, 0xD5, 0x80, 0x3B, 0x01, 0xA2, 0x48, 0x6E, 0x37, 0x92, 0x68, 0x12,
        0x5D, 0xCD, 0x87, 0x79, 0x8E, 0x19, 0x32, 0xDC, 0x27, 0x96, 0x9B, 0x1B, 0x46, 0x9A, 0x3C, 0xF5
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_112_E_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_E_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_E_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_E_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_E_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_E_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_F_PepperNoiseXORCipher {

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
    // bit0 11111000  01100110  00001110  00111010  10111100  10001001  00011001  00101010  10010001  11011011  01110010  00011010  10101101  10011001
    // bit1 11011101  01101011  00011100  10100011  00101010  00011001  00100110  00101110  01010010  00110000  10000001  10101000  01000110  00011001
    // bit2 00000010  00110100  01101110  00101000  00011010  01001101  11010000  00110011  00110100  10110011  10110100  11111011  01101111  10010000
    // bit3 00000011  01101111  10010101  01000100  11001110  11111011  01000110  00111101  11001110  01111100  11010110  11000011  00010101  11101110
    // bit4 00011011  00000000  11110000  10100101  11100001  00101000  00000011  10001100  10110100  10000110  00111001  00010101  01110111  00100010
    // bit5 11101001  01010110  10101010  10101111  10010110  10011011  01111000  00010111  10001111  10101010  10110111  00010111  01010011  10000111
    // bit6 10110100  01001011  01111001  11100000  11100011  00011011  11001010  00111001  00010110  11011010  11001001  00000100  01010001  10011011
    // bit7 11001110  00011001  00111010  00111110  10010101  10110110  11111110  01001011  01111101  00100111  00010101  00001000  11010011  01000101
    //
    // Avalanche:
    // bit0 .X.X..X.  XX..XX..  X.X..X..  X..X....  ...X.XX.  ..X...XX  X.XX..XX  X.......  ..XXX.XX  .XXX...X  XX.XX...  X.XX....  .....XXX  ..XX..XX
    // bit1 X...X...  ..XXXXX.  .X..X..X  XXXX.XX.  .XXXXXXX  .X..XX..  .XXX..XX  .XXXX.XX  .....XXX  .XX..X.X  XX.X.X..  XXXXXX.X  ...X..XX  .X..XX..
    // bit2 X.X.X...  X..XXXX.  XX...X..  X.....X.  X.XX....  XXX..XXX  .XXXX.X.  X..XX..X  X..XXXX.  ...XX..X  ...XXXX.  .X.X...X  XX...X.X  ..XXX.X.
    // bit3 .X.X.XX.  ..XXX.X.  XX......  ...X...X  X..XX.XX  X.X.XXX.  ...X..XX  .XX.X...  X..XX.XX  ..X.X..X  X.....XX  X..X.XX.  .X......  X.XXX.XX
    // bit4 X.XX...X  X.X.X.X.  .X.XX.X.  ....XXXX  .X..X.XX  X.....X.  X.X.X..X  ..X..XX.  ...XXXX.  ..X.XX..  X..X..XX  X.XXXXXX  XX.XXX.X  X...X...
    // bit5 X.XXXX..  ......XX  XXXXXXXX  XXXXX.X.  XX....XX  XX..XXX.  ..X.XX.X  .X....X.  XX.XX.X.  XXXXXXXX  XXX...X.  .X....X.  .....XX.  XX.X..X.
    // bit6 ...XXXX.  XXX....X  XX.X..XX  .X..X.X.  .X..X..X  X.XX...X  .XX.....  X..X..XX  X.XXXX..  .XXX....  .XX...XX  X.X.XXX.  XXXXX.XX  ..XX...X
    // bit7 X..XX.XX  .X..XX..  .XX.XXXX  .XX.X.XX  XX......  XXX...XX  X.X.X.XX  ...XXXX.  ..X.X...  .XXX..X.  .X......  .X.XXX.X  X....XX.  ...X....
    // Avalanche: 48.55%

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

    const std::uint8_t aNoiseBuffer[112] = {
        0xC7, 0xC5, 0x86, 0xCA, 0xCD, 0x43, 0x39, 0x5C, 0x00, 0xD6, 0xF0, 0x25, 0x53, 0xB4, 0xD6, 0x53,
        0x1C, 0x2A, 0x2F, 0x5B, 0xE7, 0xF0, 0xA5, 0x12, 0x4E, 0x12, 0xEF, 0x81, 0xA5, 0x1D, 0xC5, 0x4C,
        0x9F, 0x1A, 0xCA, 0xA5, 0xF0, 0x95, 0x76, 0x0B, 0x95, 0x30, 0x19, 0x57, 0xFE, 0x21, 0x17, 0xF6,
        0x23, 0x37, 0x45, 0xA5, 0x87, 0x51, 0x5B, 0x88, 0x08, 0x01, 0xF2, 0x36, 0xDB, 0x5C, 0xE5, 0x37,
        0x9C, 0x51, 0x29, 0xEB, 0x15, 0x3F, 0x56, 0x85, 0xAE, 0x92, 0x75, 0xF2, 0x96, 0x19, 0xAF, 0xA1,
        0x76, 0x92, 0xAC, 0xBD, 0x0A, 0x35, 0x94, 0x4F, 0x70, 0x30, 0x60, 0xAC, 0xE1, 0x0E, 0xB4, 0x3C,
        0x81, 0x6F, 0xA8, 0x1F, 0xA0, 0xF8, 0x6D, 0xBF, 0xB6, 0x11, 0x18, 0xE2, 0xD2, 0x15, 0x1E, 0xC7
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[112] = {
        0xC7, 0xC5, 0x86, 0xCA, 0xCD, 0x43, 0x39, 0x5C, 0x00, 0xD6, 0xF0, 0x25, 0x53, 0xB4, 0xD6, 0x53,
        0x1C, 0x2A, 0x2F, 0x5B, 0xE7, 0xF0, 0xA5, 0x12, 0x4E, 0x12, 0xEF, 0x81, 0xA5, 0x1D, 0xC5, 0x4C,
        0x9F, 0x1A, 0xCA, 0xA5, 0xF0, 0x95, 0x76, 0x0B, 0x95, 0x30, 0x19, 0x57, 0xFE, 0x21, 0x17, 0xF6,
        0x23, 0x37, 0x45, 0xA5, 0x87, 0x51, 0x5B, 0x88, 0x08, 0x01, 0xF2, 0x36, 0xDB, 0x5C, 0xE5, 0x37,
        0x9C, 0x51, 0x29, 0xEB, 0x15, 0x3F, 0x56, 0x85, 0xAE, 0x92, 0x75, 0xF2, 0x96, 0x19, 0xAF, 0xA1,
        0x76, 0x92, 0xAC, 0xBD, 0x0A, 0x35, 0x94, 0x4F, 0x70, 0x30, 0x60, 0xAC, 0xE1, 0x0E, 0xB4, 0x3C,
        0x81, 0x6F, 0xA8, 0x1F, 0xA0, 0xF8, 0x6D, 0xBF, 0xB6, 0x11, 0x18, 0xE2, 0xD2, 0x15, 0x1E, 0xC7
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_112_F_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_F_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_F_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_F_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_F_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_112_F_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_A_PepperNoiseXORCipher {

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
    // bit0 01001101  10101001  11001110  01100101  00000000  10100100  11000101  10100010  10001001  11100100  01001100  10000010  10000100  10111111  01110001  11010001
    // bit1 11110011  00010011  10001111  10011000  10011100  01010000  01110010  00010010  10110001  10010110  11000000  10000111  11011001  10000111  11111001  11111001
    // bit2 01001111  11111010  10100101  00101010  11100110  00001011  11000110  10010000  00110010  10100100  11111111  10011111  01001011  01111110  01001101  00000101
    // bit3 01011101  11111111  11010010  01111100  01001000  00100100  01001010  10000011  00101001  00101110  01100101  00010011  10100101  01100110  10111010  00100000
    // bit4 10000011  11011101  00011010  00110101  00011001  01001000  01100111  01111110  01111010  00001000  10101010  10001111  00101101  01100101  11100000  01000111
    // bit5 00001000  10000000  01011011  11110110  10010001  00001101  10101000  11101111  01001100  00010000  00011111  01000110  11000001  10000110  00011010  10010011
    // bit6 10101010  10001100  10111010  10011111  11001011  01001111  11100101  11110111  11011111  00100111  10110110  01010100  11010000  10100010  00001011  10101010
    // bit7 10001100  11110010  00101001  01001001  11001000  00110110  00111100  11000101  00001110  10100110  10000101  11001001  01011111  00011100  00110110  11000110
    //
    // Avalanche:
    // bit0 .X..XX.X  X.X.X..X  XX..XXX.  .XX..X.X  ........  X.X..X..  XX...X.X  X.X...X.  X...X..X  XXX..X..  .X..XX..  X.....X.  X....X..  X.XXXXXX  .XXX...X  XX.X...X
    // bit1 XXXX..XX  ...X..XX  X...XXXX  X..XX...  X..XXX..  .X.X....  .XXX..X.  ...X..X.  X.XX...X  X..X.XX.  XX......  X....XXX  XX.XX..X  X....XXX  XXXXX..X  XXXXX..X
    // bit2 .X..XXXX  XXXXX.X.  X.X..X.X  ..X.X.X.  XXX..XX.  ....X.XX  XX...XX.  X..X....  ..XX..X.  X.X..X..  XXXXXXXX  X..XXXXX  .X..X.XX  .XXXXXX.  .X..XX.X  .....X.X
    // bit3 .X.XXX.X  XXXXXXXX  XX.X..X.  .XXXXX..  .X..X...  ..X..X..  .X..X.X.  X.....XX  ..X.X..X  ..X.XXX.  .XX..X.X  ...X..XX  X.X..X.X  .XX..XX.  X.XXX.X.  ..X.....
    // bit4 X.....XX  XX.XXX.X  ...XX.X.  ..XX.X.X  ...XX..X  .X..X...  .XX..XXX  .XXXXXX.  .XXXX.X.  ....X...  X.X.X.X.  X...XXXX  ..X.XX.X  .XX..X.X  XXX.....  .X...XXX
    // bit5 ....X...  X.......  .X.XX.XX  XXXX.XX.  X..X...X  ....XX.X  X.X.X...  XXX.XXXX  .X..XX..  ...X....  ...XXXXX  .X...XX.  XX.....X  X....XX.  ...XX.X.  X..X..XX
    // bit6 X.X.X.X.  X...XX..  X.XXX.X.  X..XXXXX  XX..X.XX  .X..XXXX  XXX..X.X  XXXX.XXX  XX.XXXXX  ..X..XXX  X.XX.XX.  .X.X.X..  XX.X....  X.X...X.  ....X.XX  X.X.X.X.
    // bit7 X...XX..  XXXX..X.  ..X.X..X  .X..X..X  XX..X...  ..XX.XX.  ..XXXX..  XX...X.X  ....XXX.  X.X..XX.  X....X.X  XX..X..X  .X.XXXXX  ...XXX..  ..XX.XX.  XX...XX.
    // Avalanche: 48.44%

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

    const std::uint8_t aNoiseBuffer[128] = {
        0x4B, 0xF0, 0x42, 0x50, 0xB7, 0xB1, 0x6A, 0xF8, 0xBF, 0x39, 0xB1, 0x79, 0xBA, 0x1A, 0x71, 0xD8,
        0xF2, 0x94, 0x23, 0x1E, 0xCF, 0xE0, 0xDE, 0x65, 0x46, 0x95, 0xBC, 0x5E, 0x73, 0x9E, 0x26, 0x8B,
        0x67, 0x33, 0x20, 0x4C, 0x5B, 0x60, 0x22, 0x0E, 0x80, 0x4A, 0x91, 0x41, 0x2E, 0x97, 0x23, 0x26,
        0xA6, 0xFA, 0x4F, 0x41, 0x15, 0xAB, 0x78, 0x8A, 0xB7, 0x0F, 0x8E, 0x6A, 0x0C, 0x0F, 0xDE, 0x17,
        0xC2, 0x0E, 0x78, 0x6A, 0x9F, 0x07, 0x2B, 0xD2, 0xE1, 0x80, 0xB3, 0x44, 0x18, 0xF3, 0x53, 0x02,
        0x6B, 0xF0, 0x3A, 0x26, 0xAC, 0xB7, 0x2E, 0x35, 0xE9, 0x07, 0x00, 0x32, 0x29, 0x6E, 0xFC, 0x79,
        0xD6, 0x67, 0x18, 0x43, 0x69, 0x99, 0x21, 0x7D, 0xC6, 0x38, 0xBA, 0xA1, 0xA1, 0xFD, 0xF6, 0xC8,
        0x58, 0xE8, 0xD9, 0xD5, 0x76, 0x21, 0x17, 0xE2, 0xC7, 0xC9, 0x52, 0xC4, 0x42, 0x29, 0x0F, 0xEC
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[128] = {
        0x4B, 0xF0, 0x42, 0x50, 0xB7, 0xB1, 0x6A, 0xF8, 0xBF, 0x39, 0xB1, 0x79, 0xBA, 0x1A, 0x71, 0xD8,
        0xF2, 0x94, 0x23, 0x1E, 0xCF, 0xE0, 0xDE, 0x65, 0x46, 0x95, 0xBC, 0x5E, 0x73, 0x9E, 0x26, 0x8B,
        0x67, 0x33, 0x20, 0x4C, 0x5B, 0x60, 0x22, 0x0E, 0x80, 0x4A, 0x91, 0x41, 0x2E, 0x97, 0x23, 0x26,
        0xA6, 0xFA, 0x4F, 0x41, 0x15, 0xAB, 0x78, 0x8A, 0xB7, 0x0F, 0x8E, 0x6A, 0x0C, 0x0F, 0xDE, 0x17,
        0xC2, 0x0E, 0x78, 0x6A, 0x9F, 0x07, 0x2B, 0xD2, 0xE1, 0x80, 0xB3, 0x44, 0x18, 0xF3, 0x53, 0x02,
        0x6B, 0xF0, 0x3A, 0x26, 0xAC, 0xB7, 0x2E, 0x35, 0xE9, 0x07, 0x00, 0x32, 0x29, 0x6E, 0xFC, 0x79,
        0xD6, 0x67, 0x18, 0x43, 0x69, 0x99, 0x21, 0x7D, 0xC6, 0x38, 0xBA, 0xA1, 0xA1, 0xFD, 0xF6, 0xC8,
        0x58, 0xE8, 0xD9, 0xD5, 0x76, 0x21, 0x17, 0xE2, 0xC7, 0xC9, 0x52, 0xC4, 0x42, 0x29, 0x0F, 0xEC
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_A_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_A_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_A_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_A_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_A_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_A_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_B_PepperNoiseXORCipher {

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
    // bit0 00100011  00001011  11100100  00001011  01000100  01110110  10010000  00111011  00100001  00001001  00110000  10000000  00111100  01001000  00101100  01011111
    // bit1 00010001  10011011  01010110  00111011  11001111  11000100  00101110  11110101  11010001  11100111  10011110  10010110  01111001  00001001  11000000  00110101
    // bit2 01110100  10101100  01100111  01101110  01101111  11011011  00100011  10001100  11110001  11001010  11000011  01000111  10101111  11111010  01001001  11000001
    // bit3 11000011  11101110  11010000  10111111  10000001  10100000  00110001  11111100  10011100  11110110  10001110  10111011  11010000  01001001  11111010  00011010
    // bit4 00111111  11101111  10111011  01110011  10010101  00001000  01000101  10000011  10001000  10100100  01100010  01100011  00010000  01101010  10000010  01110100
    // bit5 00101010  11011111  00101111  00000111  10111010  00011101  11101000  01100110  00101010  10110110  00110010  01100000  01011101  10001101  01010001  00010011
    // bit6 11111101  11001111  11001110  01010000  01011100  01000011  11011010  11101111  01110101  00011110  01110010  10111010  10110010  11100011  10010011  10110010
    // bit7 10000001  01100001  01101011  01011000  01101010  00101001  11101100  01000111  11001101  00000010  01101110  10111101  10111010  01101100  00010111  01001001
    //
    // Avalanche:
    // bit0 XX.XXX..  XXXX.X..  ...XX.XX  XXXX.X..  X.XXX.XX  X...X..X  .XX.XXXX  XX...X..  XX.XXXX.  XXXX.XX.  XX..XXXX  .XXXXXXX  XX....XX  X.XX.XXX  XX.X..XX  X.X.....
    // bit1 XXX.XXX.  .XX..X..  X.X.X..X  XX...X..  ..XX....  ..XXX.XX  XX.X...X  ....X.X.  ..X.XXX.  ...XX...  .XX....X  .XX.X..X  X....XX.  XXXX.XX.  ..XXXXXX  XX..X.X.
    // bit2 X...X.XX  .X.X..XX  X..XX...  X..X...X  X..X....  ..X..X..  XX.XXX..  .XXX..XX  ....XXX.  ..XX.X.X  ..XXXX..  X.XXX...  .X.X....  .....X.X  X.XX.XX.  ..XXXXX.
    // bit3 ..XXXX..  ...X...X  ..X.XXXX  .X......  .XXXXXX.  .X.XXXXX  XX..XXX.  ......XX  .XX...XX  ....X..X  .XXX...X  .X...X..  ..X.XXXX  X.XX.XX.  .....X.X  XXX..X.X
    // bit4 XX......  ...X....  .X...X..  X...XX..  .XX.X.X.  XXXX.XXX  X.XXX.X.  .XXXXX..  .XXX.XXX  .X.XX.XX  X..XXX.X  X..XXX..  XXX.XXXX  X..X.X.X  .XXXXX.X  X...X.XX
    // bit5 XX.X.X.X  ..X.....  XX.X....  XXXXX...  .X...X.X  XXX...X.  ...X.XXX  X..XX..X  XX.X.X.X  .X..X..X  XX..XX.X  X..XXXXX  X.X...X.  .XXX..X.  X.X.XXX.  XXX.XX..
    // bit6 ......X.  ..XX....  ..XX...X  X.X.XXXX  X.X...XX  X.XXXX..  ..X..X.X  ...X....  X...X.X.  XXX....X  X...XX.X  .X...X.X  .X..XX.X  ...XXX..  .XX.XX..  .X..XX.X
    // bit7 .XXXXXX.  X..XXXX.  X..X.X..  X.X..XXX  X..X.X.X  XX.X.XX.  ...X..XX  X.XXX...  ..XX..X.  XXXXXX.X  X..X...X  .X....X.  .X...X.X  X..X..XX  XXX.X...  X.XX.XX.
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

    const std::uint8_t aNoiseBuffer[128] = {
        0x13, 0x32, 0xAE, 0x6A, 0x0E, 0x2A, 0x9C, 0xDB, 0x7E, 0x1F, 0x39, 0x44, 0xFE, 0x3E, 0xDE, 0xCF,
        0x9A, 0xF3, 0xAD, 0x58, 0x0F, 0xE6, 0x6F, 0x2D, 0x10, 0x2B, 0x78, 0x5B, 0xF1, 0x34, 0xFC, 0xDC,
        0x5C, 0xE3, 0x25, 0x0E, 0x67, 0xEA, 0x65, 0x78, 0x70, 0xE2, 0x91, 0xA4, 0x2D, 0xC4, 0xA2, 0x27,
        0x87, 0x0F, 0x75, 0x92, 0x47, 0x49, 0x62, 0x38, 0x7A, 0x57, 0xD6, 0xD0, 0xB2, 0x77, 0x8F, 0xCB,
        0x79, 0x63, 0xA6, 0x72, 0x1D, 0x13, 0x04, 0xE3, 0x7C, 0x70, 0x5C, 0x16, 0xA2, 0x5E, 0x77, 0xC0,
        0x70, 0x2B, 0x8F, 0xC6, 0x51, 0x51, 0x7F, 0x20, 0xD3, 0x2C, 0x1F, 0x53, 0x13, 0x61, 0x7A, 0x39,
        0x33, 0x54, 0xE3, 0xDF, 0xE5, 0xA4, 0x23, 0x64, 0x26, 0xBB, 0x2B, 0x20, 0xFD, 0x05, 0x2A, 0x56,
        0x5A, 0x74, 0x90, 0x17, 0xB0, 0x81, 0x1B, 0x27, 0x22, 0xA9, 0x4A, 0xDE, 0x91, 0xC8, 0x96, 0xE5
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[128] = {
        0x13, 0x32, 0xAE, 0x6A, 0x0E, 0x2A, 0x9C, 0xDB, 0x7E, 0x1F, 0x39, 0x44, 0xFE, 0x3E, 0xDE, 0xCF,
        0x9A, 0xF3, 0xAD, 0x58, 0x0F, 0xE6, 0x6F, 0x2D, 0x10, 0x2B, 0x78, 0x5B, 0xF1, 0x34, 0xFC, 0xDC,
        0x5C, 0xE3, 0x25, 0x0E, 0x67, 0xEA, 0x65, 0x78, 0x70, 0xE2, 0x91, 0xA4, 0x2D, 0xC4, 0xA2, 0x27,
        0x87, 0x0F, 0x75, 0x92, 0x47, 0x49, 0x62, 0x38, 0x7A, 0x57, 0xD6, 0xD0, 0xB2, 0x77, 0x8F, 0xCB,
        0x79, 0x63, 0xA6, 0x72, 0x1D, 0x13, 0x04, 0xE3, 0x7C, 0x70, 0x5C, 0x16, 0xA2, 0x5E, 0x77, 0xC0,
        0x70, 0x2B, 0x8F, 0xC6, 0x51, 0x51, 0x7F, 0x20, 0xD3, 0x2C, 0x1F, 0x53, 0x13, 0x61, 0x7A, 0x39,
        0x33, 0x54, 0xE3, 0xDF, 0xE5, 0xA4, 0x23, 0x64, 0x26, 0xBB, 0x2B, 0x20, 0xFD, 0x05, 0x2A, 0x56,
        0x5A, 0x74, 0x90, 0x17, 0xB0, 0x81, 0x1B, 0x27, 0x22, 0xA9, 0x4A, 0xDE, 0x91, 0xC8, 0x96, 0xE5
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_B_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_B_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_B_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_B_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_B_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_B_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_C_PepperNoiseXORCipher {

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
    // bit0 10000000  01010100  00111001  00110001  01001110  10000010  10110100  10011011  00101001  11010000  11000110  01011101  01001110  01010001  01011111  10100100
    // bit1 01001100  11101111  11100011  01101101  10110000  01100101  00111110  10000000  10111101  01111000  11001011  10001000  00100100  00101111  01000010  01011011
    // bit2 10001010  11100111  10010001  10111101  01000110  01000101  11010010  01110010  11010101  01101001  11110010  10001001  00010110  01100010  10111101  11001100
    // bit3 00010000  00000110  10010101  11110110  00011000  00100000  10011100  01001000  01010111  11010000  10010111  00110110  11101010  11100110  10001001  11111000
    // bit4 01000100  10001001  10011101  10110110  10111110  01101000  00001111  01101010  11100000  00111011  00100001  00011011  00011000  01100110  00010011  11111001
    // bit5 00110010  00110000  10011110  10011000  01011101  10110111  10111010  01111111  00100101  11010010  11010000  11101001  11110010  11100001  10010110  00000001
    // bit6 10100101  00110001  11001101  00111010  00101000  01111110  01000010  10101110  10001101  01010001  01101011  11101001  10000011  11100111  11101011  01111011
    // bit7 11101110  11000100  10111011  01100111  10111011  01010110  11011001  10000010  00100011  00001111  10101100  11011011  11011000  01011001  01001101  11000001
    //
    // Avalanche:
    // bit0 ..X.X.X.  XXXXXXX.  X..X..XX  X..XX.XX  XXX..X..  ..X.X...  ...XXXX.  ..XX...X  X.....XX  .XXXX.X.  .XX.XX..  XXXX.XXX  XXX..X..  XXXXX.XX  XXXX.X.X  ....XXX.
    // bit1 XXX..XX.  .X...X.X  .X..X..X  XX...XXX  ...XX.X.  XX..XXXX  X..X.X..  ..X.X.X.  ...X.XXX  XX.X..X.  .XX....X  ..X...X.  X...XXX.  X....X.X  XXX.X...  XXXX...X
    // bit2 ..X.....  .X..XX.X  ..XXX.XX  ...X.XXX  XXX.XX..  XXX.XXXX  .XXXX...  XX.XX...  .XXXXXXX  XX....XX  .X.XX...  ..X...XX  X.XXXX..  XX..X...  ...X.XXX  .XX..XX.
    // bit3 X.XXX.X.  X.X.XX..  ..XXXXXX  .X.XXX..  X.XX..X.  X...X.X.  ..XX.XX.  XXX...X.  XXXXXX.X  .XXXX.X.  ..XXXX.X  X..XXX..  .X......  .X..XX..  ..X...XX  .X.X..X.
    // bit4 ...X...X  XX.XXX..  XX..X...  XXX...XX  XXX.X.XX  ..XXXX.X  .X.XX.X.  ..XXXXXX  X.XX.X.X  .XX.XXX.  .XXX.X..  .X..XXX.  .X..XX.X  ..XX..XX  .X...XX.  X.X.XX..
    // bit5 .XX..XXX  .XX..X.X  XX..X.XX  XX..XX.X  ....X...  XXX...X.  XXX.XXXX  ..X.X.X.  .XXX....  X....XXX  X....X.X  X.XXXX..  X.X..XXX  X.XX.X..  XX....XX  .X.X.X..
    // bit6 XXXX....  .XX..X..  X..XX...  .XX.XXXX  .XXXXX.X  ..X.X.XX  ...X.XXX  XXXXX.XX  XX.XX...  .....X..  ..XXXXX.  X.XXXX..  XX.X.XX.  X.XX..X.  X.XXXXX.  ..X.XXX.
    // bit7 X.XXX.XX  X..X...X  XXX.XXX.  ..XX..X.  XXX.XXX.  ......XX  X...XX..  XX.X.XXX  .XXX.XX.  .X.XX.X.  XXXXX..X  X...XXX.  X...XX.X  ....XX..  ...XX...  X..X.X..
    // Avalanche: 52.05%

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

    const std::uint8_t aNoiseBuffer[128] = {
        0xA3, 0x49, 0x07, 0x14, 0x61, 0x4B, 0x25, 0x02, 0x69, 0xE1, 0x66, 0x86, 0x48, 0xF1, 0x70, 0x6A,
        0x7F, 0x42, 0xC1, 0xBD, 0x8F, 0x1E, 0x45, 0xFB, 0x3C, 0x51, 0xFB, 0xBE, 0x66, 0x79, 0x1B, 0xE1,
        0x49, 0xA4, 0x4B, 0x5D, 0x9F, 0xAC, 0xA9, 0x05, 0x84, 0x6B, 0x5E, 0x07, 0x0A, 0x67, 0x87, 0x64,
        0xB5, 0x23, 0xC4, 0xF5, 0x5D, 0xD8, 0x6E, 0x09, 0xC3, 0x3C, 0x2E, 0xA4, 0x9E, 0x06, 0xAF, 0x84,
        0x6A, 0x38, 0xCD, 0x70, 0xC2, 0x76, 0x11, 0xF7, 0x94, 0xF6, 0x68, 0xDE, 0x69, 0x01, 0x0D, 0x2B,
        0xF5, 0xE6, 0x2B, 0x34, 0x43, 0x91, 0xF2, 0x5A, 0x67, 0x87, 0x16, 0x99, 0xEF, 0x90, 0x19, 0xAF,
        0x17, 0x95, 0x54, 0x2D, 0x99, 0xE0, 0xB6, 0x02, 0x16, 0xBF, 0x7E, 0x81, 0x41, 0x5A, 0x7A, 0xC7,
        0x36, 0xC3, 0x22, 0xAC, 0xB3, 0xA5, 0xCE, 0xBB, 0xB9, 0x7B, 0x9A, 0x5A, 0x7A, 0xA0, 0x42, 0x4F
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[128] = {
        0xA3, 0x49, 0x07, 0x14, 0x61, 0x4B, 0x25, 0x02, 0x69, 0xE1, 0x66, 0x86, 0x48, 0xF1, 0x70, 0x6A,
        0x7F, 0x42, 0xC1, 0xBD, 0x8F, 0x1E, 0x45, 0xFB, 0x3C, 0x51, 0xFB, 0xBE, 0x66, 0x79, 0x1B, 0xE1,
        0x49, 0xA4, 0x4B, 0x5D, 0x9F, 0xAC, 0xA9, 0x05, 0x84, 0x6B, 0x5E, 0x07, 0x0A, 0x67, 0x87, 0x64,
        0xB5, 0x23, 0xC4, 0xF5, 0x5D, 0xD8, 0x6E, 0x09, 0xC3, 0x3C, 0x2E, 0xA4, 0x9E, 0x06, 0xAF, 0x84,
        0x6A, 0x38, 0xCD, 0x70, 0xC2, 0x76, 0x11, 0xF7, 0x94, 0xF6, 0x68, 0xDE, 0x69, 0x01, 0x0D, 0x2B,
        0xF5, 0xE6, 0x2B, 0x34, 0x43, 0x91, 0xF2, 0x5A, 0x67, 0x87, 0x16, 0x99, 0xEF, 0x90, 0x19, 0xAF,
        0x17, 0x95, 0x54, 0x2D, 0x99, 0xE0, 0xB6, 0x02, 0x16, 0xBF, 0x7E, 0x81, 0x41, 0x5A, 0x7A, 0xC7,
        0x36, 0xC3, 0x22, 0xAC, 0xB3, 0xA5, 0xCE, 0xBB, 0xB9, 0x7B, 0x9A, 0x5A, 0x7A, 0xA0, 0x42, 0x4F
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_C_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_C_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_C_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_C_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_C_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_C_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_D_PepperNoiseXORCipher {

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
    // bit0 01001101  11010111  11110001  00010100  11110110  00100000  00111110  01011111  10001110  11101011  00110010  11010010  00110011  10110000  11011010  10000011
    // bit1 01100101  01011101  11011101  00100111  11110011  00101001  10101110  01010101  00111010  10101011  10101101  11101101  00101011  11110101  00011000  00000001
    // bit2 00001101  10010001  01100011  11101111  00011001  10110010  01010000  00010111  10001100  11001000  01100011  00100001  01011111  11110110  00010100  11010101
    // bit3 01010011  00011110  00000101  11111010  01110100  00100110  10011001  01011110  00110011  10011001  10111111  10111111  10101010  10011001  11101001  00011111
    // bit4 00110111  01000011  11111111  01101010  00100100  01110011  11010010  10010011  11001100  10010111  10000001  11010110  11000110  01000111  11101000  01011111
    // bit5 01000011  10100111  01101100  11011110  10001011  10000101  01100110  00101110  00111100  01111110  00111011  01111111  10110110  01000000  10111110  10100011
    // bit6 11111000  10110000  00111010  00100010  10111111  11100101  01000110  01011111  01111001  10010001  11011010  01000001  10000000  11101100  10001101  00001001
    // bit7 11101000  10111111  01100000  01000111  11110000  00011100  11100000  01111111  11110000  10001010  10101011  11010010  11101100  00101111  10011011  11100110
    //
    // Avalanche:
    // bit0 XXX..XXX  .XXXXX.X  .X.XX.XX  X.XXXXX.  .X.XXX..  X...X.X.  X..X.X..  XXXX.X.X  ..X..X..  .X.....X  X..XX...  .XXXX...  X..XX..X  ...XX.X.  .XXX....  ..X.X..X
    // bit1 XX..XXXX  XXXX.XXX  .XXX.XXX  X...XX.X  .X.XX..X  X.....XX  .....X..  XXXXXXXX  X..X....  .......X  .....XXX  .X...XXX  X......X  .X.XXXXX  X.XX..X.  X.X.X.XX
    // bit2 .X.XX...  XX...X..  ..XX.XX.  X.XXX.X.  .X..XX..  XXX..XXX  .....X.X  .X....X.  XX.XX..X  X..XXX.X  ..XX.XX.  .XXX.X..  ....X.X.  X.X...XX  .X.....X  X.......
    // bit3 .....XX.  .X..X.XX  .X.X....  X.X.XXXX  ..X....X  .XXX..XX  XX..XX..  ....X.XX  .XX..XX.  XX..XX..  XXX.X.X.  XXX.X.X.  XXXXXXXX  XX..XX..  X.XXXX..  .X..X.X.
    // bit4 X..XXX.X  XXX.X..X  .X.X.X.X  XX......  X...XXX.  XX.XX..X  .XXXX...  ..XXX..X  .XX..XX.  ..XXXX.X  ..X.X.XX  .XXXXX..  .XX.XX..  XXX.XX.X  .X....X.  XXXX.X.X
    // bit5 XXX.X..X  ....XX.X  XX...XX.  .XXX.X..  ..X....X  ..X.XXXX  XX..XX..  X....X..  X..X.XX.  XX.X.X..  X..X...X  XX.X.X.X  ...XXX..  XXX.X.X.  ...X.X..  ....X..X
    // bit6 X.X.XX.X  XXX..X.X  .XX.XXXX  .XXX.XXX  XXX.X.X.  X.XX....  ...X..XX  ....X.X.  ..X.XX..  XX...X..  X...XXXX  ...X.X..  XX.X.X.X  X.XXX..X  XX.XX...  .X.XXX..
    // bit7 X.XXXX.X  XXX.X.X.  ..XX.X.X  ...X..X.  X.X..X.X  .X..X..X  X.XX.X.X  ..X.X.X.  X.X..X.X  XX.XXXXX  XXXXXXX.  X....XXX  X.XXX..X  .XXXX.X.  XX..XXX.  X.XX..XX
    // Avalanche: 50.39%

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

    const std::uint8_t aNoiseBuffer[128] = {
        0x03, 0xD7, 0x4B, 0x1A, 0xA3, 0xE8, 0x1C, 0xFC, 0xA7, 0xC8, 0x07, 0xF3, 0x51, 0xD5, 0x9D, 0xED,
        0xC8, 0xED, 0xAF, 0xCA, 0x4E, 0x5C, 0x2A, 0xF8, 0x34, 0x3D, 0x7A, 0x94, 0x3C, 0xE5, 0x7F, 0x61,
        0xC7, 0xD1, 0xDB, 0xF3, 0x26, 0x9A, 0xC6, 0x66, 0x26, 0x0A, 0xFA, 0x29, 0x41, 0x17, 0x38, 0x4E,
        0x59, 0x2F, 0xC5, 0xB8, 0xD0, 0xC6, 0xCE, 0x10, 0x08, 0xD3, 0x05, 0xFB, 0x97, 0xF7, 0xBF, 0xEB,
        0xA9, 0x0B, 0x57, 0x57, 0xEE, 0xAC, 0xD0, 0x12, 0xFB, 0xA4, 0xC4, 0x1E, 0xF5, 0x0C, 0xCD, 0xDA,
        0x5B, 0x22, 0xF5, 0x96, 0x57, 0x50, 0xB7, 0x7D, 0xD9, 0xCF, 0x74, 0x9D, 0x54, 0x5C, 0x9D, 0x76,
        0x1F, 0x29, 0xD5, 0xA4, 0x71, 0x2D, 0xFC, 0xE0, 0xF2, 0x6E, 0xE3, 0xF0, 0x13, 0x6B, 0x29, 0x59,
        0x9F, 0x98, 0x1C, 0xE5, 0xDF, 0x26, 0x85, 0x13, 0xA5, 0x29, 0x05, 0x38, 0x1A, 0x39, 0x9D, 0xFE
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[128] = {
        0x03, 0xD7, 0x4B, 0x1A, 0xA3, 0xE8, 0x1C, 0xFC, 0xA7, 0xC8, 0x07, 0xF3, 0x51, 0xD5, 0x9D, 0xED,
        0xC8, 0xED, 0xAF, 0xCA, 0x4E, 0x5C, 0x2A, 0xF8, 0x34, 0x3D, 0x7A, 0x94, 0x3C, 0xE5, 0x7F, 0x61,
        0xC7, 0xD1, 0xDB, 0xF3, 0x26, 0x9A, 0xC6, 0x66, 0x26, 0x0A, 0xFA, 0x29, 0x41, 0x17, 0x38, 0x4E,
        0x59, 0x2F, 0xC5, 0xB8, 0xD0, 0xC6, 0xCE, 0x10, 0x08, 0xD3, 0x05, 0xFB, 0x97, 0xF7, 0xBF, 0xEB,
        0xA9, 0x0B, 0x57, 0x57, 0xEE, 0xAC, 0xD0, 0x12, 0xFB, 0xA4, 0xC4, 0x1E, 0xF5, 0x0C, 0xCD, 0xDA,
        0x5B, 0x22, 0xF5, 0x96, 0x57, 0x50, 0xB7, 0x7D, 0xD9, 0xCF, 0x74, 0x9D, 0x54, 0x5C, 0x9D, 0x76,
        0x1F, 0x29, 0xD5, 0xA4, 0x71, 0x2D, 0xFC, 0xE0, 0xF2, 0x6E, 0xE3, 0xF0, 0x13, 0x6B, 0x29, 0x59,
        0x9F, 0x98, 0x1C, 0xE5, 0xDF, 0x26, 0x85, 0x13, 0xA5, 0x29, 0x05, 0x38, 0x1A, 0x39, 0x9D, 0xFE
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_D_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_D_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_D_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_D_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_D_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_D_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_E_PepperNoiseXORCipher {

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
    // bit0 00000001  10011010  01100011  11110111  01110000  00010101  10110001  11110111  01110011  11010100  01001011  11001001  10001010  10010100  10111100  01000101
    // bit1 11110100  00001110  01100010  01001010  11010011  11011000  10110000  11011001  00001100  11101111  10110001  00000101  11110100  10001100  00011100  00010000
    // bit2 01110101  00100110  11111000  00000000  10001010  11010101  10111111  11110111  10010100  11111111  01111011  01110101  10000100  00010000  11100111  01001011
    // bit3 10111110  10111000  01010111  01000011  11110111  00101110  10001101  10001101  01010110  11110100  00010101  01111111  11101010  10111100  10111000  00100101
    // bit4 11101000  00001101  00000100  01011100  00101001  11000110  10011101  11010110  01001001  01000000  11010111  11010100  01010111  01111011  10001111  00011001
    // bit5 01000001  10101010  00010000  01100010  11110110  00001011  00001111  00111010  01111110  01100111  10111010  10101000  10010100  00011101  00100100  00110000
    // bit6 10010100  01011000  10011101  01100110  10101010  01111111  10101111  00001101  00001010  01000111  10000000  11010000  00000000  01111110  01101000  11100101
    // bit7 01011001  10110010  10100010  10010001  01001101  01100100  00100011  11110010  10111000  00101110  00101010  10010111  00011010  10001101  11011111  00110101
    //
    // Avalanche:
    // bit0 X.X.X.XX  ..XX....  XX..X..X  .X.XXX.X  XX.XX.X.  X.XXXXXX  ...XX.XX  .X.XXX.X  XX.XX..X  .XXXXXX.  XXX....X  .XX...XX  ..X.....  ..XXXXX.  ...X.XX.  XXX.XXXX
    // bit1 .X.XXXX.  X.X..X..  XX..X...  XXX.....  .XXXX..X  .XXX..X.  ...XX.X.  .XXX..XX  X.X..XX.  .X...X.X  ...XX.XX  X.X.XXXX  .X.XXXX.  ..X..XX.  X.XX.XX.  X.XXX.X.
    // bit2 ..X.....  .XXX..XX  X.X.XX.X  .X.X.X.X  XX.XXXXX  X.......  XXX.X.X.  X.X...X.  XX.....X  X.X.X.X.  ..X.XXX.  ..X.....  XX.X...X  .X...X.X  X.XX..X.  ...XXXX.
    // bit3 XXX.X.XX  XXX.XX.X  ......X.  ...X.XX.  X.X...X.  .XXXX.XX  XX.XX...  XX.XX...  ......XX  X.X....X  .X......  ..X.X.X.  X.XXXXXX  XXX.X..X  XXX.XX.X  .XXX....
    // bit4 X.XXXX.X  .X.XX...  .X.X...X  ....X..X  .XXXXX..  X..X..XX  XX..X...  X.....XX  ...XXX..  ...X.X.X  X.....X.  X......X  ......X.  ..X.XXX.  XX.XX.X.  .X..XX..
    // bit5 ...X.X..  XXXXXXXX  .X...X.X  ..XX.XXX  X.X...XX  .X.XXXX.  .X.XX.X.  .XX.XXXX  ..X.X.XX  ..XX..X.  XXX.XXXX  XXXXXX.X  XX.....X  .X..X...  .XXX...X  .XX..X.X
    // bit6 ..XXXXX.  XXXX..X.  ..XX.XXX  XX..XX..  ........  XX.X.X.X  .....X.X  X.X..XXX  X.X.....  XXX.XX.X  ..X.X.X.  .XXXX.X.  X.X.X.X.  XX.X.X..  XX....X.  .X..XXXX
    // bit7 XXXX..XX  ...XX...  ....X...  ..XXX.XX  XXX..XXX  XX..XXX.  X...X..X  .X.XX...  ...X..X.  X....X..  X.......  ..XXXX.X  X.XX....  ..X..XXX  .XXX.X.X  X..XXXXX
    // Avalanche: 49.22%

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

    const std::uint8_t aNoiseBuffer[128] = {
        0x5A, 0x6D, 0x78, 0x73, 0x19, 0x72, 0x10, 0xA5, 0x95, 0x02, 0x35, 0x93, 0xDE, 0x68, 0xE5, 0x08,
        0x23, 0xF0, 0xE1, 0x36, 0x22, 0x1A, 0xD1, 0x92, 0x81, 0xDE, 0x86, 0x89, 0x48, 0x8A, 0xD6, 0x91,
        0x76, 0xD5, 0x9E, 0xD4, 0x2B, 0x15, 0x76, 0x59, 0x68, 0x6B, 0x13, 0xE2, 0x56, 0xBB, 0x1E, 0xA6,
        0xFA, 0x00, 0xE3, 0xE8, 0x3E, 0x3E, 0x27, 0xBF, 0xF9, 0xE9, 0xA5, 0xED, 0x56, 0xBA, 0xAD, 0xF2,
        0x21, 0x9C, 0x85, 0xB5, 0x4F, 0x74, 0x96, 0x88, 0xF0, 0xFE, 0x75, 0xB0, 0x61, 0xF7, 0x67, 0x66,
        0x4E, 0xA8, 0x65, 0x7C, 0xA5, 0x18, 0xAD, 0xF8, 0x8F, 0xBA, 0x34, 0x3B, 0x94, 0x79, 0x11, 0xF1,
        0xF4, 0x58, 0x50, 0x4D, 0x91, 0x6C, 0x99, 0x08, 0xD1, 0x0A, 0x1A, 0xBE, 0x5F, 0xD7, 0x0A, 0x0D,
        0xB9, 0x23, 0xB6, 0xD1, 0xDB, 0xED, 0x29, 0x29, 0x02, 0xA2, 0x17, 0x4D, 0x28, 0x93, 0x20, 0xBB
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[128] = {
        0x5A, 0x6D, 0x78, 0x73, 0x19, 0x72, 0x10, 0xA5, 0x95, 0x02, 0x35, 0x93, 0xDE, 0x68, 0xE5, 0x08,
        0x23, 0xF0, 0xE1, 0x36, 0x22, 0x1A, 0xD1, 0x92, 0x81, 0xDE, 0x86, 0x89, 0x48, 0x8A, 0xD6, 0x91,
        0x76, 0xD5, 0x9E, 0xD4, 0x2B, 0x15, 0x76, 0x59, 0x68, 0x6B, 0x13, 0xE2, 0x56, 0xBB, 0x1E, 0xA6,
        0xFA, 0x00, 0xE3, 0xE8, 0x3E, 0x3E, 0x27, 0xBF, 0xF9, 0xE9, 0xA5, 0xED, 0x56, 0xBA, 0xAD, 0xF2,
        0x21, 0x9C, 0x85, 0xB5, 0x4F, 0x74, 0x96, 0x88, 0xF0, 0xFE, 0x75, 0xB0, 0x61, 0xF7, 0x67, 0x66,
        0x4E, 0xA8, 0x65, 0x7C, 0xA5, 0x18, 0xAD, 0xF8, 0x8F, 0xBA, 0x34, 0x3B, 0x94, 0x79, 0x11, 0xF1,
        0xF4, 0x58, 0x50, 0x4D, 0x91, 0x6C, 0x99, 0x08, 0xD1, 0x0A, 0x1A, 0xBE, 0x5F, 0xD7, 0x0A, 0x0D,
        0xB9, 0x23, 0xB6, 0xD1, 0xDB, 0xED, 0x29, 0x29, 0x02, 0xA2, 0x17, 0x4D, 0x28, 0x93, 0x20, 0xBB
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_E_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_E_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_E_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_E_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_E_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_E_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_F_PepperNoiseXORCipher {

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
    // bit0 01101011  10001000  00000010  11101111  11011111  01010111  11111111  00011010  11110100  01000010  11101001  11010011  11110110  10011100  10010111  01010111
    // bit1 01001110  00100111  10000000  10001100  00011101  11001001  10000100  00111111  11101110  11010100  11010011  01000011  01011100  00111000  00100001  11101110
    // bit2 11101100  00100110  11010010  10111011  11110110  01011000  10011111  10110101  10010001  11110101  11000100  01111101  10000010  11000111  01011110  01001011
    // bit3 00011011  10110000  11001010  00011010  11101000  01100000  01100111  01001110  01111110  10000001  00101011  10101101  00011110  00101000  10110000  00000010
    // bit4 00110101  11001000  10101110  10110100  11111100  01001010  01000100  00000111  11000011  00001011  10000001  11010101  11110010  00111111  10101101  01101101
    // bit5 10111010  01111010  10001100  11010111  00001100  10010101  11010000  11111101  00010101  11100001  01000111  10000011  11001001  10110100  01111010  11000000
    // bit6 00011110  00000001  11101100  11110001  10111011  01000110  00110001  00101001  01111011  10010100  10001111  00101000  01001011  01010010  01001000  00111011
    // bit7 11011101  11011011  01100010  11110110  10001110  11000000  00101011  10010110  11001100  10001101  11100001  01000111  00010100  10101110  00001000  01000000
    //
    // Avalanche:
    // bit0 XX.....X  ..X...X.  X.X.X...  .X...X.X  .XXX.X.X  XXXXXX.X  .X.X.X.X  X.XX....  .X.XXXX.  XXX.X...  .X....XX  .XXXX..X  .X.XXX..  ..XX.XX.  ..XXXX.X  XXXXXX.X
    // bit1 ...XX.XX  .XXX..X.  XX.X.X.X  XX.XX..X  .X..X...  X..XXX..  XX.X...X  .XX.X.X.  X.XXX.XX  X......X  X....XX.  ...X.XX.  ....X..X  .XX.XX.X  .XXX.X..  X.XXX.XX
    // bit2 .X...XX.  X...XX..  .XXXX...  ...X...X  .X.XXX..  XXXX..X.  ..XX.X.X  ...XXXXX  ..XXX.XX  .X.XXXXX  .XX.XXX.  XX.X.XXX  ..X.X...  .XX.XX.X  XXXX.X..  XXX....X
    // bit3 .X..XXX.  XXX..X.X  X..XXXXX  .X..XXXX  X.XXXX.X  ..XX.X.X  ..XX..X.  ...XX.XX  ..X.X.XX  XX.X.X..  .XXXXXX.  XXXXX...  .X..X.XX  .XXXXX.X  XXX..X.X  .X.X.XXX
    // bit4 X..XXXXX  .XX...X.  .....X..  ...XXXX.  .X.X.XX.  XXX.....  XXX.XXX.  X.X.XX.X  .XX.X..X  X.X....X  ..X.X.XX  .XXXXXXX  .X.XX...  X..X.X.X  .....XXX  XX...XXX
    // bit5 XXX.XXXX  ..X.XXXX  XX.XX..X  X.....X.  .X.XX..X  XX......  X....X.X  X.X.X...  .X......  X.XX.X..  ...X..X.  XX.X.XX.  X..XXX..  XXX....X  ..X.XXXX  X..X.X.X
    // bit6 X.XX.X..  X.X.X.XX  .X...XX.  .X.XX.XX  ...X...X  XXX.XX..  X..XX.XX  X.....XX  XX.X...X  ..XXXXX.  ..X..X.X  X.....X.  XXX....X  XXXXX...  XXX...X.  X..X...X
    // bit7 X...X...  X...XXX.  ..XX.XXX  X.X...XX  XX.XX.XX  X..X.X.X  .XXXXXX.  XX....XX  X..XX..X  XX.XX...  X.XX.X..  ...X..X.  .X.....X  XXXXX.XX  .X.XXX.X  ...X.X.X
    // Avalanche: 51.46%

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

    const std::uint8_t aNoiseBuffer[128] = {
        0x25, 0xE1, 0xAC, 0x1F, 0xF7, 0x6B, 0xD6, 0x99, 0x99, 0x0D, 0x74, 0x15, 0x8D, 0x60, 0x65, 0x43,
        0x7E, 0x33, 0x0B, 0x20, 0x1E, 0x0E, 0xB9, 0x00, 0xEF, 0x87, 0xAB, 0x3F, 0xF0, 0xCD, 0xB5, 0xA6,
        0xBB, 0xB8, 0x3A, 0xEA, 0xDF, 0xED, 0xA3, 0xC2, 0x45, 0xFB, 0x10, 0xA4, 0x68, 0x86, 0x8A, 0xC4,
        0xE4, 0x9C, 0x93, 0xA6, 0xA1, 0xF8, 0xB1, 0xB3, 0x25, 0x14, 0x66, 0xE5, 0xD6, 0x7D, 0xD9, 0x6E,
        0xE9, 0xDB, 0xD2, 0xB6, 0x53, 0xD5, 0x5A, 0x2E, 0x77, 0xE4, 0x24, 0x62, 0x09, 0x63, 0x88, 0x3D,
        0xEB, 0xE5, 0x91, 0x40, 0x92, 0x26, 0x56, 0xDF, 0x9C, 0xE9, 0x32, 0xA8, 0x32, 0x39, 0xC5, 0xFD,
        0xAC, 0xCE, 0x88, 0xD9, 0x56, 0xD1, 0xBA, 0x06, 0xA5, 0x22, 0x5D, 0xCE, 0xD9, 0xAD, 0x2B, 0x28,
        0x98, 0x26, 0x5C, 0xB4, 0x2F, 0xA8, 0xA4, 0xC8, 0x44, 0xED, 0x4A, 0x82, 0x6A, 0xC8, 0xF2, 0xAA
    };

    PepperNoiseXORCipher aCrypt(aMaskBuffer,
        aNoiseBuffer);

    const std::uint8_t aExpected[128] = {
        0x25, 0xE1, 0xAC, 0x1F, 0xF7, 0x6B, 0xD6, 0x99, 0x99, 0x0D, 0x74, 0x15, 0x8D, 0x60, 0x65, 0x43,
        0x7E, 0x33, 0x0B, 0x20, 0x1E, 0x0E, 0xB9, 0x00, 0xEF, 0x87, 0xAB, 0x3F, 0xF0, 0xCD, 0xB5, 0xA6,
        0xBB, 0xB8, 0x3A, 0xEA, 0xDF, 0xED, 0xA3, 0xC2, 0x45, 0xFB, 0x10, 0xA4, 0x68, 0x86, 0x8A, 0xC4,
        0xE4, 0x9C, 0x93, 0xA6, 0xA1, 0xF8, 0xB1, 0xB3, 0x25, 0x14, 0x66, 0xE5, 0xD6, 0x7D, 0xD9, 0x6E,
        0xE9, 0xDB, 0xD2, 0xB6, 0x53, 0xD5, 0x5A, 0x2E, 0x77, 0xE4, 0x24, 0x62, 0x09, 0x63, 0x88, 0x3D,
        0xEB, 0xE5, 0x91, 0x40, 0x92, 0x26, 0x56, 0xDF, 0x9C, 0xE9, 0x32, 0xA8, 0x32, 0x39, 0xC5, 0xFD,
        0xAC, 0xCE, 0x88, 0xD9, 0x56, 0xD1, 0xBA, 0x06, 0xA5, 0x22, 0x5D, 0xCE, 0xD9, 0xAD, 0x2B, 0x28,
        0x98, 0x26, 0x5C, 0xB4, 0x2F, 0xA8, 0xA4, 0xC8, 0x44, 0xED, 0x4A, 0x82, 0x6A, 0xC8, 0xF2, 0xAA
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_F_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_F_PepperNoiseXORCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_F_PepperNoiseXORCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_F_PepperNoiseXORCipher")) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_F_PepperNoiseXORCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PepperNoiseXORCipher] test_fixed_128_F_PepperNoiseXORCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

@end
