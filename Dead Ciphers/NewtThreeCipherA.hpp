#ifndef SOCCER_NEWT_THREE_CIPHER_A_HPP_
#define SOCCER_NEWT_THREE_CIPHER_A_HPP_

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include "Jelly.hpp"
#include "Cipher.hpp"
#if !IGNORE_SIMD && defined(__SSE2__)
#include <immintrin.h>
#endif

// 3 distinct protected bit rows and 3 rotations measured in 64-byte windows.
// SA packs only row A from window A; SB packs only row B from window B.
// SC packs only row C from window C.
// Pack source byte 8*g+b into bit b of sample byte g. XOR the eight-byte
// samples, then repeat that eight-byte key eight times across the destination.
// SIMD aligns each assigned row before XOR, allowing a single packing step.
//
// Each DESTINATION BYTE also supplies its 3 protected bits to an AND gate.
// When all are 1, complement the writable positions of that byte's key.
// The gate is local to each byte; it is not packed into the repeated message.
// Thus bytes sharing the distant message need not receive the same update.
//
// With P=protected positions, W=~P, x=input, s=shared packed message:
//   gate = ((x & P) == P)                 // AND of all selected local bits
//   k = (s ^ (gate ? W : 0)) & W
//   Seal:   (((x | P) + k) & W) | (x & P)
//   Unseal: (((x & W) - k) & W) | (x & P)
// Addition/subtraction is modulo 2^5 in the writable-bit field. Carries
// and borrows skip the protected positions. Those positions remain unchanged
// globally, so the inverse regenerates both the distant message and local gate.
// No additional protected bit, buffer pass, or key material is needed.
//
// Seal is generally not its own inverse; unseal a stack in reverse order.
// This construction is experimental; reversibility does not establish
// resistance to parity recovery or chosen-plaintext attacks.
//
// Length is zero or a multiple of 64. Nonempty buffers must not overlap;
// unaligned buffers are supported. Rows must be distinct and in [0,7].
// No allocation, worker use, or state across calls. Offsets wrap modulo N.
class NewtThreeCipherA final : public Cipher {
public:
    explicit NewtThreeCipherA(std::size_t pRowA, std::size_t pBlockRotationA,
                              std::size_t pRowB, std::size_t pBlockRotationB,
                              std::size_t pRowC, std::size_t pBlockRotationC)
        : Cipher(CipherType::kNewtThreeCipherA),
          mRowA(pRowA), mBlockRotationA(pBlockRotationA),
          mRowB(pRowB), mBlockRotationB(pBlockRotationB),
          mRowC(pRowC), mBlockRotationC(pBlockRotationC) {}

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
        mRowA = 0U; mBlockRotationA = 0U;
        mRowB = 1U; mBlockRotationB = 0U;
        mRowC = 2U; mBlockRotationC = 0U;
    }

private:
    template <bool Inverse>
    bool Apply(const std::uint8_t *pSource, std::uint8_t *pDestination,
               std::size_t pLength, CipherErrorCode *pErrorCode) const {
        if (pLength == 0U) { SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone); return true; }
        if (pLength % 64U != 0U) { SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength); return false; }
        if (mRowA >= 8U || mRowB >= 8U || mRowC >= 8U || mRowA == mRowB || mRowA == mRowC || mRowB == mRowC) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidParameter); return false;
        }
        if (pSource == nullptr || pDestination == nullptr) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer); return false;
        }
        const auto aSource = reinterpret_cast<std::uintptr_t>(pSource);
        const auto aDestination = reinterpret_cast<std::uintptr_t>(pDestination);
        const auto aDistance = aSource <= aDestination ? aDestination - aSource : aSource - aDestination;
        if (aDistance < pLength) { SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer); return false; }
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);

        const auto aProtected = static_cast<std::uint8_t>((1U << mRowA) | (1U << mRowB) | (1U << mRowC));
        const auto aWritable = static_cast<std::uint8_t>(~aProtected);
        const auto aWindows = pLength / 64U;
        std::size_t aSampleA = (mBlockRotationA % aWindows) * 64U;
        std::size_t aSampleB = (mBlockRotationB % aWindows) * 64U;
        std::size_t aSampleC = (mBlockRotationC % aWindows) * 64U;
        std::size_t aPosition = 0U;
#if JELLY_USE_NEON && defined(__aarch64__)
        const auto aRowMask = vdupq_n_u8(aProtected);
        const int8x16_t aShifts = {0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7};
        const auto aShiftA = vsubq_s8(aShifts, vdupq_n_s8(static_cast<std::int8_t>(mRowA)));
        const auto aShiftB = vsubq_s8(aShifts, vdupq_n_s8(static_cast<std::int8_t>(mRowB)));
        const auto aShiftC = vsubq_s8(aShifts, vdupq_n_s8(static_cast<std::int8_t>(mRowC)));
        const uint8x16_t aPackingBits = {1,2,4,8,16,32,64,128,1,2,4,8,16,32,64,128};
        const auto aPositions = vandq_u8(aPackingBits, vdupq_n_u8(aWritable));
#elif !IGNORE_SIMD && defined(__SSE2__)
        const auto aShiftA = _mm_cvtsi32_si128(static_cast<int>(7U - mRowA));
        const auto aShiftB = _mm_cvtsi32_si128(static_cast<int>(7U - mRowB));
        const auto aShiftC = _mm_cvtsi32_si128(static_cast<int>(7U - mRowC));
        const std::uint64_t aWritable64 = 0x0101010101010101ULL * aWritable;
#if defined(__AVX2__)
        const auto aProtectedSIMD = _mm256_set1_epi8(static_cast<char>(aProtected));
#else
        const auto aProtectedSIMD = _mm_set1_epi8(static_cast<char>(aProtected));
#endif
#endif
        // Each sample wraps once. Split spans outside the hot window loop.
        while (aPosition < pLength) {
            const auto aSpan = std::min({pLength - aPosition, pLength - aSampleA, pLength - aSampleB, pLength - aSampleC});
            for (std::size_t aOffset = 0U; aOffset < aSpan; aOffset += 64U) {
                const auto *aInput = pSource + aPosition + aOffset;
                auto *aOutput = pDestination + aPosition + aOffset;
                const auto *aA = pSource + aSampleA + aOffset;
                const auto *aB = pSource + aSampleB + aOffset;
                const auto *aC = pSource + aSampleC + aOffset;
#if JELLY_USE_NEON && defined(__aarch64__)
                const auto aBits0 = PackParityNEON<0U>(aA, aB, aC, aShiftA, aShiftB, aShiftC, aPositions);
                const auto aBits1 = PackParityNEON<16U>(aA, aB, aC, aShiftA, aShiftB, aShiftC, aPositions);
                const auto aBits2 = PackParityNEON<32U>(aA, aB, aC, aShiftA, aShiftB, aShiftC, aPositions);
                const auto aBits3 = PackParityNEON<48U>(aA, aB, aC, aShiftA, aShiftB, aShiftC, aPositions);
                // Selected bits occupy disjoint positions: these sums have no carries.
                const auto aPairs01 = vpaddq_u8(aBits0, aBits1);
                const auto aPairs23 = vpaddq_u8(aBits2, aBits3);
                const auto aQuads = vpaddq_u8(aPairs01, aPairs23);
                const auto aMask = vpaddq_u8(aQuads, aQuads); // Eight mask bytes, twice.
                // Build both key choices once; each byte selects with its local gate.
                const auto aFlippedMask = veorq_u8(aMask, vmvnq_u8(aRowMask));
                vst1q_u8(aOutput + 0U, ApplyMaskNEON<Inverse>(vld1q_u8(aInput + 0U), aMask, aFlippedMask, aRowMask));
                vst1q_u8(aOutput + 16U, ApplyMaskNEON<Inverse>(vld1q_u8(aInput + 16U), aMask, aFlippedMask, aRowMask));
                vst1q_u8(aOutput + 32U, ApplyMaskNEON<Inverse>(vld1q_u8(aInput + 32U), aMask, aFlippedMask, aRowMask));
                vst1q_u8(aOutput + 48U, ApplyMaskNEON<Inverse>(vld1q_u8(aInput + 48U), aMask, aFlippedMask, aRowMask));
#elif !IGNORE_SIMD && defined(__AVX2__)
                const std::uint64_t aLow = PackParityAVX2<0U>(aA, aB, aC, aShiftA, aShiftB, aShiftC);
                const std::uint64_t aHigh = PackParityAVX2<32U>(aA, aB, aC, aShiftA, aShiftB, aShiftC);
                const auto aPacked = (aLow | (aHigh << 32U)) & aWritable64;
                const auto aMask = _mm256_set1_epi64x(static_cast<long long>(aPacked));
                _mm256_storeu_si256(reinterpret_cast<__m256i *>(aOutput),
                    ApplyMaskAVX2<Inverse>(_mm256_loadu_si256(reinterpret_cast<const __m256i *>(aInput)), aMask, aProtectedSIMD));
                _mm256_storeu_si256(reinterpret_cast<__m256i *>(aOutput + 32U),
                    ApplyMaskAVX2<Inverse>(_mm256_loadu_si256(reinterpret_cast<const __m256i *>(aInput + 32U)), aMask, aProtectedSIMD));
#elif !IGNORE_SIMD && defined(__SSE2__)
                const std::uint64_t aBits0 = PackParitySSE2<0U>(aA, aB, aC, aShiftA, aShiftB, aShiftC);
                const std::uint64_t aBits1 = PackParitySSE2<16U>(aA, aB, aC, aShiftA, aShiftB, aShiftC);
                const std::uint64_t aBits2 = PackParitySSE2<32U>(aA, aB, aC, aShiftA, aShiftB, aShiftC);
                const std::uint64_t aBits3 = PackParitySSE2<48U>(aA, aB, aC, aShiftA, aShiftB, aShiftC);
                const auto aPacked = (aBits0 | (aBits1 << 16U) | (aBits2 << 32U) | (aBits3 << 48U)) & aWritable64;
                const auto aMask = _mm_set1_epi64x(static_cast<long long>(aPacked));
                _mm_storeu_si128(reinterpret_cast<__m128i *>(aOutput + 0U),
                    ApplyMaskSSE2<Inverse>(_mm_loadu_si128(reinterpret_cast<const __m128i *>(aInput + 0U)), aMask, aProtectedSIMD));
                _mm_storeu_si128(reinterpret_cast<__m128i *>(aOutput + 16U),
                    ApplyMaskSSE2<Inverse>(_mm_loadu_si128(reinterpret_cast<const __m128i *>(aInput + 16U)), aMask, aProtectedSIMD));
                _mm_storeu_si128(reinterpret_cast<__m128i *>(aOutput + 32U),
                    ApplyMaskSSE2<Inverse>(_mm_loadu_si128(reinterpret_cast<const __m128i *>(aInput + 32U)), aMask, aProtectedSIMD));
                _mm_storeu_si128(reinterpret_cast<__m128i *>(aOutput + 48U),
                    ApplyMaskSSE2<Inverse>(_mm_loadu_si128(reinterpret_cast<const __m128i *>(aInput + 48U)), aMask, aProtectedSIMD));
#else
                std::uint8_t aPacked[8] = {};
                for (unsigned g = 0U; g < 8U; ++g) {
                    for (unsigned b = 0U; b < 8U; ++b) {
                        const auto aParity = ((aA[8U*g+b] >> mRowA) ^ (aB[8U*g+b] >> mRowB) ^ (aC[8U*g+b] >> mRowC)) & 1U;
                        aPacked[g] |= static_cast<std::uint8_t>(aParity << b);
                    }
                    aPacked[g] &= aWritable;
                }
                for (unsigned i = 0U; i < 64U; ++i) {
                    const auto x = aInput[i];
                    const auto aGate = static_cast<std::uint8_t>(
                        0U - static_cast<unsigned>((x & aProtected) == aProtected));
                    const auto k = static_cast<std::uint8_t>(aPacked[i % 8U] ^ (aGate & aWritable));
                    std::uint8_t value;
                    if constexpr (Inverse) { value = static_cast<std::uint8_t>((x & aWritable) - k); }
                    else { value = static_cast<std::uint8_t>((x | aProtected) + k); }
                    aOutput[i] = (value & aWritable) | (x & aProtected);
                }
#endif
            }
            aPosition += aSpan;
            aSampleA += aSpan; if (aSampleA == pLength) { aSampleA = 0U; }
            aSampleB += aSpan; if (aSampleB == pLength) { aSampleB = 0U; }
            aSampleC += aSpan; if (aSampleC == pLength) { aSampleC = 0U; }
        }
        return true;
    }

#if JELLY_USE_NEON && defined(__aarch64__)
    template <bool Inverse>
    static uint8x16_t ApplyMaskNEON(uint8x16_t pInput, uint8x16_t pKey, uint8x16_t pFlippedKey, uint8x16_t pProtected) {
        // A byte-wise equality implements the two/three-input AND gate with
        // no per-row shifts: all protected positions must be set.
        const auto aGate = vceqq_u8(vandq_u8(pInput, pProtected), pProtected);
        const auto aKey = vbslq_u8(aGate, pFlippedKey, pKey);
        uint8x16_t aValue;
        if constexpr (Inverse) { aValue = vsubq_u8(vbicq_u8(pInput, pProtected), aKey); }
        else { aValue = vaddq_u8(vorrq_u8(pInput, pProtected), aKey); }
        // Replace only writable positions. This form lets Clang emit one
        // BIT/BIF instruction; vbsl can expand to AND/AND/OR in this loop.
        return veorq_u8(pInput, vbicq_u8(veorq_u8(pInput, aValue), pProtected));
    }

    template <unsigned Byte>
    static uint8x16_t PackParityNEON(const std::uint8_t *pA, const std::uint8_t *pB, const std::uint8_t *pC,
                                    int8x16_t pShiftA, int8x16_t pShiftB, int8x16_t pShiftC, uint8x16_t pPositions) {
        const auto aA = vshlq_u8(vld1q_u8(pA + Byte), pShiftA);
        const auto aB = vshlq_u8(vld1q_u8(pB + Byte), pShiftB);
        const auto aC = vshlq_u8(vld1q_u8(pC + Byte), pShiftC);
        // Only each window's assigned row reaches the selected packing bit.
        return vandq_u8(veorq_u8(veorq_u8(aA, aB), aC), pPositions);
    }
#endif
#if !IGNORE_SIMD && defined(__SSE2__)
    template <bool Inverse>
    static __m128i ApplyMaskSSE2(__m128i pInput, __m128i pKey, __m128i pProtected) {
        const auto aSaved = _mm_and_si128(pInput, pProtected);
        const auto aGate = _mm_cmpeq_epi8(aSaved, pProtected);
        const auto aKey = _mm_xor_si128(pKey, _mm_andnot_si128(pProtected, aGate));
        __m128i aValue;
        if constexpr (Inverse) { aValue = _mm_sub_epi8(_mm_andnot_si128(pProtected, pInput), aKey); }
        else { aValue = _mm_add_epi8(_mm_or_si128(pInput, pProtected), aKey); }
        return _mm_or_si128(_mm_andnot_si128(pProtected, aValue), aSaved);
    }

    template <unsigned Byte>
    static std::uint32_t PackParitySSE2(const std::uint8_t *pA, const std::uint8_t *pB, const std::uint8_t *pC,
                                        __m128i pShiftA, __m128i pShiftB, __m128i pShiftC) {
        const auto aA = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pA + Byte));
        const auto aB = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pB + Byte));
        const auto aC = _mm_loadu_si128(reinterpret_cast<const __m128i *>(pC + Byte));
        // Shifts are 0..7: cross-byte spill never reaches the sampled sign bit.
        const auto aSignsAB = _mm_xor_si128(
            _mm_sll_epi16(aA, pShiftA), _mm_sll_epi16(aB, pShiftB));
        const auto aSigns = _mm_xor_si128(aSignsAB, _mm_sll_epi16(aC, pShiftC));
        return static_cast<std::uint32_t>(_mm_movemask_epi8(aSigns));
    }
#endif
#if !IGNORE_SIMD && defined(__AVX2__)
    template <bool Inverse>
    static __m256i ApplyMaskAVX2(__m256i pInput, __m256i pKey, __m256i pProtected) {
        const auto aSaved = _mm256_and_si256(pInput, pProtected);
        const auto aGate = _mm256_cmpeq_epi8(aSaved, pProtected);
        const auto aKey = _mm256_xor_si256(pKey, _mm256_andnot_si256(pProtected, aGate));
        __m256i aValue;
        if constexpr (Inverse) { aValue = _mm256_sub_epi8(_mm256_andnot_si256(pProtected, pInput), aKey); }
        else { aValue = _mm256_add_epi8(_mm256_or_si256(pInput, pProtected), aKey); }
        return _mm256_or_si256(_mm256_andnot_si256(pProtected, aValue), aSaved);
    }

    template <unsigned Byte>
    static std::uint32_t PackParityAVX2(const std::uint8_t *pA, const std::uint8_t *pB, const std::uint8_t *pC,
                                        __m128i pShiftA, __m128i pShiftB, __m128i pShiftC) {
        const auto aA = _mm256_loadu_si256(reinterpret_cast<const __m256i *>(pA + Byte));
        const auto aB = _mm256_loadu_si256(reinterpret_cast<const __m256i *>(pB + Byte));
        const auto aC = _mm256_loadu_si256(reinterpret_cast<const __m256i *>(pC + Byte));
        // Shifts are 0..7: cross-byte spill never reaches the sampled sign bit.
        const auto aSignsAB = _mm256_xor_si256(
            _mm256_sll_epi16(aA, pShiftA), _mm256_sll_epi16(aB, pShiftB));
        const auto aSigns = _mm256_xor_si256(aSignsAB, _mm256_sll_epi16(aC, pShiftC));
        return static_cast<std::uint32_t>(_mm256_movemask_epi8(aSigns));
    }
#endif

    std::size_t mRowA;
    std::size_t mBlockRotationA;
    std::size_t mRowB;
    std::size_t mBlockRotationB;
    std::size_t mRowC;
    std::size_t mBlockRotationC;
};

#endif // SOCCER_NEWT_THREE_CIPHER_A_HPP_
