//
//  Test_Full_KobeB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_KobeB : XCTestCase

@end

@implementation Test_Full_KobeB

- (void)testFull_KobeB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_KobeB_EachQuad_4x4();

    const M aExpected = {
        {  0, 16, 11, 27,  4, 20, 15, 31 },
        { 17, 24, 26, 19, 21, 28, 30, 23 },
        { 25,  9, 18,  2, 29, 13, 22,  6 },
        {  8,  1,  3, 10, 12,  5,  7, 14 },
        { 32, 48, 43, 59, 36, 52, 47, 63 },
        { 49, 56, 58, 51, 53, 60, 62, 55 },
        { 57, 41, 50, 34, 61, 45, 54, 38 },
        { 40, 33, 35, 42, 44, 37, 39, 46 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_KobeB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_KobeB_8x8();

    const M aExpected = {
        {  1, 43,  3, 41, 23, 61, 21, 63 },
        {  0, 42,  2, 40, 22, 60, 20, 62 },
        { 35, 59, 33, 57, 53, 45, 55, 47 },
        { 34, 58, 32, 56, 52, 44, 54, 46 },
        { 51, 25, 49, 27, 37, 15, 39, 13 },
        { 50, 24, 48, 26, 36, 14, 38, 12 },
        { 17,  9, 19, 11,  7, 31,  5, 29 },
        { 16,  8, 18, 10,  6, 30,  4, 28 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
