#define main ExistingSweepMain
#include "/Users/icarus/Desktop/Codex Maga/Soccer/Tools/strong_security_sweep.cpp"
#undef main
int main() {
 for (unsigned strength=0;strength<3;++strength) for(unsigned fixture=0;fixture<2;++fixture) {
  if(!SeedFixture(static_cast<EncryptionStrength>(strength),fixture))return 1;
  std::cout << "CONFIGURATION " << "{\"strength\":" << strength << ",\"fixture\":" << fixture << ",\"configuration\":" << Configuration() << "}" << std::endl;
  if(fixture==0) {
   Bytes plain(kBlockBytes),cipher(kBlockBytes),restored(kBlockBytes);std::mt19937_64 rng(0xFA31451ULL);
   std::vector<double> seal,unseal;std::uint64_t checksum=0;
   for(unsigned i=0;i<136;++i) {
    Fill(plain,rng);const auto start=Clock::now();
    if(!Soccer2::EncryptBlock(plain.data(),cipher.data()))return 2;
    const auto middle=Clock::now();
    if(!Soccer2::DecryptBlock(cipher.data(),restored.data()))return 3;
    const auto end=Clock::now();if(restored!=plain)return 4;
    if(i>=8){seal.push_back(std::chrono::duration<double,std::micro>(middle-start).count());unseal.push_back(std::chrono::duration<double,std::micro>(end-middle).count());}
    checksum+=cipher[i];
   }
   std::sort(seal.begin(),seal.end());std::sort(unseal.begin(),unseal.end());
   std::cout << "TIMING {\"strength\":"<<strength<<",\"calls\":128,\"bytes\":"<<kBlockBytes<<",\"encrypt_median_us\":"<<seal[64]<<",\"decrypt_median_us\":"<<unseal[64]<<",\"checksum\":"<<checksum<<"}"<<std::endl;
  }
  Soccer2::Zero();
 }
}
