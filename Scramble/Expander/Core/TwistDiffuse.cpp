//
//  TwistDiffuse.cpp
//  MeanMachine
//
//  Created by icarus black on 6/23/26.
//

#include "TwistDiffuse.hpp"
#include "TwistShuffle.hpp"

#include <array>
#include <cstddef>
#include <cstdint>

namespace {

constexpr std::size_t kDispatchCount = 256U;
constexpr std::size_t kDispatchEntropyByteCount = M88::kOperationByteCount;
constexpr std::size_t kDispatchOutputByteCount = 64U;
constexpr std::size_t kInputPairByteCount = 2U * kDispatchOutputByteCount;
constexpr std::size_t kQuartetByteCount = 4U * kDispatchOutputByteCount;
constexpr std::size_t kPermutationCount = 24U;
constexpr std::size_t kShuffleByteCount = 512U;
constexpr std::size_t kOperationSetByteCount =
    kDispatchCount * kDispatchEntropyByteCount;

constexpr std::size_t kFirstShuffleGroupStart = 0U;
constexpr std::size_t kOperationSetAStart =
    kFirstShuffleGroupStart + (4U * kShuffleByteCount);
constexpr std::size_t kSecondShuffleGroupStart =
    kOperationSetAStart + kOperationSetByteCount;
constexpr std::size_t kThirdShuffleGroupStart =
    kSecondShuffleGroupStart + (4U * kShuffleByteCount);
constexpr std::size_t kOperationSetBStart =
    kThirdShuffleGroupStart + (4U * kShuffleByteCount);
constexpr std::size_t kFourthShuffleGroupStart =
    kOperationSetBStart + kOperationSetByteCount;

constexpr std::size_t kKeyByteCount = 2048U;
constexpr std::size_t kKeyDispatchCount = 16U;
constexpr std::size_t kKeyShuffleByteCount = 256U;
constexpr std::size_t kKeyOperationSetStart = 256U;
constexpr std::size_t kKeyOperationSetByteCount = 1536U;
constexpr std::size_t kKeyFinalShuffleStart = 1792U;
constexpr std::size_t kKeyOperationSetAStart = kKeyOperationSetStart;
constexpr std::size_t kKeyOperationSetBStart =
    kKeyOperationSetAStart +
    (kKeyDispatchCount * kDispatchEntropyByteCount);

constexpr std::size_t kHalfDispatchCount = kDispatchCount / 2U;
constexpr std::size_t kKeyHalfDispatchCount = kKeyDispatchCount / 2U;

static_assert(S_BLOCK == 32768U);
static_assert(W_KEY == kKeyByteCount);
static_assert(kDispatchOutputByteCount == 64U);
static_assert(kInputPairByteCount == 128U);
static_assert(kQuartetByteCount == 256U);
static_assert(kShuffleByteCount == 512U);
static_assert(kOperationSetByteCount == 12288U);
static_assert(kOperationSetAStart == 2048U);
static_assert(kSecondShuffleGroupStart == 14336U);
static_assert(kThirdShuffleGroupStart == 16384U);
static_assert(kOperationSetBStart == 18432U);
static_assert(kFourthShuffleGroupStart == 30720U);
static_assert(kFourthShuffleGroupStart +
              (4U * kShuffleByteCount) == S_BLOCK);
static_assert(kDispatchCount * kInputPairByteCount == S_BLOCK);
static_assert(kHalfDispatchCount == 128U);

static_assert(kKeyDispatchCount * kInputPairByteCount == kKeyByteCount);
static_assert(kKeyOperationSetByteCount ==
              2U * kKeyDispatchCount * kDispatchEntropyByteCount);
static_assert(kKeyOperationSetBStart +
              (kKeyDispatchCount * kDispatchEntropyByteCount) ==
              kKeyFinalShuffleStart);
static_assert(kKeyFinalShuffleStart + kKeyShuffleByteCount ==
              kKeyByteCount);
static_assert(kKeyHalfDispatchCount == 8U);

constexpr std::uint8_t kPermutations[kPermutationCount][4] = {
    {0U, 1U, 2U, 3U}, {0U, 1U, 3U, 2U},
    {0U, 2U, 1U, 3U}, {0U, 2U, 3U, 1U},
    {0U, 3U, 1U, 2U}, {0U, 3U, 2U, 1U},

    {1U, 0U, 2U, 3U}, {1U, 0U, 3U, 2U},
    {1U, 2U, 0U, 3U}, {1U, 2U, 3U, 0U},
    {1U, 3U, 0U, 2U}, {1U, 3U, 2U, 0U},

    {2U, 0U, 1U, 3U}, {2U, 0U, 3U, 1U},
    {2U, 1U, 0U, 3U}, {2U, 1U, 3U, 0U},
    {2U, 3U, 0U, 1U}, {2U, 3U, 1U, 0U},

    {3U, 0U, 1U, 2U}, {3U, 0U, 2U, 1U},
    {3U, 1U, 0U, 2U}, {3U, 1U, 2U, 0U},
    {3U, 2U, 0U, 1U}, {3U, 2U, 1U, 0U}
};

std::size_t SelectPermutation(
    const std::uint8_t *pEntropyLane,
    const std::array<std::size_t, 4> &pOperationIndices,
    std::uint64_t pMatrixSelect) {

    const std::uint8_t aMatrixSelectByte =
        static_cast<std::uint8_t>(pMatrixSelect);

    for (std::size_t aOperationIndex : pOperationIndices) {
        for (std::size_t aByteOffset = 0U;
             aByteOffset < 4U;
             aByteOffset++) {

            const std::uint8_t aSelector =
                pEntropyLane[aOperationIndex + aByteOffset] ^
                aMatrixSelectByte;

            if (aSelector < 240U) {
                return static_cast<std::size_t>(aSelector % 24U);
            }
        }
    }

    // All 16 candidate bytes were rejected. Probability: 2^-64.
    return 0U;
}

/*
 * Each quartet reads one 64-byte block from each input lane and writes those
 * four blocks to 256 consecutive destination bytes. One of the 24 possible
 * input-lane permutations selects their output order.
 *
 * For a shuffled pair index N:
 *
 *     side 0 -> block N * 2
 *     side 1 -> block N * 2 + 1
 */
void DiffuseLaneQuartetsWithDomainWords(
    std::uint8_t *pInputLaneA,
    std::uint8_t *pInputLaneB,
    std::uint8_t *pInputLaneC,
    std::uint8_t *pInputLaneD,
    std::uint8_t *pOutputLane,
    std::uint8_t *pEntropyLane,
    std::size_t *pIndexListA,
    std::size_t *pIndexListB,
    std::size_t *pIndexListC,
    std::size_t *pIndexListD,
    M88 *pMatrix,
    std::size_t pOperationSetAStart,
    std::size_t pOperationSetBStart,
    std::size_t pIndexStart,
    std::size_t pQuartetCount,
    std::size_t pInputSide,
    std::uint64_t pMatrixSelect,
    std::uint8_t pMatrixUnroll,
    std::uint8_t pMatrixArgA,
    std::uint8_t pMatrixArgB,
    std::uint8_t pMatrixArgC,
    std::uint8_t pMatrixArgD) {

    std::array<std::uint8_t *, 4> aInputLanes = {
        pInputLaneA,
        pInputLaneB,
        pInputLaneC,
        pInputLaneD
    };

    std::array<std::size_t *, 4> aIndexLists = {
        pIndexListA,
        pIndexListB,
        pIndexListC,
        pIndexListD
    };

    for (std::size_t aQuartetIndex = 0U;
         aQuartetIndex < pQuartetCount;
         aQuartetIndex++) {

        const std::size_t aListIndex = pIndexStart + aQuartetIndex;
        const std::size_t aOperationDispatchIndexA = aQuartetIndex * 2U;
        const std::size_t aOperationDispatchIndexB =
            aOperationDispatchIndexA + 1U;

        const std::array<std::size_t, 4> aOperationIndices = {
            pOperationSetAStart +
                (aOperationDispatchIndexA * kDispatchEntropyByteCount),
            pOperationSetBStart +
                (aOperationDispatchIndexA * kDispatchEntropyByteCount),
            pOperationSetAStart +
                (aOperationDispatchIndexB * kDispatchEntropyByteCount),
            pOperationSetBStart +
                (aOperationDispatchIndexB * kDispatchEntropyByteCount)
        };

        std::array<std::size_t, 4> aReadIndices{};

        for (std::size_t aInputIndex = 0U;
             aInputIndex < 4U;
             aInputIndex++) {

            const std::size_t aPairIndex =
                aIndexLists[aInputIndex][aListIndex];
            const std::size_t aBlockIndex =
                (aPairIndex * 2U) + pInputSide;

            aReadIndices[aInputIndex] =
                aBlockIndex * kDispatchOutputByteCount;
        }

        const std::size_t aPermutationIndex =
            SelectPermutation(pEntropyLane,
                              aOperationIndices,
                              pMatrixSelect);

        const std::size_t aDestinationStart =
            aQuartetIndex * kQuartetByteCount;

        for (std::size_t aOutputIndex = 0U;
             aOutputIndex < 4U;
             aOutputIndex++) {

            const std::size_t aInputIndex =
                kPermutations[aPermutationIndex][aOutputIndex];
            const std::size_t aDestinationIndex =
                aDestinationStart +
                (aOutputIndex * kDispatchOutputByteCount);

            pMatrix->Dispatch(pEntropyLane,
                              aOperationIndices[aOutputIndex],
                              aInputLanes[aInputIndex],
                              aReadIndices[aInputIndex],
                              pOutputLane + aDestinationIndex,
                              pMatrixUnroll,
                              pMatrixArgA,
                              pMatrixArgB,
                              pMatrixArgC,
                              pMatrixArgD);
        }
    }
}

} // namespace

void TwistDiffuse::DiffuseWithDomainWords(
    std::uint8_t *pEntropyLaneA,
    std::uint8_t *pEntropyLaneB,
    std::uint8_t *pEntropyLaneC,
    std::uint8_t *pEntropyLaneD,
    std::uint8_t *pInputLaneA,
    std::uint8_t *pInputLaneB,
    std::uint8_t *pInputLaneC,
    std::uint8_t *pInputLaneD,
    std::uint8_t *pOutputLaneA,
    std::uint8_t *pOutputLaneB,
    std::uint8_t *pOutputLaneC,
    std::uint8_t *pOutputLaneD,
    std::size_t *pIndexList256A,
    std::size_t *pIndexList256B,
    std::size_t *pIndexList256C,
    std::size_t *pIndexList256D,
    M88 *pMatrix,
    std::uint64_t pMatrixSelectA,
    std::uint64_t pMatrixSelectB,
    std::uint8_t pMatrixUnrollA,
    std::uint8_t pMatrixUnrollB,
    std::uint8_t pMatrixArgA,
    std::uint8_t pMatrixArgB,
    std::uint8_t pMatrixArgC,
    std::uint8_t pMatrixArgD) {

    for (std::size_t aIndex = 0U;
         aIndex < kDispatchCount;
         aIndex++) {

        pIndexList256A[aIndex] = aIndex;
        pIndexList256B[aIndex] = aIndex;
        pIndexList256C[aIndex] = aIndex;
        pIndexList256D[aIndex] = aIndex;
    }

    // Shuffles 1-4
    TwistShuffle::ShuffleList256(
        pIndexList256A,
        pEntropyLaneA,
        kFirstShuffleGroupStart + (0U * kShuffleByteCount),
        kFirstShuffleGroupStart + (1U * kShuffleByteCount),
        1U);

    TwistShuffle::ShuffleList256(
        pIndexList256B,
        pEntropyLaneB,
        kFirstShuffleGroupStart + (1U * kShuffleByteCount),
        kFirstShuffleGroupStart + (2U * kShuffleByteCount),
        1U);

    TwistShuffle::ShuffleList256(
        pIndexList256C,
        pEntropyLaneC,
        kFirstShuffleGroupStart + (2U * kShuffleByteCount),
        kFirstShuffleGroupStart + (3U * kShuffleByteCount),
        1U);

    TwistShuffle::ShuffleList256(
        pIndexList256D,
        pEntropyLaneD,
        kFirstShuffleGroupStart + (3U * kShuffleByteCount),
        kFirstShuffleGroupStart + (4U * kShuffleByteCount),
        1U);

    // Shuffles 5-8
    TwistShuffle::ShuffleList256(
        pIndexList256A,
        pEntropyLaneA,
        kSecondShuffleGroupStart + (0U * kShuffleByteCount),
        kSecondShuffleGroupStart + (1U * kShuffleByteCount),
        1U);

    TwistShuffle::ShuffleList256(
        pIndexList256B,
        pEntropyLaneB,
        kSecondShuffleGroupStart + (1U * kShuffleByteCount),
        kSecondShuffleGroupStart + (2U * kShuffleByteCount),
        1U);

    TwistShuffle::ShuffleList256(
        pIndexList256C,
        pEntropyLaneC,
        kSecondShuffleGroupStart + (2U * kShuffleByteCount),
        kSecondShuffleGroupStart + (3U * kShuffleByteCount),
        1U);

    TwistShuffle::ShuffleList256(
        pIndexList256D,
        pEntropyLaneD,
        kSecondShuffleGroupStart + (3U * kShuffleByteCount),
        kSecondShuffleGroupStart + (4U * kShuffleByteCount),
        1U);

    // Shuffles 9-12
    TwistShuffle::ShuffleList256(
        pIndexList256A,
        pEntropyLaneA,
        kThirdShuffleGroupStart + (0U * kShuffleByteCount),
        kThirdShuffleGroupStart + (1U * kShuffleByteCount),
        1U);

    TwistShuffle::ShuffleList256(
        pIndexList256B,
        pEntropyLaneB,
        kThirdShuffleGroupStart + (1U * kShuffleByteCount),
        kThirdShuffleGroupStart + (2U * kShuffleByteCount),
        1U);

    TwistShuffle::ShuffleList256(
        pIndexList256C,
        pEntropyLaneC,
        kThirdShuffleGroupStart + (2U * kShuffleByteCount),
        kThirdShuffleGroupStart + (3U * kShuffleByteCount),
        1U);

    TwistShuffle::ShuffleList256(
        pIndexList256D,
        pEntropyLaneD,
        kThirdShuffleGroupStart + (3U * kShuffleByteCount),
        kThirdShuffleGroupStart + (4U * kShuffleByteCount),
        1U);

    // Shuffles 13-16
    TwistShuffle::ShuffleList256(
        pIndexList256A,
        pEntropyLaneA,
        kFourthShuffleGroupStart + (0U * kShuffleByteCount),
        kFourthShuffleGroupStart + (1U * kShuffleByteCount),
        1U);

    TwistShuffle::ShuffleList256(
        pIndexList256B,
        pEntropyLaneB,
        kFourthShuffleGroupStart + (1U * kShuffleByteCount),
        kFourthShuffleGroupStart + (2U * kShuffleByteCount),
        1U);

    TwistShuffle::ShuffleList256(
        pIndexList256C,
        pEntropyLaneC,
        kFourthShuffleGroupStart + (2U * kShuffleByteCount),
        kFourthShuffleGroupStart + (3U * kShuffleByteCount),
        1U);

    TwistShuffle::ShuffleList256(
        pIndexList256D,
        pEntropyLaneD,
        kFourthShuffleGroupStart + (3U * kShuffleByteCount),
        kFourthShuffleGroupStart + (4U * kShuffleByteCount),
        1U);

    auto DiffuseDestination = [&](std::uint8_t *pOutput,
                                  std::uint8_t *pEntropy,
                                  std::size_t pIndexStart,
                                  std::size_t pInputSide,
                                  std::uint64_t pMatrixSelect,
                                  std::uint8_t pMatrixUnroll) {

        DiffuseLaneQuartetsWithDomainWords(
            pInputLaneA,
            pInputLaneB,
            pInputLaneC,
            pInputLaneD,
            pOutput,
            pEntropy,
            pIndexList256A,
            pIndexList256B,
            pIndexList256C,
            pIndexList256D,
            pMatrix,
            kOperationSetAStart,
            kOperationSetBStart,
            pIndexStart,
            kHalfDispatchCount,
            pInputSide,
            pMatrixSelect,
            pMatrixUnroll,
            pMatrixArgA,
            pMatrixArgB,
            pMatrixArgC,
            pMatrixArgD);
    };

    // First half of each index list, block N * 2.
    DiffuseDestination(pOutputLaneA,
                       pEntropyLaneA,
                       0U,
                       0U,
                       pMatrixSelectA,
                       pMatrixUnrollA);

    // Second half of each index list, block N * 2.
    DiffuseDestination(pOutputLaneB,
                       pEntropyLaneB,
                       kHalfDispatchCount,
                       0U,
                       pMatrixSelectB,
                       pMatrixUnrollB);

    // First half of each index list, block N * 2 + 1.
    DiffuseDestination(pOutputLaneC,
                       pEntropyLaneC,
                       0U,
                       1U,
                       pMatrixSelectA,
                       pMatrixUnrollA);

    // Second half of each index list, block N * 2 + 1.
    DiffuseDestination(pOutputLaneD,
                       pEntropyLaneD,
                       kHalfDispatchCount,
                       1U,
                       pMatrixSelectB,
                       pMatrixUnrollB);
}

void TwistDiffuse::KeyDiffuseWithDomainWords(
    std::uint8_t *pEntropyLaneA,
    std::uint8_t *pEntropyLaneB,
    std::uint8_t *pEntropyLaneC,
    std::uint8_t *pEntropyLaneD,
    std::uint8_t *pInputLaneA,
    std::uint8_t *pInputLaneB,
    std::uint8_t *pInputLaneC,
    std::uint8_t *pInputLaneD,
    std::uint8_t *pOutputLaneA,
    std::uint8_t *pOutputLaneB,
    std::uint8_t *pOutputLaneC,
    std::uint8_t *pOutputLaneD,
    std::size_t *pIndexList16A,
    std::size_t *pIndexList16B,
    std::size_t *pIndexList16C,
    std::size_t *pIndexList16D,
    M88 *pMatrix,
    std::uint64_t pMatrixSelectA,
    std::uint64_t pMatrixSelectB,
    std::uint8_t pMatrixUnrollA,
    std::uint8_t pMatrixUnrollB,
    std::uint8_t pMatrixArgA,
    std::uint8_t pMatrixArgB,
    std::uint8_t pMatrixArgC,
    std::uint8_t pMatrixArgD) {

    for (std::size_t aIndex = 0U;
         aIndex < kKeyDispatchCount;
         aIndex++) {

        pIndexList16A[aIndex] = aIndex;
        pIndexList16B[aIndex] = aIndex;
        pIndexList16C[aIndex] = aIndex;
        pIndexList16D[aIndex] = aIndex;
    }

    TwistShuffle::ShuffleList16(pIndexList16A,
                                pEntropyLaneA,
                                0U,
                                kKeyShuffleByteCount,
                                3U);

    TwistShuffle::ShuffleList16(pIndexList16B,
                                pEntropyLaneB,
                                0U,
                                kKeyShuffleByteCount,
                                3U);

    TwistShuffle::ShuffleList16(pIndexList16C,
                                pEntropyLaneC,
                                0U,
                                kKeyShuffleByteCount,
                                3U);

    TwistShuffle::ShuffleList16(pIndexList16D,
                                pEntropyLaneD,
                                0U,
                                kKeyShuffleByteCount,
                                3U);

    TwistShuffle::ShuffleList16(pIndexList16A,
                                pEntropyLaneA,
                                kKeyFinalShuffleStart,
                                kKeyByteCount,
                                3U);

    TwistShuffle::ShuffleList16(pIndexList16B,
                                pEntropyLaneB,
                                kKeyFinalShuffleStart,
                                kKeyByteCount,
                                3U);

    TwistShuffle::ShuffleList16(pIndexList16C,
                                pEntropyLaneC,
                                kKeyFinalShuffleStart,
                                kKeyByteCount,
                                3U);

    TwistShuffle::ShuffleList16(pIndexList16D,
                                pEntropyLaneD,
                                kKeyFinalShuffleStart,
                                kKeyByteCount,
                                3U);

    auto DiffuseDestination = [&](std::uint8_t *pOutput,
                                  std::uint8_t *pEntropy,
                                  std::size_t pIndexStart,
                                  std::size_t pInputSide,
                                  std::uint64_t pMatrixSelect,
                                  std::uint8_t pMatrixUnroll) {

        DiffuseLaneQuartetsWithDomainWords(
            pInputLaneA,
            pInputLaneB,
            pInputLaneC,
            pInputLaneD,
            pOutput,
            pEntropy,
            pIndexList16A,
            pIndexList16B,
            pIndexList16C,
            pIndexList16D,
            pMatrix,
            kKeyOperationSetAStart,
            kKeyOperationSetBStart,
            pIndexStart,
            kKeyHalfDispatchCount,
            pInputSide,
            pMatrixSelect,
            pMatrixUnroll,
            pMatrixArgA,
            pMatrixArgB,
            pMatrixArgC,
            pMatrixArgD);
    };

    // First half of each index list, block N * 2.
    DiffuseDestination(pOutputLaneA,
                       pEntropyLaneA,
                       0U,
                       0U,
                       pMatrixSelectA,
                       pMatrixUnrollA);

    // Second half of each index list, block N * 2.
    DiffuseDestination(pOutputLaneB,
                       pEntropyLaneB,
                       kKeyHalfDispatchCount,
                       0U,
                       pMatrixSelectB,
                       pMatrixUnrollB);

    // First half of each index list, block N * 2 + 1.
    DiffuseDestination(pOutputLaneC,
                       pEntropyLaneC,
                       0U,
                       1U,
                       pMatrixSelectA,
                       pMatrixUnrollA);

    // Second half of each index list, block N * 2 + 1.
    DiffuseDestination(pOutputLaneD,
                       pEntropyLaneD,
                       kKeyHalfDispatchCount,
                       1U,
                       pMatrixSelectB,
                       pMatrixUnrollB);
}
