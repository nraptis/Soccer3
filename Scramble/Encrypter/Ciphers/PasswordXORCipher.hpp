#ifndef JELLY_PASSWORD_XOR_CIPHER_HPP_
#define JELLY_PASSWORD_XOR_CIPHER_HPP_

#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"

// [RELEASE] [44.7 us] [OK]

class PasswordXORCipher final : public Cipher {
public:
    explicit PasswordXORCipher(const std::uint8_t *pPassword)
    : Cipher(CipherType::kPasswordXORCipher),
    mPassword(pPassword) {}
    
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
    static constexpr std::size_t kLengthMultiple = 32u;
    
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
        if (pSource == nullptr || pDestination == nullptr ||
            mPassword == nullptr) {
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
        for (std::size_t aIndex = 0; aIndex < pLength; ++aIndex) {
            pDestination[aIndex] =
            static_cast<std::uint8_t>(pSource[aIndex] ^ mPassword[aIndex]);
        }
    }
    
#if JELLY_USE_SIMD
    void ApplySimd(const std::uint8_t *pSource,
                   std::uint8_t *pDestination,
                   std::size_t pLength) const {
        std::size_t aOffset = 0;
#if defined(__AVX2__)
        for (; aOffset + 32 <= pLength; aOffset += 32) {
            const __m256i aSource = _mm256_loadu_si256(
                                                       reinterpret_cast<const __m256i *>(pSource + aOffset));
            const __m256i aPassword = _mm256_loadu_si256(
                                                         reinterpret_cast<const __m256i *>(mPassword + aOffset));
            const __m256i aResult = _mm256_xor_si256(aSource, aPassword);
            _mm256_storeu_si256(reinterpret_cast<__m256i *>(pDestination + aOffset),
                                aResult);
        }
#endif
        
        for (; aOffset + 16 <= pLength; aOffset += 16) {
            const __m128i aSource = _mm_loadu_si128(
                                                    reinterpret_cast<const __m128i *>(pSource + aOffset));
            const __m128i aPassword = _mm_loadu_si128(
                                                      reinterpret_cast<const __m128i *>(mPassword + aOffset));
            const __m128i aResult = _mm_xor_si128(aSource, aPassword);
            _mm_storeu_si128(reinterpret_cast<__m128i *>(pDestination + aOffset),
                             aResult);
        }
    }
#endif
    
#if JELLY_USE_NEON
    void ApplyNeon(const std::uint8_t *pSource,
                   std::uint8_t *pDestination,
                   std::size_t pLength) const {
        std::size_t aOffset = 0;
        for (; aOffset + 16 <= pLength; aOffset += 16) {
            const uint8x16_t aSource = vld1q_u8(pSource + aOffset);
            const uint8x16_t aPassword = vld1q_u8(mPassword + aOffset);
            const uint8x16_t aResult = veorq_u8(aSource, aPassword);
            vst1q_u8(pDestination + aOffset, aResult);
        }
    }
#endif
    
    const std::uint8_t *mPassword = nullptr;
};

#endif  // JELLY_PASSWORD_XOR_CIPHER_HPP_
