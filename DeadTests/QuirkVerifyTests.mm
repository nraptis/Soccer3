//
//  QuirkVerifyTests.m
//  ScrambleTests
//
//  Created by Icarus Black on 11/23/26.
//

#import <XCTest/XCTest.h>
#include <atomic>
#include "Soccer3.hpp"
#include "WorkSpaceTools.hpp"
#include "LaneTool.hpp"
#include "Random.hpp"
#include <cstdint>
#include <cstring>
#include <memory>
#include <string>
#include <unordered_set>
#include <vector>

#include "QuirkHigh.hpp"
#include "QuirkLow.hpp"
#include "TESTQuirkHigh.hpp"
#include "TESTQuirkLow.hpp"
#include "WorkSpaceTools.hpp"
#include "CipherGauntlet.hpp"

@interface QuirkVerifyTests : XCTestCase

@end

@implementation QuirkVerifyTests

- (void)test_QuirkHello {
    
    std::uint8_t aOriginal[SOCCER_BLOCK_SIZE];
    std::uint8_t aWorkerA[SOCCER_BLOCK_SIZE];
    std::uint8_t aWorkerB[SOCCER_BLOCK_SIZE];
    
    std::uint8_t aEncryptedA[SOCCER_BLOCK_SIZE];
    std::uint8_t aEncryptedB[SOCCER_BLOCK_SIZE];
    
    std::uint8_t aDestA[SOCCER_BLOCK_SIZE];
    std::uint8_t aDestB[SOCCER_BLOCK_SIZE];
    
    for (std::size_t aTrial=0; aTrial<10; aTrial++) {
        
        WorkSpaceTools::FillBytes(aOriginal, SOCCER_BLOCK_SIZE);
        
        std::size_t aWindowA = (std::size_t)Random::Get32();
        std::size_t aWindowB = (std::size_t)Random::Get32();
        std::size_t aWindowC = (std::size_t)Random::Get32();
        
        TestQuirkHighA aTQHA(aWindowA, aWindowB, aWindowC);
        QuirkHighA aRQHA(aWindowA, aWindowB, aWindowC);
        
        aTQHA.SealData(aOriginal, aWorkerA, aEncryptedA, SOCCER_BLOCK_SIZE);
        aRQHA.SealData(aOriginal, aWorkerB, aEncryptedB, SOCCER_BLOCK_SIZE, nullptr);
        
        if (!CipherGauntlet::Matches(aEncryptedA, aEncryptedB, SOCCER_BLOCK_SIZE)) {
            XCTFail("test_QuirkHello: TestQuirkHighA and QuirkHighA did not match.");
            return;
        }
        
        aTQHA.UnsealData(aEncryptedA, aWorkerA, aDestA, SOCCER_BLOCK_SIZE);
        aRQHA.UnsealData(aEncryptedB, aWorkerB, aDestB, SOCCER_BLOCK_SIZE, nullptr);
        
        if (!CipherGauntlet::Matches(aOriginal, aDestA, SOCCER_BLOCK_SIZE)) {
            XCTFail("test_QuirkHello: TestQuirkHighA unseal did not work.");
            return;
        }
        
        if (!CipherGauntlet::Matches(aOriginal, aDestB, SOCCER_BLOCK_SIZE)) {
            XCTFail("test_QuirkHello: QuirkHighA unseal did not work.");
            return;
        }
        
        
        
    }
    
}



- (void)test_QuirkAll {
    std::vector<std::uint8_t> aOriginal(SOCCER_BLOCK_SIZE);
    std::vector<std::uint8_t> aWorkerA(SOCCER_BLOCK_SIZE);
    std::vector<std::uint8_t> aWorkerB(SOCCER_BLOCK_SIZE);
    std::vector<std::uint8_t> aEncryptedA(SOCCER_BLOCK_SIZE);
    std::vector<std::uint8_t> aEncryptedB(SOCCER_BLOCK_SIZE);
    std::vector<std::uint8_t> aDestA(SOCCER_BLOCK_SIZE);
    std::vector<std::uint8_t> aDestB(SOCCER_BLOCK_SIZE);

    const std::vector<const char *> aHighNames = {
        "QuirkHighA", "QuirkHighB", "QuirkHighC", "QuirkHighD",
        "QuirkHighE", "QuirkHighF", "QuirkHighG", "QuirkHighH"};
    const std::vector<const char *> aLowNames = {
        "QuirkLowA", "QuirkLowB", "QuirkLowC", "QuirkLowD",
        "QuirkLowE", "QuirkLowF", "QuirkLowG", "QuirkLowH"};

    for (std::size_t aTrial=0; aTrial<10; aTrial++) {
        WorkSpaceTools::FillBytes(aOriginal.data(), SOCCER_BLOCK_SIZE);

        std::size_t aWindowA = (std::size_t)Random::Get32();
        std::size_t aWindowB = (std::size_t)Random::Get32();
        std::size_t aWindowC = (std::size_t)Random::Get32();

        const std::vector<TESTQuirkHigh> aTestHigh = {
            TestQuirkHighA(aWindowA, aWindowB, aWindowC),
            TestQuirkHighB(aWindowA, aWindowB, aWindowC),
            TestQuirkHighC(aWindowA, aWindowB, aWindowC),
            TestQuirkHighD(aWindowA, aWindowB, aWindowC),
            TestQuirkHighE(aWindowA, aWindowB, aWindowC),
            TestQuirkHighF(aWindowA, aWindowB, aWindowC),
            TestQuirkHighG(aWindowA, aWindowB, aWindowC),
            TestQuirkHighH(aWindowA, aWindowB, aWindowC)};
        const std::vector<TESTQuirkLow> aTestLow = {
            TestQuirkLowA(aWindowA, aWindowB, aWindowC),
            TestQuirkLowB(aWindowA, aWindowB, aWindowC),
            TestQuirkLowC(aWindowA, aWindowB, aWindowC),
            TestQuirkLowD(aWindowA, aWindowB, aWindowC),
            TestQuirkLowE(aWindowA, aWindowB, aWindowC),
            TestQuirkLowF(aWindowA, aWindowB, aWindowC),
            TestQuirkLowG(aWindowA, aWindowB, aWindowC),
            TestQuirkLowH(aWindowA, aWindowB, aWindowC)};

        // Production variants have distinct types; Cipher owns their common interface.
        std::vector<std::unique_ptr<Cipher>> aHigh;
        aHigh.push_back(std::make_unique<QuirkHighA>(aWindowA, aWindowB, aWindowC));
        aHigh.push_back(std::make_unique<QuirkHighB>(aWindowA, aWindowB, aWindowC));
        aHigh.push_back(std::make_unique<QuirkHighC>(aWindowA, aWindowB, aWindowC));
        aHigh.push_back(std::make_unique<QuirkHighD>(aWindowA, aWindowB, aWindowC));
        aHigh.push_back(std::make_unique<QuirkHighE>(aWindowA, aWindowB, aWindowC));
        aHigh.push_back(std::make_unique<QuirkHighF>(aWindowA, aWindowB, aWindowC));
        aHigh.push_back(std::make_unique<QuirkHighG>(aWindowA, aWindowB, aWindowC));
        aHigh.push_back(std::make_unique<QuirkHighH>(aWindowA, aWindowB, aWindowC));
        std::vector<std::unique_ptr<Cipher>> aLow;
        aLow.push_back(std::make_unique<QuirkLowA>(aWindowA, aWindowB, aWindowC));
        aLow.push_back(std::make_unique<QuirkLowB>(aWindowA, aWindowB, aWindowC));
        aLow.push_back(std::make_unique<QuirkLowC>(aWindowA, aWindowB, aWindowC));
        aLow.push_back(std::make_unique<QuirkLowD>(aWindowA, aWindowB, aWindowC));
        aLow.push_back(std::make_unique<QuirkLowE>(aWindowA, aWindowB, aWindowC));
        aLow.push_back(std::make_unique<QuirkLowF>(aWindowA, aWindowB, aWindowC));
        aLow.push_back(std::make_unique<QuirkLowG>(aWindowA, aWindowB, aWindowC));
        aLow.push_back(std::make_unique<QuirkLowH>(aWindowA, aWindowB, aWindowC));

        const auto aVerify = [&](const auto &aTest, const Cipher &aReal, const char *aName) {
            const bool aSealedA = aTest.SealData(aOriginal.data(), aWorkerA.data(), aEncryptedA.data(), SOCCER_BLOCK_SIZE);
            const bool aSealedB = aReal.SealData(aOriginal.data(), aWorkerB.data(), aEncryptedB.data(), SOCCER_BLOCK_SIZE, nullptr);
            if (!aSealedA || !aSealedB || !CipherGauntlet::Matches(aEncryptedA.data(), aEncryptedB.data(), SOCCER_BLOCK_SIZE)) {
                XCTFail(@"test_QuirkAll: Test%s and %s did not match.", aName, aName);
                return false;
            }

            const bool aUnsealedA = aTest.UnsealData(aEncryptedA.data(), aWorkerA.data(), aDestA.data(), SOCCER_BLOCK_SIZE);
            const bool aUnsealedB = aReal.UnsealData(aEncryptedB.data(), aWorkerB.data(), aDestB.data(), SOCCER_BLOCK_SIZE, nullptr);
            if (!aUnsealedA || !CipherGauntlet::Matches(aOriginal.data(), aDestA.data(), SOCCER_BLOCK_SIZE)) {
                XCTFail(@"test_QuirkAll: Test%s unseal did not work.", aName);
                return false;
            }
            if (!aUnsealedB || !CipherGauntlet::Matches(aOriginal.data(), aDestB.data(), SOCCER_BLOCK_SIZE)) {
                XCTFail(@"test_QuirkAll: %s unseal did not work.", aName);
                return false;
            }
            return true;
        };

        for (std::size_t aIndex=0; aIndex<aHighNames.size(); aIndex++) {
            if (!aVerify(aTestHigh[aIndex], *aHigh[aIndex], aHighNames[aIndex])) return;
            if (!aVerify(aTestLow[aIndex], *aLow[aIndex], aLowNames[aIndex])) return;
        }
    }
}

@end
