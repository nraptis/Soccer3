#ifndef ByteStripStitchNEON_hpp
#define ByteStripStitchNEON_hpp

// Raw-byte NEON equivalents for reference tests and packing benchmarks.
// Unlike the readable Stitch functions, these never materialize bool strips.
#if defined(__aarch64__)
#include <arm_neon.h>
#include <cstddef>
#include <cstdint>

namespace ByteStripStitchNEON {

struct Plan {
    int8x16_t mShift1;
    int8x16_t mShift2;
    uint8x16_t mWeight1;
    uint8x16_t mWeight2;
};

// Build once per stage. The caller supplies distinct row indices in [0,7]
// and a pair rotation in [0,3]. Each Plan works with either window size.
inline Plan MakePlan(std::size_t pRow1, std::size_t pRow2, std::size_t pRotation) {
    std::int8_t aPositions[16];
    for (std::size_t aLane = 0; aLane < 16; ++aLane) {
        aPositions[aLane] = static_cast<std::int8_t>(2 * ((aLane + pRotation) % 4));
    }
    const auto aPositionsVector = vld1q_s8(aPositions);
    const auto aSecondPositions = vaddq_s8(aPositionsVector, vdupq_n_s8(1));
    return {
        vsubq_s8(aPositionsVector, vdupq_n_s8(static_cast<std::int8_t>(pRow1))),
        vsubq_s8(aSecondPositions, vdupq_n_s8(static_cast<std::int8_t>(pRow2))),
        vshlq_u8(vdupq_n_u8(1), aPositionsVector),
        vshlq_u8(vdupq_n_u8(1), aSecondPositions)
    };
}

inline uint8x16_t PlaceBits(uint8x16_t pBytes, const Plan &pPlan) {
    return vorrq_u8(vandq_u8(vshlq_u8(pBytes, pPlan.mShift1), pPlan.mWeight1),
                    vandq_u8(vshlq_u8(pBytes, pPlan.mShift2), pPlan.mWeight2));
}

// One 64-byte source window -> sixteen packed bytes.
inline uint8x16_t Pack64(const std::uint8_t *pSource, const Plan &pPlan) {
    const auto aFirst = PlaceBits(vld1q_u8(pSource), pPlan);
    const auto aSecond = PlaceBits(vld1q_u8(pSource + 16), pPlan);
    const auto aThird = PlaceBits(vld1q_u8(pSource + 32), pPlan);
    const auto aFourth = PlaceBits(vld1q_u8(pSource + 48), pPlan);
    return vpaddq_u8(vpaddq_u8(aFirst, aSecond), vpaddq_u8(aThird, aFourth));
}

// One 32-byte source window -> eight packed bytes. No read beyond byte 31.
inline uint8x8_t Pack32(const std::uint8_t *pSource, const Plan &pPlan) {
    const auto aFirst = PlaceBits(vld1q_u8(pSource), pPlan);
    const auto aSecond = PlaceBits(vld1q_u8(pSource + 16), pPlan);
    const auto aPairs = vpaddq_u8(aFirst, aSecond);
    return vpadd_u8(vget_low_u8(aPairs), vget_high_u8(aPairs));
}

} // namespace ByteStripStitchNEON
#endif

#endif /* ByteStripStitchNEON_hpp */
