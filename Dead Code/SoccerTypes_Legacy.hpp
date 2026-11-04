//
//  CipherType.h
//  MeanMachine
//
//  Created by Icarus Black on 8/4/26.
//

#ifndef CipherType_h
#define CipherType_h

#include <cstddef>
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

// IDs use the low five bits plus bit 19. The extension leaves existing
// IDs and lane/category bit positions stable; unused bits remain reserved.
#define CIPHER_MASK_CIPHER_ID             0x0008001FU

// Lane counts 0-4 are one-hot in bits 5-9.
#define CIPHER_MASK_LANE_COUNT_0          0x00000020U
#define CIPHER_MASK_LANE_COUNT_1          0x00000040U
#define CIPHER_MASK_LANE_COUNT_2          0x00000080U
#define CIPHER_MASK_LANE_COUNT_3          0x00000100U
#define CIPHER_MASK_LANE_COUNT_4          0x00000200U

#define CIPHER_FLAG_MUTATE            0x00001000U

// Rotation is separate from the mover hierarchy. These two flags are
// mutually exclusive: plain rotation (R) or masked rotation (RM).
#define CIPHER_FLAG_ROTATION              0x00002000U
#define CIPHER_FLAG_ROTATION_MASKED       0x00004000U

// Movers are either primary, wide diffusion or secondary garnish.
#define CIPHER_FLAG_PRIMARY_MOVER         0x00008000U
#define CIPHER_FLAG_SECONDARY_MOVER       0x00010000U
#define CIPHER_FLAG_MOVER_ANY             0x00040000U

#define IS_MUTATE(pType) \
    ((static_cast<std::uint32_t>(pType) & CIPHER_FLAG_MUTATE) != 0U)

#define IS_ROTATION(pType) \
    ((static_cast<std::uint32_t>(pType) & CIPHER_FLAG_ROTATION) != 0U)
#define IS_ROTATION_MASKED(pType) \
    ((static_cast<std::uint32_t>(pType) & CIPHER_FLAG_ROTATION_MASKED) != 0U)
#define IS_ROTATION_ANY(pType) \
    ((static_cast<std::uint32_t>(pType) & \
      (CIPHER_FLAG_ROTATION | CIPHER_FLAG_ROTATION_MASKED)) != 0U)

#define IS_PRIMARY_MOVER(pType) \
    ((static_cast<std::uint32_t>(pType) & CIPHER_FLAG_PRIMARY_MOVER) != 0U)
#define IS_SECONDARY_MOVER(pType) \
    ((static_cast<std::uint32_t>(pType) & CIPHER_FLAG_SECONDARY_MOVER) != 0U)
#define IS_MOVER_ANY(pType) \
    ((static_cast<std::uint32_t>(pType) & CIPHER_FLAG_MOVER_ANY) != 0U)

#define IS_MASKED(pType) \
    ((static_cast<std::uint32_t>(pType) & \
      (CIPHER_FLAG_ROTATION_MASKED | CIPHER_FLAG_MOVER_ANY)) != 0U)



enum class CipherType : std::uint32_t {
    kNone = 0U,
    
    kPasswordXORCipher = 0x01U | CIPHER_MASK_LANE_COUNT_1 | CIPHER_FLAG_MUTATE,
    kPasswordAddCipher = 0x02U | CIPHER_MASK_LANE_COUNT_1 | CIPHER_FLAG_MUTATE,
    kPasswordSubtractCipher = 0x03U | CIPHER_MASK_LANE_COUNT_1 | CIPHER_FLAG_MUTATE,

    kPasswordJumpXORCipher = 0x04U | CIPHER_MASK_LANE_COUNT_2 | CIPHER_FLAG_MUTATE,
    kPasswordJumpAddCipher = 0x05U | CIPHER_MASK_LANE_COUNT_2 | CIPHER_FLAG_MUTATE,
    kPasswordJumpSubtractCipher = 0x06U | CIPHER_MASK_LANE_COUNT_2 | CIPHER_FLAG_MUTATE,

    kPepperNoiseXORCipher = 0x07U | CIPHER_MASK_LANE_COUNT_2 | CIPHER_FLAG_MUTATE,
    kPepperJumpNoiseXORCipher = 0x08U | CIPHER_MASK_LANE_COUNT_3 | CIPHER_FLAG_MUTATE,
    kPepperDualJumpNoiseXORCipher = 0x09U | CIPHER_MASK_LANE_COUNT_4 | CIPHER_FLAG_MUTATE,
    
    
    kRotateMaskCipher = 0x0AU | CIPHER_MASK_LANE_COUNT_0 | CIPHER_FLAG_ROTATION_MASKED,
    kRotateCipher = 0x0FU | CIPHER_MASK_LANE_COUNT_0 | CIPHER_FLAG_ROTATION,
    // Retired IDs: implementations and their tests live in Dead Ciphers.
    // Keep the assigned values reserved; the active factory rejects them.
    kBitRotationCipher = 0x19U | CIPHER_MASK_LANE_COUNT_0,

    // Retired one-row mixers.
    kMixCipherA = 0x1AU | CIPHER_MASK_LANE_COUNT_0,
    kMixCipherB = 0x1BU | CIPHER_MASK_LANE_COUNT_0,
    kMixCipherC = 0x1CU | CIPHER_MASK_LANE_COUNT_0,
    kMixCipherD = 0x1DU | CIPHER_MASK_LANE_COUNT_0,
    kMixCipherE = 0x1EU | CIPHER_MASK_LANE_COUNT_0,
    kMixCipherF = 0x1FU | CIPHER_MASK_LANE_COUNT_0,
    // Use spare IDs without changing the existing type or flag values.
    kMixCipherG = 0x14U | CIPHER_MASK_LANE_COUNT_0,
    kMixCipherH = 0x15U | CIPHER_MASK_LANE_COUNT_0,

    // Retired one-row spreads.
    kSpreadCipherA = 0x00080000U | CIPHER_MASK_LANE_COUNT_0,
    kSpreadCipherB = 0x00080001U | CIPHER_MASK_LANE_COUNT_0,
    kSpreadCipherC = 0x00080002U | CIPHER_MASK_LANE_COUNT_0,
    kSpreadCipherD = 0x00080003U | CIPHER_MASK_LANE_COUNT_0,
    kSpreadCipherE = 0x00080004U | CIPHER_MASK_LANE_COUNT_0,
    kSpreadCipherF = 0x00080005U | CIPHER_MASK_LANE_COUNT_0,
    kSpreadCipherG = 0x00080006U | CIPHER_MASK_LANE_COUNT_0,
    kSpreadCipherH = 0x00080007U | CIPHER_MASK_LANE_COUNT_0,

    // Retired Mudge variants.
    kMudgeCipherA = 0x00080008U | CIPHER_MASK_LANE_COUNT_0,
    kMudgeCipherB = 0x00080009U | CIPHER_MASK_LANE_COUNT_0,
    kMudgeCipherC = 0x0008000AU | CIPHER_MASK_LANE_COUNT_0,
    // 0x0008000B is retired (former MudgeD).

    // Retired Skull variants.
    kSkullCipherA = 0x0008000CU | CIPHER_MASK_LANE_COUNT_0,
    kSkullCipherB = 0x0008000DU | CIPHER_MASK_LANE_COUNT_0,
    kSkullCipherC = 0x0008000EU | CIPHER_MASK_LANE_COUNT_0,
    kSkullCipherD = 0x0008000FU | CIPHER_MASK_LANE_COUNT_0,

    // Retired Dance variants.
    kDanceCipherA = 0x00080010U | CIPHER_MASK_LANE_COUNT_0,
    kDanceCipherB = 0x00080011U | CIPHER_MASK_LANE_COUNT_0,

    // One assigned row per window; XOR samples, then add/subtract writable bits.
    kFrogTwoCipherA = 0x00080012U | CIPHER_MASK_LANE_COUNT_0,
    kFrogThreeCipherA = 0x00080013U | CIPHER_MASK_LANE_COUNT_0,
    // Same sampling/addition, with reversed bit packing within each mask byte.
    kFrogTwoCipherB = 0x0008001BU | CIPHER_MASK_LANE_COUNT_0,
    kFrogThreeCipherB = 0x0008001CU | CIPHER_MASK_LANE_COUNT_0,

    // One assigned row per window; successive adds/subtracts on writable bits.
    kToadTwoCipherA = 0x00080014U | CIPHER_MASK_LANE_COUNT_0,
    kToadThreeCipherA = 0x00080015U | CIPHER_MASK_LANE_COUNT_0,

    // Frog-style sampling plus a per-byte AND gate on the protected rows.
    kNewtTwoCipherA = 0x00080016U | CIPHER_MASK_LANE_COUNT_0,
    kNewtThreeCipherA = 0x00080017U | CIPHER_MASK_LANE_COUNT_0,

    // Local two-control-bit conditional inversion; no material or mask bank.
    kTreeFrogTwo = 0x0008001EU | CIPHER_MASK_LANE_COUNT_0,
    kFlameToadCipher = 0x0008001FU | CIPHER_MASK_LANE_COUNT_0,
    kTwoStripReadCipher = 0x00080020U | CIPHER_MASK_LANE_COUNT_0,
    kTwoStripSixAddCipher = 0x00080021U | CIPHER_MASK_LANE_COUNT_0,

    // Public AES byte substitution; no material lanes or mask-bank entry.
    kGateCipher = 0x00080018U | CIPHER_MASK_LANE_COUNT_0,

    // Fixed per-byte bit rotations; independent of farmed byte-buffer rotations.
    kBitRotationCipherA = 0x00080019U | CIPHER_MASK_LANE_COUNT_0,
    kBitRotationCipherB = 0x0008001AU | CIPHER_MASK_LANE_COUNT_0,
    kBitRotationThreeCipher = 0x0008001DU | CIPHER_MASK_LANE_COUNT_0,
    kBitReverseCipher = 0x00080022U | CIPHER_MASK_LANE_COUNT_0,
    
    kReverseMaskCipher = 0x0BU | CIPHER_MASK_LANE_COUNT_0 | CIPHER_FLAG_PRIMARY_MOVER | CIPHER_FLAG_MOVER_ANY,
    kSplintMaskBlockCipher32 = 0x10U | CIPHER_MASK_LANE_COUNT_0 | CIPHER_FLAG_PRIMARY_MOVER | CIPHER_FLAG_MOVER_ANY,
    kSplintMaskBlockCipher64 = 0x11U | CIPHER_MASK_LANE_COUNT_0 | CIPHER_FLAG_PRIMARY_MOVER | CIPHER_FLAG_MOVER_ANY,

    kRippleMaskBlockCipher32 = 0x17U | CIPHER_MASK_LANE_COUNT_0 | CIPHER_FLAG_SECONDARY_MOVER | CIPHER_FLAG_MOVER_ANY,
    kRippleMaskBlockCipher64 = 0x18U | CIPHER_MASK_LANE_COUNT_0 | CIPHER_FLAG_SECONDARY_MOVER | CIPHER_FLAG_MOVER_ANY,

    kInvertMaskCipher = 0x0CU | CIPHER_MASK_LANE_COUNT_0 | CIPHER_FLAG_SECONDARY_MOVER | CIPHER_FLAG_MOVER_ANY,
    kReverseMaskByteBlockCipher32 = 0x0DU | CIPHER_MASK_LANE_COUNT_0 | CIPHER_FLAG_SECONDARY_MOVER | CIPHER_FLAG_MOVER_ANY,
    kReverseMaskByteBlockCipher64 = 0x0EU | CIPHER_MASK_LANE_COUNT_0 | CIPHER_FLAG_SECONDARY_MOVER | CIPHER_FLAG_MOVER_ANY,
};

static_assert(sizeof(CipherType) == sizeof(std::uint32_t));

// Separate row/offset banks from the algorithm. Default routing is
// Frog -> Planet, Toad -> Moon, Newt -> Star; explicit overrides remain available.
enum class CipherSamplingBank : std::uint8_t {
    kByCipherType = 0U,
    kPlanet,
    kMoon,
    kStar,
    // Two triplets from mBitPlanes[level][pass][group]. Also select the
    // protected-row mask when attached to a masked byte rotation.
    kBitPlaneFirstA,
    kBitPlaneFirstB,
    kBitPlaneFirstC,
    kBitPlaneSecondA,
    kBitPlaneSecondB,
    kBitPlaneSecondC,
    // Rotation-only masks: take row 0 or row 1 from each group of the
    // first Frog triplet. Each mask has three bits; they are disjoint.
    kBitPlaneRotationFirstRows,
    kBitPlaneRotationSecondRows,
};

constexpr bool IsBitPlaneSamplingBank(CipherSamplingBank pBank) {
    return pBank >= CipherSamplingBank::kBitPlaneFirstA && pBank <= CipherSamplingBank::kBitPlaneSecondC;
}

constexpr CipherSamplingBank BitPlaneSamplingBank(std::size_t pPass, std::size_t pGroup) {
    return static_cast<CipherSamplingBank>(static_cast<unsigned>(CipherSamplingBank::kBitPlaneFirstA) +
                                         pPass * 3U + pGroup);
}

constexpr bool IsBitPlaneRotationBank(CipherSamplingBank pBank) {
    return pBank == CipherSamplingBank::kBitPlaneRotationFirstRows ||
           pBank == CipherSamplingBank::kBitPlaneRotationSecondRows;
}

constexpr bool IsBitPlaneMaskBank(CipherSamplingBank pBank) {
    return IsBitPlaneSamplingBank(pBank) || IsBitPlaneRotationBank(pBank);
}

constexpr CipherSamplingBank BitPlaneRotationBank(std::size_t pRotationIndex) {
    return static_cast<CipherSamplingBank>(
        static_cast<unsigned>(CipherSamplingBank::kBitPlaneRotationFirstRows) + pRotationIndex);
}

class CipherTool {
public:
    
    static constexpr std::size_t CountLanes(CipherType pType) {
        const std::uint32_t aType = static_cast<std::uint32_t>(pType);

        if ((aType & CIPHER_MASK_LANE_COUNT_0) != 0U) { return 0U; }
        if ((aType & CIPHER_MASK_LANE_COUNT_1) != 0U) { return 1U; }
        if ((aType & CIPHER_MASK_LANE_COUNT_2) != 0U) { return 2U; }
        if ((aType & CIPHER_MASK_LANE_COUNT_3) != 0U) { return 3U; }
        if ((aType & CIPHER_MASK_LANE_COUNT_4) != 0U) { return 4U; }

        return 0U;
    }
    
};

#endif /* CipherType_h */
