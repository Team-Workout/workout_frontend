import 'package:freezed_annotation/freezed_annotation.dart';

part 'pt_session_models.freezed.dart';
part 'pt_session_models.g.dart';

@freezed
class PtSessionCreate with _$PtSessionCreate {
  const factory PtSessionCreate({
    required int appointmentId,
    required WorkoutLogCreate workoutLog,
  }) = _PtSessionCreate;

  factory PtSessionCreate.fromJson(Map<String, dynamic> json) =>
      _$PtSessionCreateFromJson(json);
}

@freezed
class WorkoutLogCreate with _$WorkoutLogCreate {
  const factory WorkoutLogCreate({
    required String workoutDate,
    required String logFeedback,
    required List<WorkoutExerciseCreate> workoutExercises,
  }) = _WorkoutLogCreate;

  factory WorkoutLogCreate.fromJson(Map<String, dynamic> json) =>
      _$WorkoutLogCreateFromJson(json);
}

@freezed
class WorkoutExerciseCreate with _$WorkoutExerciseCreate {
  const factory WorkoutExerciseCreate({
    required int exerciseId,
    required int order,
    required List<WorkoutSetCreate> workoutSets,
  }) = _WorkoutExerciseCreate;

  factory WorkoutExerciseCreate.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExerciseCreateFromJson(json);
}

@freezed
class WorkoutSetCreate with _$WorkoutSetCreate {
  const factory WorkoutSetCreate({
    required int order,
    required double weight,
    required int reps,
    String? feedback,
  }) = _WorkoutSetCreate;

  factory WorkoutSetCreate.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSetCreateFromJson(json);
}

// 기존 모델들 (응답 파싱용)
@freezed
class WorkoutLogEntry with _$WorkoutLogEntry {
  const factory WorkoutLogEntry({
    required int exerciseId,
    required List<WorkoutSet> sets,
    String? notes,
  }) = _WorkoutLogEntry;

  factory WorkoutLogEntry.fromJson(Map<String, dynamic> json) =>
      _$WorkoutLogEntryFromJson(json);
}

@freezed
class WorkoutSet with _$WorkoutSet {
  const factory WorkoutSet({
    required int reps,
    required double weight,
    int? duration,
  }) = _WorkoutSet;

  factory WorkoutSet.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSetFromJson(json);
}

@freezed
class PtSession with _$PtSession {
  const factory PtSession({
    required int ptSessionId,
    required int appointmentId,
    required String sessionDate,
    required String notes,
    required List<WorkoutLogEntry> workoutLogs,
    required DateTime createdAt,
  }) = _PtSession;

  factory PtSession.fromJson(Map<String, dynamic> json) =>
      _$PtSessionFromJson(json);
}