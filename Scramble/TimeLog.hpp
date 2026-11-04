//
//  TimeLog.hpp
//  Scramble
//

#ifndef TimeLog_hpp
#define TimeLog_hpp

#include <chrono>
#include <mutex>
#include <string>
#include <unordered_map>

namespace TimeLogDetail {

using Clock = std::chrono::steady_clock;

struct Entry {
    Clock::time_point mStart;
    double mSeconds = 0.0;
    bool mRunning = false;
};

inline std::unordered_map<std::string, Entry> &Entries() {
    static std::unordered_map<std::string, Entry> aEntries;
    return aEntries;
}

inline std::mutex &Mutex() {
    static std::mutex aMutex;
    return aMutex;
}

}

inline void Time_Reset() {
    std::lock_guard<std::mutex> aLock(TimeLogDetail::Mutex());
    TimeLogDetail::Entries().clear();
}

inline void Time_Start(const char *pName) {
    if (pName == nullptr) {
        return;
    }

    std::lock_guard<std::mutex> aLock(TimeLogDetail::Mutex());
    TimeLogDetail::Entry &aEntry = TimeLogDetail::Entries()[pName];
    const TimeLogDetail::Clock::time_point aNow =
        TimeLogDetail::Clock::now();

    if (aEntry.mRunning) {
        aEntry.mSeconds +=
            std::chrono::duration<double>(aNow - aEntry.mStart).count();
    }

    aEntry.mStart = aNow;
    aEntry.mRunning = true;
}

inline void Time_End(const char *pName) {
    if (pName == nullptr) {
        return;
    }

    const TimeLogDetail::Clock::time_point aNow =
        TimeLogDetail::Clock::now();
    std::lock_guard<std::mutex> aLock(TimeLogDetail::Mutex());
    const auto aIterator = TimeLogDetail::Entries().find(pName);
    if ((aIterator == TimeLogDetail::Entries().end()) ||
        (!aIterator->second.mRunning)) {
        return;
    }

    TimeLogDetail::Entry &aEntry = aIterator->second;
    aEntry.mSeconds +=
        std::chrono::duration<double>(aNow - aEntry.mStart).count();
    aEntry.mRunning = false;
}

inline double Time_Poll(const char *pName) {
    if (pName == nullptr) {
        return 0.0;
    }

    const TimeLogDetail::Clock::time_point aNow =
        TimeLogDetail::Clock::now();
    std::lock_guard<std::mutex> aLock(TimeLogDetail::Mutex());
    const auto aIterator = TimeLogDetail::Entries().find(pName);
    if (aIterator == TimeLogDetail::Entries().end()) {
        return 0.0;
    }

    double aSeconds = aIterator->second.mSeconds;
    if (aIterator->second.mRunning) {
        aSeconds += std::chrono::duration<double>(
            aNow - aIterator->second.mStart).count();
    }

    return aSeconds;
}

#endif /* TimeLog_hpp */
