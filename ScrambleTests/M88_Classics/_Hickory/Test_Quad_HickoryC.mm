//
//  Test_Quad_HickoryC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_HickoryC : XCTestCase

@end

@implementation Test_Quad_HickoryC

- (void)testQuad_HickoryC_4x4_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_HickoryC_4x4_A();

    const M aExpected = {
        {  4, 11,  8,  5 },
        {  7, 10,  9,  6 },
        {  2, 15, 14,  1 },
        {  3, 12, 13,  0 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_HickoryC_4x4_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_HickoryC_4x4_B();

    const M aExpected = {
        {  4, 11,  8,  5 },
        {  7, 10,  9,  6 },
        {  2, 15, 14,  1 },
        {  3, 12, 13,  0 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_HickoryC_4x4_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_HickoryC_4x4_C();

    const M aExpected = {
        {  4, 11,  8,  5 },
        {  7, 10,  9,  6 },
        {  2, 15, 14,  1 },
        {  3, 12, 13,  0 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testQuad_HickoryC_4x4_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_HickoryC_4x4_D();

    const M aExpected = {
        {  4, 11,  8,  5 },
        {  7, 10,  9,  6 },
        {  2, 15, 14,  1 },
        {  3, 12, 13,  0 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
