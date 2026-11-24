#import <XCTest/XCTest.h>
#include "QuirkCipherChecks.hpp"

@interface QuirkCipherTests : XCTestCase
@end

@implementation QuirkCipherTests
- (void)runCheck:(void (*)())pCheck {
    try { pCheck(); }
    catch (const std::exception &aError) { XCTFail(@"%s", aError.what()); }
}
- (void)testAllSixteenProductionCiphersAgainstEveryNibbleCombination { [self runCheck:QuirkCipherChecks::CheckArithmetic]; }
- (void)testFullBlocksOracleAndInPlace { [self runCheck:QuirkCipherChecks::CheckBlocks]; }
- (void)testErrorsAndZero { [self runCheck:QuirkCipherChecks::CheckValidationAndZero]; }
- (void)testAlternatingHighLowThroughCryptexLayer { [self runCheck:QuirkCipherChecks::CheckComposition]; }
@end
