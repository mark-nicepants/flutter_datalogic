import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'consts/datalogic_event_type.dart';
import 'consts/method_channel_methods.dart';
import 'models/scan_result.dart';
import 'models/scanner_status.dart';

class FlutterDatalogic {
  late final Stream<ScanResult> _scanResultStream;
  late final Stream<ScannerStatus>? _scannerStatusStream;

  final EventChannel _eventChannel = EventChannel('channels/datalogic_scan');
  final MethodChannel _methodChannel = MethodChannel('channels/datalogic_command');

  /// Subscribe to a stream of [ScanResult]s
  Stream<ScanResult> get onScanResult => _scanResultStream;

  /// Subscribe to a stream of [ScannerStatus]s
  Stream<ScannerStatus> get onScannerStatus => _scannerStatusStream!;

  /// Create a new instance of [FlutterDatalogic]
  FlutterDatalogic() {
    _setUpStreams();
  }

  /// Initialize the plugin
  /// This will enable onScannerStatus stream
  Future<void> initialize({String? commandIdentifier}) async {
    final String identifier = commandIdentifier ?? Uuid().v4();
    await _enableListeningScannerStatus(identifier);
  }

  Future<void> _enableListeningScannerStatus(String commandIdentifier) {
    return _methodChannel.invokeMethod<void>(
      MethodChannelMethods.listenScannerStatus.value
    );
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

    _scannerStatusStream = sourceStream
        .where((event) =>
            DatalogicEventType.fromMap(event) ==
            DatalogicEventType.scannerStatus)
        .map(ScannerStatus.fromJson);
  }
}
