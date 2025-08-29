import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../model/pt_contract_models.dart';
import '../model/pt_session_models.dart';

class PtContractRepository {
  final ApiService _apiService;

  PtContractRepository(this._apiService);

  Future<PtContractResponse> getMyContracts({
    int page = 0,
    int size = 10,
    String sort = 'startDate,desc',
  }) async {
    final response = await _apiService.get(
      '/pt/contract/me',
      queryParameters: {
        'page': page,
        'size': size,
        'sort': sort,
      },
    );

    return PtContractResponse.fromJson(response.data);
  }

  Future<void> proposeAppointment({
    required int contractId,
    required String startTime,
    required String endTime,
  }) async {
    final requestData = {
      'contractId': contractId,
      'startTime': startTime,
      'endTime': endTime,
    };

    await _apiService.post(
      '/pt-appointments/propose',
      data: requestData,
    );
  }

  Future<void> createAppointment({
    required int contractId,
    required String startTime,
    required String endTime,
  }) async {
    final requestData = {
      'contractId': contractId,
      'startTime': startTime,
      'endTime': endTime,
    };

    await _apiService.post(
      '/pt-appointments',
      data: requestData,
    );
  }

  Future<void> confirmAppointment({
    required int appointmentId,
  }) async {
    await _apiService.patch(
      '/pt-appointments/$appointmentId/confirm',
    );
  }

  Future<void> updateAppointmentStatus({
    required int appointmentId,
    required String status,
  }) async {
    final requestData = {
      'status': status,
    };

    await _apiService.patch(
      '/pt-appointments/$appointmentId/status',
      data: requestData,
    );
  }

  Future<void> requestScheduleChange({
    required int appointmentId,
    required String newStartTime,
    required String newEndTime,
  }) async {
    final requestData = {
      'newStartTime': newStartTime,
      'newEndTime': newEndTime,
    };

    await _apiService.patch(
      '/pt-appointments/$appointmentId/change-request',
      data: requestData,
    );
  }

  Future<void> approveScheduleChange({
    required int appointmentId,
  }) async {
    await _apiService.patch(
      '/pt-appointments/$appointmentId/change-approval',
    );
  }

  Future<void> rejectScheduleChange({
    required int appointmentId,
  }) async {
    await _apiService.patch(
      '/pt-appointments/$appointmentId/change-rejection',
    );
  }

  Future<void> trainerRequestScheduleChange({
    required int appointmentId,
    required String newStartTime,
    required String newEndTime,
  }) async {
    final requestData = {
      'newStartTime': newStartTime,
      'newEndTime': newEndTime,
    };

    await _apiService.patch(
      '/pt-appointments/$appointmentId/trainer-change-request',
      data: requestData,
    );
  }

  Future<void> memberApproveScheduleChange({
    required int appointmentId,
  }) async {
    await _apiService.patch(
      '/pt-appointments/$appointmentId/member-approve-change',
    );
  }

  Future<PtSession> createPtSession({
    required PtSessionCreate sessionData,
  }) async {
    final response = await _apiService.post(
      '/pt-sessions',
      data: sessionData.toJson(),
    );

    return PtSession.fromJson(response.data);
  }

  Future<void> deletePtSession({
    required int ptSessionId,
  }) async {
    await _apiService.delete(
      '/pt-sessions/$ptSessionId',
    );
  }
}

final ptContractRepositoryProvider = Provider<PtContractRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PtContractRepository(apiService);
});
