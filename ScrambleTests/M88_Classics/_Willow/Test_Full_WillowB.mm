//
//  Test_Full_WillowB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_WillowB : XCTestCase

@end

@implementation Test_Full_WillowB

- (void)testFull_WillowB_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WillowB_4x4();

    const M aExpected = {
        {  6,  7,  4,  5, 20, 21, 22, 23 },
        { 14, 15, 12, 13, 28, 29, 30, 31 },
        { 54, 55, 52, 53, 36, 37, 38, 39 },
        { 62, 63, 60, 61, 44, 45, 46, 47 },
        { 48, 49, 50, 51, 34, 35, 32, 33 },
        { 56, 57, 58, 59, 42, 43, 40, 41 },
        {  0,  1,  2,  3, 18, 19, 16, 17 },
        {  8,  9, 10, 11, 26, 27, 24, 25 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_WillowB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WillowB_EachQuad_4x4();

    const M aExpected = {
        {  3,  2, 10, 11,  7,  6, 14, 15 },
        { 27, 26, 18, 19, 31, 30, 22, 23 },
        { 24, 25, 17, 16, 28, 29, 21, 20 },
        {  0,  1,  9,  8,  4,  5, 13, 12 },
        { 35, 34, 42, 43, 39, 38, 46, 47 },
        { 59, 58, 50, 51, 63, 62, 54, 55 },
        { 56, 57, 49, 48, 60, 61, 53, 52 },
        { 32, 33, 41, 40, 36, 37, 45, 44 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_WillowB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WillowB_8x8();

    const M aExpected = {
        {  7, 15,  5, 13, 12,  4, 14,  6 },
        { 63, 55, 61, 53, 52, 60, 54, 62 },
        { 46, 38, 44, 36, 37, 45, 39, 47 },
        { 22, 30, 20, 28, 29, 21, 31, 23 },
        { 17, 25, 19, 27, 26, 18, 24, 16 },
        { 41, 33, 43, 35, 34, 42, 32, 40 },
        { 56, 48, 58, 50, 51, 59, 49, 57 },
        {  0,  8,  2, 10, 11,  3,  9,  1 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
