#ifndef SOCCER_ENCRYPTION_CIPHER_HPP_
#define SOCCER_ENCRYPTION_CIPHER_HPP_

#include <cstddef>
#include <cstdint>

#include "CipherErrorCodes.hpp"
#include "SoccerTypes.hpp"

class Cipher {
public:
    explicit Cipher(CipherType pType) : mType(pType) {}
    virtual ~Cipher() = default;

    virtual bool        SealData(const std::uint8_t *pSource,
                                 std::uint8_t *pWorker,
                                 std::uint8_t *pDestination,
                                 std::size_t pLength,
                                 CipherErrorCode *pErrorCode) const = 0;
    virtual bool        UnsealData(const std::uint8_t *pSource,
                                   std::uint8_t *pWorker,
                                   std::uint8_t *pDestination,
                                   std::size_t pLength,
                                   CipherErrorCode *pErrorCode) const = 0;

    virtual void        Zero() {}

    const CipherType    mType;
};

#endif  // SOCCER_ENCRYPTION_CIPHER_HPP_
