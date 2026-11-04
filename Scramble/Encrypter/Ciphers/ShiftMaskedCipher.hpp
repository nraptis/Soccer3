#ifndef JELLY_SHIFT_MASKED_CIPHER_HPP_
#define JELLY_SHIFT_MASKED_CIPHER_HPP_

#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"

// [RELEASE] [655.3 us] [OK]

class ShiftMaskedCipher final : public Cipher {
 public:
  ShiftMaskedCipher(std::uint8_t pMask, std::size_t pShift)
      : Cipher(CipherType::kShiftMaskedCipher),
        mMask(pMask),
        mShift(pShift) {}

  bool SealData(const std::uint8_t *pSource,
                std::uint8_t *pWorker,
                std::uint8_t *pDestination,
                std::size_t pLength,
                CipherErrorCode *pErrorCode) const override {
    (void)pWorker;
    return Apply(pSource, pDestination, pLength, InverseShift(mShift, pLength),
                 pErrorCode);
  }

  bool UnsealData(const std::uint8_t *pSource,
                  std::uint8_t *pWorker,
                  std::uint8_t *pDestination,
                  std::size_t pLength,
                  CipherErrorCode *pErrorCode) const override {
    (void)pWorker;
    return Apply(pSource, pDestination, pLength, NormalizeShift(mShift, pLength),
                 pErrorCode);
  }

  void Zero() override {
    mMask = 0U;
    mShift = 0U;
  }

 private:
  static constexpr std::size_t kLengthMultiple = 16u;

  static std::size_t NormalizeShift(std::size_t pShift,
                                    std::size_t pLength) {
    return pLength == 0u ? 0u : pShift % pLength;
  }

  static std::size_t InverseShift(std::size_t pShift,
                                  std::size_t pLength) {
    const std::size_t aRotation = NormalizeShift(pShift, pLength);
    if (aRotation == 0u) {
      return 0u;
    }
    return pLength - aRotation;
  }

  bool Apply(const std::uint8_t *pSource,
             std::uint8_t *pDestination,
             std::size_t pLength,
             std::size_t pRotation,
             CipherErrorCode *pErrorCode) const {
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
#if JELLY_USE_NEON
    ApplyNeon(pSource, pDestination, pLength, pRotation);
#elif JELLY_USE_SIMD
    ApplySimd(pSource, pDestination, pLength, pRotation);
#else
    ApplyScalar(pSource, pDestination, pLength, pRotation);
#endif
    return true;
  }

  void ApplyScalar(const std::uint8_t *pSource,
                   std::uint8_t *pDestination,
                   std::size_t pLength,
                   std::size_t pRotation) const {
    const std::uint8_t aAntimask = static_cast<std::uint8_t>(~mMask);
    for (std::size_t aIndex = 0u; aIndex < pLength; ++aIndex) {
      const std::size_t aSourceIndex =
          aIndex + pRotation < pLength ? aIndex + pRotation
                                       : aIndex + pRotation - pLength;
      pDestination[aIndex] = static_cast<std::uint8_t>(
          (pSource[aIndex] & aAntimask) |
          (pSource[aSourceIndex] & mMask));
    }
  }

#if JELLY_USE_SIMD
  void BlendSpanSimd(const std::uint8_t *pBaseSource,
                     const std::uint8_t *pMaskedSource,
                     std::uint8_t *pDestination,
                     std::size_t pLength) const {
    std::size_t aIndex = 0u;
#if defined(__AVX2__)
    const __m256i aMask256 = _mm256_set1_epi8(static_cast<char>(mMask));
    const __m256i aAntimask256 = _mm256_set1_epi8(
        static_cast<char>(static_cast<std::uint8_t>(~mMask)));
    for (; aIndex + 32u <= pLength; aIndex += 32u) {
      const __m256i aBase = _mm256_loadu_si256(
          reinterpret_cast<const __m256i *>(pBaseSource + aIndex));
      const __m256i aMasked = _mm256_loadu_si256(
          reinterpret_cast<const __m256i *>(pMaskedSource + aIndex));
      const __m256i aResult =
          _mm256_or_si256(_mm256_and_si256(aBase, aAntimask256),
                          _mm256_and_si256(aMasked, aMask256));
      _mm256_storeu_si256(reinterpret_cast<__m256i *>(pDestination + aIndex),
                          aResult);
    }
#endif
    const __m128i aMask128 = _mm_set1_epi8(static_cast<char>(mMask));
    const __m128i aAntimask128 =
        _mm_set1_epi8(static_cast<char>(static_cast<std::uint8_t>(~mMask)));
    for (; aIndex + 16u <= pLength; aIndex += 16u) {
      const __m128i aBase = _mm_loadu_si128(
          reinterpret_cast<const __m128i *>(pBaseSource + aIndex));
      const __m128i aMasked = _mm_loadu_si128(
          reinterpret_cast<const __m128i *>(pMaskedSource + aIndex));
      const __m128i aResult =
          _mm_or_si128(_mm_and_si128(aBase, aAntimask128),
                       _mm_and_si128(aMasked, aMask128));
      _mm_storeu_si128(reinterpret_cast<__m128i *>(pDestination + aIndex),
                       aResult);
    }

    const std::uint8_t aAntimask = static_cast<std::uint8_t>(~mMask);
    for (; aIndex < pLength; ++aIndex) {
      pDestination[aIndex] = static_cast<std::uint8_t>(
          (pBaseSource[aIndex] & aAntimask) |
          (pMaskedSource[aIndex] & mMask));
    }
  }

  void ApplySimd(const std::uint8_t *pSource,
                 std::uint8_t *pDestination,
                 std::size_t pLength,
                 std::size_t pRotation) const {
    const std::size_t aFirstSpan = pLength - pRotation;
    BlendSpanSimd(pSource, pSource + pRotation, pDestination, aFirstSpan);
    if (pRotation != 0u) {
      BlendSpanSimd(pSource + aFirstSpan, pSource, pDestination + aFirstSpan,
                    pRotation);
    }
  }
#endif

#if JELLY_USE_NEON
  void BlendSpanNeon(const std::uint8_t *pBaseSource,
                     const std::uint8_t *pMaskedSource,
                     std::uint8_t *pDestination,
                     std::size_t pLength) const {
    const uint8x16_t aMask = vdupq_n_u8(mMask);
    const uint8x16_t aAntimask = vmvnq_u8(aMask);
    std::size_t aIndex = 0u;
    for (; aIndex + 16u <= pLength; aIndex += 16u) {
      const uint8x16_t aBase = vld1q_u8(pBaseSource + aIndex);
      const uint8x16_t aMasked = vld1q_u8(pMaskedSource + aIndex);
      const uint8x16_t aResult =
          vorrq_u8(vandq_u8(aBase, aAntimask), vandq_u8(aMasked, aMask));
      vst1q_u8(pDestination + aIndex, aResult);
    }

    const std::uint8_t aAntimaskScalar = static_cast<std::uint8_t>(~mMask);
    for (; aIndex < pLength; ++aIndex) {
      pDestination[aIndex] = static_cast<std::uint8_t>(
          (pBaseSource[aIndex] & aAntimaskScalar) |
          (pMaskedSource[aIndex] & mMask));
    }
  }

  void ApplyNeon(const std::uint8_t *pSource,
                 std::uint8_t *pDestination,
                 std::size_t pLength,
                 std::size_t pRotation) const {
    const std::size_t aFirstSpan = pLength - pRotation;
    BlendSpanNeon(pSource, pSource + pRotation, pDestination, aFirstSpan);
    if (pRotation != 0u) {
      BlendSpanNeon(pSource + aFirstSpan, pSource, pDestination + aFirstSpan,
                    pRotation);
    }
  }
#endif

  std::uint8_t mMask;
  std::size_t mShift;
};

#endif  // JELLY_SHIFT_MASKED_CIPHER_HPP_
