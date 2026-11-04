#ifndef SOCCER_SKULL_CIPHER_D_HPP_
#define SOCCER_SKULL_CIPHER_D_HPP_

#include "SkullCipherBase.hpp"

// b4 a4, b5 a5, b6 a6, b7 a7, a0 b0, a1 b1, a2 b2, a3 b3.
class SkullCipherD final : public SkullCipherBase<3U, CipherType::kSkullCipherD> {
public:
    using SkullCipherBase<3U, CipherType::kSkullCipherD>::SkullCipherBase;
};

#endif  // SOCCER_SKULL_CIPHER_D_HPP_
