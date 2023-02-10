#!/bin/bash

# Init
npx react-native init AwesomeProject

# Build
# Target: android/app/build/outputs/apk/release/app-release.apk
ORG_GRADLE_PROJECT_bundleInArRelease=true npx react-native run-android --variant Release
