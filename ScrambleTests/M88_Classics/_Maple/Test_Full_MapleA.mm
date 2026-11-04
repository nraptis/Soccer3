//
//  Test_Full_MapleA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_MapleA : XCTestCase

@end

@implementation Test_Full_MapleA

- (void)testFull_MapleA_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_MapleA_4x4();

    const M aExpected = {
        { 50, 51, 48, 49, 32, 33, 34, 35 },
        { 58, 59, 56, 57, 40, 41, 42, 43 },
        {  2,  3,  0,  1, 16, 17, 18, 19 },
        { 10, 11,  8,  9, 24, 25, 26, 27 },
        {  4,  5,  6,  7, 22, 23, 20, 21 },
        { 12, 13, 14, 15, 30, 31, 28, 29 },
        { 52, 53, 54, 55, 38, 39, 36, 37 },
        { 60, 61, 62, 63, 46, 47, 44, 45 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_MapleA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_MapleA_EachQuad_4x4();

    const M aExpected = {
        { 25, 24, 16, 17, 29, 28, 20, 21 },
        {  1,  0,  8,  9,  5,  4, 12, 13 },
        {  2,  3, 11, 10,  6,  7, 15, 14 },
        { 26, 27, 19, 18, 30, 31, 23, 22 },
        { 57, 56, 48, 49, 61, 60, 52, 53 },
        { 33, 32, 40, 41, 37, 36, 44, 45 },
        { 34, 35, 43, 42, 38, 39, 47, 46 },
        { 58, 59, 51, 50, 62, 63, 55, 54 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_MapleA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_MapleA_8x8();

    const M aExpected = {
        { 35, 43, 33, 41, 40, 32, 42, 34 },
        { 27, 19, 25, 17, 16, 24, 18, 26 },
        { 10,  2,  8,  0,  1,  9,  3, 11 },
        { 50, 58, 48, 56, 57, 49, 59, 51 },
        { 53, 61, 55, 63, 62, 54, 60, 52 },
        { 13,  5, 15,  7,  6, 14,  4, 12 },
        { 28, 20, 30, 22, 23, 31, 21, 29 },
        { 36, 44, 38, 46, 47, 39, 45, 37 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
