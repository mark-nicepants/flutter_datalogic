import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_datalogic/flutter_datalogic.dart';

void main() => runApp(MaterialApp(home: const ExampleApp()));

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  late StreamSubscription onScanSubscription;

  var scannedBarcode = 'Press Scan button on device';

  @override
  void initState() {
    FlutterDatalogic dl = FlutterDatalogic();
    onScanSubscription = dl.onScanResult.listen((result) {
      setState(() {
        scannedBarcode = result.data;
      });
    });
    super.initState();
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
              scannedBarcode,
              textAlign: TextAlign.center,
            ),
            // TextButton(onPressed: _scan, child: Text('Scan')),
          ],
        ),
      ),
    );
  }

  void _scan() {
  }
}
