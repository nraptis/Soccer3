//
//  Test_Full_YorkA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_YorkA : XCTestCase

@end

@implementation Test_Full_YorkA

- (void)testFull_YorkA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_YorkA_EachQuad_4x4();

    const M aExpected = {
        {  3, 17, 26,  8,  7, 21, 30, 12 },
        { 11, 25, 18,  0, 15, 29, 22,  4 },
        { 27, 16,  2,  9, 31, 20,  6, 13 },
        { 19, 24, 10,  1, 23, 28, 14,  5 },
        { 35, 49, 58, 40, 39, 53, 62, 44 },
        { 43, 57, 50, 32, 47, 61, 54, 36 },
        { 59, 48, 34, 41, 63, 52, 38, 45 },
        { 51, 56, 42, 33, 55, 60, 46, 37 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_YorkA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_YorkA_8x8();

    const M aExpected = {
        {  6, 32, 54, 34, 52, 18,  4, 16 },
        {  7, 33, 55, 35, 53, 19,  5, 17 },
        { 22, 48, 38, 50, 36,  2, 20,  0 },
        { 23, 49, 39, 51, 37,  3, 21,  1 },
        { 62, 40, 60, 42, 12, 26, 14, 24 },
        { 63, 41, 61, 43, 13, 27, 15, 25 },
        { 46, 56, 44, 58, 28, 10, 30,  8 },
        { 47, 57, 45, 59, 29, 11, 31,  9 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
