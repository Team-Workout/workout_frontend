// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_session_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PtSessionCreateImpl _$$PtSessionCreateImplFromJson(
        Map<String, dynamic> json) =>
    _$PtSessionCreateImpl(
      appointmentId: (json['appointmentId'] as num).toInt(),
      sessionDate: json['sessionDate'] as String,
      notes: json['notes'] as String,
      workoutLogs: (json['workoutLogs'] as List<dynamic>)
          .map((e) => WorkoutLogEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PtSessionCreateImplToJson(
        _$PtSessionCreateImpl instance) =>
    <String, dynamic>{
      'appointmentId': instance.appointmentId,
      'sessionDate': instance.sessionDate,
      'notes': instance.notes,
      'workoutLogs': instance.workoutLogs,
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
