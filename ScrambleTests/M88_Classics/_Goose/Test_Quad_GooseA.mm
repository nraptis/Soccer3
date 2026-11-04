//
//  Test_Quad_GooseA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_GooseA : XCTestCase

@end

@implementation Test_Quad_GooseA

- (void)testQuad_GooseA_4x4_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_GooseA_4x4_A();

    const M aExpected = {
        {  9, 10, 11,  8 },
        { 13, 14, 15, 12 },
        {  1,  2,  3,  0 },
        {  5,  6,  7,  4 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_GooseA_4x4_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_GooseA_4x4_B();

    const M aExpected = {
        {  9, 10, 11,  8 },
        { 13, 14, 15, 12 },
        {  1,  2,  3,  0 },
        {  5,  6,  7,  4 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_GooseA_4x4_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_GooseA_4x4_C();

    const M aExpected = {
        {  9, 10, 11,  8 },
        { 13, 14, 15, 12 },
        {  1,  2,  3,  0 },
        {  5,  6,  7,  4 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_GooseA_4x4_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_GooseA_4x4_D();

    const M aExpected = {
        {  9, 10, 11,  8 },
        { 13, 14, 15, 12 },
        {  1,  2,  3,  0 },
        {  5,  6,  7,  4 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
