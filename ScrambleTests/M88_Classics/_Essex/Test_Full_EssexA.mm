//
//  Test_Full_EssexA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_EssexA : XCTestCase

@end

@implementation Test_Full_EssexA

- (void)testFull_EssexA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_EssexA_EachQuad_4x4();

    const M aExpected = {
        { 11,  0, 18, 25, 15,  4, 22, 29 },
        {  3,  8, 26, 17,  7, 12, 30, 21 },
        { 10, 24, 19,  1, 14, 28, 23,  5 },
        {  2, 16, 27,  9,  6, 20, 31, 13 },
        { 43, 32, 50, 57, 47, 36, 54, 61 },
        { 35, 40, 58, 49, 39, 44, 62, 53 },
        { 42, 56, 51, 33, 46, 60, 55, 37 },
        { 34, 48, 59, 41, 38, 52, 63, 45 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_EssexA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_EssexA_8x8();

    const M aExpected = {
        { 20,  2, 22,  0, 38, 48, 36, 50 },
        { 21,  3, 23,  1, 39, 49, 37, 51 },
        {  4, 18,  6, 16, 54, 32, 52, 34 },
        {  5, 19,  7, 17, 55, 33, 53, 35 },
        { 28,  8, 30, 56, 46, 58, 44, 10 },
        { 29,  9, 31, 57, 47, 59, 45, 11 },
        { 12, 24, 14, 40, 62, 42, 60, 26 },
        { 13, 25, 15, 41, 63, 43, 61, 27 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
