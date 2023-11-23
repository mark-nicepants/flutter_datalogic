# flutter_datalogic

[![pub package](https://img.shields.io/pub/v/flutter_datalogic.svg)](https://pub.dev/packages/flutter_datalogic)
[![pub points](https://img.shields.io/pub/points/flutter_datalogic?color=2E8B57&label=pub%20points)](https://pub.dev/packages/flutter_datalogic/score)
[![flutter_datalogic](https://github.com/tusaamf/flutter_datalogic/actions/workflows/flutter_datalogic.yml/badge.svg)](https://github.com/tusaamf/flutter_datalogic/actions/workflows/flutter_datalogic.yml)

A Flutter package communicate with Datalogic scanners.

## Platform Support

| Android | iOS |
| :-----: | :-: |
|   ✅    | ❌  |

# Usage

Initialize the FlutterDatalogic Object and attach a listener to the onScanResult Stream.

Example:

```dart
import 'package:flutter_datalogic/flutter_datalogic.dart';

FlutterDatalogic dl = FlutterDatalogic();
await dw.initialize();
StreamSubscription onScanSubscription = dl.onScanResult.listen((result) {
  print(result.data);
});
```

## Learn more

- [API Documentation](https://pub.dev/documentation/flutter_datalogic/latest/flutter_datalogic/flutter_datalogic-library.html)
- [Plugin documentation website](https://plus.fluttercommunity.dev/docs/flutter_datalogic/overview)