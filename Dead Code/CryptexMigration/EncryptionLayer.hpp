#ifndef JELLY_CORE_ENCRYPTION_LAYER_HPP_
#define JELLY_CORE_ENCRYPTION_LAYER_HPP_

#include <cstddef>
#include <cstdint>

#include "Cipher.hpp"

#define ENCRYPTION_LAYER_MAX_CIPHER_COUNT 32

class EncryptionLayer {
public:
    EncryptionLayer();
    ~EncryptionLayer();
    
    void                        AddCipher(Cipher *pCipher);
    void                        Free();
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
    
    Cipher                      *mCiphers[ENCRYPTION_LAYER_MAX_CIPHER_COUNT];
    std::size_t                 mCipherCount;
    
};

#endif  // JELLY_CORE_ENCRYPTION_LAYER_HPP_
