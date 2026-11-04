//
//  Test_Full_NickelA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_NickelA : XCTestCase

@end

@implementation Test_Full_NickelA

- (void)testFull_NickelA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NickelA_EachQuad_4x4();

    const M aExpected = {
        {  3, 17,  1, 19,  7, 21,  5, 23 },
        { 27,  9, 25, 11, 31, 13, 29, 15 },
        { 24,  8, 26, 10, 28, 12, 30, 14 },
        { 16,  0, 18,  2, 20,  4, 22,  6 },
        { 35, 49, 33, 51, 39, 53, 37, 55 },
        { 59, 41, 57, 43, 63, 45, 61, 47 },
        { 56, 40, 58, 42, 60, 44, 62, 46 },
        { 48, 32, 50, 34, 52, 36, 54, 38 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_NickelA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_NickelA_8x8();

    const M aExpected = {
        { 15, 41,  9, 43, 11, 45, 13, 47 },
        {  7, 33,  1, 35,  3, 37,  5, 39 },
        { 63, 25, 57, 27, 59, 29, 61, 31 },
        { 55, 17, 49, 19, 51, 21, 53, 23 },
        { 56, 24, 58, 26, 60, 28, 62, 30 },
        { 48, 16, 50, 18, 52, 20, 54, 22 },
        { 40,  8, 42, 10, 44, 12, 46, 14 },
        { 32,  0, 34,  2, 36,  4, 38,  6 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
