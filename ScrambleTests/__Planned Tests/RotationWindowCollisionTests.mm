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

constexpr std::size_t kRotationPackCount = 18U;
constexpr std::size_t kRotationsPerPack = 8U;
static_assert(kRotationPackCount == WindowRotationFarm::kJobCount);
static_assert(kRotationsPerPack == WindowRotationFarm::kRotationsPerJob);

struct RotationEightPack {
    const char *mName;
    std::size_t mRotations[kRotationsPerPack];
};

struct RotationCollection {
    RotationEightPack mPacks[kRotationPackCount];
};

// Soccer must already be seeded. Copy the eighteen bounded farm jobs directly
// from the stored pack, including FREE WINDOW indices before byte offsets.
RotationCollection GetRotationCollection() {
    const WindowRotationPack &aPack = Soccer3::mWindowRotationPack;
    return {{
        {"plane A / free windows", {
            aPack.mPlaneA.mChunkA.mWindowFreeA, aPack.mPlaneA.mChunkA.mWindowFreeB,
            aPack.mPlaneA.mChunkB.mWindowFreeA, aPack.mPlaneA.mChunkB.mWindowFreeB,
            aPack.mPlaneA.mChunkC.mWindowFreeA, aPack.mPlaneA.mChunkC.mWindowFreeB,
            aPack.mPlaneA.mChunkD.mWindowFreeA, aPack.mPlaneA.mChunkD.mWindowFreeB
        }},
        {"plane A / chunk A / windows A-H", {
            aPack.mPlaneA.mChunkA.mWindowA, aPack.mPlaneA.mChunkA.mWindowB,
            aPack.mPlaneA.mChunkA.mWindowC, aPack.mPlaneA.mChunkA.mWindowD,
            aPack.mPlaneA.mChunkA.mWindowE, aPack.mPlaneA.mChunkA.mWindowF,
            aPack.mPlaneA.mChunkA.mWindowG, aPack.mPlaneA.mChunkA.mWindowH
        }},
        {"plane A / chunk A / windows I-P", {
            aPack.mPlaneA.mChunkA.mWindowI, aPack.mPlaneA.mChunkA.mWindowJ,
            aPack.mPlaneA.mChunkA.mWindowK, aPack.mPlaneA.mChunkA.mWindowL,
            aPack.mPlaneA.mChunkA.mWindowM, aPack.mPlaneA.mChunkA.mWindowN,
            aPack.mPlaneA.mChunkA.mWindowO, aPack.mPlaneA.mChunkA.mWindowP
        }},
        {"plane A / chunk B / windows A-H", {
            aPack.mPlaneA.mChunkB.mWindowA, aPack.mPlaneA.mChunkB.mWindowB,
            aPack.mPlaneA.mChunkB.mWindowC, aPack.mPlaneA.mChunkB.mWindowD,
            aPack.mPlaneA.mChunkB.mWindowE, aPack.mPlaneA.mChunkB.mWindowF,
            aPack.mPlaneA.mChunkB.mWindowG, aPack.mPlaneA.mChunkB.mWindowH
        }},
        {"plane A / chunk B / windows I-P", {
            aPack.mPlaneA.mChunkB.mWindowI, aPack.mPlaneA.mChunkB.mWindowJ,
            aPack.mPlaneA.mChunkB.mWindowK, aPack.mPlaneA.mChunkB.mWindowL,
            aPack.mPlaneA.mChunkB.mWindowM, aPack.mPlaneA.mChunkB.mWindowN,
            aPack.mPlaneA.mChunkB.mWindowO, aPack.mPlaneA.mChunkB.mWindowP
        }},
        {"plane A / chunk C / windows A-H", {
            aPack.mPlaneA.mChunkC.mWindowA, aPack.mPlaneA.mChunkC.mWindowB,
            aPack.mPlaneA.mChunkC.mWindowC, aPack.mPlaneA.mChunkC.mWindowD,
            aPack.mPlaneA.mChunkC.mWindowE, aPack.mPlaneA.mChunkC.mWindowF,
            aPack.mPlaneA.mChunkC.mWindowG, aPack.mPlaneA.mChunkC.mWindowH
        }},
        {"plane A / chunk C / windows I-P", {
            aPack.mPlaneA.mChunkC.mWindowI, aPack.mPlaneA.mChunkC.mWindowJ,
            aPack.mPlaneA.mChunkC.mWindowK, aPack.mPlaneA.mChunkC.mWindowL,
            aPack.mPlaneA.mChunkC.mWindowM, aPack.mPlaneA.mChunkC.mWindowN,
            aPack.mPlaneA.mChunkC.mWindowO, aPack.mPlaneA.mChunkC.mWindowP
        }},
        {"plane A / chunk D / windows A-H", {
            aPack.mPlaneA.mChunkD.mWindowA, aPack.mPlaneA.mChunkD.mWindowB,
            aPack.mPlaneA.mChunkD.mWindowC, aPack.mPlaneA.mChunkD.mWindowD,
            aPack.mPlaneA.mChunkD.mWindowE, aPack.mPlaneA.mChunkD.mWindowF,
            aPack.mPlaneA.mChunkD.mWindowG, aPack.mPlaneA.mChunkD.mWindowH
        }},
        {"plane A / chunk D / windows I-P", {
            aPack.mPlaneA.mChunkD.mWindowI, aPack.mPlaneA.mChunkD.mWindowJ,
            aPack.mPlaneA.mChunkD.mWindowK, aPack.mPlaneA.mChunkD.mWindowL,
            aPack.mPlaneA.mChunkD.mWindowM, aPack.mPlaneA.mChunkD.mWindowN,
            aPack.mPlaneA.mChunkD.mWindowO, aPack.mPlaneA.mChunkD.mWindowP
        }},
        {"plane B / free windows", {
            aPack.mPlaneB.mChunkA.mWindowFreeA, aPack.mPlaneB.mChunkA.mWindowFreeB,
            aPack.mPlaneB.mChunkB.mWindowFreeA, aPack.mPlaneB.mChunkB.mWindowFreeB,
            aPack.mPlaneB.mChunkC.mWindowFreeA, aPack.mPlaneB.mChunkC.mWindowFreeB,
            aPack.mPlaneB.mChunkD.mWindowFreeA, aPack.mPlaneB.mChunkD.mWindowFreeB
        }},
        {"plane B / chunk A / windows A-H", {
            aPack.mPlaneB.mChunkA.mWindowA, aPack.mPlaneB.mChunkA.mWindowB,
            aPack.mPlaneB.mChunkA.mWindowC, aPack.mPlaneB.mChunkA.mWindowD,
            aPack.mPlaneB.mChunkA.mWindowE, aPack.mPlaneB.mChunkA.mWindowF,
            aPack.mPlaneB.mChunkA.mWindowG, aPack.mPlaneB.mChunkA.mWindowH
        }},
        {"plane B / chunk A / windows I-P", {
            aPack.mPlaneB.mChunkA.mWindowI, aPack.mPlaneB.mChunkA.mWindowJ,
            aPack.mPlaneB.mChunkA.mWindowK, aPack.mPlaneB.mChunkA.mWindowL,
            aPack.mPlaneB.mChunkA.mWindowM, aPack.mPlaneB.mChunkA.mWindowN,
            aPack.mPlaneB.mChunkA.mWindowO, aPack.mPlaneB.mChunkA.mWindowP
        }},
        {"plane B / chunk B / windows A-H", {
            aPack.mPlaneB.mChunkB.mWindowA, aPack.mPlaneB.mChunkB.mWindowB,
            aPack.mPlaneB.mChunkB.mWindowC, aPack.mPlaneB.mChunkB.mWindowD,
            aPack.mPlaneB.mChunkB.mWindowE, aPack.mPlaneB.mChunkB.mWindowF,
            aPack.mPlaneB.mChunkB.mWindowG, aPack.mPlaneB.mChunkB.mWindowH
        }},
        {"plane B / chunk B / windows I-P", {
            aPack.mPlaneB.mChunkB.mWindowI, aPack.mPlaneB.mChunkB.mWindowJ,
            aPack.mPlaneB.mChunkB.mWindowK, aPack.mPlaneB.mChunkB.mWindowL,
            aPack.mPlaneB.mChunkB.mWindowM, aPack.mPlaneB.mChunkB.mWindowN,
            aPack.mPlaneB.mChunkB.mWindowO, aPack.mPlaneB.mChunkB.mWindowP
        }},
        {"plane B / chunk C / windows A-H", {
            aPack.mPlaneB.mChunkC.mWindowA, aPack.mPlaneB.mChunkC.mWindowB,
            aPack.mPlaneB.mChunkC.mWindowC, aPack.mPlaneB.mChunkC.mWindowD,
            aPack.mPlaneB.mChunkC.mWindowE, aPack.mPlaneB.mChunkC.mWindowF,
            aPack.mPlaneB.mChunkC.mWindowG, aPack.mPlaneB.mChunkC.mWindowH
        }},
        {"plane B / chunk C / windows I-P", {
            aPack.mPlaneB.mChunkC.mWindowI, aPack.mPlaneB.mChunkC.mWindowJ,
            aPack.mPlaneB.mChunkC.mWindowK, aPack.mPlaneB.mChunkC.mWindowL,
            aPack.mPlaneB.mChunkC.mWindowM, aPack.mPlaneB.mChunkC.mWindowN,
            aPack.mPlaneB.mChunkC.mWindowO, aPack.mPlaneB.mChunkC.mWindowP
        }},
        {"plane B / chunk D / windows A-H", {
            aPack.mPlaneB.mChunkD.mWindowA, aPack.mPlaneB.mChunkD.mWindowB,
            aPack.mPlaneB.mChunkD.mWindowC, aPack.mPlaneB.mChunkD.mWindowD,
            aPack.mPlaneB.mChunkD.mWindowE, aPack.mPlaneB.mChunkD.mWindowF,
            aPack.mPlaneB.mChunkD.mWindowG, aPack.mPlaneB.mChunkD.mWindowH
        }},
        {"plane B / chunk D / windows I-P", {
            aPack.mPlaneB.mChunkD.mWindowI, aPack.mPlaneB.mChunkD.mWindowJ,
            aPack.mPlaneB.mChunkD.mWindowK, aPack.mPlaneB.mChunkD.mWindowL,
            aPack.mPlaneB.mChunkD.mWindowM, aPack.mPlaneB.mChunkD.mWindowN,
            aPack.mPlaneB.mChunkD.mWindowO, aPack.mPlaneB.mChunkD.mWindowP
        }},
    }};
}

bool ValidateRotationCollection(const RotationCollection &pCollection, const char *pName) {
    for (std::size_t aPackIndex=0U; aPackIndex<kRotationPackCount; aPackIndex++) {
        const RotationEightPack &aPack = pCollection.mPacks[aPackIndex];
        std::size_t aRotations[kRotationsPerPack];
        bool aInRange = true;
        for (std::size_t aIndex=0U; aIndex<kRotationsPerPack; aIndex++) {
            aRotations[aIndex] = aPack.mRotations[aIndex];
            if (aRotations[aIndex] == 0U || aRotations[aIndex] >= RWIN_SIZE) { aInRange = false; }
        }
        if (!aInRange || !EightRotationValidator::Valid(aRotations, kRotationsPerPack)) {
            std::printf("%s | %s | pack %zu/%zu (%s) | rotations=[%zu, %zu, %zu, %zu, %zu, %zu, %zu, %zu] | %s\n",
                        __func__, pName, aPackIndex + 1U, kRotationPackCount, aPack.mName,
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
            XCTFail("%s | ValidateRotationCollection failed; see the pack name and eight values above.", aTrialName);
            return;
        }
    }

    // One line after all five trials; examples come from the final seed.
    std::printf("%s | PASS | %zu weak encryptions | %zu eight-packs validated | final-trial examples:",
                __PRETTY_FUNCTION__, kTrialCount, kTrialCount * kRotationPackCount);
    for (std::size_t aExample=0U; aExample<3U; aExample++) {
        const RotationEightPack &aPack = aCollection.mPacks[aExample];
        std::printf(" %s=[%zu, %zu, %zu, %zu, %zu, %zu, %zu, %zu]%s",
                    aPack.mName, aPack.mRotations[0], aPack.mRotations[1],
                    aPack.mRotations[2], aPack.mRotations[3], aPack.mRotations[4],
                    aPack.mRotations[5], aPack.mRotations[6], aPack.mRotations[7],
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
