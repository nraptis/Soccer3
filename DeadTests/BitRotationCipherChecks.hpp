#ifndef SOCCER_BIT_ROTATION_CIPHER_CHECKS_HPP_
#define SOCCER_BIT_ROTATION_CIPHER_CHECKS_HPP_

#include "BitRotationCipherA.hpp"
#include "BitRotationCipherB.hpp"
#include <algorithm>
#include <array>
#include <random>
#include <vector>

// Independent reference: move each bit separately, including the copied groups.
inline std::uint8_t ReferenceBitRotation(std::uint8_t pValue, std::size_t pPosition,
                                        bool pVariantB, bool pInverse) {
  const bool aSelected = ((pPosition % 64u) / 16u) % 2u == (pVariantB ? 1u : 0u);
  std::uint8_t aResult = 0u;
  for (unsigned aBit = 0u; aBit < 8u; ++aBit) {
    const unsigned aDestinationBit = aSelected ? (aBit + (pInverse ? 5u : 3u)) % 8u : aBit;
    aResult |= static_cast<std::uint8_t>(((pValue >> aBit) & 1u) << aDestinationBit);
  }
  return aResult;
}

inline const char *CheckBitRotationCiphers() {
  BitRotationCipherA aCipherA{};
  BitRotationCipherB aCipherB{};
  const std::array<Cipher *, 2u> aCiphers = {&aCipherA, &aCipherB};
  std::array<std::uint8_t, 128u> aSource{}, aOutput{}, aRestored{}, aCombined{};
  for (unsigned aVariant = 0u; aVariant < 2u; ++aVariant) {
    auto &aCipher = *aCiphers[aVariant];
    for (unsigned aValue = 0u; aValue < 256u; ++aValue) {
      for (std::size_t aPosition = 0u; aPosition < aSource.size(); ++aPosition)
        aSource[aPosition] = static_cast<std::uint8_t>(aValue + 37u * aPosition);
      for (bool aInverse : {false, true}) {
        const bool aSuccess = aInverse
            ? aCipher.UnsealData(aSource.data(), nullptr, aOutput.data(), aSource.size(), nullptr)
            : aCipher.SealData(aSource.data(), nullptr, aOutput.data(), aSource.size(), nullptr);
        if (!aSuccess) return "byte mapping rejected";
        for (std::size_t aPosition = 0u; aPosition < aSource.size(); ++aPosition)
          if (aOutput[aPosition] != ReferenceBitRotation(aSource[aPosition], aPosition, aVariant != 0u, aInverse))
            return "byte mapping differs from reference";
      }
    }
    aSource.fill(1u);
    if (!aCipher.SealData(aSource.data(), nullptr, aOutput.data(), 64u, nullptr)) return "half-window seal";
    if (std::count(aOutput.begin(), aOutput.begin() + 64u, 8u) != 32 ||
        std::count(aOutput.begin(), aOutput.begin() + 64u, 1u) != 32) return "not exactly half the bytes rotated";
    aCipher.Zero();
    if (!aCipher.SealData(aSource.data(), nullptr, aRestored.data(), 64u, nullptr) ||
        !std::equal(aOutput.begin(), aOutput.begin() + 64u, aRestored.begin())) return "Zero changed fixed operation";
  }
  for (std::size_t aPosition = 0u; aPosition < aSource.size(); ++aPosition)
    aSource[aPosition] = static_cast<std::uint8_t>(aPosition * 19u);
  if (!aCipherA.SealData(aSource.data(), nullptr, aOutput.data(), aSource.size(), nullptr) ||
      !aCipherB.SealData(aOutput.data(), nullptr, aCombined.data(), aSource.size(), nullptr)) return "complement composition";
  for (std::size_t aPosition = 0u; aPosition < aSource.size(); ++aPosition)
    if (aCombined[aPosition] != static_cast<std::uint8_t>((aSource[aPosition] << 3u) | (aSource[aPosition] >> 5u)))
      return "A and B do not cover complementary bytes";

  constexpr std::size_t kLength = 1u << 20u;
  std::vector<std::uint8_t> aLargeSource(kLength + 8u, 0xD3u), aLargeOutput(kLength + 8u, 0xA5u),
      aLargeRestored(kLength + 8u, 0xB6u);
  std::array<std::uint8_t, 64u> aWorker{};
  aWorker.fill(0xC7u);
  const auto aSavedWorker = aWorker;
  std::mt19937 aRandom(0xB170A7U);
  for (std::size_t aIndex = 0u; aIndex < kLength; ++aIndex)
    aLargeSource[aIndex + 1u] = static_cast<std::uint8_t>(aRandom());
  const auto aSavedSource = aLargeSource;
  for (unsigned aVariant = 0u; aVariant < 2u; ++aVariant) {
    auto &aCipher = *aCiphers[aVariant];
    CipherErrorCode aError = CipherErrorCode::kNullCipher;
    if (!aCipher.SealData(aLargeSource.data() + 1u, aWorker.data(), aLargeOutput.data() + 3u, kLength, &aError) ||
        aError != CipherErrorCode::kNone) return "unaligned 1 MiB seal";
    for (std::size_t aIndex = 0u; aIndex < kLength; ++aIndex)
      if (aLargeOutput[aIndex + 3u] != ReferenceBitRotation(aLargeSource[aIndex + 1u], aIndex, aVariant != 0u, false))
        return "1 MiB reference";
    if (!aCipher.UnsealData(aLargeOutput.data() + 3u, nullptr, aLargeRestored.data() + 5u, kLength, &aError) ||
        aError != CipherErrorCode::kNone ||
        !std::equal(aLargeSource.begin() + 1u, aLargeSource.begin() + 1u + kLength, aLargeRestored.begin() + 5u))
      return "1 MiB inverse";
    if (aLargeSource != aSavedSource || aWorker != aSavedWorker) return "source or worker changed";
    if (!std::all_of(aLargeOutput.begin(), aLargeOutput.begin() + 3u, [](auto pValue) { return pValue == 0xA5u; }) ||
        !std::all_of(aLargeOutput.begin() + 3u + kLength, aLargeOutput.end(), [](auto pValue) { return pValue == 0xA5u; }) ||
        !std::all_of(aLargeRestored.begin(), aLargeRestored.begin() + 5u, [](auto pValue) { return pValue == 0xB6u; }) ||
        !std::all_of(aLargeRestored.begin() + 5u + kLength, aLargeRestored.end(), [](auto pValue) { return pValue == 0xB6u; }))
      return "destination guard changed";
  }
  return nullptr;
}

inline const char *CheckBitRotationErrors() {
  BitRotationCipherA aCipherA{};
  BitRotationCipherB aCipherB{};
  std::array<std::uint8_t, 256u> aBuffer{};
  aBuffer.fill(0x53u);
  for (const Cipher *aCipher : {static_cast<Cipher *>(&aCipherA), static_cast<Cipher *>(&aCipherB)}) {
    for (bool aInverse : {false, true}) {
      auto aApply = [&](const std::uint8_t *pSource, std::uint8_t *pDestination, std::size_t pLength, CipherErrorCode *pError) {
        return aInverse ? aCipher->UnsealData(pSource, nullptr, pDestination, pLength, pError)
                        : aCipher->SealData(pSource, nullptr, pDestination, pLength, pError);
      };
      CipherErrorCode aError = CipherErrorCode::kNullCipher;
      if (!aApply(nullptr, nullptr, 0u, &aError) || aError != CipherErrorCode::kNone) return "zero length";
      const auto aBefore = aBuffer;
      for (std::size_t aLength : {1u, 16u, 32u, 63u, 65u, 127u})
        if (aApply(aBuffer.data(), aBuffer.data() + 128u, aLength, &aError) || aError != CipherErrorCode::kInvalidLength)
          return "invalid length accepted";
      if (aApply(nullptr, aBuffer.data(), 64u, &aError) || aError != CipherErrorCode::kNullBuffer ||
          aApply(aBuffer.data(), nullptr, 64u, &aError) || aError != CipherErrorCode::kNullBuffer) return "null buffer accepted";
      for (std::size_t aOffset : {0u, 1u, 16u, 63u})
        if (aApply(aBuffer.data(), aBuffer.data() + aOffset, 64u, &aError) || aError != CipherErrorCode::kAliasedBuffer ||
            aApply(aBuffer.data() + aOffset, aBuffer.data(), 64u, &aError) || aError != CipherErrorCode::kAliasedBuffer)
          return "overlapping buffer accepted";
      if (aBuffer != aBefore) return "invalid call changed data";
      if (!aApply(aBuffer.data(), aBuffer.data() + 64u, 64u, nullptr)) return "adjacent buffers rejected";
    }
  }
  return nullptr;
}

#endif  // SOCCER_BIT_ROTATION_CIPHER_CHECKS_HPP_
