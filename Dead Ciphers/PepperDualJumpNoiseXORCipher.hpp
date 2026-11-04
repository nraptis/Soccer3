#ifndef JELLY_PEPPER_DUAL_JUMP_NOISE_XOR_CIPHER_HPP_
#define JELLY_PEPPER_DUAL_JUMP_NOISE_XOR_CIPHER_HPP_

#include <cstddef>
#include <cstdint>

#include "Jelly.hpp"
#include "Cipher.hpp"

// [RELEASE] [457.1 us] [OK]

class PepperDualJumpNoiseXORCipher final : public Cipher {
public:
    PepperDualJumpNoiseXORCipher(const std::uint8_t *pMask,
                                 const std::uint8_t *pNoise,
                                 const std::uint8_t *pMaskJumps,
                                 const std::uint8_t *pNoiseJumps)
    : Cipher(CipherType::kPepperDualJumpNoiseXORCipher),
    mMask(pMask),
    mNoise(pNoise),
    mMaskJumps(pMaskJumps),
    mNoiseJumps(pNoiseJumps) {}
    
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
        if (pSource == nullptr || pDestination == nullptr || mMask == nullptr ||
            mNoise == nullptr || mMaskJumps == nullptr || mNoiseJumps == nullptr) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
            return false;
        }
        if (pSource == pDestination) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
            return false;
        }
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        
        const std::size_t aChunkCount = pLength >> 4;
        const bool aPowerOfTwoChunkCount =
        (aChunkCount & (aChunkCount - 1u)) == 0u;
        
        std::size_t aMaskChunkIndex = 0u;
        std::size_t aNoiseChunkIndex = 0u;
        std::size_t aMaskJumpIndex = 0u;
        std::size_t aNoiseJumpIndex = 0u;
        
        for (std::size_t aChunk = 0; aChunk < aChunkCount; ++aChunk) {
            const std::uint8_t *aSourcePtr = pSource + (aChunk << 4);
            const std::uint8_t *aMaskPtr = mMask + (aMaskChunkIndex << 4);
            const std::uint8_t *aNoisePtr = mNoise + (aNoiseChunkIndex << 4);
            std::uint8_t *aDestinationPtr = pDestination + (aChunk << 4);
            
#if JELLY_USE_NEON
            ApplyChunkNeon(aSourcePtr, aMaskPtr, aNoisePtr, aDestinationPtr);
#elif JELLY_USE_SIMD
            ApplyChunkSimd(aSourcePtr, aMaskPtr, aNoisePtr, aDestinationPtr);
#else
            ApplyChunkScalar(aSourcePtr, aMaskPtr, aNoisePtr, aDestinationPtr);
#endif
            
            const std::size_t aMaskJump =
            static_cast<std::size_t>(mMaskJumps[aMaskJumpIndex]);
            const std::size_t aNoiseJump =
            static_cast<std::size_t>(mNoiseJumps[aNoiseJumpIndex]);
            
            ++aMaskJumpIndex;
            if (aMaskJumpIndex == pLength) {
                aMaskJumpIndex = 0u;
            }
            ++aNoiseJumpIndex;
            if (aNoiseJumpIndex == pLength) {
                aNoiseJumpIndex = 0u;
            }
            
            aMaskChunkIndex += aMaskJump;
            aNoiseChunkIndex += aNoiseJump;
            
            if (aPowerOfTwoChunkCount) {
                aMaskChunkIndex &= (aChunkCount - 1u);
            } else {
                aMaskChunkIndex %= aChunkCount;
            }
            if (aPowerOfTwoChunkCount) {
                aNoiseChunkIndex &= (aChunkCount - 1u);
            } else {
                aNoiseChunkIndex %= aChunkCount;
            }
        }
        
        return true;
    }
    
    static void ApplyChunkScalar(const std::uint8_t *pSource,
                                 const std::uint8_t *pMask,
                                 const std::uint8_t *pNoise,
                                 std::uint8_t *pDestination) {
        for (std::size_t aIndex = 0; aIndex < 16; ++aIndex) {
            pDestination[aIndex] = static_cast<std::uint8_t>(
                                                             pSource[aIndex] ^ pMask[aIndex] ^ pNoise[aIndex]);
        }
    }
    
#if JELLY_USE_SIMD
    static void ApplyChunkSimd(const std::uint8_t *pSource,
                               const std::uint8_t *pMask,
                               const std::uint8_t *pNoise,
                               std::uint8_t *pDestination) {
        _mm_storeu_si128(
                         reinterpret_cast<__m128i *>(pDestination),
                         _mm_xor_si128(
                                       _mm_xor_si128(
                                                     _mm_loadu_si128(reinterpret_cast<const __m128i *>(pSource)),
                                                     _mm_loadu_si128(reinterpret_cast<const __m128i *>(pMask))),
                                       _mm_loadu_si128(reinterpret_cast<const __m128i *>(pNoise))));
    }
#endif
    
#if JELLY_USE_NEON
    static void ApplyChunkNeon(const std::uint8_t *pSource,
                               const std::uint8_t *pMask,
                               const std::uint8_t *pNoise,
                               std::uint8_t *pDestination) {
        vst1q_u8(
                 pDestination,
                 veorq_u8(veorq_u8(vld1q_u8(pSource), vld1q_u8(pMask)),
                          vld1q_u8(pNoise)));
    }
#endif
    
    const std::uint8_t *mMask = nullptr;
    const std::uint8_t *mNoise = nullptr;
    const std::uint8_t *mMaskJumps = nullptr;
    const std::uint8_t *mNoiseJumps = nullptr;
};

#endif  // JELLY_PEPPER_DUAL_JUMP_NOISE_XOR_CIPHER_HPP_
