//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_ShearD : XCTestCase

@end

@implementation Test_Full_ShearD

- (void)testFull_ShearD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ShearD_EachQuad_4x4();

    const M aExpected = {
        { 24, 17, 26, 19, 28, 21, 30, 23 },
        {  0, 25,  2, 27,  4, 29,  6, 31 },
        {  8,  1, 10,  3, 12,  5, 14,  7 },
        { 16,  9, 18, 11, 20, 13, 22, 15 },
        { 56, 49, 58, 51, 60, 53, 62, 55 },
        { 32, 57, 34, 59, 36, 61, 38, 63 },
        { 40, 33, 42, 35, 44, 37, 46, 39 },
        { 48, 41, 50, 43, 52, 45, 54, 47 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_ShearD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ShearD_8x8();

    const M aExpected = {
        { 48, 33, 50, 35, 52, 37, 54, 39 },
        { 56, 41, 58, 43, 60, 45, 62, 47 },
        {  0, 49,  2, 51,  4, 53,  6, 55 },
        {  8, 57, 10, 59, 12, 61, 14, 63 },
        { 16,  1, 18,  3, 20,  5, 22,  7 },
        { 24,  9, 26, 11, 28, 13, 30, 15 },
        { 32, 17, 34, 19, 36, 21, 38, 23 },
        { 40, 25, 42, 27, 44, 29, 46, 31 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
