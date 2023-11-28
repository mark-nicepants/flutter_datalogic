import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datalogic/flutter_datalogic.dart';
import 'package:stream_transform/stream_transform.dart';

void main() => runApp(MaterialApp(home: const ExampleApp()));

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  late FlutterDatalogic fdl;
  late StreamSubscription onSubscription;

  var scannerStatus = ScannerStatusType.IDLE;
  var scannedBarcode = 'Press Scan button on device';

  @override
  void initState() {
    initScanner();
    super.initState();
  }

  Future<void> initScanner() async {
    if (Platform.isAndroid) {
      fdl = FlutterDatalogic();
      await fdl.initialize();
      onSubscription = fdl.onScannerStatus.combineLatest(fdl.onScanResult,
          (scannerStatus, scanResult) {
        return ScanData(scannerStatus.status, scannerStatus.status == ScannerStatusType.SCANNING ? '' : scanResult.data);
      }).listen((event) {
        setState(() {
          scannerStatus = event.scannerStatus;
          scannedBarcode = event.scannedBarcode;
        });
      });
    }
  }

  @override
  void dispose() {
    onSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Datalogic demo')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Status : ${scannerStatus.name}',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              scannedBarcode,
              textAlign: TextAlign.center,
            ),
            // TextButton(onPressed: _scan, child: Text('Scan')),
          ],
        ),
      ),
    );
  }

// void _scan() {}
}

class ScanData {
  ScanData(this.scannerStatus, this.scannedBarcode);

  final ScannerStatusType scannerStatus;
  final String scannedBarcode;
}
