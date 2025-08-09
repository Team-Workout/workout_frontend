// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PTScheduleImpl _$$PTScheduleImplFromJson(Map<String, dynamic> json) =>
    _$PTScheduleImpl(
      id: json['id'] as String,
      trainerId: json['trainerId'] as String,
      trainerName: json['trainerName'] as String,
      memberId: json['memberId'] as String,
      memberName: json['memberName'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      status: $enumDecodeNullable(_$PTScheduleStatusEnumMap, json['status']) ??
          PTScheduleStatus.scheduled,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PTScheduleImplToJson(_$PTScheduleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trainerId': instance.trainerId,
      'trainerName': instance.trainerName,
      'memberId': instance.memberId,
      'memberName': instance.memberName,
      'dateTime': instance.dateTime.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'status': _$PTScheduleStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$PTScheduleStatusEnumMap = {
  PTScheduleStatus.scheduled: 'scheduled',
  PTScheduleStatus.completed: 'completed',
  PTScheduleStatus.cancelled: 'cancelled',
};
