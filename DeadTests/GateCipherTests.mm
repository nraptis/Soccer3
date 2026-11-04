#import <XCTest/XCTest.h>
#include "GateCipherChecks.hpp"
#include "Soccer2.hpp"
#include "EncryptionLayer.hpp"
#include "PasswordAddCipher.hpp"
#include "RotateCipher.hpp"
#include <memory>

@interface GateCipherTests : XCTestCase
@end
@implementation GateCipherTests
- (void)testFipsMappingEveryBytePositionAndOneMiBRoundTrip {
    const auto failure = CheckGateCipher();
    XCTAssertTrue(failure == nullptr, @"%s", failure ? failure : "");
    std::printf("GateCipher backend: %s\n", GateCipher::BackendName());
}
- (void)testLengthZeroNullAndOverlappingBuffers {
    GateCipher cipher{};
    std::array<std::uint8_t, 768> buffer{};
    buffer.fill(0x53);
    for (bool inverse : {false, true}) {
        const auto apply = [&](const std::uint8_t *source, std::uint8_t *destination,
                               std::size_t size, CipherErrorCode *error) {
            return inverse ? cipher.UnsealData(source,nullptr,destination,size,error)
                           : cipher.SealData(source,nullptr,destination,size,error);
        };
        CipherErrorCode error = CipherErrorCode::kNullCipher;
        XCTAssertTrue(apply(nullptr,nullptr,0,&error));
        XCTAssertTrue(error == CipherErrorCode::kNone);
        const auto before = buffer;
        for (std::size_t length : {1U,16U,255U,257U,511U}) {
            XCTAssertFalse(apply(buffer.data(),buffer.data()+512,length,&error));
            XCTAssertTrue(error == CipherErrorCode::kInvalidLength);
            XCTAssertTrue(buffer == before);
        }
        XCTAssertFalse(apply(nullptr,buffer.data(),256,&error));
        XCTAssertTrue(error == CipherErrorCode::kNullBuffer);
        XCTAssertFalse(apply(buffer.data(),nullptr,256,&error));
        XCTAssertTrue(error == CipherErrorCode::kNullBuffer);
        XCTAssertFalse(apply(buffer.data(),buffer.data(),256,&error));
        XCTAssertTrue(error == CipherErrorCode::kAliasedBuffer);
        XCTAssertFalse(apply(buffer.data(),buffer.data()+1,256,&error));
        XCTAssertTrue(error == CipherErrorCode::kAliasedBuffer);
        XCTAssertFalse(apply(buffer.data()+1,buffer.data(),256,&error));
        XCTAssertTrue(error == CipherErrorCode::kAliasedBuffer);
        XCTAssertTrue(buffer == before);
        XCTAssertTrue(apply(buffer.data(),buffer.data()+256,256,nullptr));
    }
}
#if 0 // Retired Cryptex factory; direct cipher tests below remain active.
- (void)testFactoryConsumesNoMaterialOrMasks {
    const auto mask = Soccer2Internal::mMaskCursor;
    const auto material = Soccer2Internal::mMaterialIndex;
    const auto quarter = Soccer2Internal::mMaterialQuarter;
    for (std::uint8_t stage = 0; stage < 9; ++stage) {
        std::unique_ptr<Cipher> cipher(Soccer2Internal::GenerateCipher(CipherType::kGateCipher,stage));
        XCTAssertTrue(cipher != nullptr);
        if (!cipher) return;
        XCTAssertTrue(cipher->mType == CipherType::kGateCipher);
        XCTAssertEqual(CipherTool::CountLanes(cipher->mType),std::size_t{0});
        XCTAssertFalse(IS_MUTATE(cipher->mType) || IS_MASKED(cipher->mType));
    }
    XCTAssertEqual(Soccer2Internal::mMaskCursor,mask);
    XCTAssertEqual(Soccer2Internal::mMaterialIndex,material);
    XCTAssertEqual(Soccer2Internal::mMaterialQuarter,quarter);
}
#endif
- (void)testLayerReversesInterleavedGateAndKeyedOperations {
    constexpr std::size_t length = 256;
    std::array<std::uint8_t,length> source{}, key{}, worker{}, encrypted{}, restored{};
    for (std::size_t i=0;i<length;++i) {source[i]=static_cast<std::uint8_t>(i*19);key[i]=static_cast<std::uint8_t>(i*31+7);}
    EncryptionLayer layer;
    layer.AddCipher(new GateCipher{});
    layer.AddCipher(new PasswordAddCipher(key.data()));
    layer.AddCipher(new RotateCipher(37));
    layer.AddCipher(new GateCipher{});
    CipherErrorCode error;
    XCTAssertTrue(layer.SealData(source.data(),worker.data(),encrypted.data(),length,&error));
    XCTAssertTrue(layer.UnsealData(encrypted.data(),worker.data(),restored.data(),length,&error));
    XCTAssertTrue(source == restored);
    XCTAssertFalse(source == encrypted);
}
@end
