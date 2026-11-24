#ifndef TESTQuirkHighNEON_hpp
#define TESTQuirkHighNEON_hpp

#include "TESTQuirkHigh.hpp"

#if defined(__aarch64__)
#include <arm_neon.h>

namespace TESTQuirkHighNEON {

// Each direction is selected once per call. Reversed reads change load
// addresses only: no byte reversal, TBL, REV64, or intermediate buffer.
template<TESTQuirkHigh::Update Update, bool Inverse, bool ReverseA, bool ReverseB, bool ReverseC>
inline void Apply(const TESTQuirkHigh &pPlan, const std::uint8_t *pSource,
                  std::uint8_t *pDestination, std::size_t pLength) {
    constexpr auto kWindow = TESTQuirkHigh::kWindowBytes;
    constexpr auto kChunk = TESTQuirkHigh::kChunkBytes;
    const auto aWindowCount = pLength / kWindow;
    auto aWindowA = pPlan.mWindowA % aWindowCount;
    auto aWindowB = pPlan.mWindowB % aWindowCount;
    auto aWindowC = pPlan.mWindowC % aWindowCount;
    for (std::size_t aPosition = 0U; aPosition < pLength; aPosition += kWindow) {
        const auto *aSourceA = pSource + aWindowA * kWindow;
        const auto *aSourceB = pSource + aWindowB * kWindow;
        const auto *aSourceC = pSource + aWindowC * kWindow;
        for (std::size_t aOffset = 0U; aOffset < kWindow; aOffset += kChunk) {
            const auto a = vld1q_u8(aSourceA + (ReverseA ? kWindow - kChunk - aOffset : aOffset));
            const auto b = vld1q_u8(aSourceB + (ReverseB ? kWindow - kChunk - aOffset : aOffset));
            const auto c = vld1q_u8(aSourceC + (ReverseC ? kWindow - kChunk - aOffset : aOffset));
            const auto aCurrent = vld1q_u8(pSource + aPosition + aOffset);
            const auto aTwiddle = veorq_u8(a, vandq_u8(b, c));
            uint8x16_t aResult;
            if constexpr (Update == TESTQuirkHigh::Update::kXor) {
                // Four operations: AND, XOR, shift, XOR. Self-inverse.
                aResult = veorq_u8(aCurrent, vshrq_n_u8(aTwiddle, 4));
            } else if constexpr (!Inverse) {
                // Put the old low nibble at the top and add Twiddle there.
                // The lower half starts at zero, so Twiddle's unwanted low
                // bits cannot carry into the upper half. SRI restores the
                // original high nibble and inserts the new low nibble.
                const auto aSum = vaddq_u8(vshlq_n_u8(aCurrent, 4), aTwiddle);
                aResult = vsriq_n_u8(aCurrent, aSum, 4);
            } else {
                const auto aChanged = vsubq_u8(aCurrent, vshrq_n_u8(aTwiddle, 4));
                aResult = vbslq_u8(vdupq_n_u8(0xF0U), aCurrent, aChanged);
            }
            vst1q_u8(pDestination + aPosition + aOffset, aResult);
        }
        if (++aWindowA == aWindowCount) aWindowA = 0U;
        if (++aWindowB == aWindowCount) aWindowB = 0U;
        if (++aWindowC == aWindowCount) aWindowC = 0U;
    }
}

template<TESTQuirkHigh::Update Update, bool Inverse>
inline void Dispatch(const TESTQuirkHigh &pPlan, const std::uint8_t *pSource,
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

inline bool ApplyChecked(const TESTQuirkHigh &pPlan, bool pInverse, const std::uint8_t *pSource,
                          std::uint8_t *pDestination, std::size_t pLength) {
    if (!TESTQuirkHighDetail::ValidBuffers(pSource, pDestination, pLength)) return false;
    if (pLength == 0U) return true;
    switch (pPlan.mUpdate) {
        case TESTQuirkHigh::Update::kXor:
            Dispatch<TESTQuirkHigh::Update::kXor, false>(pPlan, pSource, pDestination, pLength);
            break;
        case TESTQuirkHigh::Update::kAdd:
            if (pInverse) Dispatch<TESTQuirkHigh::Update::kAdd, true>(pPlan, pSource, pDestination, pLength);
            else Dispatch<TESTQuirkHigh::Update::kAdd, false>(pPlan, pSource, pDestination, pLength);
            break;
        default: return false;
    }
    return true;
}

inline bool SealData(const TESTQuirkHigh &pPlan, const std::uint8_t *pSource,
                     std::uint8_t *pDestination, std::size_t pLength) {
    return ApplyChecked(pPlan, false, pSource, pDestination, pLength);
}

inline bool UnsealData(const TESTQuirkHigh &pPlan, const std::uint8_t *pSource,
                       std::uint8_t *pDestination, std::size_t pLength) {
    return ApplyChecked(pPlan, true, pSource, pDestination, pLength);
}
} // namespace TESTQuirkHighNEON
#endif

#endif /* TESTQuirkHighNEON_hpp */
