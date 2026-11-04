//
//  TestQuadRotA.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyQuad.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Quad_RotA : XCTestCase

@end

@implementation Test_Quad_RotA

- (void)testQuad_RotA_EachMini_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_RotA_EachMini_2x2_A();

    const M aExpected = {
        {  4,  0,  6,  2 },
        {  5,  1,  7,  3 },
        { 12,  8, 14, 10 },
        { 13,  9, 15, 11 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    } else {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        NSLog(@"%s succeeded", sel_getName(_cmd));
    }
}

- (void)testQuad_RotA_EachMini_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_RotA_EachMini_2x2_B();

    const M aExpected = {
        {  4,  0,  6,  2 },
        {  5,  1,  7,  3 },
        { 12,  8, 14, 10 },
        { 13,  9, 15, 11 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    } else {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        NSLog(@"%s succeeded", sel_getName(_cmd));
    }
}

- (void)testQuad_RotA_EachMini_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_RotA_EachMini_2x2_C();

    const M aExpected = {
        {  4,  0,  6,  2 },
        {  5,  1,  7,  3 },
        { 12,  8, 14, 10 },
        { 13,  9, 15, 11 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    } else {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        NSLog(@"%s succeeded", sel_getName(_cmd));
    }
}

- (void)testQuad_RotA_EachMini_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_RotA_EachMini_2x2_D();

    const M aExpected = {
        {  4,  0,  6,  2 },
        {  5,  1,  7,  3 },
        { 12,  8, 14, 10 },
        { 13,  9, 15, 11 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    } else {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        NSLog(@"%s succeeded", sel_getName(_cmd));
    }
}

- (void)testQuad_RotA_2x2_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_RotA_2x2_A();

    const M aExpected = {
        {  8,  9,  0,  1 },
        { 12, 13,  4,  5 },
        { 10, 11,  2,  3 },
        { 14, 15,  6,  7 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    } else {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        NSLog(@"%s succeeded", sel_getName(_cmd));
    }
}

- (void)testQuad_RotA_2x2_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_RotA_2x2_B();

    const M aExpected = {
        {  8,  9,  0,  1 },
        { 12, 13,  4,  5 },
        { 10, 11,  2,  3 },
        { 14, 15,  6,  7 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    } else {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        NSLog(@"%s succeeded", sel_getName(_cmd));
    }
}

- (void)testQuad_RotA_2x2_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_RotA_2x2_C();

    const M aExpected = {
        {  8,  9,  0,  1 },
        { 12, 13,  4,  5 },
        { 10, 11,  2,  3 },
        { 14, 15,  6,  7 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    } else {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        NSLog(@"%s succeeded", sel_getName(_cmd));
    }
}

- (void)testQuad_RotA_2x2_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_RotA_2x2_D();

    const M aExpected = {
        {  8,  9,  0,  1 },
        { 12, 13,  4,  5 },
        { 10, 11,  2,  3 },
        { 14, 15,  6,  7 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    } else {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        NSLog(@"%s succeeded", sel_getName(_cmd));
    }
}



- (void)testQuad_RotA_4x4_A {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadA();
    M88 aAfter = aBefore;

    aAfter.Quad_RotA_4x4_A();

    const M aExpected = {
        { 12,  8,  4,  0 },
        { 13,  9,  5,  1 },
        { 14, 10,  6,  2 },
        { 15, 11,  7,  3 }
    };

    if (!VerifyQuad::CheckQuadA(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    } else {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        NSLog(@"%s succeeded", sel_getName(_cmd));
    }
}

- (void)testQuad_RotA_4x4_B {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadB();
    M88 aAfter = aBefore;

    aAfter.Quad_RotA_4x4_B();

    const M aExpected = {
        { 12,  8,  4,  0 },
        { 13,  9,  5,  1 },
        { 14, 10,  6,  2 },
        { 15, 11,  7,  3 }
    };

    if (!VerifyQuad::CheckQuadB(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    } else {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        NSLog(@"%s succeeded", sel_getName(_cmd));
    }
}

- (void)testQuad_RotA_4x4_C {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadC();
    M88 aAfter = aBefore;

    aAfter.Quad_RotA_4x4_C();

    const M aExpected = {
        { 12,  8,  4,  0 },
        { 13,  9,  5,  1 },
        { 14, 10,  6,  2 },
        { 15, 11,  7,  3 }
    };

    if (!VerifyQuad::CheckQuadC(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    } else {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        NSLog(@"%s succeeded", sel_getName(_cmd));
    }
}

- (void)testQuad_RotA_4x4_D {
    M88 aBefore = VerifyQuad::SpawnTestMatrixQuadD();
    M88 aAfter = aBefore;

    aAfter.Quad_RotA_4x4_D();

    const M aExpected = {
        { 12,  8,  4,  0 },
        { 13,  9,  5,  1 },
        { 14, 10,  6,  2 },
        { 15, 11,  7,  3 }
    };

    if (!VerifyQuad::CheckQuadD(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    } else {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        NSLog(@"%s succeeded", sel_getName(_cmd));
    }
}


@end
