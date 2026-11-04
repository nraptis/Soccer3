//
//  Test_Full_TokyoB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_TokyoB : XCTestCase

@end

@implementation Test_Full_TokyoB

- (void)testFull_TokyoB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_TokyoB_EachQuad_4x4();

    const M aExpected = {
        {  0,  9, 11,  2,  4, 13, 15,  6 },
        {  8, 24,  3, 19, 12, 28,  7, 23 },
        { 25, 16, 18, 27, 29, 20, 22, 31 },
        { 17,  1, 26, 10, 21,  5, 30, 14 },
        { 32, 41, 43, 34, 36, 45, 47, 38 },
        { 40, 56, 35, 51, 44, 60, 39, 55 },
        { 57, 48, 50, 59, 61, 52, 54, 63 },
        { 49, 33, 58, 42, 53, 37, 62, 46 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_TokyoB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_TokyoB_8x8();

    const M aExpected = {
        {  8, 16, 10, 18, 30,  6, 28,  4 },
        {  9, 17, 11, 19, 31,  7, 29,  5 },
        { 24, 50, 26, 48, 14, 36, 12, 38 },
        { 25, 51, 27, 49, 15, 37, 13, 39 },
        { 58, 34, 56, 32, 44, 52, 46, 54 },
        { 59, 35, 57, 33, 45, 53, 47, 55 },
        { 42,  0, 40,  2, 60, 22, 62, 20 },
        { 43,  1, 41,  3, 61, 23, 63, 21 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
