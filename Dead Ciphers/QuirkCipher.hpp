#ifndef SOCCER_QUIRK_CIPHER_HPP_
#define SOCCER_QUIRK_CIPHER_HPP_

#include "../Cipher.hpp"
#include <array>

#if !IGNORE_SIMD && (defined(__ARM_NEON) || defined(__ARM_NEON__))
#include <arm_neon.h>
#elif !IGNORE_SIMD && (defined(__SSE2__) || defined(_M_X64) || (defined(_M_IX86_FP) && _M_IX86_FP >= 2))
#include <emmintrin.h>
#endif

namespace QuirkDetail {
// The booleans are fixed independently for every cipher and every direction.
// Reversal changes only the addresses of the sixteen 16-byte loads inside a
// 256-byte window. It never shuffles bytes inside a vector.
template<bool KeepHigh, bool Inverse, bool ReverseA, bool ReverseB, bool ReverseC>
inline void Transform(const std::array<std::size_t, 3> &pWindows,
                      const std::uint8_t *pSource, std::uint8_t *pDestination,
                      std::size_t pLength) {
    const auto aCount = pLength / 256U;
    auto aWindowA = pWindows[0] % aCount;
    auto aWindowB = pWindows[1] % aCount;
    auto aWindowC = pWindows[2] % aCount;
    for (std::size_t aPosition = 0U; aPosition < pLength; aPosition += 256U) {
        const auto *aSourceA = pSource + 256U * aWindowA;
        const auto *aSourceB = pSource + 256U * aWindowB;
        const auto *aSourceC = pSource + 256U * aWindowC;
        for (std::size_t i = 0U; i < 256U; i += 16U) {
            const auto *a = aSourceA + (ReverseA ? 240U - i : i);
            const auto *b = aSourceB + (ReverseB ? 240U - i : i);
            const auto *c = aSourceC + (ReverseC ? 240U - i : i);
            const auto *aCurrent = pSource + aPosition + i;
            auto *aOutput = pDestination + aPosition + i;
#if !IGNORE_SIMD && (defined(__ARM_NEON) || defined(__ARM_NEON__))
            const auto aValue = vld1q_u8(aCurrent);
            const auto aTwiddle = veorq_u8(vld1q_u8(a), vandq_u8(vld1q_u8(b), vld1q_u8(c)));
            uint8x16_t aResult;
            if constexpr (!KeepHigh) {
                // Four operations: AND, XOR, SHL, ADD/SUB. The shift drops
                // sampled high bits; adding zero in the low nibble keeps it.
                const auto aKey = vshlq_n_u8(aTwiddle, 4);
                if constexpr (Inverse) aResult = vsubq_u8(aValue, aKey);
                else aResult = vaddq_u8(aValue, aKey);
            } else if constexpr (!Inverse) {
                // Five operations. No masking of individual samples needed:
                // the shifted current has a zero low nibble, so Twiddle's
                // low nibble cannot carry into the useful high half.
                const auto aSum = vaddq_u8(vshlq_n_u8(aValue, 4), aTwiddle);
                aResult = vsriq_n_u8(aValue, aSum, 4);
            } else {
                const auto aChanged = vsubq_u8(aValue, vshrq_n_u8(aTwiddle, 4));
                aResult = vbslq_u8(vdupq_n_u8(0xF0U), aValue, aChanged);
            }
            vst1q_u8(aOutput, aResult);
#elif !IGNORE_SIMD && (defined(__SSE2__) || defined(_M_X64) || (defined(_M_IX86_FP) && _M_IX86_FP >= 2))
            const auto aValue = _mm_loadu_si128(reinterpret_cast<const __m128i *>(aCurrent));
            const auto aTwiddle = _mm_xor_si128(_mm_loadu_si128(reinterpret_cast<const __m128i *>(a)),
                _mm_and_si128(_mm_loadu_si128(reinterpret_cast<const __m128i *>(b)),
                              _mm_loadu_si128(reinterpret_cast<const __m128i *>(c))));
            __m128i aResult;
            if constexpr (!KeepHigh) {
                // SSE2 shifts 16-bit lanes: mask off spill from the adjacent
                // byte before ADD/SUB, so the protected low nibble stays put.
                const auto aKey = _mm_and_si128(_mm_slli_epi16(aTwiddle, 4), _mm_set1_epi8(static_cast<char>(0xF0U)));
                if constexpr (Inverse) aResult = _mm_sub_epi8(aValue, aKey);
                else aResult = _mm_add_epi8(aValue, aKey);
            } else {
                // Spill into the key's high nibble cannot affect the low
                // result. Restore the protected high nibble after arithmetic.
                const auto aKey = _mm_srli_epi16(aTwiddle, 4);
                const auto aChanged = Inverse ? _mm_sub_epi8(aValue, aKey) : _mm_add_epi8(aValue, aKey);
                aResult = _mm_xor_si128(aValue, _mm_and_si128(_mm_xor_si128(aValue, aChanged), _mm_set1_epi8(0x0F)));
            }
            _mm_storeu_si128(reinterpret_cast<__m128i *>(aOutput), aResult);
#else
            for (std::size_t j = 0U; j < 16U; ++j) {
                constexpr unsigned kShift = KeepHigh ? 4U : 0U;
                constexpr unsigned kTargetShift = KeepHigh ? 0U : 4U;
                constexpr unsigned kMask = KeepHigh ? 0xF0U : 0x0FU;
                const unsigned aKey = ((a[j] >> kShift) ^ ((b[j] >> kShift) & (c[j] >> kShift))) & 15U;
                const unsigned aValue = aCurrent[j];
                const unsigned aOld = (aValue >> kTargetShift) & 15U;
                const unsigned aChanged = Inverse ? aOld - aKey : aOld + aKey;
                aOutput[j] = static_cast<std::uint8_t>((aValue & kMask) | ((aChanged & 15U) << kTargetShift));
            }
#endif
        }
        if (++aWindowA == aCount) aWindowA = 0U;
        if (++aWindowB == aCount) aWindowB = 0U;
        if (++aWindowC == aCount) aWindowC = 0U;
    }
}
} // namespace QuirkDetail

// All sixteen specializations are independent final Cipher implementations.
// ADD/SUB modulo 16 is fixed at compile time; no update/direction dispatch.
// Each key depends exclusively on the nibble preserved by this stage, so it
// can be regenerated from ciphertext, including during exact in-place use.
// One caller thread; no allocation, material buffer, scratch, or worker.
template<bool KeepHigh, bool ReverseA, bool ReverseB, bool ReverseC>
class QuirkCipher final : public Cipher {
public:
    static constexpr std::size_t kWindowBytes = 256U;
    static constexpr std::size_t kChunkBytes = 16U;
    static constexpr unsigned kVariant = (unsigned(ReverseA) << 2U) | (unsigned(ReverseB) << 1U) | unsigned(ReverseC);
    static constexpr CipherType kType = static_cast<CipherType>(
        static_cast<std::uint32_t>(KeepHigh ? CipherType::kQuirkHighA : CipherType::kQuirkLowA) + kVariant);

    // Relative offsets in 256-byte windows, wrapping around the whole block.
    QuirkCipher(std::size_t pWindowA, std::size_t pWindowB, std::size_t pWindowC)
        : Cipher(kType), mWindows{pWindowA, pWindowB, pWindowC} {}

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
    void Zero() override { mWindows.fill(0U); }

private:
    template<bool Inverse>
    bool Apply(const std::uint8_t *pSource, std::uint8_t *pDestination,
               std::size_t pLength, CipherErrorCode *pErrorCode) const {
        if (pLength == 0U) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
            return true;
        }
        if (pLength % kWindowBytes != 0U) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength);
            return false;
        }
        if (!pSource || !pDestination) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
            return false;
        }
        if (pSource != pDestination) {
            const auto aSource = reinterpret_cast<std::uintptr_t>(pSource);
            const auto aDestination = reinterpret_cast<std::uintptr_t>(pDestination);
            const auto aDistance = aSource < aDestination ? aDestination - aSource : aSource - aDestination;
            if (aDistance < pLength) {
                SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
                return false;
            }
        }
        QuirkDetail::Transform<KeepHigh, Inverse, ReverseA, ReverseB, ReverseC>(mWindows, pSource, pDestination, pLength);
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
    }

    std::array<std::size_t, 3> mWindows;
};

#endif // SOCCER_QUIRK_CIPHER_HPP_
