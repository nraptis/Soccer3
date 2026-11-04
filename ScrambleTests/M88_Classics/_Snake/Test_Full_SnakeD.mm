//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SnakeD : XCTestCase

@end

@implementation Test_Full_SnakeD

- (void)testFull_SnakeD_EachQuad_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SnakeD_EachQuad_2x2();

    const M aExpected = {
        { 18, 19, 16, 17, 22, 23, 20, 21 },
        { 26, 27, 24, 25, 30, 31, 28, 29 },
        {  0,  1,  2,  3,  4,  5,  6,  7 },
        {  8,  9, 10, 11, 12, 13, 14, 15 },
        { 50, 51, 48, 49, 54, 55, 52, 53 },
        { 58, 59, 56, 57, 62, 63, 60, 61 },
        { 32, 33, 34, 35, 36, 37, 38, 39 },
        { 40, 41, 42, 43, 44, 45, 46, 47 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SnakeD_EachMini_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SnakeD_EachMini_2x2();

    const M aExpected = {
        {  9,  8, 11, 10, 13, 12, 15, 14 },
        {  0,  1,  2,  3,  4,  5,  6,  7 },
        { 25, 24, 27, 26, 29, 28, 31, 30 },
        { 16, 17, 18, 19, 20, 21, 22, 23 },
        { 41, 40, 43, 42, 45, 44, 47, 46 },
        { 32, 33, 34, 35, 36, 37, 38, 39 },
        { 57, 56, 59, 58, 61, 60, 63, 62 },
        { 48, 49, 50, 51, 52, 53, 54, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
