#ifndef SOCCER_BIT_REVERSE_CIPHER_HPP_
#define SOCCER_BIT_REVERSE_CIPHER_HPP_

#include <cstddef>
#include <cstdint>
#include "Jelly.hpp"
#include "Cipher.hpp"
#if !IGNORE_SIMD && (defined(__SSE2__) || defined(_M_X64) || (defined(_M_IX86_FP) && _M_IX86_FP >= 2))
#include <immintrin.h>
#endif

// Reverse bit order INSIDE every byte: abcdefgh -> hgfedcba. Byte addresses
// stay fixed. The same operation seals and unseals. No worker or material.
// Any length and unaligned buffers are supported; source/output cannot overlap.
class BitReverseCipher final : public Cipher {
 public:
  BitReverseCipher() : Cipher(CipherType::kBitReverseCipher) {}

  bool SealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                std::uint8_t *pDestination, std::size_t pLength,
                CipherErrorCode *pErrorCode) const override {
    (void)pWorker;
    return Apply(pSource, pDestination, pLength, pErrorCode);
  }

  bool UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                  std::uint8_t *pDestination, std::size_t pLength,
                  CipherErrorCode *pErrorCode) const override {
    (void)pWorker;
    return Apply(pSource, pDestination, pLength, pErrorCode);
  }

 private:
  static bool Apply(const std::uint8_t *pSource, std::uint8_t *pDestination,
                    std::size_t pLength, CipherErrorCode *pErrorCode) {
    if (pLength == 0U) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
      return true;
    }
    if (pSource == nullptr || pDestination == nullptr) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
      return false;
    }
    const auto aSourceAddress = reinterpret_cast<std::uintptr_t>(pSource);
    const auto aDestinationAddress = reinterpret_cast<std::uintptr_t>(pDestination);
    const auto aDistance = aSourceAddress <= aDestinationAddress
        ? aDestinationAddress - aSourceAddress : aSourceAddress - aDestinationAddress;
    if (aDistance < pLength) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
      return false;
    }

    std::size_t aOffset = 0U;
#if JELLY_USE_NEON && defined(__aarch64__)
    // AArch64 RBIT reverses each of the sixteen bytes in one instruction.
    for (; pLength - aOffset >= 16U; aOffset += 16U)
      vst1q_u8(pDestination + aOffset, vrbitq_u8(vld1q_u8(pSource + aOffset)));
#elif JELLY_USE_NEON
    // ARMv7 NEON has no vector RBIT: swap adjacent bits, pairs, then nibbles.
    const auto aSingleMask = vdupq_n_u8(0x55U);
    const auto aPairMask = vdupq_n_u8(0x33U);
    for (; pLength - aOffset >= 16U; aOffset += 16U) {
      auto aValue = vld1q_u8(pSource + aOffset);
      aValue = vorrq_u8(vandq_u8(vshrq_n_u8(aValue, 1), aSingleMask), vshlq_n_u8(vandq_u8(aValue, aSingleMask), 1));
      aValue = vorrq_u8(vandq_u8(vshrq_n_u8(aValue, 2), aPairMask), vshlq_n_u8(vandq_u8(aValue, aPairMask), 2));
      vst1q_u8(pDestination + aOffset, vorrq_u8(vshrq_n_u8(aValue, 4), vshlq_n_u8(aValue, 4)));
    }
#elif !IGNORE_SIMD && (defined(__SSE2__) || defined(_M_X64) || (defined(_M_IX86_FP) && _M_IX86_FP >= 2))
#if defined(__AVX2__)
    // The lookup stays in registers; each 128-bit half has the same table.
    const auto aNibbleTableWide = _mm256_setr_epi8(
        0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15,
        0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15);
    const auto aNibbleMaskWide = _mm256_set1_epi8(0x0F);
    for (; pLength - aOffset >= 32U; aOffset += 32U) {
      const auto aValue = _mm256_loadu_si256(reinterpret_cast<const __m256i *>(pSource + aOffset));
      const auto aLow = _mm256_shuffle_epi8(aNibbleTableWide, _mm256_and_si256(aValue, aNibbleMaskWide));
      const auto aHigh = _mm256_shuffle_epi8(aNibbleTableWide,
          _mm256_and_si256(_mm256_srli_epi16(aValue, 4), aNibbleMaskWide));
      _mm256_storeu_si256(reinterpret_cast<__m256i *>(pDestination + aOffset),
          _mm256_or_si256(_mm256_slli_epi16(aLow, 4), aHigh));
    }
#endif
#if defined(__SSSE3__) || defined(__AVX2__)
    const auto aNibbleTable = _mm_setr_epi8(0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15);
    const auto aNibbleMask = _mm_set1_epi8(0x0F);
    for (; pLength - aOffset >= 16U; aOffset += 16U) {
      const auto aValue = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource + aOffset));
      const auto aLow = _mm_shuffle_epi8(aNibbleTable, _mm_and_si128(aValue, aNibbleMask));
      const auto aHigh = _mm_shuffle_epi8(aNibbleTable, _mm_and_si128(_mm_srli_epi16(aValue, 4), aNibbleMask));
      _mm_storeu_si128(reinterpret_cast<__m128i *>(pDestination + aOffset),
          _mm_or_si128(_mm_slli_epi16(aLow, 4), aHigh));
    }
#else
    // SSE2 baseline. Masks remove spill between bytes in 16-bit lane shifts.
    const auto aSingleMask = _mm_set1_epi8(0x55);
    const auto aPairMask = _mm_set1_epi8(0x33);
    const auto aNibbleMask = _mm_set1_epi8(0x0F);
    for (; pLength - aOffset >= 16U; aOffset += 16U) {
      auto aValue = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource + aOffset));
      aValue = _mm_or_si128(_mm_and_si128(_mm_srli_epi16(aValue, 1), aSingleMask),
                           _mm_slli_epi16(_mm_and_si128(aValue, aSingleMask), 1));
      aValue = _mm_or_si128(_mm_and_si128(_mm_srli_epi16(aValue, 2), aPairMask),
                           _mm_slli_epi16(_mm_and_si128(aValue, aPairMask), 2));
      aValue = _mm_or_si128(_mm_and_si128(_mm_srli_epi16(aValue, 4), aNibbleMask),
                           _mm_slli_epi16(_mm_and_si128(aValue, aNibbleMask), 4));
      _mm_storeu_si128(reinterpret_cast<__m128i *>(pDestination + aOffset), aValue);
    }
#endif
#endif
    for (; aOffset < pLength; ++aOffset) {
      unsigned aValue = pSource[aOffset];
      aValue = ((aValue >> 1U) & 0x55U) | ((aValue & 0x55U) << 1U);
      aValue = ((aValue >> 2U) & 0x33U) | ((aValue & 0x33U) << 2U);
      pDestination[aOffset] = static_cast<std::uint8_t>((aValue >> 4U) | (aValue << 4U));
    }
    SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
    return true;
  }
};

#endif // SOCCER_BIT_REVERSE_CIPHER_HPP_
