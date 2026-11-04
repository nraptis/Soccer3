//
//  CipherGauntlet.hpp
//  HolyStorms
//
//  Created by icarus black on 7/2/26.
//

#ifndef CipherGauntlet_hpp
#define CipherGauntlet_hpp

#include "TestConstants.hpp"
#include <stdio.h>
#include "Jelly.hpp"
#include "Cipher.hpp"
#include <string>

class CipherGauntlet {
    
public:
    
    static bool                                 SealDataExpectingSuccess(const std::uint8_t *pSource,
                                                                         std::uint8_t *pWorker,
                                                                         std::uint8_t *pDestination,
                                                                         std::size_t pSize,
                                                                         Cipher *pCipher,
                                                                         std::string pName);
    static bool                                 UnsealDataExpectingSuccess(const std::uint8_t *pSource,
                                                                           std::uint8_t *pWorker,
                                                                           std::uint8_t *pDestination,
                                                                           std::size_t pSize,
                                                                           Cipher *pCipher,
                                                                           std::string pName);
    static bool                                 Matches(const std::uint8_t *pOriginal,
                                                        const std::uint8_t *pUnencrypted,
                                                        std::size_t pSize);
    
    

    bool                                        RunCipher(Cipher *pCipher,
                                                          std::string pName);

    bool                                        RunCipherWithSizeExpectingSuccess(Cipher *pCipher, std::size_t pSize, std::string pName, std::size_t pIndex);
    
    void                                        RandomizeSource(std::size_t pSize, std::size_t pIndex);
    static void                                 ArrayRandomize(std::uint8_t *pData, std::size_t pSize);
    static void                                 ArrayZero(std::uint8_t *pData, std::size_t pSize);
    static void                                 ArrayOne(std::uint8_t *pData, std::size_t pSize);
    
    
    
    std::uint8_t                                mSource[SOCCER_BLOCK_SIZE];
    std::uint8_t                                mWorkerA[SOCCER_BLOCK_SIZE];
    std::uint8_t                                mWorkerB[SOCCER_BLOCK_SIZE];
    
    
    std::uint8_t                                mEncrypted[SOCCER_BLOCK_SIZE];
    std::uint8_t                                mUnencrypted[SOCCER_BLOCK_SIZE];
    
    
};

#endif /* CipherGauntlet_hpp */
