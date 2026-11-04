#ifndef SOCCER_TREE_FROG_TWO_CHECKS_HPP_
#define SOCCER_TREE_FROG_TWO_CHECKS_HPP_

#include "TreeFrogTwo.hpp"
#include <algorithm>
#include <array>
#include <limits>
#include <vector>

// Literal per-bit reference, independent of the implementation's mask compare.
inline std::uint8_t TreeFrogTwoReference(std::uint8_t pValue,
                                       unsigned pRowA, unsigned pRowB) {
    const bool aBothSet = ((pValue >> pRowA) & 1U) && ((pValue >> pRowB) & 1U);
    unsigned aResult = 0U;
    for (unsigned aRow = 0U; aRow < 8U; ++aRow) {
        unsigned aBit = (pValue >> aRow) & 1U;
        if (aRow != pRowA && aRow != pRowB && !aBothSet) aBit ^= 1U;
        aResult |= aBit << aRow;
    }
    return static_cast<std::uint8_t>(aResult);
}

// Exhaust the complete byte truth table for every one of the 28 row pairs.
// Shared with the standalone NEON/scalar/x86 checks.
inline const char *CheckTreeFrogTwoTruthTables() {
    std::array<std::uint8_t, 256U> aSource{}, aOutput{}, aRestored{}, aReordered{};
    for (unsigned aValue = 0U; aValue < 256U; ++aValue) aSource[aValue] = aValue;
    for (unsigned aRowA = 0U; aRowA < 8U; ++aRowA) {
        for (unsigned aRowB = aRowA + 1U; aRowB < 8U; ++aRowB) {
            TreeFrogTwo aCipher(aRowA, aRowB), aReorderedCipher(aRowB, aRowA);
            if (aCipher.mType != CipherType::kTreeFrogTwo) return "incorrect cipher type";
            const unsigned aProtectedMask = (1U << aRowA) | (1U << aRowB);
            const unsigned aWritableMask = aProtectedMask ^ 255U;
            CipherErrorCode aError = CipherErrorCode::kNullCipher;
            if (!aCipher.SealData(aSource.data(), nullptr, aOutput.data(), aSource.size(), &aError) ||
                aError != CipherErrorCode::kNone) return "seal failed";
            if (!aReorderedCipher.SealData(aSource.data(), nullptr, aReordered.data(), aSource.size(), nullptr) ||
                aOutput != aReordered) return "row argument order changed result";
            std::array<bool, 256U> aSeen{};
            for (unsigned aValue = 0U; aValue < 256U; ++aValue) {
                if (aOutput[aValue] != TreeFrogTwoReference(aValue, aRowA, aRowB)) return "truth table mismatch";
                if (((aOutput[aValue] ^ aValue) & aProtectedMask) != 0U) return "control bit changed";
                if (aSeen[aOutput[aValue]]) return "mapping is not a permutation";
                aSeen[aOutput[aValue]] = true;
                // Document the exact limitation: any two writable bits retain their XOR.
                for (unsigned aFirst = 0U; aFirst < 8U; ++aFirst) {
                    for (unsigned aSecond = aFirst + 1U; aSecond < 8U; ++aSecond) {
                        if ((aProtectedMask & ((1U << aFirst) | (1U << aSecond))) != 0U) continue;
                        if ((((aOutput[aValue] >> aFirst) ^ (aOutput[aValue] >> aSecond) ^
                              (aValue >> aFirst) ^ (aValue >> aSecond)) & 1U) != 0U)
                            return "writable-pair parity property changed";
                    }
                }
            }
            // An affine transform has zero second derivative. This one has six set bits.
            if ((aOutput[0U] ^ aOutput[1U << aRowA] ^ aOutput[1U << aRowB] ^
                 aOutput[aProtectedMask]) != aWritableMask) return "nonlinear gate missing";
            if (!aCipher.UnsealData(aOutput.data(), nullptr, aRestored.data(), aOutput.size(), nullptr) ||
                aRestored != aSource) return "inverse failed";
            if (!aCipher.SealData(aOutput.data(), nullptr, aRestored.data(), aOutput.size(), nullptr) ||
                aRestored != aSource) return "second forward call did not reverse";
        }
    }
    return nullptr;
}

inline const char *CheckTreeFrogTwoBuffers() {
    TreeFrogTwo aCipher(0U, 7U);
    for (const std::size_t aLength : {0U, 1U, 15U, 16U, 17U, 31U, 32U, 33U, 63U, 64U, 65U, 1048576U}) {
        std::vector<std::uint8_t> aSource(aLength + 8U, 0xA5U);
        std::vector<std::uint8_t> aOutput(aLength + 8U, 0xA5U), aRestored(aLength + 8U, 0xA5U);
        std::array<std::uint8_t, 64U> aWorker{};
        aWorker.fill(0x53U);
        const auto aSavedWorker = aWorker;
        for (std::size_t aIndex = 0U; aIndex < aLength; ++aIndex)
            aSource[aIndex + 1U] = static_cast<std::uint8_t>(aIndex * 37U);
        const auto aSavedSource = aSource;
        CipherErrorCode aError = CipherErrorCode::kNullCipher;
        if (!aCipher.SealData(aSource.data() + 1U, aWorker.data(), aOutput.data() + 3U, aLength, &aError) ||
            aError != CipherErrorCode::kNone) return "unaligned seal failed";
        for (std::size_t aIndex = 0U; aIndex < aLength; ++aIndex)
            if (aOutput[aIndex + 3U] != TreeFrogTwoReference(aSource[aIndex + 1U], 0U, 7U)) return "buffer reference mismatch";
        if (!aCipher.UnsealData(aOutput.data() + 3U, nullptr, aRestored.data() + 5U, aLength, &aError) ||
            aError != CipherErrorCode::kNone ||
            !std::equal(aSource.begin() + 1U, aSource.begin() + 1U + aLength, aRestored.begin() + 5U))
            return "unaligned inverse failed";
        if (aSource != aSavedSource || aWorker != aSavedWorker) return "source or worker changed";
        for (std::size_t aIndex = 0U; aIndex < aOutput.size(); ++aIndex) {
            if ((aIndex < 3U || aIndex >= aLength + 3U) && aOutput[aIndex] != 0xA5U) return "output guard changed";
            if ((aIndex < 5U || aIndex >= aLength + 5U) && aRestored[aIndex] != 0xA5U) return "inverse guard changed";
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
        for (std::size_t aBadRow : {std::size_t{0U}, std::size_t{8U}, std::numeric_limits<std::size_t>::max()}) {
            TreeFrogTwo aInvalid(0U, aBadRow);
            const bool aSuccess = aInverse
                ? aInvalid.UnsealData(aBuffer.data(), nullptr, aBuffer.data() + 64U, 64U, &aError)
                : aInvalid.SealData(aBuffer.data(), nullptr, aBuffer.data() + 64U, 64U, &aError);
            if (aSuccess || aError != CipherErrorCode::kInvalidParameter) return "invalid rows accepted";
        }
        if (aBuffer != aSaved) return "invalid call changed data";
    }
    aCipher.Zero();
    if (!aCipher.SealData(aBuffer.data(), nullptr, aBuffer.data() + 64U, 64U, nullptr) ||
        aBuffer[64U] != TreeFrogTwoReference(aBuffer[0U], 0U, 1U)) return "zero reset failed";
    return nullptr;
}

#endif  // SOCCER_TREE_FROG_TWO_CHECKS_HPP_
