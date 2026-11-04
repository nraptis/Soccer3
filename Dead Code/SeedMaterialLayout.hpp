#ifndef SOCCER_SEED_MATERIAL_LAYOUT_HPP_
#define SOCCER_SEED_MATERIAL_LAYOUT_HPP_
#include <cstddef>

struct SeedMaterialLayout {
    // The final four 64 KiB folds supply material ordering and reversals.
    // Legacy mask-bank selection/shuffling is no longer performed.
    static constexpr std::size_t kLaneBytes = 65536U;
    static constexpr std::size_t kWordsPerLane = kLaneBytes / 8U;
    static constexpr std::size_t kSourceWords = 4U * kWordsPerLane;
    static constexpr std::size_t kMaterialShuffleBegin = 0U;
    static constexpr std::size_t kMaterialShuffleEnd = kSourceWords - 8U;
    static constexpr std::size_t kMaterialReverseBegin = kMaterialShuffleEnd;
};
#endif
