//
//  TestQuadKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_TriadE : XCTestCase

@end

@implementation Test_Quad_TriadE

- (void)testQuad_TriadE_EachMini_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_TriadE_EachMini_2x2_A();

    const M aExpected = {
        {  4,  1,  6,  3 },
        {  5,  0,  7,  2 },
        { 12,  9, 14, 11 },
        { 13,  8, 15, 10 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_TriadE_EachMini_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_TriadE_EachMini_2x2_B();

    const M aExpected = {
        {  4,  1,  6,  3 },
        {  5,  0,  7,  2 },
        { 12,  9, 14, 11 },
        { 13,  8, 15, 10 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_TriadE_EachMini_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_TriadE_EachMini_2x2_C();

    const M aExpected = {
        {  4,  1,  6,  3 },
        {  5,  0,  7,  2 },
        { 12,  9, 14, 11 },
        { 13,  8, 15, 10 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_TriadE_EachMini_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_TriadE_EachMini_2x2_D();

    const M aExpected = {
        {  4,  1,  6,  3 },
        {  5,  0,  7,  2 },
        { 12,  9, 14, 11 },
        { 13,  8, 15, 10 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_TriadE_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_TriadE_2x2_A();

    const M aExpected = {
        {  8,  9,  2,  3 },
        { 12, 13,  6,  7 },
        { 10, 11,  0,  1 },
        { 14, 15,  4,  5 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_TriadE_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_TriadE_2x2_B();

    const M aExpected = {
        {  8,  9,  2,  3 },
        { 12, 13,  6,  7 },
        { 10, 11,  0,  1 },
        { 14, 15,  4,  5 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_TriadE_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_TriadE_2x2_C();

    const M aExpected = {
        {  8,  9,  2,  3 },
        { 12, 13,  6,  7 },
        { 10, 11,  0,  1 },
        { 14, 15,  4,  5 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_TriadE_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_TriadE_2x2_D();

    const M aExpected = {
        {  8,  9,  2,  3 },
        { 12, 13,  6,  7 },
        { 10, 11,  0,  1 },
        { 14, 15,  4,  5 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
