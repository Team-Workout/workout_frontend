// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VersionCheckRequest _$VersionCheckRequestFromJson(Map<String, dynamic> json) {
  return _VersionCheckRequest.fromJson(json);
}

/// @nodoc
mixin _$VersionCheckRequest {
  Map<String, int> get versions => throw _privateConstructorUsedError;

  /// Serializes this VersionCheckRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VersionCheckRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VersionCheckRequestCopyWith<VersionCheckRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VersionCheckRequestCopyWith<$Res> {
  factory $VersionCheckRequestCopyWith(
          VersionCheckRequest value, $Res Function(VersionCheckRequest) then) =
      _$VersionCheckRequestCopyWithImpl<$Res, VersionCheckRequest>;
  @useResult
  $Res call({Map<String, int> versions});
}

/// @nodoc
class _$VersionCheckRequestCopyWithImpl<$Res, $Val extends VersionCheckRequest>
    implements $VersionCheckRequestCopyWith<$Res> {
  _$VersionCheckRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VersionCheckRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? versions = null,
  }) {
    return _then(_value.copyWith(
      versions: null == versions
          ? _value.versions
          : versions // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VersionCheckRequestImplCopyWith<$Res>
    implements $VersionCheckRequestCopyWith<$Res> {
  factory _$$VersionCheckRequestImplCopyWith(_$VersionCheckRequestImpl value,
          $Res Function(_$VersionCheckRequestImpl) then) =
      __$$VersionCheckRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, int> versions});
}

/// @nodoc
class __$$VersionCheckRequestImplCopyWithImpl<$Res>
    extends _$VersionCheckRequestCopyWithImpl<$Res, _$VersionCheckRequestImpl>
    implements _$$VersionCheckRequestImplCopyWith<$Res> {
  __$$VersionCheckRequestImplCopyWithImpl(_$VersionCheckRequestImpl _value,
      $Res Function(_$VersionCheckRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of VersionCheckRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? versions = null,
  }) {
    return _then(_$VersionCheckRequestImpl(
      versions: null == versions
          ? _value._versions
          : versions // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VersionCheckRequestImpl implements _VersionCheckRequest {
  const _$VersionCheckRequestImpl({required final Map<String, int> versions})
      : _versions = versions;

  factory _$VersionCheckRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$VersionCheckRequestImplFromJson(json);

  final Map<String, int> _versions;
  @override
  Map<String, int> get versions {
    if (_versions is EqualUnmodifiableMapView) return _versions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_versions);
  }

  @override
  String toString() {
    return 'VersionCheckRequest(versions: $versions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VersionCheckRequestImpl &&
            const DeepCollectionEquality().equals(other._versions, _versions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_versions));

  /// Create a copy of VersionCheckRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VersionCheckRequestImplCopyWith<_$VersionCheckRequestImpl> get copyWith =>
      __$$VersionCheckRequestImplCopyWithImpl<_$VersionCheckRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VersionCheckRequestImplToJson(
      this,
    );
  }
}

abstract class _VersionCheckRequest implements VersionCheckRequest {
  const factory _VersionCheckRequest(
      {required final Map<String, int> versions}) = _$VersionCheckRequestImpl;

  factory _VersionCheckRequest.fromJson(Map<String, dynamic> json) =
      _$VersionCheckRequestImpl.fromJson;

  @override
  Map<String, int> get versions;

  /// Create a copy of VersionCheckRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VersionCheckRequestImplCopyWith<_$VersionCheckRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Exercise _$ExerciseFromJson(Map<String, dynamic> json) {
  return _Exercise.fromJson(json);
}

/// @nodoc
mixin _$Exercise {
  int get exerciseId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<TargetMuscle> get targetMuscles => throw _privateConstructorUsedError;

  /// Serializes this Exercise to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseCopyWith<Exercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseCopyWith<$Res> {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) then) =
      _$ExerciseCopyWithImpl<$Res, Exercise>;
  @useResult
  $Res call({int exerciseId, String name, List<TargetMuscle> targetMuscles});
}

/// @nodoc
class _$ExerciseCopyWithImpl<$Res, $Val extends Exercise>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseId = null,
    Object? name = null,
    Object? targetMuscles = null,
  }) {
    return _then(_value.copyWith(
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      targetMuscles: null == targetMuscles
          ? _value.targetMuscles
          : targetMuscles // ignore: cast_nullable_to_non_nullable
              as List<TargetMuscle>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExerciseImplCopyWith<$Res>
    implements $ExerciseCopyWith<$Res> {
  factory _$$ExerciseImplCopyWith(
          _$ExerciseImpl value, $Res Function(_$ExerciseImpl) then) =
      __$$ExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int exerciseId, String name, List<TargetMuscle> targetMuscles});
}

/// @nodoc
class __$$ExerciseImplCopyWithImpl<$Res>
    extends _$ExerciseCopyWithImpl<$Res, _$ExerciseImpl>
    implements _$$ExerciseImplCopyWith<$Res> {
  __$$ExerciseImplCopyWithImpl(
      _$ExerciseImpl _value, $Res Function(_$ExerciseImpl) _then)
      : super(_value, _then);

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseId = null,
    Object? name = null,
    Object? targetMuscles = null,
  }) {
    return _then(_$ExerciseImpl(
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      targetMuscles: null == targetMuscles
          ? _value._targetMuscles
          : targetMuscles // ignore: cast_nullable_to_non_nullable
              as List<TargetMuscle>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseImpl implements _Exercise {
  const _$ExerciseImpl(
      {required this.exerciseId,
      required this.name,
      required final List<TargetMuscle> targetMuscles})
      : _targetMuscles = targetMuscles;

  factory _$ExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseImplFromJson(json);

  @override
  final int exerciseId;
  @override
  final String name;
  final List<TargetMuscle> _targetMuscles;
  @override
  List<TargetMuscle> get targetMuscles {
    if (_targetMuscles is EqualUnmodifiableListView) return _targetMuscles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetMuscles);
  }

  @override
  String toString() {
    return 'Exercise(exerciseId: $exerciseId, name: $name, targetMuscles: $targetMuscles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseImpl &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._targetMuscles, _targetMuscles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, exerciseId, name,
      const DeepCollectionEquality().hash(_targetMuscles));

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseImplCopyWith<_$ExerciseImpl> get copyWith =>
      __$$ExerciseImplCopyWithImpl<_$ExerciseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseImplToJson(
      this,
    );
  }
}

abstract class _Exercise implements Exercise {
  const factory _Exercise(
      {required final int exerciseId,
      required final String name,
      required final List<TargetMuscle> targetMuscles}) = _$ExerciseImpl;

  factory _Exercise.fromJson(Map<String, dynamic> json) =
      _$ExerciseImpl.fromJson;

  @override
  int get exerciseId;
  @override
  String get name;
  @override
  List<TargetMuscle> get targetMuscles;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseImplCopyWith<_$ExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TargetMuscle _$TargetMuscleFromJson(Map<String, dynamic> json) {
  return _TargetMuscle.fromJson(json);
}

/// @nodoc
mixin _$TargetMuscle {
  int get muscleId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  MuscleRole get role => throw _privateConstructorUsedError;

  /// Serializes this TargetMuscle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TargetMuscle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TargetMuscleCopyWith<TargetMuscle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TargetMuscleCopyWith<$Res> {
  factory $TargetMuscleCopyWith(
          TargetMuscle value, $Res Function(TargetMuscle) then) =
      _$TargetMuscleCopyWithImpl<$Res, TargetMuscle>;
  @useResult
  $Res call({int muscleId, String name, MuscleRole role});
}

/// @nodoc
class _$TargetMuscleCopyWithImpl<$Res, $Val extends TargetMuscle>
    implements $TargetMuscleCopyWith<$Res> {
  _$TargetMuscleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TargetMuscle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? muscleId = null,
    Object? name = null,
    Object? role = null,
  }) {
    return _then(_value.copyWith(
      muscleId: null == muscleId
          ? _value.muscleId
          : muscleId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as MuscleRole,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TargetMuscleImplCopyWith<$Res>
    implements $TargetMuscleCopyWith<$Res> {
  factory _$$TargetMuscleImplCopyWith(
          _$TargetMuscleImpl value, $Res Function(_$TargetMuscleImpl) then) =
      __$$TargetMuscleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int muscleId, String name, MuscleRole role});
}

/// @nodoc
class __$$TargetMuscleImplCopyWithImpl<$Res>
    extends _$TargetMuscleCopyWithImpl<$Res, _$TargetMuscleImpl>
    implements _$$TargetMuscleImplCopyWith<$Res> {
  __$$TargetMuscleImplCopyWithImpl(
      _$TargetMuscleImpl _value, $Res Function(_$TargetMuscleImpl) _then)
      : super(_value, _then);

  /// Create a copy of TargetMuscle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? muscleId = null,
    Object? name = null,
    Object? role = null,
  }) {
    return _then(_$TargetMuscleImpl(
      muscleId: null == muscleId
          ? _value.muscleId
          : muscleId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as MuscleRole,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TargetMuscleImpl implements _TargetMuscle {
  const _$TargetMuscleImpl(
      {required this.muscleId, required this.name, required this.role});

  factory _$TargetMuscleImpl.fromJson(Map<String, dynamic> json) =>
      _$$TargetMuscleImplFromJson(json);

  @override
  final int muscleId;
  @override
  final String name;
  @override
  final MuscleRole role;

  @override
  String toString() {
    return 'TargetMuscle(muscleId: $muscleId, name: $name, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TargetMuscleImpl &&
            (identical(other.muscleId, muscleId) ||
                other.muscleId == muscleId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, muscleId, name, role);

  /// Create a copy of TargetMuscle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TargetMuscleImplCopyWith<_$TargetMuscleImpl> get copyWith =>
      __$$TargetMuscleImplCopyWithImpl<_$TargetMuscleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TargetMuscleImplToJson(
      this,
    );
  }
}

abstract class _TargetMuscle implements TargetMuscle {
  const factory _TargetMuscle(
      {required final int muscleId,
      required final String name,
      required final MuscleRole role}) = _$TargetMuscleImpl;

  factory _TargetMuscle.fromJson(Map<String, dynamic> json) =
      _$TargetMuscleImpl.fromJson;

  @override
  int get muscleId;
  @override
  String get name;
  @override
  MuscleRole get role;

  /// Create a copy of TargetMuscle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TargetMuscleImplCopyWith<_$TargetMuscleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Muscle _$MuscleFromJson(Map<String, dynamic> json) {
  return _Muscle.fromJson(json);
}

/// @nodoc
mixin _$Muscle {
  int get muscleId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get koreanName => throw _privateConstructorUsedError;
  MuscleGroup get muscleGroup => throw _privateConstructorUsedError;

  /// Serializes this Muscle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Muscle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MuscleCopyWith<Muscle> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MuscleCopyWith<$Res> {
  factory $MuscleCopyWith(Muscle value, $Res Function(Muscle) then) =
      _$MuscleCopyWithImpl<$Res, Muscle>;
  @useResult
  $Res call(
      {int muscleId, String name, String koreanName, MuscleGroup muscleGroup});
}

/// @nodoc
class _$MuscleCopyWithImpl<$Res, $Val extends Muscle>
    implements $MuscleCopyWith<$Res> {
  _$MuscleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Muscle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? muscleId = null,
    Object? name = null,
    Object? koreanName = null,
    Object? muscleGroup = null,
  }) {
    return _then(_value.copyWith(
      muscleId: null == muscleId
          ? _value.muscleId
          : muscleId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      koreanName: null == koreanName
          ? _value.koreanName
          : koreanName // ignore: cast_nullable_to_non_nullable
              as String,
      muscleGroup: null == muscleGroup
          ? _value.muscleGroup
          : muscleGroup // ignore: cast_nullable_to_non_nullable
              as MuscleGroup,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MuscleImplCopyWith<$Res> implements $MuscleCopyWith<$Res> {
  factory _$$MuscleImplCopyWith(
          _$MuscleImpl value, $Res Function(_$MuscleImpl) then) =
      __$$MuscleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int muscleId, String name, String koreanName, MuscleGroup muscleGroup});
}

/// @nodoc
class __$$MuscleImplCopyWithImpl<$Res>
    extends _$MuscleCopyWithImpl<$Res, _$MuscleImpl>
    implements _$$MuscleImplCopyWith<$Res> {
  __$$MuscleImplCopyWithImpl(
      _$MuscleImpl _value, $Res Function(_$MuscleImpl) _then)
      : super(_value, _then);

  /// Create a copy of Muscle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? muscleId = null,
    Object? name = null,
    Object? koreanName = null,
    Object? muscleGroup = null,
  }) {
    return _then(_$MuscleImpl(
      muscleId: null == muscleId
          ? _value.muscleId
          : muscleId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      koreanName: null == koreanName
          ? _value.koreanName
          : koreanName // ignore: cast_nullable_to_non_nullable
              as String,
      muscleGroup: null == muscleGroup
          ? _value.muscleGroup
          : muscleGroup // ignore: cast_nullable_to_non_nullable
              as MuscleGroup,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MuscleImpl implements _Muscle {
  const _$MuscleImpl(
      {required this.muscleId,
      required this.name,
      required this.koreanName,
      required this.muscleGroup});

  factory _$MuscleImpl.fromJson(Map<String, dynamic> json) =>
      _$$MuscleImplFromJson(json);

  @override
  final int muscleId;
  @override
  final String name;
  @override
  final String koreanName;
  @override
  final MuscleGroup muscleGroup;

  @override
  String toString() {
    return 'Muscle(muscleId: $muscleId, name: $name, koreanName: $koreanName, muscleGroup: $muscleGroup)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MuscleImpl &&
            (identical(other.muscleId, muscleId) ||
                other.muscleId == muscleId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.koreanName, koreanName) ||
                other.koreanName == koreanName) &&
            (identical(other.muscleGroup, muscleGroup) ||
                other.muscleGroup == muscleGroup));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, muscleId, name, koreanName, muscleGroup);

  /// Create a copy of Muscle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MuscleImplCopyWith<_$MuscleImpl> get copyWith =>
      __$$MuscleImplCopyWithImpl<_$MuscleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MuscleImplToJson(
      this,
    );
  }
}

abstract class _Muscle implements Muscle {
  const factory _Muscle(
      {required final int muscleId,
      required final String name,
      required final String koreanName,
      required final MuscleGroup muscleGroup}) = _$MuscleImpl;

  factory _Muscle.fromJson(Map<String, dynamic> json) = _$MuscleImpl.fromJson;

  @override
  int get muscleId;
  @override
  String get name;
  @override
  String get koreanName;
  @override
  MuscleGroup get muscleGroup;

  /// Create a copy of Muscle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MuscleImplCopyWith<_$MuscleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExerciseTargetMuscleMapping _$ExerciseTargetMuscleMappingFromJson(
    Map<String, dynamic> json) {
  return _ExerciseTargetMuscleMapping.fromJson(json);
}

/// @nodoc
mixin _$ExerciseTargetMuscleMapping {
  int get mappingId => throw _privateConstructorUsedError;
  int get exerciseId => throw _privateConstructorUsedError;
  int get muscleId => throw _privateConstructorUsedError;
  MuscleRole get muscleRole => throw _privateConstructorUsedError;

  /// Serializes this ExerciseTargetMuscleMapping to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExerciseTargetMuscleMapping
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseTargetMuscleMappingCopyWith<ExerciseTargetMuscleMapping>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseTargetMuscleMappingCopyWith<$Res> {
  factory $ExerciseTargetMuscleMappingCopyWith(
          ExerciseTargetMuscleMapping value,
          $Res Function(ExerciseTargetMuscleMapping) then) =
      _$ExerciseTargetMuscleMappingCopyWithImpl<$Res,
          ExerciseTargetMuscleMapping>;
  @useResult
  $Res call(
      {int mappingId, int exerciseId, int muscleId, MuscleRole muscleRole});
}

/// @nodoc
class _$ExerciseTargetMuscleMappingCopyWithImpl<$Res,
        $Val extends ExerciseTargetMuscleMapping>
    implements $ExerciseTargetMuscleMappingCopyWith<$Res> {
  _$ExerciseTargetMuscleMappingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExerciseTargetMuscleMapping
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mappingId = null,
    Object? exerciseId = null,
    Object? muscleId = null,
    Object? muscleRole = null,
  }) {
    return _then(_value.copyWith(
      mappingId: null == mappingId
          ? _value.mappingId
          : mappingId // ignore: cast_nullable_to_non_nullable
              as int,
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as int,
      muscleId: null == muscleId
          ? _value.muscleId
          : muscleId // ignore: cast_nullable_to_non_nullable
              as int,
      muscleRole: null == muscleRole
          ? _value.muscleRole
          : muscleRole // ignore: cast_nullable_to_non_nullable
              as MuscleRole,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExerciseTargetMuscleMappingImplCopyWith<$Res>
    implements $ExerciseTargetMuscleMappingCopyWith<$Res> {
  factory _$$ExerciseTargetMuscleMappingImplCopyWith(
          _$ExerciseTargetMuscleMappingImpl value,
          $Res Function(_$ExerciseTargetMuscleMappingImpl) then) =
      __$$ExerciseTargetMuscleMappingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int mappingId, int exerciseId, int muscleId, MuscleRole muscleRole});
}

/// @nodoc
class __$$ExerciseTargetMuscleMappingImplCopyWithImpl<$Res>
    extends _$ExerciseTargetMuscleMappingCopyWithImpl<$Res,
        _$ExerciseTargetMuscleMappingImpl>
    implements _$$ExerciseTargetMuscleMappingImplCopyWith<$Res> {
  __$$ExerciseTargetMuscleMappingImplCopyWithImpl(
      _$ExerciseTargetMuscleMappingImpl _value,
      $Res Function(_$ExerciseTargetMuscleMappingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExerciseTargetMuscleMapping
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mappingId = null,
    Object? exerciseId = null,
    Object? muscleId = null,
    Object? muscleRole = null,
  }) {
    return _then(_$ExerciseTargetMuscleMappingImpl(
      mappingId: null == mappingId
          ? _value.mappingId
          : mappingId // ignore: cast_nullable_to_non_nullable
              as int,
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as int,
      muscleId: null == muscleId
          ? _value.muscleId
          : muscleId // ignore: cast_nullable_to_non_nullable
              as int,
      muscleRole: null == muscleRole
          ? _value.muscleRole
          : muscleRole // ignore: cast_nullable_to_non_nullable
              as MuscleRole,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseTargetMuscleMappingImpl
    implements _ExerciseTargetMuscleMapping {
  const _$ExerciseTargetMuscleMappingImpl(
      {required this.mappingId,
      required this.exerciseId,
      required this.muscleId,
      required this.muscleRole});

  factory _$ExerciseTargetMuscleMappingImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ExerciseTargetMuscleMappingImplFromJson(json);

  @override
  final int mappingId;
  @override
  final int exerciseId;
  @override
  final int muscleId;
  @override
  final MuscleRole muscleRole;

  @override
  String toString() {
    return 'ExerciseTargetMuscleMapping(mappingId: $mappingId, exerciseId: $exerciseId, muscleId: $muscleId, muscleRole: $muscleRole)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseTargetMuscleMappingImpl &&
            (identical(other.mappingId, mappingId) ||
                other.mappingId == mappingId) &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.muscleId, muscleId) ||
                other.muscleId == muscleId) &&
            (identical(other.muscleRole, muscleRole) ||
                other.muscleRole == muscleRole));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, mappingId, exerciseId, muscleId, muscleRole);

  /// Create a copy of ExerciseTargetMuscleMapping
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseTargetMuscleMappingImplCopyWith<_$ExerciseTargetMuscleMappingImpl>
      get copyWith => __$$ExerciseTargetMuscleMappingImplCopyWithImpl<
          _$ExerciseTargetMuscleMappingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseTargetMuscleMappingImplToJson(
      this,
    );
  }
}

abstract class _ExerciseTargetMuscleMapping
    implements ExerciseTargetMuscleMapping {
  const factory _ExerciseTargetMuscleMapping(
          {required final int mappingId,
          required final int exerciseId,
          required final int muscleId,
          required final MuscleRole muscleRole}) =
      _$ExerciseTargetMuscleMappingImpl;

  factory _ExerciseTargetMuscleMapping.fromJson(Map<String, dynamic> json) =
      _$ExerciseTargetMuscleMappingImpl.fromJson;

  @override
  int get mappingId;
  @override
  int get exerciseId;
  @override
  int get muscleId;
  @override
  MuscleRole get muscleRole;

  /// Create a copy of ExerciseTargetMuscleMapping
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseTargetMuscleMappingImplCopyWith<_$ExerciseTargetMuscleMappingImpl>
      get copyWith => throw _privateConstructorUsedError;
}
