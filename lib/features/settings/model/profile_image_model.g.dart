// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImageResponseImpl _$$ProfileImageResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileImageResponseImpl(
      fileId: (json['fileId'] as num).toInt(),
      fileUrl: json['fileUrl'] as String,
      originalFileName: json['originalFileName'] as String,
      recordDate: json['recordDate'] as String?,
    );

Map<String, dynamic> _$$ProfileImageResponseImplToJson(
        _$ProfileImageResponseImpl instance) =>
    <String, dynamic>{
      'fileId': instance.fileId,
      'fileUrl': instance.fileUrl,
      'originalFileName': instance.originalFileName,
      'recordDate': instance.recordDate,
    };

_$ProfileImageInfoImpl _$$ProfileImageInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileImageInfoImpl(
      profileImageUrl: json['profileImageUrl'] as String,
    );

Map<String, dynamic> _$$ProfileImageInfoImplToJson(
        _$ProfileImageInfoImpl instance) =>
    <String, dynamic>{
      'profileImageUrl': instance.profileImageUrl,
    };
