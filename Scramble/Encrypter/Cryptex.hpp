#ifndef SOCCER_CRYPTEX_HPP_
#define SOCCER_CRYPTEX_HPP_

#include "CryptexLayer.hpp"

// Eight full-block layers. Forward: AA, AB, AC, AD, BA, BB, BC, BD.
// Reverse executes both the layers and each layer's ciphers backwards.
class Cryptex {
public:
    static constexpr std::size_t kLayerCount = 8U;
    Cryptex() = default;
    ~Cryptex() = default;
    Cryptex(const Cryptex &) = delete;
    Cryptex &operator=(const Cryptex &) = delete;
    Cryptex(Cryptex &&) = delete;
    Cryptex &operator=(Cryptex &&) = delete;

    void Clear();
    // Zero each cipher, free the layers, and restore the initial state.
    void Zero();
    // Builds once into the empty layers established by Soccer3::Zero().
    // Inputs are the named Soccer3 values assigned in epilogue D.
    // Any strength other than weak/strong uses the normal schedule.
    bool Build(EncryptionStrength pStrength);
    bool IsBuilt() const { return mBuilt; }
    std::size_t GetMaterialCount() const { return mMaterialCount; }
    EncryptionStrength GetStrength() const { return mStrength; }

    // Nonzero lengths are multiples of 64. All four buffers must cover the
    // complete length and must not overlap. Execution makes no allocations.
    bool SealData(const std::uint8_t *pSource, std::uint8_t *pWorkerA,
                  std::uint8_t *pWorkerB, std::uint8_t *pDestination,
                  std::size_t pLength, CipherErrorCode *pErrorCode) const;
    bool UnsealData(const std::uint8_t *pSource, std::uint8_t *pWorkerA,
                    std::uint8_t *pWorkerB, std::uint8_t *pDestination,
                    std::size_t pLength, CipherErrorCode *pErrorCode) const;

    CryptexLayer mLayerAA;
    CryptexLayer mLayerAB;
    CryptexLayer mLayerAC;
    CryptexLayer mLayerAD;
    CryptexLayer mLayerBA;
    CryptexLayer mLayerBB;
    CryptexLayer mLayerBC;
    CryptexLayer mLayerBD;

private:
    bool Apply(bool pUnseal, const std::uint8_t *pSource, std::uint8_t *pWorkerA,
               std::uint8_t *pWorkerB, std::uint8_t *pDestination,
               std::size_t pLength, CipherErrorCode *pErrorCode) const;
    EncryptionStrength mStrength = EncryptionStrength::kNormal;
    std::size_t mMaterialCount = 0U;
    bool mBuilt = false;
};

#endif // SOCCER_CRYPTEX_HPP_
