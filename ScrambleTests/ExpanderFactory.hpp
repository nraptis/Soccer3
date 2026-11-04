//
//  ExpanderFactory.hpp
//  ScrambleTests
//
//  Created by nicholas raptis on 7/17/26.
//

#ifndef ExpanderFactory_hpp
#define ExpanderFactory_hpp

#include <stdio.h>
#include <string>
#include <vector>

#include "TwistExpander_Aldebaran.hpp"
#include "TwistExpander_Altair.hpp"
#include "TwistExpander_Antares.hpp"
#include "TwistExpander_Arcturus.hpp"
#include "TwistExpander_Bellatrix.hpp"
#include "TwistExpander_Betelgeuse.hpp"
#include "TwistExpander_Capella.hpp"
#include "TwistExpander_Castor.hpp"
#include "TwistExpander_Mimosa.hpp"
#include "TwistExpander_Polaris.hpp"
#include "TwistExpander_Pollux.hpp"
#include "TwistExpander_Procyon.hpp"
#include "TwistExpander_Regulus.hpp"
#include "TwistExpander_Rigel.hpp"
#include "TwistExpander_Saiph.hpp"
#include "TwistExpander_Sirius.hpp"
#include "TwistExpander_Vega.hpp"


struct ExpanderItem {
    TwistExpander       *mExpander;
    std::string         mName;
};

class ExpanderFactory {
    
    static inline TwistExpander_Aldebaran       mAldebaran;
    static inline TwistExpander_Altair          mAltair;
    static inline TwistExpander_Antares         mAntares;
    static inline TwistExpander_Arcturus        mArcturus;
    static inline TwistExpander_Bellatrix       mBellatrix;
    static inline TwistExpander_Capella         mCapella;
    static inline TwistExpander_Castor          mCastor;
    static inline TwistExpander_Mimosa          mMimosa;
    static inline TwistExpander_Polaris         mPolaris;
    static inline TwistExpander_Pollux          mPollux;
    static inline TwistExpander_Procyon         mProcyon;
    static inline TwistExpander_Regulus         mRegulus;
    static inline TwistExpander_Rigel           mRigel;
    static inline TwistExpander_Saiph           mSaiph;
    static inline TwistExpander_Sirius          mSirius;
    static inline TwistExpander_Vega            mVega;
    
public:
    
    static std::vector<ExpanderItem>        Get() {
        
        std::vector<ExpanderItem> aResult;
        
        aResult.push_back({&mAldebaran, "Aldebaran"});
        aResult.push_back({&mAltair, "Altair"});
        aResult.push_back({&mAntares, "Antares"});
        aResult.push_back({&mArcturus, "Arcturus"});
        aResult.push_back({&mBellatrix, "Bellatrix"});
        aResult.push_back({&mCapella, "Capella"});
        aResult.push_back({&mCastor, "Castor"});
        aResult.push_back({&mMimosa, "Mimosa"});
        aResult.push_back({&mPolaris, "Polaris"});
        aResult.push_back({&mPollux, "Pollux"});
        aResult.push_back({&mProcyon, "Procyon"});
        aResult.push_back({&mRegulus, "Regulus"});
        aResult.push_back({&mRigel, "Rigel"});
        aResult.push_back({&mSaiph, "Saiph"});
        aResult.push_back({&mSirius, "Sirius"});
        aResult.push_back({&mVega, "Vega"});
        
        return aResult;
    }
    
};

#endif /* ExpanderFactory_hpp */
