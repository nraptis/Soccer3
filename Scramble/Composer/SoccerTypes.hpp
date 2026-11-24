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

// Stable identifiers include archived experiments for historical diagnostics.
// Preserve their numeric values; do not recycle retired identifiers.
// The historical IDs and lane/category flags are in Dead Code/SoccerTypes_Legacy.hpp.
// Kernel selection and material budgets are explicit in Cryptex::Build.
enum class KernelType : std::uint32_t {
    kNone = 0U,
    kPasswordXORKernel = 0x00001041U,
    kShiftMaskedCipher = 0x0000402AU,
    kFlameToadCipher = 0x0008003FU,
    kFourToadKernel = 0x00080040U,
    kFourCrowKernel = 0x00080041U,
    kFourRavenKernel = 0x00080042U,
    kEightRaven = 0x00080043U,
    kQuirkHighA = 0x00080050U,
    kQuirkHighB = 0x00080051U,
    kQuirkHighC = 0x00080052U,
    kQuirkHighD = 0x00080053U,
    kQuirkHighE = 0x00080054U,
    kQuirkHighF = 0x00080055U,
    kQuirkHighG = 0x00080056U,
    kQuirkHighH = 0x00080057U,
    kQuirkLowA = 0x00080060U,
    kQuirkLowB = 0x00080061U,
    kQuirkLowC = 0x00080062U,
    kQuirkLowD = 0x00080063U,
    kQuirkLowE = 0x00080064U,
    kQuirkLowF = 0x00080065U,
    kQuirkLowG = 0x00080066U,
    kQuirkLowH = 0x00080067U,
    kBogAA = 0x00080080U,
    kBogAB = 0x00080081U,
    kBogAC = 0x00080082U,
    kBogAD = 0x00080083U,
    kBogAE = 0x00080084U,
    kBogAF = 0x00080085U,
    kBogBA = 0x00080086U,
    kBogBB = 0x00080087U,
    kBogBC = 0x00080088U,
    kBogBD = 0x00080089U,
    kBogBE = 0x0008008AU,
    kBogBF = 0x0008008BU,
    kBogCA = 0x0008008CU,
    kBogCB = 0x0008008DU,
    kBogCC = 0x0008008EU,
    kBogCD = 0x0008008FU,
    kBogCE = 0x00080090U,
    kBogCF = 0x00080091U,
    kBogDA = 0x00080092U,
    kBogDB = 0x00080093U,
    kBogDC = 0x00080094U,
    kBogDD = 0x00080095U,
    kBogDE = 0x00080096U,
    kBogDF = 0x00080097U,
    kBitReverseKernel = 0x00080022U,
};

static_assert(sizeof(KernelType) == sizeof(std::uint32_t));

#endif // SOCCER_TYPES_HPP_
