//
//  Test_Full_HickoryB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_HickoryB : XCTestCase

@end

@implementation Test_Full_HickoryB

- (void)testFull_HickoryB_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HickoryB_4x4();

    const M aExpected = {
        { 52, 53, 34, 35, 32, 33, 50, 51 },
        { 60, 61, 42, 43, 40, 41, 58, 59 },
        { 54, 55, 36, 37, 38, 39, 48, 49 },
        { 62, 63, 44, 45, 46, 47, 56, 57 },
        {  4,  5, 22, 23, 16, 17,  6,  7 },
        { 12, 13, 30, 31, 24, 25, 14, 15 },
        {  2,  3, 20, 21, 18, 19,  0,  1 },
        { 10, 11, 28, 29, 26, 27,  8,  9 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_HickoryB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HickoryB_EachQuad_4x4();

    const M aExpected = {
        { 26, 17, 16, 25, 30, 21, 20, 29 },
        { 27, 18, 19, 24, 31, 22, 23, 28 },
        {  2, 11,  8,  3,  6, 15, 12,  7 },
        {  1, 10,  9,  0,  5, 14, 13,  4 },
        { 58, 49, 48, 57, 62, 53, 52, 61 },
        { 59, 50, 51, 56, 63, 54, 55, 60 },
        { 34, 43, 40, 35, 38, 47, 44, 39 },
        { 33, 42, 41, 32, 37, 46, 45, 36 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_HickoryB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HickoryB_8x8();

    const M aExpected = {
        { 50, 51, 34, 35, 45, 44, 61, 60 },
        { 53, 52, 37, 36, 46, 47, 62, 63 },
        { 57, 56, 41, 40, 38, 39, 54, 55 },
        { 58, 59, 42, 43, 33, 32, 49, 48 },
        {  0,  1, 16, 17, 27, 26, 11, 10 },
        {  7,  6, 23, 22, 24, 25,  8,  9 },
        { 15, 14, 31, 30, 20, 21,  4,  5 },
        { 12, 13, 28, 29, 19, 18,  3,  2 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
