//
//  Test_Full_HickoryA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_HickoryA : XCTestCase

@end

@implementation Test_Full_HickoryA

- (void)testFull_HickoryA_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HickoryA_4x4();

    const M aExpected = {
        { 48, 49, 38, 39, 36, 37, 54, 55 },
        { 56, 57, 46, 47, 44, 45, 62, 63 },
        { 50, 51, 32, 33, 34, 35, 52, 53 },
        { 58, 59, 40, 41, 42, 43, 60, 61 },
        {  0,  1, 18, 19, 20, 21,  2,  3 },
        {  8,  9, 26, 27, 28, 29, 10, 11 },
        {  6,  7, 16, 17, 22, 23,  4,  5 },
        { 14, 15, 24, 25, 30, 31, 12, 13 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_HickoryA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HickoryA_EachQuad_4x4();

    const M aExpected = {
        { 24, 19, 18, 27, 28, 23, 22, 31 },
        { 25, 16, 17, 26, 29, 20, 21, 30 },
        {  0,  9, 10,  1,  4, 13, 14,  5 },
        {  3,  8, 11,  2,  7, 12, 15,  6 },
        { 56, 51, 50, 59, 60, 55, 54, 63 },
        { 57, 48, 49, 58, 61, 52, 53, 62 },
        { 32, 41, 42, 33, 36, 45, 46, 37 },
        { 35, 40, 43, 34, 39, 44, 47, 38 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_HickoryA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_HickoryA_8x8();

    const M aExpected = {
        { 63, 62, 47, 46, 36, 37, 52, 53 },
        { 60, 61, 44, 45, 35, 34, 51, 50 },
        { 48, 49, 32, 33, 43, 42, 59, 58 },
        { 55, 54, 39, 38, 40, 41, 56, 57 },
        {  9,  8, 25, 24, 22, 23,  6,  7 },
        { 10, 11, 26, 27, 17, 16,  1,  0 },
        {  2,  3, 18, 19, 29, 28, 13, 12 },
        {  5,  4, 21, 20, 30, 31, 14, 15 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
