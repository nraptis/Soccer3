#import <XCTest/XCTest.h>
#include "ParitySniffTestCommon.hpp"

@interface ParitySniffTestWeak : XCTestCase
@end

@implementation ParitySniffTestWeak
- (void)testParitySniff {
    const auto result = ParitySniffTest::Run(ParitySniffTest::kWeak);
    XCTAssertTrue(result.mCompleted, @"%s", result.mError.c_str());
    XCTAssertEqual(result.mControlAlerts, 0U, @"Random-label control flagged; inspect the diagnostic.");
    XCTAssertEqual(result.mScreenFindings, 0U, @"Held-out parity signal; inspect its separate confirmation.");
    XCTAssertEqual(result.mConfirmedFindings, 0U, @"Confirmed held-out parity prediction.");
}
@end
