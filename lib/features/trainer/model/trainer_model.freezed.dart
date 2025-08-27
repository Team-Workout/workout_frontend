// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trainer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Trainer _$TrainerFromJson(Map<String, dynamic> json) {
  return _Trainer.fromJson(json);
}

/// @nodoc
mixin _$Trainer {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get specialization => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  String get profileImageUrl => throw _privateConstructorUsedError;
  int get pricePerSession => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  int get yearsOfExperience => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  List<String> get certifications => throw _privateConstructorUsedError;

  /// Serializes this Trainer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Trainer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainerCopyWith<Trainer> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainerCopyWith<$Res> {
  factory $TrainerCopyWith(Trainer value, $Res Function(Trainer) then) =
      _$TrainerCopyWithImpl<$Res, Trainer>;
  @useResult
  $Res call(
      {String id,
      String name,
      String specialization,
      double rating,
      int reviewCount,
      String profileImageUrl,
      int pricePerSession,
      String description,
      List<String> tags,
      int yearsOfExperience,
      bool isFeatured,
      List<String> certifications});
}

/// @nodoc
class _$TrainerCopyWithImpl<$Res, $Val extends Trainer>
    implements $TrainerCopyWith<$Res> {
  _$TrainerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Trainer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? specialization = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? profileImageUrl = null,
    Object? pricePerSession = null,
    Object? description = null,
    Object? tags = null,
    Object? yearsOfExperience = null,
    Object? isFeatured = null,
    Object? certifications = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      specialization: null == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      profileImageUrl: null == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      pricePerSession: null == pricePerSession
          ? _value.pricePerSession
          : pricePerSession // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      yearsOfExperience: null == yearsOfExperience
          ? _value.yearsOfExperience
          : yearsOfExperience // ignore: cast_nullable_to_non_nullable
              as int,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      certifications: null == certifications
          ? _value.certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainerImplCopyWith<$Res> implements $TrainerCopyWith<$Res> {
  factory _$$TrainerImplCopyWith(
          _$TrainerImpl value, $Res Function(_$TrainerImpl) then) =
      __$$TrainerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String specialization,
      double rating,
      int reviewCount,
      String profileImageUrl,
      int pricePerSession,
      String description,
      List<String> tags,
      int yearsOfExperience,
      bool isFeatured,
      List<String> certifications});
}

/// @nodoc
class __$$TrainerImplCopyWithImpl<$Res>
    extends _$TrainerCopyWithImpl<$Res, _$TrainerImpl>
    implements _$$TrainerImplCopyWith<$Res> {
  __$$TrainerImplCopyWithImpl(
      _$TrainerImpl _value, $Res Function(_$TrainerImpl) _then)
      : super(_value, _then);

  /// Create a copy of Trainer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? specialization = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? profileImageUrl = null,
    Object? pricePerSession = null,
    Object? description = null,
    Object? tags = null,
    Object? yearsOfExperience = null,
    Object? isFeatured = null,
    Object? certifications = null,
  }) {
    return _then(_$TrainerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      specialization: null == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      profileImageUrl: null == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      pricePerSession: null == pricePerSession
          ? _value.pricePerSession
          : pricePerSession // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      yearsOfExperience: null == yearsOfExperience
          ? _value.yearsOfExperience
          : yearsOfExperience // ignore: cast_nullable_to_non_nullable
              as int,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      certifications: null == certifications
          ? _value._certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrainerImpl implements _Trainer {
  const _$TrainerImpl(
      {required this.id,
      required this.name,
      required this.specialization,
      required this.rating,
      required this.reviewCount,
      required this.profileImageUrl,
      required this.pricePerSession,
      required this.description,
      required final List<String> tags,
      required this.yearsOfExperience,
      required this.isFeatured,
      required final List<String> certifications})
      : _tags = tags,
        _certifications = certifications;

  factory _$TrainerImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainerImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String specialization;
  @override
  final double rating;
  @override
  final int reviewCount;
  @override
  final String profileImageUrl;
  @override
  final int pricePerSession;
  @override
  final String description;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final int yearsOfExperience;
  @override
  final bool isFeatured;
  final List<String> _certifications;
  @override
  List<String> get certifications {
    if (_certifications is EqualUnmodifiableListView) return _certifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_certifications);
  }

  @override
  String toString() {
    return 'Trainer(id: $id, name: $name, specialization: $specialization, rating: $rating, reviewCount: $reviewCount, profileImageUrl: $profileImageUrl, pricePerSession: $pricePerSession, description: $description, tags: $tags, yearsOfExperience: $yearsOfExperience, isFeatured: $isFeatured, certifications: $certifications)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.specialization, specialization) ||
                other.specialization == specialization) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.pricePerSession, pricePerSession) ||
                other.pricePerSession == pricePerSession) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.yearsOfExperience, yearsOfExperience) ||
                other.yearsOfExperience == yearsOfExperience) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            const DeepCollectionEquality()
                .equals(other._certifications, _certifications));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      specialization,
      rating,
      reviewCount,
      profileImageUrl,
      pricePerSession,
      description,
      const DeepCollectionEquality().hash(_tags),
      yearsOfExperience,
      isFeatured,
      const DeepCollectionEquality().hash(_certifications));

  /// Create a copy of Trainer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainerImplCopyWith<_$TrainerImpl> get copyWith =>
      __$$TrainerImplCopyWithImpl<_$TrainerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainerImplToJson(
      this,
    );
  }
}

abstract class _Trainer implements Trainer {
  const factory _Trainer(
      {required final String id,
      required final String name,
      required final String specialization,
      required final double rating,
      required final int reviewCount,
      required final String profileImageUrl,
      required final int pricePerSession,
      required final String description,
      required final List<String> tags,
      required final int yearsOfExperience,
      required final bool isFeatured,
      required final List<String> certifications}) = _$TrainerImpl;

  factory _Trainer.fromJson(Map<String, dynamic> json) = _$TrainerImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get specialization;
  @override
  double get rating;
  @override
  int get reviewCount;
  @override
  String get profileImageUrl;
  @override
  int get pricePerSession;
  @override
  String get description;
  @override
  List<String> get tags;
  @override
  int get yearsOfExperience;
  @override
  bool get isFeatured;
  @override
  List<String> get certifications;

  /// Create a copy of Trainer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainerImplCopyWith<_$TrainerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Award _$AwardFromJson(Map<String, dynamic> json) {
  return _Award.fromJson(json);
}

/// @nodoc
mixin _$Award {
  int get id => throw _privateConstructorUsedError;
  String get awardName => throw _privateConstructorUsedError;
  String get awardDate => throw _privateConstructorUsedError;
  String get awardPlace => throw _privateConstructorUsedError;

  /// Serializes this Award to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Award
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AwardCopyWith<Award> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AwardCopyWith<$Res> {
  factory $AwardCopyWith(Award value, $Res Function(Award) then) =
      _$AwardCopyWithImpl<$Res, Award>;
  @useResult
  $Res call({int id, String awardName, String awardDate, String awardPlace});
}

/// @nodoc
class _$AwardCopyWithImpl<$Res, $Val extends Award>
    implements $AwardCopyWith<$Res> {
  _$AwardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Award
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? awardName = null,
    Object? awardDate = null,
    Object? awardPlace = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      awardName: null == awardName
          ? _value.awardName
          : awardName // ignore: cast_nullable_to_non_nullable
              as String,
      awardDate: null == awardDate
          ? _value.awardDate
          : awardDate // ignore: cast_nullable_to_non_nullable
              as String,
      awardPlace: null == awardPlace
          ? _value.awardPlace
          : awardPlace // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AwardImplCopyWith<$Res> implements $AwardCopyWith<$Res> {
  factory _$$AwardImplCopyWith(
          _$AwardImpl value, $Res Function(_$AwardImpl) then) =
      __$$AwardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String awardName, String awardDate, String awardPlace});
}

/// @nodoc
class __$$AwardImplCopyWithImpl<$Res>
    extends _$AwardCopyWithImpl<$Res, _$AwardImpl>
    implements _$$AwardImplCopyWith<$Res> {
  __$$AwardImplCopyWithImpl(
      _$AwardImpl _value, $Res Function(_$AwardImpl) _then)
      : super(_value, _then);

  /// Create a copy of Award
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? awardName = null,
    Object? awardDate = null,
    Object? awardPlace = null,
  }) {
    return _then(_$AwardImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      awardName: null == awardName
          ? _value.awardName
          : awardName // ignore: cast_nullable_to_non_nullable
              as String,
      awardDate: null == awardDate
          ? _value.awardDate
          : awardDate // ignore: cast_nullable_to_non_nullable
              as String,
      awardPlace: null == awardPlace
          ? _value.awardPlace
          : awardPlace // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AwardImpl implements _Award {
  const _$AwardImpl(
      {required this.id,
      this.awardName = '',
      this.awardDate = '',
      this.awardPlace = ''});

  factory _$AwardImpl.fromJson(Map<String, dynamic> json) =>
      _$$AwardImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey()
  final String awardName;
  @override
  @JsonKey()
  final String awardDate;
  @override
  @JsonKey()
  final String awardPlace;

  @override
  String toString() {
    return 'Award(id: $id, awardName: $awardName, awardDate: $awardDate, awardPlace: $awardPlace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AwardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.awardName, awardName) ||
                other.awardName == awardName) &&
            (identical(other.awardDate, awardDate) ||
                other.awardDate == awardDate) &&
            (identical(other.awardPlace, awardPlace) ||
                other.awardPlace == awardPlace));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, awardName, awardDate, awardPlace);

  /// Create a copy of Award
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AwardImplCopyWith<_$AwardImpl> get copyWith =>
      __$$AwardImplCopyWithImpl<_$AwardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AwardImplToJson(
      this,
    );
  }
}

abstract class _Award implements Award {
  const factory _Award(
      {required final int id,
      final String awardName,
      final String awardDate,
      final String awardPlace}) = _$AwardImpl;

  factory _Award.fromJson(Map<String, dynamic> json) = _$AwardImpl.fromJson;

  @override
  int get id;
  @override
  String get awardName;
  @override
  String get awardDate;
  @override
  String get awardPlace;

  /// Create a copy of Award
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AwardImplCopyWith<_$AwardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Certification _$CertificationFromJson(Map<String, dynamic> json) {
  return _Certification.fromJson(json);
}

/// @nodoc
mixin _$Certification {
  int get id => throw _privateConstructorUsedError;
  String get certificationName => throw _privateConstructorUsedError;
  String get issuingOrganization => throw _privateConstructorUsedError;
  String get acquisitionDate => throw _privateConstructorUsedError;

  /// Serializes this Certification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Certification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CertificationCopyWith<Certification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CertificationCopyWith<$Res> {
  factory $CertificationCopyWith(
          Certification value, $Res Function(Certification) then) =
      _$CertificationCopyWithImpl<$Res, Certification>;
  @useResult
  $Res call(
      {int id,
      String certificationName,
      String issuingOrganization,
      String acquisitionDate});
}

/// @nodoc
class _$CertificationCopyWithImpl<$Res, $Val extends Certification>
    implements $CertificationCopyWith<$Res> {
  _$CertificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Certification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? certificationName = null,
    Object? issuingOrganization = null,
    Object? acquisitionDate = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      certificationName: null == certificationName
          ? _value.certificationName
          : certificationName // ignore: cast_nullable_to_non_nullable
              as String,
      issuingOrganization: null == issuingOrganization
          ? _value.issuingOrganization
          : issuingOrganization // ignore: cast_nullable_to_non_nullable
              as String,
      acquisitionDate: null == acquisitionDate
          ? _value.acquisitionDate
          : acquisitionDate // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CertificationImplCopyWith<$Res>
    implements $CertificationCopyWith<$Res> {
  factory _$$CertificationImplCopyWith(
          _$CertificationImpl value, $Res Function(_$CertificationImpl) then) =
      __$$CertificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String certificationName,
      String issuingOrganization,
      String acquisitionDate});
}

/// @nodoc
class __$$CertificationImplCopyWithImpl<$Res>
    extends _$CertificationCopyWithImpl<$Res, _$CertificationImpl>
    implements _$$CertificationImplCopyWith<$Res> {
  __$$CertificationImplCopyWithImpl(
      _$CertificationImpl _value, $Res Function(_$CertificationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Certification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? certificationName = null,
    Object? issuingOrganization = null,
    Object? acquisitionDate = null,
  }) {
    return _then(_$CertificationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      certificationName: null == certificationName
          ? _value.certificationName
          : certificationName // ignore: cast_nullable_to_non_nullable
              as String,
      issuingOrganization: null == issuingOrganization
          ? _value.issuingOrganization
          : issuingOrganization // ignore: cast_nullable_to_non_nullable
              as String,
      acquisitionDate: null == acquisitionDate
          ? _value.acquisitionDate
          : acquisitionDate // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CertificationImpl implements _Certification {
  const _$CertificationImpl(
      {required this.id,
      this.certificationName = '',
      this.issuingOrganization = '',
      this.acquisitionDate = ''});

  factory _$CertificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CertificationImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey()
  final String certificationName;
  @override
  @JsonKey()
  final String issuingOrganization;
  @override
  @JsonKey()
  final String acquisitionDate;

  @override
  String toString() {
    return 'Certification(id: $id, certificationName: $certificationName, issuingOrganization: $issuingOrganization, acquisitionDate: $acquisitionDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CertificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.certificationName, certificationName) ||
                other.certificationName == certificationName) &&
            (identical(other.issuingOrganization, issuingOrganization) ||
                other.issuingOrganization == issuingOrganization) &&
            (identical(other.acquisitionDate, acquisitionDate) ||
                other.acquisitionDate == acquisitionDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, certificationName, issuingOrganization, acquisitionDate);

  /// Create a copy of Certification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CertificationImplCopyWith<_$CertificationImpl> get copyWith =>
      __$$CertificationImplCopyWithImpl<_$CertificationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CertificationImplToJson(
      this,
    );
  }
}

abstract class _Certification implements Certification {
  const factory _Certification(
      {required final int id,
      final String certificationName,
      final String issuingOrganization,
      final String acquisitionDate}) = _$CertificationImpl;

  factory _Certification.fromJson(Map<String, dynamic> json) =
      _$CertificationImpl.fromJson;

  @override
  int get id;
  @override
  String get certificationName;
  @override
  String get issuingOrganization;
  @override
  String get acquisitionDate;

  /// Create a copy of Certification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CertificationImplCopyWith<_$CertificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Education _$EducationFromJson(Map<String, dynamic> json) {
  return _Education.fromJson(json);
}

/// @nodoc
mixin _$Education {
  int get id => throw _privateConstructorUsedError;
  String get schoolName => throw _privateConstructorUsedError;
  String get educationName => throw _privateConstructorUsedError;
  String get degree => throw _privateConstructorUsedError;
  String get startDate => throw _privateConstructorUsedError;
  String? get endDate => throw _privateConstructorUsedError;

  /// Serializes this Education to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Education
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EducationCopyWith<Education> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EducationCopyWith<$Res> {
  factory $EducationCopyWith(Education value, $Res Function(Education) then) =
      _$EducationCopyWithImpl<$Res, Education>;
  @useResult
  $Res call(
      {int id,
      String schoolName,
      String educationName,
      String degree,
      String startDate,
      String? endDate});
}

/// @nodoc
class _$EducationCopyWithImpl<$Res, $Val extends Education>
    implements $EducationCopyWith<$Res> {
  _$EducationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Education
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? schoolName = null,
    Object? educationName = null,
    Object? degree = null,
    Object? startDate = null,
    Object? endDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      schoolName: null == schoolName
          ? _value.schoolName
          : schoolName // ignore: cast_nullable_to_non_nullable
              as String,
      educationName: null == educationName
          ? _value.educationName
          : educationName // ignore: cast_nullable_to_non_nullable
              as String,
      degree: null == degree
          ? _value.degree
          : degree // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EducationImplCopyWith<$Res>
    implements $EducationCopyWith<$Res> {
  factory _$$EducationImplCopyWith(
          _$EducationImpl value, $Res Function(_$EducationImpl) then) =
      __$$EducationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String schoolName,
      String educationName,
      String degree,
      String startDate,
      String? endDate});
}

/// @nodoc
class __$$EducationImplCopyWithImpl<$Res>
    extends _$EducationCopyWithImpl<$Res, _$EducationImpl>
    implements _$$EducationImplCopyWith<$Res> {
  __$$EducationImplCopyWithImpl(
      _$EducationImpl _value, $Res Function(_$EducationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Education
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? schoolName = null,
    Object? educationName = null,
    Object? degree = null,
    Object? startDate = null,
    Object? endDate = freezed,
  }) {
    return _then(_$EducationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      schoolName: null == schoolName
          ? _value.schoolName
          : schoolName // ignore: cast_nullable_to_non_nullable
              as String,
      educationName: null == educationName
          ? _value.educationName
          : educationName // ignore: cast_nullable_to_non_nullable
              as String,
      degree: null == degree
          ? _value.degree
          : degree // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EducationImpl implements _Education {
  const _$EducationImpl(
      {required this.id,
      this.schoolName = '',
      this.educationName = '',
      this.degree = '',
      this.startDate = '',
      this.endDate});

  factory _$EducationImpl.fromJson(Map<String, dynamic> json) =>
      _$$EducationImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey()
  final String schoolName;
  @override
  @JsonKey()
  final String educationName;
  @override
  @JsonKey()
  final String degree;
  @override
  @JsonKey()
  final String startDate;
  @override
  final String? endDate;

  @override
  String toString() {
    return 'Education(id: $id, schoolName: $schoolName, educationName: $educationName, degree: $degree, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EducationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.schoolName, schoolName) ||
                other.schoolName == schoolName) &&
            (identical(other.educationName, educationName) ||
                other.educationName == educationName) &&
            (identical(other.degree, degree) || other.degree == degree) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, schoolName, educationName, degree, startDate, endDate);

  /// Create a copy of Education
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EducationImplCopyWith<_$EducationImpl> get copyWith =>
      __$$EducationImplCopyWithImpl<_$EducationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EducationImplToJson(
      this,
    );
  }
}

abstract class _Education implements Education {
  const factory _Education(
      {required final int id,
      final String schoolName,
      final String educationName,
      final String degree,
      final String startDate,
      final String? endDate}) = _$EducationImpl;

  factory _Education.fromJson(Map<String, dynamic> json) =
      _$EducationImpl.fromJson;

  @override
  int get id;
  @override
  String get schoolName;
  @override
  String get educationName;
  @override
  String get degree;
  @override
  String get startDate;
  @override
  String? get endDate;

  /// Create a copy of Education
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EducationImplCopyWith<_$EducationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkExperience _$WorkExperienceFromJson(Map<String, dynamic> json) {
  return _WorkExperience.fromJson(json);
}

/// @nodoc
mixin _$WorkExperience {
  int get id => throw _privateConstructorUsedError;
  String get workName => throw _privateConstructorUsedError;
  String get workPlace => throw _privateConstructorUsedError;
  String get workPosition => throw _privateConstructorUsedError;
  String get workStart => throw _privateConstructorUsedError;
  String? get workEnd => throw _privateConstructorUsedError;

  /// Serializes this WorkExperience to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkExperience
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkExperienceCopyWith<WorkExperience> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkExperienceCopyWith<$Res> {
  factory $WorkExperienceCopyWith(
          WorkExperience value, $Res Function(WorkExperience) then) =
      _$WorkExperienceCopyWithImpl<$Res, WorkExperience>;
  @useResult
  $Res call(
      {int id,
      String workName,
      String workPlace,
      String workPosition,
      String workStart,
      String? workEnd});
}

/// @nodoc
class _$WorkExperienceCopyWithImpl<$Res, $Val extends WorkExperience>
    implements $WorkExperienceCopyWith<$Res> {
  _$WorkExperienceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkExperience
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workName = null,
    Object? workPlace = null,
    Object? workPosition = null,
    Object? workStart = null,
    Object? workEnd = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      workName: null == workName
          ? _value.workName
          : workName // ignore: cast_nullable_to_non_nullable
              as String,
      workPlace: null == workPlace
          ? _value.workPlace
          : workPlace // ignore: cast_nullable_to_non_nullable
              as String,
      workPosition: null == workPosition
          ? _value.workPosition
          : workPosition // ignore: cast_nullable_to_non_nullable
              as String,
      workStart: null == workStart
          ? _value.workStart
          : workStart // ignore: cast_nullable_to_non_nullable
              as String,
      workEnd: freezed == workEnd
          ? _value.workEnd
          : workEnd // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkExperienceImplCopyWith<$Res>
    implements $WorkExperienceCopyWith<$Res> {
  factory _$$WorkExperienceImplCopyWith(_$WorkExperienceImpl value,
          $Res Function(_$WorkExperienceImpl) then) =
      __$$WorkExperienceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String workName,
      String workPlace,
      String workPosition,
      String workStart,
      String? workEnd});
}

/// @nodoc
class __$$WorkExperienceImplCopyWithImpl<$Res>
    extends _$WorkExperienceCopyWithImpl<$Res, _$WorkExperienceImpl>
    implements _$$WorkExperienceImplCopyWith<$Res> {
  __$$WorkExperienceImplCopyWithImpl(
      _$WorkExperienceImpl _value, $Res Function(_$WorkExperienceImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkExperience
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workName = null,
    Object? workPlace = null,
    Object? workPosition = null,
    Object? workStart = null,
    Object? workEnd = freezed,
  }) {
    return _then(_$WorkExperienceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      workName: null == workName
          ? _value.workName
          : workName // ignore: cast_nullable_to_non_nullable
              as String,
      workPlace: null == workPlace
          ? _value.workPlace
          : workPlace // ignore: cast_nullable_to_non_nullable
              as String,
      workPosition: null == workPosition
          ? _value.workPosition
          : workPosition // ignore: cast_nullable_to_non_nullable
              as String,
      workStart: null == workStart
          ? _value.workStart
          : workStart // ignore: cast_nullable_to_non_nullable
              as String,
      workEnd: freezed == workEnd
          ? _value.workEnd
          : workEnd // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkExperienceImpl implements _WorkExperience {
  const _$WorkExperienceImpl(
      {required this.id,
      this.workName = '',
      this.workPlace = '',
      this.workPosition = '',
      this.workStart = '',
      this.workEnd});

  factory _$WorkExperienceImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkExperienceImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey()
  final String workName;
  @override
  @JsonKey()
  final String workPlace;
  @override
  @JsonKey()
  final String workPosition;
  @override
  @JsonKey()
  final String workStart;
  @override
  final String? workEnd;

  @override
  String toString() {
    return 'WorkExperience(id: $id, workName: $workName, workPlace: $workPlace, workPosition: $workPosition, workStart: $workStart, workEnd: $workEnd)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkExperienceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workName, workName) ||
                other.workName == workName) &&
            (identical(other.workPlace, workPlace) ||
                other.workPlace == workPlace) &&
            (identical(other.workPosition, workPosition) ||
                other.workPosition == workPosition) &&
            (identical(other.workStart, workStart) ||
                other.workStart == workStart) &&
            (identical(other.workEnd, workEnd) || other.workEnd == workEnd));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, workName, workPlace, workPosition, workStart, workEnd);

  /// Create a copy of WorkExperience
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkExperienceImplCopyWith<_$WorkExperienceImpl> get copyWith =>
      __$$WorkExperienceImplCopyWithImpl<_$WorkExperienceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkExperienceImplToJson(
      this,
    );
  }
}

abstract class _WorkExperience implements WorkExperience {
  const factory _WorkExperience(
      {required final int id,
      final String workName,
      final String workPlace,
      final String workPosition,
      final String workStart,
      final String? workEnd}) = _$WorkExperienceImpl;

  factory _WorkExperience.fromJson(Map<String, dynamic> json) =
      _$WorkExperienceImpl.fromJson;

  @override
  int get id;
  @override
  String get workName;
  @override
  String get workPlace;
  @override
  String get workPosition;
  @override
  String get workStart;
  @override
  String? get workEnd;

  /// Create a copy of WorkExperience
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkExperienceImplCopyWith<_$WorkExperienceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrainerProfile _$TrainerProfileFromJson(Map<String, dynamic> json) {
  return _TrainerProfile.fromJson(json);
}

/// @nodoc
mixin _$TrainerProfile {
  int get trainerId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get email =>
      throw _privateConstructorUsedError; // nullable since it's not in API response
  String? get introduction => throw _privateConstructorUsedError; // nullable
  String? get profileImageUrl =>
      throw _privateConstructorUsedError; // add this field from API
  List<Award> get awards => throw _privateConstructorUsedError;
  List<Certification> get certifications => throw _privateConstructorUsedError;
  List<Education> get educations => throw _privateConstructorUsedError;
  List<WorkExperience> get workExperiences =>
      throw _privateConstructorUsedError;
  List<String> get specialties => throw _privateConstructorUsedError;

  /// Serializes this TrainerProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrainerProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainerProfileCopyWith<TrainerProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainerProfileCopyWith<$Res> {
  factory $TrainerProfileCopyWith(
          TrainerProfile value, $Res Function(TrainerProfile) then) =
      _$TrainerProfileCopyWithImpl<$Res, TrainerProfile>;
  @useResult
  $Res call(
      {int trainerId,
      String name,
      String? email,
      String? introduction,
      String? profileImageUrl,
      List<Award> awards,
      List<Certification> certifications,
      List<Education> educations,
      List<WorkExperience> workExperiences,
      List<String> specialties});
}

/// @nodoc
class _$TrainerProfileCopyWithImpl<$Res, $Val extends TrainerProfile>
    implements $TrainerProfileCopyWith<$Res> {
  _$TrainerProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainerProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trainerId = null,
    Object? name = null,
    Object? email = freezed,
    Object? introduction = freezed,
    Object? profileImageUrl = freezed,
    Object? awards = null,
    Object? certifications = null,
    Object? educations = null,
    Object? workExperiences = null,
    Object? specialties = null,
  }) {
    return _then(_value.copyWith(
      trainerId: null == trainerId
          ? _value.trainerId
          : trainerId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      introduction: freezed == introduction
          ? _value.introduction
          : introduction // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      awards: null == awards
          ? _value.awards
          : awards // ignore: cast_nullable_to_non_nullable
              as List<Award>,
      certifications: null == certifications
          ? _value.certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<Certification>,
      educations: null == educations
          ? _value.educations
          : educations // ignore: cast_nullable_to_non_nullable
              as List<Education>,
      workExperiences: null == workExperiences
          ? _value.workExperiences
          : workExperiences // ignore: cast_nullable_to_non_nullable
              as List<WorkExperience>,
      specialties: null == specialties
          ? _value.specialties
          : specialties // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainerProfileImplCopyWith<$Res>
    implements $TrainerProfileCopyWith<$Res> {
  factory _$$TrainerProfileImplCopyWith(_$TrainerProfileImpl value,
          $Res Function(_$TrainerProfileImpl) then) =
      __$$TrainerProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int trainerId,
      String name,
      String? email,
      String? introduction,
      String? profileImageUrl,
      List<Award> awards,
      List<Certification> certifications,
      List<Education> educations,
      List<WorkExperience> workExperiences,
      List<String> specialties});
}

/// @nodoc
class __$$TrainerProfileImplCopyWithImpl<$Res>
    extends _$TrainerProfileCopyWithImpl<$Res, _$TrainerProfileImpl>
    implements _$$TrainerProfileImplCopyWith<$Res> {
  __$$TrainerProfileImplCopyWithImpl(
      _$TrainerProfileImpl _value, $Res Function(_$TrainerProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainerProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trainerId = null,
    Object? name = null,
    Object? email = freezed,
    Object? introduction = freezed,
    Object? profileImageUrl = freezed,
    Object? awards = null,
    Object? certifications = null,
    Object? educations = null,
    Object? workExperiences = null,
    Object? specialties = null,
  }) {
    return _then(_$TrainerProfileImpl(
      trainerId: null == trainerId
          ? _value.trainerId
          : trainerId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      introduction: freezed == introduction
          ? _value.introduction
          : introduction // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      awards: null == awards
          ? _value._awards
          : awards // ignore: cast_nullable_to_non_nullable
              as List<Award>,
      certifications: null == certifications
          ? _value._certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<Certification>,
      educations: null == educations
          ? _value._educations
          : educations // ignore: cast_nullable_to_non_nullable
              as List<Education>,
      workExperiences: null == workExperiences
          ? _value._workExperiences
          : workExperiences // ignore: cast_nullable_to_non_nullable
              as List<WorkExperience>,
      specialties: null == specialties
          ? _value._specialties
          : specialties // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrainerProfileImpl implements _TrainerProfile {
  const _$TrainerProfileImpl(
      {required this.trainerId,
      this.name = '',
      this.email,
      this.introduction,
      this.profileImageUrl,
      final List<Award> awards = const [],
      final List<Certification> certifications = const [],
      final List<Education> educations = const [],
      final List<WorkExperience> workExperiences = const [],
      final List<String> specialties = const []})
      : _awards = awards,
        _certifications = certifications,
        _educations = educations,
        _workExperiences = workExperiences,
        _specialties = specialties;

  factory _$TrainerProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainerProfileImplFromJson(json);

  @override
  final int trainerId;
  @override
  @JsonKey()
  final String name;
  @override
  final String? email;
// nullable since it's not in API response
  @override
  final String? introduction;
// nullable
  @override
  final String? profileImageUrl;
// add this field from API
  final List<Award> _awards;
// add this field from API
  @override
  @JsonKey()
  List<Award> get awards {
    if (_awards is EqualUnmodifiableListView) return _awards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_awards);
  }

  final List<Certification> _certifications;
  @override
  @JsonKey()
  List<Certification> get certifications {
    if (_certifications is EqualUnmodifiableListView) return _certifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_certifications);
  }

  final List<Education> _educations;
  @override
  @JsonKey()
  List<Education> get educations {
    if (_educations is EqualUnmodifiableListView) return _educations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_educations);
  }

  final List<WorkExperience> _workExperiences;
  @override
  @JsonKey()
  List<WorkExperience> get workExperiences {
    if (_workExperiences is EqualUnmodifiableListView) return _workExperiences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workExperiences);
  }

  final List<String> _specialties;
  @override
  @JsonKey()
  List<String> get specialties {
    if (_specialties is EqualUnmodifiableListView) return _specialties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specialties);
  }

  @override
  String toString() {
    return 'TrainerProfile(trainerId: $trainerId, name: $name, email: $email, introduction: $introduction, profileImageUrl: $profileImageUrl, awards: $awards, certifications: $certifications, educations: $educations, workExperiences: $workExperiences, specialties: $specialties)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainerProfileImpl &&
            (identical(other.trainerId, trainerId) ||
                other.trainerId == trainerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.introduction, introduction) ||
                other.introduction == introduction) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            const DeepCollectionEquality().equals(other._awards, _awards) &&
            const DeepCollectionEquality()
                .equals(other._certifications, _certifications) &&
            const DeepCollectionEquality()
                .equals(other._educations, _educations) &&
            const DeepCollectionEquality()
                .equals(other._workExperiences, _workExperiences) &&
            const DeepCollectionEquality()
                .equals(other._specialties, _specialties));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      trainerId,
      name,
      email,
      introduction,
      profileImageUrl,
      const DeepCollectionEquality().hash(_awards),
      const DeepCollectionEquality().hash(_certifications),
      const DeepCollectionEquality().hash(_educations),
      const DeepCollectionEquality().hash(_workExperiences),
      const DeepCollectionEquality().hash(_specialties));

  /// Create a copy of TrainerProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainerProfileImplCopyWith<_$TrainerProfileImpl> get copyWith =>
      __$$TrainerProfileImplCopyWithImpl<_$TrainerProfileImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainerProfileImplToJson(
      this,
    );
  }
}

abstract class _TrainerProfile implements TrainerProfile {
  const factory _TrainerProfile(
      {required final int trainerId,
      final String name,
      final String? email,
      final String? introduction,
      final String? profileImageUrl,
      final List<Award> awards,
      final List<Certification> certifications,
      final List<Education> educations,
      final List<WorkExperience> workExperiences,
      final List<String> specialties}) = _$TrainerProfileImpl;

  factory _TrainerProfile.fromJson(Map<String, dynamic> json) =
      _$TrainerProfileImpl.fromJson;

  @override
  int get trainerId;
  @override
  String get name;
  @override
  String? get email; // nullable since it's not in API response
  @override
  String? get introduction; // nullable
  @override
  String? get profileImageUrl; // add this field from API
  @override
  List<Award> get awards;
  @override
  List<Certification> get certifications;
  @override
  List<Education> get educations;
  @override
  List<WorkExperience> get workExperiences;
  @override
  List<String> get specialties;

  /// Create a copy of TrainerProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainerProfileImplCopyWith<_$TrainerProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrainerCategory _$TrainerCategoryFromJson(Map<String, dynamic> json) {
  return _TrainerCategory.fromJson(json);
}

/// @nodoc
mixin _$TrainerCategory {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;

  /// Serializes this TrainerCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrainerCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainerCategoryCopyWith<TrainerCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainerCategoryCopyWith<$Res> {
  factory $TrainerCategoryCopyWith(
          TrainerCategory value, $Res Function(TrainerCategory) then) =
      _$TrainerCategoryCopyWithImpl<$Res, TrainerCategory>;
  @useResult
  $Res call({String id, String name, bool isSelected});
}

/// @nodoc
class _$TrainerCategoryCopyWithImpl<$Res, $Val extends TrainerCategory>
    implements $TrainerCategoryCopyWith<$Res> {
  _$TrainerCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainerCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isSelected = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainerCategoryImplCopyWith<$Res>
    implements $TrainerCategoryCopyWith<$Res> {
  factory _$$TrainerCategoryImplCopyWith(_$TrainerCategoryImpl value,
          $Res Function(_$TrainerCategoryImpl) then) =
      __$$TrainerCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, bool isSelected});
}

/// @nodoc
class __$$TrainerCategoryImplCopyWithImpl<$Res>
    extends _$TrainerCategoryCopyWithImpl<$Res, _$TrainerCategoryImpl>
    implements _$$TrainerCategoryImplCopyWith<$Res> {
  __$$TrainerCategoryImplCopyWithImpl(
      _$TrainerCategoryImpl _value, $Res Function(_$TrainerCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainerCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isSelected = null,
  }) {
    return _then(_$TrainerCategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrainerCategoryImpl implements _TrainerCategory {
  const _$TrainerCategoryImpl(
      {required this.id, required this.name, required this.isSelected});

  factory _$TrainerCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainerCategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final bool isSelected;

  @override
  String toString() {
    return 'TrainerCategory(id: $id, name: $name, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainerCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, isSelected);

  /// Create a copy of TrainerCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainerCategoryImplCopyWith<_$TrainerCategoryImpl> get copyWith =>
      __$$TrainerCategoryImplCopyWithImpl<_$TrainerCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainerCategoryImplToJson(
      this,
    );
  }
}

abstract class _TrainerCategory implements TrainerCategory {
  const factory _TrainerCategory(
      {required final String id,
      required final String name,
      required final bool isSelected}) = _$TrainerCategoryImpl;

  factory _TrainerCategory.fromJson(Map<String, dynamic> json) =
      _$TrainerCategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  bool get isSelected;

  /// Create a copy of TrainerCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainerCategoryImplCopyWith<_$TrainerCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
