//
//  Test_Full_WillowA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_WillowA : XCTestCase

@end

@implementation Test_Full_WillowA

- (void)testFull_WillowA_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WillowA_4x4();

    const M aExpected = {
        { 38, 39, 36, 37, 52, 53, 54, 55 },
        { 46, 47, 44, 45, 60, 61, 62, 63 },
        { 22, 23, 20, 21,  4,  5,  6,  7 },
        { 30, 31, 28, 29, 12, 13, 14, 15 },
        { 16, 17, 18, 19,  2,  3,  0,  1 },
        { 24, 25, 26, 27, 10, 11,  8,  9 },
        { 32, 33, 34, 35, 50, 51, 48, 49 },
        { 40, 41, 42, 43, 58, 59, 56, 57 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_WillowA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WillowA_EachQuad_4x4();

    const M aExpected = {
        { 19, 18, 26, 27, 23, 22, 30, 31 },
        { 11, 10,  2,  3, 15, 14,  6,  7 },
        {  8,  9,  1,  0, 12, 13,  5,  4 },
        { 16, 17, 25, 24, 20, 21, 29, 28 },
        { 51, 50, 58, 59, 55, 54, 62, 63 },
        { 43, 42, 34, 35, 47, 46, 38, 39 },
        { 40, 41, 33, 32, 44, 45, 37, 36 },
        { 48, 49, 57, 56, 52, 53, 61, 60 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_WillowA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WillowA_8x8();

    const M aExpected = {
        { 62, 54, 60, 52, 53, 61, 55, 63 },
        {  6, 14,  4, 12, 13,  5, 15,  7 },
        { 23, 31, 21, 29, 28, 20, 30, 22 },
        { 47, 39, 45, 37, 36, 44, 38, 46 },
        { 40, 32, 42, 34, 35, 43, 33, 41 },
        { 16, 24, 18, 26, 27, 19, 25, 17 },
        {  1,  9,  3, 11, 10,  2,  8,  0 },
        { 57, 49, 59, 51, 50, 58, 48, 56 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
