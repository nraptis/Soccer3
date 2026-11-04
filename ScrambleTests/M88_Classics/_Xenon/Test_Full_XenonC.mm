//
//  Test_Full_XenonC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_XenonC : XCTestCase

@end

@implementation Test_Full_XenonC

- (void)testFull_XenonC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_XenonC_EachQuad_4x4();

    const M aExpected = {
        { 18,  0, 11, 25, 22,  4, 15, 29 },
        { 26,  8,  3, 17, 30, 12,  7, 21 },
        { 10,  1, 19, 24, 14,  5, 23, 28 },
        {  2,  9, 27, 16,  6, 13, 31, 20 },
        { 50, 32, 43, 57, 54, 36, 47, 61 },
        { 58, 40, 35, 49, 62, 44, 39, 53 },
        { 42, 33, 51, 56, 46, 37, 55, 60 },
        { 34, 41, 59, 48, 38, 45, 63, 52 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_XenonC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_XenonC_8x8();

    const M aExpected = {
        { 45, 11, 29,  9, 31, 57, 47, 59 },
        { 44, 10, 28,  8, 30, 56, 46, 58 },
        { 61, 27, 13, 25, 15, 41, 63, 43 },
        { 60, 26, 12, 24, 14, 40, 62, 42 },
        { 21,  3, 23,  1, 39, 49, 37, 51 },
        { 20,  2, 22,  0, 38, 48, 36, 50 },
        {  5, 19,  7, 17, 55, 33, 53, 35 },
        {  4, 18,  6, 16, 54, 32, 52, 34 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
