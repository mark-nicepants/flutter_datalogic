import 'dart:convert';

import 'package:flutter/services.dart';

import 'consts/datalogic_event_type.dart';
import 'models/scan_result.dart';

class FlutterDatalogic {
  late final Stream<ScanResult> _scanResultStream;

  final EventChannel _eventChannel = EventChannel('channels/datalogic_scan');
  final MethodChannel _methodChannel =
      MethodChannel('channels/datalogic_method');

  /// Subscribe to a stream of [ScanResult]s
  Stream<ScanResult> get onScannerInfo => _scanResultStream;

  /// Create a new instance of [FlutterDatalogic]
  FlutterDatalogic() {
    _setUpStreams();
  }

  void _setUpStreams() {
    final sourceStream = _eventChannel
        .receiveBroadcastStream()
        .where((event) => event is String)
        .cast<String>()
        .map((event) => jsonDecode(event) as Map<String, dynamic>);

    _scanResultStream = sourceStream
        .where((event) =>
            DatalogicEventType.fromMap(event) == DatalogicEventType.scannerInfo)
        .map(ScanResult.fromJson);
  }

  Future<void> enableScanner() async {
    try {
      print('called startTrigger()');
      await _methodChannel.invokeMethod('startTrigger');
    } on PlatformException catch (e) {
      "Failed to get startTrigger: '${e.message}'.";
    }
  }

  Future<void> disableScanner() async {
    try {
      print('called stopTrigger()');
      await _methodChannel.invokeMethod('stopTrigger');
    } on PlatformException catch (e) {
      "Failed to get stopTrigger: '${e.message}'.";
    }
  }
}
