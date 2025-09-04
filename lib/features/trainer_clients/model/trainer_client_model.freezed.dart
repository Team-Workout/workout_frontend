// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trainer_client_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TrainerClient _$TrainerClientFromJson(Map<String, dynamic> json) {
  return _TrainerClient.fromJson(json);
}

/// @nodoc
mixin _$TrainerClient {
  int get id => throw _privateConstructorUsedError;
  int get gymId => throw _privateConstructorUsedError;
  String get gymName => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;

  /// Serializes this TrainerClient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrainerClient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainerClientCopyWith<TrainerClient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainerClientCopyWith<$Res> {
  factory $TrainerClientCopyWith(
          TrainerClient value, $Res Function(TrainerClient) then) =
      _$TrainerClientCopyWithImpl<$Res, TrainerClient>;
  @useResult
  $Res call(
      {int id,
      int gymId,
      String gymName,
      String name,
      String gender,
      String? email,
      String? profileImageUrl});
}

/// @nodoc
class _$TrainerClientCopyWithImpl<$Res, $Val extends TrainerClient>
    implements $TrainerClientCopyWith<$Res> {
  _$TrainerClientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainerClient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? gymId = null,
    Object? gymName = null,
    Object? name = null,
    Object? gender = null,
    Object? email = freezed,
    Object? profileImageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      gymId: null == gymId
          ? _value.gymId
          : gymId // ignore: cast_nullable_to_non_nullable
              as int,
      gymName: null == gymName
          ? _value.gymName
          : gymName // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainerClientImplCopyWith<$Res>
    implements $TrainerClientCopyWith<$Res> {
  factory _$$TrainerClientImplCopyWith(
          _$TrainerClientImpl value, $Res Function(_$TrainerClientImpl) then) =
      __$$TrainerClientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int gymId,
      String gymName,
      String name,
      String gender,
      String? email,
      String? profileImageUrl});
}

/// @nodoc
class __$$TrainerClientImplCopyWithImpl<$Res>
    extends _$TrainerClientCopyWithImpl<$Res, _$TrainerClientImpl>
    implements _$$TrainerClientImplCopyWith<$Res> {
  __$$TrainerClientImplCopyWithImpl(
      _$TrainerClientImpl _value, $Res Function(_$TrainerClientImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainerClient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? gymId = null,
    Object? gymName = null,
    Object? name = null,
    Object? gender = null,
    Object? email = freezed,
    Object? profileImageUrl = freezed,
  }) {
    return _then(_$TrainerClientImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      gymId: null == gymId
          ? _value.gymId
          : gymId // ignore: cast_nullable_to_non_nullable
              as int,
      gymName: null == gymName
          ? _value.gymName
          : gymName // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrainerClientImpl extends _TrainerClient {
  const _$TrainerClientImpl(
      {required this.id,
      required this.gymId,
      required this.gymName,
      required this.name,
      required this.gender,
      this.email,
      this.profileImageUrl})
      : super._();

  factory _$TrainerClientImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainerClientImplFromJson(json);

  @override
  final int id;
  @override
  final int gymId;
  @override
  final String gymName;
  @override
  final String name;
  @override
  final String gender;
  @override
  final String? email;
  @override
  final String? profileImageUrl;

  @override
  String toString() {
    return 'TrainerClient(id: $id, gymId: $gymId, gymName: $gymName, name: $name, gender: $gender, email: $email, profileImageUrl: $profileImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainerClientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.gymId, gymId) || other.gymId == gymId) &&
            (identical(other.gymName, gymName) || other.gymName == gymName) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, gymId, gymName, name, gender, email, profileImageUrl);

  /// Create a copy of TrainerClient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainerClientImplCopyWith<_$TrainerClientImpl> get copyWith =>
      __$$TrainerClientImplCopyWithImpl<_$TrainerClientImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainerClientImplToJson(
      this,
    );
  }
}

abstract class _TrainerClient extends TrainerClient {
  const factory _TrainerClient(
      {required final int id,
      required final int gymId,
      required final String gymName,
      required final String name,
      required final String gender,
      final String? email,
      final String? profileImageUrl}) = _$TrainerClientImpl;
  const _TrainerClient._() : super._();

  factory _TrainerClient.fromJson(Map<String, dynamic> json) =
      _$TrainerClientImpl.fromJson;

  @override
  int get id;
  @override
  int get gymId;
  @override
  String get gymName;
  @override
  String get name;
  @override
  String get gender;
  @override
  String? get email;
  @override
  String? get profileImageUrl;

  /// Create a copy of TrainerClient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainerClientImplCopyWith<_$TrainerClientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrainerClientResponse _$TrainerClientResponseFromJson(
    Map<String, dynamic> json) {
  return _TrainerClientResponse.fromJson(json);
}

/// @nodoc
mixin _$TrainerClientResponse {
  List<TrainerClient> get data => throw _privateConstructorUsedError;
  PageInfo get pageInfo => throw _privateConstructorUsedError;

  /// Serializes this TrainerClientResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrainerClientResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainerClientResponseCopyWith<TrainerClientResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainerClientResponseCopyWith<$Res> {
  factory $TrainerClientResponseCopyWith(TrainerClientResponse value,
          $Res Function(TrainerClientResponse) then) =
      _$TrainerClientResponseCopyWithImpl<$Res, TrainerClientResponse>;
  @useResult
  $Res call({List<TrainerClient> data, PageInfo pageInfo});

  $PageInfoCopyWith<$Res> get pageInfo;
}

/// @nodoc
class _$TrainerClientResponseCopyWithImpl<$Res,
        $Val extends TrainerClientResponse>
    implements $TrainerClientResponseCopyWith<$Res> {
  _$TrainerClientResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainerClientResponse
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
              as List<TrainerClient>,
      pageInfo: null == pageInfo
          ? _value.pageInfo
          : pageInfo // ignore: cast_nullable_to_non_nullable
              as PageInfo,
    ) as $Val);
  }

  /// Create a copy of TrainerClientResponse
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
abstract class _$$TrainerClientResponseImplCopyWith<$Res>
    implements $TrainerClientResponseCopyWith<$Res> {
  factory _$$TrainerClientResponseImplCopyWith(
          _$TrainerClientResponseImpl value,
          $Res Function(_$TrainerClientResponseImpl) then) =
      __$$TrainerClientResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TrainerClient> data, PageInfo pageInfo});

  @override
  $PageInfoCopyWith<$Res> get pageInfo;
}

/// @nodoc
class __$$TrainerClientResponseImplCopyWithImpl<$Res>
    extends _$TrainerClientResponseCopyWithImpl<$Res,
        _$TrainerClientResponseImpl>
    implements _$$TrainerClientResponseImplCopyWith<$Res> {
  __$$TrainerClientResponseImplCopyWithImpl(_$TrainerClientResponseImpl _value,
      $Res Function(_$TrainerClientResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainerClientResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? pageInfo = null,
  }) {
    return _then(_$TrainerClientResponseImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<TrainerClient>,
      pageInfo: null == pageInfo
          ? _value.pageInfo
          : pageInfo // ignore: cast_nullable_to_non_nullable
              as PageInfo,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrainerClientResponseImpl implements _TrainerClientResponse {
  const _$TrainerClientResponseImpl(
      {required final List<TrainerClient> data, required this.pageInfo})
      : _data = data;

  factory _$TrainerClientResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainerClientResponseImplFromJson(json);

  final List<TrainerClient> _data;
  @override
  List<TrainerClient> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final PageInfo pageInfo;

  @override
  String toString() {
    return 'TrainerClientResponse(data: $data, pageInfo: $pageInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainerClientResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.pageInfo, pageInfo) ||
                other.pageInfo == pageInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), pageInfo);

  /// Create a copy of TrainerClientResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainerClientResponseImplCopyWith<_$TrainerClientResponseImpl>
      get copyWith => __$$TrainerClientResponseImplCopyWithImpl<
          _$TrainerClientResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainerClientResponseImplToJson(
      this,
    );
  }
}

abstract class _TrainerClientResponse implements TrainerClientResponse {
  const factory _TrainerClientResponse(
      {required final List<TrainerClient> data,
      required final PageInfo pageInfo}) = _$TrainerClientResponseImpl;

  factory _TrainerClientResponse.fromJson(Map<String, dynamic> json) =
      _$TrainerClientResponseImpl.fromJson;

  @override
  List<TrainerClient> get data;
  @override
  PageInfo get pageInfo;

  /// Create a copy of TrainerClientResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainerClientResponseImplCopyWith<_$TrainerClientResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
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

MemberBodyImage _$MemberBodyImageFromJson(Map<String, dynamic> json) {
  return _MemberBodyImage.fromJson(json);
}

/// @nodoc
mixin _$MemberBodyImage {
  int get fileId => throw _privateConstructorUsedError;
  String get fileUrl => throw _privateConstructorUsedError;
  String? get originalFileName => throw _privateConstructorUsedError;
  String get recordDate => throw _privateConstructorUsedError;

  /// Serializes this MemberBodyImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberBodyImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberBodyImageCopyWith<MemberBodyImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberBodyImageCopyWith<$Res> {
  factory $MemberBodyImageCopyWith(
          MemberBodyImage value, $Res Function(MemberBodyImage) then) =
      _$MemberBodyImageCopyWithImpl<$Res, MemberBodyImage>;
  @useResult
  $Res call(
      {int fileId,
      String fileUrl,
      String? originalFileName,
      String recordDate});
}

/// @nodoc
class _$MemberBodyImageCopyWithImpl<$Res, $Val extends MemberBodyImage>
    implements $MemberBodyImageCopyWith<$Res> {
  _$MemberBodyImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberBodyImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileId = null,
    Object? fileUrl = null,
    Object? originalFileName = freezed,
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
      originalFileName: freezed == originalFileName
          ? _value.originalFileName
          : originalFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemberBodyImageImplCopyWith<$Res>
    implements $MemberBodyImageCopyWith<$Res> {
  factory _$$MemberBodyImageImplCopyWith(_$MemberBodyImageImpl value,
          $Res Function(_$MemberBodyImageImpl) then) =
      __$$MemberBodyImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int fileId,
      String fileUrl,
      String? originalFileName,
      String recordDate});
}

/// @nodoc
class __$$MemberBodyImageImplCopyWithImpl<$Res>
    extends _$MemberBodyImageCopyWithImpl<$Res, _$MemberBodyImageImpl>
    implements _$$MemberBodyImageImplCopyWith<$Res> {
  __$$MemberBodyImageImplCopyWithImpl(
      _$MemberBodyImageImpl _value, $Res Function(_$MemberBodyImageImpl) _then)
      : super(_value, _then);

  /// Create a copy of MemberBodyImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileId = null,
    Object? fileUrl = null,
    Object? originalFileName = freezed,
    Object? recordDate = null,
  }) {
    return _then(_$MemberBodyImageImpl(
      fileId: null == fileId
          ? _value.fileId
          : fileId // ignore: cast_nullable_to_non_nullable
              as int,
      fileUrl: null == fileUrl
          ? _value.fileUrl
          : fileUrl // ignore: cast_nullable_to_non_nullable
              as String,
      originalFileName: freezed == originalFileName
          ? _value.originalFileName
          : originalFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberBodyImageImpl implements _MemberBodyImage {
  const _$MemberBodyImageImpl(
      {required this.fileId,
      required this.fileUrl,
      this.originalFileName,
      required this.recordDate});

  factory _$MemberBodyImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberBodyImageImplFromJson(json);

  @override
  final int fileId;
  @override
  final String fileUrl;
  @override
  final String? originalFileName;
  @override
  final String recordDate;

  @override
  String toString() {
    return 'MemberBodyImage(fileId: $fileId, fileUrl: $fileUrl, originalFileName: $originalFileName, recordDate: $recordDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberBodyImageImpl &&
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

  /// Create a copy of MemberBodyImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberBodyImageImplCopyWith<_$MemberBodyImageImpl> get copyWith =>
      __$$MemberBodyImageImplCopyWithImpl<_$MemberBodyImageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberBodyImageImplToJson(
      this,
    );
  }
}

abstract class _MemberBodyImage implements MemberBodyImage {
  const factory _MemberBodyImage(
      {required final int fileId,
      required final String fileUrl,
      final String? originalFileName,
      required final String recordDate}) = _$MemberBodyImageImpl;

  factory _MemberBodyImage.fromJson(Map<String, dynamic> json) =
      _$MemberBodyImageImpl.fromJson;

  @override
  int get fileId;
  @override
  String get fileUrl;
  @override
  String? get originalFileName;
  @override
  String get recordDate;

  /// Create a copy of MemberBodyImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberBodyImageImplCopyWith<_$MemberBodyImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MemberBodyImageResponse _$MemberBodyImageResponseFromJson(
    Map<String, dynamic> json) {
  return _MemberBodyImageResponse.fromJson(json);
}

/// @nodoc
mixin _$MemberBodyImageResponse {
  List<MemberBodyImage> get data => throw _privateConstructorUsedError;
  PageInfo get pageInfo => throw _privateConstructorUsedError;

  /// Serializes this MemberBodyImageResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberBodyImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberBodyImageResponseCopyWith<MemberBodyImageResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberBodyImageResponseCopyWith<$Res> {
  factory $MemberBodyImageResponseCopyWith(MemberBodyImageResponse value,
          $Res Function(MemberBodyImageResponse) then) =
      _$MemberBodyImageResponseCopyWithImpl<$Res, MemberBodyImageResponse>;
  @useResult
  $Res call({List<MemberBodyImage> data, PageInfo pageInfo});

  $PageInfoCopyWith<$Res> get pageInfo;
}

/// @nodoc
class _$MemberBodyImageResponseCopyWithImpl<$Res,
        $Val extends MemberBodyImageResponse>
    implements $MemberBodyImageResponseCopyWith<$Res> {
  _$MemberBodyImageResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberBodyImageResponse
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
              as List<MemberBodyImage>,
      pageInfo: null == pageInfo
          ? _value.pageInfo
          : pageInfo // ignore: cast_nullable_to_non_nullable
              as PageInfo,
    ) as $Val);
  }

  /// Create a copy of MemberBodyImageResponse
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
abstract class _$$MemberBodyImageResponseImplCopyWith<$Res>
    implements $MemberBodyImageResponseCopyWith<$Res> {
  factory _$$MemberBodyImageResponseImplCopyWith(
          _$MemberBodyImageResponseImpl value,
          $Res Function(_$MemberBodyImageResponseImpl) then) =
      __$$MemberBodyImageResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<MemberBodyImage> data, PageInfo pageInfo});

  @override
  $PageInfoCopyWith<$Res> get pageInfo;
}

/// @nodoc
class __$$MemberBodyImageResponseImplCopyWithImpl<$Res>
    extends _$MemberBodyImageResponseCopyWithImpl<$Res,
        _$MemberBodyImageResponseImpl>
    implements _$$MemberBodyImageResponseImplCopyWith<$Res> {
  __$$MemberBodyImageResponseImplCopyWithImpl(
      _$MemberBodyImageResponseImpl _value,
      $Res Function(_$MemberBodyImageResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of MemberBodyImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? pageInfo = null,
  }) {
    return _then(_$MemberBodyImageResponseImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<MemberBodyImage>,
      pageInfo: null == pageInfo
          ? _value.pageInfo
          : pageInfo // ignore: cast_nullable_to_non_nullable
              as PageInfo,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberBodyImageResponseImpl implements _MemberBodyImageResponse {
  const _$MemberBodyImageResponseImpl(
      {required final List<MemberBodyImage> data, required this.pageInfo})
      : _data = data;

  factory _$MemberBodyImageResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberBodyImageResponseImplFromJson(json);

  final List<MemberBodyImage> _data;
  @override
  List<MemberBodyImage> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final PageInfo pageInfo;

  @override
  String toString() {
    return 'MemberBodyImageResponse(data: $data, pageInfo: $pageInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberBodyImageResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.pageInfo, pageInfo) ||
                other.pageInfo == pageInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), pageInfo);

  /// Create a copy of MemberBodyImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberBodyImageResponseImplCopyWith<_$MemberBodyImageResponseImpl>
      get copyWith => __$$MemberBodyImageResponseImplCopyWithImpl<
          _$MemberBodyImageResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberBodyImageResponseImplToJson(
      this,
    );
  }
}

abstract class _MemberBodyImageResponse implements MemberBodyImageResponse {
  const factory _MemberBodyImageResponse(
      {required final List<MemberBodyImage> data,
      required final PageInfo pageInfo}) = _$MemberBodyImageResponseImpl;

  factory _MemberBodyImageResponse.fromJson(Map<String, dynamic> json) =
      _$MemberBodyImageResponseImpl.fromJson;

  @override
  List<MemberBodyImage> get data;
  @override
  PageInfo get pageInfo;

  /// Create a copy of MemberBodyImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberBodyImageResponseImplCopyWith<_$MemberBodyImageResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MemberBodyComposition _$MemberBodyCompositionFromJson(
    Map<String, dynamic> json) {
  return _MemberBodyComposition.fromJson(json);
}

/// @nodoc
mixin _$MemberBodyComposition {
  int get id => throw _privateConstructorUsedError;
  String get measurementDate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _doubleFromJson)
  double? get weightKg => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _doubleFromJson)
  double? get fatKg => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _doubleFromJson)
  double? get muscleMassKg => throw _privateConstructorUsedError;

  /// Serializes this MemberBodyComposition to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberBodyComposition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberBodyCompositionCopyWith<MemberBodyComposition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberBodyCompositionCopyWith<$Res> {
  factory $MemberBodyCompositionCopyWith(MemberBodyComposition value,
          $Res Function(MemberBodyComposition) then) =
      _$MemberBodyCompositionCopyWithImpl<$Res, MemberBodyComposition>;
  @useResult
  $Res call(
      {int id,
      String measurementDate,
      @JsonKey(fromJson: _doubleFromJson) double? weightKg,
      @JsonKey(fromJson: _doubleFromJson) double? fatKg,
      @JsonKey(fromJson: _doubleFromJson) double? muscleMassKg});
}

/// @nodoc
class _$MemberBodyCompositionCopyWithImpl<$Res,
        $Val extends MemberBodyComposition>
    implements $MemberBodyCompositionCopyWith<$Res> {
  _$MemberBodyCompositionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberBodyComposition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? measurementDate = null,
    Object? weightKg = freezed,
    Object? fatKg = freezed,
    Object? muscleMassKg = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      measurementDate: null == measurementDate
          ? _value.measurementDate
          : measurementDate // ignore: cast_nullable_to_non_nullable
              as String,
      weightKg: freezed == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double?,
      fatKg: freezed == fatKg
          ? _value.fatKg
          : fatKg // ignore: cast_nullable_to_non_nullable
              as double?,
      muscleMassKg: freezed == muscleMassKg
          ? _value.muscleMassKg
          : muscleMassKg // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemberBodyCompositionImplCopyWith<$Res>
    implements $MemberBodyCompositionCopyWith<$Res> {
  factory _$$MemberBodyCompositionImplCopyWith(
          _$MemberBodyCompositionImpl value,
          $Res Function(_$MemberBodyCompositionImpl) then) =
      __$$MemberBodyCompositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String measurementDate,
      @JsonKey(fromJson: _doubleFromJson) double? weightKg,
      @JsonKey(fromJson: _doubleFromJson) double? fatKg,
      @JsonKey(fromJson: _doubleFromJson) double? muscleMassKg});
}

/// @nodoc
class __$$MemberBodyCompositionImplCopyWithImpl<$Res>
    extends _$MemberBodyCompositionCopyWithImpl<$Res,
        _$MemberBodyCompositionImpl>
    implements _$$MemberBodyCompositionImplCopyWith<$Res> {
  __$$MemberBodyCompositionImplCopyWithImpl(_$MemberBodyCompositionImpl _value,
      $Res Function(_$MemberBodyCompositionImpl) _then)
      : super(_value, _then);

  /// Create a copy of MemberBodyComposition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? measurementDate = null,
    Object? weightKg = freezed,
    Object? fatKg = freezed,
    Object? muscleMassKg = freezed,
  }) {
    return _then(_$MemberBodyCompositionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      measurementDate: null == measurementDate
          ? _value.measurementDate
          : measurementDate // ignore: cast_nullable_to_non_nullable
              as String,
      weightKg: freezed == weightKg
          ? _value.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double?,
      fatKg: freezed == fatKg
          ? _value.fatKg
          : fatKg // ignore: cast_nullable_to_non_nullable
              as double?,
      muscleMassKg: freezed == muscleMassKg
          ? _value.muscleMassKg
          : muscleMassKg // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberBodyCompositionImpl implements _MemberBodyComposition {
  const _$MemberBodyCompositionImpl(
      {required this.id,
      required this.measurementDate,
      @JsonKey(fromJson: _doubleFromJson) this.weightKg,
      @JsonKey(fromJson: _doubleFromJson) this.fatKg,
      @JsonKey(fromJson: _doubleFromJson) this.muscleMassKg});

  factory _$MemberBodyCompositionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberBodyCompositionImplFromJson(json);

  @override
  final int id;
  @override
  final String measurementDate;
  @override
  @JsonKey(fromJson: _doubleFromJson)
  final double? weightKg;
  @override
  @JsonKey(fromJson: _doubleFromJson)
  final double? fatKg;
  @override
  @JsonKey(fromJson: _doubleFromJson)
  final double? muscleMassKg;

  @override
  String toString() {
    return 'MemberBodyComposition(id: $id, measurementDate: $measurementDate, weightKg: $weightKg, fatKg: $fatKg, muscleMassKg: $muscleMassKg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberBodyCompositionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.measurementDate, measurementDate) ||
                other.measurementDate == measurementDate) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.fatKg, fatKg) || other.fatKg == fatKg) &&
            (identical(other.muscleMassKg, muscleMassKg) ||
                other.muscleMassKg == muscleMassKg));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, measurementDate, weightKg, fatKg, muscleMassKg);

  /// Create a copy of MemberBodyComposition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberBodyCompositionImplCopyWith<_$MemberBodyCompositionImpl>
      get copyWith => __$$MemberBodyCompositionImplCopyWithImpl<
          _$MemberBodyCompositionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberBodyCompositionImplToJson(
      this,
    );
  }
}

abstract class _MemberBodyComposition implements MemberBodyComposition {
  const factory _MemberBodyComposition(
          {required final int id,
          required final String measurementDate,
          @JsonKey(fromJson: _doubleFromJson) final double? weightKg,
          @JsonKey(fromJson: _doubleFromJson) final double? fatKg,
          @JsonKey(fromJson: _doubleFromJson) final double? muscleMassKg}) =
      _$MemberBodyCompositionImpl;

  factory _MemberBodyComposition.fromJson(Map<String, dynamic> json) =
      _$MemberBodyCompositionImpl.fromJson;

  @override
  int get id;
  @override
  String get measurementDate;
  @override
  @JsonKey(fromJson: _doubleFromJson)
  double? get weightKg;
  @override
  @JsonKey(fromJson: _doubleFromJson)
  double? get fatKg;
  @override
  @JsonKey(fromJson: _doubleFromJson)
  double? get muscleMassKg;

  /// Create a copy of MemberBodyComposition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberBodyCompositionImplCopyWith<_$MemberBodyCompositionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MemberBodyCompositionResponse _$MemberBodyCompositionResponseFromJson(
    Map<String, dynamic> json) {
  return _MemberBodyCompositionResponse.fromJson(json);
}

/// @nodoc
mixin _$MemberBodyCompositionResponse {
  List<MemberBodyComposition> get data => throw _privateConstructorUsedError;
  PageInfo get pageInfo => throw _privateConstructorUsedError;

  /// Serializes this MemberBodyCompositionResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberBodyCompositionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberBodyCompositionResponseCopyWith<MemberBodyCompositionResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberBodyCompositionResponseCopyWith<$Res> {
  factory $MemberBodyCompositionResponseCopyWith(
          MemberBodyCompositionResponse value,
          $Res Function(MemberBodyCompositionResponse) then) =
      _$MemberBodyCompositionResponseCopyWithImpl<$Res,
          MemberBodyCompositionResponse>;
  @useResult
  $Res call({List<MemberBodyComposition> data, PageInfo pageInfo});

  $PageInfoCopyWith<$Res> get pageInfo;
}

/// @nodoc
class _$MemberBodyCompositionResponseCopyWithImpl<$Res,
        $Val extends MemberBodyCompositionResponse>
    implements $MemberBodyCompositionResponseCopyWith<$Res> {
  _$MemberBodyCompositionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberBodyCompositionResponse
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
              as List<MemberBodyComposition>,
      pageInfo: null == pageInfo
          ? _value.pageInfo
          : pageInfo // ignore: cast_nullable_to_non_nullable
              as PageInfo,
    ) as $Val);
  }

  /// Create a copy of MemberBodyCompositionResponse
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
abstract class _$$MemberBodyCompositionResponseImplCopyWith<$Res>
    implements $MemberBodyCompositionResponseCopyWith<$Res> {
  factory _$$MemberBodyCompositionResponseImplCopyWith(
          _$MemberBodyCompositionResponseImpl value,
          $Res Function(_$MemberBodyCompositionResponseImpl) then) =
      __$$MemberBodyCompositionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<MemberBodyComposition> data, PageInfo pageInfo});

  @override
  $PageInfoCopyWith<$Res> get pageInfo;
}

/// @nodoc
class __$$MemberBodyCompositionResponseImplCopyWithImpl<$Res>
    extends _$MemberBodyCompositionResponseCopyWithImpl<$Res,
        _$MemberBodyCompositionResponseImpl>
    implements _$$MemberBodyCompositionResponseImplCopyWith<$Res> {
  __$$MemberBodyCompositionResponseImplCopyWithImpl(
      _$MemberBodyCompositionResponseImpl _value,
      $Res Function(_$MemberBodyCompositionResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of MemberBodyCompositionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? pageInfo = null,
  }) {
    return _then(_$MemberBodyCompositionResponseImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<MemberBodyComposition>,
      pageInfo: null == pageInfo
          ? _value.pageInfo
          : pageInfo // ignore: cast_nullable_to_non_nullable
              as PageInfo,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberBodyCompositionResponseImpl
    implements _MemberBodyCompositionResponse {
  const _$MemberBodyCompositionResponseImpl(
      {required final List<MemberBodyComposition> data, required this.pageInfo})
      : _data = data;

  factory _$MemberBodyCompositionResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$MemberBodyCompositionResponseImplFromJson(json);

  final List<MemberBodyComposition> _data;
  @override
  List<MemberBodyComposition> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final PageInfo pageInfo;

  @override
  String toString() {
    return 'MemberBodyCompositionResponse(data: $data, pageInfo: $pageInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberBodyCompositionResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.pageInfo, pageInfo) ||
                other.pageInfo == pageInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), pageInfo);

  /// Create a copy of MemberBodyCompositionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberBodyCompositionResponseImplCopyWith<
          _$MemberBodyCompositionResponseImpl>
      get copyWith => __$$MemberBodyCompositionResponseImplCopyWithImpl<
          _$MemberBodyCompositionResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberBodyCompositionResponseImplToJson(
      this,
    );
  }
}

abstract class _MemberBodyCompositionResponse
    implements MemberBodyCompositionResponse {
  const factory _MemberBodyCompositionResponse(
      {required final List<MemberBodyComposition> data,
      required final PageInfo pageInfo}) = _$MemberBodyCompositionResponseImpl;

  factory _MemberBodyCompositionResponse.fromJson(Map<String, dynamic> json) =
      _$MemberBodyCompositionResponseImpl.fromJson;

  @override
  List<MemberBodyComposition> get data;
  @override
  PageInfo get pageInfo;

  /// Create a copy of MemberBodyCompositionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberBodyCompositionResponseImplCopyWith<
          _$MemberBodyCompositionResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
