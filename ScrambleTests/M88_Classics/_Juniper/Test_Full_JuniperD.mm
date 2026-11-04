//
//  Test_Full_JuniperD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_JuniperD : XCTestCase

@end

@implementation Test_Full_JuniperD

- (void)testFull_JuniperD_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_JuniperD_4x4();

    const M aExpected = {
        {  2,  3, 50, 51,  4,  5, 20, 21 },
        { 10, 11, 58, 59, 12, 13, 28, 29 },
        { 16, 17,  0,  1, 54, 55,  6,  7 },
        { 24, 25,  8,  9, 62, 63, 14, 15 },
        { 32, 33, 48, 49, 38, 39, 22, 23 },
        { 40, 41, 56, 57, 46, 47, 30, 31 },
        { 18, 19, 34, 35, 52, 53, 36, 37 },
        { 26, 27, 42, 43, 60, 61, 44, 45 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_JuniperD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_JuniperD_EachQuad_4x4();

    const M aExpected = {
        {  1, 25,  2, 10,  5, 29,  6, 14 },
        {  8,  0, 27,  3, 12,  4, 31,  7 },
        { 16, 24, 19, 11, 20, 28, 23, 15 },
        {  9, 17, 26, 18, 13, 21, 30, 22 },
        { 33, 57, 34, 42, 37, 61, 38, 46 },
        { 40, 32, 59, 35, 44, 36, 63, 39 },
        { 48, 56, 51, 43, 52, 60, 55, 47 },
        { 41, 49, 58, 50, 45, 53, 62, 54 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_JuniperD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_JuniperD_8x8();

    const M aExpected = {
        { 27, 35,  2, 26, 13, 53, 52, 44 },
        { 19, 43, 10, 18,  5, 61, 60, 36 },
        { 25, 33,  0, 24, 15, 55, 54, 46 },
        { 17, 41,  8, 16,  7, 63, 62, 38 },
        { 32, 56, 57,  1, 22, 14, 47, 23 },
        { 40, 48, 49,  9, 30,  6, 39, 31 },
        { 34, 58, 59,  3, 20, 12, 45, 21 },
        { 42, 50, 51, 11, 28,  4, 37, 29 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
