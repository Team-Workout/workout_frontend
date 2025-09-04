import 'package:freezed_annotation/freezed_annotation.dart';

part 'trainer_client_model.freezed.dart';
part 'trainer_client_model.g.dart';

@freezed
class TrainerClient with _$TrainerClient {
  const TrainerClient._();
  
  const factory TrainerClient({
    required int id,
    required int gymId,
    required String gymName,
    required String name,
    required String gender,
    String? email,
    String? profileImageUrl,
  }) = _TrainerClient;

  factory TrainerClient.fromJson(Map<String, dynamic> json) =>
      _$TrainerClientFromJson(json);
  
  // memberId getter for backward compatibility
  int get memberId => id;
}

@freezed
class TrainerClientResponse with _$TrainerClientResponse {
  const factory TrainerClientResponse({
    required List<TrainerClient> data,
    required PageInfo pageInfo,
  }) = _TrainerClientResponse;

  factory TrainerClientResponse.fromJson(Map<String, dynamic> json) =>
      _$TrainerClientResponseFromJson(json);
}

@freezed
class PageInfo with _$PageInfo {
  const factory PageInfo({
    required int page,
    required int size,
    required int totalElements,
    required int totalPages,
    required bool last,
  }) = _PageInfo;

  factory PageInfo.fromJson(Map<String, dynamic> json) =>
      _$PageInfoFromJson(json);
}

// 회원의 몸 사진 모델
@freezed
class MemberBodyImage with _$MemberBodyImage {
  const factory MemberBodyImage({
    required int fileId,
    required String fileUrl,
    String? originalFileName,
    required String recordDate,
  }) = _MemberBodyImage;

  factory MemberBodyImage.fromJson(Map<String, dynamic> json) =>
      _$MemberBodyImageFromJson(json);
}

@freezed
class MemberBodyImageResponse with _$MemberBodyImageResponse {
  const factory MemberBodyImageResponse({
    required List<MemberBodyImage> data,
    required PageInfo pageInfo,
  }) = _MemberBodyImageResponse;

  factory MemberBodyImageResponse.fromJson(Map<String, dynamic> json) =>
      _$MemberBodyImageResponseFromJson(json);
}

// 회원의 체성분 모델
@freezed
class MemberBodyComposition with _$MemberBodyComposition {
  const factory MemberBodyComposition({
    required int id,
    required String measurementDate,
    @JsonKey(fromJson: _doubleFromJson) double? weightKg,
    @JsonKey(fromJson: _doubleFromJson) double? fatKg,
    @JsonKey(fromJson: _doubleFromJson) double? muscleMassKg,
  }) = _MemberBodyComposition;

  factory MemberBodyComposition.fromJson(Map<String, dynamic> json) =>
      _$MemberBodyCompositionFromJson(json);
}

// JSON에서 num을 double로 안전하게 변환하는 헬퍼 함수
double? _doubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

@freezed
class MemberBodyCompositionResponse with _$MemberBodyCompositionResponse {
  const factory MemberBodyCompositionResponse({
    required List<MemberBodyComposition> data,
    required PageInfo pageInfo,
  }) = _MemberBodyCompositionResponse;

  factory MemberBodyCompositionResponse.fromJson(Map<String, dynamic> json) =>
      _$MemberBodyCompositionResponseFromJson(json);
}