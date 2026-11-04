//
//  VerifyQuad.hpp
//  CyberMatrixTests
//
//  Created by Icarus Black on 5/29/26.
//

#ifndef VerifyQuad_hpp
#define VerifyQuad_hpp

#include <cstddef>
#include "M88.hpp"
#include "Tests.hpp"

class VerifyQuad {
public:
    static M88          SpawnTestMatrixQuadA();
    static M88          SpawnTestMatrixQuadB();
    static M88          SpawnTestMatrixQuadC();
    static M88          SpawnTestMatrixQuadD();
    
    static M            QuadBefore();
    
    static bool         CheckQuadA(const M88 &pBefore,
                                   const M88 &pAfter,
                                   const M &pExpected);
    
    static bool         CheckQuadB(const M88 &pBefore,
                                   const M88 &pAfter,
                                   const M &pExpected);
    
    static bool         CheckQuadC(const M88 &pBefore,
                                   const M88 &pAfter,
                                   const M &pExpected);
    
    static bool         CheckQuadD(const M88 &pBefore,
                                   const M88 &pAfter,
                                   const M &pExpected);
    
    static bool         CheckQuad(std::size_t pQuad,
                                  const M88 &pBefore,
                                  const M88 &pAfter,
                                  const M &pExpected);
    
private:
    static M88          SpawnTestMatrixQuad(std::size_t pQuad);
};

#endif /* VerifyQuad_hpp */
