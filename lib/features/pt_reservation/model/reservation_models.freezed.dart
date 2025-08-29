// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReservationRequest _$ReservationRequestFromJson(Map<String, dynamic> json) {
  return _ReservationRequest.fromJson(json);
}

/// @nodoc
mixin _$ReservationRequest {
  String get id => throw _privateConstructorUsedError;
  String get memberId => throw _privateConstructorUsedError;
  String get memberName => throw _privateConstructorUsedError;
  String get trainerId => throw _privateConstructorUsedError;
  String get trainerName => throw _privateConstructorUsedError;
  DateTime get requestedDateTime => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  ReservationType get type => throw _privateConstructorUsedError;
  ReservationStatus get status => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get responseMessage => throw _privateConstructorUsedError;
  DateTime? get responseAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ReservationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReservationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReservationRequestCopyWith<ReservationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservationRequestCopyWith<$Res> {
  factory $ReservationRequestCopyWith(
          ReservationRequest value, $Res Function(ReservationRequest) then) =
      _$ReservationRequestCopyWithImpl<$Res, ReservationRequest>;
  @useResult
  $Res call(
      {String id,
      String memberId,
      String memberName,
      String trainerId,
      String trainerName,
      DateTime requestedDateTime,
      int durationMinutes,
      ReservationType type,
      ReservationStatus status,
      String? message,
      String? responseMessage,
      DateTime? responseAt,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ReservationRequestCopyWithImpl<$Res, $Val extends ReservationRequest>
    implements $ReservationRequestCopyWith<$Res> {
  _$ReservationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReservationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? memberId = null,
    Object? memberName = null,
    Object? trainerId = null,
    Object? trainerName = null,
    Object? requestedDateTime = null,
    Object? durationMinutes = null,
    Object? type = null,
    Object? status = null,
    Object? message = freezed,
    Object? responseMessage = freezed,
    Object? responseAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      memberName: null == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      trainerId: null == trainerId
          ? _value.trainerId
          : trainerId // ignore: cast_nullable_to_non_nullable
              as String,
      trainerName: null == trainerName
          ? _value.trainerName
          : trainerName // ignore: cast_nullable_to_non_nullable
              as String,
      requestedDateTime: null == requestedDateTime
          ? _value.requestedDateTime
          : requestedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReservationType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReservationStatus,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      responseMessage: freezed == responseMessage
          ? _value.responseMessage
          : responseMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      responseAt: freezed == responseAt
          ? _value.responseAt
          : responseAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReservationRequestImplCopyWith<$Res>
    implements $ReservationRequestCopyWith<$Res> {
  factory _$$ReservationRequestImplCopyWith(_$ReservationRequestImpl value,
          $Res Function(_$ReservationRequestImpl) then) =
      __$$ReservationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String memberId,
      String memberName,
      String trainerId,
      String trainerName,
      DateTime requestedDateTime,
      int durationMinutes,
      ReservationType type,
      ReservationStatus status,
      String? message,
      String? responseMessage,
      DateTime? responseAt,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ReservationRequestImplCopyWithImpl<$Res>
    extends _$ReservationRequestCopyWithImpl<$Res, _$ReservationRequestImpl>
    implements _$$ReservationRequestImplCopyWith<$Res> {
  __$$ReservationRequestImplCopyWithImpl(_$ReservationRequestImpl _value,
      $Res Function(_$ReservationRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReservationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? memberId = null,
    Object? memberName = null,
    Object? trainerId = null,
    Object? trainerName = null,
    Object? requestedDateTime = null,
    Object? durationMinutes = null,
    Object? type = null,
    Object? status = null,
    Object? message = freezed,
    Object? responseMessage = freezed,
    Object? responseAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ReservationRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      memberName: null == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      trainerId: null == trainerId
          ? _value.trainerId
          : trainerId // ignore: cast_nullable_to_non_nullable
              as String,
      trainerName: null == trainerName
          ? _value.trainerName
          : trainerName // ignore: cast_nullable_to_non_nullable
              as String,
      requestedDateTime: null == requestedDateTime
          ? _value.requestedDateTime
          : requestedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReservationType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReservationStatus,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      responseMessage: freezed == responseMessage
          ? _value.responseMessage
          : responseMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      responseAt: freezed == responseAt
          ? _value.responseAt
          : responseAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReservationRequestImpl implements _ReservationRequest {
  const _$ReservationRequestImpl(
      {required this.id,
      required this.memberId,
      required this.memberName,
      required this.trainerId,
      required this.trainerName,
      required this.requestedDateTime,
      required this.durationMinutes,
      required this.type,
      required this.status,
      this.message,
      this.responseMessage,
      this.responseAt,
      required this.createdAt,
      this.updatedAt});

  factory _$ReservationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReservationRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String memberId;
  @override
  final String memberName;
  @override
  final String trainerId;
  @override
  final String trainerName;
  @override
  final DateTime requestedDateTime;
  @override
  final int durationMinutes;
  @override
  final ReservationType type;
  @override
  final ReservationStatus status;
  @override
  final String? message;
  @override
  final String? responseMessage;
  @override
  final DateTime? responseAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ReservationRequest(id: $id, memberId: $memberId, memberName: $memberName, trainerId: $trainerId, trainerName: $trainerName, requestedDateTime: $requestedDateTime, durationMinutes: $durationMinutes, type: $type, status: $status, message: $message, responseMessage: $responseMessage, responseAt: $responseAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservationRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.memberName, memberName) ||
                other.memberName == memberName) &&
            (identical(other.trainerId, trainerId) ||
                other.trainerId == trainerId) &&
            (identical(other.trainerName, trainerName) ||
                other.trainerName == trainerName) &&
            (identical(other.requestedDateTime, requestedDateTime) ||
                other.requestedDateTime == requestedDateTime) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.responseMessage, responseMessage) ||
                other.responseMessage == responseMessage) &&
            (identical(other.responseAt, responseAt) ||
                other.responseAt == responseAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      memberId,
      memberName,
      trainerId,
      trainerName,
      requestedDateTime,
      durationMinutes,
      type,
      status,
      message,
      responseMessage,
      responseAt,
      createdAt,
      updatedAt);

  /// Create a copy of ReservationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservationRequestImplCopyWith<_$ReservationRequestImpl> get copyWith =>
      __$$ReservationRequestImplCopyWithImpl<_$ReservationRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReservationRequestImplToJson(
      this,
    );
  }
}

abstract class _ReservationRequest implements ReservationRequest {
  const factory _ReservationRequest(
      {required final String id,
      required final String memberId,
      required final String memberName,
      required final String trainerId,
      required final String trainerName,
      required final DateTime requestedDateTime,
      required final int durationMinutes,
      required final ReservationType type,
      required final ReservationStatus status,
      final String? message,
      final String? responseMessage,
      final DateTime? responseAt,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$ReservationRequestImpl;

  factory _ReservationRequest.fromJson(Map<String, dynamic> json) =
      _$ReservationRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get memberId;
  @override
  String get memberName;
  @override
  String get trainerId;
  @override
  String get trainerName;
  @override
  DateTime get requestedDateTime;
  @override
  int get durationMinutes;
  @override
  ReservationType get type;
  @override
  ReservationStatus get status;
  @override
  String? get message;
  @override
  String? get responseMessage;
  @override
  DateTime? get responseAt;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ReservationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReservationRequestImplCopyWith<_$ReservationRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReservationResponse _$ReservationResponseFromJson(Map<String, dynamic> json) {
  return _ReservationResponse.fromJson(json);
}

/// @nodoc
mixin _$ReservationResponse {
  List<ReservationRequest> get data => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;

  /// Serializes this ReservationResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReservationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReservationResponseCopyWith<ReservationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservationResponseCopyWith<$Res> {
  factory $ReservationResponseCopyWith(
          ReservationResponse value, $Res Function(ReservationResponse) then) =
      _$ReservationResponseCopyWithImpl<$Res, ReservationResponse>;
  @useResult
  $Res call({List<ReservationRequest> data, int total, int page, int size});
}

/// @nodoc
class _$ReservationResponseCopyWithImpl<$Res, $Val extends ReservationResponse>
    implements $ReservationResponseCopyWith<$Res> {
  _$ReservationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReservationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? total = null,
    Object? page = null,
    Object? size = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ReservationRequest>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReservationResponseImplCopyWith<$Res>
    implements $ReservationResponseCopyWith<$Res> {
  factory _$$ReservationResponseImplCopyWith(_$ReservationResponseImpl value,
          $Res Function(_$ReservationResponseImpl) then) =
      __$$ReservationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ReservationRequest> data, int total, int page, int size});
}

/// @nodoc
class __$$ReservationResponseImplCopyWithImpl<$Res>
    extends _$ReservationResponseCopyWithImpl<$Res, _$ReservationResponseImpl>
    implements _$$ReservationResponseImplCopyWith<$Res> {
  __$$ReservationResponseImplCopyWithImpl(_$ReservationResponseImpl _value,
      $Res Function(_$ReservationResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReservationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? total = null,
    Object? page = null,
    Object? size = null,
  }) {
    return _then(_$ReservationResponseImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ReservationRequest>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReservationResponseImpl implements _ReservationResponse {
  const _$ReservationResponseImpl(
      {required final List<ReservationRequest> data,
      required this.total,
      required this.page,
      required this.size})
      : _data = data;

  factory _$ReservationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReservationResponseImplFromJson(json);

  final List<ReservationRequest> _data;
  @override
  List<ReservationRequest> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final int total;
  @override
  final int page;
  @override
  final int size;

  @override
  String toString() {
    return 'ReservationResponse(data: $data, total: $total, page: $page, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservationResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.size, size) || other.size == size));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_data), total, page, size);

  /// Create a copy of ReservationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservationResponseImplCopyWith<_$ReservationResponseImpl> get copyWith =>
      __$$ReservationResponseImplCopyWithImpl<_$ReservationResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReservationResponseImplToJson(
      this,
    );
  }
}

abstract class _ReservationResponse implements ReservationResponse {
  const factory _ReservationResponse(
      {required final List<ReservationRequest> data,
      required final int total,
      required final int page,
      required final int size}) = _$ReservationResponseImpl;

  factory _ReservationResponse.fromJson(Map<String, dynamic> json) =
      _$ReservationResponseImpl.fromJson;

  @override
  List<ReservationRequest> get data;
  @override
  int get total;
  @override
  int get page;
  @override
  int get size;

  /// Create a copy of ReservationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReservationResponseImplCopyWith<_$ReservationResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateReservationRequest _$CreateReservationRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateReservationRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateReservationRequest {
  String get trainerId => throw _privateConstructorUsedError;
  DateTime get requestedDateTime => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  ReservationType get type => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this CreateReservationRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateReservationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateReservationRequestCopyWith<CreateReservationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateReservationRequestCopyWith<$Res> {
  factory $CreateReservationRequestCopyWith(CreateReservationRequest value,
          $Res Function(CreateReservationRequest) then) =
      _$CreateReservationRequestCopyWithImpl<$Res, CreateReservationRequest>;
  @useResult
  $Res call(
      {String trainerId,
      DateTime requestedDateTime,
      int durationMinutes,
      ReservationType type,
      String? message});
}

/// @nodoc
class _$CreateReservationRequestCopyWithImpl<$Res,
        $Val extends CreateReservationRequest>
    implements $CreateReservationRequestCopyWith<$Res> {
  _$CreateReservationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateReservationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trainerId = null,
    Object? requestedDateTime = null,
    Object? durationMinutes = null,
    Object? type = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      trainerId: null == trainerId
          ? _value.trainerId
          : trainerId // ignore: cast_nullable_to_non_nullable
              as String,
      requestedDateTime: null == requestedDateTime
          ? _value.requestedDateTime
          : requestedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReservationType,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateReservationRequestImplCopyWith<$Res>
    implements $CreateReservationRequestCopyWith<$Res> {
  factory _$$CreateReservationRequestImplCopyWith(
          _$CreateReservationRequestImpl value,
          $Res Function(_$CreateReservationRequestImpl) then) =
      __$$CreateReservationRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String trainerId,
      DateTime requestedDateTime,
      int durationMinutes,
      ReservationType type,
      String? message});
}

/// @nodoc
class __$$CreateReservationRequestImplCopyWithImpl<$Res>
    extends _$CreateReservationRequestCopyWithImpl<$Res,
        _$CreateReservationRequestImpl>
    implements _$$CreateReservationRequestImplCopyWith<$Res> {
  __$$CreateReservationRequestImplCopyWithImpl(
      _$CreateReservationRequestImpl _value,
      $Res Function(_$CreateReservationRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateReservationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trainerId = null,
    Object? requestedDateTime = null,
    Object? durationMinutes = null,
    Object? type = null,
    Object? message = freezed,
  }) {
    return _then(_$CreateReservationRequestImpl(
      trainerId: null == trainerId
          ? _value.trainerId
          : trainerId // ignore: cast_nullable_to_non_nullable
              as String,
      requestedDateTime: null == requestedDateTime
          ? _value.requestedDateTime
          : requestedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReservationType,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateReservationRequestImpl implements _CreateReservationRequest {
  const _$CreateReservationRequestImpl(
      {required this.trainerId,
      required this.requestedDateTime,
      required this.durationMinutes,
      required this.type,
      this.message});

  factory _$CreateReservationRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateReservationRequestImplFromJson(json);

  @override
  final String trainerId;
  @override
  final DateTime requestedDateTime;
  @override
  final int durationMinutes;
  @override
  final ReservationType type;
  @override
  final String? message;

  @override
  String toString() {
    return 'CreateReservationRequest(trainerId: $trainerId, requestedDateTime: $requestedDateTime, durationMinutes: $durationMinutes, type: $type, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateReservationRequestImpl &&
            (identical(other.trainerId, trainerId) ||
                other.trainerId == trainerId) &&
            (identical(other.requestedDateTime, requestedDateTime) ||
                other.requestedDateTime == requestedDateTime) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, trainerId, requestedDateTime,
      durationMinutes, type, message);

  /// Create a copy of CreateReservationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateReservationRequestImplCopyWith<_$CreateReservationRequestImpl>
      get copyWith => __$$CreateReservationRequestImplCopyWithImpl<
          _$CreateReservationRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateReservationRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateReservationRequest implements CreateReservationRequest {
  const factory _CreateReservationRequest(
      {required final String trainerId,
      required final DateTime requestedDateTime,
      required final int durationMinutes,
      required final ReservationType type,
      final String? message}) = _$CreateReservationRequestImpl;

  factory _CreateReservationRequest.fromJson(Map<String, dynamic> json) =
      _$CreateReservationRequestImpl.fromJson;

  @override
  String get trainerId;
  @override
  DateTime get requestedDateTime;
  @override
  int get durationMinutes;
  @override
  ReservationType get type;
  @override
  String? get message;

  /// Create a copy of CreateReservationRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateReservationRequestImplCopyWith<_$CreateReservationRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ReservationRecommendation _$ReservationRecommendationFromJson(
    Map<String, dynamic> json) {
  return _ReservationRecommendation.fromJson(json);
}

/// @nodoc
mixin _$ReservationRecommendation {
  String get id => throw _privateConstructorUsedError;
  String get trainerId => throw _privateConstructorUsedError;
  String get trainerName => throw _privateConstructorUsedError;
  String get memberId => throw _privateConstructorUsedError;
  String get memberName => throw _privateConstructorUsedError;
  DateTime get recommendedDateTime => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  ReservationStatus get status => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get responseMessage => throw _privateConstructorUsedError;
  DateTime? get responseAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ReservationRecommendation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReservationRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReservationRecommendationCopyWith<ReservationRecommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReservationRecommendationCopyWith<$Res> {
  factory $ReservationRecommendationCopyWith(ReservationRecommendation value,
          $Res Function(ReservationRecommendation) then) =
      _$ReservationRecommendationCopyWithImpl<$Res, ReservationRecommendation>;
  @useResult
  $Res call(
      {String id,
      String trainerId,
      String trainerName,
      String memberId,
      String memberName,
      DateTime recommendedDateTime,
      int durationMinutes,
      ReservationStatus status,
      String? message,
      String? responseMessage,
      DateTime? responseAt,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ReservationRecommendationCopyWithImpl<$Res,
        $Val extends ReservationRecommendation>
    implements $ReservationRecommendationCopyWith<$Res> {
  _$ReservationRecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReservationRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trainerId = null,
    Object? trainerName = null,
    Object? memberId = null,
    Object? memberName = null,
    Object? recommendedDateTime = null,
    Object? durationMinutes = null,
    Object? status = null,
    Object? message = freezed,
    Object? responseMessage = freezed,
    Object? responseAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      trainerId: null == trainerId
          ? _value.trainerId
          : trainerId // ignore: cast_nullable_to_non_nullable
              as String,
      trainerName: null == trainerName
          ? _value.trainerName
          : trainerName // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      memberName: null == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      recommendedDateTime: null == recommendedDateTime
          ? _value.recommendedDateTime
          : recommendedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReservationStatus,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      responseMessage: freezed == responseMessage
          ? _value.responseMessage
          : responseMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      responseAt: freezed == responseAt
          ? _value.responseAt
          : responseAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReservationRecommendationImplCopyWith<$Res>
    implements $ReservationRecommendationCopyWith<$Res> {
  factory _$$ReservationRecommendationImplCopyWith(
          _$ReservationRecommendationImpl value,
          $Res Function(_$ReservationRecommendationImpl) then) =
      __$$ReservationRecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String trainerId,
      String trainerName,
      String memberId,
      String memberName,
      DateTime recommendedDateTime,
      int durationMinutes,
      ReservationStatus status,
      String? message,
      String? responseMessage,
      DateTime? responseAt,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ReservationRecommendationImplCopyWithImpl<$Res>
    extends _$ReservationRecommendationCopyWithImpl<$Res,
        _$ReservationRecommendationImpl>
    implements _$$ReservationRecommendationImplCopyWith<$Res> {
  __$$ReservationRecommendationImplCopyWithImpl(
      _$ReservationRecommendationImpl _value,
      $Res Function(_$ReservationRecommendationImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReservationRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trainerId = null,
    Object? trainerName = null,
    Object? memberId = null,
    Object? memberName = null,
    Object? recommendedDateTime = null,
    Object? durationMinutes = null,
    Object? status = null,
    Object? message = freezed,
    Object? responseMessage = freezed,
    Object? responseAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ReservationRecommendationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      trainerId: null == trainerId
          ? _value.trainerId
          : trainerId // ignore: cast_nullable_to_non_nullable
              as String,
      trainerName: null == trainerName
          ? _value.trainerName
          : trainerName // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      memberName: null == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      recommendedDateTime: null == recommendedDateTime
          ? _value.recommendedDateTime
          : recommendedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReservationStatus,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      responseMessage: freezed == responseMessage
          ? _value.responseMessage
          : responseMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      responseAt: freezed == responseAt
          ? _value.responseAt
          : responseAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReservationRecommendationImpl implements _ReservationRecommendation {
  const _$ReservationRecommendationImpl(
      {required this.id,
      required this.trainerId,
      required this.trainerName,
      required this.memberId,
      required this.memberName,
      required this.recommendedDateTime,
      required this.durationMinutes,
      required this.status,
      this.message,
      this.responseMessage,
      this.responseAt,
      required this.createdAt,
      this.updatedAt});

  factory _$ReservationRecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReservationRecommendationImplFromJson(json);

  @override
  final String id;
  @override
  final String trainerId;
  @override
  final String trainerName;
  @override
  final String memberId;
  @override
  final String memberName;
  @override
  final DateTime recommendedDateTime;
  @override
  final int durationMinutes;
  @override
  final ReservationStatus status;
  @override
  final String? message;
  @override
  final String? responseMessage;
  @override
  final DateTime? responseAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ReservationRecommendation(id: $id, trainerId: $trainerId, trainerName: $trainerName, memberId: $memberId, memberName: $memberName, recommendedDateTime: $recommendedDateTime, durationMinutes: $durationMinutes, status: $status, message: $message, responseMessage: $responseMessage, responseAt: $responseAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReservationRecommendationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.trainerId, trainerId) ||
                other.trainerId == trainerId) &&
            (identical(other.trainerName, trainerName) ||
                other.trainerName == trainerName) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.memberName, memberName) ||
                other.memberName == memberName) &&
            (identical(other.recommendedDateTime, recommendedDateTime) ||
                other.recommendedDateTime == recommendedDateTime) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.responseMessage, responseMessage) ||
                other.responseMessage == responseMessage) &&
            (identical(other.responseAt, responseAt) ||
                other.responseAt == responseAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      trainerId,
      trainerName,
      memberId,
      memberName,
      recommendedDateTime,
      durationMinutes,
      status,
      message,
      responseMessage,
      responseAt,
      createdAt,
      updatedAt);

  /// Create a copy of ReservationRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReservationRecommendationImplCopyWith<_$ReservationRecommendationImpl>
      get copyWith => __$$ReservationRecommendationImplCopyWithImpl<
          _$ReservationRecommendationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReservationRecommendationImplToJson(
      this,
    );
  }
}

abstract class _ReservationRecommendation implements ReservationRecommendation {
  const factory _ReservationRecommendation(
      {required final String id,
      required final String trainerId,
      required final String trainerName,
      required final String memberId,
      required final String memberName,
      required final DateTime recommendedDateTime,
      required final int durationMinutes,
      required final ReservationStatus status,
      final String? message,
      final String? responseMessage,
      final DateTime? responseAt,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$ReservationRecommendationImpl;

  factory _ReservationRecommendation.fromJson(Map<String, dynamic> json) =
      _$ReservationRecommendationImpl.fromJson;

  @override
  String get id;
  @override
  String get trainerId;
  @override
  String get trainerName;
  @override
  String get memberId;
  @override
  String get memberName;
  @override
  DateTime get recommendedDateTime;
  @override
  int get durationMinutes;
  @override
  ReservationStatus get status;
  @override
  String? get message;
  @override
  String? get responseMessage;
  @override
  DateTime? get responseAt;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ReservationRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReservationRecommendationImplCopyWith<_$ReservationRecommendationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RecommendationResponse _$RecommendationResponseFromJson(
    Map<String, dynamic> json) {
  return _RecommendationResponse.fromJson(json);
}

/// @nodoc
mixin _$RecommendationResponse {
  List<ReservationRecommendation> get data =>
      throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;

  /// Serializes this RecommendationResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationResponseCopyWith<RecommendationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationResponseCopyWith<$Res> {
  factory $RecommendationResponseCopyWith(RecommendationResponse value,
          $Res Function(RecommendationResponse) then) =
      _$RecommendationResponseCopyWithImpl<$Res, RecommendationResponse>;
  @useResult
  $Res call(
      {List<ReservationRecommendation> data, int total, int page, int size});
}

/// @nodoc
class _$RecommendationResponseCopyWithImpl<$Res,
        $Val extends RecommendationResponse>
    implements $RecommendationResponseCopyWith<$Res> {
  _$RecommendationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? total = null,
    Object? page = null,
    Object? size = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ReservationRecommendation>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecommendationResponseImplCopyWith<$Res>
    implements $RecommendationResponseCopyWith<$Res> {
  factory _$$RecommendationResponseImplCopyWith(
          _$RecommendationResponseImpl value,
          $Res Function(_$RecommendationResponseImpl) then) =
      __$$RecommendationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ReservationRecommendation> data, int total, int page, int size});
}

/// @nodoc
class __$$RecommendationResponseImplCopyWithImpl<$Res>
    extends _$RecommendationResponseCopyWithImpl<$Res,
        _$RecommendationResponseImpl>
    implements _$$RecommendationResponseImplCopyWith<$Res> {
  __$$RecommendationResponseImplCopyWithImpl(
      _$RecommendationResponseImpl _value,
      $Res Function(_$RecommendationResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? total = null,
    Object? page = null,
    Object? size = null,
  }) {
    return _then(_$RecommendationResponseImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ReservationRecommendation>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendationResponseImpl implements _RecommendationResponse {
  const _$RecommendationResponseImpl(
      {required final List<ReservationRecommendation> data,
      required this.total,
      required this.page,
      required this.size})
      : _data = data;

  factory _$RecommendationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendationResponseImplFromJson(json);

  final List<ReservationRecommendation> _data;
  @override
  List<ReservationRecommendation> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final int total;
  @override
  final int page;
  @override
  final int size;

  @override
  String toString() {
    return 'RecommendationResponse(data: $data, total: $total, page: $page, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.size, size) || other.size == size));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_data), total, page, size);

  /// Create a copy of RecommendationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationResponseImplCopyWith<_$RecommendationResponseImpl>
      get copyWith => __$$RecommendationResponseImplCopyWithImpl<
          _$RecommendationResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationResponseImplToJson(
      this,
    );
  }
}

abstract class _RecommendationResponse implements RecommendationResponse {
  const factory _RecommendationResponse(
      {required final List<ReservationRecommendation> data,
      required final int total,
      required final int page,
      required final int size}) = _$RecommendationResponseImpl;

  factory _RecommendationResponse.fromJson(Map<String, dynamic> json) =
      _$RecommendationResponseImpl.fromJson;

  @override
  List<ReservationRecommendation> get data;
  @override
  int get total;
  @override
  int get page;
  @override
  int get size;

  /// Create a copy of RecommendationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationResponseImplCopyWith<_$RecommendationResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
