//
//  ByteWindow.cpp
//  ScrambleTests
//
//  Created by Amada Badger on 11/11/26.
//

#include "ByteWindow.hpp"
#include "ByteWindowBitStrip.hpp"

ByteWindowBitStrip ByteWindow::GetStrip(std::size_t pBitNumber) {
    
    ByteWindowBitStrip aResult;
    
    constexpr uint8_t BIT_0 = (1U << 0); // 0x01 (0b00000001)
    constexpr uint8_t BIT_1 = (1U << 1); // 0x02 (0b00000010)
    constexpr uint8_t BIT_2 = (1U << 2); // 0x04 (0b00000100)
    constexpr uint8_t BIT_3 = (1U << 3); // 0x08 (0b00001000)
    constexpr uint8_t BIT_4 = (1U << 4); // 0x10 (0b00010000)
    constexpr uint8_t BIT_5 = (1U << 5); // 0x20 (0b00100000)
    constexpr uint8_t BIT_6 = (1U << 6); // 0x40 (0b01000000)
    constexpr uint8_t BIT_7 = (1U << 7); // 0x80 (0b10000000)
    
    pBitNumber = (pBitNumber & 0x7);
    
    std::uint8_t aMask = 0;
    if (pBitNumber == 7) { aMask = BIT_7; }
    else if (pBitNumber == 6) { aMask = BIT_6; }
    else if (pBitNumber == 5) { aMask = BIT_5; }
    else if (pBitNumber == 4) { aMask = BIT_4; }
    else if (pBitNumber == 3) { aMask = BIT_3; }
    else if (pBitNumber == 2) { aMask = BIT_2; }
    else if (pBitNumber == 1) { aMask = BIT_1; }
    else  { aMask = BIT_0; }
    
    for (std::size_t aIndex=0; aIndex<BYTE_WINDOW_SIZE; aIndex++) {
        if (mBytes[aIndex] & aMask) {
            aResult.mBits[aIndex] = true;
        } else {
            aResult.mBits[aIndex] = false;
        }
    }
    
    return aResult;
}
