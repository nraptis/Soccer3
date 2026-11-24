#ifndef SOCCER_ENCRYPTION_KERNEL_HPP_
#define SOCCER_ENCRYPTION_KERNEL_HPP_

#include <cstddef>
#include <cstdint>

#include "KernelErrorCodes.hpp"
#include "SoccerTypes.hpp"

class Kernel {
public:
    static constexpr std::size_t kBlockBytes = 1048576U;

    explicit Kernel(KernelType pType) : mType(pType) {}
    virtual ~Kernel() = default;

    virtual bool        SealData(const std::uint8_t *pSource,
                                 std::uint8_t *pWorker,
                                 std::uint8_t *pDestination,
                                 std::size_t pLength,
                                 KernelErrorCode *pErrorCode) const = 0;
    virtual bool        UnsealData(const std::uint8_t *pSource,
                                   std::uint8_t *pWorker,
                                   std::uint8_t *pDestination,
                                   std::size_t pLength,
                                   KernelErrorCode *pErrorCode) const = 0;

    virtual void        Zero() {}

    const KernelType    mType;
};

#endif  // SOCCER_ENCRYPTION_KERNEL_HPP_
