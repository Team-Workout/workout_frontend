import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_profile_model.freezed.dart';
part 'member_profile_model.g.dart';

@freezed
class MemberProfile with _$MemberProfile {
  const factory MemberProfile({
    required String id,
    required String email,
    required String name,
    String? phoneNumber,
    DateTime? birthDate,
    double? height,
    double? currentWeight,
    double? targetWeight,
    String? medicalHistory,
    String? notes,
    required DateTime joinDate,
    required int totalSessions,
    required int monthSessions,
    String? assignedTrainerId,
    @Default([]) List<WeightRecord> weightHistory,
  }) = _MemberProfile;

  factory MemberProfile.fromJson(Map<String, dynamic> json) =>
      _$MemberProfileFromJson(json);
}

@freezed
class WeightRecord with _$WeightRecord {
  const factory WeightRecord({
    required DateTime date,
    required double weight,
  }) = _WeightRecord;

  factory WeightRecord.fromJson(Map<String, dynamic> json) =>
      _$WeightRecordFromJson(json);
}