//
//  Test_Full_InglewoodA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_InglewoodA : XCTestCase

@end

@implementation Test_Full_InglewoodA

- (void)testFull_InglewoodA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_InglewoodA_EachQuad_4x4();

    const M aExpected = {
        { 16, 17, 24,  9, 20, 21, 28, 13 },
        {  8,  1,  0, 25, 12,  5,  4, 29 },
        { 10, 27,  2,  3, 14, 31,  6,  7 },
        { 18, 11, 26, 19, 22, 15, 30, 23 },
        { 48, 49, 56, 41, 52, 53, 60, 45 },
        { 40, 33, 32, 57, 44, 37, 36, 61 },
        { 42, 59, 34, 35, 46, 63, 38, 39 },
        { 50, 43, 58, 51, 54, 47, 62, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_InglewoodA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_InglewoodA_8x8();

    const M aExpected = {
        { 10, 11, 40, 41, 56, 57, 26, 27 },
        { 48, 49, 32, 33, 34, 35, 50, 51 },
        {  8,  9, 42, 43, 58, 59, 24, 25 },
        { 18, 19,  2,  3,  0,  1, 16, 17 },
        { 28, 29, 62, 63, 46, 47, 12, 13 },
        {  6,  7, 22, 23, 20, 21,  4,  5 },
        { 30, 31, 60, 61, 44, 45, 14, 15 },
        { 36, 37, 52, 53, 54, 55, 38, 39 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
