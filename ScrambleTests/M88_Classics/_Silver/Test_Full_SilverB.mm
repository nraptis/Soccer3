//
//  Test_Full_SilverB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SilverB : XCTestCase

@end

@implementation Test_Full_SilverB

- (void)testFull_SilverB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SilverB_EachQuad_4x4();

    const M aExpected = {
        { 19, 11,  8,  0, 23, 15, 12,  4 },
        {  3, 27, 26, 18,  7, 31, 30, 22 },
        { 17,  9, 10,  2, 21, 13, 14,  6 },
        {  1, 25, 24, 16,  5, 29, 28, 20 },
        { 51, 43, 40, 32, 55, 47, 44, 36 },
        { 35, 59, 58, 50, 39, 63, 62, 54 },
        { 49, 41, 42, 34, 53, 45, 46, 38 },
        { 33, 57, 56, 48, 37, 61, 60, 52 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SilverB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SilverB_8x8();

    const M aExpected = {
        { 47, 39, 31, 23, 24, 16,  8,  0 },
        { 15,  7, 63, 55, 62, 54, 46, 38 },
        { 45, 37, 29, 21, 30, 22, 14,  6 },
        { 13,  5, 61, 53, 60, 52, 44, 36 },
        { 43, 35, 27, 19, 28, 20, 12,  4 },
        { 11,  3, 59, 51, 58, 50, 42, 34 },
        { 41, 33, 25, 17, 26, 18, 10,  2 },
        {  9,  1, 57, 49, 56, 48, 40, 32 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
