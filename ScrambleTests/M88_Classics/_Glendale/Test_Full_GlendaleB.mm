//
//  Test_Full_GlendaleB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_GlendaleB : XCTestCase

@end

@implementation Test_Full_GlendaleB

- (void)testFull_GlendaleB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GlendaleB_EachQuad_4x4();

    const M aExpected = {
        {  2, 11,  9,  0,  6, 15, 13,  4 },
        { 19,  3, 24,  8, 23,  7, 28, 12 },
        { 27, 18, 16, 25, 31, 22, 20, 29 },
        { 10, 26,  1, 17, 14, 30,  5, 21 },
        { 34, 43, 41, 32, 38, 47, 45, 36 },
        { 51, 35, 56, 40, 55, 39, 60, 44 },
        { 59, 50, 48, 57, 63, 54, 52, 61 },
        { 42, 58, 33, 49, 46, 62, 37, 53 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_GlendaleB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_GlendaleB_8x8();

    const M aExpected = {
        {  4, 28,  6, 30, 18, 10, 16,  8 },
        {  5, 29,  7, 31, 19, 11, 17,  9 },
        { 38, 12, 36, 14, 48, 26, 50, 24 },
        { 39, 13, 37, 15, 49, 27, 51, 25 },
        { 54, 46, 52, 44, 32, 56, 34, 58 },
        { 55, 47, 53, 45, 33, 57, 35, 59 },
        { 20, 62, 22, 60,  2, 40,  0, 42 },
        { 21, 63, 23, 61,  3, 41,  1, 43 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
