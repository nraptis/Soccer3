#import <XCTest/XCTest.h>
#include "TESTQuirkLowChecks.hpp"

@interface TESTQuirkLowTests : XCTestCase
@end

@implementation TESTQuirkLowTests
- (void)runCheck:(void (*)())pCheck {
    try { pCheck(); }
    catch (const std::exception &aError) { XCTFail(@"%s", aError.what()); }
}
- (void)testEveryNibbleCombination { [self runCheck:TESTQuirkLowChecks::CheckArithmetic]; }
- (void)testDirectionsWrapInPlaceAndHighLowSymmetry { [self runCheck:TESTQuirkLowChecks::CheckBlocksAndSymmetry]; }
- (void)testValidation { [self runCheck:TESTQuirkLowChecks::CheckValidation]; }
@end
