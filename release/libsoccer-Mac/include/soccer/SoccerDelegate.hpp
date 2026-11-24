#ifndef SoccerDelegate_hpp
#define SoccerDelegate_hpp

class SoccerDelegate {
public:
    virtual ~SoccerDelegate() = default;

    // Synchronous callbacks on the AttemptSeed caller's thread, from 0.0 to 100.0.
    // 100.0 means the attempt returned, not necessarily that it succeeded.
    // Do not re-enter Soccer3 from this callback, except to change its delegate.
    virtual void SeedProgress(double pPercent) = 0;
};

#endif /* SoccerDelegate_hpp */
