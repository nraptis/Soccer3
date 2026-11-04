//
//  Test_Full_JuniperA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_JuniperA : XCTestCase

@end

@implementation Test_Full_JuniperA

- (void)testFull_JuniperA_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_JuniperA_4x4();

    const M aExpected = {
        {  2,  3, 18, 19, 32, 33, 16, 17 },
        { 10, 11, 26, 27, 40, 41, 24, 25 },
        { 20, 21, 36, 37, 22, 23,  6,  7 },
        { 28, 29, 44, 45, 30, 31, 14, 15 },
        {  4,  5, 52, 53, 38, 39, 54, 55 },
        { 12, 13, 60, 61, 46, 47, 62, 63 },
        { 50, 51, 34, 35, 48, 49,  0,  1 },
        { 58, 59, 42, 43, 56, 57,  8,  9 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_JuniperA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_JuniperA_EachQuad_4x4();

    const M aExpected = {
        {  1,  9, 16,  8,  5, 13, 20, 12 },
        { 10, 18, 11,  3, 14, 22, 15,  7 },
        {  2, 26, 19, 27,  6, 30, 23, 31 },
        { 25, 17, 24,  0, 29, 21, 28,  4 },
        { 33, 41, 48, 40, 37, 45, 52, 44 },
        { 42, 50, 43, 35, 46, 54, 47, 39 },
        { 34, 58, 51, 59, 38, 62, 55, 63 },
        { 57, 49, 56, 32, 61, 53, 60, 36 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_JuniperA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_JuniperA_8x8();

    const M aExpected = {
        {  9, 24, 25, 40, 32, 17, 16,  1 },
        { 30, 15, 46, 31, 23, 38,  7, 22 },
        { 20,  5, 36, 21, 29, 44, 13, 28 },
        {  3, 18, 19, 34, 42, 27, 26, 11 },
        { 59, 10, 43, 58, 50, 35,  2, 51 },
        { 12, 61, 60, 45, 37, 52, 53,  4 },
        {  6, 55, 54, 39, 47, 62, 63, 14 },
        { 49,  0, 33, 48, 56, 41,  8, 57 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
