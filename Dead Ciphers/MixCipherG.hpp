#ifndef SOCCER_MIX_CIPHER_G_HPP_
#define SOCCER_MIX_CIPHER_G_HPP_

#include "MixCipherBase.hpp"

// Pack and preserve bit 6; the common implementation is specialized at compile time.
class MixCipherG final : public MixCipherBase<6U, CipherType::kMixCipherG> {
public:
    using MixCipherBase<6U, CipherType::kMixCipherG>::MixCipherBase;
};

#endif  // SOCCER_MIX_CIPHER_G_HPP_
