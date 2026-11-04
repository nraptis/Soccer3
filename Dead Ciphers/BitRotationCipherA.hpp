#ifndef SOCCER_BIT_ROTATION_CIPHER_A_HPP_
#define SOCCER_BIT_ROTATION_CIPHER_A_HPP_

#include "BitRotationCipherBase.hpp"

// Within each 64-byte window: [rotate 16][copy 16][rotate 16][copy 16].
// Seal rotates left by 3; Unseal rotates right by 3. No constructor arguments.
class BitRotationCipherA final : public BitRotationCipherBase<false> {
 public:
  BitRotationCipherA() : BitRotationCipherBase(CipherType::kBitRotationCipherA) {}
};

#endif  // SOCCER_BIT_ROTATION_CIPHER_A_HPP_
