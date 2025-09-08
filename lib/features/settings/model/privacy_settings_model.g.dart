// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PrivacySettingsImpl _$$PrivacySettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$PrivacySettingsImpl(
      isOpenWorkoutRecord: json['isOpenWorkoutRecord'] as bool,
      isOpenBodyImg: json['isOpenBodyImg'] as bool,
      isOpenBodyComposition: json['isOpenBodyComposition'] as bool,
    );

Map<String, dynamic> _$$PrivacySettingsImplToJson(
        _$PrivacySettingsImpl instance) =>
    <String, dynamic>{
      'isOpenWorkoutRecord': instance.isOpenWorkoutRecord,
      'isOpenBodyImg': instance.isOpenBodyImg,
      'isOpenBodyComposition': instance.isOpenBodyComposition,
    };

_$MemberInfoImpl _$$MemberInfoImplFromJson(Map<String, dynamic> json) =>
    _$MemberInfoImpl(
      name: json['name'] as String,
      email: json['email'] as String,
      isOpenWorkoutRecord: json['isOpenWorkoutRecord'] as bool,
      isOpenBodyImg: json['isOpenBodyImg'] as bool,
      isOpenBodyComposition: json['IsOpenBodyComposition'] as bool,
      gymName: json['GymName'] as String,
    );

Map<String, dynamic> _$$MemberInfoImplToJson(_$MemberInfoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'isOpenWorkoutRecord': instance.isOpenWorkoutRecord,
      'isOpenBodyImg': instance.isOpenBodyImg,
      'IsOpenBodyComposition': instance.isOpenBodyComposition,
      'GymName': instance.gymName,
    };
