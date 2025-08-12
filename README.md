# Nova SMP

This repository contains the source for a simple Flutter application that wraps the website [https://nova.cube-kingdom.de](https://nova.cube-kingdom.de) in a WebView. The app name is **Nova SMP** and it uses `icon.png` as its launcher icon.

## Building

Execute the `build.sh` script on an Ubuntu server to install all dependencies, fetch the Flutter SDK, generate platform files and build release binaries for Android and (if the host supports it) iOS:

```bash
bash build.sh
```

The Android APK will be placed in `nova_smp_app/build/app/outputs/flutter-apk/`. Building the iOS app requires macOS with Xcode; on other systems the script will skip that step.
