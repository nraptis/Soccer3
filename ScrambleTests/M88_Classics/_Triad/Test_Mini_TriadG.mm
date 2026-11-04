//
//  TestMiniKINDte.m
//  UnitTests
//
//  Created by Icarus Black on 5/29/26.
//


#import <XCTest/XCTest.h>
#include "M88.hpp"
#include "VerifyMini.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Mini_TriadG : XCTestCase

@end

@implementation Test_Mini_TriadG

- (void)testMini_TriadG_2x2_A {
    M88 aBefore = VerifyMini::SpawnTestMatrixMiniA();
    M88 aAfter = aBefore;

    aAfter.Mini_TriadG_2x2_A();

    const M aExpected = {
        { 0, 2 },
        { 3, 1 }
    };

    if (!VerifyMini::CheckMiniA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testMini_TriadG_2x2_B {
    M88 aBefore = VerifyMini::SpawnTestMatrixMiniB();
    M88 aAfter = aBefore;

    aAfter.Mini_TriadG_2x2_B();

    const M aExpected = {
        { 0, 2 },
        { 3, 1 }
    };

    if (!VerifyMini::CheckMiniB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testMini_TriadG_2x2_C {
    M88 aBefore = VerifyMini::SpawnTestMatrixMiniC();
    M88 aAfter = aBefore;

    aAfter.Mini_TriadG_2x2_C();

    const M aExpected = {
        { 0, 2 },
        { 3, 1 }
    };

    if (!VerifyMini::CheckMiniC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testMini_TriadG_2x2_D {
    M88 aBefore = VerifyMini::SpawnTestMatrixMiniD();
    M88 aAfter = aBefore;

    aAfter.Mini_TriadG_2x2_D();

    const M aExpected = {
        { 0, 2 },
        { 3, 1 }
    };

    if (!VerifyMini::CheckMiniD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testMini_TriadG_2x2_E {
    M88 aBefore = VerifyMini::SpawnTestMatrixMiniE();
    M88 aAfter = aBefore;

    aAfter.Mini_TriadG_2x2_E();

    const M aExpected = {
        { 0, 2 },
        { 3, 1 }
    };

    if (!VerifyMini::CheckMiniE(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testMini_TriadG_2x2_F {
    M88 aBefore = VerifyMini::SpawnTestMatrixMiniF();
    M88 aAfter = aBefore;

    aAfter.Mini_TriadG_2x2_F();

    const M aExpected = {
        { 0, 2 },
        { 3, 1 }
    };

    if (!VerifyMini::CheckMiniF(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testMini_TriadG_2x2_G {
    M88 aBefore = VerifyMini::SpawnTestMatrixMiniG();
    M88 aAfter = aBefore;

    aAfter.Mini_TriadG_2x2_G();

    const M aExpected = {
        { 0, 2 },
        { 3, 1 }
    };

    if (!VerifyMini::CheckMiniG(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testMini_TriadG_2x2_H {
    M88 aBefore = VerifyMini::SpawnTestMatrixMiniH();
    M88 aAfter = aBefore;

    aAfter.Mini_TriadG_2x2_H();

    const M aExpected = {
        { 0, 2 },
        { 3, 1 }
    };

    if (!VerifyMini::CheckMiniH(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testMini_TriadG_2x2_I {
    M88 aBefore = VerifyMini::SpawnTestMatrixMiniI();
    M88 aAfter = aBefore;

    aAfter.Mini_TriadG_2x2_I();

    const M aExpected = {
        { 0, 2 },
        { 3, 1 }
    };

    if (!VerifyMini::CheckMiniI(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testMini_TriadG_2x2_J {
    M88 aBefore = VerifyMini::SpawnTestMatrixMiniJ();
    M88 aAfter = aBefore;

    aAfter.Mini_TriadG_2x2_J();

    const M aExpected = {
        { 0, 2 },
        { 3, 1 }
    };

    if (!VerifyMini::CheckMiniJ(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testMini_TriadG_2x2_K {
    M88 aBefore = VerifyMini::SpawnTestMatrixMiniK();
    M88 aAfter = aBefore;

    aAfter.Mini_TriadG_2x2_K();

    const M aExpected = {
        { 0, 2 },
        { 3, 1 }
    };

    if (!VerifyMini::CheckMiniK(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testMini_TriadG_2x2_L {
    M88 aBefore = VerifyMini::SpawnTestMatrixMiniL();
    M88 aAfter = aBefore;

    aAfter.Mini_TriadG_2x2_L();

    const M aExpected = {
        { 0, 2 },
        { 3, 1 }
    };

    if (!VerifyMini::CheckMiniL(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testMini_TriadG_2x2_M {
    M88 aBefore = VerifyMini::SpawnTestMatrixMiniM();
    M88 aAfter = aBefore;

    aAfter.Mini_TriadG_2x2_M();

    const M aExpected = {
        { 0, 2 },
        { 3, 1 }
    };

    if (!VerifyMini::CheckMiniM(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testMini_TriadG_2x2_N {
    M88 aBefore = VerifyMini::SpawnTestMatrixMiniN();
    M88 aAfter = aBefore;

    aAfter.Mini_TriadG_2x2_N();

    const M aExpected = {
        { 0, 2 },
        { 3, 1 }
    };

    if (!VerifyMini::CheckMiniN(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testMini_TriadG_2x2_O {
    M88 aBefore = VerifyMini::SpawnTestMatrixMiniO();
    M88 aAfter = aBefore;

    aAfter.Mini_TriadG_2x2_O();

    const M aExpected = {
        { 0, 2 },
        { 3, 1 }
    };

    if (!VerifyMini::CheckMiniO(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testMini_TriadG_2x2_P {
    M88 aBefore = VerifyMini::SpawnTestMatrixMiniP();
    M88 aAfter = aBefore;

    aAfter.Mini_TriadG_2x2_P();

    const M aExpected = {
        { 0, 2 },
        { 3, 1 }
    };

    if (!VerifyMini::CheckMiniP(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end

