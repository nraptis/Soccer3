//
//  Test_Full_JewelD.mm
//  CyberMatrixTests
//

#import <XCTest/XCTest.h>

#include "M88.hpp"
#include "VerifyFull.hpp"
#include "Tests.hpp"
#include "Logging.hpp"

@interface Test_Full_JewelD : XCTestCase

@end

@implementation Test_Full_JewelD

- (void)testFull_JewelD_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_JewelD_4x4();

    const M aExpected = {
        { 18, 19, 34, 35, 36, 37, 20, 21 },
        { 26, 27, 42, 43, 44, 45, 28, 29 },
        {  2,  3, 50, 51, 52, 53,  4,  5 },
        { 10, 11, 58, 59, 60, 61, 12, 13 },
        {  0,  1, 48, 49, 54, 55,  6,  7 },
        {  8,  9, 56, 57, 62, 63, 14, 15 },
        { 16, 17, 32, 33, 38, 39, 22, 23 },
        { 24, 25, 40, 41, 46, 47, 30, 31 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_JewelD_EachQuad_4x4 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_JewelD_EachQuad_4x4();

    const M aExpected = {
        {  9, 17, 18, 10, 13, 21, 22, 14 },
        {  1, 25, 26,  2,  5, 29, 30,  6 },
        {  0, 24, 27,  3,  4, 28, 31,  7 },
        {  8, 16, 19, 11, 12, 20, 23, 15 },
        { 41, 49, 50, 42, 45, 53, 54, 46 },
        { 33, 57, 58, 34, 37, 61, 62, 38 },
        { 32, 56, 59, 35, 36, 60, 63, 39 },
        { 40, 48, 51, 43, 44, 52, 55, 47 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

- (void)testFull_JewelD_8x8 {
    M88 aBefore = VerifyFull::SpawnTestMatrixFull();
    M88 aAfter = aBefore;

    aAfter.Full_JewelD_8x8();

    const M aExpected = {
        { 25, 33, 34, 26, 29, 37, 38, 30 },
        { 17, 41, 42, 18, 21, 45, 46, 22 },
        {  9, 49, 50, 10, 13, 53, 54, 14 },
        {  1, 57, 58,  2,  5, 61, 62,  6 },
        {  0, 56, 59,  3,  4, 60, 63,  7 },
        {  8, 48, 51, 11, 12, 52, 55, 15 },
        { 16, 40, 43, 19, 20, 44, 47, 23 },
        { 24, 32, 35, 27, 28, 36, 39, 31 }
    };

    if (!VerifyFull::CheckFull(aBefore, aAfter, aExpected)) {
        Logging::Log("Before", aBefore);
        Logging::Log("After", aAfter);
        XCTFail(@"%s failed", sel_getName(_cmd));
        return;
    }
}

@end
