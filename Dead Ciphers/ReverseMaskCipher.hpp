#ifndef JELLY_REVERSE_MASK_CIPHER_HPP_
#define JELLY_REVERSE_MASK_CIPHER_HPP_

#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"

// [RELEASE] [30.7 us] [OK]

class ReverseMaskCipher final : public Cipher {
 public:
  explicit ReverseMaskCipher(std::uint8_t pMask)
      : Cipher(CipherType::kReverseMaskCipher),
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
      const std::uint8_t aBase =
          static_cast<std::uint8_t>(pSource[aIndex] & aAntimask);
      const std::uint8_t aMasked = static_cast<std::uint8_t>(
          pSource[pLength - 1u - aIndex] & mMask);
      pDestination[aIndex] = static_cast<std::uint8_t>(aBase | aMasked);
    }
  }

#if JELLY_USE_SIMD
  void ApplySimd(const std::uint8_t *pSource,
                 std::uint8_t *pDestination,
                 std::size_t pLength) const {
    std::size_t aOffset = 0u;
#if defined(__AVX2__)
    const __m256i aLanes256 = _mm256_setr_epi8(
        15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0,
        15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0);
    const __m256i aMask = _mm256_set1_epi8(static_cast<char>(mMask));
    const __m256i aAntimask = _mm256_set1_epi8(
        static_cast<char>(static_cast<std::uint8_t>(~mMask)));
    for (; aOffset + 32u <= pLength; aOffset += 32u) {
      const std::size_t aSourceOffset = pLength - aOffset - 32u;
      const __m256i aBase = _mm256_loadu_si256(
          reinterpret_cast<const __m256i *>(pSource + aOffset));
      const __m256i aBack = _mm256_loadu_si256(
          reinterpret_cast<const __m256i *>(pSource + aSourceOffset));
      __m256i aMaskedReversed = _mm256_shuffle_epi8(aBack, aLanes256);
      aMaskedReversed =
          _mm256_permute2x128_si256(aMaskedReversed, aMaskedReversed, 0x01);
      const __m256i aResult =
          _mm256_or_si256(_mm256_and_si256(aBase, aAntimask),
                          _mm256_and_si256(aMaskedReversed, aMask));
      _mm256_storeu_si256(reinterpret_cast<__m256i *>(pDestination + aOffset),
                          aResult);
    }
#endif
    const __m128i aLanes128 =
        _mm_setr_epi8(15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0);
    const __m128i aMask128 = _mm_set1_epi8(static_cast<char>(mMask));
    const __m128i aAntimask128 =
        _mm_set1_epi8(static_cast<char>(static_cast<std::uint8_t>(~mMask)));
    for (; aOffset + 16u <= pLength; aOffset += 16u) {
      const std::size_t aSourceOffset = pLength - aOffset - 16u;
      const __m128i aBase = _mm_loadu_si128(
          reinterpret_cast<const __m128i *>(pSource + aOffset));
      const __m128i aBack = _mm_loadu_si128(
          reinterpret_cast<const __m128i *>(pSource + aSourceOffset));
      const __m128i aMaskedReversed = _mm_shuffle_epi8(aBack, aLanes128);
      const __m128i aResult =
          _mm_or_si128(_mm_and_si128(aBase, aAntimask128),
                       _mm_and_si128(aMaskedReversed, aMask128));
      _mm_storeu_si128(reinterpret_cast<__m128i *>(pDestination + aOffset),
                       aResult);
    }
  }
#endif

#if JELLY_USE_NEON
  void ApplyNeon(const std::uint8_t *pSource,
                 std::uint8_t *pDestination,
                 std::size_t pLength) const {
    alignas(16) static const std::uint8_t kLaneMap[16] = {
        15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0};
    const uint8x16_t aLanes = vld1q_u8(kLaneMap);
    const uint8x16_t aMask = vdupq_n_u8(mMask);
    const uint8x16_t aAntimask = vmvnq_u8(aMask);

    for (std::size_t aOffset = 0u; aOffset < pLength; aOffset += 16u) {
      const std::size_t aSourceOffset = pLength - aOffset - 16u;
      const uint8x16_t aBase = vld1q_u8(pSource + aOffset);
      const uint8x16_t aBack = vld1q_u8(pSource + aSourceOffset);
      const uint8x16_t aMaskedReversed = vqtbl1q_u8(aBack, aLanes);
      const uint8x16_t aResult =
          vorrq_u8(vandq_u8(aBase, aAntimask),
                   vandq_u8(aMaskedReversed, aMask));
      vst1q_u8(pDestination + aOffset, aResult);
    }
  }
#endif

  std::uint8_t mMask;
};

#endif  // JELLY_REVERSE_MASK_CIPHER_HPP_
