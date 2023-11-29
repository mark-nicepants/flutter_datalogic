enum DatalogicEventType {
  scannerInfo('SCANNER_INFO');

  final String value;

  const DatalogicEventType(this.value);

  static DatalogicEventType fromMap(Map<String, dynamic> event) =>
      DatalogicEventType.values
          .firstWhere((type) => type.value == event['EVENT_NAME']);
}