// Retired with FlameToad: historical Cryptex / premium-seed plumbing. Source retained.
#if 0
// Run serially: Soccer2's sampling inputs and factory cursors are shared state.
#import <XCTest/XCTest.h>
#include "Soccer2.hpp"
#include "EncryptionPlan.hpp"
#include "LaneCombinations.hpp"
#include <memory>
#include <random>
#include <vector>

namespace {
struct Cleanup { ~Cleanup() { Soccer2::Zero(); } };
constexpr unsigned kCounts[][9]={{2,3,3,3,3,2,3,2,3},{3,2,3,2,3,3,3,3,2},{3,3,2,3,2,3,2,3,3}};
constexpr CipherSamplingBank kBanks[]={CipherSamplingBank::kPlanet,CipherSamplingBank::kMoon,CipherSamplingBank::kStar};
CipherType Type(unsigned operation, std::size_t count) {
    constexpr CipherType types[][2]={
        {CipherType::kFrogTwoCipherA,CipherType::kFrogThreeCipherA},
        {CipherType::kToadTwoCipherA,CipherType::kToadThreeCipherA},
        {CipherType::kNewtTwoCipherA,CipherType::kNewtThreeCipherA}};
    return types[operation][count==3U];
}
const Soccer2::SamplingInput& Input(unsigned bank,unsigned stage) {
    const Soccer2::SamplingInput* banks[]={Soccer2::mPlanetInputs,Soccer2::mMoonInputs,Soccer2::mStarInputs};
    return banks[bank][stage];
}
void PrepareInputs() {
    Soccer2::Zero();
    for(unsigned bank=0;bank<3;++bank)for(unsigned stage=0;stage<9;++stage) {
        const auto& input=Input(bank,stage);
        for(unsigned i=0;i<input.mCount;++i)input.mRows[i]=(i*3+stage*2+bank)%8;
        for(unsigned i=0;i<input.mCount;++i)input.mRotations[i]=1+17*stage+7*bank+3*i;
    }
}
std::unique_ptr<Cipher> Direct(unsigned operation,const Soccer2::SamplingInput& input) {
    const auto* r=input.mRows;const auto* o=input.mRotations;
    if(operation==0) {
        if(input.mCount==2)return std::make_unique<FrogTwoCipherA>(r[0],o[0],r[1],o[1]);
        return std::make_unique<FrogThreeCipherA>(r[0],o[0],r[1],o[1],r[2],o[2]);
    }
    if(operation==1) {
        if(input.mCount==2)return std::make_unique<ToadTwoCipherA>(r[0],o[0],r[1],o[1]);
        return std::make_unique<ToadThreeCipherA>(r[0],o[0],r[1],o[1],r[2],o[2]);
    }
    if(input.mCount==2)return std::make_unique<NewtTwoCipherA>(r[0],o[0],r[1],o[1]);
    return std::make_unique<NewtThreeCipherA>(r[0],o[0],r[1],o[1],r[2],o[2]);
}
}
@interface NewtPlanTests : XCTestCase
@end
@implementation NewtPlanTests
// Active six-Frog plan checks live in FrogStackPlanTests.
- (void)testFactoryRoutesAllThreeBanksForAllThreeOperations {
    Cleanup cleanup;PrepareInputs();
    std::vector<std::uint8_t> source(127*64),actual(source.size()),expected(source.size()),restored(source.size());
    std::mt19937 random(0x4E657774U);for(auto& byte:source)byte=static_cast<std::uint8_t>(random());
    for(unsigned operation=0;operation<3;++operation)for(unsigned bank=0;bank<3;++bank)for(unsigned stage=0;stage<9;++stage) {
        const auto& input=Input(bank,stage);
        auto direct=Direct(operation,input);
        const auto type=Type(operation,static_cast<unsigned>(input.mCount));
        std::unique_ptr<Cipher> factory(Soccer2::GenerateCipher(type,stage,kBanks[bank]));
        if(!factory) {XCTFail(@"Valid operation/bank rejected");return;}
        XCTAssertEqual(factory->mType,type);
        XCTAssertTrue(direct->SealData(source.data(),nullptr,expected.data(),source.size(),nullptr));
        XCTAssertTrue(factory->SealData(source.data(),nullptr,actual.data(),source.size(),nullptr));
        XCTAssertTrue(actual==expected);
        XCTAssertTrue(factory->UnsealData(actual.data(),nullptr,restored.data(),source.size(),nullptr));
        XCTAssertTrue(restored==source);
    }
    XCTAssertEqual(Soccer2::mMaterialIndex,std::size_t{0});XCTAssertEqual(Soccer2::mMaskCursor,std::size_t{0});
}
- (void)testDefaultBanksAndInvalidRouting {
    Cleanup cleanup;PrepareInputs();
    for(unsigned operation=0;operation<3;++operation)for(unsigned stage=0;stage<9;++stage) {
        const auto type=Type(operation,kCounts[operation][stage]);
        std::unique_ptr<Cipher> implicit(Soccer2::GenerateCipher(type,stage));XCTAssertTrue(implicit!=nullptr);
    }
    for(unsigned operation=0;operation<3;++operation)for(unsigned bank=0;bank<3;++bank)for(unsigned stage=0;stage<9;++stage) {
        const auto count=Input(bank,stage).mCount;
        std::unique_ptr<Cipher> mismatch(Soccer2::GenerateCipher(Type(operation,count==2?3:2),stage,kBanks[bank]));
        XCTAssertTrue(mismatch==nullptr);
        std::unique_ptr<Cipher> invalidBank(Soccer2::GenerateCipher(Type(operation,count),stage,static_cast<CipherSamplingBank>(255)));
        XCTAssertTrue(invalidBank==nullptr);
    }
    for(unsigned stage:{9U,255U})for(auto bank:kBanks)for(auto type:{CipherType::kNewtTwoCipherA,CipherType::kNewtThreeCipherA}) {
        std::unique_ptr<Cipher> invalidStage(Soccer2::GenerateCipher(type,stage,bank));XCTAssertTrue(invalidStage==nullptr);
    }
}
- (void)testFrogToadAndNewtCanStillShareAnEncryptionLayer {
    Cleanup cleanup;PrepareInputs();
    std::vector<std::uint8_t> source(127*64),scratch(source.size()),encrypted(source.size()),restored(source.size());
    std::mt19937 random(0x3F7070U);for(auto& byte:source)byte=static_cast<std::uint8_t>(random());
    for(unsigned stage=0;stage<9;++stage) {
        EncryptionLayer layer;
        for(unsigned operation=0;operation<3;++operation) {
            const unsigned bank=operation;
            std::unique_ptr<Cipher> cipher(Soccer2::GenerateCipher(Type(operation,Input(bank,stage).mCount),stage,kBanks[bank]));
            if(!cipher) {XCTFail(@"Mixed-family factory failure");return;}
            // Each family uses its own parameter bank.
            layer.AddCipher(cipher.release());
        }
        XCTAssertTrue(layer.SealData(source.data(),scratch.data(),encrypted.data(),source.size(),nullptr));
        XCTAssertTrue(encrypted!=source);
        XCTAssertTrue(layer.UnsealData(encrypted.data(),scratch.data(),restored.data(),source.size(),nullptr));
        XCTAssertTrue(restored==source);
    }
}
@end

#endif
#import <XCTest/XCTest.h>
@interface NewtPlanTests : XCTestCase
@end
@implementation NewtPlanTests
- (void)testRetiredConstruction { XCTSkip(@"Historical Cryptex / premium-seed test; replaced by FlameToad vault checks."); }
@end
