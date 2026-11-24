#import <XCTest/XCTest.h>

#include "FourCrow.hpp"
#include "FourRaven.hpp"
#include "EightRaven.hpp"
#include "ShiftMaskedCipher.hpp"
#include "PasswordXORCipher.hpp"

#include <algorithm>
#include <limits>
#include <numeric>
#include <random>
#include <vector>

@interface CorvidCipherTests : XCTestCase
@end

@implementation CorvidCipherTests

- (void)testMatchesSeparateShiftsAndOneMutate {
    std::mt19937_64 aRandom(20261105U);
    for (std::size_t aTrial = 0U; aTrial < 1000U; ++aTrial) {
        const std::size_t aLength = aTrial % 100U == 0U ? 1048576U : 32U * (1U + aRandom() % 129U);
        std::vector<std::uint8_t> aSource(aLength), aMaterial(aLength), aOutput(aLength);
        std::vector<std::uint8_t> aExpected(aLength), aTemporary(aLength), aRestored(aLength);
        for (std::size_t aIndex = 0U; aIndex < aLength; ++aIndex) {
            aSource[aIndex] = static_cast<std::uint8_t>(aRandom());
            aMaterial[aIndex] = static_cast<std::uint8_t>(aRandom());
        }
        std::uint8_t aRows[8];
        std::iota(std::begin(aRows), std::end(aRows), 0U);
        std::shuffle(std::begin(aRows), std::end(aRows), aRandom);
        CorvidShift aShifts[4];
        for (std::size_t aPair = 0U; aPair < 4U; ++aPair) {
            aShifts[aPair] = {static_cast<std::uint8_t>(
                (1U << aRows[2U * aPair]) | (1U << aRows[2U * aPair + 1U])), aRandom()};
        }
        // Zero, aligned, unaligned, equal, wraparound, and maximum rotations.
        if (aTrial % 3U == 0U) {
            aShifts[0].mRotation = aTrial % 64U;
            aShifts[1].mRotation = aLength - 1U;
            aShifts[2].mRotation = aShifts[0].mRotation;
            aShifts[3].mRotation = std::numeric_limits<std::size_t>::max();
        }
        FourCrow aCrow(aShifts[0], aShifts[1]);
        FourRaven aFourRaven(aShifts[0], aShifts[1], aMaterial.data());
        EightRaven aEightRaven(aShifts[0], aShifts[1], aShifts[2], aShifts[3], aMaterial.data());
        Cipher *aCiphers[] = {&aCrow, &aFourRaven, &aEightRaven};
        for (std::size_t aVariant = 0U; aVariant < 3U; ++aVariant) {
            aExpected = aSource;
            const std::size_t aPairCount = aVariant == 2U ? 4U : 2U;
            for (std::size_t aPair = 0U; aPair < aPairCount; ++aPair) {
                ShiftMaskedCipher aShift(aShifts[aPair].mMask, aShifts[aPair].mRotation);
                XCTAssertTrue(aShift.SealData(aExpected.data(), nullptr, aTemporary.data(), aLength, nullptr));
                aExpected.swap(aTemporary);
            }
            if (aVariant != 0U) {
                PasswordXORCipher aMutate(aMaterial.data());
                XCTAssertTrue(aMutate.SealData(aExpected.data(), nullptr, aTemporary.data(), aLength, nullptr));
                aExpected.swap(aTemporary);
            }
            auto *aCipher = aCiphers[aVariant];
            XCTAssertTrue(aCipher->SealData(aSource.data(), nullptr, aOutput.data(), aLength, nullptr));
            XCTAssertTrue(aOutput == aExpected, @"trial=%zu variant=%zu forward", aTrial, aVariant);
            XCTAssertTrue(aCipher->UnsealData(aExpected.data(), nullptr, aRestored.data(), aLength, nullptr));
            XCTAssertTrue(aRestored == aSource, @"trial=%zu variant=%zu inverse", aTrial, aVariant);
            // Independent scalar oracle for arbitrary ciphertext, including material indexing.
            for (std::size_t aIndex = 0U; aIndex < aLength; ++aIndex) {
                std::uint8_t aValue = aSource[aIndex];
                if (aVariant != 0U) aValue ^= aMaterial[aIndex];
                for (std::size_t aPair = 0U; aPair < aPairCount; ++aPair) {
                    const auto aPosition = (aIndex + aShifts[aPair].mRotation % aLength) % aLength;
                    auto aByte = aSource[aPosition];
                    if (aVariant != 0U) aByte ^= aMaterial[aPosition];
                    aValue = (aValue & ~aShifts[aPair].mMask) | (aByte & aShifts[aPair].mMask);
                }
                aExpected[aIndex] = aValue;
            }
            XCTAssertTrue(aCipher->UnsealData(aSource.data(), nullptr, aOutput.data(), aLength, nullptr));
            XCTAssertTrue(aOutput == aExpected, @"trial=%zu variant=%zu inverse oracle", aTrial, aVariant);
        }
    }
}

- (void)testAllDisjointPairMasksAndShortCrowLength {
    std::uint8_t aSource[16], aOutput[16], aExpected[16], aRestored[16];
    for (unsigned aIndex = 0U; aIndex < 16U; ++aIndex)
        aSource[aIndex] = static_cast<std::uint8_t>(aIndex * 17U);
    std::size_t aCases = 0U;
    for (unsigned aRowA = 0U; aRowA < 8U; ++aRowA)
        for (unsigned aRowB = aRowA + 1U; aRowB < 8U; ++aRowB)
            for (unsigned aRowC = 0U; aRowC < 8U; ++aRowC)
                for (unsigned aRowD = aRowC + 1U; aRowD < 8U; ++aRowD) {
                    const auto aMaskA = static_cast<std::uint8_t>((1U << aRowA) | (1U << aRowB));
                    const auto aMaskB = static_cast<std::uint8_t>((1U << aRowC) | (1U << aRowD));
                    if ((aMaskA & aMaskB) != 0U) continue;
                    FourCrow aCipher({aMaskA, 15U}, {aMaskB, 3U});
                    for (std::size_t aIndex = 0U; aIndex < 16U; ++aIndex)
                        aExpected[aIndex] = (aSource[aIndex] & ~(aMaskA | aMaskB)) |
                            (aSource[(aIndex + 1U) % 16U] & aMaskA) |
                            (aSource[(aIndex + 13U) % 16U] & aMaskB);
                    XCTAssertTrue(aCipher.SealData(aSource, nullptr, aOutput, 16U, nullptr));
                    XCTAssertTrue(std::equal(std::begin(aOutput), std::end(aOutput), aExpected));
                    XCTAssertTrue(aCipher.UnsealData(aOutput, nullptr, aRestored, 16U, nullptr));
                    XCTAssertTrue(std::equal(std::begin(aSource), std::end(aSource), aRestored));
                    ++aCases;
                }
    XCTAssertEqual(aCases, 420U);
}

- (void)testInvalidParametersAndZero {
    std::uint8_t aSource[128]{}, aOutput[64], aMaterial[128]{};
    std::fill(std::begin(aOutput), std::end(aOutput), 0xA5U);
    FourCrow aCrow({0x03U, 1U}, {0x0CU, 3U});
    FourRaven aFour({0x03U, 1U}, {0x0CU, 3U}, aMaterial);
    EightRaven aEight({0x03U, 1U}, {0x0CU, 3U}, {0x30U, 5U}, {0xC0U, 7U}, aMaterial);
    Cipher *aCiphers[] = {&aCrow, &aFour, &aEight};
    CipherErrorCode aError{};
    for (auto *aCipher : aCiphers) {
        for (bool aUnseal : {false, true}) {
            const auto aRun = [&](const std::uint8_t *pSource, std::uint8_t *pOutput, std::size_t pLength) {
                return aUnseal ? aCipher->UnsealData(pSource, nullptr, pOutput, pLength, &aError)
                               : aCipher->SealData(pSource, nullptr, pOutput, pLength, &aError);
            };
            XCTAssertTrue(aRun(nullptr, nullptr, 0U));
            XCTAssertTrue(aError == CipherErrorCode::kNone);
            XCTAssertFalse(aRun(aSource, aOutput, 31U));
            XCTAssertTrue(aError == CipherErrorCode::kInvalidLength);
            XCTAssertFalse(aRun(nullptr, aOutput, 64U));
            XCTAssertTrue(aError == CipherErrorCode::kNullBuffer);
            XCTAssertFalse(aRun(aSource, nullptr, 64U));
            XCTAssertTrue(aError == CipherErrorCode::kNullBuffer);
            XCTAssertFalse(aRun(aSource, aSource + 1U, 64U));
            XCTAssertTrue(aError == CipherErrorCode::kAliasedBuffer);
            XCTAssertFalse(aRun(aSource + 1U, aSource, 64U));
            XCTAssertTrue(aError == CipherErrorCode::kAliasedBuffer);
        }
        aCipher->Zero();
        XCTAssertFalse(aCipher->SealData(aSource, nullptr, aOutput, 64U, &aError));
        XCTAssertTrue(aError == CipherErrorCode::kInvalidParameter);
    }
    FourCrow aOverlappingMasks({0x03U, 1U}, {0x06U, 2U});
    FourCrow aBadCount({0x07U, 1U}, {0x18U, 2U});
    FourRaven aMissingMaterial({0x03U, 1U}, {0x0CU, 2U}, nullptr);
    XCTAssertFalse(aOverlappingMasks.SealData(aSource, nullptr, aOutput, 64U, &aError));
    XCTAssertTrue(aError == CipherErrorCode::kInvalidParameter);
    XCTAssertFalse(aBadCount.SealData(aSource, nullptr, aOutput, 64U, &aError));
    XCTAssertTrue(aError == CipherErrorCode::kInvalidParameter);
    XCTAssertFalse(aMissingMaterial.SealData(aSource, nullptr, aOutput, 64U, &aError));
    XCTAssertTrue(aError == CipherErrorCode::kNullBuffer);
    FourRaven aAliasedMaterial({0x03U, 1U}, {0x0CU, 2U}, aMaterial);
    XCTAssertFalse(aAliasedMaterial.SealData(aSource, nullptr, aMaterial + 1U, 64U, &aError));
    XCTAssertTrue(aError == CipherErrorCode::kAliasedBuffer);
    XCTAssertTrue(std::all_of(std::begin(aOutput), std::end(aOutput), [](auto aByte) { return aByte == 0xA5U; }));
}

@end
