#import <XCTest/XCTest.h>
#include "BitPlaneToolChecks.hpp"

@interface BitPlaneToolTests : XCTestCase
@end
@implementation BitPlaneToolTests
- (void)testAll211392PlansAreValidUniqueAndComplete {
    const auto aFailure = CheckBitPlaneToolAllPlans();
    XCTAssertTrue(aFailure == nullptr, @"%s", aFailure ? aFailure : "");
}
- (void)testExtremeSeedsPairOrderAndInvalidPlans {
    const auto aFailure = CheckBitPlaneToolArguments();
    XCTAssertTrue(aFailure == nullptr, @"%s", aFailure ? aFailure : "");
}
@end
