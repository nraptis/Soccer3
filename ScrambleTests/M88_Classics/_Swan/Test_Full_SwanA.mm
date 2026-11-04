//
//  Test_Full_SwanA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SwanA : XCTestCase

@end

@implementation Test_Full_SwanA

- (void)testFull_SwanA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SwanA_EachQuad_4x4();

    const M aExpected = {
        { 19, 16, 17, 18, 23, 20, 21, 22 },
        { 27, 24, 25, 26, 31, 28, 29, 30 },
        {  1,  0,  3,  2,  5,  4,  7,  6 },
        {  9,  8, 11, 10, 13, 12, 15, 14 },
        { 51, 48, 49, 50, 55, 52, 53, 54 },
        { 59, 56, 57, 58, 63, 60, 61, 62 },
        { 33, 32, 35, 34, 37, 36, 39, 38 },
        { 41, 40, 43, 42, 45, 44, 47, 46 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SwanA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SwanA_8x8();

    const M aExpected = {
        { 39, 32, 33, 34, 35, 36, 37, 38 },
        { 47, 40, 41, 42, 43, 44, 45, 46 },
        { 55, 48, 49, 50, 51, 52, 53, 54 },
        { 63, 56, 57, 58, 59, 60, 61, 62 },
        {  1,  0,  3,  2,  5,  4,  7,  6 },
        {  9,  8, 11, 10, 13, 12, 15, 14 },
        { 17, 16, 19, 18, 21, 20, 23, 22 },
        { 25, 24, 27, 26, 29, 28, 31, 30 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
