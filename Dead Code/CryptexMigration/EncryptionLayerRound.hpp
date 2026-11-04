#ifndef SOCCER_ENCRYPTION_LAYER_ROUND_HPP_
#define SOCCER_ENCRYPTION_LAYER_ROUND_HPP_

#include "EncryptionLayer.hpp"

// Four consecutive full-buffer layers: A -> B -> C -> D when sealing,
// D -> C -> B -> A when unsealing. Normally the buffer is one 1 MiB L3 block;
// every layer receives the entire length, with no L2/L1 subdivision.
class EncryptionLayerRound {
public:
    static constexpr std::size_t kLayerCount = 4U;

    EncryptionLayerRound() = default;
    ~EncryptionLayerRound() = default;
    EncryptionLayerRound(const EncryptionLayerRound &) = delete;
    EncryptionLayerRound &operator=(const EncryptionLayerRound &) = delete;
    EncryptionLayerRound(EncryptionLayerRound &&) = delete;
    EncryptionLayerRound &operator=(EncryptionLayerRound &&) = delete;

    // Ownership follows EncryptionLayer: the layer owns each supplied cipher,
    // and deletes additions beyond its existing 32-cipher capacity.
    void                        AddCipherLayerA(Cipher *pCipher);
    void                        AddCipherLayerB(Cipher *pCipher);
    void                        AddCipherLayerC(Cipher *pCipher);
    void                        AddCipherLayerD(Cipher *pCipher);

    void                        Free();
    void                        Zero();

    // Nonzero lengths must be multiples of 64. All four buffers must cover
    // pLength bytes and be mutually non-overlapping. Zero length is a no-op.
    // Execution allocates no buffers and never writes to pSource. On failure,
    // workers/destination may contain partial results; the error is propagated.
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

private:
    friend class EncryptionVault;

    // Shared buffer routing lets the vault chain both rounds directly, without
    // copying a round's output or borrowing the caller's read-only source.
    static bool                 ApplyLayers(const EncryptionLayer *const *pLayers,
                                            std::size_t pLayerCount,
                                            bool pUnseal,
                                            const std::uint8_t *pSource,
                                            std::uint8_t *pWorkerA,
                                            std::uint8_t *pWorkerB,
                                            std::uint8_t *pDestination,
                                            std::size_t pLength,
                                            CipherErrorCode *pErrorCode);

    EncryptionLayer             mLayerA;
    EncryptionLayer             mLayerB;
    EncryptionLayer             mLayerC;
    EncryptionLayer             mLayerD;
};

#endif  // SOCCER_ENCRYPTION_LAYER_ROUND_HPP_
