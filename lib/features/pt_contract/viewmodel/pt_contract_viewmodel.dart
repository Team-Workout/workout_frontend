import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/pt_contract_models.dart';
import '../model/pt_session_models.dart';
import '../model/pt_appointment_models.dart';
import '../repository/pt_contract_repository.dart';

part 'pt_contract_viewmodel.g.dart';

@riverpod
class PtContractViewModel extends _$PtContractViewModel {
  @override
  FutureOr<PtContractResponse?> build() async {
    return null;
  }

  Future<void> loadMyContracts({
    int page = 0,
    int size = 10,
    String sort = 'startDate,desc',
  }) async {
    state = const AsyncLoading();
    
    try {
      final repository = ref.read(ptContractRepositoryProvider);
      final result = await repository.getMyContracts(
        page: page,
        size: size,
        sort: sort,
      );
      
      state = AsyncData(result);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> proposeAppointment({
    required int contractId,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final repository = ref.read(ptContractRepositoryProvider);
      await repository.proposeAppointment(
        contractId: contractId,
        startTime: startTime,
        endTime: endTime,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> createAppointment({
    required int contractId,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final repository = ref.read(ptContractRepositoryProvider);
      await repository.createAppointment(
        contractId: contractId,
        startTime: startTime,
        endTime: endTime,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> confirmAppointment({
    required int appointmentId,
  }) async {
    try {
      final repository = ref.read(ptContractRepositoryProvider);
      await repository.confirmAppointment(
        appointmentId: appointmentId,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateAppointmentStatus({
    required int appointmentId,
    required String status,
  }) async {
    try {
      final repository = ref.read(ptContractRepositoryProvider);
      await repository.updateAppointmentStatus(
        appointmentId: appointmentId,
        status: status,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> requestScheduleChange({
    required int appointmentId,
    required String newStartTime,
    required String newEndTime,
  }) async {
    try {
      final repository = ref.read(ptContractRepositoryProvider);
      await repository.requestScheduleChange(
        appointmentId: appointmentId,
        newStartTime: newStartTime,
        newEndTime: newEndTime,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> approveScheduleChange({
    required int appointmentId,
  }) async {
    try {
      final repository = ref.read(ptContractRepositoryProvider);
      await repository.approveScheduleChange(
        appointmentId: appointmentId,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> rejectScheduleChange({
    required int appointmentId,
  }) async {
    try {
      final repository = ref.read(ptContractRepositoryProvider);
      await repository.rejectScheduleChange(
        appointmentId: appointmentId,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> trainerRequestScheduleChange({
    required int appointmentId,
    required String newStartTime,
    required String newEndTime,
  }) async {
    try {
      final repository = ref.read(ptContractRepositoryProvider);
      await repository.trainerRequestScheduleChange(
        appointmentId: appointmentId,
        newStartTime: newStartTime,
        newEndTime: newEndTime,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> memberApproveScheduleChange({
    required int appointmentId,
  }) async {
    try {
      final repository = ref.read(ptContractRepositoryProvider);
      await repository.memberApproveScheduleChange(
        appointmentId: appointmentId,
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<PtSession> createPtSession(PtSessionCreate sessionData) async {
    try {
      final repository = ref.read(ptContractRepositoryProvider);
      return await repository.createPtSession(sessionData: sessionData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deletePtSession({required int ptSessionId}) async {
    try {
      final repository = ref.read(ptContractRepositoryProvider);
      await repository.deletePtSession(ptSessionId: ptSessionId);
    } catch (error) {
      rethrow;
    }
  }

  // PT 예약 관련 메서드들
  
  /// 내 예약 일정 조회
  Future<PtAppointmentsResponse> getMyScheduledAppointments({
    String? startDate,
    String? endDate,
    String? status,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final repository = ref.read(ptContractRepositoryProvider);
      return await repository.getMyScheduledAppointments(
        startDate: startDate,
        endDate: endDate,
        status: status,
        page: page,
        size: size,
      );
    } catch (error) {
      rethrow;
    }
  }

  /// [회원] 수업 일정 변경 요청
  Future<void> memberRequestScheduleChange({
    required int appointmentId,
    required String newStartTime,
    required String newEndTime,
  }) async {
    try {
      final repository = ref.read(ptContractRepositoryProvider);
      await repository.memberRequestScheduleChange(
        appointmentId: appointmentId,
        newStartTime: newStartTime,
        newEndTime: newEndTime,
      );
    } catch (error) {
      rethrow;
    }
  }

  /// [회원] 트레이너의 수업 변경 요청 승인
  Future<void> memberApproveTrainerChangeRequest({
    required int appointmentId,
  }) async {
    try {
      final repository = ref.read(ptContractRepositoryProvider);
      await repository.memberApproveTrainerChangeRequest(
        appointmentId: appointmentId,
      );
    } catch (error) {
      rethrow;
    }
  }

  /// 수업 변경 거절
  Future<void> rejectAppointmentChange({
    required int appointmentId,
  }) async {
    try {
      final repository = ref.read(ptContractRepositoryProvider);
      await repository.rejectAppointmentChange(
        appointmentId: appointmentId,
      );
    } catch (error) {
      rethrow;
    }
  }

  /// 수업 변경 승인
  Future<void> approveAppointmentChange({
    required int appointmentId,
  }) async {
    try {
      final repository = ref.read(ptContractRepositoryProvider);
      await repository.approveAppointmentChange(
        appointmentId: appointmentId,
      );
    } catch (error) {
      rethrow;
    }
  }
}