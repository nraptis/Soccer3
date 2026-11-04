//
//  Test_Full_ChromiumC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_ChromiumC : XCTestCase

@end

@implementation Test_Full_ChromiumC

- (void)testFull_ChromiumC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ChromiumC_EachQuad_4x4();

    const M aExpected = {
        { 27, 11, 25,  9, 31, 15, 29, 13 },
        {  3, 19,  1, 17,  7, 23,  5, 21 },
        { 18,  2, 16,  0, 22,  6, 20,  4 },
        { 26, 10, 24,  8, 30, 14, 28, 12 },
        { 59, 43, 57, 41, 63, 47, 61, 45 },
        { 35, 51, 33, 49, 39, 55, 37, 53 },
        { 50, 34, 48, 32, 54, 38, 52, 36 },
        { 58, 42, 56, 40, 62, 46, 60, 44 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_ChromiumC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ChromiumC_8x8();

    const M aExpected = {
        { 55, 23, 53, 21, 51, 19, 49, 17 },
        { 63, 31, 61, 29, 59, 27, 57, 25 },
        {  7, 39,  5, 37,  3, 35,  1, 33 },
        { 15, 47, 13, 45, 11, 43,  9, 41 },
        { 38,  6, 36,  4, 34,  2, 32,  0 },
        { 46, 14, 44, 12, 42, 10, 40,  8 },
        { 54, 22, 52, 20, 50, 18, 48, 16 },
        { 62, 30, 60, 28, 58, 26, 56, 24 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
