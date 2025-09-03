// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_image_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProfileImageResponse _$ProfileImageResponseFromJson(Map<String, dynamic> json) {
  return _ProfileImageResponse.fromJson(json);
}

/// @nodoc
mixin _$ProfileImageResponse {
  int get fileId => throw _privateConstructorUsedError;
  String get fileUrl => throw _privateConstructorUsedError;
  String get originalFileName => throw _privateConstructorUsedError;
  String? get recordDate => throw _privateConstructorUsedError;

  /// Serializes this ProfileImageResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileImageResponseCopyWith<ProfileImageResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileImageResponseCopyWith<$Res> {
  factory $ProfileImageResponseCopyWith(ProfileImageResponse value,
          $Res Function(ProfileImageResponse) then) =
      _$ProfileImageResponseCopyWithImpl<$Res, ProfileImageResponse>;
  @useResult
  $Res call(
      {int fileId,
      String fileUrl,
      String originalFileName,
      String? recordDate});
}

/// @nodoc
class _$ProfileImageResponseCopyWithImpl<$Res,
        $Val extends ProfileImageResponse>
    implements $ProfileImageResponseCopyWith<$Res> {
  _$ProfileImageResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileId = null,
    Object? fileUrl = null,
    Object? originalFileName = null,
    Object? recordDate = freezed,
  }) {
    return _then(_value.copyWith(
      fileId: null == fileId
          ? _value.fileId
          : fileId // ignore: cast_nullable_to_non_nullable
              as int,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      originalFileName: null == originalFileName
          ? _value.originalFileName
          : originalFileName // ignore: cast_nullable_to_non_nullable
              as String,
      recordDate: freezed == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileImageResponseImplCopyWith<$Res>
    implements $ProfileImageResponseCopyWith<$Res> {
  factory _$$ProfileImageResponseImplCopyWith(_$ProfileImageResponseImpl value,
          $Res Function(_$ProfileImageResponseImpl) then) =
      __$$ProfileImageResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int fileId,
      String fileUrl,
      String originalFileName,
      String? recordDate});
}

/// @nodoc
class __$$ProfileImageResponseImplCopyWithImpl<$Res>
    extends _$ProfileImageResponseCopyWithImpl<$Res, _$ProfileImageResponseImpl>
    implements _$$ProfileImageResponseImplCopyWith<$Res> {
  __$$ProfileImageResponseImplCopyWithImpl(_$ProfileImageResponseImpl _value,
      $Res Function(_$ProfileImageResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileId = null,
    Object? fileUrl = null,
    Object? originalFileName = null,
    Object? recordDate = freezed,
  }) {
    return _then(_$ProfileImageResponseImpl(
      fileId: null == fileId
          ? _value.fileId
          : fileId // ignore: cast_nullable_to_non_nullable
              as int,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      originalFileName: null == originalFileName
          ? _value.originalFileName
          : originalFileName // ignore: cast_nullable_to_non_nullable
              as String,
      recordDate: freezed == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileImageResponseImpl implements _ProfileImageResponse {
  const _$ProfileImageResponseImpl(
      {required this.fileId,
      required this.fileUrl,
      required this.originalFileName,
      this.recordDate});

  factory _$ProfileImageResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileImageResponseImplFromJson(json);

  @override
  final int fileId;
  @override
  final String fileUrl;
  @override
  final String originalFileName;
  @override
  final String? recordDate;

  @override
  String toString() {
    return 'ProfileImageResponse(fileId: $fileId, fileUrl: $fileUrl, originalFileName: $originalFileName, recordDate: $recordDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileImageResponseImpl &&
            (identical(other.fileId, fileId) || other.fileId == fileId) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.originalFileName, originalFileName) ||
                other.originalFileName == originalFileName) &&
            (identical(other.recordDate, recordDate) ||
                other.recordDate == recordDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, fileId, fileUrl, originalFileName, recordDate);

  /// Create a copy of ProfileImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileImageResponseImplCopyWith<_$ProfileImageResponseImpl>
      get copyWith =>
          __$$ProfileImageResponseImplCopyWithImpl<_$ProfileImageResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileImageResponseImplToJson(
      this,
    );
  }
}

abstract class _ProfileImageResponse implements ProfileImageResponse {
  const factory _ProfileImageResponse(
      {required final int fileId,
      required final String fileUrl,
      required final String originalFileName,
      final String? recordDate}) = _$ProfileImageResponseImpl;

  factory _ProfileImageResponse.fromJson(Map<String, dynamic> json) =
      _$ProfileImageResponseImpl.fromJson;

  @override
  int get fileId;
  @override
  String get fileUrl;
  @override
  String get originalFileName;
  @override
  String? get recordDate;

  /// Create a copy of ProfileImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileImageResponseImplCopyWith<_$ProfileImageResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ProfileImageInfo _$ProfileImageInfoFromJson(Map<String, dynamic> json) {
  return _ProfileImageInfo.fromJson(json);
}

/// @nodoc
mixin _$ProfileImageInfo {
  String get profileImageUrl => throw _privateConstructorUsedError;

  /// Serializes this ProfileImageInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileImageInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileImageInfoCopyWith<ProfileImageInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileImageInfoCopyWith<$Res> {
  factory $ProfileImageInfoCopyWith(
          ProfileImageInfo value, $Res Function(ProfileImageInfo) then) =
      _$ProfileImageInfoCopyWithImpl<$Res, ProfileImageInfo>;
  @useResult
  $Res call({String profileImageUrl});
}

/// @nodoc
class _$ProfileImageInfoCopyWithImpl<$Res, $Val extends ProfileImageInfo>
    implements $ProfileImageInfoCopyWith<$Res> {
  _$ProfileImageInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileImageInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileImageUrl = null,
  }) {
    return _then(_value.copyWith(
      profileImageUrl: null == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileImageInfoImplCopyWith<$Res>
    implements $ProfileImageInfoCopyWith<$Res> {
  factory _$$ProfileImageInfoImplCopyWith(_$ProfileImageInfoImpl value,
          $Res Function(_$ProfileImageInfoImpl) then) =
      __$$ProfileImageInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profileImageUrl});
}

/// @nodoc
class __$$ProfileImageInfoImplCopyWithImpl<$Res>
    extends _$ProfileImageInfoCopyWithImpl<$Res, _$ProfileImageInfoImpl>
    implements _$$ProfileImageInfoImplCopyWith<$Res> {
  __$$ProfileImageInfoImplCopyWithImpl(_$ProfileImageInfoImpl _value,
      $Res Function(_$ProfileImageInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileImageInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileImageUrl = null,
  }) {
    return _then(_$ProfileImageInfoImpl(
      profileImageUrl: null == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileImageInfoImpl implements _ProfileImageInfo {
  const _$ProfileImageInfoImpl({required this.profileImageUrl});

  factory _$ProfileImageInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileImageInfoImplFromJson(json);

  @override
  final String profileImageUrl;

  @override
  String toString() {
    return 'ProfileImageInfo(profileImageUrl: $profileImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileImageInfoImpl &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, profileImageUrl);

  /// Create a copy of ProfileImageInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileImageInfoImplCopyWith<_$ProfileImageInfoImpl> get copyWith =>
      __$$ProfileImageInfoImplCopyWithImpl<_$ProfileImageInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileImageInfoImplToJson(
      this,
    );
  }
}

abstract class _ProfileImageInfo implements ProfileImageInfo {
  const factory _ProfileImageInfo({required final String profileImageUrl}) =
      _$ProfileImageInfoImpl;

  factory _ProfileImageInfo.fromJson(Map<String, dynamic> json) =
      _$ProfileImageInfoImpl.fromJson;

  @override
  String get profileImageUrl;

  /// Create a copy of ProfileImageInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileImageInfoImplCopyWith<_$ProfileImageInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
