#ifndef SOCCER_BIT_PLANE_TOOL_HPP_
#define SOCCER_BIT_PLANE_TOOL_HPP_

#include <array>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <utility>

// Four layers x four pairs. Every layer AND every pair column partitions 0..7.
// Pair members must have circular distance >= 2: neither equal nor adjacent,
// including the wrap pair {0,7}. The grid enumerates unordered pairs and
// returns each pair in ascending order.
// Repeating a pair in different rows/columns is allowed by these constraints.
//
// All 211,392 labeled grids are represented, not just cyclic constructions.
// Sorting the first row's four pair masks gives 8,808 base grids. Applying
// each of the 24 column permutations restores every labeled grid exactly once.
// Arbitrary BIT-LABEL permutations would break the circular-distance rule.
class BitPlaneTool {
public:
    static constexpr std::size_t kLayerCount = 4U;
    static constexpr std::size_t kPairCount = 4U;
    static constexpr std::size_t kRowsPerPair = 2U;
    static constexpr std::size_t kBasePlanCount = 8808U;
    static constexpr std::size_t kColumnOrderCount = 24U;
    static constexpr std::size_t kPlanCount = kBasePlanCount * kColumnOrderCount;
    static constexpr std::size_t kSeedWordCount = 2U;
    static constexpr std::size_t kPackedPlanBytes = kBasePlanCount * sizeof(std::uint64_t);

    using Pair = std::array<std::uint8_t, kRowsPerPair>;
    using Layer = std::array<Pair, kPairCount>;
    using Plan = std::array<Layer, kLayerCount>;

    // Separate seed words select a base grid and its column permutation.
    // Uniform ranks give uniform labeled grids; fixed 64-bit modulo reduction
    // has only remainder bias (no greedy selection or retry-dependent bias).
    // pColumnShuffle % 24 == 23 is the identity column order.
    static Plan Select(std::uint64_t pPlanSelection, std::uint64_t pColumnShuffle) {
        std::uint64_t aPacked = kBasePlans[pPlanSelection % kBasePlanCount];
        std::array<std::array<std::uint8_t, kPairCount>, kLayerCount> aMasks{};
        for (std::size_t aLayer = 0U; aLayer < kLayerCount - 1U; ++aLayer) {
            for (std::size_t aPair = 0U; aPair < kPairCount; ++aPair) {
                aMasks[aLayer][aPair] = kPairMasks[aPacked & 31U];
                aPacked >>= 5U;
            }
        }
        for (std::size_t aPair = 0U; aPair < kPairCount; ++aPair) {
            aMasks[3U][aPair] = static_cast<std::uint8_t>(
                255U ^ (aMasks[0U][aPair] | aMasks[1U][aPair] | aMasks[2U][aPair]));
        }

        std::array<std::size_t, kPairCount> aColumns = {0U, 1U, 2U, 3U};
        pColumnShuffle %= kColumnOrderCount;
        for (std::size_t aIndex = kPairCount - 1U; aIndex > 0U; --aIndex) {
            const auto aOther = static_cast<std::size_t>(pColumnShuffle % (aIndex + 1U));
            pColumnShuffle /= aIndex + 1U;
            std::swap(aColumns[aIndex], aColumns[aOther]);
        }

        Plan aResult{};
        for (std::size_t aLayer = 0U; aLayer < kLayerCount; ++aLayer) {
            for (std::size_t aPair = 0U; aPair < kPairCount; ++aPair) {
                const auto aMask = aMasks[aLayer][aColumns[aPair]];
                std::size_t aCount = 0U;
                for (unsigned aRow = 0U; aRow < 8U; ++aRow) {
                    if ((aMask & (1U << aRow)) != 0U)
                        aResult[aLayer][aPair][aCount++] = static_cast<std::uint8_t>(aRow);
                }
            }
        }
        return aResult;
    }

    static constexpr std::uint8_t Mask(const Pair &pPair) {
        if (pPair[0] >= 8U || pPair[1] >= 8U || pPair[0] == pPair[1]) return 0U;
        return static_cast<std::uint8_t>((1U << pPair[0]) | (1U << pPair[1]));
    }

    static bool IsValid(const Plan &pPlan) {
        for (std::size_t aIndex = 0U; aIndex < kLayerCount; ++aIndex) {
            unsigned aLayerMask = 0U, aColumnMask = 0U;
            for (std::size_t aOther = 0U; aOther < kPairCount; ++aOther) {
                const auto &aPair = pPlan[aIndex][aOther];
                const auto aMask = Mask(aPair);
                if (aMask == 0U) return false;
                const unsigned aDistance = aPair[0] < aPair[1]
                    ? aPair[1] - aPair[0] : aPair[0] - aPair[1];
                if (aDistance < 2U || aDistance > 6U) return false;
                const auto aOtherMask = Mask(pPlan[aOther][aIndex]);
                if ((aLayerMask & aMask) != 0U || (aColumnMask & aOtherMask) != 0U) return false;
                aLayerMask |= aMask;
                aColumnMask |= aOtherMask;
            }
            if (aLayerMask != 255U || aColumnMask != 255U) return false;
        }
        return true;
    }

    static void Print(const Plan &pPlan, const char *pLabel = "BitPlaneTool",
                      std::FILE *pStream = stdout) {
        if (pStream == nullptr) return;
        std::fprintf(pStream, "%s | layers a-d; pair columns 1-4\n", pLabel ? pLabel : "BitPlaneTool");
        for (std::size_t aLayer = 0U; aLayer < kLayerCount; ++aLayer) {
            std::fprintf(pStream, "%c:", static_cast<int>('a' + aLayer));
            for (const auto &aPair : pPlan[aLayer])
                std::fprintf(pStream, " [%u %u]", static_cast<unsigned>(aPair[0]), static_cast<unsigned>(aPair[1]));
            std::fputc('\n', pStream);
        }
    }

private:
    // All 20 allowed unordered pairs, in ascending mask order. Shared encoding
    // contract with Tools/generate_bit_plane_tool.py.
    inline static constexpr std::array<std::uint8_t, 20U> kPairMasks = {
        0x05U, 0x09U, 0x0AU, 0x11U, 0x12U, 0x14U, 0x21U, 0x22U, 0x24U, 0x28U,
        0x41U, 0x42U, 0x44U, 0x48U, 0x50U, 0x82U, 0x84U, 0x88U, 0x90U, 0xA0U
    };
    inline static constexpr std::array<std::uint64_t, kBasePlanCount> kBasePlans = {{
#include "BitPlaneToolPlans.inc"
    }};
};

static_assert(sizeof(BitPlaneTool::Plan) == 32U);
static_assert(BitPlaneTool::kPlanCount == 211392U);
static_assert(BitPlaneTool::kPackedPlanBytes == 70464U);

#endif  // SOCCER_BIT_PLANE_TOOL_HPP_
