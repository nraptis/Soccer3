#ifndef SOCCER_SKULL_CIPHER_BASE_HPP_
#define SOCCER_SKULL_CIPHER_BASE_HPP_

#include <algorithm>
#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"

// Two protected rows, sampled from independently rotated 64-byte windows.
// Rotation +1 samples the following window, wrapping within the input span.
// Row 0 is the least significant bit. Pack consecutive groups of eight:
//   a[g] bit b = source[windowA][8*g+b] bit rowA (and likewise for b[g]).
// The 16-byte layouts are, with pairs listed in memory order:
// A: a0 b0, a1 b1, a2 b2, a3 b3, b4 a4, b5 a5, b6 a6, b7 a7
// B: a4 b4, a5 b5, a6 b6, a7 b7, b0 a0, b1 a1, b2 a2, b3 a3
// C: b0 a0, b1 a1, b2 a2, b3 a3, a4 b4, a5 b5, a6 b6, a7 b7
// D: b4 a4, b5 a5, b6 a6, b7 a7, a0 b0, a1 b1, a2 b2, a3 b3
//
// XOR the same 16 bytes into each quarter of the destination window, clearing
// rowA and rowB in every mask byte. No destination byte is skipped. Preserving
// both control rows globally makes Seal and Unseal identical with the SAME
// rows and rotations. The implementation clears the protected mask bits while
// packing, which is equivalent to clearing them after interleaving.
//
// This is XOR-linear. Repeating the mask also preserves XORs of bytes at the
// same position in different quarters of a window. Of the 128 collected
// controls, 32 fall at the two protected mask positions and do not contribute
// to the applied mask. These are properties of the specified construction,
// not evidence of nonlinear mixing or resistance to plaintext recovery.
//
// Length: zero or a multiple of 64. Nonempty input requires distinct rows in
// [0,7], valid nonoverlapping buffers, and no alignment. Rotations are reduced
// modulo the window count; equal normalized rotations are allowed. Worker is
// unused, may be null, and no allocation or state across calls is required.
template <unsigned Layout, CipherType Type>
class SkullCipherBase : public Cipher {
    static_assert(Layout < 4U, "Skull layout must be in [0,3].");

public:
    explicit SkullCipherBase(std::size_t pRowA, std::size_t pBlockRotationA,
                             std::size_t pRowB, std::size_t pBlockRotationB)
        : Cipher(Type), mRowA(pRowA), mBlockRotationA(pBlockRotationA),
          mRowB(pRowB), mBlockRotationB(pBlockRotationB) {}

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

    // Reset to a valid local configuration while preserving the layout.
    void Zero() override {
        mRowA = 0U;
        mBlockRotationA = 0U;
        mRowB = 1U;
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
        if (mRowA >= 8U || mRowB >= 8U || mRowA == mRowB) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidParameter);
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

        const auto aWritable = static_cast<std::uint8_t>(~((1U << mRowA) | (1U << mRowB)));
        const auto aWindows = pLength / 64U;
        std::size_t aSampleA = (mBlockRotationA % aWindows) * 64U;
        std::size_t aSampleB = (mBlockRotationB % aWindows) * 64U;
        std::size_t aPosition = 0U;
#if JELLY_USE_NEON && defined(__aarch64__)
        const int8x16_t aBitPositions = {0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7};
        const auto aShiftsA = vsubq_s8(aBitPositions, vdupq_n_s8(static_cast<std::int8_t>(mRowA)));
        const auto aShiftsB = vsubq_s8(aBitPositions, vdupq_n_s8(static_cast<std::int8_t>(mRowB)));
        const uint8x16_t aPackingBits = {1,2,4,8,16,32,64,128,1,2,4,8,16,32,64,128};
        const auto aPositions = vandq_u8(aPackingBits, vdupq_n_u8(aWritable));
#endif
        // At most three contiguous spans; no wrap handling in the hot loop.
        while (aPosition < pLength) {
            const auto aSpan = std::min({pLength - aPosition, pLength - aSampleA, pLength - aSampleB});
            for (std::size_t aOffset = 0U; aOffset < aSpan; aOffset += 64U) {
                const auto *aInput = pSource + aPosition + aOffset;
                const auto *aInputA = pSource + aSampleA + aOffset;
                const auto *aInputB = pSource + aSampleB + aOffset;
                auto *aOutput = pDestination + aPosition + aOffset;
#if JELLY_USE_NEON && defined(__aarch64__)
                const auto aA = PackRow(aInputA, aShiftsA, aPositions);
                const auto aB = PackRow(aInputB, aShiftsB, aPositions);
                const auto aAB = vzip_u8(aA, aB);
                const auto aBA = vzip_u8(aB, aA);
                constexpr unsigned kFirstHalf = Layout & 1U;
                uint8x16_t aMask;
                if constexpr (Layout < 2U) {
                    aMask = vcombine_u8(aAB.val[kFirstHalf], aBA.val[kFirstHalf ^ 1U]);
                } else {
                    aMask = vcombine_u8(aBA.val[kFirstHalf], aAB.val[kFirstHalf ^ 1U]);
                }
                vst1q_u8(aOutput, veorq_u8(vld1q_u8(aInput), aMask));
                vst1q_u8(aOutput + 16U, veorq_u8(vld1q_u8(aInput + 16U), aMask));
                vst1q_u8(aOutput + 32U, veorq_u8(vld1q_u8(aInput + 32U), aMask));
                vst1q_u8(aOutput + 48U, veorq_u8(vld1q_u8(aInput + 48U), aMask));
#else
                std::uint8_t aA[8] = {}, aB[8] = {}, aMask[16];
                for (unsigned g = 0U; g < 8U; ++g) {
                    for (unsigned b = 0U; b < 8U; ++b) {
                        aA[g] |= static_cast<std::uint8_t>(((aInputA[8U*g + b] >> mRowA) & 1U) << b);
                        aB[g] |= static_cast<std::uint8_t>(((aInputB[8U*g + b] >> mRowB) & 1U) << b);
                    }
                }
                for (unsigned pair = 0U; pair < 8U; ++pair) {
                    const unsigned g = (pair + ((Layout & 1U) ? 4U : 0U)) % 8U;
                    const bool aFirst = (pair < 4U) != (Layout >= 2U);
                    aMask[2U*pair] = static_cast<std::uint8_t>((aFirst ? aA[g] : aB[g]) & aWritable);
                    aMask[2U*pair + 1U] = static_cast<std::uint8_t>((aFirst ? aB[g] : aA[g]) & aWritable);
                }
                for (unsigned i = 0U; i < 64U; ++i) { aOutput[i] = aInput[i] ^ aMask[i % 16U]; }
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

#if JELLY_USE_NEON && defined(__aarch64__)
    static uint8x8_t PackRow(const std::uint8_t *pSource, int8x16_t pShifts, uint8x16_t pPositions) {
        const auto a0 = vandq_u8(vshlq_u8(vld1q_u8(pSource), pShifts), pPositions);
        const auto a1 = vandq_u8(vshlq_u8(vld1q_u8(pSource + 16U), pShifts), pPositions);
        const auto a2 = vandq_u8(vshlq_u8(vld1q_u8(pSource + 32U), pShifts), pPositions);
        const auto a3 = vandq_u8(vshlq_u8(vld1q_u8(pSource + 48U), pShifts), pPositions);
        // Sums pack distinct bit positions, so no carries occur.
        const auto aPairs01 = vpaddq_u8(a0, a1);
        const auto aPairs23 = vpaddq_u8(a2, a3);
        const auto aQuads = vpaddq_u8(aPairs01, aPairs23);
        return vpadd_u8(vget_low_u8(aQuads), vget_high_u8(aQuads));
    }
#endif

    std::size_t mRowA;
    std::size_t mBlockRotationA;
    std::size_t mRowB;
    std::size_t mBlockRotationB;
};

#endif  // SOCCER_SKULL_CIPHER_BASE_HPP_
