#ifndef SOCCER_FLAME_TOAD_CIPHER_HPP_
#define SOCCER_FLAME_TOAD_CIPHER_HPP_

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdint>
#include <span>
#include "Cipher.hpp"
#include "Jelly.hpp"
#if !IGNORE_SIMD && defined(__SSE2__)
#include <immintrin.h>
#endif

// Two protected rows, sampled from four independently offset 64-byte windows.
// Each source packs [A0 B0 A1 B1 A2 B2 A3 B3] into one byte (A0 is bit 0).
// Its sixteen packed bytes update destination positions 4*g + source-number.
// Thus neighboring destination bytes use different source windows.
//
// A packed byte has eight bits; the destination has six writable positions.
// Use the two packed bits in protected positions as an AND gate that toggles
// the lowest writable key bit, then clear the protected key positions. All
// eight sampled bits can influence the resulting key, including its low bit.
//
// Add/subtract modulo 2^6 in the six writable positions. Ones in protected
// holes propagate carries; zeros propagate borrows. Restore the original
// protected bits after arithmetic. Those rows remain unchanged globally, so
// decryption reads the same four windows and regenerates exactly the same key.
// An optional non-owning N/4-byte cache packs every source window once per
// call. The four offset reads then reuse those packed bytes. No allocation
// or new key material; both directions rebuild the cache from their input.
// An empty cache retains the direct packing path for standalone callers.
// Cache storage must outlive the cipher, must not overlap input/output, and
// must not be shared by concurrent calls. Contents are disposable each call.
// This is an experimental reversible mixer, not a security claim.
class FlameToadCipher final : public Cipher {
public:
    static constexpr std::size_t kWindowBytes = 64U;
    static constexpr std::size_t kRotationCount = 4U;

    FlameToadCipher(std::size_t pRowA, std::size_t pRowB,
                   std::size_t pBlockRotationA, std::size_t pBlockRotationB,
                   std::size_t pBlockRotationC, std::size_t pBlockRotationD,
                   std::span<std::uint8_t> pPackedRows = {})
        : Cipher(CipherType::kFlameToadCipher), mRowA(pRowA), mRowB(pRowB),
          mBlockRotations{pBlockRotationA, pBlockRotationB, pBlockRotationC, pBlockRotationD}, mPackedRows(pPackedRows) {}

    bool SealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                  std::uint8_t *pDestination, std::size_t pLength,
                  CipherErrorCode *pErrorCode) const override {
        (void)pWorker;
        return Apply<false>(pSource, pDestination, pLength, pErrorCode);
    }
    bool UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                    std::uint8_t *pDestination, std::size_t pLength,
                    CipherErrorCode *pErrorCode) const override {
        (void)pWorker;
        return Apply<true>(pSource, pDestination, pLength, pErrorCode);
    }
    void Zero() override {
        mRowA = 0U; mRowB = 1U; mBlockRotations.fill(0U); mPackedRows = {};
    }

private:
    template<bool Inverse>
    bool Apply(const std::uint8_t *pSource, std::uint8_t *pDestination,
               std::size_t pLength, CipherErrorCode *pErrorCode) const {
        if (pLength == 0U) { SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone); return true; }
        if (pLength % kWindowBytes != 0U) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength); return false;
        }
        if (mRowA >= 8U || mRowB >= 8U || mRowA == mRowB) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidParameter); return false;
        }
        if (pSource == nullptr || pDestination == nullptr) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer); return false;
        }
        const auto aSourceAddress = reinterpret_cast<std::uintptr_t>(pSource);
        const auto aDestinationAddress = reinterpret_cast<std::uintptr_t>(pDestination);
        const auto aDistance = aSourceAddress < aDestinationAddress ?
            aDestinationAddress - aSourceAddress : aSourceAddress - aDestinationAddress;
        if (aDistance < pLength) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer); return false;
        }
        std::uint8_t *aPackedRows = nullptr;
        if (!mPackedRows.empty()) {
            if (!mPackedRows.data() || mPackedRows.size() < pLength/4U) {
                SetCipherErrorCode(pErrorCode,CipherErrorCode::kInvalidParameter); return false;
            }
            const auto aPackedAddress = reinterpret_cast<std::uintptr_t>(mPackedRows.data());
            const auto aOverlaps = [&](std::uintptr_t pAddress) {
                return aPackedAddress <= pAddress ? pAddress-aPackedAddress < pLength/4U : aPackedAddress-pAddress < pLength;
            };
            if (aOverlaps(aSourceAddress) || aOverlaps(aDestinationAddress)) {
                SetCipherErrorCode(pErrorCode,CipherErrorCode::kAliasedBuffer); return false;
            }
            aPackedRows = mPackedRows.data();
        }
        const auto aProtected = static_cast<std::uint8_t>((1U << mRowA) | (1U << mRowB));
        const auto aWritable = static_cast<std::uint8_t>(~aProtected);
        const auto aLowest = static_cast<std::uint8_t>(aWritable & (0U - aWritable));
        const auto aWindowCount = pLength / kWindowBytes;
        std::array<std::size_t, kRotationCount> aSamples{};
        for (std::size_t i = 0U; i < aSamples.size(); ++i)
            aSamples[i] = (mBlockRotations[i] % aWindowCount) * kWindowBytes;
#if JELLY_USE_NEON
        const int8x16_t aPositions = {0,2,4,6,0,2,4,6,0,2,4,6,0,2,4,6};
        const auto aShiftA = vsubq_s8(aPositions, vdupq_n_s8(static_cast<std::int8_t>(mRowA)));
        const auto aShiftB = vsubq_s8(vaddq_s8(aPositions, vdupq_n_s8(1)),
                                    vdupq_n_s8(static_cast<std::int8_t>(mRowB)));
        const auto aProtectedVector = vdupq_n_u8(aProtected);
        const auto aLowestVector = vdupq_n_u8(aLowest);
#elif !IGNORE_SIMD && defined(__SSE2__)
        const auto aShiftA = _mm_cvtsi32_si128(static_cast<int>(mRowA));
        const auto aShiftB = _mm_cvtsi32_si128(static_cast<int>(mRowB));
        const auto aProtectedVector = _mm_set1_epi8(static_cast<char>(aProtected));
        const auto aLowestVector = _mm_set1_epi8(static_cast<char>(aLowest));
#endif
        if (aPackedRows != nullptr) {
            for (std::size_t aWindow = 0U; aWindow < aWindowCount; ++aWindow) {
#if JELLY_USE_NEON
                vst1q_u8(aPackedRows+16U*aWindow,PackNEON(pSource+64U*aWindow,aShiftA,aShiftB));
#elif !IGNORE_SIMD && defined(__SSE2__)
                _mm_storeu_si128(reinterpret_cast<__m128i *>(aPackedRows+16U*aWindow),
                    PackSIMD(pSource+64U*aWindow,aShiftA,aShiftB));
#else
                for (std::size_t aGroup = 0U; aGroup < 16U; ++aGroup) {
                    unsigned aPacked = 0U;
                    for (unsigned aByte = 0U; aByte < 4U; ++aByte) {
                        const auto aValue = pSource[64U*aWindow+4U*aGroup+aByte];
                        aPacked |= ((aValue >> mRowA)&1U) << (2U*aByte);
                        aPacked |= ((aValue >> mRowB)&1U) << (2U*aByte+1U);
                    }
                    aPackedRows[16U*aWindow+aGroup] = static_cast<std::uint8_t>(aPacked);
                }
#endif
            }
        }
        std::size_t aPosition = 0U;
        while (aPosition < pLength) {
            auto aSpan = pLength - aPosition;
            for (auto aSample : aSamples) aSpan = std::min(aSpan, pLength - aSample);
            for (std::size_t aOffset = 0U; aOffset < aSpan; aOffset += kWindowBytes) {
                const auto *aInput = pSource + aPosition + aOffset;
                auto *aOutput = pDestination + aPosition + aOffset;
#if JELLY_USE_NEON
                auto aValues = vld4q_u8(aInput);
                for (std::size_t aWindow = 0U; aWindow < kRotationCount; ++aWindow) {
                    const auto aPacked = aPackedRows != nullptr ? vld1q_u8(aPackedRows+(aSamples[aWindow]+aOffset)/4U) :
                        PackNEON(pSource + aSamples[aWindow] + aOffset, aShiftA, aShiftB);
                    const auto aGate = vceqq_u8(vandq_u8(aPacked, aProtectedVector), aProtectedVector);
                    const auto aKey = vbicq_u8(veorq_u8(aPacked, vandq_u8(aGate, aLowestVector)), aProtectedVector);
                    auto &aValue = aValues.val[aWindow];
                    uint8x16_t aChanged;
                    if constexpr (Inverse) aChanged = vsubq_u8(vbicq_u8(aValue, aProtectedVector), aKey);
                    else aChanged = vaddq_u8(vorrq_u8(aValue, aProtectedVector), aKey);
                    aValue = veorq_u8(aValue, vbicq_u8(veorq_u8(aValue, aChanged), aProtectedVector));
                }
                vst4q_u8(aOutput, aValues);
#elif !IGNORE_SIMD && defined(__SSE2__)
                __m128i aKeys[4];
                for (std::size_t aWindow = 0U; aWindow < kRotationCount; ++aWindow) {
                    const auto aPacked = aPackedRows != nullptr ?
                        _mm_loadu_si128(reinterpret_cast<const __m128i *>(aPackedRows+(aSamples[aWindow]+aOffset)/4U)) :
                        PackSIMD(pSource + aSamples[aWindow] + aOffset, aShiftA, aShiftB);
                    const auto aGate = _mm_cmpeq_epi8(_mm_and_si128(aPacked, aProtectedVector), aProtectedVector);
                    aKeys[aWindow] = _mm_andnot_si128(aProtectedVector,
                        _mm_xor_si128(aPacked, _mm_and_si128(aGate, aLowestVector)));
                }
                const auto aLowAB = _mm_unpacklo_epi8(aKeys[0], aKeys[1]);
                const auto aHighAB = _mm_unpackhi_epi8(aKeys[0], aKeys[1]);
                const auto aLowCD = _mm_unpacklo_epi8(aKeys[2], aKeys[3]);
                const auto aHighCD = _mm_unpackhi_epi8(aKeys[2], aKeys[3]);
                const __m128i aInterleaved[] = {_mm_unpacklo_epi16(aLowAB, aLowCD),
                    _mm_unpackhi_epi16(aLowAB, aLowCD), _mm_unpacklo_epi16(aHighAB, aHighCD),
                    _mm_unpackhi_epi16(aHighAB, aHighCD)};
                for (std::size_t i = 0U; i < 4U; ++i) {
                    const auto aValue = _mm_loadu_si128(reinterpret_cast<const __m128i *>(aInput + 16U*i));
                    __m128i aChanged;
                    if constexpr (Inverse) aChanged = _mm_sub_epi8(_mm_andnot_si128(aProtectedVector, aValue), aInterleaved[i]);
                    else aChanged = _mm_add_epi8(_mm_or_si128(aValue, aProtectedVector), aInterleaved[i]);
                    _mm_storeu_si128(reinterpret_cast<__m128i *>(aOutput + 16U*i),
                        _mm_or_si128(_mm_andnot_si128(aProtectedVector, aChanged), _mm_and_si128(aValue, aProtectedVector)));
                }
#else
                for (std::size_t aWindow = 0U; aWindow < kRotationCount; ++aWindow) {
                    const auto *aSample = pSource + aSamples[aWindow] + aOffset;
                    for (std::size_t aGroup = 0U; aGroup < 16U; ++aGroup) {
                        std::uint8_t aPacked = aPackedRows != nullptr ? aPackedRows[(aSamples[aWindow]+aOffset)/4U+aGroup] : 0U;
                        if (aPackedRows == nullptr) for (unsigned i = 0U; i < 4U; ++i) {
                            const auto aByte = aSample[4U*aGroup + i];
                            aPacked |= static_cast<std::uint8_t>(((aByte >> mRowA) & 1U) << (2U*i));
                            aPacked |= static_cast<std::uint8_t>(((aByte >> mRowB) & 1U) << (2U*i + 1U));
                        }
                        const auto aKey = static_cast<std::uint8_t>((aPacked ^
                            (((aPacked & aProtected) == aProtected) ? aLowest : 0U)) & aWritable);
                        const auto aIndex = 4U*aGroup + aWindow;
                        const auto aValue = aInput[aIndex];
                        std::uint8_t aChanged;
                        if constexpr (Inverse) aChanged = static_cast<std::uint8_t>((aValue & aWritable) - aKey);
                        else aChanged = static_cast<std::uint8_t>((aValue | aProtected) + aKey);
                        aOutput[aIndex] = (aChanged & aWritable) | (aValue & aProtected);
                    }
                }
#endif
            }
            aPosition += aSpan;
            for (auto &aSample : aSamples) { aSample += aSpan; if (aSample == pLength) aSample = 0U; }
        }
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
    }

#if JELLY_USE_NEON
    static uint8x16_t PackNEON(const std::uint8_t *pSource, int8x16_t pShiftA, int8x16_t pShiftB) {
        const uint8x16_t aWeightsA = {1,4,16,64,1,4,16,64,1,4,16,64,1,4,16,64};
        const auto aWeightsB = vshlq_n_u8(aWeightsA, 1);
        const auto aPackGroup = [&](std::size_t pOffset) {
            const auto aValue = vld1q_u8(pSource + pOffset);
            return vorrq_u8(vandq_u8(vshlq_u8(aValue, pShiftA), aWeightsA),
                            vandq_u8(vshlq_u8(aValue, pShiftB), aWeightsB));
        };
        return vpaddq_u8(vpaddq_u8(aPackGroup(0U), aPackGroup(16U)),
                         vpaddq_u8(aPackGroup(32U), aPackGroup(48U)));
    }
#elif !IGNORE_SIMD && defined(__SSE2__)
    static __m128i PackSIMD(const std::uint8_t *pSource, __m128i pShiftA, __m128i pShiftB) {
        const auto aOnes = _mm_set1_epi8(1);
        const auto aPackGroup = [&](std::size_t pOffset) {
            const auto aValue = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource + pOffset));
            auto aBits = _mm_or_si128(_mm_and_si128(_mm_srl_epi16(aValue, pShiftA), aOnes),
                _mm_slli_epi16(_mm_and_si128(_mm_srl_epi16(aValue, pShiftB), aOnes), 1));
            aBits = _mm_or_si128(aBits, _mm_srli_epi32(aBits, 6));
            aBits = _mm_or_si128(aBits, _mm_srli_epi32(aBits, 12));
            return _mm_and_si128(aBits, _mm_set1_epi32(255));
        };
        return _mm_packus_epi16(_mm_packs_epi32(aPackGroup(0U), aPackGroup(16U)),
                                _mm_packs_epi32(aPackGroup(32U), aPackGroup(48U)));
    }
#endif
    std::size_t mRowA;
    std::size_t mRowB;
    std::array<std::size_t, kRotationCount> mBlockRotations;
    std::span<std::uint8_t> mPackedRows;
};

#endif  // SOCCER_FLAME_TOAD_CIPHER_HPP_
