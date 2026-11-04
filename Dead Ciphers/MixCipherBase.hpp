#ifndef SOCCER_MIX_CIPHER_BASE_HPP_
#define SOCCER_MIX_CIPHER_BASE_HPP_

#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"
#include "BlockRotation.hpp"

// Shared implementation for MixCipherA-H. ControlBit and Type are fixed at
// compile time; the NEON shifts and masks remain constant for each cipher.
//
// Self-inverse mixing with a rotation measured in 64-byte windows. Destination
// window w samples controls from source window (w + rotation) modulo the count.
// Rotation 1 therefore uses bytes 64..127 to alter bytes 0..63.
// Within that sampled window:
//   packed[g] bit b = source[8*g + b] bit ControlBit, for g,b in [0,7].
//   destination[i] = source[i] ^ (packed[i % 8] & ~(1U << ControlBit)).
// Preserving ControlBit in every byte lets the inverse reconstruct the same
// mask, including across windows. Seal and Unseal use the SAME rotation.
//
// Every variant omits eight source controls from its XOR mask: offsets
// ControlBit, ControlBit+8, ..., ControlBit+56. Those input bits are preserved
// but do not affect other bits in this operation. This is XOR-linear mixing,
// not a source of cryptographic nonlinearity.
//
// Length: zero or a multiple of 64. Source and destination must each cover
// pLength bytes and must not overlap. Unaligned buffers are supported.
// Worker is unused, is never accessed, and may be null. No allocation or
// state is retained between calls.
template <unsigned ControlBit, CipherType Type>
class MixCipherBase : public Cipher {
  static_assert(ControlBit < 8U, "Mix cipher control bit must be in [0,7].");

 public:
  explicit MixCipherBase(std::int32_t pBlockRotation = 0)
      : Cipher(Type), mBlockRotation(pBlockRotation) {}

  void Zero() override { mBlockRotation = 0; }

  static constexpr std::size_t kBlockBytes = 64U;

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
  static constexpr std::uint8_t MaskPosition(unsigned pBit) {
    return pBit == ControlBit ? 0U : static_cast<std::uint8_t>(1U << pBit);
  }

  static bool Overlaps(const std::uint8_t *pA,
                       const std::uint8_t *pB,
                       std::size_t pLength) {
    const auto aA = reinterpret_cast<std::uintptr_t>(pA);
    const auto aB = reinterpret_cast<std::uintptr_t>(pB);
    return (aA <= aB ? aB - aA : aA - aB) < pLength;
  }

  bool Apply(const std::uint8_t *pSource,
                     std::uint8_t *pDestination,
                     std::size_t pLength,
                     CipherErrorCode *pErrorCode) const {
    if (pLength == 0U) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
      return true;
    }
    if (pLength % kBlockBytes != 0U) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength);
      return false;
    }
    if (pSource == nullptr || pDestination == nullptr) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
      return false;
    }
    if (Overlaps(pSource, pDestination, pLength)) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
      return false;
    }
    SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);

    std::size_t aSampleOffset = soccer_cipher_detail::NormalizeBlockRotation(
        mBlockRotation, pLength / kBlockBytes) * kBlockBytes;

#if JELLY_USE_NEON && defined(__aarch64__)
    constexpr int kShift = static_cast<int>(ControlBit);
    const int8x16_t aShifts = {0-kShift, 1-kShift, 2-kShift, 3-kShift,
                              4-kShift, 5-kShift, 6-kShift, 7-kShift,
                              0-kShift, 1-kShift, 2-kShift, 3-kShift,
                              4-kShift, 5-kShift, 6-kShift, 7-kShift};
    // Exclude the protected bit while packing, avoiding a separate mask pass.
    const uint8x16_t aPositions = {
        MaskPosition(0U), MaskPosition(1U), MaskPosition(2U), MaskPosition(3U),
        MaskPosition(4U), MaskPosition(5U), MaskPosition(6U), MaskPosition(7U),
        MaskPosition(0U), MaskPosition(1U), MaskPosition(2U), MaskPosition(3U),
        MaskPosition(4U), MaskPosition(5U), MaskPosition(6U), MaskPosition(7U)};
    for (std::size_t aOffset = 0U; aOffset < pLength; aOffset += kBlockBytes) {
      const uint8x16_t a0 = vld1q_u8(pSource + aSampleOffset);
      const uint8x16_t a1 = vld1q_u8(pSource + aSampleOffset + 16U);
      const uint8x16_t a2 = vld1q_u8(pSource + aSampleOffset + 32U);
      const uint8x16_t a3 = vld1q_u8(pSource + aSampleOffset + 48U);

      // Move each control bit to its packed position, excluding ControlBit.
      // Pairwise sums then pack the selected bits without carries.
      const uint8x16_t aBits0 = vandq_u8(vshlq_u8(a0, aShifts), aPositions);
      const uint8x16_t aBits1 = vandq_u8(vshlq_u8(a1, aShifts), aPositions);
      const uint8x16_t aBits2 = vandq_u8(vshlq_u8(a2, aShifts), aPositions);
      const uint8x16_t aBits3 = vandq_u8(vshlq_u8(a3, aShifts), aPositions);
      const uint8x16_t aPairs01 = vpaddq_u8(aBits0, aBits1);
      const uint8x16_t aPairs23 = vpaddq_u8(aBits2, aBits3);
      const uint8x16_t aQuads = vpaddq_u8(aPairs01, aPairs23);
      // Each half contains the same eight mask bytes, with ControlBit clear.
      const uint8x16_t aMask = vpaddq_u8(aQuads, aQuads);
      vst1q_u8(pDestination + aOffset, veorq_u8(vld1q_u8(pSource + aOffset), aMask));
      vst1q_u8(pDestination + aOffset + 16U, veorq_u8(vld1q_u8(pSource + aOffset + 16U), aMask));
      vst1q_u8(pDestination + aOffset + 32U, veorq_u8(vld1q_u8(pSource + aOffset + 32U), aMask));
      vst1q_u8(pDestination + aOffset + 48U, veorq_u8(vld1q_u8(pSource + aOffset + 48U), aMask));
      aSampleOffset += kBlockBytes;
      if (aSampleOffset == pLength) { aSampleOffset = 0U; }
    }
#else
    // A can start after its protected bit, avoiding a skipped iteration.
    constexpr std::size_t kFirstBit = ControlBit == 0U ? 1U : 0U;
    for (std::size_t aOffset = 0U; aOffset < pLength; aOffset += kBlockBytes) {
      std::uint8_t aPacked[8] = {};
      for (std::size_t g = 0U; g < 8U; ++g) {
        for (std::size_t b = kFirstBit; b < 8U; ++b) {
          if constexpr (ControlBit != 0U) {
            if (b == ControlBit) { continue; }
          }
          aPacked[g] |= static_cast<std::uint8_t>(
              ((pSource[aSampleOffset + 8U * g + b] >> ControlBit) & 1U) << b);
        }
      }
      for (std::size_t i = 0U; i < kBlockBytes; ++i) {
        pDestination[aOffset + i] = static_cast<std::uint8_t>(
            pSource[aOffset + i] ^ aPacked[i % 8U]);
      }
      aSampleOffset += kBlockBytes;
      if (aSampleOffset == pLength) { aSampleOffset = 0U; }
    }
#endif
    return true;
  }

  std::int32_t mBlockRotation;
};

#endif  // SOCCER_MIX_CIPHER_BASE_HPP_
