#ifndef SOCCER_MIX_CIPHER_B_HPP_
#define SOCCER_MIX_CIPHER_B_HPP_

#include "MixCipherBase.hpp"

// Pack and preserve bit 1; the common implementation is specialized at compile time.
class MixCipherB final : public MixCipherBase<1U, CipherType::kMixCipherB> {
public:
    using MixCipherBase<1U, CipherType::kMixCipherB>::MixCipherBase;
};

#endif  // SOCCER_MIX_CIPHER_B_HPP_
