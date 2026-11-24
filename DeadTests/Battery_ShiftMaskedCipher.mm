#import <XCTest/XCTest.h>
#include "ShiftMaskedCipher.hpp"
#include "CipherGauntlet.hpp"
#include "Random.hpp"

@interface Battery_ShiftMaskedCipher : XCTestCase
@end

@implementation Battery_ShiftMaskedCipher

- (void)test_gauntlet_ShiftMaskedCipher {
    static CipherGauntlet aGauntlet;

    for (std::size_t aTrial = 0U; aTrial < TEST_COUNT_OUTER_LOOP; ++aTrial) {
        const std::uint8_t aMask = Random::GetByte();
        const std::size_t aShift = Random::Get(SOCCER_BLOCK_SIZE);
        ShiftMaskedCipher aCipher(aMask, aShift);

        if (!aGauntlet.RunCipher(&aCipher, "ShiftMaskedCipher")) {
            XCTFail("[ShiftMaskedCipher] gauntlet failed at trial %zu: mask=%u, shift=%zu.",
                    aTrial, static_cast<unsigned>(aMask), aShift);
            return;
        }
    }
}

@end
