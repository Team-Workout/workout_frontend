// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateRoutineRequestImpl _$$CreateRoutineRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateRoutineRequestImpl(
      name: json['name'] as String,
      description: json['description'] as String?,
      routineExercises: (json['routineExercises'] as List<dynamic>)
          .map((e) => RoutineExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CreateRoutineRequestImplToJson(
        _$CreateRoutineRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'routineExercises': instance.routineExercises,
    };

_$RoutineExerciseImpl _$$RoutineExerciseImplFromJson(
        Map<String, dynamic> json) =>
    _$RoutineExerciseImpl(
      routineExerciseId: (json['routineExerciseId'] as num?)?.toInt(),
      exerciseId: (json['exerciseId'] as num?)?.toInt(),
      exerciseName: json['exerciseName'] as String?,
      order: (json['order'] as num).toInt(),
      routineSets: (json['routineSets'] as List<dynamic>)
          .map((e) => RoutineSet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RoutineExerciseImplToJson(
        _$RoutineExerciseImpl instance) =>
    <String, dynamic>{
      'routineExerciseId': instance.routineExerciseId,
      'exerciseId': instance.exerciseId,
      'exerciseName': instance.exerciseName,
      'order': instance.order,
      'routineSets': instance.routineSets,
    };

_$RoutineSetImpl _$$RoutineSetImplFromJson(Map<String, dynamic> json) =>
    _$RoutineSetImpl(
      workoutSetId: (json['workoutSetId'] as num?)?.toInt(),
      order: (json['order'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
      reps: (json['reps'] as num).toInt(),
    );

Map<String, dynamic> _$$RoutineSetImplToJson(_$RoutineSetImpl instance) =>
    <String, dynamic>{
      'workoutSetId': instance.workoutSetId,
      'order': instance.order,
      'weight': instance.weight,
      'reps': instance.reps,
    };

_$RoutineResponseImpl _$$RoutineResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RoutineResponseImpl(
      id: (json['routineId'] as num).toInt(),
      name: json['routineName'] as String,
      description: json['description'] as String?,
      userId: json['userId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      routineExercises: (json['routineExercises'] as List<dynamic>?)
          ?.map((e) => RoutineExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RoutineResponseImplToJson(
        _$RoutineResponseImpl instance) =>
    <String, dynamic>{
      'routineId': instance.id,
      'routineName': instance.name,
      'description': instance.description,
      'userId': instance.userId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'routineExercises': instance.routineExercises,
    };
