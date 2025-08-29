import 'package:freezed_annotation/freezed_annotation.dart';

part 'pt_session_models.freezed.dart';
part 'pt_session_models.g.dart';

@freezed
class PtSessionCreate with _$PtSessionCreate {
  const factory PtSessionCreate({
    required int appointmentId,
    required String sessionDate,
    required String notes,
    required List<WorkoutLogEntry> workoutLogs,
  }) = _PtSessionCreate;

  factory PtSessionCreate.fromJson(Map<String, dynamic> json) =>
      _$PtSessionCreateFromJson(json);
}

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