#ifndef JELLY_REVERSE_MASK_BYTE_BLOCK_CIPHER_32_HPP_
#define JELLY_REVERSE_MASK_BYTE_BLOCK_CIPHER_32_HPP_

#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"

// [RELEASE] [25.2 us] [OK]

class ReverseMaskByteBlockCipher32 final : public Cipher {
 public:
  explicit ReverseMaskByteBlockCipher32(std::uint8_t pMask)
      : Cipher(CipherType::kReverseMaskByteBlockCipher32),
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
  static constexpr std::size_t kBlockSize = 32u;
  static constexpr std::size_t kLengthMultiple = 32u;

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
    return ApplyNeon(pSource, pDestination, pLength);
#elif JELLY_USE_SIMD
    return ApplySimd(pSource, pDestination, pLength);
#else
    return ApplyScalar(pSource, pDestination, pLength);
#endif
  }

  bool ApplyScalar(const std::uint8_t *pSource,
                   std::uint8_t *pDestination,
                   std::size_t pLength) const {
    const std::uint8_t aAntimask = static_cast<std::uint8_t>(~mMask);

    for (std::size_t aBase = 0u; aBase < pLength; aBase += kBlockSize) {
      for (std::size_t aByte = 0u; aByte < kBlockSize; ++aByte) {
        const std::uint8_t aBaseByte =
            static_cast<std::uint8_t>(pSource[aBase + aByte] & aAntimask);
        const std::uint8_t aMaskedByte = static_cast<std::uint8_t>(
            pSource[aBase + (kBlockSize - 1u - aByte)] & mMask);
        pDestination[aBase + aByte] =
            static_cast<std::uint8_t>(aBaseByte | aMaskedByte);
      }
    }

    return true;
  }

#if JELLY_USE_SIMD
  bool ApplySimd(const std::uint8_t *pSource,
                 std::uint8_t *pDestination,
                 std::size_t pLength) const {
    const __m128i aLanes =
        _mm_setr_epi8(15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0);
    const __m128i aMask = _mm_set1_epi8(static_cast<char>(mMask));
    const __m128i aAntimask =
        _mm_set1_epi8(static_cast<char>(static_cast<std::uint8_t>(~mMask)));

    for (std::size_t aBase = 0u; aBase < pLength; aBase += kBlockSize) {
      const __m128i aSource0 =
          _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource + aBase));
      const __m128i aSource1 = _mm_loadu_si128(
          reinterpret_cast<const __m128i *>(pSource + aBase + 16u));
      const __m128i aReversed0 = _mm_shuffle_epi8(aSource1, aLanes);
      const __m128i aReversed1 = _mm_shuffle_epi8(aSource0, aLanes);
      const __m128i aResult0 =
          _mm_or_si128(_mm_and_si128(aSource0, aAntimask),
                       _mm_and_si128(aReversed0, aMask));
      const __m128i aResult1 =
          _mm_or_si128(_mm_and_si128(aSource1, aAntimask),
                       _mm_and_si128(aReversed1, aMask));
      _mm_storeu_si128(reinterpret_cast<__m128i *>(pDestination + aBase),
                       aResult0);
      _mm_storeu_si128(
          reinterpret_cast<__m128i *>(pDestination + aBase + 16u), aResult1);
    }

    return true;
  }
#endif

#if JELLY_USE_NEON
  bool ApplyNeon(const std::uint8_t *pSource,
                 std::uint8_t *pDestination,
                 std::size_t pLength) const {
    alignas(16) static const std::uint8_t kLaneMap[16] = {
        15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0};
    const uint8x16_t aLanes = vld1q_u8(kLaneMap);
    const uint8x16_t aMask = vdupq_n_u8(mMask);
    const uint8x16_t aAntimask = vmvnq_u8(aMask);

    for (std::size_t aBase = 0u; aBase < pLength; aBase += kBlockSize) {
      const uint8x16_t aSource0 = vld1q_u8(pSource + aBase);
      const uint8x16_t aSource1 = vld1q_u8(pSource + aBase + 16u);
      const uint8x16_t aReversed0 = vqtbl1q_u8(aSource1, aLanes);
      const uint8x16_t aReversed1 = vqtbl1q_u8(aSource0, aLanes);
      const uint8x16_t aResult0 =
          vorrq_u8(vandq_u8(aSource0, aAntimask),
                   vandq_u8(aReversed0, aMask));
      const uint8x16_t aResult1 =
          vorrq_u8(vandq_u8(aSource1, aAntimask),
                   vandq_u8(aReversed1, aMask));
      vst1q_u8(pDestination + aBase, aResult0);
      vst1q_u8(pDestination + aBase + 16u, aResult1);
    }

    return true;
  }
#endif

  std::uint8_t mMask;
};

#endif  // JELLY_REVERSE_MASK_BYTE_BLOCK_CIPHER_32_HPP_
