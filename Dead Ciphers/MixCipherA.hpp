#ifndef SOCCER_MIX_CIPHER_A_HPP_
#define SOCCER_MIX_CIPHER_A_HPP_

#include "MixCipherBase.hpp"

// Pack and preserve bit 0; the common implementation is specialized at compile time.
class MixCipherA final : public MixCipherBase<0U, CipherType::kMixCipherA> {
public:
    using MixCipherBase<0U, CipherType::kMixCipherA>::MixCipherBase;
};

#endif  // SOCCER_MIX_CIPHER_A_HPP_
