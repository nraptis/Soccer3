// A one-known-block attack against whole-block parity. Frozen polarity and
// fresh balanced-parity plaintexts; no access to key material in the predictor.
#import <XCTest/XCTest.h>
#include "StatisticalRecoveryHarness.hpp"
#include <bit>
#include <cmath>
using namespace StatisticalRecovery;
namespace {
unsigned BlockParity(const Bytes &pData) {
    std::uint8_t aCombined=0U;
    for (auto aByte:pData) aCombined^=aByte;
    return std::popcount(aCombined)&1U;
}
}
@interface WholeBlockParityRecoveryTests : XCTestCase
@end
@implementation WholeBlockParityRecoveryTests
- (void)checkStrength:(EncryptionStrength)pStrength {
    constexpr std::size_t kTrials=1024U;
    // Six strength/fixture hypotheses, two-sided Hoeffding, family alpha 1e-6.
    const auto aCutoff=0.5+std::sqrt(std::log(12.0/1e-6)/(2.0*kTrials));
    for(std::size_t aFixture=0;aFixture<2;++aFixture) {
        ClearSoccerOnExit aCleanup;
        if(!SeedFixture(pStrength,aFixture)){XCTFail(@"Parity fixture seeding failed");return;}
        Bytes aKnown(kBlockBytes,0U),aCipher(kBlockBytes),aPlain(kBlockBytes);
        if(!Soccer3::EncryptBlock(aKnown.data(),aCipher.data())){XCTFail(@"Known block encryption failed");return;}
        const auto aOffset=BlockParity(aKnown)^BlockParity(aCipher);
        std::mt19937_64 aRandom(0xF1A0E9A317ULL+aFixture);
        std::size_t aCorrect=0U;
        for(std::size_t i=0U;i<kTrials;++i) {
            Fill(aPlain,aRandom);
            if(BlockParity(aPlain)!=(i&1U))aPlain[0]^=1U;
            if(!Soccer3::EncryptBlock(aPlain.data(),aCipher.data())){XCTFail(@"Challenge encryption failed");return;}
            aCorrect+=(BlockParity(aCipher)^aOffset)==(i&1U);
        }
        const double aAccuracy=static_cast<double>(aCorrect)/kTrials;
        const double aBest=std::max(aAccuracy,1.0-aAccuracy);
        std::printf("Whole-block parity | flame-toad-vault | strength=%u fixture=%zu | prediction=%.4f%% | two-sided best=%.4f%% cutoff=%.4f%% | %s\n",
            unsigned(pStrength),aFixture,100*aAccuracy,100*aBest,100*aCutoff,aBest<aCutoff?"PASS":"FAIL");
        XCTAssertLessThan(aBest,aCutoff,@"SECURITY: whole-block parity remains predictable");
    }
}
- (void)testWholeBlockParityWeak { [self checkStrength:EncryptionStrength::kWeak]; }
- (void)testWholeBlockParityNormal { [self checkStrength:EncryptionStrength::kNormal]; }
- (void)testWholeBlockParityStrong { [self checkStrength:EncryptionStrength::kStrong]; }
- (void)testControlRecoversFixedParityOffset {
    Bytes aPlain(128U),aCipher(128U);std::mt19937_64 aRandom(123);
    for(unsigned i=0;i<64;++i){Fill(aPlain,aRandom);aCipher=aPlain;aCipher[17]^=0x07U;
        XCTAssertEqual(BlockParity(aCipher)^1U,BlockParity(aPlain));}
}
@end
