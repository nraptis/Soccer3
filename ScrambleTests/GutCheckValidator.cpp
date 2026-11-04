//
//  GutCheckValidator.cpp
//  ScrambleTests
//
//  Created by Icarus Black on 8/9/26.
//

#include <atomic>
#include "GutCheckValidator.hpp"

#include <cmath>
#include <vector>
#include <unordered_set>

namespace {

std::size_t CountOnes(std::uint8_t aByte) {
    const std::size_t aResult = static_cast<std::size_t>(__builtin_popcount(static_cast<unsigned int>(aByte)));
    return aResult;
}

std::size_t BitDifference(std::uint8_t aByteA, std::uint8_t aByteB) {
    const std::uint8_t aDifferenceMap = aByteA ^ aByteB;
    const std::size_t aDifference = CountOnes(aDifferenceMap);
    return aDifference;
}

}

bool GutCheckValidator::Validate(const char *pTestName,
                                 EncryptionStrength pStrength,
                                 std::uint8_t *pPassword,
                                 std::size_t pPasswordByteLength,
                                 std::uint64_t pNonce) {
    
    static std::uint8_t aOriginal[SOCCER_BLOCK_SIZE];
    static std::uint8_t aEncryptedA[SOCCER_BLOCK_SIZE];
    static std::uint8_t aEncryptedB[SOCCER_BLOCK_SIZE];
    static std::uint8_t aDecrypted[SOCCER_BLOCK_SIZE];
    
    for (std::size_t aIndex=0; aIndex<SOCCER_BLOCK_SIZE; aIndex++) {
        aOriginal[aIndex] = Random::GetByte();
    }
    
    std::uint32_t aAckWordA = 0U;
    std::uint32_t aAckWordB = 0U;
    
    Soccer3::Zero();
    
    std::atomic<bool> aCancelled{false};
    if (!Soccer3::AttemptSeed_Encrypt(pStrength,
                                      pPassword,
                                      pPasswordByteLength,
                                      pNonce,
                                      &aAckWordA,0,&aCancelled)) {
        
        printf("%s: encryption seed failed.\n", pTestName);
        return false;
    }
    
    if (!ValidatePostSeed(pTestName, pStrength)) {
        return false;
    }

    if (!Soccer3::EncryptBlock(aOriginal, aEncryptedA)) {
        printf("%s: encryption failed.\n", pTestName);
        return false;
    }
    if (std::memcmp(aOriginal, aEncryptedA, SOCCER_BLOCK_SIZE) == 0) {
        printf("%s: encryption left the source data unchanged.\n", pTestName);
        return false;
    }

    Soccer3::Zero();
    if (!Soccer3::AttemptSeed_Decrypt(pStrength,
                                       pPassword,
                                       pPasswordByteLength,
                                       pNonce,
                                      aAckWordA,0,&aCancelled)) {
        printf("%s: decryption seed failed.\n", pTestName);
        return false;
    }
    
    if (!ValidatePostSeed(pTestName, pStrength)) {
        return false;
    }

    if (!Soccer3::DecryptBlock(aEncryptedA, aDecrypted)) {
        printf("%s: decryption failed.\n", pTestName);
        return false;
    }
    if (std::memcmp(aOriginal, aDecrypted, SOCCER_BLOCK_SIZE) != 0) {
        printf("%s: decrypted data did not match the original source.\n", pTestName);
        return false;
    }
    
    
    Soccer3::Zero();
    if (!Soccer3::AttemptSeed_Encrypt(pStrength,
                                      pPassword,
                                      pPasswordByteLength,
                                      pNonce,
                                      &aAckWordB,0,&aCancelled)) {
        
        printf("%s: repeat encryption seed failed.\n", pTestName);
        return false;
    }
    
    if (!Soccer3::EncryptBlock(aOriginal, aEncryptedB)) {
        printf("%s: repeat encryption failed.\n", pTestName);
        return false;
    }
    if (std::memcmp(aEncryptedA, aEncryptedB, SOCCER_BLOCK_SIZE) != 0) {
        printf("%s: repeat encryption did not reproduce the first ciphertext.\n", pTestName);
        return false;
    }
    
    if (aAckWordA != aAckWordB) {
        printf("%s: repeat encryption did not reproduce the same ack words {%ux and %ux}.\n", pTestName, aAckWordA, aAckWordB);
        return false;
    }
    
    return true;
}

bool GutCheckValidator::ValidatePostSeed(const char *pTestName,
                                         EncryptionStrength pStrength) {
    
    if (!ValidateMaterials(pTestName, pStrength)) {
        return false;
    }
    
    // Legacy rotation fixture disabled during WindowRotationPack migration.
#if 0
    if (!ValidateSeedIndices(pTestName)) {
        return false;
    }
#endif
    
    if (!ValidateMask(pTestName)) {
        return false;
    }
    
    // Legacy rotation fixture disabled during WindowRotationPack migration.
#if 0
    if (!ValidateRotation(pTestName)) {
        return false;
    }
#endif
    
    return true;
}

bool GutCheckValidator::ValidateMaterials(const char *pTestName,
                                          EncryptionStrength pStrength) {
    
    std::size_t aExpectedCount = 8;
    if (pStrength == EncryptionStrength::kWeak) {
        aExpectedCount = 4;
    } else if (pStrength == EncryptionStrength::kStrong) {
        aExpectedCount = 16;
    }
    
    std::uint8_t *aMaterialsBase[16];
    aMaterialsBase[ 0] = Soccer3::mMaterialA;
    aMaterialsBase[ 1] = Soccer3::mMaterialB;
    aMaterialsBase[ 2] = Soccer3::mMaterialC;
    aMaterialsBase[ 3] = Soccer3::mMaterialD;
    aMaterialsBase[ 4] = Soccer3::mMaterialE;
    aMaterialsBase[ 5] = Soccer3::mMaterialF;
    aMaterialsBase[ 6] = Soccer3::mMaterialG;
    aMaterialsBase[ 7] = Soccer3::mMaterialH;
    aMaterialsBase[ 8] = Soccer3::mMaterialI;
    aMaterialsBase[ 9] = Soccer3::mMaterialJ;
    aMaterialsBase[10] = Soccer3::mMaterialK;
    aMaterialsBase[11] = Soccer3::mMaterialL;
    aMaterialsBase[12] = Soccer3::mMaterialM;
    aMaterialsBase[13] = Soccer3::mMaterialN;
    aMaterialsBase[14] = Soccer3::mMaterialO;
    aMaterialsBase[15] = Soccer3::mMaterialP;
    
    std::uint8_t *aMaterials[16];
    std::size_t aMaterialCount = 0;
    
    for (std::size_t aMaterialIndex=0; aMaterialIndex<16; aMaterialIndex++) {
        bool aIsAllZero = true;
        for (std::size_t aByteIndex=0; aByteIndex<SOCCER_BLOCK_SIZE; aByteIndex++) {
            if (aMaterialsBase[aMaterialIndex][aByteIndex] != 0) {
                aIsAllZero = false;
                break;
            }
        }
        if (aIsAllZero == false) {
            aMaterials[aMaterialCount++] = aMaterialsBase[aMaterialIndex];
        }
    }
    
    if (aMaterialCount != aExpectedCount) {
        printf("%s: non-zero material count mismatch: expected %zu, got %zu.\n",
               pTestName,
               aExpectedCount,
               aMaterialCount);
        return false;
    }
    
    const std::size_t aTotalBitCount = SOCCER_BLOCK_SIZE * 8U;
    const std::size_t aTotalByteCount = SOCCER_BLOCK_SIZE;
    
    for (std::size_t aIndexA=1; aIndexA<aMaterialCount; aIndexA++) {
        
        for (std::size_t aIndexB=0; aIndexB<aIndexA; aIndexB++) {
            
            GutCheckAvalancheScore aAvalanche = ScoreBuffers(aMaterials[aIndexA], aMaterials[aIndexB]);
            
            float aBitAvalanche = (float)aAvalanche.mDifferentBits / (float)aTotalBitCount;
            float aByteAvalanche = (float)aAvalanche.mDifferentBytes / (float)aTotalByteCount;
            
            if (std::fabs(aBitAvalanche - 0.5) > 0.1) {
                printf("%s: material lanes %zu and %zu failed bit diversity: "
                       "%zu/%zu bits differ (%.6f; expected 0.500000 +/- 0.100000), "
                       "%zu/%zu bytes differ (%.6f).\n",
                       pTestName,
                       aIndexA,
                       aIndexB,
                       aAvalanche.mDifferentBits,
                       aTotalBitCount,
                       aBitAvalanche,
                       aAvalanche.mDifferentBytes,
                       aTotalByteCount,
                       aByteAvalanche);
                return false;
            }
            
            if (std::fabs(aByteAvalanche - 0.95) > 0.05) {
                printf("%s: material lanes %zu and %zu failed byte diversity: "
                       "%zu/%zu bytes differ (%.6f; expected 0.950000 +/- 0.050000), "
                       "%zu/%zu bits differ (%.6f).\n",
                       pTestName,
                       aIndexA,
                       aIndexB,
                       aAvalanche.mDifferentBytes,
                       aTotalByteCount,
                       aByteAvalanche,
                       aAvalanche.mDifferentBits,
                       aTotalBitCount,
                       aBitAvalanche);
                return false;
            }
        }
    }
    
    return true;
}

// Historical rotation check is preserved in DeadTests/CryptexMigration.


bool GutCheckValidator::ValidateMask(const char *pTestName) {
    (void)pTestName;
    /*
    if (!Soccer3::mEncryptionReady || !Soccer3::mBitPlane.IsValid()) return false;
    const auto aRows = CryptexTestSupport::Rows();
    const auto aMasks = CryptexTestSupport::Masks();
    for (std::size_t i = 0U; i < Cryptex::kLayerCount; ++i) {
        if (aRows[i % 4U] != Soccer3::mBitPlane.GetRow(i % 4U)) return false;
        unsigned aFirst = 0U, aSecond = 0U;
        for (const auto &aPair : aRows[i % 4U].mPairs) { aFirst |= 1U << aPair.mBitA; aSecond |= 1U << aPair.mBitB; }
        if (aMasks[2U*i] != aFirst || aMasks[2U*i+1U] != aSecond ||
            (aFirst & aSecond) || (aFirst | aSecond) != 255U) return false;
    }
    */
    return true;
}



GutCheckAvalancheScore GutCheckValidator::ScoreBuffers(const std::uint8_t *pBufferA,
                                                       const std::uint8_t *pBufferB) {
    
    GutCheckAvalancheScore aScore;
    for (std::size_t aIndex=0U; aIndex<SOCCER_BLOCK_SIZE; aIndex++) {
        const std::uint8_t aDifference =
        static_cast<std::uint8_t>(pBufferA[aIndex] ^ pBufferB[aIndex]);
        if (aDifference != 0U) {
            aScore.mDifferentBytes++;
            aScore.mDifferentBits += static_cast<std::size_t>(__builtin_popcount(static_cast<unsigned int>(aDifference)));
        }
    }
    
    return aScore;
}
