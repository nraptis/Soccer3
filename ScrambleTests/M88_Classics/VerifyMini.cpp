//
//  VerifyMini.cpp
//  CyberMatrixTests
//
//  Created by Icarus Black on 5/29/26.
//

#include "VerifyMini.hpp"

#include <cstdio>
#include <cstdint>

M88 VerifyMini::SpawnTestMatrixMiniA() {
    return SpawnTestMatrixMini(0);
}

M88 VerifyMini::SpawnTestMatrixMiniB() {
    return SpawnTestMatrixMini(1);
}

M88 VerifyMini::SpawnTestMatrixMiniC() {
    return SpawnTestMatrixMini(2);
}

M88 VerifyMini::SpawnTestMatrixMiniD() {
    return SpawnTestMatrixMini(3);
}

M88 VerifyMini::SpawnTestMatrixMiniE() {
    return SpawnTestMatrixMini(4);
}

M88 VerifyMini::SpawnTestMatrixMiniF() {
    return SpawnTestMatrixMini(5);
}

M88 VerifyMini::SpawnTestMatrixMiniG() {
    return SpawnTestMatrixMini(6);
}

M88 VerifyMini::SpawnTestMatrixMiniH() {
    return SpawnTestMatrixMini(7);
}

M88 VerifyMini::SpawnTestMatrixMiniI() {
    return SpawnTestMatrixMini(8);
}

M88 VerifyMini::SpawnTestMatrixMiniJ() {
    return SpawnTestMatrixMini(9);
}

M88 VerifyMini::SpawnTestMatrixMiniK() {
    return SpawnTestMatrixMini(10);
}

M88 VerifyMini::SpawnTestMatrixMiniL() {
    return SpawnTestMatrixMini(11);
}

M88 VerifyMini::SpawnTestMatrixMiniM() {
    return SpawnTestMatrixMini(12);
}

M88 VerifyMini::SpawnTestMatrixMiniN() {
    return SpawnTestMatrixMini(13);
}

M88 VerifyMini::SpawnTestMatrixMiniO() {
    return SpawnTestMatrixMini(14);
}

M88 VerifyMini::SpawnTestMatrixMiniP() {
    return SpawnTestMatrixMini(15);
}

M VerifyMini::MiniBefore() {
    return {
        { 0, 1 },
        { 2, 3 }
    };
}

bool VerifyMini::CheckMiniA(const M88 &pBefore,
                                      const M88 &pAfter,
                                      const M &pExpected) {
    return CheckMini(0, pBefore, pAfter, pExpected);
}

bool VerifyMini::CheckMiniB(const M88 &pBefore,
                                      const M88 &pAfter,
                                      const M &pExpected) {
    return CheckMini(1, pBefore, pAfter, pExpected);
}

bool VerifyMini::CheckMiniC(const M88 &pBefore,
                                      const M88 &pAfter,
                                      const M &pExpected) {
    return CheckMini(2, pBefore, pAfter, pExpected);
}

bool VerifyMini::CheckMiniD(const M88 &pBefore,
                                      const M88 &pAfter,
                                      const M &pExpected) {
    return CheckMini(3, pBefore, pAfter, pExpected);
}

bool VerifyMini::CheckMiniE(const M88 &pBefore,
                                      const M88 &pAfter,
                                      const M &pExpected) {
    return CheckMini(4, pBefore, pAfter, pExpected);
}

bool VerifyMini::CheckMiniF(const M88 &pBefore,
                                      const M88 &pAfter,
                                      const M &pExpected) {
    return CheckMini(5, pBefore, pAfter, pExpected);
}

bool VerifyMini::CheckMiniG(const M88 &pBefore,
                                      const M88 &pAfter,
                                      const M &pExpected) {
    return CheckMini(6, pBefore, pAfter, pExpected);
}

bool VerifyMini::CheckMiniH(const M88 &pBefore,
                                      const M88 &pAfter,
                                      const M &pExpected) {
    return CheckMini(7, pBefore, pAfter, pExpected);
}

bool VerifyMini::CheckMiniI(const M88 &pBefore,
                                      const M88 &pAfter,
                                      const M &pExpected) {
    return CheckMini(8, pBefore, pAfter, pExpected);
}

bool VerifyMini::CheckMiniJ(const M88 &pBefore,
                                      const M88 &pAfter,
                                      const M &pExpected) {
    return CheckMini(9, pBefore, pAfter, pExpected);
}

bool VerifyMini::CheckMiniK(const M88 &pBefore,
                                      const M88 &pAfter,
                                      const M &pExpected) {
    return CheckMini(10, pBefore, pAfter, pExpected);
}

bool VerifyMini::CheckMiniL(const M88 &pBefore,
                                      const M88 &pAfter,
                                      const M &pExpected) {
    return CheckMini(11, pBefore, pAfter, pExpected);
}

bool VerifyMini::CheckMiniM(const M88 &pBefore,
                                      const M88 &pAfter,
                                      const M &pExpected) {
    return CheckMini(12, pBefore, pAfter, pExpected);
}

bool VerifyMini::CheckMiniN(const M88 &pBefore,
                                      const M88 &pAfter,
                                      const M &pExpected) {
    return CheckMini(13, pBefore, pAfter, pExpected);
}

bool VerifyMini::CheckMiniO(const M88 &pBefore,
                                      const M88 &pAfter,
                                      const M &pExpected) {
    return CheckMini(14, pBefore, pAfter, pExpected);
}

bool VerifyMini::CheckMiniP(const M88 &pBefore,
                                      const M88 &pAfter,
                                      const M &pExpected) {
    return CheckMini(15, pBefore, pAfter, pExpected);
}

bool VerifyMini::CheckMini(std::size_t pMini,
                                     const M88 &pBefore,
                                     const M88 &pAfter,
                                     const M &pExpected) {
    if (pExpected.size() != 2) {
        std::printf("Expected matrix height is not 2.\n");
        return false;
    }

    for (std::size_t y = 0; y < 2; y++) {
        if (pExpected[y].size() != 2) {
            std::printf("Expected matrix row %zu width is not 2.\n", y);
            return false;
        }
    }

    const std::size_t sx = (pMini & 3U) * 2U;
    const std::size_t sy = (pMini >> 2U) * 2U;

    for (std::size_t y = 0; y < 8; y++) {
        for (std::size_t x = 0; x < 8; x++) {
            const bool aInsideMini =
                (x >= sx) && (x < sx + 2U) &&
                (y >= sy) && (y < sy + 2U);

            const std::size_t aSlot = M88::Slot(x, y);
            const std::uint8_t aGot = pAfter.mData[aSlot];

            if (aInsideMini) {
                const std::uint8_t aWant = pExpected[y - sy][x - sx];

                if (aGot != aWant) {
                    std::printf("Mini mismatch at global (%zu,%zu), local (%zu,%zu): got %02u, want %02u\n",
                                x,
                                y,
                                x - sx,
                                y - sy,
                                static_cast<unsigned>(aGot),
                                static_cast<unsigned>(aWant));
                    return false;
                }
            } else {
                const std::uint8_t aWant = pBefore.mData[aSlot];

                if (aGot != aWant) {
                    std::printf("Outside-Mini byte changed at (%zu,%zu): got %02u, want %02u\n",
                                x,
                                y,
                                static_cast<unsigned>(aGot),
                                static_cast<unsigned>(aWant));
                    return false;
                }
            }
        }
    }

    return true;
}

M88 VerifyMini::SpawnTestMatrixMini(std::size_t pMini) {
    M88 aMatrix;

    std::uint8_t aValue = 255U;
    for (std::size_t y = 0; y < 8; y++) {
        for (std::size_t x = 0; x < 8; x++) {
            aMatrix.mData[M88::Slot(x, y)] = aValue;
            aValue--;
        }
    }

    const std::size_t sx = (pMini & 3U) * 2U;
    const std::size_t sy = (pMini >> 2U) * 2U;

    std::uint8_t aMiniValue = 0U;
    for (std::size_t y = 0; y < 2; y++) {
        for (std::size_t x = 0; x < 2; x++) {
            aMatrix.mData[M88::Slot(sx + x, sy + y)] = aMiniValue;
            aMiniValue++;
        }
    }

    return aMatrix;
}
