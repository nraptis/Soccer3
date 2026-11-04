//
//  Test_Quad_NaraD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_NaraD : XCTestCase

@end

@implementation Test_Quad_NaraD

- (void)testQuad_NaraD_4x4_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_NaraD_4x4_A();

    const M aExpected = {
        {  5,  0,  2,  7 },
        { 12,  4, 11,  3 },
        {  8, 13, 15, 10 },
        {  1,  9,  6, 14 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_NaraD_4x4_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_NaraD_4x4_B();

    const M aExpected = {
        {  5,  0,  2,  7 },
        { 12,  4, 11,  3 },
        {  8, 13, 15, 10 },
        {  1,  9,  6, 14 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_NaraD_4x4_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_NaraD_4x4_C();

    const M aExpected = {
        {  5,  0,  2,  7 },
        { 12,  4, 11,  3 },
        {  8, 13, 15, 10 },
        {  1,  9,  6, 14 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_NaraD_4x4_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_NaraD_4x4_D();

    const M aExpected = {
        {  5,  0,  2,  7 },
        { 12,  4, 11,  3 },
        {  8, 13, 15, 10 },
        {  1,  9,  6, 14 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
