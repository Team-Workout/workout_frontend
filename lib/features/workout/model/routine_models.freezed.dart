// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'routine_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateRoutineRequest _$CreateRoutineRequestFromJson(Map<String, dynamic> json) {
  return _CreateRoutineRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateRoutineRequest {
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<RoutineExercise> get routineExercises =>
      throw _privateConstructorUsedError;

  /// Serializes this CreateRoutineRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateRoutineRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateRoutineRequestCopyWith<CreateRoutineRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateRoutineRequestCopyWith<$Res> {
  factory $CreateRoutineRequestCopyWith(CreateRoutineRequest value,
          $Res Function(CreateRoutineRequest) then) =
      _$CreateRoutineRequestCopyWithImpl<$Res, CreateRoutineRequest>;
  @useResult
  $Res call(
      {String? name,
      String? description,
      List<RoutineExercise> routineExercises});
}

/// @nodoc
class _$CreateRoutineRequestCopyWithImpl<$Res,
        $Val extends CreateRoutineRequest>
    implements $CreateRoutineRequestCopyWith<$Res> {
  _$CreateRoutineRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateRoutineRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? routineExercises = null,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      routineExercises: null == routineExercises
          ? _value.routineExercises
          : routineExercises // ignore: cast_nullable_to_non_nullable
              as List<RoutineExercise>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateRoutineRequestImplCopyWith<$Res>
    implements $CreateRoutineRequestCopyWith<$Res> {
  factory _$$CreateRoutineRequestImplCopyWith(_$CreateRoutineRequestImpl value,
          $Res Function(_$CreateRoutineRequestImpl) then) =
      __$$CreateRoutineRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? name,
      String? description,
      List<RoutineExercise> routineExercises});
}

/// @nodoc
class __$$CreateRoutineRequestImplCopyWithImpl<$Res>
    extends _$CreateRoutineRequestCopyWithImpl<$Res, _$CreateRoutineRequestImpl>
    implements _$$CreateRoutineRequestImplCopyWith<$Res> {
  __$$CreateRoutineRequestImplCopyWithImpl(_$CreateRoutineRequestImpl _value,
      $Res Function(_$CreateRoutineRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateRoutineRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? routineExercises = null,
  }) {
    return _then(_$CreateRoutineRequestImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      routineExercises: null == routineExercises
          ? _value._routineExercises
          : routineExercises // ignore: cast_nullable_to_non_nullable
              as List<RoutineExercise>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateRoutineRequestImpl implements _CreateRoutineRequest {
  const _$CreateRoutineRequestImpl(
      {this.name,
      this.description,
      required final List<RoutineExercise> routineExercises})
      : _routineExercises = routineExercises;

  factory _$CreateRoutineRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateRoutineRequestImplFromJson(json);

  @override
  final String? name;
  @override
  final String? description;
  final List<RoutineExercise> _routineExercises;
  @override
  List<RoutineExercise> get routineExercises {
    if (_routineExercises is EqualUnmodifiableListView)
      return _routineExercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_routineExercises);
  }

  @override
  String toString() {
    return 'CreateRoutineRequest(name: $name, description: $description, routineExercises: $routineExercises)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateRoutineRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._routineExercises, _routineExercises));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, description,
      const DeepCollectionEquality().hash(_routineExercises));

  /// Create a copy of CreateRoutineRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateRoutineRequestImplCopyWith<_$CreateRoutineRequestImpl>
      get copyWith =>
          __$$CreateRoutineRequestImplCopyWithImpl<_$CreateRoutineRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateRoutineRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateRoutineRequest implements CreateRoutineRequest {
  const factory _CreateRoutineRequest(
          {final String? name,
          final String? description,
          required final List<RoutineExercise> routineExercises}) =
      _$CreateRoutineRequestImpl;

  factory _CreateRoutineRequest.fromJson(Map<String, dynamic> json) =
      _$CreateRoutineRequestImpl.fromJson;

  @override
  String? get name;
  @override
  String? get description;
  @override
  List<RoutineExercise> get routineExercises;

  /// Create a copy of CreateRoutineRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateRoutineRequestImplCopyWith<_$CreateRoutineRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RoutineExercise _$RoutineExerciseFromJson(Map<String, dynamic> json) {
  return _RoutineExercise.fromJson(json);
}

/// @nodoc
mixin _$RoutineExercise {
  int? get routineExerciseId => throw _privateConstructorUsedError;
  int? get exerciseId => throw _privateConstructorUsedError;
  String? get exerciseName => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  List<RoutineSet> get routineSets => throw _privateConstructorUsedError;

  /// Serializes this RoutineExercise to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoutineExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoutineExerciseCopyWith<RoutineExercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutineExerciseCopyWith<$Res> {
  factory $RoutineExerciseCopyWith(
          RoutineExercise value, $Res Function(RoutineExercise) then) =
      _$RoutineExerciseCopyWithImpl<$Res, RoutineExercise>;
  @useResult
  $Res call(
      {int? routineExerciseId,
      int? exerciseId,
      String? exerciseName,
      int order,
      List<RoutineSet> routineSets});
}

/// @nodoc
class _$RoutineExerciseCopyWithImpl<$Res, $Val extends RoutineExercise>
    implements $RoutineExerciseCopyWith<$Res> {
  _$RoutineExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoutineExercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? routineExerciseId = freezed,
    Object? exerciseId = freezed,
    Object? exerciseName = freezed,
    Object? order = null,
    Object? routineSets = null,
  }) {
    return _then(_value.copyWith(
      routineExerciseId: freezed == routineExerciseId
          ? _value.routineExerciseId
          : routineExerciseId // ignore: cast_nullable_to_non_nullable
              as int?,
      exerciseId: freezed == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as int?,
      exerciseName: freezed == exerciseName
          ? _value.exerciseName
          : exerciseName // ignore: cast_nullable_to_non_nullable
              as String?,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      routineSets: null == routineSets
          ? _value.routineSets
          : routineSets // ignore: cast_nullable_to_non_nullable
              as List<RoutineSet>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoutineExerciseImplCopyWith<$Res>
    implements $RoutineExerciseCopyWith<$Res> {
  factory _$$RoutineExerciseImplCopyWith(_$RoutineExerciseImpl value,
          $Res Function(_$RoutineExerciseImpl) then) =
      __$$RoutineExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? routineExerciseId,
      int? exerciseId,
      String? exerciseName,
      int order,
      List<RoutineSet> routineSets});
}

/// @nodoc
class __$$RoutineExerciseImplCopyWithImpl<$Res>
    extends _$RoutineExerciseCopyWithImpl<$Res, _$RoutineExerciseImpl>
    implements _$$RoutineExerciseImplCopyWith<$Res> {
  __$$RoutineExerciseImplCopyWithImpl(
      _$RoutineExerciseImpl _value, $Res Function(_$RoutineExerciseImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoutineExercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? routineExerciseId = freezed,
    Object? exerciseId = freezed,
    Object? exerciseName = freezed,
    Object? order = null,
    Object? routineSets = null,
  }) {
    return _then(_$RoutineExerciseImpl(
      routineExerciseId: freezed == routineExerciseId
          ? _value.routineExerciseId
          : routineExerciseId // ignore: cast_nullable_to_non_nullable
              as int?,
      exerciseId: freezed == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as int?,
      exerciseName: freezed == exerciseName
          ? _value.exerciseName
          : exerciseName // ignore: cast_nullable_to_non_nullable
              as String?,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      routineSets: null == routineSets
          ? _value._routineSets
          : routineSets // ignore: cast_nullable_to_non_nullable
              as List<RoutineSet>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoutineExerciseImpl implements _RoutineExercise {
  const _$RoutineExerciseImpl(
      {this.routineExerciseId,
      this.exerciseId,
      this.exerciseName,
      required this.order,
      required final List<RoutineSet> routineSets})
      : _routineSets = routineSets;

  factory _$RoutineExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutineExerciseImplFromJson(json);

  @override
  final int? routineExerciseId;
  @override
  final int? exerciseId;
  @override
  final String? exerciseName;
  @override
  final int order;
  final List<RoutineSet> _routineSets;
  @override
  List<RoutineSet> get routineSets {
    if (_routineSets is EqualUnmodifiableListView) return _routineSets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_routineSets);
  }

  @override
  String toString() {
    return 'RoutineExercise(routineExerciseId: $routineExerciseId, exerciseId: $exerciseId, exerciseName: $exerciseName, order: $order, routineSets: $routineSets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutineExerciseImpl &&
            (identical(other.routineExerciseId, routineExerciseId) ||
                other.routineExerciseId == routineExerciseId) &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.exerciseName, exerciseName) ||
                other.exerciseName == exerciseName) &&
            (identical(other.order, order) || other.order == order) &&
            const DeepCollectionEquality()
                .equals(other._routineSets, _routineSets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, routineExerciseId, exerciseId,
      exerciseName, order, const DeepCollectionEquality().hash(_routineSets));

  /// Create a copy of RoutineExercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutineExerciseImplCopyWith<_$RoutineExerciseImpl> get copyWith =>
      __$$RoutineExerciseImplCopyWithImpl<_$RoutineExerciseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutineExerciseImplToJson(
      this,
    );
  }
}

abstract class _RoutineExercise implements RoutineExercise {
  const factory _RoutineExercise(
      {final int? routineExerciseId,
      final int? exerciseId,
      final String? exerciseName,
      required final int order,
      required final List<RoutineSet> routineSets}) = _$RoutineExerciseImpl;

  factory _RoutineExercise.fromJson(Map<String, dynamic> json) =
      _$RoutineExerciseImpl.fromJson;

  @override
  int? get routineExerciseId;
  @override
  int? get exerciseId;
  @override
  String? get exerciseName;
  @override
  int get order;
  @override
  List<RoutineSet> get routineSets;

  /// Create a copy of RoutineExercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoutineExerciseImplCopyWith<_$RoutineExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoutineSet _$RoutineSetFromJson(Map<String, dynamic> json) {
  return _RoutineSet.fromJson(json);
}

/// @nodoc
mixin _$RoutineSet {
  int? get workoutSetId => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  int get reps => throw _privateConstructorUsedError;

  /// Serializes this RoutineSet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoutineSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoutineSetCopyWith<RoutineSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutineSetCopyWith<$Res> {
  factory $RoutineSetCopyWith(
          RoutineSet value, $Res Function(RoutineSet) then) =
      _$RoutineSetCopyWithImpl<$Res, RoutineSet>;
  @useResult
  $Res call({int? workoutSetId, int order, double weight, int reps});
}

/// @nodoc
class _$RoutineSetCopyWithImpl<$Res, $Val extends RoutineSet>
    implements $RoutineSetCopyWith<$Res> {
  _$RoutineSetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoutineSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutSetId = freezed,
    Object? order = null,
    Object? weight = null,
    Object? reps = null,
  }) {
    return _then(_value.copyWith(
      workoutSetId: freezed == workoutSetId
          ? _value.workoutSetId
          : workoutSetId // ignore: cast_nullable_to_non_nullable
              as int?,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoutineSetImplCopyWith<$Res>
    implements $RoutineSetCopyWith<$Res> {
  factory _$$RoutineSetImplCopyWith(
          _$RoutineSetImpl value, $Res Function(_$RoutineSetImpl) then) =
      __$$RoutineSetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? workoutSetId, int order, double weight, int reps});
}

/// @nodoc
class __$$RoutineSetImplCopyWithImpl<$Res>
    extends _$RoutineSetCopyWithImpl<$Res, _$RoutineSetImpl>
    implements _$$RoutineSetImplCopyWith<$Res> {
  __$$RoutineSetImplCopyWithImpl(
      _$RoutineSetImpl _value, $Res Function(_$RoutineSetImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoutineSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutSetId = freezed,
    Object? order = null,
    Object? weight = null,
    Object? reps = null,
  }) {
    return _then(_$RoutineSetImpl(
      workoutSetId: freezed == workoutSetId
          ? _value.workoutSetId
          : workoutSetId // ignore: cast_nullable_to_non_nullable
              as int?,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoutineSetImpl implements _RoutineSet {
  const _$RoutineSetImpl(
      {this.workoutSetId,
      required this.order,
      required this.weight,
      required this.reps});

  factory _$RoutineSetImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutineSetImplFromJson(json);

  @override
  final int? workoutSetId;
  @override
  final int order;
  @override
  final double weight;
  @override
  final int reps;

  @override
  String toString() {
    return 'RoutineSet(workoutSetId: $workoutSetId, order: $order, weight: $weight, reps: $reps)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutineSetImpl &&
            (identical(other.workoutSetId, workoutSetId) ||
                other.workoutSetId == workoutSetId) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.reps, reps) || other.reps == reps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, workoutSetId, order, weight, reps);

  /// Create a copy of RoutineSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutineSetImplCopyWith<_$RoutineSetImpl> get copyWith =>
      __$$RoutineSetImplCopyWithImpl<_$RoutineSetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutineSetImplToJson(
      this,
    );
  }
}

abstract class _RoutineSet implements RoutineSet {
  const factory _RoutineSet(
      {final int? workoutSetId,
      required final int order,
      required final double weight,
      required final int reps}) = _$RoutineSetImpl;

  factory _RoutineSet.fromJson(Map<String, dynamic> json) =
      _$RoutineSetImpl.fromJson;

  @override
  int? get workoutSetId;
  @override
  int get order;
  @override
  double get weight;
  @override
  int get reps;

  /// Create a copy of RoutineSet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoutineSetImplCopyWith<_$RoutineSetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoutineResponse _$RoutineResponseFromJson(Map<String, dynamic> json) {
  return _RoutineResponse.fromJson(json);
}

/// @nodoc
mixin _$RoutineResponse {
  @JsonKey(name: 'routineId')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'routineName')
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  List<RoutineExercise>? get routineExercises =>
      throw _privateConstructorUsedError;

  /// Serializes this RoutineResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoutineResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoutineResponseCopyWith<RoutineResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutineResponseCopyWith<$Res> {
  factory $RoutineResponseCopyWith(
          RoutineResponse value, $Res Function(RoutineResponse) then) =
      _$RoutineResponseCopyWithImpl<$Res, RoutineResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'routineId') int id,
      @JsonKey(name: 'routineName') String name,
      String? description,
      String? userId,
      DateTime? createdAt,
      DateTime? updatedAt,
      List<RoutineExercise>? routineExercises});
}

/// @nodoc
class _$RoutineResponseCopyWithImpl<$Res, $Val extends RoutineResponse>
    implements $RoutineResponseCopyWith<$Res> {
  _$RoutineResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoutineResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? userId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? routineExercises = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      routineExercises: freezed == routineExercises
          ? _value.routineExercises
          : routineExercises // ignore: cast_nullable_to_non_nullable
              as List<RoutineExercise>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoutineResponseImplCopyWith<$Res>
    implements $RoutineResponseCopyWith<$Res> {
  factory _$$RoutineResponseImplCopyWith(_$RoutineResponseImpl value,
          $Res Function(_$RoutineResponseImpl) then) =
      __$$RoutineResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'routineId') int id,
      @JsonKey(name: 'routineName') String name,
      String? description,
      String? userId,
      DateTime? createdAt,
      DateTime? updatedAt,
      List<RoutineExercise>? routineExercises});
}

/// @nodoc
class __$$RoutineResponseImplCopyWithImpl<$Res>
    extends _$RoutineResponseCopyWithImpl<$Res, _$RoutineResponseImpl>
    implements _$$RoutineResponseImplCopyWith<$Res> {
  __$$RoutineResponseImplCopyWithImpl(
      _$RoutineResponseImpl _value, $Res Function(_$RoutineResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoutineResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? userId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? routineExercises = freezed,
  }) {
    return _then(_$RoutineResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      routineExercises: freezed == routineExercises
          ? _value._routineExercises
          : routineExercises // ignore: cast_nullable_to_non_nullable
              as List<RoutineExercise>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoutineResponseImpl implements _RoutineResponse {
  const _$RoutineResponseImpl(
      {@JsonKey(name: 'routineId') required this.id,
      @JsonKey(name: 'routineName') required this.name,
      this.description,
      this.userId,
      this.createdAt,
      this.updatedAt,
      final List<RoutineExercise>? routineExercises})
      : _routineExercises = routineExercises;

  factory _$RoutineResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutineResponseImplFromJson(json);

  @override
  @JsonKey(name: 'routineId')
  final int id;
  @override
  @JsonKey(name: 'routineName')
  final String name;
  @override
  final String? description;
  @override
  final String? userId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  final List<RoutineExercise>? _routineExercises;
  @override
  List<RoutineExercise>? get routineExercises {
    final value = _routineExercises;
    if (value == null) return null;
    if (_routineExercises is EqualUnmodifiableListView)
      return _routineExercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'RoutineResponse(id: $id, name: $name, description: $description, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, routineExercises: $routineExercises)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutineResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._routineExercises, _routineExercises));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      userId,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_routineExercises));

  /// Create a copy of RoutineResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutineResponseImplCopyWith<_$RoutineResponseImpl> get copyWith =>
      __$$RoutineResponseImplCopyWithImpl<_$RoutineResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutineResponseImplToJson(
      this,
    );
  }
}

abstract class _RoutineResponse implements RoutineResponse {
  const factory _RoutineResponse(
      {@JsonKey(name: 'routineId') required final int id,
      @JsonKey(name: 'routineName') required final String name,
      final String? description,
      final String? userId,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final List<RoutineExercise>? routineExercises}) = _$RoutineResponseImpl;

  factory _RoutineResponse.fromJson(Map<String, dynamic> json) =
      _$RoutineResponseImpl.fromJson;

  @override
  @JsonKey(name: 'routineId')
  int get id;
  @override
  @JsonKey(name: 'routineName')
  String get name;
  @override
  String? get description;
  @override
  String? get userId;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  List<RoutineExercise>? get routineExercises;

  /// Create a copy of RoutineResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoutineResponseImplCopyWith<_$RoutineResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
