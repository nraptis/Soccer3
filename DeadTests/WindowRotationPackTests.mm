#import <XCTest/XCTest.h>
#include "WindowRotationFarm.hpp"
#include <algorithm>
#include <cstring>
#include <memory>
#include <random>
#include <set>
#include <type_traits>

namespace {
using namespace WindowRotationFarm;
static_assert(std::is_aggregate_v<WindowRotationPackChunk> && std::is_trivial_v<WindowRotationPackChunk>);
static_assert(std::is_aggregate_v<WindowRotationPackPlane> && std::is_trivial_v<WindowRotationPackPlane>);
static_assert(std::is_aggregate_v<WindowRotationPack> && std::is_trivial_v<WindowRotationPack>);
static_assert(std::is_standard_layout_v<WindowRotationPack>);
static_assert(sizeof(WindowRotationPackChunk) == 36U);
static_assert(sizeof(WindowRotationPackPlane) == 144U);
static_assert(sizeof(WindowRotationPack) == 288U);

struct Fixture {
    std::uint8_t mEntropy[kJobCount][65536U];
    Source mSources[kJobCount];
    Buffers mBuffers{};
    WindowRotationPack mPack{};
    Statistics mStatistics[kJobCount]{};

    void Fill(std::size_t pJob, std::uint64_t pSeed) {
        std::mt19937_64 aRandom(pSeed);
        for (auto &aByte : mEntropy[pJob]) aByte = static_cast<std::uint8_t>(aRandom());
        mSources[pJob] = {mEntropy[pJob], sizeof(mEntropy[pJob])};
    }
    void Prepare(std::uint64_t pSeed) {
        for (std::size_t aJob = 0U; aJob < kJobCount; ++aJob) Fill(aJob, pSeed * 101U + aJob);
    }
    bool Farm() { return FarmPack(mSources, mBuffers, mPack, mStatistics); }
};

void ExtractJobs(const WindowRotationPack &pPack, std::uint32_t (&pValues)[kJobCount][8U]) {
    const WindowRotationPackPlane *aPlanes[] = {&pPack.mPlaneA, &pPack.mPlaneB};
    for (std::size_t aPlaneIndex = 0U; aPlaneIndex < 2U; ++aPlaneIndex) {
        const auto &aPlane = *aPlanes[aPlaneIndex];
        const WindowRotationPackChunk *aChunks[] = {&aPlane.mChunkA, &aPlane.mChunkB, &aPlane.mChunkC, &aPlane.mChunkD};
        const auto aFirstJob = aPlaneIndex * 9U;
        for (std::size_t aChunkIndex = 0U; aChunkIndex < 4U; ++aChunkIndex) {
            const auto &aChunk = *aChunks[aChunkIndex];
            pValues[aFirstJob][2U * aChunkIndex] = static_cast<std::uint32_t>(aChunk.mWindowFreeA);
            pValues[aFirstJob][2U * aChunkIndex + 1U] = static_cast<std::uint32_t>(aChunk.mWindowFreeB);
            const std::uint16_t aWindows[] = {
                aChunk.mWindowA, aChunk.mWindowB, aChunk.mWindowC, aChunk.mWindowD,
                aChunk.mWindowE, aChunk.mWindowF, aChunk.mWindowG, aChunk.mWindowH,
                aChunk.mWindowI, aChunk.mWindowJ, aChunk.mWindowK, aChunk.mWindowL,
                aChunk.mWindowM, aChunk.mWindowN, aChunk.mWindowO, aChunk.mWindowP
            };
            for (std::size_t aWindow = 0U; aWindow < 16U; ++aWindow)
                pValues[aFirstJob + 1U + 2U * aChunkIndex + aWindow / 8U][aWindow % 8U] = aWindows[aWindow];
        }
    }
}

// Independently enumerate all 256 subsets; no use of the farmer's block map
// or incremental recurrence. Check both physical rings, including wraparound.
bool UniqueSubsetSums(const std::uint32_t *pValues, bool pFree) {
    std::set<std::uint32_t> aWindowSums, aByteSums;
    for (unsigned aSubset = 0U; aSubset < 256U; ++aSubset) {
        std::uint32_t aWindowSum = 0U, aByteSum = 0U;
        for (unsigned aIndex = 0U; aIndex < 8U; ++aIndex) {
            if ((aSubset & (1U << aIndex)) == 0U) continue;
            aWindowSum += pFree ? pValues[aIndex] / 64U : pValues[aIndex];
            aByteSum += pFree ? pValues[aIndex] : 64U * pValues[aIndex];
        }
        if (!aWindowSums.insert(aWindowSum % 16384U).second ||
            !aByteSums.insert(aByteSum % 1048576U).second) return false;
    }
    return true;
}
}

@interface WindowRotationPackTests : XCTestCase
@end
@implementation WindowRotationPackTests
- (void)testEighteenJobsAllSubsetsAndUniversalSingleExclusions {
    auto aFixture = std::make_unique<Fixture>();
    for (unsigned aSeed = 0U; aSeed < 64U; ++aSeed) {
        aFixture->Prepare(aSeed);
        const bool aSuccess = aFixture->Farm();
        XCTAssertTrue(aSuccess, @"seed %u", aSeed);
        if (!aSuccess) return;
        XCTAssertTrue(WindowRotationFarm::IsValid(aFixture->mPack));
        std::uint32_t aJobs[kJobCount][8U];
        ExtractJobs(aFixture->mPack, aJobs);
        std::set<std::uint32_t> aWindows, aBytes, aBlocked{0U, 8192U};
        for (std::size_t aJob = 0U; aJob < kJobCount; ++aJob) {
            const bool aFree = aJob % 9U == 0U;
            XCTAssertTrue(UniqueSubsetSums(aJobs[aJob], false), @"seed %u job %zu", aSeed, aJob);
            for (std::size_t aIndex = 0U; aIndex < 8U; ++aIndex) {
                const auto aValue = aJobs[aJob][aIndex];
                const auto aWindow = aValue;
                const auto aByte = 64U * aValue;
                XCTAssertGreaterThan(aWindow, 0U);
                XCTAssertLessThan(aWindow, 16384U);
                XCTAssertFalse(aBlocked.contains(aWindow));
                XCTAssertTrue(aWindows.insert(aWindow).second);
                XCTAssertTrue(aBytes.insert(aByte).second);
                aBlocked.insert(aWindow);
                aBlocked.insert((16384U - aWindow) % 16384U);
                if (aFree) {
                    aBlocked.insert(16383U - aWindow);
                }
            }
            const auto &aStatistics = aFixture->mStatistics[aJob];
            XCTAssertGreaterThanOrEqual(aStatistics.mBaseReadCount, std::size_t{8U});
            XCTAssertLessThanOrEqual(aStatistics.mBaseReadCount, std::size_t{16384U});
            XCTAssertGreaterThanOrEqual(aStatistics.mShuffleBytesRead, std::size_t{32766U});
            XCTAssertLessThanOrEqual(aStatistics.mEntropyBytesRead, sizeof(aFixture->mEntropy[aJob]));
        }
        XCTAssertEqual(aWindows.size(), std::size_t{144U});
        for (const auto aWindow : aWindows) XCTAssertFalse(aWindows.contains(16384U - aWindow));
        for (const auto aByte : aBytes) XCTAssertFalse(aBytes.contains(1048576U - aByte));
        for (std::size_t aWindow = 0U; aWindow < 16384U; ++aWindow)
            XCTAssertEqual(aFixture->mBuffers.mWindowRotationSingleBlocked[aWindow], aBlocked.contains(aWindow));
        std::set<std::uint16_t> aPermutation(std::begin(aFixture->mBuffers.mWindowRotationBase),
                                             std::end(aFixture->mBuffers.mWindowRotationBase));
        XCTAssertEqual(aPermutation.size(), std::size_t{16384U});
        XCTAssertEqual(*aPermutation.begin(), 0U);
        XCTAssertEqual(*aPermutation.rbegin(), 16383U);
    }
}

- (void)testReplayAndEveryJobUsesItsOwnEntropySlice {
    auto aFixture = std::make_unique<Fixture>();
    aFixture->Prepare(223U);
    XCTAssertTrue(aFixture->Farm());
    const auto aOriginal = aFixture->mPack;
    std::uint32_t aOriginalJobs[kJobCount][8U];
    ExtractJobs(aOriginal, aOriginalJobs);
    XCTAssertTrue(aFixture->Farm());
    XCTAssertEqual(std::memcmp(&aOriginal, &aFixture->mPack, sizeof(aOriginal)), 0);
    for (std::size_t aChangedJob = 0U; aChangedJob < kJobCount; ++aChangedJob) {
        aFixture->Prepare(223U);
        aFixture->Fill(aChangedJob, 80000U + aChangedJob);
        XCTAssertTrue(aFixture->Farm());
        std::uint32_t aChangedJobs[kJobCount][8U];
        ExtractJobs(aFixture->mPack, aChangedJobs);
        for (std::size_t aEarlier = 0U; aEarlier < aChangedJob; ++aEarlier)
            XCTAssertEqual(std::memcmp(aOriginalJobs[aEarlier], aChangedJobs[aEarlier], sizeof(aOriginalJobs[aEarlier])), 0);
        XCTAssertNotEqual(std::memcmp(aOriginalJobs[aChangedJob], aChangedJobs[aChangedJob], sizeof(aOriginalJobs[aChangedJob])), 0);
    }
}

- (void)testCombinationBlocksResetBetweenJobsButSinglesPersist {
    Buffers aBuffers{};
    std::uint8_t aEntropy[32766U] = {}; // Identity Fisher-Yates permutation.
    const Source aSource{aEntropy, sizeof(aEntropy)};
    std::int32_t aValues[8U];
    Statistics aStatistics{};
    XCTAssertTrue(FarmEight(aSource, false, aBuffers, aValues, aStatistics));
    for (unsigned aIndex = 0U; aIndex < 8U; ++aIndex) XCTAssertEqual(aValues[aIndex], 1 << aIndex);
    XCTAssertTrue(aBuffers.mWindowRotationBlocked[3U]); // 1+2 is a local combination.
    XCTAssertFalse(aBuffers.mWindowRotationSingleBlocked[3U]);
    XCTAssertTrue(FarmEight(aSource, false, aBuffers, aValues, aStatistics));
    XCTAssertEqual(aValues[0U], 3); // Allowed in another job.
    XCTAssertTrue(aBuffers.mWindowRotationSingleBlocked[1U]);
    XCTAssertTrue(aBuffers.mWindowRotationSingleBlocked[16383U]);
}

- (void)testActualByteCollisionIsRejectedDespiteDistinctWindowSums {
    // Force the shuffle to begin 1,2,4,8,...; all later swaps are identities.
    // Free bytes 64*1+63 and 64*2+63 sum to 64*4+62. The window sums alone
    // would accept window 4, so the independent byte-ring check must skip it.
    std::uint8_t aEntropy[32766U + 16U] = {};
    std::uint16_t aList[16384U];
    for (unsigned aIndex = 0U; aIndex < 16384U; ++aIndex) aList[aIndex] = aIndex;
    for (unsigned aIndex = 0U; aIndex < 9U; ++aIndex) {
        const auto aWanted = static_cast<std::uint16_t>(1U << aIndex);
        auto aPosition = aIndex;
        while (aList[aPosition] != aWanted) ++aPosition;
        const auto aChoice = aPosition - aIndex;
        aEntropy[2U * aIndex] = static_cast<std::uint8_t>(aChoice);
        aEntropy[2U * aIndex + 1U] = static_cast<std::uint8_t>(aChoice >> 8U);
        std::swap(aList[aIndex], aList[aPosition]);
    }
    const std::uint8_t aOffsets[] = {63U, 63U, 62U, 1U, 1U, 1U, 1U, 1U};
    for (unsigned aIndex = 0U; aIndex < 8U; ++aIndex) aEntropy[32766U + 2U * aIndex] = aOffsets[aIndex];
    Buffers aBuffers{};
    std::int32_t aValues[8U];
    Statistics aStatistics{};
    XCTAssertTrue(FarmEight({aEntropy, sizeof(aEntropy)}, true, aBuffers, aValues, aStatistics));
    XCTAssertEqual(aValues[0U], 127);
    XCTAssertEqual(aValues[1U], 191);
    XCTAssertEqual(aBuffers.mWindowRotation[2U], 8U);
    std::uint32_t aUnsigned[8U];
    std::copy_n(aValues, 8U, aUnsigned);
    XCTAssertTrue(UniqueSubsetSums(aUnsigned, true));
}

- (void)testFailureClearsPartialOutputAndDoesNotCommitSingleBlocks {
    auto aFixture = std::make_unique<Fixture>();
    aFixture->Prepare(19U);
    XCTAssertTrue(aFixture->Farm());
    aFixture->mSources[17U].mByteCount = 1U; // Fail only at the last job.
    XCTAssertFalse(aFixture->Farm());
    const WindowRotationPack aEmpty{};
    XCTAssertEqual(std::memcmp(&aEmpty, &aFixture->mPack, sizeof(aEmpty)), 0);
    for (auto aBlocked : aFixture->mBuffers.mWindowRotationSingleBlocked) XCTAssertFalse(aBlocked);
    for (const auto &aStatistics : aFixture->mStatistics) XCTAssertEqual(aStatistics.mBaseReadCount, 0U);

    Buffers aBuffers{};
    std::fill_n(aBuffers.mWindowRotationSingleBlocked, 16384U, true);
    std::uint8_t aEntropy[32766U] = {};
    std::int32_t aValues[8U];
    Statistics aStatistics{};
    XCTAssertFalse(FarmEight({aEntropy, sizeof(aEntropy)}, false, aBuffers, aValues, aStatistics));
    XCTAssertEqual(aStatistics.mBaseReadCount, std::size_t{16384U});
    for (auto aBlocked : aBuffers.mWindowRotationSingleBlocked) XCTAssertTrue(aBlocked);
    for (auto aValue : aValues) XCTAssertEqual(aValue, 0);
    aBuffers = {};
    aBuffers.mWindowRotationSingleBlocked[123U] = true;
    // Enough entropy to shuffle, none left for a nonzero byte offset.
    XCTAssertFalse(FarmEight({aEntropy, sizeof(aEntropy)}, true, aBuffers, aValues, aStatistics));
    XCTAssertTrue(aBuffers.mWindowRotationSingleBlocked[123U]);
    XCTAssertFalse(aBuffers.mWindowRotationSingleBlocked[0U]);
    XCTAssertFalse(FarmEight({nullptr, 0U}, false, aBuffers, aValues, aStatistics));
    std::fill(std::begin(aEntropy), std::end(aEntropy), 255U);
    XCTAssertFalse(FarmEight({aEntropy, sizeof(aEntropy)}, false, aBuffers, aValues, aStatistics));
    for (auto aValue : aBuffers.mWindowRotation) XCTAssertEqual(aValue, 0U);
}
@end
