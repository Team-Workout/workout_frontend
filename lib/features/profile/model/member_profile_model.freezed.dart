// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MemberProfile _$MemberProfileFromJson(Map<String, dynamic> json) {
  return _MemberProfile.fromJson(json);
}

/// @nodoc
mixin _$MemberProfile {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  DateTime? get birthDate => throw _privateConstructorUsedError;
  double? get height => throw _privateConstructorUsedError;
  double? get currentWeight => throw _privateConstructorUsedError;
  double? get targetWeight => throw _privateConstructorUsedError;
  String? get medicalHistory => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get joinDate => throw _privateConstructorUsedError;
  int get totalSessions => throw _privateConstructorUsedError;
  int get monthSessions => throw _privateConstructorUsedError;
  String? get assignedTrainerId => throw _privateConstructorUsedError;
  List<WeightRecord> get weightHistory => throw _privateConstructorUsedError;

  /// Serializes this MemberProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberProfileCopyWith<MemberProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberProfileCopyWith<$Res> {
  factory $MemberProfileCopyWith(
          MemberProfile value, $Res Function(MemberProfile) then) =
      _$MemberProfileCopyWithImpl<$Res, MemberProfile>;
  @useResult
  $Res call(
      {String id,
      String email,
      String name,
      String? phoneNumber,
      DateTime? birthDate,
      double? height,
      double? currentWeight,
      double? targetWeight,
      String? medicalHistory,
      String? notes,
      DateTime joinDate,
      int totalSessions,
      int monthSessions,
      String? assignedTrainerId,
      List<WeightRecord> weightHistory});
}

/// @nodoc
class _$MemberProfileCopyWithImpl<$Res, $Val extends MemberProfile>
    implements $MemberProfileCopyWith<$Res> {
  _$MemberProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? phoneNumber = freezed,
    Object? birthDate = freezed,
    Object? height = freezed,
    Object? currentWeight = freezed,
    Object? targetWeight = freezed,
    Object? medicalHistory = freezed,
    Object? notes = freezed,
    Object? joinDate = null,
    Object? totalSessions = null,
    Object? monthSessions = null,
    Object? assignedTrainerId = freezed,
    Object? weightHistory = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      currentWeight: freezed == currentWeight
          ? _value.currentWeight
          : currentWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      targetWeight: freezed == targetWeight
          ? _value.targetWeight
          : targetWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      medicalHistory: freezed == medicalHistory
          ? _value.medicalHistory
          : medicalHistory // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      joinDate: null == joinDate
          ? _value.joinDate
          : joinDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
      monthSessions: null == monthSessions
          ? _value.monthSessions
          : monthSessions // ignore: cast_nullable_to_non_nullable
              as int,
      assignedTrainerId: freezed == assignedTrainerId
          ? _value.assignedTrainerId
          : assignedTrainerId // ignore: cast_nullable_to_non_nullable
              as String?,
      weightHistory: null == weightHistory
          ? _value.weightHistory
          : weightHistory // ignore: cast_nullable_to_non_nullable
              as List<WeightRecord>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemberProfileImplCopyWith<$Res>
    implements $MemberProfileCopyWith<$Res> {
  factory _$$MemberProfileImplCopyWith(
          _$MemberProfileImpl value, $Res Function(_$MemberProfileImpl) then) =
      __$$MemberProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String name,
      String? phoneNumber,
      DateTime? birthDate,
      double? height,
      double? currentWeight,
      double? targetWeight,
      String? medicalHistory,
      String? notes,
      DateTime joinDate,
      int totalSessions,
      int monthSessions,
      String? assignedTrainerId,
      List<WeightRecord> weightHistory});
}

/// @nodoc
class __$$MemberProfileImplCopyWithImpl<$Res>
    extends _$MemberProfileCopyWithImpl<$Res, _$MemberProfileImpl>
    implements _$$MemberProfileImplCopyWith<$Res> {
  __$$MemberProfileImplCopyWithImpl(
      _$MemberProfileImpl _value, $Res Function(_$MemberProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of MemberProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? phoneNumber = freezed,
    Object? birthDate = freezed,
    Object? height = freezed,
    Object? currentWeight = freezed,
    Object? targetWeight = freezed,
    Object? medicalHistory = freezed,
    Object? notes = freezed,
    Object? joinDate = null,
    Object? totalSessions = null,
    Object? monthSessions = null,
    Object? assignedTrainerId = freezed,
    Object? weightHistory = null,
  }) {
    return _then(_$MemberProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double?,
      currentWeight: freezed == currentWeight
          ? _value.currentWeight
          : currentWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      targetWeight: freezed == targetWeight
          ? _value.targetWeight
          : targetWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      medicalHistory: freezed == medicalHistory
          ? _value.medicalHistory
          : medicalHistory // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      joinDate: null == joinDate
          ? _value.joinDate
          : joinDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
      monthSessions: null == monthSessions
          ? _value.monthSessions
          : monthSessions // ignore: cast_nullable_to_non_nullable
              as int,
      assignedTrainerId: freezed == assignedTrainerId
          ? _value.assignedTrainerId
          : assignedTrainerId // ignore: cast_nullable_to_non_nullable
              as String?,
      weightHistory: null == weightHistory
          ? _value._weightHistory
          : weightHistory // ignore: cast_nullable_to_non_nullable
              as List<WeightRecord>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberProfileImpl implements _MemberProfile {
  const _$MemberProfileImpl(
      {required this.id,
      required this.email,
      required this.name,
      this.phoneNumber,
      this.birthDate,
      this.height,
      this.currentWeight,
      this.targetWeight,
      this.medicalHistory,
      this.notes,
      required this.joinDate,
      required this.totalSessions,
      required this.monthSessions,
      this.assignedTrainerId,
      final List<WeightRecord> weightHistory = const []})
      : _weightHistory = weightHistory;

  factory _$MemberProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String name;
  @override
  final String? phoneNumber;
  @override
  final DateTime? birthDate;
  @override
  final double? height;
  @override
  final double? currentWeight;
  @override
  final double? targetWeight;
  @override
  final String? medicalHistory;
  @override
  final String? notes;
  @override
  final DateTime joinDate;
  @override
  final int totalSessions;
  @override
  final int monthSessions;
  @override
  final String? assignedTrainerId;
  final List<WeightRecord> _weightHistory;
  @override
  @JsonKey()
  List<WeightRecord> get weightHistory {
    if (_weightHistory is EqualUnmodifiableListView) return _weightHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weightHistory);
  }

  @override
  String toString() {
    return 'MemberProfile(id: $id, email: $email, name: $name, phoneNumber: $phoneNumber, birthDate: $birthDate, height: $height, currentWeight: $currentWeight, targetWeight: $targetWeight, medicalHistory: $medicalHistory, notes: $notes, joinDate: $joinDate, totalSessions: $totalSessions, monthSessions: $monthSessions, assignedTrainerId: $assignedTrainerId, weightHistory: $weightHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.currentWeight, currentWeight) ||
                other.currentWeight == currentWeight) &&
            (identical(other.targetWeight, targetWeight) ||
                other.targetWeight == targetWeight) &&
            (identical(other.medicalHistory, medicalHistory) ||
                other.medicalHistory == medicalHistory) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.joinDate, joinDate) ||
                other.joinDate == joinDate) &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions) &&
            (identical(other.monthSessions, monthSessions) ||
                other.monthSessions == monthSessions) &&
            (identical(other.assignedTrainerId, assignedTrainerId) ||
                other.assignedTrainerId == assignedTrainerId) &&
            const DeepCollectionEquality()
                .equals(other._weightHistory, _weightHistory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      name,
      phoneNumber,
      birthDate,
      height,
      currentWeight,
      targetWeight,
      medicalHistory,
      notes,
      joinDate,
      totalSessions,
      monthSessions,
      assignedTrainerId,
      const DeepCollectionEquality().hash(_weightHistory));

  /// Create a copy of MemberProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberProfileImplCopyWith<_$MemberProfileImpl> get copyWith =>
      __$$MemberProfileImplCopyWithImpl<_$MemberProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberProfileImplToJson(
      this,
    );
  }
}

abstract class _MemberProfile implements MemberProfile {
  const factory _MemberProfile(
      {required final String id,
      required final String email,
      required final String name,
      final String? phoneNumber,
      final DateTime? birthDate,
      final double? height,
      final double? currentWeight,
      final double? targetWeight,
      final String? medicalHistory,
      final String? notes,
      required final DateTime joinDate,
      required final int totalSessions,
      required final int monthSessions,
      final String? assignedTrainerId,
      final List<WeightRecord> weightHistory}) = _$MemberProfileImpl;

  factory _MemberProfile.fromJson(Map<String, dynamic> json) =
      _$MemberProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get name;
  @override
  String? get phoneNumber;
  @override
  DateTime? get birthDate;
  @override
  double? get height;
  @override
  double? get currentWeight;
  @override
  double? get targetWeight;
  @override
  String? get medicalHistory;
  @override
  String? get notes;
  @override
  DateTime get joinDate;
  @override
  int get totalSessions;
  @override
  int get monthSessions;
  @override
  String? get assignedTrainerId;
  @override
  List<WeightRecord> get weightHistory;

  /// Create a copy of MemberProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberProfileImplCopyWith<_$MemberProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeightRecord _$WeightRecordFromJson(Map<String, dynamic> json) {
  return _WeightRecord.fromJson(json);
}

/// @nodoc
mixin _$WeightRecord {
  DateTime get date => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;

  /// Serializes this WeightRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeightRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeightRecordCopyWith<WeightRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeightRecordCopyWith<$Res> {
  factory $WeightRecordCopyWith(
          WeightRecord value, $Res Function(WeightRecord) then) =
      _$WeightRecordCopyWithImpl<$Res, WeightRecord>;
  @useResult
  $Res call({DateTime date, double weight});
}

/// @nodoc
class _$WeightRecordCopyWithImpl<$Res, $Val extends WeightRecord>
    implements $WeightRecordCopyWith<$Res> {
  _$WeightRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeightRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? weight = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeightRecordImplCopyWith<$Res>
    implements $WeightRecordCopyWith<$Res> {
  factory _$$WeightRecordImplCopyWith(
          _$WeightRecordImpl value, $Res Function(_$WeightRecordImpl) then) =
      __$$WeightRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, double weight});
}

/// @nodoc
class __$$WeightRecordImplCopyWithImpl<$Res>
    extends _$WeightRecordCopyWithImpl<$Res, _$WeightRecordImpl>
    implements _$$WeightRecordImplCopyWith<$Res> {
  __$$WeightRecordImplCopyWithImpl(
      _$WeightRecordImpl _value, $Res Function(_$WeightRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of WeightRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? weight = null,
  }) {
    return _then(_$WeightRecordImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeightRecordImpl implements _WeightRecord {
  const _$WeightRecordImpl({required this.date, required this.weight});

  factory _$WeightRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeightRecordImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double weight;

  @override
  String toString() {
    return 'WeightRecord(date: $date, weight: $weight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeightRecordImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.weight, weight) || other.weight == weight));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, weight);

  /// Create a copy of WeightRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeightRecordImplCopyWith<_$WeightRecordImpl> get copyWith =>
      __$$WeightRecordImplCopyWithImpl<_$WeightRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeightRecordImplToJson(
      this,
    );
  }
}

abstract class _WeightRecord implements WeightRecord {
  const factory _WeightRecord(
      {required final DateTime date,
      required final double weight}) = _$WeightRecordImpl;

  factory _WeightRecord.fromJson(Map<String, dynamic> json) =
      _$WeightRecordImpl.fromJson;

  @override
  DateTime get date;
  @override
  double get weight;

  /// Create a copy of WeightRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeightRecordImplCopyWith<_$WeightRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
