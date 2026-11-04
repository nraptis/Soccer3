//
//  NonceAvalancheTests.m
//  ScrambleTests
//
//  Created by Icarus Black on 7/19/26.
//

#import <XCTest/XCTest.h>

#include <atomic>
#include "Random.hpp"
#include "Soccer3.hpp"
#include "WorkSpaceTools.hpp"

#include <cstddef>
#include <cstdio>
#include <cstdint>

namespace {

std::size_t CountDifferentBits(const std::uint8_t *pDataA,
                               const std::uint8_t *pDataB) {
    std::size_t aDifferentBitCount = 0U;
    for (std::size_t aByteIndex=0U; aByteIndex<SOCCER_BLOCK_SIZE; aByteIndex++) {
        const unsigned int aDifference = static_cast<unsigned int>(pDataA[aByteIndex] ^ pDataB[aByteIndex]);
        aDifferentBitCount += static_cast<std::size_t>(__builtin_popcount(aDifference));
    }
    return aDifferentBitCount;
}

}

@interface NonceAvalancheTests : XCTestCase

@end

@implementation NonceAvalancheTests

- (void)test_NonceAvalanches {

    std::uint8_t aPassword[256U];
    WorkSpaceTools::FillBytes(aPassword, 256U);

    static std::uint8_t aOriginal[SOCCER_BLOCK_SIZE];
    WorkSpaceTools::FillBytes(aOriginal, SOCCER_BLOCK_SIZE);

    const std::uint64_t aNonceOriginal = Random::Get64();

    const std::uint64_t aNonces[9] = {
        aNonceOriginal,
        WorkSpaceTools::FlipBit(aNonceOriginal, 24U),
        WorkSpaceTools::FlipBit(aNonceOriginal, 25U),
        WorkSpaceTools::FlipBit(aNonceOriginal, 26U),
        WorkSpaceTools::FlipBit(aNonceOriginal, 27U),
        WorkSpaceTools::FlipBit(aNonceOriginal, 28U),
        WorkSpaceTools::FlipBit(aNonceOriginal, 29U),
        WorkSpaceTools::FlipBit(aNonceOriginal, 30U),
        WorkSpaceTools::FlipBit(aNonceOriginal, 31U)
    };

    static std::uint8_t aEncryptedOriginal[SOCCER_BLOCK_SIZE];
    static std::uint8_t aEncryptedBit24[SOCCER_BLOCK_SIZE];
    static std::uint8_t aEncryptedBit25[SOCCER_BLOCK_SIZE];
    static std::uint8_t aEncryptedBit26[SOCCER_BLOCK_SIZE];
    static std::uint8_t aEncryptedBit27[SOCCER_BLOCK_SIZE];
    static std::uint8_t aEncryptedBit28[SOCCER_BLOCK_SIZE];
    static std::uint8_t aEncryptedBit29[SOCCER_BLOCK_SIZE];
    static std::uint8_t aEncryptedBit30[SOCCER_BLOCK_SIZE];
    static std::uint8_t aEncryptedBit31[SOCCER_BLOCK_SIZE];

    std::uint8_t *aEncrypted[9] = {
        aEncryptedOriginal,
        aEncryptedBit24,
        aEncryptedBit25,
        aEncryptedBit26,
        aEncryptedBit27,
        aEncryptedBit28,
        aEncryptedBit29,
        aEncryptedBit30,
        aEncryptedBit31
    };

    const char *aNames[9] = {
        "original",
        "bit 24",
        "bit 25",
        "bit 26",
        "bit 27",
        "bit 28",
        "bit 29",
        "bit 30",
        "bit 31"
    };

    std::atomic<bool> aCancelled{false};
    for (std::size_t aNonceIndex=0U; aNonceIndex<9U; aNonceIndex++) {
        std::uint32_t aAckWord = 0U;
        if (!Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kNormal,
                                         aPassword,
                                         256U,
                                         aNonces[aNonceIndex],
                                         &aAckWord,0,&aCancelled)) {
            XCTFail("failed seed encrypt");
            return;
        }

        if (!Soccer3::EncryptBlock(aOriginal, aEncrypted[aNonceIndex])) {
            XCTFail("nonce avalanche encryption failed");
            return;
        }
    
    }

    constexpr std::size_t aTotalBitCount = SOCCER_BLOCK_SIZE * 8U;
    for (std::size_t aFirstIndex=0U; aFirstIndex<9U; aFirstIndex++) {
        for (std::size_t aSecondIndex=aFirstIndex + 1U; aSecondIndex<9U; aSecondIndex++) {
            const std::size_t aDifferentBitCount = CountDifferentBits(aEncrypted[aFirstIndex],
                                                                      aEncrypted[aSecondIndex]);
            const double aDifferentBitPercent = (static_cast<double>(aDifferentBitCount) * 100.0) /
                                                static_cast<double>(aTotalBitCount);
            std::printf("Nonce avalanche %s vs %s: %.6f%% (%zu / %zu bits)\n",
                        aNames[aFirstIndex],
                        aNames[aSecondIndex],
                        aDifferentBitPercent,
                        aDifferentBitCount,
                        aTotalBitCount);
            if (aDifferentBitCount == 0U) {
                XCTFail("nonce avalanche produced identical blocks");
                return;
            }
        }
    }

}

@end
