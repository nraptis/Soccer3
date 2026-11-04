#ifndef SOCCER_MIX_CIPHER_C_HPP_
#define SOCCER_MIX_CIPHER_C_HPP_

#include "MixCipherBase.hpp"

// Pack and preserve bit 2; the common implementation is specialized at compile time.
class MixCipherC final : public MixCipherBase<2U, CipherType::kMixCipherC> {
public:
    using MixCipherBase<2U, CipherType::kMixCipherC>::MixCipherBase;
};

#endif  // SOCCER_MIX_CIPHER_C_HPP_
