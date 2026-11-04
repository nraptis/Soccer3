#include "EncryptionVault.hpp"

void EncryptionVault::Free() {
    mRoundA.Free();
    mRoundB.Free();
}

void EncryptionVault::Zero() {
    mRoundA.Zero();
    mRoundB.Zero();
}

bool EncryptionVault::SealData(const std::uint8_t *pSource,
                               std::uint8_t *pWorkerA,
                               std::uint8_t *pWorkerB,
                               std::uint8_t *pDestination,
                               std::size_t pLength,
                               CipherErrorCode *pErrorCode) const {
    const EncryptionLayer *aLayers[kLayerCount] = {
        &mRoundA.mLayerA, &mRoundA.mLayerB, &mRoundA.mLayerC, &mRoundA.mLayerD,
        &mRoundB.mLayerA, &mRoundB.mLayerB, &mRoundB.mLayerC, &mRoundB.mLayerD
    };
    return EncryptionLayerRound::ApplyLayers(aLayers, kLayerCount, false,
        pSource, pWorkerA, pWorkerB, pDestination, pLength, pErrorCode);
}

bool EncryptionVault::UnsealData(const std::uint8_t *pSource,
                                 std::uint8_t *pWorkerA,
                                 std::uint8_t *pWorkerB,
                                 std::uint8_t *pDestination,
                                 std::size_t pLength,
                                 CipherErrorCode *pErrorCode) const {
    const EncryptionLayer *aLayers[kLayerCount] = {
        &mRoundA.mLayerA, &mRoundA.mLayerB, &mRoundA.mLayerC, &mRoundA.mLayerD,
        &mRoundB.mLayerA, &mRoundB.mLayerB, &mRoundB.mLayerC, &mRoundB.mLayerD
    };
    return EncryptionLayerRound::ApplyLayers(aLayers, kLayerCount, true,
        pSource, pWorkerA, pWorkerB, pDestination, pLength, pErrorCode);
}
