#ifndef JELLY_PEPPER_JUMP_NOISE_XOR_CIPHER_HPP_
#define JELLY_PEPPER_JUMP_NOISE_XOR_CIPHER_HPP_

#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"

// [RELEASE] [459.4 us] [OK]

class PepperJumpNoiseXORCipher final : public Cipher {
 public:
  PepperJumpNoiseXORCipher(const std::uint8_t *pMask,
                           const std::uint8_t *pNoise,
                           const std::uint8_t *pJumps)
      : Cipher(CipherType::kPepperJumpNoiseXORCipher),
        mMask(pMask),
        mNoise(pNoise),
        mJumps(pJumps) {}

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
    if (pSource == nullptr || pDestination == nullptr || mMask == nullptr ||
        mNoise == nullptr || mJumps == nullptr) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
      return false;
    }
    if (pSource == pDestination) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
      return false;
    }

    SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
    const std::size_t aChunkCount = pLength >> 4u;
    const bool aPowerOfTwoChunkCount =
        (aChunkCount & (aChunkCount - 1u)) == 0u;
    std::size_t aMaskChunkIndex = 0u;
    std::size_t aNoiseChunkIndex = 0u;
    std::size_t aJumpIndex = 0u;

    for (std::size_t aChunk = 0u; aChunk < aChunkCount; ++aChunk) {
      const std::uint8_t *aSourcePtr = pSource + (aChunk << 4u);
      const std::uint8_t *aMaskPtr = mMask + (aMaskChunkIndex << 4u);
      const std::uint8_t *aNoisePtr = mNoise + (aNoiseChunkIndex << 4u);
      std::uint8_t *aDestinationPtr = pDestination + (aChunk << 4u);

#if JELLY_USE_NEON
      ApplyChunkNeon(aSourcePtr, aMaskPtr, aNoisePtr, aDestinationPtr);
#elif JELLY_USE_SIMD
      ApplyChunkSimd(aSourcePtr, aMaskPtr, aNoisePtr, aDestinationPtr);
#else
      ApplyChunkScalar(aSourcePtr, aMaskPtr, aNoisePtr, aDestinationPtr);
#endif

      const std::size_t aJump = static_cast<std::size_t>(mJumps[aJumpIndex]);
      ++aJumpIndex;
      if (aJumpIndex == pLength) {
        aJumpIndex = 0u;
      }

      aMaskChunkIndex += aJump;
      aNoiseChunkIndex += aJump;
      if (aPowerOfTwoChunkCount) {
        aMaskChunkIndex &= (aChunkCount - 1u);
        aNoiseChunkIndex &= (aChunkCount - 1u);
      } else {
        aMaskChunkIndex %= aChunkCount;
        aNoiseChunkIndex %= aChunkCount;
      }
    }

    return true;
  }

  static void ApplyChunkScalar(const std::uint8_t *pSource,
                               const std::uint8_t *pMask,
                               const std::uint8_t *pNoise,
                               std::uint8_t *pDestination) {
    for (std::size_t aIndex = 0u; aIndex < 16u; ++aIndex) {
      pDestination[aIndex] = static_cast<std::uint8_t>(
          pSource[aIndex] ^ pMask[aIndex] ^ pNoise[aIndex]);
    }
  }

#if JELLY_USE_SIMD
  static void ApplyChunkSimd(const std::uint8_t *pSource,
                             const std::uint8_t *pMask,
                             const std::uint8_t *pNoise,
                             std::uint8_t *pDestination) {
    _mm_storeu_si128(
        reinterpret_cast<__m128i *>(pDestination),
        _mm_xor_si128(
            _mm_xor_si128(
                _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource)),
                _mm_loadu_si128(reinterpret_cast<const __m128i *>(pMask))),
            _mm_loadu_si128(reinterpret_cast<const __m128i *>(pNoise))));
  }
#endif

#if JELLY_USE_NEON
  static void ApplyChunkNeon(const std::uint8_t *pSource,
                             const std::uint8_t *pMask,
                             const std::uint8_t *pNoise,
                             std::uint8_t *pDestination) {
    vst1q_u8(pDestination,
             veorq_u8(veorq_u8(vld1q_u8(pSource), vld1q_u8(pMask)),
                      vld1q_u8(pNoise)));
  }
#endif

  const std::uint8_t *mMask = nullptr;
  const std::uint8_t *mNoise = nullptr;
  const std::uint8_t *mJumps = nullptr;
};

#endif  // JELLY_PEPPER_JUMP_NOISE_XOR_CIPHER_HPP_
