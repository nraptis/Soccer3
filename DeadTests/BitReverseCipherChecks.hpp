#ifndef SOCCER_BIT_REVERSE_CIPHER_CHECKS_HPP_
#define SOCCER_BIT_REVERSE_CIPHER_CHECKS_HPP_

#include "BitReverseCipher.hpp"
#include <algorithm>
#include <array>
#include <vector>

// Shared by XCTest and the standalone NEON/scalar/x86 checks.
inline const char *CheckBitReverseCipher() {
    BitReverseCipher aCipher;
    for (const std::size_t aLength : {0U, 1U, 15U, 16U, 17U, 31U, 32U, 33U, 63U, 64U, 65U, 127U, 128U, 129U, 256U, 1048576U, 1048579U}) {
        std::vector<std::uint8_t> aSource(aLength + 8U, 0xA5U);
        std::vector<std::uint8_t> aOutput(aLength + 8U, 0xA5U), aRestored(aLength + 8U, 0xA5U);
        std::array<std::uint8_t, 64U> aWorker{};
        aWorker.fill(0x53U);
        const auto aSavedWorker = aWorker;
        for (std::size_t aIndex = 0U; aIndex < aLength; ++aIndex)
            aSource[aIndex + 1U] = static_cast<std::uint8_t>(aIndex * 37U);
        const auto aSavedSource = aSource;
        for (bool aInverse : {false, true}) {
            CipherErrorCode aError = CipherErrorCode::kNullCipher;
            const bool aSuccess = aInverse
                ? aCipher.UnsealData(aSource.data() + 1U, aWorker.data(), aOutput.data() + 3U, aLength, &aError)
                : aCipher.SealData(aSource.data() + 1U, aWorker.data(), aOutput.data() + 3U, aLength, &aError);
            if (!aSuccess || aError != CipherErrorCode::kNone) return "unaligned transform rejected";
            for (std::size_t aIndex = 0U; aIndex < aLength; ++aIndex) {
                // Independent reference: move each source bit to its destination.
                unsigned aExpected = 0U;
                for (unsigned aBit = 0U; aBit < 8U; ++aBit)
                    aExpected |= ((aSource[aIndex + 1U] >> aBit) & 1U) << (7U - aBit);
                if (aOutput[aIndex + 3U] != aExpected) return "incorrect byte mapping";
            }
            const bool aReversed = aInverse
                ? aCipher.SealData(aOutput.data() + 3U, nullptr, aRestored.data() + 5U, aLength, &aError)
                : aCipher.UnsealData(aOutput.data() + 3U, nullptr, aRestored.data() + 5U, aLength, &aError);
            if (!aReversed || aError != CipherErrorCode::kNone ||
                !std::equal(aSource.begin() + 1U, aSource.begin() + 1U + aLength, aRestored.begin() + 5U))
                return "round trip failed";
            if (aSource != aSavedSource || aWorker != aSavedWorker) return "source or worker changed";
            for (std::size_t aIndex = 0U; aIndex < aOutput.size(); ++aIndex) {
                if ((aIndex < 3U || aIndex >= aLength + 3U) && aOutput[aIndex] != 0xA5U) return "output guard changed";
                if ((aIndex < 5U || aIndex >= aLength + 5U) && aRestored[aIndex] != 0xA5U) return "restored guard changed";
            }
        }
    }
    std::array<std::uint8_t, 128U> aBuffer{};
    aBuffer.fill(0xA5U);
    const auto aSaved = aBuffer;
    for (bool aInverse : {false, true}) {
        auto aApply = [&](const std::uint8_t *pSource, std::uint8_t *pDestination, std::size_t pLength, CipherErrorCode *pError) {
            return aInverse ? aCipher.UnsealData(pSource, nullptr, pDestination, pLength, pError)
                            : aCipher.SealData(pSource, nullptr, pDestination, pLength, pError);
        };
        CipherErrorCode aError = CipherErrorCode::kNullCipher;
        if (!aApply(nullptr, nullptr, 0U, &aError) || aError != CipherErrorCode::kNone) return "zero length rejected";
        if (aApply(nullptr, aBuffer.data(), 64U, &aError) || aError != CipherErrorCode::kNullBuffer ||
            aApply(aBuffer.data(), nullptr, 64U, &aError) || aError != CipherErrorCode::kNullBuffer) return "null accepted";
        for (std::size_t aDistance : {0U, 1U, 16U, 63U}) {
            if (aApply(aBuffer.data(), aBuffer.data() + aDistance, 64U, &aError) || aError != CipherErrorCode::kAliasedBuffer ||
                aApply(aBuffer.data() + aDistance, aBuffer.data(), 64U, &aError) || aError != CipherErrorCode::kAliasedBuffer)
                return "overlap accepted";
        }
        if (aBuffer != aSaved) return "invalid call changed data";
    }
    return nullptr;
}

#endif  // SOCCER_BIT_REVERSE_CIPHER_CHECKS_HPP_
