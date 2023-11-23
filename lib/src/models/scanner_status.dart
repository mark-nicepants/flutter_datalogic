import 'package:freezed_annotation/freezed_annotation.dart';

part 'scanner_status.g.dart';

part 'scanner_status.freezed.dart';

@freezed
class ScannerStatus with _$ScannerStatus {
  const factory ScannerStatus({
    required ScannerStatusType status,
  }) = _ScannerStatus;

  factory ScannerStatus.fromJson(Map<String, dynamic> json) =>
      _$ScannerStatusFromJson(json);
}

enum ScannerStatusType {
  /// Scanner has emitted the scan beam and scanning is in progress
  SCANNING,

  /// Scanner is in one of the following states: enabled but not yet in the waiting state, in the suspended state by an intent (e.g. SUSPEND_PLUGIN) or disabled due to the hardware trigger
  IDLE,
}