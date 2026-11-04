//
//  Test_Quad_SteelA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_SteelA : XCTestCase

@end

@implementation Test_Quad_SteelA

- (void)testQuad_SteelA_4x4_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_SteelA_4x4_A();

    const M aExpected = {
        { 11,  1,  9,  3 },
        { 14,  4, 12,  6 },
        { 10,  2,  8,  0 },
        { 13,  5, 15,  7 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SteelA_4x4_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_SteelA_4x4_B();

    const M aExpected = {
        { 11,  1,  9,  3 },
        { 14,  4, 12,  6 },
        { 10,  2,  8,  0 },
        { 13,  5, 15,  7 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SteelA_4x4_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_SteelA_4x4_C();

    const M aExpected = {
        { 11,  1,  9,  3 },
        { 14,  4, 12,  6 },
        { 10,  2,  8,  0 },
        { 13,  5, 15,  7 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SteelA_4x4_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_SteelA_4x4_D();

    const M aExpected = {
        { 11,  1,  9,  3 },
        { 14,  4, 12,  6 },
        { 10,  2,  8,  0 },
        { 13,  5, 15,  7 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
