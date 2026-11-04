#ifndef JELLY_BIT_ROTATION_CIPHER_HPP_
#define JELLY_BIT_ROTATION_CIPHER_HPP_

#include <cstddef>
#include <cstdint>
#include <cstring>

#include "Jelly.hpp"
#include "Cipher.hpp"

// Rotates the eight bits within each byte; byte positions do not change.
// Seal rotates left by pShift % 8; Unseal rotates right by the same amount.
// Input shape: pLength must be 0 or a multiple of 16. Source and destination
// must not overlap. The worker buffer is unused and may be null.
// This is a bit permutation, not a standalone encryption construction.

class BitRotationCipher final : public Cipher {
 public:
  explicit BitRotationCipher(std::size_t pShift)
      : Cipher(CipherType::kBitRotationCipher), mShift(pShift % 8u) {}

  bool SealData(const std::uint8_t *pSource,
                std::uint8_t *pWorker,
                std::uint8_t *pDestination,
                std::size_t pLength,
                CipherErrorCode *pErrorCode) const override {
    (void)pWorker;
    return Apply(pSource, pDestination, pLength, mShift, pErrorCode);
  }

  bool UnsealData(const std::uint8_t *pSource,
                  std::uint8_t *pWorker,
                  std::uint8_t *pDestination,
                  std::size_t pLength,
                  CipherErrorCode *pErrorCode) const override {
    (void)pWorker;
    return Apply(pSource, pDestination, pLength, (8u - mShift) % 8u,
                 pErrorCode);
  }

  void Zero() override {
    mShift = 0u;
  }

 private:
  static constexpr std::size_t kLengthMultiple = 16u;

  static bool Apply(const std::uint8_t *pSource,
                    std::uint8_t *pDestination,
                    std::size_t pLength,
                    std::size_t pRotation,
                    CipherErrorCode *pErrorCode) {
    if (pLength == 0u) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
      return true;
    }
    if ((pLength % kLengthMultiple) != 0u) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength);
      return false;
    }
    if (pSource == nullptr || pDestination == nullptr) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
      return false;
    }
    if (pSource == pDestination) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
      return false;
    }

    SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
    // Dispatch once per buffer so the vector shifts use immediate constants.
    // Zero is a copy, avoiding an out-of-range eight-bit left shift in NEON.
    switch (pRotation) {
      case 0u: std::memcpy(pDestination, pSource, pLength); break;
      case 1u: ApplyRotation<1u>(pSource, pDestination, pLength); break;
      case 2u: ApplyRotation<2u>(pSource, pDestination, pLength); break;
      case 3u: ApplyRotation<3u>(pSource, pDestination, pLength); break;
      case 4u: ApplyRotation<4u>(pSource, pDestination, pLength); break;
      case 5u: ApplyRotation<5u>(pSource, pDestination, pLength); break;
      case 6u: ApplyRotation<6u>(pSource, pDestination, pLength); break;
      case 7u: ApplyRotation<7u>(pSource, pDestination, pLength); break;
    }
    return true;
  }

  template <std::size_t kRotation>
  static void ApplyRotation(const std::uint8_t *pSource,
                            std::uint8_t *pDestination,
                            std::size_t pLength) {
    static_assert(kRotation > 0u && kRotation < 8u,
                  "Nonzero byte rotations must be between 1 and 7.");
#if JELLY_USE_NEON
    for (std::size_t aOffset = 0u; aOffset < pLength; aOffset += 16u) {
      const uint8x16_t aSource = vld1q_u8(pSource + aOffset);
      // SHL + SRI: preserve the high bits of the left shift and insert the
      // wrapped bits at the bottom, independently in all sixteen byte lanes.
      const uint8x16_t aResult = vsriq_n_u8(
          vshlq_n_u8(aSource, kRotation), aSource, 8u - kRotation);
      vst1q_u8(pDestination + aOffset, aResult);
    }
#elif JELLY_USE_SIMD
    // x86 shifts operate on 16-bit lanes. Mask each half so bits cannot leak
    // across adjacent bytes before combining the two directions.
    constexpr std::uint8_t kLeftMask =
        static_cast<std::uint8_t>(0xFFu << kRotation);
    constexpr std::uint8_t kRightMask =
        static_cast<std::uint8_t>((1u << kRotation) - 1u);
    std::size_t aOffset = 0u;
#if defined(__AVX2__)
    const __m256i aLeftMask256 = _mm256_set1_epi8(static_cast<char>(kLeftMask));
    const __m256i aRightMask256 = _mm256_set1_epi8(static_cast<char>(kRightMask));
    for (; pLength - aOffset >= 32u; aOffset += 32u) {
      const __m256i aSource = _mm256_loadu_si256(
          reinterpret_cast<const __m256i *>(pSource + aOffset));
      const __m256i aLeft = _mm256_and_si256(
          _mm256_slli_epi16(aSource, kRotation), aLeftMask256);
      const __m256i aRight = _mm256_and_si256(
          _mm256_srli_epi16(aSource, 8u - kRotation), aRightMask256);
      _mm256_storeu_si256(reinterpret_cast<__m256i *>(pDestination + aOffset),
                          _mm256_or_si256(aLeft, aRight));
    }
#endif
    const __m128i aLeftMask128 = _mm_set1_epi8(static_cast<char>(kLeftMask));
    const __m128i aRightMask128 = _mm_set1_epi8(static_cast<char>(kRightMask));
    for (; aOffset < pLength; aOffset += 16u) {
      const __m128i aSource = _mm_loadu_si128(
          reinterpret_cast<const __m128i *>(pSource + aOffset));
      const __m128i aLeft = _mm_and_si128(
          _mm_slli_epi16(aSource, kRotation), aLeftMask128);
      const __m128i aRight = _mm_and_si128(
          _mm_srli_epi16(aSource, 8u - kRotation), aRightMask128);
      _mm_storeu_si128(reinterpret_cast<__m128i *>(pDestination + aOffset),
                       _mm_or_si128(aLeft, aRight));
    }
#else
    for (std::size_t aOffset = 0u; aOffset < pLength; ++aOffset) {
      const std::uint8_t aSource = pSource[aOffset];
      pDestination[aOffset] = static_cast<std::uint8_t>(
          (aSource << kRotation) | (aSource >> (8u - kRotation)));
    }
#endif
  }

  std::size_t mShift;
};

#endif  // JELLY_BIT_ROTATION_CIPHER_HPP_
