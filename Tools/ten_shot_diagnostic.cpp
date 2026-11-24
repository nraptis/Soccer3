#if 0 // Historical Cryptex trace; retained for source reference.
// Targeted replay of DiscardableTestTenShot, with full rows and predictors.
// Build: python3 Tools/build_strong_security_sweep.py build-security/diagnostic Tools/ten_shot_diagnostic.cpp
// Run: build-security/diagnostic/ten_shot_diagnostic --selection 4 --fixture 1 --out SecurityResults/replay4
// Selection and fixture numbers are one-based, matching the XCTest output.
#include "../StatisticalTests/StatisticalRecoveryHarness.hpp"
#define SOCCER_ENCRYPTION_STRENGTH_DEFINED
#define SOCCER3_DISABLE_COMPAT_ALIAS
#include "../Scramble/Composer/Soccer3.hpp"
#include "../Scramble/Composer/EncryptionPlan.hpp"
#include "SweepCipherNames.hpp"
#include <chrono>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <memory>
#include <string>

using namespace StatisticalRecovery;
namespace fs = std::filesystem;
using Selection = std::array<std::uint64_t, 3U>;
constexpr std::size_t kCampaignHypotheses = 10U * kHypotheses;
#include "../Dead Code/TenShotTrace.hpp"

Selection SelectionValues(unsigned pSelection) {
    Selection aResult = Soccer3Internal::kDefaultBitPlaneSelectionValues;
    std::mt19937_64 aRandom(0x7E10540B17A5C329ULL);
    for (unsigned i = 1U; i < pSelection; ++i) for (auto &aWord : aResult) aWord = aRandom();
    return aResult;
}

void WriteConfiguration(const fs::path &pOutput, unsigned pSelection, unsigned pFixture) {
    std::ofstream aFile(pOutput / "configuration.txt");
    aFile << "selection=" << pSelection << " fixture=" << pFixture << " strength=normal\nselectors=";
    for (auto aValue : SelectionValues(pSelection)) aFile << " 0x" << std::hex << aValue;
    aFile << std::dec << "\nplan_selector=" << Soccer3Internal::mPlanSelectionValue << '\n';
    const auto aPlan = EncryptionPlanTool::MakePlanNormal(Soccer3Internal::mPlanSelectionValue,
        Soccer3Internal::mCiphersMutate, Soccer3Internal::mCiphersPrimaryMovers, Soccer3Internal::mCiphersSecondaryMovers);
    const EncryptionPlanStage *aStages[] = {&aPlan.mL3A,&aPlan.mL2A,&aPlan.mL1A,&aPlan.mL3B,&aPlan.mL2B,&aPlan.mL1B,&aPlan.mL3C,&aPlan.mL2C,&aPlan.mL1C};
    const char *aNames[] = {"L3A","L2A","L1A","L3B","L2B","L1B","L3C","L2C","L1C"};
    aFile << "Rows below are actual execution rows; row 0 is the least significant bit.\n";
    for (unsigned aStage = 0U; aStage < 9U; ++aStage) {
        aFile << aNames[aStage];
        for (unsigned aGroup = 0U; aGroup < 3U; ++aGroup) {
            const auto &aInput = Soccer3Internal::mBitPlaneInputs[aStage][0][aGroup];
            aFile << " | frog" << aGroup << " rows=";
            for (unsigned i=0;i<aInput.mCount;++i) aFile << (i ? "," : "") << unsigned(aInput.mRows[i]);
            aFile << " windows=";
            for (unsigned i=0;i<aInput.mCount;++i) aFile << (i ? "," : "") << aInput.mRotations[i];
        }
        aFile << " | rotate_mask=" << unsigned(Soccer3Internal::GetBitPlaneMask(aStage,CipherSamplingBank::kBitPlaneFirstA))
              << " rotate_bytes=" << Soccer3Internal::GetByteRotationForStage(aStage) << '\n';
        for (unsigned i=0;i<aStages[aStage]->mCount;++i) aFile << ' ' << SweepCipherName(aStages[aStage]->mType[i]);
        aFile << '\n';
    }
    aFile << "Base grid (before within-group rotation):\n";
    for (unsigned aLevel=0;aLevel<3;++aLevel) {
        for (unsigned aGroup=0;aGroup<3;++aGroup) {
            aFile << " [";
            const auto aMask=Soccer3Internal::mBitPlanes[aLevel][0][aGroup];
            for(unsigned aRow=0;aRow<8;++aRow)if(aMask&(1U<<aRow))aFile << aRow;
            aFile << ']';
        }
        aFile << '\n';
    }
}

bool Install() {
    Soccer3Internal::mCryptex9.Free();
    Soccer3Internal::mMaskCursor=Soccer3Internal::mMaterialIndex=Soccer3Internal::mMaterialQuarter=0;
    return Soccer3Internal::SeedEpilogue_Regular_D();
}

int main(int argc, char **argv) try {
    // Historical nine-layer diagnostic: keep reproducing the original attack.
    Soccer3Internal::mUseLegacyCryptex = true;
    unsigned aSelection=4U,aFixture=1U,aReplacement=1U;
    int aReplaceLevel=-1,aReplaceStage=-1;
    fs::path aTraceModel;
    fs::path aOutput="SecurityResults/ten-shot-diagnostic";
    bool aConfigurationOnly=false;
    for(int i=1;i<argc;++i) {
        const std::string aArgument=argv[i];
        if(aArgument=="--configuration-only"){aConfigurationOnly=true;continue;}
        if(i+1==argc)throw std::runtime_error("missing argument");
        const std::string aValue=argv[++i];
        if(aArgument=="--selection")aSelection=std::stoul(aValue);
        else if(aArgument=="--fixture")aFixture=std::stoul(aValue);
        else if(aArgument=="--out")aOutput=aValue;
        else if(aArgument=="--replace-level")aReplaceLevel=std::stoi(aValue);
        else if(aArgument=="--rows-from")aReplacement=std::stoul(aValue);
        else if(aArgument=="--replace-stage")aReplaceStage=std::stoi(aValue);
        else if(aArgument=="--trace-model")aTraceModel=aValue;
        else throw std::runtime_error("unknown argument: "+aArgument);
    }
    if(aSelection<1U||aSelection>10U||aFixture<1U||aFixture>2U||aReplacement<1U||aReplacement>10U||aReplaceLevel< -1||aReplaceLevel>2||aReplaceStage< -1||aReplaceStage>8||(aReplaceStage>=0&&aReplaceLevel>=0))
        throw std::runtime_error("invalid selection, fixture or level");
    fs::create_directories(aOutput);
    const auto aStart=std::chrono::steady_clock::now();
    const auto aSaved=Soccer3Internal::mBitPlaneSelectionValues;
    struct Restore { Selection mValues; ~Restore(){Soccer3::Zero();Soccer3Internal::mBitPlaneSelectionValues=mValues;} } aRestore{aSaved};
    Soccer3Internal::mBitPlaneSelectionValues=SelectionValues(aSelection);
    if(!SeedFixture(EncryptionStrength::kNormal,aFixture-1U))throw std::runtime_error("seed failure");
    if(aReplaceLevel>=0) {
        const auto aValues=SelectionValues(aReplacement);
        const auto aOther=BitPlaneFarm::Select(aValues[0],aValues[1],aValues[2]);
        Soccer3Internal::mBitPlanes[aReplaceLevel]=aOther[aReplaceLevel];
        Soccer3Internal::AssignRotationWindows();
        if(!Install())throw std::runtime_error("modified plan installation failed");
        std::ofstream(aOutput/"intervention.txt") << "Only level " << aReplaceLevel << " rows replaced from selection " << aReplacement
            << "; window values and materials unchanged. Cross-level partition may be broken.\n";
    }
    if(aReplaceStage>=0) {
        const auto aValues=SelectionValues(aReplacement);
        const auto aOther=BitPlaneFarm::Select(aValues[0],aValues[1],aValues[2]);
        const unsigned aLevel=aReplaceStage%3U;
        for(unsigned aGroup=0;aGroup<3;++aGroup) {
            auto &aInput=Soccer3Internal::mBitPlaneInputs[aReplaceStage][0][aGroup];
            unsigned aIndex=0U;
            for(unsigned aRow=0;aRow<8;++aRow)if(aOther[aLevel][0][aGroup]&(1U<<aRow))
                aInput.mRows[aIndex++]=(aRow+3U*aLevel)%8U;
        }
        if(!Install())throw std::runtime_error("modified stage installation failed");
        std::ofstream(aOutput/"intervention.txt") << "Only stage " << aReplaceStage << " rows replaced from selection " << aReplacement
            << "; window values and materials unchanged. Cross-level partition may be broken.\n";
    }
    WriteConfiguration(aOutput,aSelection,aFixture);
    if(aConfigurationOnly)return 0;
    const auto aScenario=MakeScenario(kBlockBytes);
    if(!aTraceModel.empty()){TraceFrozenModel(aOutput,aTraceModel,aScenario);return 0;}
    const Oracle aOracle=[](const Bytes &pInput,Bytes &pOutput) {
        Bytes aSource=pInput;pOutput.resize(kBlockBytes);
        return Soccer3::EncryptBlock(aSource.data(),pOutput.data());
    };
    Bytes aCiphertext,aRecovered(kBlockBytes);
    if(!aOracle(aScenario.mTemplate,aCiphertext)||!Soccer3::DecryptBlock(aCiphertext.data(),aRecovered.data())||aRecovered!=aScenario.mTemplate)
        throw std::runtime_error("round trip failed");
    Model aModel;
    if(!Train(aOracle,aScenario,aModel,false)||aModel.mQueries!=1U+kFlags+kTrain+kValidate)throw std::runtime_error("training failure");
    std::ofstream aModelFile(aOutput/"model.txt");
    for(const auto &aCandidate:aModel.mPredictions)
        aModelFile << aCandidate.mFeature.mA << ' ' << aCandidate.mFeature.mB << ' ' << aCandidate.mPolarity << ' ' << aCandidate.mTrainingCorrect << '\n';
    aModelFile.close();
    Result aChallenge,aConfirmation;
    if(!Challenge(aOracle,aScenario,aModel,kChallenge,0xFA481C1B83D24E99ULL,aChallenge,kCampaignHypotheses,false))throw std::runtime_error("challenge failure");
    PrintResult("challenge",EncryptionStrength::kNormal,aFixture-1U,aScenario,aModel,aChallenge,kCampaignHypotheses);
    if(aChallenge.mSignificant && !Challenge(aOracle,aScenario,aModel,kConfirm,0x90B67FD8A3C1254EULL,aConfirmation,kCampaignHypotheses,false))
        throw std::runtime_error("confirmation failure");
    if(aConfirmation.mQueries)PrintResult("confirmation",EncryptionStrength::kNormal,aFixture-1U,aScenario,aModel,aConfirmation,kCampaignHypotheses);
    std::ofstream aFile(aOutput/"predictors.csv");
    aFile << "flag,plaintext_byte,plaintext_row,cipher_bit_a,cipher_bit_b,polarity,training_correct,challenge_correct,challenge_n,confirmation_correct,confirmation_n,significant,confirmed,shuffled_correct\n";
    for(unsigned i=0;i<kFlags;++i) {
        const auto &aCandidate=aModel.mPredictions[i];
        aFile << i << ',' << aScenario.mBits[i]/8U << ',' << aScenario.mBits[i]%8U << ','
              << aCandidate.mFeature.mA << ',' << aCandidate.mFeature.mB << ',' << aCandidate.mPolarity << ','
              << aCandidate.mTrainingCorrect << ',' << aChallenge.mCorrect[i] << ',' << aChallenge.mQueries << ','
              << aConfirmation.mCorrect[i] << ',' << aConfirmation.mQueries << ','
              << ((aChallenge.mSignificant>>i)&1U) << ',' << (((aChallenge.mSignificant&aConfirmation.mSignificant)>>i)&1U) << ','
              << aChallenge.mShuffledCorrect[i] << '\n';
    }
    const auto aElapsed=std::chrono::duration<double>(std::chrono::steady_clock::now()-aStart).count();
    std::cout << "COMPLETE selection=" << aSelection << " fixture=" << aFixture << " seconds=" << aElapsed << '\n';
    return 0; // Findings are data; a nonzero exit denotes an incomplete/error run.
} catch(const std::exception &pError) { std::cerr << pError.what() << '\n';return 1; }

#endif
#include <cstdio>
int main() { std::fputs("Retired Cryptex diagnostic. Use the FlameToad sweep or DiscardableTestTenShot.\n", stderr); return 2; }
