//
//  PasswordAvalancheTests.mm
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

std::size_t CountPasswordAvalancheDifferentBits(const std::uint8_t *pDataA,
                                                const std::uint8_t *pDataB) {
    std::size_t aDifferentBitCount = 0U;
    for (std::size_t aByteIndex=0U; aByteIndex<SOCCER_BLOCK_SIZE; aByteIndex++) {
        const unsigned int aDifference = static_cast<unsigned int>(pDataA[aByteIndex] ^ pDataB[aByteIndex]);
        aDifferentBitCount += static_cast<std::size_t>(__builtin_popcount(aDifference));
    }
    return aDifferentBitCount;
}

}

@interface PasswordAvalancheTests : XCTestCase

@end

@implementation PasswordAvalancheTests

- (void)test_PasswordAvalanches {

    constexpr std::uint8_t aPasswordOriginal = static_cast<std::uint8_t>('A');
    std::uint8_t aPasswords[9] = {
        aPasswordOriginal,
        static_cast<std::uint8_t>(WorkSpaceTools::FlipBit(aPasswordOriginal, 0U)),
        static_cast<std::uint8_t>(WorkSpaceTools::FlipBit(aPasswordOriginal, 1U)),
        static_cast<std::uint8_t>(WorkSpaceTools::FlipBit(aPasswordOriginal, 2U)),
        static_cast<std::uint8_t>(WorkSpaceTools::FlipBit(aPasswordOriginal, 3U)),
        static_cast<std::uint8_t>(WorkSpaceTools::FlipBit(aPasswordOriginal, 4U)),
        static_cast<std::uint8_t>(WorkSpaceTools::FlipBit(aPasswordOriginal, 5U)),
        static_cast<std::uint8_t>(WorkSpaceTools::FlipBit(aPasswordOriginal, 6U)),
        static_cast<std::uint8_t>(WorkSpaceTools::FlipBit(aPasswordOriginal, 7U))
    };

    static std::uint8_t aOriginal[SOCCER_BLOCK_SIZE];
    WorkSpaceTools::FillBytes(aOriginal, SOCCER_BLOCK_SIZE);

    const std::uint64_t aNonce = Random::Get64();

    static std::uint8_t aEncryptedOriginal[SOCCER_BLOCK_SIZE];
    static std::uint8_t aEncryptedBit0[SOCCER_BLOCK_SIZE];
    static std::uint8_t aEncryptedBit1[SOCCER_BLOCK_SIZE];
    static std::uint8_t aEncryptedBit2[SOCCER_BLOCK_SIZE];
    static std::uint8_t aEncryptedBit3[SOCCER_BLOCK_SIZE];
    static std::uint8_t aEncryptedBit4[SOCCER_BLOCK_SIZE];
    static std::uint8_t aEncryptedBit5[SOCCER_BLOCK_SIZE];
    static std::uint8_t aEncryptedBit6[SOCCER_BLOCK_SIZE];
    static std::uint8_t aEncryptedBit7[SOCCER_BLOCK_SIZE];

    std::uint8_t *aEncrypted[9] = {
        aEncryptedOriginal,
        aEncryptedBit0,
        aEncryptedBit1,
        aEncryptedBit2,
        aEncryptedBit3,
        aEncryptedBit4,
        aEncryptedBit5,
        aEncryptedBit6,
        aEncryptedBit7
    };

    const char *aNames[9] = {
        "original A",
        "bit 0",
        "bit 1",
        "bit 2",
        "bit 3",
        "bit 4",
        "bit 5",
        "bit 6",
        "bit 7"
    };

    std::atomic<bool> aCancelled{false};
    for (std::size_t aPasswordIndex=0U; aPasswordIndex<9U; aPasswordIndex++) {
        std::uint32_t aAckWord = 0U;
        if (!Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kNormal,
                                          &aPasswords[aPasswordIndex],
                                         1U,
                                         aNonce,
                                         &aAckWord,0,&aCancelled)) {
            XCTFail("failed seed encrypt");
            return;
        }

        if (!Soccer3::EncryptBlock(aOriginal, aEncrypted[aPasswordIndex])) {
            XCTFail("password avalanche encryption failed");
            return;
        }
        
    }

    constexpr std::size_t aTotalBitCount = SOCCER_BLOCK_SIZE * 8U;
    for (std::size_t aFirstIndex=0U; aFirstIndex<9U; aFirstIndex++) {
        for (std::size_t aSecondIndex=aFirstIndex + 1U; aSecondIndex<9U; aSecondIndex++) {
            const std::size_t aDifferentBitCount = CountPasswordAvalancheDifferentBits(aEncrypted[aFirstIndex],
                                                                                       aEncrypted[aSecondIndex]);
            const double aDifferentBitPercent = (static_cast<double>(aDifferentBitCount) * 100.0) /
                                                static_cast<double>(aTotalBitCount);
            std::printf("Password avalanche %s vs %s: %.6f%% (%zu / %zu bits)\n",
                        aNames[aFirstIndex],
                        aNames[aSecondIndex],
                        aDifferentBitPercent,
                        aDifferentBitCount,
                        aTotalBitCount);
            if (aDifferentBitCount == 0U) {
                XCTFail("password avalanche produced identical blocks");
                return;
            }
        }
    }

}

@end
