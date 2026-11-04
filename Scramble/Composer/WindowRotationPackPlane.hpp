#ifndef SOCCER_WINDOW_ROTATION_PACK_PLANE_HPP_
#define SOCCER_WINDOW_ROTATION_PACK_PLANE_HPP_

#include "WindowRotationPackChunk.hpp"

// Data for four layers. One farm supplies all eight free rotations;
// two separate farms supply each chunk's sixteen window rotations.
struct WindowRotationPackPlane {
    WindowRotationPackChunk mChunkA;
    WindowRotationPackChunk mChunkB;
    WindowRotationPackChunk mChunkC;
    WindowRotationPackChunk mChunkD;
};

#endif // SOCCER_WINDOW_ROTATION_PACK_PLANE_HPP_
