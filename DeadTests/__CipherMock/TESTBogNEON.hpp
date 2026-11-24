#ifndef TESTBogNEON_hpp
#define TESTBogNEON_hpp

#include "TESTBog.hpp"
#if defined(__aarch64__)
#include <arm_neon.h>

// Experimental kernels for checking SIMD cost against the readable reference.
// They are not production Cipher subclasses. Range calls use a stable full
// input block and disjoint output ranges; synchronize before the next stage.
// All calls assume valid settings and buffers. Transform takes a nonzero
// length, with begin/end at multiples of 256 inside that block. Whole-block
// SealData/UnsealData also accept zero length as a no-op.
namespace TESTBogNEON {
template<TESTBog::HotPair Pair, TESTBog::PackOrder Order, bool Inverse>
inline void Transform(const TESTBog &pPlan, const std::uint8_t *pSource,
                      std::uint8_t *pDestination, std::size_t pLength,
                      std::size_t pBegin, std::size_t pEnd) {
    constexpr auto kOrder = TESTBog::kOrders[static_cast<unsigned>(Order)];
    constexpr auto kMask = static_cast<std::uint8_t>(3U << static_cast<unsigned>(Pair));
    const auto aCount = pLength/256U;
    auto aWindowA = (pPlan.mWindowA%aCount+pBegin/256U)%aCount;
    auto aWindowB = (pPlan.mWindowB%aCount+pBegin/256U)%aCount;
    auto aWindowC = (pPlan.mWindowC%aCount+pBegin/256U)%aCount;
    for (std::size_t aPosition = pBegin; aPosition < pEnd; aPosition += 256U) {
        const auto *a = pSource+256U*aWindowA;
        const auto *b = pSource+256U*aWindowB;
        const auto *c = pSource+256U*aWindowC;
        for (std::size_t i = 0U; i < 256U; i += 16U) {
            const std::array<uint8x16_t,3> aSamples = {vld1q_u8(a+i),vld1q_u8(b+i),vld1q_u8(c+i)};
            const auto x = aSamples[kOrder[0]], y = aSamples[kOrder[1]], z = aSamples[kOrder[2]];
            uint8x16_t aKey;
            if constexpr (Pair == TESTBog::HotPair::kA) {
                // High two bits of x,y,z -> 00XXYYZZ: two inserts + shift.
                aKey = vshrq_n_u8(vsriq_n_u8(vsriq_n_u8(x,y,2),z,4),2);
            } else if constexpr (Pair == TESTBog::HotPair::kD) {
                // Low two bits -> XXYYZZ00. The bottom two bits stay zero.
                aKey = vshlq_n_u8(vsliq_n_u8(vsliq_n_u8(z,y,2),x,4),2);
            } else if constexpr (Pair == TESTBog::HotPair::kB) {
                const auto aPacked = vsliq_n_u8(vsliq_n_u8(vshrq_n_u8(z,4),vshrq_n_u8(y,4),2),vshrq_n_u8(x,4),6);
                aKey = vbicq_u8(aPacked,vdupq_n_u8(kMask));
            } else {
                const auto aPacked = vsriq_n_u8(vsriq_n_u8(vshlq_n_u8(x,4),vshlq_n_u8(y,4),2),vshlq_n_u8(z,4),6);
                aKey = vbicq_u8(aPacked,vdupq_n_u8(kMask));
            }
            const auto aCurrent = vld1q_u8(pSource+aPosition+i);
            uint8x16_t aResult;
            if constexpr (Pair == TESTBog::HotPair::kD) {
                aResult = Inverse ? vsubq_u8(aCurrent,aKey) : vaddq_u8(aCurrent,aKey);
            } else {
                auto aBase = aCurrent;
                if constexpr (Pair != TESTBog::HotPair::kA) {
                    // Ones propagate carries over the hot gap. Zeros do
                    // the equivalent job for borrows during subtraction.
                    if constexpr (Inverse) aBase = vbicq_u8(aBase,vdupq_n_u8(kMask));
                    else aBase = vorrq_u8(aBase,vdupq_n_u8(kMask));
                }
                const auto aChanged = Inverse ? vsubq_u8(aBase,aKey) : vaddq_u8(aBase,aKey);
                aResult = vbslq_u8(vdupq_n_u8(kMask),aCurrent,aChanged);
            }
            vst1q_u8(pDestination+aPosition+i,aResult);
        }
        if (++aWindowA == aCount) aWindowA = 0U;
        if (++aWindowB == aCount) aWindowB = 0U;
        if (++aWindowC == aCount) aWindowC = 0U;
    }
}

using Kernel = void (*)(const TESTBog &, const std::uint8_t *, std::uint8_t *, std::size_t, std::size_t, std::size_t);
template<TESTBog::HotPair Pair, bool Inverse>
inline constexpr std::array<Kernel,6> kOrders = {
    Transform<Pair,TESTBog::PackOrder::kABC,Inverse>, Transform<Pair,TESTBog::PackOrder::kACB,Inverse>,
    Transform<Pair,TESTBog::PackOrder::kBAC,Inverse>, Transform<Pair,TESTBog::PackOrder::kBCA,Inverse>,
    Transform<Pair,TESTBog::PackOrder::kCAB,Inverse>, Transform<Pair,TESTBog::PackOrder::kCBA,Inverse>};
template<bool Inverse>
inline constexpr std::array<std::array<Kernel,6>,4> kPairs = {
    kOrders<TESTBog::HotPair::kA,Inverse>, kOrders<TESTBog::HotPair::kB,Inverse>,
    kOrders<TESTBog::HotPair::kC,Inverse>, kOrders<TESTBog::HotPair::kD,Inverse>};
template<bool Inverse>
inline Kernel GetKernel(const TESTBog &pPlan) {
    // Pair shifts A/B/C/D = 6/4/2/0 map to table rows 0/1/2/3.
    const auto aFamily = (6U-static_cast<unsigned>(pPlan.mHotPair))/2U;
    return kPairs<Inverse>[aFamily][static_cast<unsigned>(pPlan.mPackOrder)];
}
template<bool Inverse>
inline bool Apply(const TESTBog &pPlan, const std::uint8_t *src, std::uint8_t *dst, std::size_t len) {
    if (len != 0U) GetKernel<Inverse>(pPlan)(pPlan,src,dst,len,0U,len);
    return true;
}
inline bool SealData(const TESTBog &pPlan, const std::uint8_t *src, std::uint8_t *dst, std::size_t len) {
    return Apply<false>(pPlan,src,dst,len);
}
inline bool UnsealData(const TESTBog &pPlan, const std::uint8_t *src, std::uint8_t *dst, std::size_t len) {
    return Apply<true>(pPlan,src,dst,len);
}
} // namespace TESTBogNEON
#endif
#endif
