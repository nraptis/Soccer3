//
//  Test_Full_PalladiumB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_PalladiumB : XCTestCase

@end

@implementation Test_Full_PalladiumB

- (void)testFull_PalladiumB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PalladiumB_EachQuad_4x4();

    const M aExpected = {
        { 19, 24, 18, 27, 23, 28, 22, 31 },
        {  3,  8,  2, 11,  7, 12,  6, 15 },
        { 17, 26, 16, 25, 21, 30, 20, 29 },
        {  1, 10,  0,  9,  5, 14,  4, 13 },
        { 51, 56, 50, 59, 55, 60, 54, 63 },
        { 35, 40, 34, 43, 39, 44, 38, 47 },
        { 49, 58, 48, 57, 53, 62, 52, 61 },
        { 33, 42, 32, 41, 37, 46, 36, 45 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PalladiumB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PalladiumB_8x8();

    const M aExpected = {
        { 37, 47, 53, 63, 36, 46, 52, 62 },
        {  5, 15, 21, 31,  4, 14, 20, 30 },
        { 39, 41, 55, 57, 38, 40, 54, 56 },
        {  7,  9, 23, 25,  6,  8, 22, 24 },
        { 33, 43, 49, 59, 32, 42, 48, 58 },
        {  1, 11, 17, 27,  0, 10, 16, 26 },
        { 35, 45, 51, 61, 34, 44, 50, 60 },
        {  3, 13, 19, 29,  2, 12, 18, 28 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
