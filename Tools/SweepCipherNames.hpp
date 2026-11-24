#pragma once
#include "SoccerTypes.hpp"
inline const char* SweepCipherName(KernelType type) {
    switch(type) {
        case KernelType::kNone: return "None";
        case KernelType::kPasswordXORKernel: return "PasswordXORKernel";
        case KernelType::kShiftMaskedCipher: return "ShiftMaskedCipher";
        case KernelType::kBitReverseKernel: return "BitReverseKernel";
        case KernelType::kFourToadKernel: return "FourToadKernel";
        case KernelType::kFourCrowKernel: return "FourCrowKernel";
        case KernelType::kFourRavenKernel: return "FourRavenKernel";
        case KernelType::kEightRaven: return "EightRaven";
        case KernelType::kQuirkHighA: return "QuirkHighA";
        case KernelType::kQuirkHighB: return "QuirkHighB";
        case KernelType::kQuirkHighC: return "QuirkHighC";
        case KernelType::kQuirkHighD: return "QuirkHighD";
        case KernelType::kQuirkHighE: return "QuirkHighE";
        case KernelType::kQuirkHighF: return "QuirkHighF";
        case KernelType::kQuirkHighG: return "QuirkHighG";
        case KernelType::kQuirkHighH: return "QuirkHighH";
        case KernelType::kQuirkLowA: return "QuirkLowA";
        case KernelType::kQuirkLowB: return "QuirkLowB";
        case KernelType::kQuirkLowC: return "QuirkLowC";
        case KernelType::kQuirkLowD: return "QuirkLowD";
        case KernelType::kQuirkLowE: return "QuirkLowE";
        case KernelType::kQuirkLowF: return "QuirkLowF";
        case KernelType::kQuirkLowG: return "QuirkLowG";
        case KernelType::kQuirkLowH: return "QuirkLowH";
        case KernelType::kFlameToadCipher: return "FlameToadCipher";
        case KernelType::kBogAA: return "BogAA";
        case KernelType::kBogAB: return "BogAB";
        case KernelType::kBogAC: return "BogAC";
        case KernelType::kBogAD: return "BogAD";
        case KernelType::kBogAE: return "BogAE";
        case KernelType::kBogAF: return "BogAF";
        case KernelType::kBogBA: return "BogBA";
        case KernelType::kBogBB: return "BogBB";
        case KernelType::kBogBC: return "BogBC";
        case KernelType::kBogBD: return "BogBD";
        case KernelType::kBogBE: return "BogBE";
        case KernelType::kBogBF: return "BogBF";
        case KernelType::kBogCA: return "BogCA";
        case KernelType::kBogCB: return "BogCB";
        case KernelType::kBogCC: return "BogCC";
        case KernelType::kBogCD: return "BogCD";
        case KernelType::kBogCE: return "BogCE";
        case KernelType::kBogCF: return "BogCF";
        case KernelType::kBogDA: return "BogDA";
        case KernelType::kBogDB: return "BogDB";
        case KernelType::kBogDC: return "BogDC";
        case KernelType::kBogDD: return "BogDD";
        case KernelType::kBogDE: return "BogDE";
        case KernelType::kBogDF: return "BogDF";
        default: return "Unknown";
    }
}
