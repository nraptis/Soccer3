#ifndef JELLY_PEPPER_NOISE_XOR_CIPHER_HPP_
#define JELLY_PEPPER_NOISE_XOR_CIPHER_HPP_

#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"

// [RELEASE] [419.8 us] [OK]

class PepperNoiseXORCipher final : public Cipher {
public:
    PepperNoiseXORCipher(const std::uint8_t *pMask,
                         const std::uint8_t *pNoise)
    : Cipher(CipherType::kPepperNoiseXORCipher),
    mMask(pMask),
    mNoise(pNoise) {}
    
    bool SealData(const std::uint8_t *pSource,
                  std::uint8_t *pWorker,
                  std::uint8_t *pDestination,
                  std::size_t pLength,
                  CipherErrorCode *pErrorCode) const override {
        (void)pWorker;
        return Apply(pSource, pDestination, pLength, pErrorCode);
    }
    
    bool UnsealData(const std::uint8_t *pSource,
                    std::uint8_t *pWorker,
                    std::uint8_t *pDestination,
                    std::size_t pLength,
                    CipherErrorCode *pErrorCode) const override {
        (void)pWorker;
        return Apply(pSource, pDestination, pLength, pErrorCode);
    }
    
private:
    static constexpr std::size_t kLengthMultiple = 16u;
    
    bool Apply(const std::uint8_t *pSource,
               std::uint8_t *pDestination,
               std::size_t pLength,
               CipherErrorCode *pErrorCode) const {
        if (pLength == 0u) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
            return true;
        }
        if ((pLength % kLengthMultiple) != 0u) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength);
            return false;
        }
        if (pSource == nullptr || pDestination == nullptr || mMask == nullptr ||
            mNoise == nullptr) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
            return false;
        }
        if (pSource == pDestination) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
            return false;
        }
        
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
#if JELLY_USE_NEON
        ApplyNeon(pSource, pDestination, pLength);
#elif JELLY_USE_SIMD
        ApplySimd(pSource, pDestination, pLength);
#else
        ApplyScalar(pSource, pDestination, pLength);
#endif
        return true;
    }
    
    void ApplyScalar(const std::uint8_t *pSource,
                     std::uint8_t *pDestination,
                     std::size_t pLength) const {
        for (std::size_t aIndex = 0u; aIndex < pLength; ++aIndex) {
            pDestination[aIndex] = static_cast<std::uint8_t>(
                                                             pSource[aIndex] ^ mMask[aIndex] ^ mNoise[aIndex]);
        }
    }
    
#if JELLY_USE_SIMD
    void ApplySimd(const std::uint8_t *pSource,
                   std::uint8_t *pDestination,
                   std::size_t pLength) const {
        std::size_t aOffset = 0u;
#if defined(__AVX2__)
        for (; aOffset + 32u <= pLength; aOffset += 32u) {
            const __m256i aSource = _mm256_loadu_si256(
                                                       reinterpret_cast<const __m256i *>(pSource + aOffset));
            const __m256i aMask = _mm256_loadu_si256(
                                                     reinterpret_cast<const __m256i *>(mMask + aOffset));
            const __m256i aNoise = _mm256_loadu_si256(
                                                      reinterpret_cast<const __m256i *>(mNoise + aOffset));
            const __m256i aResult =
            _mm256_xor_si256(_mm256_xor_si256(aSource, aMask), aNoise);
            _mm256_storeu_si256(reinterpret_cast<__m256i *>(pDestination + aOffset),
                                aResult);
        }
#endif
        for (; aOffset + 16u <= pLength; aOffset += 16u) {
            const __m128i aSource = _mm_loadu_si128(
                                                    reinterpret_cast<const __m128i *>(pSource + aOffset));
            const __m128i aMask = _mm_loadu_si128(
                                                  reinterpret_cast<const __m128i *>(mMask + aOffset));
            const __m128i aNoise = _mm_loadu_si128(
                                                   reinterpret_cast<const __m128i *>(mNoise + aOffset));
            const __m128i aResult =
            _mm_xor_si128(_mm_xor_si128(aSource, aMask), aNoise);
            _mm_storeu_si128(reinterpret_cast<__m128i *>(pDestination + aOffset),
                             aResult);
        }
    }
#endif
    
#if JELLY_USE_NEON
    void ApplyNeon(const std::uint8_t *pSource,
                   std::uint8_t *pDestination,
                   std::size_t pLength) const {
        for (std::size_t aOffset = 0u; aOffset < pLength; aOffset += 16u) {
            const uint8x16_t aSource = vld1q_u8(pSource + aOffset);
            const uint8x16_t aMask = vld1q_u8(mMask + aOffset);
            const uint8x16_t aNoise = vld1q_u8(mNoise + aOffset);
            vst1q_u8(pDestination + aOffset,
                     veorq_u8(veorq_u8(aSource, aMask), aNoise));
        }
    }
#endif
    
    const std::uint8_t *mMask = nullptr;
    const std::uint8_t *mNoise = nullptr;
};

#endif  // JELLY_PEPPER_NOISE_XOR_CIPHER_HPP_
