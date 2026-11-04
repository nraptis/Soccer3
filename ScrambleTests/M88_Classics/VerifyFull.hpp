//
//  VerifyFull.hpp
//  CyberMatrixTests
//
//  Created by Icarus Black on 5/29/26.
//

#ifndef VerifyFull_hpp
#define VerifyFull_hpp

#include "M88.hpp"
#include "Tests.hpp"

class VerifyFull {
public:
    static M88              SpawnTestMatrixFull();
    
    static M                FullBefore();
    
    static bool             CheckFull(const M88 &pBefore,
                                      const M88 &pAfter,
                                      const M &pExpected);
};

#endif /* VerifyFull_hpp */
