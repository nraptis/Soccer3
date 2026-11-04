#ifndef SOCCER_BLOCK_ROTATION_HPP_
#define SOCCER_BLOCK_ROTATION_HPP_

#include <cstddef>
#include <cstdint>

namespace soccer_cipher_detail {

// Positive shifts sample ahead; negative shifts sample behind. Widen before
// negation so INT32_MIN is supported. The caller supplies the window count.
inline std::size_t NormalizeBlockRotation(std::int32_t pRotation,
                                          std::size_t pWindowCount) {
    if (pWindowCount == 0U) { return 0U; }
    if (pRotation >= 0) { return static_cast<std::size_t>(pRotation) % pWindowCount; }
    const auto aMagnitude = static_cast<std::uint64_t>(-static_cast<std::int64_t>(pRotation));
    const auto aBack = static_cast<std::size_t>(aMagnitude % pWindowCount);
    return aBack == 0U ? 0U : pWindowCount - aBack;
}

} // namespace soccer_cipher_detail

#endif // SOCCER_BLOCK_ROTATION_HPP_
