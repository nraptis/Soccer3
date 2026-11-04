//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SwapD : XCTestCase

@end

@implementation Test_Full_SwapD

- (void)testFull_SwapD_EachQuad_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SwapD_EachQuad_2x2();

    const M aExpected = {
        {  0,  1,  2,  3,  4,  5,  6,  7 },
        {  8,  9, 10, 11, 12, 13, 14, 15 },
        { 18, 19, 16, 17, 22, 23, 20, 21 },
        { 26, 27, 24, 25, 30, 31, 28, 29 },
        { 32, 33, 34, 35, 36, 37, 38, 39 },
        { 40, 41, 42, 43, 44, 45, 46, 47 },
        { 50, 51, 48, 49, 54, 55, 52, 53 },
        { 58, 59, 56, 57, 62, 63, 60, 61 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SwapD_EachMini_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SwapD_EachMini_2x2();

    const M aExpected = {
        {  0,  1,  2,  3,  4,  5,  6,  7 },
        {  9,  8, 11, 10, 13, 12, 15, 14 },
        { 16, 17, 18, 19, 20, 21, 22, 23 },
        { 25, 24, 27, 26, 29, 28, 31, 30 },
        { 32, 33, 34, 35, 36, 37, 38, 39 },
        { 41, 40, 43, 42, 45, 44, 47, 46 },
        { 48, 49, 50, 51, 52, 53, 54, 55 },
        { 57, 56, 59, 58, 61, 60, 63, 62 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
