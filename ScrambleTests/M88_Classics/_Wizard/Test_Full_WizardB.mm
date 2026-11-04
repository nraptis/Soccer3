//
//  Test_Full_WizardB.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_WizardB : XCTestCase

@end

@implementation Test_Full_WizardB

- (void)testFull_WizardB_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WizardB_EachQuad_4x4();

    const M aExpected = {
        {  0,  8, 19,  2,  4, 12, 23,  6 },
        {  9, 24,  3, 11, 13, 28,  7, 15 },
        {  1, 16, 18, 26,  5, 20, 22, 30 },
        { 17, 25, 27, 10, 21, 29, 31, 14 },
        { 32, 40, 51, 34, 36, 44, 55, 38 },
        { 41, 56, 35, 43, 45, 60, 39, 47 },
        { 33, 48, 50, 58, 37, 52, 54, 62 },
        { 49, 57, 59, 42, 53, 61, 63, 46 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_WizardB_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WizardB_8x8();

    const M aExpected = {
        {  8, 16, 24, 50, 12, 38, 28,  4 },
        {  9, 17, 25, 51, 13, 39, 29,  5 },
        { 10, 18, 26, 48, 14, 36, 30,  6 },
        { 11, 19, 27, 49, 15, 37, 31,  7 },
        { 40,  2, 56, 32, 44, 52, 60, 22 },
        { 41,  3, 57, 33, 45, 53, 61, 23 },
        { 42,  0, 58, 34, 46, 54, 62, 20 },
        { 43,  1, 59, 35, 47, 55, 63, 21 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
