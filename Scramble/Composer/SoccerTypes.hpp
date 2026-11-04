#ifndef SOCCER_TYPES_HPP_
#define SOCCER_TYPES_HPP_

#include <cstdint>

#ifndef SOCCER_ENCRYPTION_STRENGTH_DEFINED
#define SOCCER_ENCRYPTION_STRENGTH_DEFINED
enum class EncryptionStrength : std::uint8_t {
    kTest = 3,
    kWeak = 0,
    kNormal = 1,
    kStrong = 2,
};
#endif

// Only implemented ciphers belong in this catalog. Preserve their existing
// numeric values for diagnostics; do not recycle retired identifiers.
// The historical IDs and lane/category flags are in Dead Code/SoccerTypes_Legacy.hpp.
// Cipher selection and material budgets are explicit in Cryptex::Build.
enum class CipherType : std::uint32_t {
    kNone = 0U,
    kPasswordXORCipher = 0x00001041U,
    kShiftMaskedCipher = 0x0000402AU,
    kFlameToadCipher = 0x0008003FU,
    kBitReverseCipher = 0x00080022U,
};

static_assert(sizeof(CipherType) == sizeof(std::uint32_t));

#endif // SOCCER_TYPES_HPP_
