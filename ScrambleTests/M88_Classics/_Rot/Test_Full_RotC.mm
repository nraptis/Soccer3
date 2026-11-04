//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_RotC : XCTestCase

@end

@implementation Test_Full_RotC

- (void)testFull_RotC_EachQuad_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_RotC_EachQuad_2x2();

    const M aExpected = {
        { 18, 19, 16, 17, 22, 23, 20, 21 },
        { 26, 27, 24, 25, 30, 31, 28, 29 },
        {  2,  3,  0,  1,  6,  7,  4,  5 },
        { 10, 11,  8,  9, 14, 15, 12, 13 },
        { 50, 51, 48, 49, 54, 55, 52, 53 },
        { 58, 59, 56, 57, 62, 63, 60, 61 },
        { 34, 35, 32, 33, 38, 39, 36, 37 },
        { 42, 43, 40, 41, 46, 47, 44, 45 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_RotC_EachMini_2x2 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_RotC_EachMini_2x2();

    const M aExpected = {
        {  9,  8, 11, 10, 13, 12, 15, 14 },
        {  1,  0,  3,  2,  5,  4,  7,  6 },
        { 25, 24, 27, 26, 29, 28, 31, 30 },
        { 17, 16, 19, 18, 21, 20, 23, 22 },
        { 41, 40, 43, 42, 45, 44, 47, 46 },
        { 33, 32, 35, 34, 37, 36, 39, 38 },
        { 57, 56, 59, 58, 61, 60, 63, 62 },
        { 49, 48, 51, 50, 53, 52, 55, 54 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_RotC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_RotC_EachQuad_4x4();

    const M aExpected = {
        { 27, 26, 25, 24, 31, 30, 29, 28 },
        { 19, 18, 17, 16, 23, 22, 21, 20 },
        { 11, 10,  9,  8, 15, 14, 13, 12 },
        {  3,  2,  1,  0,  7,  6,  5,  4 },
        { 59, 58, 57, 56, 63, 62, 61, 60 },
        { 51, 50, 49, 48, 55, 54, 53, 52 },
        { 43, 42, 41, 40, 47, 46, 45, 44 },
        { 35, 34, 33, 32, 39, 38, 37, 36 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_RotC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_RotC_8x8();

    const M aExpected = {
        { 63, 62, 61, 60, 59, 58, 57, 56 },
        { 55, 54, 53, 52, 51, 50, 49, 48 },
        { 47, 46, 45, 44, 43, 42, 41, 40 },
        { 39, 38, 37, 36, 35, 34, 33, 32 },
        { 31, 30, 29, 28, 27, 26, 25, 24 },
        { 23, 22, 21, 20, 19, 18, 17, 16 },
        { 15, 14, 13, 12, 11, 10,  9,  8 },
        {  7,  6,  5,  4,  3,  2,  1,  0 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
