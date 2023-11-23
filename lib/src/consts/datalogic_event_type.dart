enum DatalogicEventType {
  scannerStatus('SCANNER_STATUS'),
  scanResult('SCAN_RESULT');

  final String value;

  const DatalogicEventType(this.value);

  static DatalogicEventType fromMap(Map<String, dynamic> event) =>
      DatalogicEventType.values
          .firstWhere((type) => type.value == event['EVENT_NAME']);
}