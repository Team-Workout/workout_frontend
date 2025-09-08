import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_settings_model.freezed.dart';
part 'privacy_settings_model.g.dart';

@freezed
class PrivacySettings with _$PrivacySettings {
  const factory PrivacySettings({
    required bool isOpenWorkoutRecord,
    required bool isOpenBodyImg,
    required bool isOpenBodyComposition,
  }) = _PrivacySettings;

  factory PrivacySettings.fromJson(Map<String, dynamic> json) =>
      _$PrivacySettingsFromJson(json);
}

@freezed
class MemberInfo with _$MemberInfo {
  const factory MemberInfo({
    required String name,
    required String email,
    required bool isOpenWorkoutRecord,
    required bool isOpenBodyImg,
    @JsonKey(name: 'IsOpenBodyComposition') required bool isOpenBodyComposition,
    @JsonKey(name: 'GymName') required String gymName,
  }) = _MemberInfo;

  factory MemberInfo.fromJson(Map<String, dynamic> json) =>
      _$MemberInfoFromJson(json);
}