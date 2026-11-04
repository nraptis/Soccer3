//
//  Test_Full_SwanB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SwanB : XCTestCase

@end

@implementation Test_Full_SwanB

- (void)testFull_SwanB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SwanB_EachQuad_4x4();

    const M aExpected = {
        {  9,  1, 27, 19, 13,  5, 31, 23 },
        {  8,  0, 24, 16, 12,  4, 28, 20 },
        { 11,  3, 25, 17, 15,  7, 29, 21 },
        { 10,  2, 26, 18, 14,  6, 30, 22 },
        { 41, 33, 59, 51, 45, 37, 63, 55 },
        { 40, 32, 56, 48, 44, 36, 60, 52 },
        { 43, 35, 57, 49, 47, 39, 61, 53 },
        { 42, 34, 58, 50, 46, 38, 62, 54 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SwanB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SwanB_8x8();

    const M aExpected = {
        { 25, 17,  9,  1, 63, 55, 47, 39 },
        { 24, 16,  8,  0, 56, 48, 40, 32 },
        { 27, 19, 11,  3, 57, 49, 41, 33 },
        { 26, 18, 10,  2, 58, 50, 42, 34 },
        { 29, 21, 13,  5, 59, 51, 43, 35 },
        { 28, 20, 12,  4, 60, 52, 44, 36 },
        { 31, 23, 15,  7, 61, 53, 45, 37 },
        { 30, 22, 14,  6, 62, 54, 46, 38 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
