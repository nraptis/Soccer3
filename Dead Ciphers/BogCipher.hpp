#ifndef SOCCER_BOG_CIPHER_HPP_
#define SOCCER_BOG_CIPHER_HPP_

#include "../Cipher.hpp"
#include <array>

#if !IGNORE_SIMD && (defined(__ARM_NEON) || defined(__ARM_NEON__))
#include <arm_neon.h>
#endif

namespace BogDetail {
inline constexpr std::array<std::array<unsigned,3>,6> kOrders = {{
    {0U,1U,2U}, {0U,2U,1U}, {1U,0U,2U},
    {1U,2U,0U}, {2U,0U,1U}, {2U,1U,0U}}};

// HotShift = 6/4/2/0 for families A/B/C/D. Order = 0..5 for suffix A..F.
// Every mask, packing order and inverse operation is fixed at compile time.
template<unsigned HotShift, unsigned Order, bool Inverse>
inline void Transform(const std::array<std::size_t,3> &pWindows,
                      const std::uint8_t *pSource, std::uint8_t *pDestination,
                      std::size_t pLength) {
    constexpr auto kOrder = kOrders[Order];
    constexpr auto kMask = static_cast<std::uint8_t>(3U << HotShift);
    const auto aWindowCount = pLength / 256U;
    auto aWindowA = pWindows[0] % aWindowCount;
    auto aWindowB = pWindows[1] % aWindowCount;
    auto aWindowC = pWindows[2] % aWindowCount;
    for (std::size_t aPosition = 0U; aPosition < pLength; aPosition += 256U) {
        const auto *aSourceA = pSource + 256U * aWindowA;
        const auto *aSourceB = pSource + 256U * aWindowB;
        const auto *aSourceC = pSource + 256U * aWindowC;
        for (std::size_t i = 0U; i < 256U; i += 16U) {
#if !IGNORE_SIMD && (defined(__ARM_NEON) || defined(__ARM_NEON__))
            const std::array<uint8x16_t,3> aSamples = {
                vld1q_u8(aSourceA+i), vld1q_u8(aSourceB+i), vld1q_u8(aSourceC+i)};
            const auto x = aSamples[kOrder[0]];
            const auto y = aSamples[kOrder[1]];
            const auto z = aSamples[kOrder[2]];
            uint8x16_t aKey;
            if constexpr (HotShift == 6U) {
                // High pairs -> 00XXYYZZ. Clang can fuse the final right
                // shift and forward addition into a single USRA instruction.
                aKey = vshrq_n_u8(vsriq_n_u8(vsriq_n_u8(x,y,2),z,4),2);
            } else if constexpr (HotShift == 0U) {
                // Low pairs -> XXYYZZ00; the preserved low pair stays zero.
                aKey = vshlq_n_u8(vsliq_n_u8(vsliq_n_u8(z,y,2),x,4),2);
            } else if constexpr (HotShift == 4U) {
                // Expanded key XX00YYZZ; leave the hot gap at zero.
                const auto aPacked = vsliq_n_u8(
                    vsliq_n_u8(vshrq_n_u8(z,4),vshrq_n_u8(y,4),2),vshrq_n_u8(x,4),6);
                aKey = vbicq_u8(aPacked,vdupq_n_u8(kMask));
            } else {
                // Expanded key XXYY00ZZ.
                const auto aPacked = vsriq_n_u8(
                    vsriq_n_u8(vshlq_n_u8(x,4),vshlq_n_u8(y,4),2),vshlq_n_u8(z,4),6);
                aKey = vbicq_u8(aPacked,vdupq_n_u8(kMask));
            }
            const auto aCurrent = vld1q_u8(pSource+aPosition+i);
            uint8x16_t aResult;
            if constexpr (HotShift == 0U) {
                aResult = Inverse ? vsubq_u8(aCurrent,aKey) : vaddq_u8(aCurrent,aKey);
            } else {
                auto aBase = aCurrent;
                if constexpr (HotShift != 6U) {
                    // Carry through the hot gap using ones; borrow through
                    // it using zeros. Restore the original hot bits below.
                    if constexpr (Inverse) aBase = vbicq_u8(aBase,vdupq_n_u8(kMask));
                    else aBase = vorrq_u8(aBase,vdupq_n_u8(kMask));
                }
                const auto aChanged = Inverse ? vsubq_u8(aBase,aKey) : vaddq_u8(aBase,aKey);
                aResult = vbslq_u8(vdupq_n_u8(kMask),aCurrent,aChanged);
            }
            vst1q_u8(pDestination+aPosition+i,aResult);
#else
            // Portable fallback. Delete the two-bit hole to obtain a six-bit
            // word, add/subtract mod 64, then insert the hole again.
            constexpr unsigned kLowMask = (1U << HotShift)-1U;
            for (std::size_t j = 0U; j < 16U; ++j) {
                const std::array<unsigned,3> aSamples = {
                    (aSourceA[i+j] >> HotShift) & 3U,
                    (aSourceB[i+j] >> HotShift) & 3U,
                    (aSourceC[i+j] >> HotShift) & 3U};
                const unsigned aKey = (aSamples[kOrder[0]] << 4U) |
                                          (aSamples[kOrder[1]] << 2U) | aSamples[kOrder[2]];
                const unsigned aCurrent = pSource[aPosition+i+j];
                const unsigned aOld = (aCurrent & kLowMask) | ((aCurrent >> (HotShift+2U)) << HotShift);
                const unsigned aChanged = (Inverse ? aOld-aKey : aOld+aKey) & 63U;
                const unsigned aExpanded = (aChanged & kLowMask) | ((aChanged >> HotShift) << (HotShift+2U));
                pDestination[aPosition+i+j] = static_cast<std::uint8_t>((aCurrent & kMask) | aExpanded);
            }
#endif
        }
        if (++aWindowA == aWindowCount) aWindowA = 0U;
        if (++aWindowB == aWindowCount) aWindowB = 0U;
        if (++aWindowC == aWindowCount) aWindowC = 0U;
    }
}
} // namespace BogDetail

// Independent final Cipher specializations: three sampled windows, six-bit
// modulo addition, preserved hot pair, and no nonlinear AND mixing gate.
// Offsets are relative 256-byte windows and wrap around the complete block.
// One caller thread, no allocation, no scratch; exact in-place use is safe.
template<unsigned HotShift, unsigned Order>
class BogCipher final : public Cipher {
    static_assert(HotShift <= 6U && HotShift % 2U == 0U);
    static_assert(Order < 6U);
public:
    static constexpr std::size_t kWindowBytes = 256U;
    static constexpr std::size_t kChunkBytes = 16U;
    static constexpr std::uint8_t kHotMask = static_cast<std::uint8_t>(3U << HotShift);
    static constexpr CipherType kType = static_cast<CipherType>(
        static_cast<std::uint32_t>(CipherType::kBogAA) + ((6U-HotShift)/2U)*6U + Order);

    BogCipher(std::size_t pWindowA, std::size_t pWindowB, std::size_t pWindowC)
        : Cipher(kType), mWindows{pWindowA,pWindowB,pWindowC} {}

    bool SealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                  std::uint8_t *pDestination, std::size_t pLength,
                  CipherErrorCode *pErrorCode) const override {
        (void)pWorker;
        return Apply<false>(pSource,pDestination,pLength,pErrorCode);
    }
    bool UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                    std::uint8_t *pDestination, std::size_t pLength,
                    CipherErrorCode *pErrorCode) const override {
        (void)pWorker;
        return Apply<true>(pSource,pDestination,pLength,pErrorCode);
    }
    void Zero() override { mWindows.fill(0U); }

private:
    template<bool Inverse>
    bool Apply(const std::uint8_t *pSource, std::uint8_t *pDestination,
               std::size_t pLength, CipherErrorCode *pErrorCode) const {
        if (pLength == 0U) {
            SetCipherErrorCode(pErrorCode,CipherErrorCode::kNone);
            return true;
        }
        if (pLength % kWindowBytes != 0U) {
            SetCipherErrorCode(pErrorCode,CipherErrorCode::kInvalidLength);
            return false;
        }
        if (!pSource || !pDestination) {
            SetCipherErrorCode(pErrorCode,CipherErrorCode::kNullBuffer);
            return false;
        }
        if (pSource != pDestination) {
            const auto aSource = reinterpret_cast<std::uintptr_t>(pSource);
            const auto aDestination = reinterpret_cast<std::uintptr_t>(pDestination);
            const auto aDistance = aSource < aDestination ? aDestination-aSource : aSource-aDestination;
            if (aDistance < pLength) {
                SetCipherErrorCode(pErrorCode,CipherErrorCode::kAliasedBuffer);
                return false;
            }
        }
        BogDetail::Transform<HotShift,Order,Inverse>(mWindows,pSource,pDestination,pLength);
        SetCipherErrorCode(pErrorCode,CipherErrorCode::kNone);
        return true;
    }
    std::array<std::size_t,3> mWindows;
};

#endif // SOCCER_BOG_CIPHER_HPP_
