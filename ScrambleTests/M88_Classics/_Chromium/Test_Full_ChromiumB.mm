//
//  Test_Full_ChromiumB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_ChromiumB : XCTestCase

@end

@implementation Test_Full_ChromiumB

- (void)testFull_ChromiumB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ChromiumB_EachQuad_4x4();

    const M aExpected = {
        {  9, 17,  0,  8, 13, 21,  4, 12 },
        { 25,  1, 16, 24, 29,  5, 20, 28 },
        { 11, 19,  2, 10, 15, 23,  6, 14 },
        { 27,  3, 18, 26, 31,  7, 22, 30 },
        { 41, 49, 32, 40, 45, 53, 36, 44 },
        { 57, 33, 48, 56, 61, 37, 52, 60 },
        { 43, 51, 34, 42, 47, 55, 38, 46 },
        { 59, 35, 50, 58, 63, 39, 54, 62 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_ChromiumB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ChromiumB_8x8();

    const M aExpected = {
        { 17, 25, 33, 41,  0,  8, 16, 24 },
        { 49, 57,  1,  9, 32, 40, 48, 56 },
        { 19, 27, 35, 43,  2, 10, 18, 26 },
        { 51, 59,  3, 11, 34, 42, 50, 58 },
        { 21, 29, 37, 45,  4, 12, 20, 28 },
        { 53, 61,  5, 13, 36, 44, 52, 60 },
        { 23, 31, 39, 47,  6, 14, 22, 30 },
        { 55, 63,  7, 15, 38, 46, 54, 62 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
