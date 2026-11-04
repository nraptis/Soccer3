#ifndef SOCCER_MIX_CIPHER_D_HPP_
#define SOCCER_MIX_CIPHER_D_HPP_

#include "MixCipherBase.hpp"

// Pack and preserve bit 3; the common implementation is specialized at compile time.
class MixCipherD final : public MixCipherBase<3U, CipherType::kMixCipherD> {
public:
    using MixCipherBase<3U, CipherType::kMixCipherD>::MixCipherBase;
};

#endif  // SOCCER_MIX_CIPHER_D_HPP_
