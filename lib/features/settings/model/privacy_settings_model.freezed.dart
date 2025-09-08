// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PrivacySettings _$PrivacySettingsFromJson(Map<String, dynamic> json) {
  return _PrivacySettings.fromJson(json);
}

/// @nodoc
mixin _$PrivacySettings {
  bool get isOpenWorkoutRecord => throw _privateConstructorUsedError;
  bool get isOpenBodyImg => throw _privateConstructorUsedError;
  bool get isOpenBodyComposition => throw _privateConstructorUsedError;

  /// Serializes this PrivacySettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrivacySettingsCopyWith<PrivacySettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrivacySettingsCopyWith<$Res> {
  factory $PrivacySettingsCopyWith(
          PrivacySettings value, $Res Function(PrivacySettings) then) =
      _$PrivacySettingsCopyWithImpl<$Res, PrivacySettings>;
  @useResult
  $Res call(
      {bool isOpenWorkoutRecord,
      bool isOpenBodyImg,
      bool isOpenBodyComposition});
}

/// @nodoc
class _$PrivacySettingsCopyWithImpl<$Res, $Val extends PrivacySettings>
    implements $PrivacySettingsCopyWith<$Res> {
  _$PrivacySettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOpenWorkoutRecord = null,
    Object? isOpenBodyImg = null,
    Object? isOpenBodyComposition = null,
  }) {
    return _then(_value.copyWith(
      isOpenWorkoutRecord: null == isOpenWorkoutRecord
          ? _value.isOpenWorkoutRecord
          : isOpenWorkoutRecord // ignore: cast_nullable_to_non_nullable
              as bool,
      isOpenBodyImg: null == isOpenBodyImg
          ? _value.isOpenBodyImg
          : isOpenBodyImg // ignore: cast_nullable_to_non_nullable
              as bool,
      isOpenBodyComposition: null == isOpenBodyComposition
          ? _value.isOpenBodyComposition
          : isOpenBodyComposition // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrivacySettingsImplCopyWith<$Res>
    implements $PrivacySettingsCopyWith<$Res> {
  factory _$$PrivacySettingsImplCopyWith(_$PrivacySettingsImpl value,
          $Res Function(_$PrivacySettingsImpl) then) =
      __$$PrivacySettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isOpenWorkoutRecord,
      bool isOpenBodyImg,
      bool isOpenBodyComposition});
}

/// @nodoc
class __$$PrivacySettingsImplCopyWithImpl<$Res>
    extends _$PrivacySettingsCopyWithImpl<$Res, _$PrivacySettingsImpl>
    implements _$$PrivacySettingsImplCopyWith<$Res> {
  __$$PrivacySettingsImplCopyWithImpl(
      _$PrivacySettingsImpl _value, $Res Function(_$PrivacySettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOpenWorkoutRecord = null,
    Object? isOpenBodyImg = null,
    Object? isOpenBodyComposition = null,
  }) {
    return _then(_$PrivacySettingsImpl(
      isOpenWorkoutRecord: null == isOpenWorkoutRecord
          ? _value.isOpenWorkoutRecord
          : isOpenWorkoutRecord // ignore: cast_nullable_to_non_nullable
              as bool,
      isOpenBodyImg: null == isOpenBodyImg
          ? _value.isOpenBodyImg
          : isOpenBodyImg // ignore: cast_nullable_to_non_nullable
              as bool,
      isOpenBodyComposition: null == isOpenBodyComposition
          ? _value.isOpenBodyComposition
          : isOpenBodyComposition // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrivacySettingsImpl implements _PrivacySettings {
  const _$PrivacySettingsImpl(
      {required this.isOpenWorkoutRecord,
      required this.isOpenBodyImg,
      required this.isOpenBodyComposition});

  factory _$PrivacySettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrivacySettingsImplFromJson(json);

  @override
  final bool isOpenWorkoutRecord;
  @override
  final bool isOpenBodyImg;
  @override
  final bool isOpenBodyComposition;

  @override
  String toString() {
    return 'PrivacySettings(isOpenWorkoutRecord: $isOpenWorkoutRecord, isOpenBodyImg: $isOpenBodyImg, isOpenBodyComposition: $isOpenBodyComposition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrivacySettingsImpl &&
            (identical(other.isOpenWorkoutRecord, isOpenWorkoutRecord) ||
                other.isOpenWorkoutRecord == isOpenWorkoutRecord) &&
            (identical(other.isOpenBodyImg, isOpenBodyImg) ||
                other.isOpenBodyImg == isOpenBodyImg) &&
            (identical(other.isOpenBodyComposition, isOpenBodyComposition) ||
                other.isOpenBodyComposition == isOpenBodyComposition));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, isOpenWorkoutRecord, isOpenBodyImg, isOpenBodyComposition);

  /// Create a copy of PrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrivacySettingsImplCopyWith<_$PrivacySettingsImpl> get copyWith =>
      __$$PrivacySettingsImplCopyWithImpl<_$PrivacySettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrivacySettingsImplToJson(
      this,
    );
  }
}

abstract class _PrivacySettings implements PrivacySettings {
  const factory _PrivacySettings(
      {required final bool isOpenWorkoutRecord,
      required final bool isOpenBodyImg,
      required final bool isOpenBodyComposition}) = _$PrivacySettingsImpl;

  factory _PrivacySettings.fromJson(Map<String, dynamic> json) =
      _$PrivacySettingsImpl.fromJson;

  @override
  bool get isOpenWorkoutRecord;
  @override
  bool get isOpenBodyImg;
  @override
  bool get isOpenBodyComposition;

  /// Create a copy of PrivacySettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrivacySettingsImplCopyWith<_$PrivacySettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MemberInfo _$MemberInfoFromJson(Map<String, dynamic> json) {
  return _MemberInfo.fromJson(json);
}

/// @nodoc
mixin _$MemberInfo {
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  bool get isOpenWorkoutRecord => throw _privateConstructorUsedError;
  bool get isOpenBodyImg => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsOpenBodyComposition')
  bool get isOpenBodyComposition => throw _privateConstructorUsedError;
  @JsonKey(name: 'GymName')
  String get gymName => throw _privateConstructorUsedError;

  /// Serializes this MemberInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberInfoCopyWith<MemberInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberInfoCopyWith<$Res> {
  factory $MemberInfoCopyWith(
          MemberInfo value, $Res Function(MemberInfo) then) =
      _$MemberInfoCopyWithImpl<$Res, MemberInfo>;
  @useResult
  $Res call(
      {String name,
      String email,
      bool isOpenWorkoutRecord,
      bool isOpenBodyImg,
      @JsonKey(name: 'IsOpenBodyComposition') bool isOpenBodyComposition,
      @JsonKey(name: 'GymName') String gymName});
}

/// @nodoc
class _$MemberInfoCopyWithImpl<$Res, $Val extends MemberInfo>
    implements $MemberInfoCopyWith<$Res> {
  _$MemberInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? isOpenWorkoutRecord = null,
    Object? isOpenBodyImg = null,
    Object? isOpenBodyComposition = null,
    Object? gymName = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      isOpenWorkoutRecord: null == isOpenWorkoutRecord
          ? _value.isOpenWorkoutRecord
          : isOpenWorkoutRecord // ignore: cast_nullable_to_non_nullable
              as bool,
      isOpenBodyImg: null == isOpenBodyImg
          ? _value.isOpenBodyImg
          : isOpenBodyImg // ignore: cast_nullable_to_non_nullable
              as bool,
      isOpenBodyComposition: null == isOpenBodyComposition
          ? _value.isOpenBodyComposition
          : isOpenBodyComposition // ignore: cast_nullable_to_non_nullable
              as bool,
      gymName: null == gymName
          ? _value.gymName
          : gymName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemberInfoImplCopyWith<$Res>
    implements $MemberInfoCopyWith<$Res> {
  factory _$$MemberInfoImplCopyWith(
          _$MemberInfoImpl value, $Res Function(_$MemberInfoImpl) then) =
      __$$MemberInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String email,
      bool isOpenWorkoutRecord,
      bool isOpenBodyImg,
      @JsonKey(name: 'IsOpenBodyComposition') bool isOpenBodyComposition,
      @JsonKey(name: 'GymName') String gymName});
}

/// @nodoc
class __$$MemberInfoImplCopyWithImpl<$Res>
    extends _$MemberInfoCopyWithImpl<$Res, _$MemberInfoImpl>
    implements _$$MemberInfoImplCopyWith<$Res> {
  __$$MemberInfoImplCopyWithImpl(
      _$MemberInfoImpl _value, $Res Function(_$MemberInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of MemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? isOpenWorkoutRecord = null,
    Object? isOpenBodyImg = null,
    Object? isOpenBodyComposition = null,
    Object? gymName = null,
  }) {
    return _then(_$MemberInfoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      isOpenWorkoutRecord: null == isOpenWorkoutRecord
          ? _value.isOpenWorkoutRecord
          : isOpenWorkoutRecord // ignore: cast_nullable_to_non_nullable
              as bool,
      isOpenBodyImg: null == isOpenBodyImg
          ? _value.isOpenBodyImg
          : isOpenBodyImg // ignore: cast_nullable_to_non_nullable
              as bool,
      isOpenBodyComposition: null == isOpenBodyComposition
          ? _value.isOpenBodyComposition
          : isOpenBodyComposition // ignore: cast_nullable_to_non_nullable
              as bool,
      gymName: null == gymName
          ? _value.gymName
          : gymName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberInfoImpl implements _MemberInfo {
  const _$MemberInfoImpl(
      {required this.name,
      required this.email,
      required this.isOpenWorkoutRecord,
      required this.isOpenBodyImg,
      @JsonKey(name: 'IsOpenBodyComposition')
      required this.isOpenBodyComposition,
      @JsonKey(name: 'GymName') required this.gymName});

  factory _$MemberInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberInfoImplFromJson(json);

  @override
  final String name;
  @override
  final String email;
  @override
  final bool isOpenWorkoutRecord;
  @override
  final bool isOpenBodyImg;
  @override
  @JsonKey(name: 'IsOpenBodyComposition')
  final bool isOpenBodyComposition;
  @override
  @JsonKey(name: 'GymName')
  final String gymName;

  @override
  String toString() {
    return 'MemberInfo(name: $name, email: $email, isOpenWorkoutRecord: $isOpenWorkoutRecord, isOpenBodyImg: $isOpenBodyImg, isOpenBodyComposition: $isOpenBodyComposition, gymName: $gymName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberInfoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isOpenWorkoutRecord, isOpenWorkoutRecord) ||
                other.isOpenWorkoutRecord == isOpenWorkoutRecord) &&
            (identical(other.isOpenBodyImg, isOpenBodyImg) ||
                other.isOpenBodyImg == isOpenBodyImg) &&
            (identical(other.isOpenBodyComposition, isOpenBodyComposition) ||
                other.isOpenBodyComposition == isOpenBodyComposition) &&
            (identical(other.gymName, gymName) || other.gymName == gymName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, email, isOpenWorkoutRecord,
      isOpenBodyImg, isOpenBodyComposition, gymName);

  /// Create a copy of MemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberInfoImplCopyWith<_$MemberInfoImpl> get copyWith =>
      __$$MemberInfoImplCopyWithImpl<_$MemberInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberInfoImplToJson(
      this,
    );
  }
}

abstract class _MemberInfo implements MemberInfo {
  const factory _MemberInfo(
          {required final String name,
          required final String email,
          required final bool isOpenWorkoutRecord,
          required final bool isOpenBodyImg,
          @JsonKey(name: 'IsOpenBodyComposition')
          required final bool isOpenBodyComposition,
          @JsonKey(name: 'GymName') required final String gymName}) =
      _$MemberInfoImpl;

  factory _MemberInfo.fromJson(Map<String, dynamic> json) =
      _$MemberInfoImpl.fromJson;

  @override
  String get name;
  @override
  String get email;
  @override
  bool get isOpenWorkoutRecord;
  @override
  bool get isOpenBodyImg;
  @override
  @JsonKey(name: 'IsOpenBodyComposition')
  bool get isOpenBodyComposition;
  @override
  @JsonKey(name: 'GymName')
  String get gymName;

  /// Create a copy of MemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberInfoImplCopyWith<_$MemberInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
