//
//  Test_Full_ArgonA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_ArgonA : XCTestCase

@end

@implementation Test_Full_ArgonA

- (void)testFull_ArgonA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ArgonA_EachQuad_4x4();

    const M aExpected = {
        {  8,  0,  3, 11, 12,  4,  7, 15 },
        {  9,  1,  2, 10, 13,  5,  6, 14 },
        { 17, 25, 26, 18, 21, 29, 30, 22 },
        { 16, 24, 27, 19, 20, 28, 31, 23 },
        { 40, 32, 35, 43, 44, 36, 39, 47 },
        { 41, 33, 34, 42, 45, 37, 38, 46 },
        { 49, 57, 58, 50, 53, 61, 62, 54 },
        { 48, 56, 59, 51, 52, 60, 63, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_ArgonA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ArgonA_8x8();

    const M aExpected = {
        { 16, 17,  0,  1,  6,  7, 22, 23 },
        { 24, 25,  8,  9, 14, 15, 30, 31 },
        { 18, 19,  2,  3,  4,  5, 20, 21 },
        { 26, 27, 10, 11, 12, 13, 28, 29 },
        { 34, 35, 50, 51, 52, 53, 36, 37 },
        { 42, 43, 58, 59, 60, 61, 44, 45 },
        { 32, 33, 48, 49, 54, 55, 38, 39 },
        { 40, 41, 56, 57, 62, 63, 46, 47 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
