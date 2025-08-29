// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_schedule_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PtScheduleImpl _$$PtScheduleImplFromJson(Map<String, dynamic> json) =>
    _$PtScheduleImpl(
      appointmentId: (json['id'] as num).toInt(),
      contractId: (json['contractId'] as num).toInt(),
      trainerName: json['trainerName'] as String,
      memberName: json['memberName'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      status: json['status'] as String,
      requestedStartTime: json['requestedStartTime'] as String?,
      requestedEndTime: json['requestedEndTime'] as String?,
      hasChangeRequest: json['hasChangeRequest'] as bool?,
      changeRequestBy: json['changeRequestBy'] as String?,
    );

Map<String, dynamic> _$$PtScheduleImplToJson(_$PtScheduleImpl instance) =>
    <String, dynamic>{
      'id': instance.appointmentId,
      'contractId': instance.contractId,
      'trainerName': instance.trainerName,
      'memberName': instance.memberName,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'status': instance.status,
      'requestedStartTime': instance.requestedStartTime,
      'requestedEndTime': instance.requestedEndTime,
      'hasChangeRequest': instance.hasChangeRequest,
      'changeRequestBy': instance.changeRequestBy,
    };
