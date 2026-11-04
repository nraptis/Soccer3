#ifndef SOCCER_MIX_CIPHER_E_HPP_
#define SOCCER_MIX_CIPHER_E_HPP_

#include "MixCipherBase.hpp"

// Pack and preserve bit 4; the common implementation is specialized at compile time.
class MixCipherE final : public MixCipherBase<4U, CipherType::kMixCipherE> {
public:
    using MixCipherBase<4U, CipherType::kMixCipherE>::MixCipherBase;
};

#endif  // SOCCER_MIX_CIPHER_E_HPP_
