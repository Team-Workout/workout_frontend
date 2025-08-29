// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pt_offering_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PtOffering _$PtOfferingFromJson(Map<String, dynamic> json) {
  return _PtOffering.fromJson(json);
}

/// @nodoc
mixin _$PtOffering {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;
  int get totalSessions => throw _privateConstructorUsedError;
  int? get trainerId =>
      throw _privateConstructorUsedError; // API 응답에 없을 수 있으므로 nullable로 변경
  int get gymId => throw _privateConstructorUsedError;
  String? get trainerName =>
      throw _privateConstructorUsedError; // API 응답에 포함된 필드 추가
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this PtOffering to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PtOffering
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PtOfferingCopyWith<PtOffering> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PtOfferingCopyWith<$Res> {
  factory $PtOfferingCopyWith(
          PtOffering value, $Res Function(PtOffering) then) =
      _$PtOfferingCopyWithImpl<$Res, PtOffering>;
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      int price,
      int totalSessions,
      int? trainerId,
      int gymId,
      String? trainerName,
      String? status});
}

/// @nodoc
class _$PtOfferingCopyWithImpl<$Res, $Val extends PtOffering>
    implements $PtOfferingCopyWith<$Res> {
  _$PtOfferingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PtOffering
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? totalSessions = null,
    Object? trainerId = freezed,
    Object? gymId = null,
    Object? trainerName = freezed,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
      trainerId: freezed == trainerId
          ? _value.trainerId
          : trainerId // ignore: cast_nullable_to_non_nullable
              as int?,
      gymId: null == gymId
          ? _value.gymId
          : gymId // ignore: cast_nullable_to_non_nullable
              as int,
      trainerName: freezed == trainerName
          ? _value.trainerName
          : trainerName // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PtOfferingImplCopyWith<$Res>
    implements $PtOfferingCopyWith<$Res> {
  factory _$$PtOfferingImplCopyWith(
          _$PtOfferingImpl value, $Res Function(_$PtOfferingImpl) then) =
      __$$PtOfferingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String description,
      int price,
      int totalSessions,
      int? trainerId,
      int gymId,
      String? trainerName,
      String? status});
}

/// @nodoc
class __$$PtOfferingImplCopyWithImpl<$Res>
    extends _$PtOfferingCopyWithImpl<$Res, _$PtOfferingImpl>
    implements _$$PtOfferingImplCopyWith<$Res> {
  __$$PtOfferingImplCopyWithImpl(
      _$PtOfferingImpl _value, $Res Function(_$PtOfferingImpl) _then)
      : super(_value, _then);

  /// Create a copy of PtOffering
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? totalSessions = null,
    Object? trainerId = freezed,
    Object? gymId = null,
    Object? trainerName = freezed,
    Object? status = freezed,
  }) {
    return _then(_$PtOfferingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
      trainerId: freezed == trainerId
          ? _value.trainerId
          : trainerId // ignore: cast_nullable_to_non_nullable
              as int?,
      gymId: null == gymId
          ? _value.gymId
          : gymId // ignore: cast_nullable_to_non_nullable
              as int,
      trainerName: freezed == trainerName
          ? _value.trainerName
          : trainerName // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PtOfferingImpl implements _PtOffering {
  const _$PtOfferingImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.totalSessions,
      this.trainerId,
      required this.gymId,
      this.trainerName,
      this.status});

  factory _$PtOfferingImpl.fromJson(Map<String, dynamic> json) =>
      _$$PtOfferingImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  final int price;
  @override
  final int totalSessions;
  @override
  final int? trainerId;
// API 응답에 없을 수 있으므로 nullable로 변경
  @override
  final int gymId;
  @override
  final String? trainerName;
// API 응답에 포함된 필드 추가
  @override
  final String? status;

  @override
  String toString() {
    return 'PtOffering(id: $id, title: $title, description: $description, price: $price, totalSessions: $totalSessions, trainerId: $trainerId, gymId: $gymId, trainerName: $trainerName, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PtOfferingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions) &&
            (identical(other.trainerId, trainerId) ||
                other.trainerId == trainerId) &&
            (identical(other.gymId, gymId) || other.gymId == gymId) &&
            (identical(other.trainerName, trainerName) ||
                other.trainerName == trainerName) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, price,
      totalSessions, trainerId, gymId, trainerName, status);

  /// Create a copy of PtOffering
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PtOfferingImplCopyWith<_$PtOfferingImpl> get copyWith =>
      __$$PtOfferingImplCopyWithImpl<_$PtOfferingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PtOfferingImplToJson(
      this,
    );
  }
}

abstract class _PtOffering implements PtOffering {
  const factory _PtOffering(
      {required final int id,
      required final String title,
      required final String description,
      required final int price,
      required final int totalSessions,
      final int? trainerId,
      required final int gymId,
      final String? trainerName,
      final String? status}) = _$PtOfferingImpl;

  factory _PtOffering.fromJson(Map<String, dynamic> json) =
      _$PtOfferingImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get description;
  @override
  int get price;
  @override
  int get totalSessions;
  @override
  int? get trainerId; // API 응답에 없을 수 있으므로 nullable로 변경
  @override
  int get gymId;
  @override
  String? get trainerName; // API 응답에 포함된 필드 추가
  @override
  String? get status;

  /// Create a copy of PtOffering
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PtOfferingImplCopyWith<_$PtOfferingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatePtOfferingRequest _$CreatePtOfferingRequestFromJson(
    Map<String, dynamic> json) {
  return _CreatePtOfferingRequest.fromJson(json);
}

/// @nodoc
mixin _$CreatePtOfferingRequest {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;
  int get totalSessions => throw _privateConstructorUsedError;
  int get trainerId => throw _privateConstructorUsedError;

  /// Serializes this CreatePtOfferingRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatePtOfferingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatePtOfferingRequestCopyWith<CreatePtOfferingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePtOfferingRequestCopyWith<$Res> {
  factory $CreatePtOfferingRequestCopyWith(CreatePtOfferingRequest value,
          $Res Function(CreatePtOfferingRequest) then) =
      _$CreatePtOfferingRequestCopyWithImpl<$Res, CreatePtOfferingRequest>;
  @useResult
  $Res call(
      {String title,
      String description,
      int price,
      int totalSessions,
      int trainerId});
}

/// @nodoc
class _$CreatePtOfferingRequestCopyWithImpl<$Res,
        $Val extends CreatePtOfferingRequest>
    implements $CreatePtOfferingRequestCopyWith<$Res> {
  _$CreatePtOfferingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatePtOfferingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? totalSessions = null,
    Object? trainerId = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
      trainerId: null == trainerId
          ? _value.trainerId
          : trainerId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatePtOfferingRequestImplCopyWith<$Res>
    implements $CreatePtOfferingRequestCopyWith<$Res> {
  factory _$$CreatePtOfferingRequestImplCopyWith(
          _$CreatePtOfferingRequestImpl value,
          $Res Function(_$CreatePtOfferingRequestImpl) then) =
      __$$CreatePtOfferingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String description,
      int price,
      int totalSessions,
      int trainerId});
}

/// @nodoc
class __$$CreatePtOfferingRequestImplCopyWithImpl<$Res>
    extends _$CreatePtOfferingRequestCopyWithImpl<$Res,
        _$CreatePtOfferingRequestImpl>
    implements _$$CreatePtOfferingRequestImplCopyWith<$Res> {
  __$$CreatePtOfferingRequestImplCopyWithImpl(
      _$CreatePtOfferingRequestImpl _value,
      $Res Function(_$CreatePtOfferingRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreatePtOfferingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? totalSessions = null,
    Object? trainerId = null,
  }) {
    return _then(_$CreatePtOfferingRequestImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
      trainerId: null == trainerId
          ? _value.trainerId
          : trainerId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePtOfferingRequestImpl implements _CreatePtOfferingRequest {
  const _$CreatePtOfferingRequestImpl(
      {required this.title,
      required this.description,
      required this.price,
      required this.totalSessions,
      required this.trainerId});

  factory _$CreatePtOfferingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePtOfferingRequestImplFromJson(json);

  @override
  final String title;
  @override
  final String description;
  @override
  final int price;
  @override
  final int totalSessions;
  @override
  final int trainerId;

  @override
  String toString() {
    return 'CreatePtOfferingRequest(title: $title, description: $description, price: $price, totalSessions: $totalSessions, trainerId: $trainerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePtOfferingRequestImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions) &&
            (identical(other.trainerId, trainerId) ||
                other.trainerId == trainerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, title, description, price, totalSessions, trainerId);

  /// Create a copy of CreatePtOfferingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePtOfferingRequestImplCopyWith<_$CreatePtOfferingRequestImpl>
      get copyWith => __$$CreatePtOfferingRequestImplCopyWithImpl<
          _$CreatePtOfferingRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePtOfferingRequestImplToJson(
      this,
    );
  }
}

abstract class _CreatePtOfferingRequest implements CreatePtOfferingRequest {
  const factory _CreatePtOfferingRequest(
      {required final String title,
      required final String description,
      required final int price,
      required final int totalSessions,
      required final int trainerId}) = _$CreatePtOfferingRequestImpl;

  factory _CreatePtOfferingRequest.fromJson(Map<String, dynamic> json) =
      _$CreatePtOfferingRequestImpl.fromJson;

  @override
  String get title;
  @override
  String get description;
  @override
  int get price;
  @override
  int get totalSessions;
  @override
  int get trainerId;

  /// Create a copy of CreatePtOfferingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePtOfferingRequestImplCopyWith<_$CreatePtOfferingRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PtOfferingsResponse _$PtOfferingsResponseFromJson(Map<String, dynamic> json) {
  return _PtOfferingsResponse.fromJson(json);
}

/// @nodoc
mixin _$PtOfferingsResponse {
  List<PtOffering> get ptOfferings => throw _privateConstructorUsedError;

  /// Serializes this PtOfferingsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PtOfferingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PtOfferingsResponseCopyWith<PtOfferingsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PtOfferingsResponseCopyWith<$Res> {
  factory $PtOfferingsResponseCopyWith(
          PtOfferingsResponse value, $Res Function(PtOfferingsResponse) then) =
      _$PtOfferingsResponseCopyWithImpl<$Res, PtOfferingsResponse>;
  @useResult
  $Res call({List<PtOffering> ptOfferings});
}

/// @nodoc
class _$PtOfferingsResponseCopyWithImpl<$Res, $Val extends PtOfferingsResponse>
    implements $PtOfferingsResponseCopyWith<$Res> {
  _$PtOfferingsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PtOfferingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ptOfferings = null,
  }) {
    return _then(_value.copyWith(
      ptOfferings: null == ptOfferings
          ? _value.ptOfferings
          : ptOfferings // ignore: cast_nullable_to_non_nullable
              as List<PtOffering>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PtOfferingsResponseImplCopyWith<$Res>
    implements $PtOfferingsResponseCopyWith<$Res> {
  factory _$$PtOfferingsResponseImplCopyWith(_$PtOfferingsResponseImpl value,
          $Res Function(_$PtOfferingsResponseImpl) then) =
      __$$PtOfferingsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<PtOffering> ptOfferings});
}

/// @nodoc
class __$$PtOfferingsResponseImplCopyWithImpl<$Res>
    extends _$PtOfferingsResponseCopyWithImpl<$Res, _$PtOfferingsResponseImpl>
    implements _$$PtOfferingsResponseImplCopyWith<$Res> {
  __$$PtOfferingsResponseImplCopyWithImpl(_$PtOfferingsResponseImpl _value,
      $Res Function(_$PtOfferingsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PtOfferingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ptOfferings = null,
  }) {
    return _then(_$PtOfferingsResponseImpl(
      ptOfferings: null == ptOfferings
          ? _value._ptOfferings
          : ptOfferings // ignore: cast_nullable_to_non_nullable
              as List<PtOffering>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PtOfferingsResponseImpl implements _PtOfferingsResponse {
  const _$PtOfferingsResponseImpl({required final List<PtOffering> ptOfferings})
      : _ptOfferings = ptOfferings;

  factory _$PtOfferingsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PtOfferingsResponseImplFromJson(json);

  final List<PtOffering> _ptOfferings;
  @override
  List<PtOffering> get ptOfferings {
    if (_ptOfferings is EqualUnmodifiableListView) return _ptOfferings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ptOfferings);
  }

  @override
  String toString() {
    return 'PtOfferingsResponse(ptOfferings: $ptOfferings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PtOfferingsResponseImpl &&
            const DeepCollectionEquality()
                .equals(other._ptOfferings, _ptOfferings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_ptOfferings));

  /// Create a copy of PtOfferingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PtOfferingsResponseImplCopyWith<_$PtOfferingsResponseImpl> get copyWith =>
      __$$PtOfferingsResponseImplCopyWithImpl<_$PtOfferingsResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PtOfferingsResponseImplToJson(
      this,
    );
  }
}

abstract class _PtOfferingsResponse implements PtOfferingsResponse {
  const factory _PtOfferingsResponse(
          {required final List<PtOffering> ptOfferings}) =
      _$PtOfferingsResponseImpl;

  factory _PtOfferingsResponse.fromJson(Map<String, dynamic> json) =
      _$PtOfferingsResponseImpl.fromJson;

  @override
  List<PtOffering> get ptOfferings;

  /// Create a copy of PtOfferingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PtOfferingsResponseImplCopyWith<_$PtOfferingsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
