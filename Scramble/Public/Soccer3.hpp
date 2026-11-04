#ifndef Soccer3Public_hpp
#define Soccer3Public_hpp

#include <atomic>
#include <cstddef>
#include <cstdint>

#include "SoccerDelegate.hpp"

enum class EncryptionStrength : std::uint8_t {
    kTest = 3,
    kWeak = 0,
    kNormal = 1,
    kStrong = 2,
};

#define SOCCER_BLOCK_SIZE 1048576

class Soccer3 {
public:
    // Shared process-wide state. Calls must be serialized; concurrent Soccer
    // operations are unsupported.
    // Non-owning. The delegate must outlive its registration; nullptr detaches it.
    // Registration is preserved by Zero().
    static void SetDelegate(SoccerDelegate *pDelegate);

    // For kTest only: configure a smaller block after seeding. Zero() and each
    // new seed restore the default 1 MiB length.
    static void ConfigureTestBuffers(std::uint32_t pTestBlockLength);

    // Both seed attempts accept an optional, caller-owned cancellation flag.
    // Keep it alive until the attempt returns; nullptr disables cancellation.
    // Another thread may store true with memory_order_relaxed. Do not reset it
    // during an attempt. Cancellation returns false at the next polling point.
    // Each attempt starts with Zero(), discarding any previous seed or plan.
    static bool AttemptSeed_Encrypt(EncryptionStrength pStrength,
                                    std::uint8_t *pPassword,
                                    std::size_t pPasswordByteLength,
                                    std::uint64_t pNonce,
                                    std::uint32_t *pAckWord,
                                    std::uint64_t pVersion,
                                    const std::atomic<bool> *pCancelled);

    static bool AttemptSeed_Decrypt(EncryptionStrength pStrength,
                                    std::uint8_t *pPassword,
                                    std::size_t pPasswordByteLength,
                                    std::uint64_t pNonce,
                                    std::uint32_t pAckWord,
                                    std::uint64_t pVersion,
                                    const std::atomic<bool> *pCancelled);

    static bool EncryptBlock(std::uint8_t *pSource,
                             std::uint8_t *pDestination);

    static bool DecryptBlock(std::uint8_t *pSource,
                             std::uint8_t *pDestination);

    // Clears seed/cipher data and restores the initial pointer and index lists.
    static void Zero();
};

#endif /* Soccer3Public_hpp */
