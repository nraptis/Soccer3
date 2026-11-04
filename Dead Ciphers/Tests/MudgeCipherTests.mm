#import <XCTest/XCTest.h>
#include "Cryptex.hpp"
#include <array>
#include <algorithm>
#include <limits>
#include <memory>
#include <random>
#include <vector>

namespace {
using Bytes = std::vector<std::uint8_t>;
using Rows = std::array<std::size_t, 3>;
using Rotations = std::array<std::size_t, 3>;
std::unique_ptr<Cipher> Make(unsigned variant, Rows rows, Rotations r) {
    if (variant == 0U) { return std::make_unique<MudgeCipherA>(rows[0],r[0],rows[1],r[1],rows[2],r[2]); }
    if (variant == 1U) { return std::make_unique<MudgeCipherB>(rows[0],r[0],rows[1],r[1],rows[2],r[2]); }
    return std::make_unique<MudgeCipherC>(rows[0],r[0],rows[1],r[1]);
}
// Direct modulo specification; does not use the SIMD loads, halves, or spans.
Bytes Reference(const Bytes& input, unsigned variant, Rows rows, Rotations r) {
    Bytes output = input;
    const auto windows = input.size()/64U;
    const unsigned controls = variant == 2U ? 2U : 3U;
    const unsigned offset = variant == 0U ? 13U : variant == 1U ? 21U : 49U;
    unsigned protectedRows = 0U;
    for (unsigned c=0; c<controls; ++c) { protectedRows |= 1U << rows[c]; }
    for (std::size_t w=0; w<windows; ++w) {
        for (unsigned i=0; i<64U; ++i) {
            unsigned gate = 1U;
            for (unsigned c=0; c<controls; ++c) {
                const auto sample = 64U*((w+r[c]%windows)%windows)+(i+c*offset)%64U;
                gate &= (input[sample] >> rows[c]) & 1U;
            }
            if (gate) { output[w*64U+i] ^= static_cast<std::uint8_t>(~protectedRows); }
        }
    }
    return output;
}
const char* Check(const Bytes& input, unsigned variant, Rows rows, Rotations rotations) {
    auto cipher = Make(variant,rows,rotations);
    Bytes source(input.size()+8,0xD3), output(input.size()+8,0xA5), restored(input.size()+8,0xB6);
    std::copy(input.begin(),input.end(),source.begin()+1);
    const auto saved=source;
    const auto expected=Reference(input,variant,rows,rotations);
    CipherErrorCode error=CipherErrorCode::kNullCipher;
    if (!cipher->SealData(source.data()+1,nullptr,output.data()+3,input.size(),&error) || error!=CipherErrorCode::kNone) return "seal";
    if (!std::equal(expected.begin(),expected.end(),output.begin()+3)) return "scalar/NEON mismatch";
    if (source!=saved) return "source changed";
    if (!std::all_of(output.begin(),output.begin()+3,[](auto x){return x==0xA5;}) ||
        !std::all_of(output.begin()+3+input.size(),output.end(),[](auto x){return x==0xA5;})) return "bounds";
    if (!cipher->UnsealData(output.data()+3,nullptr,restored.data()+5,input.size(),&error) ||
        !std::equal(input.begin(),input.end(),restored.begin()+5)) return "inverse";
    cipher->Zero();
    const auto reset=Reference(input,variant,{0,1,2},{0,0,0});
    if (!cipher->SealData(input.data(),nullptr,output.data(),input.size(),nullptr) ||
        !std::equal(reset.begin(),reset.end(),output.begin())) return "zero";
    return nullptr;
}
}

@interface MudgeCipherTests : XCTestCase
@end
@implementation MudgeCipherTests
- (void)testAllRowsOffsetsWrapsAndInverse {
    std::mt19937_64 random(0x12349AULL);
    const auto max=std::numeric_limits<std::size_t>::max();
    for (auto length : {64U,192U,320U,1024U}) {
        Bytes input(length); for (auto& b:input) b=static_cast<std::uint8_t>(random());
        for (unsigned v=0; v<3; ++v) for (unsigned a=0;a<8;++a) for (unsigned b=0;b<8;++b) {
            if (a==b) continue;
            for (unsigned c=0;c<(v==2?1U:8U);++c) {
                if (v!=2 && (a==c || b==c)) continue;
                for (auto r : {Rotations{0,0,0},Rotations{1,2,3},Rotations{max,max-17,max-29}}) {
                    const auto failure=Check(input,v,{a,b,c},r);
                    if (failure) { XCTFail(@"%s: variant=%u rows=%u,%u,%u",failure,v,a,b,c); return; }
                }
            }
        }
    }
}
- (void)testAndTruthTablesAndProtectedRows {
    for (unsigned v=0;v<3;++v) {
        const unsigned controls=v==2?2:3, offset=v==0?13:v==1?21:49;
        auto cipher=Make(v,{0,3,7},{1,2,3});
        const unsigned protectedRows=v==2?9U:137U;
        for (unsigned bits=0;bits<(1U<<controls);++bits) {
            Bytes input(256,0), output(256);
            input[0]=0x55;
            const unsigned rows[]={0,3,7};
            for (unsigned c=0;c<controls;++c) input[(c+1)*64+(c*offset)%64] |= ((bits>>c)&1U)<<rows[c];
            XCTAssertTrue(cipher->SealData(input.data(),nullptr,output.data(),input.size(),nullptr));
            const auto expected=std::uint8_t(input[0] ^ (bits==(1U<<controls)-1U ? std::uint8_t(~protectedRows) : 0U));
            XCTAssertEqual(output[0],expected);
            for (std::size_t i=0;i<input.size();++i) XCTAssertEqual((input[i]^output[i])&protectedRows,0U);
        }
    }
}
- (void)testFullBlockStackReversesAndRepeats {
    std::mt19937_64 random(31847);
    Bytes input(1U<<20); for(auto& b:input) b=std::uint8_t(random());
    std::unique_ptr<Cipher> stack[]={Make(2,{6,7,0},{8193,12289,0}),Make(1,{3,4,5},{8195,10247,12291}),Make(0,{0,1,2},{8201,10249,12297})};
    Bytes a=input,b(input.size());
    for(auto& cipher:stack) { XCTAssertTrue(cipher->SealData(a.data(),nullptr,b.data(),a.size(),nullptr)); a.swap(b); }
    const auto first=a;
    for(int i=2;i>=0;--i) { XCTAssertTrue(stack[i]->UnsealData(a.data(),nullptr,b.data(),a.size(),nullptr)); a.swap(b); }
    XCTAssertTrue(a==input);
    for(auto& cipher:stack) { XCTAssertTrue(cipher->SealData(a.data(),nullptr,b.data(),a.size(),nullptr)); a.swap(b); }
    XCTAssertTrue(a==first);
}
- (void)testValidationDoesNotWrite {
    Bytes input(256,0x71), output(256,0xA5); const auto savedInput=input,savedOutput=output;
    for(unsigned v=0;v<3;++v) {
        auto good=Make(v,{0,1,2},{1,2,3}); CipherErrorCode error=CipherErrorCode::kNone;
        XCTAssertTrue(good->SealData(nullptr,nullptr,nullptr,0,&error));
        for (auto length : {1U,63U,65U}) {
            XCTAssertFalse(good->SealData(input.data(),nullptr,output.data(),length,&error));
            XCTAssertEqual(error,CipherErrorCode::kInvalidLength);
        }
        for(auto rows : {Rows{0,0,2},Rows{8,1,2},Rows{0,8,2}}) {
            auto invalid=Make(v,rows,{0,0,0});
            XCTAssertFalse(invalid->SealData(input.data(),nullptr,output.data(),64,&error));
            XCTAssertEqual(error,CipherErrorCode::kInvalidParameter);
        }
        if (v!=2) for(auto rows : {Rows{0,1,0},Rows{0,1,1},Rows{0,1,8}}) {
            auto invalid=Make(v,rows,{0,0,0});
            XCTAssertFalse(invalid->SealData(input.data(),nullptr,output.data(),64,&error));
            XCTAssertEqual(error,CipherErrorCode::kInvalidParameter);
        }
        XCTAssertFalse(good->SealData(nullptr,nullptr,output.data(),64,&error));
        XCTAssertEqual(error,CipherErrorCode::kNullBuffer);
        XCTAssertFalse(good->SealData(input.data(),nullptr,nullptr,64,&error));
        for(auto offset : {0U,1U,63U}) {
            XCTAssertFalse(good->UnsealData(input.data(),nullptr,input.data()+offset,64,&error));
            XCTAssertEqual(error,CipherErrorCode::kAliasedBuffer);
            XCTAssertFalse(good->SealData(input.data()+offset,nullptr,input.data(),64,&error));
        }
    }
    XCTAssertTrue(input==savedInput); XCTAssertTrue(output==savedOutput);
}
@end
