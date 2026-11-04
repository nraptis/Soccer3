//
//  GutCheckValidator.hpp
//  ScrambleTests
//
//  Created by Icarus Black on 8/9/26.
//

#ifndef GutCheckValidator_hpp
#define GutCheckValidator_hpp

#include "Random.hpp"
#include "Soccer3.hpp"
#include "WorkSpaceTools.hpp"

#include <cstddef>
#include <cstdint>
#include <functional>
#include <vector>

struct GutCheckAvalancheScore {
    std::size_t mDifferentBytes = 0U;
    std::size_t mDifferentBits = 0U;
};

struct BytePointerListHash {
    std::size_t operator()(const std::vector<std::uint8_t *> &pList) const noexcept {
        std::size_t aHash = 0U;

        for (std::uint8_t *aPointer : pList) {
            const std::size_t aPointerHash =
                std::hash<std::uint8_t *>{}(aPointer);

            aHash ^= aPointerHash +
                     0x9E3779B97F4A7C15ULL +
                     (aHash << 6U) +
                     (aHash >> 2U);
        }

        return aHash;
    }
};

struct ByteListHash {
    std::size_t operator()(const std::vector<std::uint8_t> &pData) const noexcept {
        std::size_t aHash = 1469598103934665603ULL;

        for (std::uint8_t aByte : pData) {
            aHash ^= static_cast<std::size_t>(aByte);
            aHash *= 1099511628211ULL;
        }

        return aHash;
    }
};

struct SizeHash {
    std::size_t operator()(const std::vector<std::size_t> &pData) const noexcept {
        std::size_t aHash = 0U;

        for (std::size_t aValue : pData) {
            const std::size_t aValueHash = std::hash<std::size_t>{}(aValue);
            aHash ^= aValueHash +
                     0x9E3779B97F4A7C15ULL +
                     (aHash << 6U) +
                     (aHash >> 2U);
        }

        return aHash;
    }
};

struct LongLongHash {
    std::size_t operator()(const std::vector<std::uint64_t> &pData) const noexcept {
        std::size_t aHash = 0U;

        for (std::uint64_t aValue : pData) {
            const std::size_t aValueHash = std::hash<std::uint64_t>{}(aValue);
            aHash ^= aValueHash +
                     0x9E3779B97F4A7C15ULL +
                     (aHash << 6U) +
                     (aHash >> 2U);
        }

        return aHash;
    }
};

class GutCheckValidator {
    
public:
    
    static bool                     Validate(const char *pTestName,
                                             EncryptionStrength pStrength,
                                             std::uint8_t *pPassword,
                                             std::size_t pPasswordByteLength,
                                             std::uint64_t pNonce);
    
    static bool                     ValidatePostSeed(const char *pTestName,
                                                     EncryptionStrength pStrength);
    
    
    static bool                     ValidateMaterials(const char *pTestName,
                                                      EncryptionStrength pStrength);
    // static bool                  ValidateSeedIndices(const char *pTestName);
    static bool                     ValidateMask(const char *pTestName);
    // static bool                  ValidateRotation(const char *pTestName);
    
    static GutCheckAvalancheScore   ScoreBuffers(const std::uint8_t *pBufferA,
                                                 const std::uint8_t *pBufferB);
    
    
};

#endif /* GutCheckValidator_hpp */
