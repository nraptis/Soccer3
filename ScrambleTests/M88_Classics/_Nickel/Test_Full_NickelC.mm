//
//  Test_Full_NickelC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_NickelC : XCTestCase

@end

@implementation Test_Full_NickelC

- (void)testFull_NickelC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NickelC_EachQuad_4x4();

    const M aExpected = {
        {  2, 18,  0, 16,  6, 22,  4, 20 },
        { 10, 26,  8, 24, 14, 30, 12, 28 },
        { 11, 25,  9, 27, 15, 29, 13, 31 },
        { 19,  1, 17,  3, 23,  5, 21,  7 },
        { 34, 50, 32, 48, 38, 54, 36, 52 },
        { 42, 58, 40, 56, 46, 62, 44, 60 },
        { 43, 57, 41, 59, 47, 61, 45, 63 },
        { 51, 33, 49, 35, 55, 37, 53, 39 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_NickelC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NickelC_8x8();

    const M aExpected = {
        {  6, 38,  4, 36,  2, 34,  0, 32 },
        { 14, 46, 12, 44, 10, 42,  8, 40 },
        { 22, 54, 20, 52, 18, 50, 16, 48 },
        { 30, 62, 28, 60, 26, 58, 24, 56 },
        { 23, 53, 21, 51, 19, 49, 17, 55 },
        { 31, 61, 29, 59, 27, 57, 25, 63 },
        { 39,  5, 37,  3, 35,  1, 33,  7 },
        { 47, 13, 45, 11, 43,  9, 41, 15 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
