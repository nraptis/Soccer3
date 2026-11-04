#ifndef SOCCER_TOAD_TWO_CIPHER_A_HPP_
#define SOCCER_TOAD_TWO_CIPHER_A_HPP_

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include "Jelly.hpp"
#include "Cipher.hpp"
#if !IGNORE_SIMD && defined(__SSE2__)
#include <immintrin.h>
#endif

// 2 distinct protected rows, each paired with its own 64-byte-window rotation.
// SA packs row A from window A; SB packs row B from window B.
// Source byte 8*g+b supplies bit b of sample byte g. Each sample is exactly
// eight bytes, repeated eight times across the 64-byte destination window.
//
// Seal successively ADDS SA, then SB into each byte's 6 writable bits,
// modulo 2^6. Unseal SUBTRACTS them in reverse order. All 2 selected rows
// remain unchanged globally, so decryption regenerates the same samples.
// No XOR-combined mask is used by Toad.
//
// Each step skips protected positions using ones for carry propagation or
// zeros for borrow propagation, exactly like Frog. The intermediate values
// stay in registers; restoring protected bits once at the end is equivalent
// to restoring them after every step. No temporary work buffer is needed.
// Successive additions are modular addition of the sample fields, not
// independent cryptographic rounds. Nonlinearity alone is no security proof.
//
// Length is zero or a multiple of 64. Nonempty buffers must not overlap;
// unaligned buffers are supported. Rows must be distinct and in [0,7].
// No allocation, worker use, or state across calls. Offsets wrap modulo N.
class ToadTwoCipherA final : public Cipher {
public:
    explicit ToadTwoCipherA(std::size_t pRowA, std::size_t pBlockRotationA,
                            std::size_t pRowB, std::size_t pBlockRotationB)
        : Cipher(CipherType::kToadTwoCipherA),
          mRowA(pRowA), mBlockRotationA(pBlockRotationA),
          mRowB(pRowB), mBlockRotationB(pBlockRotationB) {}

    bool SealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                  std::uint8_t *pDestination, std::size_t pLength,
                  CipherErrorCode *pErrorCode) const override {
        (void)pWorker;
        return Apply<false>(pSource, pDestination, pLength, pErrorCode);
    }
    bool UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                    std::uint8_t *pDestination, std::size_t pLength,
                    CipherErrorCode *pErrorCode) const override {
        (void)pWorker;
        return Apply<true>(pSource, pDestination, pLength, pErrorCode);
    }
    void Zero() override {
        mRowA = 0U; mBlockRotationA = 0U;
        mRowB = 1U; mBlockRotationB = 0U;
    }

private:
    template <bool Inverse>
    bool Apply(const std::uint8_t *pSource, std::uint8_t *pDestination,
               std::size_t pLength, CipherErrorCode *pErrorCode) const {
        if (pLength == 0U) { SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone); return true; }
        if (pLength % 64U != 0U) { SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength); return false; }
        if (mRowA >= 8U || mRowB >= 8U || mRowA == mRowB) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidParameter); return false;
        }
        if (pSource == nullptr || pDestination == nullptr) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer); return false;
        }
        const auto aSource = reinterpret_cast<std::uintptr_t>(pSource);
        const auto aDestination = reinterpret_cast<std::uintptr_t>(pDestination);
        const auto aDistance = aSource <= aDestination ? aDestination - aSource : aSource - aDestination;
        if (aDistance < pLength) { SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer); return false; }
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);

        const auto aProtected = static_cast<std::uint8_t>((1U << mRowA) | (1U << mRowB));
        const auto aWritable = static_cast<std::uint8_t>(~aProtected);
        const auto aWindows = pLength / 64U;
        std::size_t aSampleA = (mBlockRotationA % aWindows) * 64U;
        std::size_t aSampleB = (mBlockRotationB % aWindows) * 64U;
        std::size_t aPosition = 0U;
#if JELLY_USE_NEON && defined(__aarch64__)
        const auto aRowMask = vdupq_n_u8(aProtected);
        const int8x16_t aShifts = {0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7};
        const auto aShiftA = vsubq_s8(aShifts, vdupq_n_s8(static_cast<std::int8_t>(mRowA)));
        const auto aShiftB = vsubq_s8(aShifts, vdupq_n_s8(static_cast<std::int8_t>(mRowB)));
        const uint8x16_t aPackingBits = {1,2,4,8,16,32,64,128,1,2,4,8,16,32,64,128};
        const auto aPositions = vandq_u8(aPackingBits, vdupq_n_u8(aWritable));
#elif !IGNORE_SIMD && defined(__SSE2__)
        const auto aShiftA = _mm_cvtsi32_si128(static_cast<int>(7U - mRowA));
        const auto aShiftB = _mm_cvtsi32_si128(static_cast<int>(7U - mRowB));
        const std::uint64_t aWritable64 = 0x0101010101010101ULL * aWritable;
#if defined(__AVX2__)
        const auto aProtectedSIMD = _mm256_set1_epi8(static_cast<char>(aProtected));
#else
        const auto aProtectedSIMD = _mm_set1_epi8(static_cast<char>(aProtected));
#endif
#endif
        // Each sample wraps once. Split spans outside the hot window loop.
        while (aPosition < pLength) {
            const auto aSpan = std::min({pLength - aPosition, pLength - aSampleA, pLength - aSampleB});
            for (std::size_t aOffset = 0U; aOffset < aSpan; aOffset += 64U) {
                const auto *aInput = pSource + aPosition + aOffset;
                auto *aOutput = pDestination + aPosition + aOffset;
                const auto *aA = pSource + aSampleA + aOffset;
                const auto *aB = pSource + aSampleB + aOffset;
#if JELLY_USE_NEON && defined(__aarch64__)
                const auto aMaskA = PackRowNEON(aA, aShiftA, aPositions);
                const auto aMaskB = PackRowNEON(aB, aShiftB, aPositions);
                vst1q_u8(aOutput + 0U, ApplyMasksNEON<Inverse>(vld1q_u8(aInput + 0U), aMaskA, aMaskB, aRowMask));
                vst1q_u8(aOutput + 16U, ApplyMasksNEON<Inverse>(vld1q_u8(aInput + 16U), aMaskA, aMaskB, aRowMask));
                vst1q_u8(aOutput + 32U, ApplyMasksNEON<Inverse>(vld1q_u8(aInput + 32U), aMaskA, aMaskB, aRowMask));
                vst1q_u8(aOutput + 48U, ApplyMasksNEON<Inverse>(vld1q_u8(aInput + 48U), aMaskA, aMaskB, aRowMask));
#elif !IGNORE_SIMD && defined(__AVX2__)
                const auto aMaskA = _mm256_set1_epi64x(static_cast<long long>(PackRowAVX2(aA, aShiftA) & aWritable64));
                const auto aMaskB = _mm256_set1_epi64x(static_cast<long long>(PackRowAVX2(aB, aShiftB) & aWritable64));
                _mm256_storeu_si256(reinterpret_cast<__m256i *>(aOutput + 0U),
                    ApplyMasksAVX2<Inverse>(_mm256_loadu_si256(reinterpret_cast<const __m256i *>(aInput + 0U)), aMaskA, aMaskB, aProtectedSIMD));
                _mm256_storeu_si256(reinterpret_cast<__m256i *>(aOutput + 32U),
                    ApplyMasksAVX2<Inverse>(_mm256_loadu_si256(reinterpret_cast<const __m256i *>(aInput + 32U)), aMaskA, aMaskB, aProtectedSIMD));
#elif !IGNORE_SIMD && defined(__SSE2__)
                const auto aMaskA = _mm_set1_epi64x(static_cast<long long>(PackRowSSE2(aA, aShiftA) & aWritable64));
                const auto aMaskB = _mm_set1_epi64x(static_cast<long long>(PackRowSSE2(aB, aShiftB) & aWritable64));
                _mm_storeu_si128(reinterpret_cast<__m128i *>(aOutput + 0U),
                    ApplyMasksSSE2<Inverse>(_mm_loadu_si128(reinterpret_cast<const __m128i *>(aInput + 0U)), aMaskA, aMaskB, aProtectedSIMD));
                _mm_storeu_si128(reinterpret_cast<__m128i *>(aOutput + 16U),
                    ApplyMasksSSE2<Inverse>(_mm_loadu_si128(reinterpret_cast<const __m128i *>(aInput + 16U)), aMaskA, aMaskB, aProtectedSIMD));
                _mm_storeu_si128(reinterpret_cast<__m128i *>(aOutput + 32U),
                    ApplyMasksSSE2<Inverse>(_mm_loadu_si128(reinterpret_cast<const __m128i *>(aInput + 32U)), aMaskA, aMaskB, aProtectedSIMD));
                _mm_storeu_si128(reinterpret_cast<__m128i *>(aOutput + 48U),
                    ApplyMasksSSE2<Inverse>(_mm_loadu_si128(reinterpret_cast<const __m128i *>(aInput + 48U)), aMaskA, aMaskB, aProtectedSIMD));
#else
                std::uint8_t aPackedA[8] = {};
                std::uint8_t aPackedB[8] = {};
                for (unsigned g = 0U; g < 8U; ++g) {
                    for (unsigned b = 0U; b < 8U; ++b) {
                        aPackedA[g] |= static_cast<std::uint8_t>(((aA[8U*g+b] >> mRowA) & 1U) << b);
                        aPackedB[g] |= static_cast<std::uint8_t>(((aB[8U*g+b] >> mRowB) & 1U) << b);
                    }
                    aPackedA[g] &= aWritable;
                    aPackedB[g] &= aWritable;
                }
                for (unsigned i = 0U; i < 64U; ++i) {
                    const auto x = aInput[i];
                    auto value = x;
                    if constexpr (Inverse) {
                        value = static_cast<std::uint8_t>((value & aWritable) - aPackedB[i % 8U]);
                        value = static_cast<std::uint8_t>((value & aWritable) - aPackedA[i % 8U]);
                    } else {
                        value = static_cast<std::uint8_t>((value | aProtected) + aPackedA[i % 8U]);
                        value = static_cast<std::uint8_t>((value | aProtected) + aPackedB[i % 8U]);
                    }
                    aOutput[i] = (value & aWritable) | (x & aProtected);
                }
#endif
            }
            aPosition += aSpan;
            aSampleA += aSpan; if (aSampleA == pLength) { aSampleA = 0U; }
            aSampleB += aSpan; if (aSampleB == pLength) { aSampleB = 0U; }
        }
        return true;
    }

#if JELLY_USE_NEON && defined(__aarch64__)
    template <bool Inverse>
    static uint8x16_t ApplyMasksNEON(uint8x16_t pInput, uint8x16_t pA, uint8x16_t pB, uint8x16_t pProtected) {
        auto value = pInput;
        if constexpr (Inverse) {
            value = vsubq_u8(vbicq_u8(value, pProtected), pB);
            value = vsubq_u8(vbicq_u8(value, pProtected), pA);
        } else {
            value = vaddq_u8(vorrq_u8(value, pProtected), pA);
            value = vaddq_u8(vorrq_u8(value, pProtected), pB);
        }
        // Preserve the original protected bits with one BIT/BIF instruction.
        return veorq_u8(pInput, vbicq_u8(veorq_u8(pInput, value), pProtected));
    }

    static uint8x16_t PackRowNEON(const std::uint8_t *pSource, int8x16_t pShifts, uint8x16_t pPositions) {
        const auto aBits0 = vandq_u8(vshlq_u8(vld1q_u8(pSource + 0U), pShifts), pPositions);
        const auto aBits1 = vandq_u8(vshlq_u8(vld1q_u8(pSource + 16U), pShifts), pPositions);
        const auto aBits2 = vandq_u8(vshlq_u8(vld1q_u8(pSource + 32U), pShifts), pPositions);
        const auto aBits3 = vandq_u8(vshlq_u8(vld1q_u8(pSource + 48U), pShifts), pPositions);
        // Disjoint bit positions: these pairwise sums only pack, without carries.
        const auto aPairs01 = vpaddq_u8(aBits0, aBits1);
        const auto aPairs23 = vpaddq_u8(aBits2, aBits3);
        const auto aQuads = vpaddq_u8(aPairs01, aPairs23);
        return vpaddq_u8(aQuads, aQuads); // Eight sample bytes, twice.
    }
#endif
#if !IGNORE_SIMD && defined(__SSE2__)
    template <bool Inverse>
    static __m128i ApplyMasksSSE2(__m128i pInput, __m128i pA, __m128i pB, __m128i pProtected) {
        auto value = pInput;
        if constexpr (Inverse) {
            value = _mm_sub_epi8(_mm_andnot_si128(pProtected, value), pB);
            value = _mm_sub_epi8(_mm_andnot_si128(pProtected, value), pA);
        } else {
            value = _mm_add_epi8(_mm_or_si128(value, pProtected), pA);
            value = _mm_add_epi8(_mm_or_si128(value, pProtected), pB);
        }
        return _mm_or_si128(_mm_andnot_si128(pProtected, value),
                                   _mm_and_si128(pProtected, pInput));
    }

    static std::uint64_t PackRowSSE2(const std::uint8_t *pSource, __m128i pShift) {
        // Shifts are 0..7: cross-byte spill cannot reach the next sign bit.
        const auto aBits0 = _mm_sll_epi16(_mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource + 0U)), pShift);
        const auto aPacked0 = static_cast<std::uint64_t>(static_cast<std::uint32_t>(_mm_movemask_epi8(aBits0)));
        const auto aBits1 = _mm_sll_epi16(_mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource + 16U)), pShift);
        const auto aPacked1 = static_cast<std::uint64_t>(static_cast<std::uint32_t>(_mm_movemask_epi8(aBits1)));
        const auto aBits2 = _mm_sll_epi16(_mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource + 32U)), pShift);
        const auto aPacked2 = static_cast<std::uint64_t>(static_cast<std::uint32_t>(_mm_movemask_epi8(aBits2)));
        const auto aBits3 = _mm_sll_epi16(_mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource + 48U)), pShift);
        const auto aPacked3 = static_cast<std::uint64_t>(static_cast<std::uint32_t>(_mm_movemask_epi8(aBits3)));
        return aPacked0 | (aPacked1 << 16U) | (aPacked2 << 32U) | (aPacked3 << 48U);
    }
#endif
#if !IGNORE_SIMD && defined(__AVX2__)
    template <bool Inverse>
    static __m256i ApplyMasksAVX2(__m256i pInput, __m256i pA, __m256i pB, __m256i pProtected) {
        auto value = pInput;
        if constexpr (Inverse) {
            value = _mm256_sub_epi8(_mm256_andnot_si256(pProtected, value), pB);
            value = _mm256_sub_epi8(_mm256_andnot_si256(pProtected, value), pA);
        } else {
            value = _mm256_add_epi8(_mm256_or_si256(value, pProtected), pA);
            value = _mm256_add_epi8(_mm256_or_si256(value, pProtected), pB);
        }
        return _mm256_or_si256(_mm256_andnot_si256(pProtected, value),
                                   _mm256_and_si256(pProtected, pInput));
    }

    static std::uint64_t PackRowAVX2(const std::uint8_t *pSource, __m128i pShift) {
        // Shifts are 0..7: cross-byte spill cannot reach the next sign bit.
        const auto aBits0 = _mm256_sll_epi16(_mm256_loadu_si256(reinterpret_cast<const __m256i *>(pSource + 0U)), pShift);
        const auto aPacked0 = static_cast<std::uint64_t>(static_cast<std::uint32_t>(_mm256_movemask_epi8(aBits0)));
        const auto aBits1 = _mm256_sll_epi16(_mm256_loadu_si256(reinterpret_cast<const __m256i *>(pSource + 32U)), pShift);
        const auto aPacked1 = static_cast<std::uint64_t>(static_cast<std::uint32_t>(_mm256_movemask_epi8(aBits1)));
        return aPacked0 | (aPacked1 << 32U);
    }
#endif

    std::size_t mRowA;
    std::size_t mBlockRotationA;
    std::size_t mRowB;
    std::size_t mBlockRotationB;
};

#endif // SOCCER_TOAD_TWO_CIPHER_A_HPP_
