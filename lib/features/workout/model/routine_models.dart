import 'package:freezed_annotation/freezed_annotation.dart';

part 'routine_models.freezed.dart';
part 'routine_models.g.dart';

@freezed
class CreateRoutineRequest with _$CreateRoutineRequest {
  const factory CreateRoutineRequest({
    String? name,
    String? description,
    required List<RoutineExercise> routineExercises,
  }) = _CreateRoutineRequest;

  factory CreateRoutineRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateRoutineRequestFromJson(json);
}

@freezed
class RoutineExercise with _$RoutineExercise {
  const factory RoutineExercise({
    int? routineExerciseId,
    int? exerciseId,
    String? exerciseName,
    required int order,
    required List<RoutineSet> routineSets,
  }) = _RoutineExercise;

  factory RoutineExercise.fromJson(Map<String, dynamic> json) =>
      _$RoutineExerciseFromJson(json);
}

@freezed
class RoutineSet with _$RoutineSet {
  const factory RoutineSet({
    int? workoutSetId,
    required int order,
    required double weight,
    required int reps,
  }) = _RoutineSet;

  factory RoutineSet.fromJson(Map<String, dynamic> json) =>
      _$RoutineSetFromJson(json);
}

@freezed
class RoutineResponse with _$RoutineResponse {
  const factory RoutineResponse({
    @JsonKey(name: 'routineId') required int id,
    @JsonKey(name: 'routineName') required String name,
    String? description,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<RoutineExercise>? routineExercises,
  }) = _RoutineResponse;

  factory RoutineResponse.fromJson(Map<String, dynamic> json) =>
      _$RoutineResponseFromJson(json);
}