#ifndef SOCCER_DANCE_CIPHER_BASE_HPP_
#define SOCCER_DANCE_CIPHER_BASE_HPP_

#include <algorithm>
#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"

// Each 64-byte window has two 32-byte halves. A preserves the first half
// and changes the second; B preserves the second and changes the first.
// For destination window w and byte i in [0,31]:
//   a = source[(w + rotationA) % windows][ControlHalf*32 + i]
//   b = source[(w + rotationB) % windows][ControlHalf*32 + i]
//   destination[w][(1-ControlHalf)*32 + i] = source[w][...] ^ uint8_t(a + b)
// Copy the other half unchanged. Addition wraps independently in each byte;
// there is no carry between bytes, bit packing, or external mask.
//
// Both sampled halves are preserved globally, so Seal and Unseal use the
// SAME operation and rotations. Reverse a sequence of ciphers in reverse
// order. Equal normalized rotations are allowed, but then a+b = 2*a mod 256
// is a linear shift; distinct source windows permit nonlinear carry effects.
//
// Length: zero or a multiple of 64. Nonempty buffers must not overlap;
// unaligned buffers are supported. Rotations are size_t window counts reduced
// modulo the span. Worker is unused and may be null. No allocation or state
// across calls is required.
template <unsigned ControlHalf, CipherType Type>
class DanceCipherBase : public Cipher {
    static_assert(ControlHalf < 2U, "Dance control half must be 0 or 1.");

public:
    explicit DanceCipherBase(std::size_t pBlockRotationA, std::size_t pBlockRotationB)
        : Cipher(Type), mBlockRotationA(pBlockRotationA), mBlockRotationB(pBlockRotationB) {}

    bool SealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                  std::uint8_t *pDestination, std::size_t pLength,
                  CipherErrorCode *pErrorCode) const override {
        (void)pWorker;
        return Apply(pSource, pDestination, pLength, pErrorCode);
    }

    bool UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                    std::uint8_t *pDestination, std::size_t pLength,
                    CipherErrorCode *pErrorCode) const override {
        (void)pWorker;
        return Apply(pSource, pDestination, pLength, pErrorCode);
    }

    void Zero() override {
        mBlockRotationA = 0U;
        mBlockRotationB = 0U;
    }

private:
    bool Apply(const std::uint8_t *pSource, std::uint8_t *pDestination,
               std::size_t pLength, CipherErrorCode *pErrorCode) const {
        if (pLength == 0U) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
            return true;
        }
        if (pLength % 64U != 0U) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength);
            return false;
        }
        if (pSource == nullptr || pDestination == nullptr) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
            return false;
        }
        const auto aSource = reinterpret_cast<std::uintptr_t>(pSource);
        const auto aDestination = reinterpret_cast<std::uintptr_t>(pDestination);
        const auto aDistance = aSource <= aDestination ? aDestination - aSource : aSource - aDestination;
        if (aDistance < pLength) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
            return false;
        }
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);

        constexpr std::size_t kControlOffset = ControlHalf * 32U;
        constexpr std::size_t kTargetOffset = (1U - ControlHalf) * 32U;
        const auto aWindows = pLength / 64U;
        std::size_t aSampleA = (mBlockRotationA % aWindows) * 64U;
        std::size_t aSampleB = (mBlockRotationB % aWindows) * 64U;
        std::size_t aPosition = 0U;
        // Handle the two possible circular wraps outside the hot loop.
        while (aPosition < pLength) {
            const auto aSpan = std::min({pLength - aPosition, pLength - aSampleA, pLength - aSampleB});
            for (std::size_t aOffset = 0U; aOffset < aSpan; aOffset += 64U) {
                const auto *aInput = pSource + aPosition + aOffset;
                const auto *aA = pSource + aSampleA + aOffset + kControlOffset;
                const auto *aB = pSource + aSampleB + aOffset + kControlOffset;
                auto *aOutput = pDestination + aPosition + aOffset;
#if JELLY_USE_NEON
                const auto aSum0 = vaddq_u8(vld1q_u8(aA), vld1q_u8(aB));
                const auto aSum1 = vaddq_u8(vld1q_u8(aA + 16U), vld1q_u8(aB + 16U));
                vst1q_u8(aOutput + kControlOffset, vld1q_u8(aInput + kControlOffset));
                vst1q_u8(aOutput + kControlOffset + 16U, vld1q_u8(aInput + kControlOffset + 16U));
                vst1q_u8(aOutput + kTargetOffset, veorq_u8(vld1q_u8(aInput + kTargetOffset), aSum0));
                vst1q_u8(aOutput + kTargetOffset + 16U, veorq_u8(vld1q_u8(aInput + kTargetOffset + 16U), aSum1));
#else
                for (std::size_t i = 0U; i < 32U; ++i) {
                    const auto aSum = static_cast<std::uint8_t>(aA[i] + aB[i]);
                    aOutput[kControlOffset + i] = aInput[kControlOffset + i];
                    aOutput[kTargetOffset + i] = aInput[kTargetOffset + i] ^ aSum;
                }
#endif
            }
            aPosition += aSpan;
            aSampleA += aSpan;
            aSampleB += aSpan;
            if (aSampleA == pLength) { aSampleA = 0U; }
            if (aSampleB == pLength) { aSampleB = 0U; }
        }
        return true;
    }

    std::size_t mBlockRotationA;
    std::size_t mBlockRotationB;
};

#endif  // SOCCER_DANCE_CIPHER_BASE_HPP_
