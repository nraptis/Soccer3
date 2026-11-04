//
//  CipherGauntlet.cpp
//  HolyStorms
//
//  Created by icarus black on 7/2/26.
//

#include "CipherGauntlet.hpp"
#include "PrintExamplesHelper.hpp"
#include "Random.hpp"
#include "TestConstants.hpp"

namespace {

void PrintExpectingSuccessFailure(const std::string &pFunction,
                                  const std::string &pName,
                                  const std::string &pReason) {
    printf("%s failed on %s, %s.\n",
           pFunction.c_str(),
           pName.c_str(),
           pReason.c_str());
}

void PrintExpectingSuccessError(const std::string &pFunction,
                                const std::string &pName,
                                const CipherErrorCode pErrorCode) {
    printf("%s failed on %s, error code %u.\n",
           pFunction.c_str(),
           pName.c_str(),
           static_cast<std::uint32_t>(pErrorCode));
}

void PrintExpectingFailureSuccess(const std::string &pFunction,
                                  const std::string &pName,
                                  const std::string &pReason) {
    printf("%s succeeded (expecting failure) on %s, %s.\n",
           pFunction.c_str(),
           pName.c_str(),
           pReason.c_str());
}

void PrintExpectingFailureError(const std::string &pFunction,
                                const std::string &pName,
                                const CipherErrorCode pErrorCode) {
    printf("%s failed (expecting failure) on %s, error code %u.\n",
           pFunction.c_str(),
           pName.c_str(),
           static_cast<std::uint32_t>(pErrorCode));
}

void PrintMatchWindow(const std::uint8_t *pOriginal,
                      const std::uint8_t *pUnencrypted,
                      const std::size_t pSize,
                      const std::size_t pIndex) {
    constexpr std::size_t kWindowSize = 64u;
    const std::size_t aStart = pIndex > kWindowSize ? pIndex - kWindowSize : 0u;
    const std::size_t aEnd = pIndex + kWindowSize + 1u < pSize
                                 ? pIndex + kWindowSize + 1u
                                 : pSize;
    const std::size_t aLength = aEnd - aStart;
    
    printf("Matches failed.\n");
    printf("Mismatch index: %zu\n", pIndex);
    printf("Window: [%zu, %zu]\n", aStart, aEnd == 0u ? 0u : aEnd - 1u);
    printf("Original: %s\n",
           PrintExamplesHelper::HexArray(pOriginal + aStart, aLength).c_str());
    printf("Unencrypted: %s\n",
           PrintExamplesHelper::HexArray(pUnencrypted + aStart, aLength).c_str());
}

}  // namespace

void CipherGauntlet::RandomizeSource(std::size_t pSize, std::size_t pIndex) {
    
    if (pSize > SOCCER_BLOCK_SIZE) {
        pSize = SOCCER_BLOCK_SIZE;
    }
    
    if (pIndex == 0) {
        memset(mSource, 0x00, pSize);
    }
    
    if (pIndex == 1) {
        memset(mSource, 0xFF, pSize);
    }
    
    std::size_t aCount64 = pSize / sizeof(std::uint64_t);
    
    std::uint64_t *aSource64 = reinterpret_cast<std::uint64_t *>(mSource);
    for (std::size_t i = 0; i < aCount64; i++) {
        aSource64[i] = Random::Get64();
    }
    
    std::size_t aIndex = aCount64 * sizeof(std::uint64_t);
    while (aIndex < pSize) {
        mSource[aIndex] = Random::GetByte();
        aIndex++;
    }
}

void CipherGauntlet::ArrayRandomize(std::uint8_t *pData, std::size_t pSize) {
    if (pSize > SOCCER_BLOCK_SIZE) {
        pSize = SOCCER_BLOCK_SIZE;
    }
    
    std::size_t aCount64 = pSize / sizeof(std::uint64_t);
    
    std::uint64_t *aSource64 = reinterpret_cast<std::uint64_t *>(pData);
    for (std::size_t i = 0; i < aCount64; i++) {
        aSource64[i] = Random::Get64();
    }
    
    std::size_t aIndex = aCount64 * sizeof(std::uint64_t);
    while (aIndex < pSize) {
        pData[aIndex] = Random::GetByte();
        aIndex++;
    }
}

void CipherGauntlet::ArrayZero(std::uint8_t *pData, std::size_t pSize) {
    if (pSize > SOCCER_BLOCK_SIZE) {
        pSize = SOCCER_BLOCK_SIZE;
    }
    memset(pData, 0x00, pSize);
}

void CipherGauntlet::ArrayOne(std::uint8_t *pData, std::size_t pSize) {
    if (pSize > SOCCER_BLOCK_SIZE) {
        pSize = SOCCER_BLOCK_SIZE;
    }
    memset(pData, 0xFF, pSize);
}

bool CipherGauntlet::RunCipher(Cipher *pCipher, std::string pName) {

    for (std::size_t aTrial = 0; aTrial < (TEST_COUNT_MAIN_TRIAL_L1); aTrial++) {
        if (!RunCipherWithSizeExpectingSuccess(pCipher, SOCCER_BLOCK_QUARTER, pName, aTrial)) {
            return false;
        }
    }

    return true;
}

bool CipherGauntlet::RunCipherWithSizeExpectingSuccess(Cipher *pCipher, std::size_t pSize, std::string pName, std::size_t pIndex) {
    
    if (pSize > SOCCER_BLOCK_SIZE) {
        printf("RunCipherWithSizeExpectingSuccess %s cannot run with size %d, too large\n", pName.c_str(), (int)pSize);
        return false;
    }
    
    RandomizeSource(pSize, pIndex);
    
    CipherErrorCode aErrorCode;
    if (!pCipher->SealData(mSource,
                         mWorkerA,
                          mEncrypted,
                         pSize,
                         &aErrorCode)) {
        PrintExpectingSuccessFailure("RunCipherWithSizeExpectingSuccess",
                                     pName,
                                     "seal data failed at size " + std::to_string(pSize) + ", error code was " + std::to_string((int)aErrorCode));
        return false;
    }
    
    if (!pCipher->UnsealData(mEncrypted, mWorkerB, mUnencrypted, pSize, &aErrorCode)) {
        PrintExpectingSuccessFailure("RunCipherWithSizeExpectingSuccess",
                                     pName,
                                     "unseal data failed at size " + std::to_string(pSize) + ", error code was " + std::to_string((int)aErrorCode));
        return false;
    }
    
    if (!Matches(mSource, mUnencrypted, pSize)) {
        PrintExpectingSuccessFailure("RunCipherWithSizeExpectingSuccess",
                                     pName,
                                     "unencrypted data did not match source/original");
        return false;
    }
    
    return true;
}


bool CipherGauntlet::SealDataExpectingSuccess(const std::uint8_t *pSource,
                                              std::uint8_t *pWorker,
                                              std::uint8_t *pDestination,
                                              std::size_t pSize,
                                              Cipher *pCipher,
                                              std::string pName) {
    if (pCipher == nullptr) {
        PrintExpectingSuccessFailure("SealDataExpectingSuccess",
                                     pName,
                                     "null cipher");
        return false;
    }
    if (pSource == nullptr && pSize != 0u) {
        PrintExpectingSuccessFailure("SealDataExpectingSuccess",
                                     pName,
                                     "null source");
        return false;
    }
    if (pWorker == nullptr && pSize != 0u) {
        PrintExpectingSuccessFailure("SealDataExpectingSuccess",
                                     pName,
                                     "null worker");
        return false;
    }
    if (pDestination == nullptr && pSize != 0u) {
        PrintExpectingSuccessFailure("SealDataExpectingSuccess",
                                     pName,
                                     "null destination");
        return false;
    }
    
    CipherErrorCode aErrorCode = CipherErrorCode::kNone;
    
    if (!pCipher->SealData(pSource,
                          pWorker,
                          pDestination,
                          pSize,
                          &aErrorCode)) {
        PrintExpectingSuccessError("SealDataExpectingSuccess",
                                   pName,
                                   aErrorCode);
        return false;
    }
    
    return true;
}

bool CipherGauntlet::UnsealDataExpectingSuccess(const std::uint8_t *pSource,
                                                std::uint8_t *pWorker,
                                                std::uint8_t *pDestination,
                                                std::size_t pSize,
                                                Cipher *pCipher,
                                                std::string pName) {
    if (pCipher == nullptr) {
        PrintExpectingSuccessFailure("UnsealDataExpectingSuccess",
                                     pName,
                                     "null cipher");
        return false;
    }
    if (pSource == nullptr && pSize != 0u) {
        PrintExpectingSuccessFailure("UnsealDataExpectingSuccess",
                                     pName,
                                     "null source");
        return false;
    }
    if (pWorker == nullptr && pSize != 0u) {
        PrintExpectingSuccessFailure("UnsealDataExpectingSuccess",
                                     pName,
                                     "null worker");
        return false;
    }
    if (pDestination == nullptr && pSize != 0u) {
        PrintExpectingSuccessFailure("UnsealDataExpectingSuccess",
                                     pName,
                                     "null destination");
        return false;
    }
    
    CipherErrorCode aErrorCode = CipherErrorCode::kNone;
    
    if (!pCipher->UnsealData(pSource,
                            pWorker,
                            pDestination,
                            pSize,
                            &aErrorCode)) {
        PrintExpectingSuccessError("UnsealDataExpectingSuccess",
                                   pName,
                                   aErrorCode);
        return false;
    }
    
    return true;
}

bool CipherGauntlet::Matches(const std::uint8_t *pOriginal,
                             const std::uint8_t *pUnencrypted,
                             std::size_t pSize) {
    if ((pOriginal == nullptr || pUnencrypted == nullptr) && pSize != 0u) {
        printf("Matches failed, null buffer.\n");
        return false;
    }
    
    for (std::size_t aIndex = 0; aIndex < pSize; ++aIndex) {
        if (pOriginal[aIndex] != pUnencrypted[aIndex]) {
            PrintMatchWindow(pOriginal, pUnencrypted, pSize, aIndex);
            return false;
        }
    }
    
    return true;
}
