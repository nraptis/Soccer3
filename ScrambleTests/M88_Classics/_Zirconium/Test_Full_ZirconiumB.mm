//
//  Test_Full_ZirconiumB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_ZirconiumB : XCTestCase

@end

@implementation Test_Full_ZirconiumB

- (void)testFull_ZirconiumB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ZirconiumB_EachQuad_4x4();

    const M aExpected = {
        {  1,  9,  8, 16,  5, 13, 12, 20 },
        { 17, 25, 24,  0, 21, 29, 28,  4 },
        {  3, 11, 10, 18,  7, 15, 14, 22 },
        { 19, 27, 26,  2, 23, 31, 30,  6 },
        { 33, 41, 40, 48, 37, 45, 44, 52 },
        { 49, 57, 56, 32, 53, 61, 60, 36 },
        { 35, 43, 42, 50, 39, 47, 46, 54 },
        { 51, 59, 58, 34, 55, 63, 62, 38 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_ZirconiumB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ZirconiumB_8x8();

    const M aExpected = {
        {  1,  9, 17, 25, 16, 24, 32, 40 },
        { 33, 41, 49, 57, 48, 56,  0,  8 },
        {  3, 11, 19, 27, 18, 26, 34, 42 },
        { 35, 43, 51, 59, 50, 58,  2, 10 },
        {  5, 13, 21, 29, 20, 28, 36, 44 },
        { 37, 45, 53, 61, 52, 60,  4, 12 },
        {  7, 15, 23, 31, 22, 30, 38, 46 },
        { 39, 47, 55, 63, 54, 62,  6, 14 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
