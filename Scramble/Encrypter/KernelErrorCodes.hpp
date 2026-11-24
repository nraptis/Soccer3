#ifndef SOCCER_KERNEL_ERROR_CODES_HPP_
#define SOCCER_KERNEL_ERROR_CODES_HPP_

#include <cstdint>

enum class KernelErrorCode : std::uint32_t {
  kNone = 0,
  kInvalidLength = 1,
  kNullBuffer = 2,
  kAliasedBuffer = 3,
  kInvalidBlockSize = 4,
  kNullKernel = 5,
  kInvalidParameter = 6,
};

inline void SetKernelErrorCode(KernelErrorCode *pErrorCode,
                               KernelErrorCode pValue) {
  if (pErrorCode != nullptr) {
    *pErrorCode = pValue;
  }
}

#endif  // SOCCER_KERNEL_ERROR_CODES_HPP_
