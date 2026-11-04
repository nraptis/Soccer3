#import <XCTest/XCTest.h>
#include "EncryptionPlan.hpp"
#include "Soccer2.hpp"
#include "LaneCombinations.hpp"
#include <algorithm>
#include <random>
@interface CascadePolicyTests : XCTestCase
@end
@implementation CascadePolicyTests
- (void)testPoliciesPreserveEveryStrongLaneChoice {
    Soccer2Internal::InitializeCiphers();
    std::mt19937 random(0x6CA5CADEU);
    for(unsigned shuffle=0;shuffle<3;++shuffle) {
        std::shuffle(std::begin(Soccer2Internal::mCiphersMutate),std::end(Soccer2Internal::mCiphersMutate),random);
        for(std::size_t selection=0;selection<LaneCombinations::mStrongCount;++selection) {
            const auto original=EncryptionPlanTool::MakePlanStrong(selection,Soccer2Internal::mCiphersMutate,Soccer2Internal::mCiphersPrimaryMovers,Soccer2Internal::mCiphersSecondaryMovers);
            auto always=original;EncryptionPlanTool::ApplyCascadePolicy(always,CascadePolicy::kAlwaysEligible);
            auto never=always;EncryptionPlanTool::ApplyCascadePolicy(never,CascadePolicy::kNever);
            const EncryptionPlanStage* a[]={&original.mL3A,&original.mL2A,&original.mL1A,&original.mL3B,&original.mL2B,&original.mL1B,&original.mL3C,&original.mL2C,&original.mL1C};
            const EncryptionPlanStage* b[]={&always.mL3A,&always.mL2A,&always.mL1A,&always.mL3B,&always.mL2B,&always.mL1B,&always.mL3C,&always.mL2C,&always.mL1C};
            const EncryptionPlanStage* c[]={&never.mL3A,&never.mL2A,&never.mL1A,&never.mL3B,&never.mL2B,&never.mL1B,&never.mL3C,&never.mL2C,&never.mL1C};
            for(unsigned s=0;s<9;++s)for(std::size_t i=0;i<a[s]->mCount;++i) {
                const auto x=a[s]->mType[i],y=b[s]->mType[i],z=c[s]->mType[i];const auto lanes=CipherTool::CountLanes(x);
                XCTAssertFalse(x==CipherType::kCascadeCipher || x==CipherType::kCascadeJumpCipher);
                XCTAssertFalse(z==CipherType::kCascadeCipher || z==CipherType::kCascadeJumpCipher);
                XCTAssertEqual(lanes,CipherTool::CountLanes(y));XCTAssertEqual(lanes,CipherTool::CountLanes(z));
                XCTAssertEqual(IS_MASKED(x),IS_MASKED(y));
                if(IS_MUTATE_ANY(x) && lanes==1)XCTAssertTrue(y==CipherType::kCascadeCipher);
                else if(IS_MUTATE_ANY(x) && lanes==2)XCTAssertTrue(y==CipherType::kCascadeJumpCipher);
                else XCTAssertTrue(x==y);
            }
        }
    }
    Soccer2Internal::Zero();
}
@end
