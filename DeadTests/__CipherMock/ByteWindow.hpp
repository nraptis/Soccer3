//
//  ByteWindow.hpp
//  ScrambleTests
//
//  Created by Amada Badger on 11/11/26.
//

#ifndef ByteWindow_hpp
#define ByteWindow_hpp

#include <stdio.h>
#include <cstdint>
#include <vector>

#define BYTE_WINDOW_SIZE 64

struct ByteWindowBitStrip;

struct ByteWindow {
    
    std::uint8_t                mBytes[BYTE_WINDOW_SIZE];
    
    // little endian layout
    // [byte 0][byte 1][byte 2][byte 3][byte 4][byte 5][byte 6][byte 7]
    
    ByteWindowBitStrip          GetStrip(std::size_t pBitNumber);
    
    
};


#endif /* ByteWindow_hpp */
