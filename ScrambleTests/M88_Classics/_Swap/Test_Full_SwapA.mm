//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SwapA : XCTestCase

@end

@implementation Test_Full_SwapA

- (void)testFull_SwapA_EachQuad_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SwapA_EachQuad_2x2();

    const M aExpected = {
        {  2,  3,  0,  1,  6,  7,  4,  5 },
        { 10, 11,  8,  9, 14, 15, 12, 13 },
        { 16, 17, 18, 19, 20, 21, 22, 23 },
        { 24, 25, 26, 27, 28, 29, 30, 31 },
        { 34, 35, 32, 33, 38, 39, 36, 37 },
        { 42, 43, 40, 41, 46, 47, 44, 45 },
        { 48, 49, 50, 51, 52, 53, 54, 55 },
        { 56, 57, 58, 59, 60, 61, 62, 63 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SwapA_EachMini_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SwapA_EachMini_2x2();

    const M aExpected = {
        {  1,  0,  3,  2,  5,  4,  7,  6 },
        {  8,  9, 10, 11, 12, 13, 14, 15 },
        { 17, 16, 19, 18, 21, 20, 23, 22 },
        { 24, 25, 26, 27, 28, 29, 30, 31 },
        { 33, 32, 35, 34, 37, 36, 39, 38 },
        { 40, 41, 42, 43, 44, 45, 46, 47 },
        { 49, 48, 51, 50, 53, 52, 55, 54 },
        { 56, 57, 58, 59, 60, 61, 62, 63 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
