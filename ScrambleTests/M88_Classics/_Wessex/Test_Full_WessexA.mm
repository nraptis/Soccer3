//
//  Test_Full_WessexA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_WessexA : XCTestCase

@end

@implementation Test_Full_WessexA

- (void)testFull_WessexA_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WessexA_4x4();

    const M aExpected = {
        {  4,  5, 32, 33, 54, 55, 18, 19 },
        { 12, 13, 40, 41, 62, 63, 26, 27 },
        { 20, 21, 48, 49, 38, 39,  2,  3 },
        { 28, 29, 56, 57, 46, 47, 10, 11 },
        { 52, 53, 34, 35,  6,  7, 16, 17 },
        { 60, 61, 42, 43, 14, 15, 24, 25 },
        { 36, 37, 50, 51, 22, 23,  0,  1 },
        { 44, 45, 58, 59, 30, 31,  8,  9 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_WessexA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WessexA_EachQuad_4x4();

    const M aExpected = {
        {  2, 16, 27,  9,  6, 20, 31, 13 },
        { 10, 24, 19,  1, 14, 28, 23,  5 },
        { 26, 17,  3,  8, 30, 21,  7, 12 },
        { 18, 25, 11,  0, 22, 29, 15,  4 },
        { 34, 48, 59, 41, 38, 52, 63, 45 },
        { 42, 56, 51, 33, 46, 60, 55, 37 },
        { 58, 49, 35, 40, 62, 53, 39, 44 },
        { 50, 57, 43, 32, 54, 61, 47, 36 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_WessexA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WessexA_8x8();

    const M aExpected = {
        { 12, 42, 60, 40, 62, 24, 14, 26 },
        { 13, 43, 61, 41, 63, 25, 15, 27 },
        { 28, 58, 44, 56, 46,  8, 30, 10 },
        { 29, 59, 45, 57, 47,  9, 31, 11 },
        { 52, 34, 54, 32,  6, 16,  4, 18 },
        { 53, 35, 55, 33,  7, 17,  5, 19 },
        { 36, 50, 38, 48, 22,  0, 20,  2 },
        { 37, 51, 39, 49, 23,  1, 21,  3 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
