//
//  Cryptex.cpp
//  Scramble
//
//  Created by Icarus Black on 8/6/26.
//

#include "Cryptex.hpp"
#include "Jelly.hpp"

namespace {

bool ValidateBuffers(const std::uint8_t *pSource,
                     std::uint8_t *pWorkerA,
                     std::uint8_t *pWorkerB,
                     std::uint8_t *pDestination,
                     std::size_t pLength,
                     CipherErrorCode *pErrorCode) {
    if ((pLength % (SOCCER_BLOCK_GRANULARITY * 4U)) != 0U) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength);
        return false;
    }
    if ((pSource == nullptr) ||
        (pWorkerA == nullptr) ||
        (pWorkerB == nullptr) ||
        (pDestination == nullptr)) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
        return false;
    }
    if ((pSource == pWorkerA) ||
        (pSource == pWorkerB) ||
        (pSource == pDestination) ||
        (pWorkerA == pWorkerB) ||
        (pWorkerA == pDestination) ||
        (pWorkerB == pDestination)) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
        return false;
    }
    return true;
}

bool SealL2(const EncryptionLayer &pLayer,
            const std::uint8_t *pSource,
            std::uint8_t *pScratch,
            std::uint8_t *pDestination,
            std::size_t pLength,
            CipherErrorCode *pErrorCode) {
    const std::size_t aLaneLength = pLength >> 1U;
    for (std::size_t aLaneIndex=0U; aLaneIndex<2U; aLaneIndex++) {
        const std::size_t aOffset = aLaneIndex * aLaneLength;
        if (!pLayer.SealData(pSource + aOffset,
                             pScratch + aOffset,
                             pDestination + aOffset,
                             aLaneLength,
                             pErrorCode)) {
            return false;
        }
    }
    return true;
}

bool SealL1(const EncryptionLayer &pLayer,
            const std::uint8_t *pSource,
            std::uint8_t *pScratch,
            std::uint8_t *pDestination,
            std::size_t pLength,
            CipherErrorCode *pErrorCode) {
    const std::size_t aLaneLength = pLength >> 2U;
    for (std::size_t aLaneIndex=0U; aLaneIndex<4U; aLaneIndex++) {
        const std::size_t aOffset = aLaneIndex * aLaneLength;
        if (!pLayer.SealData(pSource + aOffset,
                             pScratch + aOffset,
                             pDestination + aOffset,
                             aLaneLength,
                             pErrorCode)) {
            return false;
        }
    }
    return true;
}

bool UnsealL2(const EncryptionLayer &pLayer,
              const std::uint8_t *pSource,
              std::uint8_t *pScratch,
              std::uint8_t *pDestination,
              std::size_t pLength,
              CipherErrorCode *pErrorCode) {
    const std::size_t aLaneLength = pLength >> 1U;
    for (std::size_t aLaneIndex=0U; aLaneIndex<2U; aLaneIndex++) {
        const std::size_t aOffset = aLaneIndex * aLaneLength;
        if (!pLayer.UnsealData(pSource + aOffset,
                               pScratch + aOffset,
                               pDestination + aOffset,
                               aLaneLength,
                               pErrorCode)) {
            return false;
        }
    }
    return true;
}

bool UnsealL1(const EncryptionLayer &pLayer,
              const std::uint8_t *pSource,
              std::uint8_t *pScratch,
              std::uint8_t *pDestination,
              std::size_t pLength,
              CipherErrorCode *pErrorCode) {
    const std::size_t aLaneLength = pLength >> 2U;
    for (std::size_t aLaneIndex=0U; aLaneIndex<4U; aLaneIndex++) {
        const std::size_t aOffset = aLaneIndex * aLaneLength;
        if (!pLayer.UnsealData(pSource + aOffset,
                               pScratch + aOffset,
                               pDestination + aOffset,
                               aLaneLength,
                               pErrorCode)) {
            return false;
        }
    }
    return true;
}

} // namespace

void Cryptex3::AddCipherL3A(Cipher *pCipher) {
    mLayerL3A.AddCipher(pCipher);
}

void Cryptex3::AddCipherL2A(Cipher *pCipher) {
    mLayerL2A.AddCipher(pCipher);
}

void Cryptex3::AddCipherL1A(Cipher *pCipher) {
    mLayerL1A.AddCipher(pCipher);
}

void Cryptex3::Free() {
    mLayerL3A.Free();
    mLayerL2A.Free();
    mLayerL1A.Free();
}

void Cryptex3::Zero() {
    mLayerL3A.Zero();
    mLayerL2A.Zero();
    mLayerL1A.Zero();
}

bool Cryptex3::SealData(const std::uint8_t *pSource,
                        std::uint8_t *pWorkerA,
                        std::uint8_t *pWorkerB,
                        std::uint8_t *pDestination,
                        std::size_t pLength,
                        CipherErrorCode *pErrorCode) const {
    if (pLength == 0U) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
    }
    if (!ValidateBuffers(pSource, pWorkerA, pWorkerB, pDestination,
                         pLength, pErrorCode)) {
        return false;
    }

    if (!mLayerL3A.SealData(pSource, pWorkerB, pWorkerA,
                            pLength, pErrorCode)) {
        return false;
    }
    if (!SealL2(mLayerL2A, pWorkerA, pDestination, pWorkerB,
                pLength, pErrorCode)) {
        return false;
    }
    return SealL1(mLayerL1A, pWorkerB, pWorkerA, pDestination,
                  pLength, pErrorCode);
}

bool Cryptex3::UnsealData(const std::uint8_t *pSource,
                          std::uint8_t *pWorkerA,
                          std::uint8_t *pWorkerB,
                          std::uint8_t *pDestination,
                          std::size_t pLength,
                          CipherErrorCode *pErrorCode) const {
    if (pLength == 0U) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
    }
    if (!ValidateBuffers(pSource, pWorkerA, pWorkerB, pDestination,
                         pLength, pErrorCode)) {
        return false;
    }

    if (!UnsealL1(mLayerL1A, pSource, pWorkerA, pWorkerB,
                  pLength, pErrorCode)) {
        return false;
    }
    if (!UnsealL2(mLayerL2A, pWorkerB, pDestination, pWorkerA,
                  pLength, pErrorCode)) {
        return false;
    }
    return mLayerL3A.UnsealData(pWorkerA, pWorkerB, pDestination,
                                pLength, pErrorCode);
}

void Cryptex6::AddCipherL3B(Cipher *pCipher) {
    mLayerL3B.AddCipher(pCipher);
}

void Cryptex6::AddCipherL2B(Cipher *pCipher) {
    mLayerL2B.AddCipher(pCipher);
}

void Cryptex6::AddCipherL1B(Cipher *pCipher) {
    mLayerL1B.AddCipher(pCipher);
}

void Cryptex6::Free() {
    Cryptex3::Free();
    mLayerL3B.Free();
    mLayerL2B.Free();
    mLayerL1B.Free();
}

void Cryptex6::Zero() {
    Cryptex3::Zero();
    mLayerL3B.Zero();
    mLayerL2B.Zero();
    mLayerL1B.Zero();
}

bool Cryptex6::SealData(const std::uint8_t *pSource,
                        std::uint8_t *pWorkerA,
                        std::uint8_t *pWorkerB,
                        std::uint8_t *pDestination,
                        std::size_t pLength,
                        CipherErrorCode *pErrorCode) const {
    if (pLength == 0U) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
    }
    if (!ValidateBuffers(pSource, pWorkerA, pWorkerB, pDestination,
                         pLength, pErrorCode)) {
        return false;
    }

    if (!mLayerL3A.SealData(pSource, pWorkerB, pWorkerA,
                            pLength, pErrorCode)) {
        return false;
    }
    if (!SealL2(mLayerL2A, pWorkerA, pDestination, pWorkerB,
                pLength, pErrorCode)) {
        return false;
    }
    if (!SealL1(mLayerL1A, pWorkerB, pDestination, pWorkerA,
                pLength, pErrorCode)) {
        return false;
    }

    if (!mLayerL3B.SealData(pWorkerA, pDestination, pWorkerB,
                            pLength, pErrorCode)) {
        return false;
    }
    if (!SealL2(mLayerL2B, pWorkerB, pDestination, pWorkerA,
                pLength, pErrorCode)) {
        return false;
    }
    return SealL1(mLayerL1B, pWorkerA, pWorkerB, pDestination,
                  pLength, pErrorCode);
}

bool Cryptex6::UnsealData(const std::uint8_t *pSource,
                          std::uint8_t *pWorkerA,
                          std::uint8_t *pWorkerB,
                          std::uint8_t *pDestination,
                          std::size_t pLength,
                          CipherErrorCode *pErrorCode) const {
    if (pLength == 0U) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
    }
    if (!ValidateBuffers(pSource, pWorkerA, pWorkerB, pDestination,
                         pLength, pErrorCode)) {
        return false;
    }

    if (!UnsealL1(mLayerL1B, pSource, pWorkerB, pWorkerA,
                  pLength, pErrorCode)) {
        return false;
    }
    if (!UnsealL2(mLayerL2B, pWorkerA, pDestination, pWorkerB,
                  pLength, pErrorCode)) {
        return false;
    }
    if (!mLayerL3B.UnsealData(pWorkerB, pDestination, pWorkerA,
                              pLength, pErrorCode)) {
        return false;
    }

    if (!UnsealL1(mLayerL1A, pWorkerA, pDestination, pWorkerB,
                  pLength, pErrorCode)) {
        return false;
    }
    if (!UnsealL2(mLayerL2A, pWorkerB, pDestination, pWorkerA,
                  pLength, pErrorCode)) {
        return false;
    }
    return mLayerL3A.UnsealData(pWorkerA, pWorkerB, pDestination,
                                pLength, pErrorCode);
}

void Cryptex9::AddCipherL3C(Cipher *pCipher) {
    mLayerL3C.AddCipher(pCipher);
}

void Cryptex9::AddCipherL2C(Cipher *pCipher) {
    mLayerL2C.AddCipher(pCipher);
}

void Cryptex9::AddCipherL1C(Cipher *pCipher) {
    mLayerL1C.AddCipher(pCipher);
}

void Cryptex9::Free() {
    Cryptex6::Free();
    mLayerL3C.Free();
    mLayerL2C.Free();
    mLayerL1C.Free();
}

void Cryptex9::Zero() {
    Cryptex6::Zero();
    mLayerL3C.Zero();
    mLayerL2C.Zero();
    mLayerL1C.Zero();
}

bool Cryptex9::SealData(const std::uint8_t *pSource,
                        std::uint8_t *pWorkerA,
                        std::uint8_t *pWorkerB,
                        std::uint8_t *pDestination,
                        std::size_t pLength,
                        CipherErrorCode *pErrorCode) const {
    if (pLength == 0U) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
    }
    if (!ValidateBuffers(pSource, pWorkerA, pWorkerB, pDestination,
                         pLength, pErrorCode)) {
        return false;
    }

    if (!mLayerL3A.SealData(pSource, pWorkerB, pWorkerA,
                            pLength, pErrorCode)) {
        return false;
    }
    if (!SealL2(mLayerL2A, pWorkerA, pDestination, pWorkerB,
                pLength, pErrorCode)) {
        return false;
    }
    if (!SealL1(mLayerL1A, pWorkerB, pDestination, pWorkerA,
                pLength, pErrorCode)) {
        return false;
    }

    if (!mLayerL3B.SealData(pWorkerA, pDestination, pWorkerB,
                            pLength, pErrorCode)) {
        return false;
    }
    if (!SealL2(mLayerL2B, pWorkerB, pDestination, pWorkerA,
                pLength, pErrorCode)) {
        return false;
    }
    if (!SealL1(mLayerL1B, pWorkerA, pDestination, pWorkerB,
                pLength, pErrorCode)) {
        return false;
    }

    if (!mLayerL3C.SealData(pWorkerB, pDestination, pWorkerA,
                            pLength, pErrorCode)) {
        return false;
    }
    if (!SealL2(mLayerL2C, pWorkerA, pDestination, pWorkerB,
                pLength, pErrorCode)) {
        return false;
    }
    return SealL1(mLayerL1C, pWorkerB, pWorkerA, pDestination,
                  pLength, pErrorCode);
}

bool Cryptex9::UnsealData(const std::uint8_t *pSource,
                          std::uint8_t *pWorkerA,
                          std::uint8_t *pWorkerB,
                          std::uint8_t *pDestination,
                          std::size_t pLength,
                          CipherErrorCode *pErrorCode) const {
    if (pLength == 0U) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
    }
    if (!ValidateBuffers(pSource, pWorkerA, pWorkerB, pDestination,
                         pLength, pErrorCode)) {
        return false;
    }

    if (!UnsealL1(mLayerL1C, pSource, pWorkerA, pWorkerB,
                  pLength, pErrorCode)) {
        return false;
    }
    if (!UnsealL2(mLayerL2C, pWorkerB, pDestination, pWorkerA,
                  pLength, pErrorCode)) {
        return false;
    }
    if (!mLayerL3C.UnsealData(pWorkerA, pDestination, pWorkerB,
                              pLength, pErrorCode)) {
        return false;
    }

    if (!UnsealL1(mLayerL1B, pWorkerB, pDestination, pWorkerA,
                  pLength, pErrorCode)) {
        return false;
    }
    if (!UnsealL2(mLayerL2B, pWorkerA, pDestination, pWorkerB,
                  pLength, pErrorCode)) {
        return false;
    }
    if (!mLayerL3B.UnsealData(pWorkerB, pDestination, pWorkerA,
                              pLength, pErrorCode)) {
        return false;
    }

    if (!UnsealL1(mLayerL1A, pWorkerA, pDestination, pWorkerB,
                  pLength, pErrorCode)) {
        return false;
    }
    if (!UnsealL2(mLayerL2A, pWorkerB, pDestination, pWorkerA,
                  pLength, pErrorCode)) {
        return false;
    }
    return mLayerL3A.UnsealData(pWorkerA, pWorkerB, pDestination,
                                pLength, pErrorCode);
}
