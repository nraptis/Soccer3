//
//  Test_Full_ZirconiumC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_ZirconiumC : XCTestCase

@end

@implementation Test_Full_ZirconiumC

- (void)testFull_ZirconiumC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ZirconiumC_EachQuad_4x4();

    const M aExpected = {
        { 19,  3, 17,  1, 23,  7, 21,  5 },
        { 27, 11, 25,  9, 31, 15, 29, 13 },
        { 26, 10, 24,  8, 30, 14, 28, 12 },
        {  2, 18,  0, 16,  6, 22,  4, 20 },
        { 51, 35, 49, 33, 55, 39, 53, 37 },
        { 59, 43, 57, 41, 63, 47, 61, 45 },
        { 58, 42, 56, 40, 62, 46, 60, 44 },
        { 34, 50, 32, 48, 38, 54, 36, 52 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_ZirconiumC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ZirconiumC_8x8();

    const M aExpected = {
        { 39,  7, 37,  5, 35,  3, 33,  1 },
        { 47, 15, 45, 13, 43, 11, 41,  9 },
        { 55, 23, 53, 21, 51, 19, 49, 17 },
        { 63, 31, 61, 29, 59, 27, 57, 25 },
        { 54, 22, 52, 20, 50, 18, 48, 16 },
        { 62, 30, 60, 28, 58, 26, 56, 24 },
        {  6, 38,  4, 36,  2, 34,  0, 32 },
        { 14, 46, 12, 44, 10, 42,  8, 40 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
