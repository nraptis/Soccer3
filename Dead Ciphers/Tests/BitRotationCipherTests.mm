#import <XCTest/XCTest.h>

#include "BitRotationCipher.hpp"

#include <array>
#include <cstddef>
#include <cstdint>

@interface BitRotationCipherTests : XCTestCase
@end

@implementation BitRotationCipherTests

- (void)testCipherImportPolymorphismAndZero {
    std::array<std::uint8_t, 256U> aSource = {};
    std::array<std::uint8_t, 256U> aEncrypted = {};
    std::array<std::uint8_t, 256U> aRecovered = {};
    for (std::size_t aIndex = 0U; aIndex < aSource.size(); ++aIndex) {
        aSource[aIndex] = static_cast<std::uint8_t>(aIndex);
    }
    for (std::size_t aShift = 0U; aShift < 16U; ++aShift) {
        BitRotationCipher aRotation(aShift);
        Cipher &aCipher = aRotation;
        XCTAssertEqual(aCipher.mType, CipherType::kBitRotationCipher);
        XCTAssertEqual(CipherTool::CountLanes(aCipher.mType), std::size_t{0U});
        XCTAssertFalse(IS_ROTATION_ANY(aCipher.mType));

        XCTAssertTrue(aCipher.SealData(aSource.data(), nullptr, aEncrypted.data(),
                                      aSource.size(), nullptr));
        for (std::size_t aIndex = 0U; aIndex < aSource.size(); ++aIndex) {
            std::uint8_t aExpected = 0U;
            for (std::size_t aBit = 0U; aBit < 8U; ++aBit) {
                if ((aSource[aIndex] & (1U << aBit)) != 0U) {
                    aExpected = static_cast<std::uint8_t>(
                        aExpected | (1U << ((aBit + aShift) % 8U)));
                }
            }
            XCTAssertEqual(aEncrypted[aIndex], aExpected);
        }
        XCTAssertTrue(aCipher.UnsealData(aEncrypted.data(), nullptr, aRecovered.data(),
                                        aEncrypted.size(), nullptr));
        XCTAssertTrue(aRecovered == aSource);

        aCipher.Zero();
        XCTAssertTrue(aCipher.SealData(aSource.data(), nullptr, aEncrypted.data(),
                                      aSource.size(), nullptr));
        XCTAssertTrue(aEncrypted == aSource);
    }
}

@end
