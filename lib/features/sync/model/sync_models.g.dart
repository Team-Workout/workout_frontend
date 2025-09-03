// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VersionCheckRequestImpl _$$VersionCheckRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$VersionCheckRequestImpl(
      versions: Map<String, int>.from(json['versions'] as Map),
    );

Map<String, dynamic> _$$VersionCheckRequestImplToJson(
        _$VersionCheckRequestImpl instance) =>
    <String, dynamic>{
      'versions': instance.versions,
    };

_$ExerciseImpl _$$ExerciseImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseImpl(
      exerciseId: (json['exerciseId'] as num).toInt(),
      name: json['name'] as String,
      targetMuscles: (json['targetMuscles'] as List<dynamic>)
          .map((e) => TargetMuscle.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ExerciseImplToJson(_$ExerciseImpl instance) =>
    <String, dynamic>{
      'exerciseId': instance.exerciseId,
      'name': instance.name,
      'targetMuscles': instance.targetMuscles,
    };

_$TargetMuscleImpl _$$TargetMuscleImplFromJson(Map<String, dynamic> json) =>
    _$TargetMuscleImpl(
      muscleId: (json['muscleId'] as num).toInt(),
      name: json['name'] as String,
      role: $enumDecode(_$MuscleRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$$TargetMuscleImplToJson(_$TargetMuscleImpl instance) =>
    <String, dynamic>{
      'muscleId': instance.muscleId,
      'name': instance.name,
      'role': _$MuscleRoleEnumMap[instance.role]!,
    };

const _$MuscleRoleEnumMap = {
  MuscleRole.primary: 'PRIMARY',
  MuscleRole.secondary: 'SECONDARY',
};

_$MuscleImpl _$$MuscleImplFromJson(Map<String, dynamic> json) => _$MuscleImpl(
      muscleId: (json['muscleId'] as num).toInt(),
      name: json['name'] as String,
      koreanName: json['koreanName'] as String,
      muscleGroup: $enumDecode(_$MuscleGroupEnumMap, json['muscleGroup']),
    );

Map<String, dynamic> _$$MuscleImplToJson(_$MuscleImpl instance) =>
    <String, dynamic>{
      'muscleId': instance.muscleId,
      'name': instance.name,
      'koreanName': instance.koreanName,
      'muscleGroup': _$MuscleGroupEnumMap[instance.muscleGroup]!,
    };

const _$MuscleGroupEnumMap = {
  MuscleGroup.chest: 'CHEST',
  MuscleGroup.back: 'BACK',
  MuscleGroup.shoulders: 'SHOULDERS',
  MuscleGroup.shoulder: 'SHOULDER',
  MuscleGroup.arms: 'ARMS',
  MuscleGroup.legs: 'LEGS',
  MuscleGroup.core: 'CORE',
  MuscleGroup.abs: 'ABS',
};

_$ExerciseTargetMuscleMappingImpl _$$ExerciseTargetMuscleMappingImplFromJson(
        Map<String, dynamic> json) =>
    _$ExerciseTargetMuscleMappingImpl(
      mappingId: (json['mappingId'] as num).toInt(),
      exerciseId: (json['exerciseId'] as num).toInt(),
      muscleId: (json['muscleId'] as num).toInt(),
      muscleRole: $enumDecode(_$MuscleRoleEnumMap, json['muscleRole']),
    );

Map<String, dynamic> _$$ExerciseTargetMuscleMappingImplToJson(
        _$ExerciseTargetMuscleMappingImpl instance) =>
    <String, dynamic>{
      'mappingId': instance.mappingId,
      'exerciseId': instance.exerciseId,
      'muscleId': instance.muscleId,
      'muscleRole': _$MuscleRoleEnumMap[instance.muscleRole]!,
    };
