#ifndef JELLY_CORE_CRYPTEX_LAYER_HPP_
#define JELLY_CORE_CRYPTEX_LAYER_HPP_

#include <cstddef>
#include <cstdint>

#include "Cipher.hpp"

#define CRYPTEX_LAYER_MAX_CIPHER_COUNT 32

class CryptexLayer {
public:
    CryptexLayer();
    ~CryptexLayer();
    CryptexLayer(const CryptexLayer &) = delete;
    CryptexLayer &operator=(const CryptexLayer &) = delete;
    CryptexLayer(CryptexLayer &&) = delete;
    CryptexLayer &operator=(CryptexLayer &&) = delete;
    std::size_t                 GetCipherCount() const { return mCipherCount; }
    CipherType                  GetCipherType(std::size_t pIndex) const;
    
    void                        Add(Cipher *pCipher);
    void                        Clear();
    void                        Zero();
    
    bool                        SealData(const std::uint8_t* pSource,
                                         std::uint8_t* pScratch,
                                         std::uint8_t* pDestination,
                                         std::size_t pLength,
                                         CipherErrorCode *pErrorCode) const;

    bool                        UnsealData(const std::uint8_t* pSource,
                                           std::uint8_t* pScratch,
                                           std::uint8_t* pDestination,
                                           std::size_t pLength,
                                           CipherErrorCode *pErrorCode) const;
    
private:
    
    Cipher                      *mCiphers[CRYPTEX_LAYER_MAX_CIPHER_COUNT];
    std::size_t                 mCipherCount;
    
};

#endif  // JELLY_CORE_CRYPTEX_LAYER_HPP_
