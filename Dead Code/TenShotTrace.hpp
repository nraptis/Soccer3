#pragma once
#include <map>
// Victim-side diagnostic only. Not part of the attack or the production cipher.
// The caller supplies a frozen model, and this traces its main byte/bit paths.

struct TraceOperation {
    unsigned mStage, mPosition;
    CipherType mType;
    std::unique_ptr<Cipher> mCipher;
};

void TraceFrozenModel(const fs::path &pOutput, const fs::path &pModelFile, const Scenario &pScenario) {
    Model aModel;aModel.mReady=true;aModel.mBytes=kBlockBytes;
    std::ifstream aInput(pModelFile);
    for(auto &aCandidate:aModel.mPredictions)
        if(!(aInput>>aCandidate.mFeature.mA>>aCandidate.mFeature.mB>>aCandidate.mPolarity>>aCandidate.mTrainingCorrect))
            throw std::runtime_error("invalid frozen model");
    for(const auto &aCandidate:aModel.mPredictions)
        if(aCandidate.mFeature.mA>=kBlockBytes*8U ||
           (aCandidate.mFeature.mB!=kNoBit && aCandidate.mFeature.mB>=kBlockBytes*8U) || aCandidate.mPolarity>1U)
            throw std::runtime_error("out-of-range frozen predictor");
    const auto aPlan=EncryptionPlanTool::MakePlanNormal(Soccer3Internal::mPlanSelectionValue,
        Soccer3Internal::mCiphersMutate,Soccer3Internal::mCiphersPrimaryMovers,Soccer3Internal::mCiphersSecondaryMovers);
    const EncryptionPlanStage *aStages[]={&aPlan.mL3A,&aPlan.mL2A,&aPlan.mL1A,&aPlan.mL3B,&aPlan.mL2B,&aPlan.mL1B,&aPlan.mL3C,&aPlan.mL2C,&aPlan.mL1C};
    std::array<std::vector<TraceOperation>,9U> aByStage;
    Soccer3Internal::mMaskCursor=Soccer3Internal::mMaterialIndex=Soccer3Internal::mMaterialQuarter=0U;
    for(unsigned aLevel=0;aLevel<3;++aLevel)for(unsigned aGroup=0;aGroup<3;++aGroup) {
        const auto aStage=aGroup*3U+aLevel;const auto &aLayer=*aStages[aStage];
        for(unsigned i=0;i<aLayer.mCount;++i) {
            std::unique_ptr<Cipher> aCipher(Soccer3Internal::GenerateCipher(aLayer.mType[i],aStage,aLayer.mSamplingBank[i],aLayer.mRotationIndex[i]));
            if(!aCipher)throw std::runtime_error("trace factory failure");
            aByStage[aStage].push_back({aStage,i,aLayer.mType[i],std::move(aCipher)});
        }
    }
    std::vector<TraceOperation> aOperations;
    for(auto &aStage:aByStage)for(auto &aOperation:aStage)aOperations.push_back(std::move(aOperation));
    std::vector<std::array<Feature,kFlags>> aFeatures(aOperations.size()+1U);
    for(unsigned i=0;i<kFlags;++i)aFeatures.back()[i]=aModel.mPredictions[i].mFeature;
    for(std::size_t i=aOperations.size();i>0;--i) {
        const auto &aOperation=aOperations[i-1U];aFeatures[i-1U]=aFeatures[i];
        const auto aLength=kBlockBytes>>(aOperation.mStage%3U);
        auto aBack=[&](std::uint32_t pBit) {
            if(pBit==kNoBit)return pBit;
            auto aByte=pBit/8U;auto aRow=pBit%8U;
            if(aOperation.mType==CipherType::kBitRotationThreeCipher)aRow=(aRow+5U)%8U;
            if(aOperation.mType==CipherType::kShiftMaskedCipher) {
                const auto aMask=Soccer3Internal::GetBitPlaneMask(aOperation.mStage,CipherSamplingBank::kBitPlaneFirstA);
                if(aMask&(1U<<aRow))aByte=aByte/aLength*aLength+(aByte%aLength+aLength-Soccer3Internal::GetByteRotationForStage(aOperation.mStage))%aLength;
            }
            return static_cast<std::uint32_t>(aByte*8U+aRow);
        };
        for(auto &aFeature:aFeatures[i-1U]) {aFeature.mA=aBack(aFeature.mA);aFeature.mB=aBack(aFeature.mB);}
    }
    constexpr unsigned kSamples=8192U;
    std::vector<std::array<unsigned,kFlags>> aCorrect(aFeatures.size()),aChanges(aOperations.size());
    std::array<unsigned,kFlags> aDifferencePreserved{};
    std::map<std::array<unsigned,4U>,unsigned> aProbeCounts;
    std::mt19937_64 aRandom(0xC346F40A77B09E21ULL);
    Bytes aCurrent,aNext(kBlockBytes),aWorker(kBlockBytes),aReference(kBlockBytes);
    for(unsigned aSample=0;aSample<kSamples;++aSample) {
        const auto aSecret=aRandom();aCurrent=WithFlags(pScenario,aSecret);
        if(aSample==0 && !Soccer3::EncryptBlock(aCurrent.data(),aReference.data()))throw std::runtime_error("reference encryption failure");
        std::array<unsigned,kFlags> aPrevious{},aDifference{};
        for(unsigned f=0;f<kFlags;++f) {
            aPrevious[f]=Evaluate(aFeatures[0][f],aCurrent);
            aCorrect[0][f]+=(aPrevious[f]==((aSecret>>f)&1U));
        }
        for(unsigned i=0;i<aOperations.size();++i) {
            const auto &aOperation=aOperations[i];const auto aLength=kBlockBytes>>(aOperation.mStage%3U);
            // Inspect the third Frog in L1A for the reported best flag (63).
            const bool aProbe=aOperation.mStage==2U && aOperation.mPosition==2U;
            const auto aProbeFeature=aFeatures[i][63U];
            const auto aProbeMask=Soccer3Internal::GetBitPlaneMask(2U,CipherSamplingBank::kBitPlaneFirstC);
            auto aCompress=[&](unsigned pValue) {
                unsigned aResult=0U,aPosition=0U;
                for(unsigned aBit=0U;aBit<8U;++aBit)if(!(aProbeMask&(1U<<aBit)))
                    aResult|=((pValue>>aBit)&1U)<<aPosition++;
                return aResult;
            };
            const unsigned aProbeFirst=aProbe?aCompress(aCurrent[aProbeFeature.mA/8U]):0U;
            const unsigned aProbeSecond=aProbe&&aProbeFeature.mB!=kNoBit?aCompress(aCurrent[aProbeFeature.mB/8U]):0U;
            if(aOperation.mStage==8U && aOperation.mPosition==0U)
                for(unsigned f=0;f<kFlags;++f) {
                    const auto &aFeature=aFeatures[i][f];
                    if(aFeature.mB!=kNoBit)aDifference[f]=(aCurrent[aFeature.mA/8U]-aCurrent[aFeature.mB/8U])&3U;
                }
            for(unsigned aOffset=0;aOffset<kBlockBytes;aOffset+=aLength)
                if(!aOperation.mCipher->SealData(aCurrent.data()+aOffset,aWorker.data()+aOffset,aNext.data()+aOffset,aLength,nullptr))
                    throw std::runtime_error("trace execution failure");
            aCurrent.swap(aNext);
            if(aProbe && aProbeFeature.mB!=kNoBit) {
                const unsigned aModulusMask=(1U<<(8U-__builtin_popcount(aProbeMask)))-1U;
                const unsigned aKey=(aCompress(aCurrent[aProbeFeature.mA/8U])-aProbeFirst)&aModulusMask;
                ++aProbeCounts[{static_cast<unsigned>((aSecret>>63U)&1U),aProbeFirst,aProbeSecond,aKey}];
            }
            if(aOperation.mStage==8U && aOperation.mPosition==2U)
                for(unsigned f=0;f<kFlags;++f) {
                    const auto &aFeature=aFeatures[i+1U][f];
                    if(aFeature.mB!=kNoBit)aDifferencePreserved[f]+=aDifference[f]==((aCurrent[aFeature.mA/8U]-aCurrent[aFeature.mB/8U])&3U);
                }
            for(unsigned f=0;f<kFlags;++f) {
                const auto aValue=Evaluate(aFeatures[i+1U][f],aCurrent);
                aCorrect[i+1U][f]+=aValue==((aSecret>>f)&1U);
                aChanges[i][f]+=aValue!=aPrevious[f];aPrevious[f]=aValue;
            }
        }
        if(aSample==0 && aCurrent!=aReference)throw std::runtime_error("trace differs from full production API");
    }
    std::ofstream aFile(pOutput/"trace.csv");
    aFile<<"step,stage,cipher,flag,byte_a,row_a,byte_b,row_b,correct,n,changed\n";
    for(unsigned i=0;i<aFeatures.size();++i)for(unsigned f=0;f<kFlags;++f) {
        const auto &aFeature=aFeatures[i][f];
        aFile<<i<<','<<(i?static_cast<int>(aOperations[i-1U].mStage):-1)<<','<<(i?SweepCipherName(aOperations[i-1U].mType):"input")<<','<<f<<','
             <<aFeature.mA/8U<<','<<aFeature.mA%8U<<','<<aFeature.mB/8U<<','<<aFeature.mB%8U<<','<<aCorrect[i][f]<<','<<kSamples<<','<<(i?aChanges[i-1U][f]:0U)<<'\n';
    }
    std::ofstream aDifferenceFile(pOutput/"low_two_bit_difference.csv");
    aDifferenceFile<<"flag,preserved,n\n";
    for(unsigned f=0;f<kFlags;++f)aDifferenceFile<<f<<','<<aDifferencePreserved[f]<<','<<kSamples<<'\n';
    std::ofstream aProbeFile(pOutput/"l1a_flag63_addition.csv");
    aProbeFile<<"secret_flag,first_writable_value,second_writable_value,added_writable_key,count\n";
    for(const auto &[aValues,aCount]:aProbeCounts)aProbeFile<<aValues[0]<<','<<aValues[1]<<','<<aValues[2]<<','<<aValues[3]<<','<<aCount<<'\n';
    std::cout<<"TRACE_COMPLETE samples="<<kSamples<<" production_equivalence=PASS\n";
}
