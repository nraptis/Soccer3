#ifndef SOCCER_FLAME_TOAD_PACKING_HPP_
#define SOCCER_FLAME_TOAD_PACKING_HPP_

#include "../../Composer/Soccer3.hpp"
#if !IGNORE_SIMD && defined(__SSE2__)
#include <immintrin.h>
#endif

namespace FlameToadPacking {
#if SOCCER_USE_NEON
inline uint8x16_t PackNEON(const std::uint8_t *pSource, int8x16_t pShiftA, int8x16_t pShiftB) {
    const uint8x16_t aWeightsA = {1,4,16,64,1,4,16,64,1,4,16,64,1,4,16,64};
    const auto aWeightsB = vshlq_n_u8(aWeightsA, 1);
    const auto aPackGroup = [&](std::size_t pOffset) {
        const auto aValue = vld1q_u8(pSource + pOffset);
        return vorrq_u8(vandq_u8(vshlq_u8(aValue, pShiftA), aWeightsA),
                        vandq_u8(vshlq_u8(aValue, pShiftB), aWeightsB));
    };
    return vpaddq_u8(vpaddq_u8(aPackGroup(0U), aPackGroup(16U)),
                     vpaddq_u8(aPackGroup(32U), aPackGroup(48U)));
}
#elif !IGNORE_SIMD && defined(__SSE2__)
inline __m128i PackSIMD(const std::uint8_t *pSource, __m128i pShiftA, __m128i pShiftB) {
    const auto aOnes = _mm_set1_epi8(1);
    const auto aPackGroup = [&](std::size_t pOffset) {
        const auto aValue = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource + pOffset));
        auto aBits = _mm_or_si128(_mm_and_si128(_mm_srl_epi16(aValue, pShiftA), aOnes),
            _mm_slli_epi16(_mm_and_si128(_mm_srl_epi16(aValue, pShiftB), aOnes), 1));
        aBits = _mm_or_si128(aBits, _mm_srli_epi32(aBits, 6));
        aBits = _mm_or_si128(aBits, _mm_srli_epi32(aBits, 12));
        return _mm_and_si128(aBits, _mm_set1_epi32(255));
    };
    return _mm_packus_epi16(_mm_packs_epi32(aPackGroup(0U), aPackGroup(16U)),
                            _mm_packs_epi32(aPackGroup(32U), aPackGroup(48U)));
}
#endif
} // namespace FlameToadPacking

#endif
