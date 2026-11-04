//
//  EightRotationValidator.hpp
//  ScrambleTests
//
//  Created by Icarus Black on 11/4/26.
//

#ifndef EightRotationValidator_hpp
#define EightRotationValidator_hpp

#define RWIN_SIZE 16384U

#include <cstddef>

class EightRotationValidator {
public:

    static std::size_t              ComplimentWindow(std::size_t pRotation);
    
    // Uses shared scratch; calls must be serialized. An empty list is valid.
    // A nonempty list needs a pointer. More than 14 rotations cannot have
    // distinct subset sums in 16,384 windows and is rejected immediately.
    static bool                     Valid(std::size_t *pRotationArray, std::size_t pRotationArrayCount);
    
    
    // Whole-window rotations, normalized modulo RWIN_SIZE.
    // Reject zero and any signed combination that wraps to zero: every
    // rotation can be absent, added, or complemented, at most once.
    // Equivalently, all subset sums (including the empty sum) must differ.
    static bool                     Valid(std::size_t pRotationA, std::size_t pRotationB);
    static bool                     Valid(std::size_t pRotationA, std::size_t pRotationB, std::size_t pRotationC);
    static bool                     Valid(std::size_t pRotationA, std::size_t pRotationB, std::size_t pRotationC, std::size_t pRotationD);
    
    
private:
    static bool                     Valid_Helper(const std::size_t *pRotationArray,
                                                 std::size_t pRotationArrayCount,
                                                 std::size_t pRotationSum);
};

#endif /* EightRotationValidator_hpp */
