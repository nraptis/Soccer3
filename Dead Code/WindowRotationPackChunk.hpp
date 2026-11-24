#ifndef SOCCER_WINDOW_ROTATION_PACK_CHUNK_HPP_
#define SOCCER_WINDOW_ROTATION_PACK_CHUNK_HPP_

#include <cstdint>

// Data for one full-size layer. All values are 64-byte WINDOW offsets.
// Free windows acquire their 1..63 byte offsets when Cryptex inputs are built.
// Four consecutive sampling windows feed one FlameToad.
// A..H form one eight-value farm; I..P form the other.
struct WindowRotationPackChunk {
    std::uint16_t mWindowFreeA;
    std::uint16_t mWindowFreeB;

    std::uint16_t mWindowA;
    std::uint16_t mWindowB;
    std::uint16_t mWindowC;
    std::uint16_t mWindowD;

    std::uint16_t mWindowE;
    std::uint16_t mWindowF;
    std::uint16_t mWindowG;
    std::uint16_t mWindowH;

    std::uint16_t mWindowI;
    std::uint16_t mWindowJ;
    std::uint16_t mWindowK;
    std::uint16_t mWindowL;

    std::uint16_t mWindowM;
    std::uint16_t mWindowN;
    std::uint16_t mWindowO;
    std::uint16_t mWindowP;
};

#endif // SOCCER_WINDOW_ROTATION_PACK_CHUNK_HPP_
