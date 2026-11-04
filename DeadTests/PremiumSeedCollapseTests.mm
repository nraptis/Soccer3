// Retired with FlameToad: historical Cryptex / premium-seed plumbing. Source retained.
#if 0
// Run serially: the production seed buffers are process-global.
#import <XCTest/XCTest.h>
#include "SeedMaterialTestSupport.hpp"
#include <algorithm>
#include <array>

namespace {
using namespace SeedMaterialTestSupport;
struct Cleanup {~Cleanup(){Soccer2::Zero();}};
using Seed=std::array<std::uint64_t,63>;
Seed ReadSeed(){Seed aResult;std::copy_n(Soccer2::mPremiumSeed,63,aResult.begin());return aResult;}
}
@interface PremiumSeedCollapseTests : XCTestCase
@end
@implementation PremiumSeedCollapseTests
- (void)testEverySourceWordHasExactlyOneDirectOrFoldPurpose {
    std::array<unsigned,8192> aUses{};
    for(unsigned i=0;i<5168;++i) {
        XCTAssertEqual(Layout::ShuffleWordIndex(i),DirectWords()[i]);++aUses[Layout::ShuffleWordIndex(i)];
    }
    for(unsigned i=0;i<3024;++i) {
        XCTAssertEqual(Layout::SeedWordIndex(i),FoldWords()[i]);++aUses[Layout::SeedWordIndex(i)];
    }
    for(auto aCount:aUses)XCTAssertEqual(aCount,1U);
    XCTAssertEqual(Soccer2::kPremiumSeedWordCount,std::size_t{63});
    XCTAssertEqual(Soccer2::kSeedIndexCount,std::size_t{1512});
    // All direct ranges meet exactly, with no reused or unassigned words.
    XCTAssertEqual(Layout::kIndexShuffleEnd,std::size_t{128});
    XCTAssertEqual(Layout::kPremiumShuffleEnd,std::size_t{192});
    XCTAssertEqual(Layout::kRotationShuffleEnd,std::size_t{4286});
    XCTAssertEqual(Layout::kRotationLiftL2Begin,std::size_t{4286});
    XCTAssertEqual(Layout::kRotationLiftL3Begin,std::size_t{4350});
    XCTAssertEqual(Layout::kRotationFreeLiftBegin,std::size_t{4414});
    XCTAssertEqual(Layout::kRotationFreeByteBegin,std::size_t{4478});
    XCTAssertEqual(Layout::kPlanSelectionIndex,std::size_t{4542});
    XCTAssertEqual(Layout::kMaskSelectionIndex,std::size_t{4543});
    XCTAssertEqual(Layout::kMaterialShuffleBegin,std::size_t{4544});
    XCTAssertEqual(Layout::kMaterialShuffleEnd,std::size_t{4880});
    XCTAssertEqual(Layout::kMaterialReverseBegin,std::size_t{4880});
    XCTAssertEqual(Layout::kMaterialReverseEnd,std::size_t{4888});
    XCTAssertEqual(Layout::kMaskShuffleBegin,std::size_t{4888});
    XCTAssertEqual(Layout::kMaskShuffleEnd,std::size_t{5168});
}
- (void)testEverySeedSourceContributesToExactlyOne48WordFold {
    Cleanup aCleanup;Soccer2::Zero();Prepare();Soccer2::SeedEpilogue_Regular_B();const auto aBaseline=ReadSeed();
    std::array<unsigned,63> aContributions{};
    for(auto aPhysical:FoldWords()) {
        Source(aPhysical)[0]^=1U;Soccer2::SeedEpilogue_Regular_B();unsigned aChanged=0;
        for(unsigned i=0;i<63;++i)if(Soccer2::mPremiumSeed[i]!=aBaseline[i]){++aChanged;++aContributions[i];}
        XCTAssertEqual(aChanged,1U);Source(aPhysical)[0]^=1U;
    }
    for(auto aCount:aContributions)XCTAssertEqual(aCount,48U);
}
- (void)testOnlyIndexAndPremiumShuffleWordsAffectTheCollapse {
    Cleanup aCleanup;Soccer2::Zero();Prepare();
    for(auto aPhysical:DirectWords())Store(aPhysical,0);
    Soccer2::SeedEpilogue_Regular_B();const auto aBaseline=ReadSeed();
    for(unsigned i=0;i<5168;++i) {
        SetChoice(i,i<128?1ULL:1ULL<<32U);Soccer2::SeedEpilogue_Regular_B();
        if(i<192)XCTAssertTrue(ReadSeed()!=aBaseline,@"Unused direct word %u",i);
        else XCTAssertTrue(ReadSeed()==aBaseline,@"Direct choice leaked into premium seed: %u",i);
        Store(DirectWords()[i],0);
    }
}
- (void)testFoldMatchesIndependentReferenceIncludingTheMiddleBoundary {
    Cleanup aCleanup;Soccer2::Zero();Prepare();Soccer2::SeedEpilogue_Regular_B();
    std::array<std::size_t,1512> aFirst{},aSecond{};
    for(unsigned i=0;i<1512;++i)aFirst[i]=aSecond[i]=i;
    for(unsigned i=0;i<128;++i) {
        auto aWord=Choice(i);auto &aIndices=i%2==0?aFirst:aSecond;
        for(unsigned j=0;j<2;++j) {
            auto a= aWord%1512U;aWord/=1512U;auto b=aWord%1512U;aWord/=1512U;std::swap(aIndices[a],aIndices[b]);
        }
    }
    Seed aExpected{};
    for(unsigned i=0;i<3024;++i) {
        const auto aIndex=i<1512?aFirst[i]:1512U+aSecond[i-1512];
        aExpected[i/48U]=TwistMix64::DiffuseA(aExpected[i/48U]^Read(FoldWords()[aIndex]));
    }
    for(unsigned i=128;i<192;++i) {
        auto aWord=Choice(i);std::swap(aExpected[static_cast<std::uint32_t>(aWord)%63],aExpected[(aWord>>32U)%63]);
    }
    XCTAssertTrue(ReadSeed()==aExpected);
    for(const auto *aSource:{Soccer2::mIndexListA,Soccer2::mIndexListB}) {
        std::array<std::uint16_t,1512> aCopy{};std::copy_n(aSource,1512,aCopy.begin());std::sort(aCopy.begin(),aCopy.end());
        for(unsigned i=0;i<1512;++i)XCTAssertEqual(aCopy[i],i);
    }
    for(auto &aWord:Soccer2::mPremiumSeed)aWord=~aWord;
    Soccer2::SeedEpilogue_Regular_B();XCTAssertTrue(ReadSeed()==aExpected);
}
@end

#endif
#import <XCTest/XCTest.h>
@interface PremiumSeedCollapseTests : XCTestCase
@end
@implementation PremiumSeedCollapseTests
- (void)testRetiredConstruction { XCTSkip(@"Historical Cryptex / premium-seed test; replaced by FlameToad vault checks."); }
@end
