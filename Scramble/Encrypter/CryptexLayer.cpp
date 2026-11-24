#include "CryptexLayer.hpp"

#include <cstdint>
#include <cstring>

CryptexLayer::CryptexLayer() {
    mKernelCount = 0;
    for (std::size_t aKernelIndex=0; aKernelIndex<CRYPTEX_LAYER_MAX_KERNEL_COUNT; aKernelIndex++) {
        mKernels[aKernelIndex] = nullptr;
    }
}

CryptexLayer::~CryptexLayer() {
    for (std::size_t aKernelIndex=0; aKernelIndex<mKernelCount; aKernelIndex++) {
        delete mKernels[aKernelIndex];
        mKernels[aKernelIndex] = nullptr;
    }
    mKernelCount = 0;
}

void CryptexLayer::Add(Kernel *pKernel) {
    if (mKernelCount < CRYPTEX_LAYER_MAX_KERNEL_COUNT) {
        mKernels[mKernelCount] = pKernel;
        mKernelCount++;
    } else {

        delete pKernel;
    }
}

void CryptexLayer::Clear() {
    for (std::size_t aKernelIndex=0; aKernelIndex<mKernelCount; aKernelIndex++) {
        delete mKernels[aKernelIndex];
        mKernels[aKernelIndex] = nullptr;
    }
    mKernelCount = 0;
}

void CryptexLayer::Zero() {
    for (std::size_t aKernelIndex=0U;
         aKernelIndex<mKernelCount;
         aKernelIndex++) {
        if (mKernels[aKernelIndex] != nullptr) {
            mKernels[aKernelIndex]->Zero();
        }
    }
}

bool CryptexLayer::SealData(const std::uint8_t* pSource,
                               std::uint8_t* pScratch,
                               std::uint8_t* pDestination,
                               std::size_t pLength,
                               KernelErrorCode *pErrorCode) const {
    if (pLength == 0) {
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kNone);
        return true;
    }
    
    if (pSource == nullptr || pScratch == nullptr || pDestination == nullptr) {
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kNullBuffer);
        return false;
    }
    
    if (mKernelCount == 0) {
        if (pSource != pDestination) {
            std::memcpy(pDestination, pSource, pLength);
        }
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kNone);
        return true;
    }
    
    if ((pSource == pDestination) ||
        (pSource == pScratch) ||
        (pDestination == pScratch)) {
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kAliasedBuffer);
        return false;
    }
    
    const std::uint8_t* aInput = pSource;
    std::uint8_t* aOutput =
    ((mKernelCount & 1U) == 0U) ? pScratch : pDestination;
    
    for (std::size_t aKernelIndex=0; aKernelIndex<mKernelCount; aKernelIndex++) {
        Kernel *aKernel = mKernels[aKernelIndex];
        if (aKernel == nullptr) {
            SetKernelErrorCode(pErrorCode, KernelErrorCode::kNullKernel);
            return false;
        }
        if (!aKernel->SealData(aInput, pScratch, aOutput, pLength, pErrorCode)) {
            return false;
        }
        aInput = aOutput;
        aOutput = (aOutput == pDestination) ? pScratch : pDestination;
    }
    
    SetKernelErrorCode(pErrorCode, KernelErrorCode::kNone);
    return true;
}

bool CryptexLayer::UnsealData(const std::uint8_t* pSource,
                                 std::uint8_t* pScratch,
                                 std::uint8_t* pDestination,
                                 std::size_t pLength,
                                 KernelErrorCode *pErrorCode) const {
    if (pLength == 0) {
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kNone);
        return true;
    }
    
    if (pSource == nullptr || pScratch == nullptr || pDestination == nullptr) {
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kNullBuffer);
        return false;
    }
    
    if (mKernelCount == 0) {
        if (pSource != pDestination) {
            std::memcpy(pDestination, pSource, pLength);
        }
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kNone);
        return true;
    }
    
    if ((pSource == pDestination) ||
        (pSource == pScratch) ||
        (pDestination == pScratch)) {
        SetKernelErrorCode(pErrorCode, KernelErrorCode::kAliasedBuffer);
        return false;
    }
    
    const std::uint8_t* aInput = pSource;
    std::uint8_t* aOutput =
    ((mKernelCount & 1U) == 0U) ? pScratch : pDestination;
    
    std::size_t aKernelIndex = mKernelCount;
    while (aKernelIndex > 0) {
        aKernelIndex--;
        Kernel *aKernel = mKernels[aKernelIndex];
        if (aKernel == nullptr) {
            SetKernelErrorCode(pErrorCode, KernelErrorCode::kNullKernel);
            return false;
        }
        if (!aKernel->UnsealData(aInput, pScratch, aOutput, pLength,
                                 pErrorCode)) {
            return false;
        }
        aInput = aOutput;
        aOutput = (aOutput == pDestination) ? pScratch : pDestination;
    }
    
    SetKernelErrorCode(pErrorCode, KernelErrorCode::kNone);
    return true;
}

KernelType CryptexLayer::GetKernelType(std::size_t pIndex) const {
    return pIndex < mKernelCount && mKernels[pIndex] != nullptr
        ? mKernels[pIndex]->mType : KernelType::kNone;
}
