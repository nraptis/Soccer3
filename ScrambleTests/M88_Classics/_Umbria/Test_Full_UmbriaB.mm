//
//  Test_Full_UmbriaB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_UmbriaB : XCTestCase

@end

@implementation Test_Full_UmbriaB

- (void)testFull_UmbriaB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_UmbriaB_EachQuad_4x4();

    const M aExpected = {
        { 27, 24, 10,  9, 31, 28, 14, 13 },
        {  3, 16,  2, 17,  7, 20,  6, 21 },
        { 19,  1, 18,  0, 23,  5, 22,  4 },
        { 11, 25, 26,  8, 15, 29, 30, 12 },
        { 59, 56, 42, 41, 63, 60, 46, 45 },
        { 35, 48, 34, 49, 39, 52, 38, 53 },
        { 51, 33, 50, 32, 55, 37, 54, 36 },
        { 43, 57, 58, 40, 47, 61, 62, 44 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_UmbriaB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_UmbriaB_8x8();

    const M aExpected = {
        { 63,  9, 61, 11, 45, 27, 47, 25 },
        { 46, 56, 44, 58, 28, 10, 30,  8 },
        { 15, 57, 13, 59, 29, 43, 31, 41 },
        { 62, 40, 60, 42, 12, 26, 14, 24 },
        { 39,  1, 55,  3, 53, 19, 37, 17 },
        { 22, 48, 38, 50, 36,  2, 20,  0 },
        { 23, 49,  7, 51,  5, 35, 21, 33 },
        {  6, 32, 54, 34, 52, 18,  4, 16 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
