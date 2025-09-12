// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pt_session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PtSessionListResponse _$PtSessionListResponseFromJson(
    Map<String, dynamic> json) {
  return _PtSessionListResponse.fromJson(json);
}

/// @nodoc
mixin _$PtSessionListResponse {
  List<PtSessionResponse> get data => throw _privateConstructorUsedError;
  PageInfo get pageInfo => throw _privateConstructorUsedError;

  /// Serializes this PtSessionListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PtSessionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PtSessionListResponseCopyWith<PtSessionListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PtSessionListResponseCopyWith<$Res> {
  factory $PtSessionListResponseCopyWith(PtSessionListResponse value,
          $Res Function(PtSessionListResponse) then) =
      _$PtSessionListResponseCopyWithImpl<$Res, PtSessionListResponse>;
  @useResult
  $Res call({List<PtSessionResponse> data, PageInfo pageInfo});

  $PageInfoCopyWith<$Res> get pageInfo;
}

/// @nodoc
class _$PtSessionListResponseCopyWithImpl<$Res,
        $Val extends PtSessionListResponse>
    implements $PtSessionListResponseCopyWith<$Res> {
  _$PtSessionListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PtSessionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? pageInfo = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<PtSessionResponse>,
      pageInfo: null == pageInfo
          ? _value.pageInfo
          : pageInfo // ignore: cast_nullable_to_non_nullable
              as PageInfo,
    ) as $Val);
  }

  /// Create a copy of PtSessionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PageInfoCopyWith<$Res> get pageInfo {
    return $PageInfoCopyWith<$Res>(_value.pageInfo, (value) {
      return _then(_value.copyWith(pageInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PtSessionListResponseImplCopyWith<$Res>
    implements $PtSessionListResponseCopyWith<$Res> {
  factory _$$PtSessionListResponseImplCopyWith(
          _$PtSessionListResponseImpl value,
          $Res Function(_$PtSessionListResponseImpl) then) =
      __$$PtSessionListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<PtSessionResponse> data, PageInfo pageInfo});

  @override
  $PageInfoCopyWith<$Res> get pageInfo;
}

/// @nodoc
class __$$PtSessionListResponseImplCopyWithImpl<$Res>
    extends _$PtSessionListResponseCopyWithImpl<$Res,
        _$PtSessionListResponseImpl>
    implements _$$PtSessionListResponseImplCopyWith<$Res> {
  __$$PtSessionListResponseImplCopyWithImpl(_$PtSessionListResponseImpl _value,
      $Res Function(_$PtSessionListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PtSessionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? pageInfo = null,
  }) {
    return _then(_$PtSessionListResponseImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<PtSessionResponse>,
      pageInfo: null == pageInfo
          ? _value.pageInfo
          : pageInfo // ignore: cast_nullable_to_non_nullable
              as PageInfo,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PtSessionListResponseImpl implements _PtSessionListResponse {
  const _$PtSessionListResponseImpl(
      {required final List<PtSessionResponse> data, required this.pageInfo})
      : _data = data;

  factory _$PtSessionListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PtSessionListResponseImplFromJson(json);

  final List<PtSessionResponse> _data;
  @override
  List<PtSessionResponse> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final PageInfo pageInfo;

  @override
  String toString() {
    return 'PtSessionListResponse(data: $data, pageInfo: $pageInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PtSessionListResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.pageInfo, pageInfo) ||
                other.pageInfo == pageInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), pageInfo);

  /// Create a copy of PtSessionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PtSessionListResponseImplCopyWith<_$PtSessionListResponseImpl>
      get copyWith => __$$PtSessionListResponseImplCopyWithImpl<
          _$PtSessionListResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PtSessionListResponseImplToJson(
      this,
    );
  }
}

abstract class _PtSessionListResponse implements PtSessionListResponse {
  const factory _PtSessionListResponse(
      {required final List<PtSessionResponse> data,
      required final PageInfo pageInfo}) = _$PtSessionListResponseImpl;

  factory _PtSessionListResponse.fromJson(Map<String, dynamic> json) =
      _$PtSessionListResponseImpl.fromJson;

  @override
  List<PtSessionResponse> get data;
  @override
  PageInfo get pageInfo;

  /// Create a copy of PtSessionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PtSessionListResponseImplCopyWith<_$PtSessionListResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PtSessionResponse _$PtSessionResponseFromJson(Map<String, dynamic> json) {
  return _PtSessionResponse.fromJson(json);
}

/// @nodoc
mixin _$PtSessionResponse {
  int get id => throw _privateConstructorUsedError;
  WorkoutLogResponse? get workoutLogResponse =>
      throw _privateConstructorUsedError;

  /// Serializes this PtSessionResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PtSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PtSessionResponseCopyWith<PtSessionResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PtSessionResponseCopyWith<$Res> {
  factory $PtSessionResponseCopyWith(
          PtSessionResponse value, $Res Function(PtSessionResponse) then) =
      _$PtSessionResponseCopyWithImpl<$Res, PtSessionResponse>;
  @useResult
  $Res call({int id, WorkoutLogResponse? workoutLogResponse});

  $WorkoutLogResponseCopyWith<$Res>? get workoutLogResponse;
}

/// @nodoc
class _$PtSessionResponseCopyWithImpl<$Res, $Val extends PtSessionResponse>
    implements $PtSessionResponseCopyWith<$Res> {
  _$PtSessionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PtSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workoutLogResponse = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      workoutLogResponse: freezed == workoutLogResponse
          ? _value.workoutLogResponse
          : workoutLogResponse // ignore: cast_nullable_to_non_nullable
              as WorkoutLogResponse?,
    ) as $Val);
  }

  /// Create a copy of PtSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WorkoutLogResponseCopyWith<$Res>? get workoutLogResponse {
    if (_value.workoutLogResponse == null) {
      return null;
    }

    return $WorkoutLogResponseCopyWith<$Res>(_value.workoutLogResponse!,
        (value) {
      return _then(_value.copyWith(workoutLogResponse: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PtSessionResponseImplCopyWith<$Res>
    implements $PtSessionResponseCopyWith<$Res> {
  factory _$$PtSessionResponseImplCopyWith(_$PtSessionResponseImpl value,
          $Res Function(_$PtSessionResponseImpl) then) =
      __$$PtSessionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, WorkoutLogResponse? workoutLogResponse});

  @override
  $WorkoutLogResponseCopyWith<$Res>? get workoutLogResponse;
}

/// @nodoc
class __$$PtSessionResponseImplCopyWithImpl<$Res>
    extends _$PtSessionResponseCopyWithImpl<$Res, _$PtSessionResponseImpl>
    implements _$$PtSessionResponseImplCopyWith<$Res> {
  __$$PtSessionResponseImplCopyWithImpl(_$PtSessionResponseImpl _value,
      $Res Function(_$PtSessionResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PtSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workoutLogResponse = freezed,
  }) {
    return _then(_$PtSessionResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      workoutLogResponse: freezed == workoutLogResponse
          ? _value.workoutLogResponse
          : workoutLogResponse // ignore: cast_nullable_to_non_nullable
              as WorkoutLogResponse?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PtSessionResponseImpl implements _PtSessionResponse {
  const _$PtSessionResponseImpl({required this.id, this.workoutLogResponse});

  factory _$PtSessionResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PtSessionResponseImplFromJson(json);

  @override
  final int id;
  @override
  final WorkoutLogResponse? workoutLogResponse;

  @override
  String toString() {
    return 'PtSessionResponse(id: $id, workoutLogResponse: $workoutLogResponse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PtSessionResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workoutLogResponse, workoutLogResponse) ||
                other.workoutLogResponse == workoutLogResponse));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, workoutLogResponse);

  /// Create a copy of PtSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PtSessionResponseImplCopyWith<_$PtSessionResponseImpl> get copyWith =>
      __$$PtSessionResponseImplCopyWithImpl<_$PtSessionResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PtSessionResponseImplToJson(
      this,
    );
  }
}

abstract class _PtSessionResponse implements PtSessionResponse {
  const factory _PtSessionResponse(
      {required final int id,
      final WorkoutLogResponse? workoutLogResponse}) = _$PtSessionResponseImpl;

  factory _PtSessionResponse.fromJson(Map<String, dynamic> json) =
      _$PtSessionResponseImpl.fromJson;

  @override
  int get id;
  @override
  WorkoutLogResponse? get workoutLogResponse;

  /// Create a copy of PtSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PtSessionResponseImplCopyWith<_$PtSessionResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkoutLogResponse _$WorkoutLogResponseFromJson(Map<String, dynamic> json) {
  return _WorkoutLogResponse.fromJson(json);
}

/// @nodoc
mixin _$WorkoutLogResponse {
  int get workoutLogId => throw _privateConstructorUsedError;
  String get workoutDate => throw _privateConstructorUsedError;
  List<FeedbackResponse> get feedbacks => throw _privateConstructorUsedError;
  List<WorkoutExerciseResponse> get workoutExercises =>
      throw _privateConstructorUsedError;

  /// Serializes this WorkoutLogResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutLogResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutLogResponseCopyWith<WorkoutLogResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutLogResponseCopyWith<$Res> {
  factory $WorkoutLogResponseCopyWith(
          WorkoutLogResponse value, $Res Function(WorkoutLogResponse) then) =
      _$WorkoutLogResponseCopyWithImpl<$Res, WorkoutLogResponse>;
  @useResult
  $Res call(
      {int workoutLogId,
      String workoutDate,
      List<FeedbackResponse> feedbacks,
      List<WorkoutExerciseResponse> workoutExercises});
}

/// @nodoc
class _$WorkoutLogResponseCopyWithImpl<$Res, $Val extends WorkoutLogResponse>
    implements $WorkoutLogResponseCopyWith<$Res> {
  _$WorkoutLogResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutLogResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutLogId = null,
    Object? workoutDate = null,
    Object? feedbacks = null,
    Object? workoutExercises = null,
  }) {
    return _then(_value.copyWith(
      workoutLogId: null == workoutLogId
          ? _value.workoutLogId
          : workoutLogId // ignore: cast_nullable_to_non_nullable
              as int,
      workoutDate: null == workoutDate
          ? _value.workoutDate
          : workoutDate // ignore: cast_nullable_to_non_nullable
              as String,
      feedbacks: null == feedbacks
          ? _value.feedbacks
          : feedbacks // ignore: cast_nullable_to_non_nullable
              as List<FeedbackResponse>,
      workoutExercises: null == workoutExercises
          ? _value.workoutExercises
          : workoutExercises // ignore: cast_nullable_to_non_nullable
              as List<WorkoutExerciseResponse>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutLogResponseImplCopyWith<$Res>
    implements $WorkoutLogResponseCopyWith<$Res> {
  factory _$$WorkoutLogResponseImplCopyWith(_$WorkoutLogResponseImpl value,
          $Res Function(_$WorkoutLogResponseImpl) then) =
      __$$WorkoutLogResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int workoutLogId,
      String workoutDate,
      List<FeedbackResponse> feedbacks,
      List<WorkoutExerciseResponse> workoutExercises});
}

/// @nodoc
class __$$WorkoutLogResponseImplCopyWithImpl<$Res>
    extends _$WorkoutLogResponseCopyWithImpl<$Res, _$WorkoutLogResponseImpl>
    implements _$$WorkoutLogResponseImplCopyWith<$Res> {
  __$$WorkoutLogResponseImplCopyWithImpl(_$WorkoutLogResponseImpl _value,
      $Res Function(_$WorkoutLogResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutLogResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutLogId = null,
    Object? workoutDate = null,
    Object? feedbacks = null,
    Object? workoutExercises = null,
  }) {
    return _then(_$WorkoutLogResponseImpl(
      workoutLogId: null == workoutLogId
          ? _value.workoutLogId
          : workoutLogId // ignore: cast_nullable_to_non_nullable
              as int,
      workoutDate: null == workoutDate
          ? _value.workoutDate
          : workoutDate // ignore: cast_nullable_to_non_nullable
              as String,
      feedbacks: null == feedbacks
          ? _value._feedbacks
          : feedbacks // ignore: cast_nullable_to_non_nullable
              as List<FeedbackResponse>,
      workoutExercises: null == workoutExercises
          ? _value._workoutExercises
          : workoutExercises // ignore: cast_nullable_to_non_nullable
              as List<WorkoutExerciseResponse>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutLogResponseImpl implements _WorkoutLogResponse {
  const _$WorkoutLogResponseImpl(
      {required this.workoutLogId,
      required this.workoutDate,
      final List<FeedbackResponse> feedbacks = const [],
      final List<WorkoutExerciseResponse> workoutExercises = const []})
      : _feedbacks = feedbacks,
        _workoutExercises = workoutExercises;

  factory _$WorkoutLogResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutLogResponseImplFromJson(json);

  @override
  final int workoutLogId;
  @override
  final String workoutDate;
  final List<FeedbackResponse> _feedbacks;
  @override
  @JsonKey()
  List<FeedbackResponse> get feedbacks {
    if (_feedbacks is EqualUnmodifiableListView) return _feedbacks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_feedbacks);
  }

  final List<WorkoutExerciseResponse> _workoutExercises;
  @override
  @JsonKey()
  List<WorkoutExerciseResponse> get workoutExercises {
    if (_workoutExercises is EqualUnmodifiableListView)
      return _workoutExercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workoutExercises);
  }

  @override
  String toString() {
    return 'WorkoutLogResponse(workoutLogId: $workoutLogId, workoutDate: $workoutDate, feedbacks: $feedbacks, workoutExercises: $workoutExercises)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutLogResponseImpl &&
            (identical(other.workoutLogId, workoutLogId) ||
                other.workoutLogId == workoutLogId) &&
            (identical(other.workoutDate, workoutDate) ||
                other.workoutDate == workoutDate) &&
            const DeepCollectionEquality()
                .equals(other._feedbacks, _feedbacks) &&
            const DeepCollectionEquality()
                .equals(other._workoutExercises, _workoutExercises));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      workoutLogId,
      workoutDate,
      const DeepCollectionEquality().hash(_feedbacks),
      const DeepCollectionEquality().hash(_workoutExercises));

  /// Create a copy of WorkoutLogResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutLogResponseImplCopyWith<_$WorkoutLogResponseImpl> get copyWith =>
      __$$WorkoutLogResponseImplCopyWithImpl<_$WorkoutLogResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutLogResponseImplToJson(
      this,
    );
  }
}

abstract class _WorkoutLogResponse implements WorkoutLogResponse {
  const factory _WorkoutLogResponse(
          {required final int workoutLogId,
          required final String workoutDate,
          final List<FeedbackResponse> feedbacks,
          final List<WorkoutExerciseResponse> workoutExercises}) =
      _$WorkoutLogResponseImpl;

  factory _WorkoutLogResponse.fromJson(Map<String, dynamic> json) =
      _$WorkoutLogResponseImpl.fromJson;

  @override
  int get workoutLogId;
  @override
  String get workoutDate;
  @override
  List<FeedbackResponse> get feedbacks;
  @override
  List<WorkoutExerciseResponse> get workoutExercises;

  /// Create a copy of WorkoutLogResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutLogResponseImplCopyWith<_$WorkoutLogResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkoutExerciseResponse _$WorkoutExerciseResponseFromJson(
    Map<String, dynamic> json) {
  return _WorkoutExerciseResponse.fromJson(json);
}

/// @nodoc
mixin _$WorkoutExerciseResponse {
  int get workoutExerciseId => throw _privateConstructorUsedError;
  String get exerciseName => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  List<WorkoutSetResponse> get workoutSets =>
      throw _privateConstructorUsedError;
  List<FeedbackResponse> get feedbacks => throw _privateConstructorUsedError;

  /// Serializes this WorkoutExerciseResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutExerciseResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutExerciseResponseCopyWith<WorkoutExerciseResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutExerciseResponseCopyWith<$Res> {
  factory $WorkoutExerciseResponseCopyWith(WorkoutExerciseResponse value,
          $Res Function(WorkoutExerciseResponse) then) =
      _$WorkoutExerciseResponseCopyWithImpl<$Res, WorkoutExerciseResponse>;
  @useResult
  $Res call(
      {int workoutExerciseId,
      String exerciseName,
      int order,
      List<WorkoutSetResponse> workoutSets,
      List<FeedbackResponse> feedbacks});
}

/// @nodoc
class _$WorkoutExerciseResponseCopyWithImpl<$Res,
        $Val extends WorkoutExerciseResponse>
    implements $WorkoutExerciseResponseCopyWith<$Res> {
  _$WorkoutExerciseResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutExerciseResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutExerciseId = null,
    Object? exerciseName = null,
    Object? order = null,
    Object? workoutSets = null,
    Object? feedbacks = null,
  }) {
    return _then(_value.copyWith(
      workoutExerciseId: null == workoutExerciseId
          ? _value.workoutExerciseId
          : workoutExerciseId // ignore: cast_nullable_to_non_nullable
              as int,
      exerciseName: null == exerciseName
          ? _value.exerciseName
          : exerciseName // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      workoutSets: null == workoutSets
          ? _value.workoutSets
          : workoutSets // ignore: cast_nullable_to_non_nullable
              as List<WorkoutSetResponse>,
      feedbacks: null == feedbacks
          ? _value.feedbacks
          : feedbacks // ignore: cast_nullable_to_non_nullable
              as List<FeedbackResponse>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutExerciseResponseImplCopyWith<$Res>
    implements $WorkoutExerciseResponseCopyWith<$Res> {
  factory _$$WorkoutExerciseResponseImplCopyWith(
          _$WorkoutExerciseResponseImpl value,
          $Res Function(_$WorkoutExerciseResponseImpl) then) =
      __$$WorkoutExerciseResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int workoutExerciseId,
      String exerciseName,
      int order,
      List<WorkoutSetResponse> workoutSets,
      List<FeedbackResponse> feedbacks});
}

/// @nodoc
class __$$WorkoutExerciseResponseImplCopyWithImpl<$Res>
    extends _$WorkoutExerciseResponseCopyWithImpl<$Res,
        _$WorkoutExerciseResponseImpl>
    implements _$$WorkoutExerciseResponseImplCopyWith<$Res> {
  __$$WorkoutExerciseResponseImplCopyWithImpl(
      _$WorkoutExerciseResponseImpl _value,
      $Res Function(_$WorkoutExerciseResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutExerciseResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutExerciseId = null,
    Object? exerciseName = null,
    Object? order = null,
    Object? workoutSets = null,
    Object? feedbacks = null,
  }) {
    return _then(_$WorkoutExerciseResponseImpl(
      workoutExerciseId: null == workoutExerciseId
          ? _value.workoutExerciseId
          : workoutExerciseId // ignore: cast_nullable_to_non_nullable
              as int,
      exerciseName: null == exerciseName
          ? _value.exerciseName
          : exerciseName // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      workoutSets: null == workoutSets
          ? _value._workoutSets
          : workoutSets // ignore: cast_nullable_to_non_nullable
              as List<WorkoutSetResponse>,
      feedbacks: null == feedbacks
          ? _value._feedbacks
          : feedbacks // ignore: cast_nullable_to_non_nullable
              as List<FeedbackResponse>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutExerciseResponseImpl implements _WorkoutExerciseResponse {
  const _$WorkoutExerciseResponseImpl(
      {required this.workoutExerciseId,
      required this.exerciseName,
      required this.order,
      final List<WorkoutSetResponse> workoutSets = const [],
      final List<FeedbackResponse> feedbacks = const []})
      : _workoutSets = workoutSets,
        _feedbacks = feedbacks;

  factory _$WorkoutExerciseResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutExerciseResponseImplFromJson(json);

  @override
  final int workoutExerciseId;
  @override
  final String exerciseName;
  @override
  final int order;
  final List<WorkoutSetResponse> _workoutSets;
  @override
  @JsonKey()
  List<WorkoutSetResponse> get workoutSets {
    if (_workoutSets is EqualUnmodifiableListView) return _workoutSets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workoutSets);
  }

  final List<FeedbackResponse> _feedbacks;
  @override
  @JsonKey()
  List<FeedbackResponse> get feedbacks {
    if (_feedbacks is EqualUnmodifiableListView) return _feedbacks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_feedbacks);
  }

  @override
  String toString() {
    return 'WorkoutExerciseResponse(workoutExerciseId: $workoutExerciseId, exerciseName: $exerciseName, order: $order, workoutSets: $workoutSets, feedbacks: $feedbacks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutExerciseResponseImpl &&
            (identical(other.workoutExerciseId, workoutExerciseId) ||
                other.workoutExerciseId == workoutExerciseId) &&
            (identical(other.exerciseName, exerciseName) ||
                other.exerciseName == exerciseName) &&
            (identical(other.order, order) || other.order == order) &&
            const DeepCollectionEquality()
                .equals(other._workoutSets, _workoutSets) &&
            const DeepCollectionEquality()
                .equals(other._feedbacks, _feedbacks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      workoutExerciseId,
      exerciseName,
      order,
      const DeepCollectionEquality().hash(_workoutSets),
      const DeepCollectionEquality().hash(_feedbacks));

  /// Create a copy of WorkoutExerciseResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutExerciseResponseImplCopyWith<_$WorkoutExerciseResponseImpl>
      get copyWith => __$$WorkoutExerciseResponseImplCopyWithImpl<
          _$WorkoutExerciseResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutExerciseResponseImplToJson(
      this,
    );
  }
}

abstract class _WorkoutExerciseResponse implements WorkoutExerciseResponse {
  const factory _WorkoutExerciseResponse(
      {required final int workoutExerciseId,
      required final String exerciseName,
      required final int order,
      final List<WorkoutSetResponse> workoutSets,
      final List<FeedbackResponse> feedbacks}) = _$WorkoutExerciseResponseImpl;

  factory _WorkoutExerciseResponse.fromJson(Map<String, dynamic> json) =
      _$WorkoutExerciseResponseImpl.fromJson;

  @override
  int get workoutExerciseId;
  @override
  String get exerciseName;
  @override
  int get order;
  @override
  List<WorkoutSetResponse> get workoutSets;
  @override
  List<FeedbackResponse> get feedbacks;

  /// Create a copy of WorkoutExerciseResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutExerciseResponseImplCopyWith<_$WorkoutExerciseResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

WorkoutSetResponse _$WorkoutSetResponseFromJson(Map<String, dynamic> json) {
  return _WorkoutSetResponse.fromJson(json);
}

/// @nodoc
mixin _$WorkoutSetResponse {
  int get workoutSetId => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  int get reps => throw _privateConstructorUsedError;
  List<FeedbackResponse> get feedbacks => throw _privateConstructorUsedError;

  /// Serializes this WorkoutSetResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutSetResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutSetResponseCopyWith<WorkoutSetResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutSetResponseCopyWith<$Res> {
  factory $WorkoutSetResponseCopyWith(
          WorkoutSetResponse value, $Res Function(WorkoutSetResponse) then) =
      _$WorkoutSetResponseCopyWithImpl<$Res, WorkoutSetResponse>;
  @useResult
  $Res call(
      {int workoutSetId,
      int order,
      double weight,
      int reps,
      List<FeedbackResponse> feedbacks});
}

/// @nodoc
class _$WorkoutSetResponseCopyWithImpl<$Res, $Val extends WorkoutSetResponse>
    implements $WorkoutSetResponseCopyWith<$Res> {
  _$WorkoutSetResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutSetResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutSetId = null,
    Object? order = null,
    Object? weight = null,
    Object? reps = null,
    Object? feedbacks = null,
  }) {
    return _then(_value.copyWith(
      workoutSetId: null == workoutSetId
          ? _value.workoutSetId
          : workoutSetId // ignore: cast_nullable_to_non_nullable
              as int,
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
      feedbacks: null == feedbacks
          ? _value.feedbacks
          : feedbacks // ignore: cast_nullable_to_non_nullable
              as List<FeedbackResponse>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutSetResponseImplCopyWith<$Res>
    implements $WorkoutSetResponseCopyWith<$Res> {
  factory _$$WorkoutSetResponseImplCopyWith(_$WorkoutSetResponseImpl value,
          $Res Function(_$WorkoutSetResponseImpl) then) =
      __$$WorkoutSetResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int workoutSetId,
      int order,
      double weight,
      int reps,
      List<FeedbackResponse> feedbacks});
}

/// @nodoc
class __$$WorkoutSetResponseImplCopyWithImpl<$Res>
    extends _$WorkoutSetResponseCopyWithImpl<$Res, _$WorkoutSetResponseImpl>
    implements _$$WorkoutSetResponseImplCopyWith<$Res> {
  __$$WorkoutSetResponseImplCopyWithImpl(_$WorkoutSetResponseImpl _value,
      $Res Function(_$WorkoutSetResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkoutSetResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workoutSetId = null,
    Object? order = null,
    Object? weight = null,
    Object? reps = null,
    Object? feedbacks = null,
  }) {
    return _then(_$WorkoutSetResponseImpl(
      workoutSetId: null == workoutSetId
          ? _value.workoutSetId
          : workoutSetId // ignore: cast_nullable_to_non_nullable
              as int,
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
      feedbacks: null == feedbacks
          ? _value._feedbacks
          : feedbacks // ignore: cast_nullable_to_non_nullable
              as List<FeedbackResponse>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkoutSetResponseImpl implements _WorkoutSetResponse {
  const _$WorkoutSetResponseImpl(
      {required this.workoutSetId,
      required this.order,
      required this.weight,
      required this.reps,
      final List<FeedbackResponse> feedbacks = const []})
      : _feedbacks = feedbacks;

  factory _$WorkoutSetResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkoutSetResponseImplFromJson(json);

  @override
  final int workoutSetId;
  @override
  final int order;
  @override
  final double weight;
  @override
  final int reps;
  final List<FeedbackResponse> _feedbacks;
  @override
  @JsonKey()
  List<FeedbackResponse> get feedbacks {
    if (_feedbacks is EqualUnmodifiableListView) return _feedbacks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_feedbacks);
  }

  @override
  String toString() {
    return 'WorkoutSetResponse(workoutSetId: $workoutSetId, order: $order, weight: $weight, reps: $reps, feedbacks: $feedbacks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutSetResponseImpl &&
            (identical(other.workoutSetId, workoutSetId) ||
                other.workoutSetId == workoutSetId) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            const DeepCollectionEquality()
                .equals(other._feedbacks, _feedbacks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, workoutSetId, order, weight,
      reps, const DeepCollectionEquality().hash(_feedbacks));

  /// Create a copy of WorkoutSetResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutSetResponseImplCopyWith<_$WorkoutSetResponseImpl> get copyWith =>
      __$$WorkoutSetResponseImplCopyWithImpl<_$WorkoutSetResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkoutSetResponseImplToJson(
      this,
    );
  }
}

abstract class _WorkoutSetResponse implements WorkoutSetResponse {
  const factory _WorkoutSetResponse(
      {required final int workoutSetId,
      required final int order,
      required final double weight,
      required final int reps,
      final List<FeedbackResponse> feedbacks}) = _$WorkoutSetResponseImpl;

  factory _WorkoutSetResponse.fromJson(Map<String, dynamic> json) =
      _$WorkoutSetResponseImpl.fromJson;

  @override
  int get workoutSetId;
  @override
  int get order;
  @override
  double get weight;
  @override
  int get reps;
  @override
  List<FeedbackResponse> get feedbacks;

  /// Create a copy of WorkoutSetResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutSetResponseImplCopyWith<_$WorkoutSetResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedbackResponse _$FeedbackResponseFromJson(Map<String, dynamic> json) {
  return _FeedbackResponse.fromJson(json);
}

/// @nodoc
mixin _$FeedbackResponse {
  int get feedbackId => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  /// Serializes this FeedbackResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedbackResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedbackResponseCopyWith<FeedbackResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackResponseCopyWith<$Res> {
  factory $FeedbackResponseCopyWith(
          FeedbackResponse value, $Res Function(FeedbackResponse) then) =
      _$FeedbackResponseCopyWithImpl<$Res, FeedbackResponse>;
  @useResult
  $Res call({int feedbackId, String authorName, String content});
}

/// @nodoc
class _$FeedbackResponseCopyWithImpl<$Res, $Val extends FeedbackResponse>
    implements $FeedbackResponseCopyWith<$Res> {
  _$FeedbackResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedbackResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feedbackId = null,
    Object? authorName = null,
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      feedbackId: null == feedbackId
          ? _value.feedbackId
          : feedbackId // ignore: cast_nullable_to_non_nullable
              as int,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeedbackResponseImplCopyWith<$Res>
    implements $FeedbackResponseCopyWith<$Res> {
  factory _$$FeedbackResponseImplCopyWith(_$FeedbackResponseImpl value,
          $Res Function(_$FeedbackResponseImpl) then) =
      __$$FeedbackResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int feedbackId, String authorName, String content});
}

/// @nodoc
class __$$FeedbackResponseImplCopyWithImpl<$Res>
    extends _$FeedbackResponseCopyWithImpl<$Res, _$FeedbackResponseImpl>
    implements _$$FeedbackResponseImplCopyWith<$Res> {
  __$$FeedbackResponseImplCopyWithImpl(_$FeedbackResponseImpl _value,
      $Res Function(_$FeedbackResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedbackResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feedbackId = null,
    Object? authorName = null,
    Object? content = null,
  }) {
    return _then(_$FeedbackResponseImpl(
      feedbackId: null == feedbackId
          ? _value.feedbackId
          : feedbackId // ignore: cast_nullable_to_non_nullable
              as int,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedbackResponseImpl implements _FeedbackResponse {
  const _$FeedbackResponseImpl(
      {required this.feedbackId,
      required this.authorName,
      required this.content});

  factory _$FeedbackResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedbackResponseImplFromJson(json);

  @override
  final int feedbackId;
  @override
  final String authorName;
  @override
  final String content;

  @override
  String toString() {
    return 'FeedbackResponse(feedbackId: $feedbackId, authorName: $authorName, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackResponseImpl &&
            (identical(other.feedbackId, feedbackId) ||
                other.feedbackId == feedbackId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, feedbackId, authorName, content);

  /// Create a copy of FeedbackResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackResponseImplCopyWith<_$FeedbackResponseImpl> get copyWith =>
      __$$FeedbackResponseImplCopyWithImpl<_$FeedbackResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedbackResponseImplToJson(
      this,
    );
  }
}

abstract class _FeedbackResponse implements FeedbackResponse {
  const factory _FeedbackResponse(
      {required final int feedbackId,
      required final String authorName,
      required final String content}) = _$FeedbackResponseImpl;

  factory _FeedbackResponse.fromJson(Map<String, dynamic> json) =
      _$FeedbackResponseImpl.fromJson;

  @override
  int get feedbackId;
  @override
  String get authorName;
  @override
  String get content;

  /// Create a copy of FeedbackResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedbackResponseImplCopyWith<_$FeedbackResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PageInfo _$PageInfoFromJson(Map<String, dynamic> json) {
  return _PageInfo.fromJson(json);
}

/// @nodoc
mixin _$PageInfo {
  int get page => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  int get totalElements => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  bool get last => throw _privateConstructorUsedError;

  /// Serializes this PageInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PageInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PageInfoCopyWith<PageInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageInfoCopyWith<$Res> {
  factory $PageInfoCopyWith(PageInfo value, $Res Function(PageInfo) then) =
      _$PageInfoCopyWithImpl<$Res, PageInfo>;
  @useResult
  $Res call({int page, int size, int totalElements, int totalPages, bool last});
}

/// @nodoc
class _$PageInfoCopyWithImpl<$Res, $Val extends PageInfo>
    implements $PageInfoCopyWith<$Res> {
  _$PageInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PageInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? size = null,
    Object? totalElements = null,
    Object? totalPages = null,
    Object? last = null,
  }) {
    return _then(_value.copyWith(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      totalElements: null == totalElements
          ? _value.totalElements
          : totalElements // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      last: null == last
          ? _value.last
          : last // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PageInfoImplCopyWith<$Res>
    implements $PageInfoCopyWith<$Res> {
  factory _$$PageInfoImplCopyWith(
          _$PageInfoImpl value, $Res Function(_$PageInfoImpl) then) =
      __$$PageInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int page, int size, int totalElements, int totalPages, bool last});
}

/// @nodoc
class __$$PageInfoImplCopyWithImpl<$Res>
    extends _$PageInfoCopyWithImpl<$Res, _$PageInfoImpl>
    implements _$$PageInfoImplCopyWith<$Res> {
  __$$PageInfoImplCopyWithImpl(
      _$PageInfoImpl _value, $Res Function(_$PageInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PageInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? size = null,
    Object? totalElements = null,
    Object? totalPages = null,
    Object? last = null,
  }) {
    return _then(_$PageInfoImpl(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      totalElements: null == totalElements
          ? _value.totalElements
          : totalElements // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      last: null == last
          ? _value.last
          : last // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PageInfoImpl implements _PageInfo {
  const _$PageInfoImpl(
      {required this.page,
      required this.size,
      required this.totalElements,
      required this.totalPages,
      required this.last});

  factory _$PageInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PageInfoImplFromJson(json);

  @override
  final int page;
  @override
  final int size;
  @override
  final int totalElements;
  @override
  final int totalPages;
  @override
  final bool last;

  @override
  String toString() {
    return 'PageInfo(page: $page, size: $size, totalElements: $totalElements, totalPages: $totalPages, last: $last)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageInfoImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.totalElements, totalElements) ||
                other.totalElements == totalElements) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.last, last) || other.last == last));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, page, size, totalElements, totalPages, last);

  /// Create a copy of PageInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageInfoImplCopyWith<_$PageInfoImpl> get copyWith =>
      __$$PageInfoImplCopyWithImpl<_$PageInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PageInfoImplToJson(
      this,
    );
  }
}

abstract class _PageInfo implements PageInfo {
  const factory _PageInfo(
      {required final int page,
      required final int size,
      required final int totalElements,
      required final int totalPages,
      required final bool last}) = _$PageInfoImpl;

  factory _PageInfo.fromJson(Map<String, dynamic> json) =
      _$PageInfoImpl.fromJson;

  @override
  int get page;
  @override
  int get size;
  @override
  int get totalElements;
  @override
  int get totalPages;
  @override
  bool get last;

  /// Create a copy of PageInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageInfoImplCopyWith<_$PageInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
