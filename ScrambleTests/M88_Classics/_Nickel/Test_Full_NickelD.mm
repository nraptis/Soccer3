//
//  Test_Full_NickelD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_NickelD : XCTestCase

@end

@implementation Test_Full_NickelD

- (void)testFull_NickelD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NickelD_EachQuad_4x4();

    const M aExpected = {
        { 19, 11, 10,  2, 23, 15, 14,  6 },
        {  1, 25, 26, 18,  5, 29, 30, 22 },
        { 17,  9,  8,  0, 21, 13, 12,  4 },
        {  3, 27, 24, 16,  7, 31, 28, 20 },
        { 51, 43, 42, 34, 55, 47, 46, 38 },
        { 33, 57, 58, 50, 37, 61, 62, 54 },
        { 49, 41, 40, 32, 53, 45, 44, 36 },
        { 35, 59, 56, 48, 39, 63, 60, 52 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_NickelD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NickelD_8x8();

    const M aExpected = {
        { 47, 39, 31, 23, 30, 22, 14,  6 },
        { 13,  5, 61, 53, 62, 54, 46, 38 },
        { 45, 37, 29, 21, 28, 20, 12,  4 },
        { 11,  3, 59, 51, 60, 52, 44, 36 },
        { 43, 35, 27, 19, 26, 18, 10,  2 },
        {  9,  1, 57, 49, 58, 50, 42, 34 },
        { 41, 33, 25, 17, 24, 16,  8,  0 },
        { 15,  7, 63, 55, 56, 48, 40, 32 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
