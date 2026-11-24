#!/bin/zsh
set -euo pipefail

aProjectRoot="${0:A:h:h}"
aOutputRoot="$aProjectRoot/Statistical Outputs/CaptureWeakestPredictorTest"
aDerivedData="$aProjectRoot/build/capture-weakest"
aSessionName="$(date +%Y%m%d-%H%M%S)-$$"
aLogPath="$aOutputRoot/launch-$aSessionName.log"
aResultPath="$aOutputRoot/launch-$aSessionName.xcresult"
mkdir -p "$aOutputRoot"
cd "$aProjectRoot"

export DEVELOPER_DIR="${DEVELOPER_DIR:-/Applications/Xcode.app/Contents/Developer}"
# xcodebuild forwards TEST_RUNNER_ variables to the test process without that prefix.
for aVariableName in SOCCER_CAPTURE_SEED SOCCER_CAPTURE_RUNS SOCCER_CAPTURE_FIRST_FIXTURE \
                     SOCCER_CAPTURE_VERIFICATION_SAMPLES SOCCER_CAPTURE_OUTPUT; do
    if (( ${+parameters[$aVariableName]} )); then
        export "TEST_RUNNER_${aVariableName}=${(P)aVariableName}"
    fi
done

print "Capture console log: $aLogPath"
print "Capture result bundle: $aResultPath"
print "The default capture runs until stopped. Completed fixtures save individually."

"$DEVELOPER_DIR/usr/bin/xcodebuild" \
    -project "$aProjectRoot/Scramble.xcodeproj" -scheme StatisticalTests \
    -configuration Release -destination "platform=macOS,arch=$(uname -m)" \
    -derivedDataPath "$aDerivedData" -resultBundlePath "$aResultPath" \
    -parallel-testing-enabled NO -enableCodeCoverage NO -test-timeouts-enabled NO \
    -only-testing:StatisticalTests/CaptureWeakestPredictorTest/testCaptureWeakestPredictor \
    test 2>&1 | tee "$aLogPath"
