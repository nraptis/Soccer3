#include "CryptexLayer.hpp"
#include "Jelly.hpp"

#include <cstdint>
#include <cstring>

CryptexLayer::CryptexLayer() {
    mCipherCount = 0;
    for (std::size_t aCipherIndex=0; aCipherIndex<CRYPTEX_LAYER_MAX_CIPHER_COUNT; aCipherIndex++) {
        mCiphers[aCipherIndex] = nullptr;
    }
}

CryptexLayer::~CryptexLayer() {
    for (std::size_t aCipherIndex=0; aCipherIndex<mCipherCount; aCipherIndex++) {
        delete mCiphers[aCipherIndex];
        mCiphers[aCipherIndex] = nullptr;
    }
    mCipherCount = 0;
}

void CryptexLayer::Add(Cipher *pCipher) {
    if (mCipherCount < CRYPTEX_LAYER_MAX_CIPHER_COUNT) {
        mCiphers[mCipherCount] = pCipher;
        mCipherCount++;
    } else {

        delete pCipher;
    }
}

void CryptexLayer::Clear() {
    for (std::size_t aCipherIndex=0; aCipherIndex<mCipherCount; aCipherIndex++) {
        delete mCiphers[aCipherIndex];
        mCiphers[aCipherIndex] = nullptr;
    }
    mCipherCount = 0;
}

void CryptexLayer::Zero() {
    for (std::size_t aCipherIndex=0U;
         aCipherIndex<mCipherCount;
         aCipherIndex++) {
        if (mCiphers[aCipherIndex] != nullptr) {
            mCiphers[aCipherIndex]->Zero();
        }
    }
}

bool CryptexLayer::SealData(const std::uint8_t* pSource,
                               std::uint8_t* pScratch,
                               std::uint8_t* pDestination,
                               std::size_t pLength,
                               CipherErrorCode *pErrorCode) const {
    if (pLength == 0) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
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

bool CryptexLayer::UnsealData(const std::uint8_t* pSource,
                                 std::uint8_t* pScratch,
                                 std::uint8_t* pDestination,
                                 std::size_t pLength,
                                 CipherErrorCode *pErrorCode) const {
    if (pLength == 0) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
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

CipherType CryptexLayer::GetCipherType(std::size_t pIndex) const {
    return pIndex < mCipherCount && mCiphers[pIndex] != nullptr
        ? mCiphers[pIndex]->mType : CipherType::kNone;
}
