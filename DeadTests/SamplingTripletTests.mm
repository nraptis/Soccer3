#import <XCTest/XCTest.h>
#include "SamplingTriplet.hpp"
#include <map>
#include <set>
#include <functional>
#include <vector>

@interface SamplingTripletTests : XCTestCase
@end
@implementation SamplingTripletTests
- (void)testAllValidGridsAreReachableExactlyOncePerPartitionAndCompletion {
    using Grid = SamplingTriplet::Grid;
    std::map<std::array<std::uint8_t,3>,unsigned> firstLayers;
    // The last Fisher-Yates rank is the identity swap sequence.
    for(unsigned rank=0;rank<40320;++rank) {
        const auto grid=SamplingTriplet::Select(rank,40319,0);
        firstLayers.emplace(grid[0],rank);
    }
    XCTAssertEqual(firstLayers.size(),std::size_t{560});
    std::set<Grid> generated;
    for(const auto& [first,rank]:firstLayers)for(unsigned completion=0;completion<28;++completion) {
        const auto grid=SamplingTriplet::Select(rank,40319,completion);
        XCTAssertTrue(generated.insert(grid).second);
        for(unsigned i=0;i<3;++i) {
            unsigned rowMask=0,columnMask=0,rowCount=0,columnCount=0;
            for(unsigned j=0;j<3;++j) {
                XCTAssertEqual(SamplingTriplet::Count(grid[i][j]),i==j?2U:3U);
                rowMask|=grid[i][j];columnMask|=grid[j][i];
                rowCount+=SamplingTriplet::Count(grid[i][j]);columnCount+=SamplingTriplet::Count(grid[j][i]);
            }
            XCTAssertEqual(rowMask,255U);XCTAssertEqual(columnMask,255U);
            XCTAssertEqual(rowCount,8U);XCTAssertEqual(columnCount,8U);
        }
    }
    // Independent exhaustive oracle: every bit chooses one of six bijections
    // between levels and families, respecting the requested cell capacities.
    constexpr unsigned permutations[][3]={{0,1,2},{0,2,1},{1,0,2},{1,2,0},{2,0,1},{2,1,0}};
    Grid grid{};unsigned left[3][3]={{2,3,3},{3,2,3},{3,3,2}};
    std::set<Grid> expected;
    std::function<void(unsigned)> visit=[&](unsigned bit) {
        if(bit==8) {expected.insert(grid);return;}
        for(const auto& p:permutations) {
            if(!left[0][p[0]]||!left[1][p[1]]||!left[2][p[2]])continue;
            for(unsigned level=0;level<3;++level){--left[level][p[level]];grid[level][p[level]]|=1U<<bit;}
            visit(bit+1);
            for(unsigned level=0;level<3;++level){++left[level][p[level]];grid[level][p[level]]^=1U<<bit;}
        }
    };
    visit(0);
    XCTAssertEqual(expected.size(),std::size_t{15680});
    XCTAssertTrue(generated==expected);
}
- (void)testBothGridShufflePassesComposeAndEveryBitIsSymmetric {
    const auto once=SamplingTriplet::Select(0,40319,0);
    const auto twice=SamplingTriplet::Select(0,0,0);
    // Rank zero rotates labels left by one. The second pass must not reset them.
    XCTAssertEqual(once[0][0],std::uint8_t{(1U<<1)|(1U<<2)});
    XCTAssertEqual(twice[0][0],std::uint8_t{(1U<<2)|(1U<<3)});
    unsigned frequency[3][8]={};
    for(unsigned rank=0;rank<40320;++rank) {
        const auto grid=SamplingTriplet::Select(rank,40319,0);
        for(unsigned bank=0;bank<3;++bank)for(unsigned bit=0;bit<8;++bit)
            frequency[bank][bit]+=(grid[0][bank]>>bit)&1U;
    }
    for(unsigned bank=0;bank<3;++bank)for(unsigned bit=0;bit<8;++bit)
        XCTAssertEqual(frequency[bank][bit],40320U*(bank==0?2U:3U)/8U);
}
- (void)testRowOrderingPreservesSetsAndReachesEveryAllowedOrder {
    for(unsigned mask=0;mask<256;++mask) {
        const auto count=SamplingTriplet::Count(mask);
        if(count!=2 && count!=3)continue;
        const unsigned orders=count==2?2:6;
        std::set<std::array<std::uint8_t,3>> seen;
        for(unsigned rank=0;rank<orders;++rank) {
            std::array<std::uint8_t,3> rows{255,255,255};
            SamplingTriplet::OrderRows(mask,rank,orders-1,rows.data());
            unsigned used=0;
            for(unsigned i=0;i<count;++i)used|=1U<<rows[i];
            XCTAssertEqual(used,mask);
            if(count==2)XCTAssertEqual(rows[2],255U);
            XCTAssertTrue(seen.insert(rows).second);
        }
        XCTAssertEqual(seen.size(),std::size_t{orders});
        std::uint8_t twice[3];SamplingTriplet::OrderRows(mask,0,0,twice);
        std::vector<unsigned> selected;
        for(unsigned bit=0;bit<8;++bit)if((mask>>bit)&1)selected.push_back(bit);
        for(unsigned i=0;i<count;++i)XCTAssertEqual(twice[i],selected[(i+2)%count]);
    }
}
@end
