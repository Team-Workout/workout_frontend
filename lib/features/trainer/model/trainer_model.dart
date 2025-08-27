import 'package:freezed_annotation/freezed_annotation.dart';

part 'trainer_model.freezed.dart';
part 'trainer_model.g.dart';

@freezed
class Trainer with _$Trainer {
  const factory Trainer({
    required String id,
    required String name,
    required String specialization,
    required double rating,
    required int reviewCount,
    required String profileImageUrl,
    required int pricePerSession,
    required String description,
    required List<String> tags,
    required int yearsOfExperience,
    required bool isFeatured,
    required List<String> certifications,
  }) = _Trainer;

  factory Trainer.fromJson(Map<String, dynamic> json) =>
      _$TrainerFromJson(json);
}

@freezed
class Award with _$Award {
  const factory Award({
    required int id,
    @Default('') String awardName,
    @Default('') String awardDate,
    @Default('') String awardPlace,
  }) = _Award;

  factory Award.fromJson(Map<String, dynamic> json) => _$AwardFromJson(json);
}

@freezed
class Certification with _$Certification {
  const factory Certification({
    required int id,
    @Default('') String certificationName,
    @Default('') String issuingOrganization,
    @Default('') String acquisitionDate,
  }) = _Certification;

  factory Certification.fromJson(Map<String, dynamic> json) =>
      _$CertificationFromJson(json);
}

@freezed
class Education with _$Education {
  const factory Education({
    required int id,
    @Default('') String schoolName,
    @Default('') String educationName,
    @Default('') String degree,
    @Default('') String startDate,
    String? endDate, // nullable in case of ongoing education
  }) = _Education;

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);
}

@freezed
class WorkExperience with _$WorkExperience {
  const factory WorkExperience({
    required int id,
    @Default('') String workName,
    @Default('') String workPlace,
    @Default('') String workPosition,
    @Default('') String workStart,
    String? workEnd, // null if currently working
  }) = _WorkExperience;

  factory WorkExperience.fromJson(Map<String, dynamic> json) =>
      _$WorkExperienceFromJson(json);
}

@freezed
class TrainerProfile with _$TrainerProfile {
  const factory TrainerProfile({
    required int trainerId,
    @Default('') String name,
    String? email, // nullable since it's not in API response
    String? introduction, // nullable
    String? profileImageUrl, // add this field from API
    @Default([]) List<Award> awards,
    @Default([]) List<Certification> certifications,
    @Default([]) List<Education> educations,
    @Default([]) List<WorkExperience> workExperiences,
    @Default([]) List<String> specialties,
  }) = _TrainerProfile;

  factory TrainerProfile.fromJson(Map<String, dynamic> json) =>
      _$TrainerProfileFromJson(json);
}

@freezed
class TrainerCategory with _$TrainerCategory {
  const factory TrainerCategory({
    required String id,
    required String name,
    required bool isSelected,
  }) = _TrainerCategory;

  factory TrainerCategory.fromJson(Map<String, dynamic> json) =>
      _$TrainerCategoryFromJson(json);
}