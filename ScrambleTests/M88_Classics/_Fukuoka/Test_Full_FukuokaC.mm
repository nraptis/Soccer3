//
//  Test_Full_FukuokaC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_FukuokaC : XCTestCase

@end

@implementation Test_Full_FukuokaC

- (void)testFull_FukuokaC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_FukuokaC_EachQuad_4x4();

    const M aExpected = {
        { 24, 17, 19, 26, 28, 21, 23, 30 },
        { 16,  0, 27, 11, 20,  4, 31, 15 },
        {  1,  8, 10,  3,  5, 12, 14,  7 },
        {  9, 25,  2, 18, 13, 29,  6, 22 },
        { 56, 49, 51, 58, 60, 53, 55, 62 },
        { 48, 32, 59, 43, 52, 36, 63, 47 },
        { 33, 40, 42, 35, 37, 44, 46, 39 },
        { 41, 57, 34, 50, 45, 61, 38, 54 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_FukuokaC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_FukuokaC_8x8();

    const M aExpected = {
        { 48, 40, 50, 42, 38, 62, 36, 60 },
        { 49, 41, 51, 43, 39, 63, 37, 61 },
        { 32, 10, 34,  8, 54, 28, 52, 30 },
        { 33, 11, 35,  9, 55, 29, 53, 31 },
        {  2, 26,  0, 24, 20, 12, 22, 14 },
        {  3, 27,  1, 25, 21, 13, 23, 15 },
        { 18, 56, 16, 58,  4, 46,  6, 44 },
        { 19, 57, 17, 59,  5, 47,  7, 45 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
