// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PtSessionListResponseImpl _$$PtSessionListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PtSessionListResponseImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => PtSessionResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageInfo: PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PtSessionListResponseImplToJson(
        _$PtSessionListResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'pageInfo': instance.pageInfo,
    };

_$PtSessionResponseImpl _$$PtSessionResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PtSessionResponseImpl(
      id: (json['id'] as num).toInt(),
      workoutLogResponse: json['workoutLogResponse'] == null
          ? null
          : WorkoutLogResponse.fromJson(
              json['workoutLogResponse'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PtSessionResponseImplToJson(
        _$PtSessionResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workoutLogResponse': instance.workoutLogResponse,
    };

_$WorkoutLogResponseImpl _$$WorkoutLogResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkoutLogResponseImpl(
      workoutLogId: (json['workoutLogId'] as num).toInt(),
      workoutDate: json['workoutDate'] as String,
      feedbacks: (json['feedbacks'] as List<dynamic>?)
              ?.map((e) => FeedbackResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      workoutExercises: (json['workoutExercises'] as List<dynamic>?)
              ?.map((e) =>
                  WorkoutExerciseResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WorkoutLogResponseImplToJson(
        _$WorkoutLogResponseImpl instance) =>
    <String, dynamic>{
      'workoutLogId': instance.workoutLogId,
      'workoutDate': instance.workoutDate,
      'feedbacks': instance.feedbacks,
      'workoutExercises': instance.workoutExercises,
    };

_$WorkoutExerciseResponseImpl _$$WorkoutExerciseResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkoutExerciseResponseImpl(
      workoutExerciseId: (json['workoutExerciseId'] as num).toInt(),
      exerciseName: json['exerciseName'] as String,
      order: (json['order'] as num).toInt(),
      workoutSets: (json['workoutSets'] as List<dynamic>?)
              ?.map(
                  (e) => WorkoutSetResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      feedbacks: (json['feedbacks'] as List<dynamic>?)
              ?.map((e) => FeedbackResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WorkoutExerciseResponseImplToJson(
        _$WorkoutExerciseResponseImpl instance) =>
    <String, dynamic>{
      'workoutExerciseId': instance.workoutExerciseId,
      'exerciseName': instance.exerciseName,
      'order': instance.order,
      'workoutSets': instance.workoutSets,
      'feedbacks': instance.feedbacks,
    };

_$WorkoutSetResponseImpl _$$WorkoutSetResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkoutSetResponseImpl(
      workoutSetId: (json['workoutSetId'] as num).toInt(),
      order: (json['order'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
      reps: (json['reps'] as num).toInt(),
      feedbacks: (json['feedbacks'] as List<dynamic>?)
              ?.map((e) => FeedbackResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WorkoutSetResponseImplToJson(
        _$WorkoutSetResponseImpl instance) =>
    <String, dynamic>{
      'workoutSetId': instance.workoutSetId,
      'order': instance.order,
      'weight': instance.weight,
      'reps': instance.reps,
      'feedbacks': instance.feedbacks,
    };

_$FeedbackResponseImpl _$$FeedbackResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$FeedbackResponseImpl(
      feedbackId: (json['feedbackId'] as num).toInt(),
      authorName: json['authorName'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$$FeedbackResponseImplToJson(
        _$FeedbackResponseImpl instance) =>
    <String, dynamic>{
      'feedbackId': instance.feedbackId,
      'authorName': instance.authorName,
      'content': instance.content,
    };

_$PageInfoImpl _$$PageInfoImplFromJson(Map<String, dynamic> json) =>
    _$PageInfoImpl(
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      totalElements: (json['totalElements'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      last: json['last'] as bool,
    );

Map<String, dynamic> _$$PageInfoImplToJson(_$PageInfoImpl instance) =>
    <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'last': instance.last,
    };
