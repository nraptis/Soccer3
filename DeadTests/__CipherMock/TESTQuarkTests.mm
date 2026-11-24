#import <XCTest/XCTest.h>

#include "TESTQuarkChecks.hpp"

@interface TESTQuarkTests : XCTestCase
@end

@implementation TESTQuarkTests
- (void)testEveryHighNibbleCombination {
    XCTAssertNoThrow((TESTQuarkChecks::CheckArithmetic<TESTQuarkHigh, true>()));
}
- (void)testEveryLowNibbleCombination {
    XCTAssertNoThrow((TESTQuarkChecks::CheckArithmetic<TESTQuarkLow, false>()));
}
- (void)testPairAndInPlaceRoundTrips {
    XCTAssertNoThrow(TESTQuarkChecks::CheckRoundTrips());
}
- (void)testRejectsInvalidInputsBeforeWriting {
    XCTAssertNoThrow(TESTQuarkChecks::CheckValidation<TESTQuarkHigh>());
    XCTAssertNoThrow(TESTQuarkChecks::CheckValidation<TESTQuarkLow>());
}
@end
