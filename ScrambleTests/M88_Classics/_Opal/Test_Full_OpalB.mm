//
//  Test_Full_OpalB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_OpalB : XCTestCase

@end

@implementation Test_Full_OpalB

- (void)testFull_OpalB_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_OpalB_4x4();

    const M aExpected = {
        { 38, 39, 54, 55, 52, 53, 36, 37 },
        { 46, 47, 62, 63, 60, 61, 44, 45 },
        { 22, 23,  6,  7,  4,  5, 20, 21 },
        { 30, 31, 14, 15, 12, 13, 28, 29 },
        { 16, 17,  0,  1,  2,  3, 18, 19 },
        { 24, 25,  8,  9, 10, 11, 26, 27 },
        { 32, 33, 48, 49, 50, 51, 34, 35 },
        { 40, 41, 56, 57, 58, 59, 42, 43 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_OpalB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_OpalB_EachQuad_4x4();

    const M aExpected = {
        { 19, 27, 26, 18, 23, 31, 30, 22 },
        { 11,  3,  2, 10, 15,  7,  6, 14 },
        {  8,  0,  1,  9, 12,  4,  5, 13 },
        { 16, 24, 25, 17, 20, 28, 29, 21 },
        { 51, 59, 58, 50, 55, 63, 62, 54 },
        { 43, 35, 34, 42, 47, 39, 38, 46 },
        { 40, 32, 33, 41, 44, 36, 37, 45 },
        { 48, 56, 57, 49, 52, 60, 61, 53 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_OpalB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_OpalB_8x8();

    const M aExpected = {
        { 39, 47, 55, 63, 62, 54, 46, 38 },
        { 31, 23, 15,  7,  6, 14, 22, 30 },
        { 28, 20, 12,  4,  5, 13, 21, 29 },
        { 36, 44, 52, 60, 61, 53, 45, 37 },
        { 35, 43, 51, 59, 58, 50, 42, 34 },
        { 27, 19, 11,  3,  2, 10, 18, 26 },
        { 24, 16,  8,  0,  1,  9, 17, 25 },
        { 32, 40, 48, 56, 57, 49, 41, 33 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
