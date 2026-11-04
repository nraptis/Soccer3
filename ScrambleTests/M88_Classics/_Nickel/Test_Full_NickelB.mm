//
//  Test_Full_NickelB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_NickelB : XCTestCase

@end

@implementation Test_Full_NickelB

- (void)testFull_NickelB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NickelB_EachQuad_4x4();

    const M aExpected = {
        { 16, 24, 27,  3, 20, 28, 31,  7 },
        {  0,  8,  9, 17,  4, 12, 13, 21 },
        { 18, 26, 25,  1, 22, 30, 29,  5 },
        {  2, 10, 11, 19,  6, 14, 15, 23 },
        { 48, 56, 59, 35, 52, 60, 63, 39 },
        { 32, 40, 41, 49, 36, 44, 45, 53 },
        { 50, 58, 57, 33, 54, 62, 61, 37 },
        { 34, 42, 43, 51, 38, 46, 47, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_NickelB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NickelB_8x8();

    const M aExpected = {
        { 32, 40, 48, 56, 55, 63,  7, 15 },
        {  0,  8, 16, 24, 17, 25, 33, 41 },
        { 34, 42, 50, 58, 49, 57,  1,  9 },
        {  2, 10, 18, 26, 19, 27, 35, 43 },
        { 36, 44, 52, 60, 51, 59,  3, 11 },
        {  4, 12, 20, 28, 21, 29, 37, 45 },
        { 38, 46, 54, 62, 53, 61,  5, 13 },
        {  6, 14, 22, 30, 23, 31, 39, 47 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
