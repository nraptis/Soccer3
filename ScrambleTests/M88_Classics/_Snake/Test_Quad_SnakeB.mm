//
//  TestQuadKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_SnakeB : XCTestCase

@end

@implementation Test_Quad_SnakeB

- (void)testQuad_SnakeB_EachMini_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_SnakeB_EachMini_2x2_A();

    const M aExpected = {
        {  5,  0,  7,  2 },
        {  1,  4,  3,  6 },
        { 13,  8, 15, 10 },
        {  9, 12, 11, 14 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SnakeB_EachMini_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_SnakeB_EachMini_2x2_B();

    const M aExpected = {
        {  5,  0,  7,  2 },
        {  1,  4,  3,  6 },
        { 13,  8, 15, 10 },
        {  9, 12, 11, 14 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SnakeB_EachMini_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_SnakeB_EachMini_2x2_C();

    const M aExpected = {
        {  5,  0,  7,  2 },
        {  1,  4,  3,  6 },
        { 13,  8, 15, 10 },
        {  9, 12, 11, 14 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SnakeB_EachMini_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_SnakeB_EachMini_2x2_D();

    const M aExpected = {
        {  5,  0,  7,  2 },
        {  1,  4,  3,  6 },
        { 13,  8, 15, 10 },
        {  9, 12, 11, 14 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SnakeB_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_SnakeB_2x2_A();

    const M aExpected = {
        { 10, 11,  0,  1 },
        { 14, 15,  4,  5 },
        {  2,  3,  8,  9 },
        {  6,  7, 12, 13 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SnakeB_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_SnakeB_2x2_B();

    const M aExpected = {
        { 10, 11,  0,  1 },
        { 14, 15,  4,  5 },
        {  2,  3,  8,  9 },
        {  6,  7, 12, 13 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SnakeB_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_SnakeB_2x2_C();

    const M aExpected = {
        { 10, 11,  0,  1 },
        { 14, 15,  4,  5 },
        {  2,  3,  8,  9 },
        {  6,  7, 12, 13 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SnakeB_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_SnakeB_2x2_D();

    const M aExpected = {
        { 10, 11,  0,  1 },
        { 14, 15,  4,  5 },
        {  2,  3,  8,  9 },
        {  6,  7, 12, 13 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
