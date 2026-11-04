//
//  Test_Quad_SussexC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_SussexC : XCTestCase

@end

@implementation Test_Quad_SussexC

- (void)testQuad_SussexC_4x4_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_SussexC_4x4_A();

    const M aExpected = {
        { 12,  8,  2,  6 },
        {  9, 15,  5,  3 },
        { 13,  7,  1, 11 },
        { 10,  0,  4, 14 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SussexC_4x4_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_SussexC_4x4_B();

    const M aExpected = {
        { 12,  8,  2,  6 },
        {  9, 15,  5,  3 },
        { 13,  7,  1, 11 },
        { 10,  0,  4, 14 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SussexC_4x4_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_SussexC_4x4_C();

    const M aExpected = {
        { 12,  8,  2,  6 },
        {  9, 15,  5,  3 },
        { 13,  7,  1, 11 },
        { 10,  0,  4, 14 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SussexC_4x4_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_SussexC_4x4_D();

    const M aExpected = {
        { 12,  8,  2,  6 },
        {  9, 15,  5,  3 },
        { 13,  7,  1, 11 },
        { 10,  0,  4, 14 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
