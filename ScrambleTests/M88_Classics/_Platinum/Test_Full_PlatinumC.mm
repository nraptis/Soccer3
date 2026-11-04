//
//  Test_Full_PlatinumC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_PlatinumC : XCTestCase

@end

@implementation Test_Full_PlatinumC

- (void)testFull_PlatinumC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PlatinumC_EachQuad_4x4();

    const M aExpected = {
        { 26, 10, 24,  8, 30, 14, 28, 12 },
        { 19,  3, 17,  1, 23,  7, 21,  5 },
        { 27, 11, 25,  9, 31, 15, 29, 13 },
        { 16,  0, 18,  2, 20,  4, 22,  6 },
        { 58, 42, 56, 40, 62, 46, 60, 44 },
        { 51, 35, 49, 33, 55, 39, 53, 37 },
        { 59, 43, 57, 41, 63, 47, 61, 45 },
        { 48, 32, 50, 34, 52, 36, 54, 38 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PlatinumC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PlatinumC_8x8();

    const M aExpected = {
        { 60, 28, 62, 30, 56, 24, 58, 26 },
        { 54, 22, 48, 16, 50, 18, 52, 20 },
        { 44, 12, 46, 14, 40,  8, 42, 10 },
        { 38,  6, 32,  0, 34,  2, 36,  4 },
        { 61, 29, 63, 31, 57, 25, 59, 27 },
        { 55, 23, 49, 17, 51, 19, 53, 21 },
        { 45, 13, 47, 15, 41,  9, 43, 11 },
        { 39,  7, 33,  1, 35,  3, 37,  5 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
