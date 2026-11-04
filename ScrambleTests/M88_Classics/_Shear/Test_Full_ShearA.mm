//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_ShearA : XCTestCase

@end

@implementation Test_Full_ShearA

- (void)testFull_ShearA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ShearA_EachQuad_4x4();

    const M aExpected = {
        {  2,  3,  0,  1,  6,  7,  4,  5 },
        { 11,  8,  9, 10, 15, 12, 13, 14 },
        { 18, 19, 16, 17, 22, 23, 20, 21 },
        { 27, 24, 25, 26, 31, 28, 29, 30 },
        { 34, 35, 32, 33, 38, 39, 36, 37 },
        { 43, 40, 41, 42, 47, 44, 45, 46 },
        { 50, 51, 48, 49, 54, 55, 52, 53 },
        { 59, 56, 57, 58, 63, 60, 61, 62 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

// ============================================================
// ShearA 8x8 tests
// ============================================================

- (void)testFull_ShearA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ShearA_8x8();

    const M aExpected = {
        {  4,  5,  6,  7,  0,  1,  2,  3 },
        { 14, 15,  8,  9, 10, 11, 12, 13 },
        { 20, 21, 22, 23, 16, 17, 18, 19 },
        { 30, 31, 24, 25, 26, 27, 28, 29 },
        { 36, 37, 38, 39, 32, 33, 34, 35 },
        { 46, 47, 40, 41, 42, 43, 44, 45 },
        { 52, 53, 54, 55, 48, 49, 50, 51 },
        { 62, 63, 56, 57, 58, 59, 60, 61 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
