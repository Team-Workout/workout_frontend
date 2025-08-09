// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemberProfileImpl _$$MemberProfileImplFromJson(Map<String, dynamic> json) =>
    _$MemberProfileImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      height: (json['height'] as num?)?.toDouble(),
      currentWeight: (json['currentWeight'] as num?)?.toDouble(),
      targetWeight: (json['targetWeight'] as num?)?.toDouble(),
      medicalHistory: json['medicalHistory'] as String?,
      notes: json['notes'] as String?,
      joinDate: DateTime.parse(json['joinDate'] as String),
      totalSessions: (json['totalSessions'] as num).toInt(),
      monthSessions: (json['monthSessions'] as num).toInt(),
      assignedTrainerId: json['assignedTrainerId'] as String?,
      weightHistory: (json['weightHistory'] as List<dynamic>?)
              ?.map((e) => WeightRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MemberProfileImplToJson(_$MemberProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'birthDate': instance.birthDate?.toIso8601String(),
      'height': instance.height,
      'currentWeight': instance.currentWeight,
      'targetWeight': instance.targetWeight,
      'medicalHistory': instance.medicalHistory,
      'notes': instance.notes,
      'joinDate': instance.joinDate.toIso8601String(),
      'totalSessions': instance.totalSessions,
      'monthSessions': instance.monthSessions,
      'assignedTrainerId': instance.assignedTrainerId,
      'weightHistory': instance.weightHistory,
    };

_$WeightRecordImpl _$$WeightRecordImplFromJson(Map<String, dynamic> json) =>
    _$WeightRecordImpl(
      date: DateTime.parse(json['date'] as String),
      weight: (json['weight'] as num).toDouble(),
    );

Map<String, dynamic> _$$WeightRecordImplToJson(_$WeightRecordImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'weight': instance.weight,
    };
