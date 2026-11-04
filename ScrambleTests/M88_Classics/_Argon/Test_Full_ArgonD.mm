//
//  Test_Full_ArgonD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_ArgonD : XCTestCase

@end

@implementation Test_Full_ArgonD

- (void)testFull_ArgonD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ArgonD_EachQuad_4x4();

    const M aExpected = {
        { 10, 24, 19,  1, 14, 28, 23,  5 },
        {  2, 16, 27,  9,  6, 20, 31, 13 },
        { 18, 25, 11,  0, 22, 29, 15,  4 },
        { 26, 17,  3,  8, 30, 21,  7, 12 },
        { 42, 56, 51, 33, 46, 60, 55, 37 },
        { 34, 48, 59, 41, 38, 52, 63, 45 },
        { 50, 57, 43, 32, 54, 61, 47, 36 },
        { 58, 49, 35, 40, 62, 53, 39, 44 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_ArgonD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ArgonD_8x8();

    const M aExpected = {
        { 20, 50, 36, 48, 38,  0, 22,  2 },
        { 21, 51, 37, 49, 39,  1, 23,  3 },
        {  4, 34, 52, 32, 54, 16,  6, 18 },
        {  5, 35, 53, 33, 55, 17,  7, 19 },
        { 44, 58, 46, 56, 30,  8, 28, 10 },
        { 45, 59, 47, 57, 31,  9, 29, 11 },
        { 60, 42, 62, 40, 14, 24, 12, 26 },
        { 61, 43, 63, 41, 15, 25, 13, 27 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
