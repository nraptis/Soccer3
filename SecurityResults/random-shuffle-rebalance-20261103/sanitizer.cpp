#include "WindowRotationFarm.hpp"
#include "RandomShuffleLayout.hpp"
#include "TwistShuffle.hpp"
#include <algorithm>
#include <cstdio>
#include <cstring>
#include <memory>
#include <random>
using namespace WindowRotationFarm;
struct Inputs {
    std::uint16_t mBase[kJobCount][kWindowCount];
    std::uint8_t mRandom[RandomShuffleLayout::kRandomBytes];
    std::uint8_t mOffsets[2][64];
    PreparedSource mSources[kJobCount];
};
int main() {
    auto aInput = std::make_unique<Inputs>();
    std::mt19937_64 aRandom(0xA17E4B8DULL);
    Buffers aBuffers{};
    Statistics aStatistics[kJobCount]{};
    std::size_t aMinimumAvailable=16384, aMaximumScanned=0;
    for (unsigned aTrial=0; aTrial<128; ++aTrial) {
        for (std::size_t aJob=0; aJob<kJobCount; ++aJob) {
            for (std::size_t i=0; i<kWindowCount; ++i) aInput->mBase[aJob][i]=static_cast<std::uint16_t>(i);
            aInput->mSources[aJob]={aInput->mBase[aJob],0,false,{nullptr,0},0};
        }
        for (std::size_t aGeneration=0; aGeneration<RandomShuffleLayout::kGenerationCount; ++aGeneration) {
            for (auto &aByte : aInput->mRandom) aByte=static_cast<std::uint8_t>(aRandom());
            for (std::size_t aJob=0; aJob<kJobCount; ++aJob) {
                auto &aSource=aInput->mSources[aJob];
                std::size_t aRead=0;
                aSource.mBackwards=(aGeneration&1U)!=0;
                if (TwistShuffle::ShuffleList16384(aInput->mBase[aJob],
                    aInput->mRandom+RandomShuffleLayout::RotationListBegin(aGeneration,aJob),
                    RandomShuffleLayout::RotationBytesPerList(aGeneration),aRead,
                    aSource.mBackwards,&aSource.mAvailable)) return 1;
                aSource.mShuffleBytesRead+=aRead;
            }
        }
        for (std::size_t p=0;p<2;++p) {
            for(auto &aByte:aInput->mOffsets[p]) aByte=static_cast<std::uint8_t>(aRandom());
            aInput->mSources[p*9].mOffsets={aInput->mOffsets[p],64};
        }
        WindowRotationPack aPack{};
        if (!FarmPreparedPack(aInput->mSources,aBuffers,aPack,aStatistics)||!IsValid(aPack)) return 2;
        for (std::size_t aJob=0;aJob<kJobCount;++aJob) {
            if(aStatistics[aJob].mShuffleBytesRead!=32768) return 3;
            aMinimumAvailable=std::min(aMinimumAvailable,aInput->mSources[aJob].mAvailable);
            aMaximumScanned=std::max(aMaximumScanned,aStatistics[aJob].mBaseReadCount);
        }
        // Every job must respect its supplied candidate bound; no fallback.
        auto aSource=aInput->mSources[aTrial%kJobCount];
        aInput->mSources[aTrial%kJobCount].mAvailable=0;
        if(FarmPreparedPack(aInput->mSources,aBuffers,aPack,aStatistics)) return 4;
        const WindowRotationPack aEmpty{};
        if(std::memcmp(&aPack,&aEmpty,sizeof(aPack))!=0) return 5;
        aInput->mSources[aTrial%kJobCount]=aSource;
    }
    std::printf("PASS: 128 prepared packs / 2304 jobs, exact 589824-byte budgets, ASan/UBSan.\nMinimum final available prefix=%zu; maximum candidates scanned=%zu.\n",aMinimumAvailable,aMaximumScanned);
}
