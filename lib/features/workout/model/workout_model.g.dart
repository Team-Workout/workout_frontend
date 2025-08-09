// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkoutRecordImpl _$$WorkoutRecordImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutRecordImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      type: $enumDecode(_$WorkoutTypeEnumMap, json['type']),
      duration: (json['duration'] as num).toInt(),
      description: json['description'] as String?,
      trainerId: json['trainerId'] as String?,
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) => Exercise.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WorkoutRecordImplToJson(_$WorkoutRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'date': instance.date.toIso8601String(),
      'type': _$WorkoutTypeEnumMap[instance.type]!,
      'duration': instance.duration,
      'description': instance.description,
      'trainerId': instance.trainerId,
      'exercises': instance.exercises,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$WorkoutTypeEnumMap = {
  WorkoutType.fullBody: 'full_body',
  WorkoutType.upperBody: 'upper_body',
  WorkoutType.lowerBody: 'lower_body',
  WorkoutType.cardio: 'cardio',
  WorkoutType.flexibility: 'flexibility',
};

_$ExerciseImpl _$$ExerciseImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseImpl(
      name: json['name'] as String,
      sets: (json['sets'] as num).toInt(),
      reps: (json['reps'] as num).toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$ExerciseImplToJson(_$ExerciseImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'sets': instance.sets,
      'reps': instance.reps,
      'weight': instance.weight,
      'notes': instance.notes,
    };
