//
//  Test_Full_PeridotD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_PeridotD : XCTestCase

@end

@implementation Test_Full_PeridotD

- (void)testFull_PeridotD_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PeridotD_4x4();

    const M aExpected = {
        { 22, 23, 38, 39, 32, 33, 16, 17 },
        { 30, 31, 46, 47, 40, 41, 24, 25 },
        {  6,  7, 54, 55, 48, 49,  0,  1 },
        { 14, 15, 62, 63, 56, 57,  8,  9 },
        {  4,  5, 52, 53, 50, 51,  2,  3 },
        { 12, 13, 60, 61, 58, 59, 10, 11 },
        { 20, 21, 36, 37, 34, 35, 18, 19 },
        { 28, 29, 44, 45, 42, 43, 26, 27 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PeridotD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PeridotD_EachQuad_4x4();

    const M aExpected = {
        { 11, 19, 16,  8, 15, 23, 20, 12 },
        {  3, 27, 24,  0,  7, 31, 28,  4 },
        {  2, 26, 25,  1,  6, 30, 29,  5 },
        { 10, 18, 17,  9, 14, 22, 21, 13 },
        { 43, 51, 48, 40, 47, 55, 52, 44 },
        { 35, 59, 56, 32, 39, 63, 60, 36 },
        { 34, 58, 57, 33, 38, 62, 61, 37 },
        { 42, 50, 49, 41, 46, 54, 53, 45 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PeridotD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PeridotD_8x8();

    const M aExpected = {
        { 31, 39, 36, 28, 27, 35, 32, 24 },
        { 23, 47, 44, 20, 19, 43, 40, 16 },
        { 15, 55, 52, 12, 11, 51, 48,  8 },
        {  7, 63, 60,  4,  3, 59, 56,  0 },
        {  6, 62, 61,  5,  2, 58, 57,  1 },
        { 14, 54, 53, 13, 10, 50, 49,  9 },
        { 22, 46, 45, 21, 18, 42, 41, 17 },
        { 30, 38, 37, 29, 26, 34, 33, 25 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
