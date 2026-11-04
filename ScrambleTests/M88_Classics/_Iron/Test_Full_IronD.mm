//
//  Test_Full_IronD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_IronD : XCTestCase

@end

@implementation Test_Full_IronD

- (void)testFull_IronD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_IronD_EachQuad_4x4();

    const M aExpected = {
        {  2, 11,  3,  8,  6, 15,  7, 12 },
        { 16, 25, 19, 24, 20, 29, 23, 28 },
        {  0,  9,  1, 10,  4, 13,  5, 14 },
        { 18, 27, 17, 26, 22, 31, 21, 30 },
        { 34, 43, 35, 40, 38, 47, 39, 44 },
        { 48, 57, 51, 56, 52, 61, 55, 60 },
        { 32, 41, 33, 42, 36, 45, 37, 46 },
        { 50, 59, 49, 58, 54, 63, 53, 62 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_IronD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_IronD_8x8();

    const M aExpected = {
        {  4, 14, 20, 30,  5, 15, 21, 31 },
        { 38, 40, 54, 56, 37, 47, 53, 63 },
        {  6,  8, 22, 24,  7,  9, 23, 25 },
        { 32, 42, 48, 58, 39, 41, 55, 57 },
        {  0, 10, 16, 26,  1, 11, 17, 27 },
        { 34, 44, 50, 60, 33, 43, 49, 59 },
        {  2, 12, 18, 28,  3, 13, 19, 29 },
        { 36, 46, 52, 62, 35, 45, 51, 61 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
