import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_models.freezed.dart';
part 'sync_models.g.dart';

enum DataCategory {
  @JsonValue('EXERCISE')
  exercise,
  @JsonValue('MUSCLE')
  muscle,
  @JsonValue('EXERCISE_TARGET_MUSCLE')
  exerciseTargetMuscle,
}

enum MuscleRole {
  @JsonValue('PRIMARY')
  primary,
  @JsonValue('SECONDARY')
  secondary,
}

enum MuscleGroup {
  @JsonValue('CHEST')
  chest,
  @JsonValue('BACK')
  back,
  @JsonValue('SHOULDERS')
  shoulders,
  @JsonValue('SHOULDER')
  shoulder,
  @JsonValue('ARMS')
  arms,
  @JsonValue('LEGS')
  legs,
  @JsonValue('CORE')
  core,
  @JsonValue('ABS')
  abs,
}

@freezed
class VersionCheckRequest with _$VersionCheckRequest {
  const factory VersionCheckRequest({
    required Map<String, int> versions,
  }) = _VersionCheckRequest;

  factory VersionCheckRequest.fromJson(Map<String, dynamic> json) =>
      _$VersionCheckRequestFromJson(json);
}

@freezed
class Exercise with _$Exercise {
  const factory Exercise({
    required int exerciseId,
    required String name,
    required List<TargetMuscle> targetMuscles,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);
}

@freezed
class TargetMuscle with _$TargetMuscle {
  const factory TargetMuscle({
    required int muscleId,
    required String name,
    required MuscleRole role,
  }) = _TargetMuscle;

  factory TargetMuscle.fromJson(Map<String, dynamic> json) =>
      _$TargetMuscleFromJson(json);
}

@freezed
class Muscle with _$Muscle {
  const factory Muscle({
    required int muscleId,
    required String name,
    required String koreanName,
    required MuscleGroup muscleGroup,
  }) = _Muscle;

  factory Muscle.fromJson(Map<String, dynamic> json) => _$MuscleFromJson(json);
}

@freezed
class ExerciseTargetMuscleMapping with _$ExerciseTargetMuscleMapping {
  const factory ExerciseTargetMuscleMapping({
    required int mappingId,
    required int exerciseId,
    required int muscleId,
    required MuscleRole muscleRole,
  }) = _ExerciseTargetMuscleMapping;

  factory ExerciseTargetMuscleMapping.fromJson(Map<String, dynamic> json) =>
      _$ExerciseTargetMuscleMappingFromJson(json);
}
