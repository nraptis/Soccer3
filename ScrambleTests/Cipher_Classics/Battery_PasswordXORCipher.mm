#import <XCTest/XCTest.h>
#include "PasswordXORCipher.hpp"
#include "CipherGauntlet.hpp"

@interface Battery_PasswordXORCipher : XCTestCase
@end

@implementation Battery_PasswordXORCipher

- (void)test_gauntlet_PasswordXORCipher {
    static CipherGauntlet aGauntlet;
    alignas(std::uint64_t) static std::uint8_t aPassword[SOCCER_BLOCK_SIZE];

    for (std::size_t aTrial = 0U; aTrial < TEST_COUNT_OUTER_LOOP; ++aTrial) {
        CipherGauntlet::ArrayRandomize(aPassword, sizeof(aPassword));
        PasswordXORCipher aCipher(aPassword);

        if (!aGauntlet.RunCipher(&aCipher, "PasswordXORCipher")) {
            XCTFail("[PasswordXORCipher] gauntlet failed at trial %zu.", aTrial);
            return;
        }
    }
}

@end
