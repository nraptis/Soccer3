#import <XCTest/XCTest.h>

#include "TESTQuirkHighChecks.hpp"

using QuirkCheck = void (*)();

@interface TESTQuirkHighTests : XCTestCase
@end

@implementation TESTQuirkHighTests
- (void)runCheck:(QuirkCheck)pCheck {
    try { pCheck(); }
    catch (const std::exception &aError) { XCTFail(@"%s", aError.what()); }
}
- (void)testAllEightPresets { [self runCheck:TESTQuirkHighChecks::CheckPresets]; }
- (void)testEveryNibbleCombination { [self runCheck:TESTQuirkHighChecks::CheckArithmetic]; }
- (void)testReversesChunkOrderWithoutReversingBytes { [self runCheck:TESTQuirkHighChecks::CheckChunkDirections]; }
- (void)testWraparoundAndInPlace { [self runCheck:TESTQuirkHighChecks::CheckBlocks]; }
- (void)testRejectsInvalidInputs { [self runCheck:TESTQuirkHighChecks::CheckValidation]; }
- (void)testPreservesLowNibbleInformationAndReversesSequences { [self runCheck:TESTQuirkHighChecks::CheckReversibility]; }
@end
