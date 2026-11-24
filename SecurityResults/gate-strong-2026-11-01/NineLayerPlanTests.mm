// Run serially: the production API owns process-global seed/plan state.
#import <XCTest/XCTest.h>
#include <CommonCrypto/CommonDigest.h>
#include "../Scramble/Public/Soccer2.hpp"
#define SOCCER_ENCRYPTION_STRENGTH_DEFINED
#define SOCCER2_DISABLE_COMPAT_ALIAS
#include "../Scramble/Composer/Soccer2.hpp"
#include "EncryptionPlan.hpp"
#include "LaneCombinations.hpp"
#include <array>
#include <algorithm>
#include <cstdio>
#include <cstring>
#include <random>
#include <string>
#include <vector>

namespace {
struct Cleanup { ~Cleanup() { Soccer2::Zero(); } };
bool Seed(EncryptionStrength strength, unsigned fixture, std::uint32_t &ack) {
    constexpr const char *passwords[] = {"review-fixture", "second-fixture"};
    constexpr std::uint64_t nonces[] = {0x2026103001234567ULL, 0xD3B91C764E2085AFULL};
    std::array<std::uint8_t,14> password{};
    std::memcpy(password.data(),passwords[fixture],password.size());
    Soccer2::Zero();
    return Soccer2::AttemptSeed_Encrypt(strength,password.data(),password.size(),nonces[fixture],&ack,0,nullptr);
}
std::string Hash(const std::vector<std::uint8_t> &bytes) {
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(bytes.data(),static_cast<CC_LONG>(bytes.size()),digest);
    char text[CC_SHA256_DIGEST_LENGTH*2+1];
    for(unsigned i=0;i<CC_SHA256_DIGEST_LENGTH;++i)std::snprintf(text+2*i,3,"%02x",digest[i]);
    return text;
}
std::vector<std::uint8_t> Plaintext() {
    std::vector<std::uint8_t> bytes(SOCCER_BLOCK_SIZE);
    for(std::size_t i=0;i<bytes.size();++i)bytes[i]=static_cast<std::uint8_t>((i*37U)^(i>>8U)^(i>>17U));
    return bytes;
}
}

@interface NineLayerPlanTests : XCTestCase
@end
@implementation NineLayerPlanTests
- (void)testStrongCiphertextWithInterleavedSeedLayout {
    Cleanup cleanup;
    constexpr std::uint32_t acknowledgements[]={1870322214U,1105695652U};
    // Fixed vectors for the 25/75 source split, 384-word seed, and two-Gate layers.
    constexpr const char* hashes[]={
        "8d3737565259846e774e9ffc441b000e74414765e8b672b4199738efa30cbed2",
        "f142e1079779bf1873dc1da7c206bb3d158d7cb409bfa9f0c193b905e22d37ac"};
    auto plain=Plaintext();std::vector<std::uint8_t> encrypted(plain.size()),restored(plain.size());
    for(unsigned fixture=0;fixture<2;++fixture) {
        std::uint32_t ack=0;
        if(!Seed(EncryptionStrength::kStrong,fixture,ack)) {XCTFail(@"Could not seed strong");return;}
        XCTAssertTrue(Soccer2::EncryptBlock(plain.data(),encrypted.data()));
        std::printf("Strong interleaved-seed fixture=%u ack=%u sha256=%s\n",fixture,ack,Hash(encrypted).c_str());
        XCTAssertEqual(ack,acknowledgements[fixture]);
        XCTAssertTrue(Hash(encrypted)==hashes[fixture]);
        XCTAssertTrue(Soccer2::DecryptBlock(encrypted.data(),restored.data()));
        XCTAssertTrue(restored==plain);
    }
}
- (void)testAllLaneChoicesStayWithinMaskAndMaterialBudgets {
    Cleanup cleanup;Soccer2Internal::Zero();Soccer2Internal::InitializeCiphers();
    using Factory=decltype(&EncryptionPlanTool::MakePlanWeak);
    const Factory factories[]={EncryptionPlanTool::MakePlanWeak,EncryptionPlanTool::MakePlanNormal,EncryptionPlanTool::MakePlanStrong};
    const std::size_t selections[]={LaneCombinations::mWeakCount,LaneCombinations::mNormalCount,LaneCombinations::mStrongCount};
    const unsigned masks[]={9,12,13},mutations[]={4,7,14},quarters[]={16,32,64};
    std::mt19937 random(0x394C6179U);
    for(unsigned shuffle=0;shuffle<3;++shuffle) {
        if(shuffle) {
            std::shuffle(std::begin(Soccer2Internal::mCiphersMutate),std::end(Soccer2Internal::mCiphersMutate),random);
            std::shuffle(std::begin(Soccer2Internal::mCiphersPrimaryMovers),std::end(Soccer2Internal::mCiphersPrimaryMovers),random);
            std::shuffle(std::begin(Soccer2Internal::mCiphersSecondaryMovers),std::end(Soccer2Internal::mCiphersSecondaryMovers),random);
        }
        for(unsigned strength=0;strength<3;++strength)for(std::size_t selection=0;selection<selections[strength];++selection) {
            const auto plan=factories[strength](selection,Soccer2Internal::mCiphersMutate,Soccer2Internal::mCiphersPrimaryMovers,Soccer2Internal::mCiphersSecondaryMovers);
            const EncryptionPlanStage* stages[]={&plan.mL3A,&plan.mL2A,&plan.mL1A,&plan.mL3B,&plan.mL2B,&plan.mL1B,&plan.mL3C,&plan.mL2C,&plan.mL1C};
            unsigned maskCount=0,mutateCount=0,materialQuarters=0;
            for(unsigned stage=0;stage<9;++stage) {
                const auto& layer=*stages[stage];
                unsigned primary=0,secondary=0,mutate=0,rotate=0;
                for(std::size_t i=0;i<layer.mCount;++i) {
                    const auto type=layer.mType[i];
                    maskCount+=IS_MASKED(type);mutate+=IS_MUTATE(type);
                    primary+=IS_PRIMARY_MOVER(type);secondary+=IS_SECONDARY_MOVER(type);
                    rotate+=IS_ROTATION_ANY(type);
                    materialQuarters+=CipherTool::CountLanes(type)*(4U>>(stage%3U));
                    if(strength!=2)XCTAssertFalse(IS_ROTATION_MASKED(type));
                }
                mutateCount+=mutate;XCTAssertEqual(rotate,1U);
                if(strength==0 || (strength==1 && stage<6))XCTAssertEqual(primary+secondary,1U);
                if(strength==1 && stage>=6) {
                    XCTAssertEqual(primary,8U-stage);XCTAssertEqual(secondary,stage-6U);
                    XCTAssertEqual(mutate,1U);
                }
            }
            XCTAssertEqual(maskCount,masks[strength]);
            XCTAssertLessThanOrEqual(maskCount,SoccerMaskBank::mMaskGridWidth);
            XCTAssertEqual(mutateCount,mutations[strength]);
            XCTAssertLessThanOrEqual(materialQuarters,quarters[strength]);
        }
    }
}
- (void)testIndependentBlocksRepeatAndDecryptAfterReseeding {
    Cleanup cleanup;
    auto plain=Plaintext(),other=plain;
    for(std::size_t i=0;i<other.size();i+=997)other[i]^=0xA5U;
    std::vector<std::uint8_t> encrypted(plain.size()),otherEncrypted(plain.size()),repeat(plain.size()),restored(plain.size());
    for(auto strength:{EncryptionStrength::kWeak,EncryptionStrength::kNormal,EncryptionStrength::kStrong}) {
        std::uint32_t ack=0;
        if(!Seed(strength,0,ack)) {XCTFail(@"Could not seed plan");return;}
        XCTAssertTrue(Soccer2::EncryptBlock(plain.data(),encrypted.data()));
        XCTAssertTrue(Soccer2::EncryptBlock(other.data(),otherEncrypted.data()));
        XCTAssertTrue(Soccer2::EncryptBlock(plain.data(),repeat.data()));
        XCTAssertTrue(repeat==encrypted);XCTAssertTrue(otherEncrypted!=encrypted);
        Soccer2::Zero();
        std::array<std::uint8_t,14> password{};std::memcpy(password.data(),"review-fixture",password.size());
        if(!Soccer2::AttemptSeed_Decrypt(strength,password.data(),password.size(),0x2026103001234567ULL,ack,0,nullptr)) {
            XCTFail(@"Could not reconstruct plan for decryption");return;
        }
        // Reverse block order deliberately: blocks have no chaining state.
        XCTAssertTrue(Soccer2::DecryptBlock(otherEncrypted.data(),restored.data()));XCTAssertTrue(restored==other);
        XCTAssertTrue(Soccer2::DecryptBlock(encrypted.data(),restored.data()));XCTAssertTrue(restored==plain);
    }
}
@end
