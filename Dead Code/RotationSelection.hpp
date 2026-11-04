#ifndef SOCCER_ROTATION_SELECTION_HPP_
#define SOCCER_ROTATION_SELECTION_HPP_

#include <cstddef>
#include <cstdint>
#include "RotationPack.hpp"

namespace RotationSelection {
inline constexpr std::size_t kPackCount = 8U;
inline constexpr std::size_t kWindowCount = RotationPack::kWindowCount;
inline constexpr std::size_t kSamplingCount = kPackCount * 4U * 4U;
inline constexpr std::size_t kByteCount = kPackCount * 2U;
inline constexpr std::size_t kSelectedCount = kSamplingCount + kByteCount;

struct Statistics {
    std::size_t mBaseReadCount = 0U;
    std::size_t mBlockedCount = 0U;
    std::size_t mShuffleBytesRead = 0U;
};

// Independent validator for the observable plan. Global rules are uniqueness
// and inverse exclusion. Within each frog+two-masked-rotations group, all 64
// subset sums must differ, in BOTH the window and actual byte rings. This is
// deliberately local; it does not forbid combinations across different frogs.
inline bool IsValid(const std::uint16_t *pSamples, std::size_t pSampleCount,
                    const std::int32_t *pBytes, std::size_t pByteCount) {
    if (!pSamples || !pBytes || pSampleCount != kSamplingCount || pByteCount != kByteCount) return false;
    constexpr std::uint32_t kByteMask = RotationPack::kBlockBytes - 1U;
    std::uint32_t aBytes[kSelectedCount] = {};
    bool aBlocked[kWindowCount] = {};
    aBlocked[0U] = true;
    aBlocked[kWindowCount / 2U] = true;
    for (std::size_t aIndex = 0U; aIndex < kSelectedCount; ++aIndex) {
        std::uint32_t aWindow;
        if (aIndex < kSamplingCount) {
            aWindow = pSamples[aIndex];
            aBytes[aIndex] = 64U * aWindow;
        } else {
            const auto aValue = pBytes[aIndex - kSamplingCount];
            if (aValue <= 0 || aValue > static_cast<std::int32_t>(kByteMask) || aValue % 64 == 0) return false;
            aBytes[aIndex] = static_cast<std::uint32_t>(aValue);
            aWindow = aBytes[aIndex] / 64U;
        }
        if (aWindow >= kWindowCount || aBlocked[aWindow]) return false;
        aBlocked[aWindow] = true;
        aBlocked[(0U - aWindow) & (kWindowCount - 1U)] = true;
        for (std::size_t aPrevious = 0U; aPrevious < aIndex; ++aPrevious)
            if (aBytes[aIndex] == aBytes[aPrevious] ||
                ((aBytes[aIndex] + aBytes[aPrevious]) & kByteMask) == 0U) return false;
    }
    for (std::size_t aPack = 0U; aPack < kPackCount; ++aPack) {
        if (((pBytes[2U*aPack] | pBytes[2U*aPack + 1U]) & 1U) == 0U) return false;
        for (std::size_t aFrog = 0U; aFrog < 4U; ++aFrog) {
            std::uint32_t aWindows[6];
            std::uint32_t aOffsets[6];
            for (std::size_t aSample = 0U; aSample < 4U; ++aSample) {
                aWindows[aSample] = pSamples[16U*aPack + 4U*aFrog + aSample];
                aOffsets[aSample] = 64U*aWindows[aSample];
            }
            for (std::size_t aRotation = 0U; aRotation < 2U; ++aRotation) {
                aOffsets[4U+aRotation] = static_cast<std::uint32_t>(pBytes[2U*aPack+aRotation]);
                aWindows[4U+aRotation] = aOffsets[4U+aRotation] / 64U;
            }
            std::uint32_t aWindowSums[64] = {};
            std::uint32_t aByteSums[64] = {};
            for (unsigned aSubset = 0U; aSubset < 64U; ++aSubset) {
                for (unsigned aBit = 0U; aBit < 6U; ++aBit) if (aSubset & (1U << aBit)) {
                    aWindowSums[aSubset] += aWindows[aBit];
                    aByteSums[aSubset] += aOffsets[aBit];
                }
                aWindowSums[aSubset] &= kWindowCount - 1U;
                aByteSums[aSubset] &= kByteMask;
                for (unsigned aPrevious = 0U; aPrevious < aSubset; ++aPrevious)
                    if (aWindowSums[aSubset] == aWindowSums[aPrevious] ||
                        aByteSums[aSubset] == aByteSums[aPrevious]) return false;
            }
        }
    }
    return true;
}
} // namespace RotationSelection
#endif
