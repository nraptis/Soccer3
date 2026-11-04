//
//  TestQuadKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_TriadG : XCTestCase

@end

@implementation Test_Quad_TriadG

- (void)testQuad_TriadG_EachMini_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_TriadG_EachMini_2x2_A();

    const M aExpected = {
        {  0,  4,  2,  6 },
        {  5,  1,  7,  3 },
        {  8, 12, 10, 14 },
        { 13,  9, 15, 11 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_TriadG_EachMini_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_TriadG_EachMini_2x2_B();

    const M aExpected = {
        {  0,  4,  2,  6 },
        {  5,  1,  7,  3 },
        {  8, 12, 10, 14 },
        { 13,  9, 15, 11 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_TriadG_EachMini_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_TriadG_EachMini_2x2_C();

    const M aExpected = {
        {  0,  4,  2,  6 },
        {  5,  1,  7,  3 },
        {  8, 12, 10, 14 },
        { 13,  9, 15, 11 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_TriadG_EachMini_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_TriadG_EachMini_2x2_D();

    const M aExpected = {
        {  0,  4,  2,  6 },
        {  5,  1,  7,  3 },
        {  8, 12, 10, 14 },
        { 13,  9, 15, 11 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_TriadG_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_TriadG_2x2_A();

    const M aExpected = {
        {  0,  1,  8,  9 },
        {  4,  5, 12, 13 },
        { 10, 11,  2,  3 },
        { 14, 15,  6,  7 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_TriadG_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_TriadG_2x2_B();

    const M aExpected = {
        {  0,  1,  8,  9 },
        {  4,  5, 12, 13 },
        { 10, 11,  2,  3 },
        { 14, 15,  6,  7 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_TriadG_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_TriadG_2x2_C();

    const M aExpected = {
        {  0,  1,  8,  9 },
        {  4,  5, 12, 13 },
        { 10, 11,  2,  3 },
        { 14, 15,  6,  7 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_TriadG_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_TriadG_2x2_D();

    const M aExpected = {
        {  0,  1,  8,  9 },
        {  4,  5, 12, 13 },
        { 10, 11,  2,  3 },
        { 14, 15,  6,  7 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
