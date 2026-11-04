//
//  TestQuadKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_SnakeD : XCTestCase

@end

@implementation Test_Quad_SnakeD

- (void)testQuad_SnakeD_EachMini_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_SnakeD_EachMini_2x2_A();

    const M aExpected = {
        {  5,  4,  7,  6 },
        {  0,  1,  2,  3 },
        { 13, 12, 15, 14 },
        {  8,  9, 10, 11 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SnakeD_EachMini_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_SnakeD_EachMini_2x2_B();

    const M aExpected = {
        {  5,  4,  7,  6 },
        {  0,  1,  2,  3 },
        { 13, 12, 15, 14 },
        {  8,  9, 10, 11 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SnakeD_EachMini_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_SnakeD_EachMini_2x2_C();

    const M aExpected = {
        {  5,  4,  7,  6 },
        {  0,  1,  2,  3 },
        { 13, 12, 15, 14 },
        {  8,  9, 10, 11 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SnakeD_EachMini_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_SnakeD_EachMini_2x2_D();

    const M aExpected = {
        {  5,  4,  7,  6 },
        {  0,  1,  2,  3 },
        { 13, 12, 15, 14 },
        {  8,  9, 10, 11 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SnakeD_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_SnakeD_2x2_A();

    const M aExpected = {
        { 10, 11,  8,  9 },
        { 14, 15, 12, 13 },
        {  0,  1,  2,  3 },
        {  4,  5,  6,  7 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SnakeD_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_SnakeD_2x2_B();

    const M aExpected = {
        { 10, 11,  8,  9 },
        { 14, 15, 12, 13 },
        {  0,  1,  2,  3 },
        {  4,  5,  6,  7 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SnakeD_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_SnakeD_2x2_C();

    const M aExpected = {
        { 10, 11,  8,  9 },
        { 14, 15, 12, 13 },
        {  0,  1,  2,  3 },
        {  4,  5,  6,  7 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SnakeD_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_SnakeD_2x2_D();

    const M aExpected = {
        { 10, 11,  8,  9 },
        { 14, 15, 12, 13 },
        {  0,  1,  2,  3 },
        {  4,  5,  6,  7 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
