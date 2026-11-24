#include "FlameToadCipher.hpp"
#include <vector>
#include <random>
#include <bit>
#include <cstdio>
int main() {
 std::vector<std::uint8_t> in(4096), out(4096); std::mt19937_64 random(77331);
 unsigned unchanged=0,total=0;
 for(unsigned a=0;a<8;++a) for(unsigned b=0;b<8;++b) if(a!=b) for(unsigned trial=0;trial<16;++trial) {
  for(auto &v:in)v=static_cast<std::uint8_t>(random());
  FlameToadCipher cipher(a,b,1,3,7,11); CipherErrorCode error;
  if(!cipher.SealData(in.data(),nullptr,out.data(),in.size(),&error)) return 1;
  std::uint8_t x=0,y=0; for(unsigned i=0;i<in.size();++i){x^=in[i];y^=out[i];}
  if((x^y)&1U)return 2;
  unchanged+=(std::popcount(x)==std::popcount(y)) || ((std::popcount(x)&1)==(std::popcount(y)&1));
  ++total;
 }
 std::printf("Primitive diagnostic: bit-0 plane parity preserved in %u/%u cases; whole-block parity preserved in %u/%u. Not a full-vault attack.\n",total,total,unchanged,total);
}
