//
//  Test_Full_WizardA.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_WizardA : XCTestCase

@end

@implementation Test_Full_WizardA

- (void)testFull_WizardA_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WizardA_EachQuad_4x4();

    const M aExpected = {
        {  8, 25,  2, 10, 12, 29,  6, 14 },
        {  1,  9, 18,  3,  5, 13, 22,  7 },
        { 16, 24, 26, 11, 20, 28, 30, 15 },
        {  0, 17, 19, 27,  4, 21, 23, 31 },
        { 40, 57, 34, 42, 44, 61, 38, 46 },
        { 33, 41, 50, 35, 37, 45, 54, 39 },
        { 48, 56, 58, 43, 52, 60, 62, 47 },
        { 32, 49, 51, 59, 36, 53, 55, 63 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_WizardA_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_WizardA_8x8();

    const M aExpected = {
        { 24,  0, 58, 16, 46,  4, 12, 20 },
        { 25,  1, 59, 17, 47,  5, 13, 21 },
        { 26,  2, 56, 18, 44,  6, 14, 22 },
        { 27,  3, 57, 19, 45,  7, 15, 23 },
        { 10, 32, 40, 48, 60, 36, 30, 52 },
        { 11, 33, 41, 49, 61, 37, 31, 53 },
        {  8, 34, 42, 50, 62, 38, 28, 54 },
        {  9, 35, 43, 51, 63, 39, 29, 55 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
