// Security regressions for the current deterministic, repeated-plan block API.
// These tests intentionally FAIL while the demonstrated weaknesses remain.
// Passing them would rule out only these particular attacks, not prove security.
// Run serially: Soccer3 owns process-global mutable state.

#import <XCTest/XCTest.h>

// Use only the public API, even though the test target also exposes internals.
#include "Soccer3.hpp"

#include <array>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <functional>
#include <random>
#include <vector>

namespace {

constexpr std::size_t kBlockBytes = SOCCER_BLOCK_SIZE;
constexpr unsigned int kAddressBits = 20U;
static_assert(kBlockBytes == (std::size_t{1} << kAddressBits));
using Bytes = std::vector<std::uint8_t>;
using EncryptOracle = std::function<bool(Bytes &, Bytes &)>;

struct ClearSoccerOnExit {
    ~ClearSoccerOnExit() { Soccer3::Zero(); }
};

bool SeedFixture(EncryptionStrength pStrength) {
    // The fixture owns the password; the attack helpers below never receive it.
    std::array<std::uint8_t, 14U> aPassword = {
        'r', 'e', 'v', 'i', 'e', 'w', '-', 'f', 'i', 'x', 't', 'u', 'r', 'e'
    };
    std::uint32_t aAckWord = 0U;
    return Soccer3::AttemptSeed_Encrypt(pStrength, aPassword.data(),
                                       aPassword.size(), 0x2026103001234567ULL,
                                       &aAckWord, 0U, nullptr);
}

Bytes MakePlaintext(std::uint64_t pFixtureSeed) {
    // Reproducible test data, not a cryptographic random-number generator.
    std::mt19937_64 aRandom(pFixtureSeed);
    Bytes aPlaintext(kBlockBytes);
    for (auto &aByte : aPlaintext) {
        aByte = static_cast<std::uint8_t>(aRandom());
    }
    return aPlaintext;
}

struct LowBitModel {
    Bytes mMask;
    std::vector<std::uint32_t> mSourceForOutput;
    std::size_t mQueryCount = 0U;
    bool mIsPermutation = false;
};

// The attacker learns only from chosen-plaintext encryption responses.
// No password, material, plan, or held-out plaintext is accessible here.
// false means an oracle/API error, not that the attack was defeated.
bool LearnLowBitModel(const EncryptOracle &pEncrypt, LowBitModel &pModel) {
    pModel = LowBitModel{};
    Bytes aQuery(kBlockBytes, 0U);
    Bytes aResponse(kBlockBytes);
    if (!pEncrypt(aQuery, aResponse)) {
        return false;
    }
    ++pModel.mQueryCount;
    pModel.mMask.resize(kBlockBytes);
    pModel.mSourceForOutput.assign(kBlockBytes, 0U);
    for (std::size_t j = 0U; j < kBlockBytes; ++j) {
        pModel.mMask[j] = aResponse[j] & 1U; // E(0) reveals the effective LSB mask.
    }

    for (unsigned int t = 0U; t < kAddressBits; ++t) {
        for (std::size_t i = 0U; i < kBlockBytes; ++i) {
            aQuery[i] = static_cast<std::uint8_t>((i >> t) & 1U);
        }
        if (!pEncrypt(aQuery, aResponse)) {
            return false;
        }
        ++pModel.mQueryCount;
        for (std::size_t j = 0U; j < kBlockBytes; ++j) {
            const std::uint32_t aAddressBit =
                (aResponse[j] ^ pModel.mMask[j]) & 1U;
            pModel.mSourceForOutput[j] |= aAddressBit << t;
        }
    }

    Bytes aSeen(kBlockBytes, 0U);
    for (const auto aSource : pModel.mSourceForOutput) {
        if (aSource >= kBlockBytes || aSeen[aSource] != 0U) {
            // A changed construction need not have this permutation form.
            return true;
        }
        aSeen[aSource] = 1U;
    }
    pModel.mIsPermutation = true;
    return true;
}

// Recovery uses the learned model and ciphertext only. Ground truth is used
// later by XCTest to measure recovery, never to choose this output.
Bytes RecoverLowBits(const LowBitModel &pModel, const Bytes &pCiphertext) {
    Bytes aRecovered(kBlockBytes);
    for (std::size_t j = 0U; j < kBlockBytes; ++j) {
        aRecovered[pModel.mSourceForOutput[j]] =
            (pCiphertext[j] ^ pModel.mMask[j]) & 1U;
    }
    return aRecovered;
}

} // namespace

@interface RepeatedPlanSecurityTests : XCTestCase
@end

@implementation RepeatedPlanSecurityTests

- (void)checkSingleHighBitForStrength:(EncryptionStrength)pStrength {
    ClearSoccerOnExit aCleanup;
    if (!SeedFixture(pStrength)) {
        XCTFail(@"Fixture setup failed for strength %u", static_cast<unsigned>(pStrength));
        return;
    }

    Bytes aPlaintext = MakePlaintext(0x20261030ULL);
    Bytes aCiphertext(kBlockBytes);
    Bytes aRestored(kBlockBytes);
    if (!Soccer3::EncryptBlock(aPlaintext.data(), aCiphertext.data()) ||
        !Soccer3::DecryptBlock(aCiphertext.data(), aRestored.data())) {
        XCTFail(@"Baseline encrypt/decrypt API call failed");
        return;
    }
    if (aRestored != aPlaintext) {
        XCTFail(@"Baseline inverse failed; cannot interpret the security probe");
        return;
    }

    // Exercise vector, quarter, half, and full-block boundaries without reseeding.
    constexpr std::array<std::size_t, 8U> aPositions = {
        0U, 15U, 32U, 262143U, 262144U, 524287U, 524288U, kBlockBytes - 1U
    };
    Bytes aChangedPlaintext;
    Bytes aChangedCiphertext(kBlockBytes);
    std::size_t aSingleBitCases = 0U;
    for (const auto aPosition : aPositions) {
        aChangedPlaintext = aPlaintext;
        aChangedPlaintext[aPosition] ^= 0x80U;
        if (!Soccer3::EncryptBlock(aChangedPlaintext.data(), aChangedCiphertext.data())) {
            XCTFail(@"Differential encryption API call failed");
            return;
        }
        std::size_t aChangedBits = 0U;
        std::size_t aLastChangedByte = 0U;
        for (std::size_t j = 0U; j < kBlockBytes; ++j) {
            const unsigned int aDelta = aCiphertext[j] ^ aChangedCiphertext[j];
            aChangedBits += static_cast<std::size_t>(__builtin_popcount(aDelta));
            if (aDelta != 0U) {
                aLastChangedByte = j;
            }
        }
        std::printf("Single-bit probe: strength=%u input=%zu changed_bits=%zu last_changed_byte=%zu\n",
                    static_cast<unsigned>(pStrength), aPosition, aChangedBits, aLastChangedByte);
        if (aChangedBits == 0U) {
            XCTFail(@"Distinct inputs produced identical ciphertexts");
            return;
        }
        aSingleBitCases += (aChangedBits == 1U);
    }

    // This is a regression for Soccer's claimed large-block composition, not
    // a general rule for stream ciphers or a proof that >1 bit is sufficient.
    XCTAssertEqual(aSingleBitCases, std::size_t{0U},
                   @"SECURITY: %zu/%zu input MSB flips survived as exactly one ciphertext bit under strength %u",
                   aSingleBitCases, aPositions.size(), static_cast<unsigned>(pStrength));
}

- (void)checkTwentyOneQueryAttackForStrength:(EncryptionStrength)pStrength {
    ClearSoccerOnExit aCleanup;
    if (!SeedFixture(pStrength)) {
        XCTFail(@"Fixture setup failed for strength %u", static_cast<unsigned>(pStrength));
        return;
    }

    LowBitModel aModel;
    const EncryptOracle aOracle = [](Bytes &pQuery, Bytes &pResponse) {
        return Soccer3::EncryptBlock(pQuery.data(), pResponse.data());
    };
    if (!LearnLowBitModel(aOracle, aModel)) {
        XCTFail(@"Training encryption API call failed");
        return;
    }
    XCTAssertEqual(aModel.mQueryCount, std::size_t{21U});
    if (!aModel.mIsPermutation) {
        std::printf("21-query probe: strength=%u model is not a permutation; this specific attack did not learn a valid map\n",
                    static_cast<unsigned>(pStrength));
        return;
    }

    // Only after training, create an independent challenge block. Its encryption
    // supplies the target ciphertext and is NOT one of the 21 training queries.
    Bytes aPlaintext = MakePlaintext(0xD6E8FEB86659FD93ULL);
    Bytes aCiphertext(kBlockBytes);
    Bytes aRestored(kBlockBytes);
    if (!Soccer3::EncryptBlock(aPlaintext.data(), aCiphertext.data()) ||
        !Soccer3::DecryptBlock(aCiphertext.data(), aRestored.data())) {
        XCTFail(@"Challenge encrypt/decrypt API call failed");
        return;
    }
    if (aRestored != aPlaintext) {
        XCTFail(@"Challenge inverse failed; cannot interpret recovery");
        return;
    }
    const Bytes aRecovered = RecoverLowBits(aModel, aCiphertext);
    std::size_t aCorrectBits = 0U;
    for (std::size_t i = 0U; i < kBlockBytes; ++i) {
        aCorrectBits += (aRecovered[i] == (aPlaintext[i] & 1U));
    }
    std::printf("21-query probe: strength=%u training_queries=%zu recovered_low_bits=%zu/%zu (%.6f%%); inverse OK\n",
                static_cast<unsigned>(pStrength), aModel.mQueryCount, aCorrectBits,
                kBlockBytes, 100.0 * static_cast<double>(aCorrectBits) / kBlockBytes);

    // Deliberately red when the attack succeeds. Partial leakage could also be
    // serious; this assertion detects the demonstrated complete-LSB recovery.
    XCTAssertLessThan(aCorrectBits, kBlockBytes,
                      @"SECURITY: 21 chosen plaintexts recovered every plaintext LSB (%zu bits) under strength %u without the password or ARX state",
                      aCorrectBits, static_cast<unsigned>(pStrength));
}

- (void)testSingleHighBit_Weak {
    [self checkSingleHighBitForStrength:EncryptionStrength::kWeak];
}
- (void)testSingleHighBit_Normal {
    [self checkSingleHighBitForStrength:EncryptionStrength::kNormal];
}
- (void)testSingleHighBit_Strong {
    [self checkSingleHighBitForStrength:EncryptionStrength::kStrong];
}
- (void)testTwentyOneQueryRecovery_Weak {
    [self checkTwentyOneQueryAttackForStrength:EncryptionStrength::kWeak];
}
- (void)testTwentyOneQueryRecovery_Normal {
    [self checkTwentyOneQueryAttackForStrength:EncryptionStrength::kNormal];
}
- (void)testTwentyOneQueryRecovery_Strong {
    [self checkTwentyOneQueryAttackForStrength:EncryptionStrength::kStrong];
}

@end
