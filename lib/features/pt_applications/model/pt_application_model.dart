import 'package:freezed_annotation/freezed_annotation.dart';

part 'pt_application_model.freezed.dart';
part 'pt_application_model.g.dart';

@freezed
class PtApplication with _$PtApplication {
  const factory PtApplication({
    @JsonKey(fromJson: _parseApplicationId) required int applicationId,
    required String memberName,
    String? trainerName, // 트레이너 이름 추가 (회원이 볼 때 필요)
    required String appliedAt,
    @JsonKey(fromJson: _parseTotalSessions) int? totalSessions, // null 값을 허용하도록 변경
    String? offeringTitle, // PT 상품 제목 추가
  }) = _PtApplication;

  factory PtApplication.fromJson(Map<String, dynamic> json) =>
      _$PtApplicationFromJson(json);
}

// applicationId 안전 파싱 함수
int _parseApplicationId(dynamic value) {
  if (value is String) {
    return int.parse(value);
  } else if (value is num) {
    return value.toInt();
  }
  throw FormatException('Cannot parse applicationId: $value');
}

// totalSessions 안전 파싱 함수
int? _parseTotalSessions(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    return int.tryParse(value);
  } else if (value is num) {
    return value.toInt();
  }
  return null;
}

@freezed
class CreatePtApplicationRequest with _$CreatePtApplicationRequest {
  const factory CreatePtApplicationRequest({
    required int offeringId,
  }) = _CreatePtApplicationRequest;

  factory CreatePtApplicationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePtApplicationRequestFromJson(json);
}

@freezed
class PtApplicationsResponse with _$PtApplicationsResponse {
  const factory PtApplicationsResponse({
    required List<PtApplication> applications,
  }) = _PtApplicationsResponse;

  factory PtApplicationsResponse.fromJson(Map<String, dynamic> json) =>
      _$PtApplicationsResponseFromJson(json);
}