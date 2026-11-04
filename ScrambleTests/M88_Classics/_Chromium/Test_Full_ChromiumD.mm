//
//  Test_Full_ChromiumD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_ChromiumD : XCTestCase

@end

@implementation Test_Full_ChromiumD

- (void)testFull_ChromiumD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ChromiumD_EachQuad_4x4();

    const M aExpected = {
        { 26, 18,  3, 27, 30, 22,  7, 31 },
        { 10,  2, 19, 11, 14,  6, 23, 15 },
        { 24, 16,  1, 25, 28, 20,  5, 29 },
        {  8,  0, 17,  9, 12,  4, 21, 13 },
        { 58, 50, 35, 59, 62, 54, 39, 63 },
        { 42, 34, 51, 43, 46, 38, 55, 47 },
        { 56, 48, 33, 57, 60, 52, 37, 61 },
        { 40, 32, 49, 41, 44, 36, 53, 45 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_ChromiumD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ChromiumD_8x8();

    const M aExpected = {
        { 62, 54, 46, 38, 15,  7, 63, 55 },
        { 30, 22, 14,  6, 47, 39, 31, 23 },
        { 60, 52, 44, 36, 13,  5, 61, 53 },
        { 28, 20, 12,  4, 45, 37, 29, 21 },
        { 58, 50, 42, 34, 11,  3, 59, 51 },
        { 26, 18, 10,  2, 43, 35, 27, 19 },
        { 56, 48, 40, 32,  9,  1, 57, 49 },
        { 24, 16,  8,  0, 41, 33, 25, 17 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
