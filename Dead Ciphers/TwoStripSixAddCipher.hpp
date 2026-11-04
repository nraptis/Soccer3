#ifndef SOCCER_TWO_STRIP_SIX_ADD_CIPHER_HPP_
#define SOCCER_TWO_STRIP_SIX_ADD_CIPHER_HPP_

#include "Cipher.hpp"
#include "Jelly.hpp"
#include "TwoStripBuffer.hpp"
#if !IGNORE_SIMD && defined(__SSE2__)
#include <immintrin.h>
#endif

// Consume the mask prepared by TwoStripReadCipher. Retain FlameToad's AND
// fold of the two otherwise discarded packed bits into the lowest writable
// key bit, then add modulo 64 through the six writable positions. Subtract
// to reverse. The two selected rows never change.
//
// A matching read MUST prepare the current block before either direction.
// This split prototype is not a valid ordinary reversed layer pair: the
// caller must explicitly prepare before subtracting. The active plan uses
// the combined FlameToad instead. This class never owns or frees pBuffer.
class TwoStripSixAddCipher final : public Cipher {
public:
    TwoStripSixAddCipher(std::size_t pBitPlaneA,std::size_t pBitPlaneB,TwoStripBuffer *pBuffer)
        : Cipher(CipherType::kTwoStripSixAddCipher),mBitPlaneA(pBitPlaneA),mBitPlaneB(pBitPlaneB),mBuffer(pBuffer) {}
    std::size_t GetBitPlaneA() const { return mBitPlaneA; }
    std::size_t GetBitPlaneB() const { return mBitPlaneB; }
    TwoStripBuffer *GetBuffer() const { return mBuffer; }
    bool SealData(const std::uint8_t *pSource,std::uint8_t *,std::uint8_t *pDestination,
                  std::size_t pLength,CipherErrorCode *pErrorCode) const override {
        return Apply<false>(pSource,pDestination,pLength,pErrorCode);
    }
    bool UnsealData(const std::uint8_t *pSource,std::uint8_t *,std::uint8_t *pDestination,
                    std::size_t pLength,CipherErrorCode *pErrorCode) const override {
        return Apply<true>(pSource,pDestination,pLength,pErrorCode);
    }
    void Zero() override { if (mBuffer) mBuffer->Invalidate(); mBuffer = nullptr; mBitPlaneA = 0U; mBitPlaneB = 1U; }
private:
    template<bool Inverse>
    bool Apply(const std::uint8_t *pSource,std::uint8_t *pDestination,std::size_t pLength,CipherErrorCode *pErrorCode) const {
        if (pLength == 0U) { SetCipherErrorCode(pErrorCode,CipherErrorCode::kNone); return true; }
        if (pLength % 64U != 0U) { SetCipherErrorCode(pErrorCode,CipherErrorCode::kInvalidLength); return false; }
        if (!pSource || !pDestination || !mBuffer) { SetCipherErrorCode(pErrorCode,CipherErrorCode::kNullBuffer); return false; }
        if (mBitPlaneA >= 8U || mBitPlaneB >= 8U || mBitPlaneA == mBitPlaneB || !mBuffer->HasCapacity(pLength) ||
            !mBuffer->mReady || mBuffer->mPreparedLength != pLength || mBuffer->mBitPlaneA != mBitPlaneA || mBuffer->mBitPlaneB != mBitPlaneB) {
            SetCipherErrorCode(pErrorCode,CipherErrorCode::kInvalidParameter); return false;
        }
        if (TwoStripBuffer::Overlaps(pSource,pLength,pDestination,pLength) ||
            mBuffer->OverlapsData(pSource,pLength) || mBuffer->OverlapsData(pDestination,pLength)) {
            SetCipherErrorCode(pErrorCode,CipherErrorCode::kAliasedBuffer); return false;
        }
        const auto aProtected = static_cast<std::uint8_t>((1U << mBitPlaneA)|(1U << mBitPlaneB));
        const auto aWritable = static_cast<std::uint8_t>(~aProtected);
        const auto aLowest = static_cast<std::uint8_t>(aWritable & (0U-aWritable));
        const auto *aMask = mBuffer->mMask.data();
#if JELLY_USE_NEON
        const auto aProtectedVector = vdupq_n_u8(aProtected);
        const auto aLowestVector = vdupq_n_u8(aLowest);
        for (std::size_t aIndex = 0U; aIndex < pLength; aIndex += 16U) {
            const auto aValue = vld1q_u8(pSource+aIndex);
            const auto aPacked = vld1q_u8(aMask+aIndex);
            const auto aGate = vceqq_u8(vandq_u8(aPacked,aProtectedVector),aProtectedVector);
            const auto aKey = vbicq_u8(veorq_u8(aPacked,vandq_u8(aGate,aLowestVector)),aProtectedVector);
            uint8x16_t aChanged;
            if constexpr (Inverse) aChanged = vsubq_u8(vbicq_u8(aValue,aProtectedVector),aKey);
            else aChanged = vaddq_u8(vorrq_u8(aValue,aProtectedVector),aKey);
            vst1q_u8(pDestination+aIndex,vbslq_u8(aProtectedVector,aValue,aChanged));
        }
#elif !IGNORE_SIMD && defined(__SSE2__)
        const auto aProtectedVector = _mm_set1_epi8(static_cast<char>(aProtected));
        const auto aLowestVector = _mm_set1_epi8(static_cast<char>(aLowest));
        for (std::size_t aIndex = 0U; aIndex < pLength; aIndex += 16U) {
            const auto aValue = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource+aIndex));
            const auto aPacked = _mm_loadu_si128(reinterpret_cast<const __m128i *>(aMask+aIndex));
            const auto aGate = _mm_cmpeq_epi8(_mm_and_si128(aPacked,aProtectedVector),aProtectedVector);
            const auto aKey = _mm_andnot_si128(aProtectedVector,_mm_xor_si128(aPacked,_mm_and_si128(aGate,aLowestVector)));
            __m128i aChanged;
            if constexpr (Inverse) aChanged = _mm_sub_epi8(_mm_andnot_si128(aProtectedVector,aValue),aKey);
            else aChanged = _mm_add_epi8(_mm_or_si128(aValue,aProtectedVector),aKey);
            _mm_storeu_si128(reinterpret_cast<__m128i *>(pDestination+aIndex),_mm_or_si128(
                _mm_and_si128(aValue,aProtectedVector),_mm_andnot_si128(aProtectedVector,aChanged)));
        }
#else
        for (std::size_t aIndex = 0U; aIndex < pLength; ++aIndex) {
            const auto aPacked = aMask[aIndex];
            const auto aKey = static_cast<std::uint8_t>((aPacked^(((aPacked&aProtected)==aProtected)?aLowest:0U))&aWritable);
            const auto aValue = pSource[aIndex];
            const auto aChanged = Inverse ? static_cast<std::uint8_t>((aValue&aWritable)-aKey) :
                                            static_cast<std::uint8_t>((aValue|aProtected)+aKey);
            pDestination[aIndex] = (aValue&aProtected)|(aChanged&aWritable);
        }
#endif
        SetCipherErrorCode(pErrorCode,CipherErrorCode::kNone); return true;
    }
    std::size_t mBitPlaneA;
    std::size_t mBitPlaneB;
    TwoStripBuffer *mBuffer;
};
#endif
