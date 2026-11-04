#ifndef JELLY_CASCADE_XOR_CIPHER_HPP_
#define JELLY_CASCADE_XOR_CIPHER_HPP_

#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"

// [RELEASE] [1019.1 us] [OK]

class CascadeCipher final : public Cipher {
public:
    explicit CascadeCipher(const std::uint8_t *pMask)
    : Cipher(CipherType::kCascadeCipher),
    mMask(pMask) {}
    
    bool SealData(const std::uint8_t *pSource,
                  std::uint8_t *pWorker,
                  std::uint8_t *pDestination,
                  std::size_t pLength,
                  CipherErrorCode *pErrorCode) const override {
        return Apply(pSource, pWorker, pDestination, pLength, pErrorCode);
    }
    
    bool UnsealData(const std::uint8_t *pSource,
                    std::uint8_t *pWorker,
                    std::uint8_t *pDestination,
                    std::size_t pLength,
                    CipherErrorCode *pErrorCode) const override {
        return Apply(pSource, pWorker, pDestination, pLength, pErrorCode);
    }
    
private:
    static constexpr std::size_t kLengthMultiple = 16u;
    
    bool Apply(const std::uint8_t *pSource,
               std::uint8_t *pWorker,
               std::uint8_t *pDestination,
               std::size_t pLength,
               CipherErrorCode *pErrorCode) const {
        (void)pWorker;
        if (pLength == 0u) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
            return true;
        }
        if ((pLength % kLengthMultiple) != 0u) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength);
            return false;
        }
        if (pSource == nullptr || pDestination == nullptr || mMask == nullptr) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
            return false;
        }
        if (pSource == pDestination) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
            return false;
        }
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        
        const std::size_t aChunkCount = pLength >> 4;
        std::size_t aMaskChunkIndex = 0u;
        std::uint8_t aState[16] = {};
        
        for (std::size_t aChunk = 0; aChunk < aChunkCount; ++aChunk) {
            const std::uint8_t *aSourcePtr = pSource + (aChunk << 4);
            const std::uint8_t *aMaskPtr = mMask + (aMaskChunkIndex << 4);
            std::uint8_t *aDestinationPtr = pDestination + (aChunk << 4);
            std::uint8_t aDerived[16];
            
#if JELLY_USE_NEON
            ApplyChunkNeon(aSourcePtr, aMaskPtr, aState, aDestinationPtr, aDerived);
#elif JELLY_USE_SIMD
            ApplyChunkSimd(aSourcePtr, aMaskPtr, aState, aDestinationPtr, aDerived);
#else
            ApplyChunkScalar(aSourcePtr, aMaskPtr, aState, aDestinationPtr, aDerived);
#endif
            
            for (std::size_t aIndex = 0; aIndex < 16; ++aIndex) {
                aState[aIndex] = static_cast<std::uint8_t>(
                                                           (aDerived[(aIndex + 1u) & 15u] << 1u) |
                                                           (aDerived[aIndex] >> 7u));
            }
            ++aMaskChunkIndex;
            if (aMaskChunkIndex == aChunkCount) {
                aMaskChunkIndex = 0u;
            }
        }
        return true;
    }
    
    static void ApplyChunkScalar(const std::uint8_t *pSource,
                                 const std::uint8_t *pMask,
                                 const std::uint8_t *pState,
                                 std::uint8_t *pDestination,
                                 std::uint8_t *pDerived) {
        for (std::size_t aIndex = 0; aIndex < 16; ++aIndex) {
            pDerived[aIndex] =
            static_cast<std::uint8_t>(pMask[aIndex] ^ pState[aIndex]);
            pDestination[aIndex] =
            static_cast<std::uint8_t>(pSource[aIndex] ^ pDerived[aIndex]);
        }
    }
    
#if JELLY_USE_SIMD
    static void ApplyChunkSimd(const std::uint8_t *pSource,
                               const std::uint8_t *pMask,
                               const std::uint8_t *pState,
                               std::uint8_t *pDestination,
                               std::uint8_t *pDerived) {
        const __m128i aMask = _mm_loadu_si128(
                                              reinterpret_cast<const __m128i *>(pMask));
        const __m128i aStateVec = _mm_loadu_si128(
                                                  reinterpret_cast<const __m128i *>(pState));
        const __m128i aDerivedVec = _mm_xor_si128(aMask, aStateVec);
        _mm_storeu_si128(reinterpret_cast<__m128i *>(pDerived), aDerivedVec);
        _mm_storeu_si128(
                         reinterpret_cast<__m128i *>(pDestination),
                         _mm_xor_si128(
                                       _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource)),
                                       aDerivedVec));
    }
#endif
    
#if JELLY_USE_NEON
    static void ApplyChunkNeon(const std::uint8_t *pSource,
                               const std::uint8_t *pMask,
                               const std::uint8_t *pState,
                               std::uint8_t *pDestination,
                               std::uint8_t *pDerived) {
        const uint8x16_t aDerivedVec =
        veorq_u8(vld1q_u8(pMask), vld1q_u8(pState));
        vst1q_u8(pDerived, aDerivedVec);
        vst1q_u8(pDestination, veorq_u8(vld1q_u8(pSource), aDerivedVec));
    }
#endif
    
    const std::uint8_t *mMask = nullptr;
};

#endif  // JELLY_CASCADE_XOR_CIPHER_HPP_
