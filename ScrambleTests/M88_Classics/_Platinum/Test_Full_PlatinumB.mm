//
//  Test_Full_PlatinumB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_PlatinumB : XCTestCase

@end

@implementation Test_Full_PlatinumB

- (void)testFull_PlatinumB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PlatinumB_EachQuad_4x4();

    const M aExpected = {
        {  8,  1,  9,  2, 12,  5, 13,  6 },
        { 24, 17, 25, 18, 28, 21, 29, 22 },
        { 10,  3, 11,  0, 14,  7, 15,  4 },
        { 26, 19, 27, 16, 30, 23, 31, 20 },
        { 40, 33, 41, 34, 44, 37, 45, 38 },
        { 56, 49, 57, 50, 60, 53, 61, 54 },
        { 42, 35, 43, 32, 46, 39, 47, 36 },
        { 58, 51, 59, 48, 62, 55, 63, 52 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PlatinumB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PlatinumB_8x8();

    const M aExpected = {
        { 26, 20, 10,  4, 27, 21, 11,  5 },
        { 58, 52, 42, 36, 59, 53, 43, 37 },
        { 24, 18,  8,  2, 25, 19,  9,  3 },
        { 56, 50, 40, 34, 57, 51, 41, 35 },
        { 30, 16, 14,  0, 31, 17, 15,  1 },
        { 62, 48, 46, 32, 63, 49, 47, 33 },
        { 28, 22, 12,  6, 29, 23, 13,  7 },
        { 60, 54, 44, 38, 61, 55, 45, 39 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
