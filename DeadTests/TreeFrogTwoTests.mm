#import <XCTest/XCTest.h>
#include "TreeFrogTwoChecks.hpp"

@interface TreeFrogTwoTests : XCTestCase
@end
@implementation TreeFrogTwoTests
- (void)testAll28PairsAgainstEveryByteValue {
    const auto aFailure = CheckTreeFrogTwoTruthTables();
    XCTAssertTrue(aFailure == nullptr, @"%s", aFailure ? aFailure : "");
}
- (void)testUnalignedMegabyteTailsAndInvalidArguments {
    const auto aFailure = CheckTreeFrogTwoBuffers();
    XCTAssertTrue(aFailure == nullptr, @"%s", aFailure ? aFailure : "");
}
@end
