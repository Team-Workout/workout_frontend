// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PtApplicationImpl _$$PtApplicationImplFromJson(Map<String, dynamic> json) =>
    _$PtApplicationImpl(
      applicationId: _parseApplicationId(json['applicationId']),
      memberName: json['memberName'] as String,
      trainerName: json['trainerName'] as String?,
      appliedAt: json['appliedAt'] as String,
      totalSessions: _parseTotalSessions(json['totalSessions']),
      offeringTitle: json['offeringTitle'] as String?,
    );

Map<String, dynamic> _$$PtApplicationImplToJson(_$PtApplicationImpl instance) =>
    <String, dynamic>{
      'applicationId': instance.applicationId,
      'memberName': instance.memberName,
      'trainerName': instance.trainerName,
      'appliedAt': instance.appliedAt,
      'totalSessions': instance.totalSessions,
      'offeringTitle': instance.offeringTitle,
    };

_$CreatePtApplicationRequestImpl _$$CreatePtApplicationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreatePtApplicationRequestImpl(
      offeringId: (json['offeringId'] as num).toInt(),
    );

Map<String, dynamic> _$$CreatePtApplicationRequestImplToJson(
        _$CreatePtApplicationRequestImpl instance) =>
    <String, dynamic>{
      'offeringId': instance.offeringId,
    };

_$PtApplicationsResponseImpl _$$PtApplicationsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PtApplicationsResponseImpl(
      applications: (json['applications'] as List<dynamic>)
          .map((e) => PtApplication.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PtApplicationsResponseImplToJson(
        _$PtApplicationsResponseImpl instance) =>
    <String, dynamic>{
      'applications': instance.applications,
    };
