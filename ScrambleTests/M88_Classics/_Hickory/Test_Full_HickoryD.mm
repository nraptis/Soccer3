//
//  Test_Full_HickoryD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_HickoryD : XCTestCase

@end

@implementation Test_Full_HickoryD

- (void)testFull_HickoryD_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HickoryD_4x4();

    const M aExpected = {
        { 48, 49,  6,  7,  0,  1, 50, 51 },
        { 56, 57, 14, 15,  8,  9, 58, 59 },
        { 54, 55,  4,  5,  2,  3, 52, 53 },
        { 62, 63, 12, 13, 10, 11, 60, 61 },
        { 36, 37, 22, 23, 20, 21, 34, 35 },
        { 44, 45, 30, 31, 28, 29, 42, 43 },
        { 38, 39, 16, 17, 18, 19, 32, 33 },
        { 46, 47, 24, 25, 26, 27, 40, 41 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_HickoryD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HickoryD_EachQuad_4x4();

    const M aExpected = {
        { 24,  3,  0, 25, 28,  7,  4, 29 },
        { 27,  2,  1, 26, 31,  6,  5, 30 },
        { 18, 11, 10, 17, 22, 15, 14, 21 },
        { 19,  8,  9, 16, 23, 12, 13, 20 },
        { 56, 35, 32, 57, 60, 39, 36, 61 },
        { 59, 34, 33, 58, 63, 38, 37, 62 },
        { 50, 43, 42, 49, 54, 47, 46, 53 },
        { 51, 40, 41, 48, 55, 44, 45, 52 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_HickoryD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HickoryD_8x8();

    const M aExpected = {
        { 41, 23,  6, 56, 59,  1, 16, 42 },
        { 39, 25,  8, 54, 49, 11, 26, 32 },
        { 47, 21,  4, 62, 61,  3, 18, 44 },
        { 37, 31, 14, 52, 51, 13, 28, 34 },
        { 36, 30, 15, 53, 50, 12, 29, 35 },
        { 46, 20,  5, 63, 60,  2, 19, 45 },
        { 38, 24,  9, 55, 48, 10, 27, 33 },
        { 40, 22,  7, 57, 58,  0, 17, 43 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
