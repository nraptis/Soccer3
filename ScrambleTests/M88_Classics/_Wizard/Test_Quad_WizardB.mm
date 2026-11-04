//
//  Test_Quad_WizardB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_WizardB : XCTestCase

@end

@implementation Test_Quad_WizardB

- (void)testQuad_WizardB_4x4_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_WizardB_4x4_A();

    const M aExpected = {
        {  0,  4, 11,  2 },
        {  5, 12,  3,  7 },
        {  1,  8, 10, 14 },
        {  9, 13, 15,  6 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_WizardB_4x4_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_WizardB_4x4_B();

    const M aExpected = {
        {  0,  4, 11,  2 },
        {  5, 12,  3,  7 },
        {  1,  8, 10, 14 },
        {  9, 13, 15,  6 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_WizardB_4x4_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_WizardB_4x4_C();

    const M aExpected = {
        {  0,  4, 11,  2 },
        {  5, 12,  3,  7 },
        {  1,  8, 10, 14 },
        {  9, 13, 15,  6 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_WizardB_4x4_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_WizardB_4x4_D();

    const M aExpected = {
        {  0,  4, 11,  2 },
        {  5, 12,  3,  7 },
        {  1,  8, 10, 14 },
        {  9, 13, 15,  6 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
