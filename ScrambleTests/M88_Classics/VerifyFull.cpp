//
//  VerifyFull.cpp
//  CyberMatrixTests
//
//  Created by Icarus Black on 5/29/26.
//

#include "VerifyFull.hpp"
#include <cstdio>
#include <cstdint>

M88 VerifyFull::SpawnTestMatrixFull() {
    M88 aMatrix;

    std::uint8_t aValue = 0U;
    for (std::size_t y = 0; y < 8; y++) {
        for (std::size_t x = 0; x < 8; x++) {
            aMatrix.mData[M88::Slot(x, y)] = aValue;
            aValue++;
        }
    }

    return aMatrix;
}

M VerifyFull::FullBefore() {
    return {
        {  0,  1,  2,  3,  4,  5,  6,  7 },
        {  8,  9, 10, 11, 12, 13, 14, 15 },
        { 16, 17, 18, 19, 20, 21, 22, 23 },
        { 24, 25, 26, 27, 28, 29, 30, 31 },
        { 32, 33, 34, 35, 36, 37, 38, 39 },
        { 40, 41, 42, 43, 44, 45, 46, 47 },
        { 48, 49, 50, 51, 52, 53, 54, 55 },
        { 56, 57, 58, 59, 60, 61, 62, 63 }
    };
}

bool VerifyFull::CheckFull(const M88 &pBefore,
                           const M88 &pAfter,
                           const M &pExpected) {
    if (pExpected.size() != 8) {
        std::printf("Expected matrix height is not 8.\n");
        return false;
    }

    for (std::size_t y = 0; y < 8; y++) {
        if (pExpected[y].size() != 8) {
            std::printf("Expected matrix row %zu width is not 8.\n", y);
            return false;
        }
    }

    for (std::size_t y = 0; y < 8; y++) {
        for (std::size_t x = 0; x < 8; x++) {
            const std::size_t aSlot = M88::Slot(x, y);
            const std::uint8_t aGot = pAfter.mData[aSlot];
            const std::uint8_t aWant = pExpected[y][x];

            if (aGot != aWant) {
                std::printf("Full mismatch at (%zu,%zu): got %02u, want %02u; before was %02u\n",
                            x,
                            y,
                            static_cast<unsigned>(aGot),
                            static_cast<unsigned>(aWant),
                            static_cast<unsigned>(pBefore.mData[aSlot]));
                return false;
            }
        }
    }

    return true;
}
