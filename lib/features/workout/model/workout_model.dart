import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_model.freezed.dart';
part 'workout_model.g.dart';

enum WorkoutType {
  @JsonValue('full_body')
  fullBody,
  @JsonValue('upper_body')
  upperBody,
  @JsonValue('lower_body')
  lowerBody,
  @JsonValue('cardio')
  cardio,
  @JsonValue('flexibility')
  flexibility,
}

@freezed
class WorkoutRecord with _$WorkoutRecord {
  const factory WorkoutRecord({
    required String id,
    required String userId,
    required String title,
    required DateTime date,
    required WorkoutType type,
    required int duration,
    String? description,
    String? trainerId,
    @Default([]) List<Exercise> exercises,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WorkoutRecord;

  factory WorkoutRecord.fromJson(Map<String, dynamic> json) =>
      _$WorkoutRecordFromJson(json);
}

@freezed
class Exercise with _$Exercise {
  const factory Exercise({
    required String name,
    required int sets,
    required int reps,
    double? weight,
    String? notes,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);
}