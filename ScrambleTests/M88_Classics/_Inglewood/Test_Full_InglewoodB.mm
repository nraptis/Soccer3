//
//  Test_Full_InglewoodB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_InglewoodB : XCTestCase

@end

@implementation Test_Full_InglewoodB

- (void)testFull_InglewoodB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_InglewoodB_EachQuad_4x4();

    const M aExpected = {
        {  9, 16, 17, 24, 13, 20, 21, 28 },
        {  1,  0, 25,  8,  5,  4, 29, 12 },
        {  3, 10, 27,  2,  7, 14, 31,  6 },
        { 11, 26, 19, 18, 15, 30, 23, 22 },
        { 41, 48, 49, 56, 45, 52, 53, 60 },
        { 33, 32, 57, 40, 37, 36, 61, 44 },
        { 35, 42, 59, 34, 39, 46, 63, 38 },
        { 43, 58, 51, 50, 47, 62, 55, 54 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_InglewoodB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_InglewoodB_8x8();

    const M aExpected = {
        { 26, 27, 10, 11, 40, 41, 56, 57 },
        { 32, 33, 34, 35, 50, 51, 48, 49 },
        { 24, 25,  8,  9, 42, 43, 58, 59 },
        {  2,  3,  0,  1, 16, 17, 18, 19 },
        { 12, 13, 28, 29, 62, 63, 46, 47 },
        { 22, 23, 20, 21,  4,  5,  6,  7 },
        { 14, 15, 30, 31, 60, 61, 44, 45 },
        { 52, 53, 54, 55, 38, 39, 36, 37 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
