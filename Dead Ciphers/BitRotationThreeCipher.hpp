#ifndef SOCCER_BIT_ROTATION_THREE_CIPHER_HPP_
#define SOCCER_BIT_ROTATION_THREE_CIPHER_HPP_

#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"
#if !IGNORE_SIMD && defined(__SSE2__)
#include <immintrin.h>
#endif

// Rotate every byte left by three on Seal, right by three on Unseal.
// Byte positions stay fixed. Any length and unaligned buffers are supported;
// nonempty source/destination buffers must not overlap. No worker or material.
class BitRotationThreeCipher final : public Cipher {
 public:
  BitRotationThreeCipher() : Cipher(CipherType::kBitRotationThreeCipher) {}

  bool SealData(const std::uint8_t *pSource,
                std::uint8_t *pWorker,
                std::uint8_t *pDestination,
                std::size_t pLength,
                CipherErrorCode *pErrorCode) const override {
    (void)pWorker;
    return Apply<3u>(pSource, pDestination, pLength, pErrorCode);
  }

  bool UnsealData(const std::uint8_t *pSource,
                  std::uint8_t *pWorker,
                  std::uint8_t *pDestination,
                  std::size_t pLength,
                  CipherErrorCode *pErrorCode) const override {
    (void)pWorker;
    return Apply<5u>(pSource, pDestination, pLength, pErrorCode);
  }

 private:
  template <unsigned kRotation>
  static bool Apply(const std::uint8_t *pSource,
                    std::uint8_t *pDestination,
                    std::size_t pLength,
                    CipherErrorCode *pErrorCode) {
    if (pLength == 0u) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
      return true;
    }
    if (pSource == nullptr || pDestination == nullptr) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
      return false;
    }
    const std::uintptr_t aSourceAddress = reinterpret_cast<std::uintptr_t>(pSource);
    const std::uintptr_t aDestinationAddress = reinterpret_cast<std::uintptr_t>(pDestination);
    const std::uintptr_t aBufferDistance = aSourceAddress <= aDestinationAddress
        ? aDestinationAddress - aSourceAddress : aSourceAddress - aDestinationAddress;
    if (aBufferDistance < pLength) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
      return false;
    }

    std::size_t aOffset = 0u;
#if JELLY_USE_NEON
    for (; pLength - aOffset >= 16u; aOffset += 16u) {
      const uint8x16_t aValue = vld1q_u8(pSource + aOffset);
      const uint8x16_t aRotated = vsriq_n_u8(
          vshlq_n_u8(aValue, kRotation), aValue, 8u - kRotation);
      vst1q_u8(pDestination + aOffset, aRotated);
    }
#elif !IGNORE_SIMD && defined(__SSE2__)
    // SSE2 shifts words; masks remove spill between neighboring bytes.
    const __m128i aLeftMask = _mm_set1_epi8(static_cast<char>(0xFFu << kRotation));
    const __m128i aRightMask = _mm_set1_epi8(static_cast<char>((1u << kRotation) - 1u));
    for (; pLength - aOffset >= 16u; aOffset += 16u) {
      const __m128i aValue = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource + aOffset));
      const __m128i aLeft = _mm_and_si128(_mm_slli_epi16(aValue, kRotation), aLeftMask);
      const __m128i aRight = _mm_and_si128(_mm_srli_epi16(aValue, 8u - kRotation), aRightMask);
      _mm_storeu_si128(reinterpret_cast<__m128i *>(pDestination + aOffset), _mm_or_si128(aLeft, aRight));
    }
#endif
    for (; aOffset < pLength; ++aOffset) {
      const std::uint8_t aValue = pSource[aOffset];
      pDestination[aOffset] = static_cast<std::uint8_t>(
          (aValue << kRotation) | (aValue >> (8u - kRotation)));
    }
    SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
    return true;
  }
};

#endif  // SOCCER_BIT_ROTATION_THREE_CIPHER_HPP_
