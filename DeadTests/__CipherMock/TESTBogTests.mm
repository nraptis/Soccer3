#import <XCTest/XCTest.h>
#include "TESTBogChecks.hpp"

@interface TESTBogTests : XCTestCase
@end
@implementation TESTBogTests
- (void)runCheck:(void (*)())check {
    try { check(); }
    catch (const std::exception &error) { XCTFail(@"%s",error.what()); }
}
- (void)testAllTwentyFourPresetsAndEveryArithmeticCombination { [self runCheck:TESTBogChecks::CheckPresetsAndArithmetic]; }
- (void)testBlocksWrappingAndInPlace { [self runCheck:TESTBogChecks::CheckBlocks]; }
- (void)testEmptyAdjacentBuffersAndReversibleSequence { [self runCheck:TESTBogChecks::CheckCallsAndSequences]; }
@end
