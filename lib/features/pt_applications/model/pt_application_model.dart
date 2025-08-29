import 'package:freezed_annotation/freezed_annotation.dart';

part 'pt_application_model.freezed.dart';
part 'pt_application_model.g.dart';

@freezed
class PtApplication with _$PtApplication {
  const factory PtApplication({
    required int applicationId,
    required String memberName,
    String? trainerName, // 트레이너 이름 추가 (회원이 볼 때 필요)
    required String appliedAt,
    int? totalSessions, // null 값을 허용하도록 변경
    String? offeringTitle, // PT 상품 제목 추가
  }) = _PtApplication;

  factory PtApplication.fromJson(Map<String, dynamic> json) =>
      _$PtApplicationFromJson(json);
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