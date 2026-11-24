//
//  ByteStripStitch.cpp
//  ScrambleTests
//
//  Created by Amada Badger on 11/11/26.
//

#include "ByteStripStitch.hpp"

#include <array>

namespace {

ByteWindow StitchWithPairRotation(const std::array<const ByteWindowBitStrip *, 8> &pStrips,
                                 std::size_t pPairRotation) {
    ByteWindow aResult{};

    // Each window contributes two rows. Four positions from those rows fill
    // one output byte; the four windows fill four neighboring output bytes.
    for (std::size_t aGroup = 0; aGroup < BYTE_WINDOW_SIZE / 4; ++aGroup) {
        for (std::size_t aWindow = 0; aWindow < 4; ++aWindow) {
            const auto &aFirstRow = *pStrips[2 * aWindow];
            const auto &aSecondRow = *pStrips[2 * aWindow + 1];
            std::uint8_t aPacked = 0;
            for (std::size_t aPosition = 0; aPosition < 4; ++aPosition) {
                const auto aStripIndex = 4 * aGroup + aPosition;
                const auto aOutputPair = (aPosition + pPairRotation) % 4;
                if (aFirstRow.mBits[aStripIndex]) {
                    aPacked |= static_cast<std::uint8_t>(1U << (2 * aOutputPair));
                }
                if (aSecondRow.mBits[aStripIndex]) {
                    aPacked |= static_cast<std::uint8_t>(1U << (2 * aOutputPair + 1));
                }
            }
            aResult.mBytes[4 * aGroup + aWindow] = aPacked;
        }
    }
    return aResult;
}

} // namespace

ByteWindow ByteStripStitch::StitchA(ByteWindowBitStrip pStripA1,
                                   ByteWindowBitStrip pStripA2,
                                   ByteWindowBitStrip pStripB1,
                                   ByteWindowBitStrip pStripB2,
                                   ByteWindowBitStrip pStripC1,
                                   ByteWindowBitStrip pStripC2,
                                   ByteWindowBitStrip pStripD1,
                                   ByteWindowBitStrip pStripD2) {
    return StitchWithPairRotation({&pStripA1, &pStripA2, &pStripB1, &pStripB2,
                                   &pStripC1, &pStripC2, &pStripD1, &pStripD2}, 0);
}

ByteWindow ByteStripStitch::StitchB(ByteWindowBitStrip pStripA1,
                                   ByteWindowBitStrip pStripA2,
                                   ByteWindowBitStrip pStripB1,
                                   ByteWindowBitStrip pStripB2,
                                   ByteWindowBitStrip pStripC1,
                                   ByteWindowBitStrip pStripC2,
                                   ByteWindowBitStrip pStripD1,
                                   ByteWindowBitStrip pStripD2) {
    return StitchWithPairRotation({&pStripA1, &pStripA2, &pStripB1, &pStripB2,
                                   &pStripC1, &pStripC2, &pStripD1, &pStripD2}, 1);
}

ByteWindow ByteStripStitch::StitchC(ByteWindowBitStrip pStripA1,
                                   ByteWindowBitStrip pStripA2,
                                   ByteWindowBitStrip pStripB1,
                                   ByteWindowBitStrip pStripB2,
                                   ByteWindowBitStrip pStripC1,
                                   ByteWindowBitStrip pStripC2,
                                   ByteWindowBitStrip pStripD1,
                                   ByteWindowBitStrip pStripD2) {
    return StitchWithPairRotation({&pStripA1, &pStripA2, &pStripB1, &pStripB2,
                                   &pStripC1, &pStripC2, &pStripD1, &pStripD2}, 2);
}

ByteWindow ByteStripStitch::StitchD(ByteWindowBitStrip pStripA1,
                                   ByteWindowBitStrip pStripA2,
                                   ByteWindowBitStrip pStripB1,
                                   ByteWindowBitStrip pStripB2,
                                   ByteWindowBitStrip pStripC1,
                                   ByteWindowBitStrip pStripC2,
                                   ByteWindowBitStrip pStripD1,
                                   ByteWindowBitStrip pStripD2) {
    return StitchWithPairRotation({&pStripA1, &pStripA2, &pStripB1, &pStripB2,
                                   &pStripC1, &pStripC2, &pStripD1, &pStripD2}, 3);
}
