#import <XCTest/XCTest.h>
#include "Cryptex.hpp"

#include <algorithm>
#include <array>
#include <limits>
#include <memory>
#include <random>
#include <vector>

namespace {
using Bytes = std::vector<std::uint8_t>;

std::unique_ptr<Cipher> Make(unsigned half, std::size_t rotationA, std::size_t rotationB) {
    if (half == 0U) { return std::make_unique<DanceCipherA>(rotationA, rotationB); }
    return std::make_unique<DanceCipherB>(rotationA, rotationB);
}

// Direct byte-by-byte reference; independent of the SIMD and span traversal.
Bytes Reference(const Bytes &input, unsigned half, std::size_t rotationA, std::size_t rotationB) {
    Bytes output = input;
    const auto windows = input.size() / 64U;
    for (std::size_t i = 0U; i < input.size(); ++i) {
        if ((i % 64U) / 32U == half) { continue; }
        const auto a = ((i / 64U + rotationA % windows) % windows) * 64U + half * 32U + i % 32U;
        const auto b = ((i / 64U + rotationB % windows) % windows) * 64U + half * 32U + i % 32U;
        output[i] ^= static_cast<std::uint8_t>((unsigned(input[a]) + unsigned(input[b])) % 256U);
    }
    return output;
}

const char *CheckCase(const Bytes &input, unsigned half, std::size_t rotationA, std::size_t rotationB) {
    auto cipher = Make(half, rotationA, rotationB);
    const auto type = half == 0U ? CipherType::kDanceCipherA : CipherType::kDanceCipherB;
    if (cipher->mType != type || CipherTool::CountLanes(type) != 0U) { return "type/lanes"; }
    Bytes source(input.size() + 8U, 0xD3U), output(input.size() + 8U, 0xA5U);
    Bytes restored(input.size() + 8U, 0xB6U), worker(32U, 0x79U);
    std::copy(input.begin(), input.end(), source.begin() + 1U);
    const auto savedSource = source, savedWorker = worker;
    const auto expected = Reference(input, half, rotationA, rotationB);
    CipherErrorCode error = CipherErrorCode::kNullCipher;
    if (!cipher->SealData(source.data() + 1U, worker.data(), output.data() + 3U, input.size(), &error) ||
        error != CipherErrorCode::kNone) { return "seal status"; }
    if (!std::equal(expected.begin(), expected.end(), output.begin() + 3U)) { return "reference"; }
    if (source != savedSource || worker != savedWorker) { return "source/worker changed"; }
    if (!std::all_of(output.begin(), output.begin() + 3U, [](auto b) { return b == 0xA5U; }) ||
        !std::all_of(output.begin() + 3U + input.size(), output.end(), [](auto b) { return b == 0xA5U; })) { return "output boundary"; }
    for (std::size_t i = 0U; i < input.size(); ++i) {
        if ((i % 64U) / 32U == half && output[i + 3U] != input[i]) { return "preserved half"; }
    }
    if (!cipher->UnsealData(output.data() + 3U, nullptr, restored.data() + 5U, input.size(), &error) ||
        error != CipherErrorCode::kNone ||
        !std::equal(input.begin(), input.end(), restored.begin() + 5U)) { return "inverse"; }
    if (!std::all_of(restored.begin(), restored.begin() + 5U, [](auto b) { return b == 0xB6U; }) ||
        !std::all_of(restored.begin() + 5U + input.size(), restored.end(), [](auto b) { return b == 0xB6U; })) { return "inverse boundary"; }
    // No state carries from one block execution to the next.
    if (!cipher->SealData(input.data(), nullptr, restored.data(), input.size(), nullptr) ||
        !std::equal(expected.begin(), expected.end(), restored.begin())) { return "repeat execution"; }
    cipher->Zero();
    if (!cipher->SealData(input.data(), nullptr, output.data(), input.size(), &error)) { return "zero status"; }
    const auto reset = Reference(input, half, 0U, 0U);
    if (!std::equal(reset.begin(), reset.end(), output.begin())) { return "zero configuration"; }
    return nullptr;
}
} // namespace

@interface DanceCipherTests : XCTestCase
@end

@implementation DanceCipherTests

- (void)testReferenceInverseHalvesRotationsAndUnalignedBuffers {
    std::mt19937_64 random(0xDA4CE190247ULL);
    const std::array<std::size_t, 2> rotations[] = {{0U, 0U}, {0U, 1U}, {1U, 0U},
        {1U, 2U}, {2U, 1U}, {4U, 4U}, {std::numeric_limits<std::size_t>::max(),
        std::numeric_limits<std::size_t>::max() - 17U}};
    for (std::size_t length : {64U, 128U, 192U, 320U, 1024U}) {
        Bytes input(length);
        for (auto &b : input) { b = static_cast<std::uint8_t>(random()); }
        for (unsigned half = 0U; half < 2U; ++half) {
            for (const auto &rotation : rotations) {
                if (const auto failure = CheckCase(input, half, rotation[0], rotation[1])) {
                    XCTFail(@"%s: half=%u rotations=%zu,%zu length=%zu",
                            failure, half, rotation[0], rotation[1], length);
                    return;
                }
            }
        }
    }
}

- (void)testEveryByteAdditionPairWithoutCarryBetweenBytes {
    for (unsigned half = 0U; half < 2U; ++half) {
        auto cipher = Make(half, 1U, 2U);
        Bytes input(192U, 0xA5U), output(192U);
        for (unsigned base = 0U; base < 65536U; base += 32U) {
            for (unsigned i = 0U; i < 32U; ++i) {
                input[64U + half * 32U + i] = static_cast<std::uint8_t>((base + i) >> 8U);
                input[128U + half * 32U + i] = static_cast<std::uint8_t>(base + i);
            }
            XCTAssertTrue(cipher->SealData(input.data(), nullptr, output.data(), input.size(), nullptr));
            for (unsigned i = 0U; i < 32U; ++i) {
                const unsigned sum = ((base + i) >> 8U) + ((base + i) & 255U);
                XCTAssertEqual(output[(1U - half) * 32U + i], std::uint8_t(0xA5U ^ (sum & 255U)));
                XCTAssertEqual(output[half * 32U + i], input[half * 32U + i]);
            }
        }
    }
}

- (void)testFullSizeIndependentBlocksAndReverseSequence {
    std::mt19937_64 random(739124U);
    for (std::size_t length : {262144U, 524288U, 1048576U}) {
        Bytes input(length);
        for (auto &b : input) { b = static_cast<std::uint8_t>(random()); }
        for (unsigned half = 0U; half < 2U; ++half) {
            const auto failure = CheckCase(input, half, 8193U, 12289U);
            XCTAssertTrue(failure == nullptr, @"%s", failure ? failure : "");
        }
        std::array<std::unique_ptr<Cipher>, 4> sequence = {
            Make(0U, 1U, 3U), Make(1U, 7U, 11U), Make(0U, 8193U, 12289U), Make(1U, 0U, 29U)};
        Bytes current = input, next(length);
        for (const auto &cipher : sequence) {
            XCTAssertTrue(cipher->SealData(current.data(), nullptr, next.data(), length, nullptr));
            current.swap(next);
        }
        for (auto it = sequence.rbegin(); it != sequence.rend(); ++it) {
            XCTAssertTrue((*it)->UnsealData(current.data(), nullptr, next.data(), length, nullptr));
            current.swap(next);
        }
        XCTAssertTrue(current == input);
    }
}

- (void)testCarriesHaveJointEffectAndEqualRotationsDouble {
    // Demonstrates this primitive's carry behavior, not full-plan security.
    for (unsigned half = 0U; half < 2U; ++half) {
        auto cipher = Make(half, 1U, 2U);
        Bytes a(192U, 0U), b(192U, 0U), both(192U, 0U), ea(192U), eb(192U), eab(192U);
        a[64U + half * 32U] = 1U;
        b[128U + half * 32U] = 1U;
        for (std::size_t i = 0U; i < both.size(); ++i) { both[i] = a[i] ^ b[i]; }
        XCTAssertTrue(cipher->SealData(a.data(), nullptr, ea.data(), a.size(), nullptr));
        XCTAssertTrue(cipher->SealData(b.data(), nullptr, eb.data(), b.size(), nullptr));
        XCTAssertTrue(cipher->SealData(both.data(), nullptr, eab.data(), both.size(), nullptr));
        const auto target = (1U - half) * 32U;
        XCTAssertEqual(ea[target], 1U);
        XCTAssertEqual(eb[target], 1U);
        XCTAssertEqual(eab[target], 2U);
        XCTAssertTrue(eab[target] != (ea[target] ^ eb[target]));

        // Rotations 1 and 4 select the same window in this three-window span.
        auto equal = Make(half, 1U, 4U);
        for (std::size_t i = 0U; i < a.size(); ++i) { a[i] = static_cast<std::uint8_t>(i * 73U + 191U); }
        XCTAssertTrue(equal->SealData(a.data(), nullptr, ea.data(), a.size(), nullptr));
        for (unsigned i = 0U; i < 32U; ++i) {
            const auto doubled = static_cast<std::uint8_t>(2U * a[64U + half * 32U + i]);
            XCTAssertEqual(ea[target + i], std::uint8_t(a[target + i] ^ doubled));
        }
    }
}

- (void)testValidationDoesNotWriteOutput {
    Bytes input(256U, 0x71U), output(256U, 0xA5U);
    const auto savedInput = input, savedOutput = output;
    for (unsigned half = 0U; half < 2U; ++half) {
        auto cipher = Make(half, 1U, 2U);
        CipherErrorCode error = CipherErrorCode::kNullCipher;
        XCTAssertTrue(cipher->SealData(nullptr, nullptr, nullptr, 0U, &error));
        XCTAssertEqual(error, CipherErrorCode::kNone);
        XCTAssertTrue(cipher->UnsealData(nullptr, nullptr, nullptr, 0U, nullptr));
        for (bool unseal : {false, true}) {
            auto apply = [&](const std::uint8_t *s, std::uint8_t *d, std::size_t n) {
                return unseal ? cipher->UnsealData(s, nullptr, d, n, &error) : cipher->SealData(s, nullptr, d, n, &error);
            };
            for (std::size_t length : {1U, 31U, 32U, 63U, 65U, 127U}) {
                XCTAssertFalse(apply(input.data(), output.data(), length));
                XCTAssertEqual(error, CipherErrorCode::kInvalidLength);
            }
            XCTAssertFalse(apply(nullptr, output.data(), 64U));
            XCTAssertEqual(error, CipherErrorCode::kNullBuffer);
            XCTAssertFalse(apply(input.data(), nullptr, 64U));
            XCTAssertEqual(error, CipherErrorCode::kNullBuffer);
            for (std::size_t offset : {0U, 1U, 63U}) {
                XCTAssertFalse(apply(input.data(), input.data() + offset, 64U));
                XCTAssertEqual(error, CipherErrorCode::kAliasedBuffer);
                XCTAssertFalse(apply(input.data() + offset, input.data(), 64U));
                XCTAssertEqual(error, CipherErrorCode::kAliasedBuffer);
            }
        }
        XCTAssertTrue(input == savedInput);
        XCTAssertTrue(output == savedOutput);
    }
}

@end
