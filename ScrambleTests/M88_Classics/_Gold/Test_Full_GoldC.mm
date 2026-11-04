//
//  Test_Full_GoldC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_GoldC : XCTestCase

@end

@implementation Test_Full_GoldC

- (void)testFull_GoldC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GoldC_EachQuad_4x4();

    const M aExpected = {
        { 25,  9, 27, 11, 29, 13, 31, 15 },
        { 17,  1, 19,  3, 21,  5, 23,  7 },
        {  0, 18,  2, 16,  4, 22,  6, 20 },
        { 24, 10, 26,  8, 28, 14, 30, 12 },
        { 57, 41, 59, 43, 61, 45, 63, 47 },
        { 49, 33, 51, 35, 53, 37, 55, 39 },
        { 32, 50, 34, 48, 36, 54, 38, 52 },
        { 56, 42, 58, 40, 60, 46, 62, 44 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_GoldC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GoldC_8x8();

    const M aExpected = {
        { 57, 25, 59, 27, 61, 29, 63, 31 },
        { 49, 17, 51, 19, 53, 21, 55, 23 },
        { 41,  9, 43, 11, 45, 13, 47, 15 },
        { 33,  1, 35,  3, 37,  5, 39,  7 },
        {  8, 42, 10, 44, 12, 46, 14, 40 },
        {  0, 34,  2, 36,  4, 38,  6, 32 },
        { 56, 26, 58, 28, 60, 30, 62, 24 },
        { 48, 18, 50, 20, 52, 22, 54, 16 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
