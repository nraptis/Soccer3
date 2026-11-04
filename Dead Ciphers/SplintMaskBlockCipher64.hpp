#ifndef JELLY_SPLINT_MASK_BLOCK_CIPHER_64_HPP_
#define JELLY_SPLINT_MASK_BLOCK_CIPHER_64_HPP_

#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"

// [RELEASE] [89.3 us] [OK]
// Note, we do not have this benchmark, this is from 48, but they are all same category.

class SplintMaskBlockCipher64 final : public Cipher {
 public:
  explicit SplintMaskBlockCipher64(std::uint8_t pMask)
      : Cipher(CipherType::kSplintMaskBlockCipher64),
        mMask(pMask) {}

  bool SealData(const std::uint8_t *pSource,
                std::uint8_t *pWorker,
                std::uint8_t *pDestination,
                std::size_t pLength,
                CipherErrorCode *pErrorCode) const override {
    (void)pWorker;
    return ApplyEncrypt(pSource, pDestination, pLength, pErrorCode);
  }

  bool UnsealData(const std::uint8_t *pSource,
                  std::uint8_t *pWorker,
                  std::uint8_t *pDestination,
                  std::size_t pLength,
                  CipherErrorCode *pErrorCode) const override {
    (void)pWorker;
    return ApplyDecrypt(pSource, pDestination, pLength, pErrorCode);
  }

  void Zero() override {
    mMask = 0U;
  }

 private:
  static constexpr std::size_t kBlockSize = 64u;
  static constexpr std::size_t kLengthMultiple = 64u;

  bool ValidateInputs(const std::uint8_t *pSource,
                      const std::uint8_t *pDestination,
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
    return true;
  }

  bool ApplyEncrypt(const std::uint8_t *pSource,
                    std::uint8_t *pDestination,
                    std::size_t pLength,
                    CipherErrorCode *pErrorCode) const {
    if (!ValidateInputs(pSource, pDestination, pLength, pErrorCode)) {
      return false;
    }
    if (pLength == 0u) {
      return true;
    }

    const std::size_t aHalf = ((pLength >> 1u) / kBlockSize) * kBlockSize;
    std::size_t aFront = 0u;
    std::size_t aBack = aHalf;
    std::size_t aOut = 0u;

    while (aFront < aHalf && aBack < pLength) {
      BlendMasked(pSource + aOut, pSource + aFront, pDestination + aOut);
      aOut += kBlockSize;
      aFront += kBlockSize;
      BlendMasked(pSource + aOut, pSource + aBack, pDestination + aOut);
      aOut += kBlockSize;
      aBack += kBlockSize;
    }

    while (aFront < aHalf) {
      BlendMasked(pSource + aOut, pSource + aFront, pDestination + aOut);
      aOut += kBlockSize;
      aFront += kBlockSize;
    }

    while (aBack < pLength) {
      BlendMasked(pSource + aOut, pSource + aBack, pDestination + aOut);
      aOut += kBlockSize;
      aBack += kBlockSize;
    }

    return true;
  }

  bool ApplyDecrypt(const std::uint8_t *pSource,
                    std::uint8_t *pDestination,
                    std::size_t pLength,
                    CipherErrorCode *pErrorCode) const {
    if (!ValidateInputs(pSource, pDestination, pLength, pErrorCode)) {
      return false;
    }
    if (pLength == 0u) {
      return true;
    }

    const std::size_t aHalf = ((pLength >> 1u) / kBlockSize) * kBlockSize;
    std::size_t aIn = 0u;
    std::size_t aFront = 0u;
    std::size_t aBack = aHalf;

    while (aFront < aHalf && aBack < pLength && aIn < pLength) {
      BlendMasked(pSource + aFront, pSource + aIn, pDestination + aFront);
      aFront += kBlockSize;
      aIn += kBlockSize;
      BlendMasked(pSource + aBack, pSource + aIn, pDestination + aBack);
      aBack += kBlockSize;
      aIn += kBlockSize;
    }

    while (aFront < aHalf && aIn < pLength) {
      BlendMasked(pSource + aFront, pSource + aIn, pDestination + aFront);
      aFront += kBlockSize;
      aIn += kBlockSize;
    }

    while (aBack < pLength && aIn < pLength) {
      BlendMasked(pSource + aBack, pSource + aIn, pDestination + aBack);
      aBack += kBlockSize;
      aIn += kBlockSize;
    }

    return true;
  }

  void BlendMasked(const std::uint8_t *pBaseSource,
                   const std::uint8_t *pMaskedSource,
                   std::uint8_t *pDestination) const {
#if JELLY_USE_NEON
    BlendMaskedNeon(pBaseSource, pMaskedSource, pDestination);
#elif JELLY_USE_SIMD
    BlendMaskedSimd(pBaseSource, pMaskedSource, pDestination);
#else
    BlendMaskedScalar(pBaseSource, pMaskedSource, pDestination);
#endif
  }

  void BlendMaskedScalar(const std::uint8_t *pBaseSource,
                         const std::uint8_t *pMaskedSource,
                         std::uint8_t *pDestination) const {
    const std::uint8_t aAntimask = static_cast<std::uint8_t>(~mMask);
    for (std::size_t aIndex = 0u; aIndex < kBlockSize; ++aIndex) {
      pDestination[aIndex] = static_cast<std::uint8_t>(
          (pBaseSource[aIndex] & aAntimask) |
          (pMaskedSource[aIndex] & mMask));
    }
  }

#if JELLY_USE_SIMD
  void BlendMaskedSimd(const std::uint8_t *pBaseSource,
                       const std::uint8_t *pMaskedSource,
                       std::uint8_t *pDestination) const {
#if defined(__AVX2__)
    const __m256i aMask = _mm256_set1_epi8(static_cast<char>(mMask));
    const __m256i aAntimask = _mm256_set1_epi8(
        static_cast<char>(static_cast<std::uint8_t>(~mMask)));
    for (std::size_t aOffset = 0u; aOffset < kBlockSize; aOffset += 32u) {
      const __m256i aBase = _mm256_loadu_si256(
          reinterpret_cast<const __m256i *>(pBaseSource + aOffset));
      const __m256i aMasked = _mm256_loadu_si256(
          reinterpret_cast<const __m256i *>(pMaskedSource + aOffset));
      const __m256i aResult =
          _mm256_or_si256(_mm256_and_si256(aBase, aAntimask),
                          _mm256_and_si256(aMasked, aMask));
      _mm256_storeu_si256(
          reinterpret_cast<__m256i *>(pDestination + aOffset), aResult);
    }
#else
    const __m128i aMask = _mm_set1_epi8(static_cast<char>(mMask));
    const __m128i aAntimask =
        _mm_set1_epi8(static_cast<char>(static_cast<std::uint8_t>(~mMask)));
    for (std::size_t aOffset = 0u; aOffset < kBlockSize; aOffset += 16u) {
      const __m128i aBase = _mm_loadu_si128(
          reinterpret_cast<const __m128i *>(pBaseSource + aOffset));
      const __m128i aMasked = _mm_loadu_si128(
          reinterpret_cast<const __m128i *>(pMaskedSource + aOffset));
      const __m128i aResult =
          _mm_or_si128(_mm_and_si128(aBase, aAntimask),
                       _mm_and_si128(aMasked, aMask));
      _mm_storeu_si128(reinterpret_cast<__m128i *>(pDestination + aOffset),
                       aResult);
    }
#endif
  }
#endif

#if JELLY_USE_NEON
  void BlendMaskedNeon(const std::uint8_t *pBaseSource,
                       const std::uint8_t *pMaskedSource,
                       std::uint8_t *pDestination) const {
    const uint8x16_t aMask = vdupq_n_u8(mMask);
    const uint8x16_t aAntimask = vmvnq_u8(aMask);
    for (std::size_t aOffset = 0u; aOffset < kBlockSize; aOffset += 16u) {
      const uint8x16_t aBase = vld1q_u8(pBaseSource + aOffset);
      const uint8x16_t aMasked = vld1q_u8(pMaskedSource + aOffset);
      const uint8x16_t aResult =
          vorrq_u8(vandq_u8(aBase, aAntimask), vandq_u8(aMasked, aMask));
      vst1q_u8(pDestination + aOffset, aResult);
    }
  }
#endif

  std::uint8_t mMask;
};

#endif  // JELLY_SPLINT_MASK_BLOCK_CIPHER_64_HPP_
