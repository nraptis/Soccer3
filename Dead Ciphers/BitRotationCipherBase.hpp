#ifndef SOCCER_BIT_ROTATION_CIPHER_BASE_HPP_
#define SOCCER_BIT_ROTATION_CIPHER_BASE_HPP_

#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"
#if !IGNORE_SIMD && defined(__SSE2__)
#include <immintrin.h>
#endif

// Rotate alternate 16-byte groups inside each 64-byte window. Byte positions
// stay fixed. Seal rotates selected bytes left by 3; Unseal rotates right by 3.
// Length must be zero or a multiple of 64. Nonempty buffers must not overlap;
// unaligned buffers are supported. No worker, materials, masks or state needed.
// The group choice and shift are compile-time constants in both variants.
template <bool kRotateSecondGroup>
class BitRotationCipherBase : public Cipher {
 public:
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

 protected:
  explicit BitRotationCipherBase(CipherType pType) : Cipher(pType) {}

 private:
  static constexpr std::size_t kWindowBytes = 64u;
  static constexpr std::size_t kRotatedOffset = kRotateSecondGroup ? 16u : 0u;
  static constexpr std::size_t kCopiedOffset = kRotateSecondGroup ? 0u : 16u;

  template <unsigned kRotation>
  static bool Apply(const std::uint8_t *pSource,
                    std::uint8_t *pDestination,
                    std::size_t pLength,
                    CipherErrorCode *pErrorCode) {
    static_assert(kRotation == 3u || kRotation == 5u);
    if (pLength == 0u) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
      return true;
    }
    if ((pLength % kWindowBytes) != 0u) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength);
      return false;
    }
    if (pSource == nullptr || pDestination == nullptr) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
      return false;
    }
    const std::uintptr_t aSourceAddress = reinterpret_cast<std::uintptr_t>(pSource);
    const std::uintptr_t aDestinationAddress = reinterpret_cast<std::uintptr_t>(pDestination);
    const std::uintptr_t aBufferDistance = aSourceAddress <= aDestinationAddress
        ? aDestinationAddress - aSourceAddress
        : aSourceAddress - aDestinationAddress;
    if (aBufferDistance < pLength) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
      return false;
    }

#if JELLY_USE_NEON
    for (std::size_t aOffset = 0u; aOffset < pLength; aOffset += kWindowBytes) {
      const uint8x16_t aFirst = vld1q_u8(pSource + aOffset + kRotatedOffset);
      const uint8x16_t aSecond = vld1q_u8(pSource + aOffset + 32u + kRotatedOffset);
      // SHL + SRI rotates all sixteen bytes independently, without a mask.
      const uint8x16_t aFirstRotated = vsriq_n_u8(
          vshlq_n_u8(aFirst, kRotation), aFirst, 8u - kRotation);
      const uint8x16_t aSecondRotated = vsriq_n_u8(
          vshlq_n_u8(aSecond, kRotation), aSecond, 8u - kRotation);
      vst1q_u8(pDestination + aOffset + kRotatedOffset, aFirstRotated);
      vst1q_u8(pDestination + aOffset + 32u + kRotatedOffset, aSecondRotated);
      vst1q_u8(pDestination + aOffset + kCopiedOffset,
               vld1q_u8(pSource + aOffset + kCopiedOffset));
      vst1q_u8(pDestination + aOffset + 32u + kCopiedOffset,
               vld1q_u8(pSource + aOffset + 32u + kCopiedOffset));
    }
#elif !IGNORE_SIMD && defined(__SSE2__)
    // SSE2 shifts 16-bit lanes. Clear spill bits so neighboring bytes cannot
    // affect one another. Only the selected 16-byte groups need arithmetic.
    const __m128i aLeftMask = _mm_set1_epi8(static_cast<char>(0xFFu << kRotation));
    const __m128i aRightMask = _mm_set1_epi8(static_cast<char>((1u << kRotation) - 1u));
    for (std::size_t aOffset = 0u; aOffset < pLength; aOffset += kWindowBytes) {
      for (std::size_t aHalf = 0u; aHalf < kWindowBytes; aHalf += 32u) {
        const auto *aSource = pSource + aOffset + aHalf;
        auto *aDestination = pDestination + aOffset + aHalf;
        const __m128i aRotating = _mm_loadu_si128(
            reinterpret_cast<const __m128i *>(aSource + kRotatedOffset));
        const __m128i aLeft = _mm_and_si128(_mm_slli_epi16(aRotating, kRotation), aLeftMask);
        const __m128i aRight = _mm_and_si128(_mm_srli_epi16(aRotating, 8u - kRotation), aRightMask);
        _mm_storeu_si128(reinterpret_cast<__m128i *>(aDestination + kRotatedOffset),
                         _mm_or_si128(aLeft, aRight));
        _mm_storeu_si128(reinterpret_cast<__m128i *>(aDestination + kCopiedOffset),
                         _mm_loadu_si128(reinterpret_cast<const __m128i *>(aSource + kCopiedOffset)));
      }
    }
#else
    for (std::size_t aOffset = 0u; aOffset < pLength; aOffset += 32u) {
      for (std::size_t aByteIndex = 0u; aByteIndex < 16u; ++aByteIndex) {
        const std::uint8_t aValue = pSource[aOffset + kRotatedOffset + aByteIndex];
        pDestination[aOffset + kRotatedOffset + aByteIndex] =
            static_cast<std::uint8_t>((aValue << kRotation) | (aValue >> (8u - kRotation)));
        pDestination[aOffset + kCopiedOffset + aByteIndex] =
            pSource[aOffset + kCopiedOffset + aByteIndex];
      }
    }
#endif
    SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
    return true;
  }
};

#endif  // SOCCER_BIT_ROTATION_CIPHER_BASE_HPP_
