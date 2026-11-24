//
//  RotationWindowCollisionTests.m
//  ScrambleTests
//
//  Created by Icarus Black on 11/4/26.
//

#import <XCTest/XCTest.h>
#include "../../Scramble/Composer/Soccer3.hpp"
#include "Random.hpp"
#include "EightRotationValidator.hpp"
#include <cstddef>
#include <cstdint>
#include <cstdio>


namespace {

constexpr std::size_t kRotationListCount = 18U;
constexpr std::size_t kRotationsPerList = 8U;
static_assert(kRotationListCount == Soccer3::kRotationListCount);
static_assert(kRotationsPerList == Soccer3::kRotationsPerList);

struct RotationEightList {
    const char *mName;
    std::size_t mRotations[kRotationsPerList];
};

struct RotationCollection {
    RotationEightList mLists[kRotationListCount];
};

// Soccer must already be seeded. Read chosen WINDOW indices, before byte offsets.
RotationCollection GetRotationCollection() {
    return {{
        {"ShiftMasked A", {
            Soccer3::mShiftMaskedRotationListChosenA[0U], Soccer3::mShiftMaskedRotationListChosenA[1U],
            Soccer3::mShiftMaskedRotationListChosenA[2U], Soccer3::mShiftMaskedRotationListChosenA[3U],
            Soccer3::mShiftMaskedRotationListChosenA[4U], Soccer3::mShiftMaskedRotationListChosenA[5U],
            Soccer3::mShiftMaskedRotationListChosenA[6U], Soccer3::mShiftMaskedRotationListChosenA[7U]
        }},
        {"ShiftMasked B", {
            Soccer3::mShiftMaskedRotationListChosenB[0U], Soccer3::mShiftMaskedRotationListChosenB[1U],
            Soccer3::mShiftMaskedRotationListChosenB[2U], Soccer3::mShiftMaskedRotationListChosenB[3U],
            Soccer3::mShiftMaskedRotationListChosenB[4U], Soccer3::mShiftMaskedRotationListChosenB[5U],
            Soccer3::mShiftMaskedRotationListChosenB[6U], Soccer3::mShiftMaskedRotationListChosenB[7U]
        }},
        {"FlameToad AALeft", {
            Soccer3::mFlameToadRotationListChosenAALeft[0U], Soccer3::mFlameToadRotationListChosenAALeft[1U],
            Soccer3::mFlameToadRotationListChosenAALeft[2U], Soccer3::mFlameToadRotationListChosenAALeft[3U],
            Soccer3::mFlameToadRotationListChosenAALeft[4U], Soccer3::mFlameToadRotationListChosenAALeft[5U],
            Soccer3::mFlameToadRotationListChosenAALeft[6U], Soccer3::mFlameToadRotationListChosenAALeft[7U]
        }},
        {"FlameToad AARight", {
            Soccer3::mFlameToadRotationListChosenAARight[0U], Soccer3::mFlameToadRotationListChosenAARight[1U],
            Soccer3::mFlameToadRotationListChosenAARight[2U], Soccer3::mFlameToadRotationListChosenAARight[3U],
            Soccer3::mFlameToadRotationListChosenAARight[4U], Soccer3::mFlameToadRotationListChosenAARight[5U],
            Soccer3::mFlameToadRotationListChosenAARight[6U], Soccer3::mFlameToadRotationListChosenAARight[7U]
        }},
        {"FlameToad ABLeft", {
            Soccer3::mFlameToadRotationListChosenABLeft[0U], Soccer3::mFlameToadRotationListChosenABLeft[1U],
            Soccer3::mFlameToadRotationListChosenABLeft[2U], Soccer3::mFlameToadRotationListChosenABLeft[3U],
            Soccer3::mFlameToadRotationListChosenABLeft[4U], Soccer3::mFlameToadRotationListChosenABLeft[5U],
            Soccer3::mFlameToadRotationListChosenABLeft[6U], Soccer3::mFlameToadRotationListChosenABLeft[7U]
        }},
        {"FlameToad ABRight", {
            Soccer3::mFlameToadRotationListChosenABRight[0U], Soccer3::mFlameToadRotationListChosenABRight[1U],
            Soccer3::mFlameToadRotationListChosenABRight[2U], Soccer3::mFlameToadRotationListChosenABRight[3U],
            Soccer3::mFlameToadRotationListChosenABRight[4U], Soccer3::mFlameToadRotationListChosenABRight[5U],
            Soccer3::mFlameToadRotationListChosenABRight[6U], Soccer3::mFlameToadRotationListChosenABRight[7U]
        }},
        {"FlameToad ACLeft", {
            Soccer3::mFlameToadRotationListChosenACLeft[0U], Soccer3::mFlameToadRotationListChosenACLeft[1U],
            Soccer3::mFlameToadRotationListChosenACLeft[2U], Soccer3::mFlameToadRotationListChosenACLeft[3U],
            Soccer3::mFlameToadRotationListChosenACLeft[4U], Soccer3::mFlameToadRotationListChosenACLeft[5U],
            Soccer3::mFlameToadRotationListChosenACLeft[6U], Soccer3::mFlameToadRotationListChosenACLeft[7U]
        }},
        {"FlameToad ACRight", {
            Soccer3::mFlameToadRotationListChosenACRight[0U], Soccer3::mFlameToadRotationListChosenACRight[1U],
            Soccer3::mFlameToadRotationListChosenACRight[2U], Soccer3::mFlameToadRotationListChosenACRight[3U],
            Soccer3::mFlameToadRotationListChosenACRight[4U], Soccer3::mFlameToadRotationListChosenACRight[5U],
            Soccer3::mFlameToadRotationListChosenACRight[6U], Soccer3::mFlameToadRotationListChosenACRight[7U]
        }},
        {"FlameToad ADLeft", {
            Soccer3::mFlameToadRotationListChosenADLeft[0U], Soccer3::mFlameToadRotationListChosenADLeft[1U],
            Soccer3::mFlameToadRotationListChosenADLeft[2U], Soccer3::mFlameToadRotationListChosenADLeft[3U],
            Soccer3::mFlameToadRotationListChosenADLeft[4U], Soccer3::mFlameToadRotationListChosenADLeft[5U],
            Soccer3::mFlameToadRotationListChosenADLeft[6U], Soccer3::mFlameToadRotationListChosenADLeft[7U]
        }},
        {"FlameToad ADRight", {
            Soccer3::mFlameToadRotationListChosenADRight[0U], Soccer3::mFlameToadRotationListChosenADRight[1U],
            Soccer3::mFlameToadRotationListChosenADRight[2U], Soccer3::mFlameToadRotationListChosenADRight[3U],
            Soccer3::mFlameToadRotationListChosenADRight[4U], Soccer3::mFlameToadRotationListChosenADRight[5U],
            Soccer3::mFlameToadRotationListChosenADRight[6U], Soccer3::mFlameToadRotationListChosenADRight[7U]
        }},
        {"FlameToad BALeft", {
            Soccer3::mFlameToadRotationListChosenBALeft[0U], Soccer3::mFlameToadRotationListChosenBALeft[1U],
            Soccer3::mFlameToadRotationListChosenBALeft[2U], Soccer3::mFlameToadRotationListChosenBALeft[3U],
            Soccer3::mFlameToadRotationListChosenBALeft[4U], Soccer3::mFlameToadRotationListChosenBALeft[5U],
            Soccer3::mFlameToadRotationListChosenBALeft[6U], Soccer3::mFlameToadRotationListChosenBALeft[7U]
        }},
        {"FlameToad BARight", {
            Soccer3::mFlameToadRotationListChosenBARight[0U], Soccer3::mFlameToadRotationListChosenBARight[1U],
            Soccer3::mFlameToadRotationListChosenBARight[2U], Soccer3::mFlameToadRotationListChosenBARight[3U],
            Soccer3::mFlameToadRotationListChosenBARight[4U], Soccer3::mFlameToadRotationListChosenBARight[5U],
            Soccer3::mFlameToadRotationListChosenBARight[6U], Soccer3::mFlameToadRotationListChosenBARight[7U]
        }},
        {"FlameToad BBLeft", {
            Soccer3::mFlameToadRotationListChosenBBLeft[0U], Soccer3::mFlameToadRotationListChosenBBLeft[1U],
            Soccer3::mFlameToadRotationListChosenBBLeft[2U], Soccer3::mFlameToadRotationListChosenBBLeft[3U],
            Soccer3::mFlameToadRotationListChosenBBLeft[4U], Soccer3::mFlameToadRotationListChosenBBLeft[5U],
            Soccer3::mFlameToadRotationListChosenBBLeft[6U], Soccer3::mFlameToadRotationListChosenBBLeft[7U]
        }},
        {"FlameToad BBRight", {
            Soccer3::mFlameToadRotationListChosenBBRight[0U], Soccer3::mFlameToadRotationListChosenBBRight[1U],
            Soccer3::mFlameToadRotationListChosenBBRight[2U], Soccer3::mFlameToadRotationListChosenBBRight[3U],
            Soccer3::mFlameToadRotationListChosenBBRight[4U], Soccer3::mFlameToadRotationListChosenBBRight[5U],
            Soccer3::mFlameToadRotationListChosenBBRight[6U], Soccer3::mFlameToadRotationListChosenBBRight[7U]
        }},
        {"FlameToad BCLeft", {
            Soccer3::mFlameToadRotationListChosenBCLeft[0U], Soccer3::mFlameToadRotationListChosenBCLeft[1U],
            Soccer3::mFlameToadRotationListChosenBCLeft[2U], Soccer3::mFlameToadRotationListChosenBCLeft[3U],
            Soccer3::mFlameToadRotationListChosenBCLeft[4U], Soccer3::mFlameToadRotationListChosenBCLeft[5U],
            Soccer3::mFlameToadRotationListChosenBCLeft[6U], Soccer3::mFlameToadRotationListChosenBCLeft[7U]
        }},
        {"FlameToad BCRight", {
            Soccer3::mFlameToadRotationListChosenBCRight[0U], Soccer3::mFlameToadRotationListChosenBCRight[1U],
            Soccer3::mFlameToadRotationListChosenBCRight[2U], Soccer3::mFlameToadRotationListChosenBCRight[3U],
            Soccer3::mFlameToadRotationListChosenBCRight[4U], Soccer3::mFlameToadRotationListChosenBCRight[5U],
            Soccer3::mFlameToadRotationListChosenBCRight[6U], Soccer3::mFlameToadRotationListChosenBCRight[7U]
        }},
        {"FlameToad BDLeft", {
            Soccer3::mFlameToadRotationListChosenBDLeft[0U], Soccer3::mFlameToadRotationListChosenBDLeft[1U],
            Soccer3::mFlameToadRotationListChosenBDLeft[2U], Soccer3::mFlameToadRotationListChosenBDLeft[3U],
            Soccer3::mFlameToadRotationListChosenBDLeft[4U], Soccer3::mFlameToadRotationListChosenBDLeft[5U],
            Soccer3::mFlameToadRotationListChosenBDLeft[6U], Soccer3::mFlameToadRotationListChosenBDLeft[7U]
        }},
        {"FlameToad BDRight", {
            Soccer3::mFlameToadRotationListChosenBDRight[0U], Soccer3::mFlameToadRotationListChosenBDRight[1U],
            Soccer3::mFlameToadRotationListChosenBDRight[2U], Soccer3::mFlameToadRotationListChosenBDRight[3U],
            Soccer3::mFlameToadRotationListChosenBDRight[4U], Soccer3::mFlameToadRotationListChosenBDRight[5U],
            Soccer3::mFlameToadRotationListChosenBDRight[6U], Soccer3::mFlameToadRotationListChosenBDRight[7U]
        }},
    }};
}

bool ValidateRotationCollection(const RotationCollection &pCollection, const char *pName) {
    for (std::size_t aListIndex=0U; aListIndex<kRotationListCount; aListIndex++) {
        const RotationEightList &aList = pCollection.mLists[aListIndex];
        std::size_t aRotations[kRotationsPerList];
        bool aInRange = true;
        for (std::size_t aIndex=0U; aIndex<kRotationsPerList; aIndex++) {
            aRotations[aIndex] = aList.mRotations[aIndex];
            if (aRotations[aIndex] == 0U || aRotations[aIndex] >= RWIN_SIZE) { aInRange = false; }
        }
        if (!aInRange || !EightRotationValidator::Valid(aRotations, kRotationsPerList)) {
            std::printf("%s | %s | pack %zu/%zu (%s) | rotations=[%zu, %zu, %zu, %zu, %zu, %zu, %zu, %zu] | %s\n",
                        __func__, pName, aListIndex + 1U, kRotationListCount, aList.mName,
                        aRotations[0], aRotations[1], aRotations[2], aRotations[3],
                        aRotations[4], aRotations[5], aRotations[6], aRotations[7],
                        aInRange ? "EightRotationValidator::Valid(array, 8)=false, expected=true" :
                                   "window range check failed, expected 1...16383");
            std::fflush(stdout);
            return false;
        }
    }
    return true;
}

} // namespace

@interface RotationWindowCollisionTests : XCTestCase
@end

@implementation RotationWindowCollisionTests

- (void)test_WeakFive {
    constexpr std::size_t kTrialCount = 5U;
    constexpr std::size_t kPasswordLength = 8U;
    constexpr char kPasswordCharacters[] =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    static std::uint8_t aPlaintext[SOCCER_BLOCK_SIZE];
    static std::uint8_t aCiphertext[SOCCER_BLOCK_SIZE];
    RotationCollection aCollection{};

    for (std::size_t aTrial=0U; aTrial<kTrialCount; aTrial++) {
        std::uint8_t aPassword[kPasswordLength];
        for (std::size_t aIndex=0U; aIndex<kPasswordLength; aIndex++) {
            aPassword[aIndex] = static_cast<std::uint8_t>(
                kPasswordCharacters[Random::Get(static_cast<int>(sizeof(kPasswordCharacters) - 1U))]);
        }
        const std::uint64_t aNonce = Random::Get64();
        char aTrialName[256];
        std::snprintf(aTrialName, sizeof(aTrialName),
                      "%s | weak trial=%zu/%zu | password=%.*s | nonce=0x%016llX",
                      __PRETTY_FUNCTION__, aTrial + 1U, kTrialCount,
                      static_cast<int>(kPasswordLength), reinterpret_cast<const char *>(aPassword),
                      static_cast<unsigned long long>(aNonce));

        std::uint32_t aAckWord = 0U;
        if (!Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kWeak, aPassword, kPasswordLength,
                                        aNonce, &aAckWord, 0U, nullptr)) {
            XCTFail("%s | Soccer3::AttemptSeed_Encrypt failed.", aTrialName);
            return;
        }

        for (std::size_t aIndex=0U; aIndex<SOCCER_BLOCK_SIZE; aIndex++) {
            aPlaintext[aIndex] = Random::GetByte();
        }
        if (!Soccer3::EncryptBlock(aPlaintext, aCiphertext)) {
            XCTFail("%s | Soccer3::EncryptBlock failed.", aTrialName);
            return;
        }

        aCollection = GetRotationCollection();
        if (!ValidateRotationCollection(aCollection, aTrialName)) {
            XCTFail("%s | ValidateRotationCollection failed; see the list name and eight values above.", aTrialName);
            return;
        }
    }

    // One line after all five trials; examples come from the final seed.
    std::printf("%s | PASS | %zu weak encryptions | %zu eight-packs validated | final-trial examples:",
                __PRETTY_FUNCTION__, kTrialCount, kTrialCount * kRotationListCount);
    for (std::size_t aExample=0U; aExample<3U; aExample++) {
        const RotationEightList &aList = aCollection.mLists[aExample];
        std::printf(" %s=[%zu, %zu, %zu, %zu, %zu, %zu, %zu, %zu]%s",
                    aList.mName, aList.mRotations[0], aList.mRotations[1],
                    aList.mRotations[2], aList.mRotations[3], aList.mRotations[4],
                    aList.mRotations[5], aList.mRotations[6], aList.mRotations[7],
                    aExample < 2U ? " |" : "");
    }
    std::printf("\n");
    std::fflush(stdout);
}

- (void)test_SimpleCaseA {
    
    std::size_t aRotationA = 1;
    std::size_t aRotationB = RWIN_SIZE - 1;
    
    bool aResultA = EightRotationValidator::Valid(aRotationA, aRotationB);
    
    if (aResultA == true) {
        XCTFail("%s | case A | EightRotationValidator::Valid(A, B) | rotations=[A=%zu, B=%zu] | expected=false, actual=%s",
                __PRETTY_FUNCTION__, aRotationA, aRotationB, aResultA ? "true" : "false");
        return;
    }
    
    std::size_t aList[8];
    aList[0] = aRotationA;
    aList[1] = aRotationB;
    bool aResultB = EightRotationValidator::Valid(aList, 2);
    
    if (aResultB == true) {
        XCTFail("%s | case B | EightRotationValidator::Valid(array, 2) | rotations=[A=%zu, B=%zu] | expected=false, actual=%s",
                __PRETTY_FUNCTION__, aRotationA, aRotationB, aResultB ? "true" : "false");
        return;
    }
    
}

- (void)test_SimpleCaseB {
    
    std::size_t aRotationA = 1;
    std::size_t aRotationB = 2;
    
    bool aResultA = EightRotationValidator::Valid(aRotationA, aRotationB);
    
    if (aResultA == false) {
        XCTFail("%s | case A | EightRotationValidator::Valid(A, B) | rotations=[A=%zu, B=%zu] | expected=true, actual=%s",
                __PRETTY_FUNCTION__, aRotationA, aRotationB, aResultA ? "true" : "false");
        return;
    }
    
    std::size_t aList[8];
    aList[0] = aRotationA;
    aList[1] = aRotationB;
    bool aResultB = EightRotationValidator::Valid(aList, 2);
    
    if (aResultB == false) {
        XCTFail("%s | case B | EightRotationValidator::Valid(array, 2) | rotations=[A=%zu, B=%zu] | expected=true, actual=%s",
                __PRETTY_FUNCTION__, aRotationA, aRotationB, aResultB ? "true" : "false");
        return;
    }
}

- (void)test_SimpleCaseC {
    
    std::size_t aRotationA = 1;
    std::size_t aRotationB = 1;
    
    bool aResultA = EightRotationValidator::Valid(aRotationA, aRotationB);
    
    if (aResultA == true) {
        XCTFail("%s | case A | EightRotationValidator::Valid(A, B) | rotations=[A=%zu, B=%zu] | expected=false, actual=%s",
                __PRETTY_FUNCTION__, aRotationA, aRotationB, aResultA ? "true" : "false");
        return;
    }
    
    std::size_t aList[8];
    aList[0] = aRotationA;
    aList[1] = aRotationB;
    bool aResultB = EightRotationValidator::Valid(aList, 2);
    
    if (aResultB == true) {
        XCTFail("%s | case B | EightRotationValidator::Valid(array, 2) | rotations=[A=%zu, B=%zu] | expected=false, actual=%s",
                __PRETTY_FUNCTION__, aRotationA, aRotationB, aResultB ? "true" : "false");
        return;
    }
    
}

- (void)test_SimpleCaseD {
    
    std::size_t aRotationA = 0;
    std::size_t aRotationB = 1;
    
    bool aResultA = EightRotationValidator::Valid(aRotationA, aRotationB);
    
    if (aResultA == true) {
        XCTFail("%s | case A | EightRotationValidator::Valid(A, B) | rotations=[A=%zu, B=%zu] | expected=false, actual=%s",
                __PRETTY_FUNCTION__, aRotationA, aRotationB, aResultA ? "true" : "false");
        return;
    }
    
    std::size_t aList[8];
    aList[0] = aRotationA;
    aList[1] = aRotationB;
    bool aResultB = EightRotationValidator::Valid(aList, 2);
    
    if (aResultB == true) {
        XCTFail("%s | case B | EightRotationValidator::Valid(array, 2) | rotations=[A=%zu, B=%zu] | expected=false, actual=%s",
                __PRETTY_FUNCTION__, aRotationA, aRotationB, aResultB ? "true" : "false");
        return;
    }
}

- (void)test_SimpleCaseE {
    
    std::size_t aRotationA = 1;
    std::size_t aRotationB = 0;
    
    bool aResultA = EightRotationValidator::Valid(aRotationA, aRotationB);
    
    if (aResultA == true) {
        XCTFail("%s | case A | EightRotationValidator::Valid(A, B) | rotations=[A=%zu, B=%zu] | expected=false, actual=%s",
                __PRETTY_FUNCTION__, aRotationA, aRotationB, aResultA ? "true" : "false");
        return;
    }
    
    std::size_t aList[8];
    aList[0] = aRotationA;
    aList[1] = aRotationB;
    bool aResultB = EightRotationValidator::Valid(aList, 2);
    
    if (aResultB == true) {
        XCTFail("%s | case B | EightRotationValidator::Valid(array, 2) | rotations=[A=%zu, B=%zu] | expected=false, actual=%s",
                __PRETTY_FUNCTION__, aRotationA, aRotationB, aResultB ? "true" : "false");
        return;
    }
}

- (void)test_SimpleCaseF {
    
    std::size_t aRotationA = 0;
    std::size_t aRotationB = 0;
    
    bool aResultA = EightRotationValidator::Valid(aRotationA, aRotationB);
    
    if (aResultA == true) {
        XCTFail("%s | case A | EightRotationValidator::Valid(A, B) | rotations=[A=%zu, B=%zu] | expected=false, actual=%s",
                __PRETTY_FUNCTION__, aRotationA, aRotationB, aResultA ? "true" : "false");
        return;
    }
    
    std::size_t aList[8];
    aList[0] = aRotationA;
    aList[1] = aRotationB;
    bool aResultB = EightRotationValidator::Valid(aList, 2);
    
    if (aResultB == true) {
        XCTFail("%s | case B | EightRotationValidator::Valid(array, 2) | rotations=[A=%zu, B=%zu] | expected=false, actual=%s",
                __PRETTY_FUNCTION__, aRotationA, aRotationB, aResultB ? "true" : "false");
        return;
    }
}

- (void)test_Combos_2 {
    std::size_t aList[8];
    for (std::int32_t aRotationA=0; aRotationA<16384;aRotationA++) {
        for (std::int32_t aRotationB=0; aRotationB<16384;aRotationB++) {
            bool aResultA = EightRotationValidator::Valid(aRotationA, aRotationB);
            aList[0] = aRotationA;
            aList[1] = aRotationB;
            bool aResultB = EightRotationValidator::Valid(aList, 2);
            if (aResultA != aResultB) {
                XCTFail("%s | 2-rotation comparison | rotations=[A=%zu, B=%zu] | "
                            "EightRotationValidator::Valid(A, B)=%s | EightRotationValidator::Valid(array, 2)=%s",
                            __PRETTY_FUNCTION__, static_cast<std::size_t>(aRotationA), static_cast<std::size_t>(aRotationB),
                            aResultA ? "true" : "false", aResultB ? "true" : "false");
                return;
            }
        }
    }
}

- (void)test_Combos_3 {
    std::size_t aList[8];
    for (std::int32_t aRotationA=0; aRotationA<648;aRotationA++) {
        for (std::int32_t aRotationB=0; aRotationB<648;aRotationB++) {
            for (std::int32_t aRotationC=0; aRotationC<648;aRotationC++) {
                bool aResultA = EightRotationValidator::Valid(aRotationA, aRotationB, aRotationC);
                aList[0] = aRotationA;
                aList[1] = aRotationB;
                aList[2] = aRotationC;
                
                bool aResultB = EightRotationValidator::Valid(aList, 3);
                if (aResultA != aResultB) {
                    XCTFail("%s | 3-rotation comparison | rotations=[A=%zu, B=%zu, C=%zu] | "
                                "EightRotationValidator::Valid(A, B, C)=%s | EightRotationValidator::Valid(array, 3)=%s",
                                __PRETTY_FUNCTION__, static_cast<std::size_t>(aRotationA), static_cast<std::size_t>(aRotationB), static_cast<std::size_t>(aRotationC),
                                aResultA ? "true" : "false", aResultB ? "true" : "false");
                    return;
                }
            }
        }
    }
}

- (void)test_Combos_4 {
    std::size_t aList[8];
    for (std::int32_t aRotationA=0; aRotationA<128;aRotationA++) {
        for (std::int32_t aRotationB=0; aRotationB<128;aRotationB++) {
            for (std::int32_t aRotationC=0; aRotationC<128;aRotationC++) {
                for (std::int32_t aRotationD=0; aRotationD<128;aRotationD++) {
                    bool aResultA = EightRotationValidator::Valid(aRotationA, aRotationB, aRotationC, aRotationD);
                    aList[0] = aRotationA;
                    aList[1] = aRotationB;
                    aList[2] = aRotationC;
                    aList[3] = aRotationD;
                    
                    bool aResultB = EightRotationValidator::Valid(aList, 4);
                    if (aResultA != aResultB) {
                        XCTFail("%s | 4-rotation comparison | rotations=[A=%zu, B=%zu, C=%zu, D=%zu] | "
                                    "EightRotationValidator::Valid(A, B, C, D)=%s | EightRotationValidator::Valid(array, 4)=%s",
                                    __PRETTY_FUNCTION__, static_cast<std::size_t>(aRotationA), static_cast<std::size_t>(aRotationB), static_cast<std::size_t>(aRotationC), static_cast<std::size_t>(aRotationD),
                                    aResultA ? "true" : "false", aResultB ? "true" : "false");
                        return;
                    }
                }
            }
        }
    }
}


@end
