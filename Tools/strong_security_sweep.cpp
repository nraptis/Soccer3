// Standalone, resumable chosen-plaintext experiment. Synthetic fixtures only.
#include "../StatisticalTests/StatisticalRecoveryHarness.hpp"
#define SOCCER_ENCRYPTION_STRENGTH_DEFINED
#define SOCCER3_DISABLE_COMPAT_ALIAS
#include "../Scramble/Composer/Soccer3.hpp"
#include "../ScrambleTests/CryptexTestSupport.hpp"
#include <chrono>
#include <csignal>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <set>
#include <sstream>
#include <string>
#ifndef SOCCER_SWEEP_BUILD
#define SOCCER_SWEEP_BUILD "unidentified"
#endif
using namespace StatisticalRecovery;
namespace fs=std::filesystem;
using Clock=std::chrono::steady_clock;
volatile std::sig_atomic_t stopped=0;
void Stop(int) {stopped=1;}
struct Options {
    fs::path out="strong-sweep";
    unsigned fixtures=64;
    std::size_t challenge=32768,confirm=16384;
    double hours=8;
    std::uint64_t master=0x63D28A1EF450B917ULL;
    bool selfTest=false;
};
std::string Quote(const std::string &s) {
    std::string r="\"";for(char c:s) {if(c=='\\'||c=='\"')r+='\\';if(c=='\n')r+="\\n";else r+=c;}return r+'\"';
}
template<class T> void Array(std::ostream &o,const T &v) {
    o<<'[';bool first=true;for(auto n:v){if(!first)o<<',';first=false;o<<+n;}o<<']';
}
std::string Id(unsigned f) {return std::to_string(f);}
bool Install() { return Soccer3Internal::SeedEpilogue_Regular_D(); }
std::string Configuration() {
    {
        const auto &aCryptex = Soccer3Internal::mCryptex;
        const auto aRows = CryptexTestSupport::Rows();
        const auto aMasks = CryptexTestSupport::Masks();
        const auto aRotations = CryptexTestSupport::Rotations();
        const auto aSamples = CryptexTestSupport::SamplingRotations();

        std::ostringstream aOutput;
        aOutput << "{\"construction\":\"flame-toad-vault\",\"bit_plane_selection\":";
        const std::uint64_t aWords[] = {Soccer3Internal::mBitPlaneWordA, Soccer3Internal::mBitPlaneWordB, Soccer3Internal::mBitPlaneWordC};
        Array(aOutput, aWords);
        aOutput << ",\"bit_plane_policy\":\"seeded-word-sums-v1\""
                << ",\"rotation_policy\":\"flat-window-lists-forward-units-v4\""
                << ",\"rotation_farm_jobs\":18,\"rotation_candidates_read\":" << Soccer3Internal::mRotationCandidatesRead
                << ",\"rotation_shuffle_bytes\":" << Soccer3Internal::mRotationShuffleBytesRead
                << ",\"material_count\":" << aCryptex.GetMaterialCount()
                << ",\"bit_reverse_after_layer\":3,\"layers\":[";
        for (std::size_t aIndex = 0U; aIndex < Cryptex::kLayerCount; ++aIndex) {
            if (aIndex) aOutput << ',';
            aOutput << "{\"index\":" << aIndex << ",\"rows\":[";
            for (std::size_t aPair = 0U; aPair < 4U; ++aPair) {
                if (aPair) aOutput << ',';
                const auto &aPairRows = aRows[aIndex % 4U].mPairs[aPair];
                const std::uint8_t aBits[] = {aPairRows.mBitA, aPairRows.mBitB};
                Array(aOutput, aBits);
            }
            aOutput << "],\"masks\":"; Array(aOutput, std::array{aMasks[2U*aIndex], aMasks[2U*aIndex+1U]});
            aOutput << ",\"rotations\":"; Array(aOutput, std::array{aRotations[2U*aIndex], aRotations[2U*aIndex+1U]});
            aOutput << ",\"sampling_rotations\":[";
            for (std::size_t j = 0U; j < 4U; ++j) { if (j) aOutput << ','; Array(aOutput, std::array{aSamples[16U*aIndex+4U*j], aSamples[16U*aIndex+4U*j+1U], aSamples[16U*aIndex+4U*j+2U], aSamples[16U*aIndex+4U*j+3U]}); }
            aOutput << ']';
            aOutput << ",\"xor_before_rotations\":" << (2U*aIndex)
                    << ",\"xor_after_rotations\":" << (2U*aIndex+1U) << '}';
        }
        aOutput << "]}";
        return aOutput.str();
    }
}

bool Seed(unsigned fixture,std::uint64_t master) {
    if(fixture<2)return SeedFixture(EncryptionStrength::kStrong,fixture);
    std::mt19937_64 random(master^(0x9E3779B97F4A7C15ULL*(fixture+1ULL)));
    std::array<std::uint8_t,32> password{};for(auto& b:password)b=static_cast<std::uint8_t>(random());
    const auto nonce=random();std::uint32_t ack=0;Soccer3::Zero();
    return Soccer3::AttemptSeed_Encrypt(EncryptionStrength::kStrong,password.data(),password.size(),nonce,&ack,0,nullptr);
}
Scenario ScenarioFor(unsigned fixture,std::uint64_t master) {
    auto s=MakeScenario(kBlockBytes);if(fixture<2)return s;
    std::mt19937_64 random(master^(0xD1B54A32D192ED03ULL*(fixture+1ULL)));Fill(s.mTemplate,random);
    const unsigned mode=fixture%3U;
    const auto cluster=(random()%(kBlockBytes-4096U))&~std::size_t{63};
    std::set<std::uint32_t> used;
    for(unsigned i=0;i<64;++i) {
        std::uint32_t bit=0;
        do {
            std::size_t byte;
            if(i<32)byte=mode==0?cluster+i:mode==1?cluster+i*8U:cluster+i*64U;
            else byte=(i-32U)*(kBlockBytes/32U)+random()%(kBlockBytes/32U);
            bit=static_cast<std::uint32_t>(byte*8U+i%8U);
        }while(!used.insert(bit).second);
        s.mBits[i]=bit;s.mTemplate[bit/8U]&=static_cast<std::uint8_t>(~(1U<<(bit%8U)));
    }
    return s;
}
void ResultJson(std::ostream& o,const Result& r) {
    const auto best=*std::max_element(r.mCorrect.begin(),r.mCorrect.end());
    o<<"{\"queries\":"<<r.mQueries<<",\"best_correct\":"<<best<<",\"best_accuracy\":"<<std::setprecision(12)<<double(best)/r.mQueries
     <<",\"significant\":"<<r.mSignificant<<",\"shuffled_significant\":"<<r.mShuffledSignificant<<",\"exact_plaintexts\":"<<r.mExactPlaintexts<<",\"correct\":";
    Array(o,r.mCorrect);o<<'}';
}
bool SelfTest() {
    if(!Seed(0,0))return false;
    auto plain=MakeScenario(kBlockBytes).mTemplate;Bytes first(kBlockBytes),again(kBlockBytes),encrypted(kBlockBytes),restored(kBlockBytes);
    if(!Soccer3::EncryptBlock(plain.data(),first.data()))return false;
    if(!Install() || !Soccer3::EncryptBlock(plain.data(),encrypted.data()) || !Soccer3::DecryptBlock(encrypted.data(),restored.data()))return false;
    if(restored!=plain || encrypted!=first)return false;
    if(!Soccer3::EncryptBlock(plain.data(),again.data()) || again!=encrypted)return false;
    std::cout<<"SELF_TEST "<<Configuration()<<'\n';
    Soccer3::Zero();return true;
}
int main(int argc,char** argv) try {
    Options opt;
    for(int i=1;i<argc;++i) {
        const std::string arg=argv[i];if(arg=="--self-test"){opt.selfTest=true;continue;}
        if(i+1==argc)throw std::runtime_error("missing argument value");const std::string value=argv[++i];
        if(arg=="--out")opt.out=value;else if(arg=="--fixtures")opt.fixtures=std::stoul(value);
        else if(arg=="--hours")opt.hours=std::stod(value);else if(arg=="--challenge")opt.challenge=std::stoull(value);
        else if(arg=="--confirm")opt.confirm=std::stoull(value);else if(arg=="--master-seed")opt.master=std::stoull(value,nullptr,0);
        else throw std::runtime_error("unknown argument: "+arg);
    }
    if(opt.selfTest)return SelfTest()?0:1;
    if(!opt.fixtures || opt.fixtures>100000 || !(opt.hours>0 && opt.hours<=168) || opt.challenge<64 || opt.confirm<64)throw std::runtime_error("invalid run limits");
    fs::create_directories(opt.out);
    std::ostringstream config;config<<"protocol=3\nbuild="<<SOCCER_SWEEP_BUILD<<"\nfixtures="<<opt.fixtures<<"\nmaster="<<opt.master
        <<"\ntrain="<<kTrain<<"\nvalidate="<<kValidate<<"\nchallenge="<<opt.challenge<<"\nconfirm="<<opt.confirm<<"\n";
    const auto configPath=opt.out/"run_config.txt";
    if(fs::exists(configPath)) {
        std::ifstream in(configPath);const std::string previous((std::istreambuf_iterator<char>(in)),{});
        if(previous!=config.str())throw std::runtime_error("resume configuration/build differs; choose a new output directory");
    }else{std::ofstream out(configPath);out<<config.str();}
    bool leaked=false;
    std::set<std::string> completed;std::ifstream prior(opt.out/"results.jsonl");std::string line;
    while(std::getline(prior,line)) {
        if(line.size()<2 || line.substr(line.size()-2)!="}}")continue;
        const std::string tag="\"trial_id\":\"";auto start=line.find(tag);
        if(start!=std::string::npos && line.find("\"status\":\"complete\"")!=std::string::npos) {
            start+=tag.size();completed.insert(line.substr(start,line.find('"',start)-start));
            const auto challengeStart=line.find("\"challenge\":");
            const auto sig=line.find("\"significant\":",challengeStart);
            if(sig!=std::string::npos)leaked|=std::stoull(line.substr(sig+14))!=0;
        }
    }
    std::ofstream results(opt.out/"results.jsonl",std::ios::app);
    if(!results)throw std::runtime_error("cannot open results");
    std::signal(SIGINT,Stop);std::signal(SIGTERM,Stop);
    const auto deadline=Clock::now()+std::chrono::duration<double>(opt.hours*3600.0);
    const auto hypotheses=std::max(kHypotheses,std::size_t{opt.fixtures}*kFlags);
    for(unsigned f=0;f<opt.fixtures;++f) {
        const auto id=Id(f);
        if(completed.count(id))continue;
        if(stopped || Clock::now()>=deadline)break;
        std::cout<<"SEED fixture="<<f<<" hypotheses="<<hypotheses<<std::endl;
        if(!Seed(f,opt.master))throw std::runtime_error("seeding failed");
        const auto scenario=ScenarioFor(f,opt.master);if(!ValidScenario(scenario))throw std::runtime_error("invalid scenario");
        // Victim-side sanity check, separate from the attacker's budget.
        // An invalid reversible plan must never become a security pass.
        Bytes checkInput=scenario.mTemplate,checkCipher(kBlockBytes),checkPlain(kBlockBytes);
        if(!Soccer3::EncryptBlock(checkInput.data(),checkCipher.data()) ||
           !Soccer3::DecryptBlock(checkCipher.data(),checkPlain.data()) ||
           checkPlain!=scenario.mTemplate)throw std::runtime_error("trial round trip failed");
        const auto setup=Configuration();const auto start=Clock::now();
        std::cout<<"BEGIN trial="<<id<<" config="<<setup<<std::endl;
        const Oracle oracle=[&](const Bytes& input,Bytes& output) {
            if(stopped || Clock::now()>=deadline || input.size()!=kBlockBytes)return false;
            Bytes source=input;output.resize(kBlockBytes);return Soccer3::EncryptBlock(source.data(),output.data());
        };
        Model model;Result challenge,confirmation;
        const bool ok=Train(oracle,scenario,model) &&
            Challenge(oracle,scenario,model,opt.challenge,0xFA481C1B83D24E99ULL,challenge,hypotheses) &&
            Challenge(oracle,scenario,model,opt.confirm,0x90B67FD8A3C1254EULL,confirmation,hypotheses);
        if(!ok) {
            if(stopped || Clock::now()>=deadline) {std::cout<<"INCOMPLETE trial="<<id<<" (resume will restart it)"<<std::endl;break;}
            throw std::runtime_error("attack/API failed; not a security pass");
        }
        if(challenge.mShuffledSignificant || confirmation.mShuffledSignificant)throw std::runtime_error("shuffled-label control failed");
        const auto confirmed=challenge.mSignificant&confirmation.mSignificant;
        leaked|=challenge.mSignificant!=0;
        std::ostringstream record;record<<"{\"status\":\"complete\",\"roundtrip_valid\":true,\"trial_id\":"<<Quote(id)<<",\"fixture\":"<<f
            <<",\"build\":"<<Quote(SOCCER_SWEEP_BUILD)<<",\"master_seed\":"<<opt.master<<",\"layout\":"<<Quote(f<2?"original":f%3==0?"contiguous":f%3==1?"stride8":"stride64")
            <<",\"hypotheses\":"<<hypotheses<<",\"training_queries\":"<<model.mQueries<<",\"features\":"<<model.mFeatures<<",\"seconds\":"<<std::chrono::duration<double>(Clock::now()-start).count()
            <<",\"challenge\":";ResultJson(record,challenge);record<<",\"confirmation\":";ResultJson(record,confirmation);
        record<<",\"confirmed\":"<<confirmed<<",\"plaintext_bits\":";Array(record,scenario.mBits);
        record<<",\"predictors\":[";for(unsigned i=0;i<64;++i){if(i)record<<',';const auto& c=model.mPredictions[i];record<<'['<<c.mFeature.mA<<','<<c.mFeature.mB<<','<<c.mPolarity<<']';}
        record<<"],\"configuration\":"<<setup<<'}';results<<'\n'<<record.str()<<'\n';results.flush();if(!results)throw std::runtime_error("result write failed");
        std::cout<<"RESULT "<<record.str()<<std::endl;completed.insert(id);
        Soccer3::Zero();
    }
    Soccer3::Zero();
    std::cout<<"FINISHED completed="<<completed.size()<<"/"<<opt.fixtures<<"; lower measured leakage is not a security proof."<<std::endl;
    return leaked?2:completed.size()==opt.fixtures?0:3;
} catch(const std::exception& e) {std::cerr<<"ERROR: "<<e.what()<<'\n';Soccer3::Zero();return 1;}
