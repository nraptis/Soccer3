//
//  Test_Quad_CrystalA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_CrystalA : XCTestCase

@end

@implementation Test_Quad_CrystalA

- (void)testQuad_CrystalA_4x4_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_CrystalA_4x4_A();

    const M aExpected = {
        {  9, 10,  6,  5 },
        {  8, 11,  7,  4 },
        { 12, 15,  3,  0 },
        { 13, 14,  2,  1 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_CrystalA_4x4_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_CrystalA_4x4_B();

    const M aExpected = {
        {  9, 10,  6,  5 },
        {  8, 11,  7,  4 },
        { 12, 15,  3,  0 },
        { 13, 14,  2,  1 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_CrystalA_4x4_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_CrystalA_4x4_C();

    const M aExpected = {
        {  9, 10,  6,  5 },
        {  8, 11,  7,  4 },
        { 12, 15,  3,  0 },
        { 13, 14,  2,  1 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_CrystalA_4x4_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_CrystalA_4x4_D();

    const M aExpected = {
        {  9, 10,  6,  5 },
        {  8, 11,  7,  4 },
        { 12, 15,  3,  0 },
        { 13, 14,  2,  1 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
