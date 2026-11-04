#ifndef JELLY_CIPHER_ERROR_CODES_HPP_
#define JELLY_CIPHER_ERROR_CODES_HPP_

#include <cstdint>

enum class CipherErrorCode : std::uint32_t {
  kNone = 0,
  kInvalidLength = 1,
  kNullBuffer = 2,
  kAliasedBuffer = 3,
  kInvalidBlockSize = 4,
  kNullCipher = 5,
  kInvalidParameter = 6,
};

inline void SetCipherErrorCode(CipherErrorCode *pErrorCode,
                               CipherErrorCode pValue) {
  if (pErrorCode != nullptr) {
    *pErrorCode = pValue;
  }
}

#endif  // JELLY_CIPHER_ERROR_CODES_HPP_
