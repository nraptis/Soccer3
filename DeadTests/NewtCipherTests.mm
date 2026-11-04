#import <XCTest/XCTest.h>
#include "NewtTwoCipherA.hpp"
#include "NewtThreeCipherA.hpp"
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
std::unique_ptr<Cipher> Make(unsigned count, Rows rows, Offsets offsets) {
    if (count == 2U) return std::make_unique<NewtTwoCipherA>(rows[0],offsets[0],rows[1],offsets[1]);
    return std::make_unique<NewtThreeCipherA>(rows[0],offsets[0],rows[1],offsets[1],rows[2],offsets[2]);
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

// Explicit per-bit gate, independent of the implementation's masked comparison.
std::uint8_t LocalKey(std::uint8_t input, std::uint8_t shared, unsigned count, Rows rows) {
    unsigned gate=1U, writable=255U;
    for(unsigned r=0U;r<count;++r) {
        gate &= (input >> rows[r]) & 1U;
        writable &= ~(1U << rows[r]);
    }
    return static_cast<std::uint8_t>((shared ^ (gate ? writable : 0U)) & writable);
}

// Literal specification: independently pack SA/SB/SC, XOR and repeat the key,
// adjust the shared key with the local gate and add into the compacted field.
// Does not use the optimized implementation's XOR-before-packing identity.
Bytes Reference(const Bytes& input, unsigned count, Rows rows, Offsets offsets) {
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
                samples[sample][byte/8U] |= static_cast<std::uint8_t>(bit << (byte%8U));
            }
        }
        for (unsigned byte=0U;byte<64U;++byte) {
            unsigned mask = 0U;
            for (unsigned sample=0U;sample<count;++sample) mask ^= samples[sample][byte%8U];
            output[w*64U+byte] = FieldAdd(input[w*64U+byte],LocalKey(input[w*64U+byte],static_cast<std::uint8_t>(mask),count,rows),protectedRows);
        }
    }
    return output;
}
const char* Check(const Bytes& input, unsigned count, Rows rows, Offsets offsets) {
    auto cipher = Make(count,rows,offsets);
    const auto expectedType = count==2U ? CipherType::kNewtTwoCipherA : CipherType::kNewtThreeCipherA;
    if (cipher->mType!=expectedType || CipherTool::CountLanes(cipher->mType)!=0U) return "type/lanes";
    Bytes source(input.size()+8U,0xD3), output(input.size()+8U,0xA5), restored(input.size()+8U,0xB6), worker(64U,0xC7);
    std::copy(input.begin(),input.end(),source.begin()+1U);
    const auto savedSource=source, savedWorker=worker;
    const auto expected=Reference(input,count,rows,offsets);
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
    const auto reset=Reference(input,count,{0,1,2},{0,0,0});
    if (!cipher->SealData(input.data(),nullptr,output.data(),input.size(),&error) ||
        !std::equal(reset.begin(),reset.end(),output.begin())) return "zero";
    return nullptr;
}
}

@interface NewtCipherTests : XCTestCase
@end
@implementation NewtCipherTests
- (void)testReferenceAllRowsOffsetsAndUnalignedBuffers {
    std::mt19937_64 random(0xF2069281ULL);
    const auto max=std::numeric_limits<std::size_t>::max();
    for (auto length : {64U,192U,320U,1024U}) {
        Bytes input(length);for(auto& b:input)b=static_cast<std::uint8_t>(random());
        for(unsigned count : {2U,3U}) for(unsigned a=0U;a<8U;++a) for(unsigned b=0U;b<8U;++b) {
            if(a==b) continue;
            for(unsigned c=0U;c<(count==2U?1U:8U);++c) {
                if(count==3U && (c==a || c==b)) continue;
                for(auto offsets : {Offsets{0,0,0},Offsets{1,2,3},Offsets{3,1,2},Offsets{max,max-17U,max-29U}}) {
                    const auto failure=Check(input,count,{a,b,c},offsets);
                    if(failure) { XCTFail(@"%s: count=%u rows=%u,%u,%u length=%u",failure,count,a,b,c,length);return; }
                }
            }
        }
    }
}
- (void)testOnlyAssignedRowContributesWhenLocalGateIsOff {
    const Rows rows={1U,4U,7U};
    for(unsigned count : {2U,3U}) {
        auto cipher=Make(count,rows,{1U,2U,3U});
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
                        ? ((1U<<(position%8U)) & ~protectedRows) : 0U;
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
    for(unsigned count : {2U,3U}) {
        const auto failure=Check(input,count,{0,3,7},{8193,10247,12289});
        XCTAssertTrue(failure==nullptr,@"%s",failure?failure:"");
        auto cipher=Make(count,{0,3,7},{8193,10247,12289});
        XCTAssertTrue(cipher->SealData(input.data(),nullptr,first.data(),input.size(),nullptr));
        XCTAssertTrue(cipher->SealData(input.data(),nullptr,second.data(),input.size(),nullptr));
        XCTAssertTrue(first==second);
    }
    NewtTwoCipherA equal(2U,1U,7U,1U+input.size()/64U);
    XCTAssertTrue(equal.SealData(input.data(),nullptr,first.data(),input.size(),nullptr));
    XCTAssertTrue(first==Reference(input,2U,{2U,7U,0U},{1U,1U+input.size()/64U,0U}));
    XCTAssertFalse(first==input); // Equal offsets still sample two different rows.
}
- (void)testLocalGateVariesWithinOneWindowAndBreaksTheOldPairParity {
    // Both destination bytes see packed key 1, but only byte 8 has all its
    // protected controls set. Bit 0 is writable for both variants here.
    for(unsigned count : {2U,3U}) {
        const Rows rows={3U,7U,5U};
        unsigned protectedRows=0U;
        for(unsigned row=0U;row<count;++row)protectedRows|=1U<<rows[row];
        Bytes input(256U,0U),output(input.size()),restored(input.size());
        input[8U]=static_cast<std::uint8_t>(protectedRows);
        input[64U]=1U<<rows[0];
        auto cipher=Make(count,rows,{1U,2U,3U});
        XCTAssertTrue(cipher->SealData(input.data(),nullptr,output.data(),input.size(),nullptr));
        XCTAssertTrue(output==Reference(input,count,rows,{1U,2U,3U}));
        XCTAssertEqual(output[0U],1U);
        XCTAssertEqual((input[0U]^input[8U])&1U,0U);
        XCTAssertEqual((output[0U]^output[8U])&1U,1U);
        XCTAssertEqual(output[8U]&protectedRows,protectedRows);
        XCTAssertTrue(cipher->UnsealData(output.data(),nullptr,restored.data(),input.size(),nullptr));
        XCTAssertTrue(restored==input);
    }
}
- (void)testMixedTwoAndThreeStackReversesInOppositeOrder {
    std::vector<std::unique_ptr<Cipher>> stack;
    for(unsigned round=0U;round<9U;++round) {
        stack.push_back(Make(round%2U==0U?2U:3U,
            {round%8U,(round+3U)%8U,(round+5U)%8U},
            {8193U+17U*round,10247U+29U*round,12289U+37U*round}));
    }
    std::mt19937_64 random(0x4E657774ULL);
    Bytes plain(1U<<20U),current(plain.size()),next(plain.size());
    for(auto& byte:plain)byte=static_cast<std::uint8_t>(random());
    current=plain;
    for(auto& cipher:stack) {
        XCTAssertTrue(cipher->SealData(current.data(),nullptr,next.data(),current.size(),nullptr));
        current.swap(next);
    }
    XCTAssertTrue(current!=plain);
    for(auto cipher=stack.rbegin();cipher!=stack.rend();++cipher) {
        XCTAssertTrue((*cipher)->UnsealData(current.data(),nullptr,next.data(),current.size(),nullptr));
        current.swap(next);
    }
    XCTAssertTrue(current==plain);
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
                        if(output[x]!=FieldAdd(x,LocalKey(x,key,count,{a,b,c}),protectedRows)) { XCTFail(@"Arithmetic mismatch: rows=%u,%u,%u count=%u x=%u key=%u",a,b,c,count,x,key);return; }
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
    for(unsigned count : {2U,3U}) {
        auto cipher=Make(count,{0,1,2},{1,2,3});CipherErrorCode error=CipherErrorCode::kNullCipher;
        XCTAssertTrue(cipher->SealData(nullptr,nullptr,nullptr,0U,&error));XCTAssertEqual(error,CipherErrorCode::kNone);
        XCTAssertTrue(cipher->UnsealData(nullptr,nullptr,nullptr,0U,nullptr));
        for(bool inverse : {false,true}) {
            const auto apply=[&](Cipher& c,const std::uint8_t* src,std::uint8_t* dst,std::size_t length) {
                return inverse?c.UnsealData(src,nullptr,dst,length,&error):c.SealData(src,nullptr,dst,length,&error);
            };
            for(auto length : {1U,63U,65U,127U}) { XCTAssertFalse(apply(*cipher,input.data(),output.data(),length));XCTAssertEqual(error,CipherErrorCode::kInvalidLength); }
            for(auto rows : {Rows{0,0,2},Rows{8,1,2},Rows{0,8,2},Rows{std::numeric_limits<std::size_t>::max(),1,2}}) {
                auto invalid=Make(count,rows,{0,0,0});XCTAssertFalse(apply(*invalid,input.data(),output.data(),64U));XCTAssertEqual(error,CipherErrorCode::kInvalidParameter);
            }
            if(count==3U)for(auto rows : {Rows{0,1,0},Rows{0,1,1},Rows{0,1,8}}) {
                auto invalid=Make(count,rows,{0,0,0});XCTAssertFalse(apply(*invalid,input.data(),output.data(),64U));XCTAssertEqual(error,CipherErrorCode::kInvalidParameter);
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
