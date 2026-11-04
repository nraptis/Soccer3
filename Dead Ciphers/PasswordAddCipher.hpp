#ifndef JELLY_PASSWORD_ADD_CIPHER_HPP_
#define JELLY_PASSWORD_ADD_CIPHER_HPP_

#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"

// [RELEASE] [45.6 us] [OK]

class PasswordAddCipher final : public Cipher {
public:
    explicit PasswordAddCipher(const std::uint8_t *pPassword)
    : Cipher(CipherType::kPasswordAddCipher),
    mPassword(pPassword) {}
    
    bool SealData(const std::uint8_t *pSource,
                  std::uint8_t *pWorker,
                  std::uint8_t *pDestination,
                  std::size_t pLength,
                  CipherErrorCode *pErrorCode) const override {
        (void)pWorker;
        return ApplyAdd(pSource, pDestination, pLength, pErrorCode);
    }
    
    bool UnsealData(const std::uint8_t *pSource,
                    std::uint8_t *pWorker,
                    std::uint8_t *pDestination,
                    std::size_t pLength,
                    CipherErrorCode *pErrorCode) const override {
        (void)pWorker;
        return ApplySubtract(pSource, pDestination, pLength, pErrorCode);
    }
    
private:
    static constexpr std::size_t kLengthMultiple = 32u;
    
    bool Validate(const std::uint8_t *pSource,
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
        if (pSource == nullptr || pDestination == nullptr || mPassword == nullptr) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
            return false;
        }
        if (pSource == pDestination) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
            return false;
        }
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
    }
    
    bool ApplyAdd(const std::uint8_t *pSource,
                  std::uint8_t *pDestination,
                  std::size_t pLength,
                  CipherErrorCode *pErrorCode) const {
        if (!Validate(pSource, pDestination, pLength, pErrorCode)) {
            return false;
        }
        if (pLength == 0u) {
            return true;
        }
#if JELLY_USE_NEON
        ApplyAddNeon(pSource, pDestination, pLength);
#elif JELLY_USE_SIMD
        ApplyAddSimd(pSource, pDestination, pLength);
#else
        ApplyAddScalar(pSource, pDestination, pLength);
#endif
        return true;
    }
    
    bool ApplySubtract(const std::uint8_t *pSource,
                       std::uint8_t *pDestination,
                       std::size_t pLength,
                       CipherErrorCode *pErrorCode) const {
        if (!Validate(pSource, pDestination, pLength, pErrorCode)) {
            return false;
        }
        if (pLength == 0u) {
            return true;
        }
#if JELLY_USE_NEON
        ApplySubtractNeon(pSource, pDestination, pLength);
#elif JELLY_USE_SIMD
        ApplySubtractSimd(pSource, pDestination, pLength);
#else
        ApplySubtractScalar(pSource, pDestination, pLength);
#endif
        return true;
    }
    
    void ApplyAddScalar(const std::uint8_t *pSource,
                        std::uint8_t *pDestination,
                        std::size_t pLength) const {
        for (std::size_t aIndex = 0; aIndex < pLength; ++aIndex) {
            pDestination[aIndex] =
            static_cast<std::uint8_t>(pSource[aIndex] + mPassword[aIndex]);
        }
    }
    
    void ApplySubtractScalar(const std::uint8_t *pSource,
                             std::uint8_t *pDestination,
                             std::size_t pLength) const {
        for (std::size_t aIndex = 0; aIndex < pLength; ++aIndex) {
            pDestination[aIndex] =
            static_cast<std::uint8_t>(pSource[aIndex] - mPassword[aIndex]);
        }
    }
    
#if JELLY_USE_SIMD
    void ApplyAddSimd(const std::uint8_t *pSource,
                      std::uint8_t *pDestination,
                      std::size_t pLength) const {
        std::size_t aIndex = 0;
#if defined(__AVX2__)
        for (; aIndex + 32 <= pLength; aIndex += 32) {
            _mm256_storeu_si256(
                                reinterpret_cast<__m256i *>(pDestination + aIndex),
                                _mm256_add_epi8(
                                                _mm256_loadu_si256(
                                                                   reinterpret_cast<const __m256i *>(pSource + aIndex)),
                                                _mm256_loadu_si256(
                                                                   reinterpret_cast<const __m256i *>(mPassword + aIndex))));
        }
#endif
        for (; aIndex + 16 <= pLength; aIndex += 16) {
            _mm_storeu_si128(
                             reinterpret_cast<__m128i *>(pDestination + aIndex),
                             _mm_add_epi8(
                                          _mm_loadu_si128(
                                                          reinterpret_cast<const __m128i *>(pSource + aIndex)),
                                          _mm_loadu_si128(
                                                          reinterpret_cast<const __m128i *>(mPassword + aIndex))));
        }
        for (; aIndex < pLength; ++aIndex) {
            pDestination[aIndex] =
            static_cast<std::uint8_t>(pSource[aIndex] + mPassword[aIndex]);
        }
    }
    
    void ApplySubtractSimd(const std::uint8_t *pSource,
                           std::uint8_t *pDestination,
                           std::size_t pLength) const {
        std::size_t aIndex = 0;
#if defined(__AVX2__)
        for (; aIndex + 32 <= pLength; aIndex += 32) {
            _mm256_storeu_si256(
                                reinterpret_cast<__m256i *>(pDestination + aIndex),
                                _mm256_sub_epi8(
                                                _mm256_loadu_si256(
                                                                   reinterpret_cast<const __m256i *>(pSource + aIndex)),
                                                _mm256_loadu_si256(
                                                                   reinterpret_cast<const __m256i *>(mPassword + aIndex))));
        }
#endif
        for (; aIndex + 16 <= pLength; aIndex += 16) {
            _mm_storeu_si128(
                             reinterpret_cast<__m128i *>(pDestination + aIndex),
                             _mm_sub_epi8(
                                          _mm_loadu_si128(
                                                          reinterpret_cast<const __m128i *>(pSource + aIndex)),
                                          _mm_loadu_si128(
                                                          reinterpret_cast<const __m128i *>(mPassword + aIndex))));
        }
        for (; aIndex < pLength; ++aIndex) {
            pDestination[aIndex] =
            static_cast<std::uint8_t>(pSource[aIndex] - mPassword[aIndex]);
        }
    }
#endif
    
#if JELLY_USE_NEON
    void ApplyAddNeon(const std::uint8_t *pSource,
                      std::uint8_t *pDestination,
                      std::size_t pLength) const {
        std::size_t aIndex = 0;
        for (; aIndex + 16 <= pLength; aIndex += 16) {
            vst1q_u8(pDestination + aIndex,
                     vaddq_u8(vld1q_u8(pSource + aIndex),
                              vld1q_u8(mPassword + aIndex)));
        }
        for (; aIndex < pLength; ++aIndex) {
            pDestination[aIndex] =
            static_cast<std::uint8_t>(pSource[aIndex] + mPassword[aIndex]);
        }
    }
    
    void ApplySubtractNeon(const std::uint8_t *pSource,
                           std::uint8_t *pDestination,
                           std::size_t pLength) const {
        std::size_t aIndex = 0;
        for (; aIndex + 16 <= pLength; aIndex += 16) {
            vst1q_u8(pDestination + aIndex,
                     vsubq_u8(vld1q_u8(pSource + aIndex),
                              vld1q_u8(mPassword + aIndex)));
        }
        for (; aIndex < pLength; ++aIndex) {
            pDestination[aIndex] =
            static_cast<std::uint8_t>(pSource[aIndex] - mPassword[aIndex]);
        }
    }
#endif
    
    const std::uint8_t *mPassword = nullptr;
};

#endif  // JELLY_PASSWORD_ADD_CIPHER_HPP_
