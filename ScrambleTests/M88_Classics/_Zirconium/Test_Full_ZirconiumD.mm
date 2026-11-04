//
//  Test_Full_ZirconiumD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_ZirconiumD : XCTestCase

@end

@implementation Test_Full_ZirconiumD

- (void)testFull_ZirconiumD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ZirconiumD_EachQuad_4x4();

    const M aExpected = {
        {  2, 26, 27, 19,  6, 30, 31, 23 },
        { 18, 10, 11,  3, 22, 14, 15,  7 },
        {  0, 24, 25, 17,  4, 28, 29, 21 },
        { 16,  8,  9,  1, 20, 12, 13,  5 },
        { 34, 58, 59, 51, 38, 62, 63, 55 },
        { 50, 42, 43, 35, 54, 46, 47, 39 },
        { 32, 56, 57, 49, 36, 60, 61, 53 },
        { 48, 40, 41, 33, 52, 44, 45, 37 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_ZirconiumD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_ZirconiumD_8x8();

    const M aExpected = {
        { 14,  6, 62, 54, 63, 55, 47, 39 },
        { 46, 38, 30, 22, 31, 23, 15,  7 },
        { 12,  4, 60, 52, 61, 53, 45, 37 },
        { 44, 36, 28, 20, 29, 21, 13,  5 },
        { 10,  2, 58, 50, 59, 51, 43, 35 },
        { 42, 34, 26, 18, 27, 19, 11,  3 },
        {  8,  0, 56, 48, 57, 49, 41, 33 },
        { 40, 32, 24, 16, 25, 17,  9,  1 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
