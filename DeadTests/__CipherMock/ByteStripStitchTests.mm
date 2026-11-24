#import <XCTest/XCTest.h>

#include "ByteStripStitch.hpp"
#include "ByteStripStitchNEON.hpp"
#include "../../Scramble/Encrypter/Ciphers/FlameToadPacking.hpp"

#include <array>
#include <random>

namespace {
constexpr std::array kStitches = {ByteStripStitch::StitchA, ByteStripStitch::StitchB,
                                  ByteStripStitch::StitchC, ByteStripStitch::StitchD};
}

@interface ByteStripStitchTests : XCTestCase
@end

@implementation ByteStripStitchTests

- (void)testEveryInputBitHasItsOwnOutputPosition {
    // Each of the 512 input bits must appear exactly once, in the documented
    // byte lane and bit position. Also catches any uninitialized output bits.
    for (std::size_t aStrip = 0; aStrip < 8; ++aStrip) {
        for (std::size_t aBit = 0; aBit < BYTE_WINDOW_SIZE; ++aBit) {
            std::array<ByteWindowBitStrip, 8> aStrips{};
            aStrips[aStrip].mBits[aBit] = true;
            for (std::size_t aRotation = 0; aRotation < kStitches.size(); ++aRotation) {
                const auto aResult = kStitches[aRotation](
                    aStrips[0], aStrips[1], aStrips[2], aStrips[3],
                    aStrips[4], aStrips[5], aStrips[6], aStrips[7]);

                const auto aOutputByte = (aBit / 4) * 4 + aStrip / 2;
                const auto aOutputBit = ((aBit + aRotation) % 4) * 2 + aStrip % 2;
                for (std::size_t aByte = 0; aByte < BYTE_WINDOW_SIZE; ++aByte) {
                    const unsigned aExpected = aByte == aOutputByte ? 1U << aOutputBit : 0U;
                    XCTAssertEqual(aResult.mBytes[aByte], aExpected,
                                   @"rotation=%zu strip=%zu bit=%zu byte=%zu",
                                   aRotation, aStrip, aBit, aByte);
                }
            }
        }
    }
}

- (void)testMatchesProductionSIMDPackingForEveryOrderedRowPair {
#if SOCCER_USE_NEON || (!IGNORE_SIMD && defined(__SSE2__))
    std::mt19937_64 aRandom(20261111);
    for (unsigned aRow1 = 0; aRow1 < 8; ++aRow1) {
        for (unsigned aRow2 = 0; aRow2 < 8; ++aRow2) {
            if (aRow1 == aRow2) continue;
            for (unsigned aTrial = 0; aTrial < 32; ++aTrial) {
                std::array<ByteWindow, 4> aWindows{};
                for (auto &aWindow : aWindows) {
                    for (auto &aByte : aWindow.mBytes) {
                        aByte = aTrial == 0 ? 0 : aTrial == 1 ? 255 : aRandom();
                    }
                }
                const auto aResult = ByteStripStitch::StitchA(
                    aWindows[0].GetStrip(aRow1), aWindows[0].GetStrip(aRow2),
                    aWindows[1].GetStrip(aRow1), aWindows[1].GetStrip(aRow2),
                    aWindows[2].GetStrip(aRow1), aWindows[2].GetStrip(aRow2),
                    aWindows[3].GetStrip(aRow1), aWindows[3].GetStrip(aRow2));

                ByteWindow aExpected{};
#if SOCCER_USE_NEON
                const int8x16_t aPositions = {0,2,4,6,0,2,4,6,0,2,4,6,0,2,4,6};
                const auto aShift1 = vsubq_s8(aPositions, vdupq_n_s8(aRow1));
                const auto aShift2 = vsubq_s8(vaddq_s8(aPositions, vdupq_n_s8(1)), vdupq_n_s8(aRow2));
                uint8x16x4_t aPacked;
                for (std::size_t aWindow = 0; aWindow < 4; ++aWindow) {
                    aPacked.val[aWindow] = FlameToadPacking::PackNEON(aWindows[aWindow].mBytes, aShift1, aShift2);
                }
                vst4q_u8(aExpected.mBytes, aPacked);
#else
                for (std::size_t aWindow = 0; aWindow < 4; ++aWindow) {
                    std::uint8_t aPacked[16];
                    _mm_storeu_si128(reinterpret_cast<__m128i *>(aPacked),
                        FlameToadPacking::PackSIMD(aWindows[aWindow].mBytes,
                                                  _mm_cvtsi32_si128(aRow1), _mm_cvtsi32_si128(aRow2)));
                    for (std::size_t aGroup = 0; aGroup < 16; ++aGroup) {
                        aExpected.mBytes[4 * aGroup + aWindow] = aPacked[aGroup];
                    }
                }
#endif
                for (std::size_t aByte = 0; aByte < BYTE_WINDOW_SIZE; ++aByte) {
                    XCTAssertEqual(aResult.mBytes[aByte], aExpected.mBytes[aByte],
                                   @"rows=%u,%u trial=%u byte=%zu", aRow1, aRow2, aTrial, aByte);
                }
            }
        }
    }
#else
    XCTSkip(@"Requires a NEON or SSE2 build to compare against the production SIMD packer.");
#endif
}

- (void)testAllFourStitchesMatchNEONAtBothWindowSizes {
#if defined(__aarch64__)
    std::mt19937_64 aRandom(20261112);
    for (unsigned aRow1 = 0; aRow1 < 8; ++aRow1) {
        for (unsigned aRow2 = 0; aRow2 < 8; ++aRow2) {
            if (aRow1 == aRow2) continue;
            for (unsigned aTrial = 0; aTrial < 32; ++aTrial) {
                std::array<ByteWindow, 4> aWindows{};
                std::array<std::array<std::uint8_t, 32>, 4> aShortWindows{};
                for (std::size_t aWindow = 0; aWindow < 4; ++aWindow) {
                    for (std::size_t aByte = 0; aByte < 64; ++aByte) {
                        const auto aValue = static_cast<std::uint8_t>(
                            aTrial == 0 ? 0 : aTrial == 1 ? 255 : aRandom());
                        aWindows[aWindow].mBytes[aByte] = aValue;
                        if (aByte < 32) aShortWindows[aWindow][aByte] = aValue;
                    }
                }
                for (std::size_t aRotation = 0; aRotation < kStitches.size(); ++aRotation) {
                    const auto aExpected = kStitches[aRotation](
                        aWindows[0].GetStrip(aRow1), aWindows[0].GetStrip(aRow2),
                        aWindows[1].GetStrip(aRow1), aWindows[1].GetStrip(aRow2),
                        aWindows[2].GetStrip(aRow1), aWindows[2].GetStrip(aRow2),
                        aWindows[3].GetStrip(aRow1), aWindows[3].GetStrip(aRow2));

                    const auto aPlan = ByteStripStitchNEON::MakePlan(aRow1, aRow2, aRotation);
                    uint8x16x4_t aPacked64;
                    uint8x8x4_t aPacked32;
                    for (std::size_t aWindow = 0; aWindow < 4; ++aWindow) {
                        aPacked64.val[aWindow] = ByteStripStitchNEON::Pack64(aWindows[aWindow].mBytes, aPlan);
                        aPacked32.val[aWindow] = ByteStripStitchNEON::Pack32(aShortWindows[aWindow].data(), aPlan);
                    }
                    ByteWindow aResult64{};
                    std::array<std::uint8_t, 32> aResult32{};
                    vst4q_u8(aResult64.mBytes, aPacked64);
                    vst4_u8(aResult32.data(), aPacked32);
                    for (std::size_t aByte = 0; aByte < 64; ++aByte) {
                        XCTAssertEqual(aResult64.mBytes[aByte], aExpected.mBytes[aByte],
                                       @"64-byte rotation=%zu rows=%u,%u byte=%zu",
                                       aRotation, aRow1, aRow2, aByte);
                        if (aByte < 32) {
                            XCTAssertEqual(aResult32[aByte], aExpected.mBytes[aByte],
                                           @"32-byte rotation=%zu rows=%u,%u byte=%zu",
                                           aRotation, aRow1, aRow2, aByte);
                        }
                    }
                }
            }
        }
    }
#else
    XCTSkip(@"Requires AArch64 NEON to compare both native window sizes.");
#endif
}

@end
