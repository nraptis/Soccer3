//
//  Test_Full_WillowD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_WillowD : XCTestCase

@end

@implementation Test_Full_WillowD

- (void)testFull_WillowD_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WillowD_4x4();

    const M aExpected = {
        { 38, 39, 32, 33, 16, 17, 22, 23 },
        { 46, 47, 40, 41, 24, 25, 30, 31 },
        { 54, 55, 48, 49,  0,  1,  6,  7 },
        { 62, 63, 56, 57,  8,  9, 14, 15 },
        { 52, 53, 50, 51,  2,  3,  4,  5 },
        { 60, 61, 58, 59, 10, 11, 12, 13 },
        { 36, 37, 34, 35, 18, 19, 20, 21 },
        { 44, 45, 42, 43, 26, 27, 28, 29 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_WillowD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WillowD_EachQuad_4x4();

    const M aExpected = {
        { 19, 16,  8, 11, 23, 20, 12, 15 },
        { 27, 24,  0,  3, 31, 28,  4,  7 },
        { 26, 25,  1,  2, 30, 29,  5,  6 },
        { 18, 17,  9, 10, 22, 21, 13, 14 },
        { 51, 48, 40, 43, 55, 52, 44, 47 },
        { 59, 56, 32, 35, 63, 60, 36, 39 },
        { 58, 57, 33, 34, 62, 61, 37, 38 },
        { 50, 49, 41, 42, 54, 53, 45, 46 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_WillowD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WillowD_8x8();

    const M aExpected = {
        { 44, 43, 33, 38, 30, 25, 19, 20 },
        { 45, 42, 32, 39, 31, 24, 18, 21 },
        { 60, 59, 49, 54, 14,  9,  3,  4 },
        { 61, 58, 48, 55, 15,  8,  2,  5 },
        { 53, 50, 56, 63,  7,  0, 10, 13 },
        { 52, 51, 57, 62,  6,  1, 11, 12 },
        { 37, 34, 40, 47, 23, 16, 26, 29 },
        { 36, 35, 41, 46, 22, 17, 27, 28 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
