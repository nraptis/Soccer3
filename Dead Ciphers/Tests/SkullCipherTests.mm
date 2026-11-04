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
constexpr CipherType kTypes[] = {CipherType::kSkullCipherA, CipherType::kSkullCipherB,
    CipherType::kSkullCipherC, CipherType::kSkullCipherD};

std::unique_ptr<Cipher> Make(unsigned variant, std::size_t rowA, std::size_t rotationA,
                             std::size_t rowB, std::size_t rotationB) {
    switch (variant) {
        case 0: return std::make_unique<SkullCipherA>(rowA, rotationA, rowB, rotationB);
        case 1: return std::make_unique<SkullCipherB>(rowA, rotationA, rowB, rotationB);
        case 2: return std::make_unique<SkullCipherC>(rowA, rotationA, rowB, rotationB);
        default: return std::make_unique<SkullCipherD>(rowA, rotationA, rowB, rotationB);
    }
}

// Literal byte layouts: 0..7 identify a0..a7; 8..15 identify b0..b7.
constexpr unsigned kLayout[4][16] = {
    {0,8,1,9,2,10,3,11,12,4,13,5,14,6,15,7},
    {4,12,5,13,6,14,7,15,8,0,9,1,10,2,11,3},
    {8,0,9,1,10,2,11,3,4,12,5,13,6,14,7,15},
    {12,4,13,5,14,6,15,7,0,8,1,9,2,10,3,11}
};

// Direct source-bit-to-destination-bit reference, with no packed work mask.
Bytes Reference(const Bytes &input, unsigned variant, std::size_t rowA, std::size_t rotationA,
                std::size_t rowB, std::size_t rotationB) {
    Bytes output = input;
    const auto windows = input.size() / 64U;
    for (std::size_t i = 0U; i < input.size(); ++i) {
        const auto origin = kLayout[variant][i % 16U];
        const auto row = origin < 8U ? rowA : rowB;
        const auto rotation = origin < 8U ? rotationA : rotationB;
        const auto base = ((i / 64U + rotation % windows) % windows) * 64U;
        for (unsigned bit = 0U; bit < 8U; ++bit) {
            if (bit == rowA || bit == rowB) { continue; }
            output[i] ^= static_cast<std::uint8_t>(((input[base + 8U*(origin % 8U) + bit] >> row) & 1U) << bit);
        }
    }
    return output;
}

// Also used by the standalone sanitizer check; returns the failed property.
const char *CheckCase(const Bytes &input, unsigned variant, std::size_t rowA, std::size_t rotationA,
                      std::size_t rowB, std::size_t rotationB) {
    auto cipher = Make(variant, rowA, rotationA, rowB, rotationB);
    if (cipher->mType != kTypes[variant] || CipherTool::CountLanes(cipher->mType) != 0U) { return "type/lanes"; }
    Bytes source(input.size() + 8U, 0xD3U), output(input.size() + 8U, 0xA5U), restored(input.size() + 8U, 0xB6U);
    std::copy(input.begin(), input.end(), source.begin() + 1U);
    const auto savedSource = source;
    const auto expected = Reference(input, variant, rowA, rotationA, rowB, rotationB);
    CipherErrorCode error = CipherErrorCode::kNullCipher;
    if (!cipher->SealData(source.data() + 1U, nullptr, output.data() + 3U, input.size(), &error) ||
        error != CipherErrorCode::kNone) { return "seal status"; }
    if (!std::equal(expected.begin(), expected.end(), output.begin() + 3U)) { return "reference"; }
    if (source != savedSource) { return "source changed"; }
    if (!std::all_of(output.begin(), output.begin() + 3U, [](auto b) { return b == 0xA5U; }) ||
        !std::all_of(output.begin() + 3U + input.size(), output.end(), [](auto b) { return b == 0xA5U; })) { return "output boundary"; }
    const auto protectedBits = (1U << rowA) | (1U << rowB);
    for (std::size_t i = 0U; i < input.size(); ++i) {
        if (((input[i] ^ output[i + 3U]) & protectedBits) != 0U) { return "protected row"; }
    }
    if (!cipher->UnsealData(output.data() + 3U, nullptr, restored.data() + 5U, input.size(), &error) ||
        !std::equal(input.begin(), input.end(), restored.begin() + 5U)) { return "inverse"; }
    if (!std::all_of(restored.begin(), restored.begin() + 5U, [](auto b) { return b == 0xB6U; }) ||
        !std::all_of(restored.begin() + 5U + input.size(), restored.end(), [](auto b) { return b == 0xB6U; })) { return "inverse boundary"; }
    cipher->Zero();
    if (!cipher->SealData(input.data(), nullptr, output.data(), input.size(), &error)) { return "zero status"; }
    const auto reset = Reference(input, variant, 0U, 0U, 1U, 0U);
    if (!std::equal(reset.begin(), reset.end(), output.begin())) { return "zero configuration"; }
    return nullptr;
}
} // namespace

@interface SkullCipherTests : XCTestCase
@end

@implementation SkullCipherTests

- (void)testReferenceInverseRowsRotationsAndUnalignedBuffers {
    std::mt19937_64 random(0x43A1927DF652BC80ULL);
    const std::array<std::size_t, 2> rotations[] = {{0U, 0U}, {1U, 2U}, {4U, 1U},
        {std::numeric_limits<std::size_t>::max(), std::numeric_limits<std::size_t>::max() - 17U}};
    for (std::size_t length : {64U, 192U, 320U, 1024U}) {
        Bytes input(length);
        for (auto &b : input) { b = static_cast<std::uint8_t>(random()); }
        for (unsigned variant = 0U; variant < 4U; ++variant) {
            for (unsigned rowA = 0U; rowA < 8U; ++rowA) {
                for (unsigned rowB = 0U; rowB < 8U; ++rowB) {
                    if (rowA == rowB) { continue; }
                    for (const auto &rotation : rotations) {
                        if (const auto failure = CheckCase(input, variant, rowA, rotation[0], rowB, rotation[1])) {
                            XCTFail(@"%s: variant=%u rows=%u,%u rotations=%zu,%zu length=%zu",
                                    failure, variant, rowA, rowB, rotation[0], rotation[1], length);
                            return;
                        }
                    }
                }
            }
        }
    }
}

- (void)testFullSizeIndependentBlocks {
    std::mt19937_64 random(482917U);
    Bytes input(1U << 20U);
    for (auto &b : input) { b = static_cast<std::uint8_t>(random()); }
    for (unsigned variant = 0U; variant < 4U; ++variant) {
        const auto failure = CheckCase(input, variant, variant, 8193U, variant + 4U, 12289U);
        XCTAssertTrue(failure == nullptr, @"%s", failure ? failure : "");
        auto cipher = Make(variant, variant, 8193U, variant + 4U, 12289U);
        Bytes first(input.size()), second(input.size());
        XCTAssertTrue(cipher->SealData(input.data(), nullptr, first.data(), input.size(), nullptr));
        XCTAssertTrue(cipher->SealData(input.data(), nullptr, second.data(), input.size(), nullptr));
        XCTAssertTrue(first == second);
    }
}

- (void)testExactFourLayoutsRepeatedAcrossWindow {
    constexpr std::uint8_t packedA[] = {0x02,0x04,0x06,0x08,0x0A,0x0C,0x0E,0x10};
    constexpr std::uint8_t packedB[] = {0x20,0x22,0x24,0x26,0x28,0x2A,0x2C,0x2E};
    constexpr std::uint8_t expected[4][16] = {
        {0x02,0x20,0x04,0x22,0x06,0x24,0x08,0x26,0x28,0x0A,0x2A,0x0C,0x2C,0x0E,0x2E,0x10},
        {0x0A,0x28,0x0C,0x2A,0x0E,0x2C,0x10,0x2E,0x20,0x02,0x22,0x04,0x24,0x06,0x26,0x08},
        {0x20,0x02,0x22,0x04,0x24,0x06,0x26,0x08,0x0A,0x28,0x0C,0x2A,0x0E,0x2C,0x10,0x2E},
        {0x28,0x0A,0x2A,0x0C,0x2C,0x0E,0x2E,0x10,0x02,0x20,0x04,0x22,0x06,0x24,0x08,0x26}
    };
    Bytes input(192U, 0U), output(192U);
    std::fill(input.begin(), input.begin() + 64U, 0x39U);
    for (unsigned g = 0U; g < 8U; ++g) {
        for (unsigned bit = 0U; bit < 8U; ++bit) {
            input[64U + 8U*g + bit] = (packedA[g] >> bit) & 1U;
            input[128U + 8U*g + bit] = static_cast<std::uint8_t>(((packedB[g] >> bit) & 1U) << 7U);
        }
    }
    for (unsigned variant = 0U; variant < 4U; ++variant) {
        auto cipher = Make(variant, 0U, 1U, 7U, 2U);
        XCTAssertTrue(cipher->SealData(input.data(), nullptr, output.data(), input.size(), nullptr));
        for (std::size_t i = 0U; i < 64U; ++i) {
            XCTAssertEqual(output[i], static_cast<std::uint8_t>(input[i] ^ expected[variant][i % 16U]));
        }
    }
}

- (void)testEveryControlBitAndProtectedMaskPositions {
    for (unsigned variant = 0U; variant < 4U; ++variant) {
        auto cipher = Make(variant, 2U, 1U, 6U, 2U);
        for (unsigned stream = 0U; stream < 2U; ++stream) {
            for (unsigned position = 0U; position < 64U; ++position) {
                Bytes input(192U, 0U), output(192U);
                const unsigned row = stream == 0U ? 2U : 6U;
                input[64U * (stream + 1U) + position] = 1U << row;
                XCTAssertTrue(cipher->SealData(input.data(), nullptr, output.data(), input.size(), nullptr));
                XCTAssertTrue(output == Reference(input, variant, 2U, 1U, 6U, 2U));
                unsigned changes = 0U;
                for (std::size_t i = 0U; i < 64U; ++i) { changes += __builtin_popcount(output[i]); }
                const bool masked = position % 8U == 2U || position % 8U == 6U;
                XCTAssertEqual(changes, masked ? 0U : 4U);
            }
        }
    }
}

- (void)testSpecifiedLinearityAndQuarterParity {
    // These are limitations of the specified XOR mixer, not security passes.
    std::mt19937_64 random(19283U);
    Bytes x(320U), y(320U), xy(320U), ex(320U), ey(320U), exy(320U);
    for (std::size_t i = 0U; i < x.size(); ++i) {
        x[i] = static_cast<std::uint8_t>(random());
        y[i] = static_cast<std::uint8_t>(random());
        xy[i] = x[i] ^ y[i];
    }
    for (unsigned variant = 0U; variant < 4U; ++variant) {
        auto cipher = Make(variant, 1U, 2U, 5U, 4U);
        XCTAssertTrue(cipher->SealData(x.data(), nullptr, ex.data(), x.size(), nullptr));
        XCTAssertTrue(cipher->SealData(y.data(), nullptr, ey.data(), y.size(), nullptr));
        XCTAssertTrue(cipher->SealData(xy.data(), nullptr, exy.data(), xy.size(), nullptr));
        for (std::size_t i = 0U; i < x.size(); ++i) { XCTAssertEqual(exy[i], std::uint8_t(ex[i] ^ ey[i])); }
        for (std::size_t w = 0U; w < x.size(); w += 64U) {
            for (unsigned i = 0U; i < 16U; ++i) {
                for (unsigned q = 1U; q < 4U; ++q) {
                    XCTAssertEqual(ex[w+i] ^ ex[w+i+16U*q], x[w+i] ^ x[w+i+16U*q]);
                }
            }
        }
    }
}

- (void)testValidationDoesNotWriteOutput {
    Bytes input(256U, 0x71U), output(256U, 0xA5U);
    const auto savedInput = input, savedOutput = output;
    for (unsigned variant = 0U; variant < 4U; ++variant) {
        auto cipher = Make(variant, 0U, 1U, 7U, 2U);
        CipherErrorCode error = CipherErrorCode::kNullCipher;
        XCTAssertTrue(cipher->SealData(nullptr, nullptr, nullptr, 0U, &error));
        XCTAssertEqual(error, CipherErrorCode::kNone);
        XCTAssertTrue(cipher->UnsealData(nullptr, nullptr, nullptr, 0U, nullptr));
        for (bool unseal : {false, true}) {
            auto apply = [&](Cipher &c, const std::uint8_t *s, std::uint8_t *d, std::size_t n) {
                return unseal ? c.UnsealData(s, nullptr, d, n, &error) : c.SealData(s, nullptr, d, n, &error);
            };
            for (std::size_t length : {1U, 63U, 65U, 127U}) {
                XCTAssertFalse(apply(*cipher, input.data(), output.data(), length));
                XCTAssertEqual(error, CipherErrorCode::kInvalidLength);
            }
            for (auto rows : {std::array<std::size_t, 2>{0U, 0U}, {8U, 1U}, {0U, 8U},
                              {std::numeric_limits<std::size_t>::max(), 1U}}) {
                auto invalid = Make(variant, rows[0], 0U, rows[1], 0U);
                XCTAssertFalse(apply(*invalid, input.data(), output.data(), 64U));
                XCTAssertEqual(error, CipherErrorCode::kInvalidParameter);
            }
            XCTAssertFalse(apply(*cipher, nullptr, output.data(), 64U));
            XCTAssertEqual(error, CipherErrorCode::kNullBuffer);
            XCTAssertFalse(apply(*cipher, input.data(), nullptr, 64U));
            XCTAssertEqual(error, CipherErrorCode::kNullBuffer);
            for (std::size_t offset : {0U, 1U, 63U}) {
                XCTAssertFalse(apply(*cipher, input.data(), input.data() + offset, 64U));
                XCTAssertEqual(error, CipherErrorCode::kAliasedBuffer);
                XCTAssertFalse(apply(*cipher, input.data() + offset, input.data(), 64U));
                XCTAssertEqual(error, CipherErrorCode::kAliasedBuffer);
            }
        }
        XCTAssertTrue(input == savedInput);
        XCTAssertTrue(output == savedOutput);
    }
}

@end
