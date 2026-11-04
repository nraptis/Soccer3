#include "EncryptionLayer.hpp"
#include "Jelly.hpp"

#include <cstdint>
#include <cstring>

EncryptionLayer::EncryptionLayer() {
    mCipherCount = 0;
    for (std::size_t aCipherIndex=0; aCipherIndex<ENCRYPTION_LAYER_MAX_CIPHER_COUNT; aCipherIndex++) {
        mCiphers[aCipherIndex] = nullptr;
    }
}

EncryptionLayer::~EncryptionLayer() {
    for (std::size_t aCipherIndex=0; aCipherIndex<mCipherCount; aCipherIndex++) {
        delete mCiphers[aCipherIndex];
        mCiphers[aCipherIndex] = nullptr;
    }
    mCipherCount = 0;
}

void EncryptionLayer::AddCipher(Cipher *pCipher) {
    if (mCipherCount < ENCRYPTION_LAYER_MAX_CIPHER_COUNT) {
        mCiphers[mCipherCount] = pCipher;
        mCipherCount++;
    } else {

        delete pCipher;
    }
}

void EncryptionLayer::Free() {
    for (std::size_t aCipherIndex=0; aCipherIndex<mCipherCount; aCipherIndex++) {
        delete mCiphers[aCipherIndex];
        mCiphers[aCipherIndex] = nullptr;
    }
    mCipherCount = 0;
}

void EncryptionLayer::Zero() {
    for (std::size_t aCipherIndex=0U;
         aCipherIndex<mCipherCount;
         aCipherIndex++) {
        if (mCiphers[aCipherIndex] != nullptr) {
            mCiphers[aCipherIndex]->Zero();
        }
    }
}

bool EncryptionLayer::SealData(const std::uint8_t* pSource,
                               std::uint8_t* pScratch,
                               std::uint8_t* pDestination,
                               std::size_t pLength,
                               CipherErrorCode *pErrorCode) const {
    if (pLength == 0) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
    }
    if ((pLength % SOCCER_BLOCK_GRANULARITY) != 0) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength);
        return false;
    }
    if (pSource == nullptr || pScratch == nullptr || pDestination == nullptr) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
        return false;
    }
    
    if (mCipherCount == 0) {
        if (pSource != pDestination) {
            std::memcpy(pDestination, pSource, pLength);
        }
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
    }
    
    if ((pSource == pDestination) ||
        (pSource == pScratch) ||
        (pDestination == pScratch)) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
        return false;
    }
    
    const std::uint8_t* aInput = pSource;
    std::uint8_t* aOutput =
    ((mCipherCount & 1U) == 0U) ? pScratch : pDestination;
    
    for (std::size_t aCipherIndex=0; aCipherIndex<mCipherCount; aCipherIndex++) {
        Cipher *aCipher = mCiphers[aCipherIndex];
        if (aCipher == nullptr) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullCipher);
            return false;
        }
        if (!aCipher->SealData(aInput, pScratch, aOutput, pLength, pErrorCode)) {
            return false;
        }
        aInput = aOutput;
        aOutput = (aOutput == pDestination) ? pScratch : pDestination;
    }
    
    SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
    return true;
}

bool EncryptionLayer::UnsealData(const std::uint8_t* pSource,
                                 std::uint8_t* pScratch,
                                 std::uint8_t* pDestination,
                                 std::size_t pLength,
                                 CipherErrorCode *pErrorCode) const {
    if (pLength == 0) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
    }
    if ((pLength % SOCCER_BLOCK_GRANULARITY) != 0) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength);
        return false;
    }
    if (pSource == nullptr || pScratch == nullptr || pDestination == nullptr) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
        return false;
    }
    
    if (mCipherCount == 0) {
        if (pSource != pDestination) {
            std::memcpy(pDestination, pSource, pLength);
        }
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
    }
    
    if ((pSource == pDestination) ||
        (pSource == pScratch) ||
        (pDestination == pScratch)) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
        return false;
    }
    
    const std::uint8_t* aInput = pSource;
    std::uint8_t* aOutput =
    ((mCipherCount & 1U) == 0U) ? pScratch : pDestination;
    
    std::size_t aCipherIndex = mCipherCount;
    while (aCipherIndex > 0) {
        aCipherIndex--;
        Cipher *aCipher = mCiphers[aCipherIndex];
        if (aCipher == nullptr) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullCipher);
            return false;
        }
        if (!aCipher->UnsealData(aInput, pScratch, aOutput, pLength,
                                 pErrorCode)) {
            return false;
        }
        aInput = aOutput;
        aOutput = (aOutput == pDestination) ? pScratch : pDestination;
    }
    
    SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
    return true;
}
