#ifndef SOCCER_ROTATION_PACK_HPP_
#define SOCCER_ROTATION_PACK_HPP_

#include <cstddef>
#include <cstdint>
#include <cstring>
#include "TwistShuffle.hpp"

// One full-size layer: four FlameToads (four windows each), plus two masked
// byte rotations. Each pack owns its permutation and a wrapping read cursor.
// No allocation, span, vector, or dependency on Soccer's global buffers.
struct RotationPack {
    static constexpr std::size_t kWindowCount = 16384U;
    static constexpr std::size_t kWindowBytes = 64U;
    static constexpr std::size_t kBlockBytes = kWindowCount * kWindowBytes;
    static constexpr std::size_t kFrogCount = 4U;
    static constexpr std::size_t kFrogRotationCount = 4U;
    static constexpr std::size_t kFreeRotationCount = 2U;

    std::uint16_t mRotationWindowBase[kWindowCount] = {};
    std::uint16_t mRotationWindow[kFrogCount][kFrogRotationCount] = {};
    std::int32_t mRotationsFree[kFreeRotationCount] = {};
    std::size_t mCursor = 0U;
    std::size_t mReadCount = 0U;
    std::size_t mShuffleBytesRead = 0U;
    std::size_t mEntropyBytesRead = 0U;
    bool mShuffled = false;
    bool mReady = false;

    void Zero() { *this = {}; }

    bool Shuffle(const std::uint8_t *pEntropy, std::size_t pLength) {
        Zero();
        for (std::size_t aIndex = 0U; aIndex < kWindowCount; ++aIndex)
            mRotationWindowBase[aIndex] = static_cast<std::uint16_t>(aIndex);
        mShuffled = TwistShuffle::ShuffleList16384(mRotationWindowBase, pEntropy, pLength, mShuffleBytesRead);
        mEntropyBytesRead = mShuffleBytesRead;
        return mShuffled;
    }

    bool IsPermutation() const {
        bool aSeen[kWindowCount] = {};
        for (const auto aWindow : mRotationWindowBase) {
            if (aWindow >= kWindowCount || aSeen[aWindow]) return false;
            aSeen[aWindow] = true;
        }
        return true;
    }

    // pBlocked is shared by all eight packs. Only selected values and their
    // inverses are committed globally. Local subset sums are never committed.
    // Failure leaves pBlocked unchanged and marks this pack unusable.
    bool Farm(bool *pBlocked, const std::uint8_t *pEntropy, std::size_t pLength) {
        mReady = false;
        std::memset(mRotationWindow, 0, sizeof(mRotationWindow));
        std::memset(mRotationsFree, 0, sizeof(mRotationsFree));
        if (!pBlocked || !pEntropy || !mShuffled || mCursor >= kWindowCount ||
            mEntropyBytesRead > pLength || !IsPermutation()) return false;
        bool aBlocked[kWindowCount];
        std::memcpy(aBlocked, pBlocked, sizeof(aBlocked));
        aBlocked[0U] = true;
        aBlocked[kWindowCount / 2U] = true; // Self-inverse half turn.

        std::uint32_t aWindowSums[64] = {};
        std::uint32_t aByteSums[64] = {};
        std::size_t aSumCount = 1U; // Include the empty subset, sum zero.
        for (std::size_t aIndex = 0U; aIndex < kFreeRotationCount; ++aIndex) {
            std::uint16_t aOffset;
            // At least one masked rotation must be odd. Each accepted choice
            // is drawn by rejection from 1..63 (or the odd subset thereof).
            const bool aRequireOdd = aIndex == 1U && (mRotationsFree[0U] & 1U) == 0U;
            do {
                if (pLength - mEntropyBytesRead < 2U) return false;
                aOffset = static_cast<std::uint16_t>((pEntropy[mEntropyBytesRead] |
                          (std::uint16_t{pEntropy[mEntropyBytesRead + 1U]} << 8U)) & 63U);
                mEntropyBytesRead += 2U;
            } while (aOffset == 0U || (aRequireOdd && (aOffset & 1U) == 0U));
            std::uint16_t aWindow;
            if (!SelectWindow(aBlocked, aOffset, aWindowSums, aByteSums, aSumCount, aWindow)) return false;
            mRotationsFree[aIndex] = static_cast<std::int32_t>(kWindowBytes * aWindow + aOffset);
        }

        for (std::size_t aFrog = 0U; aFrog < kFrogCount; ++aFrog) {
            // Start each group with only the two shared masked rotations.
            // SelectWindow appends sums; the first four entries stay intact.
            aSumCount = 4U;
            for (std::size_t aSample = 0U; aSample < kFrogRotationCount; ++aSample)
                if (!SelectWindow(aBlocked, 0U, aWindowSums, aByteSums, aSumCount,
                                  mRotationWindow[aFrog][aSample])) return false;
        }
        std::memcpy(pBlocked, aBlocked, sizeof(aBlocked));
        mReady = true;
        return true;
    }

private:
    // Return the first valid candidate, wrapping the cursor and stopping
    // after one full traversal. Even an exhausted/hostile bag cannot hang.
    bool SelectWindow(bool *pBlocked, std::uint16_t pOffset,
                      std::uint32_t *pWindowSums, std::uint32_t *pByteSums,
                      std::size_t &pSumCount, std::uint16_t &pResult) {
        for (std::size_t aAttempt = 0U; aAttempt < kWindowCount; ++aAttempt) {
            const auto aWindow = mRotationWindowBase[mCursor];
            mCursor = (mCursor + 1U) & (kWindowCount - 1U);
            ++mReadCount;
            if (pBlocked[aWindow]) continue;
            const auto aByte = static_cast<std::uint32_t>(kWindowBytes * aWindow + pOffset);
            bool aCollision = false;
            for (std::size_t aIndex = 0U; aIndex < pSumCount && !aCollision; ++aIndex) {
                const auto aWindowSum = (pWindowSums[aIndex] + aWindow) & (kWindowCount - 1U);
                const auto aByteSum = (pByteSums[aIndex] + aByte) & (kBlockBytes - 1U);
                for (std::size_t aPrevious = 0U; aPrevious < pSumCount; ++aPrevious)
                    if (aWindowSum == pWindowSums[aPrevious] || aByteSum == pByteSums[aPrevious]) {
                        aCollision = true;
                        break;
                    }
            }
            if (aCollision) continue;
            for (std::size_t aIndex = 0U; aIndex < pSumCount; ++aIndex) {
                pWindowSums[pSumCount + aIndex] = (pWindowSums[aIndex] + aWindow) & (kWindowCount - 1U);
                pByteSums[pSumCount + aIndex] = (pByteSums[aIndex] + aByte) & (kBlockBytes - 1U);
            }
            pSumCount *= 2U;
            pBlocked[aWindow] = true;
            pBlocked[(0U - aWindow) & (kWindowCount - 1U)] = true;
            // Nonzero byte offsets borrow one window when reversed.
            pBlocked[((0U - aByte) & (kBlockBytes - 1U)) / kWindowBytes] = true;
            pResult = aWindow;
            return true;
        }
        return false;
    }
};

#endif // SOCCER_ROTATION_PACK_HPP_
