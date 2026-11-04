//
//  Battery_CascadeCipher.m
//  HolyStorms
//
//  Created by icarus black on 7/5/26.
//

#import <XCTest/XCTest.h>
#import "CascadeCipher.hpp"
#import "PrintExamplesHelper.hpp"
#import "CipherGauntlet.hpp"
#include <memory>

@interface Battery_CascadeCipher : XCTestCase

@end

@implementation Battery_CascadeCipher

- (void)test_gauntlet_CascadeCipher {
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
        
        CascadeCipher aCipher(aMask);
        if (!aGauntlet.RunCipher(&aCipher,
                                 16,
                                 "CascadeCipher")) {
            XCTFail("[CascadeCipher] test_gauntlet_CascadeCipher failed.");
            return;
        }
        
    }
}

- (void)test_fixed_16_A_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_16_A_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_A_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_16_A_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_A_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_A_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_16_A_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_B_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_16_B_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_B_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_16_B_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_B_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_B_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_16_B_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_C_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_16_C_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_C_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_16_C_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_C_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_C_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_16_C_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_D_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_16_D_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_D_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_16_D_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_D_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_D_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_16_D_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_E_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_16_E_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_E_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_16_E_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_E_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_E_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_16_E_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_F_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_16_F_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_F_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_16_F_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_F_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_F_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_16_F_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_G_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_16_G_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_G_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_16_G_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_G_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_G_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_16_G_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_H_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_16_H_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_H_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_16_H_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_H_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_H_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_16_H_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_I_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_16_I_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_I_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_16_I_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_I_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_I_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_16_I_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_J_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_16_J_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_J_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_16_J_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_J_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_J_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_16_J_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_K_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_16_K_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_K_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_16_K_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_K_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_K_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_16_K_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_16_L_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_16_L_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_L_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_16_L_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_16_L_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_16_L_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_16_L_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_A_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_A_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_A_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_32_A_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_A_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_A_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_32_A_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_B_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_B_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_B_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_32_B_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_B_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_B_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_32_B_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_C_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_C_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_C_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_32_C_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_C_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_C_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_32_C_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_D_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_D_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_D_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_32_D_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_D_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_D_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_32_D_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_E_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_E_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_E_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_32_E_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_E_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_E_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_32_E_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_F_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_F_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_F_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_32_F_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_F_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_F_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_32_F_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_G_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_G_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_G_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_32_G_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_G_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_G_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_32_G_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_H_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_H_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_H_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_32_H_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_H_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_H_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_32_H_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_I_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_I_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_I_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_32_I_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_I_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_I_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_32_I_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_J_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_J_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_J_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_32_J_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_J_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_J_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_32_J_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_K_CascadeCipher {

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
    // bit1 00000000  00000000  01010100  10101011
    // bit2 00000000  00000000  01010100  10101011
    // bit3 00000000  00000000  10101011  01010100
    // bit4 00000000  00000000  10101011  01010100
    // bit5 00000000  00000000  10101010  10101010
    // bit6 00000000  00000000  10101010  10101010
    // bit7 00000000  00000000  10101010  10101010
    //
    // Avalanche:
    // bit0 X.X.X.X.  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit1 X.X.X.X.  X.X.X.X.  XXXXXXX.  XXXXXXX.
    // bit2 X.X.X.X.  .X.X.X.X  .......X  .......X
    // bit3 X.X.X.X.  .X.X.X.X  XXXXXXX.  .......X
    // bit4 .X.X.X.X  X.X.X.X.  XXXXXXX.  XXXXXXX.
    // bit5 .X.X.X.X  X.X.X.X.  XXXXXXXX  XXXXXXXX
    // bit6 .X.X.X.X  .X.X.X.X  ........  ........
    // bit7 .X.X.X.X  .X.X.X.X  ........  XXXXXXXX
    // Avalanche: 55.47%

    const std::uint8_t aOriginal[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    const std::uint8_t aMaskBuffer[32] = {
        0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xF0, 0x0F, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33, 0xCC, 0x33,
        0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xC3, 0x3C, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55, 0xAA, 0x55
    };

    CascadeCipher aCrypt(aMaskBuffer);

    const std::uint8_t aExpected[32] = {
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0xE0, 0x1F, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0x98, 0x67, 0xE0
    };

    std::uint8_t aWorker[sizeof(aOriginal)] = {};
    std::uint8_t aEncrypted[sizeof(aOriginal)] = {};
    std::uint8_t aUnencrypted[sizeof(aOriginal)] = {};

    if (!CipherGauntlet::SealDataExpectingSuccess(aOriginal,
                                                    aWorker,
                                                    aEncrypted,
                                                    sizeof(aOriginal),
                                                    &aCrypt,
                                                    "test_fixed_32_K_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_K_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_32_K_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_K_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_K_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_32_K_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_32_L_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_32_L_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_L_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_32_L_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_32_L_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_32_L_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_32_L_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_A_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_48_A_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_48_A_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_48_A_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_A_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_48_A_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_48_A_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_B_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_48_B_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_48_B_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_48_B_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_B_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_48_B_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_48_B_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_C_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_48_C_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_48_C_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_48_C_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_C_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_48_C_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_48_C_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_D_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_48_D_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_48_D_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_48_D_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_D_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_48_D_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_48_D_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_E_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_48_E_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_48_E_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_48_E_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_E_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_48_E_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_48_E_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_48_F_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_48_F_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_48_F_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_48_F_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_48_F_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_48_F_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_48_F_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_A_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_64_A_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_64_A_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_64_A_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_A_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_64_A_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_64_A_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_B_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_64_B_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_64_B_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_64_B_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_B_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_64_B_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_64_B_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_C_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_64_C_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_64_C_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_64_C_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_C_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_64_C_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_64_C_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_D_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_64_D_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_64_D_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_64_D_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_D_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_64_D_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_64_D_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_E_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_64_E_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_64_E_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_64_E_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_E_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_64_E_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_64_E_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_64_F_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_64_F_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_64_F_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_64_F_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_64_F_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_64_F_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_64_F_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_A_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_80_A_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_80_A_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_80_A_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_A_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_80_A_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_80_A_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_B_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_80_B_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_80_B_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_80_B_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_B_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_80_B_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_80_B_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_C_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_80_C_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_80_C_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_80_C_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_C_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_80_C_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_80_C_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_D_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_80_D_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_80_D_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_80_D_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_D_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_80_D_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_80_D_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_E_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_80_E_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_80_E_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_80_E_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_E_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_80_E_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_80_E_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_80_F_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_80_F_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_80_F_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_80_F_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_80_F_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_80_F_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_80_F_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_A_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_96_A_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_96_A_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_96_A_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_A_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_96_A_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_96_A_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_B_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_96_B_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_96_B_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_96_B_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_B_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_96_B_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_96_B_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_C_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_96_C_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_96_C_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_96_C_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_C_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_96_C_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_96_C_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_D_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_96_D_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_96_D_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_96_D_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_D_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_96_D_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_96_D_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_E_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_96_E_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_96_E_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_96_E_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_E_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_96_E_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_96_E_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_96_F_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_96_F_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_96_F_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_96_F_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_96_F_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_96_F_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_96_F_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_A_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_112_A_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_112_A_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_112_A_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_A_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_112_A_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_112_A_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_B_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_112_B_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_112_B_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_112_B_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_B_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_112_B_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_112_B_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_C_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_112_C_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_112_C_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_112_C_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_C_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_112_C_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_112_C_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_D_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_112_D_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_112_D_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_112_D_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_D_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_112_D_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_112_D_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_E_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_112_E_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_112_E_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_112_E_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_E_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_112_E_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_112_E_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_112_F_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_112_F_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_112_F_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_112_F_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_112_F_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_112_F_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_112_F_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_A_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_128_A_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_128_A_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_128_A_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_A_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_128_A_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_128_A_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_B_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_128_B_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_128_B_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_128_B_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_B_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_128_B_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_128_B_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_C_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_128_C_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_128_C_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_128_C_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_C_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_128_C_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_128_C_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_D_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_128_D_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_128_D_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_128_D_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_D_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_128_D_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_128_D_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_E_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_128_E_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_128_E_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_128_E_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_E_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_128_E_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_128_E_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

- (void)test_fixed_128_F_CascadeCipher {

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

    CascadeCipher aCrypt(aMaskBuffer);

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
                                                    "test_fixed_128_F_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_128_F_CascadeCipher failed while sealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aExpected, aEncrypted, sizeof(aExpected))) {
        XCTFail("[CascadeCipher] test_fixed_128_F_CascadeCipher failed after seal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aExpected, sizeof(aExpected)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aEncrypted, sizeof(aEncrypted)).c_str());
        return;
    }

    if (!CipherGauntlet::UnsealDataExpectingSuccess(aEncrypted,
                                                      aWorker,
                                                      aUnencrypted,
                                                      sizeof(aEncrypted),
                                                      &aCrypt,
                                                      "test_fixed_128_F_CascadeCipher")) {
        XCTFail("[CascadeCipher] test_fixed_128_F_CascadeCipher failed while unsealing.");
        return;
    }

    if (!CipherGauntlet::Matches(aOriginal, aUnencrypted, sizeof(aOriginal))) {
        XCTFail("[CascadeCipher] test_fixed_128_F_CascadeCipher failed after unseal.");
        printf("Expected: %s\n", PrintExamplesHelper::HexArray(aOriginal, sizeof(aOriginal)).c_str());
        printf("Actual: %s\n", PrintExamplesHelper::HexArray(aUnencrypted, sizeof(aUnencrypted)).c_str());
        return;
    }

}

@end
