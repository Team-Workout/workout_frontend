// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_appointment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PtAppointmentImpl _$$PtAppointmentImplFromJson(Map<String, dynamic> json) =>
    _$PtAppointmentImpl(
      appointmentId: (json['appointmentId'] as num).toInt(),
      contractId: (json['contractId'] as num).toInt(),
      memberId: (json['memberId'] as num).toInt(),
      trainerId: (json['trainerId'] as num).toInt(),
      memberName: json['memberName'] as String,
      trainerName: json['trainerName'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      status: json['status'] as String,
      changeRequestStartTime: json['changeRequestStartTime'] as String?,
      changeRequestEndTime: json['changeRequestEndTime'] as String?,
      changeRequestBy: json['changeRequestBy'] as String?,
      changeRequestStatus: json['changeRequestStatus'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PtAppointmentImplToJson(_$PtAppointmentImpl instance) =>
    <String, dynamic>{
      'appointmentId': instance.appointmentId,
      'contractId': instance.contractId,
      'memberId': instance.memberId,
      'trainerId': instance.trainerId,
      'memberName': instance.memberName,
      'trainerName': instance.trainerName,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'status': instance.status,
      'changeRequestStartTime': instance.changeRequestStartTime,
      'changeRequestEndTime': instance.changeRequestEndTime,
      'changeRequestBy': instance.changeRequestBy,
      'changeRequestStatus': instance.changeRequestStatus,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$PtAppointmentsResponseImpl _$$PtAppointmentsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PtAppointmentsResponseImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => PtAppointment.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalElements: (json['totalElements'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      currentPage: (json['currentPage'] as num).toInt(),
      hasNext: json['hasNext'] as bool,
      hasPrevious: json['hasPrevious'] as bool,
    );

Map<String, dynamic> _$$PtAppointmentsResponseImplToJson(
        _$PtAppointmentsResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'currentPage': instance.currentPage,
      'hasNext': instance.hasNext,
      'hasPrevious': instance.hasPrevious,
    };

_$AppointmentStatusUpdateImpl _$$AppointmentStatusUpdateImplFromJson(
        Map<String, dynamic> json) =>
    _$AppointmentStatusUpdateImpl(
      status: json['status'] as String,
    );

Map<String, dynamic> _$$AppointmentStatusUpdateImplToJson(
        _$AppointmentStatusUpdateImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
    };

_$AppointmentChangeRequestImpl _$$AppointmentChangeRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$AppointmentChangeRequestImpl(
      newStartTime: json['newStartTime'] as String,
      newEndTime: json['newEndTime'] as String,
    );

Map<String, dynamic> _$$AppointmentChangeRequestImplToJson(
        _$AppointmentChangeRequestImpl instance) =>
    <String, dynamic>{
      'newStartTime': instance.newStartTime,
      'newEndTime': instance.newEndTime,
    };

_$AppointmentCreateRequestImpl _$$AppointmentCreateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$AppointmentCreateRequestImpl(
      contractId: (json['contractId'] as num).toInt(),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
    );

Map<String, dynamic> _$$AppointmentCreateRequestImplToJson(
        _$AppointmentCreateRequestImpl instance) =>
    <String, dynamic>{
      'contractId': instance.contractId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };
