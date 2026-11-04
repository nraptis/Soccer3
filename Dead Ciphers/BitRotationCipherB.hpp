#ifndef SOCCER_BIT_ROTATION_CIPHER_B_HPP_
#define SOCCER_BIT_ROTATION_CIPHER_B_HPP_

#include "BitRotationCipherBase.hpp"

// Within each 64-byte window: [copy 16][rotate 16][copy 16][rotate 16].
// Opposite byte selection to A; both use the same forward rotation direction.
class BitRotationCipherB final : public BitRotationCipherBase<true> {
 public:
  BitRotationCipherB() : BitRotationCipherBase(CipherType::kBitRotationCipherB) {}
};

#endif  // SOCCER_BIT_ROTATION_CIPHER_B_HPP_
