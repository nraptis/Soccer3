#ifndef SOCCER_RANDOM_SHUFFLE_LAYOUT_HPP_
#define SOCCER_RANDOM_SHUFFLE_LAYOUT_HPP_
#include <cstddef>

// Eighteen identical-sized units fill 32,760 of each 32,768-byte block.
// A unit gives one rotation list a forward partial pass, feeds every word
// accumulator, and reserves one pass for each ordering list and one cross list.
// Small shuffles use byte choices; rotation shuffles use little-endian uint16.
// Four choice words per small-list entry is a budget, not a promise to read
// every reserved word: rejection or early completion determines consumption.
struct RandomShuffleLayout {
    static constexpr std::size_t kRandomBytes = 32768U;
    static constexpr std::size_t kGenerationCount = 38U;
    static constexpr std::size_t kRotationListCount = 18U;
    static constexpr std::size_t kUnitCount = kRotationListCount;
    static constexpr std::size_t kUnitBytes = 1820U;
    static constexpr std::size_t kUsedBytes = kUnitCount * kUnitBytes;
    static constexpr std::size_t kUnusedBytes = kRandomBytes - kUsedBytes;
    static constexpr std::size_t kWordsPerEntry = 4U;
    static constexpr std::size_t kFreeRotationWordCount = 16U;
    static constexpr std::size_t kFreeRotationBytes = 8U * kFreeRotationWordCount;
    static constexpr std::size_t kBitPlaneWordCount = 3U;
    static constexpr std::size_t kBitPlaneBytes = 8U * kBitPlaneWordCount;
    static constexpr std::size_t kExpandersBytes = kWordsPerEntry * 16U;

    // Final folded material: four 64 KiB lanes addressed in 64-bit words.
    // These words supply material ordering and whole-lane reversal selection.
    static constexpr std::size_t kMaterialLaneBytes = 65536U;
    static constexpr std::size_t kMaterialWordsPerLane = kMaterialLaneBytes / 8U;
    static constexpr std::size_t kMaterialSourceWords = 4U * kMaterialWordsPerLane;
    static constexpr std::size_t kMaterialShuffleBegin = 0U;
    static constexpr std::size_t kMaterialShuffleEnd = kMaterialSourceWords - 8U;
    static constexpr std::size_t kMaterialReverseBegin = kMaterialShuffleEnd;

    static constexpr std::size_t UnitBegin(std::size_t pUnit) { return pUnit * kUnitBytes; }
    static constexpr std::size_t FreeRotationWordOffset(std::size_t pUnit, std::size_t pWord) {
        return UnitBegin(pUnit) + 8U * pWord;
    }
    static constexpr std::size_t BitPlaneWordOffset(std::size_t pUnit, std::size_t pWord) {
        return UnitBegin(pUnit) + kFreeRotationBytes + 8U * pWord;
    }
    static constexpr std::size_t OrderingBytes(std::size_t pLaneCount) { return kWordsPerEntry * pLaneCount; }
    static constexpr std::size_t CrossBytes(std::size_t pLaneCount) { return kWordsPerEntry * (4U * pLaneCount); }
    static constexpr std::size_t RotationBytesPerList(std::size_t pLaneCount) {
        return kUnitBytes - kFreeRotationBytes - kBitPlaneBytes -
               3U * OrderingBytes(pLaneCount) - kExpandersBytes - CrossBytes(pLaneCount);
    }
    static constexpr std::size_t RotationBegin(std::size_t pOffset) {
        return pOffset + kFreeRotationBytes + kBitPlaneBytes;
    }
    static constexpr std::size_t MaterialsBegin(std::size_t pOffset, std::size_t pLaneCount) {
        return RotationBegin(pOffset) + RotationBytesPerList(pLaneCount);
    }
    static constexpr std::size_t SourcesBegin(std::size_t pOffset, std::size_t pLaneCount) {
        return MaterialsBegin(pOffset, pLaneCount) + OrderingBytes(pLaneCount);
    }
    static constexpr std::size_t WorkSpacesBegin(std::size_t pOffset, std::size_t pLaneCount) {
        return SourcesBegin(pOffset, pLaneCount) + OrderingBytes(pLaneCount);
    }
    static constexpr std::size_t ExpandersBegin(std::size_t pOffset, std::size_t pLaneCount) {
        return WorkSpacesBegin(pOffset, pLaneCount) + OrderingBytes(pLaneCount);
    }
    static constexpr std::size_t CrossBegin(std::size_t pOffset, std::size_t pLaneCount) {
        return ExpandersBegin(pOffset, pLaneCount) + kExpandersBytes;
    }
    static constexpr std::size_t CrossLane(std::size_t pGeneration, std::size_t pUnit, std::size_t pLaneCount) {
        return (pGeneration * kUnitCount + pUnit) % pLaneCount;
    }
    static constexpr std::size_t RotationBudgetBytes(std::size_t pLaneCount) {
        return kGenerationCount * kUnitCount * RotationBytesPerList(pLaneCount);
    }
};
static_assert(RandomShuffleLayout::kUnusedBytes == 8U);
static_assert(RandomShuffleLayout::RotationBytesPerList(16U) == 1156U);
static_assert(RandomShuffleLayout::CrossBegin(0U,16U) + RandomShuffleLayout::CrossBytes(16U) == RandomShuffleLayout::kUnitBytes);
static_assert(RandomShuffleLayout::CrossBegin(0U,8U) + RandomShuffleLayout::CrossBytes(8U) == RandomShuffleLayout::kUnitBytes);
static_assert(RandomShuffleLayout::CrossBegin(0U,4U) + RandomShuffleLayout::CrossBytes(4U) == RandomShuffleLayout::kUnitBytes);
#endif
