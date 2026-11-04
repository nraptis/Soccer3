#import <XCTest/XCTest.h>
#include "BitRotationCipherChecks.hpp"
#include "Soccer2.hpp"
#include "PasswordAddCipher.hpp"
#include "RotateCipher.hpp"
#include <memory>

@interface BitRotationCipherTests : XCTestCase
@end
@implementation BitRotationCipherTests
- (void)testEveryByteValueComplementaryHalvesAndUnalignedOneMiBRoundTrip {
    const auto aFailure = CheckBitRotationCiphers();
    XCTAssertTrue(aFailure == nullptr, @"%s", aFailure ? aFailure : "");
}
- (void)testLengthNullOverlapAndZeroLength {
    const auto aFailure = CheckBitRotationErrors();
    XCTAssertTrue(aFailure == nullptr, @"%s", aFailure ? aFailure : "");
}
#if 0 // Retired Cryptex factory; direct cipher tests below remain active.
- (void)testFactoryConsumesNoMaterialsMasksOrByteRotationSlots {
    const auto aMask = Soccer2Internal::mMaskCursor;
    const auto aMaterial = Soccer2Internal::mMaterialIndex;
    const auto aQuarter = Soccer2Internal::mMaterialQuarter;
    for (auto aType : {CipherType::kBitRotationCipherA, CipherType::kBitRotationCipherB}) {
        for (std::uint8_t aStage = 0u; aStage < 9u; ++aStage) {
            std::unique_ptr<Cipher> aCipher(Soccer2Internal::GenerateCipher(
                aType, aStage, CipherSamplingBank::kByCipherType, Soccer2Internal::kRotationsPerLayer));
            XCTAssertTrue(aCipher != nullptr);
            if (!aCipher) return;
            XCTAssertTrue(aCipher->mType == aType);
            XCTAssertEqual(CipherTool::CountLanes(aType), std::size_t{0});
            XCTAssertFalse(IS_MASKED(aType) || IS_MUTATE(aType) || IS_ROTATION_ANY(aType));
        }
    }
    XCTAssertEqual(Soccer2Internal::mMaskCursor, aMask);
    XCTAssertEqual(Soccer2Internal::mMaterialIndex, aMaterial);
    XCTAssertEqual(Soccer2Internal::mMaterialQuarter, aQuarter);
}
#endif
- (void)testLayerReversesInterleavedRotationsAndAddition {
    constexpr std::size_t kLength = 256u;
    std::array<std::uint8_t, kLength> aSource{}, aKey{}, aWorker{}, aEncrypted{}, aRestored{};
    for (std::size_t aIndex = 0u; aIndex < kLength; ++aIndex) {
        aSource[aIndex] = static_cast<std::uint8_t>(aIndex * 19u);
        aKey[aIndex] = static_cast<std::uint8_t>(aIndex * 31u + 7u);
    }
    EncryptionLayer aLayer;
    aLayer.AddCipher(new BitRotationCipherA{});
    aLayer.AddCipher(new PasswordAddCipher(aKey.data()));
    aLayer.AddCipher(new RotateCipher(37));
    aLayer.AddCipher(new BitRotationCipherB{});
    XCTAssertTrue(aLayer.SealData(aSource.data(), aWorker.data(), aEncrypted.data(), kLength, nullptr));
    XCTAssertTrue(aLayer.UnsealData(aEncrypted.data(), aWorker.data(), aRestored.data(), kLength, nullptr));
    XCTAssertTrue(aRestored == aSource);
    XCTAssertTrue(aEncrypted != aSource);
}
@end
