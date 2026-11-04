//
//  TestQuadKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_FlipA : XCTestCase

@end

@implementation Test_Quad_FlipA

- (void)testQuad_FlipA_EachMini_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipA_EachMini_2x2_A();

    const M aExpected = {
        {  1,  0,  3,  2 },
        {  5,  4,  7,  6 },
        {  9,  8, 11, 10 },
        { 13, 12, 15, 14 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipA_EachMini_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipA_EachMini_2x2_B();

    const M aExpected = {
        {  1,  0,  3,  2 },
        {  5,  4,  7,  6 },
        {  9,  8, 11, 10 },
        { 13, 12, 15, 14 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipA_EachMini_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipA_EachMini_2x2_C();

    const M aExpected = {
        {  1,  0,  3,  2 },
        {  5,  4,  7,  6 },
        {  9,  8, 11, 10 },
        { 13, 12, 15, 14 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipA_EachMini_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipA_EachMini_2x2_D();

    const M aExpected = {
        {  1,  0,  3,  2 },
        {  5,  4,  7,  6 },
        {  9,  8, 11, 10 },
        { 13, 12, 15, 14 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipA_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipA_2x2_A();

    const M aExpected = {
        {  2,  3,  0,  1 },
        {  6,  7,  4,  5 },
        { 10, 11,  8,  9 },
        { 14, 15, 12, 13 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipA_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipA_2x2_B();

    const M aExpected = {
        {  2,  3,  0,  1 },
        {  6,  7,  4,  5 },
        { 10, 11,  8,  9 },
        { 14, 15, 12, 13 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipA_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipA_2x2_C();

    const M aExpected = {
        {  2,  3,  0,  1 },
        {  6,  7,  4,  5 },
        { 10, 11,  8,  9 },
        { 14, 15, 12, 13 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipA_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipA_2x2_D();

    const M aExpected = {
        {  2,  3,  0,  1 },
        {  6,  7,  4,  5 },
        { 10, 11,  8,  9 },
        { 14, 15, 12, 13 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipA_4x4_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipA_4x4_A();

    const M aExpected = {
        {  3,  2,  1,  0 },
        {  7,  6,  5,  4 },
        { 11, 10,  9,  8 },
        { 15, 14, 13, 12 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipA_4x4_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipA_4x4_B();

    const M aExpected = {
        {  3,  2,  1,  0 },
        {  7,  6,  5,  4 },
        { 11, 10,  9,  8 },
        { 15, 14, 13, 12 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipA_4x4_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipA_4x4_C();

    const M aExpected = {
        {  3,  2,  1,  0 },
        {  7,  6,  5,  4 },
        { 11, 10,  9,  8 },
        { 15, 14, 13, 12 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipA_4x4_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipA_4x4_D();

    const M aExpected = {
        {  3,  2,  1,  0 },
        {  7,  6,  5,  4 },
        { 11, 10,  9,  8 },
        { 15, 14, 13, 12 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
