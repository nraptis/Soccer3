//
//  SoccerMaskBank.hpp
//  Scramble
//
//  Created by Icarus Black on 8/8/26.
//

#ifndef SoccerMaskBank_hpp
#define SoccerMaskBank_hpp

#include <cstddef>
#include <cstdint>


class SoccerMaskBank {

public:
    static constexpr std::size_t    mMaskGridWidth = 13U;
    static constexpr std::size_t    mMaskGridHeight = 420U;
    static const std::uint8_t       mMaskGrid[mMaskGridHeight][mMaskGridWidth];
};

#endif /* SoccerMaskBank_hpp */
