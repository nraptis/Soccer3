#ifndef SOCCER_TWO_STRIP_READ_CIPHER_HPP_
#define SOCCER_TWO_STRIP_READ_CIPHER_HPP_

#include "Cipher.hpp"
#include "Jelly.hpp"
#include "TwoStripBuffer.hpp"
#include <algorithm>
#include <array>
#include <cstring>
#if !IGNORE_SIMD && defined(__SSE2__)
#include <immintrin.h>
#endif

// Pack the current pair once, then gather four offset views into a full mask.
// Same byte layout as FlameToad: [A0 B0 A1 B1 A2 B2 A3 B3], low bit first;
// source window s supplies destination bytes 4*g+s. Offsets count 64-byte
// windows and wrap modulo the number of input windows.
//
// Retained split prototype; the active plan uses the combined FlameToad.
// Prepare writes only the external buffer. Standalone SealData/UnsealData
// also copy the unchanged input to their destination. A caller orchestrating
// this prototype must call Prepare before both the add and the subtract.
class TwoStripReadCipher final : public Cipher {
public:
    TwoStripReadCipher(std::size_t pBitPlaneA, std::size_t pBitPlaneB,
                       std::size_t pWindowOffsetA, std::size_t pWindowOffsetB,
                       std::size_t pWindowOffsetC, std::size_t pWindowOffsetD,
                       TwoStripBuffer *pBuffer)
        : Cipher(CipherType::kTwoStripReadCipher), mBitPlaneA(pBitPlaneA), mBitPlaneB(pBitPlaneB),
          mWindowOffsets{pWindowOffsetA,pWindowOffsetB,pWindowOffsetC,pWindowOffsetD}, mBuffer(pBuffer) {}

    std::size_t GetBitPlaneA() const { return mBitPlaneA; }
    std::size_t GetBitPlaneB() const { return mBitPlaneB; }
    TwoStripBuffer *GetBuffer() const { return mBuffer; }

    bool Prepare(const std::uint8_t *pSource, std::size_t pLength, CipherErrorCode *pErrorCode = nullptr) const {
        if (mBuffer) mBuffer->Invalidate();
        if (pLength == 0U) { SetCipherErrorCode(pErrorCode,CipherErrorCode::kNone); return true; }
        if (pLength % 64U != 0U) { SetCipherErrorCode(pErrorCode,CipherErrorCode::kInvalidLength); return false; }
        if (mBitPlaneA >= 8U || mBitPlaneB >= 8U || mBitPlaneA == mBitPlaneB) {
            SetCipherErrorCode(pErrorCode,CipherErrorCode::kInvalidParameter); return false;
        }
        if (!pSource || !mBuffer || !mBuffer->mMask.data() || !mBuffer->mPackedRows.data()) {
            SetCipherErrorCode(pErrorCode,CipherErrorCode::kNullBuffer); return false;
        }
        if (!mBuffer->HasCapacity(pLength)) { SetCipherErrorCode(pErrorCode,CipherErrorCode::kInvalidParameter); return false; }
        if (mBuffer->OverlapsData(pSource,pLength)) { SetCipherErrorCode(pErrorCode,CipherErrorCode::kAliasedBuffer); return false; }

        auto *aPackedRows = mBuffer->mPackedRows.data();
        const auto aWindowCount = pLength/64U;
#if JELLY_USE_NEON
        const int8x16_t aPositions = {0,2,4,6,0,2,4,6,0,2,4,6,0,2,4,6};
        const auto aShiftA = vsubq_s8(aPositions,vdupq_n_s8(static_cast<std::int8_t>(mBitPlaneA)));
        const auto aShiftB = vsubq_s8(vaddq_s8(aPositions,vdupq_n_s8(1)),vdupq_n_s8(static_cast<std::int8_t>(mBitPlaneB)));
        for (std::size_t aWindow = 0U; aWindow < aWindowCount; ++aWindow)
            vst1q_u8(aPackedRows+16U*aWindow,PackNEON(pSource+64U*aWindow,aShiftA,aShiftB));
#elif !IGNORE_SIMD && defined(__SSE2__)
        const auto aShiftA = _mm_cvtsi32_si128(static_cast<int>(mBitPlaneA));
        const auto aShiftB = _mm_cvtsi32_si128(static_cast<int>(mBitPlaneB));
        for (std::size_t aWindow = 0U; aWindow < aWindowCount; ++aWindow)
            _mm_storeu_si128(reinterpret_cast<__m128i *>(aPackedRows+16U*aWindow),PackSIMD(pSource+64U*aWindow,aShiftA,aShiftB));
#else
        for (std::size_t aGroup = 0U; aGroup < pLength/4U; ++aGroup) {
            unsigned aPacked = 0U;
            for (unsigned aByte = 0U; aByte < 4U; ++aByte) {
                const auto aValue = pSource[4U*aGroup+aByte];
                aPacked |= ((aValue >> mBitPlaneA)&1U) << (2U*aByte);
                aPacked |= ((aValue >> mBitPlaneB)&1U) << (2U*aByte+1U);
            }
            aPackedRows[aGroup] = static_cast<std::uint8_t>(aPacked);
        }
#endif
        std::array<std::size_t,4U> aSamples{};
        for (std::size_t aIndex = 0U; aIndex < 4U; ++aIndex) aSamples[aIndex] = mWindowOffsets[aIndex]%aWindowCount;
        std::size_t aPosition = 0U;
        while (aPosition < aWindowCount) {
            auto aSpan = aWindowCount-aPosition;
            for (auto aSample : aSamples) aSpan = std::min(aSpan,aWindowCount-aSample);
            for (std::size_t aOffset = 0U; aOffset < aSpan; ++aOffset) {
                auto *aOutput = mBuffer->mMask.data()+64U*(aPosition+aOffset);
#if JELLY_USE_NEON
                uint8x16x4_t aMask;
                for (std::size_t aIndex = 0U; aIndex < 4U; ++aIndex)
                    aMask.val[aIndex] = vld1q_u8(aPackedRows+16U*(aSamples[aIndex]+aOffset));
                vst4q_u8(aOutput,aMask);
#elif !IGNORE_SIMD && defined(__SSE2__)
                __m128i aMask[4];
                for (std::size_t aIndex = 0U; aIndex < 4U; ++aIndex)
                    aMask[aIndex] = _mm_loadu_si128(reinterpret_cast<const __m128i *>(aPackedRows+16U*(aSamples[aIndex]+aOffset)));
                const auto aLowAB = _mm_unpacklo_epi8(aMask[0],aMask[1]);
                const auto aHighAB = _mm_unpackhi_epi8(aMask[0],aMask[1]);
                const auto aLowCD = _mm_unpacklo_epi8(aMask[2],aMask[3]);
                const auto aHighCD = _mm_unpackhi_epi8(aMask[2],aMask[3]);
                _mm_storeu_si128(reinterpret_cast<__m128i *>(aOutput),_mm_unpacklo_epi16(aLowAB,aLowCD));
                _mm_storeu_si128(reinterpret_cast<__m128i *>(aOutput+16U),_mm_unpackhi_epi16(aLowAB,aLowCD));
                _mm_storeu_si128(reinterpret_cast<__m128i *>(aOutput+32U),_mm_unpacklo_epi16(aHighAB,aHighCD));
                _mm_storeu_si128(reinterpret_cast<__m128i *>(aOutput+48U),_mm_unpackhi_epi16(aHighAB,aHighCD));
#else
                for (std::size_t aGroup = 0U; aGroup < 16U; ++aGroup)
                    for (std::size_t aIndex = 0U; aIndex < 4U; ++aIndex)
                        aOutput[4U*aGroup+aIndex] = aPackedRows[16U*(aSamples[aIndex]+aOffset)+aGroup];
#endif
            }
            aPosition += aSpan;
            for (auto &aSample : aSamples) { aSample += aSpan; if (aSample == aWindowCount) aSample = 0U; }
        }
        mBuffer->mPreparedLength = pLength; mBuffer->mBitPlaneA = mBitPlaneA; mBuffer->mBitPlaneB = mBitPlaneB; mBuffer->mReady = true;
        SetCipherErrorCode(pErrorCode,CipherErrorCode::kNone); return true;
    }

    bool SealData(const std::uint8_t *pSource,std::uint8_t *,std::uint8_t *pDestination,
                  std::size_t pLength,CipherErrorCode *pErrorCode) const override {
        if (pLength == 0U) return Prepare(pSource,pLength,pErrorCode);
        if (!pSource || !pDestination) { if (mBuffer) mBuffer->Invalidate(); SetCipherErrorCode(pErrorCode,CipherErrorCode::kNullBuffer); return false; }
        if ((pSource != pDestination && TwoStripBuffer::Overlaps(pSource,pLength,pDestination,pLength)) ||
            (mBuffer && mBuffer->OverlapsData(pDestination,pLength))) {
            if (mBuffer) mBuffer->Invalidate(); SetCipherErrorCode(pErrorCode,CipherErrorCode::kAliasedBuffer); return false;
        }
        if (!Prepare(pSource,pLength,pErrorCode)) return false;
        if (pSource != pDestination) std::memcpy(pDestination,pSource,pLength);
        return true;
    }
    bool UnsealData(const std::uint8_t *pSource,std::uint8_t *pWorker,std::uint8_t *pDestination,
                    std::size_t pLength,CipherErrorCode *pErrorCode) const override {
        return SealData(pSource,pWorker,pDestination,pLength,pErrorCode);
    }
    void Zero() override { if (mBuffer) mBuffer->Invalidate(); mBuffer = nullptr; mBitPlaneA = 0U; mBitPlaneB = 1U; mWindowOffsets.fill(0U); }

private:
#if JELLY_USE_NEON
    static uint8x16_t PackNEON(const std::uint8_t *pSource,int8x16_t pShiftA,int8x16_t pShiftB) {
        const uint8x16_t aWeightsA = {1,4,16,64,1,4,16,64,1,4,16,64,1,4,16,64};
        const auto aWeightsB = vshlq_n_u8(aWeightsA,1);
        const auto aPackGroup = [&](std::size_t pOffset) {
            const auto aValue = vld1q_u8(pSource+pOffset);
            return vorrq_u8(vandq_u8(vshlq_u8(aValue,pShiftA),aWeightsA),vandq_u8(vshlq_u8(aValue,pShiftB),aWeightsB));
        };
        return vpaddq_u8(vpaddq_u8(aPackGroup(0U),aPackGroup(16U)),vpaddq_u8(aPackGroup(32U),aPackGroup(48U)));
    }
#elif !IGNORE_SIMD && defined(__SSE2__)
    static __m128i PackSIMD(const std::uint8_t *pSource,__m128i pShiftA,__m128i pShiftB) {
        const auto aOnes = _mm_set1_epi8(1);
        const auto aPackGroup = [&](std::size_t pOffset) {
            const auto aValue = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource+pOffset));
            auto aBits = _mm_or_si128(_mm_and_si128(_mm_srl_epi16(aValue,pShiftA),aOnes),
                _mm_slli_epi16(_mm_and_si128(_mm_srl_epi16(aValue,pShiftB),aOnes),1));
            aBits = _mm_or_si128(aBits,_mm_srli_epi32(aBits,6));
            aBits = _mm_or_si128(aBits,_mm_srli_epi32(aBits,12));
            return _mm_and_si128(aBits,_mm_set1_epi32(255));
        };
        return _mm_packus_epi16(_mm_packs_epi32(aPackGroup(0U),aPackGroup(16U)),_mm_packs_epi32(aPackGroup(32U),aPackGroup(48U)));
    }
#endif
    std::size_t mBitPlaneA;
    std::size_t mBitPlaneB;
    std::array<std::size_t,4U> mWindowOffsets;
    TwoStripBuffer *mBuffer;
};
#endif
