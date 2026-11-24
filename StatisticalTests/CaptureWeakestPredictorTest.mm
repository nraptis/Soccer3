// Weak only. Descriptive capture, with no security pass/fail threshold.
// Default: run until stopped. Save each fixture, summarize every five.
#import <XCTest/XCTest.h>
#include <CommonCrypto/CommonDigest.h>
#include "FileIO.hpp"
#include "StatisticalRecoveryFixture.hpp"
#include <cerrno>
#include <chrono>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <sstream>
#include <string>

namespace {
using namespace StatisticalRecovery;
using CaptureClock = std::chrono::steady_clock;
constexpr std::size_t kCaptureGroupSize = 5U;
constexpr std::size_t kProgressIntervalBlocks = 32768U;
constexpr std::size_t kCaptureVerificationSamples = 262144U;
constexpr std::size_t kCaptureTrainingQueries = 1U + kFlags + kTrain + kValidate;
NSString *const kCaptureCipherPlan = @"fourtoad-corvid-per-layer-v1";

struct CaptureOptions {
    std::uint64_t mSeed = 0U;
    std::size_t mFirstFixture = 0U;
    std::size_t mRunLimit = 0U; // Zero means unlimited.
    std::size_t mScreenSamples = kChallenge;
    std::size_t mVerificationSamples = kCaptureVerificationSamples;
    NSString *mOutputDirectory = nil;
};

NSString *HexWord(std::uint64_t pWord) {
    return [NSString stringWithFormat:@"0x%016llx", static_cast<unsigned long long>(pWord)];
}
NSString *HexBytes(const std::uint8_t *pBytes, std::size_t pCount) {
    std::ostringstream aText;
    aText << std::hex << std::setfill('0');
    for (std::size_t aIndex = 0U; aIndex < pCount; ++aIndex)
        aText << std::setw(2) << static_cast<unsigned>(pBytes[aIndex]);
    return [NSString stringWithUTF8String:aText.str().c_str()];
}

bool ReadCaptureWord(const char *pName, std::uint64_t &pResult) {
    const char *aText = std::getenv(pName);
    if (aText == nullptr) return true;
    if (*aText < '0' || *aText > '9') return false;
    errno = 0;
    char *aEnd = nullptr;
    const auto aWord = std::strtoull(aText, &aEnd, 0);
    if (errno != 0 || aEnd == aText || *aEnd != '\0') return false;
    pResult = aWord;
    return true;
}
NSString *StatisticalOutputRoot() {
    return [NSString stringWithUTF8String:StatisticalTests::FileIO::ProjectRoot("Statistical Outputs").c_str()];
}
bool ReadCaptureOptions(CaptureOptions &pOptions) {
    std::random_device aRandom;
    pOptions.mSeed = (std::uint64_t{aRandom()} << 32U) ^ aRandom();
    std::uint64_t aRuns = 0U, aFirst = 0U, aSamples = kCaptureVerificationSamples;
    if (!ReadCaptureWord("SOCCER_CAPTURE_SEED", pOptions.mSeed) ||
        !ReadCaptureWord("SOCCER_CAPTURE_RUNS", aRuns) ||
        !ReadCaptureWord("SOCCER_CAPTURE_FIRST_FIXTURE", aFirst) ||
        !ReadCaptureWord("SOCCER_CAPTURE_VERIFICATION_SAMPLES", aSamples) ||
        aSamples == 0U || aSamples > 16777216U || aRuns > 1000000000U ||
        aFirst > 1000000000U) return false;
    pOptions.mRunLimit = aRuns;
    pOptions.mFirstFixture = aFirst;
    pOptions.mVerificationSamples = aSamples;
    NSString *aRoot;
    if (const char *aDirectory = std::getenv("SOCCER_CAPTURE_OUTPUT")) {
        aRoot = [NSString stringWithUTF8String:aDirectory];
        if (aRoot.length == 0U) return false;
    } else {
        aRoot = [StatisticalOutputRoot() stringByAppendingPathComponent:@"CaptureWeakestPredictorTest"];
    }
    // A new directory for each invocation preserves earlier campaigns, including replays.
    NSDateFormatter *aFormat = [NSDateFormatter new];
    aFormat.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    aFormat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    aFormat.dateFormat = @"yyyyMMdd'T'HHmmss'Z'";
    NSString *aSession = [NSString stringWithFormat:@"%@-%@-%@", [aFormat stringFromDate:[NSDate date]],
                          HexWord(pOptions.mSeed), [NSUUID UUID].UUIDString];
    pOptions.mOutputDirectory = [aRoot stringByAppendingPathComponent:aSession];
    return true;
}

struct CaptureObservation {
    Model mFrozen;
    Result mScreen;
    Result mVerification;
    std::size_t mScreenWinner = 0U;
    std::uint32_t mAcknowledgement = 0U;
    NSString *mTemplateCipherSHA256 = nil;
    double mSeconds = 0.0;
    const char *mError = nullptr;
};

std::size_t MostDeviantFlag(const Result &pResult) {
    std::size_t aWinner = 0U;
    std::uint64_t aLargest = 0U;
    for (std::size_t aFlag = 0U; aFlag < kFlags; ++aFlag) {
        const std::uint64_t aTwiceCorrect = 2U * pResult.mCorrect[aFlag];
        const std::uint64_t aDeviation = aTwiceCorrect > pResult.mQueries ?
            aTwiceCorrect - pResult.mQueries : pResult.mQueries - aTwiceCorrect;
        if (aFlag == 0U || aDeviation > aLargest) { aWinner = aFlag; aLargest = aDeviation; }
    }
    return aWinner;
}

NSData *JsonData(id pObject, bool pPretty);
bool AtomicWrite(NSData *pData, NSString *pPath);

struct CaptureProgress {
    const CaptureOptions &mOptions;
    const RandomFixture &mFixture;
    std::size_t mRun;
    const char *mPhase = "training";
    std::size_t mBlocks = 0U;
    std::size_t mTotal = kCaptureTrainingQueries;

    void Report(NSString *pStatus = @"running") const {
        const auto aFixtureIndex = mOptions.mFirstFixture + mRun - 1U;
        NSDictionary *aProgress = @{
            @"run": @(mRun), @"fixture_index": @(aFixtureIndex), @"campaign_seed": HexWord(mOptions.mSeed),
            @"cipher_plan": kCaptureCipherPlan,
            @"password_hex": HexBytes(mFixture.mPassword.data(), mFixture.mPassword.size()), @"nonce": HexWord(mFixture.mNonce),
            @"status": pStatus, @"phase": [NSString stringWithUTF8String:mPhase], @"blocks_encrypted_in_phase": @(mBlocks),
            @"phase_total_blocks": @(mTotal), @"updated_unix_seconds": @([NSDate date].timeIntervalSince1970)
        };
        AtomicWrite(JsonData(aProgress, true), [mOptions.mOutputDirectory stringByAppendingPathComponent:@"progress.json"]);
        std::printf("CAPTURE | weak | run=%zu fixture=%zu | %s | %s %zu/%zu blocks (%.1f%%)\n",
                    mRun, aFixtureIndex, pStatus.UTF8String, mPhase, mBlocks, mTotal, 100.0 * mBlocks / mTotal);
        std::fflush(stdout);
    }
    void StartPhase(const char *pPhase, std::size_t pTotal) {
        mPhase = pPhase;
        mTotal = pTotal;
        mBlocks = 0U;
        Report();
    }
};

CaptureObservation MeasureFixture(RandomFixture &pFixture, const CaptureOptions &pOptions, CaptureProgress &pProgress) {
    ClearSoccerOnExit aCleanup;
    CaptureObservation aObservation;
    pProgress.Report();
    if (!ValidScenario(pFixture.mScenario) ||
        !Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kWeak, pFixture.mPassword.data(),
            pFixture.mPassword.size(), pFixture.mNonce, &aObservation.mAcknowledgement, 0U, nullptr)) {
        aObservation.mError = "weak fixture/seeding failure";
        return aObservation;
    }
    Bytes aInput = pFixture.mScenario.mTemplate, aCipher(kBlockBytes), aRestored(kBlockBytes);
    if (!Soccer3::EncryptBlock(aInput.data(), aCipher.data()) ||
        !Soccer3::DecryptBlock(aCipher.data(), aRestored.data()) || aInput != aRestored) {
        aObservation.mError = "victim round-trip failure";
        return aObservation;
    }
    unsigned char aDigest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(aCipher.data(), static_cast<CC_LONG>(aCipher.size()), aDigest);
    aObservation.mTemplateCipherSHA256 = HexBytes(aDigest, sizeof(aDigest));
    const Oracle aVictim = [&](const Bytes &pInput, Bytes &pOutput) {
        if (pInput.size() != kBlockBytes) return false;
        Bytes aSource = pInput;
        pOutput.resize(kBlockBytes);
        if (!Soccer3::EncryptBlock(aSource.data(), pOutput.data())) return false;
        ++pProgress.mBlocks;
        if (pProgress.mBlocks % kProgressIntervalBlocks == 0U && pProgress.mBlocks < pProgress.mTotal)
            pProgress.Report();
        return true;
    };
    std::size_t aTrainingCalls = 0U;
    const Oracle aTraining = [&](const Bytes &pInput, Bytes &pOutput) {
        if (aTrainingCalls >= kCaptureTrainingQueries) return false;
        ++aTrainingCalls;
        return aVictim(pInput, pOutput);
    };
    Model aModel;
    if (!Train(aTraining, pFixture.mScenario, aModel, false) ||
        aTrainingCalls != kCaptureTrainingQueries || aModel.mQueries != kCaptureTrainingQueries) {
        aObservation.mError = "training/API failure";
        return aObservation;
    }
    aObservation.mFrozen = aModel;
    pProgress.StartPhase("screening", pOptions.mScreenSamples);
    if (!Challenge(aVictim, pFixture.mScenario, aObservation.mFrozen, pOptions.mScreenSamples,
                   pFixture.mChallengeSeed, aObservation.mScreen, kFlags, false) ||
        aObservation.mScreen.mQueries != pOptions.mScreenSamples) {
        aObservation.mError = "screening/API failure";
        return aObservation;
    }
    // Select before fresh verification. Never refit a predictor or flip polarity
    // after seeing either challenge's labels, even for below-chance results.
    aObservation.mScreenWinner = MostDeviantFlag(aObservation.mScreen);
    pProgress.StartPhase("verification", pOptions.mVerificationSamples);
    if (!Challenge(aVictim, pFixture.mScenario, aObservation.mFrozen, pOptions.mVerificationSamples,
                   pFixture.mConfirmSeed, aObservation.mVerification, kFlags, false) ||
        aObservation.mVerification.mQueries != pOptions.mVerificationSamples ||
        aTrainingCalls != kCaptureTrainingQueries) {
        aObservation.mError = "fresh verification/API failure";
    }
    // Challenge's finite-experiment significance fields are deliberately unused:
    // an unbounded diagnostic must not report them as campaign-wide significance.
    return aObservation;
}

struct CaptureBucket {
    std::uint64_t mPredictors = 0U;
    std::uint64_t mCorrect = 0U;
    std::uint64_t mMeasurements = 0U;
    void Add(std::size_t pCorrect, std::size_t pMeasurements) {
        ++mPredictors;
        mCorrect += pCorrect;
        mMeasurements += pMeasurements;
    }
    double Percent() const { return mMeasurements == 0U ? 0.0 : 100.0 * mCorrect / mMeasurements; }
    NSDictionary *Json() const {
        return @{@"predictors": @(mPredictors), @"correct": @(mCorrect), @"measurements": @(mMeasurements),
                 @"mean_match_percent": mMeasurements == 0U ? (id)[NSNull null] : @(Percent())};
    }
};
struct CaptureRates {
    CaptureBucket mAll, mAbove, mBelow, mEqual;
    void Add(std::size_t pCorrect, std::size_t pMeasurements) {
        mAll.Add(pCorrect, pMeasurements);
        if (2U * pCorrect > pMeasurements) mAbove.Add(pCorrect, pMeasurements);
        else if (2U * pCorrect < pMeasurements) mBelow.Add(pCorrect, pMeasurements);
        else mEqual.Add(pCorrect, pMeasurements);
    }
    NSDictionary *Json() const {
        return @{@"all": mAll.Json(), @"above_50": mAbove.Json(),
                 @"below_50": mBelow.Json(), @"exactly_50": mEqual.Json()};
    }
};

NSDictionary *ObservationRecord(const CaptureOptions &pOptions, std::size_t pRun, std::size_t pFixtureIndex,
                                const RandomFixture &pFixture, const CaptureObservation &pObservation) {
    NSMutableDictionary *aRecord = [@{
        @"format": @"weak-predictor-capture-v1", @"strength": @"weak", @"run": @(pRun),
        @"cipher_plan": kCaptureCipherPlan,
        @"fixture_index": @(pFixtureIndex), @"campaign_seed": HexWord(pOptions.mSeed),
        @"seconds": @(pObservation.mSeconds), @"status": pObservation.mError ? @"error" : @"observed",
        @"password_hex": HexBytes(pFixture.mPassword.data(), pFixture.mPassword.size()),
        @"nonce": HexWord(pFixture.mNonce), @"acknowledgement": @(pObservation.mAcknowledgement),
        @"screen_seed": HexWord(pFixture.mChallengeSeed), @"verification_seed": HexWord(pFixture.mConfirmSeed),
        @"screen_samples": @(pOptions.mScreenSamples), @"verification_samples": @(pOptions.mVerificationSamples)
    } mutableCopy];
    if (pObservation.mError) {
        aRecord[@"error"] = [NSString stringWithUTF8String:pObservation.mError];
        return aRecord;
    }
    NSMutableArray *aPredictions = [NSMutableArray arrayWithCapacity:kFlags];
    CaptureRates aVerificationRates, aShuffledRates;
    for (std::size_t aFlag = 0U; aFlag < kFlags; ++aFlag) {
        const auto &aCandidate = pObservation.mFrozen.mPredictions[aFlag];
        const auto aCorrect = pObservation.mVerification.mCorrect[aFlag];
        aVerificationRates.Add(aCorrect, pObservation.mVerification.mQueries);
        aShuffledRates.Add(pObservation.mVerification.mShuffledCorrect[aFlag], pObservation.mVerification.mQueries);
        [aPredictions addObject:@{
            @"flag": @(aFlag), @"plaintext_bit": @(pFixture.mScenario.mBits[aFlag]),
            @"ciphertext_bit_a": @(aCandidate.mFeature.mA),
            @"ciphertext_bit_b": aCandidate.mFeature.mB == kNoBit ? (id)[NSNull null] : @(aCandidate.mFeature.mB),
            @"polarity": @(aCandidate.mPolarity),
            @"training_correct": @(aCandidate.mTrainingCorrect),
            @"screen_correct": @(pObservation.mScreen.mCorrect[aFlag]),
            @"verification_correct": @(aCorrect),
            @"verification_match_percent": @(100.0 * aCorrect / pObservation.mVerification.mQueries),
            @"shuffled_correct": @(pObservation.mVerification.mShuffledCorrect[aFlag])
        }];
    }
    aRecord[@"training_queries"] = @(pObservation.mFrozen.mQueries);
    aRecord[@"block_bytes"] = @(kBlockBytes);
    aRecord[@"template_cipher_sha256"] = pObservation.mTemplateCipherSHA256 ?: (id)[NSNull null];
    aRecord[@"features_searched"] = @(pObservation.mFrozen.mFeatures);
    aRecord[@"sampled_bytes"] = @(pObservation.mFrozen.mSampledBytes);
    aRecord[@"screen_selected_flag"] = @(pObservation.mScreenWinner);
    aRecord[@"verification_max_deviant_flag"] = @(MostDeviantFlag(pObservation.mVerification));
    aRecord[@"verification_rates"] = aVerificationRates.Json();
    aRecord[@"shuffled_control_rates"] = aShuffledRates.Json();
    aRecord[@"predictors"] = aPredictions;
    return aRecord;
}

struct CaptureSummary {
    std::size_t mAttempts = 0U, mCompleted = 0U, mErrors = 0U;
    CaptureRates mVerification, mShuffled, mScreenSelected;
    double mMaximumDeviation = -1.0;
    NSDictionary *mWeakest = nil;
    NSData *mWeakestTemplate = nil;
    NSString *mWeakestTemplateName = nil;

    void Add(NSDictionary *pRecord, const RandomFixture &pFixture, const CaptureObservation &pObservation) {
        ++mAttempts;
        if (pObservation.mError) { ++mErrors; return; }
        ++mCompleted;
        const auto &aResult = pObservation.mVerification;
        for (std::size_t aFlag = 0U; aFlag < kFlags; ++aFlag) {
            mVerification.Add(aResult.mCorrect[aFlag], aResult.mQueries);
            mShuffled.Add(aResult.mShuffledCorrect[aFlag], aResult.mQueries);
        }
        mScreenSelected.Add(aResult.mCorrect[pObservation.mScreenWinner], aResult.mQueries);
        const auto aFlag = MostDeviantFlag(aResult);
        const double aPercent = 100.0 * aResult.mCorrect[aFlag] / aResult.mQueries;
        const double aDeviation = std::abs(aPercent - 50.0);
        if (aDeviation > mMaximumDeviation) {
            mMaximumDeviation = aDeviation;
            mWeakestTemplateName = [NSString stringWithFormat:@"weakest-run-%@-template.bin", pRecord[@"run"]];
            mWeakestTemplate = [NSData dataWithBytes:pFixture.mScenario.mTemplate.data()
                                             length:pFixture.mScenario.mTemplate.size()];
            mWeakest = @{@"run": pRecord[@"run"], @"fixture_index": pRecord[@"fixture_index"],
                @"predictor": pRecord[@"predictors"][aFlag], @"match_percent": @(aPercent),
                @"absolute_deviation_percentage_points": @(aDeviation),
                @"selected_during_screening": @(aFlag == pObservation.mScreenWinner),
                @"template_file": mWeakestTemplateName, @"replay_record": pRecord};
        }
    }
    NSDictionary *Json(const CaptureOptions &pOptions) const {
        return @{
            @"format": @"weak-predictor-capture-v1", @"strength": @"weak", @"campaign_seed": HexWord(pOptions.mSeed),
            @"cipher_plan": kCaptureCipherPlan,
            @"first_fixture_index": @(pOptions.mFirstFixture), @"run_limit": @(pOptions.mRunLimit),
            @"attempted_runs": @(mAttempts), @"completed_runs": @(mCompleted), @"error_runs": @(mErrors),
            @"next_fixture_index": @(pOptions.mFirstFixture + mAttempts), @"flags_per_run": @(kFlags),
            @"training_queries_per_run": @(kCaptureTrainingQueries), @"screen_samples": @(pOptions.mScreenSamples),
            @"verification_samples": @(pOptions.mVerificationSamples),
            @"verification_rates": mVerification.Json(), @"shuffled_control_rates": mShuffled.Json(),
            @"screen_selected_predictors_on_fresh_data": mScreenSelected.Json(),
            @"maximum_deviant": mWeakest ?: (id)[NSNull null],
            @"compiled": [NSString stringWithUTF8String:__DATE__ " " __TIME__],
            @"fixture_recipe": @"StatisticalRecoveryFixture/MakeRandomFixture-v1",
            @"interpretation": @"Descriptive only. Conditional above/below means and maximum deviations select on observed results. No security pass/fail or unbounded-campaign significance claim."
        };
    }
};

NSData *JsonData(id pObject, bool pPretty) {
    NSError *aError = nil;
    NSData *aData = [NSJSONSerialization dataWithJSONObject:pObject
        options:pPretty ? NSJSONWritingPrettyPrinted | NSJSONWritingSortedKeys : NSJSONWritingSortedKeys error:&aError];
    if (aData == nil) std::fprintf(stderr, "CAPTURE JSON ERROR | %s\n", aError.description.UTF8String);
    return aData;
}
bool AtomicWrite(NSData *pData, NSString *pPath) {
    NSError *aError = nil;
    if (pData != nil && [pData writeToFile:pPath options:NSDataWritingAtomic error:&aError]) return true;
    std::fprintf(stderr, "CAPTURE FILE ERROR | %s | %s\n", pPath.UTF8String,
                 aError ? aError.description.UTF8String : "no data");
    return false;
}

void Checkpoint(const CaptureOptions &pOptions, const CaptureSummary &pSummary, NSDictionary *pRecord) {
    NSError *aError = nil;
    const bool aDirectoryReady = [[NSFileManager defaultManager] createDirectoryAtPath:pOptions.mOutputDirectory
        withIntermediateDirectories:YES attributes:nil error:&aError];
    NSData *aLine = pRecord ? JsonData(pRecord, false) : nil;
    const auto aSummaryData = JsonData(pSummary.Json(pOptions), true);
    bool aWritten = aDirectoryReady && (!pRecord || aLine != nil);
    if (aDirectoryReady && aLine != nil) {
        NSString *aPath = [pOptions.mOutputDirectory stringByAppendingPathComponent:@"runs.jsonl"];
        std::ofstream aOutput(aPath.fileSystemRepresentation, std::ios::binary | std::ios::app);
        aOutput.write(static_cast<const char *>(aLine.bytes), aLine.length);
        aOutput.put('\n');
        aOutput.close();
        aWritten = aOutput.good();
    }
    if (aDirectoryReady && pSummary.mWeakestTemplate != nil) {
        NSString *aPath = [pOptions.mOutputDirectory stringByAppendingPathComponent:pSummary.mWeakestTemplateName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:aPath])
            aWritten = AtomicWrite(pSummary.mWeakestTemplate, aPath) && aWritten;
    }
    if (aDirectoryReady)
        aWritten = AtomicWrite(aSummaryData, [pOptions.mOutputDirectory stringByAppendingPathComponent:@"summary.json"]) && aWritten;
    if (!aWritten) {
        // Printing the complete records is an intentional fallback if file output fails.
        std::fprintf(stderr, "CAPTURE | checkpoint could not be fully saved; JSON follows for manual capture.\n");
        if (aLine.length) { std::fwrite(aLine.bytes, 1U, aLine.length, stdout); std::puts(""); }
        if (aSummaryData.length) std::fwrite(aSummaryData.bytes, 1U, aSummaryData.length, stdout);
        std::puts("");
    }
    std::fflush(stdout);
}

std::string MeanText(const CaptureBucket &pBucket) {
    if (pBucket.mMeasurements == 0U) return "N/A";
    std::ostringstream aText;
    aText << std::fixed << std::setprecision(4) << pBucket.Percent() << '%';
    return aText.str();
}
void PrintCaptureSummary(const CaptureSummary &pSummary, double pBatchSeconds) {
    std::printf("CAPTURE | weak | runs=%zu, completed=%zu, errors=%zu | above50=%s (n=%llu) | below50=%s (n=%llu) | equal50=%llu | overall=%s | shuffled above50=%s below50=%s | ",
        pSummary.mAttempts, pSummary.mCompleted, pSummary.mErrors,
        MeanText(pSummary.mVerification.mAbove).c_str(), static_cast<unsigned long long>(pSummary.mVerification.mAbove.mPredictors),
        MeanText(pSummary.mVerification.mBelow).c_str(), static_cast<unsigned long long>(pSummary.mVerification.mBelow.mPredictors),
        static_cast<unsigned long long>(pSummary.mVerification.mEqual.mPredictors), MeanText(pSummary.mVerification.mAll).c_str(),
        MeanText(pSummary.mShuffled.mAbove).c_str(), MeanText(pSummary.mShuffled.mBelow).c_str());
    if (pSummary.mWeakest) {
        std::printf("max deviation=%.4fpp (match=%.4f%% run=%llu flag=%llu) | ", pSummary.mMaximumDeviation,
            [pSummary.mWeakest[@"match_percent"] doubleValue], [pSummary.mWeakest[@"run"] unsignedLongLongValue],
            [pSummary.mWeakest[@"predictor"][@"flag"] unsignedLongLongValue]);
    } else std::printf("max deviation=N/A | ");
    std::printf("screen-selected fresh mean=%s | batch=%.1fs\n", MeanText(pSummary.mScreenSelected.mAll).c_str(), pBatchSeconds);
    std::fflush(stdout);
}

void RunCapture(const CaptureOptions &pOptions) {
    CaptureSummary aSummary;
    std::printf("CAPTURE START | weak only | seed=%s | first fixture=%zu | run limit=%zu (0=unlimited) | screen=%zu, fresh verification=%zu per predictor | save every run | directory=%s\n",
        HexWord(pOptions.mSeed).UTF8String, pOptions.mFirstFixture, pOptions.mRunLimit,
        pOptions.mScreenSamples, pOptions.mVerificationSamples, pOptions.mOutputDirectory.UTF8String);
    Checkpoint(pOptions, aSummary, nil); // Save configuration immediately, before the first long run.
    auto aBatchStart = CaptureClock::now();
    for (std::size_t aRun = 0U; pOptions.mRunLimit == 0U || aRun < pOptions.mRunLimit; ++aRun) {
        @autoreleasepool {
            const auto aStart = CaptureClock::now();
            const auto aFixtureIndex = pOptions.mFirstFixture + aRun;
            auto aFixture = MakeRandomFixture(pOptions.mSeed, aFixtureIndex);
            CaptureProgress aProgress{pOptions, aFixture, aRun + 1U};
            auto aObservation = MeasureFixture(aFixture, pOptions, aProgress);
            aObservation.mSeconds = std::chrono::duration<double>(CaptureClock::now() - aStart).count();
            NSDictionary *aRecord = ObservationRecord(pOptions, aRun + 1U, aFixtureIndex, aFixture, aObservation);
            aSummary.Add(aRecord, aFixture, aObservation);
            Checkpoint(pOptions, aSummary, aRecord);
            aProgress.Report(aObservation.mError ? @"error" : @"completed");
            if (aObservation.mError)
                std::fprintf(stderr, "CAPTURE ERROR | run=%zu fixture=%zu | %s\n", aRun + 1U, aFixtureIndex, aObservation.mError);
        }
        if (aSummary.mAttempts % kCaptureGroupSize == 0U || aSummary.mAttempts == pOptions.mRunLimit) {
            PrintCaptureSummary(aSummary, std::chrono::duration<double>(CaptureClock::now() - aBatchStart).count());
            aBatchStart = CaptureClock::now();
        }
    }
}
} // namespace

@interface CaptureWeakestPredictorTest : XCTestCase
@end
@implementation CaptureWeakestPredictorTest
- (void)testCaptureWeakestPredictor {
    CaptureOptions aOptions;
    if (!ReadCaptureOptions(aOptions)) {
        XCTFail(@"CAPTURE CONFIG ERROR | invalid SOCCER_CAPTURE setting; diagnostic not started.");
        return;
    }
    id<NSObject> aActivity = [NSProcessInfo.processInfo
        beginActivityWithOptions:NSActivityUserInitiated
        reason:@"Running the weak-cipher overnight capture"];
    @try {
        RunCapture(aOptions);
    } @finally {
        [NSProcessInfo.processInfo endActivity:aActivity];
    }
}
@end

// Bounded checks for the recorder. These do not run the indefinite diagnostic.
@interface CaptureWeakestPredictorReportingTests : XCTestCase
@end
@implementation CaptureWeakestPredictorReportingTests
- (void)testSeparateAboveBelowAndExactMeans {
    CaptureRates aRates;
    for (const auto aCorrect : {55U, 60U, 45U, 40U, 50U}) aRates.Add(aCorrect, 100U);
    XCTAssertEqual(aRates.mAll.mPredictors, 5U);
    XCTAssertEqualWithAccuracy(aRates.mAll.Percent(), 50.0, 0.000001);
    XCTAssertEqual(aRates.mAbove.mPredictors, 2U);
    XCTAssertEqualWithAccuracy(aRates.mAbove.Percent(), 57.5, 0.000001);
    XCTAssertEqualWithAccuracy(aRates.mBelow.Percent(), 42.5, 0.000001);
    XCTAssertEqual(aRates.mEqual.mPredictors, 1U);
    CaptureRates aEmpty;
    XCTAssertEqualObjects(aEmpty.Json()[@"above_50"][@"mean_match_percent"], [NSNull null]);
}

- (void)testEachRunCheckpointsAndPreservesNegativeMaximumAndFrozenScreenWinner {
    CaptureOptions aOptions;
    aOptions.mSeed = 0xF79062DF8A905396ULL;
    aOptions.mScreenSamples = 100U;
    aOptions.mVerificationSamples = 100U;
    aOptions.mOutputDirectory = [NSTemporaryDirectory() stringByAppendingPathComponent:
        [@"SoccerCaptureReporting-" stringByAppendingString:[NSUUID UUID].UUIDString]];
    auto aFixture = MakeRandomFixture(aOptions.mSeed, 0U);
    CaptureObservation aObservation;
    aObservation.mScreen.mQueries = 100U;
    aObservation.mVerification.mQueries = 100U;
    for (std::size_t aFlag = 0U; aFlag < kFlags; ++aFlag) {
        aObservation.mScreen.mCorrect[aFlag] = 50U;
        aObservation.mVerification.mCorrect[aFlag] = 50U;
        aObservation.mVerification.mShuffledCorrect[aFlag] = 50U;
        aObservation.mFrozen.mPredictions[aFlag].mFeature = {static_cast<std::uint32_t>(aFlag), kNoBit};
    }
    aObservation.mScreen.mCorrect[2U] = 65U;
    aObservation.mScreenWinner = MostDeviantFlag(aObservation.mScreen);
    aObservation.mVerification.mCorrect[2U] = 55U;
    aObservation.mVerification.mCorrect[3U] = 30U;
    aObservation.mFrozen.mPredictions[3U].mPolarity = 1U;
    CaptureSummary aSummary;
    for (std::size_t aRun = 1U; aRun <= 5U; ++aRun) {
        auto aRecord = ObservationRecord(aOptions, aRun, 0U, aFixture, aObservation);
        aSummary.Add(aRecord, aFixture, aObservation);
        Checkpoint(aOptions, aSummary, aRecord);
        NSData *aData = [NSData dataWithContentsOfFile:[aOptions.mOutputDirectory stringByAppendingPathComponent:@"summary.json"]];
        NSDictionary *aCheckpoint = aData ? [NSJSONSerialization JSONObjectWithData:aData options:0 error:nullptr] : nil;
        XCTAssertEqual([aCheckpoint[@"completed_runs"] unsignedIntegerValue], aRun);
    }
    NSError *aError = nil;
    NSData *aSummaryData = [NSData dataWithContentsOfFile:[aOptions.mOutputDirectory stringByAppendingPathComponent:@"summary.json"]];
    XCTAssertNotNil(aSummaryData);
    if (aSummaryData == nil) return;
    NSDictionary *aJson = [NSJSONSerialization JSONObjectWithData:aSummaryData options:0 error:&aError];
    XCTAssertNil(aError);
    XCTAssertEqual([aJson[@"completed_runs"] unsignedIntegerValue], 5U);
    XCTAssertEqual([aJson[@"verification_rates"][@"all"][@"predictors"] unsignedIntegerValue], 320U);
    XCTAssertEqual([aJson[@"maximum_deviant"][@"predictor"][@"flag"] unsignedIntegerValue], 3U);
    XCTAssertEqual([aJson[@"maximum_deviant"][@"predictor"][@"polarity"] unsignedIntegerValue], 1U);
    XCTAssertEqualWithAccuracy([aJson[@"maximum_deviant"][@"match_percent"] doubleValue], 30.0, 0.000001);
    XCTAssertEqualWithAccuracy([aJson[@"screen_selected_predictors_on_fresh_data"][@"all"][@"mean_match_percent"] doubleValue], 55.0, 0.000001);
    NSData *aTemplate = [NSData dataWithContentsOfFile:[aOptions.mOutputDirectory stringByAppendingPathComponent:aJson[@"maximum_deviant"][@"template_file"]]];
    XCTAssertEqual(aTemplate.length, kBlockBytes);
    if (aTemplate.length == kBlockBytes)
        XCTAssertEqual(std::memcmp(aTemplate.bytes, aFixture.mScenario.mTemplate.data(), kBlockBytes), 0);
    NSString *aLines = [NSString stringWithContentsOfFile:[aOptions.mOutputDirectory stringByAppendingPathComponent:@"runs.jsonl"]
                                               encoding:NSUTF8StringEncoding error:&aError];
    XCTAssertNil(aError);
    XCTAssertEqual([aLines componentsSeparatedByString:@"\n"].count, 6U);
    for (NSString *aLine in [aLines componentsSeparatedByString:@"\n"]) {
        if (aLine.length == 0U) continue;
        NSDictionary *aRun = [NSJSONSerialization JSONObjectWithData:[aLine dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&aError];
        XCTAssertNil(aError);
        XCTAssertEqual([aRun[@"predictors"] count], 64U);
        XCTAssertEqual([aRun[@"screen_selected_flag"] unsignedIntegerValue], 2U);
    }
    // Operational errors are recorded separately and never add fake 0% results.
    CaptureObservation aFailure;
    aFailure.mError = "synthetic API error";
    auto aErrorRecord = ObservationRecord(aOptions, 6U, 1U, aFixture, aFailure);
    aSummary.Add(aErrorRecord, aFixture, aFailure);
    XCTAssertEqual(aSummary.mAttempts, 6U);
    XCTAssertEqual(aSummary.mCompleted, 5U);
    XCTAssertEqual(aSummary.mErrors, 1U);
    XCTAssertEqual(aSummary.mVerification.mAll.mPredictors, 320U);
}

- (void)testBoundedWeakCapture {
    // Real 1 MiB weak encryption, complete training, deliberately short grading.
    // This verifies wiring and persisted output, not leakage at production sample size.
    CaptureOptions aOptions;
    aOptions.mSeed = 0xF79062DF8A905396ULL;
    aOptions.mRunLimit = 1U;
    aOptions.mScreenSamples = 128U;
    aOptions.mVerificationSamples = 512U;
    aOptions.mOutputDirectory = [[StatisticalOutputRoot() stringByAppendingPathComponent:@"ReportingTests"] stringByAppendingPathComponent:
        [@"SoccerCaptureSmoke-" stringByAppendingString:[NSUUID UUID].UUIDString]];
    RunCapture(aOptions);
    NSData *aData = [NSData dataWithContentsOfFile:[aOptions.mOutputDirectory stringByAppendingPathComponent:@"summary.json"]];
    XCTAssertNotNil(aData);
    if (aData == nil) return;
    NSError *aError = nil;
    NSDictionary *aJson = [NSJSONSerialization JSONObjectWithData:aData options:0 error:&aError];
    XCTAssertNil(aError);
    XCTAssertEqual([aJson[@"completed_runs"] unsignedIntegerValue], 1U);
    XCTAssertEqual([aJson[@"error_runs"] unsignedIntegerValue], 0U);
    XCTAssertEqual([aJson[@"verification_rates"][@"all"][@"measurements"] unsignedIntegerValue], 64U * 512U);
    XCTAssertEqualObjects(aJson[@"strength"], @"weak");
    XCTAssertEqualObjects(aJson[@"cipher_plan"], kCaptureCipherPlan);
    XCTAssertEqual([aJson[@"maximum_deviant"][@"replay_record"][@"template_cipher_sha256"] length], 64U);
    NSData *aProgressData = [NSData dataWithContentsOfFile:[aOptions.mOutputDirectory stringByAppendingPathComponent:@"progress.json"]];
    NSDictionary *aProgress = aProgressData ? [NSJSONSerialization JSONObjectWithData:aProgressData options:0 error:nullptr] : nil;
    XCTAssertEqualObjects(aProgress[@"status"], @"completed");
    XCTAssertEqualObjects(aProgress[@"cipher_plan"], kCaptureCipherPlan);
    XCTAssertEqualObjects(aProgress[@"phase"], @"verification");
    XCTAssertEqualObjects(aProgress[@"blocks_encrypted_in_phase"], @512);
    XCTAssertEqualObjects(aProgress[@"password_hex"], aJson[@"maximum_deviant"][@"replay_record"][@"password_hex"]);
}
@end
