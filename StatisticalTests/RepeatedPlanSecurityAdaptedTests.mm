// Adapted chosen-plaintext regressions for repeated, independently encrypted
// 1 MiB blocks. Run serially: Soccer3 owns process-global mutable state.
// Security tests intentionally FAIL when the measured leakage remains.
// Passing rules out only these probes for this fixture, not other attacks.

#import <XCTest/XCTest.h>

// Attack helpers receive only encryption responses, never Soccer3 internals.
#include "Soccer3.hpp"

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <functional>
#include <numeric>
#include <random>
#include <vector>

namespace {

constexpr std::size_t kBlockBytes = SOCCER_BLOCK_SIZE;
constexpr std::size_t kValidationQueries = 64U;
constexpr std::size_t kChallengeBlocks = 8U;
constexpr std::size_t kMinimumRecoveredBits = 128U;
static_assert(kBlockBytes == (std::size_t{1U} << 20U));
using Bytes = std::vector<std::uint8_t>;
using EncryptOracle = std::function<bool(const Bytes &, Bytes &)>;

struct ClearSoccerOnExit {
    ~ClearSoccerOnExit() { Soccer3::Zero(); }
};

bool SeedFixture(EncryptionStrength pStrength) {
    // Same seed fixture as RepeatedPlanSecurityTests, for direct comparison.
    std::array<std::uint8_t, 14U> aPassword = {
        'r', 'e', 'v', 'i', 'e', 'w', '-', 'f', 'i', 'x', 't', 'u', 'r', 'e'
    };
    std::uint32_t aAckWord = 0U;
    return Soccer3::AttemptSeed_Encrypt(pStrength, aPassword.data(),
                                       aPassword.size(), 0x2026103001234567ULL,
                                       &aAckWord, 0U, nullptr);
}

void FillPlaintext(Bytes &pPlaintext, std::mt19937_64 &pRandom) {
    // Reproducible test inputs, not a cryptographic random-number generator.
    for (auto &aByte : pPlaintext) {
        aByte = static_cast<std::uint8_t>(pRandom());
    }
}

std::uint8_t Bit(const Bytes &pBytes, std::size_t pBit) {
    return (pBytes[pBit >> 3U] >> (pBit & 7U)) & 1U;
}

struct BitMapping {
    std::uint32_t mSource; // Plaintext bit address, including its bit-in-byte.
    std::uint32_t mOutput; // Ciphertext bit address; need not have the same bit-in-byte.
};

struct CrossBitModel {
    Bytes mZeroCiphertext;
    std::vector<BitMapping> mMappings;
    std::size_t mMappingQueries = 0U;
    std::size_t mValidationQueries = 0U;
    std::size_t mSurvivingOutputBits = 0U;
};

// Generalize the original address attack from 2^20 bytes to 2^23 bits:
//   1. E(0) supplies candidate output polarities.
//   2. 23 binary-address queries label EVERY input bit, including all 8 planes.
//   3. Keep candidate C[output] = P[source] XOR E(0)[output] relations only if
//      they predict all 64 additional random chosen-plaintext responses.
//   4. Deduplicate plaintext addresses BEFORE seeing any challenge plaintext.
// No global permutation is required: a surviving subset can still leak data.
// False means an invalid size or oracle failure, never a defeated attack.
bool LearnCrossBitModel(const EncryptOracle &pEncrypt, std::size_t pBlockBytes,
                        CrossBitModel &pModel) {
    pModel = CrossBitModel{};
    if (pBlockBytes == 0U || pBlockBytes > kBlockBytes ||
        (pBlockBytes & (pBlockBytes - 1U)) != 0U) {
        return false;
    }
    const std::size_t aBitCount = pBlockBytes * 8U;
    unsigned int aAddressBits = 0U;
    for (std::size_t aCount = aBitCount; aCount > 1U; aCount >>= 1U) {
        ++aAddressBits;
    }
    Bytes aQuery(pBlockBytes, 0U);
    Bytes aResponse(pBlockBytes);
    if (!pEncrypt(aQuery, aResponse) || aResponse.size() != pBlockBytes) {
        return false;
    }
    ++pModel.mMappingQueries;
    pModel.mZeroCiphertext = aResponse;

    {
        std::vector<std::uint32_t> aSources(aBitCount, 0U);
        for (unsigned int t = 0U; t < aAddressBits; ++t) {
            if (t < 3U) {
                // Binary labels of the bit position inside each byte.
                constexpr std::uint8_t kBitLabels[] = {0xAAU, 0xCCU, 0xF0U};
                std::fill(aQuery.begin(), aQuery.end(), kBitLabels[t]);
            } else {
                for (std::size_t i = 0U; i < pBlockBytes; ++i) {
                    aQuery[i] = ((i >> (t - 3U)) & 1U) != 0U ? 0xFFU : 0U;
                }
            }
            if (!pEncrypt(aQuery, aResponse) || aResponse.size() != pBlockBytes) {
                return false;
            }
            ++pModel.mMappingQueries;
            for (std::size_t j = 0U; j < pBlockBytes; ++j) {
                const unsigned int aDelta = aResponse[j] ^ pModel.mZeroCiphertext[j];
                for (unsigned int b = 0U; b < 8U; ++b) {
                    aSources[j * 8U + b] |= ((aDelta >> b) & 1U) << t;
                }
            }
        }
        pModel.mMappings.reserve(aBitCount);
        for (std::size_t j = 0U; j < aBitCount; ++j) {
            pModel.mMappings.push_back({aSources[j], static_cast<std::uint32_t>(j)});
        }
    }

    std::mt19937_64 aValidationRandom(0xA0761D6478BD642FULL);
    for (std::size_t q = 0U; q < kValidationQueries; ++q) {
        FillPlaintext(aQuery, aValidationRandom);
        if (!pEncrypt(aQuery, aResponse) || aResponse.size() != pBlockBytes) {
            return false;
        }
        ++pModel.mValidationQueries;
        std::erase_if(pModel.mMappings, [&](const BitMapping &pMapping) {
            return (Bit(aResponse, pMapping.mOutput) ^
                    Bit(pModel.mZeroCiphertext, pMapping.mOutput)) !=
                   Bit(aQuery, pMapping.mSource);
        });
    }
    pModel.mSurvivingOutputBits = pModel.mMappings.size();
    Bytes aSeen(pBlockBytes, 0U);
    std::erase_if(pModel.mMappings, [&](const BitMapping &pMapping) {
        const std::uint8_t aMask = static_cast<std::uint8_t>(1U << (pMapping.mSource & 7U));
        auto &aSeenByte = aSeen[pMapping.mSource >> 3U];
        const bool aDuplicate = (aSeenByte & aMask) != 0U;
        aSeenByte |= aMask;
        return aDuplicate;
    });
    return true;
}

// One prediction per preselected, UNIQUE plaintext bit, in mMappings order.
// Unknown bits are omitted, not silently filled with zero or counted as correct.
// This function has no access to the oracle, plaintext, password, or ARX state.
Bytes RecoverSelectedBits(const CrossBitModel &pModel, const Bytes &pCiphertext) {
    Bytes aRecovered;
    aRecovered.reserve(pModel.mMappings.size());
    for (const auto &aMapping : pModel.mMappings) {
        aRecovered.push_back(Bit(pCiphertext, aMapping.mOutput) ^
                             Bit(pModel.mZeroCiphertext, aMapping.mOutput));
    }
    return aRecovered;
}

// Deterministic toy controls for the attack harness, not proposed encryption.
// An arbitrary byte substitution removes direct single-input-bit relations;
// an odd address multiplier permutes bit positions across bytes and planes.
EncryptOracle MakeControlOracle(std::size_t pUnsubstitutedBytes) {
    std::array<std::uint8_t, 256U> aSubstitution;
    std::iota(aSubstitution.begin(), aSubstitution.end(), std::uint8_t{0U});
    std::mt19937_64 aRandom(0xE7037ED1A0B428DBULL);
    std::shuffle(aSubstitution.begin(), aSubstitution.end(), aRandom);
    return [aSubstitution, pUnsubstitutedBytes](const Bytes &pInput, Bytes &pOutput) {
        Bytes aTransformed = pInput;
        for (std::size_t i = pUnsubstitutedBytes; i < pInput.size(); ++i) {
            aTransformed[i] = aSubstitution[pInput[i]];
        }
        pOutput.assign(pInput.size(), 0U);
        const std::size_t aBitCount = pInput.size() * 8U;
        for (std::size_t j = 0U; j < aBitCount; ++j) {
            const std::size_t aSource = (j * 73U + 19U) % aBitCount;
            pOutput[j >> 3U] |= Bit(aTransformed, aSource) << (j & 7U);
        }
        for (std::size_t j = 0U; j < pOutput.size(); ++j) {
            pOutput[j] ^= static_cast<std::uint8_t>(j * 37U + 11U);
        }
        return true;
    };
}

} // namespace

@interface RepeatedPlanSecurityAdaptedTests : XCTestCase
@end

@implementation RepeatedPlanSecurityAdaptedTests

- (void)checkCrossBitRecoveryForStrength:(EncryptionStrength)pStrength {
    ClearSoccerOnExit aCleanup;
    if (!SeedFixture(pStrength)) {
        XCTFail(@"Fixture setup failed for strength %u", static_cast<unsigned>(pStrength));
        return;
    }
    const EncryptOracle aOracle = [](const Bytes &pInput, Bytes &pOutput) {
        Bytes aSource = pInput; // The public API accepts a mutable source buffer.
        return Soccer3::EncryptBlock(aSource.data(), pOutput.data());
    };
    CrossBitModel aModel;
    if (!LearnCrossBitModel(aOracle, kBlockBytes, aModel)) {
        XCTFail(@"Adapted attack training oracle failed");
        return;
    }
    XCTAssertEqual(aModel.mMappingQueries, std::size_t{24U});
    XCTAssertEqual(aModel.mValidationQueries, kValidationQueries);

    std::array<std::size_t, 8U> aPlaneCounts{};
    for (const auto &aMapping : aModel.mMappings) {
        ++aPlaneCounts[aMapping.mSource & 7U];
    }
    std::printf("Adapted recovery: strength=%u mapping_queries=%zu validation_queries=%zu "
                "surviving_outputs=%zu unique_plaintext_bits=%zu/%zu\n",
                static_cast<unsigned>(pStrength), aModel.mMappingQueries,
                aModel.mValidationQueries, aModel.mSurvivingOutputBits,
                aModel.mMappings.size(), kBlockBytes * 8U);
    for (unsigned int b = 0U; b < 8U; ++b) {
        std::printf("Adapted coverage: strength=%u input_bit=%u selected=%zu/%zu\n",
                    static_cast<unsigned>(pStrength), b, aPlaneCounts[b], kBlockBytes);
    }

    // The model is frozen. These challenge plaintexts are created only after
    // training, use a separate PRNG seed, and never enter the recovery helper.
    // Challenge encryption calls are counted separately from the 88 attack queries.
    std::mt19937_64 aChallengeRandom(0x8EBC6AF09C88C6E3ULL);
    std::size_t aCorrect = 0U;
    std::size_t aPredictions = 0U;
    Bytes aPlaintext(kBlockBytes), aCiphertext(kBlockBytes), aRestored(kBlockBytes);
    for (std::size_t q = 0U; q < kChallengeBlocks; ++q) {
        FillPlaintext(aPlaintext, aChallengeRandom);
        if (!aOracle(aPlaintext, aCiphertext) ||
            !Soccer3::DecryptBlock(aCiphertext.data(), aRestored.data())) {
            XCTFail(@"Held-out challenge encrypt/decrypt API call failed");
            return;
        }
        if (aRestored != aPlaintext) {
            XCTFail(@"Held-out challenge inverse failed; cannot interpret recovery");
            return;
        }
        const Bytes aRecovered = RecoverSelectedBits(aModel, aCiphertext);
        std::size_t aBlockCorrect = 0U;
        for (std::size_t i = 0U; i < aRecovered.size(); ++i) {
            aBlockCorrect += aRecovered[i] == Bit(aPlaintext, aModel.mMappings[i].mSource);
        }
        aCorrect += aBlockCorrect;
        aPredictions += aRecovered.size();
        std::printf("Adapted challenge: strength=%u block=%zu correct=%zu/%zu; inverse OK\n",
                    static_cast<unsigned>(pStrength), q, aBlockCorrect, aRecovered.size());
    }
    const double aAccuracy = aPredictions == 0U ? 0.0 :
        100.0 * static_cast<double>(aCorrect) / static_cast<double>(aPredictions);
    std::printf("Adapted result: strength=%u training_queries=%zu challenge_blocks=%zu "
                "selected_bits_per_block=%zu correct=%zu/%zu accuracy=%.6f%%\n",
                static_cast<unsigned>(pStrength),
                aModel.mMappingQueries + aModel.mValidationQueries, kChallengeBlocks,
                aModel.mMappings.size(), aCorrect, aPredictions, aAccuracy);

    // An explicit partial-leakage regression: >=128 distinct, preselected input
    // bits predicted with >=75% accuracy across 8 unseen blocks. These cutoffs
    // do not declare smaller leaks safe or establish a formal security bound.
    const bool aSubstantialLeak = aModel.mMappings.size() >= kMinimumRecoveredBits &&
                                 aCorrect * 4U >= aPredictions * 3U;
    XCTAssertFalse(aSubstantialLeak,
                   @"SECURITY: adapted attack selected %zu plaintext bits per block and "
                    "recovered %zu/%zu held-out bits (%.6f%%) under strength %u, "
                    "using 24 mapping + 64 validation queries without the password or ARX state",
                   aModel.mMappings.size(), aCorrect, aPredictions, aAccuracy,
                   static_cast<unsigned>(pStrength));
}

- (void)checkAllBitDiffusionForStrength:(EncryptionStrength)pStrength {
    ClearSoccerOnExit aCleanup;
    if (!SeedFixture(pStrength)) {
        XCTFail(@"Fixture setup failed for strength %u", static_cast<unsigned>(pStrength));
        return;
    }
    std::mt19937_64 aRandom(0x20261030ULL);
    Bytes aPlaintext(kBlockBytes), aCiphertext(kBlockBytes), aRestored(kBlockBytes);
    FillPlaintext(aPlaintext, aRandom);
    if (!Soccer3::EncryptBlock(aPlaintext.data(), aCiphertext.data()) ||
        !Soccer3::DecryptBlock(aCiphertext.data(), aRestored.data())) {
        XCTFail(@"Baseline encrypt/decrypt API call failed");
        return;
    }
    if (aRestored != aPlaintext) {
        XCTFail(@"Baseline inverse failed; cannot interpret diffusion");
        return;
    }
    constexpr std::array<std::size_t, 8U> kPositions = {
        0U, 15U, 32U, 262143U, 262144U, 524287U, 524288U, kBlockBytes - 1U
    };
    Bytes aChangedPlaintext, aChangedCiphertext(kBlockBytes);
    std::size_t aTotalSingleBitCases = 0U;
    for (unsigned int b = 0U; b < 8U; ++b) {
        std::size_t aSingleBitCases = 0U;
        std::size_t aMinimum = kBlockBytes * 8U;
        std::size_t aMaximum = 0U;
        for (const auto aPosition : kPositions) {
            aChangedPlaintext = aPlaintext;
            aChangedPlaintext[aPosition] ^= static_cast<std::uint8_t>(1U << b);
            if (!Soccer3::EncryptBlock(aChangedPlaintext.data(), aChangedCiphertext.data())) {
                XCTFail(@"Differential encryption API call failed");
                return;
            }
            std::size_t aChangedBits = 0U;
            for (std::size_t j = 0U; j < kBlockBytes; ++j) {
                aChangedBits += static_cast<std::size_t>(__builtin_popcount(
                    static_cast<unsigned int>(aCiphertext[j] ^ aChangedCiphertext[j])));
            }
            if (aChangedBits == 0U) {
                XCTFail(@"Distinct inputs produced identical ciphertexts");
                return;
            }
            aSingleBitCases += aChangedBits == 1U;
            aMinimum = std::min(aMinimum, aChangedBits);
            aMaximum = std::max(aMaximum, aChangedBits);
        }
        aTotalSingleBitCases += aSingleBitCases;
        std::printf("Adapted diffusion: strength=%u input_bit=%u single_bit_cases=%zu/8 "
                    "min_changed=%zu max_changed=%zu\n",
                    static_cast<unsigned>(pStrength), b, aSingleBitCases, aMinimum, aMaximum);
    }
    // Same modest regression as the original MSB probe, extended to all planes.
    // This is not an avalanche benchmark or a universal stream-cipher criterion.
    XCTAssertEqual(aTotalSingleBitCases, std::size_t{0U},
                   @"SECURITY: %zu/64 input flips survived as one ciphertext bit under strength %u",
                   aTotalSingleBitCases, static_cast<unsigned>(pStrength));
}

- (void)checkControlWithUnsubstitutedBytes:(std::size_t)pBytes {
    constexpr std::size_t kControlBytes = 128U;
    const auto aOracle = MakeControlOracle(pBytes);
    CrossBitModel aModel;
    if (!LearnCrossBitModel(aOracle, kControlBytes, aModel)) {
        XCTFail(@"Control oracle failed");
        return;
    }
    XCTAssertEqual(aModel.mMappingQueries, std::size_t{11U});
    XCTAssertEqual(aModel.mValidationQueries, kValidationQueries);
    XCTAssertEqual(aModel.mMappings.size(), pBytes * 8U);
    std::mt19937_64 aRandom(0x589965CC75374CC3ULL);
    Bytes aPlaintext(kControlBytes), aCiphertext(kControlBytes);
    for (std::size_t q = 0U; q < kChallengeBlocks; ++q) {
        FillPlaintext(aPlaintext, aRandom);
        XCTAssertTrue(aOracle(aPlaintext, aCiphertext));
        const Bytes aRecovered = RecoverSelectedBits(aModel, aCiphertext);
        for (std::size_t i = 0U; i < aRecovered.size(); ++i) {
            XCTAssertEqual(aRecovered[i], Bit(aPlaintext, aModel.mMappings[i].mSource));
        }
    }
}

- (void)testControlRecoversMaskedPermutationAcrossBitPlanes {
    [self checkControlWithUnsubstitutedBytes:128U];
}
- (void)testControlRecoversPartialLeakWithoutGlobalPermutation {
    [self checkControlWithUnsubstitutedBytes:16U];
}
- (void)testControlRejectsNonlinearSingleBitCandidates {
    [self checkControlWithUnsubstitutedBytes:0U];
}
- (void)testControlReportsOracleFailures {
    // Exercise both mapping and validation failures; neither may look secure.
    for (const std::size_t aFailAt : {0U, 5U, 15U}) {
        std::size_t aCalls = 0U;
        const EncryptOracle aOracle = [&](const Bytes &pInput, Bytes &pOutput) {
            if (aCalls++ == aFailAt) { return false; }
            pOutput = pInput;
            return true;
        };
        CrossBitModel aModel;
        XCTAssertFalse(LearnCrossBitModel(aOracle, 128U, aModel));
        XCTAssertEqual(aCalls, aFailAt + 1U);
    }
}

- (void)testCrossBitRecovery_Weak {
    [self checkCrossBitRecoveryForStrength:EncryptionStrength::kWeak];
}
- (void)testCrossBitRecovery_Normal {
    [self checkCrossBitRecoveryForStrength:EncryptionStrength::kNormal];
}
- (void)testCrossBitRecovery_Strong {
    [self checkCrossBitRecoveryForStrength:EncryptionStrength::kStrong];
}
- (void)testAllBitDiffusion_Weak {
    [self checkAllBitDiffusionForStrength:EncryptionStrength::kWeak];
}
- (void)testAllBitDiffusion_Normal {
    [self checkAllBitDiffusionForStrength:EncryptionStrength::kNormal];
}
- (void)testAllBitDiffusion_Strong {
    [self checkAllBitDiffusionForStrength:EncryptionStrength::kStrong];
}

@end
