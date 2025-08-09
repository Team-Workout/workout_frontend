// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pt_schedule_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PTSchedule _$PTScheduleFromJson(Map<String, dynamic> json) {
  return _PTSchedule.fromJson(json);
}

/// @nodoc
mixin _$PTSchedule {
  String get id => throw _privateConstructorUsedError;
  String get trainerId => throw _privateConstructorUsedError;
  String get trainerName => throw _privateConstructorUsedError;
  String get memberId => throw _privateConstructorUsedError;
  String get memberName => throw _privateConstructorUsedError;
  DateTime get dateTime => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  PTScheduleStatus get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PTSchedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PTSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PTScheduleCopyWith<PTSchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PTScheduleCopyWith<$Res> {
  factory $PTScheduleCopyWith(
          PTSchedule value, $Res Function(PTSchedule) then) =
      _$PTScheduleCopyWithImpl<$Res, PTSchedule>;
  @useResult
  $Res call(
      {String id,
      String trainerId,
      String trainerName,
      String memberId,
      String memberName,
      DateTime dateTime,
      int durationMinutes,
      PTScheduleStatus status,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$PTScheduleCopyWithImpl<$Res, $Val extends PTSchedule>
    implements $PTScheduleCopyWith<$Res> {
  _$PTScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PTSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trainerId = null,
    Object? trainerName = null,
    Object? memberId = null,
    Object? memberName = null,
    Object? dateTime = null,
    Object? durationMinutes = null,
    Object? status = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
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
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PTScheduleStatus,
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
abstract class _$$PTScheduleImplCopyWith<$Res>
    implements $PTScheduleCopyWith<$Res> {
  factory _$$PTScheduleImplCopyWith(
          _$PTScheduleImpl value, $Res Function(_$PTScheduleImpl) then) =
      __$$PTScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String trainerId,
      String trainerName,
      String memberId,
      String memberName,
      DateTime dateTime,
      int durationMinutes,
      PTScheduleStatus status,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$PTScheduleImplCopyWithImpl<$Res>
    extends _$PTScheduleCopyWithImpl<$Res, _$PTScheduleImpl>
    implements _$$PTScheduleImplCopyWith<$Res> {
  __$$PTScheduleImplCopyWithImpl(
      _$PTScheduleImpl _value, $Res Function(_$PTScheduleImpl) _then)
      : super(_value, _then);

  /// Create a copy of PTSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trainerId = null,
    Object? trainerName = null,
    Object? memberId = null,
    Object? memberName = null,
    Object? dateTime = null,
    Object? durationMinutes = null,
    Object? status = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PTScheduleImpl(
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
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PTScheduleStatus,
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
class _$PTScheduleImpl implements _PTSchedule {
  const _$PTScheduleImpl(
      {required this.id,
      required this.trainerId,
      required this.trainerName,
      required this.memberId,
      required this.memberName,
      required this.dateTime,
      required this.durationMinutes,
      this.status = PTScheduleStatus.scheduled,
      this.notes,
      this.createdAt,
      this.updatedAt});

  factory _$PTScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$PTScheduleImplFromJson(json);

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
  final DateTime dateTime;
  @override
  final int durationMinutes;
  @override
  @JsonKey()
  final PTScheduleStatus status;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PTSchedule(id: $id, trainerId: $trainerId, trainerName: $trainerName, memberId: $memberId, memberName: $memberName, dateTime: $dateTime, durationMinutes: $durationMinutes, status: $status, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PTScheduleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.trainerId, trainerId) ||
                other.trainerId == trainerId) &&
            (identical(other.trainerName, trainerName) ||
                other.trainerName == trainerName) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.memberName, memberName) ||
                other.memberName == memberName) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.status, status) || other.status == status) &&
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
      id,
      trainerId,
      trainerName,
      memberId,
      memberName,
      dateTime,
      durationMinutes,
      status,
      notes,
      createdAt,
      updatedAt);

  /// Create a copy of PTSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PTScheduleImplCopyWith<_$PTScheduleImpl> get copyWith =>
      __$$PTScheduleImplCopyWithImpl<_$PTScheduleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PTScheduleImplToJson(
      this,
    );
  }
}

abstract class _PTSchedule implements PTSchedule {
  const factory _PTSchedule(
      {required final String id,
      required final String trainerId,
      required final String trainerName,
      required final String memberId,
      required final String memberName,
      required final DateTime dateTime,
      required final int durationMinutes,
      final PTScheduleStatus status,
      final String? notes,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$PTScheduleImpl;

  factory _PTSchedule.fromJson(Map<String, dynamic> json) =
      _$PTScheduleImpl.fromJson;

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
  DateTime get dateTime;
  @override
  int get durationMinutes;
  @override
  PTScheduleStatus get status;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of PTSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PTScheduleImplCopyWith<_$PTScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
