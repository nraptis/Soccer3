// Retired with FlameToad: historical Cryptex / premium-seed plumbing. Source retained.
#if 0
// Run serially: Soccer's farmed inputs and cipher pools are shared state.
#import <XCTest/XCTest.h>
#include "SeedMaterialTestSupport.hpp"
#include "EncryptionPlan.hpp"
#include "LaneCombinations.hpp"
#include <algorithm>
#include <array>
#include <memory>
#include <vector>

namespace {
using namespace SeedMaterialTestSupport;
struct Cleanup{~Cleanup(){Soccer2::Zero();}};
std::array<const EncryptionPlanStage*,9> Stages(const EncryptionPlan &p) {
    return {&p.mL3A,&p.mL2A,&p.mL1A,&p.mL3B,&p.mL2B,&p.mL1B,&p.mL3C,&p.mL2C,&p.mL1C};
}
constexpr CipherType R=CipherType::kRotateMaskCipher;
constexpr CipherType A2=CipherType::kFrogTwoCipherA,A3=CipherType::kFrogThreeCipherA;
constexpr CipherType B2=CipherType::kFrogTwoCipherB,B3=CipherType::kFrogThreeCipherB;
constexpr CipherType kFirst[9][3]={
    {A2,B3,A3},{B3,A2,B3},{A3,B3,A2},
    {B2,A3,B3},{A3,B2,A3},{B3,A3,B2},
    {A2,B3,A3},{B3,A2,B3},{A3,B3,A2}};
constexpr CipherSamplingBank kBanks[2][3]={
    {CipherSamplingBank::kBitPlaneFirstA,CipherSamplingBank::kBitPlaneFirstB,CipherSamplingBank::kBitPlaneFirstC},
    {CipherSamplingBank::kBitPlaneSecondA,CipherSamplingBank::kBitPlaneSecondB,CipherSamplingBank::kBitPlaneSecondC}};
void PrepareInputs(){Soccer2::Zero();Prepare();Soccer2::InitializeCiphers();Soccer2::FarmBitPlanes();Soccer2::FarmRotationWindows();Soccer2::AssignRotationWindows();}
}
@interface FrogStackPlanTests : XCTestCase
@end
@implementation FrogStackPlanTests
- (void)testAllLaneChoicesFollowTheSameRotatingRowStructure {
    Cleanup aCleanup;PrepareInputs();
    constexpr EncryptionStrength kStrengths[]={EncryptionStrength::kWeak,EncryptionStrength::kNormal,EncryptionStrength::kStrong};
    const std::size_t aChoices[]={LaneCombinations::mWeakCount,LaneCombinations::mNormalCount,LaneCombinations::mStrongCount};
    constexpr unsigned kMutations[3][9]={{1,1,1,1,0,0,0,0,0},{1,1,1,1,0,0,1,1,1},{2,2,2,2,1,1,2,1,1}};
    constexpr unsigned kTotals[]={48,51,58},kBudgets[]={16,32,64};
    for(unsigned strength=0;strength<3;++strength)for(std::size_t choice=0;choice<aChoices[strength];++choice) {
        const auto plan=EncryptionPlanTool::MakePlan(kStrengths[strength],choice,Soccer2::mCiphersMutate,
            Soccer2::mCiphersPrimaryMovers,Soccer2::mCiphersSecondaryMovers);
        const auto stages=Stages(plan);unsigned total=0,quarters=0;
        for(unsigned stage=0;stage<9;++stage) {
            const auto &layer=*stages[stage];
            const unsigned mutations=kMutations[strength][stage];
            XCTAssertEqual(layer.mCount,4U+(stage<8U?1U:0U)+mutations);
            if(layer.mCount>12){XCTFail(@"Layer exceeds storage");return;}
            unsigned position=0;
            for(unsigned frog=0;frog<3;++frog,++position) {
                XCTAssertTrue(layer.mType[position]==kFirst[stage][frog]);
                XCTAssertTrue(layer.mSamplingBank[position]==kBanks[0][frog]);
            }
            if(mutations) {
                XCTAssertTrue(IS_MUTATE(layer.mType[position]));
                quarters+=CipherTool::CountLanes(layer.mType[position++])*(4U>>(stage%3));
            }
            XCTAssertTrue(layer.mType[position]==R);
            XCTAssertTrue(layer.mSamplingBank[position]==CipherSamplingBank::kBitPlaneFirstA);
            XCTAssertEqual(layer.mRotationIndex[position++],0U);
            if(stage<8U)XCTAssertTrue(layer.mType[position++]==CipherType::kBitRotationThreeCipher);
            if(mutations==2U) {
                XCTAssertTrue(IS_MUTATE(layer.mType[position]));
                quarters+=CipherTool::CountLanes(layer.mType[position++])*(4U>>(stage%3));
            }
            XCTAssertEqual(position,layer.mCount);
            total+=layer.mCount;
        }
        XCTAssertEqual(total,kTotals[strength]);XCTAssertLessThanOrEqual(quarters,kBudgets[strength]);
    }
}
- (void)testRowsFollowBitRotationsAndMasksCoverEachThreeLayerGroup {
    Cleanup aCleanup;PrepareInputs();
    constexpr unsigned kOffsets[]={0,3,6,0,3,6,0,3,6};
    unsigned accumulated=0,positions=0;
    for(unsigned stage=0;stage<9;++stage) {
        positions|=1U<<accumulated;
        for(unsigned pass=0;pass<2;++pass)for(unsigned group=0;group<3;++group) {
            const auto &input=Soccer2::mBitPlaneInputs[stage][pass][group];
            unsigned index=0;
            for(unsigned row=0;row<8;++row)if(Soccer2::mBitPlanes[stage%3][pass][group]&(1U<<row)) {
                XCTAssertEqual(input.mRows[index++],(row+kOffsets[stage])%8U);
            }
            XCTAssertEqual(index,input.mCount);
        }
        if(stage<8U)accumulated=(accumulated+3U)%8U;
    }
    XCTAssertEqual(positions,255U);XCTAssertEqual(accumulated,0U);
    for(unsigned group=0;group<3;++group) {
        unsigned coverage=0;
        for(unsigned level=0;level<3;++level) {
            const unsigned stage=group*3+level;
            const auto mask=Soccer2::GetBitPlaneMask(stage,CipherSamplingBank::kBitPlaneFirstA);
            // Track the selected rows back to this group's starting orientation.
            unsigned originalMask=0;
            for(unsigned bit=0;bit<8;++bit)if(mask&(1U<<bit))originalMask|=1U<<((bit+8U-kOffsets[stage])%8U);
            XCTAssertEqual(originalMask&coverage,0U);coverage|=originalMask;
        }
        XCTAssertEqual(coverage,255U);
    }
}
- (void)testActiveMaskedRotationsUseTheFirstFrogsEntireMask {
    Cleanup aCleanup;PrepareInputs();Soccer2::mMaskCursor=7U;
    std::vector<std::uint8_t> source(8192),actual(source.size()),restored(source.size());
    for(unsigned i=0;i<source.size();++i)source[i]=static_cast<std::uint8_t>(i*37U+(i>>8U));
    for(unsigned stage=0;stage<9;++stage) {
        const auto bank=CipherSamplingBank::kBitPlaneFirstA;
        const auto mask=Soccer2::GetBitPlaneMask(stage,bank);
        const auto rotation=Soccer2::GetByteRotationForStage(stage,0)%source.size();
        std::unique_ptr<Cipher> cipher(Soccer2::GenerateCipher(R,stage,bank,0));
        XCTAssertTrue(cipher!=nullptr);if(!cipher)return;
        XCTAssertTrue(cipher->SealData(source.data(),nullptr,actual.data(),source.size(),nullptr));
        // RotateMaskCipher moves selected bits right by its byte offset.
        for(unsigned i=0;i<source.size();++i) {
            const auto from=(i+source.size()-rotation)%source.size();
            const auto expected=static_cast<std::uint8_t>((source[i]&~mask)|(source[from]&mask));
            if(actual[i]!=expected){XCTFail(@"Wrong mask orientation or byte source at stage %u",stage);return;}
        }
        XCTAssertTrue(cipher->UnsealData(actual.data(),nullptr,restored.data(),source.size(),nullptr));
        XCTAssertTrue(restored==source);
    }
    XCTAssertEqual(Soccer2::mMaskCursor,std::size_t{7});
}
- (void)testBothFarmedTripletsCoverEightRowsAndAllReservedOffsetsAreUnique {
    Cleanup aCleanup;PrepareInputs();std::vector<unsigned> aWindows;
    unsigned aUsed[3]={};
    const std::uint16_t *lists[]={Soccer2::mRotationWindowListL3,Soccer2::mRotationWindowListL2,Soccer2::mRotationWindowListL1};
    for(unsigned stage=0;stage<9;++stage) {
        for(unsigned pass=0;pass<2;++pass) {
            unsigned mask=0;
            for(unsigned group=0;group<3;++group) {
                const auto bank=BitPlaneSamplingBank(pass,group);const auto *input=Soccer2::GetBitPlaneInput(stage,bank);
                XCTAssertTrue(input!=nullptr);if(!input)return;
                const auto rows=Soccer2::GetBitPlaneMask(stage,bank);
                XCTAssertEqual(mask&rows,0U);mask|=rows;
                const auto original=Soccer2::mBitPlanes[stage%3][pass][group];
                const auto shift=(stage%3)*3U;
                XCTAssertEqual(rows,static_cast<std::uint8_t>((original<<shift)|(original>>(8U-shift))));
                XCTAssertEqual(input->mCount,std::size_t{group==stage%3?2U:3U});
                for(unsigned i=0;i<input->mCount;++i) {
                    XCTAssertEqual(input->mRotations[i],lists[stage%3][aUsed[stage%3]++]);aWindows.push_back(input->mRotations[i]);
                }
            }
            XCTAssertEqual(mask,255U);
        }
        for(unsigned slot=0;slot<2;++slot)aWindows.push_back(Soccer2::GetByteRotationForStage(stage,slot)/64U);
    }
    for(auto used:aUsed)XCTAssertEqual(used,48U);
    XCTAssertEqual(aWindows.size(),std::size_t{162});
    for(unsigned i=0;i<aWindows.size();++i)for(unsigned j=0;j<i;++j) {
        XCTAssertNotEqual(aWindows[i]%4096U,aWindows[j]%4096U);
        XCTAssertNotEqual((aWindows[i]+aWindows[j])%4096U,0U);
        XCTAssertNotEqual((aWindows[i]+aWindows[j]+1U)%4096U,0U);
    }
}
- (void)testFactoryUsesOneRowFromEachFrogWithoutConsumingTheMaskBank {
    Cleanup aCleanup;PrepareInputs();Soccer2::mMaskCursor=7U;
    std::fill_n(Soccer2::mMasks,SoccerMaskBank::mMaskGridWidth,0xFFU);
    std::vector<std::uint8_t> source(127U*64U),actual(source.size()),expected(source.size()),restored(source.size());
    for(unsigned i=0;i<source.size();++i)source[i]=static_cast<std::uint8_t>(i*37U+(i>>3U));
    for(unsigned stage=0;stage<9;++stage)for(unsigned slot=0;slot<2;++slot) {
        std::uint8_t mask=0;
        for(unsigned group=0;group<3;++group)mask|=1U<<Soccer2::mBitPlaneInputs[stage][0][group].mRows[slot];
        const auto bank=BitPlaneRotationBank(slot);
        XCTAssertEqual(__builtin_popcount(mask),3);
        XCTAssertEqual(Soccer2::GetBitPlaneMask(stage,bank),mask);
        XCTAssertEqual(mask&Soccer2::GetBitPlaneMask(stage,BitPlaneRotationBank(1U-slot)),0U);
        RotateMaskCipher direct(mask,Soccer2::GetByteRotationForStage(stage,slot));
        std::unique_ptr<Cipher> factory(Soccer2::GenerateCipher(R,stage,bank,slot));
        XCTAssertTrue(factory!=nullptr);if(!factory)return;
        XCTAssertTrue(direct.SealData(source.data(),nullptr,expected.data(),source.size(),nullptr));
        XCTAssertTrue(factory->SealData(source.data(),nullptr,actual.data(),source.size(),nullptr));XCTAssertTrue(actual==expected);
        XCTAssertTrue(factory->UnsealData(actual.data(),nullptr,restored.data(),source.size(),nullptr));XCTAssertTrue(restored==source);
        for(unsigned i=0;i<source.size();++i)if((actual[i]&~mask)!=(source[i]&~mask)){XCTFail(@"Unmasked bit changed");return;}
    }
    XCTAssertEqual(Soccer2::mMaskCursor,std::size_t{7});
}
- (void)testRotationMasksRespectRowOrderAndRejectInvalidPartitions {
    Cleanup aCleanup;PrepareInputs();
    auto &inputs=Soccer2::mBitPlaneInputs[0][0];
    const std::uint8_t rows[3][3]={{7,1,0},{0,5,3},{6,2,4}};
    for(unsigned group=0;group<3;++group)std::copy_n(rows[group],inputs[group].mCount,inputs[group].mRows);
    XCTAssertEqual(Soccer2::GetBitPlaneMask(0,BitPlaneRotationBank(0)),0xC1U);
    XCTAssertEqual(Soccer2::GetBitPlaneMask(0,BitPlaneRotationBank(1)),0x26U);
    for(unsigned slot=0;slot<2;++slot) {
        XCTAssertTrue(Soccer2::GetBitPlaneInput(0,BitPlaneRotationBank(slot))==nullptr);
        std::unique_ptr<Cipher> wrongSlot(Soccer2::GenerateCipher(R,0,BitPlaneRotationBank(slot),1U-slot));
        XCTAssertTrue(wrongSlot==nullptr);
        std::unique_ptr<Cipher> wrongType(Soccer2::GenerateCipher(A2,0,BitPlaneRotationBank(slot)));
        XCTAssertTrue(wrongType==nullptr);
        XCTAssertEqual(Soccer2::GetBitPlaneMask(9,BitPlaneRotationBank(slot)),0U);
    }
    for(auto invalidRow:{7U,8U}) {
        inputs[1].mRows[0]=invalidRow; // Cross-group duplicate, then out-of-range.
        for(unsigned slot=0;slot<2;++slot) {
            XCTAssertEqual(Soccer2::GetBitPlaneMask(0,BitPlaneRotationBank(slot)),0U);
            std::unique_ptr<Cipher> invalid(Soccer2::GenerateCipher(R,0,BitPlaneRotationBank(slot),slot));
            XCTAssertTrue(invalid==nullptr);
        }
    }
}
- (void)testEveryFrogVariantUsesItsAssignedRowsAndOffsetsAndReverses {
    Cleanup aCleanup;PrepareInputs();
    std::vector<std::uint8_t> source(127U*64U),actual(source.size()),expected(source.size()),restored(source.size());
    std::mt19937 random(0xF60AB);for(auto &byte:source)byte=static_cast<std::uint8_t>(random());
    for(unsigned stage=0;stage<9;++stage)for(unsigned pass=0;pass<2;++pass)for(unsigned group=0;group<3;++group) {
        const auto bank=BitPlaneSamplingBank(pass,group);const auto &input=*Soccer2::GetBitPlaneInput(stage,bank);
        const auto *r=input.mRows;const auto *o=input.mRotations;
        const bool two=group==stage%3,variantB=((group+pass)&1U)!=0U;
        const auto type=variantB?(two?B2:B3):(two?A2:A3);std::unique_ptr<Cipher> direct;
        if(type==A2)direct=std::make_unique<FrogTwoCipherA>(r[0],o[0],r[1],o[1]);
        else if(type==B2)direct=std::make_unique<FrogTwoCipherB>(r[0],o[0],r[1],o[1]);
        else if(type==A3)direct=std::make_unique<FrogThreeCipherA>(r[0],o[0],r[1],o[1],r[2],o[2]);
        else direct=std::make_unique<FrogThreeCipherB>(r[0],o[0],r[1],o[1],r[2],o[2]);
        std::unique_ptr<Cipher> factory(Soccer2::GenerateCipher(type,stage,bank));XCTAssertTrue(factory!=nullptr);if(!factory)return;
        XCTAssertTrue(direct->SealData(source.data(),nullptr,expected.data(),source.size(),nullptr));
        XCTAssertTrue(factory->SealData(source.data(),nullptr,actual.data(),source.size(),nullptr));XCTAssertTrue(actual==expected);
        XCTAssertTrue(factory->UnsealData(actual.data(),nullptr,restored.data(),source.size(),nullptr));XCTAssertTrue(restored==source);
        std::unique_ptr<Cipher> invalid(Soccer2::GenerateCipher(input.mCount==2?A3:A2,stage,bank));XCTAssertTrue(invalid==nullptr);
    }
}
- (void)testPairedBitRotationsRotateEveryByteByThreeAndReverse {
    std::vector<std::uint8_t> source(256),middle(256),actual(256),restored(256);
    for(unsigned i=0;i<256;++i)source[i]=i;
    BitRotationCipherA a;BitRotationCipherB b;
    XCTAssertTrue(a.SealData(source.data(),nullptr,middle.data(),256,nullptr));
    XCTAssertTrue(b.SealData(middle.data(),nullptr,actual.data(),256,nullptr));
    for(unsigned i=0;i<256;++i)XCTAssertEqual(actual[i],static_cast<std::uint8_t>((i<<3U)|(i>>5U)));
    XCTAssertTrue(b.UnsealData(actual.data(),nullptr,middle.data(),256,nullptr));
    XCTAssertTrue(a.UnsealData(middle.data(),nullptr,restored.data(),256,nullptr));XCTAssertTrue(restored==source);
}
@end

#endif
#import <XCTest/XCTest.h>
@interface FrogStackPlanTests : XCTestCase
@end
@implementation FrogStackPlanTests
- (void)testRetiredConstruction { XCTSkip(@"Historical Cryptex / premium-seed test; replaced by FlameToad vault checks."); }
@end
