//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SwapC : XCTestCase

@end

@implementation Test_Full_SwapC

- (void)testFull_SwapC_EachQuad_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SwapC_EachQuad_2x2();

    const M aExpected = {
        {  0,  1, 18, 19,  4,  5, 22, 23 },
        {  8,  9, 26, 27, 12, 13, 30, 31 },
        { 16, 17,  2,  3, 20, 21,  6,  7 },
        { 24, 25, 10, 11, 28, 29, 14, 15 },
        { 32, 33, 50, 51, 36, 37, 54, 55 },
        { 40, 41, 58, 59, 44, 45, 62, 63 },
        { 48, 49, 34, 35, 52, 53, 38, 39 },
        { 56, 57, 42, 43, 60, 61, 46, 47 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SwapC_EachMini_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SwapC_EachMini_2x2();

    const M aExpected = {
        {  0,  9,  2, 11,  4, 13,  6, 15 },
        {  8,  1, 10,  3, 12,  5, 14,  7 },
        { 16, 25, 18, 27, 20, 29, 22, 31 },
        { 24, 17, 26, 19, 28, 21, 30, 23 },
        { 32, 41, 34, 43, 36, 45, 38, 47 },
        { 40, 33, 42, 35, 44, 37, 46, 39 },
        { 48, 57, 50, 59, 52, 61, 54, 63 },
        { 56, 49, 58, 51, 60, 53, 62, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
