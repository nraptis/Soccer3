#ifndef JELLY_RIPPLE_MASK_BLOCK_CIPHER_32_HPP_
#define JELLY_RIPPLE_MASK_BLOCK_CIPHER_32_HPP_

#include <cstddef>
#include <cstdint>
#include <cstring>

#include "Jelly.hpp"
#include "Cipher.hpp"

// [RELEASE] [179.2 us] [OK]

class RippleMaskBlockCipher32 final : public Cipher {
 public:
  explicit RippleMaskBlockCipher32(std::uint8_t pMask)
      : Cipher(CipherType::kRippleMaskBlockCipher32),
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
    const std::size_t aBlockCount = pLength / kBlockSize;
    ApplyMaskedBlockPass(pSource, pDestination, aBlockCount);
    return true;
  }

  void ApplyMaskedBlockPass(const std::uint8_t *pSource,
                            std::uint8_t *pDestination,
                            std::size_t pBlockCount) const {
    std::size_t aBlock = 0u;
    for (; aBlock + 1u < pBlockCount; aBlock += 2u) {
      const std::size_t aLeftOffset = aBlock * kBlockSize;
      const std::size_t aRightOffset = aLeftOffset + kBlockSize;
      BlendBlocks(pDestination + aLeftOffset, pSource + aLeftOffset,
                  pSource + aRightOffset);
      BlendBlocks(pDestination + aRightOffset, pSource + aRightOffset,
                  pSource + aLeftOffset);
    }

    if (aBlock < pBlockCount) {
      const std::size_t aOffset = aBlock * kBlockSize;
      CopyBlock(pDestination + aOffset, pSource + aOffset);
    }
  }

  static void CopyBlock(std::uint8_t *pDestination,
                        const std::uint8_t *pSource) {
    std::memcpy(pDestination, pSource, kBlockSize);
  }

  void BlendBlocks(std::uint8_t *pDestination,
                   const std::uint8_t *pBaseBlock,
                   const std::uint8_t *pMovedBlock) const {
#if JELLY_USE_NEON
    BlendBlocksNeon(pDestination, pBaseBlock, pMovedBlock);
#elif JELLY_USE_SIMD
    BlendBlocksSimd(pDestination, pBaseBlock, pMovedBlock);
#else
    BlendBlocksScalar(pDestination, pBaseBlock, pMovedBlock);
#endif
  }

  void BlendBlocksScalar(std::uint8_t *pDestination,
                         const std::uint8_t *pBaseBlock,
                         const std::uint8_t *pMovedBlock) const {
    const std::uint8_t aAntimask = static_cast<std::uint8_t>(~mMask);
    for (std::size_t aIndex = 0u; aIndex < kBlockSize; ++aIndex) {
      pDestination[aIndex] = static_cast<std::uint8_t>(
          (pBaseBlock[aIndex] & aAntimask) |
          (pMovedBlock[aIndex] & mMask));
    }
  }

#if JELLY_USE_SIMD
  void BlendBlocksSimd(std::uint8_t *pDestination,
                       const std::uint8_t *pBaseBlock,
                       const std::uint8_t *pMovedBlock) const {
#if defined(__AVX2__)
    const __m256i aMask = _mm256_set1_epi8(static_cast<char>(mMask));
    const __m256i aAntimask = _mm256_set1_epi8(
        static_cast<char>(static_cast<std::uint8_t>(~mMask)));
    const __m256i aBase =
        _mm256_loadu_si256(reinterpret_cast<const __m256i *>(pBaseBlock));
    const __m256i aMoved =
        _mm256_loadu_si256(reinterpret_cast<const __m256i *>(pMovedBlock));
    const __m256i aResult =
        _mm256_or_si256(_mm256_and_si256(aBase, aAntimask),
                        _mm256_and_si256(aMoved, aMask));
    _mm256_storeu_si256(reinterpret_cast<__m256i *>(pDestination), aResult);
#else
    const __m128i aMask = _mm_set1_epi8(static_cast<char>(mMask));
    const __m128i aAntimask =
        _mm_set1_epi8(static_cast<char>(static_cast<std::uint8_t>(~mMask)));
    for (std::size_t aOffset = 0u; aOffset < kBlockSize; aOffset += 16u) {
      const __m128i aBase = _mm_loadu_si128(
          reinterpret_cast<const __m128i *>(pBaseBlock + aOffset));
      const __m128i aMoved = _mm_loadu_si128(
          reinterpret_cast<const __m128i *>(pMovedBlock + aOffset));
      const __m128i aResult =
          _mm_or_si128(_mm_and_si128(aBase, aAntimask),
                       _mm_and_si128(aMoved, aMask));
      _mm_storeu_si128(reinterpret_cast<__m128i *>(pDestination + aOffset),
                       aResult);
    }
#endif
  }
#endif

#if JELLY_USE_NEON
  void BlendBlocksNeon(std::uint8_t *pDestination,
                       const std::uint8_t *pBaseBlock,
                       const std::uint8_t *pMovedBlock) const {
    const uint8x16_t aMask = vdupq_n_u8(mMask);
    const uint8x16_t aAntimask = vmvnq_u8(aMask);
    for (std::size_t aOffset = 0u; aOffset < kBlockSize; aOffset += 16u) {
      const uint8x16_t aBase = vld1q_u8(pBaseBlock + aOffset);
      const uint8x16_t aMoved = vld1q_u8(pMovedBlock + aOffset);
      const uint8x16_t aResult =
          vorrq_u8(vandq_u8(aBase, aAntimask),
                   vandq_u8(aMoved, aMask));
      vst1q_u8(pDestination + aOffset, aResult);
    }
  }
#endif

  std::uint8_t mMask;
};

#endif  // JELLY_RIPPLE_MASK_BLOCK_CIPHER_32_HPP_
