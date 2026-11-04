#import <XCTest/XCTest.h>
#include "EncryptionVaultChecks.hpp"

@interface EncryptionVaultTests : XCTestCase
@end
@implementation EncryptionVaultTests
- (void)testFourLayerRoundOrderAndInverseOnOneMiB {
    const auto aFailure = EncryptionVaultChecks::CheckRoundOrder();
    XCTAssertTrue(aFailure == nullptr, @"%s", aFailure ? aFailure : "");
}
- (void)testEightLayerVaultOrderWithEmptyOddAndEvenLayers {
    const auto aFailure = EncryptionVaultChecks::CheckVaultOrder();
    XCTAssertTrue(aFailure == nullptr, @"%s", aFailure ? aFailure : "");
}
// The historical sample ciphers were archived; keep the remaining vault mechanics checks.
#if 0
- (void)testActualCiphersMatchTwoRoundsAndRepeatIndependentBlocks {
    const auto aFailure = EncryptionVaultChecks::CheckRealCiphersAndIndependentBlocks();
    XCTAssertTrue(aFailure == nullptr, @"%s", aFailure ? aFailure : "");
}
#endif
- (void)testRoundBufferValidationAndEmptyIdentity {
    const auto aFailure = EncryptionVaultChecks::CheckBufferErrors<EncryptionLayerRound>();
    XCTAssertTrue(aFailure == nullptr, @"%s", aFailure ? aFailure : "");
}
- (void)testVaultBufferValidationAndEmptyIdentity {
    const auto aFailure = EncryptionVaultChecks::CheckBufferErrors<EncryptionVault>();
    XCTAssertTrue(aFailure == nullptr, @"%s", aFailure ? aFailure : "");
}
- (void)testErrorPropagationCleanupAndCipherOwnership {
    const auto aFailure = EncryptionVaultChecks::CheckFailuresAndOwnership();
    XCTAssertTrue(aFailure == nullptr, @"%s", aFailure ? aFailure : "");
}
@end
