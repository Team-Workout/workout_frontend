// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pt_appointment_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PtAppointment _$PtAppointmentFromJson(Map<String, dynamic> json) {
  return _PtAppointment.fromJson(json);
}

/// @nodoc
mixin _$PtAppointment {
  @JsonKey(name: 'id')
  int get appointmentId => throw _privateConstructorUsedError; // API는 'id'로 전송
  int get contractId => throw _privateConstructorUsedError;
  int? get memberId => throw _privateConstructorUsedError; // API 응답에 없을 수 있음
  int? get trainerId => throw _privateConstructorUsedError; // API 응답에 없을 수 있음
  String get memberName => throw _privateConstructorUsedError;
  String get trainerName => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError; // API 응답에 없을 수 있음
  String? get changeRequestStartTime => throw _privateConstructorUsedError;
  String? get changeRequestEndTime => throw _privateConstructorUsedError;
  String? get changeRequestBy =>
      throw _privateConstructorUsedError; // MEMBER, TRAINER
  String? get changeRequestStatus =>
      throw _privateConstructorUsedError; // PENDING, APPROVED, REJECTED
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PtAppointment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PtAppointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PtAppointmentCopyWith<PtAppointment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PtAppointmentCopyWith<$Res> {
  factory $PtAppointmentCopyWith(
          PtAppointment value, $Res Function(PtAppointment) then) =
      _$PtAppointmentCopyWithImpl<$Res, PtAppointment>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int appointmentId,
      int contractId,
      int? memberId,
      int? trainerId,
      String memberName,
      String trainerName,
      String startTime,
      String endTime,
      String? status,
      String? changeRequestStartTime,
      String? changeRequestEndTime,
      String? changeRequestBy,
      String? changeRequestStatus,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$PtAppointmentCopyWithImpl<$Res, $Val extends PtAppointment>
    implements $PtAppointmentCopyWith<$Res> {
  _$PtAppointmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PtAppointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appointmentId = null,
    Object? contractId = null,
    Object? memberId = freezed,
    Object? trainerId = freezed,
    Object? memberName = null,
    Object? trainerName = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = freezed,
    Object? changeRequestStartTime = freezed,
    Object? changeRequestEndTime = freezed,
    Object? changeRequestBy = freezed,
    Object? changeRequestStatus = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      appointmentId: null == appointmentId
          ? _value.appointmentId
          : appointmentId // ignore: cast_nullable_to_non_nullable
              as int,
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as int,
      memberId: freezed == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int?,
      trainerId: freezed == trainerId
          ? _value.trainerId
          : trainerId // ignore: cast_nullable_to_non_nullable
              as int?,
      memberName: null == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      trainerName: null == trainerName
          ? _value.trainerName
          : trainerName // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      changeRequestStartTime: freezed == changeRequestStartTime
          ? _value.changeRequestStartTime
          : changeRequestStartTime // ignore: cast_nullable_to_non_nullable
              as String?,
      changeRequestEndTime: freezed == changeRequestEndTime
          ? _value.changeRequestEndTime
          : changeRequestEndTime // ignore: cast_nullable_to_non_nullable
              as String?,
      changeRequestBy: freezed == changeRequestBy
          ? _value.changeRequestBy
          : changeRequestBy // ignore: cast_nullable_to_non_nullable
              as String?,
      changeRequestStatus: freezed == changeRequestStatus
          ? _value.changeRequestStatus
          : changeRequestStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PtAppointmentImplCopyWith<$Res>
    implements $PtAppointmentCopyWith<$Res> {
  factory _$$PtAppointmentImplCopyWith(
          _$PtAppointmentImpl value, $Res Function(_$PtAppointmentImpl) then) =
      __$$PtAppointmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int appointmentId,
      int contractId,
      int? memberId,
      int? trainerId,
      String memberName,
      String trainerName,
      String startTime,
      String endTime,
      String? status,
      String? changeRequestStartTime,
      String? changeRequestEndTime,
      String? changeRequestBy,
      String? changeRequestStatus,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$PtAppointmentImplCopyWithImpl<$Res>
    extends _$PtAppointmentCopyWithImpl<$Res, _$PtAppointmentImpl>
    implements _$$PtAppointmentImplCopyWith<$Res> {
  __$$PtAppointmentImplCopyWithImpl(
      _$PtAppointmentImpl _value, $Res Function(_$PtAppointmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of PtAppointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appointmentId = null,
    Object? contractId = null,
    Object? memberId = freezed,
    Object? trainerId = freezed,
    Object? memberName = null,
    Object? trainerName = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = freezed,
    Object? changeRequestStartTime = freezed,
    Object? changeRequestEndTime = freezed,
    Object? changeRequestBy = freezed,
    Object? changeRequestStatus = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PtAppointmentImpl(
      appointmentId: null == appointmentId
          ? _value.appointmentId
          : appointmentId // ignore: cast_nullable_to_non_nullable
              as int,
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as int,
      memberId: freezed == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int?,
      trainerId: freezed == trainerId
          ? _value.trainerId
          : trainerId // ignore: cast_nullable_to_non_nullable
              as int?,
      memberName: null == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      trainerName: null == trainerName
          ? _value.trainerName
          : trainerName // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      changeRequestStartTime: freezed == changeRequestStartTime
          ? _value.changeRequestStartTime
          : changeRequestStartTime // ignore: cast_nullable_to_non_nullable
              as String?,
      changeRequestEndTime: freezed == changeRequestEndTime
          ? _value.changeRequestEndTime
          : changeRequestEndTime // ignore: cast_nullable_to_non_nullable
              as String?,
      changeRequestBy: freezed == changeRequestBy
          ? _value.changeRequestBy
          : changeRequestBy // ignore: cast_nullable_to_non_nullable
              as String?,
      changeRequestStatus: freezed == changeRequestStatus
          ? _value.changeRequestStatus
          : changeRequestStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PtAppointmentImpl implements _PtAppointment {
  const _$PtAppointmentImpl(
      {@JsonKey(name: 'id') required this.appointmentId,
      required this.contractId,
      this.memberId,
      this.trainerId,
      required this.memberName,
      required this.trainerName,
      required this.startTime,
      required this.endTime,
      this.status,
      this.changeRequestStartTime,
      this.changeRequestEndTime,
      this.changeRequestBy,
      this.changeRequestStatus,
      this.notes,
      this.createdAt,
      this.updatedAt});

  factory _$PtAppointmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PtAppointmentImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int appointmentId;
// API는 'id'로 전송
  @override
  final int contractId;
  @override
  final int? memberId;
// API 응답에 없을 수 있음
  @override
  final int? trainerId;
// API 응답에 없을 수 있음
  @override
  final String memberName;
  @override
  final String trainerName;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final String? status;
// API 응답에 없을 수 있음
  @override
  final String? changeRequestStartTime;
  @override
  final String? changeRequestEndTime;
  @override
  final String? changeRequestBy;
// MEMBER, TRAINER
  @override
  final String? changeRequestStatus;
// PENDING, APPROVED, REJECTED
  @override
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PtAppointment(appointmentId: $appointmentId, contractId: $contractId, memberId: $memberId, trainerId: $trainerId, memberName: $memberName, trainerName: $trainerName, startTime: $startTime, endTime: $endTime, status: $status, changeRequestStartTime: $changeRequestStartTime, changeRequestEndTime: $changeRequestEndTime, changeRequestBy: $changeRequestBy, changeRequestStatus: $changeRequestStatus, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PtAppointmentImpl &&
            (identical(other.appointmentId, appointmentId) ||
                other.appointmentId == appointmentId) &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.trainerId, trainerId) ||
                other.trainerId == trainerId) &&
            (identical(other.memberName, memberName) ||
                other.memberName == memberName) &&
            (identical(other.trainerName, trainerName) ||
                other.trainerName == trainerName) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.changeRequestStartTime, changeRequestStartTime) ||
                other.changeRequestStartTime == changeRequestStartTime) &&
            (identical(other.changeRequestEndTime, changeRequestEndTime) ||
                other.changeRequestEndTime == changeRequestEndTime) &&
            (identical(other.changeRequestBy, changeRequestBy) ||
                other.changeRequestBy == changeRequestBy) &&
            (identical(other.changeRequestStatus, changeRequestStatus) ||
                other.changeRequestStatus == changeRequestStatus) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      appointmentId,
      contractId,
      memberId,
      trainerId,
      memberName,
      trainerName,
      startTime,
      endTime,
      status,
      changeRequestStartTime,
      changeRequestEndTime,
      changeRequestBy,
      changeRequestStatus,
      notes,
      createdAt,
      updatedAt);

  /// Create a copy of PtAppointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PtAppointmentImplCopyWith<_$PtAppointmentImpl> get copyWith =>
      __$$PtAppointmentImplCopyWithImpl<_$PtAppointmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PtAppointmentImplToJson(
      this,
    );
  }
}

abstract class _PtAppointment implements PtAppointment {
  const factory _PtAppointment(
      {@JsonKey(name: 'id') required final int appointmentId,
      required final int contractId,
      final int? memberId,
      final int? trainerId,
      required final String memberName,
      required final String trainerName,
      required final String startTime,
      required final String endTime,
      final String? status,
      final String? changeRequestStartTime,
      final String? changeRequestEndTime,
      final String? changeRequestBy,
      final String? changeRequestStatus,
      final String? notes,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$PtAppointmentImpl;

  factory _PtAppointment.fromJson(Map<String, dynamic> json) =
      _$PtAppointmentImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get appointmentId; // API는 'id'로 전송
  @override
  int get contractId;
  @override
  int? get memberId; // API 응답에 없을 수 있음
  @override
  int? get trainerId; // API 응답에 없을 수 있음
  @override
  String get memberName;
  @override
  String get trainerName;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  String? get status; // API 응답에 없을 수 있음
  @override
  String? get changeRequestStartTime;
  @override
  String? get changeRequestEndTime;
  @override
  String? get changeRequestBy; // MEMBER, TRAINER
  @override
  String? get changeRequestStatus; // PENDING, APPROVED, REJECTED
  @override
  String? get notes;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of PtAppointment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PtAppointmentImplCopyWith<_$PtAppointmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PtAppointmentsResponse _$PtAppointmentsResponseFromJson(
    Map<String, dynamic> json) {
  return _PtAppointmentsResponse.fromJson(json);
}

/// @nodoc
mixin _$PtAppointmentsResponse {
  List<PtAppointment> get data => throw _privateConstructorUsedError;
  int get totalElements => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  bool get hasNext => throw _privateConstructorUsedError;
  bool get hasPrevious => throw _privateConstructorUsedError;

  /// Serializes this PtAppointmentsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PtAppointmentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PtAppointmentsResponseCopyWith<PtAppointmentsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PtAppointmentsResponseCopyWith<$Res> {
  factory $PtAppointmentsResponseCopyWith(PtAppointmentsResponse value,
          $Res Function(PtAppointmentsResponse) then) =
      _$PtAppointmentsResponseCopyWithImpl<$Res, PtAppointmentsResponse>;
  @useResult
  $Res call(
      {List<PtAppointment> data,
      int totalElements,
      int totalPages,
      int currentPage,
      bool hasNext,
      bool hasPrevious});
}

/// @nodoc
class _$PtAppointmentsResponseCopyWithImpl<$Res,
        $Val extends PtAppointmentsResponse>
    implements $PtAppointmentsResponseCopyWith<$Res> {
  _$PtAppointmentsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PtAppointmentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? totalElements = null,
    Object? totalPages = null,
    Object? currentPage = null,
    Object? hasNext = null,
    Object? hasPrevious = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<PtAppointment>,
      totalElements: null == totalElements
          ? _value.totalElements
          : totalElements // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasNext: null == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPrevious: null == hasPrevious
          ? _value.hasPrevious
          : hasPrevious // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PtAppointmentsResponseImplCopyWith<$Res>
    implements $PtAppointmentsResponseCopyWith<$Res> {
  factory _$$PtAppointmentsResponseImplCopyWith(
          _$PtAppointmentsResponseImpl value,
          $Res Function(_$PtAppointmentsResponseImpl) then) =
      __$$PtAppointmentsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<PtAppointment> data,
      int totalElements,
      int totalPages,
      int currentPage,
      bool hasNext,
      bool hasPrevious});
}

/// @nodoc
class __$$PtAppointmentsResponseImplCopyWithImpl<$Res>
    extends _$PtAppointmentsResponseCopyWithImpl<$Res,
        _$PtAppointmentsResponseImpl>
    implements _$$PtAppointmentsResponseImplCopyWith<$Res> {
  __$$PtAppointmentsResponseImplCopyWithImpl(
      _$PtAppointmentsResponseImpl _value,
      $Res Function(_$PtAppointmentsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PtAppointmentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? totalElements = null,
    Object? totalPages = null,
    Object? currentPage = null,
    Object? hasNext = null,
    Object? hasPrevious = null,
  }) {
    return _then(_$PtAppointmentsResponseImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<PtAppointment>,
      totalElements: null == totalElements
          ? _value.totalElements
          : totalElements // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasNext: null == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPrevious: null == hasPrevious
          ? _value.hasPrevious
          : hasPrevious // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PtAppointmentsResponseImpl implements _PtAppointmentsResponse {
  const _$PtAppointmentsResponseImpl(
      {required final List<PtAppointment> data,
      required this.totalElements,
      required this.totalPages,
      required this.currentPage,
      required this.hasNext,
      required this.hasPrevious})
      : _data = data;

  factory _$PtAppointmentsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PtAppointmentsResponseImplFromJson(json);

  final List<PtAppointment> _data;
  @override
  List<PtAppointment> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final int totalElements;
  @override
  final int totalPages;
  @override
  final int currentPage;
  @override
  final bool hasNext;
  @override
  final bool hasPrevious;

  @override
  String toString() {
    return 'PtAppointmentsResponse(data: $data, totalElements: $totalElements, totalPages: $totalPages, currentPage: $currentPage, hasNext: $hasNext, hasPrevious: $hasPrevious)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PtAppointmentsResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.totalElements, totalElements) ||
                other.totalElements == totalElements) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext) &&
            (identical(other.hasPrevious, hasPrevious) ||
                other.hasPrevious == hasPrevious));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_data),
      totalElements,
      totalPages,
      currentPage,
      hasNext,
      hasPrevious);

  /// Create a copy of PtAppointmentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PtAppointmentsResponseImplCopyWith<_$PtAppointmentsResponseImpl>
      get copyWith => __$$PtAppointmentsResponseImplCopyWithImpl<
          _$PtAppointmentsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PtAppointmentsResponseImplToJson(
      this,
    );
  }
}

abstract class _PtAppointmentsResponse implements PtAppointmentsResponse {
  const factory _PtAppointmentsResponse(
      {required final List<PtAppointment> data,
      required final int totalElements,
      required final int totalPages,
      required final int currentPage,
      required final bool hasNext,
      required final bool hasPrevious}) = _$PtAppointmentsResponseImpl;

  factory _PtAppointmentsResponse.fromJson(Map<String, dynamic> json) =
      _$PtAppointmentsResponseImpl.fromJson;

  @override
  List<PtAppointment> get data;
  @override
  int get totalElements;
  @override
  int get totalPages;
  @override
  int get currentPage;
  @override
  bool get hasNext;
  @override
  bool get hasPrevious;

  /// Create a copy of PtAppointmentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PtAppointmentsResponseImplCopyWith<_$PtAppointmentsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AppointmentStatusUpdate _$AppointmentStatusUpdateFromJson(
    Map<String, dynamic> json) {
  return _AppointmentStatusUpdate.fromJson(json);
}

/// @nodoc
mixin _$AppointmentStatusUpdate {
  String get status => throw _privateConstructorUsedError;

  /// Serializes this AppointmentStatusUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentStatusUpdateCopyWith<AppointmentStatusUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentStatusUpdateCopyWith<$Res> {
  factory $AppointmentStatusUpdateCopyWith(AppointmentStatusUpdate value,
          $Res Function(AppointmentStatusUpdate) then) =
      _$AppointmentStatusUpdateCopyWithImpl<$Res, AppointmentStatusUpdate>;
  @useResult
  $Res call({String status});
}

/// @nodoc
class _$AppointmentStatusUpdateCopyWithImpl<$Res,
        $Val extends AppointmentStatusUpdate>
    implements $AppointmentStatusUpdateCopyWith<$Res> {
  _$AppointmentStatusUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppointmentStatusUpdateImplCopyWith<$Res>
    implements $AppointmentStatusUpdateCopyWith<$Res> {
  factory _$$AppointmentStatusUpdateImplCopyWith(
          _$AppointmentStatusUpdateImpl value,
          $Res Function(_$AppointmentStatusUpdateImpl) then) =
      __$$AppointmentStatusUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status});
}

/// @nodoc
class __$$AppointmentStatusUpdateImplCopyWithImpl<$Res>
    extends _$AppointmentStatusUpdateCopyWithImpl<$Res,
        _$AppointmentStatusUpdateImpl>
    implements _$$AppointmentStatusUpdateImplCopyWith<$Res> {
  __$$AppointmentStatusUpdateImplCopyWithImpl(
      _$AppointmentStatusUpdateImpl _value,
      $Res Function(_$AppointmentStatusUpdateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppointmentStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_$AppointmentStatusUpdateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentStatusUpdateImpl implements _AppointmentStatusUpdate {
  const _$AppointmentStatusUpdateImpl({required this.status});

  factory _$AppointmentStatusUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentStatusUpdateImplFromJson(json);

  @override
  final String status;

  @override
  String toString() {
    return 'AppointmentStatusUpdate(status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentStatusUpdateImpl &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status);

  /// Create a copy of AppointmentStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentStatusUpdateImplCopyWith<_$AppointmentStatusUpdateImpl>
      get copyWith => __$$AppointmentStatusUpdateImplCopyWithImpl<
          _$AppointmentStatusUpdateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentStatusUpdateImplToJson(
      this,
    );
  }
}

abstract class _AppointmentStatusUpdate implements AppointmentStatusUpdate {
  const factory _AppointmentStatusUpdate({required final String status}) =
      _$AppointmentStatusUpdateImpl;

  factory _AppointmentStatusUpdate.fromJson(Map<String, dynamic> json) =
      _$AppointmentStatusUpdateImpl.fromJson;

  @override
  String get status;

  /// Create a copy of AppointmentStatusUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentStatusUpdateImplCopyWith<_$AppointmentStatusUpdateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AppointmentChangeRequest _$AppointmentChangeRequestFromJson(
    Map<String, dynamic> json) {
  return _AppointmentChangeRequest.fromJson(json);
}

/// @nodoc
mixin _$AppointmentChangeRequest {
  String get newStartTime => throw _privateConstructorUsedError;
  String get newEndTime => throw _privateConstructorUsedError;

  /// Serializes this AppointmentChangeRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentChangeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentChangeRequestCopyWith<AppointmentChangeRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentChangeRequestCopyWith<$Res> {
  factory $AppointmentChangeRequestCopyWith(AppointmentChangeRequest value,
          $Res Function(AppointmentChangeRequest) then) =
      _$AppointmentChangeRequestCopyWithImpl<$Res, AppointmentChangeRequest>;
  @useResult
  $Res call({String newStartTime, String newEndTime});
}

/// @nodoc
class _$AppointmentChangeRequestCopyWithImpl<$Res,
        $Val extends AppointmentChangeRequest>
    implements $AppointmentChangeRequestCopyWith<$Res> {
  _$AppointmentChangeRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentChangeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newStartTime = null,
    Object? newEndTime = null,
  }) {
    return _then(_value.copyWith(
      newStartTime: null == newStartTime
          ? _value.newStartTime
          : newStartTime // ignore: cast_nullable_to_non_nullable
              as String,
      newEndTime: null == newEndTime
          ? _value.newEndTime
          : newEndTime // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppointmentChangeRequestImplCopyWith<$Res>
    implements $AppointmentChangeRequestCopyWith<$Res> {
  factory _$$AppointmentChangeRequestImplCopyWith(
          _$AppointmentChangeRequestImpl value,
          $Res Function(_$AppointmentChangeRequestImpl) then) =
      __$$AppointmentChangeRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String newStartTime, String newEndTime});
}

/// @nodoc
class __$$AppointmentChangeRequestImplCopyWithImpl<$Res>
    extends _$AppointmentChangeRequestCopyWithImpl<$Res,
        _$AppointmentChangeRequestImpl>
    implements _$$AppointmentChangeRequestImplCopyWith<$Res> {
  __$$AppointmentChangeRequestImplCopyWithImpl(
      _$AppointmentChangeRequestImpl _value,
      $Res Function(_$AppointmentChangeRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppointmentChangeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newStartTime = null,
    Object? newEndTime = null,
  }) {
    return _then(_$AppointmentChangeRequestImpl(
      newStartTime: null == newStartTime
          ? _value.newStartTime
          : newStartTime // ignore: cast_nullable_to_non_nullable
              as String,
      newEndTime: null == newEndTime
          ? _value.newEndTime
          : newEndTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentChangeRequestImpl implements _AppointmentChangeRequest {
  const _$AppointmentChangeRequestImpl(
      {required this.newStartTime, required this.newEndTime});

  factory _$AppointmentChangeRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentChangeRequestImplFromJson(json);

  @override
  final String newStartTime;
  @override
  final String newEndTime;

  @override
  String toString() {
    return 'AppointmentChangeRequest(newStartTime: $newStartTime, newEndTime: $newEndTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentChangeRequestImpl &&
            (identical(other.newStartTime, newStartTime) ||
                other.newStartTime == newStartTime) &&
            (identical(other.newEndTime, newEndTime) ||
                other.newEndTime == newEndTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, newStartTime, newEndTime);

  /// Create a copy of AppointmentChangeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentChangeRequestImplCopyWith<_$AppointmentChangeRequestImpl>
      get copyWith => __$$AppointmentChangeRequestImplCopyWithImpl<
          _$AppointmentChangeRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentChangeRequestImplToJson(
      this,
    );
  }
}

abstract class _AppointmentChangeRequest implements AppointmentChangeRequest {
  const factory _AppointmentChangeRequest(
      {required final String newStartTime,
      required final String newEndTime}) = _$AppointmentChangeRequestImpl;

  factory _AppointmentChangeRequest.fromJson(Map<String, dynamic> json) =
      _$AppointmentChangeRequestImpl.fromJson;

  @override
  String get newStartTime;
  @override
  String get newEndTime;

  /// Create a copy of AppointmentChangeRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentChangeRequestImplCopyWith<_$AppointmentChangeRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AppointmentCreateRequest _$AppointmentCreateRequestFromJson(
    Map<String, dynamic> json) {
  return _AppointmentCreateRequest.fromJson(json);
}

/// @nodoc
mixin _$AppointmentCreateRequest {
  int get contractId => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;

  /// Serializes this AppointmentCreateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentCreateRequestCopyWith<AppointmentCreateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentCreateRequestCopyWith<$Res> {
  factory $AppointmentCreateRequestCopyWith(AppointmentCreateRequest value,
          $Res Function(AppointmentCreateRequest) then) =
      _$AppointmentCreateRequestCopyWithImpl<$Res, AppointmentCreateRequest>;
  @useResult
  $Res call({int contractId, String startTime, String endTime});
}

/// @nodoc
class _$AppointmentCreateRequestCopyWithImpl<$Res,
        $Val extends AppointmentCreateRequest>
    implements $AppointmentCreateRequestCopyWith<$Res> {
  _$AppointmentCreateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(_value.copyWith(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as int,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppointmentCreateRequestImplCopyWith<$Res>
    implements $AppointmentCreateRequestCopyWith<$Res> {
  factory _$$AppointmentCreateRequestImplCopyWith(
          _$AppointmentCreateRequestImpl value,
          $Res Function(_$AppointmentCreateRequestImpl) then) =
      __$$AppointmentCreateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int contractId, String startTime, String endTime});
}

/// @nodoc
class __$$AppointmentCreateRequestImplCopyWithImpl<$Res>
    extends _$AppointmentCreateRequestCopyWithImpl<$Res,
        _$AppointmentCreateRequestImpl>
    implements _$$AppointmentCreateRequestImplCopyWith<$Res> {
  __$$AppointmentCreateRequestImplCopyWithImpl(
      _$AppointmentCreateRequestImpl _value,
      $Res Function(_$AppointmentCreateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppointmentCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(_$AppointmentCreateRequestImpl(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as int,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentCreateRequestImpl implements _AppointmentCreateRequest {
  const _$AppointmentCreateRequestImpl(
      {required this.contractId,
      required this.startTime,
      required this.endTime});

  factory _$AppointmentCreateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentCreateRequestImplFromJson(json);

  @override
  final int contractId;
  @override
  final String startTime;
  @override
  final String endTime;

  @override
  String toString() {
    return 'AppointmentCreateRequest(contractId: $contractId, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentCreateRequestImpl &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, contractId, startTime, endTime);

  /// Create a copy of AppointmentCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentCreateRequestImplCopyWith<_$AppointmentCreateRequestImpl>
      get copyWith => __$$AppointmentCreateRequestImplCopyWithImpl<
          _$AppointmentCreateRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentCreateRequestImplToJson(
      this,
    );
  }
}

abstract class _AppointmentCreateRequest implements AppointmentCreateRequest {
  const factory _AppointmentCreateRequest(
      {required final int contractId,
      required final String startTime,
      required final String endTime}) = _$AppointmentCreateRequestImpl;

  factory _AppointmentCreateRequest.fromJson(Map<String, dynamic> json) =
      _$AppointmentCreateRequestImpl.fromJson;

  @override
  int get contractId;
  @override
  String get startTime;
  @override
  String get endTime;

  /// Create a copy of AppointmentCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentCreateRequestImplCopyWith<_$AppointmentCreateRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
