//
//  Test_Full_PeridotA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_PeridotA : XCTestCase

@end

@implementation Test_Full_PeridotA

- (void)testFull_PeridotA_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PeridotA_4x4();

    const M aExpected = {
        { 50, 51, 48, 49, 32, 33, 34, 35 },
        { 58, 59, 56, 57, 40, 41, 42, 43 },
        { 52, 53, 54, 55, 38, 39, 36, 37 },
        { 60, 61, 62, 63, 46, 47, 44, 45 },
        {  4,  5,  6,  7, 22, 23, 20, 21 },
        { 12, 13, 14, 15, 30, 31, 28, 29 },
        {  2,  3,  0,  1, 16, 17, 18, 19 },
        { 10, 11,  8,  9, 24, 25, 26, 27 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PeridotA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PeridotA_EachQuad_4x4();

    const M aExpected = {
        { 25, 24, 16, 17, 29, 28, 20, 21 },
        { 26, 27, 19, 18, 30, 31, 23, 22 },
        {  2,  3, 11, 10,  6,  7, 15, 14 },
        {  1,  0,  8,  9,  5,  4, 12, 13 },
        { 57, 56, 48, 49, 61, 60, 52, 53 },
        { 58, 59, 51, 50, 62, 63, 55, 54 },
        { 34, 35, 43, 42, 38, 39, 47, 46 },
        { 33, 32, 40, 41, 37, 36, 44, 45 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PeridotA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PeridotA_8x8();

    const M aExpected = {
        { 59, 58, 57, 56, 48, 49, 50, 51 },
        { 60, 61, 62, 63, 55, 54, 53, 52 },
        { 36, 37, 38, 39, 47, 46, 45, 44 },
        { 35, 34, 33, 32, 40, 41, 42, 43 },
        { 27, 26, 25, 24, 16, 17, 18, 19 },
        { 28, 29, 30, 31, 23, 22, 21, 20 },
        {  4,  5,  6,  7, 15, 14, 13, 12 },
        {  3,  2,  1,  0,  8,  9, 10, 11 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
