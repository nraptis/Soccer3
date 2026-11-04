//
//  Test_Full_SteelB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SteelB : XCTestCase

@end

@implementation Test_Full_SteelB

- (void)testFull_SteelB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SteelB_EachQuad_4x4();

    const M aExpected = {
        { 25, 18, 26, 19, 29, 22, 30, 23 },
        {  9,  2,  8,  1, 13,  6, 12,  5 },
        { 27, 16, 24, 17, 31, 20, 28, 21 },
        { 11,  0, 10,  3, 15,  4, 14,  7 },
        { 57, 50, 58, 51, 61, 54, 62, 55 },
        { 41, 34, 40, 33, 45, 38, 44, 37 },
        { 59, 48, 56, 49, 63, 52, 60, 53 },
        { 43, 32, 42, 35, 47, 36, 46, 39 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SteelB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SteelB_8x8();

    const M aExpected = {
        { 59, 53, 43, 37, 60, 54, 44, 38 },
        { 27, 21, 11,  5, 26, 20, 10,  4 },
        { 57, 51, 41, 35, 58, 52, 42, 36 },
        { 25, 19,  9,  3, 24, 18,  8,  2 },
        { 63, 49, 47, 33, 56, 50, 40, 34 },
        { 31, 17, 15,  1, 30, 16, 14,  0 },
        { 61, 55, 45, 39, 62, 48, 46, 32 },
        { 29, 23, 13,  7, 28, 22, 12,  6 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
