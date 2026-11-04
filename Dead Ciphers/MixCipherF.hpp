#ifndef SOCCER_MIX_CIPHER_F_HPP_
#define SOCCER_MIX_CIPHER_F_HPP_

#include "MixCipherBase.hpp"

// Pack and preserve bit 5; the common implementation is specialized at compile time.
class MixCipherF final : public MixCipherBase<5U, CipherType::kMixCipherF> {
public:
    using MixCipherBase<5U, CipherType::kMixCipherF>::MixCipherBase;
};

#endif  // SOCCER_MIX_CIPHER_F_HPP_
