//
//  Test_Full_GooseB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_GooseB : XCTestCase

@end

@implementation Test_Full_GooseB

- (void)testFull_GooseB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GooseB_EachQuad_4x4();

    const M aExpected = {
        {  9,  1, 25, 17, 13,  5, 29, 21 },
        { 10,  2, 26, 18, 14,  6, 30, 22 },
        { 11,  3, 27, 19, 15,  7, 31, 23 },
        {  8,  0, 24, 16, 12,  4, 28, 20 },
        { 41, 33, 57, 49, 45, 37, 61, 53 },
        { 42, 34, 58, 50, 46, 38, 62, 54 },
        { 43, 35, 59, 51, 47, 39, 63, 55 },
        { 40, 32, 56, 48, 44, 36, 60, 52 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_GooseB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GooseB_8x8();

    const M aExpected = {
        { 25, 17,  9,  1, 57, 49, 41, 33 },
        { 26, 18, 10,  2, 58, 50, 42, 34 },
        { 27, 19, 11,  3, 59, 51, 43, 35 },
        { 28, 20, 12,  4, 60, 52, 44, 36 },
        { 29, 21, 13,  5, 61, 53, 45, 37 },
        { 30, 22, 14,  6, 62, 54, 46, 38 },
        { 31, 23, 15,  7, 63, 55, 47, 39 },
        { 24, 16,  8,  0, 56, 48, 40, 32 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
