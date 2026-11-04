#ifndef JELLY_PASSWORD_JUMP_XOR_CIPHER_HPP_
#define JELLY_PASSWORD_JUMP_XOR_CIPHER_HPP_

#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"

// [RELEASE] [316.3 us] [OK]

class PasswordJumpXORCipher final : public Cipher {
 public:
  PasswordJumpXORCipher(const std::uint8_t *pPassword,
                        const std::uint8_t *pJumps)
      : Cipher(CipherType::kPasswordJumpXORCipher),
        mPassword(pPassword),
        mJumps(pJumps) {}

  bool SealData(const std::uint8_t *pSource,
                std::uint8_t *pWorker,
                std::uint8_t *pDestination,
                std::size_t pLength,
                CipherErrorCode *pErrorCode) const override {
    return Apply(pSource, pWorker, pDestination, pLength, pErrorCode);
  }

  bool UnsealData(const std::uint8_t *pSource,
                  std::uint8_t *pWorker,
                  std::uint8_t *pDestination,
                  std::size_t pLength,
                  CipherErrorCode *pErrorCode) const override {
    return Apply(pSource, pWorker, pDestination, pLength, pErrorCode);
  }

 private:
  static constexpr std::size_t kLengthMultiple = 32u;

  bool Apply(const std::uint8_t *pSource,
             std::uint8_t *pWorker,
             std::uint8_t *pDestination,
             std::size_t pLength,
             CipherErrorCode *pErrorCode) const {
    (void)pWorker;
    if (pLength == 0u) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
      return true;
    }
    if ((pLength % kLengthMultiple) != 0u) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength);
      return false;
    }
    if (pSource == nullptr || pDestination == nullptr || mPassword == nullptr ||
        mJumps == nullptr) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
      return false;
    }
    if (pSource == pDestination) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
      return false;
    }

    SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);

    const std::size_t aChunkCount = pLength >> 4;
    const bool aPowerOfTwoPasswordChunks =
        (aChunkCount & (aChunkCount - 1u)) == 0u;

    std::size_t aPasswordChunkIndex = 0u;

    for (std::size_t aChunk = 0u; aChunk < aChunkCount; ++aChunk) {
      const std::uint8_t *aSourcePtr = pSource + (aChunk << 4);
      const std::uint8_t *aPasswordPtr =
          mPassword + (aPasswordChunkIndex << 4);
      std::uint8_t *aDestinationPtr = pDestination + (aChunk << 4);

#if JELLY_USE_NEON
      ApplyChunkNeon(aSourcePtr, aPasswordPtr, aDestinationPtr);
#elif JELLY_USE_SIMD
      ApplyChunkSimd(aSourcePtr, aPasswordPtr, aDestinationPtr);
#else
      ApplyChunkScalar(aSourcePtr, aPasswordPtr, aDestinationPtr);
#endif

      const std::size_t aJump = static_cast<std::size_t>(mJumps[aChunk]);
      aPasswordChunkIndex += aJump;
      if (aPowerOfTwoPasswordChunks) {
        aPasswordChunkIndex &= (aChunkCount - 1u);
      } else {
        aPasswordChunkIndex %= aChunkCount;
      }
    }

    return true;
  }

  static void ApplyChunkScalar(const std::uint8_t *pSource,
                               const std::uint8_t *pPassword,
                               std::uint8_t *pDestination) {
    for (std::size_t aIndex = 0u; aIndex < 16u; ++aIndex) {
      pDestination[aIndex] =
          static_cast<std::uint8_t>(pSource[aIndex] ^ pPassword[aIndex]);
    }
  }

#if JELLY_USE_SIMD
  static void ApplyChunkSimd(const std::uint8_t *pSource,
                             const std::uint8_t *pPassword,
                             std::uint8_t *pDestination) {
    _mm_storeu_si128(
        reinterpret_cast<__m128i *>(pDestination),
        _mm_xor_si128(
            _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource)),
            _mm_loadu_si128(reinterpret_cast<const __m128i *>(pPassword))));
  }
#endif

#if JELLY_USE_NEON
  static void ApplyChunkNeon(const std::uint8_t *pSource,
                             const std::uint8_t *pPassword,
                             std::uint8_t *pDestination) {
    vst1q_u8(pDestination,
             veorq_u8(vld1q_u8(pSource), vld1q_u8(pPassword)));
  }
#endif

  const std::uint8_t *mPassword = nullptr;
  const std::uint8_t *mJumps = nullptr;
};

#endif  // JELLY_PASSWORD_JUMP_XOR_CIPHER_HPP_
