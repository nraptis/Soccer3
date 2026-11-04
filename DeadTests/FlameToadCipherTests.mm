#import <XCTest/XCTest.h>
#include "FlameToadCipherChecks.hpp"
@interface FlameToadCipherTests : XCTestCase
@end
@implementation FlameToadCipherTests
- (void)testAllOrderedRowPairsPackingWrapsAndIndependentInverse {
    const auto aFailure=FlameToadChecks::CheckReferenceAndInverse();
    XCTAssertTrue(aFailure==nullptr,@"%s",aFailure?aFailure:"");
}
- (void)testUnalignedMiBGuardsAndRejectedArguments {
    const auto aFailure=FlameToadChecks::CheckBuffers();
    XCTAssertTrue(aFailure==nullptr,@"%s",aFailure?aFailure:"");
}
- (void)testPackedCacheCapacityAliasingGuardsAndFreshInverse {
    const auto aFailure=FlameToadChecks::CheckCachedBuffers();
    XCTAssertTrue(aFailure==nullptr,@"%s",aFailure?aFailure:"");
}
@end
