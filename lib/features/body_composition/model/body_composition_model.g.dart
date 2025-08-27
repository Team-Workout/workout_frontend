// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_composition_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BodyCompositionImpl _$$BodyCompositionImplFromJson(
        Map<String, dynamic> json) =>
    _$BodyCompositionImpl(
      id: (json['id'] as num).toInt(),
      member: json['member'] as Map<String, dynamic>,
      measurementDate: json['measurementDate'] as String,
      weightKg: (json['weightKg'] as num).toDouble(),
      fatKg: (json['fatKg'] as num).toDouble(),
      muscleMassKg: (json['muscleMassKg'] as num).toDouble(),
    );

Map<String, dynamic> _$$BodyCompositionImplToJson(
        _$BodyCompositionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'member': instance.member,
      'measurementDate': instance.measurementDate,
      'weightKg': instance.weightKg,
      'fatKg': instance.fatKg,
      'muscleMassKg': instance.muscleMassKg,
    };

_$BodyStatsImpl _$$BodyStatsImplFromJson(Map<String, dynamic> json) =>
    _$BodyStatsImpl(
      currentWeight: (json['currentWeight'] as num).toDouble(),
      weightChange: (json['weightChange'] as num).toDouble(),
      bodyFatPercentage: (json['bodyFatPercentage'] as num).toDouble(),
      fatChange: (json['fatChange'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
      bmiChange: (json['bmiChange'] as num).toDouble(),
      muscleMass: (json['muscleMass'] as num).toDouble(),
      goalWeight: (json['goalWeight'] as num?)?.toDouble(),
      goalProgress: (json['goalProgress'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$BodyStatsImplToJson(_$BodyStatsImpl instance) =>
    <String, dynamic>{
      'currentWeight': instance.currentWeight,
      'weightChange': instance.weightChange,
      'bodyFatPercentage': instance.bodyFatPercentage,
      'fatChange': instance.fatChange,
      'bmi': instance.bmi,
      'bmiChange': instance.bmiChange,
      'muscleMass': instance.muscleMass,
      'goalWeight': instance.goalWeight,
      'goalProgress': instance.goalProgress,
    };
