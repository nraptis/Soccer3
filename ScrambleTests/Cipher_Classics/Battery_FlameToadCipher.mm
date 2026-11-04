#import <XCTest/XCTest.h>
#include "FlameToadCipher.hpp"
#include "CipherGauntlet.hpp"
#include "Random.hpp"

@interface Battery_FlameToadCipher : XCTestCase
@end

@implementation Battery_FlameToadCipher

- (void)test_gauntlet_FlameToadCipher {
    static CipherGauntlet aGauntlet;
    static std::uint8_t aPackedRows[SOCCER_BLOCK_SIZE / 4U];
    constexpr int kWindowCount = SOCCER_BLOCK_SIZE / FlameToadCipher::kWindowBytes;
    
    for (std::size_t aTrial = 0U; aTrial < TEST_COUNT_OUTER_LOOP; ++aTrial) {
        std::uint8_t aBitRows[] = {0U, 1U, 2U, 3U, 4U, 5U, 6U, 7U};
        Random::Shuffle(aBitRows, 8);
        const std::size_t aRotationA = Random::Get(kWindowCount);
        const std::size_t aRotationB = Random::Get(kWindowCount);
        const std::size_t aRotationC = Random::Get(kWindowCount);
        const std::size_t aRotationD = Random::Get(kWindowCount);
        const bool aUsePackedRows = Random::Bool();
        FlameToadCipher aCipher(aBitRows[0], aBitRows[1],
                                aRotationA, aRotationB, aRotationC, aRotationD,
                                aUsePackedRows ? std::span<std::uint8_t>{aPackedRows}
                                : std::span<std::uint8_t>{});
        
        if (!aGauntlet.RunCipher(&aCipher, "FlameToadCipher")) {
            XCTFail("[FlameToadCipher] gauntlet failed at trial %zu: rows=%u,%u, rotations=%zu,%zu,%zu,%zu, cached=%d.",
                    aTrial, static_cast<unsigned>(aBitRows[0]), static_cast<unsigned>(aBitRows[1]),
                    aRotationA, aRotationB, aRotationC, aRotationD, aUsePackedRows);
            return;
        }
    }
}

@end
