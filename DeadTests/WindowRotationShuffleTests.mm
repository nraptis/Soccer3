#import <XCTest/XCTest.h>
#include "TwistShuffle.hpp"
#include <algorithm>
#include <array>
#include <cstdint>
#include <random>

namespace {
constexpr std::size_t kWindowCount = 16384U;
using WindowList = std::array<std::uint16_t, kWindowCount>;
WindowList Identity() {
    WindowList aList{};
    for (std::size_t aIndex = 0U; aIndex < kWindowCount; ++aIndex)
        aList[aIndex] = static_cast<std::uint16_t>(aIndex);
    return aList;
}
bool IsPermutation(WindowList pList) {
    std::sort(pList.begin(), pList.end());
    return pList == Identity();
}
}

@interface WindowRotationShuffleTests : XCTestCase
@end
@implementation WindowRotationShuffleTests
- (void)testOddAndEvenTraversalMirrorEachOther {
    std::array<std::uint8_t, 49152U> aEntropy;
    std::mt19937_64 aRandom(0xB1D1F15EULL);
    for (auto &aByte : aEntropy) aByte = static_cast<std::uint8_t>(aRandom());
    auto aForward = Identity();
    auto aBackward = Identity();
    std::size_t aForwardRead = 0U, aBackwardRead = 0U;
    XCTAssertTrue(TwistShuffle::ShuffleList16384(aForward.data(), aEntropy.data(), aEntropy.size(), aForwardRead, false));
    XCTAssertTrue(TwistShuffle::ShuffleList16384(aBackward.data(), aEntropy.data(), aEntropy.size(), aBackwardRead, true));
    XCTAssertEqual(aForwardRead, aBackwardRead);
    XCTAssertTrue(IsPermutation(aForward));
    XCTAssertTrue(IsPermutation(aBackward));
    for (std::size_t aIndex = 0U; aIndex < kWindowCount; ++aIndex)
        XCTAssertEqual(aBackward[aIndex], kWindowCount - 1U - aForward[kWindowCount - 1U - aIndex]);
}

- (void)testRejectionKeepsTheDestinationUntilAnInRangeWordArrives {
    // First swap is an identity. 16383 is out of range for the second
    // destination, so the following choice 1 must still act on that slot.
    const std::uint8_t aEntropy[] = {0U, 0U, 255U, 63U, 1U, 0U, 255U};
    for (const bool aOdd : {false, true}) {
        auto aList = Identity();
        auto aExpected = aList;
        if (aOdd) std::swap(aExpected[16382U], aExpected[16381U]);
        else std::swap(aExpected[1U], aExpected[2U]);
        std::size_t aRead = 0U;
        XCTAssertFalse(TwistShuffle::ShuffleList16384(aList.data(), aEntropy, sizeof(aEntropy), aRead, aOdd));
        XCTAssertEqual(aRead, std::size_t{6U}); // Last unmatched byte is untouched.
        XCTAssertTrue(aList == aExpected);
    }
}

- (void)testAlternatingPartialPassesStayBoundedAndPreserveTheList {
    struct GuardedList {
        std::uint64_t mBefore = 0x123456789ABCDEF0ULL;
        WindowList mList = Identity();
        std::uint64_t mAfter = 0xFEDCBA9876543210ULL;
    } aGuarded;
    std::mt19937_64 aRandom(8712U);
    std::uint8_t aEntropy[1820U];
    for (unsigned aPass = 0U; aPass < 38U; ++aPass) {
        for (auto &aByte : aEntropy) aByte = static_cast<std::uint8_t>(aRandom());
        std::size_t aRead = 0U;
        XCTAssertFalse(TwistShuffle::ShuffleList16384(aGuarded.mList.data(), aEntropy, sizeof(aEntropy), aRead, (aPass & 1U) != 0U));
        XCTAssertEqual(aRead, sizeof(aEntropy));
        XCTAssertTrue(IsPermutation(aGuarded.mList));
        XCTAssertEqual(aGuarded.mBefore, 0x123456789ABCDEF0ULL);
        XCTAssertEqual(aGuarded.mAfter, 0xFEDCBA9876543210ULL);
    }
}

- (void)testExhaustionNeverWrapsEntropyOrRetriesForever {
    std::uint8_t aEntropy[32U];
    std::fill(std::begin(aEntropy), std::end(aEntropy), 255U);
    for (const bool aOdd : {false, true}) {
        auto aList = Identity();
        auto aExpected = aList;
        std::swap(aExpected.front(), aExpected.back());
        std::size_t aRead = 0U;
        XCTAssertFalse(TwistShuffle::ShuffleList16384(aList.data(), aEntropy, sizeof(aEntropy), aRead, aOdd));
        XCTAssertEqual(aRead, sizeof(aEntropy));
        XCTAssertTrue(aList == aExpected);
    }
}
@end
