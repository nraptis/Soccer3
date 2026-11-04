#include "Soccer3.hpp"

#define SOCCER_ENCRYPTION_STRENGTH_DEFINED
#define SOCCER3_DISABLE_COMPAT_ALIAS
#include "../Composer/Soccer3.hpp"

void Soccer3::SetDelegate(SoccerDelegate *pDelegate) {
    Soccer3Internal::SetDelegate(pDelegate);
}

void Soccer3::ConfigureTestBuffers(std::uint32_t pTestBlockLength) {
    Soccer3Internal::ConfigureTestBuffers(pTestBlockLength);
}

bool Soccer3::AttemptSeed_Encrypt(EncryptionStrength pStrength,
                                  std::uint8_t *pPassword,
                                  std::size_t pPasswordByteLength,
                                  std::uint64_t pNonce,
                                  std::uint32_t *pAckWord,
                                  std::uint64_t pVersion,
                                  const std::atomic<bool> *pCancelled) {
    return Soccer3Internal::AttemptSeed_Encrypt(pStrength,
                                                pPassword,
                                                pPasswordByteLength,
                                                pNonce,
                                                pAckWord,
                                                pVersion,
                                                pCancelled);
}

bool Soccer3::AttemptSeed_Decrypt(EncryptionStrength pStrength,
                                  std::uint8_t *pPassword,
                                  std::size_t pPasswordByteLength,
                                  std::uint64_t pNonce,
                                  std::uint32_t pAckWord,
                                  std::uint64_t pVersion,
                                  const std::atomic<bool> *pCancelled) {
    return Soccer3Internal::AttemptSeed_Decrypt(pStrength,
                                                pPassword,
                                                pPasswordByteLength,
                                                pNonce,
                                                pAckWord,
                                                pVersion,
                                                pCancelled);
}

bool Soccer3::EncryptBlock(std::uint8_t *pSource,
                           std::uint8_t *pDestination) {
    return Soccer3Internal::EncryptBlock(pSource, pDestination);
}

bool Soccer3::DecryptBlock(std::uint8_t *pSource,
                           std::uint8_t *pDestination) {
    return Soccer3Internal::DecryptBlock(pSource, pDestination);
}

void Soccer3::Zero() {
    Soccer3Internal::Zero();
}
