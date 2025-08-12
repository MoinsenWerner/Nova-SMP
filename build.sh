#!/usr/bin/env bash
set -e

APP_DIR="nova_smp_app"
PACKAGE_ID="com.plsreload9383.novasmp"
APP_NAME="Nova SMP"
URL="https://nova.cube-kingdom.de"
FLUTTER_VERSION=3.22.1

# Install dependencies
sudo apt-get update
sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa default-jdk build-essential || true

# Install Flutter SDK if not present
if [ ! -d flutter-sdk ]; then
  git clone https://github.com/flutter/flutter.git -b ${FLUTTER_VERSION} flutter-sdk
fi
export PATH="$PWD/flutter-sdk/bin:$PATH"

# Create project if not exists
if [ ! -d "$APP_DIR" ]; then
  flutter create --platforms=android,ios --org com.plsreload9383 ${APP_DIR}
  (cd ${APP_DIR} && rm -rf lib pubspec.yaml)
  cp -r lib ${APP_DIR}/lib
  cp pubspec.yaml ${APP_DIR}/pubspec.yaml
  cp icon.png ${APP_DIR}/icon.png
fi

cd ${APP_DIR}

# Ensure correct package id in android
perl -0 -i -pe "s/applicationId \"[^"]*\"/applicationId \"${PACKAGE_ID}\"/" android/app/build.gradle
perl -0 -i -pe "s/android:label=\"[^\"]*\"/android:label=\"${APP_NAME}\"/" android/app/src/main/AndroidManifest.xml

# Ensure iOS bundle identifier and name
if [ -f ios/Runner.xcodeproj/project.pbxproj ]; then
  perl -0 -i -pe "s/PRODUCT_BUNDLE_IDENTIFIER = [^;]*;/PRODUCT_BUNDLE_IDENTIFIER = ${PACKAGE_ID};/" ios/Runner.xcodeproj/project.pbxproj || true
  perl -0 -i -pe "s/CFBundleName\"\>[^<]*\<\/string\>/CFBundleName\">${APP_NAME}<\/string>/" ios/Runner/Info.plist || true
fi

flutter pub get
flutter pub run flutter_launcher_icons:main

# Build Android APK
flutter build apk --release

# Attempt to build iOS (will fail on non-macOS but we attempt)
flutter build ios --release --no-codesign || echo "iOS build requires macOS with Xcode"
