//
//  VerifyQuad.cpp
//  CyberMatrixTests
//
//  Created by Icarus Black on 5/29/26.
//

#include "VerifyQuad.hpp"

#include <cstdio>
#include <cstdint>

M88 VerifyQuad::SpawnTestMatrixQuadA() {
    return SpawnTestMatrixQuad(0);
}

M88 VerifyQuad::SpawnTestMatrixQuadB() {
    return SpawnTestMatrixQuad(1);
}

M88 VerifyQuad::SpawnTestMatrixQuadC() {
    return SpawnTestMatrixQuad(2);
}

M88 VerifyQuad::SpawnTestMatrixQuadD() {
    return SpawnTestMatrixQuad(3);
}

M VerifyQuad::QuadBefore() {
    return {
        {  0,  1,  2,  3 },
        {  4,  5,  6,  7 },
        {  8,  9, 10, 11 },
        { 12, 13, 14, 15 }
    };
}

bool VerifyQuad::CheckQuadA(const M88 &pBefore,
                                  const M88 &pAfter,
                                  const M &pExpected) {
    return CheckQuad(0, pBefore, pAfter, pExpected);
}

bool VerifyQuad::CheckQuadB(const M88 &pBefore,
                                  const M88 &pAfter,
                                  const M &pExpected) {
    return CheckQuad(1, pBefore, pAfter, pExpected);
}

bool VerifyQuad::CheckQuadC(const M88 &pBefore,
                                  const M88 &pAfter,
                                  const M &pExpected) {
    return CheckQuad(2, pBefore, pAfter, pExpected);
}

bool VerifyQuad::CheckQuadD(const M88 &pBefore,
                                  const M88 &pAfter,
                                  const M &pExpected) {
    return CheckQuad(3, pBefore, pAfter, pExpected);
}

bool VerifyQuad::CheckQuad(std::size_t pQuad,
                                 const M88 &pBefore,
                                 const M88 &pAfter,
                                 const M &pExpected) {
    if (pExpected.size() != 4) {
        std::printf("Expected matrix height is not 4.\n");
        return false;
    }

    for (std::size_t y = 0; y < 4; y++) {
        if (pExpected[y].size() != 4) {
            std::printf("Expected matrix row %zu width is not 4.\n", y);
            return false;
        }
    }

    const std::size_t qx = (pQuad & 1U) * 4U;
    const std::size_t qy = (pQuad >> 1U) * 4U;

    for (std::size_t y = 0; y < 8; y++) {
        for (std::size_t x = 0; x < 8; x++) {
            const bool aInsideQuad =
                (x >= qx) && (x < qx + 4U) &&
                (y >= qy) && (y < qy + 4U);

            const std::size_t aSlot = M88::Slot(x, y);
            const std::uint8_t aGot = pAfter.mData[aSlot];

            if (aInsideQuad) {
                const std::uint8_t aWant = pExpected[y - qy][x - qx];

                if (aGot != aWant) {
                    std::printf("Quad mismatch at global (%zu,%zu), local (%zu,%zu): got %02u, want %02u\n",
                                x,
                                y,
                                x - qx,
                                y - qy,
                                static_cast<unsigned>(aGot),
                                static_cast<unsigned>(aWant));
                    return false;
                }
            } else {
                const std::uint8_t aWant = pBefore.mData[aSlot];

                if (aGot != aWant) {
                    std::printf("Outside-Quad byte changed at (%zu,%zu): got %02u, want %02u\n",
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

M88 VerifyQuad::SpawnTestMatrixQuad(std::size_t pQuad) {
    M88 aMatrix;

    std::uint8_t aValue = 255U;
    for (std::size_t y = 0; y < 8; y++) {
        for (std::size_t x = 0; x < 8; x++) {
            aMatrix.mData[M88::Slot(x, y)] = aValue;
            aValue--;
        }
    }

    const std::size_t qx = (pQuad & 1U) * 4U;
    const std::size_t qy = (pQuad >> 1U) * 4U;

    std::uint8_t aQuadValue = 0U;
    for (std::size_t y = 0; y < 4; y++) {
        for (std::size_t x = 0; x < 4; x++) {
            aMatrix.mData[M88::Slot(qx + x, qy + y)] = aQuadValue;
            aQuadValue++;
        }
    }

    return aMatrix;
}
