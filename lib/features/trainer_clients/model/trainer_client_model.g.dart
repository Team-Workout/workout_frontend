// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trainer_client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrainerClientImpl _$$TrainerClientImplFromJson(Map<String, dynamic> json) =>
    _$TrainerClientImpl(
      id: (json['id'] as num).toInt(),
      gymId: (json['gymId'] as num).toInt(),
      gymName: json['gymName'] as String,
      name: json['name'] as String,
      gender: json['gender'] as String,
      email: json['email'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
    );

Map<String, dynamic> _$$TrainerClientImplToJson(_$TrainerClientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gymId': instance.gymId,
      'gymName': instance.gymName,
      'name': instance.name,
      'gender': instance.gender,
      'email': instance.email,
      'profileImageUrl': instance.profileImageUrl,
    };

_$TrainerClientResponseImpl _$$TrainerClientResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TrainerClientResponseImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => TrainerClient.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageInfo: PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TrainerClientResponseImplToJson(
        _$TrainerClientResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'pageInfo': instance.pageInfo,
    };

_$PageInfoImpl _$$PageInfoImplFromJson(Map<String, dynamic> json) =>
    _$PageInfoImpl(
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      totalElements: (json['totalElements'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      last: json['last'] as bool,
    );

Map<String, dynamic> _$$PageInfoImplToJson(_$PageInfoImpl instance) =>
    <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'last': instance.last,
    };

_$MemberBodyImageImpl _$$MemberBodyImageImplFromJson(
        Map<String, dynamic> json) =>
    _$MemberBodyImageImpl(
      fileId: (json['fileId'] as num).toInt(),
      fileUrl: json['fileUrl'] as String,
      originalFileName: json['originalFileName'] as String?,
      recordDate: json['recordDate'] as String,
    );

Map<String, dynamic> _$$MemberBodyImageImplToJson(
        _$MemberBodyImageImpl instance) =>
    <String, dynamic>{
      'fileId': instance.fileId,
      'fileUrl': instance.fileUrl,
      'originalFileName': instance.originalFileName,
      'recordDate': instance.recordDate,
    };

_$MemberBodyImageResponseImpl _$$MemberBodyImageResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$MemberBodyImageResponseImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => MemberBodyImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageInfo: PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MemberBodyImageResponseImplToJson(
        _$MemberBodyImageResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'pageInfo': instance.pageInfo,
    };

_$MemberBodyCompositionImpl _$$MemberBodyCompositionImplFromJson(
        Map<String, dynamic> json) =>
    _$MemberBodyCompositionImpl(
      id: (json['id'] as num).toInt(),
      measurementDate: json['measurementDate'] as String,
      weightKg: _doubleFromJson(json['weightKg']),
      fatKg: _doubleFromJson(json['fatKg']),
      muscleMassKg: _doubleFromJson(json['muscleMassKg']),
    );

Map<String, dynamic> _$$MemberBodyCompositionImplToJson(
        _$MemberBodyCompositionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'measurementDate': instance.measurementDate,
      'weightKg': instance.weightKg,
      'fatKg': instance.fatKg,
      'muscleMassKg': instance.muscleMassKg,
    };

_$MemberBodyCompositionResponseImpl
    _$$MemberBodyCompositionResponseImplFromJson(Map<String, dynamic> json) =>
        _$MemberBodyCompositionResponseImpl(
          data: (json['data'] as List<dynamic>)
              .map((e) =>
                  MemberBodyComposition.fromJson(e as Map<String, dynamic>))
              .toList(),
          pageInfo: PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$$MemberBodyCompositionResponseImplToJson(
        _$MemberBodyCompositionResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'pageInfo': instance.pageInfo,
    };
