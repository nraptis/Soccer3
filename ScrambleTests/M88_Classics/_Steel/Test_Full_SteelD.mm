//
//  Test_Full_SteelD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_SteelD : XCTestCase

@end

@implementation Test_Full_SteelD

- (void)testFull_SteelD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SteelD_EachQuad_4x4();

    const M aExpected = {
        {  3, 10,  0, 11,  7, 14,  4, 15 },
        { 17, 24, 16, 27, 21, 28, 20, 31 },
        {  1,  8,  2,  9,  5, 12,  6, 13 },
        { 19, 26, 18, 25, 23, 30, 22, 29 },
        { 35, 42, 32, 43, 39, 46, 36, 47 },
        { 49, 56, 48, 59, 53, 60, 52, 63 },
        { 33, 40, 34, 41, 37, 44, 38, 45 },
        { 51, 58, 50, 57, 55, 62, 54, 61 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_SteelD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_SteelD_8x8();

    const M aExpected = {
        {  6, 12, 22, 28,  7, 13, 23, 29 },
        { 32, 46, 48, 62, 39, 45, 55, 61 },
        {  0, 14, 16, 30,  1, 15, 17, 31 },
        { 34, 40, 50, 56, 33, 47, 49, 63 },
        {  2,  8, 18, 24,  3,  9, 19, 25 },
        { 36, 42, 52, 58, 35, 41, 51, 57 },
        {  4, 10, 20, 26,  5, 11, 21, 27 },
        { 38, 44, 54, 60, 37, 43, 53, 59 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
