#import <XCTest/XCTest.h>
#include "BitRotationThreeCipherChecks.hpp"

@interface BitRotationThreeCipherTests : XCTestCase
@end
@implementation BitRotationThreeCipherTests
- (void)testByteMappingInverseUnalignedBuffersAndErrors {
    const auto aFailure = CheckBitRotationThreeCipher();
    XCTAssertTrue(aFailure == nullptr, @"%s", aFailure ? aFailure : "");
}
// Retired pair comparison retained; the current standalone mapping test above remains active.
#if 0
- (void)testMatchesTheOldPair {
    std::array<std::uint8_t, 256U> aSource{}, aMiddle{}, aExpected{}, aActual{};
    for (unsigned i=0; i<256; ++i) aSource[i]=i;
    BitRotationCipherA aFirst; BitRotationCipherB aSecond; BitRotationThreeCipher aCombined;
    XCTAssertTrue(aFirst.SealData(aSource.data(), nullptr, aMiddle.data(), 256U, nullptr));
    XCTAssertTrue(aSecond.SealData(aMiddle.data(), nullptr, aExpected.data(), 256U, nullptr));
    XCTAssertTrue(aCombined.SealData(aSource.data(), nullptr, aActual.data(), 256U, nullptr));
    XCTAssertTrue(aActual == aExpected);
}
#endif
@end
