#import <XCTest/XCTest.h>
#include "BitReverseCipher.hpp"
#include "CipherGauntlet.hpp"

@interface Battery_BitReverseCipher : XCTestCase
@end

@implementation Battery_BitReverseCipher

- (void)test_gauntlet_BitReverseCipher {
    static CipherGauntlet aGauntlet;

    for (std::size_t aTrial = 0U; aTrial < TEST_COUNT_OUTER_LOOP; ++aTrial) {
        BitReverseCipher aCipher{};

        if (!aGauntlet.RunCipher(&aCipher, "BitReverseCipher")) {
            XCTFail("[BitReverseCipher] gauntlet failed at trial %zu.", aTrial);
            return;
        }
    }
}

@end
