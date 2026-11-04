//
//  Logging.cpp
//  CyberMatrixTests
//
//  Created by Icarus Black on 5/29/26.
//

#include "Logging.hpp"

void Logging::Log(const char *pLabel, const M &pMatrix) {
    std::printf("\n%s:\n", pLabel);
    
    for (std::size_t y = 0; y < pMatrix.size(); y++) {
        std::printf("  ");
        for (std::size_t x = 0; x < pMatrix[y].size(); x++) {
            std::printf("%03u ", static_cast<unsigned>(pMatrix[y][x]));
        }
        std::printf("\n");
    }
    
    std::printf("\n");
}

void Logging::Log(const char *pLabel, const M88 &pMatrix) {
    std::printf("\n%s:\n", pLabel);
    
    for (std::size_t y = 0; y < 8; y++) {
        std::printf("  ");
        for (std::size_t x = 0; x < 8; x++) {
            const std::size_t aSlot = M88::Slot(x, y);
            std::printf("%03u ", static_cast<unsigned>(pMatrix.mData[aSlot]));
        }
        std::printf("\n");
    }
    
    std::printf("\n");
}
