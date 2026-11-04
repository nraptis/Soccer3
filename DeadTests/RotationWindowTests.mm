// Serial: Soccer owns the eight rotation packs and shared block map.
#import <XCTest/XCTest.h>
#include "Soccer2.hpp"
#include "SeedMaterialTestSupport.hpp"
#include <algorithm>
#include <cstring>
#include <memory>
#include <random>
#include <set>

namespace {
using namespace RotationSelection;
struct Fixture {
    RotationPack mPacks[kPackCount];
    bool mBlocked[kWindowCount] = {};
    std::uint16_t mSamples[kSamplingCount] = {};
    std::int32_t mBytes[kByteCount] = {};
    std::uint8_t mEntropy[SeedMaterialLayout::kRotationPackBytes] = {};
    bool Make(std::uint64_t pSeed) {
        std::memset(mBlocked,0,sizeof(mBlocked));
        std::mt19937_64 aRandom(pSeed);
        for (std::size_t aPack=0U;aPack<kPackCount;++aPack) {
            for (std::size_t i=0U;i<sizeof(mEntropy);i+=8U) {
                const auto aWord=aRandom();
                for (unsigned b=0U;b<8U;++b)mEntropy[i+b]=static_cast<std::uint8_t>(aWord>>(8U*b));
            }
            auto &p=mPacks[aPack];
            if (!p.Shuffle(mEntropy,sizeof(mEntropy)) || !p.Farm(mBlocked,mEntropy,sizeof(mEntropy))) return false;
            for(unsigned f=0U;f<4U;++f)for(unsigned r=0U;r<4U;++r)mSamples[16U*aPack+4U*f+r]=p.mRotationWindow[f][r];
            for(unsigned r=0U;r<2U;++r)mBytes[2U*aPack+r]=p.mRotationsFree[r];
        }
        return true;
    }
};
struct Cleanup { ~Cleanup(){Soccer2::Zero();} };
}
@interface RotationWindowTests : XCTestCase
@end
@implementation RotationWindowTests
- (void)testEightPacksGlobalExclusionsAndAllLocalSubsetSums {
    auto f=std::make_unique<Fixture>();
    for (unsigned seed=0U;seed<64U;++seed) {
        XCTAssertTrue(f->Make(seed));
        XCTAssertTrue(IsValid(f->mSamples,kSamplingCount,f->mBytes,kByteCount));
        std::set<unsigned> aWindows, aBytes, aExpectedBlocked{0U,8192U};
        for (std::size_t pack=0U;pack<8U;++pack) {
            XCTAssertTrue(f->mPacks[pack].mReady);
            XCTAssertTrue(f->mPacks[pack].IsPermutation());
            XCTAssertLessThan(f->mPacks[pack].mCursor,kWindowCount);
            XCTAssertLessThanOrEqual(f->mPacks[pack].mEntropyBytesRead,sizeof(f->mEntropy));
            const auto aRemember=[&](unsigned w,unsigned b){
                XCTAssertTrue(aWindows.insert(w).second);XCTAssertTrue(aBytes.insert(b).second);
                aExpectedBlocked.insert(w);aExpectedBlocked.insert((16384U-w)%16384U);
                aExpectedBlocked.insert(((1048576U-b)%1048576U)/64U);
            };
            for (unsigned frog=0U;frog<4U;++frog) {
                unsigned w[6], b[6];
                for(unsigned r=0U;r<4U;++r){w[r]=f->mSamples[16U*pack+4U*frog+r];b[r]=64U*w[r];aRemember(w[r],b[r]);}
                for(unsigned r=0U;r<2U;++r){b[4U+r]=unsigned(f->mBytes[2U*pack+r]);w[4U+r]=b[4U+r]/64U;}
                std::set<unsigned> aWindowSums,aByteSums;
                for(unsigned mask=0U;mask<64U;++mask){
                    unsigned sw=0U,sb=0U;
                    for(unsigned r=0U;r<6U;++r)if(mask&(1U<<r)){sw+=w[r];sb+=b[r];}
                    aWindowSums.insert(sw%16384U);aByteSums.insert(sb%1048576U);
                }
                XCTAssertEqual(aWindowSums.size(),std::size_t{64U});
                XCTAssertEqual(aByteSums.size(),std::size_t{64U});
            }
            for(unsigned r=0U;r<2U;++r){const unsigned b=unsigned(f->mBytes[2U*pack+r]);aRemember(b/64U,b);XCTAssertNotEqual(b%64U,0U);}
            XCTAssertNotEqual((f->mBytes[2U*pack]|f->mBytes[2U*pack+1U])&1,0);
        }
        XCTAssertEqual(aWindows.size(),std::size_t{144U});
        for(auto w:aWindows){XCTAssertFalse(aWindows.contains((16384U-w)%16384U));XCTAssertNotEqual(w,0U);}
        for(auto b:aBytes)XCTAssertFalse(aBytes.contains((1048576U-b)%1048576U));
        for(unsigned w=0U;w<16384U;++w)XCTAssertEqual(f->mBlocked[w],aExpectedBlocked.contains(w));
    }
}
- (void)testSixteenBitShuffleAgainstIndependentReferenceAndShortEntropy {
    std::uint16_t aActual[16384],aExpected[16384];
    std::uint8_t aEntropy[65537];
    std::mt19937_64 aRandom(22U);for(auto &b:aEntropy)b=static_cast<std::uint8_t>(aRandom());
    for(unsigned i=0U;i<16384U;++i)aActual[i]=aExpected[i]=i;
    std::size_t aRead=0U,aReferenceRead=0U;
    XCTAssertTrue(TwistShuffle::ShuffleList16384(aActual,aEntropy+1U,65536U,aRead));
    for(unsigned i=0U;i<16383U;++i){
        const unsigned remaining=16384U-i;unsigned range=1U;while(range<remaining)range*=2U;
        unsigned choice;
        do {choice=(unsigned(aEntropy[1U+aReferenceRead])|(unsigned(aEntropy[2U+aReferenceRead])<<8U))%range;aReferenceRead+=2U;}while(choice>=remaining);
        std::swap(aExpected[i],aExpected[i+choice]);
    }
    XCTAssertEqual(aRead,aReferenceRead);XCTAssertEqual(std::memcmp(aActual,aExpected,sizeof(aActual)),0);
    RotationPack aPack;
    XCTAssertFalse(aPack.Shuffle(nullptr,0U));XCTAssertFalse(aPack.mShuffled);
    XCTAssertFalse(aPack.Shuffle(aEntropy,1U));XCTAssertFalse(aPack.mReady);
    std::fill(std::begin(aEntropy),std::end(aEntropy),0xFFU);
    XCTAssertFalse(aPack.Shuffle(aEntropy,sizeof(aEntropy))); // Rejection cannot loop forever.
}
- (void)testCursorWrapAndExhaustionHaveNoGlobalSideEffects {
    auto f=std::make_unique<Fixture>();XCTAssertTrue(f->Make(20261103));
    RotationPack p;XCTAssertTrue(p.Shuffle(f->mEntropy,sizeof(f->mEntropy)));
    p.mCursor=16382U;
    bool blocked[16384]={};
    XCTAssertTrue(p.Farm(blocked,f->mEntropy,sizeof(f->mEntropy)));
    XCTAssertLessThan(p.mCursor,std::size_t{100U});XCTAssertGreaterThanOrEqual(p.mReadCount,std::size_t{18U});
    XCTAssertTrue(p.IsPermutation());
    XCTAssertTrue(p.Shuffle(f->mEntropy,sizeof(f->mEntropy)));
    std::fill(std::begin(blocked),std::end(blocked),true);
    XCTAssertFalse(p.Farm(blocked,f->mEntropy,sizeof(f->mEntropy)));
    XCTAssertFalse(p.mReady);XCTAssertEqual(p.mReadCount,std::size_t{16384U});
    XCTAssertTrue(std::all_of(std::begin(blocked),std::end(blocked),[](bool b){return b;}));
    p.mRotationWindowBase[1]=p.mRotationWindowBase[0];
    XCTAssertFalse(p.Farm(blocked,f->mEntropy,sizeof(f->mEntropy)));
}
- (void)testValidatorRejectsDuplicatesComplementsAndLocalCombinationCollisions {
    auto f=std::make_unique<Fixture>();XCTAssertTrue(f->Make(77));
    std::uint16_t samples[kSamplingCount];
    const auto aReset=[&]{std::memcpy(samples,f->mSamples,sizeof(samples));};
    aReset();samples[1]=samples[0];XCTAssertFalse(IsValid(samples,kSamplingCount,f->mBytes,kByteCount));
    aReset();samples[1]=16384U-samples[0];XCTAssertFalse(IsValid(samples,kSamplingCount,f->mBytes,kByteCount));
    aReset();samples[2]=(samples[0]+samples[1])%16384U;XCTAssertFalse(IsValid(samples,kSamplingCount,f->mBytes,kByteCount));
    aReset();samples[3]=(samples[0]+samples[1]+16384U-samples[2])%16384U;XCTAssertFalse(IsValid(samples,kSamplingCount,f->mBytes,kByteCount));
    aReset();samples[0]=0U;XCTAssertFalse(IsValid(samples,kSamplingCount,f->mBytes,kByteCount));
    aReset();samples[0]=8192U;XCTAssertFalse(IsValid(samples,kSamplingCount,f->mBytes,kByteCount));
}
- (void)testFarmingReproducesAndUsesSeparateIntermediateTailSlices {
    Cleanup cleanup;Soccer2::Zero();SeedMaterialTestSupport::Prepare(91);
    XCTAssertTrue(Soccer2::FarmRotationWindows());
    auto saved=std::make_unique<RotationPack[]>(8U);
    for(unsigned i=0U;i<8U;++i)saved[i]=Soccer2::mRotationPacks[i];
    XCTAssertTrue(Soccer2::FarmRotationWindows());
    for(unsigned i=0U;i<8U;++i){
        XCTAssertEqual(std::memcmp(saved[i].mRotationWindowBase,Soccer2::mRotationPacks[i].mRotationWindowBase,sizeof(saved[i].mRotationWindowBase)),0);
        XCTAssertEqual(std::memcmp(saved[i].mRotationWindow,Soccer2::mRotationPacks[i].mRotationWindow,sizeof(saved[i].mRotationWindow)),0);
        XCTAssertEqual(std::memcmp(saved[i].mRotationsFree,Soccer2::mRotationPacks[i].mRotationsFree,sizeof(saved[i].mRotationsFree)),0);
    }
    SeedMaterialTestSupport::RotationEntropy(3U)[1U]^=0x3FU;
    XCTAssertTrue(Soccer2::FarmRotationWindows());
    for(unsigned i=0U;i<8U;++i){
        const bool same=std::memcmp(saved[i].mRotationWindowBase,Soccer2::mRotationPacks[i].mRotationWindowBase,sizeof(saved[i].mRotationWindowBase))==0;
        XCTAssertEqual(same,i!=3U);
    }
    XCTAssertTrue(IsValid(Soccer2::mRotationWindow,kSamplingCount,Soccer2::mRotationsByte,kByteCount));
    // Folded output controls material choices only; it cannot reshuffle packs.
    SeedMaterialTestSupport::Store(0U,~SeedMaterialTestSupport::Read(0U));
    std::uint16_t windows[144];std::copy_n(Soccer2::mRotationWindow,144U,windows);
    XCTAssertTrue(Soccer2::FarmRotationWindows());XCTAssertTrue(std::equal(std::begin(windows),std::end(windows),Soccer2::mRotationWindow));
    // Failure clears all exported offsets and the global block map.
    std::fill_n(SeedMaterialTestSupport::RotationEntropy(7U),SeedMaterialLayout::kRotationPackBytes,0xFFU);
    XCTAssertFalse(Soccer2::FarmRotationWindows());
    for(auto w:Soccer2::mRotationWindow)XCTAssertEqual(w,0U);
    for(auto b:Soccer2::mRotationsByte)XCTAssertEqual(b,0);
    for(auto &p:Soccer2::mRotationPacks)XCTAssertFalse(p.mReady);
}
@end
