//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_FlipB : XCTestCase

@end

@implementation Test_Full_FlipB

- (void)testFull_FlipB_EachQuad_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_FlipB_EachQuad_2x2();

    const M aExpected = {
        { 16, 17, 18, 19, 20, 21, 22, 23 },
        { 24, 25, 26, 27, 28, 29, 30, 31 },
        {  0,  1,  2,  3,  4,  5,  6,  7 },
        {  8,  9, 10, 11, 12, 13, 14, 15 },
        { 48, 49, 50, 51, 52, 53, 54, 55 },
        { 56, 57, 58, 59, 60, 61, 62, 63 },
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

- (void)testFull_FlipB_EachMini_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_FlipB_EachMini_2x2();

    const M aExpected = {
        {  8,  9, 10, 11, 12, 13, 14, 15 },
        {  0,  1,  2,  3,  4,  5,  6,  7 },
        { 24, 25, 26, 27, 28, 29, 30, 31 },
        { 16, 17, 18, 19, 20, 21, 22, 23 },
        { 40, 41, 42, 43, 44, 45, 46, 47 },
        { 32, 33, 34, 35, 36, 37, 38, 39 },
        { 56, 57, 58, 59, 60, 61, 62, 63 },
        { 48, 49, 50, 51, 52, 53, 54, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_FlipB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_FlipB_EachQuad_4x4();

    const M aExpected = {
        { 24, 25, 26, 27, 28, 29, 30, 31 },
        { 16, 17, 18, 19, 20, 21, 22, 23 },
        {  8,  9, 10, 11, 12, 13, 14, 15 },
        {  0,  1,  2,  3,  4,  5,  6,  7 },
        { 56, 57, 58, 59, 60, 61, 62, 63 },
        { 48, 49, 50, 51, 52, 53, 54, 55 },
        { 40, 41, 42, 43, 44, 45, 46, 47 },
        { 32, 33, 34, 35, 36, 37, 38, 39 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_FlipB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_FlipB_8x8();

    const M aExpected = {
        { 56, 57, 58, 59, 60, 61, 62, 63 },
        { 48, 49, 50, 51, 52, 53, 54, 55 },
        { 40, 41, 42, 43, 44, 45, 46, 47 },
        { 32, 33, 34, 35, 36, 37, 38, 39 },
        { 24, 25, 26, 27, 28, 29, 30, 31 },
        { 16, 17, 18, 19, 20, 21, 22, 23 },
        {  8,  9, 10, 11, 12, 13, 14, 15 },
        {  0,  1,  2,  3,  4,  5,  6,  7 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
