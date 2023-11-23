import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datalogic/flutter_datalogic.dart';

void main() => runApp(MaterialApp(home: const ExampleApp()));

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  late FlutterDatalogic fdl;
  late StreamSubscription onScanSubscription;

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
      onScanSubscription = fdl.onScannerStatus.listen((result) {
        setState(() {
          scannerStatus = result.status;
        });
      });
      onScanSubscription = fdl.onScanResult.listen((result) {
        setState(() {
          scannedBarcode = result.data;
        });
      });
    }
  }

  @override
  void dispose() {
    onScanSubscription.cancel();
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
