// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pt_application_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PtApplication _$PtApplicationFromJson(Map<String, dynamic> json) {
  return _PtApplication.fromJson(json);
}

/// @nodoc
mixin _$PtApplication {
  @JsonKey(fromJson: _parseApplicationId)
  int get applicationId => throw _privateConstructorUsedError;
  String get memberName => throw _privateConstructorUsedError;
  String? get trainerName =>
      throw _privateConstructorUsedError; // 트레이너 이름 추가 (회원이 볼 때 필요)
  String get appliedAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseTotalSessions)
  int? get totalSessions =>
      throw _privateConstructorUsedError; // null 값을 허용하도록 변경
  String? get offeringTitle => throw _privateConstructorUsedError;

  /// Serializes this PtApplication to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PtApplication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PtApplicationCopyWith<PtApplication> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PtApplicationCopyWith<$Res> {
  factory $PtApplicationCopyWith(
          PtApplication value, $Res Function(PtApplication) then) =
      _$PtApplicationCopyWithImpl<$Res, PtApplication>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseApplicationId) int applicationId,
      String memberName,
      String? trainerName,
      String appliedAt,
      @JsonKey(fromJson: _parseTotalSessions) int? totalSessions,
      String? offeringTitle});
}

/// @nodoc
class _$PtApplicationCopyWithImpl<$Res, $Val extends PtApplication>
    implements $PtApplicationCopyWith<$Res> {
  _$PtApplicationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PtApplication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applicationId = null,
    Object? memberName = null,
    Object? trainerName = freezed,
    Object? appliedAt = null,
    Object? totalSessions = freezed,
    Object? offeringTitle = freezed,
  }) {
    return _then(_value.copyWith(
      applicationId: null == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
              as int,
      memberName: null == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      trainerName: freezed == trainerName
          ? _value.trainerName
          : trainerName // ignore: cast_nullable_to_non_nullable
              as String?,
      appliedAt: null == appliedAt
          ? _value.appliedAt
          : appliedAt // ignore: cast_nullable_to_non_nullable
              as String,
      totalSessions: freezed == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int?,
      offeringTitle: freezed == offeringTitle
          ? _value.offeringTitle
          : offeringTitle // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PtApplicationImplCopyWith<$Res>
    implements $PtApplicationCopyWith<$Res> {
  factory _$$PtApplicationImplCopyWith(
          _$PtApplicationImpl value, $Res Function(_$PtApplicationImpl) then) =
      __$$PtApplicationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseApplicationId) int applicationId,
      String memberName,
      String? trainerName,
      String appliedAt,
      @JsonKey(fromJson: _parseTotalSessions) int? totalSessions,
      String? offeringTitle});
}

/// @nodoc
class __$$PtApplicationImplCopyWithImpl<$Res>
    extends _$PtApplicationCopyWithImpl<$Res, _$PtApplicationImpl>
    implements _$$PtApplicationImplCopyWith<$Res> {
  __$$PtApplicationImplCopyWithImpl(
      _$PtApplicationImpl _value, $Res Function(_$PtApplicationImpl) _then)
      : super(_value, _then);

  /// Create a copy of PtApplication
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applicationId = null,
    Object? memberName = null,
    Object? trainerName = freezed,
    Object? appliedAt = null,
    Object? totalSessions = freezed,
    Object? offeringTitle = freezed,
  }) {
    return _then(_$PtApplicationImpl(
      applicationId: null == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
              as int,
      memberName: null == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      trainerName: freezed == trainerName
          ? _value.trainerName
          : trainerName // ignore: cast_nullable_to_non_nullable
              as String?,
      appliedAt: null == appliedAt
          ? _value.appliedAt
          : appliedAt // ignore: cast_nullable_to_non_nullable
              as String,
      totalSessions: freezed == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int?,
      offeringTitle: freezed == offeringTitle
          ? _value.offeringTitle
          : offeringTitle // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PtApplicationImpl implements _PtApplication {
  const _$PtApplicationImpl(
      {@JsonKey(fromJson: _parseApplicationId) required this.applicationId,
      required this.memberName,
      this.trainerName,
      required this.appliedAt,
      @JsonKey(fromJson: _parseTotalSessions) this.totalSessions,
      this.offeringTitle});

  factory _$PtApplicationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PtApplicationImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseApplicationId)
  final int applicationId;
  @override
  final String memberName;
  @override
  final String? trainerName;
// 트레이너 이름 추가 (회원이 볼 때 필요)
  @override
  final String appliedAt;
  @override
  @JsonKey(fromJson: _parseTotalSessions)
  final int? totalSessions;
// null 값을 허용하도록 변경
  @override
  final String? offeringTitle;

  @override
  String toString() {
    return 'PtApplication(applicationId: $applicationId, memberName: $memberName, trainerName: $trainerName, appliedAt: $appliedAt, totalSessions: $totalSessions, offeringTitle: $offeringTitle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PtApplicationImpl &&
            (identical(other.applicationId, applicationId) ||
                other.applicationId == applicationId) &&
            (identical(other.memberName, memberName) ||
                other.memberName == memberName) &&
            (identical(other.trainerName, trainerName) ||
                other.trainerName == trainerName) &&
            (identical(other.appliedAt, appliedAt) ||
                other.appliedAt == appliedAt) &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions) &&
            (identical(other.offeringTitle, offeringTitle) ||
                other.offeringTitle == offeringTitle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, applicationId, memberName,
      trainerName, appliedAt, totalSessions, offeringTitle);

  /// Create a copy of PtApplication
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PtApplicationImplCopyWith<_$PtApplicationImpl> get copyWith =>
      __$$PtApplicationImplCopyWithImpl<_$PtApplicationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PtApplicationImplToJson(
      this,
    );
  }
}

abstract class _PtApplication implements PtApplication {
  const factory _PtApplication(
      {@JsonKey(fromJson: _parseApplicationId) required final int applicationId,
      required final String memberName,
      final String? trainerName,
      required final String appliedAt,
      @JsonKey(fromJson: _parseTotalSessions) final int? totalSessions,
      final String? offeringTitle}) = _$PtApplicationImpl;

  factory _PtApplication.fromJson(Map<String, dynamic> json) =
      _$PtApplicationImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseApplicationId)
  int get applicationId;
  @override
  String get memberName;
  @override
  String? get trainerName; // 트레이너 이름 추가 (회원이 볼 때 필요)
  @override
  String get appliedAt;
  @override
  @JsonKey(fromJson: _parseTotalSessions)
  int? get totalSessions; // null 값을 허용하도록 변경
  @override
  String? get offeringTitle;

  /// Create a copy of PtApplication
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PtApplicationImplCopyWith<_$PtApplicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatePtApplicationRequest _$CreatePtApplicationRequestFromJson(
    Map<String, dynamic> json) {
  return _CreatePtApplicationRequest.fromJson(json);
}

/// @nodoc
mixin _$CreatePtApplicationRequest {
  int get offeringId => throw _privateConstructorUsedError;

  /// Serializes this CreatePtApplicationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatePtApplicationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatePtApplicationRequestCopyWith<CreatePtApplicationRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePtApplicationRequestCopyWith<$Res> {
  factory $CreatePtApplicationRequestCopyWith(CreatePtApplicationRequest value,
          $Res Function(CreatePtApplicationRequest) then) =
      _$CreatePtApplicationRequestCopyWithImpl<$Res,
          CreatePtApplicationRequest>;
  @useResult
  $Res call({int offeringId});
}

/// @nodoc
class _$CreatePtApplicationRequestCopyWithImpl<$Res,
        $Val extends CreatePtApplicationRequest>
    implements $CreatePtApplicationRequestCopyWith<$Res> {
  _$CreatePtApplicationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatePtApplicationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offeringId = null,
  }) {
    return _then(_value.copyWith(
      offeringId: null == offeringId
          ? _value.offeringId
          : offeringId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatePtApplicationRequestImplCopyWith<$Res>
    implements $CreatePtApplicationRequestCopyWith<$Res> {
  factory _$$CreatePtApplicationRequestImplCopyWith(
          _$CreatePtApplicationRequestImpl value,
          $Res Function(_$CreatePtApplicationRequestImpl) then) =
      __$$CreatePtApplicationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int offeringId});
}

/// @nodoc
class __$$CreatePtApplicationRequestImplCopyWithImpl<$Res>
    extends _$CreatePtApplicationRequestCopyWithImpl<$Res,
        _$CreatePtApplicationRequestImpl>
    implements _$$CreatePtApplicationRequestImplCopyWith<$Res> {
  __$$CreatePtApplicationRequestImplCopyWithImpl(
      _$CreatePtApplicationRequestImpl _value,
      $Res Function(_$CreatePtApplicationRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreatePtApplicationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offeringId = null,
  }) {
    return _then(_$CreatePtApplicationRequestImpl(
      offeringId: null == offeringId
          ? _value.offeringId
          : offeringId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePtApplicationRequestImpl implements _CreatePtApplicationRequest {
  const _$CreatePtApplicationRequestImpl({required this.offeringId});

  factory _$CreatePtApplicationRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CreatePtApplicationRequestImplFromJson(json);

  @override
  final int offeringId;

  @override
  String toString() {
    return 'CreatePtApplicationRequest(offeringId: $offeringId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePtApplicationRequestImpl &&
            (identical(other.offeringId, offeringId) ||
                other.offeringId == offeringId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, offeringId);

  /// Create a copy of CreatePtApplicationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePtApplicationRequestImplCopyWith<_$CreatePtApplicationRequestImpl>
      get copyWith => __$$CreatePtApplicationRequestImplCopyWithImpl<
          _$CreatePtApplicationRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePtApplicationRequestImplToJson(
      this,
    );
  }
}

abstract class _CreatePtApplicationRequest
    implements CreatePtApplicationRequest {
  const factory _CreatePtApplicationRequest({required final int offeringId}) =
      _$CreatePtApplicationRequestImpl;

  factory _CreatePtApplicationRequest.fromJson(Map<String, dynamic> json) =
      _$CreatePtApplicationRequestImpl.fromJson;

  @override
  int get offeringId;

  /// Create a copy of CreatePtApplicationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePtApplicationRequestImplCopyWith<_$CreatePtApplicationRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PtApplicationsResponse _$PtApplicationsResponseFromJson(
    Map<String, dynamic> json) {
  return _PtApplicationsResponse.fromJson(json);
}

/// @nodoc
mixin _$PtApplicationsResponse {
  List<PtApplication> get applications => throw _privateConstructorUsedError;

  /// Serializes this PtApplicationsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PtApplicationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PtApplicationsResponseCopyWith<PtApplicationsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PtApplicationsResponseCopyWith<$Res> {
  factory $PtApplicationsResponseCopyWith(PtApplicationsResponse value,
          $Res Function(PtApplicationsResponse) then) =
      _$PtApplicationsResponseCopyWithImpl<$Res, PtApplicationsResponse>;
  @useResult
  $Res call({List<PtApplication> applications});
}

/// @nodoc
class _$PtApplicationsResponseCopyWithImpl<$Res,
        $Val extends PtApplicationsResponse>
    implements $PtApplicationsResponseCopyWith<$Res> {
  _$PtApplicationsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PtApplicationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applications = null,
  }) {
    return _then(_value.copyWith(
      applications: null == applications
          ? _value.applications
          : applications // ignore: cast_nullable_to_non_nullable
              as List<PtApplication>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PtApplicationsResponseImplCopyWith<$Res>
    implements $PtApplicationsResponseCopyWith<$Res> {
  factory _$$PtApplicationsResponseImplCopyWith(
          _$PtApplicationsResponseImpl value,
          $Res Function(_$PtApplicationsResponseImpl) then) =
      __$$PtApplicationsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<PtApplication> applications});
}

/// @nodoc
class __$$PtApplicationsResponseImplCopyWithImpl<$Res>
    extends _$PtApplicationsResponseCopyWithImpl<$Res,
        _$PtApplicationsResponseImpl>
    implements _$$PtApplicationsResponseImplCopyWith<$Res> {
  __$$PtApplicationsResponseImplCopyWithImpl(
      _$PtApplicationsResponseImpl _value,
      $Res Function(_$PtApplicationsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PtApplicationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applications = null,
  }) {
    return _then(_$PtApplicationsResponseImpl(
      applications: null == applications
          ? _value._applications
          : applications // ignore: cast_nullable_to_non_nullable
              as List<PtApplication>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PtApplicationsResponseImpl implements _PtApplicationsResponse {
  const _$PtApplicationsResponseImpl(
      {required final List<PtApplication> applications})
      : _applications = applications;

  factory _$PtApplicationsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PtApplicationsResponseImplFromJson(json);

  final List<PtApplication> _applications;
  @override
  List<PtApplication> get applications {
    if (_applications is EqualUnmodifiableListView) return _applications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_applications);
  }

  @override
  String toString() {
    return 'PtApplicationsResponse(applications: $applications)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PtApplicationsResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._applications, _applications));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_applications));

  /// Create a copy of PtApplicationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PtApplicationsResponseImplCopyWith<_$PtApplicationsResponseImpl>
      get copyWith => __$$PtApplicationsResponseImplCopyWithImpl<
          _$PtApplicationsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PtApplicationsResponseImplToJson(
      this,
    );
  }
}

abstract class _PtApplicationsResponse implements PtApplicationsResponse {
  const factory _PtApplicationsResponse(
          {required final List<PtApplication> applications}) =
      _$PtApplicationsResponseImpl;

  factory _PtApplicationsResponse.fromJson(Map<String, dynamic> json) =
      _$PtApplicationsResponseImpl.fromJson;

  @override
  List<PtApplication> get applications;

  /// Create a copy of PtApplicationsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PtApplicationsResponseImplCopyWith<_$PtApplicationsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
