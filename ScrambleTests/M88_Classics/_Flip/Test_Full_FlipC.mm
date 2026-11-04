//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_FlipC : XCTestCase

@end

@implementation Test_Full_FlipC

- (void)testFull_FlipC_EachQuad_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_FlipC_EachQuad_2x2();

    const M aExpected = {
        {  0,  1, 16, 17,  4,  5, 20, 21 },
        {  8,  9, 24, 25, 12, 13, 28, 29 },
        {  2,  3, 18, 19,  6,  7, 22, 23 },
        { 10, 11, 26, 27, 14, 15, 30, 31 },
        { 32, 33, 48, 49, 36, 37, 52, 53 },
        { 40, 41, 56, 57, 44, 45, 60, 61 },
        { 34, 35, 50, 51, 38, 39, 54, 55 },
        { 42, 43, 58, 59, 46, 47, 62, 63 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_FlipC_EachMini_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_FlipC_EachMini_2x2();

    const M aExpected = {
        {  0,  8,  2, 10,  4, 12,  6, 14 },
        {  1,  9,  3, 11,  5, 13,  7, 15 },
        { 16, 24, 18, 26, 20, 28, 22, 30 },
        { 17, 25, 19, 27, 21, 29, 23, 31 },
        { 32, 40, 34, 42, 36, 44, 38, 46 },
        { 33, 41, 35, 43, 37, 45, 39, 47 },
        { 48, 56, 50, 58, 52, 60, 54, 62 },
        { 49, 57, 51, 59, 53, 61, 55, 63 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}


@end
