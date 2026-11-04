//
//  LaneTool.hpp
//  ScrambleTests
//
//  Created by nicholas raptis on 7/17/26.
//

#ifndef LaneTool_hpp
#define LaneTool_hpp

#include <stdio.h>
#include <cstdint>
#include <cstddef>
#include <string>

class LaneTool {
    
public:
    
    static void                     PrintMismatch(std::string pName, std::uint8_t *pLaneA, std::uint8_t *pLaneB, std::size_t pIndex, std::size_t pSize);
    
    static std::size_t              ByteRichness(std::uint8_t *pLane, std::size_t pSize);
    
};

#endif /* LaneTool_hpp */
