//
//  Test_Full_GoldB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_GoldB : XCTestCase

@end

@implementation Test_Full_GoldB

- (void)testFull_GoldB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GoldB_EachQuad_4x4();

    const M aExpected = {
        { 11,  3, 16,  8, 15,  7, 20, 12 },
        { 27, 19,  2, 26, 31, 23,  6, 30 },
        {  9,  1, 18, 10, 13,  5, 22, 14 },
        { 25, 17,  0, 24, 29, 21,  4, 28 },
        { 43, 35, 48, 40, 47, 39, 52, 44 },
        { 59, 51, 34, 58, 63, 55, 38, 62 },
        { 41, 33, 50, 42, 45, 37, 54, 46 },
        { 57, 49, 32, 56, 61, 53, 36, 60 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_GoldB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GoldB_8x8();

    const M aExpected = {
        { 31, 23, 15,  7, 40, 32, 24, 16 },
        { 63, 55, 47, 39, 14,  6, 62, 54 },
        { 29, 21, 13,  5, 46, 38, 30, 22 },
        { 61, 53, 45, 37, 12,  4, 60, 52 },
        { 27, 19, 11,  3, 44, 36, 28, 20 },
        { 59, 51, 43, 35, 10,  2, 58, 50 },
        { 25, 17,  9,  1, 42, 34, 26, 18 },
        { 57, 49, 41, 33,  8,  0, 56, 48 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
