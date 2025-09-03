// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'body_image_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BodyImageResponse _$BodyImageResponseFromJson(Map<String, dynamic> json) {
  return _BodyImageResponse.fromJson(json);
}

/// @nodoc
mixin _$BodyImageResponse {
  int get fileId => throw _privateConstructorUsedError;
  String get fileUrl => throw _privateConstructorUsedError;
  String get originalFileName => throw _privateConstructorUsedError;
  String get recordDate => throw _privateConstructorUsedError;

  /// Serializes this BodyImageResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BodyImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BodyImageResponseCopyWith<BodyImageResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BodyImageResponseCopyWith<$Res> {
  factory $BodyImageResponseCopyWith(
          BodyImageResponse value, $Res Function(BodyImageResponse) then) =
      _$BodyImageResponseCopyWithImpl<$Res, BodyImageResponse>;
  @useResult
  $Res call(
      {int fileId, String fileUrl, String originalFileName, String recordDate});
}

/// @nodoc
class _$BodyImageResponseCopyWithImpl<$Res, $Val extends BodyImageResponse>
    implements $BodyImageResponseCopyWith<$Res> {
  _$BodyImageResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BodyImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileId = null,
    Object? fileUrl = null,
    Object? originalFileName = null,
    Object? recordDate = null,
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
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BodyImageResponseImplCopyWith<$Res>
    implements $BodyImageResponseCopyWith<$Res> {
  factory _$$BodyImageResponseImplCopyWith(_$BodyImageResponseImpl value,
          $Res Function(_$BodyImageResponseImpl) then) =
      __$$BodyImageResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int fileId, String fileUrl, String originalFileName, String recordDate});
}

/// @nodoc
class __$$BodyImageResponseImplCopyWithImpl<$Res>
    extends _$BodyImageResponseCopyWithImpl<$Res, _$BodyImageResponseImpl>
    implements _$$BodyImageResponseImplCopyWith<$Res> {
  __$$BodyImageResponseImplCopyWithImpl(_$BodyImageResponseImpl _value,
      $Res Function(_$BodyImageResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of BodyImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileId = null,
    Object? fileUrl = null,
    Object? originalFileName = null,
    Object? recordDate = null,
  }) {
    return _then(_$BodyImageResponseImpl(
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
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BodyImageResponseImpl implements _BodyImageResponse {
  const _$BodyImageResponseImpl(
      {required this.fileId,
      required this.fileUrl,
      required this.originalFileName,
      required this.recordDate});

  factory _$BodyImageResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$BodyImageResponseImplFromJson(json);

  @override
  final int fileId;
  @override
  final String fileUrl;
  @override
  final String originalFileName;
  @override
  final String recordDate;

  @override
  String toString() {
    return 'BodyImageResponse(fileId: $fileId, fileUrl: $fileUrl, originalFileName: $originalFileName, recordDate: $recordDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodyImageResponseImpl &&
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

  /// Create a copy of BodyImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BodyImageResponseImplCopyWith<_$BodyImageResponseImpl> get copyWith =>
      __$$BodyImageResponseImplCopyWithImpl<_$BodyImageResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BodyImageResponseImplToJson(
      this,
    );
  }
}

abstract class _BodyImageResponse implements BodyImageResponse {
  const factory _BodyImageResponse(
      {required final int fileId,
      required final String fileUrl,
      required final String originalFileName,
      required final String recordDate}) = _$BodyImageResponseImpl;

  factory _BodyImageResponse.fromJson(Map<String, dynamic> json) =
      _$BodyImageResponseImpl.fromJson;

  @override
  int get fileId;
  @override
  String get fileUrl;
  @override
  String get originalFileName;
  @override
  String get recordDate;

  /// Create a copy of BodyImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodyImageResponseImplCopyWith<_$BodyImageResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
