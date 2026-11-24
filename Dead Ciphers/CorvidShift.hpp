#pragma once

#include "Cipher.hpp"

// Move the two bit planes in mMask forward by mRotation bytes around the block.
struct CorvidShift {
    std::uint8_t mMask;
    std::size_t mRotation;
};

// Pair masks must be disjoint. A Raven borrows a material lane with at least
// pLength bytes and applies its XOR after all the shifts. Buffers are separate.
// Crow accepts multiples of 16 bytes, Raven multiples of 32. Zero length is a
// successful no-op. Rotations wrap modulo pLength. The material stays immutable
// throughout encryption/decryption, and must outlive the cipher.
// Four/Eight counts the shifted planes. A Raven's material XOR covers all bits.
template<std::size_t kPairCount, bool kMutate>
class CorvidCipher : public Cipher {
public:
    bool SealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                  std::uint8_t *pDestination, std::size_t pLength,
                  CipherErrorCode *pErrorCode) const final;
    bool UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorker,
                    std::uint8_t *pDestination, std::size_t pLength,
                    CipherErrorCode *pErrorCode) const final;
    void Zero() final;

protected:
    CorvidCipher(CipherType pType, const CorvidShift (&pShifts)[kPairCount],
                 const std::uint8_t *pMaterial);

private:
    template<bool kUnseal>
    bool Apply(const std::uint8_t *pSource, std::uint8_t *pDestination,
               std::size_t pLength, CipherErrorCode *pErrorCode) const;

    CorvidShift mShifts[kPairCount];
    const std::uint8_t *mMaterial;
    std::uint8_t mStationaryMask;
    bool mValidMasks;
};
