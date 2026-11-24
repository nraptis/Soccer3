#import <XCTest/XCTest.h>
#include "WindowRotationFarm.hpp"
#include <algorithm>
#include <cstring>

namespace {
struct RotationFallbackFixture {
    WindowRotationFarm::Buffers mBuffers{};
    WindowRotationPack mPack{};
    WindowRotationFarm::Statistics mStatistics[WindowRotationFarm::kJobCount]{};
    WindowRotationFarm::PreparedSource mSources[WindowRotationFarm::kJobCount]{};
    std::uint16_t mBase[2][WindowRotationFarm::kWindowCount]{};
    std::uint64_t mOffsetWords[2][WindowRotationFarm::kRotationsPerJob]{};

    void Prepare() {
        for (std::size_t aIndex=0U; aIndex<WindowRotationFarm::kWindowCount; aIndex++)
            mBase[0][aIndex] = static_cast<std::uint16_t>(aIndex);
        // The preferred two values are always banned; both traversal directions
        // must enter their opposite-end fallback before selecting anything.
        std::swap(mBase[0][1], mBase[0][WindowRotationFarm::kWindowCount / 2U]);
        for (std::size_t aIndex=0U; aIndex<WindowRotationFarm::kWindowCount; aIndex++)
            mBase[1][aIndex] = mBase[0][WindowRotationFarm::kWindowCount - 1U - aIndex];
        for (std::size_t aPlane=0U; aPlane<2U; aPlane++)
            for (std::size_t aIndex=0U; aIndex<WindowRotationFarm::kRotationsPerJob; aIndex++)
                mOffsetWords[aPlane][aIndex] = 61U + aPlane * 31U + aIndex;
        for (std::size_t aJob=0U; aJob<WindowRotationFarm::kJobCount; aJob++) {
            const bool aFree = aJob % WindowRotationFarm::kJobsPerPlane == 0U;
            mSources[aJob] = {mBase[aJob % 2U], 2U, aJob % 2U != 0U,
                aFree ? mOffsetWords[aJob / WindowRotationFarm::kJobsPerPlane] : nullptr, 0U};
        }
    }

    bool ValidWithByteOffsets() const {
        const WindowRotationPackChunk *aChunks[] = {
            &mPack.mPlaneA.mChunkA, &mPack.mPlaneA.mChunkB,
            &mPack.mPlaneA.mChunkC, &mPack.mPlaneA.mChunkD,
            &mPack.mPlaneB.mChunkA, &mPack.mPlaneB.mChunkB,
            &mPack.mPlaneB.mChunkC, &mPack.mPlaneB.mChunkD
        };
        std::int32_t aFreeRotations[WindowRotationFarm::kFreeRotationCount];
        for (std::size_t aLayer=0U; aLayer<8U; aLayer++) {
            const std::size_t aFirst = 2U * aLayer;
            const std::uint64_t *aWords = mOffsetWords[aLayer / 4U] + 2U * (aLayer % 4U);
            aFreeRotations[aFirst] = 64U * aChunks[aLayer]->mWindowFreeA +
                WindowRotationFarm::FreeByteOffset(aWords[0], false);
            aFreeRotations[aFirst + 1U] = 64U * aChunks[aLayer]->mWindowFreeB +
                WindowRotationFarm::FreeByteOffset(aWords[1], (aFreeRotations[aFirst] & 1) == 0);
        }
        return WindowRotationFarm::IsValid(mPack, aFreeRotations);
    }
};
} // namespace

@interface WindowRotationFarmFallbackTests : XCTestCase
@end

@implementation WindowRotationFarmFallbackTests

- (void)test_ExhaustedPrefixesUseBothTailsAndReplay {
    RotationFallbackFixture aFixture;
    aFixture.Prepare();
    WindowRotationFarm::FarmPreparedPack(aFixture.mSources, aFixture.mBuffers,
                                        aFixture.mPack, aFixture.mStatistics);
    XCTAssertTrue(aFixture.ValidWithByteOffsets());
    for (const auto &aStatistics : aFixture.mStatistics) {
        XCTAssertGreaterThan(aStatistics.mFallbackReadCount, std::size_t{0U});
        XCTAssertGreaterThan(aStatistics.mBaseReadCount, std::size_t{2U});
        XCTAssertLessThanOrEqual(aStatistics.mBaseReadCount, WindowRotationFarm::kWindowCount);
    }
    const WindowRotationPack aFirstPack = aFixture.mPack;
    WindowRotationFarm::FarmPreparedPack(aFixture.mSources, aFixture.mBuffers,
                                        aFixture.mPack, aFixture.mStatistics);
    XCTAssertTrue(aFixture.ValidWithByteOffsets());
    XCTAssertEqual(std::memcmp(&aFirstPack, &aFixture.mPack, sizeof(aFirstPack)), 0);
}

- (void)test_MissingAndMalformedListsUseNumericDefaults {
    RotationFallbackFixture aFixture;
    for (std::size_t aCase=0U; aCase<3U; aCase++) {
        // Null list, repeated zero, and out-of-range values must all complete.
        for (auto &aValue : aFixture.mBase[0]) aValue = aCase == 2U ? 65535U : 0U;
        for (auto &aSource : aFixture.mSources)
            aSource = {aCase == 0U ? nullptr : aFixture.mBase[0],
                       WindowRotationFarm::kWindowCount, false, nullptr, 0U};
        WindowRotationFarm::FarmPreparedPack(aFixture.mSources, aFixture.mBuffers,
                                            aFixture.mPack, aFixture.mStatistics);
        XCTAssertTrue(aFixture.ValidWithByteOffsets(), "Default case %zu failed.", aCase);
        for (const auto &aStatistics : aFixture.mStatistics)
            XCTAssertGreaterThan(aStatistics.mFallbackReadCount, std::size_t{0U});
    }
}

- (void)test_ShortEntropyAndMissingOffsetBytesStillFillPack {
    RotationFallbackFixture aFixture;
    std::uint8_t aShuffleBytes[32766U] = {};
    WindowRotationFarm::Source aSources[WindowRotationFarm::kJobCount];
    for (std::size_t aCase=0U; aCase<3U; aCase++) {
        // No entropy, one byte, or exactly enough to shuffle with no offsets left.
        const std::size_t aLength = aCase == 2U ? sizeof(aShuffleBytes) : aCase;
        for (auto &aSource : aSources) aSource = {aLength == 0U ? nullptr : aShuffleBytes, aLength};
        WindowRotationFarm::FarmPack(aSources, aFixture.mBuffers, aFixture.mPack, aFixture.mStatistics);
        XCTAssertTrue(aFixture.ValidWithByteOffsets(), "Entropy case %zu failed.", aCase);
        for (const auto &aStatistics : aFixture.mStatistics)
            XCTAssertLessThanOrEqual(aStatistics.mEntropyBytesRead, aLength);
    }
}

- (void)test_TailFallbackStillRejectsActualByteCollisions {
    RotationFallbackFixture aFixture;
    aFixture.Prepare();
    for (std::size_t aIndex=0U; aIndex<WindowRotationFarm::kWindowCount; aIndex++)
        aFixture.mBase[0][aIndex] = static_cast<std::uint16_t>(aIndex);
    std::swap(aFixture.mBase[0][0], aFixture.mBase[0][1]);
    std::swap(aFixture.mBase[0][1], aFixture.mBase[0][2]);
    std::swap(aFixture.mBase[0][16383], aFixture.mBase[0][4]);
    std::swap(aFixture.mBase[0][16382], aFixture.mBase[0][8]);
    aFixture.mSources[0] = {aFixture.mBase[0], 2U, false, aFixture.mOffsetWords[0], 0U};
    aFixture.mOffsetWords[0][0] = 62U; // offset 63
    aFixture.mOffsetWords[0][1] = 62U; // offset 63
    aFixture.mOffsetWords[0][2] = 61U; // offset 62
    WindowRotationFarm::FarmPreparedPack(aFixture.mSources, aFixture.mBuffers,
                                        aFixture.mPack, aFixture.mStatistics);
    // 64*1+63 + 64*2+63 == 64*4+62, so tail window 4 must be skipped.
    XCTAssertEqual(aFixture.mPack.mPlaneA.mChunkA.mWindowFreeA, 1U);
    XCTAssertEqual(aFixture.mPack.mPlaneA.mChunkA.mWindowFreeB, 2U);
    XCTAssertEqual(aFixture.mPack.mPlaneA.mChunkB.mWindowFreeA, 8U);
    XCTAssertTrue(aFixture.ValidWithByteOffsets());
    XCTAssertGreaterThan(aFixture.mStatistics[0].mFallbackReadCount, std::size_t{0U});
}

@end
