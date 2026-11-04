//
//  Test_Quad_BurbankD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_BurbankD : XCTestCase

@end

@implementation Test_Quad_BurbankD

- (void)testQuad_BurbankD_4x4_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_BurbankD_4x4_A();

    const M aExpected = {
        { 11, 14,  6,  3 },
        { 13, 15,  0,  2 },
        { 12,  9,  1,  4 },
        { 10,  8,  7,  5 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_BurbankD_4x4_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_BurbankD_4x4_B();

    const M aExpected = {
        { 11, 14,  6,  3 },
        { 13, 15,  0,  2 },
        { 12,  9,  1,  4 },
        { 10,  8,  7,  5 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_BurbankD_4x4_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_BurbankD_4x4_C();

    const M aExpected = {
        { 11, 14,  6,  3 },
        { 13, 15,  0,  2 },
        { 12,  9,  1,  4 },
        { 10,  8,  7,  5 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_BurbankD_4x4_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_BurbankD_4x4_D();

    const M aExpected = {
        { 11, 14,  6,  3 },
        { 13, 15,  0,  2 },
        { 12,  9,  1,  4 },
        { 10,  8,  7,  5 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
