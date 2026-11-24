#import <XCTest/XCTest.h>

#include "FourToad.hpp"
#include "FlameToadCipher.hpp"

#include <algorithm>
#include <limits>
#include <random>
#include <vector>

@interface FourToadTests : XCTestCase
@end

@implementation FourToadTests

- (void)testMatchesFourSequentialFlameToads {
    using Bytes = std::vector<std::uint8_t>;
    std::mt19937_64 aRandom(20261105);
    // Includes short serial inputs, uneven parallel quarters, and the archiver's 1 MiB.
    for (std::size_t aWindows : {1U, 3U, 17U, 1023U, 1024U, 1027U, 16384U}) {
        const auto aLength = aWindows * 64;
        Bytes aSource(aLength), aResult(aLength), aRestored(aLength), aKeys(aLength / 4);
        for (auto &aByte : aSource) aByte = static_cast<std::uint8_t>(aRandom());
        for (unsigned aRow = 0; aRow < 8; ++aRow) {
            std::array<FourToad::Stage, 4> aStages;
            for (unsigned i = 0; i < aStages.size(); ++i) {
                auto &aStage = aStages[i];
                aStage.mRowA = (aRow + 2 * i) % 8;
                aStage.mRowB = (aStage.mRowA + 1 + aRow % 7) % 8;
                aStage.mWindowRotations = {0, aWindows - 1, aRandom(), std::numeric_limits<std::size_t>::max()};
            }
            // The direct FlameToad path computes each key from the source on demand.
            Bytes aExpected = aSource, aTemporary(aLength);
            for (const auto &aStage : aStages) {
                const auto &aRotation = aStage.mWindowRotations;
                FlameToadCipher aReference(aStage.mRowA, aStage.mRowB, aRotation[0], aRotation[1],
                                           aRotation[2], aRotation[3]);
                XCTAssertTrue(aReference.SealData(aExpected.data(), nullptr, aTemporary.data(), aLength, nullptr));
                aExpected.swap(aTemporary);
            }
            FourToad aCipher(aStages[0], aStages[1], aStages[2], aStages[3], aKeys);
            XCTAssertTrue(aCipher.SealData(aSource.data(), nullptr, aResult.data(), aLength, nullptr));
            XCTAssertTrue(aResult == aExpected, @"windows=%zu row=%u", aWindows, aRow);
            std::fill(aKeys.begin(), aKeys.end(), 0x55);
            XCTAssertTrue(aCipher.UnsealData(aExpected.data(), nullptr, aRestored.data(), aLength, nullptr));
            XCTAssertTrue(aRestored == aSource, @"windows=%zu row=%u", aWindows, aRow);
        }
    }
}

- (void)testRejectsInvalidBuffersAndStagesBeforeWriting {
    std::array<std::uint8_t, 129> aSource{};
    std::array<std::uint8_t, 64> aOutput{};
    std::array<std::uint8_t, 16> aKeys{};
    const FourToad::Stage aStage{2, 4, {0, 1, 2, 3}};
    FourToad aCipher(aStage, aStage, aStage, aStage, aKeys);
    CipherErrorCode aError{};
    XCTAssertTrue(aCipher.SealData(nullptr, nullptr, nullptr, 0, &aError));
    XCTAssertFalse(aCipher.SealData(aSource.data(), nullptr, aOutput.data(), 63, &aError));
    XCTAssertTrue(aError == CipherErrorCode::kInvalidLength);
    XCTAssertFalse(aCipher.SealData(nullptr, nullptr, aOutput.data(), 64, &aError));
    XCTAssertTrue(aError == CipherErrorCode::kNullBuffer);
    XCTAssertFalse(aCipher.UnsealData(aSource.data(), nullptr, aSource.data() + 1, 64, &aError));
    XCTAssertTrue(aError == CipherErrorCode::kAliasedBuffer);
    FourToad aShort(aStage, aStage, aStage, aStage, std::span(aKeys).first(15));
    XCTAssertFalse(aShort.SealData(aSource.data(), nullptr, aOutput.data(), 64, &aError));
    XCTAssertTrue(aError == CipherErrorCode::kInvalidParameter);
    FourToad aOverlap(aStage, aStage, aStage, aStage, std::span(aSource).subspan(57, 16));
    XCTAssertFalse(aOverlap.SealData(aSource.data(), nullptr, aOutput.data(), 64, &aError));
    XCTAssertTrue(aError == CipherErrorCode::kAliasedBuffer);
    auto aBadStage = aStage;
    aBadStage.mRowB = aStage.mRowA;
    FourToad aBad(aStage, aStage, aStage, aBadStage, aKeys);
    aOutput.fill(0x77);
    const auto aBefore = aOutput;
    XCTAssertFalse(aBad.SealData(aSource.data(), nullptr, aOutput.data(), 64, &aError));
    XCTAssertTrue(aError == CipherErrorCode::kInvalidParameter);
    XCTAssertTrue(aOutput == aBefore);
}

@end
