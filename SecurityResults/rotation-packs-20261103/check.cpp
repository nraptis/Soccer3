#include "RotationSelection.hpp"
#include <random>
#include <cstdio>
#include <cstring>
#include <memory>
int main() {
    using namespace RotationSelection;
    auto packs=std::make_unique<RotationPack[]>(8);
    std::uint8_t entropy[65536];bool blocked[16384];
    std::uint16_t samples[128];std::int32_t bytes[16];
    std::size_t maxRead=0,maxEntropy=0,totalRead=0;
    for(unsigned seed=0;seed<1000;++seed){
        std::mt19937_64 rng(seed);std::memset(blocked,0,sizeof(blocked));
        for(unsigned p=0;p<8;++p){
            for(unsigned i=0;i<65536;i+=8){auto w=rng();for(unsigned b=0;b<8;++b)entropy[i+b]=w>>(8*b);}
            auto &pack=packs[p];
            if(!pack.Shuffle(entropy,sizeof(entropy))||!pack.Farm(blocked,entropy,sizeof(entropy))||!pack.IsPermutation())return 1;
            for(unsigned f=0;f<4;++f)for(unsigned r=0;r<4;++r)samples[p*16+f*4+r]=pack.mRotationWindow[f][r];
            for(unsigned r=0;r<2;++r)bytes[p*2+r]=pack.mRotationsFree[r];
            maxRead=std::max(maxRead,pack.mReadCount);maxEntropy=std::max(maxEntropy,pack.mEntropyBytesRead);totalRead+=pack.mReadCount;
        }
        if(!IsValid(samples,128,bytes,16))return 2;
    }
    std::printf("PASS: 1000 eight-pack plans, all 144 values, independent local/global validation. Maximum pack reads=%zu; maximum entropy bytes=%zu/65536; mean reads/pack=%.3f\n",maxRead,maxEntropy,totalRead/8000.0);
}
