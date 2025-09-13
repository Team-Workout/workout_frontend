// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pt_session_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PtSessionCreate _$PtSessionCreateFromJson(Map<String, dynamic> json) {
  return _PtSessionCreate.fromJson(json);
}

/// @nodoc
mixin _$PtSessionCreate {
  int get appointmentId => throw _privateConstructorUsedError;
  WorkoutLogCreate get workoutLog => throw _privateConstructorUsedError;

  /// Serializes this PtSessionCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PtSessionCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PtSessionCreateCopyWith<PtSessionCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PtSessionCreateCopyWith<$Res> {
  factory $PtSessionCreateCopyWith(
          PtSessionCreate value, $Res Function(PtSessionCreate) then) =
      _$PtSessionCreateCopyWithImpl<$Res, PtSessionCreate>;
  @useResult
  $Res call({int appointmentId, WorkoutLogCreate workoutLog});

  $WorkoutLogCreateCopyWith<$Res> get workoutLog;
}

/// @nodoc
class _$PtSessionCreateCopyWithImpl<$Res, $Val extends PtSessionCreate>
    implements $PtSessionCreateCopyWith<$Res> {
  _$PtSessionCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PtSessionCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appointmentId = null,
    Object? workoutLog = null,
  }) {
    return _then(_value.copyWith(
      appointmentId: null == appointmentId
          ? _value.appointmentId
          : appointmentId // ignore: cast_nullable_to_non_nullable
              as int,
      workoutLog: null == workoutLog
          ? _value.workoutLog
          : workoutLog // ignore: cast_nullable_to_non_nullable
              as WorkoutLogCreate,
    ) as $Val);
  }

  /// Create a copy of PtSessionCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkoutLogCreateCopyWith<$Res> get workoutLog {
    return $WorkoutLogCreateCopyWith<$Res>(_value.workoutLog, (value) {
      return _then(_value.copyWith(workoutLog: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PtSessionCreateImplCopyWith<$Res>
    implements $PtSessionCreateCopyWith<$Res> {
  factory _$$PtSessionCreateImplCopyWith(_$PtSessionCreateImpl value,
          $Res Function(_$PtSessionCreateImpl) then) =
      __$$PtSessionCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int appointmentId, WorkoutLogCreate workoutLog});

  @override
  $WorkoutLogCreateCopyWith<$Res> get workoutLog;
}

/// @nodoc
class __$$PtSessionCreateImplCopyWithImpl<$Res>
    extends _$PtSessionCreateCopyWithImpl<$Res, _$PtSessionCreateImpl>
    implements _$$PtSessionCreateImplCopyWith<$Res> {
  __$$PtSessionCreateImplCopyWithImpl(
      _$PtSessionCreateImpl _value, $Res Function(_$PtSessionCreateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PtSessionCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appointmentId = null,
    Object? workoutLog = null,
  }) {
    return _then(_$PtSessionCreateImpl(
      appointmentId: null == appointmentId
          ? _value.appointmentId
          : appointmentId // ignore: cast_nullable_to_non_nullable
              as int,
      workoutLog: null == workoutLog
          ? _value.workoutLog
          : workoutLog // ignore: cast_nullable_to_non_nullable
              as WorkoutLogCreate,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PtSessionCreateImpl implements _PtSessionCreate {
  const _$PtSessionCreateImpl(
      {required this.appointmentId, required this.workoutLog});

  factory _$PtSessionCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$PtSessionCreateImplFromJson(json);

  @override
  final int appointmentId;
  @override
  final WorkoutLogCreate workoutLog;

  @override
  String toString() {
    return 'PtSessionCreate(appointmentId: $appointmentId, workoutLog: $workoutLog)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PtSessionCreateImpl &&
            (identical(other.appointmentId, appointmentId) ||
                other.appointmentId == appointmentId) &&
            (identical(other.workoutLog, workoutLog) ||
                other.workoutLog == workoutLog));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, appointmentId, workoutLog);

  /// Create a copy of PtSessionCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PtSessionCreateImplCopyWith<_$PtSessionCreateImpl> get copyWith =>
      __$$PtSessionCreateImplCopyWithImpl<_$PtSessionCreateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PtSessionCreateImplToJson(
      this,
    );
  }
}

abstract class _PtSessionCreate implements PtSessionCreate {
  const factory _PtSessionCreate(
      {required final int appointmentId,
      required final WorkoutLogCreate workoutLog}) = _$PtSessionCreateImpl;

  factory _PtSessionCreate.fromJson(Map<String, dynamic> json) =
      _$PtSessionCreateImpl.fromJson;

  @override
  int get appointmentId;
  @override
  WorkoutLogCreate get workoutLog;

  /// Create a copy of PtSessionCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PtSessionCreateImplCopyWith<_$PtSessionCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkoutLogCreate _$WorkoutLogCreateFromJson(Map<String, dynamic> json) {
  return _WorkoutLogCreate.fromJson(json);
}

/// @nodoc
mixin _$WorkoutLogCreate {
  String get workoutDate => throw _privateConstructorUsedError;
  String get logFeedback => throw _privateConstructorUsedError;
  List<WorkoutExerciseCreate> get workoutExercises =>
      throw _privateConstructorUsedError;

  /// Serializes this WorkoutLogCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutLogCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutLogCreateCopyWith<WorkoutLogCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutLogCreateCopyWith<$Res> {
  factory $WorkoutLogCreateCopyWith(
          WorkoutLogCreate value, $Res Function(WorkoutLogCreate) then) =
      _$WorkoutLogCreateCopyWithImpl<$Res, WorkoutLogCreate>;
  @useResult
  $Res call(
      {String workoutDate,
      String logFeedback,
      List<WorkoutExerciseCreate> workoutExercises});
}

/// @nodoc
class _$WorkoutLogCreateCopyWithImpl<$Res, $Val extends WorkoutLogCreate>
    implements $WorkoutLogCreateCopyWith<$Res> {
  _$WorkoutLogCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutLogCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutDate = null,
    Object? logFeedback = null,
    Object? workoutExercises = null,
  }) {
    return _then(_value.copyWith(
      workoutDate: null == workoutDate
          ? _value.workoutDate
          : workoutDate // ignore: cast_nullable_to_non_nullable
              as String,
      logFeedback: null == logFeedback
          ? _value.logFeedback
          : logFeedback // ignore: cast_nullable_to_non_nullable
              as String,
      workoutExercises: null == workoutExercises
          ? _value.workoutExercises
          : workoutExercises // ignore: cast_nullable_to_non_nullable
              as List<WorkoutExerciseCreate>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutLogCreateImplCopyWith<$Res>
    implements $WorkoutLogCreateCopyWith<$Res> {
  factory _$$WorkoutLogCreateImplCopyWith(_$WorkoutLogCreateImpl value,
          $Res Function(_$WorkoutLogCreateImpl) then) =
      __$$WorkoutLogCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String workoutDate,
      String logFeedback,
      List<WorkoutExerciseCreate> workoutExercises});
}

/// @nodoc
class __$$WorkoutLogCreateImplCopyWithImpl<$Res>
    extends _$WorkoutLogCreateCopyWithImpl<$Res, _$WorkoutLogCreateImpl>
    implements _$$WorkoutLogCreateImplCopyWith<$Res> {
  __$$WorkoutLogCreateImplCopyWithImpl(_$WorkoutLogCreateImpl _value,
      $Res Function(_$WorkoutLogCreateImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutLogCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutDate = null,
    Object? logFeedback = null,
    Object? workoutExercises = null,
  }) {
    return _then(_$WorkoutLogCreateImpl(
      workoutDate: null == workoutDate
          ? _value.workoutDate
          : workoutDate // ignore: cast_nullable_to_non_nullable
              as String,
      logFeedback: null == logFeedback
          ? _value.logFeedback
          : logFeedback // ignore: cast_nullable_to_non_nullable
              as String,
      workoutExercises: null == workoutExercises
          ? _value._workoutExercises
          : workoutExercises // ignore: cast_nullable_to_non_nullable
              as List<WorkoutExerciseCreate>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutLogCreateImpl implements _WorkoutLogCreate {
  const _$WorkoutLogCreateImpl(
      {required this.workoutDate,
      required this.logFeedback,
      required final List<WorkoutExerciseCreate> workoutExercises})
      : _workoutExercises = workoutExercises;

  factory _$WorkoutLogCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutLogCreateImplFromJson(json);

  @override
  final String workoutDate;
  @override
  final String logFeedback;
  final List<WorkoutExerciseCreate> _workoutExercises;
  @override
  List<WorkoutExerciseCreate> get workoutExercises {
    if (_workoutExercises is EqualUnmodifiableListView)
      return _workoutExercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workoutExercises);
  }

  @override
  String toString() {
    return 'WorkoutLogCreate(workoutDate: $workoutDate, logFeedback: $logFeedback, workoutExercises: $workoutExercises)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutLogCreateImpl &&
            (identical(other.workoutDate, workoutDate) ||
                other.workoutDate == workoutDate) &&
            (identical(other.logFeedback, logFeedback) ||
                other.logFeedback == logFeedback) &&
            const DeepCollectionEquality()
                .equals(other._workoutExercises, _workoutExercises));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, workoutDate, logFeedback,
      const DeepCollectionEquality().hash(_workoutExercises));

  /// Create a copy of WorkoutLogCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutLogCreateImplCopyWith<_$WorkoutLogCreateImpl> get copyWith =>
      __$$WorkoutLogCreateImplCopyWithImpl<_$WorkoutLogCreateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutLogCreateImplToJson(
      this,
    );
  }
}

abstract class _WorkoutLogCreate implements WorkoutLogCreate {
  const factory _WorkoutLogCreate(
          {required final String workoutDate,
          required final String logFeedback,
          required final List<WorkoutExerciseCreate> workoutExercises}) =
      _$WorkoutLogCreateImpl;

  factory _WorkoutLogCreate.fromJson(Map<String, dynamic> json) =
      _$WorkoutLogCreateImpl.fromJson;

  @override
  String get workoutDate;
  @override
  String get logFeedback;
  @override
  List<WorkoutExerciseCreate> get workoutExercises;

  /// Create a copy of WorkoutLogCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutLogCreateImplCopyWith<_$WorkoutLogCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkoutExerciseCreate _$WorkoutExerciseCreateFromJson(
    Map<String, dynamic> json) {
  return _WorkoutExerciseCreate.fromJson(json);
}

/// @nodoc
mixin _$WorkoutExerciseCreate {
  int get exerciseId => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  List<WorkoutSetCreate> get workoutSets => throw _privateConstructorUsedError;

  /// Serializes this WorkoutExerciseCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutExerciseCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutExerciseCreateCopyWith<WorkoutExerciseCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutExerciseCreateCopyWith<$Res> {
  factory $WorkoutExerciseCreateCopyWith(WorkoutExerciseCreate value,
          $Res Function(WorkoutExerciseCreate) then) =
      _$WorkoutExerciseCreateCopyWithImpl<$Res, WorkoutExerciseCreate>;
  @useResult
  $Res call({int exerciseId, int order, List<WorkoutSetCreate> workoutSets});
}

/// @nodoc
class _$WorkoutExerciseCreateCopyWithImpl<$Res,
        $Val extends WorkoutExerciseCreate>
    implements $WorkoutExerciseCreateCopyWith<$Res> {
  _$WorkoutExerciseCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutExerciseCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseId = null,
    Object? order = null,
    Object? workoutSets = null,
  }) {
    return _then(_value.copyWith(
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as int,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      workoutSets: null == workoutSets
          ? _value.workoutSets
          : workoutSets // ignore: cast_nullable_to_non_nullable
              as List<WorkoutSetCreate>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutExerciseCreateImplCopyWith<$Res>
    implements $WorkoutExerciseCreateCopyWith<$Res> {
  factory _$$WorkoutExerciseCreateImplCopyWith(
          _$WorkoutExerciseCreateImpl value,
          $Res Function(_$WorkoutExerciseCreateImpl) then) =
      __$$WorkoutExerciseCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int exerciseId, int order, List<WorkoutSetCreate> workoutSets});
}

/// @nodoc
class __$$WorkoutExerciseCreateImplCopyWithImpl<$Res>
    extends _$WorkoutExerciseCreateCopyWithImpl<$Res,
        _$WorkoutExerciseCreateImpl>
    implements _$$WorkoutExerciseCreateImplCopyWith<$Res> {
  __$$WorkoutExerciseCreateImplCopyWithImpl(_$WorkoutExerciseCreateImpl _value,
      $Res Function(_$WorkoutExerciseCreateImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutExerciseCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseId = null,
    Object? order = null,
    Object? workoutSets = null,
  }) {
    return _then(_$WorkoutExerciseCreateImpl(
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as int,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      workoutSets: null == workoutSets
          ? _value._workoutSets
          : workoutSets // ignore: cast_nullable_to_non_nullable
              as List<WorkoutSetCreate>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutExerciseCreateImpl implements _WorkoutExerciseCreate {
  const _$WorkoutExerciseCreateImpl(
      {required this.exerciseId,
      required this.order,
      required final List<WorkoutSetCreate> workoutSets})
      : _workoutSets = workoutSets;

  factory _$WorkoutExerciseCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutExerciseCreateImplFromJson(json);

  @override
  final int exerciseId;
  @override
  final int order;
  final List<WorkoutSetCreate> _workoutSets;
  @override
  List<WorkoutSetCreate> get workoutSets {
    if (_workoutSets is EqualUnmodifiableListView) return _workoutSets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workoutSets);
  }

  @override
  String toString() {
    return 'WorkoutExerciseCreate(exerciseId: $exerciseId, order: $order, workoutSets: $workoutSets)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutExerciseCreateImpl &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            (identical(other.order, order) || other.order == order) &&
            const DeepCollectionEquality()
                .equals(other._workoutSets, _workoutSets));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, exerciseId, order,
      const DeepCollectionEquality().hash(_workoutSets));

  /// Create a copy of WorkoutExerciseCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutExerciseCreateImplCopyWith<_$WorkoutExerciseCreateImpl>
      get copyWith => __$$WorkoutExerciseCreateImplCopyWithImpl<
          _$WorkoutExerciseCreateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutExerciseCreateImplToJson(
      this,
    );
  }
}

abstract class _WorkoutExerciseCreate implements WorkoutExerciseCreate {
  const factory _WorkoutExerciseCreate(
          {required final int exerciseId,
          required final int order,
          required final List<WorkoutSetCreate> workoutSets}) =
      _$WorkoutExerciseCreateImpl;

  factory _WorkoutExerciseCreate.fromJson(Map<String, dynamic> json) =
      _$WorkoutExerciseCreateImpl.fromJson;

  @override
  int get exerciseId;
  @override
  int get order;
  @override
  List<WorkoutSetCreate> get workoutSets;

  /// Create a copy of WorkoutExerciseCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutExerciseCreateImplCopyWith<_$WorkoutExerciseCreateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

WorkoutSetCreate _$WorkoutSetCreateFromJson(Map<String, dynamic> json) {
  return _WorkoutSetCreate.fromJson(json);
}

/// @nodoc
mixin _$WorkoutSetCreate {
  int get order => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  int get reps => throw _privateConstructorUsedError;
  String? get feedback => throw _privateConstructorUsedError;

  /// Serializes this WorkoutSetCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutSetCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutSetCreateCopyWith<WorkoutSetCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutSetCreateCopyWith<$Res> {
  factory $WorkoutSetCreateCopyWith(
          WorkoutSetCreate value, $Res Function(WorkoutSetCreate) then) =
      _$WorkoutSetCreateCopyWithImpl<$Res, WorkoutSetCreate>;
  @useResult
  $Res call({int order, double weight, int reps, String? feedback});
}

/// @nodoc
class _$WorkoutSetCreateCopyWithImpl<$Res, $Val extends WorkoutSetCreate>
    implements $WorkoutSetCreateCopyWith<$Res> {
  _$WorkoutSetCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutSetCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? order = null,
    Object? weight = null,
    Object? reps = null,
    Object? feedback = freezed,
  }) {
    return _then(_value.copyWith(
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
      feedback: freezed == feedback
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutSetCreateImplCopyWith<$Res>
    implements $WorkoutSetCreateCopyWith<$Res> {
  factory _$$WorkoutSetCreateImplCopyWith(_$WorkoutSetCreateImpl value,
          $Res Function(_$WorkoutSetCreateImpl) then) =
      __$$WorkoutSetCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int order, double weight, int reps, String? feedback});
}

/// @nodoc
class __$$WorkoutSetCreateImplCopyWithImpl<$Res>
    extends _$WorkoutSetCreateCopyWithImpl<$Res, _$WorkoutSetCreateImpl>
    implements _$$WorkoutSetCreateImplCopyWith<$Res> {
  __$$WorkoutSetCreateImplCopyWithImpl(_$WorkoutSetCreateImpl _value,
      $Res Function(_$WorkoutSetCreateImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutSetCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? order = null,
    Object? weight = null,
    Object? reps = null,
    Object? feedback = freezed,
  }) {
    return _then(_$WorkoutSetCreateImpl(
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
      feedback: freezed == feedback
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutSetCreateImpl implements _WorkoutSetCreate {
  const _$WorkoutSetCreateImpl(
      {required this.order,
      required this.weight,
      required this.reps,
      this.feedback});

  factory _$WorkoutSetCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutSetCreateImplFromJson(json);

  @override
  final int order;
  @override
  final double weight;
  @override
  final int reps;
  @override
  final String? feedback;

  @override
  String toString() {
    return 'WorkoutSetCreate(order: $order, weight: $weight, reps: $reps, feedback: $feedback)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutSetCreateImpl &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.feedback, feedback) ||
                other.feedback == feedback));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, order, weight, reps, feedback);

  /// Create a copy of WorkoutSetCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutSetCreateImplCopyWith<_$WorkoutSetCreateImpl> get copyWith =>
      __$$WorkoutSetCreateImplCopyWithImpl<_$WorkoutSetCreateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutSetCreateImplToJson(
      this,
    );
  }
}

abstract class _WorkoutSetCreate implements WorkoutSetCreate {
  const factory _WorkoutSetCreate(
      {required final int order,
      required final double weight,
      required final int reps,
      final String? feedback}) = _$WorkoutSetCreateImpl;

  factory _WorkoutSetCreate.fromJson(Map<String, dynamic> json) =
      _$WorkoutSetCreateImpl.fromJson;

  @override
  int get order;
  @override
  double get weight;
  @override
  int get reps;
  @override
  String? get feedback;

  /// Create a copy of WorkoutSetCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutSetCreateImplCopyWith<_$WorkoutSetCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkoutLogEntry _$WorkoutLogEntryFromJson(Map<String, dynamic> json) {
  return _WorkoutLogEntry.fromJson(json);
}

/// @nodoc
mixin _$WorkoutLogEntry {
  int get exerciseId => throw _privateConstructorUsedError;
  List<WorkoutSet> get sets => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this WorkoutLogEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutLogEntryCopyWith<WorkoutLogEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutLogEntryCopyWith<$Res> {
  factory $WorkoutLogEntryCopyWith(
          WorkoutLogEntry value, $Res Function(WorkoutLogEntry) then) =
      _$WorkoutLogEntryCopyWithImpl<$Res, WorkoutLogEntry>;
  @useResult
  $Res call({int exerciseId, List<WorkoutSet> sets, String? notes});
}

/// @nodoc
class _$WorkoutLogEntryCopyWithImpl<$Res, $Val extends WorkoutLogEntry>
    implements $WorkoutLogEntryCopyWith<$Res> {
  _$WorkoutLogEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseId = null,
    Object? sets = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as int,
      sets: null == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<WorkoutSet>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutLogEntryImplCopyWith<$Res>
    implements $WorkoutLogEntryCopyWith<$Res> {
  factory _$$WorkoutLogEntryImplCopyWith(_$WorkoutLogEntryImpl value,
          $Res Function(_$WorkoutLogEntryImpl) then) =
      __$$WorkoutLogEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int exerciseId, List<WorkoutSet> sets, String? notes});
}

/// @nodoc
class __$$WorkoutLogEntryImplCopyWithImpl<$Res>
    extends _$WorkoutLogEntryCopyWithImpl<$Res, _$WorkoutLogEntryImpl>
    implements _$$WorkoutLogEntryImplCopyWith<$Res> {
  __$$WorkoutLogEntryImplCopyWithImpl(
      _$WorkoutLogEntryImpl _value, $Res Function(_$WorkoutLogEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exerciseId = null,
    Object? sets = null,
    Object? notes = freezed,
  }) {
    return _then(_$WorkoutLogEntryImpl(
      exerciseId: null == exerciseId
          ? _value.exerciseId
          : exerciseId // ignore: cast_nullable_to_non_nullable
              as int,
      sets: null == sets
          ? _value._sets
          : sets // ignore: cast_nullable_to_non_nullable
              as List<WorkoutSet>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutLogEntryImpl implements _WorkoutLogEntry {
  const _$WorkoutLogEntryImpl(
      {required this.exerciseId,
      required final List<WorkoutSet> sets,
      this.notes})
      : _sets = sets;

  factory _$WorkoutLogEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutLogEntryImplFromJson(json);

  @override
  final int exerciseId;
  final List<WorkoutSet> _sets;
  @override
  List<WorkoutSet> get sets {
    if (_sets is EqualUnmodifiableListView) return _sets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sets);
  }

  @override
  final String? notes;

  @override
  String toString() {
    return 'WorkoutLogEntry(exerciseId: $exerciseId, sets: $sets, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutLogEntryImpl &&
            (identical(other.exerciseId, exerciseId) ||
                other.exerciseId == exerciseId) &&
            const DeepCollectionEquality().equals(other._sets, _sets) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, exerciseId,
      const DeepCollectionEquality().hash(_sets), notes);

  /// Create a copy of WorkoutLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutLogEntryImplCopyWith<_$WorkoutLogEntryImpl> get copyWith =>
      __$$WorkoutLogEntryImplCopyWithImpl<_$WorkoutLogEntryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutLogEntryImplToJson(
      this,
    );
  }
}

abstract class _WorkoutLogEntry implements WorkoutLogEntry {
  const factory _WorkoutLogEntry(
      {required final int exerciseId,
      required final List<WorkoutSet> sets,
      final String? notes}) = _$WorkoutLogEntryImpl;

  factory _WorkoutLogEntry.fromJson(Map<String, dynamic> json) =
      _$WorkoutLogEntryImpl.fromJson;

  @override
  int get exerciseId;
  @override
  List<WorkoutSet> get sets;
  @override
  String? get notes;

  /// Create a copy of WorkoutLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutLogEntryImplCopyWith<_$WorkoutLogEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkoutSet _$WorkoutSetFromJson(Map<String, dynamic> json) {
  return _WorkoutSet.fromJson(json);
}

/// @nodoc
mixin _$WorkoutSet {
  int get reps => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError;

  /// Serializes this WorkoutSet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutSetCopyWith<WorkoutSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutSetCopyWith<$Res> {
  factory $WorkoutSetCopyWith(
          WorkoutSet value, $Res Function(WorkoutSet) then) =
      _$WorkoutSetCopyWithImpl<$Res, WorkoutSet>;
  @useResult
  $Res call({int reps, double weight, int? duration});
}

/// @nodoc
class _$WorkoutSetCopyWithImpl<$Res, $Val extends WorkoutSet>
    implements $WorkoutSetCopyWith<$Res> {
  _$WorkoutSetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reps = null,
    Object? weight = null,
    Object? duration = freezed,
  }) {
    return _then(_value.copyWith(
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutSetImplCopyWith<$Res>
    implements $WorkoutSetCopyWith<$Res> {
  factory _$$WorkoutSetImplCopyWith(
          _$WorkoutSetImpl value, $Res Function(_$WorkoutSetImpl) then) =
      __$$WorkoutSetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int reps, double weight, int? duration});
}

/// @nodoc
class __$$WorkoutSetImplCopyWithImpl<$Res>
    extends _$WorkoutSetCopyWithImpl<$Res, _$WorkoutSetImpl>
    implements _$$WorkoutSetImplCopyWith<$Res> {
  __$$WorkoutSetImplCopyWithImpl(
      _$WorkoutSetImpl _value, $Res Function(_$WorkoutSetImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutSet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reps = null,
    Object? weight = null,
    Object? duration = freezed,
  }) {
    return _then(_$WorkoutSetImpl(
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutSetImpl implements _WorkoutSet {
  const _$WorkoutSetImpl(
      {required this.reps, required this.weight, this.duration});

  factory _$WorkoutSetImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutSetImplFromJson(json);

  @override
  final int reps;
  @override
  final double weight;
  @override
  final int? duration;

  @override
  String toString() {
    return 'WorkoutSet(reps: $reps, weight: $weight, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutSetImpl &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, reps, weight, duration);

  /// Create a copy of WorkoutSet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutSetImplCopyWith<_$WorkoutSetImpl> get copyWith =>
      __$$WorkoutSetImplCopyWithImpl<_$WorkoutSetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutSetImplToJson(
      this,
    );
  }
}

abstract class _WorkoutSet implements WorkoutSet {
  const factory _WorkoutSet(
      {required final int reps,
      required final double weight,
      final int? duration}) = _$WorkoutSetImpl;

  factory _WorkoutSet.fromJson(Map<String, dynamic> json) =
      _$WorkoutSetImpl.fromJson;

  @override
  int get reps;
  @override
  double get weight;
  @override
  int? get duration;

  /// Create a copy of WorkoutSet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutSetImplCopyWith<_$WorkoutSetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PtSession _$PtSessionFromJson(Map<String, dynamic> json) {
  return _PtSession.fromJson(json);
}

/// @nodoc
mixin _$PtSession {
  int get ptSessionId => throw _privateConstructorUsedError;
  int get appointmentId => throw _privateConstructorUsedError;
  String get sessionDate => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  List<WorkoutLogEntry> get workoutLogs => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this PtSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PtSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PtSessionCopyWith<PtSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PtSessionCopyWith<$Res> {
  factory $PtSessionCopyWith(PtSession value, $Res Function(PtSession) then) =
      _$PtSessionCopyWithImpl<$Res, PtSession>;
  @useResult
  $Res call(
      {int ptSessionId,
      int appointmentId,
      String sessionDate,
      String notes,
      List<WorkoutLogEntry> workoutLogs,
      DateTime createdAt});
}

/// @nodoc
class _$PtSessionCopyWithImpl<$Res, $Val extends PtSession>
    implements $PtSessionCopyWith<$Res> {
  _$PtSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PtSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ptSessionId = null,
    Object? appointmentId = null,
    Object? sessionDate = null,
    Object? notes = null,
    Object? workoutLogs = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      ptSessionId: null == ptSessionId
          ? _value.ptSessionId
          : ptSessionId // ignore: cast_nullable_to_non_nullable
              as int,
      appointmentId: null == appointmentId
          ? _value.appointmentId
          : appointmentId // ignore: cast_nullable_to_non_nullable
              as int,
      sessionDate: null == sessionDate
          ? _value.sessionDate
          : sessionDate // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      workoutLogs: null == workoutLogs
          ? _value.workoutLogs
          : workoutLogs // ignore: cast_nullable_to_non_nullable
              as List<WorkoutLogEntry>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PtSessionImplCopyWith<$Res>
    implements $PtSessionCopyWith<$Res> {
  factory _$$PtSessionImplCopyWith(
          _$PtSessionImpl value, $Res Function(_$PtSessionImpl) then) =
      __$$PtSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int ptSessionId,
      int appointmentId,
      String sessionDate,
      String notes,
      List<WorkoutLogEntry> workoutLogs,
      DateTime createdAt});
}

/// @nodoc
class __$$PtSessionImplCopyWithImpl<$Res>
    extends _$PtSessionCopyWithImpl<$Res, _$PtSessionImpl>
    implements _$$PtSessionImplCopyWith<$Res> {
  __$$PtSessionImplCopyWithImpl(
      _$PtSessionImpl _value, $Res Function(_$PtSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PtSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ptSessionId = null,
    Object? appointmentId = null,
    Object? sessionDate = null,
    Object? notes = null,
    Object? workoutLogs = null,
    Object? createdAt = null,
  }) {
    return _then(_$PtSessionImpl(
      ptSessionId: null == ptSessionId
          ? _value.ptSessionId
          : ptSessionId // ignore: cast_nullable_to_non_nullable
              as int,
      appointmentId: null == appointmentId
          ? _value.appointmentId
          : appointmentId // ignore: cast_nullable_to_non_nullable
              as int,
      sessionDate: null == sessionDate
          ? _value.sessionDate
          : sessionDate // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      workoutLogs: null == workoutLogs
          ? _value._workoutLogs
          : workoutLogs // ignore: cast_nullable_to_non_nullable
              as List<WorkoutLogEntry>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PtSessionImpl implements _PtSession {
  const _$PtSessionImpl(
      {required this.ptSessionId,
      required this.appointmentId,
      required this.sessionDate,
      required this.notes,
      required final List<WorkoutLogEntry> workoutLogs,
      required this.createdAt})
      : _workoutLogs = workoutLogs;

  factory _$PtSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PtSessionImplFromJson(json);

  @override
  final int ptSessionId;
  @override
  final int appointmentId;
  @override
  final String sessionDate;
  @override
  final String notes;
  final List<WorkoutLogEntry> _workoutLogs;
  @override
  List<WorkoutLogEntry> get workoutLogs {
    if (_workoutLogs is EqualUnmodifiableListView) return _workoutLogs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workoutLogs);
  }

  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'PtSession(ptSessionId: $ptSessionId, appointmentId: $appointmentId, sessionDate: $sessionDate, notes: $notes, workoutLogs: $workoutLogs, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PtSessionImpl &&
            (identical(other.ptSessionId, ptSessionId) ||
                other.ptSessionId == ptSessionId) &&
            (identical(other.appointmentId, appointmentId) ||
                other.appointmentId == appointmentId) &&
            (identical(other.sessionDate, sessionDate) ||
                other.sessionDate == sessionDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality()
                .equals(other._workoutLogs, _workoutLogs) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      ptSessionId,
      appointmentId,
      sessionDate,
      notes,
      const DeepCollectionEquality().hash(_workoutLogs),
      createdAt);

  /// Create a copy of PtSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PtSessionImplCopyWith<_$PtSessionImpl> get copyWith =>
      __$$PtSessionImplCopyWithImpl<_$PtSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PtSessionImplToJson(
      this,
    );
  }
}

abstract class _PtSession implements PtSession {
  const factory _PtSession(
      {required final int ptSessionId,
      required final int appointmentId,
      required final String sessionDate,
      required final String notes,
      required final List<WorkoutLogEntry> workoutLogs,
      required final DateTime createdAt}) = _$PtSessionImpl;

  factory _PtSession.fromJson(Map<String, dynamic> json) =
      _$PtSessionImpl.fromJson;

  @override
  int get ptSessionId;
  @override
  int get appointmentId;
  @override
  String get sessionDate;
  @override
  String get notes;
  @override
  List<WorkoutLogEntry> get workoutLogs;
  @override
  DateTime get createdAt;

  /// Create a copy of PtSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PtSessionImplCopyWith<_$PtSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
