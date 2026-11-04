// Retired with FlameToad: historical Cryptex / premium-seed plumbing. Source retained.
#if 0
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
struct Cleanup {
    bool mSavedLegacy = Soccer2Internal::mUseLegacyCryptex;
    Cleanup() { Soccer2Internal::mUseLegacyCryptex = true; }
    ~Cleanup() { Soccer2::Zero(); Soccer2Internal::mUseLegacyCryptex = mSavedLegacy; }
};
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
    // Fixed vectors for one Frog triplet and one derived masked rotation
    // per layer. Eight full bit rotations; row offsets repeat 0/3/6 in A/B/C.
    constexpr const char* hashes[]={
        "12b7a62f635e63e06d0275cc86818e89227221e6086552e4bb612aec823ccd76",
        "6d856b50a2d187bc37c8abf4720813bf6522e9aa602e33a45c4c1876201ea182"};
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

#endif
#import <XCTest/XCTest.h>
@interface NineLayerPlanTests : XCTestCase
@end
@implementation NineLayerPlanTests
- (void)testRetiredConstruction { XCTSkip(@"Historical Cryptex / premium-seed test; replaced by FlameToad vault checks."); }
@end
