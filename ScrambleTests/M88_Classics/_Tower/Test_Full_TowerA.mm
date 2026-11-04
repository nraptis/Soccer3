//
//  TestFullKIND.m
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_TowerA : XCTestCase

@end

@implementation Test_Full_TowerA

- (void)testFull_TowerA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_TowerA_EachQuad_4x4();

    const M aExpected = {
        { 19, 10, 24, 25, 23, 14, 28, 29 },
        { 27, 16,  1, 18, 31, 20,  5, 22 },
        {  9, 26, 11,  0, 13, 30, 15,  4 },
        {  2,  3, 17,  8,  6,  7, 21, 12 },
        { 51, 42, 56, 57, 55, 46, 60, 61 },
        { 59, 48, 33, 50, 63, 52, 37, 54 },
        { 41, 58, 43, 32, 45, 62, 47, 36 },
        { 34, 35, 49, 40, 38, 39, 53, 44 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}



@end
