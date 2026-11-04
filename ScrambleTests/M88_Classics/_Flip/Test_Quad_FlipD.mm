//
//  TestQuadKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_FlipD : XCTestCase

@end

@implementation Test_Quad_FlipD

- (void)testQuad_FlipD_EachMini_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipD_EachMini_2x2_A();

    const M aExpected = {
        {  5,  1,  7,  3 },
        {  4,  0,  6,  2 },
        { 13,  9, 15, 11 },
        { 12,  8, 14, 10 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipD_EachMini_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipD_EachMini_2x2_B();

    const M aExpected = {
        {  5,  1,  7,  3 },
        {  4,  0,  6,  2 },
        { 13,  9, 15, 11 },
        { 12,  8, 14, 10 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipD_EachMini_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipD_EachMini_2x2_C();

    const M aExpected = {
        {  5,  1,  7,  3 },
        {  4,  0,  6,  2 },
        { 13,  9, 15, 11 },
        { 12,  8, 14, 10 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipD_EachMini_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipD_EachMini_2x2_D();

    const M aExpected = {
        {  5,  1,  7,  3 },
        {  4,  0,  6,  2 },
        { 13,  9, 15, 11 },
        { 12,  8, 14, 10 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipD_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipD_2x2_A();

    const M aExpected = {
        { 10, 11,  2,  3 },
        { 14, 15,  6,  7 },
        {  8,  9,  0,  1 },
        { 12, 13,  4,  5 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipD_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipD_2x2_B();

    const M aExpected = {
        { 10, 11,  2,  3 },
        { 14, 15,  6,  7 },
        {  8,  9,  0,  1 },
        { 12, 13,  4,  5 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipD_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipD_2x2_C();

    const M aExpected = {
        { 10, 11,  2,  3 },
        { 14, 15,  6,  7 },
        {  8,  9,  0,  1 },
        { 12, 13,  4,  5 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_FlipD_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_FlipD_2x2_D();

    const M aExpected = {
        { 10, 11,  2,  3 },
        { 14, 15,  6,  7 },
        {  8,  9,  0,  1 },
        { 12, 13,  4,  5 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}


@end
