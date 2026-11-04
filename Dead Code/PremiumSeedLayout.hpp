#ifndef PremiumSeedLayout_hpp
#define PremiumSeedLayout_hpp

#include <cstddef>

// Four 16 KiB lanes: 8,192 source words, each with exactly one purpose.
// 63 interleaved groups of [80 direct words, 48 fold words], followed by
// 128 direct words. The 3,024 fold words produce 63 premium row-family words.
// All other choices read the 5,168 direct words, never the premium seed.
struct PremiumSeedLayout {
    static constexpr std::size_t kLanes = 4U;
    static constexpr std::size_t kLaneBytes = 16384U;
    static constexpr std::size_t kWordBytes = 8U;
    static constexpr std::size_t kWordsPerLane = kLaneBytes / kWordBytes;
    static constexpr std::size_t kSourceWords = kLanes * kWordsPerLane;
    static constexpr std::size_t kGroupWords = 128U;
    static constexpr std::size_t kDirectWordsPerGroup = 80U;
    static constexpr std::size_t kFoldWords = 48U;
    static constexpr std::size_t kPremiumWords = 63U;
    static constexpr std::size_t kSeedWords = kPremiumWords * kFoldWords;
    static constexpr std::size_t kSeedWordsPerHalf = kSeedWords / 2U;
    static constexpr std::size_t kShuffleWords = kSourceWords - kSeedWords;

    // Disjoint, half-open ranges in the direct-word stream.
    static constexpr std::size_t kIndexShuffleEnd = 128U;
    static constexpr std::size_t kPremiumShuffleEnd = 192U;
    static constexpr std::size_t kRotationShuffleBegin = kPremiumShuffleEnd;
    static constexpr std::size_t kRotationShuffleEnd = kRotationShuffleBegin + 4094U;
    static constexpr std::size_t kRotationLiftL2Begin = kRotationShuffleEnd;
    static constexpr std::size_t kRotationLiftL3Begin = kRotationLiftL2Begin + 64U;
    static constexpr std::size_t kRotationFreeLiftBegin = kRotationLiftL3Begin + 64U;
    static constexpr std::size_t kRotationFreeByteBegin = kRotationFreeLiftBegin + 64U;
    static constexpr std::size_t kPlanSelectionIndex = kRotationFreeByteBegin + 64U;
    static constexpr std::size_t kMaskSelectionIndex = kPlanSelectionIndex + 1U;
    static constexpr std::size_t kMaterialShuffleBegin = kMaskSelectionIndex + 1U;
    static constexpr std::size_t kMaterialShuffleEnd = kMaterialShuffleBegin + 336U;
    static constexpr std::size_t kMaterialReverseBegin = kMaterialShuffleEnd;
    static constexpr std::size_t kMaterialReverseEnd = kMaterialReverseBegin + 8U;
    static constexpr std::size_t kMaskShuffleBegin = kMaterialReverseEnd;
    static constexpr std::size_t kMaskShuffleEnd = kShuffleWords;

    // Return a physical word index across all four lanes, not a byte offset.
    static constexpr std::size_t ShuffleWordIndex(std::size_t pIndex) {
        constexpr auto kGrouped = kPremiumWords * kDirectWordsPerGroup;
        return pIndex < kGrouped ? (pIndex / kDirectWordsPerGroup) * kGroupWords +
            pIndex % kDirectWordsPerGroup : kPremiumWords * kGroupWords + pIndex - kGrouped;
    }
    static constexpr std::size_t SeedWordIndex(std::size_t pIndex) {
        return (pIndex / kFoldWords) * kGroupWords + kDirectWordsPerGroup + pIndex % kFoldWords;
    }
};

static_assert(PremiumSeedLayout::kSeedWords == 3024U);
static_assert(PremiumSeedLayout::kShuffleWords == 5168U);
static_assert(PremiumSeedLayout::kMaskShuffleEnd - PremiumSeedLayout::kMaskShuffleBegin == 280U);
static_assert(PremiumSeedLayout::ShuffleWordIndex(PremiumSeedLayout::kShuffleWords - 1U) + 1U ==
              PremiumSeedLayout::kSourceWords);
#endif /* PremiumSeedLayout_hpp */
