#ifndef SOCCER_SPREAD_CIPHER_BASE_HPP_
#define SOCCER_SPREAD_CIPHER_BASE_HPP_

#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"
#include "BlockRotation.hpp"

// Preserve ControlBit at every byte. For destination window w, take controls
// from window (w + rotation) modulo the number of 64-byte windows, matching
// byte positions within each window. Invert the destination byte's other bits
// when the sampled control is 1. Rotation 0 retains the original behavior.
// The preserved control bit makes this self-inverse with the SAME rotation.
// This is XOR-linear;
// choosing "invert if zero" instead would only add a fixed XOR mask.
//
// Separate cipher instances share this compile-time implementation. No key,
// material lane, bank mask, worker buffer, or allocation is required.
// Rotation 0 supports any byte length; nonzero rotations require a multiple
// of 64 bytes. Nonempty buffers must not overlap; unaligned
// buffers are supported. Seal and Unseal perform the same transformation.
template <unsigned ControlBit, CipherType Type>
class SpreadCipherBase : public Cipher {
    static_assert(ControlBit < 8U, "Spread cipher control bit must be in [0,7].");
    
public:
    explicit SpreadCipherBase(std::int32_t pBlockRotation = 0)
        : Cipher(Type), mBlockRotation(pBlockRotation) {}

    void Zero() override { mBlockRotation = 0; }
    
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
    static constexpr std::uint8_t kControlMask = static_cast<std::uint8_t>(1U << ControlBit);
    static constexpr std::uint8_t kOtherMask = static_cast<std::uint8_t>(~kControlMask);
    
    bool Apply(const std::uint8_t *pSource,
                      std::uint8_t *pDestination,
                      std::size_t pLength,
                      CipherErrorCode *pErrorCode) const {
        if (pLength == 0U) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
            return true;
        }
        if (mBlockRotation != 0 && pLength % 64U != 0U) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength);
            return false;
        }
        if (pSource == nullptr || pDestination == nullptr) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
            return false;
        }
        const auto aSourceAddress = reinterpret_cast<std::uintptr_t>(pSource);
        const auto aDestinationAddress = reinterpret_cast<std::uintptr_t>(pDestination);
        const auto aDistance = aSourceAddress <= aDestinationAddress ?
        aDestinationAddress - aSourceAddress : aSourceAddress - aDestinationAddress;
        if (aDistance < pLength) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
            return false;
        }
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        
        const std::size_t aSampleOffset = soccer_cipher_detail::NormalizeBlockRotation(
            mBlockRotation, pLength / 64U) * 64U;
        if (aSampleOffset == 0U) {
            ApplySpan<true>(pSource, pSource, pDestination, pLength);
        } else {
            // Both read streams are contiguous within each span. Handle the
            // single circular wrap here, not in every SIMD/scalar iteration.
            const std::size_t aFirstLength = pLength - aSampleOffset;
            ApplySpan<false>(pSource, pSource + aSampleOffset, pDestination, aFirstLength);
            ApplySpan<false>(pSource + aFirstLength, pSource, pDestination + aFirstLength, aSampleOffset);
        }
        return true;
    }

    template <bool LocalControls>
    static void ApplySpan(const std::uint8_t *pSource,
                          const std::uint8_t *pControls,
                          std::uint8_t *pDestination,
                          std::size_t pLength) {
        std::size_t aOffset = 0U;
#if JELLY_USE_NEON
        const uint8x16_t aControlMask = vdupq_n_u8(kControlMask);
        const uint8x16_t aOtherMask = vdupq_n_u8(kOtherMask);
        const std::size_t aVectorLength = pLength & ~std::size_t{15U};
        for (; aOffset < aVectorLength; aOffset += 16U) {
            const uint8x16_t aSource = vld1q_u8(pSource + aOffset);
            const uint8x16_t aControls = LocalControls ? aSource : vld1q_u8(pControls + aOffset);
            const uint8x16_t aIfOne = vtstq_u8(aControls, aControlMask);
            const uint8x16_t aFlip = vandq_u8(aIfOne, aOtherMask);
            vst1q_u8(pDestination + aOffset, veorq_u8(aSource, aFlip));
        }
#endif
        for (; aOffset < pLength; ++aOffset) {
            const std::uint8_t aSource = pSource[aOffset];
            const std::uint8_t aControl = LocalControls ? aSource : pControls[aOffset];
            const auto aIfOne = static_cast<std::uint8_t>(0U - ((aControl >> ControlBit) & 1U));
            pDestination[aOffset] = static_cast<std::uint8_t>(aSource ^ (aIfOne & kOtherMask));
        }
    }

    std::int32_t mBlockRotation;
};

#endif  // SOCCER_SPREAD_CIPHER_BASE_HPP_
