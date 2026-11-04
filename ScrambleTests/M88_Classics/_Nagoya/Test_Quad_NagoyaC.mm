//
//  Test_Quad_NagoyaC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_NagoyaC : XCTestCase

@end

@implementation Test_Quad_NagoyaC

- (void)testQuad_NagoyaC_4x4_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_NagoyaC_4x4_A();

    const M aExpected = {
        { 12, 13,  5,  4 },
        { 11,  9,  0,  2 },
        { 15, 14,  6,  7 },
        { 10,  8,  1,  3 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_NagoyaC_4x4_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_NagoyaC_4x4_B();

    const M aExpected = {
        { 12, 13,  5,  4 },
        { 11,  9,  0,  2 },
        { 15, 14,  6,  7 },
        { 10,  8,  1,  3 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_NagoyaC_4x4_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_NagoyaC_4x4_C();

    const M aExpected = {
        { 12, 13,  5,  4 },
        { 11,  9,  0,  2 },
        { 15, 14,  6,  7 },
        { 10,  8,  1,  3 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_NagoyaC_4x4_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_NagoyaC_4x4_D();

    const M aExpected = {
        { 12, 13,  5,  4 },
        { 11,  9,  0,  2 },
        { 15, 14,  6,  7 },
        { 10,  8,  1,  3 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
