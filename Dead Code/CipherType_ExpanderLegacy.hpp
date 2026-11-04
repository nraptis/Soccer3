//
//  CipherType.h
//  MeanMachine
//
//  Created by Icarus Black on 8/4/26.
//

#ifndef CipherType_h
#define CipherType_h

enum class CipherType : std::uint8_t {
    kNone = 0,
    kPasswordXORCipher = 4,
    kPasswordAddCipher = 8,
    kPasswordSubtractCipher = 12,

    kPasswordJumpXORCipher = 16,
    kPasswordJumpAddCipher = 20,
    kPasswordJumpSubtractCipher = 24,


    kPepperNoiseXORCipher = 36,
    kPepperJumpNoiseXORCipher = 40,
    kPepperDualJumpNoiseXORCipher = 44,

    kInvertMaskCipher = 44,
    kRotateMaskCipher = 48,

    kReverseMaskCipher = 52,
    kReverseMaskByteBlockCipher32 = 56,
    kReverseMaskByteBlockCipher64 = 60,

    kSplintMaskBlockCipher32 = 64,
    kSplintMaskBlockCipher64 = 68,
};

#endif /* CipherType_h */
