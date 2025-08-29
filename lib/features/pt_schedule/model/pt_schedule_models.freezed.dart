// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pt_schedule_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PtSchedule _$PtScheduleFromJson(Map<String, dynamic> json) {
  return _PtSchedule.fromJson(json);
}

/// @nodoc
mixin _$PtSchedule {
  @JsonKey(name: 'id')
  int get appointmentId => throw _privateConstructorUsedError;
  int get contractId => throw _privateConstructorUsedError;
  String get trainerName => throw _privateConstructorUsedError;
  String get memberName => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get requestedStartTime => throw _privateConstructorUsedError;
  String? get requestedEndTime => throw _privateConstructorUsedError;
  bool? get hasChangeRequest => throw _privateConstructorUsedError;
  String? get changeRequestBy => throw _privateConstructorUsedError;

  /// Serializes this PtSchedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PtSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PtScheduleCopyWith<PtSchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PtScheduleCopyWith<$Res> {
  factory $PtScheduleCopyWith(
          PtSchedule value, $Res Function(PtSchedule) then) =
      _$PtScheduleCopyWithImpl<$Res, PtSchedule>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int appointmentId,
      int contractId,
      String trainerName,
      String memberName,
      String startTime,
      String endTime,
      String status,
      String? requestedStartTime,
      String? requestedEndTime,
      bool? hasChangeRequest,
      String? changeRequestBy});
}

/// @nodoc
class _$PtScheduleCopyWithImpl<$Res, $Val extends PtSchedule>
    implements $PtScheduleCopyWith<$Res> {
  _$PtScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PtSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appointmentId = null,
    Object? contractId = null,
    Object? trainerName = null,
    Object? memberName = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? requestedStartTime = freezed,
    Object? requestedEndTime = freezed,
    Object? hasChangeRequest = freezed,
    Object? changeRequestBy = freezed,
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
      trainerName: null == trainerName
          ? _value.trainerName
          : trainerName // ignore: cast_nullable_to_non_nullable
              as String,
      memberName: null == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      requestedStartTime: freezed == requestedStartTime
          ? _value.requestedStartTime
          : requestedStartTime // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedEndTime: freezed == requestedEndTime
          ? _value.requestedEndTime
          : requestedEndTime // ignore: cast_nullable_to_non_nullable
              as String?,
      hasChangeRequest: freezed == hasChangeRequest
          ? _value.hasChangeRequest
          : hasChangeRequest // ignore: cast_nullable_to_non_nullable
              as bool?,
      changeRequestBy: freezed == changeRequestBy
          ? _value.changeRequestBy
          : changeRequestBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PtScheduleImplCopyWith<$Res>
    implements $PtScheduleCopyWith<$Res> {
  factory _$$PtScheduleImplCopyWith(
          _$PtScheduleImpl value, $Res Function(_$PtScheduleImpl) then) =
      __$$PtScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int appointmentId,
      int contractId,
      String trainerName,
      String memberName,
      String startTime,
      String endTime,
      String status,
      String? requestedStartTime,
      String? requestedEndTime,
      bool? hasChangeRequest,
      String? changeRequestBy});
}

/// @nodoc
class __$$PtScheduleImplCopyWithImpl<$Res>
    extends _$PtScheduleCopyWithImpl<$Res, _$PtScheduleImpl>
    implements _$$PtScheduleImplCopyWith<$Res> {
  __$$PtScheduleImplCopyWithImpl(
      _$PtScheduleImpl _value, $Res Function(_$PtScheduleImpl) _then)
      : super(_value, _then);

  /// Create a copy of PtSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appointmentId = null,
    Object? contractId = null,
    Object? trainerName = null,
    Object? memberName = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? requestedStartTime = freezed,
    Object? requestedEndTime = freezed,
    Object? hasChangeRequest = freezed,
    Object? changeRequestBy = freezed,
  }) {
    return _then(_$PtScheduleImpl(
      appointmentId: null == appointmentId
          ? _value.appointmentId
          : appointmentId // ignore: cast_nullable_to_non_nullable
              as int,
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as int,
      trainerName: null == trainerName
          ? _value.trainerName
          : trainerName // ignore: cast_nullable_to_non_nullable
              as String,
      memberName: null == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      requestedStartTime: freezed == requestedStartTime
          ? _value.requestedStartTime
          : requestedStartTime // ignore: cast_nullable_to_non_nullable
              as String?,
      requestedEndTime: freezed == requestedEndTime
          ? _value.requestedEndTime
          : requestedEndTime // ignore: cast_nullable_to_non_nullable
              as String?,
      hasChangeRequest: freezed == hasChangeRequest
          ? _value.hasChangeRequest
          : hasChangeRequest // ignore: cast_nullable_to_non_nullable
              as bool?,
      changeRequestBy: freezed == changeRequestBy
          ? _value.changeRequestBy
          : changeRequestBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PtScheduleImpl implements _PtSchedule {
  const _$PtScheduleImpl(
      {@JsonKey(name: 'id') required this.appointmentId,
      required this.contractId,
      required this.trainerName,
      required this.memberName,
      required this.startTime,
      required this.endTime,
      required this.status,
      this.requestedStartTime,
      this.requestedEndTime,
      this.hasChangeRequest,
      this.changeRequestBy});

  factory _$PtScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$PtScheduleImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int appointmentId;
  @override
  final int contractId;
  @override
  final String trainerName;
  @override
  final String memberName;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final String status;
  @override
  final String? requestedStartTime;
  @override
  final String? requestedEndTime;
  @override
  final bool? hasChangeRequest;
  @override
  final String? changeRequestBy;

  @override
  String toString() {
    return 'PtSchedule(appointmentId: $appointmentId, contractId: $contractId, trainerName: $trainerName, memberName: $memberName, startTime: $startTime, endTime: $endTime, status: $status, requestedStartTime: $requestedStartTime, requestedEndTime: $requestedEndTime, hasChangeRequest: $hasChangeRequest, changeRequestBy: $changeRequestBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PtScheduleImpl &&
            (identical(other.appointmentId, appointmentId) ||
                other.appointmentId == appointmentId) &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.trainerName, trainerName) ||
                other.trainerName == trainerName) &&
            (identical(other.memberName, memberName) ||
                other.memberName == memberName) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.requestedStartTime, requestedStartTime) ||
                other.requestedStartTime == requestedStartTime) &&
            (identical(other.requestedEndTime, requestedEndTime) ||
                other.requestedEndTime == requestedEndTime) &&
            (identical(other.hasChangeRequest, hasChangeRequest) ||
                other.hasChangeRequest == hasChangeRequest) &&
            (identical(other.changeRequestBy, changeRequestBy) ||
                other.changeRequestBy == changeRequestBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      appointmentId,
      contractId,
      trainerName,
      memberName,
      startTime,
      endTime,
      status,
      requestedStartTime,
      requestedEndTime,
      hasChangeRequest,
      changeRequestBy);

  /// Create a copy of PtSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PtScheduleImplCopyWith<_$PtScheduleImpl> get copyWith =>
      __$$PtScheduleImplCopyWithImpl<_$PtScheduleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PtScheduleImplToJson(
      this,
    );
  }
}

abstract class _PtSchedule implements PtSchedule {
  const factory _PtSchedule(
      {@JsonKey(name: 'id') required final int appointmentId,
      required final int contractId,
      required final String trainerName,
      required final String memberName,
      required final String startTime,
      required final String endTime,
      required final String status,
      final String? requestedStartTime,
      final String? requestedEndTime,
      final bool? hasChangeRequest,
      final String? changeRequestBy}) = _$PtScheduleImpl;

  factory _PtSchedule.fromJson(Map<String, dynamic> json) =
      _$PtScheduleImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get appointmentId;
  @override
  int get contractId;
  @override
  String get trainerName;
  @override
  String get memberName;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  String get status;
  @override
  String? get requestedStartTime;
  @override
  String? get requestedEndTime;
  @override
  bool? get hasChangeRequest;
  @override
  String? get changeRequestBy;

  /// Create a copy of PtSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PtScheduleImplCopyWith<_$PtScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
