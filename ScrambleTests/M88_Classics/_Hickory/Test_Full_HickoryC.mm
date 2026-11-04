//
//  Test_Full_HickoryC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_HickoryC : XCTestCase

@end

@implementation Test_Full_HickoryC

- (void)testFull_HickoryC_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HickoryC_4x4();

    const M aExpected = {
        { 16, 17, 38, 39, 32, 33, 18, 19 },
        { 24, 25, 46, 47, 40, 41, 26, 27 },
        { 22, 23, 36, 37, 34, 35, 20, 21 },
        { 30, 31, 44, 45, 42, 43, 28, 29 },
        {  4,  5, 54, 55, 52, 53,  2,  3 },
        { 12, 13, 62, 63, 60, 61, 10, 11 },
        {  6,  7, 48, 49, 50, 51,  0,  1 },
        { 14, 15, 56, 57, 58, 59,  8,  9 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_HickoryC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HickoryC_EachQuad_4x4();

    const M aExpected = {
        {  8, 19, 16,  9, 12, 23, 20, 13 },
        { 11, 18, 17, 10, 15, 22, 21, 14 },
        {  2, 27, 26,  1,  6, 31, 30,  5 },
        {  3, 24, 25,  0,  7, 28, 29,  4 },
        { 40, 51, 48, 41, 44, 55, 52, 45 },
        { 43, 50, 49, 42, 47, 54, 53, 46 },
        { 34, 59, 58, 33, 38, 63, 62, 37 },
        { 35, 56, 57, 32, 39, 60, 61, 36 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_HickoryC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HickoryC_8x8();

    const M aExpected = {
        { 22, 40, 57,  7,  0, 58, 43, 17 },
        { 24, 38, 55,  9, 10, 48, 33, 27 },
        { 20, 46, 63,  5,  2, 60, 45, 19 },
        { 30, 36, 53, 15, 12, 50, 35, 29 },
        { 31, 37, 52, 14, 13, 51, 34, 28 },
        { 21, 47, 62,  4,  3, 61, 44, 18 },
        { 25, 39, 54,  8, 11, 49, 32, 26 },
        { 23, 41, 56,  6,  1, 59, 42, 16 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
