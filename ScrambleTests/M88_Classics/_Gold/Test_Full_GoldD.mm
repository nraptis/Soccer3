//
//  Test_Full_GoldD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_GoldD : XCTestCase

@end

@implementation Test_Full_GoldD

- (void)testFull_GoldD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GoldD_EachQuad_4x4();

    const M aExpected = {
        { 24,  0, 17, 25, 28,  4, 21, 29 },
        { 10, 18,  1,  9, 14, 22,  5, 13 },
        { 26,  2, 19, 27, 30,  6, 23, 31 },
        {  8, 16,  3, 11, 12, 20,  7, 15 },
        { 56, 32, 49, 57, 60, 36, 53, 61 },
        { 42, 50, 33, 41, 46, 54, 37, 45 },
        { 58, 34, 51, 59, 62, 38, 55, 63 },
        { 40, 48, 35, 43, 44, 52, 39, 47 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_GoldD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GoldD_8x8();

    const M aExpected = {
        { 48, 56,  0,  8, 33, 41, 49, 57 },
        { 18, 26, 34, 42,  1,  9, 17, 25 },
        { 50, 58,  2, 10, 35, 43, 51, 59 },
        { 20, 28, 36, 44,  3, 11, 19, 27 },
        { 52, 60,  4, 12, 37, 45, 53, 61 },
        { 22, 30, 38, 46,  5, 13, 21, 29 },
        { 54, 62,  6, 14, 39, 47, 55, 63 },
        { 16, 24, 32, 40,  7, 15, 23, 31 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
