#ifndef SOCCER_ENCRYPTION_VAULT_HPP_
#define SOCCER_ENCRYPTION_VAULT_HPP_

#include "EncryptionLayerRound.hpp"

// Two four-layer rounds, all operating on the complete block.
// Seal:   A.A -> A.B -> A.C -> A.D -> B.A -> B.B -> B.C -> B.D
// Unseal: B.D -> B.C -> B.B -> B.A -> A.D -> A.C -> A.B -> A.A
// Cipher selection is explicit; an empty vault is the identity transform.
class EncryptionVault {
public:
    static constexpr std::size_t kRoundCount = 2U;
    static constexpr std::size_t kLayerCount = kRoundCount * EncryptionLayerRound::kLayerCount;

    EncryptionVault() = default;
    ~EncryptionVault() = default;
    EncryptionVault(const EncryptionVault &) = delete;
    EncryptionVault &operator=(const EncryptionVault &) = delete;
    EncryptionVault(EncryptionVault &&) = delete;
    EncryptionVault &operator=(EncryptionVault &&) = delete;

    void                        Free();
    void                        Zero();

    // Same buffer contract as EncryptionLayerRound. Both rounds share the
    // caller's two worker buffers; there are no execution-time allocations.
    bool                        SealData(const std::uint8_t *pSource,
                                         std::uint8_t *pWorkerA,
                                         std::uint8_t *pWorkerB,
                                         std::uint8_t *pDestination,
                                         std::size_t pLength,
                                         CipherErrorCode *pErrorCode) const;

    bool                        UnsealData(const std::uint8_t *pSource,
                                           std::uint8_t *pWorkerA,
                                           std::uint8_t *pWorkerB,
                                           std::uint8_t *pDestination,
                                           std::size_t pLength,
                                           CipherErrorCode *pErrorCode) const;

    // Configure each round directly, e.g. mRoundA.AddCipherLayerA(new ...).
    EncryptionLayerRound        mRoundA;
    EncryptionLayerRound        mRoundB;
};

#endif  // SOCCER_ENCRYPTION_VAULT_HPP_
