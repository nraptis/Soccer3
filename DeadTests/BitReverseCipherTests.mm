#import <XCTest/XCTest.h>
#include "BitReverseCipherChecks.hpp"

@interface BitReverseCipherTests : XCTestCase
@end
@implementation BitReverseCipherTests
- (void)testAllByteValuesBothDirectionsTailsGuardsAndRejectedBuffers {
    const auto aFailure = CheckBitReverseCipher();
    XCTAssertTrue(aFailure == nullptr, @"%s", aFailure ? aFailure : "");
}
@end
