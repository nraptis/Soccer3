#ifndef SOCCER_TREE_FROG_TWO_HPP_
#define SOCCER_TREE_FROG_TWO_HPP_

#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"
#if !IGNORE_SIMD && defined(__SSE2__)
#include <immintrin.h>
#endif

// Each byte supplies its own two control bits. Keep those bits unchanged.
// If BOTH are one, copy the byte; otherwise invert the other six bits.
// The preserved controls make the transform its own inverse.
//
// P = protected mask, W = ~P:
//   output = input ^ (((input & P) == P) ? 0 : W)
// This is nonlinear, but XOR parity between two writable bits is preserved.
// It supplies no diffusion between bytes and is not a complete cipher alone.
//
// Any length and unaligned buffers are supported. Nonempty source/destination
// buffers must not overlap. No worker, material, lookup table, or allocation.
class TreeFrogTwo final : public Cipher {
 public:
  TreeFrogTwo(std::size_t pRowA, std::size_t pRowB)
      : Cipher(CipherType::kTreeFrogTwo),
        mProtectedMask(pRowA < 8u && pRowB < 8u && pRowA != pRowB
            ? static_cast<std::uint8_t>((1u << pRowA) | (1u << pRowB)) : 0u) {}

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
    // Restore the default public row configuration: 0 and 1.
    mProtectedMask = 0x03u;
  }

 private:
  bool Apply(const std::uint8_t *pSource,
             std::uint8_t *pDestination,
             std::size_t pLength,
             CipherErrorCode *pErrorCode) const {
    if (pLength == 0u) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
      return true;
    }
    if (mProtectedMask == 0u) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidParameter);
      return false;
    }
    if (pSource == nullptr || pDestination == nullptr) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
      return false;
    }
    const std::uintptr_t aSourceAddress = reinterpret_cast<std::uintptr_t>(pSource);
    const std::uintptr_t aDestinationAddress = reinterpret_cast<std::uintptr_t>(pDestination);
    const std::uintptr_t aBufferDistance = aSourceAddress <= aDestinationAddress
        ? aDestinationAddress - aSourceAddress : aSourceAddress - aDestinationAddress;
    if (aBufferDistance < pLength) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
      return false;
    }

    const auto aWritableMask = static_cast<std::uint8_t>(~mProtectedMask);
    std::size_t aOffset = 0u;
#if JELLY_USE_NEON
    const uint8x16_t aProtected = vdupq_n_u8(mProtectedMask);
    const uint8x16_t aWritable = vdupq_n_u8(aWritableMask);
    for (; pLength - aOffset >= 16u; aOffset += 16u) {
      const uint8x16_t aValue = vld1q_u8(pSource + aOffset);
      const uint8x16_t aBothSet = vceqq_u8(vandq_u8(aValue, aProtected), aProtected);
      const uint8x16_t aFlipMask = vbicq_u8(aWritable, aBothSet);
      vst1q_u8(pDestination + aOffset, veorq_u8(aValue, aFlipMask));
    }
#elif !IGNORE_SIMD && defined(__SSE2__)
#if defined(__AVX2__)
    const __m256i aProtectedWide = _mm256_set1_epi8(static_cast<char>(mProtectedMask));
    const __m256i aWritableWide = _mm256_set1_epi8(static_cast<char>(aWritableMask));
    for (; pLength - aOffset >= 32u; aOffset += 32u) {
      const __m256i aValue = _mm256_loadu_si256(reinterpret_cast<const __m256i *>(pSource + aOffset));
      const __m256i aBothSet = _mm256_cmpeq_epi8(_mm256_and_si256(aValue, aProtectedWide), aProtectedWide);
      const __m256i aFlipMask = _mm256_andnot_si256(aBothSet, aWritableWide);
      _mm256_storeu_si256(reinterpret_cast<__m256i *>(pDestination + aOffset), _mm256_xor_si256(aValue, aFlipMask));
    }
#endif
    const __m128i aProtected = _mm_set1_epi8(static_cast<char>(mProtectedMask));
    const __m128i aWritable = _mm_set1_epi8(static_cast<char>(aWritableMask));
    for (; pLength - aOffset >= 16u; aOffset += 16u) {
      const __m128i aValue = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource + aOffset));
      const __m128i aBothSet = _mm_cmpeq_epi8(_mm_and_si128(aValue, aProtected), aProtected);
      const __m128i aFlipMask = _mm_andnot_si128(aBothSet, aWritable);
      _mm_storeu_si128(reinterpret_cast<__m128i *>(pDestination + aOffset), _mm_xor_si128(aValue, aFlipMask));
    }
#endif
    for (; aOffset < pLength; ++aOffset) {
      const std::uint8_t aValue = pSource[aOffset];
      const auto aFlipMask = static_cast<std::uint8_t>(
          (0u - static_cast<unsigned>((aValue & mProtectedMask) != mProtectedMask)) & aWritableMask);
      pDestination[aOffset] = aValue ^ aFlipMask;
    }
    SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
    return true;
  }

  std::uint8_t mProtectedMask;
};

#endif  // SOCCER_TREE_FROG_TWO_HPP_
