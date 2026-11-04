#import <XCTest/XCTest.h>
#include "Cryptex.hpp"

#include <algorithm>
#include <array>
#include <cstdint>
#include <limits>
#include <memory>
#include <random>
#include <vector>

namespace {
using Bytes = std::vector<std::uint8_t>;
constexpr CipherType kTypes[2][8] = {
    {CipherType::kMixCipherA, CipherType::kMixCipherB, CipherType::kMixCipherC, CipherType::kMixCipherD,
     CipherType::kMixCipherE, CipherType::kMixCipherF, CipherType::kMixCipherG, CipherType::kMixCipherH},
    {CipherType::kSpreadCipherA, CipherType::kSpreadCipherB, CipherType::kSpreadCipherC, CipherType::kSpreadCipherD,
     CipherType::kSpreadCipherE, CipherType::kSpreadCipherF, CipherType::kSpreadCipherG, CipherType::kSpreadCipherH}
};

std::unique_ptr<Cipher> MakeCipher(unsigned pFamily, unsigned pBit, std::int32_t pRotation) {
    switch (kTypes[pFamily][pBit]) {
        case CipherType::kMixCipherA: return std::make_unique<MixCipherA>(pRotation);
        case CipherType::kMixCipherB: return std::make_unique<MixCipherB>(pRotation);
        case CipherType::kMixCipherC: return std::make_unique<MixCipherC>(pRotation);
        case CipherType::kMixCipherD: return std::make_unique<MixCipherD>(pRotation);
        case CipherType::kMixCipherE: return std::make_unique<MixCipherE>(pRotation);
        case CipherType::kMixCipherF: return std::make_unique<MixCipherF>(pRotation);
        case CipherType::kMixCipherG: return std::make_unique<MixCipherG>(pRotation);
        case CipherType::kMixCipherH: return std::make_unique<MixCipherH>(pRotation);
        case CipherType::kSpreadCipherA: return std::make_unique<SpreadCipherA>(pRotation);
        case CipherType::kSpreadCipherB: return std::make_unique<SpreadCipherB>(pRotation);
        case CipherType::kSpreadCipherC: return std::make_unique<SpreadCipherC>(pRotation);
        case CipherType::kSpreadCipherD: return std::make_unique<SpreadCipherD>(pRotation);
        case CipherType::kSpreadCipherE: return std::make_unique<SpreadCipherE>(pRotation);
        case CipherType::kSpreadCipherF: return std::make_unique<SpreadCipherF>(pRotation);
        case CipherType::kSpreadCipherG: return std::make_unique<SpreadCipherG>(pRotation);
        case CipherType::kSpreadCipherH: return std::make_unique<SpreadCipherH>(pRotation);
        default: return nullptr;
    }
}

// Independent byte/bit reference, including signed modulo and window wrapping.
Bytes Reference(const Bytes &pInput, unsigned pFamily, unsigned pBit, std::int32_t pRotation) {
    Bytes output = pInput;
    const std::int64_t windows = pInput.size() / 64U;
    const auto shift = windows == 0 ? 0 : (std::int64_t{pRotation} % windows + windows) % windows;
    for (std::size_t i = 0U; i < pInput.size(); ++i) {
        const auto base = windows == 0 ? 0U : ((i / 64U + shift) % windows) * 64U;
        for (unsigned bit = 0U; bit < 8U; ++bit) {
            if (bit == pBit) { continue; }
            const auto control = pFamily == 0U ? base + (i % 8U) * 8U + bit : (pRotation == 0 ? i : base + i % 64U);
            output[i] ^= ((pInput[control] >> pBit) & 1U) << bit;
        }
    }
    return output;
}
} // namespace

@interface MixSpreadBlockRotationTests : XCTestCase
@end

@implementation MixSpreadBlockRotationTests


- (void)testReferenceInverseUnalignedBuffersAndZero {
    std::mt19937_64 random(0x6B3DA07F94521CE8ULL);
    constexpr std::int32_t rotations[] = {0, 1, -1, 2, 3, 100001, -100001,
        std::numeric_limits<std::int32_t>::min(), std::numeric_limits<std::int32_t>::max()};
    for (auto length : {64U, 128U, 192U, 320U, 16384U}) {
        Bytes input(length);
        for (auto &byte : input) { byte = static_cast<std::uint8_t>(random()); }
        for (unsigned family = 0U; family < 2U; ++family) {
            for (unsigned bit = 0U; bit < 8U; ++bit) {
                for (auto rotation : rotations) {
                    auto cipher = MakeCipher(family, bit, rotation);
                    Bytes source(length + 8U, 0xD3U), encrypted(length + 8U, 0xA5U), restored(length + 8U, 0xB6U);
                    std::copy(input.begin(), input.end(), source.begin() + 1U);
                    const auto savedSource = source;
                    const auto expected = Reference(input, family, bit, rotation);
                    CipherErrorCode error;
                    XCTAssertTrue(cipher->SealData(source.data() + 1U, nullptr, encrypted.data() + 3U, length, &error));
                    XCTAssertEqual(error, CipherErrorCode::kNone);
                    XCTAssertTrue(std::equal(expected.begin(), expected.end(), encrypted.begin() + 3U),
                                  @"family=%u bit=%u rotation=%d length=%u", family, bit, rotation, length);
                    XCTAssertTrue(source == savedSource);
                    XCTAssertTrue(std::all_of(encrypted.begin(), encrypted.begin() + 3U, [](auto b) { return b == 0xA5U; }));
                    XCTAssertTrue(std::all_of(encrypted.begin() + 3U + length, encrypted.end(), [](auto b) { return b == 0xA5U; }));
                    XCTAssertTrue(cipher->UnsealData(encrypted.data() + 3U, nullptr, restored.data() + 5U, length, &error));
                    XCTAssertTrue(std::equal(input.begin(), input.end(), restored.begin() + 5U));
                    XCTAssertTrue(std::all_of(restored.begin(), restored.begin() + 5U, [](auto b) { return b == 0xB6U; }));
                    XCTAssertTrue(std::all_of(restored.begin() + 5U + length, restored.end(), [](auto b) { return b == 0xB6U; }));
                    for (std::size_t i = 0U; i < length; ++i) {
                        if (((encrypted[i + 3U] ^ input[i]) & (1U << bit)) != 0U) {
                            XCTFail(@"Protected control bit changed"); return;
                        }
                    }
                    cipher->Zero();
                    const auto local = Reference(input, family, bit, 0);
                    XCTAssertTrue(cipher->SealData(input.data(), nullptr, encrypted.data(), length, &error));
                    XCTAssertTrue(std::equal(local.begin(), local.end(), encrypted.begin()));
                }
            }
        }
    }
}

- (void)testRotationOneSamplesTheNextWindow {
    Bytes input(128U, 0U), output(128U);
    input[65U] = 1U;
    MixCipherA mix(1);
    XCTAssertTrue(mix.SealData(input.data(), nullptr, output.data(), input.size(), nullptr));
    Bytes expected = input;
    for (std::size_t i = 0U; i < 64U; i += 8U) { expected[i] = 2U; }
    XCTAssertTrue(output == expected);
    SpreadCipherA spread(1);
    XCTAssertTrue(spread.SealData(input.data(), nullptr, output.data(), input.size(), nullptr));
    expected = input;
    expected[1U] = 0xFEU;
    XCTAssertTrue(output == expected);
}

- (void)testValidationAndLegacySpreadLengths {
    Bytes input(192U), output(192U);
    for (std::size_t i = 0U; i < input.size(); ++i) { input[i] = static_cast<std::uint8_t>(i * 53U + 17U); }
    for (unsigned family = 0U; family < 2U; ++family) {
        for (unsigned bit = 0U; bit < 8U; ++bit) {
            auto cipher = MakeCipher(family, bit, 1);
            CipherErrorCode error;
            XCTAssertTrue(cipher->SealData(nullptr, nullptr, nullptr, 0U, &error));
            XCTAssertEqual(error, CipherErrorCode::kNone);
            XCTAssertFalse(cipher->SealData(input.data(), nullptr, output.data(), 65U, &error));
            XCTAssertEqual(error, CipherErrorCode::kInvalidLength);
            XCTAssertFalse(cipher->SealData(nullptr, nullptr, output.data(), 64U, &error));
            XCTAssertEqual(error, CipherErrorCode::kNullBuffer);
            XCTAssertFalse(cipher->SealData(input.data(), nullptr, input.data() + 1U, 128U, &error));
            XCTAssertEqual(error, CipherErrorCode::kAliasedBuffer);
            XCTAssertFalse(cipher->UnsealData(input.data() + 1U, nullptr, input.data(), 128U, &error));
            XCTAssertEqual(error, CipherErrorCode::kAliasedBuffer);
        }
    }
    for (unsigned bit = 0U; bit < 8U; ++bit) {
        auto cipher = MakeCipher(1U, bit, 0);
        for (auto length : {1U, 15U, 16U, 17U, 63U, 65U, 127U}) {
            Bytes source(input.begin(), input.begin() + length), restored(length);
            XCTAssertTrue(cipher->SealData(source.data(), nullptr, output.data(), length, nullptr));
            const auto expected = Reference(source, 1U, bit, 0);
            XCTAssertTrue(std::equal(expected.begin(), expected.end(), output.begin()));
            XCTAssertTrue(cipher->UnsealData(output.data(), nullptr, restored.data(), length, nullptr));
            XCTAssertTrue(restored == source);
        }
    }
}


@end
