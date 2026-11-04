#ifndef JELLY_ROTATE_CIPHER_HPP_
#define JELLY_ROTATE_CIPHER_HPP_

#include <cstddef>
#include <cstdint>
#include <cstring>

#include "Jelly.hpp"
#include "Cipher.hpp"

// [RELEASE] [17.6 us] [OK]

class RotateCipher final : public Cipher {
 public:
  explicit RotateCipher(std::int32_t pShift)
      : Cipher(CipherType::kRotateCipher),
        mShift(pShift) {}

  bool SealData(const std::uint8_t *pSource,
                std::uint8_t *pWorker,
                std::uint8_t *pDestination,
                std::size_t pLength,
                CipherErrorCode *pErrorCode) const override {
    (void)pWorker;
    return Apply(pSource, pDestination, pLength,
                 InverseShift(mShift, pLength), pErrorCode);
  }

  bool UnsealData(const std::uint8_t *pSource,
                  std::uint8_t *pWorker,
                  std::uint8_t *pDestination,
                  std::size_t pLength,
                  CipherErrorCode *pErrorCode) const override {
    (void)pWorker;
    return Apply(pSource, pDestination, pLength,
                 NormalizeShift(mShift, pLength), pErrorCode);
  }

  void Zero() override {
    mShift = 0;
  }

 private:
  static constexpr std::size_t kLengthMultiple = 16u;

  static std::size_t NormalizeShift(std::int32_t pShift,
                                    std::size_t pLength) {
    if (pLength == 0u) {
      return 0u;
    }
    if (pShift >= 0) {
      return static_cast<std::size_t>(pShift) % pLength;
    }

    const std::size_t aMagnitude =
        static_cast<std::size_t>(-static_cast<std::int64_t>(pShift));
    const std::size_t aReverseRotation = aMagnitude % pLength;
    return aReverseRotation == 0u ? 0u : pLength - aReverseRotation;
  }

  static std::size_t InverseShift(std::int32_t pShift,
                                  std::size_t pLength) {
    const std::size_t aRotation = NormalizeShift(pShift, pLength);
    if (aRotation == 0u) {
      return 0u;
    }
    return pLength - aRotation;
  }

  static bool Apply(const std::uint8_t *pSource,
                    std::uint8_t *pDestination,
                    std::size_t pLength,
                    std::size_t pRotation,
                    CipherErrorCode *pErrorCode) {
    if (pLength == 0u) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
      return true;
    }
    if ((pLength % kLengthMultiple) != 0u) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kInvalidLength);
      return false;
    }
    if (pSource == nullptr || pDestination == nullptr) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kNullBuffer);
      return false;
    }
    if (pSource == pDestination) {
      SetCipherErrorCode(pErrorCode, CipherErrorCode::kAliasedBuffer);
      return false;
    }

    SetCipherErrorCode(pErrorCode, CipherErrorCode::kNone);
    const std::size_t aFirstSpan = pLength - pRotation;
    std::memcpy(pDestination, pSource + pRotation, aFirstSpan);
    std::memcpy(pDestination + aFirstSpan, pSource, pRotation);
    return true;
  }

  std::int32_t mShift;
};

#endif  // JELLY_ROTATE_CIPHER_HPP_
