// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trainer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrainerImpl _$$TrainerImplFromJson(Map<String, dynamic> json) =>
    _$TrainerImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      specialization: json['specialization'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      profileImageUrl: json['profileImageUrl'] as String,
      pricePerSession: (json['pricePerSession'] as num).toInt(),
      description: json['description'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      yearsOfExperience: (json['yearsOfExperience'] as num).toInt(),
      isFeatured: json['isFeatured'] as bool,
      certifications: (json['certifications'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$TrainerImplToJson(_$TrainerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'specialization': instance.specialization,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'profileImageUrl': instance.profileImageUrl,
      'pricePerSession': instance.pricePerSession,
      'description': instance.description,
      'tags': instance.tags,
      'yearsOfExperience': instance.yearsOfExperience,
      'isFeatured': instance.isFeatured,
      'certifications': instance.certifications,
    };

_$AwardImpl _$$AwardImplFromJson(Map<String, dynamic> json) => _$AwardImpl(
      id: (json['id'] as num).toInt(),
      awardName: json['awardName'] as String? ?? '',
      awardDate: json['awardDate'] as String? ?? '',
      awardPlace: json['awardPlace'] as String? ?? '',
    );

Map<String, dynamic> _$$AwardImplToJson(_$AwardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'awardName': instance.awardName,
      'awardDate': instance.awardDate,
      'awardPlace': instance.awardPlace,
    };

_$CertificationImpl _$$CertificationImplFromJson(Map<String, dynamic> json) =>
    _$CertificationImpl(
      id: (json['id'] as num).toInt(),
      certificationName: json['certificationName'] as String? ?? '',
      issuingOrganization: json['issuingOrganization'] as String? ?? '',
      acquisitionDate: json['acquisitionDate'] as String? ?? '',
    );

Map<String, dynamic> _$$CertificationImplToJson(_$CertificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'certificationName': instance.certificationName,
      'issuingOrganization': instance.issuingOrganization,
      'acquisitionDate': instance.acquisitionDate,
    };

_$EducationImpl _$$EducationImplFromJson(Map<String, dynamic> json) =>
    _$EducationImpl(
      id: (json['id'] as num).toInt(),
      schoolName: json['schoolName'] as String? ?? '',
      educationName: json['educationName'] as String? ?? '',
      degree: json['degree'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String?,
    );

Map<String, dynamic> _$$EducationImplToJson(_$EducationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'schoolName': instance.schoolName,
      'educationName': instance.educationName,
      'degree': instance.degree,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };

_$WorkExperienceImpl _$$WorkExperienceImplFromJson(Map<String, dynamic> json) =>
    _$WorkExperienceImpl(
      id: (json['id'] as num).toInt(),
      workName: json['workName'] as String? ?? '',
      workPlace: json['workPlace'] as String? ?? '',
      workPosition: json['workPosition'] as String? ?? '',
      workStart: json['workStart'] as String? ?? '',
      workEnd: json['workEnd'] as String?,
    );

Map<String, dynamic> _$$WorkExperienceImplToJson(
        _$WorkExperienceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workName': instance.workName,
      'workPlace': instance.workPlace,
      'workPosition': instance.workPosition,
      'workStart': instance.workStart,
      'workEnd': instance.workEnd,
    };

_$TrainerProfileImpl _$$TrainerProfileImplFromJson(Map<String, dynamic> json) =>
    _$TrainerProfileImpl(
      trainerId: (json['trainerId'] as num).toInt(),
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      introduction: json['introduction'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      awards: (json['awards'] as List<dynamic>?)
              ?.map((e) => Award.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => Certification.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      educations: (json['educations'] as List<dynamic>?)
              ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      workExperiences: (json['workExperiences'] as List<dynamic>?)
              ?.map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      specialties: (json['specialties'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TrainerProfileImplToJson(
        _$TrainerProfileImpl instance) =>
    <String, dynamic>{
      'trainerId': instance.trainerId,
      'name': instance.name,
      'email': instance.email,
      'introduction': instance.introduction,
      'profileImageUrl': instance.profileImageUrl,
      'awards': instance.awards,
      'certifications': instance.certifications,
      'educations': instance.educations,
      'workExperiences': instance.workExperiences,
      'specialties': instance.specialties,
    };

_$TrainerCategoryImpl _$$TrainerCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$TrainerCategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      isSelected: json['isSelected'] as bool,
    );

Map<String, dynamic> _$$TrainerCategoryImplToJson(
        _$TrainerCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isSelected': instance.isSelected,
    };
