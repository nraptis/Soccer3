//
//  Cryptex.hpp
//  Scramble
//
//  Created by Icarus Black on 8/6/26.
//

#ifndef Cryptex_hpp
#define Cryptex_hpp

#include <cstddef>
#include <cstdint>

#include "EncryptionLayer.hpp"

#include "PasswordXORCipher.hpp"
#include "PasswordAddCipher.hpp"
#include "PasswordSubtractCipher.hpp"
#include "PasswordJumpXORCipher.hpp"
#include "PasswordJumpAddCipher.hpp"
#include "PasswordJumpSubtractCipher.hpp"
#include "PepperNoiseXORCipher.hpp"
#include "PepperJumpNoiseXORCipher.hpp"
#include "PepperDualJumpNoiseXORCipher.hpp"
#include "GateCipher.hpp"

#include "RotateMaskCipher.hpp"
#include "ReverseMaskCipher.hpp"
#include "InvertMaskCipher.hpp"
#include "ReverseMaskByteBlockCipher32.hpp"
#include "ReverseMaskByteBlockCipher64.hpp"
#include "SplintMaskBlockCipher32.hpp"
#include "SplintMaskBlockCipher64.hpp"
#include "RotateCipher.hpp"
#include "BitRotationCipherA.hpp"
#include "BitRotationCipherB.hpp"
#include "BitRotationThreeCipher.hpp"
#include "FrogTwoCipherA.hpp"
#include "FrogThreeCipherA.hpp"
#include "FrogTwoCipherB.hpp"
#include "FrogThreeCipherB.hpp"
#include "ToadTwoCipherA.hpp"
#include "ToadThreeCipherA.hpp"
#include "NewtTwoCipherA.hpp"
#include "NewtThreeCipherA.hpp"
#include "TreeFrogTwo.hpp"
#include "RippleMaskBlockCipher32.hpp"
#include "RippleMaskBlockCipher64.hpp"

class Cryptex3 {
public:
    void                        AddCipherL3A(Cipher *pCipher);
    void                        AddCipherL2A(Cipher *pCipher);
    void                        AddCipherL1A(Cipher *pCipher);

    void                        Free();
    void                        Zero();

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

protected:
    EncryptionLayer             mLayerL3A;
    EncryptionLayer             mLayerL2A;
    EncryptionLayer             mLayerL1A;
};

class Cryptex6 : public Cryptex3 {
public:
    void                        AddCipherL3B(Cipher *pCipher);
    void                        AddCipherL2B(Cipher *pCipher);
    void                        AddCipherL1B(Cipher *pCipher);

    void                        Free();
    void                        Zero();

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

protected:
    EncryptionLayer             mLayerL3B;
    EncryptionLayer             mLayerL2B;
    EncryptionLayer             mLayerL1B;
};

class Cryptex9 : public Cryptex6 {
public:
    void                        AddCipherL3C(Cipher *pCipher);
    void                        AddCipherL2C(Cipher *pCipher);
    void                        AddCipherL1C(Cipher *pCipher);

    void                        Free();
    void                        Zero();
    
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
    EncryptionLayer             mLayerL3C;
    EncryptionLayer             mLayerL2C;
    EncryptionLayer             mLayerL1C;
};

#endif /* Cryptex_hpp */
