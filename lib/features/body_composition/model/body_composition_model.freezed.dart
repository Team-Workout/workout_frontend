// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'body_composition_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BodyComposition _$BodyCompositionFromJson(Map<String, dynamic> json) {
  return _BodyComposition.fromJson(json);
}

/// @nodoc
mixin _$BodyComposition {
  int get id => throw _privateConstructorUsedError;
  Map<String, dynamic> get member => throw _privateConstructorUsedError;
  String get measurementDate => throw _privateConstructorUsedError;
  double get weightKg => throw _privateConstructorUsedError;
  double get fatKg => throw _privateConstructorUsedError;
  double get muscleMassKg => throw _privateConstructorUsedError;

  /// Serializes this BodyComposition to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BodyComposition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BodyCompositionCopyWith<BodyComposition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BodyCompositionCopyWith<$Res> {
  factory $BodyCompositionCopyWith(
          BodyComposition value, $Res Function(BodyComposition) then) =
      _$BodyCompositionCopyWithImpl<$Res, BodyComposition>;
  @useResult
  $Res call(
      {int id,
      Map<String, dynamic> member,
      String measurementDate,
      double weightKg,
      double fatKg,
      double muscleMassKg});
}

/// @nodoc
class _$BodyCompositionCopyWithImpl<$Res, $Val extends BodyComposition>
    implements $BodyCompositionCopyWith<$Res> {
  _$BodyCompositionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BodyComposition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? member = null,
    Object? measurementDate = null,
    Object? weightKg = null,
    Object? fatKg = null,
    Object? muscleMassKg = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      member: null == member
          ? _value.member
          : member // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      measurementDate: null == measurementDate
          ? _value.measurementDate
          : measurementDate // ignore: cast_nullable_to_non_nullable
              as String,
      weightKg: null == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      fatKg: null == fatKg
          ? _value.fatKg
          : fatKg // ignore: cast_nullable_to_non_nullable
              as double,
      muscleMassKg: null == muscleMassKg
          ? _value.muscleMassKg
          : muscleMassKg // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BodyCompositionImplCopyWith<$Res>
    implements $BodyCompositionCopyWith<$Res> {
  factory _$$BodyCompositionImplCopyWith(_$BodyCompositionImpl value,
          $Res Function(_$BodyCompositionImpl) then) =
      __$$BodyCompositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      Map<String, dynamic> member,
      String measurementDate,
      double weightKg,
      double fatKg,
      double muscleMassKg});
}

/// @nodoc
class __$$BodyCompositionImplCopyWithImpl<$Res>
    extends _$BodyCompositionCopyWithImpl<$Res, _$BodyCompositionImpl>
    implements _$$BodyCompositionImplCopyWith<$Res> {
  __$$BodyCompositionImplCopyWithImpl(
      _$BodyCompositionImpl _value, $Res Function(_$BodyCompositionImpl) _then)
      : super(_value, _then);

  /// Create a copy of BodyComposition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? member = null,
    Object? measurementDate = null,
    Object? weightKg = null,
    Object? fatKg = null,
    Object? muscleMassKg = null,
  }) {
    return _then(_$BodyCompositionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      member: null == member
          ? _value._member
          : member // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      measurementDate: null == measurementDate
          ? _value.measurementDate
          : measurementDate // ignore: cast_nullable_to_non_nullable
              as String,
      weightKg: null == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      fatKg: null == fatKg
          ? _value.fatKg
          : fatKg // ignore: cast_nullable_to_non_nullable
              as double,
      muscleMassKg: null == muscleMassKg
          ? _value.muscleMassKg
          : muscleMassKg // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BodyCompositionImpl implements _BodyComposition {
  const _$BodyCompositionImpl(
      {required this.id,
      required final Map<String, dynamic> member,
      required this.measurementDate,
      required this.weightKg,
      required this.fatKg,
      required this.muscleMassKg})
      : _member = member;

  factory _$BodyCompositionImpl.fromJson(Map<String, dynamic> json) =>
      _$$BodyCompositionImplFromJson(json);

  @override
  final int id;
  final Map<String, dynamic> _member;
  @override
  Map<String, dynamic> get member {
    if (_member is EqualUnmodifiableMapView) return _member;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_member);
  }

  @override
  final String measurementDate;
  @override
  final double weightKg;
  @override
  final double fatKg;
  @override
  final double muscleMassKg;

  @override
  String toString() {
    return 'BodyComposition(id: $id, member: $member, measurementDate: $measurementDate, weightKg: $weightKg, fatKg: $fatKg, muscleMassKg: $muscleMassKg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodyCompositionImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._member, _member) &&
            (identical(other.measurementDate, measurementDate) ||
                other.measurementDate == measurementDate) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.fatKg, fatKg) || other.fatKg == fatKg) &&
            (identical(other.muscleMassKg, muscleMassKg) ||
                other.muscleMassKg == muscleMassKg));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_member),
      measurementDate,
      weightKg,
      fatKg,
      muscleMassKg);

  /// Create a copy of BodyComposition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BodyCompositionImplCopyWith<_$BodyCompositionImpl> get copyWith =>
      __$$BodyCompositionImplCopyWithImpl<_$BodyCompositionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BodyCompositionImplToJson(
      this,
    );
  }
}

abstract class _BodyComposition implements BodyComposition {
  const factory _BodyComposition(
      {required final int id,
      required final Map<String, dynamic> member,
      required final String measurementDate,
      required final double weightKg,
      required final double fatKg,
      required final double muscleMassKg}) = _$BodyCompositionImpl;

  factory _BodyComposition.fromJson(Map<String, dynamic> json) =
      _$BodyCompositionImpl.fromJson;

  @override
  int get id;
  @override
  Map<String, dynamic> get member;
  @override
  String get measurementDate;
  @override
  double get weightKg;
  @override
  double get fatKg;
  @override
  double get muscleMassKg;

  /// Create a copy of BodyComposition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodyCompositionImplCopyWith<_$BodyCompositionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BodyStats _$BodyStatsFromJson(Map<String, dynamic> json) {
  return _BodyStats.fromJson(json);
}

/// @nodoc
mixin _$BodyStats {
  double get currentWeight => throw _privateConstructorUsedError;
  double get weightChange => throw _privateConstructorUsedError;
  double get bodyFatPercentage => throw _privateConstructorUsedError;
  double get fatChange => throw _privateConstructorUsedError;
  double get bmi => throw _privateConstructorUsedError;
  double get bmiChange => throw _privateConstructorUsedError;
  double get muscleMass => throw _privateConstructorUsedError;
  double? get goalWeight => throw _privateConstructorUsedError;
  int? get goalProgress => throw _privateConstructorUsedError;

  /// Serializes this BodyStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BodyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BodyStatsCopyWith<BodyStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BodyStatsCopyWith<$Res> {
  factory $BodyStatsCopyWith(BodyStats value, $Res Function(BodyStats) then) =
      _$BodyStatsCopyWithImpl<$Res, BodyStats>;
  @useResult
  $Res call(
      {double currentWeight,
      double weightChange,
      double bodyFatPercentage,
      double fatChange,
      double bmi,
      double bmiChange,
      double muscleMass,
      double? goalWeight,
      int? goalProgress});
}

/// @nodoc
class _$BodyStatsCopyWithImpl<$Res, $Val extends BodyStats>
    implements $BodyStatsCopyWith<$Res> {
  _$BodyStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BodyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentWeight = null,
    Object? weightChange = null,
    Object? bodyFatPercentage = null,
    Object? fatChange = null,
    Object? bmi = null,
    Object? bmiChange = null,
    Object? muscleMass = null,
    Object? goalWeight = freezed,
    Object? goalProgress = freezed,
  }) {
    return _then(_value.copyWith(
      currentWeight: null == currentWeight
          ? _value.currentWeight
          : currentWeight // ignore: cast_nullable_to_non_nullable
              as double,
      weightChange: null == weightChange
          ? _value.weightChange
          : weightChange // ignore: cast_nullable_to_non_nullable
              as double,
      bodyFatPercentage: null == bodyFatPercentage
          ? _value.bodyFatPercentage
          : bodyFatPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      fatChange: null == fatChange
          ? _value.fatChange
          : fatChange // ignore: cast_nullable_to_non_nullable
              as double,
      bmi: null == bmi
          ? _value.bmi
          : bmi // ignore: cast_nullable_to_non_nullable
              as double,
      bmiChange: null == bmiChange
          ? _value.bmiChange
          : bmiChange // ignore: cast_nullable_to_non_nullable
              as double,
      muscleMass: null == muscleMass
          ? _value.muscleMass
          : muscleMass // ignore: cast_nullable_to_non_nullable
              as double,
      goalWeight: freezed == goalWeight
          ? _value.goalWeight
          : goalWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      goalProgress: freezed == goalProgress
          ? _value.goalProgress
          : goalProgress // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BodyStatsImplCopyWith<$Res>
    implements $BodyStatsCopyWith<$Res> {
  factory _$$BodyStatsImplCopyWith(
          _$BodyStatsImpl value, $Res Function(_$BodyStatsImpl) then) =
      __$$BodyStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double currentWeight,
      double weightChange,
      double bodyFatPercentage,
      double fatChange,
      double bmi,
      double bmiChange,
      double muscleMass,
      double? goalWeight,
      int? goalProgress});
}

/// @nodoc
class __$$BodyStatsImplCopyWithImpl<$Res>
    extends _$BodyStatsCopyWithImpl<$Res, _$BodyStatsImpl>
    implements _$$BodyStatsImplCopyWith<$Res> {
  __$$BodyStatsImplCopyWithImpl(
      _$BodyStatsImpl _value, $Res Function(_$BodyStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of BodyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentWeight = null,
    Object? weightChange = null,
    Object? bodyFatPercentage = null,
    Object? fatChange = null,
    Object? bmi = null,
    Object? bmiChange = null,
    Object? muscleMass = null,
    Object? goalWeight = freezed,
    Object? goalProgress = freezed,
  }) {
    return _then(_$BodyStatsImpl(
      currentWeight: null == currentWeight
          ? _value.currentWeight
          : currentWeight // ignore: cast_nullable_to_non_nullable
              as double,
      weightChange: null == weightChange
          ? _value.weightChange
          : weightChange // ignore: cast_nullable_to_non_nullable
              as double,
      bodyFatPercentage: null == bodyFatPercentage
          ? _value.bodyFatPercentage
          : bodyFatPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      fatChange: null == fatChange
          ? _value.fatChange
          : fatChange // ignore: cast_nullable_to_non_nullable
              as double,
      bmi: null == bmi
          ? _value.bmi
          : bmi // ignore: cast_nullable_to_non_nullable
              as double,
      bmiChange: null == bmiChange
          ? _value.bmiChange
          : bmiChange // ignore: cast_nullable_to_non_nullable
              as double,
      muscleMass: null == muscleMass
          ? _value.muscleMass
          : muscleMass // ignore: cast_nullable_to_non_nullable
              as double,
      goalWeight: freezed == goalWeight
          ? _value.goalWeight
          : goalWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      goalProgress: freezed == goalProgress
          ? _value.goalProgress
          : goalProgress // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BodyStatsImpl implements _BodyStats {
  const _$BodyStatsImpl(
      {required this.currentWeight,
      required this.weightChange,
      required this.bodyFatPercentage,
      required this.fatChange,
      required this.bmi,
      required this.bmiChange,
      required this.muscleMass,
      this.goalWeight,
      this.goalProgress});

  factory _$BodyStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BodyStatsImplFromJson(json);

  @override
  final double currentWeight;
  @override
  final double weightChange;
  @override
  final double bodyFatPercentage;
  @override
  final double fatChange;
  @override
  final double bmi;
  @override
  final double bmiChange;
  @override
  final double muscleMass;
  @override
  final double? goalWeight;
  @override
  final int? goalProgress;

  @override
  String toString() {
    return 'BodyStats(currentWeight: $currentWeight, weightChange: $weightChange, bodyFatPercentage: $bodyFatPercentage, fatChange: $fatChange, bmi: $bmi, bmiChange: $bmiChange, muscleMass: $muscleMass, goalWeight: $goalWeight, goalProgress: $goalProgress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodyStatsImpl &&
            (identical(other.currentWeight, currentWeight) ||
                other.currentWeight == currentWeight) &&
            (identical(other.weightChange, weightChange) ||
                other.weightChange == weightChange) &&
            (identical(other.bodyFatPercentage, bodyFatPercentage) ||
                other.bodyFatPercentage == bodyFatPercentage) &&
            (identical(other.fatChange, fatChange) ||
                other.fatChange == fatChange) &&
            (identical(other.bmi, bmi) || other.bmi == bmi) &&
            (identical(other.bmiChange, bmiChange) ||
                other.bmiChange == bmiChange) &&
            (identical(other.muscleMass, muscleMass) ||
                other.muscleMass == muscleMass) &&
            (identical(other.goalWeight, goalWeight) ||
                other.goalWeight == goalWeight) &&
            (identical(other.goalProgress, goalProgress) ||
                other.goalProgress == goalProgress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentWeight,
      weightChange,
      bodyFatPercentage,
      fatChange,
      bmi,
      bmiChange,
      muscleMass,
      goalWeight,
      goalProgress);

  /// Create a copy of BodyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BodyStatsImplCopyWith<_$BodyStatsImpl> get copyWith =>
      __$$BodyStatsImplCopyWithImpl<_$BodyStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BodyStatsImplToJson(
      this,
    );
  }
}

abstract class _BodyStats implements BodyStats {
  const factory _BodyStats(
      {required final double currentWeight,
      required final double weightChange,
      required final double bodyFatPercentage,
      required final double fatChange,
      required final double bmi,
      required final double bmiChange,
      required final double muscleMass,
      final double? goalWeight,
      final int? goalProgress}) = _$BodyStatsImpl;

  factory _BodyStats.fromJson(Map<String, dynamic> json) =
      _$BodyStatsImpl.fromJson;

  @override
  double get currentWeight;
  @override
  double get weightChange;
  @override
  double get bodyFatPercentage;
  @override
  double get fatChange;
  @override
  double get bmi;
  @override
  double get bmiChange;
  @override
  double get muscleMass;
  @override
  double? get goalWeight;
  @override
  int? get goalProgress;

  /// Create a copy of BodyStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodyStatsImplCopyWith<_$BodyStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
