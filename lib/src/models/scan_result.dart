import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_result.g.dart';

part 'scan_result.freezed.dart';

@freezed
class ScanResult with _$ScanResult {
  const factory ScanResult({
    @JsonKey(name: 'status') required ScannerStatusType status,
    @JsonKey(name: 'scanData') required String data,
  }) = _ScanResult;

  factory ScanResult.fromJson(Map<String, dynamic> json) =>
      _$ScanResultFromJson(json);
}

enum ScannerStatusType {
  /// Scanner has emitted the scan beam and scanning is in progress
  SCANNING,

  /// Scanner is in one of the following states: enabled but not yet in the waiting state, in the suspended state by an intent (e.g. SUSPEND_PLUGIN) or disabled due to the hardware trigger
  IDLE,
}