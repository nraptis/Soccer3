// Serial: exercises the shared production seed state.
#import <XCTest/XCTest.h>
#include "Soccer3.hpp"
#include "SeedMaterialTestSupport.hpp"
#include <algorithm>
#include <limits>

namespace {
struct Cleanup { ~Cleanup() { Soccer3::Zero(); } };
void PoisonFreeRotations() {
    for (auto *aWord : SeedMaterialTestSupport::FreeRotationWords()) *aWord = 999U;
    for (auto *aRotation : SeedMaterialTestSupport::FreeRotations()) *aRotation = 777;
}
}

@interface FreeRotationSeedTests : XCTestCase
@end
@implementation FreeRotationSeedTests

- (void)testZeroAndBothSeedEntryPointsClearWordsAndAssembledRotations {
    Cleanup aCleanup;
    const auto aCheck = [&] {
        for (const auto *aWord : SeedMaterialTestSupport::FreeRotationWords()) XCTAssertEqual(*aWord, std::uint64_t{0U});
        for (const auto *aRotation : SeedMaterialTestSupport::FreeRotations()) XCTAssertEqual(*aRotation, 0);
    };
    PoisonFreeRotations();
    Soccer3::Zero();
    aCheck();
    std::uint8_t aPassword[] = {1U, 7U, 19U};
    std::uint32_t aAcknowledgement = 0U;
    PoisonFreeRotations();
    XCTAssertTrue(Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kTest, aPassword, sizeof(aPassword),
                                             91U, &aAcknowledgement, 0U, nullptr));
    aCheck();
    PoisonFreeRotations();
    XCTAssertTrue(Soccer3::AttemptSeed_Decrypt(EncryptionStrength::kTest, aPassword, sizeof(aPassword),
                                             91U, aAcknowledgement, 0U, nullptr));
    aCheck();
}

@end
