//
//  Test_Quad_ArgonD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_ArgonD : XCTestCase

@end

@implementation Test_Quad_ArgonD

- (void)testQuad_ArgonD_4x4_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_ArgonD_4x4_A();

    const M aExpected = {
        {  6, 12, 11,  1 },
        {  2,  8, 15,  5 },
        { 10, 13,  7,  0 },
        { 14,  9,  3,  4 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_ArgonD_4x4_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_ArgonD_4x4_B();

    const M aExpected = {
        {  6, 12, 11,  1 },
        {  2,  8, 15,  5 },
        { 10, 13,  7,  0 },
        { 14,  9,  3,  4 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_ArgonD_4x4_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_ArgonD_4x4_C();

    const M aExpected = {
        {  6, 12, 11,  1 },
        {  2,  8, 15,  5 },
        { 10, 13,  7,  0 },
        { 14,  9,  3,  4 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_ArgonD_4x4_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_ArgonD_4x4_D();

    const M aExpected = {
        {  6, 12, 11,  1 },
        {  2,  8, 15,  5 },
        { 10, 13,  7,  0 },
        { 14,  9,  3,  4 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
