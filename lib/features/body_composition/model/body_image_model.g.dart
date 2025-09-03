// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BodyImageResponseImpl _$$BodyImageResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$BodyImageResponseImpl(
      fileId: (json['fileId'] as num).toInt(),
      fileUrl: json['fileUrl'] as String,
      originalFileName: json['originalFileName'] as String,
      recordDate: json['recordDate'] as String,
    );

Map<String, dynamic> _$$BodyImageResponseImplToJson(
        _$BodyImageResponseImpl instance) =>
    <String, dynamic>{
      'fileId': instance.fileId,
      'fileUrl': instance.fileUrl,
      'originalFileName': instance.originalFileName,
      'recordDate': instance.recordDate,
    };
