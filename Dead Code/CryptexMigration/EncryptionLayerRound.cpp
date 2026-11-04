#include "EncryptionLayerRound.hpp"
#include "Jelly.hpp"

void EncryptionLayerRound::AddCipherLayerA(Cipher *pCipher) { mLayerA.AddCipher(pCipher); }
void EncryptionLayerRound::AddCipherLayerB(Cipher *pCipher) { mLayerB.AddCipher(pCipher); }
void EncryptionLayerRound::AddCipherLayerC(Cipher *pCipher) { mLayerC.AddCipher(pCipher); }
void EncryptionLayerRound::AddCipherLayerD(Cipher *pCipher) { mLayerD.AddCipher(pCipher); }

void EncryptionLayerRound::Free() {
    mLayerA.Free();
    mLayerB.Free();
    mLayerC.Free();
    mLayerD.Free();
}

void EncryptionLayerRound::Zero() {
    mLayerA.Zero();
    mLayerB.Zero();
    mLayerC.Zero();
    mLayerD.Zero();
}

bool EncryptionLayerRound::SealData(const std::uint8_t *pSource,
                                    std::uint8_t *pWorkerA,
                                    std::uint8_t *pWorkerB,
                                    std::uint8_t *pDestination,
                                    std::size_t pLength,
                                    CipherErrorCode *pErrorCode) const {
    const EncryptionLayer *aLayers[kLayerCount] = {&mLayerA, &mLayerB, &mLayerC, &mLayerD};
    return ApplyLayers(aLayers, kLayerCount, false, pSource, pWorkerA, pWorkerB,
                       pDestination, pLength, pErrorCode);
}

bool EncryptionLayerRound::UnsealData(const std::uint8_t *pSource,
                                      std::uint8_t *pWorkerA,
                                      std::uint8_t *pWorkerB,
                                      std::uint8_t *pDestination,
                                      std::size_t pLength,
                                      CipherErrorCode *pErrorCode) const {
    const EncryptionLayer *aLayers[kLayerCount] = {&mLayerA, &mLayerB, &mLayerC, &mLayerD};
    return ApplyLayers(aLayers, kLayerCount, true, pSource, pWorkerA, pWorkerB,
                       pDestination, pLength, pErrorCode);
}

bool EncryptionLayerRound::ApplyLayers(const EncryptionLayer *const *pLayers,
                                       std::size_t pLayerCount,
                                       bool pUnseal,
                                       const std::uint8_t *pSource,
                                       std::uint8_t *pWorkerA,
                                       std::uint8_t *pWorkerB,
                                       std::uint8_t *pDestination,
                                       std::size_t pLength,
                                       CipherErrorCode *pErrorCode) {
    if (pLength == 0U) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
        return true;
    }
    if ((pLength % SOCCER_BLOCK_GRANULARITY) != 0U) {
        SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength);
        return false;
    }
    const std::uint8_t *aBuffers[] = {pSource, pWorkerA, pWorkerB, pDestination};
    for (const auto *aBuffer : aBuffers) {
        if (aBuffer == nullptr) {
            SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
            return false;
        }
    }
    for (std::size_t aFirst = 0U; aFirst < 4U; ++aFirst) {
        for (std::size_t aSecond = aFirst + 1U; aSecond < 4U; ++aSecond) {
            const auto aFirstAddress = reinterpret_cast<std::uintptr_t>(aBuffers[aFirst]);
            const auto aSecondAddress = reinterpret_cast<std::uintptr_t>(aBuffers[aSecond]);
            const auto aDistance = aFirstAddress < aSecondAddress
                ? aSecondAddress - aFirstAddress : aFirstAddress - aSecondAddress;
            if (aDistance < pLength) {
                SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
                return false;
            }
        }
    }

    const std::uint8_t *aInput = pSource;
    for (std::size_t aStep = 0U; aStep < pLayerCount; ++aStep) {
        const bool aLast = aStep + 1U == pLayerCount;
        std::uint8_t *aOutput = aLast ? pDestination : ((aStep & 1U) == 0U ? pWorkerA : pWorkerB);
        // Keep three distinct buffers available to each EncryptionLayer.
        // Destination is temporary scratch until the final layer writes it.
        std::uint8_t *aScratch = aStep == 0U ? pWorkerB
            : (aLast ? (aInput == pWorkerA ? pWorkerB : pWorkerA) : pDestination);
        const auto *aLayer = pLayers[pUnseal ? pLayerCount - 1U - aStep : aStep];
        const bool aSuccess = pUnseal
            ? aLayer->UnsealData(aInput, aScratch, aOutput, pLength, pErrorCode)
            : aLayer->SealData(aInput, aScratch, aOutput, pLength, pErrorCode);
        if (!aSuccess) return false;
        aInput = aOutput;
    }
    SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
    return true;
}
