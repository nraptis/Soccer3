#import <XCTest/XCTest.h>
#include "BitReverseKernel.hpp"
#include "CipherGauntlet.hpp"

@interface Battery_BitReverseCipher : XCTestCase
@end

@implementation Battery_BitReverseCipher

- (void)test_gauntlet_BitReverseCipher {
    static CipherGauntlet aGauntlet;

    for (std::size_t aTrial = 0U; aTrial < TEST_COUNT_OUTER_LOOP; ++aTrial) {
        BitReverseKernel aCipher{};

        if (!aGauntlet.RunCipher(&aCipher, "BitReverseKernel")) {
            XCTFail("[BitReverseKernel] gauntlet failed at trial %zu.", aTrial);
            return;
        }
    }
}

@end
