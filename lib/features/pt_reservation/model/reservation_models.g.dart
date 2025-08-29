// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReservationRequestImpl _$$ReservationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ReservationRequestImpl(
      id: json['id'] as String,
      memberId: json['memberId'] as String,
      memberName: json['memberName'] as String,
      trainerId: json['trainerId'] as String,
      trainerName: json['trainerName'] as String,
      requestedDateTime: DateTime.parse(json['requestedDateTime'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      type: $enumDecode(_$ReservationTypeEnumMap, json['type']),
      status: $enumDecode(_$ReservationStatusEnumMap, json['status']),
      message: json['message'] as String?,
      responseMessage: json['responseMessage'] as String?,
      responseAt: json['responseAt'] == null
          ? null
          : DateTime.parse(json['responseAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ReservationRequestImplToJson(
        _$ReservationRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberId': instance.memberId,
      'memberName': instance.memberName,
      'trainerId': instance.trainerId,
      'trainerName': instance.trainerName,
      'requestedDateTime': instance.requestedDateTime.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'type': _$ReservationTypeEnumMap[instance.type]!,
      'status': _$ReservationStatusEnumMap[instance.status]!,
      'message': instance.message,
      'responseMessage': instance.responseMessage,
      'responseAt': instance.responseAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ReservationTypeEnumMap = {
  ReservationType.request: 'REQUEST',
  ReservationType.recommendation: 'RECOMMENDATION',
};

const _$ReservationStatusEnumMap = {
  ReservationStatus.requested: 'REQUESTED',
  ReservationStatus.approved: 'APPROVED',
  ReservationStatus.rejected: 'REJECTED',
  ReservationStatus.cancelled: 'CANCELLED',
  ReservationStatus.completed: 'COMPLETED',
};

_$ReservationResponseImpl _$$ReservationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ReservationResponseImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => ReservationRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$$ReservationResponseImplToJson(
        _$ReservationResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'total': instance.total,
      'page': instance.page,
      'size': instance.size,
    };

_$CreateReservationRequestImpl _$$CreateReservationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateReservationRequestImpl(
      trainerId: json['trainerId'] as String,
      requestedDateTime: DateTime.parse(json['requestedDateTime'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      type: $enumDecode(_$ReservationTypeEnumMap, json['type']),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$CreateReservationRequestImplToJson(
        _$CreateReservationRequestImpl instance) =>
    <String, dynamic>{
      'trainerId': instance.trainerId,
      'requestedDateTime': instance.requestedDateTime.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'type': _$ReservationTypeEnumMap[instance.type]!,
      'message': instance.message,
    };

_$ReservationRecommendationImpl _$$ReservationRecommendationImplFromJson(
        Map<String, dynamic> json) =>
    _$ReservationRecommendationImpl(
      id: json['id'] as String,
      trainerId: json['trainerId'] as String,
      trainerName: json['trainerName'] as String,
      memberId: json['memberId'] as String,
      memberName: json['memberName'] as String,
      recommendedDateTime:
          DateTime.parse(json['recommendedDateTime'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      status: $enumDecode(_$ReservationStatusEnumMap, json['status']),
      message: json['message'] as String?,
      responseMessage: json['responseMessage'] as String?,
      responseAt: json['responseAt'] == null
          ? null
          : DateTime.parse(json['responseAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ReservationRecommendationImplToJson(
        _$ReservationRecommendationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trainerId': instance.trainerId,
      'trainerName': instance.trainerName,
      'memberId': instance.memberId,
      'memberName': instance.memberName,
      'recommendedDateTime': instance.recommendedDateTime.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'status': _$ReservationStatusEnumMap[instance.status]!,
      'message': instance.message,
      'responseMessage': instance.responseMessage,
      'responseAt': instance.responseAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$RecommendationResponseImpl _$$RecommendationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendationResponseImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) =>
              ReservationRecommendation.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$$RecommendationResponseImplToJson(
        _$RecommendationResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'total': instance.total,
      'page': instance.page,
      'size': instance.size,
    };
