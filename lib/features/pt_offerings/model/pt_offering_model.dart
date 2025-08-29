import 'package:freezed_annotation/freezed_annotation.dart';

part 'pt_offering_model.freezed.dart';
part 'pt_offering_model.g.dart';

@freezed
class PtOffering with _$PtOffering {
  const factory PtOffering({
    required int id,
    required String title,
    required String description,
    required int price,
    required int totalSessions,
    int? trainerId, // API 응답에 없을 수 있으므로 nullable로 변경
    required int gymId,
    String? trainerName, // API 응답에 포함된 필드 추가
    String? status, // API 응답에 포함된 필드 추가
  }) = _PtOffering;

  factory PtOffering.fromJson(Map<String, dynamic> json) =>
      _$PtOfferingFromJson(json);
}

@freezed
class CreatePtOfferingRequest with _$CreatePtOfferingRequest {
  const factory CreatePtOfferingRequest({
    required String title,
    required String description,
    required int price,
    required int totalSessions,
    required int trainerId,
  }) = _CreatePtOfferingRequest;

  factory CreatePtOfferingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePtOfferingRequestFromJson(json);
}

@freezed
class PtOfferingsResponse with _$PtOfferingsResponse {
  const factory PtOfferingsResponse({
    required List<PtOffering> ptOfferings,
  }) = _PtOfferingsResponse;

  factory PtOfferingsResponse.fromJson(Map<String, dynamic> json) =>
      _$PtOfferingsResponseFromJson(json);
}