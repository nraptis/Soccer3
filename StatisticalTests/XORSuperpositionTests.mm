// Four-query chosen-plaintext regressions against the FULL repeated 1 MiB API.
// Run serially: Soccer3 has process-global mutable state. These tests deliberately
// fail on repeated predictable XOR relations; passing is not a security proof.

#import <XCTest/XCTest.h>
#include "../Scramble/Public/Soccer3.hpp"

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <functional>
#include <random>
#include <vector>

namespace {

using Bytes = std::vector<std::uint8_t>;
using Oracle = std::function<bool(const Bytes &, Bytes &)>;
constexpr std::size_t kBlockBytes = SOCCER_BLOCK_SIZE;
constexpr std::size_t kFixtureCount = 2U;
constexpr std::size_t kDenseTrials = 8U;
constexpr std::size_t kPlaneTrials = 4U;
static_assert(kBlockBytes == (1U << 20U));

struct ClearSoccerOnExit {
    ~ClearSoccerOnExit() { Soccer3::Zero(); }
};

bool SeedFixture(EncryptionStrength pStrength, std::size_t pFixture) {
    constexpr const char *kPasswords[] = {"review-fixture", "second-fixture"};
    constexpr std::uint64_t kNonces[] = {0x2026103001234567ULL, 0xD3B91C764E2085AFULL};
    std::array<std::uint8_t, 14U> aPassword{};
    std::memcpy(aPassword.data(), kPasswords[pFixture], aPassword.size());
    std::uint32_t aAckWord = 0U;
    Soccer3::Zero();
    return Soccer3::AttemptSeed_Encrypt(pStrength, aPassword.data(), aPassword.size(),
                                       kNonces[pFixture], &aAckWord, 0U, nullptr);
}

void Fill(Bytes &pBytes, std::mt19937_64 &pRandom) {
    // Reproducible test data, not a cryptographic RNG.
    for (std::size_t i = 0U; i < pBytes.size(); i += 8U) {
        const std::uint64_t aWord = pRandom();
        std::memcpy(pBytes.data() + i, &aWord, std::min(std::size_t{8U}, pBytes.size() - i));
    }
}

struct SuperpositionResult {
    std::size_t mTrials = 0U;
    std::size_t mQueries = 0U;
    std::size_t mZeroResiduals = 0U;
    std::size_t mMinimumResidualBits = 0U;
    std::size_t mMaximumResidualBits = 0U;
};

// Test E(P) XOR E(P XOR A) XOR E(P XOR B) XOR E(P XOR A XOR B).
// A and B are distinct, nonzero changes. pChangeMask=0xff exercises the
// whole input; a one-bit mask tests a particular input-plane restriction.
// A zero residual for a plane is NOT a claim that the entire cipher is affine.
// Oracle/API errors return false, never an apparently successful security test.
bool MeasureSuperposition(const Oracle &pEncrypt, std::size_t pBytes,
                          std::uint8_t pChangeMask, std::size_t pTrials,
                          std::uint64_t pSeed, SuperpositionResult &pResult) {
    pResult = {};
    if (pBytes < 2U || pChangeMask == 0U || pTrials == 0U) { return false; }
    pResult.mMinimumResidualBits = pBytes * 8U;
    std::mt19937_64 aRandom(pSeed);
    Bytes aBase(pBytes), aA(pBytes), aB(pBytes), aInput(pBytes), aOutput;
    Bytes aResidual(pBytes);
    for (std::size_t trial = 0U; trial < pTrials; ++trial) {
        Fill(aBase, aRandom);
        Fill(aA, aRandom);
        Fill(aB, aRandom);
        for (std::size_t i = 0U; i < pBytes; ++i) {
            aA[i] &= pChangeMask;
            aB[i] &= pChangeMask;
        }
        // Two reserved coordinates ensure all four plaintexts are distinct.
        aA[0] = pChangeMask; aA[1] = 0U;
        aB[0] = 0U; aB[1] = pChangeMask;
        std::fill(aResidual.begin(), aResidual.end(), 0U);
        for (unsigned corner = 0U; corner < 4U; ++corner) {
            for (std::size_t i = 0U; i < pBytes; ++i) {
                aInput[i] = aBase[i] ^ ((corner & 1U) ? aA[i] : 0U)
                                      ^ ((corner & 2U) ? aB[i] : 0U);
            }
            if (!pEncrypt(aInput, aOutput) || aOutput.size() != pBytes) { return false; }
            ++pResult.mQueries;
            for (std::size_t i = 0U; i < pBytes; ++i) { aResidual[i] ^= aOutput[i]; }
        }
        std::size_t aChanged = 0U;
        for (auto byte : aResidual) { aChanged += __builtin_popcount(static_cast<unsigned>(byte)); }
        ++pResult.mTrials;
        pResult.mZeroResiduals += aChanged == 0U;
        pResult.mMinimumResidualBits = std::min(pResult.mMinimumResidualBits, aChanged);
        pResult.mMaximumResidualBits = std::max(pResult.mMaximumResidualBits, aChanged);
    }
    return true;
}

bool RepeatedPredictability(const SuperpositionResult &pResult) {
    // Require repeated independent quartets. This flags a distinguisher for
    // the tested input family, not global affine behavior or key recovery.
    return pResult.mZeroResiduals >= 3U;
}

Oracle ControlOracle(bool pNonlinear, bool pOnlyLowBits = false) {
    return [pNonlinear, pOnlyLowBits](const Bytes &input, Bytes &output) {
        output = input;
        const auto half = input.size() / 2U;
        if (pNonlinear) {
            for (std::size_t i = 0U; i < half; ++i) {
                auto interaction = static_cast<std::uint8_t>(input[i] & input[(i + 1U) % half]);
                if (pOnlyLowBits) { interaction &= 1U; }
                output[half + i] ^= interaction;
            }
        } else {
            // Invertible affine mixing with output XOR offsets.
            for (std::size_t i = 0U; i < half; ++i) { output[half + i] ^= input[i]; }
        }
        for (std::size_t i = 0U; i < output.size(); ++i) {
            output[i] ^= static_cast<std::uint8_t>(i * 37U + 11U);
        }
        return true;
    };
}

} // namespace

@interface XORSuperpositionTests : XCTestCase
@end

@implementation XORSuperpositionTests

- (void)checkStrength:(EncryptionStrength)pStrength {
    for (std::size_t fixture = 0U; fixture < kFixtureCount; ++fixture) {
        ClearSoccerOnExit aCleanup;
        if (!SeedFixture(pStrength, fixture)) {
            XCTFail(@"Superposition fixture %zu failed to seed", fixture); return;
        }
        const Oracle aOracle = [](const Bytes &input, Bytes &output) {
            if (input.size() != kBlockBytes) { return false; }
            Bytes source = input;
            output.resize(kBlockBytes);
            return Soccer3::EncryptBlock(source.data(), output.data());
        };
        // Establish the repeated-plan premise and a functioning inverse first.
        std::mt19937_64 aRandom(0x37B2DC06A49E85F1ULL ^ fixture);
        Bytes aInput(kBlockBytes), aOutput, aRepeated, aRestored(kBlockBytes);
        Fill(aInput, aRandom);
        if (!aOracle(aInput, aOutput) || !aOracle(aInput, aRepeated) ||
            !Soccer3::DecryptBlock(aOutput.data(), aRestored.data())) {
            XCTFail(@"Superposition baseline API failure"); return;
        }
        if (aOutput != aRepeated || aInput != aRestored) {
            XCTFail(@"Superposition requires deterministic encryption and a valid inverse"); return;
        }
        for (unsigned mode = 0U; mode < 9U; ++mode) {
            const auto aMask = static_cast<std::uint8_t>(mode == 0U ? 0xFFU : 1U << (mode - 1U));
            const auto aTrials = mode == 0U ? kDenseTrials : kPlaneTrials;
            SuperpositionResult aResult;
            if (!MeasureSuperposition(aOracle, kBlockBytes, aMask, aTrials,
                                      0xBCE7F04A3298156DULL ^ (fixture << 8U) ^ mode, aResult)) {
                XCTFail(@"Superposition oracle failure, strength=%u fixture=%zu mode=%u",
                        static_cast<unsigned>(pStrength), fixture, mode); return;
            }
            XCTAssertEqual(aResult.mQueries, aTrials * 4U);
            std::printf("XOR superposition: strength=%u fixture=%zu change_mask=0x%02x "
                        "queries=%zu zero_residuals=%zu/%zu residual_bits=%zu..%zu\n",
                        static_cast<unsigned>(pStrength), fixture, static_cast<unsigned>(aMask),
                        aResult.mQueries, aResult.mZeroResiduals, aResult.mTrials,
                        aResult.mMinimumResidualBits, aResult.mMaximumResidualBits);
            XCTAssertFalse(RepeatedPredictability(aResult),
                           @"SECURITY: four-query XOR prediction succeeded %zu/%zu times "
                            "for strength=%u fixture=%zu change_mask=0x%02x; "
                            "this identifies predictable behavior for this input family",
                           aResult.mZeroResiduals, aResult.mTrials, static_cast<unsigned>(pStrength),
                           fixture, static_cast<unsigned>(aMask));
        }
    }
}

- (void)testControlDetectsAffineMixingWithOffsets {
    for (unsigned mode = 0U; mode < 9U; ++mode) {
        SuperpositionResult result;
        const auto mask = static_cast<std::uint8_t>(mode == 0U ? 255U : 1U << (mode - 1U));
        XCTAssertTrue(MeasureSuperposition(ControlOracle(false), 256U, mask, 4U, 1234U + mode, result));
        XCTAssertEqual(result.mZeroResiduals, std::size_t{4U});
        XCTAssertTrue(RepeatedPredictability(result));
    }
}

- (void)testControlDetectsNonlinearInteractions {
    for (unsigned mode = 0U; mode < 9U; ++mode) {
        SuperpositionResult result;
        const auto mask = static_cast<std::uint8_t>(mode == 0U ? 255U : 1U << (mode - 1U));
        XCTAssertTrue(MeasureSuperposition(ControlOracle(true), 256U, mask, 4U, 1234U + mode, result));
        XCTAssertEqual(result.mZeroResiduals, std::size_t{0U});
        XCTAssertFalse(RepeatedPredictability(result));
    }
}

- (void)testControlFindsAnAffinePlaneInsideANonlinearFunction {
    SuperpositionResult dense, highPlane;
    XCTAssertTrue(MeasureSuperposition(ControlOracle(true, true), 256U, 255U, 4U, 1234U, dense));
    XCTAssertTrue(MeasureSuperposition(ControlOracle(true, true), 256U, 128U, 4U, 5678U, highPlane));
    XCTAssertFalse(RepeatedPredictability(dense));
    XCTAssertTrue(RepeatedPredictability(highPlane));
}

- (void)testControlReportsOracleErrors {
    for (std::size_t failAt : {0U, 3U, 7U}) {
        std::size_t calls = 0U;
        const Oracle oracle = [&](const Bytes &input, Bytes &output) {
            if (calls++ == failAt) { return false; }
            output = input; return true;
        };
        SuperpositionResult result;
        XCTAssertFalse(MeasureSuperposition(oracle, 64U, 255U, 4U, 1234U, result));
        XCTAssertEqual(calls, failAt + 1U);
    }
    SuperpositionResult result;
    const Oracle wrongSize = [](const Bytes &, Bytes &output) { output.clear(); return true; };
    XCTAssertFalse(MeasureSuperposition(wrongSize, 64U, 255U, 4U, 1234U, result));
}

- (void)testXORSuperposition_Weak { [self checkStrength:EncryptionStrength::kWeak]; }
- (void)testXORSuperposition_Normal { [self checkStrength:EncryptionStrength::kNormal]; }
- (void)testXORSuperposition_Strong { [self checkStrength:EncryptionStrength::kStrong]; }

@end
