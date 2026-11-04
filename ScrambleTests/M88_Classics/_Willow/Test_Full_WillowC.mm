//
//  Test_Full_WillowC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_WillowC : XCTestCase

@end

@implementation Test_Full_WillowC

- (void)testFull_WillowC_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WillowC_4x4();

    const M aExpected = {
        { 34, 35, 36, 37, 20, 21, 18, 19 },
        { 42, 43, 44, 45, 28, 29, 26, 27 },
        { 50, 51, 52, 53,  4,  5,  2,  3 },
        { 58, 59, 60, 61, 12, 13, 10, 11 },
        { 48, 49, 54, 55,  6,  7,  0,  1 },
        { 56, 57, 62, 63, 14, 15,  8,  9 },
        { 32, 33, 38, 39, 22, 23, 16, 17 },
        { 40, 41, 46, 47, 30, 31, 24, 25 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_WillowC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WillowC_EachQuad_4x4();

    const M aExpected = {
        { 17, 18, 10,  9, 21, 22, 14, 13 },
        { 25, 26,  2,  1, 29, 30,  6,  5 },
        { 24, 27,  3,  0, 28, 31,  7,  4 },
        { 16, 19, 11,  8, 20, 23, 15, 12 },
        { 49, 50, 42, 41, 53, 54, 46, 45 },
        { 57, 58, 34, 33, 61, 62, 38, 37 },
        { 56, 59, 35, 32, 60, 63, 39, 36 },
        { 48, 51, 43, 40, 52, 55, 47, 44 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_WillowC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WillowC_8x8();

    const M aExpected = {
        { 35, 36, 46, 41, 17, 22, 28, 27 },
        { 34, 37, 47, 40, 16, 23, 29, 26 },
        { 51, 52, 62, 57,  1,  6, 12, 11 },
        { 50, 53, 63, 56,  0,  7, 13, 10 },
        { 58, 61, 55, 48,  8, 15,  5,  2 },
        { 59, 60, 54, 49,  9, 14,  4,  3 },
        { 42, 45, 39, 32, 24, 31, 21, 18 },
        { 43, 44, 38, 33, 25, 30, 20, 19 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
