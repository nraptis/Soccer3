// Serial, intentionally long: [5 weak, 5 normal, 5 strong], repeated.
// Default: ten batches = 50 random fixtures per strength = 150 trials.
// Set SOCCER_MANY_SHOT_BATCHES and SOCCER_MANY_SHOT_SEED to resize/replay.
// All strengths see the same fixture indices. No production selectors are overridden.
// One summary line per five COMPLETED trials, including failed trials.
#import <XCTest/XCTest.h>
#include "StatisticalRecoveryFixture.hpp"
#include <cerrno>
#include <chrono>
#include <cstdlib>
#include <iomanip>
#include <sstream>
#include <string>

namespace {
using namespace StatisticalRecovery;
using Clock = std::chrono::steady_clock;
constexpr std::size_t kGroupSize = 5U;
constexpr std::size_t kStrengthCount = 3U;
constexpr std::size_t kDefaultBatches = 10U;
constexpr unsigned kFailurePercent = 52U;
constexpr std::size_t kTrainingBudget = 1U + kFlags + kTrain + kValidate;

struct Campaign {
    std::size_t mBatches = kDefaultBatches;
    std::uint64_t mSeed = 0U;
    std::size_t Trials() const { return mBatches * kGroupSize * kStrengthCount; }
};
struct Position {
    EncryptionStrength mStrength;
    std::size_t mStrengthIndex;
    std::size_t mFixture;
};
Position PositionAt(std::size_t pTrial) {
    const auto aStrength = (pTrial / kGroupSize) % kStrengthCount;
    const EncryptionStrength aStrengths[] = {EncryptionStrength::kWeak, EncryptionStrength::kNormal, EncryptionStrength::kStrong};
    return {aStrengths[aStrength], aStrength,
            (pTrial / (kGroupSize * kStrengthCount)) * kGroupSize + pTrial % kGroupSize};
}
const char *StrengthName(std::size_t pIndex) {
    const char *aNames[] = {"weak", "normal", "strong"};
    return aNames[pIndex];
}
bool ParseWord(const char *pText, std::uint64_t &pResult) {
    if (pText == nullptr || *pText < '0' || *pText > '9') return false;
    errno = 0;
    char *aEnd = nullptr;
    const auto aValue = std::strtoull(pText, &aEnd, 0);
    if (errno != 0 || aEnd == pText || *aEnd != '\0') return false;
    pResult = static_cast<std::uint64_t>(aValue);
    return true;
}
bool ReadCampaign(Campaign &pCampaign) {
    if (const auto *aText = std::getenv("SOCCER_MANY_SHOT_BATCHES")) {
        std::uint64_t aCount;
        if (!ParseWord(aText,aCount) || aCount == 0U || aCount > 1000U) return false;
        pCampaign.mBatches = static_cast<std::size_t>(aCount);
    }
    if (const auto *aText = std::getenv("SOCCER_MANY_SHOT_SEED")) return ParseWord(aText,pCampaign.mSeed);
    std::random_device aRandom;
    pCampaign.mSeed = (std::uint64_t{aRandom()} << 32U) ^ aRandom();
    return true;
}

// This exact 52% screen is deliberately stricter than the campaign-adjusted
// significance bound. A screen failure alone is not a significance claim.
std::uint64_t ScreenFlags(const Result &pResult) {
    if (pResult.mQueries == 0U) return 0U;
    std::uint64_t aFlags = 0U;
    for (std::size_t aFlag=0U;aFlag<kFlags;++aFlag)
        if (100U*pResult.mCorrect[aFlag] >= kFailurePercent*pResult.mQueries)
            aFlags |= std::uint64_t{1U} << aFlag;
    return aFlags;
}
struct Trial {
    bool mCompleted = false;
    bool mHasResult = false;
    const char *mError = nullptr;
    std::size_t mBestCorrect = 0U;
    std::uint64_t mScreen = 0U;
    std::uint64_t mSignificant = 0U;
    std::uint64_t mConfirmed = 0U;
    std::uint64_t mControl = 0U;
    bool Passed() const {
        return mCompleted && mError == nullptr && mScreen == 0U && mSignificant == 0U && mControl == 0U;
    }
};
Trial Attack(const Oracle &pVictim,const Scenario &pScenario,
             std::uint64_t pChallengeSeed,std::uint64_t pConfirmSeed,std::size_t pHypotheses) {
    Trial aTrial;
    std::size_t aAttackerCalls = 0U;
    const Oracle aTraining = [&](const Bytes &pInput,Bytes &pOutput) {
        if (aAttackerCalls >= kTrainingBudget) return false;
        ++aAttackerCalls;
        return pVictim(pInput,pOutput);
    };
    Model aModel;
    if (!Train(aTraining,pScenario,aModel,false)) { aTrial.mError="training/API failure";return aTrial; }
    if (aAttackerCalls != kTrainingBudget || aModel.mQueries != kTrainingBudget) {
        aTrial.mError="training query count";return aTrial;
    }
    const Model aFrozen = aModel;
    Result aResult;
    if (!Challenge(pVictim,pScenario,aFrozen,kChallenge,pChallengeSeed,aResult,pHypotheses,false) ||
        aResult.mQueries != kChallenge || aAttackerCalls != kTrainingBudget) {
        aTrial.mError="challenge/API failure";return aTrial;
    }
    aTrial.mHasResult = true;
    aTrial.mBestCorrect = *std::max_element(aResult.mCorrect.begin(),aResult.mCorrect.end());
    aTrial.mScreen = ScreenFlags(aResult);
    aTrial.mSignificant = aResult.mSignificant;
    aTrial.mControl = aResult.mShuffledSignificant;
    if (aTrial.mScreen != 0U || aTrial.mSignificant != 0U) {
        Result aConfirmation;
        if (!Challenge(pVictim,pScenario,aFrozen,kConfirm,pConfirmSeed,aConfirmation,pHypotheses,false) ||
            aConfirmation.mQueries != kConfirm) { aTrial.mError="confirmation/API failure";return aTrial; }
        aTrial.mConfirmed = aTrial.mScreen & ScreenFlags(aConfirmation);
        aTrial.mControl |= aConfirmation.mShuffledSignificant;
    }
    aTrial.mCompleted = true;
    return aTrial;
}
Trial RunTrial(EncryptionStrength pStrength,RandomFixture &pFixture,std::size_t pHypotheses) {
    ClearSoccerOnExit aCleanup;
    Soccer3::Zero();
    Trial aFailure;
    std::uint32_t aAcknowledgement = 0U;
    if (!ValidScenario(pFixture.mScenario) ||
        !Soccer3::AttemptSeed_Encrypt(pStrength,pFixture.mPassword.data(),pFixture.mPassword.size(),
                                     pFixture.mNonce,&aAcknowledgement,0U,nullptr)) {
        aFailure.mError="fixture/seeding failure";return aFailure;
    }
    Bytes aInput=pFixture.mScenario.mTemplate,aCipher(kBlockBytes),aRestored(kBlockBytes);
    if (!Soccer3::EncryptBlock(aInput.data(),aCipher.data()) ||
        !Soccer3::DecryptBlock(aCipher.data(),aRestored.data()) || aRestored!=aInput) {
        aFailure.mError="victim round-trip failure";return aFailure;
    }
    const Oracle aVictim=[](const Bytes &pInput,Bytes &pOutput) {
        if (pInput.size()!=kBlockBytes) return false;
        Bytes aSource=pInput;pOutput.resize(kBlockBytes);
        return Soccer3::EncryptBlock(aSource.data(),pOutput.data());
    };
    return Attack(aVictim,pFixture.mScenario,pFixture.mChallengeSeed,pFixture.mConfirmSeed,pHypotheses);
}
struct Summary {
    std::size_t mTrials=0U,mFailed=0U,mErrors=0U,mControls=0U,mScreened=0U,mSignificant=0U,mConfirmed=0U;
    bool mHasWorst=false;
    std::size_t mWorstCorrect=0U,mWorstFixture=0U;
    const char *mLastError=nullptr;
    void Add(const Trial &pTrial,std::size_t pFixture) {
        ++mTrials;mFailed+=!pTrial.Passed();
        mErrors+=!pTrial.mCompleted || pTrial.mError!=nullptr;
        mControls+=pTrial.mControl!=0U;
        mScreened+=pTrial.mScreen!=0U;
        mSignificant+=pTrial.mSignificant!=0U;
        mConfirmed+=pTrial.mConfirmed!=0U;
        if (pTrial.mError) mLastError=pTrial.mError;
        if (pTrial.mHasResult && (!mHasWorst || pTrial.mBestCorrect>mWorstCorrect)) {
            mHasWorst=true;mWorstCorrect=pTrial.mBestCorrect;mWorstFixture=pFixture;
        }
    }
};
std::string BatchLine(const Campaign &pCampaign,std::size_t pFinished,std::size_t pStrength,
                      const Summary &pGroup,const Summary &pRunning,double pSeconds) {
    std::ostringstream aText;
    aText<<(pGroup.mFailed?"FAIL":"PASS")<<" | "<<StrengthName(pStrength)
         <<" | batch="<<pGroup.mTrials<<" trials, failed="<<pGroup.mFailed
         <<" | worst match=";
    if (pRunning.mHasWorst) aText<<std::fixed<<std::setprecision(4)<<100.0*pRunning.mWorstCorrect/kChallenge
                                <<"% (fixture "<<pRunning.mWorstFixture+1U<<")";
    else aText<<"N/A";
    aText<<" | cutoff=52.0000% | strength total="<<pRunning.mTrials
         <<", failed="<<pRunning.mFailed<<", screened="<<pRunning.mScreened
         <<", significant="<<pRunning.mSignificant<<", confirmed="<<pRunning.mConfirmed
         <<", control failures="<<pRunning.mControls<<", errors="<<pRunning.mErrors;
    if (pGroup.mLastError) aText<<" ("<<pGroup.mLastError<<")";
    aText<<" | done="<<std::fixed<<std::setprecision(2)<<100.0*pFinished/pCampaign.Trials()
         <<"% ("<<pFinished<<'/'<<pCampaign.Trials()<<") | "<<std::setprecision(1)<<pSeconds
         <<"s | replay seed=0x"<<std::hex<<pCampaign.mSeed;
    return aText.str();
}
}

@interface DiscardableTestRandomManyShot : XCTestCase
@end
@implementation DiscardableTestRandomManyShot
- (void)testRandomManyShotAllStrengths {
    ClearSoccerOnExit aCleanup;
    self.continueAfterFailure=YES;
    Campaign aCampaign;
    if (!ReadCampaign(aCampaign)) { XCTFail(@"Invalid MANY_SHOT config: batches 1..1000, seed uint64");return; }
    Summary aRunning[3];
    const auto aHypotheses=aCampaign.Trials()*kFlags;
    for (std::size_t aGroup=0U;aGroup<aCampaign.Trials();aGroup+=kGroupSize) {
        const auto aStart=Clock::now();
        Summary aSummary;
        const auto aStrength=PositionAt(aGroup).mStrengthIndex;
        for (std::size_t aOffset=0U;aOffset<kGroupSize;++aOffset) {
            const auto aPosition=PositionAt(aGroup+aOffset);
            auto aFixture=MakeRandomFixture(aCampaign.mSeed,aPosition.mFixture);
            const auto aTrial=RunTrial(aPosition.mStrength,aFixture,aHypotheses);
            aSummary.Add(aTrial,aPosition.mFixture);
            aRunning[aStrength].Add(aTrial,aPosition.mFixture);
        }
        const auto aLine=BatchLine(aCampaign,aGroup+kGroupSize,aStrength,aSummary,aRunning[aStrength],
                                  std::chrono::duration<double>(Clock::now()-aStart).count());
        std::puts(aLine.c_str());std::fflush(stdout);
    }
    const auto aFailed=aRunning[0].mFailed+aRunning[1].mFailed+aRunning[2].mFailed;
    XCTAssertEqual(aFailed,0U,@"%zu/%zu random trials failed; replay seed=0x%016llx",aFailed,aCampaign.Trials(),
                   static_cast<unsigned long long>(aCampaign.mSeed));
}

- (void)testScheduleReplayAndThresholdBoundaries {
    Campaign aCampaign;aCampaign.mSeed=0xC0FFEEU;
    XCTAssertEqual(aCampaign.Trials(),150U);
    for (std::size_t aTrial=0U;aTrial<aCampaign.Trials();++aTrial) {
        const auto aPosition=PositionAt(aTrial);
        XCTAssertEqual(aPosition.mStrengthIndex,(aTrial/5U)%3U);
        XCTAssertEqual(aPosition.mFixture,(aTrial/15U)*5U+aTrial%5U);
    }
    for (std::size_t aIndex=0U;aIndex<8U;++aIndex) {
        const auto aFirst=MakeRandomFixture(aCampaign.mSeed,aIndex),aRepeat=MakeRandomFixture(aCampaign.mSeed,aIndex);
        XCTAssertTrue(ValidScenario(aFirst.mScenario));
        XCTAssertTrue(aFirst.mPassword==aRepeat.mPassword);
        XCTAssertEqual(aFirst.mNonce,aRepeat.mNonce);
        XCTAssertTrue(aFirst.mScenario.mBits==aRepeat.mScenario.mBits);
        XCTAssertTrue(aFirst.mScenario.mTemplate==aRepeat.mScenario.mTemplate);
        for (std::size_t aHalf=0U;aHalf<2U;++aHalf) {
            unsigned aCounts[8]{};
            for (std::size_t aFlag=32U*aHalf;aFlag<32U*(aHalf+1U);++aFlag) ++aCounts[aFirst.mScenario.mBits[aFlag]%8U];
            for (auto aCount:aCounts) XCTAssertEqual(aCount,4U);
        }
    }
    Result aResult;aResult.mQueries=kChallenge;
    aResult.mCorrect[0]=8519U;XCTAssertEqual(ScreenFlags(aResult),0U);
    aResult.mCorrect[0]=8520U;XCTAssertEqual(ScreenFlags(aResult),1U);
    XCTAssertGreaterThan(AdjustedTailBound(8520U,kChallenge,aCampaign.Trials()*kFlags),kFamilyAlpha);
    std::uint64_t aParsed=0U;
    XCTAssertTrue(ParseWord("0x1234",aParsed));XCTAssertEqual(aParsed,0x1234U);
    XCTAssertFalse(ParseWord("-1",aParsed));XCTAssertFalse(ParseWord("junk",aParsed));
    XCTAssertFalse(ParseWord("18446744073709551616",aParsed));
}

- (void)testBiasedControlConfirmationAndApiFailures {
    const auto aScenario=MakeScenario(128U);
    const Oracle aBiased=[&](const Bytes &pInput,Bytes &pOutput) {
        pOutput=pInput;
        const auto a=pInput[aScenario.mBits[1]/8U]>>(aScenario.mBits[1]%8U);
        const auto b=pInput[aScenario.mBits[2]/8U]>>(aScenario.mBits[2]%8U);
        pOutput[aScenario.mBits[0]/8U]^=static_cast<std::uint8_t>(((a&b)&1U)<<(aScenario.mBits[0]%8U));
        return true;
    };
    const auto aRecovered=Attack(aBiased,aScenario,0x1234U,0x9876U,150U*kFlags);
    XCTAssertTrue(aRecovered.mCompleted);XCTAssertFalse(aRecovered.Passed());
    XCTAssertNotEqual(aRecovered.mScreen,0U);XCTAssertNotEqual(aRecovered.mConfirmed,0U);
    XCTAssertEqual(aRecovered.mControl,0U);
    std::size_t aCalls=0U;
    const Oracle aFailure=[&](const Bytes &,Bytes &) {++aCalls;return false;};
    const auto aFailed=Attack(aFailure,aScenario,1U,2U,150U*kFlags);
    XCTAssertFalse(aFailed.Passed());XCTAssertFalse(aFailed.mCompleted);XCTAssertEqual(aCalls,1U);
}

- (void)testBatchSummaryIncludesFailuresWorstPercentAndProgress {
    Campaign aCampaign;aCampaign.mSeed=0x1234U;
    Summary aSummary;
    Trial aGood;aGood.mCompleted=true;aGood.mHasResult=true;aGood.mBestCorrect=8350U;
    for (unsigned aIndex=0U;aIndex<4U;++aIndex) aSummary.Add(aGood,aIndex);
    Trial aBad=aGood;aBad.mBestCorrect=9000U;aBad.mScreen=1U;aSummary.Add(aBad,4U);
    const auto aLine=BatchLine(aCampaign,5U,0U,aSummary,aSummary,1000.0);
    XCTAssertTrue(aLine.find("FAIL | weak")!=std::string::npos);
    XCTAssertTrue(aLine.find("worst match=54.9316%")!=std::string::npos);
    XCTAssertTrue(aLine.find("done=3.33% (5/150)")!=std::string::npos);
    XCTAssertTrue(aLine.find("failed=1")!=std::string::npos);
    XCTAssertTrue(aLine.find("replay seed=0x1234")!=std::string::npos);
}
@end
