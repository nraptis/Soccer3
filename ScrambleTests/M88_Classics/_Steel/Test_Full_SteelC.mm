//
//  Test_Full_SteelC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SteelC : XCTestCase

@end

@implementation Test_Full_SteelC

- (void)testFull_SteelC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SteelC_EachQuad_4x4();

    const M aExpected = {
        { 11, 27,  9, 25, 15, 31, 13, 29 },
        {  0, 16,  2, 18,  4, 20,  6, 22 },
        { 10, 24,  8, 26, 14, 28, 12, 30 },
        {  3, 17,  1, 19,  7, 21,  5, 23 },
        { 43, 59, 41, 57, 47, 63, 45, 61 },
        { 32, 48, 34, 50, 36, 52, 38, 54 },
        { 42, 56, 40, 58, 46, 60, 44, 62 },
        { 35, 49, 33, 51, 39, 53, 37, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SteelC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SteelC_8x8();

    const M aExpected = {
        { 29, 61, 31, 63, 25, 57, 27, 59 },
        { 23, 55, 17, 49, 19, 51, 21, 53 },
        { 13, 45, 15, 47,  9, 41, 11, 43 },
        {  7, 39,  1, 33,  3, 35,  5, 37 },
        { 28, 62, 30, 56, 24, 58, 26, 60 },
        { 22, 48, 16, 50, 18, 52, 20, 54 },
        { 12, 46, 14, 40,  8, 42, 10, 44 },
        {  6, 32,  0, 34,  2, 36,  4, 38 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
