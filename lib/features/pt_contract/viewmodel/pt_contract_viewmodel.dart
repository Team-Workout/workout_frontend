import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/pt_contract_models.dart';
import '../model/pt_session_models.dart';
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
}