//
//  Test_Full_WizardD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_WizardD : XCTestCase

@end

@implementation Test_Full_WizardD

- (void)testFull_WizardD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WizardD_EachQuad_4x4();

    const M aExpected = {
        {  9,  0,  1,  3, 13,  4,  5,  7 },
        {  8, 10, 11,  2, 12, 14, 15,  6 },
        { 19, 17, 27, 18, 23, 21, 31, 22 },
        { 25, 16, 26, 24, 29, 20, 30, 28 },
        { 41, 32, 33, 35, 45, 36, 37, 39 },
        { 40, 42, 43, 34, 44, 46, 47, 38 },
        { 51, 49, 59, 50, 55, 53, 63, 54 },
        { 57, 48, 58, 56, 61, 52, 62, 60 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_WizardD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WizardD_8x8();

    const M aExpected = {
        { 19, 27,  3, 11, 23, 31,  7, 15 },
        { 16, 24,  0,  8,  2, 10, 18, 26 },
        { 17, 25,  1,  9, 21, 29,  5, 13 },
        {  4, 12, 20, 28, 22, 30,  6, 14 },
        { 51, 59, 35, 43, 55, 63, 39, 47 },
        { 38, 46, 54, 62, 52, 60, 36, 44 },
        { 49, 57, 33, 41, 53, 61, 37, 45 },
        { 50, 58, 34, 42, 32, 40, 48, 56 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
