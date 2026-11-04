#import <XCTest/XCTest.h>
#include "FrogTwoCipherA.hpp"
#include "FrogThreeCipherA.hpp"
#include "FrogTwoCipherB.hpp"
#include "FrogThreeCipherB.hpp"
#include <algorithm>
#include <array>
#include <cstdint>
#include <limits>
#include <memory>
#include <random>
#include <vector>

namespace {
using Bytes = std::vector<std::uint8_t>;
using Rows = std::array<std::size_t,3>;
using Offsets = std::array<std::size_t,3>;
std::unique_ptr<Cipher> Make(unsigned count, Rows rows, Offsets offsets, bool reversed = false) {
    if (reversed) {
        if (count == 2U) return std::make_unique<FrogTwoCipherB>(rows[0],offsets[0],rows[1],offsets[1]);
        return std::make_unique<FrogThreeCipherB>(rows[0],offsets[0],rows[1],offsets[1],rows[2],offsets[2]);
    }
    if (count == 2U) return std::make_unique<FrogTwoCipherA>(rows[0],offsets[0],rows[1],offsets[1]);
    return std::make_unique<FrogThreeCipherA>(rows[0],offsets[0],rows[1],offsets[1],rows[2],offsets[2]);
}
// Reference arithmetic explicitly compacts the writable bits, adds modulo
// 2^(writable count), and deposits them back. It does not use carry-hole tricks.
std::uint8_t FieldAdd(std::uint8_t input, std::uint8_t key, unsigned protectedRows) {
    unsigned value=0U, packedKey=0U, count=0U;
    for(unsigned bit=0U;bit<8U;++bit) {
        if((protectedRows & (1U<<bit))!=0U) continue;
        value |= ((input>>bit)&1U)<<count;
        packedKey |= ((key>>bit)&1U)<<count;
        ++count;
    }
    const unsigned sum=(value+packedKey)&((1U<<count)-1U);
    unsigned result=input&protectedRows;
    count=0U;
    for(unsigned bit=0U;bit<8U;++bit) {
        if((protectedRows & (1U<<bit))!=0U) continue;
        result |= ((sum>>count)&1U)<<bit;
        ++count;
    }
    return static_cast<std::uint8_t>(result);
}

// Literal specification: independently pack SA/SB/SC, XOR and repeat the key,
// then add the key into each byte's compacted writable-bit field.
// Does not use the optimized implementation's XOR-before-packing identity.
Bytes Reference(const Bytes& input, unsigned count, Rows rows, Offsets offsets, bool reversed = false) {
    Bytes output = input;
    const auto windows = input.size()/64U;
    unsigned protectedRows = 0U;
    for (unsigned row=0U;row<count;++row) protectedRows |= 1U << rows[row];
    for (std::size_t w=0U;w<windows;++w) {
        std::uint8_t samples[3][8] = {};
        for (unsigned sample=0U;sample<count;++sample) {
            const auto base = ((w+offsets[sample]%windows)%windows)*64U;
            for (unsigned byte=0U;byte<64U;++byte) {
                const auto bit = (input[base+byte] >> rows[sample]) & 1U;
                samples[sample][byte/8U] |= static_cast<std::uint8_t>(bit << (reversed ? 7U-byte%8U : byte%8U));
            }
        }
        for (unsigned byte=0U;byte<64U;++byte) {
            unsigned mask = 0U;
            for (unsigned sample=0U;sample<count;++sample) mask ^= samples[sample][byte%8U];
            output[w*64U+byte] = FieldAdd(input[w*64U+byte],static_cast<std::uint8_t>(mask),protectedRows);
        }
    }
    return output;
}
const char* Check(const Bytes& input, unsigned count, Rows rows, Offsets offsets, bool reversed = false) {
    auto cipher = Make(count,rows,offsets,reversed);
    const auto expectedType = reversed ? (count==2U ? CipherType::kFrogTwoCipherB : CipherType::kFrogThreeCipherB)
                                       : (count==2U ? CipherType::kFrogTwoCipherA : CipherType::kFrogThreeCipherA);
    if (cipher->mType!=expectedType || CipherTool::CountLanes(cipher->mType)!=0U) return "type/lanes";
    Bytes source(input.size()+8U,0xD3), output(input.size()+8U,0xA5), restored(input.size()+8U,0xB6), worker(64U,0xC7);
    std::copy(input.begin(),input.end(),source.begin()+1U);
    const auto savedSource=source, savedWorker=worker;
    const auto expected=Reference(input,count,rows,offsets,reversed);
    CipherErrorCode error=CipherErrorCode::kNullCipher;
    if (!cipher->SealData(source.data()+1U,worker.data(),output.data()+3U,input.size(),&error) || error!=CipherErrorCode::kNone) return "seal";
    if (!std::equal(expected.begin(),expected.end(),output.begin()+3U)) return "reference";
    if (source!=savedSource || worker!=savedWorker) return "source/worker changed";
    if (!std::all_of(output.begin(),output.begin()+3U,[](auto x){return x==0xA5;}) ||
        !std::all_of(output.begin()+3U+input.size(),output.end(),[](auto x){return x==0xA5;})) return "output boundary";
    unsigned protectedRows=0U;for(unsigned row=0;row<count;++row) protectedRows|=1U<<rows[row];
    for(std::size_t i=0;i<input.size();++i) if(((input[i]^output[3U+i])&protectedRows)!=0U) return "protected row";
    if (!cipher->UnsealData(output.data()+3U,nullptr,restored.data()+5U,input.size(),&error) ||
        !std::equal(input.begin(),input.end(),restored.begin()+5U)) return "inverse";
    if (!std::all_of(restored.begin(),restored.begin()+5U,[](auto x){return x==0xB6;}) ||
        !std::all_of(restored.begin()+5U+input.size(),restored.end(),[](auto x){return x==0xB6;})) return "inverse boundary";
    cipher->Zero();
    const auto reset=Reference(input,count,{0,1,2},{0,0,0},reversed);
    if (!cipher->SealData(input.data(),nullptr,output.data(),input.size(),&error) ||
        !std::equal(reset.begin(),reset.end(),output.begin())) return "zero";
    return nullptr;
}
}

@interface FrogCipherTests : XCTestCase
@end
@implementation FrogCipherTests
- (void)testReferenceAllRowsOffsetsAndUnalignedBuffers {
    std::mt19937_64 random(0xF2069281ULL);
    const auto max=std::numeric_limits<std::size_t>::max();
    for (auto length : {64U,192U,320U,1024U}) {
        Bytes input(length);for(auto& b:input)b=static_cast<std::uint8_t>(random());
        for(bool reversed : {false,true}) for(unsigned count : {2U,3U}) for(unsigned a=0U;a<8U;++a) for(unsigned b=0U;b<8U;++b) {
            if(a==b) continue;
            for(unsigned c=0U;c<(count==2U?1U:8U);++c) {
                if(count==3U && (c==a || c==b)) continue;
                for(auto offsets : {Offsets{0,0,0},Offsets{1,2,3},Offsets{3,1,2},Offsets{max,max-17U,max-29U}}) {
                    const auto failure=Check(input,count,{a,b,c},offsets,reversed);
                    if(failure) { XCTFail(@"%s: count=%u rows=%u,%u,%u length=%u",failure,count,a,b,c,length);return; }
                }
            }
        }
    }
}
- (void)testOnlyAssignedRowContributesAndEightByteMaskRepeats {
    const Rows rows={1U,4U,7U};
    for(bool reversed : {false,true}) for(unsigned count : {2U,3U}) {
        auto cipher=Make(count,rows,{1U,2U,3U},reversed);
        unsigned protectedRows=0U;
        for(unsigned sample=0U;sample<count;++sample)protectedRows|=1U<<rows[sample];
        Bytes input(256U),output(input.size());
        for(unsigned sample=0U;sample<count;++sample) for(unsigned row=0U;row<8U;++row) {
            for(unsigned position=0U;position<64U;++position) {
                std::fill(input.begin(),input.end(),0U);
                input[(sample+1U)*64U+position]=static_cast<std::uint8_t>(1U<<row);
                if(!cipher->SealData(input.data(),nullptr,output.data(),input.size(),nullptr)) { XCTFail(@"Seal failed");return; }
                for(unsigned byte=0U;byte<64U;++byte) {
                    const auto expected=(row==rows[sample] && byte%8U==position/8U)
                        ? ((1U<<(reversed ? 7U-position%8U : position%8U)) & ~protectedRows) : 0U;
                    if(output[byte]!=expected) { XCTFail(@"Wrong sample or packing: count=%u sample=%u row=%u position=%u byte=%u",count,sample,row,position,byte);return; }
                }
            }
        }
    }
}
- (void)testFullSizeIndependentBlocksAndEqualOffsets {
    std::mt19937_64 random(0x9817F209ULL);
    Bytes input(1U<<20U), first(input.size()), second(input.size());
    for(auto& b:input)b=static_cast<std::uint8_t>(random());
    for(bool reversed : {false,true}) for(unsigned count : {2U,3U}) {
        const auto failure=Check(input,count,{0,3,7},{8193,10247,12289},reversed);
        XCTAssertTrue(failure==nullptr,@"%s",failure?failure:"");
        auto cipher=Make(count,{0,3,7},{8193,10247,12289},reversed);
        XCTAssertTrue(cipher->SealData(input.data(),nullptr,first.data(),input.size(),nullptr));
        XCTAssertTrue(cipher->SealData(input.data(),nullptr,second.data(),input.size(),nullptr));
        XCTAssertTrue(first==second);
    }
    FrogTwoCipherA equal(2U,1U,7U,1U+input.size()/64U);
    XCTAssertTrue(equal.SealData(input.data(),nullptr,first.data(),input.size(),nullptr));
    XCTAssertTrue(first==Reference(input,2U,{2U,7U,0U},{1U,1U+input.size()/64U,0U}));
    XCTAssertFalse(first==input); // Equal offsets still sample two different rows.
}
- (void)testBReversesPackingWithoutReorderingAssignedRows {
    for (unsigned count : {2U,3U}) {
        Bytes input(256U,0U),outputA(input.size()),outputB(input.size());
        // Source byte 1 in row 0: A packs bit 1, B packs bit 6.
        input[64U+1U]=1U;
        auto cipherA=Make(count,{0,3,7},{1,2,3});
        auto cipherB=Make(count,{0,3,7},{1,2,3},true);
        XCTAssertTrue(cipherA->SealData(input.data(),nullptr,outputA.data(),input.size(),nullptr));
        XCTAssertTrue(cipherB->SealData(input.data(),nullptr,outputB.data(),input.size(),nullptr));
        for (unsigned byte=0U;byte<64U;++byte) {
            XCTAssertEqual(outputA[byte],byte%8U==0U ? 2U : 0U);
            XCTAssertEqual(outputB[byte],byte%8U==0U ? 64U : 0U);
        }
        XCTAssertTrue(outputA!=outputB);
    }
}
- (void)testTwentyAlternatingRoundsBreakXorSuperposition {
    // Check dense and individual-plane XOR probes. Passing these finite
    // fixtures does not establish resistance to plaintext recovery.
    std::vector<std::unique_ptr<Cipher>> stack;
    for(unsigned round=0U;round<20U;++round) {
        stack.push_back(Make(round%2U==0U?2U:3U,
            {round%8U,(round+3U)%8U,(round+5U)%8U},
            {8193U+17U*round,10247U+29U*round,12289U+37U*round}));
    }
    const auto run=[&](Bytes value,bool inverse) {
        Bytes next(value.size());
        for(unsigned i=0U;i<20U;++i) {
            auto& cipher=stack[inverse?19U-i:i];
            const bool ok=inverse?cipher->UnsealData(value.data(),nullptr,next.data(),value.size(),nullptr)
                                 :cipher->SealData(value.data(),nullptr,next.data(),value.size(),nullptr);
            if(!ok) return Bytes{};
            value.swap(next);
        }
        return value;
    };
    std::mt19937_64 random(0x20F206F203ULL);
    Bytes p(1U<<20U),q(p.size()),both(p.size()),zero(p.size(),0U),fixedMask(p.size());
    for(std::size_t i=0;i<p.size();++i) { p[i]=std::uint8_t(random());q[i]=std::uint8_t(random());both[i]=p[i]^q[i];fixedMask[i]=std::uint8_t(random()); }
    const auto fp=run(p,false),fq=run(q,false),fb=run(both,false),fz=run(zero,false);
    XCTAssertEqual(fp.size(),p.size());XCTAssertEqual(fq.size(),p.size());XCTAssertEqual(fb.size(),p.size());XCTAssertEqual(fz.size(),p.size());
    if(fp.size()!=p.size() || fq.size()!=p.size() || fb.size()!=p.size() || fz.size()!=p.size())return;
    XCTAssertTrue(run(fp,true)==p);
    Bytes prediction(p.size()),affinePrediction(p.size()),affineActual(p.size());
    for(std::size_t i=0;i<p.size();++i) {
        prediction[i]=fp[i]^fq[i];
        // A fixed key XOR only adds an offset: E(P^Q)=E(P)^E(Q)^E(0).
        affinePrediction[i]=(fp[i]^fixedMask[i])^(fq[i]^fixedMask[i])^(fz[i]^fixedMask[i]);
        affineActual[i]=fb[i]^fixedMask[i];
    }
    XCTAssertTrue(fz==zero);
    XCTAssertFalse(fb==prediction);
    XCTAssertFalse(affineActual==affinePrediction);
    // A nonzero baseline also exercises carries in the restricted planes.
    for(unsigned bit=0U;bit<8U;++bit) {
        Bytes a=p,b=p,ab=p;
        for(std::size_t i=0;i<p.size();++i) {
            const auto u=static_cast<std::uint8_t>(random() & (1U<<bit));
            const auto v=static_cast<std::uint8_t>(random() & (1U<<bit));
            a[i]^=u;b[i]^=v;ab[i]^=u^v;
        }
        const auto fa=run(a,false),fc=run(b,false),fab=run(ab,false);
        if(fa.size()!=p.size() || fc.size()!=p.size() || fab.size()!=p.size()) { XCTFail(@"Oracle failure");return; }
        bool identical=true;
        for(std::size_t i=0;i<p.size();++i) {
            if((fa[i]^fc[i]^fp[i])!=fab[i]) { identical=false;break; }
        }
        XCTAssertFalse(identical,@"XOR prediction survived for plane %u",bit);
    }
}
- (void)testEveryByteAndKeyAcrossAllProtectedRowSets {
    // Four destination windows hold all 256 byte values. The next four
    // encode each possible repeated key; the last four contribute zero.
    // This checks the actual scalar/SIMD kernels, not a duplicate helper.
    for(unsigned count : {2U,3U}) {
        for(unsigned a=0U;a<8U;++a) for(unsigned b=a+1U;b<8U;++b) {
            for(unsigned c=(count==2U?0U:b+1U);c<(count==2U?1U:8U);++c) {
                const unsigned protectedRows=(1U<<a)|(1U<<b)|(count==3U?(1U<<c):0U);
                auto cipher=Make(count,{a,b,c},{4U,8U,8U});
                Bytes input(12U*64U),output(input.size()),recovered(input.size());
                for(unsigned key=0U;key<256U;++key) {
                    std::fill(input.begin(),input.end(),0U);
                    for(unsigned x=0U;x<256U;++x) input[x]=static_cast<std::uint8_t>(x);
                    for(unsigned i=4U*64U;i<8U*64U;++i) input[i]=static_cast<std::uint8_t>(((key>>(i%8U))&1U)<<a);
                    if(!cipher->SealData(input.data(),nullptr,output.data(),input.size(),nullptr)) { XCTFail(@"Seal failed");return; }
                    for(unsigned x=0U;x<256U;++x) {
                        if(output[x]!=FieldAdd(x,key,protectedRows)) { XCTFail(@"Arithmetic mismatch: rows=%u,%u,%u count=%u x=%u key=%u",a,b,c,count,x,key);return; }
                    }
                    if(!cipher->UnsealData(output.data(),nullptr,recovered.data(),input.size(),nullptr) || recovered!=input) { XCTFail(@"Arithmetic inverse failed");return; }
                }
            }
        }
    }
}
- (void)testSealTwiceGenerallyDoesNotCancel {
    Bytes input(192U,0U),first(input.size()),second(input.size()),restored(input.size());
    // Generate key 2 in packed byte zero; writable bit 1 is the field's LSB.
    input[64U+1U]=1U;
    for(unsigned count : {2U,3U}) {
        auto cipher=Make(count,{0U,7U,3U},{1U,2U,2U});
        XCTAssertTrue(cipher->SealData(input.data(),nullptr,first.data(),input.size(),nullptr));
        XCTAssertTrue(cipher->SealData(first.data(),nullptr,second.data(),input.size(),nullptr));
        XCTAssertEqual(first[0],2U);
        XCTAssertEqual(second[0],4U);
        XCTAssertTrue(second!=input);
        XCTAssertTrue(cipher->UnsealData(first.data(),nullptr,restored.data(),input.size(),nullptr));
        XCTAssertTrue(restored==input);
    }
}

- (void)testValidationDoesNotWrite {
    Bytes input(256U,0x71),output(256U,0xA5);const auto savedInput=input,savedOutput=output;
    for(bool reversed : {false,true}) for(unsigned count : {2U,3U}) {
        auto cipher=Make(count,{0,1,2},{1,2,3},reversed);CipherErrorCode error=CipherErrorCode::kNullCipher;
        XCTAssertTrue(cipher->SealData(nullptr,nullptr,nullptr,0U,&error));XCTAssertEqual(error,CipherErrorCode::kNone);
        XCTAssertTrue(cipher->UnsealData(nullptr,nullptr,nullptr,0U,nullptr));
        for(bool inverse : {false,true}) {
            const auto apply=[&](Cipher& c,const std::uint8_t* src,std::uint8_t* dst,std::size_t length) {
                return inverse?c.UnsealData(src,nullptr,dst,length,&error):c.SealData(src,nullptr,dst,length,&error);
            };
            for(auto length : {1U,63U,65U,127U}) { XCTAssertFalse(apply(*cipher,input.data(),output.data(),length));XCTAssertEqual(error,CipherErrorCode::kInvalidLength); }
            for(auto rows : {Rows{0,0,2},Rows{8,1,2},Rows{0,8,2},Rows{std::numeric_limits<std::size_t>::max(),1,2}}) {
                auto invalid=Make(count,rows,{0,0,0},reversed);XCTAssertFalse(apply(*invalid,input.data(),output.data(),64U));XCTAssertEqual(error,CipherErrorCode::kInvalidParameter);
            }
            if(count==3U)for(auto rows : {Rows{0,1,0},Rows{0,1,1},Rows{0,1,8}}) {
                auto invalid=Make(count,rows,{0,0,0},reversed);XCTAssertFalse(apply(*invalid,input.data(),output.data(),64U));XCTAssertEqual(error,CipherErrorCode::kInvalidParameter);
            }
            XCTAssertFalse(apply(*cipher,nullptr,output.data(),64U));XCTAssertEqual(error,CipherErrorCode::kNullBuffer);
            XCTAssertFalse(apply(*cipher,input.data(),nullptr,64U));XCTAssertEqual(error,CipherErrorCode::kNullBuffer);
            for(auto offset : {0U,1U,63U}) {
                XCTAssertFalse(apply(*cipher,input.data(),input.data()+offset,64U));XCTAssertEqual(error,CipherErrorCode::kAliasedBuffer);
                XCTAssertFalse(apply(*cipher,input.data()+offset,input.data(),64U));XCTAssertEqual(error,CipherErrorCode::kAliasedBuffer);
            }
        }
    }
    XCTAssertTrue(input==savedInput);XCTAssertTrue(output==savedOutput);
}
@end
