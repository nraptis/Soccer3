// Retired with FlameToad: historical Cryptex / premium-seed plumbing. Source retained.
#if 0
#import <XCTest/XCTest.h>
#include "Soccer2.hpp"
#include <memory>

@interface RetiredCipherPlanTests : XCTestCase
@end
@implementation RetiredCipherPlanTests
- (void)testRetiredPlanCipherTypesAreRejectedByTheFactory {
    // These reserved IDs require no archived implementation headers.
    for(auto type : {
        // Removed mutator encodings remain invalid; do not recycle these IDs.
        static_cast<CipherType>(0x1852U),
        static_cast<CipherType>(0x1893U),
        CipherType::kBitRotationCipher,
        CipherType::kMixCipherA,
        CipherType::kMixCipherB,
        CipherType::kMixCipherC,
        CipherType::kMixCipherD,
        CipherType::kMixCipherE,
        CipherType::kMixCipherF,
        CipherType::kMixCipherG,
        CipherType::kMixCipherH,
        CipherType::kSpreadCipherA,
        CipherType::kSpreadCipherB,
        CipherType::kSpreadCipherC,
        CipherType::kSpreadCipherD,
        CipherType::kSpreadCipherE,
        CipherType::kSpreadCipherF,
        CipherType::kSpreadCipherG,
        CipherType::kSpreadCipherH,
        CipherType::kMudgeCipherA,
        CipherType::kMudgeCipherB,
        CipherType::kMudgeCipherC,
        CipherType::kSkullCipherA,
        CipherType::kSkullCipherB,
        CipherType::kSkullCipherC,
        CipherType::kSkullCipherD,
        CipherType::kDanceCipherA,
        CipherType::kDanceCipherB}) {
        for(unsigned stage=0;stage<9;++stage) {
            std::unique_ptr<Cipher> cipher(Soccer2::GenerateCipher(type,stage));
            XCTAssertTrue(cipher==nullptr);
        }
    }
}
@end

#endif
#import <XCTest/XCTest.h>
@interface RetiredCipherPlanTests : XCTestCase
@end
@implementation RetiredCipherPlanTests
- (void)testRetiredConstruction { XCTSkip(@"Historical Cryptex / premium-seed test; replaced by FlameToad vault checks."); }
@end
