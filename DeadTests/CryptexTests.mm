#import <XCTest/XCTest.h>
#include "CryptexChecks.hpp"

@interface CryptexTests : XCTestCase
@end
@implementation CryptexTests
- (void)testEightLayerVaultOrderWithEmptyOddAndEvenLayers {
    const auto aFailure = CryptexChecks::CheckVaultOrder();
    XCTAssertTrue(aFailure == nullptr, @"%s", aFailure ? aFailure : "");
}
- (void)testVaultBufferValidationAndEmptyIdentity {
    const auto aFailure = CryptexChecks::CheckBufferErrors<Cryptex>();
    XCTAssertTrue(aFailure == nullptr, @"%s", aFailure ? aFailure : "");
}
- (void)testErrorPropagationCleanupAndCipherOwnership {
    const auto aFailure = CryptexChecks::CheckFailuresAndOwnership();
    XCTAssertTrue(aFailure == nullptr, @"%s", aFailure ? aFailure : "");
}
@end
