//
//  TestQuadKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_FlipC : XCTestCase

@end

@implementation Test_Quad_FlipC

- (void)testQuad_FlipC_EachMini_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipC_EachMini_2x2_A();

    const M aExpected = {
        {  0,  4,  2,  6 },
        {  1,  5,  3,  7 },
        {  8, 12, 10, 14 },
        {  9, 13, 11, 15 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipC_EachMini_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipC_EachMini_2x2_B();

    const M aExpected = {
        {  0,  4,  2,  6 },
        {  1,  5,  3,  7 },
        {  8, 12, 10, 14 },
        {  9, 13, 11, 15 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipC_EachMini_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipC_EachMini_2x2_C();

    const M aExpected = {
        {  0,  4,  2,  6 },
        {  1,  5,  3,  7 },
        {  8, 12, 10, 14 },
        {  9, 13, 11, 15 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipC_EachMini_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipC_EachMini_2x2_D();

    const M aExpected = {
        {  0,  4,  2,  6 },
        {  1,  5,  3,  7 },
        {  8, 12, 10, 14 },
        {  9, 13, 11, 15 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipC_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipC_2x2_A();

    const M aExpected = {
        {  0,  1,  8,  9 },
        {  4,  5, 12, 13 },
        {  2,  3, 10, 11 },
        {  6,  7, 14, 15 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipC_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipC_2x2_B();

    const M aExpected = {
        {  0,  1,  8,  9 },
        {  4,  5, 12, 13 },
        {  2,  3, 10, 11 },
        {  6,  7, 14, 15 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipC_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipC_2x2_C();

    const M aExpected = {
        {  0,  1,  8,  9 },
        {  4,  5, 12, 13 },
        {  2,  3, 10, 11 },
        {  6,  7, 14, 15 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipC_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipC_2x2_D();

    const M aExpected = {
        {  0,  1,  8,  9 },
        {  4,  5, 12, 13 },
        {  2,  3, 10, 11 },
        {  6,  7, 14, 15 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
