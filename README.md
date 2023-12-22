# flutter_datalogic

[![pub package](https://img.shields.io/pub/v/flutter_datalogic.svg)](https://pub.dev/packages/flutter_datalogic)
[![pub points](https://img.shields.io/pub/points/flutter_datalogic?color=2E8B57&label=pub%20points)](https://pub.dev/packages/flutter_datalogic/score)
[![flutter_datalogic](https://github.com/tusaamf/flutter_datalogic/actions/workflows/flutter_datalogic.yml/badge.svg)](https://github.com/tusaamf/flutter_datalogic/actions/workflows/flutter_datalogic.yml)

A Flutter package communicate with Datalogic scanners.

## Platform Support

| Android | iOS |
| :-----: | :-: |
|   ✅    | ❌  |

# Installation

First, add `flutter_datalogic` as a [dependency in your pubspec.yaml file](https://flutter.dev/using-packages/).

## Android

Create file name `proguard-rules.pro` in same directory with your `android/app/build.gradle`

```text
-keep class com.datalogic.cradle.** { *; }
-keep class com.datalogic.decode.** { *; }
-keep class com.datalogic.device.** { *; }
-keep class com.datalogic.extension.** { *; }
-keep class com.datalogic.softspot.** { *; }
```

Configure the `buildTypes release` in your `android/app/build.gradle` file.

```groovy
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        signingConfig signingConfigs.release
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

Add config in your `android/app/src/main/AndroidManifest.xml` file.

```xml
<application>
    <uses-library
        android:name="com.datalogic.device"
        android:required="false" />
</application>
```

# Usage

Initialize the FlutterDatalogic Object and attach a listener to the onScanResult Stream.

Example:

```dart
import 'package:flutter_datalogic/flutter_datalogic.dart';

FlutterDatalogic dl = FlutterDatalogic();
StreamSubscription onScanSubscription = dl.onScannerInfo.listen((result) {
  print(result.status);
  print(result.data);
});
```

## Learn more

- [API Documentation](https://pub.dev/documentation/flutter_datalogic/latest/flutter_datalogic/flutter_datalogic-library.html)
- [Plugin documentation website](https://plus.fluttercommunity.dev/docs/flutter_datalogic/overview)