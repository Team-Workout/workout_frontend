// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pt_contract_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PtContractResponse _$PtContractResponseFromJson(Map<String, dynamic> json) {
  return _PtContractResponse.fromJson(json);
}

/// @nodoc
mixin _$PtContractResponse {
  List<PtContract> get data => throw _privateConstructorUsedError;
  PageInfo get pageInfo => throw _privateConstructorUsedError;

  /// Serializes this PtContractResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PtContractResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PtContractResponseCopyWith<PtContractResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PtContractResponseCopyWith<$Res> {
  factory $PtContractResponseCopyWith(
          PtContractResponse value, $Res Function(PtContractResponse) then) =
      _$PtContractResponseCopyWithImpl<$Res, PtContractResponse>;
  @useResult
  $Res call({List<PtContract> data, PageInfo pageInfo});

  $PageInfoCopyWith<$Res> get pageInfo;
}

/// @nodoc
class _$PtContractResponseCopyWithImpl<$Res, $Val extends PtContractResponse>
    implements $PtContractResponseCopyWith<$Res> {
  _$PtContractResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PtContractResponse
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
              as List<PtContract>,
      pageInfo: null == pageInfo
          ? _value.pageInfo
          : pageInfo // ignore: cast_nullable_to_non_nullable
              as PageInfo,
    ) as $Val);
  }

  /// Create a copy of PtContractResponse
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
abstract class _$$PtContractResponseImplCopyWith<$Res>
    implements $PtContractResponseCopyWith<$Res> {
  factory _$$PtContractResponseImplCopyWith(_$PtContractResponseImpl value,
          $Res Function(_$PtContractResponseImpl) then) =
      __$$PtContractResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<PtContract> data, PageInfo pageInfo});

  @override
  $PageInfoCopyWith<$Res> get pageInfo;
}

/// @nodoc
class __$$PtContractResponseImplCopyWithImpl<$Res>
    extends _$PtContractResponseCopyWithImpl<$Res, _$PtContractResponseImpl>
    implements _$$PtContractResponseImplCopyWith<$Res> {
  __$$PtContractResponseImplCopyWithImpl(_$PtContractResponseImpl _value,
      $Res Function(_$PtContractResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PtContractResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? pageInfo = null,
  }) {
    return _then(_$PtContractResponseImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<PtContract>,
      pageInfo: null == pageInfo
          ? _value.pageInfo
          : pageInfo // ignore: cast_nullable_to_non_nullable
              as PageInfo,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PtContractResponseImpl implements _PtContractResponse {
  const _$PtContractResponseImpl(
      {required final List<PtContract> data, required this.pageInfo})
      : _data = data;

  factory _$PtContractResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PtContractResponseImplFromJson(json);

  final List<PtContract> _data;
  @override
  List<PtContract> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final PageInfo pageInfo;

  @override
  String toString() {
    return 'PtContractResponse(data: $data, pageInfo: $pageInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PtContractResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.pageInfo, pageInfo) ||
                other.pageInfo == pageInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), pageInfo);

  /// Create a copy of PtContractResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PtContractResponseImplCopyWith<_$PtContractResponseImpl> get copyWith =>
      __$$PtContractResponseImplCopyWithImpl<_$PtContractResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PtContractResponseImplToJson(
      this,
    );
  }
}

abstract class _PtContractResponse implements PtContractResponse {
  const factory _PtContractResponse(
      {required final List<PtContract> data,
      required final PageInfo pageInfo}) = _$PtContractResponseImpl;

  factory _PtContractResponse.fromJson(Map<String, dynamic> json) =
      _$PtContractResponseImpl.fromJson;

  @override
  List<PtContract> get data;
  @override
  PageInfo get pageInfo;

  /// Create a copy of PtContractResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PtContractResponseImplCopyWith<_$PtContractResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PtContract _$PtContractFromJson(Map<String, dynamic> json) {
  return _PtContract.fromJson(json);
}

/// @nodoc
mixin _$PtContract {
  int get contractId => throw _privateConstructorUsedError;
  int get memberId => throw _privateConstructorUsedError;
  int get trainerId => throw _privateConstructorUsedError;
  String get trainerName => throw _privateConstructorUsedError;
  String get memberName => throw _privateConstructorUsedError;
  int get totalSessions => throw _privateConstructorUsedError;
  int get remainingSessions => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get startDate => throw _privateConstructorUsedError;
  int? get price => throw _privateConstructorUsedError;

  /// Serializes this PtContract to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PtContract
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PtContractCopyWith<PtContract> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PtContractCopyWith<$Res> {
  factory $PtContractCopyWith(
          PtContract value, $Res Function(PtContract) then) =
      _$PtContractCopyWithImpl<$Res, PtContract>;
  @useResult
  $Res call(
      {int contractId,
      int memberId,
      int trainerId,
      String trainerName,
      String memberName,
      int totalSessions,
      int remainingSessions,
      String status,
      String? startDate,
      int? price});
}

/// @nodoc
class _$PtContractCopyWithImpl<$Res, $Val extends PtContract>
    implements $PtContractCopyWith<$Res> {
  _$PtContractCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PtContract
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? memberId = null,
    Object? trainerId = null,
    Object? trainerName = null,
    Object? memberName = null,
    Object? totalSessions = null,
    Object? remainingSessions = null,
    Object? status = null,
    Object? startDate = freezed,
    Object? price = freezed,
  }) {
    return _then(_value.copyWith(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as int,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      trainerId: null == trainerId
          ? _value.trainerId
          : trainerId // ignore: cast_nullable_to_non_nullable
              as int,
      trainerName: null == trainerName
          ? _value.trainerName
          : trainerName // ignore: cast_nullable_to_non_nullable
              as String,
      memberName: null == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
      remainingSessions: null == remainingSessions
          ? _value.remainingSessions
          : remainingSessions // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PtContractImplCopyWith<$Res>
    implements $PtContractCopyWith<$Res> {
  factory _$$PtContractImplCopyWith(
          _$PtContractImpl value, $Res Function(_$PtContractImpl) then) =
      __$$PtContractImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int contractId,
      int memberId,
      int trainerId,
      String trainerName,
      String memberName,
      int totalSessions,
      int remainingSessions,
      String status,
      String? startDate,
      int? price});
}

/// @nodoc
class __$$PtContractImplCopyWithImpl<$Res>
    extends _$PtContractCopyWithImpl<$Res, _$PtContractImpl>
    implements _$$PtContractImplCopyWith<$Res> {
  __$$PtContractImplCopyWithImpl(
      _$PtContractImpl _value, $Res Function(_$PtContractImpl) _then)
      : super(_value, _then);

  /// Create a copy of PtContract
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? memberId = null,
    Object? trainerId = null,
    Object? trainerName = null,
    Object? memberName = null,
    Object? totalSessions = null,
    Object? remainingSessions = null,
    Object? status = null,
    Object? startDate = freezed,
    Object? price = freezed,
  }) {
    return _then(_$PtContractImpl(
      contractId: null == contractId
          ? _value.contractId
          : contractId // ignore: cast_nullable_to_non_nullable
              as int,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      trainerId: null == trainerId
          ? _value.trainerId
          : trainerId // ignore: cast_nullable_to_non_nullable
              as int,
      trainerName: null == trainerName
          ? _value.trainerName
          : trainerName // ignore: cast_nullable_to_non_nullable
              as String,
      memberName: null == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      totalSessions: null == totalSessions
          ? _value.totalSessions
          : totalSessions // ignore: cast_nullable_to_non_nullable
              as int,
      remainingSessions: null == remainingSessions
          ? _value.remainingSessions
          : remainingSessions // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PtContractImpl implements _PtContract {
  const _$PtContractImpl(
      {required this.contractId,
      required this.memberId,
      required this.trainerId,
      required this.trainerName,
      required this.memberName,
      required this.totalSessions,
      required this.remainingSessions,
      required this.status,
      this.startDate,
      this.price});

  factory _$PtContractImpl.fromJson(Map<String, dynamic> json) =>
      _$$PtContractImplFromJson(json);

  @override
  final int contractId;
  @override
  final int memberId;
  @override
  final int trainerId;
  @override
  final String trainerName;
  @override
  final String memberName;
  @override
  final int totalSessions;
  @override
  final int remainingSessions;
  @override
  final String status;
  @override
  final String? startDate;
  @override
  final int? price;

  @override
  String toString() {
    return 'PtContract(contractId: $contractId, memberId: $memberId, trainerId: $trainerId, trainerName: $trainerName, memberName: $memberName, totalSessions: $totalSessions, remainingSessions: $remainingSessions, status: $status, startDate: $startDate, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PtContractImpl &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.trainerId, trainerId) ||
                other.trainerId == trainerId) &&
            (identical(other.trainerName, trainerName) ||
                other.trainerName == trainerName) &&
            (identical(other.memberName, memberName) ||
                other.memberName == memberName) &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions) &&
            (identical(other.remainingSessions, remainingSessions) ||
                other.remainingSessions == remainingSessions) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      contractId,
      memberId,
      trainerId,
      trainerName,
      memberName,
      totalSessions,
      remainingSessions,
      status,
      startDate,
      price);

  /// Create a copy of PtContract
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PtContractImplCopyWith<_$PtContractImpl> get copyWith =>
      __$$PtContractImplCopyWithImpl<_$PtContractImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PtContractImplToJson(
      this,
    );
  }
}

abstract class _PtContract implements PtContract {
  const factory _PtContract(
      {required final int contractId,
      required final int memberId,
      required final int trainerId,
      required final String trainerName,
      required final String memberName,
      required final int totalSessions,
      required final int remainingSessions,
      required final String status,
      final String? startDate,
      final int? price}) = _$PtContractImpl;

  factory _PtContract.fromJson(Map<String, dynamic> json) =
      _$PtContractImpl.fromJson;

  @override
  int get contractId;
  @override
  int get memberId;
  @override
  int get trainerId;
  @override
  String get trainerName;
  @override
  String get memberName;
  @override
  int get totalSessions;
  @override
  int get remainingSessions;
  @override
  String get status;
  @override
  String? get startDate;
  @override
  int? get price;

  /// Create a copy of PtContract
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PtContractImplCopyWith<_$PtContractImpl> get copyWith =>
      throw _privateConstructorUsedError;
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

PtAppointmentProposal _$PtAppointmentProposalFromJson(
    Map<String, dynamic> json) {
  return _PtAppointmentProposal.fromJson(json);
}

/// @nodoc
mixin _$PtAppointmentProposal {
  int get contractId => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;

  /// Serializes this PtAppointmentProposal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PtAppointmentProposal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PtAppointmentProposalCopyWith<PtAppointmentProposal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PtAppointmentProposalCopyWith<$Res> {
  factory $PtAppointmentProposalCopyWith(PtAppointmentProposal value,
          $Res Function(PtAppointmentProposal) then) =
      _$PtAppointmentProposalCopyWithImpl<$Res, PtAppointmentProposal>;
  @useResult
  $Res call({int contractId, String startTime, String endTime});
}

/// @nodoc
class _$PtAppointmentProposalCopyWithImpl<$Res,
        $Val extends PtAppointmentProposal>
    implements $PtAppointmentProposalCopyWith<$Res> {
  _$PtAppointmentProposalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PtAppointmentProposal
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
abstract class _$$PtAppointmentProposalImplCopyWith<$Res>
    implements $PtAppointmentProposalCopyWith<$Res> {
  factory _$$PtAppointmentProposalImplCopyWith(
          _$PtAppointmentProposalImpl value,
          $Res Function(_$PtAppointmentProposalImpl) then) =
      __$$PtAppointmentProposalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int contractId, String startTime, String endTime});
}

/// @nodoc
class __$$PtAppointmentProposalImplCopyWithImpl<$Res>
    extends _$PtAppointmentProposalCopyWithImpl<$Res,
        _$PtAppointmentProposalImpl>
    implements _$$PtAppointmentProposalImplCopyWith<$Res> {
  __$$PtAppointmentProposalImplCopyWithImpl(_$PtAppointmentProposalImpl _value,
      $Res Function(_$PtAppointmentProposalImpl) _then)
      : super(_value, _then);

  /// Create a copy of PtAppointmentProposal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(_$PtAppointmentProposalImpl(
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
class _$PtAppointmentProposalImpl implements _PtAppointmentProposal {
  const _$PtAppointmentProposalImpl(
      {required this.contractId,
      required this.startTime,
      required this.endTime});

  factory _$PtAppointmentProposalImpl.fromJson(Map<String, dynamic> json) =>
      _$$PtAppointmentProposalImplFromJson(json);

  @override
  final int contractId;
  @override
  final String startTime;
  @override
  final String endTime;

  @override
  String toString() {
    return 'PtAppointmentProposal(contractId: $contractId, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PtAppointmentProposalImpl &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, contractId, startTime, endTime);

  /// Create a copy of PtAppointmentProposal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PtAppointmentProposalImplCopyWith<_$PtAppointmentProposalImpl>
      get copyWith => __$$PtAppointmentProposalImplCopyWithImpl<
          _$PtAppointmentProposalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PtAppointmentProposalImplToJson(
      this,
    );
  }
}

abstract class _PtAppointmentProposal implements PtAppointmentProposal {
  const factory _PtAppointmentProposal(
      {required final int contractId,
      required final String startTime,
      required final String endTime}) = _$PtAppointmentProposalImpl;

  factory _PtAppointmentProposal.fromJson(Map<String, dynamic> json) =
      _$PtAppointmentProposalImpl.fromJson;

  @override
  int get contractId;
  @override
  String get startTime;
  @override
  String get endTime;

  /// Create a copy of PtAppointmentProposal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PtAppointmentProposalImplCopyWith<_$PtAppointmentProposalImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PtAppointmentSchedule _$PtAppointmentScheduleFromJson(
    Map<String, dynamic> json) {
  return _PtAppointmentSchedule.fromJson(json);
}

/// @nodoc
mixin _$PtAppointmentSchedule {
  int get contractId => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;

  /// Serializes this PtAppointmentSchedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PtAppointmentSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PtAppointmentScheduleCopyWith<PtAppointmentSchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PtAppointmentScheduleCopyWith<$Res> {
  factory $PtAppointmentScheduleCopyWith(PtAppointmentSchedule value,
          $Res Function(PtAppointmentSchedule) then) =
      _$PtAppointmentScheduleCopyWithImpl<$Res, PtAppointmentSchedule>;
  @useResult
  $Res call({int contractId, String startTime, String endTime});
}

/// @nodoc
class _$PtAppointmentScheduleCopyWithImpl<$Res,
        $Val extends PtAppointmentSchedule>
    implements $PtAppointmentScheduleCopyWith<$Res> {
  _$PtAppointmentScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PtAppointmentSchedule
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
abstract class _$$PtAppointmentScheduleImplCopyWith<$Res>
    implements $PtAppointmentScheduleCopyWith<$Res> {
  factory _$$PtAppointmentScheduleImplCopyWith(
          _$PtAppointmentScheduleImpl value,
          $Res Function(_$PtAppointmentScheduleImpl) then) =
      __$$PtAppointmentScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int contractId, String startTime, String endTime});
}

/// @nodoc
class __$$PtAppointmentScheduleImplCopyWithImpl<$Res>
    extends _$PtAppointmentScheduleCopyWithImpl<$Res,
        _$PtAppointmentScheduleImpl>
    implements _$$PtAppointmentScheduleImplCopyWith<$Res> {
  __$$PtAppointmentScheduleImplCopyWithImpl(_$PtAppointmentScheduleImpl _value,
      $Res Function(_$PtAppointmentScheduleImpl) _then)
      : super(_value, _then);

  /// Create a copy of PtAppointmentSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contractId = null,
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(_$PtAppointmentScheduleImpl(
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
class _$PtAppointmentScheduleImpl implements _PtAppointmentSchedule {
  const _$PtAppointmentScheduleImpl(
      {required this.contractId,
      required this.startTime,
      required this.endTime});

  factory _$PtAppointmentScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$PtAppointmentScheduleImplFromJson(json);

  @override
  final int contractId;
  @override
  final String startTime;
  @override
  final String endTime;

  @override
  String toString() {
    return 'PtAppointmentSchedule(contractId: $contractId, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PtAppointmentScheduleImpl &&
            (identical(other.contractId, contractId) ||
                other.contractId == contractId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, contractId, startTime, endTime);

  /// Create a copy of PtAppointmentSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PtAppointmentScheduleImplCopyWith<_$PtAppointmentScheduleImpl>
      get copyWith => __$$PtAppointmentScheduleImplCopyWithImpl<
          _$PtAppointmentScheduleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PtAppointmentScheduleImplToJson(
      this,
    );
  }
}

abstract class _PtAppointmentSchedule implements PtAppointmentSchedule {
  const factory _PtAppointmentSchedule(
      {required final int contractId,
      required final String startTime,
      required final String endTime}) = _$PtAppointmentScheduleImpl;

  factory _PtAppointmentSchedule.fromJson(Map<String, dynamic> json) =
      _$PtAppointmentScheduleImpl.fromJson;

  @override
  int get contractId;
  @override
  String get startTime;
  @override
  String get endTime;

  /// Create a copy of PtAppointmentSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PtAppointmentScheduleImplCopyWith<_$PtAppointmentScheduleImpl>
      get copyWith => throw _privateConstructorUsedError;
}
