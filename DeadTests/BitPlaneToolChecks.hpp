#ifndef SOCCER_BIT_PLANE_TOOL_CHECKS_HPP_
#define SOCCER_BIT_PLANE_TOOL_CHECKS_HPP_

#include "BitPlaneTool.hpp"
#include <algorithm>
#include <array>
#include <limits>
#include <set>
#include <vector>

// Independent check using eight-entry occurrence counters, not combined masks.
inline bool CheckBitPlaneToolOccurrences(const BitPlaneTool::Plan &pPlan) {
    for (unsigned aIndex = 0U; aIndex < 4U; ++aIndex) {
        std::array<unsigned, 8U> aLayerCounts{}, aColumnCounts{};
        for (unsigned aOther = 0U; aOther < 4U; ++aOther) {
            const auto &aPair = pPlan[aIndex][aOther];
            if (aPair[0] >= 8U || aPair[1] >= 8U) return false;
            const unsigned aDifference = (aPair[0] + 8U - aPair[1]) % 8U;
            if (aDifference == 0U || aDifference == 1U || aDifference == 7U) return false;
            for (unsigned aMember = 0U; aMember < 2U; ++aMember) {
                ++aLayerCounts[aPair[aMember]];
                const auto aColumnRow = pPlan[aOther][aIndex][aMember];
                if (aColumnRow >= 8U) return false;
                ++aColumnCounts[aColumnRow];
            }
        }
        for (unsigned aRow = 0U; aRow < 8U; ++aRow)
            if (aLayerCounts[aRow] != 1U || aColumnCounts[aRow] != 1U) return false;
    }
    return true;
}

// Independent counting oracle: enumerate all 8! arrangements of a layer,
// then join compatible complete layers. The generator instead fills cells
// recursively. Only the top layer is normalized by ascending pair mask.
inline std::size_t CountBitPlaneToolBasePlans() {
    using MaskLayer = std::array<std::uint8_t, 4U>;
    std::vector<MaskLayer> aLayers;
    std::array<std::uint8_t, 8U> aRows = {0U, 1U, 2U, 3U, 4U, 5U, 6U, 7U};
    do {
        MaskLayer aLayer{};
        bool aValid = true;
        for (unsigned aPair = 0U; aPair < 4U; ++aPair) {
            const unsigned aFirst = aRows[2U * aPair], aSecond = aRows[2U * aPair + 1U];
            if (aFirst >= aSecond || aSecond - aFirst < 2U || aSecond - aFirst > 6U) { aValid = false; break; }
            aLayer[aPair] = static_cast<std::uint8_t>((1U << aFirst) | (1U << aSecond));
        }
        if (aValid) aLayers.push_back(aLayer);
    } while (std::next_permutation(aRows.begin(), aRows.end()));
    if (aLayers.size() != 744U) return 0U;
    auto aDisjoint = [](const MaskLayer &pFirst, const MaskLayer &pSecond) {
        for (unsigned aColumn = 0U; aColumn < 4U; ++aColumn)
            if ((pFirst[aColumn] & pSecond[aColumn]) != 0U) return false;
        return true;
    };
    std::array<bool, 256U> aAllowed{};
    for (unsigned aFirst = 0U; aFirst < 8U; ++aFirst)
        for (unsigned aSecond = aFirst + 2U; aSecond < 8U; ++aSecond)
            if (aSecond - aFirst != 7U) aAllowed[(1U << aFirst) | (1U << aSecond)] = true;
    std::size_t aCount = 0U;
    for (const auto &aFirst : aLayers) {
        if (!std::is_sorted(aFirst.begin(), aFirst.end())) continue;
        std::vector<MaskLayer> aCompatible;
        for (const auto &aSecond : aLayers) if (aDisjoint(aFirst, aSecond)) aCompatible.push_back(aSecond);
        for (const auto &aSecond : aCompatible) {
            for (const auto &aThird : aCompatible) {
                if (!aDisjoint(aSecond, aThird)) continue;
                unsigned aLastMask = 0U;
                bool aValid = true;
                for (unsigned aColumn = 0U; aColumn < 4U; ++aColumn) {
                    const unsigned aMask = 255U ^ (aFirst[aColumn] | aSecond[aColumn] | aThird[aColumn]);
                    if (!aAllowed[aMask] || (aLastMask & aMask) != 0U) { aValid = false; break; }
                    aLastMask |= aMask;
                }
                if (aValid && aLastMask == 255U) ++aCount;
            }
        }
    }
    return aCount;
}

inline const char *CheckBitPlaneToolAllPlans() {
    if (CountBitPlaneToolBasePlans() != BitPlaneTool::kBasePlanCount) return "independent enumeration disagrees with bank size";
    std::set<BitPlaneTool::Plan> aPlans;
    for (std::uint64_t aBase = 0U; aBase < BitPlaneTool::kBasePlanCount; ++aBase) {
        for (std::uint64_t aShuffle = 0U; aShuffle < BitPlaneTool::kColumnOrderCount; ++aShuffle) {
            const auto aPlan = BitPlaneTool::Select(aBase, aShuffle);
            if (!CheckBitPlaneToolOccurrences(aPlan) || !BitPlaneTool::IsValid(aPlan)) return "invalid selected plan";
            if (!aPlans.insert(aPlan).second) return "duplicate selected plan";
            if (aShuffle == 23U) {
                for (unsigned aColumn = 1U; aColumn < 4U; ++aColumn)
                    if (BitPlaneTool::Mask(aPlan[0U][aColumn - 1U]) >= BitPlaneTool::Mask(aPlan[0U][aColumn]))
                        return "base plan top layer not normalized";
            }
        }
    }
    if (aPlans.size() != BitPlaneTool::kPlanCount) return "incomplete plan coverage";
    return nullptr;
}

inline const char *CheckBitPlaneToolArguments() {
    const auto aMaximum = std::numeric_limits<std::uint64_t>::max();
    for (std::uint64_t aWord : {std::uint64_t{0U}, std::uint64_t{1U}, std::uint64_t{8807U},
                               std::uint64_t{8808U}, aMaximum}) {
        for (std::uint64_t aShuffle : {std::uint64_t{0U}, std::uint64_t{23U}, std::uint64_t{24U}, aMaximum}) {
            const auto aPlan = BitPlaneTool::Select(aWord, aShuffle);
            if (!CheckBitPlaneToolOccurrences(aPlan)) return "extreme seed generated invalid plan";
            if (aPlan != BitPlaneTool::Select(aWord % 8808U, aShuffle % 24U)) return "selection is not deterministic";
        }
    }
    const auto aBase = BitPlaneTool::Select(0U, 23U);
    for (const BitPlaneTool::Pair aBadPair : {BitPlaneTool::Pair{0U, 7U}, {0U, 1U}, {1U, 0U},
                                            {7U, 0U}, {3U, 3U}, {8U, 2U}, {0U, 255U}}) {
        auto aPlan = aBase;
        aPlan[0U][0U] = aBadPair;
        if (BitPlaneTool::IsValid(aPlan)) return "invalid pair accepted";
    }
    auto aPlan = aBase;
    aPlan[1U] = aPlan[0U];
    if (BitPlaneTool::IsValid(aPlan)) return "column duplicate accepted";
    aPlan = aBase;
    aPlan[0U][1U] = aPlan[0U][0U];
    if (BitPlaneTool::IsValid(aPlan)) return "layer duplicate accepted";
    aPlan = aBase;
    for (auto &aLayer : aPlan) for (auto &aPair : aLayer) std::swap(aPair[0U], aPair[1U]);
    if (!BitPlaneTool::IsValid(aPlan)) return "reversing unordered pair members changed validity";
    if (BitPlaneTool::Mask({0U, 7U}) != 0x81U || BitPlaneTool::Mask({1U, 1U}) != 0U ||
        BitPlaneTool::Mask({8U, 2U}) != 0U) return "pair mask conversion failed";
    return nullptr;
}

#endif  // SOCCER_BIT_PLANE_TOOL_CHECKS_HPP_
