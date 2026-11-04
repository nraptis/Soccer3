//
//  Test_Full_PlatinumD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_PlatinumD : XCTestCase

@end

@implementation Test_Full_PlatinumD

- (void)testFull_PlatinumD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PlatinumD_EachQuad_4x4();

    const M aExpected = {
        { 16, 27, 19, 26, 20, 31, 23, 30 },
        {  0, 11,  3, 10,  4, 15,  7, 14 },
        { 18, 25, 17, 24, 22, 29, 21, 28 },
        {  2,  9,  1,  8,  6, 13,  5, 12 },
        { 48, 59, 51, 58, 52, 63, 55, 62 },
        { 32, 43, 35, 42, 36, 47, 39, 46 },
        { 50, 57, 49, 56, 54, 61, 53, 60 },
        { 34, 41, 33, 40, 38, 45, 37, 44 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PlatinumD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PlatinumD_8x8();

    const M aExpected = {
        { 39, 45, 55, 61, 38, 44, 54, 60 },
        {  7, 13, 23, 29,  6, 12, 22, 28 },
        { 33, 47, 49, 63, 32, 46, 48, 62 },
        {  1, 15, 17, 31,  0, 14, 16, 30 },
        { 35, 41, 51, 57, 34, 40, 50, 56 },
        {  3,  9, 19, 25,  2,  8, 18, 24 },
        { 37, 43, 53, 59, 36, 42, 52, 58 },
        {  5, 11, 21, 27,  4, 10, 20, 26 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
