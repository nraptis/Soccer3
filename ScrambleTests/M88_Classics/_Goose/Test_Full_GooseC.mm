//
//  Test_Full_GooseC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_GooseC : XCTestCase

@end

@implementation Test_Full_GooseC

- (void)testFull_GooseC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GooseC_EachQuad_4x4();

    const M aExpected = {
        {  8, 11, 10,  9, 12, 15, 14, 13 },
        {  0,  3,  2,  1,  4,  7,  6,  5 },
        { 24, 27, 26, 25, 28, 31, 30, 29 },
        { 16, 19, 18, 17, 20, 23, 22, 21 },
        { 40, 43, 42, 41, 44, 47, 46, 45 },
        { 32, 35, 34, 33, 36, 39, 38, 37 },
        { 56, 59, 58, 57, 60, 63, 62, 61 },
        { 48, 51, 50, 49, 52, 55, 54, 53 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_GooseC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GooseC_8x8();

    const M aExpected = {
        { 24, 31, 30, 29, 28, 27, 26, 25 },
        { 16, 23, 22, 21, 20, 19, 18, 17 },
        {  8, 15, 14, 13, 12, 11, 10,  9 },
        {  0,  7,  6,  5,  4,  3,  2,  1 },
        { 56, 63, 62, 61, 60, 59, 58, 57 },
        { 48, 55, 54, 53, 52, 51, 50, 49 },
        { 40, 47, 46, 45, 44, 43, 42, 41 },
        { 32, 39, 38, 37, 36, 35, 34, 33 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
