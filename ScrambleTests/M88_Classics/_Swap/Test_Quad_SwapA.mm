//
//  TestQuadKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_SwapA : XCTestCase

@end

@implementation Test_Quad_SwapA


- (void)testQuad_SwapA_EachMini_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_SwapA_EachMini_2x2_A();

    const M aExpected = {
        {  1,  0,  3,  2 },
        {  4,  5,  6,  7 },
        {  9,  8, 11, 10 },
        { 12, 13, 14, 15 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SwapA_EachMini_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_SwapA_EachMini_2x2_B();

    const M aExpected = {
        {  1,  0,  3,  2 },
        {  4,  5,  6,  7 },
        {  9,  8, 11, 10 },
        { 12, 13, 14, 15 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SwapA_EachMini_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_SwapA_EachMini_2x2_C();

    const M aExpected = {
        {  1,  0,  3,  2 },
        {  4,  5,  6,  7 },
        {  9,  8, 11, 10 },
        { 12, 13, 14, 15 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SwapA_EachMini_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_SwapA_EachMini_2x2_D();

    const M aExpected = {
        {  1,  0,  3,  2 },
        {  4,  5,  6,  7 },
        {  9,  8, 11, 10 },
        { 12, 13, 14, 15 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SwapA_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_SwapA_2x2_A();

    const M aExpected = {
        {  2,  3,  0,  1 },
        {  6,  7,  4,  5 },
        {  8,  9, 10, 11 },
        { 12, 13, 14, 15 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SwapA_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_SwapA_2x2_B();

    const M aExpected = {
        {  2,  3,  0,  1 },
        {  6,  7,  4,  5 },
        {  8,  9, 10, 11 },
        { 12, 13, 14, 15 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SwapA_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_SwapA_2x2_C();

    const M aExpected = {
        {  2,  3,  0,  1 },
        {  6,  7,  4,  5 },
        {  8,  9, 10, 11 },
        { 12, 13, 14, 15 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_SwapA_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_SwapA_2x2_D();

    const M aExpected = {
        {  2,  3,  0,  1 },
        {  6,  7,  4,  5 },
        {  8,  9, 10, 11 },
        { 12, 13, 14, 15 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
