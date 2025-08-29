import 'package:freezed_annotation/freezed_annotation.dart';

part 'pt_contract_models.freezed.dart';
part 'pt_contract_models.g.dart';

@freezed
class PtContractResponse with _$PtContractResponse {
  const factory PtContractResponse({
    required List<PtContract> data,
    required PageInfo pageInfo,
  }) = _PtContractResponse;

  factory PtContractResponse.fromJson(Map<String, dynamic> json) =>
      _$PtContractResponseFromJson(json);
}

@freezed
class PtContract with _$PtContract {
  const factory PtContract({
    required int contractId,
    required int memberId,
    required int trainerId,
    required String trainerName,
    required String memberName,
    required int totalSessions,
    required int remainingSessions,
    required String status,
    String? startDate,
    int? price,
  }) = _PtContract;

  factory PtContract.fromJson(Map<String, dynamic> json) =>
      _$PtContractFromJson(json);
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

@freezed
class PtAppointmentProposal with _$PtAppointmentProposal {
  const factory PtAppointmentProposal({
    required int contractId,
    required String startTime,
    required String endTime,
  }) = _PtAppointmentProposal;

  factory PtAppointmentProposal.fromJson(Map<String, dynamic> json) =>
      _$PtAppointmentProposalFromJson(json);
}

@freezed
class PtAppointmentSchedule with _$PtAppointmentSchedule {
  const factory PtAppointmentSchedule({
    required int contractId,
    required String startTime,
    required String endTime,
  }) = _PtAppointmentSchedule;

  factory PtAppointmentSchedule.fromJson(Map<String, dynamic> json) =>
      _$PtAppointmentScheduleFromJson(json);
}