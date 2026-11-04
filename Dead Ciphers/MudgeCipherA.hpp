#ifndef SOCCER_MUDGE_CIPHER_A_HPP_
#define SOCCER_MUDGE_CIPHER_A_HPP_

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include "Jelly.hpp"
#include "Cipher.hpp"

// L1 Mudge: 3 distinct protected bit rows, 3 window rotations.
// For destination window w, sample row X from window (w + rotationX) % N.
// At byte i the sample positions are i, (i + 13) % 64, (i + 26) % 64.
// AND the 3 bits, then XOR that result into every unprotected bit of byte i.
// 13 is a FIXED byte offset, not an output-bit stride. No row packing.
// All control rows remain unchanged globally: Seal and Unseal are identical.
// Reverse a stack in reverse order. This primitive alone is not a security claim.
// Input length is zero or a multiple of 64; nonempty buffers cannot overlap.
// Rotations accept any size_t and wrap within the actual number of windows.
class MudgeCipherA final : public Cipher {
public:
    explicit MudgeCipherA(std::size_t pRowA, std::size_t pBlockRotationA,
                          std::size_t pRowB, std::size_t pBlockRotationB,
                          std::size_t pRowC, std::size_t pBlockRotationC)
        : Cipher(CipherType::kMudgeCipherA),
          mRowA(pRowA), mBlockRotationA(pBlockRotationA),
          mRowB(pRowB), mBlockRotationB(pBlockRotationB),
          mRowC(pRowC), mBlockRotationC(pBlockRotationC) {}

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
        mRowA = 0U; mBlockRotationA = 0U;
        mRowB = 1U; mBlockRotationB = 0U;
        mRowC = 2U; mBlockRotationC = 0U;
    }

private:
    bool Apply(const std::uint8_t *pSource, std::uint8_t *pDestination,
               std::size_t pLength, CipherErrorCode *pErrorCode) const {
        if (pLength == 0U) { SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone); return true; }
        if (pLength % 64U != 0U) { SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength); return false; }
        if (mRowA >= 8U || mRowB >= 8U || mRowC >= 8U || mRowA == mRowB || mRowA == mRowC || mRowB == mRowC) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidParameter); return false;
        }
        if (pSource == nullptr || pDestination == nullptr) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer); return false;
        }
        const auto aSource = reinterpret_cast<std::uintptr_t>(pSource);
        const auto aDestination = reinterpret_cast<std::uintptr_t>(pDestination);
        const auto aDistance = aSource <= aDestination ? aDestination - aSource : aSource - aDestination;
        if (aDistance < pLength) { SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer); return false; }
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        const auto aWritable = static_cast<std::uint8_t>(~((1U << mRowA) | (1U << mRowB) | (1U << mRowC)));
        const auto aWindows = pLength / 64U;
        std::size_t aSampleA = (mBlockRotationA % aWindows) * 64U;
        std::size_t aSampleB = (mBlockRotationB % aWindows) * 64U;
        std::size_t aSampleC = (mBlockRotationC % aWindows) * 64U;
        std::size_t aPosition = 0U;
#if JELLY_USE_NEON
        const auto aMaskA = vdupq_n_u8(static_cast<std::uint8_t>(1U << mRowA));
        const auto aMaskB = vdupq_n_u8(static_cast<std::uint8_t>(1U << mRowB));
        const auto aMaskC = vdupq_n_u8(static_cast<std::uint8_t>(1U << mRowC));
        const auto aWritableMask = vdupq_n_u8(aWritable);
#endif
        // Split only at circular wraps; no modulo or bounds check in the NEON kernel.
        while (aPosition < pLength) {
            const auto aSpan = std::min({pLength - aPosition, pLength - aSampleA, pLength - aSampleB, pLength - aSampleC});
            for (std::size_t aOffset = 0U; aOffset < aSpan; aOffset += 64U) {
                const auto *aInput = pSource + aPosition + aOffset;
                auto *aOutput = pDestination + aPosition + aOffset;
                const auto *aA = pSource + aSampleA + aOffset;
                const auto *aB = pSource + aSampleB + aOffset;
                const auto *aC = pSource + aSampleC + aOffset;
#if JELLY_USE_NEON
                ApplyHalf<0U>(aInput, aOutput, aA, aB, aC, aMaskA, aMaskB, aMaskC, aWritableMask);
                ApplyHalf<32U>(aInput, aOutput, aA, aB, aC, aMaskA, aMaskB, aMaskC, aWritableMask);
#else
                for (std::size_t i = 0U; i < 64U; ++i) {
                    const unsigned aBitA = (aA[(i + 0U) % 64U] >> mRowA) & 1U;
                    const unsigned aBitB = (aB[(i + 13U) % 64U] >> mRowB) & 1U;
                    const unsigned aBitC = (aC[(i + 26U) % 64U] >> mRowC) & 1U;
                    const auto aFlip = static_cast<std::uint8_t>(0U - (aBitA & aBitB & aBitC));
                    aOutput[i] = aInput[i] ^ (aFlip & aWritable);
                }
#endif
            }
            aPosition += aSpan;
            aSampleA += aSpan; if (aSampleA == pLength) { aSampleA = 0U; }
            aSampleB += aSpan; if (aSampleB == pLength) { aSampleB = 0U; }
            aSampleC += aSpan; if (aSampleC == pLength) { aSampleC = 0U; }
        }
        return true;
    }

#if JELLY_USE_NEON
    // Byte is compile-time fixed. Only the one vector crossing byte 63 wraps.
    template <unsigned Byte>
    static uint8x16_t Read16(const std::uint8_t *pSource) {
        constexpr unsigned k = Byte % 64U;
        if constexpr (k <= 48U) { return vld1q_u8(pSource + k); }
        else { return vextq_u8(vld1q_u8(pSource + 48U), vld1q_u8(pSource), k - 48U); }
    }

    template <unsigned Byte>
    static void Apply16(const std::uint8_t *pSource, std::uint8_t *pDestination,
                        const std::uint8_t *pA, const std::uint8_t *pB, const std::uint8_t *pC,
                        uint8x16_t pMaskA, uint8x16_t pMaskB, uint8x16_t pMaskC, uint8x16_t pWritable) {
        const auto aA = vtstq_u8(Read16<Byte + 0U>(pA), pMaskA);
        const auto aB = vtstq_u8(Read16<Byte + 13U>(pB), pMaskB);
        const auto aC = vtstq_u8(Read16<Byte + 26U>(pC), pMaskC);
        const auto aFlip = vandq_u8(vandq_u8(vandq_u8(aA, aB), aC), pWritable);
        vst1q_u8(pDestination + Byte, veorq_u8(vld1q_u8(pSource + Byte), aFlip));
    }

    template <unsigned Half>
    static void ApplyHalf(const std::uint8_t *pSource, std::uint8_t *pDestination,
                          const std::uint8_t *pA, const std::uint8_t *pB, const std::uint8_t *pC,
                          uint8x16_t pMaskA, uint8x16_t pMaskB, uint8x16_t pMaskC, uint8x16_t pWritable) {
        Apply16<Half>(pSource, pDestination, pA, pB, pC, pMaskA, pMaskB, pMaskC, pWritable);
        Apply16<Half + 16U>(pSource, pDestination, pA, pB, pC, pMaskA, pMaskB, pMaskC, pWritable);
    }
#endif

    std::size_t mRowA;
    std::size_t mBlockRotationA;
    std::size_t mRowB;
    std::size_t mBlockRotationB;
    std::size_t mRowC;
    std::size_t mBlockRotationC;
};

#endif // SOCCER_MUDGE_CIPHER_A_HPP_
