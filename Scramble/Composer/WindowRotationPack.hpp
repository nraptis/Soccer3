#ifndef SOCCER_WINDOW_ROTATION_PACK_HPP_
#define SOCCER_WINDOW_ROTATION_PACK_HPP_

#include "WindowRotationPackPlane.hpp"

// Data only: two rounds, eight layers, 128 window offsets and 16 byte offsets.
// No shuffles, cursors, scratch buffers, or farming methods live in the pack.
struct WindowRotationPack {
    WindowRotationPackPlane mPlaneA;
    WindowRotationPackPlane mPlaneB;
};

#endif // SOCCER_WINDOW_ROTATION_PACK_HPP_
