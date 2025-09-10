import 'package:freezed_annotation/freezed_annotation.dart';

part 'pt_appointment_models.freezed.dart';
part 'pt_appointment_models.g.dart';

@freezed
class PtAppointment with _$PtAppointment {
  const factory PtAppointment({
    @JsonKey(name: 'id') required int appointmentId,  // API는 'id'로 전송
    required int contractId,
    int? memberId,  // API 응답에 없을 수 있음
    int? trainerId,  // API 응답에 없을 수 있음
    required String memberName,
    required String trainerName,
    required String startTime,
    required String endTime,
    String? status, // API 응답에 없을 수 있음
    String? changeRequestStartTime,
    String? changeRequestEndTime,
    String? changeRequestBy, // MEMBER, TRAINER
    String? changeRequestStatus, // PENDING, APPROVED, REJECTED
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PtAppointment;

  factory PtAppointment.fromJson(Map<String, dynamic> json) =>
      _$PtAppointmentFromJson(json);
}

@freezed
class PtAppointmentsResponse with _$PtAppointmentsResponse {
  const factory PtAppointmentsResponse({
    required List<PtAppointment> data,
    required int totalElements,
    required int totalPages,
    required int currentPage,
    required bool hasNext,
    required bool hasPrevious,
  }) = _PtAppointmentsResponse;

  factory PtAppointmentsResponse.fromJson(Map<String, dynamic> json) =>
      _$PtAppointmentsResponseFromJson(json);
}

@freezed
class AppointmentStatusUpdate with _$AppointmentStatusUpdate {
  const factory AppointmentStatusUpdate({
    required String status,
  }) = _AppointmentStatusUpdate;

  factory AppointmentStatusUpdate.fromJson(Map<String, dynamic> json) =>
      _$AppointmentStatusUpdateFromJson(json);
}

@freezed
class AppointmentChangeRequest with _$AppointmentChangeRequest {
  const factory AppointmentChangeRequest({
    required String newStartTime,
    required String newEndTime,
  }) = _AppointmentChangeRequest;

  factory AppointmentChangeRequest.fromJson(Map<String, dynamic> json) =>
      _$AppointmentChangeRequestFromJson(json);
}

@freezed
class AppointmentCreateRequest with _$AppointmentCreateRequest {
  const factory AppointmentCreateRequest({
    required int contractId,
    required String startTime,
    required String endTime,
  }) = _AppointmentCreateRequest;

  factory AppointmentCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$AppointmentCreateRequestFromJson(json);
}