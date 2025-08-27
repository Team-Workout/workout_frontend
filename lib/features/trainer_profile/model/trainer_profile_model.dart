import 'package:freezed_annotation/freezed_annotation.dart';

part 'trainer_profile_model.freezed.dart';
part 'trainer_profile_model.g.dart';

@freezed
class TrainerProfile with _$TrainerProfile {
  const factory TrainerProfile({
    int? trainerId,
    String? name,
    String? email,
    @Default('') String introduction,
    @Default([]) List<Award> awards,
    @Default([]) List<Certification> certifications,
    @Default([]) List<Education> educations,
    @Default([]) List<WorkExperience> workExperiences,
    @Default([]) List<String> specialties,
  }) = _TrainerProfile;

  factory TrainerProfile.fromJson(Map<String, dynamic> json) =>
      _$TrainerProfileFromJson(json);
      
  factory TrainerProfile.empty() => const TrainerProfile();
}

@freezed
class Award with _$Award {
  const factory Award({
    int? id,
    required String awardName,
    required String awardDate,
    required String awardPlace,
  }) = _Award;

  factory Award.fromJson(Map<String, dynamic> json) =>
      _$AwardFromJson(json);
      
  factory Award.empty() => Award(
    awardName: '',
    awardDate: DateTime.now().toIso8601String().split('T')[0],
    awardPlace: '',
  );
}

@freezed
class Certification with _$Certification {
  const factory Certification({
    int? id,
    required String certificationName,
    required String issuingOrganization,
    required String acquisitionDate,
  }) = _Certification;

  factory Certification.fromJson(Map<String, dynamic> json) =>
      _$CertificationFromJson(json);
      
  factory Certification.empty() => Certification(
    certificationName: '',
    issuingOrganization: '',
    acquisitionDate: DateTime.now().toIso8601String().split('T')[0],
  );
}

@freezed
class Education with _$Education {
  const factory Education({
    int? id,
    required String schoolName,
    required String educationName,
    required String degree,
    required String startDate,
    String? endDate,
  }) = _Education;

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);
      
  factory Education.empty() => Education(
    schoolName: '',
    educationName: '',
    degree: '',
    startDate: DateTime.now().toIso8601String().split('T')[0],
  );
}

@freezed
class WorkExperience with _$WorkExperience {
  const factory WorkExperience({
    int? id,
    required String workName,
    required String workStartDate,
    String? workEndDate,
    required String workPlace,
    required String workPosition,
  }) = _WorkExperience;

  factory WorkExperience.fromJson(Map<String, dynamic> json) =>
      _$WorkExperienceFromJson(json);
      
  factory WorkExperience.empty() => WorkExperience(
    workName: '',
    workStartDate: DateTime.now().toIso8601String().split('T')[0],
    workPlace: '',
    workPosition: '',
  );
}