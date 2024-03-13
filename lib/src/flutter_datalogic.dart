import 'dart:convert';

import 'package:flutter/services.dart';

import 'consts/datalogic_event_type.dart';
import 'models/scan_result.dart';

class FlutterDatalogic {
  late final Stream<ScanResult> _scanResultStream;

  final EventChannel _eventChannel = EventChannel('channels/datalogic_scan');
  final MethodChannel _methodChannel = MethodChannel('channels/datalogic_command');

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
        .where((event) => DatalogicEventType.fromMap(event) == DatalogicEventType.scannerInfo)
        .map(ScanResult.fromJson);
  }

  Future<void> startScanning() async {
    try {
      await _methodChannel.invokeMethod('startScanning');
    } on PlatformException catch (e) {
      "Failed to get startScanning: '${e.message}'.";
    }
  }

  Future<void> stopScanning() async {
    try {
      await _methodChannel.invokeMethod('stopScanning');
    } on PlatformException catch (e) {
      "Failed to get stopScanning: '${e.message}'.";
    }
  }

  Future<bool?> hasScanner() async {
    try {
      return await _methodChannel.invokeMethod<bool>('hasScanner');
    } on PlatformException catch (e) {
      "Failed to get hasScanner: '${e.message}'.";
      return false;
    }
  }
}
