//
//  TestQuadKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_RotC : XCTestCase

@end

@implementation Test_Quad_RotC

- (void)testQuad_RotC_EachMini_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_RotC_EachMini_2x2_A();

    const M aExpected = {
        {  5,  4,  7,  6 },
        {  1,  0,  3,  2 },
        { 13, 12, 15, 14 },
        {  9,  8, 11, 10 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_RotC_EachMini_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_RotC_EachMini_2x2_B();

    const M aExpected = {
        {  5,  4,  7,  6 },
        {  1,  0,  3,  2 },
        { 13, 12, 15, 14 },
        {  9,  8, 11, 10 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_RotC_EachMini_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_RotC_EachMini_2x2_C();

    const M aExpected = {
        {  5,  4,  7,  6 },
        {  1,  0,  3,  2 },
        { 13, 12, 15, 14 },
        {  9,  8, 11, 10 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_RotC_EachMini_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_RotC_EachMini_2x2_D();

    const M aExpected = {
        {  5,  4,  7,  6 },
        {  1,  0,  3,  2 },
        { 13, 12, 15, 14 },
        {  9,  8, 11, 10 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_RotC_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_RotC_2x2_A();

    const M aExpected = {
        { 10, 11,  8,  9 },
        { 14, 15, 12, 13 },
        {  2,  3,  0,  1 },
        {  6,  7,  4,  5 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_RotC_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_RotC_2x2_B();

    const M aExpected = {
        { 10, 11,  8,  9 },
        { 14, 15, 12, 13 },
        {  2,  3,  0,  1 },
        {  6,  7,  4,  5 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_RotC_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_RotC_2x2_C();

    const M aExpected = {
        { 10, 11,  8,  9 },
        { 14, 15, 12, 13 },
        {  2,  3,  0,  1 },
        {  6,  7,  4,  5 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_RotC_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_RotC_2x2_D();

    const M aExpected = {
        { 10, 11,  8,  9 },
        { 14, 15, 12, 13 },
        {  2,  3,  0,  1 },
        {  6,  7,  4,  5 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}


- (void)testQuad_RotC_4x4_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_RotC_4x4_A();

    const M aExpected = {
        { 15, 14, 13, 12 },
        { 11, 10,  9,  8 },
        {  7,  6,  5,  4 },
        {  3,  2,  1,  0 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_RotC_4x4_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_RotC_4x4_B();

    const M aExpected = {
        { 15, 14, 13, 12 },
        { 11, 10,  9,  8 },
        {  7,  6,  5,  4 },
        {  3,  2,  1,  0 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_RotC_4x4_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_RotC_4x4_C();

    const M aExpected = {
        { 15, 14, 13, 12 },
        { 11, 10,  9,  8 },
        {  7,  6,  5,  4 },
        {  3,  2,  1,  0 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_RotC_4x4_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_RotC_4x4_D();

    const M aExpected = {
        { 15, 14, 13, 12 },
        { 11, 10,  9,  8 },
        {  7,  6,  5,  4 },
        {  3,  2,  1,  0 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
