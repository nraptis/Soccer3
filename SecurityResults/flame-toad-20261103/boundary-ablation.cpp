#define main ExistingSweepMain
#include "/Users/icarus/Desktop/Codex Maga/Soccer/Tools/strong_security_sweep.cpp"
#undef main
#include "BitRotationThreeCipher.hpp"
class UndoBoundary final: public Cipher {
 BitRotationThreeCipher mRotation;
 public: UndoBoundary():Cipher(CipherType::kBitRotationThreeCipher){}
 bool SealData(const std::uint8_t *s,std::uint8_t *w,std::uint8_t *d,std::size_t n,CipherErrorCode *e)const override{return mRotation.UnsealData(s,w,d,n,e);}
 bool UnsealData(const std::uint8_t *s,std::uint8_t *w,std::uint8_t *d,std::size_t n,CipherErrorCode *e)const override{return mRotation.SealData(s,w,d,n,e);}
 void Zero()override{mRotation.Zero();}
};
unsigned PlaneZero(const Bytes &b){std::uint8_t x=0;for(auto v:b)x^=v;return x&1U;}
int main(){
 if(!SeedFixture(EncryptionStrength::kStrong,0))return 1;
 Soccer2Internal::mEncryptionVault.mRoundA.AddCipherLayerD(new UndoBoundary{});
 Bytes plain(kBlockBytes,0),cipher(kBlockBytes),restored(kBlockBytes);std::mt19937_64 random(0xFA00123ULL);
 if(!Soccer2::EncryptBlock(plain.data(),cipher.data()))return 2;
 const auto offset=PlaneZero(cipher);unsigned correct=0;
 for(unsigned i=0;i<256;++i){Fill(plain,random);if(!Soccer2::EncryptBlock(plain.data(),cipher.data()))return 3;
  correct+=(PlaneZero(cipher)^offset)==PlaneZero(plain);
 }
 if(!Soccer2::DecryptBlock(cipher.data(),restored.data()) || restored!=plain)return 4;
 std::printf("CONTROL ABLATION: strong fixture 0, cancel only the boundary bit rotation; bit-0 plane parity recovered %u/256, roundtrip valid. Production plan unchanged.\n",correct);
 Soccer2::Zero();return correct==256?0:5;
}
