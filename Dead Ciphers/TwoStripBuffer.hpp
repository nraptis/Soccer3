#ifndef SOCCER_TWO_STRIP_BUFFER_HPP_
#define SOCCER_TWO_STRIP_BUFFER_HPP_

#include <cstddef>
#include <cstdint>
#include <span>

// Non-owning storage shared by a read/add pair. For N input bytes, the mask
// needs N bytes and the packed-row cache needs N/4 bytes. They may be slices
// of one allocation or two existing buffers. Neither cipher allocates memory.
// The view and its storage must outlive all ciphers referring to it.
struct TwoStripBuffer {
    TwoStripBuffer(std::span<std::uint8_t> pMask, std::span<std::uint8_t> pPackedRows)
        : mMask(pMask), mPackedRows(pPackedRows) {}

    static bool Overlaps(const void *pFirst, std::size_t pFirstLength,
                         const void *pSecond, std::size_t pSecondLength) {
        if (pFirstLength == 0U || pSecondLength == 0U) return false;
        const auto aFirst = reinterpret_cast<std::uintptr_t>(pFirst);
        const auto aSecond = reinterpret_cast<std::uintptr_t>(pSecond);
        return aFirst <= aSecond ? aSecond - aFirst < pFirstLength : aFirst - aSecond < pSecondLength;
    }
    bool HasCapacity(std::size_t pLength) const {
        return pLength % 64U == 0U && mMask.size() >= pLength && mPackedRows.size() >= pLength/4U &&
            (pLength == 0U || (mMask.data() && mPackedRows.data())) &&
            !Overlaps(mMask.data(),pLength,mPackedRows.data(),pLength/4U);
    }
    bool OverlapsData(const void *pData, std::size_t pLength) const {
        return Overlaps(mMask.data(),pLength,pData,pLength) ||
               Overlaps(mPackedRows.data(),pLength/4U,pData,pLength);
    }
    void Invalidate() { mReady = false; mPreparedLength = 0U; }

    std::span<std::uint8_t> mMask;
    std::span<std::uint8_t> mPackedRows;
    std::size_t mPreparedLength = 0U;
    std::size_t mBitPlaneA = 8U;
    std::size_t mBitPlaneB = 8U;
    bool mReady = false;
};

#endif
