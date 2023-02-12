#!/bin/bash

# Init
npx react-native init AwesomeProject

# Build debug
# Target: android/app/build/outputs/apk/debug/app-debug.apk
pushd AwesomeProject || exit
npx react-native build-android --no-packager
popd || exit

# Build release
# Target: android/app/build/outputs/apk/release/app-release.apk
pushd AwesomeProject/android || exit
./gradlew assembleRelease
popd || exit
