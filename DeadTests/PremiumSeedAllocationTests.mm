// Retired with FlameToad: historical Cryptex / premium-seed plumbing. Source retained.
#if 0
// Run serially: Soccer owns shared seed/plan state.
#import <XCTest/XCTest.h>
#include "SeedMaterialTestSupport.hpp"
#include <algorithm>
#include <array>
#include <cstdint>
#include <random>
#include <vector>

namespace {
using namespace SeedMaterialTestSupport;
struct ClearSoccerOnExit {
    bool mSavedLegacy=Soccer2::mUseLegacyCryptex;
    ClearSoccerOnExit(){Soccer2::mUseLegacyCryptex=true;}
    decltype(Soccer2::mBitPlaneSelectionValues) mPlanes=Soccer2::mBitPlaneSelectionValues;
    ~ClearSoccerOnExit(){Soccer2::mBitPlaneSelectionValues=mPlanes;Soccer2::Zero();Soccer2::mUseLegacyCryptex=mSavedLegacy;}
};
constexpr EncryptionStrength kStrengths[]={EncryptionStrength::kWeak,EncryptionStrength::kNormal,EncryptionStrength::kStrong};
constexpr std::uint64_t kWindows[]={16384,8192,4096};
unsigned Count(unsigned stage,unsigned bank){return bank==(stage%3+stage/3)%3?2U:3U;}
std::size_t MaterialCount(EncryptionStrength s){return s==EncryptionStrength::kWeak?4U:s==EncryptionStrength::kStrong?16U:8U;}
const Soccer2::SamplingInput& Input(unsigned stage,unsigned bank) {
    const Soccer2::SamplingInput* banks[]={Soccer2::mPlanetInputs,Soccer2::mMoonInputs,Soccer2::mStarInputs};return banks[bank][stage];
}
std::int32_t& ByteRotation(unsigned stage,unsigned slot=0) {
    std::int32_t* values[]={Soccer2::mRotationsByteL3,Soccer2::mRotationsByteL2,Soccer2::mRotationsByteL1};return values[stage%3][slot*3+stage/3];
}
void PrepareEpilogue(EncryptionStrength strength,std::uint64_t planWord=0) {
    Soccer2::Zero();Soccer2::mStrength=strength;Soccer2::InitializeMaterials();Soccer2::InitializeCiphers();Prepare();
    SetChoice(Layout::kPlanSelectionIndex,planWord);
    for(std::size_t i=0;i<Soccer2::kPremiumSeedWordCount;++i)Soccer2::mPremiumSeed[i]=0x9E3779B97F4A7C15ULL*(i+1)^0xD1B54A32D192ED03ULL;
    for(std::size_t lane=0;lane<MaterialCount(strength);++lane)for(std::size_t i=0;i<SOCCER_BLOCK_SIZE;++i)
        Soccer2::mMaterials[lane][i]=static_cast<std::uint8_t>((i*29U+lane*31U)^(i>>10U));
}
enum class Kind{GridShuffle,GridCompletion,Rows,Offset};
struct Parameter{unsigned stage,bank,slot;Kind kind;};
std::vector<Parameter> Parameters(EncryptionStrength) {
    std::vector<Parameter> result;
    for(unsigned group=0;group<3;++group) {
        result.push_back({group*3,0,0,Kind::GridShuffle});result.push_back({group*3,0,1,Kind::GridShuffle});
        result.push_back({group*3,0,2,Kind::GridCompletion});
        for(unsigned level=0;level<3;++level)for(unsigned bank=0;bank<3;++bank) {
            result.push_back({group*3+level,bank,0,Kind::Rows});result.push_back({group*3+level,bank,1,Kind::Rows});
        }
    }
    return result;
}
struct Snapshot {
    BitPlaneFarm::Bank bitPlanes{};
    std::uint64_t plan{};
    std::array<std::int32_t,9> bytes{};
    std::array<std::array<std::int32_t,1>,9> extraBytes{};
    std::array<std::array<std::array<std::uint8_t,8>,3>,9> rows{};
    std::array<std::array<std::array<std::int32_t,3>,3>,9> offsets{};
    std::array<std::uint8_t,SoccerMaskBank::mMaskGridWidth> masks{};
    std::vector<const std::uint8_t*> materialOrder;
    std::vector<std::uint8_t> materialEdges;
    bool operator==(const Snapshot&)const=default;
};
Snapshot Capture() {
    Soccer2::SeedEpilogue_Regular_C();Snapshot s;s.bitPlanes=Soccer2::mBitPlanes;s.plan=Soccer2::mPlanSelectionValue;
    for(unsigned stage=0;stage<9;++stage) {
        s.bytes[stage]=ByteRotation(stage);s.extraBytes[stage][0]=ByteRotation(stage,1);
        for(unsigned bank=0;bank<3;++bank) {
            const auto &input=Input(stage,bank);std::copy_n(input.mRows,input.mCount,s.rows[stage][bank].begin());
            std::copy_n(input.mRotations,input.mCount,s.offsets[stage][bank].begin());
        }
    }
    std::copy_n(Soccer2::mMasks,s.masks.size(),s.masks.begin());
    for(unsigned lane=0;lane<MaterialCount(Soccer2::mStrength);++lane) {
        const auto *bytes=Soccer2::mMaterials[lane];s.materialOrder.push_back(bytes);
        s.materialEdges.insert(s.materialEdges.end(),bytes,bytes+32);
        s.materialEdges.insert(s.materialEdges.end(),bytes+SOCCER_BLOCK_SIZE-32,bytes+SOCCER_BLOCK_SIZE);
    }
    return s;
}
}
@interface PremiumSeedAllocationTests : XCTestCase
@end
@implementation PremiumSeedAllocationTests
- (void)testEveryPremiumWordControlsOnlyItsRowFamilyOrOrder {
    ClearSoccerOnExit aCleanup;
    for(auto aStrength:kStrengths) {
        const auto aParameters=Parameters(aStrength);XCTAssertEqual(aParameters.size(),std::size_t{63});
        PrepareEpilogue(aStrength);const auto aBaseline=Capture();
        for(unsigned i=0;i<63;++i) {
            bool aChanged=false;
            for(unsigned aTry=0;aTry<32 && !aChanged;++aTry) {
                PrepareEpilogue(aStrength);Soccer2::mPremiumSeed[i]^=(1ULL<<63U)+aTry;
                const auto aNext=Capture();auto aExpected=aBaseline;aExpected.rows=aNext.rows;
                XCTAssertTrue(aNext==aExpected,@"Premium word %u affected something besides rows",i);
                const auto p=aParameters[i];
                for(unsigned stage=0;stage<9;++stage)for(unsigned bank=0;bank<3;++bank) {
                    const bool grid=p.kind!=Kind::Rows && stage/3==p.stage/3;
                    const bool order=p.kind==Kind::Rows && stage==p.stage && bank==p.bank;
                    if(!grid&&!order)XCTAssertTrue(aNext.rows[stage][bank]==aBaseline.rows[stage][bank]);
                }
                aChanged=aNext.rows!=aBaseline.rows;
            }
            XCTAssertTrue(aChanged,@"Unused premium row word %u",i);
        }
    }
}
- (void)testRowCoverageAndDistinctRotationsAcrossSeedsAndStrengths {
    ClearSoccerOnExit aCleanup;std::mt19937_64 aRandom(0xAABBCDD);
    for(auto aStrength:kStrengths)for(unsigned aTrial=0;aTrial<12;++aTrial) {
        PrepareEpilogue(aStrength);for(auto &aWord:Soccer2::mPremiumSeed)aWord=aRandom();Prepare(aRandom());const auto s=Capture();
        std::vector<unsigned> aChosen;
        for(unsigned group=0;group<3;++group) {
            unsigned family[3]={};
            for(unsigned level=0;level<3;++level) {
                unsigned aMask=0;const auto stage=group*3+level;
                for(unsigned bank=0;bank<3;++bank)for(unsigned i=0;i<Count(stage,bank);++i) {
                    const auto row=s.rows[stage][bank][i];XCTAssertLessThan(row,8U);
                    XCTAssertEqual(aMask&(1U<<row),0U);XCTAssertEqual(family[bank]&(1U<<row),0U);
                    aMask|=1U<<row;family[bank]|=1U<<row;
                    const auto value=static_cast<unsigned>(s.offsets[stage][bank][i]);
                    XCTAssertGreaterThan(value%4096U,0U);XCTAssertLessThan(value,kWindows[level]);aChosen.push_back(value);
                }
                XCTAssertEqual(aMask,255U);
                for(unsigned slot=0;slot<2;++slot) {
                    const auto value=Soccer2::GetByteRotationForStage(stage,slot);
                    XCTAssertGreaterThan(value%64,0);XCTAssertLessThan(value,kWindows[level]*64U);aChosen.push_back(value/64U);
                }
            }
            for(auto mask:family)XCTAssertEqual(mask,255U);
        }
        XCTAssertEqual(aChosen.size(),std::size_t{90});
        for(unsigned i=0;i<aChosen.size();++i)for(unsigned j=0;j<i;++j) {
            XCTAssertNotEqual(aChosen[i]%4096U,aChosen[j]%4096U);
            XCTAssertNotEqual((aChosen[i]+aChosen[j])%4096U,0U);
            XCTAssertNotEqual((aChosen[i]+aChosen[j]+1U)%4096U,0U);
        }
    }
}
- (void)testFoldSourceSlotsAreNeverUsedAsDirectEpilogueInputs {
    ClearSoccerOnExit aCleanup;PrepareEpilogue(EncryptionStrength::kStrong);const auto aBaseline=Capture();
    PrepareEpilogue(EncryptionStrength::kStrong);
    for(auto aPhysical:FoldWords())Store(aPhysical,Read(aPhysical)^~0ULL);
    XCTAssertTrue(Capture()==aBaseline);
}
- (void)testDirectChoicesAffectOnlyTheirAssignedTargets {
    ClearSoccerOnExit aCleanup;
    for(unsigned aIndex:{4542U,4543U,4544U,4879U,4880U,4887U,4888U,5167U}) {
        PrepareEpilogue(EncryptionStrength::kStrong);const auto aBaseline=Capture();bool aChanged=false;
        for(unsigned aTry=0;aTry<32 && !aChanged;++aTry) {
            PrepareEpilogue(EncryptionStrength::kStrong);SetChoice(aIndex,std::uint64_t{aTry}<<32U|aTry+1U);
            const auto aNext=Capture();auto aExpected=aBaseline;
            if(aIndex==4542)aExpected.plan=aNext.plan;
            else if(aIndex==4543 || aIndex>=4888)aExpected.masks=aNext.masks;
            else {aExpected.materialOrder=aNext.materialOrder;aExpected.materialEdges=aNext.materialEdges;}
            XCTAssertTrue(aNext==aExpected);aChanged=aNext!=aBaseline;
        }
        XCTAssertTrue(aChanged,@"Direct word %u had no effect",aIndex);
    }
}
- (void)testFixedBitPlaneSelectionValuesAreConfigurableAndIsolated {
    ClearSoccerOnExit aCleanup;
    const auto aOriginal = Soccer2::mBitPlaneSelectionValues;
    for (auto aStrength : kStrengths) {
        PrepareEpilogue(aStrength);
        const auto aBaseline = Capture();
        for (std::size_t aIndex = 0U; aIndex < aOriginal.size(); ++aIndex) {
            bool aChanged = false;
            for (unsigned aBit : {8U,24U,40U,56U}) {
                Soccer2::mBitPlaneSelectionValues = aOriginal;
                Soccer2::mBitPlaneSelectionValues[aIndex] ^= std::uint64_t{1} << aBit;
                PrepareEpilogue(aStrength);
                const auto aNext = Capture();
                auto aExpected = aBaseline;
                aExpected.bitPlanes = aNext.bitPlanes;
                XCTAssertTrue(aNext == aExpected, @"Bit-plane word %zu affected an unrelated input", aIndex);
                aChanged |= aNext.bitPlanes != aBaseline.bitPlanes;
            }
            XCTAssertTrue(aChanged, @"Bit-plane word %zu did not affect the new bank", aIndex);
            Soccer2::mBitPlaneSelectionValues = aOriginal;
        }
    }
}
- (void)testBitPlaneBankRegeneratesAndZeroClearsIt {
    ClearSoccerOnExit aCleanup;
    BitPlaneFarm::Bank aExpected{};
    for (auto aStrength : kStrengths) {
        PrepareEpilogue(aStrength);
        const auto aFirst = Capture().bitPlanes;
        if (aStrength == EncryptionStrength::kWeak) { aExpected = aFirst; }
        XCTAssertTrue(aFirst == aExpected); // Fixed selector values at every strength.
        Soccer2::mBitPlanes = {};
        Soccer2::SeedEpilogue_Regular_C();
        XCTAssertTrue(Soccer2::mBitPlanes == aFirst);
        Soccer2::Zero();
        const BitPlaneFarm::Bank aEmpty{};
        XCTAssertTrue(Soccer2::mBitPlanes == aEmpty);
    }
}
- (void)testOnlyFirstByteRotationSlotsAffectIndependentBlockPlans {
    ClearSoccerOnExit cleanup;
    std::vector<std::uint8_t> plain(SOCCER_BLOCK_SIZE),encrypted(plain.size()),recovered(plain.size()),repeat(plain.size());
    std::mt19937_64 random(0xF20A70ADULL);for(auto& value:plain)value=static_cast<std::uint8_t>(random());
    for(auto strength:kStrengths) {
        std::vector<std::uint8_t> baseline;
        for(unsigned trial=0;trial<=Soccer2::kByteRotationCount;++trial) {
            PrepareEpilogue(strength,0x0123456789ABCDEFULL);Soccer2::SeedEpilogue_Regular_C();
            if(trial) {
                const unsigned stage=(trial-1)/Soccer2::kRotationsPerLayer,slot=(trial-1)%Soccer2::kRotationsPerLayer;
                auto& value=ByteRotation(stage,slot);
                value+=value%64U==63U?-1:1;
            }
            if(!Soccer2::SeedEpilogue_Regular_D() || !Soccer2::EncryptBlock(plain.data(),encrypted.data()) ||
               !Soccer2::DecryptBlock(encrypted.data(),recovered.data())) {XCTFail(@"Plan/round-trip failure");return;}
            XCTAssertTrue(recovered==plain);
            if(!trial) {
                baseline=encrypted;XCTAssertTrue(Soccer2::EncryptBlock(plain.data(),repeat.data()));XCTAssertTrue(repeat==baseline);
            } else {
                const bool active=(trial-1U)%Soccer2::kRotationsPerLayer==0U;
                XCTAssertTrue((encrypted!=baseline)==active,@"Rotation %u has wrong activity at strength %u",trial,static_cast<unsigned>(strength));
            }
        }
    }
}
- (void)testOnlyActiveFrogRowListsAndOffsetsReachTheFullPlans {
    ClearSoccerOnExit cleanup;
    std::vector<std::uint8_t> plain(SOCCER_BLOCK_SIZE),encrypted(plain.size()),recovered(plain.size());
    std::mt19937_64 random(0x53414D504C4552ULL);for(auto& value:plain)value=static_cast<std::uint8_t>(random());
    for(auto strength:kStrengths) {
        std::vector<Parameter> parameters;
        for(unsigned stage=0;stage<9;++stage)for(unsigned bank=0;bank<6;++bank) {
            parameters.push_back({stage,bank,0,Kind::Rows});
            const unsigned count=bank%3==stage%3?2U:3U;
            for(unsigned slot=0;slot<count;++slot)parameters.push_back({stage,bank,slot,Kind::Offset});
        }
        // Farming retains all 54 row lists and 144 offsets; only first
        // triplets are active. Reserved inputs must not affect ciphertext.
        XCTAssertEqual(parameters.size(),std::size_t{198});
        std::vector<std::uint8_t> baseline;
        for(unsigned trial=0;trial<=parameters.size();++trial) {
            PrepareEpilogue(strength,0x0123456789ABCDEFULL);Soccer2::SeedEpilogue_Regular_C();
            if(trial) {
                const auto parameter=parameters[trial-1];
                auto& input=Soccer2::mBitPlaneInputs[parameter.stage][parameter.bank/3U][parameter.bank%3U];
                if(parameter.kind==Kind::Rows) {
                    // Keep the eight-row partition valid while changing the
                    // row-to-window assignment.
                    std::swap(input.mRows[0],input.mRows[1]);
                } else {
                    auto& value=input.mRotations[parameter.slot];
                    value+=value==kWindows[parameter.stage%3]-1?-1:1;
                }
            }
            if(!Soccer2::SeedEpilogue_Regular_D() || !Soccer2::EncryptBlock(plain.data(),encrypted.data()) ||
               !Soccer2::DecryptBlock(encrypted.data(),recovered.data())) {XCTFail(@"Active Frog plan/round-trip failure");return;}
            XCTAssertTrue(recovered==plain);
            if(!trial)baseline=encrypted;
            else {
                const auto parameter=parameters[trial-1];
                const bool active=parameter.bank<3U;
                XCTAssertTrue((encrypted!=baseline)==active,@"Sampling parameter %u has wrong activity at strength %u",trial,static_cast<unsigned>(strength));
            }
        }
    }
}
- (void)testZeroClearsDerivedSamplingAndPlanValues {
    ClearSoccerOnExit aCleanup;PrepareEpilogue(EncryptionStrength::kStrong);Capture();Soccer2::Zero();
    XCTAssertEqual(Soccer2::mPlanSelectionValue,0ULL);
    for(auto word:Soccer2::mPremiumSeed)XCTAssertEqual(word,0ULL);
    for(const auto &stage:Soccer2::mBitPlaneInputs)for(const auto &pass:stage)for(const auto &input:pass) {
        XCTAssertEqual(input.mCount,std::size_t{0});
        for(auto row:input.mRows)XCTAssertEqual(row,0U);
        for(auto offset:input.mRotations)XCTAssertEqual(offset,0);
    }
    for(unsigned stage=0;stage<9;++stage) {
        for(unsigned slot=0;slot<2;++slot)XCTAssertEqual(ByteRotation(stage,slot),0);
        for(unsigned bank=0;bank<3;++bank) {
            const auto &input=Input(stage,bank);
            for(unsigned i=0;i<input.mCount;++i){XCTAssertEqual(input.mRows[i],0U);XCTAssertEqual(input.mRotations[i],0);}
        }
    }
}
@end

#endif
#import <XCTest/XCTest.h>
@interface PremiumSeedAllocationTests : XCTestCase
@end
@implementation PremiumSeedAllocationTests
- (void)testRetiredConstruction { XCTSkip(@"Historical Cryptex / premium-seed test; replaced by FlameToad vault checks."); }
@end
