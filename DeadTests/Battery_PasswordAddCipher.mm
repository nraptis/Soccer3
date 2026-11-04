//
//  Battery_PasswordAddCipher.m
//  HolyStorms
//
//  Created by icarus black on 7/5/26.
//

#import <XCTest/XCTest.h>
#import "PasswordAddCipher.hpp"
#import "PrintExamplesHelper.hpp"
#import "CipherGauntlet.hpp"
#include <memory>

@interface Battery_PasswordAddCipher : XCTestCase

@end

@implementation Battery_PasswordAddCipher

- (void)test_gauntlet_PasswordAddCipher {
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
    static std::uint8_t aRandI[SOCCER_BLOCK_SIZE];
    static std::uint8_t aRandJ[SOCCER_BLOCK_SIZE];
    static std::uint8_t aRandK[SOCCER_BLOCK_SIZE];
    static std::uint8_t aRandL[SOCCER_BLOCK_SIZE];
    static std::uint8_t aRandM[SOCCER_BLOCK_SIZE];
    static std::uint8_t aRandN[SOCCER_BLOCK_SIZE];
    static std::uint8_t aRandO[SOCCER_BLOCK_SIZE];
    static std::uint8_t aRandP[SOCCER_BLOCK_SIZE];
    
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
    CipherGauntlet::ArrayRandomize(aRandI, SOCCER_BLOCK_SIZE);
    CipherGauntlet::ArrayRandomize(aRandJ, SOCCER_BLOCK_SIZE);
    CipherGauntlet::ArrayRandomize(aRandK, SOCCER_BLOCK_SIZE);
    CipherGauntlet::ArrayRandomize(aRandL, SOCCER_BLOCK_SIZE);
    CipherGauntlet::ArrayRandomize(aRandM, SOCCER_BLOCK_SIZE);
    CipherGauntlet::ArrayRandomize(aRandN, SOCCER_BLOCK_SIZE);
    CipherGauntlet::ArrayRandomize(aRandO, SOCCER_BLOCK_SIZE);
    CipherGauntlet::ArrayRandomize(aRandP, SOCCER_BLOCK_SIZE);
    
    std::vector<std::uint8_t *> aListMask;
    std::vector<std::uint8_t *> aListMaskJumps;
    
    aListMask.push_back(aRandA); aListMask.push_back(aRandB); aListMask.push_back(aRandC); aListMask.push_back(aRandD);
    aListMask.push_back(aRandE); aListMask.push_back(aRandF); aListMask.push_back(aRandG); aListMask.push_back(aRandH);
    aListMask.push_back(aRandI); aListMask.push_back(aRandJ); aListMask.push_back(aRandK); aListMask.push_back(aRandL);
    aListMask.push_back(aRandM); aListMask.push_back(aRandN); aListMask.push_back(aRandO); aListMask.push_back(aRandP);
    aListMask.push_back(aAllZero); aListMask.push_back(aAllOne);
    
    static CipherGauntlet aGauntlet;
    
    for (std::size_t aIndexA=0; aIndexA<aListMask.size(); aIndexA++) {
        std::uint8_t *aMask = aListMask[aIndexA];
        
        PasswordAddCipher aCipher(aMask);
        if (!aGauntlet.RunCipher(&aCipher,
                                 32,
                                 "PasswordAddCipher")) {
            XCTFail("[PasswordAddCipher] test_gauntlet_PasswordAddCipher failed.");
            return;
        }
        
    }
}

- (void)test_fixed_32_A_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_A_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_A_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_A_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_A_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_A_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_A_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_B_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_B_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_B_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_B_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_B_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_B_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_B_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_C_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_C_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_C_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_C_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_C_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_C_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_C_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_D_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_D_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_D_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_D_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_D_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_D_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_D_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_E_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_E_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_E_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_E_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_E_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_E_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_E_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_F_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_F_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_F_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_F_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_F_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_F_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_F_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_G_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_G_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_G_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_G_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_G_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_G_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_G_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_H_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_H_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_H_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_H_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_H_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_H_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_H_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_I_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_I_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_I_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_I_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_I_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_I_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_I_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_J_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_J_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_J_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_J_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_J_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_J_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_J_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_K_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_K_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_K_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_K_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_K_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_K_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_K_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_L_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_L_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_L_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_L_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_L_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_32_L_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_32_L_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_A_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_64_A_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_A_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_A_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_A_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_A_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_A_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_B_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_64_B_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_B_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_B_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_B_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_B_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_B_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_C_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_64_C_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_C_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_C_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_C_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_C_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_C_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_D_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_64_D_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_D_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_D_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_D_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_D_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_D_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_E_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_64_E_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_E_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_E_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_E_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_E_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_E_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_F_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_64_F_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_F_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_F_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_F_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_F_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_F_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_G_PasswordAddCipher {

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
    // bit0 10101001  10101010  01101010  10011010  10100110  10101001  10101010  01101010
    // bit1 10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001
    // bit2 10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001
    // bit3 01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110
    // bit4 01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110
    // bit5 01011010  10010110  10100101  10101001  01101010  01011010  10010110  10100101
    // bit6 01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......
    // bit1 ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX  XX....XX
    // bit2 ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......
    // bit3 XXXX..XX  ..XXXX..  XX..XXXX  ..XX..XX  XX..XX..  XXXX..XX  ..XXXX..  XX..XXXX
    // bit4 ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......
    // bit5 ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX  XX....XX
    // bit6 ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......
    // bit7 .X.XX..X  X..X.XX.  .XX..X.X  X..XX..X  .XX..XX.  .X.XX..X  X..X.XX.  .XX..X.X
    // Avalanche: 38.28%

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

    PasswordAddCipher aCrypt(aMaskBuffer);

    const std::uint8_t aExpected[64] = {
        0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78,
        0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E,
        0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA,
        0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_G_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_G_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_G_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_G_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_G_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_G_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_H_PasswordAddCipher {

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
    // bit0 01100101  01011001  01010110  01010101  10010101  01100101  01011001  01010110
    // bit1 01011010  01010110  10010101  10100101  01101001  01011010  01010110  10010101
    // bit2 01101010  01011010  10010110  10100101  10101001  01101010  01011010  10010110
    // bit3 01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101
    // bit4 01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110
    // bit5 01010110  10010101  10100101  01101001  01011010  01010110  10010101  10100101
    // bit6 01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX
    // bit1 ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX  XX....XX
    // bit2 ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX
    // bit3 ..XX..XX  XX..XX..  XXXX..XX  ..XXXX..  XX..XXXX  ..XX..XX  XX..XX..  XXXX..XX
    // bit4 ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX
    // bit5 ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX  XX....XX
    // bit6 ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX
    // bit7 .XX..XX.  X..XX..X  X.X..XX.  .XX.X..X  X..XX.X.  .XX..XX.  X..XX..X  X.X..XX.
    // Avalanche: 39.45%

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

    PasswordAddCipher aCrypt(aMaskBuffer);

    const std::uint8_t aExpected[64] = {
        0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86,
        0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE,
        0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98,
        0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_H_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_H_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_H_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_H_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_H_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_H_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_I_PasswordAddCipher {

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
    // bit0 10001010  11100010  10111000  10101110  00101011  10001010  11100010  10111000
    // bit1 11100110  00111001  10001110  01100011  10011000  11100110  00111001  10001110
    // bit2 11000110  01110001  10011100  01100111  00011001  11000110  01110001  10011100
    // bit3 00101111  00001011  11000010  11110000  10111100  00101111  00001011  11000010
    // bit4 00001111  01000011  11010000  11110100  00111101  00001111  01000011  11010000
    // bit5 01100011  10011000  11100110  00111001  10001110  01100011  10011000  11100110
    // bit6 01000011  11010000  11110100  00111101  00001111  01000011  11010000  11110100
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...  ...X..X.
    // bit1 .XX.XX..  XX.XX.XX  ..XX.XX.  XX..XX.X  X.XX..XX  .XX.XX..  XX.XX.XX  ..XX.XX.
    // bit2 ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...  ...X..X.
    // bit3 XXX.X..X  .XXXX.X.  .X.XXXX.  X..X.XXX  X.X..X.X  XXX.X..X  .XXXX.X.  .X.XXXX.
    // bit4 ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...  ...X..X.
    // bit5 .XX.XX..  XX.XX.XX  ..XX.XX.  XX..XX.X  X.XX..XX  .XX.XX..  XX.XX.XX  ..XX.XX.
    // bit6 ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...  ...X..X.
    // bit7 .X....XX  XX.X....  XXXX.X..  ..XXXX.X  ....XXXX  .X....XX  XX.X....  XXXX.X..
    // Avalanche: 38.67%

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

    PasswordAddCipher aCrypt(aMaskBuffer);

    const std::uint8_t aExpected[64] = {
        0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78,
        0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66,
        0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E,
        0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_I_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_I_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_I_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_I_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_I_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_I_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_J_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_64_J_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_J_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_J_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_J_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_J_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_J_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_K_PasswordAddCipher {

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
    // bit1 10101010  01010101  01010101  10101010  10101010  10101010  01010101  01010101
    // bit2 10101010  01010101  01010101  01010101  10101010  10101010  01010101  01010101
    // bit3 01010101  10101010  01010101  10101010  10101010  01010101  10101010  01010101
    // bit4 01010101  10101010  01010101  01010101  10101010  01010101  10101010  01010101
    // bit5 01010101  01010101  10101010  10101010  10101010  01010101  01010101  10101010
    // bit6 01010101  01010101  10101010  01010101  10101010  01010101  01010101  10101010
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  XXXXXXXX  ........  ........  ........  ........
    // bit1 ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit2 ........  ........  ........  XXXXXXXX  ........  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  ........  XXXXXXXX  ........  XXXXXXXX  XXXXXXXX  ........
    // bit4 ........  ........  ........  XXXXXXXX  ........  ........  ........  ........
    // bit5 ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX
    // bit6 ........  ........  ........  XXXXXXXX  ........  ........  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.
    // Avalanche: 35.94%

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

    PasswordAddCipher aCrypt(aMaskBuffer);

    const std::uint8_t aExpected[64] = {
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0xFE, 0x00, 0xFE, 0x00, 0xFE, 0x00, 0xFE, 0x00, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_K_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_K_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_K_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_K_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_K_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_K_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_L_PasswordAddCipher {

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
    // bit0 10000101  01010101  01011110  10000000  10101000  01011110  10101111  11101000
    // bit1 10101010  10101000  01010101  01111111  11101000  00000001  01010101  11101010
    // bit2 10101010  00010101  01010101  01111010  10101000  00000001  01111111  11101010
    // bit3 01010000  10101000  00001010  10101111  11101010  11110101  01010101  01010101
    // bit4 01010000  00010101  00001010  10101010  10101010  11110101  01111111  01010101
    // bit5 01111111  11101000  00000001  01010101  11101010  10101010  10000101  01010111
    // bit6 01111111  01010101  00000001  01010000  10101010  10101010  10101111  01010111
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  X.XXXX.X  ........  .....X.X  .X......  ........  ..X.X.X.  ........
    // bit1 ..X.XXXX  XXXXXX.X  ....X.XX  XXXXXXXX  .X......  .X.XXXXX  XXXXX.X.  ......X.
    // bit2 ........  X.XXXX.X  ........  .....X.X  .X......  ........  ..X.X.X.  ........
    // bit3 XXXXX.X.  X.XXXX.X  .X.XXXXX  XX.X.X.X  .X....X.  XXXX.X..  ..X.X.X.  X.XXXXXX
    // bit4 ........  X.XXXX.X  ........  .....X.X  .X......  ........  ..X.X.X.  ........
    // bit5 ..X.XXXX  XXXXXX.X  ....X.XX  XXXXXXXX  .X......  .X.XXXXX  XXXXX.X.  ......X.
    // bit6 ........  X.XXXX.X  ........  .....X.X  .X......  ........  ..X.X.X.  ........
    // bit7 .XXXXXXX  .X.X.X.X  .......X  .X.X....  X.X.X.X.  X.X.X.X.  X.X.XXXX  .X.X.XXX
    // Avalanche: 38.09%

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

    PasswordAddCipher aCrypt(aMaskBuffer);

    const std::uint8_t aExpected[64] = {
        0xE0, 0x1E, 0x66, 0x1E, 0x66, 0x86, 0x66, 0x86, 0x54, 0x86, 0x54, 0xAA, 0x54, 0xAA, 0x00, 0xAA,
        0x00, 0xE0, 0x00, 0xE0, 0x98, 0xE0, 0x98, 0x66, 0x98, 0x66, 0x78, 0x66, 0x78, 0x54, 0x78, 0x54,
        0xFE, 0x54, 0xFE, 0x00, 0xFE, 0x00, 0x1E, 0x00, 0x1E, 0x98, 0x1E, 0x98, 0x86, 0x98, 0x86, 0x78,
        0x86, 0x78, 0xAA, 0x78, 0xAA, 0xFE, 0xAA, 0xFE, 0xE0, 0xFE, 0xE0, 0x1E, 0xE0, 0x1E, 0x66, 0x1E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_64_L_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_L_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_L_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_L_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_64_L_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_64_L_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_A_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_96_A_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_A_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_A_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_A_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_A_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_A_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_B_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_96_B_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_B_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_B_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_B_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_B_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_B_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_C_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_96_C_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_C_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_C_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_C_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_C_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_C_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_D_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_96_D_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_D_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_D_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_D_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_D_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_D_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_E_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_96_E_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_E_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_E_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_E_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_E_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_E_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_F_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_96_F_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_F_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_F_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_F_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_F_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_F_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_G_PasswordAddCipher {

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
    // bit0 10101001  10101010  01101010  10011010  10100110  10101001  10101010  01101010  10011010  10100110  10101001  10101010
    // bit1 10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001  01101010  01011010  10010110  10100101
    // bit2 10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001  01011010  01010110  10010101  10100101
    // bit3 01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110  10011001
    // bit4 01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101  10011001
    // bit5 01011010  10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001  01101010  01011010  10010110
    // bit6 01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110  01011001  10010110
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........
    // bit1 ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX
    // bit2 ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........
    // bit3 XXXX..XX  ..XXXX..  XX..XXXX  ..XX..XX  XX..XX..  XXXX..XX  ..XXXX..  XX..XXXX  ..XX..XX  XX..XX..  XXXX..XX  ..XXXX..
    // bit4 ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........
    // bit5 ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX
    // bit6 ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........
    // bit7 .X.XX..X  X..X.XX.  .XX..X.X  X..XX..X  .XX..XX.  .X.XX..X  X..X.XX.  .XX..X.X  X..XX..X  .XX..XX.  .X.XX..X  X..X.XX.
    // Avalanche: 38.28%

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

    PasswordAddCipher aCrypt(aMaskBuffer);

    const std::uint8_t aExpected[96] = {
        0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78,
        0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E,
        0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA,
        0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66,
        0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00,
        0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_G_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_G_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_G_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_G_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_G_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_G_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_H_PasswordAddCipher {

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
    // bit0 01100101  01011001  01010110  01010101  10010101  01100101  01011001  01010110  01010101  10010101  01100101  01011001
    // bit1 01011010  01010110  10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001  01011010  01010110
    // bit2 01101010  01011010  10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001  01101010  01011010
    // bit3 01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110  01011001  10010110
    // bit4 01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110  01101001  10011010
    // bit5 01010110  10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001  01011010  01010110  10010101
    // bit6 01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110  10011001
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..
    // bit1 ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX
    // bit2 ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..
    // bit3 ..XX..XX  XX..XX..  XXXX..XX  ..XXXX..  XX..XXXX  ..XX..XX  XX..XX..  XXXX..XX  ..XXXX..  XX..XXXX  ..XX..XX  XX..XX..
    // bit4 ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..
    // bit5 ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX
    // bit6 ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..
    // bit7 .XX..XX.  X..XX..X  X.X..XX.  .XX.X..X  X..XX.X.  .XX..XX.  X..XX..X  X.X..XX.  .XX.X..X  X..XX.X.  .XX..XX.  X..XX..X
    // Avalanche: 39.06%

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

    PasswordAddCipher aCrypt(aMaskBuffer);

    const std::uint8_t aExpected[96] = {
        0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86,
        0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE,
        0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98,
        0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54,
        0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0,
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
                                                    "test_fixed_96_H_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_H_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_H_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_H_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_H_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_H_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_I_PasswordAddCipher {

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
    // bit1 11100110  00111001  10001110  01100011  10011000  11100110  00111001  10001110  01100011  10011000  11100110  00111001
    // bit2 11000110  01110001  10011100  01100111  00011001  11000110  01110001  10011100  01100111  00011001  11000110  01110001
    // bit3 00101111  00001011  11000010  11110000  10111100  00101111  00001011  11000010  11110000  10111100  00101111  00001011
    // bit4 00001111  01000011  11010000  11110100  00111101  00001111  01000011  11010000  11110100  00111101  00001111  01000011
    // bit5 01100011  10011000  11100110  00111001  10001110  01100011  10011000  11100110  00111001  10001110  01100011  10011000
    // bit6 01000011  11010000  11110100  00111101  00001111  01000011  11010000  11110100  00111101  00001111  01000011  11010000
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...
    // bit1 .XX.XX..  XX.XX.XX  ..XX.XX.  XX..XX.X  X.XX..XX  .XX.XX..  XX.XX.XX  ..XX.XX.  XX..XX.X  X.XX..XX  .XX.XX..  XX.XX.XX
    // bit2 ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...
    // bit3 XXX.X..X  .XXXX.X.  .X.XXXX.  X..X.XXX  X.X..X.X  XXX.X..X  .XXXX.X.  .X.XXXX.  X..X.XXX  X.X..X.X  XXX.X..X  .XXXX.X.
    // bit4 ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...
    // bit5 .XX.XX..  XX.XX.XX  ..XX.XX.  XX..XX.X  X.XX..XX  .XX.XX..  XX.XX.XX  ..XX.XX.  XX..XX.X  X.XX..XX  .XX.XX..  XX.XX.XX
    // bit6 ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...
    // bit7 .X....XX  XX.X....  XXXX.X..  ..XXXX.X  ....XXXX  .X....XX  XX.X....  XXXX.X..  ..XXXX.X  ....XXXX  .X....XX  XX.X....
    // Avalanche: 38.54%

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

    PasswordAddCipher aCrypt(aMaskBuffer);

    const std::uint8_t aExpected[96] = {
        0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78,
        0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66,
        0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E,
        0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00,
        0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA,
        0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_I_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_I_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_I_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_I_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_I_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_I_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_J_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_96_J_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_J_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_J_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_J_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_J_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_J_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_K_PasswordAddCipher {

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
    // bit0 10101010  10101010  10101010  01010101  10101010  10101010  10101010  10101010  01010101  10101010  10101010  10101010
    // bit1 10101010  01010101  01010101  10101010  10101010  10101010  01010101  01010101  10101010  10101010  10101010  01010101
    // bit2 10101010  01010101  01010101  01010101  10101010  10101010  01010101  01010101  01010101  10101010  10101010  01010101
    // bit3 01010101  10101010  01010101  10101010  10101010  01010101  10101010  01010101  10101010  10101010  01010101  10101010
    // bit4 01010101  10101010  01010101  01010101  10101010  01010101  10101010  01010101  01010101  10101010  01010101  10101010
    // bit5 01010101  01010101  10101010  10101010  10101010  01010101  01010101  10101010  10101010  10101010  01010101  01010101
    // bit6 01010101  01010101  10101010  01010101  10101010  01010101  01010101  10101010  01010101  10101010  01010101  01010101
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  XXXXXXXX  ........  ........  ........  ........  XXXXXXXX  ........  ........  ........
    // bit1 ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX
    // bit2 ........  ........  ........  XXXXXXXX  ........  ........  ........  ........  XXXXXXXX  ........  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  ........  XXXXXXXX  ........  XXXXXXXX  XXXXXXXX  ........  XXXXXXXX  ........  XXXXXXXX  XXXXXXXX
    // bit4 ........  ........  ........  XXXXXXXX  ........  ........  ........  ........  XXXXXXXX  ........  ........  ........
    // bit5 ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX
    // bit6 ........  ........  ........  XXXXXXXX  ........  ........  ........  ........  XXXXXXXX  ........  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X
    // Avalanche: 37.50%

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

    PasswordAddCipher aCrypt(aMaskBuffer);

    const std::uint8_t aExpected[96] = {
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0xFE, 0x00, 0xFE, 0x00, 0xFE, 0x00, 0xFE, 0x00, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0xFE, 0x00, 0xFE, 0x00, 0xFE, 0x00, 0xFE, 0x00,
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_K_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_K_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_K_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_K_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_K_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_K_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_L_PasswordAddCipher {

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
    // bit0 10000101  01010101  01011110  10000000  10101000  01011110  10101111  11101000  01010101  01010101  11101000  00001010
    // bit1 10101010  10101000  01010101  01111111  11101000  00000001  01010101  11101010  10101010  10000101  01010111  11111110
    // bit2 10101010  00010101  01010101  01111010  10101000  00000001  01111111  11101010  10100001  01010101  01010111  10101010
    // bit3 01010000  10101000  00001010  10101111  11101010  11110101  01010101  01010101  00001010  10000000  10101010  11111110
    // bit4 01010000  00010101  00001010  10101010  10101010  11110101  01111111  01010101  00000001  01010000  10101010  10101010
    // bit5 01111111  11101000  00000001  01010101  11101010  10101010  10000101  01010111  11111110  10000000  00010101  01011110
    // bit6 01111111  01010101  00000001  01010000  10101010  10101010  10101111  01010111  11110101  01010000  00010101  00001010
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  X.XXXX.X  ........  .....X.X  .X......  ........  ..X.X.X.  ........  ....X.XX  XX.X....  ........  .X.X.X..
    // bit1 ..X.XXXX  XXXXXX.X  ....X.XX  XXXXXXXX  .X......  .X.XXXXX  XXXXX.X.  ......X.  XXXXXXXX  XX.X....  X.XXXXXX  XXXX.X..
    // bit2 ........  X.XXXX.X  ........  .....X.X  .X......  ........  ..X.X.X.  ........  ....X.XX  XX.X....  ........  .X.X.X..
    // bit3 XXXXX.X.  X.XXXX.X  .X.XXXXX  XX.X.X.X  .X....X.  XXXX.X..  ..X.X.X.  X.XXXXXX  X.X.X.XX  XX.X.X.X  XXXXXX.X  .X.X.X..
    // bit4 ........  X.XXXX.X  ........  .....X.X  .X......  ........  ..X.X.X.  ........  ....X.XX  XX.X....  ........  .X.X.X..
    // bit5 ..X.XXXX  XXXXXX.X  ....X.XX  XXXXXXXX  .X......  .X.XXXXX  XXXXX.X.  ......X.  XXXXXXXX  XX.X....  X.XXXXXX  XXXX.X..
    // bit6 ........  X.XXXX.X  ........  .....X.X  .X......  ........  ..X.X.X.  ........  ....X.XX  XX.X....  ........  .X.X.X..
    // bit7 .XXXXXXX  .X.X.X.X  .......X  .X.X....  X.X.X.X.  X.X.X.X.  X.X.XXXX  .X.X.XXX  XXXX.X.X  .X.X....  ...X.X.X  ....X.X.
    // Avalanche: 40.36%

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

    PasswordAddCipher aCrypt(aMaskBuffer);

    const std::uint8_t aExpected[96] = {
        0xE0, 0x1E, 0x66, 0x1E, 0x66, 0x86, 0x66, 0x86, 0x54, 0x86, 0x54, 0xAA, 0x54, 0xAA, 0x00, 0xAA,
        0x00, 0xE0, 0x00, 0xE0, 0x98, 0xE0, 0x98, 0x66, 0x98, 0x66, 0x78, 0x66, 0x78, 0x54, 0x78, 0x54,
        0xFE, 0x54, 0xFE, 0x00, 0xFE, 0x00, 0x1E, 0x00, 0x1E, 0x98, 0x1E, 0x98, 0x86, 0x98, 0x86, 0x78,
        0x86, 0x78, 0xAA, 0x78, 0xAA, 0xFE, 0xAA, 0xFE, 0xE0, 0xFE, 0xE0, 0x1E, 0xE0, 0x1E, 0x66, 0x1E,
        0x66, 0x86, 0x66, 0x86, 0x54, 0x86, 0x54, 0xAA, 0x54, 0xAA, 0x00, 0xAA, 0x00, 0xE0, 0x00, 0xE0,
        0x98, 0xE0, 0x98, 0x66, 0x98, 0x66, 0x78, 0x66, 0x78, 0x54, 0x78, 0x54, 0xFE, 0x54, 0xFE, 0x00
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_96_L_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_L_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_L_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_L_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_96_L_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_96_L_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_A_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_128_A_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_A_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_A_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_A_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_A_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_A_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_B_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_128_B_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_B_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_B_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_B_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_B_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_B_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_C_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_128_C_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_C_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_C_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_C_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_C_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_C_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_D_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_128_D_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_D_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_D_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_D_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_D_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_D_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_E_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_128_E_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_E_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_E_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_E_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_E_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_E_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_F_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_128_F_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_F_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_F_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_F_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_F_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_F_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_G_PasswordAddCipher {

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
    // bit0 10101001  10101010  01101010  10011010  10100110  10101001  10101010  01101010  10011010  10100110  10101001  10101010  01101010  10011010  10100110  10101001
    // bit1 10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001  01101010  01011010  10010110
    // bit2 10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001  01011010  01010110  10010101
    // bit3 01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110
    // bit4 01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101
    // bit5 01011010  10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001  01101010  01011010
    // bit6 01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110  01011001
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX
    // bit1 ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX
    // bit2 ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX
    // bit3 XXXX..XX  ..XXXX..  XX..XXXX  ..XX..XX  XX..XX..  XXXX..XX  ..XXXX..  XX..XXXX  ..XX..XX  XX..XX..  XXXX..XX  ..XXXX..  XX..XXXX  ..XX..XX  XX..XX..  XXXX..XX
    // bit4 ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX
    // bit5 ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX
    // bit6 ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX
    // bit7 .X.XX..X  X..X.XX.  .XX..X.X  X..XX..X  .XX..XX.  .X.XX..X  X..X.XX.  .XX..X.X  X..XX..X  .XX..XX.  .X.XX..X  X..X.XX.  .XX..X.X  X..XX..X  .XX..XX.  .X.XX..X
    // Avalanche: 39.26%

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

    PasswordAddCipher aCrypt(aMaskBuffer);

    const std::uint8_t aExpected[128] = {
        0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78,
        0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E,
        0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA,
        0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66,
        0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00,
        0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78,
        0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E, 0x98, 0x66, 0x86, 0x78, 0x54, 0xAA, 0xFE, 0x00, 0xE0, 0x1E,
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
                                                    "test_fixed_128_G_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_G_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_G_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_G_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_G_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_G_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_H_PasswordAddCipher {

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
    // bit0 01100101  01011001  01010110  01010101  10010101  01100101  01011001  01010110  01010101  10010101  01100101  01011001  01010110  01010101  10010101  01100101
    // bit1 01011010  01010110  10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001  01011010
    // bit2 01101010  01011010  10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001  01101010  01011010  10010110  10100101  10101001  01101010
    // bit3 01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110  01011001  10010110  01100101  10011001  01100110  01011001
    // bit4 01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110  01101001
    // bit5 01010110  10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001  01011010  01010110  10010101  10100101  01101001  01011010  01010110
    // bit6 01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110  10011001  10100110  01101001  10011010  01100110
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....
    // bit1 ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX
    // bit2 ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....
    // bit3 ..XX..XX  XX..XX..  XXXX..XX  ..XXXX..  XX..XXXX  ..XX..XX  XX..XX..  XXXX..XX  ..XXXX..  XX..XXXX  ..XX..XX  XX..XX..  XXXX..XX  ..XXXX..  XX..XXXX  ..XX..XX
    // bit4 ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....
    // bit5 ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX  ....XXXX  XX....XX  XXXX....  XXXXXX..  ..XXXXXX
    // bit6 ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....  ....XX..  ......XX  ........  XX......  ..XX....
    // bit7 .XX..XX.  X..XX..X  X.X..XX.  .XX.X..X  X..XX.X.  .XX..XX.  X..XX..X  X.X..XX.  .XX.X..X  X..XX.X.  .XX..XX.  X..XX..X  X.X..XX.  .XX.X..X  X..XX.X.  .XX..XX.
    // Avalanche: 39.06%

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

    PasswordAddCipher aCrypt(aMaskBuffer);

    const std::uint8_t aExpected[128] = {
        0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86,
        0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE,
        0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98,
        0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54,
        0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0,
        0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86,
        0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE,
        0xAA, 0x54, 0x78, 0x86, 0x66, 0x98, 0x1E, 0xE0, 0x00, 0xFE, 0xAA, 0x54, 0x78, 0x86, 0x66, 0x98
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_H_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_H_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_H_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_H_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_H_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_H_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_I_PasswordAddCipher {

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
    // bit0 10001010  11100010  10111000  10101110  00101011  10001010  11100010  10111000  10101110  00101011  10001010  11100010  10111000  10101110  00101011  10001010
    // bit1 11100110  00111001  10001110  01100011  10011000  11100110  00111001  10001110  01100011  10011000  11100110  00111001  10001110  01100011  10011000  11100110
    // bit2 11000110  01110001  10011100  01100111  00011001  11000110  01110001  10011100  01100111  00011001  11000110  01110001  10011100  01100111  00011001  11000110
    // bit3 00101111  00001011  11000010  11110000  10111100  00101111  00001011  11000010  11110000  10111100  00101111  00001011  11000010  11110000  10111100  00101111
    // bit4 00001111  01000011  11010000  11110100  00111101  00001111  01000011  11010000  11110100  00111101  00001111  01000011  11010000  11110100  00111101  00001111
    // bit5 01100011  10011000  11100110  00111001  10001110  01100011  10011000  11100110  00111001  10001110  01100011  10011000  11100110  00111001  10001110  01100011
    // bit6 01000011  11010000  11110100  00111101  00001111  01000011  11010000  11110100  00111101  00001111  01000011  11010000  11110100  00111101  00001111  01000011
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....
    // bit1 .XX.XX..  XX.XX.XX  ..XX.XX.  XX..XX.X  X.XX..XX  .XX.XX..  XX.XX.XX  ..XX.XX.  XX..XX.X  X.XX..XX  .XX.XX..  XX.XX.XX  ..XX.XX.  XX..XX.X  X.XX..XX  .XX.XX..
    // bit2 ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....
    // bit3 XXX.X..X  .XXXX.X.  .X.XXXX.  X..X.XXX  X.X..X.X  XXX.X..X  .XXXX.X.  .X.XXXX.  X..X.XXX  X.X..X.X  XXX.X..X  .XXXX.X.  .X.XXXX.  X..X.XXX  X.X..X.X  XXX.X..X
    // bit4 ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....
    // bit5 .XX.XX..  XX.XX.XX  ..XX.XX.  XX..XX.X  X.XX..XX  .XX.XX..  XX.XX.XX  ..XX.XX.  XX..XX.X  X.XX..XX  .XX.XX..  XX.XX.XX  ..XX.XX.  XX..XX.X  X.XX..XX  .XX.XX..
    // bit6 ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....  .X..X...  ...X..X.  .....X..  X......X  ..X.....
    // bit7 .X....XX  XX.X....  XXXX.X..  ..XXXX.X  ....XXXX  .X....XX  XX.X....  XXXX.X..  ..XXXX.X  ....XXXX  .X....XX  XX.X....  XXXX.X..  ..XXXX.X  ....XXXX  .X....XX
    // Avalanche: 38.28%

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

    PasswordAddCipher aCrypt(aMaskBuffer);

    const std::uint8_t aExpected[128] = {
        0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78,
        0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66,
        0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E,
        0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00,
        0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA,
        0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78,
        0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66,
        0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E, 0x86, 0xAA, 0xE0, 0x66, 0x54, 0x00, 0x98, 0x78, 0xFE, 0x1E
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_I_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_I_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_I_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_I_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_I_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_I_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_J_PasswordAddCipher {

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

    PasswordAddCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_128_J_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_J_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_J_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_J_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_J_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_J_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_K_PasswordAddCipher {

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
    // bit0 10101010  10101010  10101010  01010101  10101010  10101010  10101010  10101010  01010101  10101010  10101010  10101010  10101010  01010101  10101010  10101010
    // bit1 10101010  01010101  01010101  10101010  10101010  10101010  01010101  01010101  10101010  10101010  10101010  01010101  01010101  10101010  10101010  10101010
    // bit2 10101010  01010101  01010101  01010101  10101010  10101010  01010101  01010101  01010101  10101010  10101010  01010101  01010101  01010101  10101010  10101010
    // bit3 01010101  10101010  01010101  10101010  10101010  01010101  10101010  01010101  10101010  10101010  01010101  10101010  01010101  10101010  10101010  01010101
    // bit4 01010101  10101010  01010101  01010101  10101010  01010101  10101010  01010101  01010101  10101010  01010101  10101010  01010101  01010101  10101010  01010101
    // bit5 01010101  01010101  10101010  10101010  10101010  01010101  01010101  10101010  10101010  10101010  01010101  01010101  10101010  10101010  10101010  01010101
    // bit6 01010101  01010101  10101010  01010101  10101010  01010101  01010101  10101010  01010101  10101010  01010101  01010101  10101010  01010101  10101010  01010101
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  ........  ........  XXXXXXXX  ........  ........  ........  ........  XXXXXXXX  ........  ........  ........  ........  XXXXXXXX  ........  ........
    // bit1 ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  ........
    // bit2 ........  ........  ........  XXXXXXXX  ........  ........  ........  ........  XXXXXXXX  ........  ........  ........  ........  XXXXXXXX  ........  ........
    // bit3 XXXXXXXX  XXXXXXXX  ........  XXXXXXXX  ........  XXXXXXXX  XXXXXXXX  ........  XXXXXXXX  ........  XXXXXXXX  XXXXXXXX  ........  XXXXXXXX  ........  XXXXXXXX
    // bit4 ........  ........  ........  XXXXXXXX  ........  ........  ........  ........  XXXXXXXX  ........  ........  ........  ........  XXXXXXXX  ........  ........
    // bit5 ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  ........  XXXXXXXX  XXXXXXXX  XXXXXXXX  ........  ........
    // bit6 ........  ........  ........  XXXXXXXX  ........  ........  ........  ........  XXXXXXXX  ........  ........  ........  ........  XXXXXXXX  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X  .X.X.X.X  X.X.X.X.  .X.X.X.X  X.X.X.X.  .X.X.X.X
    // Avalanche: 37.50%

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

    PasswordAddCipher aCrypt(aMaskBuffer);

    const std::uint8_t aExpected[128] = {
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
        0xFE, 0x00, 0xFE, 0x00, 0xFE, 0x00, 0xFE, 0x00, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E,
        0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78,
        0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0xFE, 0x00, 0xFE, 0x00, 0xFE, 0x00, 0xFE, 0x00,
        0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0xE0, 0x1E, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66, 0x98, 0x66,
        0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x86, 0x78, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA, 0x54, 0xAA,
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
                                                    "test_fixed_128_K_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_K_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_K_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_K_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_K_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_K_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_L_PasswordAddCipher {

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
    // bit0 10000101  01010101  01011110  10000000  10101000  01011110  10101111  11101000  01010101  01010101  11101000  00001010  10000101  11101010  11111110  10000101
    // bit1 10101010  10101000  01010101  01111111  11101000  00000001  01010101  11101010  10101010  10000101  01010111  11111110  10000000  00010101  01011110  10101010
    // bit2 10101010  00010101  01010101  01111010  10101000  00000001  01111111  11101010  10100001  01010101  01010111  10101010  10000000  00010111  11111110  10101010
    // bit3 01010000  10101000  00001010  10101111  11101010  11110101  01010101  01010101  00001010  10000000  10101010  11111110  10101111  01010101  01010101  01010000
    // bit4 01010000  00010101  00001010  10101010  10101010  11110101  01111111  01010101  00000001  01010000  10101010  10101010  10101111  01010111  11110101  01010000
    // bit5 01111111  11101000  00000001  01010101  11101010  10101010  10000101  01010111  11111110  10000000  00010101  01011110  10101010  10101000  01010101  01111111
    // bit6 01111111  01010101  00000001  01010000  10101010  10101010  10101111  01010111  11110101  01010000  00010101  00001010  10101010  10101010  11110101  01111111
    // bit7 00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000  00000000
    //
    // Avalanche:
    // bit0 ........  X.XXXX.X  ........  .....X.X  .X......  ........  ..X.X.X.  ........  ....X.XX  XX.X....  ........  .X.X.X..  ........  ......X.  X.X.....  ........
    // bit1 ..X.XXXX  XXXXXX.X  ....X.XX  XXXXXXXX  .X......  .X.XXXXX  XXXXX.X.  ......X.  XXXXXXXX  XX.X....  X.XXXXXX  XXXX.X..  .....X.X  XXXXXXXX  X.X.....  ..X.XXXX
    // bit2 ........  X.XXXX.X  ........  .....X.X  .X......  ........  ..X.X.X.  ........  ....X.XX  XX.X....  ........  .X.X.X..  ........  ......X.  X.X.....  ........
    // bit3 XXXXX.X.  X.XXXX.X  .X.XXXXX  XX.X.X.X  .X....X.  XXXX.X..  ..X.X.X.  X.XXXXXX  X.X.X.XX  XX.X.X.X  XXXXXX.X  .X.X.X..  ..X.XXXX  .X....X.  X.X.X.XX  XXXXX.X.
    // bit4 ........  X.XXXX.X  ........  .....X.X  .X......  ........  ..X.X.X.  ........  ....X.XX  XX.X....  ........  .X.X.X..  ........  ......X.  X.X.....  ........
    // bit5 ..X.XXXX  XXXXXX.X  ....X.XX  XXXXXXXX  .X......  .X.XXXXX  XXXXX.X.  ......X.  XXXXXXXX  XX.X....  X.XXXXXX  XXXX.X..  .....X.X  XXXXXXXX  X.X.....  ..X.XXXX
    // bit6 ........  X.XXXX.X  ........  .....X.X  .X......  ........  ..X.X.X.  ........  ....X.XX  XX.X....  ........  .X.X.X..  ........  ......X.  X.X.....  ........
    // bit7 .XXXXXXX  .X.X.X.X  .......X  .X.X....  X.X.X.X.  X.X.X.X.  X.X.XXXX  .X.X.XXX  XXXX.X.X  .X.X....  ...X.X.X  ....X.X.  X.X.X.X.  X.X.X.X.  XXXX.X.X  .XXXXXXX
    // Avalanche: 38.57%

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

    PasswordAddCipher aCrypt(aMaskBuffer);

    const std::uint8_t aExpected[128] = {
        0xE0, 0x1E, 0x66, 0x1E, 0x66, 0x86, 0x66, 0x86, 0x54, 0x86, 0x54, 0xAA, 0x54, 0xAA, 0x00, 0xAA,
        0x00, 0xE0, 0x00, 0xE0, 0x98, 0xE0, 0x98, 0x66, 0x98, 0x66, 0x78, 0x66, 0x78, 0x54, 0x78, 0x54,
        0xFE, 0x54, 0xFE, 0x00, 0xFE, 0x00, 0x1E, 0x00, 0x1E, 0x98, 0x1E, 0x98, 0x86, 0x98, 0x86, 0x78,
        0x86, 0x78, 0xAA, 0x78, 0xAA, 0xFE, 0xAA, 0xFE, 0xE0, 0xFE, 0xE0, 0x1E, 0xE0, 0x1E, 0x66, 0x1E,
        0x66, 0x86, 0x66, 0x86, 0x54, 0x86, 0x54, 0xAA, 0x54, 0xAA, 0x00, 0xAA, 0x00, 0xE0, 0x00, 0xE0,
        0x98, 0xE0, 0x98, 0x66, 0x98, 0x66, 0x78, 0x66, 0x78, 0x54, 0x78, 0x54, 0xFE, 0x54, 0xFE, 0x00,
        0xFE, 0x00, 0x1E, 0x00, 0x1E, 0x98, 0x1E, 0x98, 0x86, 0x98, 0x86, 0x78, 0x86, 0x78, 0xAA, 0x78,
        0xAA, 0xFE, 0xAA, 0xFE, 0xE0, 0xFE, 0xE0, 0x1E, 0xE0, 0x1E, 0x66, 0x1E, 0x66, 0x86, 0x66, 0x86
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_128_L_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_L_PasswordAddCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_L_PasswordAddCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_L_PasswordAddCipher")) {
        XCTFail("[PasswordAddCipher] test_fixed_128_L_PasswordAddCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[PasswordAddCipher] test_fixed_128_L_PasswordAddCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

@end
