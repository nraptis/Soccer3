#ifndef JELLY_CORE_CRYPTEX_LAYER_HPP_
#define JELLY_CORE_CRYPTEX_LAYER_HPP_

#include <cstddef>
#include <cstdint>

#include "Kernel.hpp"

#define CRYPTEX_LAYER_MAX_KERNEL_COUNT 32

class CryptexLayer {
public:
    CryptexLayer();
    ~CryptexLayer();
    CryptexLayer(const CryptexLayer &) = delete;
    CryptexLayer &operator=(const CryptexLayer &) = delete;
    CryptexLayer(CryptexLayer &&) = delete;
    CryptexLayer &operator=(CryptexLayer &&) = delete;
    std::size_t                 GetKernelCount() const { return mKernelCount; }
    KernelType                  GetKernelType(std::size_t pIndex) const;
    
    void                        Add(Kernel *pKernel);
    void                        Clear();
    void                        Zero();
    
    bool                        SealData(const std::uint8_t* pSource,
                                         std::uint8_t* pScratch,
                                         std::uint8_t* pDestination,
                                         std::size_t pLength,
                                         KernelErrorCode *pErrorCode) const;

    bool                        UnsealData(const std::uint8_t* pSource,
                                           std::uint8_t* pScratch,
                                           std::uint8_t* pDestination,
                                           std::size_t pLength,
                                           KernelErrorCode *pErrorCode) const;
    
private:
    
    Kernel                      *mKernels[CRYPTEX_LAYER_MAX_KERNEL_COUNT];
    std::size_t                 mKernelCount;
    
};

#endif  // JELLY_CORE_CRYPTEX_LAYER_HPP_
