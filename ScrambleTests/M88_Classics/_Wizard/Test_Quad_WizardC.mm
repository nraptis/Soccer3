//
//  Test_Quad_WizardC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_WizardC : XCTestCase

@end

@implementation Test_Quad_WizardC

- (void)testQuad_WizardC_4x4_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_WizardC_4x4_A();

    const M aExpected = {
        {  4,  1,  7,  5 },
        {  2,  0,  6,  3 },
        { 13, 15, 14, 11 },
        { 12,  9,  8, 10 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_WizardC_4x4_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_WizardC_4x4_B();

    const M aExpected = {
        {  4,  1,  7,  5 },
        {  2,  0,  6,  3 },
        { 13, 15, 14, 11 },
        { 12,  9,  8, 10 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_WizardC_4x4_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_WizardC_4x4_C();

    const M aExpected = {
        {  4,  1,  7,  5 },
        {  2,  0,  6,  3 },
        { 13, 15, 14, 11 },
        { 12,  9,  8, 10 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_WizardC_4x4_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_WizardC_4x4_D();

    const M aExpected = {
        {  4,  1,  7,  5 },
        {  2,  0,  6,  3 },
        { 13, 15, 14, 11 },
        { 12,  9,  8, 10 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
