import 'package:freezed_annotation/freezed_annotation.dart';

part 'pt_session_model.freezed.dart';
part 'pt_session_model.g.dart';

@freezed
class PtSessionListResponse with _$PtSessionListResponse {
  const factory PtSessionListResponse({
    required List<PtSessionResponse> data,
    required PageInfo pageInfo,
  }) = _PtSessionListResponse;

  factory PtSessionListResponse.fromJson(Map<String, dynamic> json) =>
      _$PtSessionListResponseFromJson(json);
}

@freezed
class PtSessionResponse with _$PtSessionResponse {
  const factory PtSessionResponse({
    required int id,
    WorkoutLogResponse? workoutLogResponse,
  }) = _PtSessionResponse;

  factory PtSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$PtSessionResponseFromJson(json);
}

@freezed
class WorkoutLogResponse with _$WorkoutLogResponse {
  const factory WorkoutLogResponse({
    required int workoutLogId,
    required String workoutDate,
    @Default([]) List<FeedbackResponse> feedbacks,
    @Default([]) List<WorkoutExerciseResponse> workoutExercises,
  }) = _WorkoutLogResponse;

  factory WorkoutLogResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkoutLogResponseFromJson(json);
}

@freezed
class WorkoutExerciseResponse with _$WorkoutExerciseResponse {
  const factory WorkoutExerciseResponse({
    required int workoutExerciseId,
    required String exerciseName,
    required int order,
    @Default([]) List<WorkoutSetResponse> workoutSets,
    @Default([]) List<FeedbackResponse> feedbacks,
  }) = _WorkoutExerciseResponse;

  factory WorkoutExerciseResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkoutExerciseResponseFromJson(json);
}

@freezed
class WorkoutSetResponse with _$WorkoutSetResponse {
  const factory WorkoutSetResponse({
    required int workoutSetId,
    required int order,
    required double weight,
    required int reps,
    @Default([]) List<FeedbackResponse> feedbacks,
  }) = _WorkoutSetResponse;

  factory WorkoutSetResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSetResponseFromJson(json);
}

@freezed
class FeedbackResponse with _$FeedbackResponse {
  const factory FeedbackResponse({
    required int feedbackId,
    required String authorName,
    required String content,
  }) = _FeedbackResponse;

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedbackResponseFromJson(json);
}

@freezed
class PageInfo with _$PageInfo {
  const factory PageInfo({
    required int page,
    required int size,
    required int totalElements,
    required int totalPages,
    required bool last,
  }) = _PageInfo;

  factory PageInfo.fromJson(Map<String, dynamic> json) =>
      _$PageInfoFromJson(json);
}