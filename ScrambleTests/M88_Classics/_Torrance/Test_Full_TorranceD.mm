//
//  Test_Full_TorranceD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_TorranceD : XCTestCase

@end

@implementation Test_Full_TorranceD

- (void)testFull_TorranceD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_TorranceD_EachQuad_4x4();

    const M aExpected = {
        { 18, 16, 11,  9, 22, 20, 15, 13 },
        { 24, 17,  1,  8, 28, 21,  5, 12 },
        { 25, 27,  0,  2, 29, 31,  4,  6 },
        { 19, 26, 10,  3, 23, 30, 14,  7 },
        { 50, 48, 43, 41, 54, 52, 47, 45 },
        { 56, 49, 33, 40, 60, 53, 37, 44 },
        { 57, 59, 32, 34, 61, 63, 36, 38 },
        { 51, 58, 42, 35, 55, 62, 46, 39 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_TorranceD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_TorranceD_8x8();

    const M aExpected = {
        { 44, 57, 60, 41, 30, 11, 14, 27 },
        { 36, 49, 52, 33, 22,  3,  6, 19 },
        { 56, 59, 40, 43, 10,  9, 26, 25 },
        { 48, 51, 32, 35,  2,  1, 18, 17 },
        { 58, 47, 42, 63,  8, 29, 24, 13 },
        { 50, 39, 34, 55,  0, 21, 16,  5 },
        { 46, 45, 62, 61, 28, 31, 12, 15 },
        { 38, 37, 54, 53, 20, 23,  4,  7 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
