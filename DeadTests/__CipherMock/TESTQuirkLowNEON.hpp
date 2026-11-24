#ifndef TESTQuirkLowNEON_hpp
#define TESTQuirkLowNEON_hpp

#include "TESTQuirkLow.hpp"

#if defined(__aarch64__)
#include <arm_neon.h>

namespace TESTQuirkLowNEON {
template<TESTQuirkLow::Update Update, bool Inverse, bool ReverseA, bool ReverseB, bool ReverseC>
inline void Apply(const TESTQuirkLow &pPlan, const std::uint8_t *pSource,
                  std::uint8_t *pDestination, std::size_t pLength) {
    const auto aCount = pLength / 256U;
    auto aWindowA = pPlan.mWindowA % aCount;
    auto aWindowB = pPlan.mWindowB % aCount;
    auto aWindowC = pPlan.mWindowC % aCount;
    for (std::size_t aPosition = 0U; aPosition < pLength; aPosition += 256U) {
        const auto *aSourceA = pSource + 256U * aWindowA;
        const auto *aSourceB = pSource + 256U * aWindowB;
        const auto *aSourceC = pSource + 256U * aWindowC;
        for (std::size_t i = 0U; i < 256U; i += 16U) {
            const auto a = vld1q_u8(aSourceA + (ReverseA ? 240U - i : i));
            const auto b = vld1q_u8(aSourceB + (ReverseB ? 240U - i : i));
            const auto c = vld1q_u8(aSourceC + (ReverseC ? 240U - i : i));
            const auto aCurrent = vld1q_u8(pSource + aPosition + i);
            const auto aKey = vshlq_n_u8(veorq_u8(a, vandq_u8(b, c)), 4);
            uint8x16_t aResult;
            if constexpr (Update == TESTQuirkLow::Update::kXor) aResult = veorq_u8(aCurrent, aKey);
            else if constexpr (Inverse) aResult = vsubq_u8(aCurrent, aKey);
            else aResult = vaddq_u8(aCurrent, aKey);
            vst1q_u8(pDestination + aPosition + i, aResult);
        }
        if (++aWindowA == aCount) aWindowA = 0U;
        if (++aWindowB == aCount) aWindowB = 0U;
        if (++aWindowC == aCount) aWindowC = 0U;
    }
}

template<TESTQuirkLow::Update Update, bool Inverse>
inline void Dispatch(const TESTQuirkLow &pPlan, const std::uint8_t *pSource,
                      std::uint8_t *pDestination, std::size_t pLength) {
    const unsigned aVariant = (static_cast<unsigned>(pPlan.mReverseA) << 2U) |
                             (static_cast<unsigned>(pPlan.mReverseB) << 1U) |
                             static_cast<unsigned>(pPlan.mReverseC);
    switch (aVariant) {
        case 0U: Apply<Update, Inverse, false, false, false>(pPlan, pSource, pDestination, pLength); break;
        case 1U: Apply<Update, Inverse, false, false, true>(pPlan, pSource, pDestination, pLength); break;
        case 2U: Apply<Update, Inverse, false, true, false>(pPlan, pSource, pDestination, pLength); break;
        case 3U: Apply<Update, Inverse, false, true, true>(pPlan, pSource, pDestination, pLength); break;
        case 4U: Apply<Update, Inverse, true, false, false>(pPlan, pSource, pDestination, pLength); break;
        case 5U: Apply<Update, Inverse, true, false, true>(pPlan, pSource, pDestination, pLength); break;
        case 6U: Apply<Update, Inverse, true, true, false>(pPlan, pSource, pDestination, pLength); break;
        case 7U: Apply<Update, Inverse, true, true, true>(pPlan, pSource, pDestination, pLength); break;
    }
}

inline bool ApplyChecked(const TESTQuirkLow &pPlan, bool pInverse, const std::uint8_t *pSource,
                          std::uint8_t *pDestination, std::size_t pLength) {
    if (!TESTQuirkHighDetail::ValidBuffers(pSource, pDestination, pLength)) return false;
    if (pLength == 0U) return true;
    switch (pPlan.mUpdate) {
        case TESTQuirkLow::Update::kXor:
            Dispatch<TESTQuirkLow::Update::kXor, false>(pPlan, pSource, pDestination, pLength);
            break;
        case TESTQuirkLow::Update::kAdd:
            if (pInverse) Dispatch<TESTQuirkLow::Update::kAdd, true>(pPlan, pSource, pDestination, pLength);
            else Dispatch<TESTQuirkLow::Update::kAdd, false>(pPlan, pSource, pDestination, pLength);
            break;
        default: return false;
    }
    return true;
}

inline bool SealData(const TESTQuirkLow &pPlan, const std::uint8_t *pSource,
                     std::uint8_t *pDestination, std::size_t pLength) {
    return ApplyChecked(pPlan, false, pSource, pDestination, pLength);
}
inline bool UnsealData(const TESTQuirkLow &pPlan, const std::uint8_t *pSource,
                       std::uint8_t *pDestination, std::size_t pLength) {
    return ApplyChecked(pPlan, true, pSource, pDestination, pLength);
}
} // namespace TESTQuirkLowNEON
#endif
#endif
