//
//  Test_Full_WessexB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_WessexB : XCTestCase

@end

@implementation Test_Full_WessexB

- (void)testFull_WessexB_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WessexB_4x4();

    const M aExpected = {
        { 34, 35, 52, 53, 16, 17,  6,  7 },
        { 42, 43, 60, 61, 24, 25, 14, 15 },
        { 50, 51, 36, 37,  0,  1, 22, 23 },
        { 58, 59, 44, 45,  8,  9, 30, 31 },
        { 18, 19, 54, 55, 32, 33,  4,  5 },
        { 26, 27, 62, 63, 40, 41, 12, 13 },
        {  2,  3, 38, 39, 48, 49, 20, 21 },
        { 10, 11, 46, 47, 56, 57, 28, 29 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_WessexB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WessexB_EachQuad_4x4();

    const M aExpected = {
        { 17, 26,  8,  3, 21, 30, 12,  7 },
        { 25, 18,  0, 11, 29, 22,  4, 15 },
        {  9, 27, 16,  2, 13, 31, 20,  6 },
        {  1, 19, 24, 10,  5, 23, 28, 14 },
        { 49, 58, 40, 35, 53, 62, 44, 39 },
        { 57, 50, 32, 43, 61, 54, 36, 47 },
        { 41, 59, 48, 34, 45, 63, 52, 38 },
        { 33, 51, 56, 42, 37, 55, 60, 46 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_WessexB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WessexB_8x8();

    const M aExpected = {
        { 34, 52, 32, 54, 16,  6, 18,  4 },
        { 35, 53, 33, 55, 17,  7, 19,  5 },
        { 50, 36, 48, 38,  0, 22,  2, 20 },
        { 51, 37, 49, 39,  1, 23,  3, 21 },
        { 26, 60, 42, 62, 40, 14, 24, 12 },
        { 27, 61, 43, 63, 41, 15, 25, 13 },
        { 10, 44, 58, 46, 56, 30,  8, 28 },
        { 11, 45, 59, 47, 57, 31,  9, 29 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
