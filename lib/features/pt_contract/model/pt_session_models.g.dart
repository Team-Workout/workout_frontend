// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_session_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PtSessionCreateImpl _$$PtSessionCreateImplFromJson(
        Map<String, dynamic> json) =>
    _$PtSessionCreateImpl(
      appointmentId: (json['appointmentId'] as num).toInt(),
      workoutLog:
          WorkoutLogCreate.fromJson(json['workoutLog'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PtSessionCreateImplToJson(
        _$PtSessionCreateImpl instance) =>
    <String, dynamic>{
      'appointmentId': instance.appointmentId,
      'workoutLog': instance.workoutLog,
    };

_$WorkoutLogCreateImpl _$$WorkoutLogCreateImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkoutLogCreateImpl(
      workoutDate: json['workoutDate'] as String,
      logFeedback: json['logFeedback'] as String,
      workoutExercises: (json['workoutExercises'] as List<dynamic>)
          .map((e) => WorkoutExerciseCreate.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WorkoutLogCreateImplToJson(
        _$WorkoutLogCreateImpl instance) =>
    <String, dynamic>{
      'workoutDate': instance.workoutDate,
      'logFeedback': instance.logFeedback,
      'workoutExercises': instance.workoutExercises,
    };

_$WorkoutExerciseCreateImpl _$$WorkoutExerciseCreateImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkoutExerciseCreateImpl(
      exerciseId: (json['exerciseId'] as num).toInt(),
      order: (json['order'] as num).toInt(),
      workoutSets: (json['workoutSets'] as List<dynamic>)
          .map((e) => WorkoutSetCreate.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WorkoutExerciseCreateImplToJson(
        _$WorkoutExerciseCreateImpl instance) =>
    <String, dynamic>{
      'exerciseId': instance.exerciseId,
      'order': instance.order,
      'workoutSets': instance.workoutSets,
    };

_$WorkoutSetCreateImpl _$$WorkoutSetCreateImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkoutSetCreateImpl(
      order: (json['order'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
      reps: (json['reps'] as num).toInt(),
      feedback: json['feedback'] as String?,
    );

Map<String, dynamic> _$$WorkoutSetCreateImplToJson(
        _$WorkoutSetCreateImpl instance) =>
    <String, dynamic>{
      'order': instance.order,
      'weight': instance.weight,
      'reps': instance.reps,
      'feedback': instance.feedback,
    };

_$WorkoutLogEntryImpl _$$WorkoutLogEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$WorkoutLogEntryImpl(
      exerciseId: (json['exerciseId'] as num).toInt(),
      sets: (json['sets'] as List<dynamic>)
          .map((e) => WorkoutSet.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$WorkoutLogEntryImplToJson(
        _$WorkoutLogEntryImpl instance) =>
    <String, dynamic>{
      'exerciseId': instance.exerciseId,
      'sets': instance.sets,
      'notes': instance.notes,
    };

_$WorkoutSetImpl _$$WorkoutSetImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutSetImpl(
      reps: (json['reps'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
      duration: (json['duration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$WorkoutSetImplToJson(_$WorkoutSetImpl instance) =>
    <String, dynamic>{
      'reps': instance.reps,
      'weight': instance.weight,
      'duration': instance.duration,
    };

_$PtSessionImpl _$$PtSessionImplFromJson(Map<String, dynamic> json) =>
    _$PtSessionImpl(
      ptSessionId: (json['ptSessionId'] as num).toInt(),
      appointmentId: (json['appointmentId'] as num).toInt(),
      sessionDate: json['sessionDate'] as String,
      notes: json['notes'] as String,
      workoutLogs: (json['workoutLogs'] as List<dynamic>)
          .map((e) => WorkoutLogEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$PtSessionImplToJson(_$PtSessionImpl instance) =>
    <String, dynamic>{
      'ptSessionId': instance.ptSessionId,
      'appointmentId': instance.appointmentId,
      'sessionDate': instance.sessionDate,
      'notes': instance.notes,
      'workoutLogs': instance.workoutLogs,
      'createdAt': instance.createdAt.toIso8601String(),
    };
