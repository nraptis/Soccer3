#ifndef JELLY_INVERT_MASK_CIPHER_HPP_
#define JELLY_INVERT_MASK_CIPHER_HPP_

#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"

// [RELEASE] [22.2 us] [OK]

class InvertMaskCipher final : public Cipher {
 public:
  explicit InvertMaskCipher(std::uint8_t pMask)
      : Cipher(CipherType::kInvertMaskCipher),
        mMask(pMask) {}

  bool SealData(const std::uint8_t *pSource,
                std::uint8_t *pWorker,
                std::uint8_t *pDestination,
                std::size_t pLength,
                CipherErrorCode *pErrorCode) const override {
    (void)pWorker;
    return Apply(pSource, pDestination, pLength, pErrorCode);
  }

  bool UnsealData(const std::uint8_t *pSource,
                  std::uint8_t *pWorker,
                  std::uint8_t *pDestination,
                  std::size_t pLength,
                  CipherErrorCode *pErrorCode) const override {
    (void)pWorker;
    return Apply(pSource, pDestination, pLength, pErrorCode);
  }

  void Zero() override {
    mMask = 0U;
  }

 private:
  static constexpr std::size_t kLengthMultiple = 16u;

  bool Apply(const std::uint8_t *pSource,
             std::uint8_t *pDestination,
             std::size_t pLength,
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
    ApplyNeon(pSource, pDestination, pLength);
#elif JELLY_USE_SIMD
    ApplySimd(pSource, pDestination, pLength);
#else
    ApplyScalar(pSource, pDestination, pLength);
#endif
    return true;
  }

  void ApplyScalar(const std::uint8_t *pSource,
                   std::uint8_t *pDestination,
                   std::size_t pLength) const {
    const std::uint8_t aAntimask = static_cast<std::uint8_t>(~mMask);
    for (std::size_t aIndex = 0u; aIndex < pLength; ++aIndex) {
      const std::uint8_t aMaskedBits = static_cast<std::uint8_t>(
          static_cast<std::uint8_t>(~pSource[aIndex]) & mMask);
      const std::uint8_t aBase =
          static_cast<std::uint8_t>(pSource[aIndex] & aAntimask);
      pDestination[aIndex] = static_cast<std::uint8_t>(aBase | aMaskedBits);
    }
  }

#if JELLY_USE_SIMD
  void ApplySimd(const std::uint8_t *pSource,
                 std::uint8_t *pDestination,
                 std::size_t pLength) const {
    std::size_t aOffset = 0u;
#if defined(__AVX2__)
    const __m256i aMask256 = _mm256_set1_epi8(static_cast<char>(mMask));
    const __m256i aAntimask256 = _mm256_set1_epi8(
        static_cast<char>(static_cast<std::uint8_t>(~mMask)));
    for (; aOffset + 32u <= pLength; aOffset += 32u) {
      const __m256i aSource = _mm256_loadu_si256(
          reinterpret_cast<const __m256i *>(pSource + aOffset));
      const __m256i aMasked = _mm256_andnot_si256(aSource, aMask256);
      const __m256i aBase = _mm256_and_si256(aSource, aAntimask256);
      const __m256i aResult = _mm256_or_si256(aBase, aMasked);
      _mm256_storeu_si256(reinterpret_cast<__m256i *>(pDestination + aOffset),
                          aResult);
    }
#endif

    const __m128i aMask128 = _mm_set1_epi8(static_cast<char>(mMask));
    const __m128i aAntimask128 = _mm_set1_epi8(
        static_cast<char>(static_cast<std::uint8_t>(~mMask)));
    for (; aOffset + 16u <= pLength; aOffset += 16u) {
      const __m128i aSource = _mm_loadu_si128(
          reinterpret_cast<const __m128i *>(pSource + aOffset));
      const __m128i aMasked = _mm_andnot_si128(aSource, aMask128);
      const __m128i aBase = _mm_and_si128(aSource, aAntimask128);
      const __m128i aResult = _mm_or_si128(aBase, aMasked);
      _mm_storeu_si128(reinterpret_cast<__m128i *>(pDestination + aOffset),
                       aResult);
    }
  }
#endif

#if JELLY_USE_NEON
  void ApplyNeon(const std::uint8_t *pSource,
                 std::uint8_t *pDestination,
                 std::size_t pLength) const {
    const uint8x16_t aMask = vdupq_n_u8(mMask);
    const uint8x16_t aAntimask = vmvnq_u8(aMask);

    for (std::size_t aOffset = 0u; aOffset < pLength; aOffset += 16u) {
      const uint8x16_t aSource = vld1q_u8(pSource + aOffset);
      const uint8x16_t aMasked = vandq_u8(vmvnq_u8(aSource), aMask);
      const uint8x16_t aBase = vandq_u8(aSource, aAntimask);
      vst1q_u8(pDestination + aOffset, vorrq_u8(aBase, aMasked));
    }
  }
#endif

  std::uint8_t mMask;
};

#endif  // JELLY_INVERT_MASK_CIPHER_HPP_
