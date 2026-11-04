#import <XCTest/XCTest.h>
#include "Soccer3.hpp"
#include <algorithm>
#include <limits>

namespace {
struct Cleanup { ~Cleanup() { Soccer3::Zero(); } };
void PoisonPlane() {
    Soccer3::mBitPlaneWordA = 111U;
    Soccer3::mBitPlaneWordB = 222U;
    Soccer3::mBitPlaneWordC = 333U;
    Soccer3::mBitPlane = BitPlaneFarm::mBitPlanes[7U];
}
}

@interface BitPlaneSeedTests : XCTestCase
@end
@implementation BitPlaneSeedTests
- (void)testEveryUnitFeedsEachBitPlaneWordAndWraps {
    Cleanup aCleanup;
    Soccer3::Zero();
    Soccer3::InitializeMaterials(); Soccer3::InitializeWorkSpaces();
    Soccer3::InitializeExpanders(); Soccer3::InitializeRotationWindows();
    Soccer3::mStrength = EncryptionStrength::kStrong;
    using Layout = RandomShuffleLayout;
    std::uint64_t *aWords[] = {&Soccer3::mBitPlaneWordA, &Soccer3::mBitPlaneWordB, &Soccer3::mBitPlaneWordC};
    const BitPlane aEmpty{};
    for (std::size_t aUnit = 0U; aUnit < Layout::kUnitCount; ++aUnit) {
        for (std::size_t aFamily = 0U; aFamily < 3U; ++aFamily) {
            std::fill(std::begin(Soccer3::mRandom), std::end(Soccer3::mRandom), 0xA5U);
            for (std::size_t aClear = 0U; aClear < Layout::kUnitCount; ++aClear)
                std::fill_n(Soccer3::mRandom + Layout::BitPlaneWordOffset(aClear, 0U), Layout::kBitPlaneBytes, 0U);
            const std::uint64_t aValue = 0xFEDCBA9876543210ULL + aUnit;
            for (unsigned aByte = 0U; aByte < 8U; ++aByte)
                Soccer3::mRandom[Layout::BitPlaneWordOffset(aUnit, aFamily) + aByte] = static_cast<std::uint8_t>(aValue >> (8U*aByte));
            std::uint64_t aExpected[] = {7U,11U,13U};
            for (unsigned aWord=0U;aWord<3U;++aWord) *aWords[aWord]=aExpected[aWord];
            for (unsigned aPass=0U;aPass<2U;++aPass) {
                aExpected[aFamily] += aValue;
                Soccer3::Shuffle_CROWSCIMASSORMATEX();
                for (unsigned aWord=0U;aWord<3U;++aWord) XCTAssertEqual(*aWords[aWord],aExpected[aWord]);
                XCTAssertTrue(Soccer3::mBitPlane == aEmpty);
            }
        }
    }
}

- (void)testAll38ShuffleCallsAccumulateBeforeSelection {
    Cleanup aCleanup;
    Soccer3::Zero();
    Soccer3::InitializeMaterials(); Soccer3::InitializeWorkSpaces();
    Soccer3::InitializeExpanders(); Soccer3::InitializeRotationWindows();
    Soccer3::mStrength = EncryptionStrength::kNormal;
    using Layout = RandomShuffleLayout;
    std::uint64_t aExpected[3]{};
    for (std::size_t aGeneration=0U;aGeneration<Layout::kGenerationCount;++aGeneration) {
        for (std::size_t aUnit=0U;aUnit<Layout::kUnitCount;++aUnit) {
            for (std::size_t aFamily=0U;aFamily<3U;++aFamily) {
                const auto aWord=(std::uint64_t{aGeneration+1U}<<40U)+3U*aUnit+aFamily;
                aExpected[aFamily]+=aWord;
                for (unsigned aByte=0U;aByte<8U;++aByte)
                    Soccer3::mRandom[Layout::BitPlaneWordOffset(aUnit,aFamily)+aByte]=static_cast<std::uint8_t>(aWord>>(8U*aByte));
            }
        }
        Soccer3::Shuffle_CROWSCIMASSORMATEX();
    }
    XCTAssertEqual(Soccer3::mBitPlaneWordA,aExpected[0]);
    XCTAssertEqual(Soccer3::mBitPlaneWordB,aExpected[1]);
    XCTAssertEqual(Soccer3::mBitPlaneWordC,aExpected[2]);
    BitPlane aPlane{};
    BitPlaneFarm::Select(aExpected[0],aExpected[1],aExpected[2],&aPlane);
    Soccer3::SelectBitPlane();
    XCTAssertTrue(Soccer3::mBitPlane == aPlane);
    XCTAssertFalse(Soccer3::mEncryptionReady);
}

- (void)testZeroAndBothSeedEntryPointsClearWordsAndPlane {
    Cleanup aCleanup;
    const BitPlane aEmpty{};
    const auto aCheck = [&] {
        XCTAssertEqual(Soccer3::mBitPlaneWordA, std::uint64_t{0U});
        XCTAssertEqual(Soccer3::mBitPlaneWordB, std::uint64_t{0U});
        XCTAssertEqual(Soccer3::mBitPlaneWordC, std::uint64_t{0U});
        XCTAssertTrue(Soccer3::mBitPlane == aEmpty);
    };
    PoisonPlane();
    Soccer3::Zero();
    aCheck();
    std::uint8_t aPassword[] = {1U, 7U, 19U};
    std::uint32_t aAcknowledgement = 0U;
    PoisonPlane();
    XCTAssertTrue(Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kTest, aPassword, sizeof(aPassword),
                                             91U, &aAcknowledgement, 0U, nullptr));
    aCheck();
    PoisonPlane();
    XCTAssertTrue(Soccer3::AttemptSeed_Decrypt(EncryptionStrength::kTest, aPassword, sizeof(aPassword),
                                             91U, aAcknowledgement, 0U, nullptr));
    aCheck();
}
@end
