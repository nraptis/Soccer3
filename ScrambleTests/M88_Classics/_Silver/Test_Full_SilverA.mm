//
//  Test_Full_SilverA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SilverA : XCTestCase

@end

@implementation Test_Full_SilverA

- (void)testFull_SilverA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SilverA_EachQuad_4x4();

    const M aExpected = {
        {  0, 18,  2, 16,  4, 22,  6, 20 },
        {  8, 26, 10, 24, 12, 30, 14, 28 },
        { 11, 27,  9, 25, 15, 31, 13, 29 },
        { 19,  3, 17,  1, 23,  7, 21,  5 },
        { 32, 50, 34, 48, 36, 54, 38, 52 },
        { 40, 58, 42, 56, 44, 62, 46, 60 },
        { 43, 59, 41, 57, 47, 63, 45, 61 },
        { 51, 35, 49, 33, 55, 39, 53, 37 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SilverA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SilverA_8x8();

    const M aExpected = {
        {  0, 38,  6, 36,  4, 34,  2, 32 },
        {  8, 46, 14, 44, 12, 42, 10, 40 },
        { 16, 54, 22, 52, 20, 50, 18, 48 },
        { 24, 62, 30, 60, 28, 58, 26, 56 },
        { 23, 55, 21, 53, 19, 51, 17, 49 },
        { 31, 63, 29, 61, 27, 59, 25, 57 },
        { 39,  7, 37,  5, 35,  3, 33,  1 },
        { 47, 15, 45, 13, 43, 11, 41,  9 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
