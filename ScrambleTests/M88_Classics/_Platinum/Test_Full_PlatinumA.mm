//
//  Test_Full_PlatinumA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_PlatinumA : XCTestCase

@end

@implementation Test_Full_PlatinumA

- (void)testFull_PlatinumA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PlatinumA_EachQuad_4x4();

    const M aExpected = {
        {  2, 18,  0, 16,  6, 22,  4, 20 },
        {  9, 25, 11, 27, 13, 29, 15, 31 },
        {  1, 17,  3, 19,  5, 21,  7, 23 },
        {  8, 24, 10, 26, 12, 28, 14, 30 },
        { 34, 50, 32, 48, 38, 54, 36, 52 },
        { 41, 57, 43, 59, 45, 61, 47, 63 },
        { 33, 49, 35, 51, 37, 53, 39, 55 },
        { 40, 56, 42, 58, 44, 60, 46, 62 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_PlatinumA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_PlatinumA_8x8();

    const M aExpected = {
        {  5, 37,  3, 35,  1, 33,  7, 39 },
        { 11, 43,  9, 41, 15, 47, 13, 45 },
        { 21, 53, 19, 51, 17, 49, 23, 55 },
        { 27, 59, 25, 57, 31, 63, 29, 61 },
        {  4, 36,  2, 34,  0, 32,  6, 38 },
        { 10, 42,  8, 40, 14, 46, 12, 44 },
        { 20, 52, 18, 50, 16, 48, 22, 54 },
        { 26, 58, 24, 56, 30, 62, 28, 60 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
