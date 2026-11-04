#ifndef SOCCER_CRYPTEX_CHECKS_HPP_
#define SOCCER_CRYPTEX_CHECKS_HPP_

#include "Cryptex.hpp"
#include "CryptexTestSupport.hpp"
#include <algorithm>
#include <array>
#include <cstring>
#include <type_traits>
#include <vector>

namespace CryptexChecks {
using Bytes = std::vector<std::uint8_t>;
struct Probe {
    std::vector<int> mCalls;
    std::size_t mExpectedLength = 1U << 20U;
    unsigned mZeroCount = 0U;
    unsigned mDeleteCount = 0U;
    int mFailureIdentifier = 0;
};

// Noncommuting byte operations detect wrong layer/cipher ordering. Recording
// lengths also detects accidental L1/L2 subdivision of the 1 MiB input.
class ProbeCipher final : public Cipher {
public:
    ProbeCipher(Probe &pProbe, int pIdentifier) : Cipher(CipherType::kNone),
        mProbe(pProbe), mIdentifier(pIdentifier) {}
    ~ProbeCipher() override { ++mProbe.mDeleteCount; }
    void Zero() override { ++mProbe.mZeroCount; }
    static std::uint8_t Forward(std::uint8_t pValue, int pIdentifier) {
        const unsigned aShift = static_cast<unsigned>(pIdentifier) % 7U + 1U;
        const unsigned aValue = pValue ^ static_cast<std::uint8_t>(pIdentifier * 29);
        return static_cast<std::uint8_t>((aValue << aShift) | (aValue >> (8U - aShift)));
    }
    bool SealData(const std::uint8_t *pSource, std::uint8_t *, std::uint8_t *pDestination,
                  std::size_t pLength, CipherErrorCode *pError) const override {
        return Apply(pSource, pDestination, pLength, pError, false);
    }
    bool UnsealData(const std::uint8_t *pSource, std::uint8_t *, std::uint8_t *pDestination,
                    std::size_t pLength, CipherErrorCode *pError) const override {
        return Apply(pSource, pDestination, pLength, pError, true);
    }
private:
    bool Apply(const std::uint8_t *pSource, std::uint8_t *pDestination,
               std::size_t pLength, CipherErrorCode *pError, bool pUnseal) const {
        mProbe.mCalls.push_back(pUnseal ? -mIdentifier : mIdentifier);
        if (pLength != mProbe.mExpectedLength || mProbe.mFailureIdentifier == mIdentifier) {
            SetCipherErrorCode(pError, CipherErrorCode::kInvalidParameter);
            return false;
        }
        if (pSource == pDestination) {
            SetCipherErrorCode(pError, CipherErrorCode::kAliasedBuffer);
            return false;
        }
        const unsigned aShift = static_cast<unsigned>(mIdentifier) % 7U + 1U;
        for (std::size_t aIndex = 0U; aIndex < pLength; ++aIndex) {
            if (pUnseal) {
                const unsigned aValue = pSource[aIndex];
                pDestination[aIndex] = static_cast<std::uint8_t>(
                    ((aValue >> aShift) | (aValue << (8U - aShift))) ^ static_cast<unsigned>(mIdentifier * 29));
            } else pDestination[aIndex] = Forward(pSource[aIndex], mIdentifier);
        }
        SetCipherErrorCode(pError, CipherErrorCode::kNone);
        return true;
    }
    Probe &mProbe;
    int mIdentifier;
};

template <typename Sequence>
const char *CheckSequence(Sequence &pSequence, Probe &pProbe, const std::vector<int> &pExpectedCalls) {
    const auto aLength = pProbe.mExpectedLength;
    std::array<Bytes, 5U> aBuffers;
    for (auto &aBuffer : aBuffers) aBuffer.assign(aLength + 8U, 0xA5U);
    auto *aSource = aBuffers[0U].data() + 1U;
    auto *aWorkerA = aBuffers[1U].data() + 2U;
    auto *aWorkerB = aBuffers[2U].data() + 3U;
    auto *aOutput = aBuffers[3U].data() + 4U;
    auto *aRestored = aBuffers[4U].data() + 5U;
    Bytes aExpected(aLength);
    for (std::size_t aIndex = 0U; aIndex < aLength; ++aIndex) {
        aSource[aIndex] = static_cast<std::uint8_t>((aIndex * 37U) ^ (aIndex >> 7U));
        aExpected[aIndex] = aSource[aIndex];
        for (auto aIdentifier : pExpectedCalls)
            aExpected[aIndex] = ProbeCipher::Forward(aExpected[aIndex], aIdentifier);
    }
    const auto aSavedSource = aBuffers[0U];
    CipherErrorCode aError = CipherErrorCode::kNullCipher;
    if (!pSequence.SealData(aSource, aWorkerA, aWorkerB, aOutput, aLength, &aError) ||
        aError != CipherErrorCode::kNone) return "seal failed";
    if (pProbe.mCalls != pExpectedCalls || !std::equal(aExpected.begin(), aExpected.end(), aOutput))
        return "incorrect forward order or output routing";
    pProbe.mCalls.clear();
    const auto aSavedOutput = aBuffers[3U];
    if (!pSequence.UnsealData(aOutput, aWorkerA, aWorkerB, aRestored, aLength, &aError) ||
        aError != CipherErrorCode::kNone) return "unseal failed";
    std::vector<int> aReverseCalls;
    for (auto aIterator = pExpectedCalls.rbegin(); aIterator != pExpectedCalls.rend(); ++aIterator)
        aReverseCalls.push_back(-*aIterator);
    if (pProbe.mCalls != aReverseCalls || !std::equal(aSource, aSource + aLength, aRestored))
        return "incorrect inverse order or output routing";
    if (aBuffers[0U] != aSavedSource || aBuffers[3U] != aSavedOutput) return "read-only input modified";
    for (std::size_t aBuffer = 0U; aBuffer < aBuffers.size(); ++aBuffer)
        for (std::size_t aIndex = 0U; aIndex < aBuffers[aBuffer].size(); ++aIndex)
            if ((aIndex < aBuffer + 1U || aIndex >= aLength + aBuffer + 1U) && aBuffers[aBuffer][aIndex] != 0xA5U)
                return "buffer guard modified";
    return nullptr;
}

inline const char *CheckVaultOrder() {
    Probe aProbe;
    Cryptex aVault;
    const unsigned aCounts[] = {0U, 1U, 2U, 3U, 4U, 0U, 1U, 2U};
    std::vector<int> aCalls;
    int aIdentifier = 0;
    for (unsigned aLayer = 0U; aLayer < 8U; ++aLayer) {
        auto *aTarget = CryptexTestSupport::Layers(aVault)[aLayer];
        for (unsigned aCipher = 0U; aCipher < aCounts[aLayer]; ++aCipher) {
            aCalls.push_back(++aIdentifier);
            aTarget->Add(new ProbeCipher(aProbe, aIdentifier));
        }
    }
    return CheckSequence(aVault, aProbe, aCalls);
}


template <typename Sequence>
const char *CheckBufferErrors() {
    Sequence aSequence;
    std::array<std::uint8_t, 1024U> aStorage{};
    for (std::size_t aIndex = 0U; aIndex < aStorage.size(); ++aIndex) aStorage[aIndex] = static_cast<std::uint8_t>(aIndex * 37U);
    for (bool aUnseal : {false, true}) {
        auto aApply = [&](const std::array<std::uint8_t *, 4U> &pBuffers, std::size_t pLength, CipherErrorCode *pError) {
            return aUnseal ? aSequence.UnsealData(pBuffers[0U], pBuffers[1U], pBuffers[2U], pBuffers[3U], pLength, pError)
                           : aSequence.SealData(pBuffers[0U], pBuffers[1U], pBuffers[2U], pBuffers[3U], pLength, pError);
        };
        const std::array<std::uint8_t *, 4U> aBuffers = {aStorage.data(), aStorage.data() + 128U, aStorage.data() + 256U, aStorage.data() + 384U};
        CipherErrorCode aError = CipherErrorCode::kNullCipher;
        if (!aApply({nullptr, nullptr, nullptr, nullptr}, 0U, &aError) || aError != CipherErrorCode::kNone) return "zero length rejected";
        if (!aApply(aBuffers, 64U, &aError) || aError != CipherErrorCode::kNone ||
            !std::equal(aBuffers[0U], aBuffers[0U] + 64U, aBuffers[3U])) return "empty sequence is not identity";
        const auto aSaved = aStorage;
        for (std::size_t aLength : {1U, 63U, 65U})
            if (aApply(aBuffers, aLength, &aError) || aError != CipherErrorCode::kInvalidLength) return "invalid length accepted";
        for (unsigned aIndex = 0U; aIndex < 4U; ++aIndex) {
            auto aNull = aBuffers; aNull[aIndex] = nullptr;
            if (aApply(aNull, 64U, &aError) || aError != CipherErrorCode::kNullBuffer) return "null buffer accepted";
        }
        for (unsigned aFirst = 0U; aFirst < 4U; ++aFirst)
            for (unsigned aSecond = aFirst + 1U; aSecond < 4U; ++aSecond)
                for (unsigned aDistance : {0U, 1U, 63U})
                    for (bool aReverse : {false, true}) {
                        auto aOverlap = aBuffers;
                        if (aReverse) aOverlap[aFirst] = aOverlap[aSecond] + aDistance;
                        else aOverlap[aSecond] = aOverlap[aFirst] + aDistance;
                        if (aApply(aOverlap, 64U, &aError) || aError != CipherErrorCode::kAliasedBuffer) return "overlapping buffers accepted";
                    }
        if (aStorage != aSaved) return "invalid arguments modified buffers";
    }
    return nullptr;
}

inline const char *CheckFailuresAndOwnership() {
    Probe aProbe;
    aProbe.mExpectedLength = 64U;
    std::array<std::uint8_t, 64U> aSource{}, aWorkerA{}, aWorkerB{}, aOutput{};
    {
        Cryptex aVault;
        aVault.mLayerAA.Add(new ProbeCipher(aProbe, 1));
        aVault.mLayerAB.Add(new ProbeCipher(aProbe, 2));
        aVault.mLayerBC.Add(new ProbeCipher(aProbe, 3));
        aVault.mLayerBD.Add(new ProbeCipher(aProbe, 4));
        aProbe.mFailureIdentifier = 2;
        CipherErrorCode aError = CipherErrorCode::kNone;
        if (aVault.SealData(aSource.data(), aWorkerA.data(), aWorkerB.data(), aOutput.data(), 64U, &aError) ||
            aError != CipherErrorCode::kInvalidParameter || aProbe.mCalls != std::vector<int>{1, 2}) return "seal did not stop at failing cipher";
        aProbe.mCalls.clear();
        if (aVault.UnsealData(aSource.data(), aWorkerA.data(), aWorkerB.data(), aOutput.data(), 64U, &aError) ||
            aError != CipherErrorCode::kInvalidParameter || aProbe.mCalls != std::vector<int>{-4, -3, -2}) return "unseal did not stop at failing cipher";
        aVault.Zero();
        if (aProbe.mZeroCount != 4U) return "zero did not visit both rounds";
        aVault.Clear(); aVault.Clear();
        if (aProbe.mDeleteCount != 4U) return "free did not release each cipher exactly once";
        aVault.mLayerBD.Add(nullptr);
        if (aVault.SealData(aSource.data(), aWorkerA.data(), aWorkerB.data(), aOutput.data(), 64U, &aError) ||
            aError != CipherErrorCode::kNullCipher) return "null cipher error lost";
        aVault.Clear();
        for (unsigned aIndex = 0U; aIndex <= CRYPTEX_LAYER_MAX_CIPHER_COUNT; ++aIndex)
            aVault.mLayerBD.Add(new ProbeCipher(aProbe, 5));
        if (aProbe.mDeleteCount != 5U) return "overflow cipher ownership changed";
    }
    if (aProbe.mDeleteCount != 5U + CRYPTEX_LAYER_MAX_CIPHER_COUNT) return "destructor did not release ciphers";
    return nullptr;
}

static_assert(!std::is_copy_constructible_v<Cryptex> && !std::is_move_constructible_v<Cryptex>);
}  // namespace CryptexChecks

#endif  // SOCCER_CRYPTEX_CHECKS_HPP_
