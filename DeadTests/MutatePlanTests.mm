// Retired with FlameToad: historical Cryptex / premium-seed plumbing. Source retained.
#if 0
#import <XCTest/XCTest.h>
#include "Soccer2.hpp"
#include "EncryptionPlan.hpp"
#include "LaneCombinations.hpp"
#include <algorithm>
#include <iterator>

@interface MutatePlanTests : XCTestCase
@end
@implementation MutatePlanTests
- (void)testEveryMutatorHasOneCategoryAndItsMaterialBudget {
    const CipherType types[] = {CipherType::kPasswordXORCipher,
        CipherType::kPasswordAddCipher, CipherType::kPasswordSubtractCipher,
        CipherType::kPasswordJumpXORCipher, CipherType::kPasswordJumpAddCipher,
        CipherType::kPasswordJumpSubtractCipher, CipherType::kPepperNoiseXORCipher,
        CipherType::kPepperJumpNoiseXORCipher, CipherType::kPepperDualJumpNoiseXORCipher};
    const unsigned lanes[] = {1,1,1,2,2,2,2,3,4};
    for(unsigned i=0;i<9;++i) {
        XCTAssertTrue(IS_MUTATE(types[i]));
        XCTAssertEqual(CipherTool::CountLanes(types[i]),lanes[i]);
        XCTAssertFalse(IS_MASKED(types[i]) || IS_MOVER_ANY(types[i]) || IS_ROTATION_ANY(types[i]));
    }
    for(auto type : {CipherType::kNone, CipherType::kRotateCipher,
        CipherType::kRotateMaskCipher, CipherType::kInvertMaskCipher,
        CipherType::kFrogTwoCipherA, CipherType::kToadThreeCipherA, CipherType::kNewtThreeCipherA}) {
        XCTAssertFalse(IS_MUTATE(type));
    }
}
- (void)testAllStrongOneLaneSlotsCanUseEachOneLaneMutator {
    Soccer2Internal::InitializeCiphers();
    for(auto selected : {CipherType::kPasswordXORCipher,
        CipherType::kPasswordAddCipher, CipherType::kPasswordSubtractCipher}) {
        CipherType pool[32];std::fill(std::begin(pool),std::end(pool),selected);
        pool[29]=CipherType::kPasswordJumpXORCipher;
        pool[30]=CipherType::kPepperJumpNoiseXORCipher;
        pool[31]=CipherType::kPepperDualJumpNoiseXORCipher;
        unsigned checked=0;
        for(std::size_t choice=0;choice<LaneCombinations::mStrongCount;++choice) {
            const auto plan=EncryptionPlanTool::MakePlanStrong(choice,pool,
                Soccer2Internal::mCiphersPrimaryMovers,Soccer2Internal::mCiphersSecondaryMovers);
            const EncryptionPlanStage* stages[]={&plan.mL3A,&plan.mL2A,&plan.mL1A,
                &plan.mL3B,&plan.mL2B,&plan.mL1B,&plan.mL3C,&plan.mL2C,&plan.mL1C};
            for(const auto* stage:stages)for(std::size_t i=0;i<stage->mCount;++i) {
                const auto type=stage->mType[i];
                if(IS_MUTATE(type) && CipherTool::CountLanes(type)==1) {
                    XCTAssertTrue(type==selected);++checked;
                }
            }
        }
        XCTAssertGreaterThan(checked,0U);
    }
    Soccer2Internal::Zero();
}
@end

#endif
#import <XCTest/XCTest.h>
@interface MutatePlanTests : XCTestCase
@end
@implementation MutatePlanTests
- (void)testRetiredConstruction { XCTSkip(@"Historical Cryptex / premium-seed test; replaced by FlameToad vault checks."); }
@end
