#include "BitReverseCipher.hpp"
extern "C" bool reverse_bytes(const std::uint8_t *pSource,std::uint8_t *pDestination,std::size_t pLength) {
    BitReverseCipher aCipher;
    return aCipher.SealData(pSource,nullptr,pDestination,pLength,nullptr);
}
