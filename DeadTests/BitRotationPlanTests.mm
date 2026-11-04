// Retired with FlameToad: historical Cryptex / premium-seed plumbing. Source retained.
#if 0
// Run serially: the epilogue owns shared mask, seed, and material buffers.
#import <XCTest/XCTest.h>
#include "Soccer2.hpp"
#include "EncryptionPlan.hpp"
#include "PremiumSeedLayout.hpp"
#include "TwistMix64.hpp"
#include "SeedMaterialTestSupport.hpp"
#include <algorithm>
#include <array>

namespace {
struct Cleanup {
    bool mSavedLegacy = Soccer2::mUseLegacyCryptex;
    Cleanup() { Soccer2::mUseLegacyCryptex = true; }
    ~Cleanup() { Soccer2::Zero(); Soccer2::mUseLegacyCryptex = mSavedLegacy; }
};
using Masks = std::array<std::uint8_t, SoccerMaskBank::mMaskGridWidth>;
constexpr unsigned kExpectedRotations[] = {0,0,0,0,0,0,0,0,0,0,0,0,0};
static_assert(std::size(kExpectedRotations) == SoccerMaskBank::mMaskGridWidth);
std::uint8_t RotateReference(std::uint8_t pMask, unsigned pRotation) {
    std::uint8_t aResult = 0;
    for (unsigned aBit = 0; aBit < 8; ++aBit)
        aResult |= static_cast<std::uint8_t>(((pMask >> aBit) & 1U) << ((aBit+pRotation)%8U));
    return aResult;
}
Masks ReferenceShuffledMasks(EncryptionStrength pStrength) {
    using namespace SeedMaterialTestSupport;
    const auto aSelection=Choice(Layout::kMaskSelectionIndex);
    Masks aMasks{};
    std::copy_n(SoccerMaskBank::mMaskGrid[aSelection%SoccerMaskBank::mMaskGridHeight],aMasks.size(),aMasks.begin());
    const unsigned aReversals=pStrength==EncryptionStrength::kWeak?2U:pStrength==EncryptionStrength::kStrong?8U:4U;
    for(std::size_t i=Layout::kMaterialReverseBegin+aReversals;i<Layout::kMaskShuffleEnd;++i) {
        const auto aWord=Choice(i);
        std::swap(aMasks[static_cast<std::uint32_t>(aWord)%aMasks.size()],aMasks[(aWord>>32U)%aMasks.size()]);
    }
    return aMasks;
}
}

@interface BitRotationPlanTests : XCTestCase
@end
@implementation BitRotationPlanTests
- (void)testDerivedPlansLeaveLegacyMaskBankUnchangedAtEveryStrength {
    Cleanup aCleanup;Soccer2::Zero();Soccer2::InitializeCiphers();
    for (auto aStrength : {EncryptionStrength::kWeak,EncryptionStrength::kNormal,EncryptionStrength::kStrong}) {
        const auto aPlan=EncryptionPlanTool::MakePlan(aStrength,0,Soccer2::mCiphersMutate,
            Soccer2::mCiphersPrimaryMovers,Soccer2::mCiphersSecondaryMovers);
        for (unsigned aValue=0;aValue<256;++aValue) {
            Masks aMasks{};
            for (unsigned aIndex=0;aIndex<aMasks.size();++aIndex) aMasks[aIndex]=static_cast<std::uint8_t>(aValue+17U*aIndex);
            const auto aBefore=aMasks;
            XCTAssertTrue(EncryptionPlanTool::RotateMasksForPlan(aPlan,aMasks.data(),aMasks.size()));
            for (unsigned aIndex=0;aIndex<aMasks.size();++aIndex)
                XCTAssertEqual(aMasks[aIndex],RotateReference(aBefore[aIndex],kExpectedRotations[aIndex]));
        }
    }
}
- (void)testMaskScheduleAdaptsToDifferentCountsAndRejectsOverdraw {
    EncryptionPlan aPlan{};
    aPlan.mL3A.mCount=1;aPlan.mL3A.mType[0]=CipherType::kRotateMaskCipher;
    aPlan.mL3B.mCount=2;aPlan.mL3B.mType[0]=aPlan.mL3B.mType[1]=CipherType::kReverseMaskCipher;
    aPlan.mL2A.mCount=1;aPlan.mL2A.mType[0]=CipherType::kInvertMaskCipher;
    aPlan.mL1C.mCount=2;aPlan.mL1C.mType[0]=aPlan.mL1C.mType[1]=CipherType::kRotateMaskCipher;
    constexpr unsigned kRotations[]={0,0,0,3,6,6,0};
    std::array<std::uint8_t,7> aMasks={1,2,4,8,16,32,64};
    const auto aBefore=aMasks;
    XCTAssertFalse(EncryptionPlanTool::RotateMasksForPlan(aPlan,aMasks.data(),5));
    XCTAssertTrue(aMasks==aBefore);
    XCTAssertFalse(EncryptionPlanTool::RotateMasksForPlan(aPlan,nullptr,6));
    XCTAssertTrue(EncryptionPlanTool::RotateMasksForPlan(aPlan,aMasks.data(),aMasks.size()));
    for (unsigned aIndex=0;aIndex<aMasks.size();++aIndex)
        XCTAssertEqual(aMasks[aIndex],RotateReference(aBefore[aIndex],kRotations[aIndex]));
    const auto aRotated=aMasks;
    aPlan.mL2B.mCount=13;
    XCTAssertFalse(EncryptionPlanTool::RotateMasksForPlan(aPlan,aMasks.data(),aMasks.size()));
    XCTAssertTrue(aMasks==aRotated);
}
- (void)testEpiloguePreservesLegacyMaskBankAndDerivedPlansDoNotConsumeIt {
    Cleanup aCleanup;
    for (auto aStrength : {EncryptionStrength::kWeak,EncryptionStrength::kNormal,EncryptionStrength::kStrong}) {
        Soccer2::Zero();Soccer2::mStrength=aStrength;Soccer2::InitializeMaterials();Soccer2::InitializeCiphers();
        for (std::size_t aIndex=0;aIndex<Soccer2::kPremiumSeedWordCount;++aIndex)
            Soccer2::mPremiumSeed[aIndex]=(0x9E3779B97F4A7C15ULL*(aIndex+1U))^0xD1B54A32D192ED03ULL;
        unsigned aLaneIndex=0;
        for (auto *aLane : {Soccer2::mCondenseLaneA,Soccer2::mCondenseLaneB,Soccer2::mCondenseLaneC,Soccer2::mCondenseLaneD}) {
            for (std::size_t aByte=0;aByte<SOCCER_BLOCK_SIZE_C1;++aByte)
                aLane[aByte]=static_cast<std::uint8_t>((aByte*37U+11U+aLaneIndex*53U)^(aByte>>8U));
            ++aLaneIndex;
        }
        const auto aShuffled=ReferenceShuffledMasks(aStrength);
        unsigned aMaximumDifference=0;
        for (unsigned aIndex=0;aIndex<aShuffled.size();++aIndex) {
            for (unsigned aPrevious=0;aPrevious<aIndex;++aPrevious) {
                const auto aDifference=static_cast<unsigned>(__builtin_popcount(aShuffled[aIndex]^aShuffled[aPrevious]));
                XCTAssertGreaterThanOrEqual(aDifference,4U);
                aMaximumDifference=std::max(aMaximumDifference,aDifference);
            }
        }
        XCTAssertEqual(aMaximumDifference,8U);
        for (unsigned aRepeat=0;aRepeat<2;++aRepeat) {
            Soccer2::SeedEpilogue_Regular_C();
            for (unsigned aIndex=0;aIndex<aShuffled.size();++aIndex) {
                XCTAssertEqual(Soccer2::mMasks[aIndex],RotateReference(aShuffled[aIndex],kExpectedRotations[aIndex]));
                XCTAssertEqual(__builtin_popcount(Soccer2::mMasks[aIndex]),__builtin_popcount(aShuffled[aIndex]));
                for (unsigned aPrevious=0;aPrevious<aIndex;++aPrevious)
                    if (kExpectedRotations[aPrevious]==kExpectedRotations[aIndex])
                        XCTAssertGreaterThanOrEqual(__builtin_popcount(Soccer2::mMasks[aPrevious]^Soccer2::mMasks[aIndex]),4);
            }
        }
        // D uses derived Frog masks and leaves the legacy bank untouched.
        Masks aBefore{};std::copy_n(Soccer2::mMasks,aBefore.size(),aBefore.begin());
        XCTAssertTrue(Soccer2::SeedEpilogue_Regular_D());
        XCTAssertTrue(std::equal(aBefore.begin(),aBefore.end(),Soccer2::mMasks));
        XCTAssertEqual(Soccer2::mMaskCursor,std::size_t{0}); // No legacy mask-bank uses.
    }
}
@end

#endif
#import <XCTest/XCTest.h>
@interface BitRotationPlanTests : XCTestCase
@end
@implementation BitRotationPlanTests
- (void)testRetiredConstruction { XCTSkip(@"Historical Cryptex / premium-seed test; replaced by FlameToad vault checks."); }
@end
