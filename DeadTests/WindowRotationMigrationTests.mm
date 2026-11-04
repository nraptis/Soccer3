// Serial: exercises the production seed buffers and installed vault state.
#import <XCTest/XCTest.h>
#include "Soccer3.hpp"
#include "SeedMaterialTestSupport.hpp"
#include <algorithm>
#include <cstring>
#include <vector>

namespace {
struct Cleanup { ~Cleanup() { Soccer3::Zero(); } };
bool SamePack(const WindowRotationPack &pA, const WindowRotationPack &pB) {
    return std::memcmp(&pA, &pB, sizeof(pA)) == 0;
}
}

@interface WindowRotationMigrationTests : XCTestCase
@end
@implementation WindowRotationMigrationTests
- (void)testRotationAndCrossRangesAreIsolatedAndInactiveLanesStayUntouched {
    Cleanup aCleanup;
    for (auto aStrength : {EncryptionStrength::kWeak, EncryptionStrength::kNormal, EncryptionStrength::kStrong}) {
        Soccer3::Zero();
        
        Soccer3::InitializeCrossPermutations();
        Soccer3::mStrength = aStrength;
        const std::size_t aLaneCount = aStrength == EncryptionStrength::kWeak ? 4U :
                                      aStrength == EncryptionStrength::kNormal ? 8U : 16U;
        constexpr std::size_t kChangedJob = 7U;
        Soccer3::mRandom[RandomShuffleLayout::RotationBegin(RandomShuffleLayout::UnitBegin(kChangedJob))] = 1U;
        Soccer3::mRandom[RandomShuffleLayout::CrossBegin(RandomShuffleLayout::UnitBegin(17U), aLaneCount) + RandomShuffleLayout::CrossBytes(aLaneCount) - 1U] = 1U;
        Soccer3::Shuffle_CROWSCIMASSORMATEX();
        Soccer3::Shuffle_CROPER(4U * aLaneCount);
        for (std::size_t aJob = 0U; aJob < WindowRotationFarm::kJobCount; ++aJob) {
            XCTAssertEqual(Soccer3::mWindowRotationBase[aJob][0U], aJob == kChangedJob ? 1U : 0U);
            XCTAssertEqual(Soccer3::mWindowRotationBase[aJob][1U], aJob == kChangedJob ? 0U : 1U);
        }
        for (std::size_t aLane = 0U; aLane < 16U; ++aLane) {
            XCTAssertEqual(Soccer3::mCrossPermutations[aLane][0U], aLane == RandomShuffleLayout::CrossLane(0U,17U,aLaneCount) ? 1U : 0U);
            for (std::size_t aIndex = 2U; aIndex < 64U; ++aIndex)
                XCTAssertEqual(Soccer3::mCrossPermutations[aLane][aIndex], aIndex);
        }
        XCTAssertEqual(Soccer3::mMaterials[0U], &Soccer3::mMaterialA[0U]);
        XCTAssertEqual(Soccer3::mExpanders[0U], &Soccer3::mAldebaran);
    }
}

- (void)testEqualUnitsPartitionAlmostAllRandomAndFavorLongShuffles {
    using Layout = RandomShuffleLayout;
    for (const std::size_t aLaneCount : {4U,8U,16U}) {
        std::vector<bool> aClaimed(Layout::kRandomBytes,false);
        const auto aClaim = [&](std::size_t pBegin,std::size_t pBytes) {
            XCTAssertLessThanOrEqual(pBegin+pBytes,Layout::kRandomBytes);
            for (auto aByte=pBegin;aByte<pBegin+pBytes;++aByte) {
                XCTAssertFalse(aClaimed[aByte]);aClaimed[aByte]=true;
            }
        };
        for (std::size_t aUnit=0U;aUnit<Layout::kUnitCount;++aUnit) {
            const auto aOffset=Layout::UnitBegin(aUnit);
            aClaim(Layout::FreeRotationWordOffset(aUnit,0U),Layout::kFreeRotationBytes);
            aClaim(Layout::BitPlaneWordOffset(aUnit,0U),Layout::kBitPlaneBytes);
            aClaim(Layout::RotationBegin(aOffset),Layout::RotationBytesPerList(aLaneCount));
            aClaim(Layout::MaterialsBegin(aOffset,aLaneCount),Layout::OrderingBytes(aLaneCount));
            aClaim(Layout::SourcesBegin(aOffset,aLaneCount),Layout::OrderingBytes(aLaneCount));
            aClaim(Layout::WorkSpacesBegin(aOffset,aLaneCount),Layout::OrderingBytes(aLaneCount));
            aClaim(Layout::ExpandersBegin(aOffset,aLaneCount),Layout::kExpandersBytes);
            aClaim(Layout::CrossBegin(aOffset,aLaneCount),Layout::CrossBytes(aLaneCount));
            XCTAssertEqual(Layout::CrossBegin(aOffset,aLaneCount)+Layout::CrossBytes(aLaneCount),aOffset+Layout::kUnitBytes);
        }
        XCTAssertTrue(std::all_of(aClaimed.begin(),aClaimed.begin()+Layout::kUsedBytes,[](bool pUsed){return pUsed;}));
        XCTAssertTrue(std::none_of(aClaimed.begin()+Layout::kUsedBytes,aClaimed.end(),[](bool pUsed){return pUsed;}));
        XCTAssertEqual(Layout::OrderingBytes(aLaneCount),4U*aLaneCount);
        XCTAssertGreaterThan(Layout::RotationBytesPerList(aLaneCount),Layout::kUnitBytes/2U);
        // The extra cross units are handed out evenly over generations.
        std::size_t aVisits[16]{};
        for (std::size_t aGeneration=0U;aGeneration<Layout::kGenerationCount;++aGeneration)
            for (std::size_t aUnit=0U;aUnit<Layout::kUnitCount;++aUnit)
                ++aVisits[Layout::CrossLane(aGeneration,aUnit,aLaneCount)];
        const auto aBounds=std::minmax_element(aVisits,aVisits+aLaneCount);
        XCTAssertLessThanOrEqual(*aBounds.second-*aBounds.first,1U);
    }
    XCTAssertEqual(Layout::kUsedBytes,32760U);
    XCTAssertEqual(Layout::RotationBudgetBytes(16U),790704U);
    XCTAssertEqual(Layout::RotationBudgetBytes(8U),943920U);
    XCTAssertEqual(Layout::RotationBudgetBytes(4U),1020528U);
}

@end
