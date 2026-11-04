#include "WindowRotationFarm.hpp"
#include "TwistShuffle.hpp"
#include <algorithm>
#include <cassert>
#include <cstring>

namespace WindowRotationFarm {
namespace {
constexpr std::uint32_t kWindowMask = kWindowCount - 1U;
constexpr std::uint32_t kByteMask = kBlockBytes - 1U;
constexpr std::size_t kSubsetCount = 1U << kRotationsPerJob;

std::uint32_t ReadByteOffset(const Source &pSource, bool pRequireOdd,
                             std::size_t &pBytesRead) {
    while (pSource.mBytes != nullptr && pBytesRead <= pSource.mByteCount &&
           pSource.mByteCount - pBytesRead >= 2U) {
        const auto aOffset = (std::uint32_t{pSource.mBytes[pBytesRead]} |
                              (std::uint32_t{pSource.mBytes[pBytesRead + 1U]} << 8U)) & 63U;
        pBytesRead += 2U;
        if (aOffset != 0U && (!pRequireOdd || (aOffset & 1U) != 0U)) return aOffset;
    }
    // Deterministic, nonzero and odd when no usable offset word remains.
    return 1U;
}

bool ByteSumsCollide(const std::uint32_t *pSums, std::size_t pCount, std::uint32_t pValue) {
    for (std::size_t aNew = 0U; aNew < pCount; ++aNew) {
        const auto aSum = (pSums[aNew] + pValue) & kByteMask;
        for (std::size_t aOld = 0U; aOld < pCount; ++aOld)
            if (aSum == pSums[aOld]) return true;
    }
    return false;
}

void StoreWindows(WindowRotationPackChunk &pChunk, bool pSecondHalf,
                  const std::int32_t (&pValues)[kRotationsPerJob]) {
    // Named members are not an array: assign explicitly, without pointer
    // arithmetic across struct members or assumptions about their padding.
    if (!pSecondHalf) {
        pChunk.mWindowA = static_cast<std::uint16_t>(pValues[0U]);
        pChunk.mWindowB = static_cast<std::uint16_t>(pValues[1U]);
        pChunk.mWindowC = static_cast<std::uint16_t>(pValues[2U]);
        pChunk.mWindowD = static_cast<std::uint16_t>(pValues[3U]);
        pChunk.mWindowE = static_cast<std::uint16_t>(pValues[4U]);
        pChunk.mWindowF = static_cast<std::uint16_t>(pValues[5U]);
        pChunk.mWindowG = static_cast<std::uint16_t>(pValues[6U]);
        pChunk.mWindowH = static_cast<std::uint16_t>(pValues[7U]);
    } else {
        pChunk.mWindowI = static_cast<std::uint16_t>(pValues[0U]);
        pChunk.mWindowJ = static_cast<std::uint16_t>(pValues[1U]);
        pChunk.mWindowK = static_cast<std::uint16_t>(pValues[2U]);
        pChunk.mWindowL = static_cast<std::uint16_t>(pValues[3U]);
        pChunk.mWindowM = static_cast<std::uint16_t>(pValues[4U]);
        pChunk.mWindowN = static_cast<std::uint16_t>(pValues[5U]);
        pChunk.mWindowO = static_cast<std::uint16_t>(pValues[6U]);
        pChunk.mWindowP = static_cast<std::uint16_t>(pValues[7U]);
    }
}
} // namespace

namespace {
void SelectEight(const Source &pSource, bool pFreeRotations, Buffers &pBuffers,
                 std::int32_t (&pResult)[kRotationsPerJob], Statistics &pStatistics,
                 const std::uint16_t *pBase, std::size_t pAvailable, bool pBackwards,
                 const std::uint64_t *pOffsetWords = nullptr) {
    std::memset(pResult, 0, sizeof(pResult));
    std::memset(pBuffers.mWindowRotation, 0, sizeof(pBuffers.mWindowRotation));
    std::memset(pBuffers.mWindowRotationBlocked, 0, sizeof(pBuffers.mWindowRotationBlocked));
    const auto aAvailable = pBase == nullptr ? 0U : std::min(pAvailable, kWindowCount);
    std::size_t aBaseCursor = 0U;
    // Shared exclusions come from at most eighteen eight-value jobs.
    // Before the eighth choice, window/byte differences each ban at most
    // 3^7 = 2187 candidates. Even with all shared exclusions, choices remain.
    static_assert(kRotationsPerJob == 8U);
    static_assert(2U * 2187U + 3U * kRotationsPerJob * kJobCount + 2U < kWindowCount);
    bool aSingleBlocked[kWindowCount];
    std::memcpy(aSingleBlocked, pBuffers.mWindowRotationSingleBlocked, sizeof(aSingleBlocked));
    aSingleBlocked[0U] = true;
    aSingleBlocked[kWindowCount / 2U] = true;
    pBuffers.mWindowRotationBlocked[0U] = true;
    pBuffers.mWindowRotationBlocked[kWindowCount / 2U] = true;
    std::uint16_t aWindows[kRotationsPerJob] = {};
    std::int32_t aResult[kRotationsPerJob] = {};
    std::uint32_t aWindowSums[kSubsetCount] = {};
    std::uint32_t aByteSums[kSubsetCount] = {};
    std::size_t aSumCount = 1U;

    for (std::size_t aIndex = 0U; aIndex < kRotationsPerJob; ++aIndex) {
        std::uint32_t aOffset = 0U;
        if (pFreeRotations) {
            const bool aRequireOdd = (aIndex & 1U) != 0U && (aResult[aIndex - 1U] & 1) == 0;
            if (pOffsetWords != nullptr) {
                const auto aWord = pOffsetWords[aIndex];
                aOffset = FreeByteOffset(aWord, aRequireOdd);
                pStatistics.mEntropyBytesRead += sizeof(aWord);
            } else {
                aOffset = ReadByteOffset(pSource, aRequireOdd, pStatistics.mEntropyBytesRead);
            }
        }
        std::size_t aDefaultWindow = 1U;
        for (;;) {
            std::uint32_t aWindow;
            if (pBase != nullptr && aBaseCursor < kWindowCount) {
                const auto aPosition = aBaseCursor++;
                std::size_t aSourceIndex;
                if (aPosition < aAvailable) {
                    aSourceIndex = pBackwards ? kWindowCount - 1U - aPosition : aPosition;
                } else {
                    // Scan the remaining tail from the opposite end. Do not
                    // blindly accept its last eight values: checks still apply.
                    const auto aTailPosition = aPosition - aAvailable;
                    aSourceIndex = pBackwards ? aTailPosition : kWindowCount - 1U - aTailPosition;
                    ++pStatistics.mFallbackReadCount;
                }
                aWindow = pBase[aSourceIndex];
                ++pStatistics.mBaseReadCount;
                if (aWindow >= kWindowCount) continue;
            } else {
                // Missing/malformed lists still have a deterministic full-domain
                // fallback. The bound above guarantees a choice for a valid farm
                // session; an externally overfilled block map violates that contract.
                assert(aDefaultWindow < kWindowCount);
                aWindow = static_cast<std::uint32_t>(aDefaultWindow++);
                ++pStatistics.mFallbackReadCount;
            }
            if (aSingleBlocked[aWindow] || pBuffers.mWindowRotationBlocked[aWindow]) continue;
            const auto aByte = static_cast<std::uint32_t>(kWindowBytes * aWindow + aOffset);
            if (pFreeRotations && ByteSumsCollide(aByteSums, aSumCount, aByte)) continue;

            // A candidate is forbidden when it equals the DIFFERENCE of two
            // existing subset sums. Blocking both signs excludes duplicates,
            // complements, zero-sum subsets, AND equal nonzero subset sums.
            for (std::size_t aNew = 0U; aNew < aSumCount; ++aNew) {
                const auto aSum = (aWindowSums[aNew] + aWindow) & kWindowMask;
                aWindowSums[aSumCount + aNew] = aSum;
                aByteSums[aSumCount + aNew] = (aByteSums[aNew] + aByte) & kByteMask;
                for (std::size_t aOld = 0U; aOld < aSumCount; ++aOld) {
                    const auto aDifference = (aSum - aWindowSums[aOld]) & kWindowMask;
                    pBuffers.mWindowRotationBlocked[aDifference] = true;
                    pBuffers.mWindowRotationBlocked[(0U - aDifference) & kWindowMask] = true;
                }
            }
            aSumCount *= 2U;
            aSingleBlocked[aWindow] = true;
            aSingleBlocked[(0U - aWindow) & kWindowMask] = true;
            if (pFreeRotations) {
                // The actual inverse of 64*w+offset borrows one window.
                aSingleBlocked[((0U - aByte) & kByteMask) / kWindowBytes] = true;
            }
            aWindows[aIndex] = aWindow;
            aResult[aIndex] = static_cast<std::int32_t>(pFreeRotations ? aByte : aWindow);
            break;
        }
    }
    std::memcpy(pBuffers.mWindowRotationSingleBlocked, aSingleBlocked, sizeof(aSingleBlocked));
    std::memcpy(pBuffers.mWindowRotation, aWindows, sizeof(aWindows));
    std::memcpy(pResult, aResult, sizeof(aResult));
}

} // namespace

void FarmEight(const Source &pSource, bool pFreeRotations, Buffers &pBuffers,
               std::int32_t (&pResult)[kRotationsPerJob], Statistics &pStatistics) {
    std::memset(pResult, 0, sizeof(pResult));
    std::memset(pBuffers.mWindowRotation, 0, sizeof(pBuffers.mWindowRotation));
    std::memset(pBuffers.mWindowRotationBlocked, 0, sizeof(pBuffers.mWindowRotationBlocked));
    pStatistics = {};
    for (std::size_t aIndex = 0U; aIndex < kWindowCount; ++aIndex)
        pBuffers.mWindowRotationBase[aIndex] = static_cast<std::uint16_t>(aIndex);
    std::size_t aAvailable = 0U;
    TwistShuffle::ShuffleList16384(pBuffers.mWindowRotationBase, pSource.mBytes,
                                  pSource.mByteCount, pStatistics.mEntropyBytesRead,
                                  false, &aAvailable);
    pStatistics.mShuffleBytesRead = pStatistics.mEntropyBytesRead;
    SelectEight(pSource, pFreeRotations, pBuffers, pResult, pStatistics,
                pBuffers.mWindowRotationBase, aAvailable, false);
}

namespace {
template <typename FarmJob>
void AssemblePack(Buffers &pBuffers, WindowRotationPack &pResult,
                  Statistics (&pStatistics)[kJobCount], FarmJob pFarmJob) {
    pResult = {};
    std::memset(&pBuffers, 0, sizeof(pBuffers));
    std::memset(pStatistics, 0, sizeof(pStatistics));
    WindowRotationPack aResult{};
    WindowRotationPackPlane *aPlanes[] = {&aResult.mPlaneA, &aResult.mPlaneB};
    for (std::size_t aPlaneIndex = 0U; aPlaneIndex < 2U; ++aPlaneIndex) {
        auto &aPlane = *aPlanes[aPlaneIndex];
        WindowRotationPackChunk *aChunks[] = {&aPlane.mChunkA, &aPlane.mChunkB, &aPlane.mChunkC, &aPlane.mChunkD};
        const auto aFirstJob = aPlaneIndex * kJobsPerPlane;
        std::int32_t aValues[kRotationsPerJob];
        pFarmJob(aFirstJob, true, aValues);
        for (std::size_t aChunkIndex = 0U; aChunkIndex < 4U; ++aChunkIndex) {
            aChunks[aChunkIndex]->mWindowFreeA = static_cast<std::uint16_t>(aValues[2U * aChunkIndex] / kWindowBytes);
            aChunks[aChunkIndex]->mWindowFreeB = static_cast<std::uint16_t>(aValues[2U * aChunkIndex + 1U] / kWindowBytes);
        }
        for (std::size_t aChunkIndex = 0U; aChunkIndex < 4U; ++aChunkIndex) {
            pFarmJob(aFirstJob + 1U + 2U * aChunkIndex, false, aValues);
            StoreWindows(*aChunks[aChunkIndex], false, aValues);
            pFarmJob(aFirstJob + 2U + 2U * aChunkIndex, false, aValues);
            StoreWindows(*aChunks[aChunkIndex], true, aValues);
        }
    }
    pResult = aResult;
}

} // namespace

void FarmPack(const Source (&pSources)[kJobCount], Buffers &pBuffers,
              WindowRotationPack &pResult, Statistics (&pStatistics)[kJobCount]) {
    AssemblePack(pBuffers, pResult, pStatistics,
        [&](std::size_t pJob, bool pFree, std::int32_t (&pValues)[kRotationsPerJob]) {
            FarmEight(pSources[pJob], pFree, pBuffers, pValues, pStatistics[pJob]);
        });
}

void FarmPreparedPack(const PreparedSource (&pSources)[kJobCount], Buffers &pBuffers,
                      WindowRotationPack &pResult, Statistics (&pStatistics)[kJobCount]) {
    AssemblePack(pBuffers, pResult, pStatistics,
        [&](std::size_t pJob, bool pFree, std::int32_t (&pValues)[kRotationsPerJob]) {
            const auto &aSource = pSources[pJob];
            auto &aStatistics = pStatistics[pJob];
            aStatistics.mShuffleBytesRead = aSource.mShuffleBytesRead;
            SelectEight({nullptr, 0U}, pFree, pBuffers,
                pValues, aStatistics, aSource.mWindows, aSource.mAvailable, aSource.mBackwards,
                aSource.mOffsetWords);
            aStatistics.mEntropyBytesRead += aSource.mShuffleBytesRead;
        });
}

namespace {
bool Validate(const WindowRotationPack &pPack, const std::int32_t *pFreeRotations) {
    // Enumerate the exported fields directly. This does not consult or
    // reproduce the farmer's incremental subset-difference block map.
    bool aBlocked[kWindowCount] = {};
    aBlocked[0U] = true;
    aBlocked[kWindowCount / 2U] = true;
    const WindowRotationPackPlane *aPlanes[] = {&pPack.mPlaneA, &pPack.mPlaneB};
    for (std::size_t aPlaneIndex = 0U; aPlaneIndex < 2U; ++aPlaneIndex) {
        const auto *aPlane = aPlanes[aPlaneIndex];
        const WindowRotationPackChunk *aChunks[] = {
            &aPlane->mChunkA, &aPlane->mChunkB, &aPlane->mChunkC, &aPlane->mChunkD
        };
        std::int32_t aJobs[kJobsPerPlane][kRotationsPerJob] = {};
        for (std::size_t aChunkIndex = 0U; aChunkIndex < 4U; ++aChunkIndex) {
            const auto &aChunk = *aChunks[aChunkIndex];
            aJobs[0U][2U * aChunkIndex] = aChunk.mWindowFreeA;
            aJobs[0U][2U * aChunkIndex + 1U] = aChunk.mWindowFreeB;
            const std::uint16_t aWindows[] = {
                aChunk.mWindowA, aChunk.mWindowB, aChunk.mWindowC, aChunk.mWindowD,
                aChunk.mWindowE, aChunk.mWindowF, aChunk.mWindowG, aChunk.mWindowH,
                aChunk.mWindowI, aChunk.mWindowJ, aChunk.mWindowK, aChunk.mWindowL,
                aChunk.mWindowM, aChunk.mWindowN, aChunk.mWindowO, aChunk.mWindowP
            };
            for (std::size_t aIndex = 0U; aIndex < 16U; ++aIndex)
                aJobs[1U + 2U * aChunkIndex + aIndex / 8U][aIndex % 8U] = aWindows[aIndex];
        }
        for (std::size_t aJob = 0U; aJob < kJobsPerPlane; ++aJob) {
            const bool aFree = aJob == 0U;
            std::uint32_t aWindows[kRotationsPerJob], aBytes[kRotationsPerJob];
            for (std::size_t aIndex = 0U; aIndex < kRotationsPerJob; ++aIndex) {
                const auto aValue = aJobs[aJob][aIndex];
                if (aValue <= 0 || aValue >= static_cast<std::int32_t>(kWindowCount)) return false;
                const auto aWindow = static_cast<std::uint32_t>(aValue);
                std::uint32_t aByte = kWindowBytes * aWindow;
                if (aFree && pFreeRotations != nullptr) {
                    const auto aIndexInPack = aPlaneIndex * kRotationsPerJob + aIndex;
                    const auto aShift = pFreeRotations[aIndexInPack];
                    if (aShift <= 0 || aShift >= static_cast<std::int32_t>(kBlockBytes) ||
                        aShift % kWindowBytes == 0 || aShift / kWindowBytes != aWindow) return false;
                    if (aIndex % 2U == 1U && ((aShift | pFreeRotations[aIndexInPack - 1U]) & 1) == 0) return false;
                    aByte = static_cast<std::uint32_t>(aShift);
                }
                if (aBlocked[aWindow]) return false;
                aBlocked[aWindow] = true;
                aBlocked[(kWindowCount - aWindow) % kWindowCount] = true;
                // Any offset in 1..63 borrows one window in the inverse.
                if (aFree) aBlocked[kWindowCount - 1U - aWindow] = true;
                aWindows[aIndex] = aWindow;
                aBytes[aIndex] = aByte;
            }
            bool aSeenWindows[kWindowCount] = {};
            std::uint32_t aByteSums[kSubsetCount] = {};
            for (unsigned aSubset = 0U; aSubset < kSubsetCount; ++aSubset) {
                std::uint32_t aWindowSum = 0U, aByteSum = 0U;
                for (unsigned aIndex = 0U; aIndex < kRotationsPerJob; ++aIndex) {
                    if ((aSubset & (1U << aIndex)) == 0U) continue;
                    aWindowSum += aWindows[aIndex];
                    aByteSum += aBytes[aIndex];
                }
                aWindowSum %= kWindowCount;
                if (aSeenWindows[aWindowSum]) return false;
                aSeenWindows[aWindowSum] = true;
                // For whole-window jobs distinct window sums already imply
                // distinct byte sums. Free offsets can carry, so check both.
                if (aFree && pFreeRotations != nullptr) {
                    aByteSum %= kBlockBytes;
                    for (unsigned aPrevious = 0U; aPrevious < aSubset; ++aPrevious)
                        if (aByteSum == aByteSums[aPrevious]) return false;
                    aByteSums[aSubset] = aByteSum;
                }
            }
        }
    }
    return true;
}
} // namespace

bool IsValid(const WindowRotationPack &pPack) {
    return Validate(pPack, nullptr);
}

bool IsValid(const WindowRotationPack &pPack,
             const std::int32_t (&pFreeRotations)[kFreeRotationCount]) {
    return Validate(pPack, pFreeRotations);
}
} // namespace WindowRotationFarm
