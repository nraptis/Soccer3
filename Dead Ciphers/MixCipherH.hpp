#ifndef SOCCER_MIX_CIPHER_H_HPP_
#define SOCCER_MIX_CIPHER_H_HPP_

#include "MixCipherBase.hpp"

// Pack and preserve bit 7; the common implementation is specialized at compile time.
class MixCipherH final : public MixCipherBase<7U, CipherType::kMixCipherH> {
public:
    using MixCipherBase<7U, CipherType::kMixCipherH>::MixCipherBase;
};

#endif  // SOCCER_MIX_CIPHER_H_HPP_
