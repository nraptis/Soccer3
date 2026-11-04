//
//  Test_Full_JuniperB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_JuniperB : XCTestCase

@end

@implementation Test_Full_JuniperB

- (void)testFull_JuniperB_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_JuniperB_4x4();

    const M aExpected = {
        {  6,  7, 22, 23, 36, 37, 20, 21 },
        { 14, 15, 30, 31, 44, 45, 28, 29 },
        { 16, 17, 32, 33, 18, 19,  2,  3 },
        { 24, 25, 40, 41, 26, 27, 10, 11 },
        {  0,  1, 48, 49, 34, 35, 50, 51 },
        {  8,  9, 56, 57, 42, 43, 58, 59 },
        { 54, 55, 38, 39, 52, 53,  4,  5 },
        { 62, 63, 46, 47, 60, 61, 12, 13 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_JuniperB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_JuniperB_EachQuad_4x4();

    const M aExpected = {
        {  3, 11, 18, 10,  7, 15, 22, 14 },
        {  8, 16,  9,  1, 12, 20, 13,  5 },
        {  0, 24, 17, 25,  4, 28, 21, 29 },
        { 27, 19, 26,  2, 31, 23, 30,  6 },
        { 35, 43, 50, 42, 39, 47, 54, 46 },
        { 40, 48, 41, 33, 44, 52, 45, 37 },
        { 32, 56, 49, 57, 36, 60, 53, 61 },
        { 59, 51, 58, 34, 63, 55, 62, 38 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_JuniperB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_JuniperB_8x8();

    const M aExpected = {
        { 22,  7, 38, 23, 31, 46, 15, 30 },
        {  1, 16, 17, 32, 40, 25, 24,  9 },
        { 11, 26, 27, 42, 34, 19, 18,  3 },
        { 28, 13, 44, 29, 21, 36,  5, 20 },
        {  4, 53, 52, 37, 45, 60, 61, 12 },
        { 51,  2, 35, 50, 58, 43, 10, 59 },
        { 57,  8, 41, 56, 48, 33,  0, 49 },
        { 14, 63, 62, 47, 39, 54, 55,  6 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
