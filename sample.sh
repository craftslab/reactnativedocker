#!/bin/bash

# Init project
npx react-native init AwesomeProject

# Download gradle
curl -L https://services.gradle.org/distributions/gradle-7.5.1-all.zip -o /tmp/gradle-7.5.1-all.zip

# Set distributionUrl
pushd AwesomeProject || exit
sed -i "s/^distributionUrl=.*$/distributionUrl=file:\/tmp\/gradle-7.5.1-all.zip/g" android/gradle/wrapper/gradle-wrapper.properties
popd || exit

# Build debug
# Target: android/app/build/outputs/apk/debug/app-debug.apk
pushd AwesomeProject || exit
yarn
npx react-native build-android --no-packager
popd || exit

# Build release
# Target: android/app/build/outputs/apk/release/app-release.apk
pushd AwesomeProject/android || exit
./gradlew assembleRelease
popd || exit
