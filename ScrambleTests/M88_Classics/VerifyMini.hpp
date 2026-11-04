//
//  VerifyMini.hpp
//  CyberMatrixTests
//
//  Created by Icarus Black on 5/29/26.
//

#ifndef VerifyMini_hpp
#define VerifyMini_hpp

#include <cstddef>
#include "M88.hpp"
#include "Tests.hpp"

class VerifyMini {
public:
    static M88              SpawnTestMatrixMiniA();
    static M88              SpawnTestMatrixMiniB();
    static M88              SpawnTestMatrixMiniC();
    static M88              SpawnTestMatrixMiniD();
    
    static M88              SpawnTestMatrixMiniE();
    static M88              SpawnTestMatrixMiniF();
    static M88              SpawnTestMatrixMiniG();
    static M88              SpawnTestMatrixMiniH();
    
    static M88              SpawnTestMatrixMiniI();
    static M88              SpawnTestMatrixMiniJ();
    static M88              SpawnTestMatrixMiniK();
    static M88              SpawnTestMatrixMiniL();
    
    static M88              SpawnTestMatrixMiniM();
    static M88              SpawnTestMatrixMiniN();
    static M88              SpawnTestMatrixMiniO();
    static M88              SpawnTestMatrixMiniP();
    
    static M                MiniBefore();
    
    
    static bool             CheckMiniA(const M88 &pBefore,
                                       const M88 &pAfter,
                                       const M &pExpected);
    
    static bool             CheckMiniB(const M88 &pBefore,
                                       const M88 &pAfter,
                                       const M &pExpected);
    
    static bool             CheckMiniC(const M88 &pBefore,
                                       const M88 &pAfter,
                                       const M &pExpected);
    
    static bool             CheckMiniD(const M88 &pBefore,
                                       const M88 &pAfter,
                                       const M &pExpected);
    
    static bool             CheckMiniE(const M88 &pBefore,
                                       const M88 &pAfter,
                                       const M &pExpected);
    
    static bool             CheckMiniF(const M88 &pBefore,
                                       const M88 &pAfter,
                                       const M &pExpected);
    
    static bool             CheckMiniG(const M88 &pBefore,
                                       const M88 &pAfter,
                                       const M &pExpected);
    
    static bool             CheckMiniH(const M88 &pBefore,
                                       const M88 &pAfter,
                                       const M &pExpected);
    
    static bool             CheckMiniI(const M88 &pBefore,
                                       const M88 &pAfter,
                                       const M &pExpected);
    
    static bool             CheckMiniJ(const M88 &pBefore,
                                       const M88 &pAfter,
                                       const M &pExpected);
    
    static bool             CheckMiniK(const M88 &pBefore,
                                       const M88 &pAfter,
                                       const M &pExpected);
    
    static bool             CheckMiniL(const M88 &pBefore,
                                       const M88 &pAfter,
                                       const M &pExpected);
    
    static bool             CheckMiniM(const M88 &pBefore,
                                       const M88 &pAfter,
                                       const M &pExpected);
    
    static bool             CheckMiniN(const M88 &pBefore,
                                       const M88 &pAfter,
                                       const M &pExpected);
    
    static bool             CheckMiniO(const M88 &pBefore,
                                       const M88 &pAfter,
                                       const M &pExpected);
    
    static bool             CheckMiniP(const M88 &pBefore,
                                       const M88 &pAfter,
                                       const M &pExpected);
    
    static bool             CheckMini(std::size_t pMini,
                                      const M88 &pBefore,
                                      const M88 &pAfter,
                                      const M &pExpected);
    
private:
    static M88              SpawnTestMatrixMini(std::size_t pMini);
    
};

#endif /* VerifyMini_hpp */
