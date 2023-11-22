import 'dart:convert';

import 'package:flutter/services.dart';

import 'consts/datalogic_event_type.dart';
import 'models/scan_result.dart';

class FlutterDatalogic {
  late final Stream<ScanResult> _scanResultStream;

  final EventChannel _eventChannel =
      EventChannel('channels/datalogic_scan');

  /// Subscribe to a stream of [ScanResult]s
  Stream<ScanResult> get onScanResult => _scanResultStream;

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
            DatalogicEventType.fromMap(event) == DatalogicEventType.scanResult)
        .map(ScanResult.fromJson);
  }
}
