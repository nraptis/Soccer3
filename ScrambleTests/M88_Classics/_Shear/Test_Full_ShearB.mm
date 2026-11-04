//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_ShearB : XCTestCase

@end

@implementation Test_Full_ShearB

- (void)testFull_ShearB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ShearB_EachQuad_4x4();

    const M aExpected = {
        {  3,  0,  1,  2,  7,  4,  5,  6 },
        { 10, 11,  8,  9, 14, 15, 12, 13 },
        { 19, 16, 17, 18, 23, 20, 21, 22 },
        { 26, 27, 24, 25, 30, 31, 28, 29 },
        { 35, 32, 33, 34, 39, 36, 37, 38 },
        { 42, 43, 40, 41, 46, 47, 44, 45 },
        { 51, 48, 49, 50, 55, 52, 53, 54 },
        { 58, 59, 56, 57, 62, 63, 60, 61 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}


- (void)testFull_ShearB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ShearB_8x8();

    const M aExpected = {
        {  6,  7,  0,  1,  2,  3,  4,  5 },
        { 12, 13, 14, 15,  8,  9, 10, 11 },
        { 22, 23, 16, 17, 18, 19, 20, 21 },
        { 28, 29, 30, 31, 24, 25, 26, 27 },
        { 38, 39, 32, 33, 34, 35, 36, 37 },
        { 44, 45, 46, 47, 40, 41, 42, 43 },
        { 54, 55, 48, 49, 50, 51, 52, 53 },
        { 60, 61, 62, 63, 56, 57, 58, 59 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
