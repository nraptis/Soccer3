// Retired with FlameToad: historical Cryptex / premium-seed plumbing. Source retained.
#if 0
// Run serially: Soccer2's plan inputs are shared state.
#import <XCTest/XCTest.h>
#include "Soccer2.hpp"
#include "EncryptionPlan.hpp"
#include "LaneCombinations.hpp"
#include <algorithm>
#include <memory>
#include <random>
#include <vector>
namespace {
struct Cleanup { ~Cleanup() { Soccer2::Zero(); } };
constexpr unsigned kFrogCounts[]={2,3,3,3,3,2,3,2,3};
constexpr unsigned kToadCounts[]={3,2,3,2,3,3,3,3,2};
CipherType Type(bool frog,unsigned stage) {
    const unsigned count=(frog?kFrogCounts:kToadCounts)[stage];
    return frog?(count==2?CipherType::kFrogTwoCipherA:CipherType::kFrogThreeCipherA)
               :(count==2?CipherType::kToadTwoCipherA:CipherType::kToadThreeCipherA);
}
}
@interface FrogPlanTests : XCTestCase
@end
@implementation FrogPlanTests
- (void)testFrogBFactoryUsesDefaultAndExplicitSamplingBanks {
    Cleanup aCleanup; Soccer2::Zero();
    const Soccer2::SamplingInput *aBanks[] = {Soccer2::mPlanetInputs, Soccer2::mMoonInputs, Soccer2::mStarInputs};
    const CipherSamplingBank aBankTypes[] = {CipherSamplingBank::kPlanet, CipherSamplingBank::kMoon, CipherSamplingBank::kStar};
    std::vector<std::uint8_t> aSource(7U*64U),aActual(aSource.size()),aExpected(aSource.size()),aRestored(aSource.size());
    for(std::size_t i=0U;i<aSource.size();++i)aSource[i]=static_cast<std::uint8_t>(i*31U+i/8U);
    for(unsigned aBank=0U;aBank<3U;++aBank)for(std::uint8_t aStage=0U;aStage<9U;++aStage) {
        const auto &aInput=aBanks[aBank][aStage];
        for(unsigned i=0U;i<aInput.mCount;++i) {
            aInput.mRows[i]=static_cast<std::uint8_t>((i*3U+aStage+aBank)%8U);
            aInput.mRotations[i]=static_cast<std::int32_t>(1U+i*7U+aStage*3U+aBank);
        }
        const auto *r=aInput.mRows;const auto *o=aInput.mRotations;
        const auto aType=aInput.mCount==2U?CipherType::kFrogTwoCipherB:CipherType::kFrogThreeCipherB;
        std::unique_ptr<Cipher> aDirect;
        if(aInput.mCount==2U)aDirect=std::make_unique<FrogTwoCipherB>(r[0],o[0],r[1],o[1]);
        else aDirect=std::make_unique<FrogThreeCipherB>(r[0],o[0],r[1],o[1],r[2],o[2]);
        XCTAssertTrue(aDirect->SealData(aSource.data(),nullptr,aExpected.data(),aSource.size(),nullptr));
        for(auto aSelection:{aBankTypes[aBank],aBank==0U?CipherSamplingBank::kByCipherType:aBankTypes[aBank]}) {
            std::unique_ptr<Cipher> aFactory(Soccer2::GenerateCipher(aType,aStage,aSelection));
            XCTAssertTrue(aFactory!=nullptr);if(!aFactory)return;
            XCTAssertTrue(aFactory->mType==aType);
            XCTAssertTrue(aFactory->SealData(aSource.data(),nullptr,aActual.data(),aSource.size(),nullptr));
            XCTAssertTrue(aActual==aExpected);
            XCTAssertTrue(aFactory->UnsealData(aActual.data(),nullptr,aRestored.data(),aSource.size(),nullptr));
            XCTAssertTrue(aRestored==aSource);
        }
        const auto aWrongType=aInput.mCount==2U?CipherType::kFrogThreeCipherB:CipherType::kFrogTwoCipherB;
        std::unique_ptr<Cipher> aInvalid(Soccer2::GenerateCipher(aWrongType,aStage,aBankTypes[aBank]));
        XCTAssertTrue(aInvalid==nullptr);
    }
    for(auto aType:{CipherType::kFrogTwoCipherB,CipherType::kFrogThreeCipherB}) {
        std::unique_ptr<Cipher> aInvalid(Soccer2::GenerateCipher(aType,9U));
        XCTAssertTrue(aInvalid==nullptr);
    }
    XCTAssertEqual(Soccer2::mMaterialIndex,std::size_t{0});
    XCTAssertEqual(Soccer2::mMaterialQuarter,std::size_t{0});
    XCTAssertEqual(Soccer2::mMaskCursor,std::size_t{0});
}
- (void)testFactoryRoutesEachIndependentRowAndOffsetList {
    Cleanup cleanup;Soccer2::Zero();
    for(unsigned family=0;family<2;++family)for(unsigned stage=0;stage<9;++stage) {
        const auto& input=(family==0?Soccer2::mPlanetInputs:Soccer2::mMoonInputs)[stage];
        XCTAssertEqual(input.mCount,std::size_t{(family==0?kFrogCounts:kToadCounts)[stage]});
        for(unsigned i=0;i<input.mCount;++i)input.mRows[i]=(i*3+stage*2+family)%8;
        for(unsigned i=0;i<input.mCount;++i)input.mRotations[i]=1+17*stage+7*family+3*i;
    }
    std::vector<std::uint8_t> source(127*64),actual(source.size()),expected(source.size()),restored(source.size());
    std::mt19937 random(0xF206A9U);for(auto& b:source)b=static_cast<std::uint8_t>(random());
    for(bool frog : {true,false})for(unsigned stage=0;stage<9;++stage) {
        const auto& input=(frog?Soccer2::mPlanetInputs:Soccer2::mMoonInputs)[stage];
        const auto* r=input.mRows;const auto* o=input.mRotations;
        std::unique_ptr<Cipher> direct;
        if(frog && input.mCount==2)direct=std::make_unique<FrogTwoCipherA>(r[0],o[0],r[1],o[1]);
        if(frog && input.mCount==3)direct=std::make_unique<FrogThreeCipherA>(r[0],o[0],r[1],o[1],r[2],o[2]);
        if(!frog && input.mCount==2)direct=std::make_unique<ToadTwoCipherA>(r[0],o[0],r[1],o[1]);
        if(!frog && input.mCount==3)direct=std::make_unique<ToadThreeCipherA>(r[0],o[0],r[1],o[1],r[2],o[2]);
        std::unique_ptr<Cipher> factory(Soccer2::GenerateCipher(Type(frog,stage),stage));
        if(!factory) {XCTFail(@"Valid stage rejected");return;}
        XCTAssertTrue(direct->SealData(source.data(),nullptr,expected.data(),source.size(),nullptr));
        XCTAssertTrue(factory->SealData(source.data(),nullptr,actual.data(),source.size(),nullptr));
        XCTAssertTrue(actual==expected);
        XCTAssertTrue(factory->UnsealData(actual.data(),nullptr,restored.data(),source.size(),nullptr));
        XCTAssertTrue(restored==source);
    }
    XCTAssertEqual(Soccer2::mMaterialIndex,std::size_t{0});XCTAssertEqual(Soccer2::mMaskCursor,std::size_t{0});
}
- (void)testByteRotationsUseTheirStageAndSlotWithoutACursor {
    Cleanup cleanup;Soccer2::Zero();
    std::int32_t* rotations[]={Soccer2::mRotationsByteL3,Soccer2::mRotationsByteL2,Soccer2::mRotationsByteL1};
    std::vector<std::uint8_t> source(1024),actual(1024),expected(1024);
    for(unsigned i=0;i<1024;++i)source[i]=i*31U+i/256;
    for(unsigned stage=0;stage<9;++stage)for(unsigned slot=0;slot<Soccer2::kRotationsPerLayer;++slot) {
        const auto rotation=(stage*Soccer2::kRotationsPerLayer+slot)*71+1;
        rotations[stage%3][slot*3+stage/3]=rotation;
        RotateCipher direct(rotation);
        std::unique_ptr<Cipher> factory(Soccer2::GenerateCipher(CipherType::kRotateCipher,stage,
            CipherSamplingBank::kByCipherType,slot));
        XCTAssertTrue(factory!=nullptr);if(!factory)return;
        XCTAssertTrue(direct.SealData(source.data(),nullptr,expected.data(),source.size(),nullptr));
        XCTAssertTrue(factory->SealData(source.data(),nullptr,actual.data(),source.size(),nullptr));
        XCTAssertTrue(actual==expected);
    }
    for(auto type:{CipherType::kRotateCipher,CipherType::kRotateMaskCipher}) {
        std::unique_ptr<Cipher> invalid(Soccer2::GenerateCipher(type,0,CipherSamplingBank::kByCipherType,Soccer2::kRotationsPerLayer));
        XCTAssertTrue(invalid==nullptr);
    }
}
- (void)testFactoryRejectsWrongVariantsAndInvalidStages {
    Cleanup cleanup;Soccer2::Zero();
    for(bool frog : {true,false})for(unsigned stage=0;stage<9;++stage) {
        const auto right=Type(frog,stage);
        const auto wrong=frog?(right==CipherType::kFrogTwoCipherA?CipherType::kFrogThreeCipherA:CipherType::kFrogTwoCipherA)
                             :(right==CipherType::kToadTwoCipherA?CipherType::kToadThreeCipherA:CipherType::kToadTwoCipherA);
        std::unique_ptr<Cipher> invalid(Soccer2::GenerateCipher(wrong,stage));XCTAssertTrue(invalid==nullptr);
    }
    for(unsigned stage : {9U,255U})for(auto type : {CipherType::kRotateCipher,CipherType::kFrogThreeCipherA,CipherType::kToadTwoCipherA}) {
        std::unique_ptr<Cipher> invalid(Soccer2::GenerateCipher(type,stage));XCTAssertTrue(invalid==nullptr);
    }
}
@end

#endif
#import <XCTest/XCTest.h>
@interface FrogPlanTests : XCTestCase
@end
@implementation FrogPlanTests
- (void)testRetiredConstruction { XCTSkip(@"Historical Cryptex / premium-seed test; replaced by FlameToad vault checks."); }
@end
