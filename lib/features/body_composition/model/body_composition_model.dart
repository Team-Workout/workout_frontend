import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_composition_model.freezed.dart';
part 'body_composition_model.g.dart';

@freezed
class BodyComposition with _$BodyComposition {
  const factory BodyComposition({
    required int id,
    required Map<String, dynamic> member,
    required String measurementDate,
    required double weightKg,
    required double fatKg,
    required double muscleMassKg,
  }) = _BodyComposition;

  factory BodyComposition.fromJson(Map<String, dynamic> json) =>
      _$BodyCompositionFromJson(json);
}

@freezed
class BodyStats with _$BodyStats {
  const factory BodyStats({
    required double currentWeight,
    required double weightChange,
    required double bodyFatPercentage,
    required double fatChange,
    required double bmi,
    required double bmiChange,
    required double muscleMass,
    double? goalWeight,
    int? goalProgress,
  }) = _BodyStats;

  factory BodyStats.fromJson(Map<String, dynamic> json) =>
      _$BodyStatsFromJson(json);
}