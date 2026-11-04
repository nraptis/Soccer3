//
//  Test_Full_ChromiumA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_ChromiumA : XCTestCase

@end

@implementation Test_Full_ChromiumA

- (void)testFull_ChromiumA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ChromiumA_EachQuad_4x4();

    const M aExpected = {
        {  8, 24, 10, 26, 12, 28, 14, 30 },
        {  0, 16,  2, 18,  4, 20,  6, 22 },
        { 17,  1, 19,  3, 21,  5, 23,  7 },
        {  9, 25, 11, 27, 13, 29, 15, 31 },
        { 40, 56, 42, 58, 44, 60, 46, 62 },
        { 32, 48, 34, 50, 36, 52, 38, 54 },
        { 49, 33, 51, 35, 53, 37, 55, 39 },
        { 41, 57, 43, 59, 45, 61, 47, 63 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_ChromiumA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ChromiumA_8x8();

    const M aExpected = {
        { 24, 56, 26, 58, 28, 60, 30, 62 },
        { 16, 48, 18, 50, 20, 52, 22, 54 },
        {  8, 40, 10, 42, 12, 44, 14, 46 },
        {  0, 32,  2, 34,  4, 36,  6, 38 },
        { 41,  9, 43, 11, 45, 13, 47, 15 },
        { 33,  1, 35,  3, 37,  5, 39,  7 },
        { 25, 57, 27, 59, 29, 61, 31, 63 },
        { 17, 49, 19, 51, 21, 53, 23, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
