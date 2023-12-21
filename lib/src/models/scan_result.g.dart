// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScanResultImpl _$$ScanResultImplFromJson(Map<String, dynamic> json) =>
    _$ScanResultImpl(
      status: $enumDecode(_$ScannerStatusTypeEnumMap, json['status']),
      data: json['scanData'] as String,
    );

Map<String, dynamic> _$$ScanResultImplToJson(_$ScanResultImpl instance) =>
    <String, dynamic>{
      'status': _$ScannerStatusTypeEnumMap[instance.status]!,
      'scanData': instance.data,
    };

const _$ScannerStatusTypeEnumMap = {
  ScannerStatusType.SCANNING: 'SCANNING',
  ScannerStatusType.IDLE: 'IDLE',
};
