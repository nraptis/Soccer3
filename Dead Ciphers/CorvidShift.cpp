#include "CorvidShift.hpp"
#include "../../Composer/Soccer3.hpp"

#if !IGNORE_SIMD && (defined(__SSE2__) || defined(_M_X64))
#include <immintrin.h>
#endif

#include <algorithm>
#include <bit>

namespace {
bool BuffersOverlap(const std::uint8_t *pFirst, const std::uint8_t *pSecond,
                    std::size_t pLength) {
    const auto aFirst = reinterpret_cast<std::uintptr_t>(pFirst);
    const auto aSecond = reinterpret_cast<std::uintptr_t>(pSecond);
    return aFirst <= aSecond ? aSecond - aFirst < pLength
                            : aFirst - aSecond < pLength;
}

// Each span ends at the next circular-buffer wrap. The inner loop therefore
// has only contiguous loads, bit operations, and one store per output byte.
// Compile-time pair/direction choices remove unused streams and XOR operations.
// Inverse gathers each material byte from the same position as its ciphertext.
template<std::size_t kPairCount, bool kMutate, bool kUnseal>
void BlendSpan(const std::uint8_t *pSource, const std::uint8_t *pMaterial,
               std::uint8_t *__restrict pDestination, std::size_t pLength,
               const std::uint8_t *const (&pShiftedSources)[kPairCount],
               const std::uint8_t *const (&pShiftedMaterials)[kPairCount],
               const CorvidShift (&pShifts)[kPairCount],
               std::uint8_t pStationaryMask) {
    std::size_t aIndex = 0U;
#if SOCCER_USE_NEON
    {
        const auto aStationaryMask = vdupq_n_u8(pStationaryMask);
        uint8x16_t aMasks[kPairCount];
        for (std::size_t aPair = 0U; aPair < kPairCount; ++aPair)
            aMasks[aPair] = vdupq_n_u8(pShifts[aPair].mMask);
        for (; aIndex + 16U <= pLength; aIndex += 16U) {
            auto aResult = vdupq_n_u8(0U);
            if constexpr (kPairCount == 2U) {
                auto aSource = vld1q_u8(pSource + aIndex);
                if constexpr (kMutate && kUnseal)
                    aSource = veorq_u8(aSource, vld1q_u8(pMaterial + aIndex));
                aResult = vandq_u8(aSource, aStationaryMask);
            }
#if defined(__clang__)
#pragma clang loop unroll(full)
#endif
            for (std::size_t aPair = 0U; aPair < kPairCount; ++aPair) {
                auto aSource = vld1q_u8(pShiftedSources[aPair] + aIndex);
                if constexpr (kMutate && kUnseal)
                    aSource = veorq_u8(aSource, vld1q_u8(pShiftedMaterials[aPair] + aIndex));
                aResult = vorrq_u8(aResult, vandq_u8(aSource, aMasks[aPair]));
            }
            if constexpr (kMutate && !kUnseal)
                aResult = veorq_u8(aResult, vld1q_u8(pMaterial + aIndex));
            vst1q_u8(pDestination + aIndex, aResult);
        }
    }
#elif !IGNORE_SIMD && (defined(__SSE2__) || defined(_M_X64))
#if defined(__AVX2__)
    {
        const auto aStationaryMask = _mm256_set1_epi8(static_cast<char>(pStationaryMask));
        __m256i aMasks[kPairCount];
        for (std::size_t aPair = 0U; aPair < kPairCount; ++aPair)
            aMasks[aPair] = _mm256_set1_epi8(static_cast<char>(pShifts[aPair].mMask));
        for (; aIndex + 32U <= pLength; aIndex += 32U) {
            auto aResult = _mm256_set1_epi8(static_cast<char>(0U));
            if constexpr (kPairCount == 2U) {
                auto aSource = _mm256_loadu_si256(reinterpret_cast<const __m256i *>(pSource + aIndex));
                if constexpr (kMutate && kUnseal)
                    aSource = _mm256_xor_si256(aSource, _mm256_loadu_si256(reinterpret_cast<const __m256i *>(pMaterial + aIndex)));
                aResult = _mm256_and_si256(aSource, aStationaryMask);
            }
#if defined(__clang__)
#pragma clang loop unroll(full)
#endif
            for (std::size_t aPair = 0U; aPair < kPairCount; ++aPair) {
                auto aSource = _mm256_loadu_si256(reinterpret_cast<const __m256i *>(pShiftedSources[aPair] + aIndex));
                if constexpr (kMutate && kUnseal)
                    aSource = _mm256_xor_si256(aSource, _mm256_loadu_si256(reinterpret_cast<const __m256i *>(pShiftedMaterials[aPair] + aIndex)));
                aResult = _mm256_or_si256(aResult, _mm256_and_si256(aSource, aMasks[aPair]));
            }
            if constexpr (kMutate && !kUnseal)
                aResult = _mm256_xor_si256(aResult, _mm256_loadu_si256(reinterpret_cast<const __m256i *>(pMaterial + aIndex)));
            _mm256_storeu_si256(reinterpret_cast<__m256i *>(pDestination + aIndex), aResult);
        }
    }
#endif
    {
        const auto aStationaryMask = _mm_set1_epi8(static_cast<char>(pStationaryMask));
        __m128i aMasks[kPairCount];
        for (std::size_t aPair = 0U; aPair < kPairCount; ++aPair)
            aMasks[aPair] = _mm_set1_epi8(static_cast<char>(pShifts[aPair].mMask));
        for (; aIndex + 16U <= pLength; aIndex += 16U) {
            auto aResult = _mm_set1_epi8(static_cast<char>(0U));
            if constexpr (kPairCount == 2U) {
                auto aSource = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource + aIndex));
                if constexpr (kMutate && kUnseal)
                    aSource = _mm_xor_si128(aSource, _mm_loadu_si128(reinterpret_cast<const __m128i *>(pMaterial + aIndex)));
                aResult = _mm_and_si128(aSource, aStationaryMask);
            }
#if defined(__clang__)
#pragma clang loop unroll(full)
#endif
            for (std::size_t aPair = 0U; aPair < kPairCount; ++aPair) {
                auto aSource = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pShiftedSources[aPair] + aIndex));
                if constexpr (kMutate && kUnseal)
                    aSource = _mm_xor_si128(aSource, _mm_loadu_si128(reinterpret_cast<const __m128i *>(pShiftedMaterials[aPair] + aIndex)));
                aResult = _mm_or_si128(aResult, _mm_and_si128(aSource, aMasks[aPair]));
            }
            if constexpr (kMutate && !kUnseal)
                aResult = _mm_xor_si128(aResult, _mm_loadu_si128(reinterpret_cast<const __m128i *>(pMaterial + aIndex)));
            _mm_storeu_si128(reinterpret_cast<__m128i *>(pDestination + aIndex), aResult);
        }
    }
#endif
    for (; aIndex < pLength; ++aIndex) {
        std::uint8_t aResult = 0U;
        if constexpr (kPairCount == 2U) {
            auto aSource = pSource[aIndex];
            if constexpr (kMutate && kUnseal) aSource ^= pMaterial[aIndex];
            aResult = aSource & pStationaryMask;
        }
        for (std::size_t aPair = 0U; aPair < kPairCount; ++aPair) {
            auto aSource = pShiftedSources[aPair][aIndex];
            if constexpr (kMutate && kUnseal) aSource ^= pShiftedMaterials[aPair][aIndex];
            aResult |= aSource & pShifts[aPair].mMask;
        }
        if constexpr (kMutate && !kUnseal) aResult ^= pMaterial[aIndex];
        pDestination[aIndex] = aResult;
    }
}
}

template<std::size_t kPairCount, bool kMutate>
CorvidCipher<kPairCount, kMutate>::CorvidCipher(
    CipherType pType, const CorvidShift (&pShifts)[kPairCount],
    const std::uint8_t *pMaterial)
    : Cipher(pType), mMaterial(pMaterial), mStationaryMask(0xFFU), mValidMasks(true) {
    static_assert(kPairCount == 2U || kPairCount == 4U);
    for (std::size_t aPair = 0U; aPair < kPairCount; ++aPair) {
        mShifts[aPair] = pShifts[aPair];
        const auto aMask = pShifts[aPair].mMask;
        mValidMasks &= std::popcount(aMask) == 2 && (aMask & mStationaryMask) == aMask;
        mStationaryMask &= static_cast<std::uint8_t>(~aMask);
    }
}

template<std::size_t kPairCount, bool kMutate>
bool CorvidCipher<kPairCount, kMutate>::SealData(
    const std::uint8_t *pSource, std::uint8_t *pWorker,
    std::uint8_t *pDestination, std::size_t pLength, CipherErrorCode *pErrorCode) const {
    (void)pWorker;
    return Apply<false>(pSource, pDestination, pLength, pErrorCode);
}

template<std::size_t kPairCount, bool kMutate>
bool CorvidCipher<kPairCount, kMutate>::UnsealData(
    const std::uint8_t *pSource, std::uint8_t *pWorker,
    std::uint8_t *pDestination, std::size_t pLength, CipherErrorCode *pErrorCode) const {
    (void)pWorker;
    return Apply<true>(pSource, pDestination, pLength, pErrorCode);
}

template<std::size_t kPairCount, bool kMutate>
void CorvidCipher<kPairCount, kMutate>::Zero() {
    for (auto &aShift : mShifts) aShift = {};
    mMaterial = nullptr;
    mStationaryMask = 0U;
    mValidMasks = false;
}

template<std::size_t kPairCount, bool kMutate>
template<bool kUnseal>
bool CorvidCipher<kPairCount, kMutate>::Apply(
    const std::uint8_t *pSource, std::uint8_t *pDestination,
    std::size_t pLength, CipherErrorCode *pErrorCode) const {
    if (pLength == 0U) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
    }
    constexpr std::size_t kLengthMultiple = kMutate ? 32U : 16U;
    if (pLength % kLengthMultiple != 0U) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength);
        return false;
    }
    if (!mValidMasks) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidParameter);
        return false;
    }
    if (pSource == nullptr || pDestination == nullptr || (kMutate && mMaterial == nullptr)) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
        return false;
    }
    if (BuffersOverlap(pSource, pDestination, pLength) ||
        (kMutate && BuffersOverlap(mMaterial, pDestination, pLength))) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
        return false;
    }

    std::size_t aPositions[kPairCount];
    for (std::size_t aPair = 0U; aPair < kPairCount; ++aPair) {
        const auto aRotation = mShifts[aPair].mRotation % pLength;
        aPositions[aPair] = kUnseal || aRotation == 0U ? aRotation : pLength - aRotation;
    }
    std::size_t aOffset = 0U;
    while (aOffset < pLength) {
        std::size_t aSpanLength = pLength - aOffset;
        const std::uint8_t *aShiftedSources[kPairCount];
        const std::uint8_t *aShiftedMaterials[kPairCount]{};
        for (std::size_t aPair = 0U; aPair < kPairCount; ++aPair) {
            aSpanLength = std::min(aSpanLength, pLength - aPositions[aPair]);
            aShiftedSources[aPair] = pSource + aPositions[aPair];
            if constexpr (kMutate && kUnseal)
                aShiftedMaterials[aPair] = mMaterial + aPositions[aPair];
        }
        const std::uint8_t *aMaterial = nullptr;
        if constexpr (kMutate) aMaterial = mMaterial + aOffset;
        BlendSpan<kPairCount, kMutate, kUnseal>(
            pSource + aOffset, aMaterial, pDestination + aOffset, aSpanLength,
            aShiftedSources, aShiftedMaterials, mShifts, mStationaryMask);
        aOffset += aSpanLength;
        for (std::size_t aPair = 0U; aPair < kPairCount; ++aPair) {
            aPositions[aPair] += aSpanLength;
            if (aPositions[aPair] == pLength) aPositions[aPair] = 0U;
        }
    }
    SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
    return true;
}

template class CorvidCipher<2, false>;
template class CorvidCipher<2, true>;
template class CorvidCipher<4, true>;
