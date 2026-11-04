//
//  Test_Full_SilverD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SilverD : XCTestCase

@end

@implementation Test_Full_SilverD

- (void)testFull_SilverD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SilverD_EachQuad_4x4();

    const M aExpected = {
        { 16, 24, 25,  1, 20, 28, 29,  5 },
        {  2, 10,  9, 17,  6, 14, 13, 21 },
        { 18, 26, 27,  3, 22, 30, 31,  7 },
        {  0,  8, 11, 19,  4, 12, 15, 23 },
        { 48, 56, 57, 33, 52, 60, 61, 37 },
        { 34, 42, 41, 49, 38, 46, 45, 53 },
        { 50, 58, 59, 35, 54, 62, 63, 39 },
        { 32, 40, 43, 51, 36, 44, 47, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SilverD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SilverD_8x8();

    const M aExpected = {
        { 32, 40, 48, 56, 49, 57,  1,  9 },
        {  2, 10, 18, 26, 17, 25, 33, 41 },
        { 34, 42, 50, 58, 51, 59,  3, 11 },
        {  4, 12, 20, 28, 19, 27, 35, 43 },
        { 36, 44, 52, 60, 53, 61,  5, 13 },
        {  6, 14, 22, 30, 21, 29, 37, 45 },
        { 38, 46, 54, 62, 55, 63,  7, 15 },
        {  0,  8, 16, 24, 23, 31, 39, 47 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
