//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SnakeB : XCTestCase

@end

@implementation Test_Full_SnakeB

- (void)testFull_SnakeB_EachQuad_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SnakeB_EachQuad_2x2();

    const M aExpected = {
        { 18, 19,  0,  1, 22, 23,  4,  5 },
        { 26, 27,  8,  9, 30, 31, 12, 13 },
        {  2,  3, 16, 17,  6,  7, 20, 21 },
        { 10, 11, 24, 25, 14, 15, 28, 29 },
        { 50, 51, 32, 33, 54, 55, 36, 37 },
        { 58, 59, 40, 41, 62, 63, 44, 45 },
        { 34, 35, 48, 49, 38, 39, 52, 53 },
        { 42, 43, 56, 57, 46, 47, 60, 61 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SnakeB_EachMini_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SnakeB_EachMini_2x2();

    const M aExpected = {
        {  9,  0, 11,  2, 13,  4, 15,  6 },
        {  1,  8,  3, 10,  5, 12,  7, 14 },
        { 25, 16, 27, 18, 29, 20, 31, 22 },
        { 17, 24, 19, 26, 21, 28, 23, 30 },
        { 41, 32, 43, 34, 45, 36, 47, 38 },
        { 33, 40, 35, 42, 37, 44, 39, 46 },
        { 57, 48, 59, 50, 61, 52, 63, 54 },
        { 49, 56, 51, 58, 53, 60, 55, 62 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}


@end
