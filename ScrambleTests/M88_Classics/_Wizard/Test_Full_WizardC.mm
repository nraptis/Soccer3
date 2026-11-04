//
//  Test_Full_WizardC.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_WizardC : XCTestCase

@end

@implementation Test_Full_WizardC

- (void)testFull_WizardC_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WizardC_EachQuad_4x4();

    const M aExpected = {
        {  8,  1, 11,  9, 12,  5, 15, 13 },
        {  2,  0, 10,  3,  6,  4, 14,  7 },
        { 25, 27, 26, 19, 29, 31, 30, 23 },
        { 24, 17, 16, 18, 28, 21, 20, 22 },
        { 40, 33, 43, 41, 44, 37, 47, 45 },
        { 34, 32, 42, 35, 38, 36, 46, 39 },
        { 57, 59, 58, 51, 61, 63, 62, 55 },
        { 56, 49, 48, 50, 60, 53, 52, 54 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_WizardC_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WizardC_8x8();

    const M aExpected = {
        { 17, 25,  1,  9,  3, 11, 19, 27 },
        { 18, 26,  2, 10, 22, 30,  6, 14 },
        {  5, 13, 21, 29, 23, 31,  7, 15 },
        { 16, 24,  0,  8, 20, 28,  4, 12 },
        { 39, 47, 55, 63, 53, 61, 37, 45 },
        { 50, 58, 34, 42, 54, 62, 38, 46 },
        { 51, 59, 35, 43, 33, 41, 49, 57 },
        { 48, 56, 32, 40, 52, 60, 36, 44 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
