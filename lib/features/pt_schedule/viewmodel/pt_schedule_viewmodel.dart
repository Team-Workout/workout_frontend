import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/pt_schedule_models.dart';
import '../repository/pt_schedule_repository.dart';
import '../../pt_contract/viewmodel/pt_contract_viewmodel.dart';

part 'pt_schedule_viewmodel.g.dart';

@riverpod
class PtScheduleViewModel extends _$PtScheduleViewModel {
  @override
  FutureOr<List<PtSchedule>> build() async {
    return [];
  }

  Future<void> loadWeeklySchedule({
    required DateTime startDate,
    required DateTime endDate,
    String? status,
  }) async {
    state = const AsyncLoading();
    
    try {
      final repository = ref.read(ptScheduleRepositoryProvider);
      final appointments = await repository.getScheduledAppointments(
        startDate: _formatDate(startDate),
        endDate: _formatDate(endDate),
        status: status,
      );
      
      state = AsyncData(appointments);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> loadMonthlySchedule({
    required DateTime month,
    String? status,
  }) async {
    state = const AsyncLoading();
    
    try {
      final repository = ref.read(ptScheduleRepositoryProvider);
      final appointments = await repository.getMonthlySchedule(
        month: month,
        status: status,
      );
      
      state = AsyncData(appointments);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> loadTodaySchedule() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    print('📅 [TODAY_SCHEDULE] 오늘의 PT 조회 시작');
    print('📅 [TODAY_SCHEDULE] 현재 시간: $now');
    print('📅 [TODAY_SCHEDULE] 조회 날짜: ${_formatDate(today)}');
    print('📅 [TODAY_SCHEDULE] startDate = endDate = ${_formatDate(today)}');
    
    state = const AsyncLoading();
    
    try {
      final repository = ref.read(ptScheduleRepositoryProvider);
      final appointments = await repository.getScheduledAppointments(
        startDate: _formatDate(today),
        endDate: _formatDate(today), // 시작일과 종료일을 같게 설정하여 하루만 조회
        status: 'SCHEDULED',
      );
      
      print('📅 [TODAY_SCHEDULE] 조회 결과: ${appointments.length}건');
      for (int i = 0; i < appointments.length; i++) {
        final apt = appointments[i];
        print('📅 [TODAY_SCHEDULE] 항목 ${i + 1}: ${apt.memberName} - ${apt.startTime} - ${apt.status}');
      }
      
      state = AsyncData(appointments);
    } catch (error, stackTrace) {
      print('❌ [TODAY_SCHEDULE] 조회 오류: $error');
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> updateAppointmentStatus({
    required int appointmentId,
    required String status,
  }) async {
    try {
      await ref.read(ptContractViewModelProvider.notifier).updateAppointmentStatus(
        appointmentId: appointmentId,
        status: status,
      );
      
      // 상태 변경 후 현재 보고 있는 달의 스케줄을 다시 로드
      final currentMonth = DateTime.now();
      await loadMonthlySchedule(month: currentMonth, status: 'SCHEDULED');
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> requestScheduleChange({
    required int appointmentId,
    required DateTime newStartTime,
    required DateTime newEndTime,
  }) async {
    try {
      final startTimeString = newStartTime.toIso8601String();
      final endTimeString = newEndTime.toIso8601String();
      
      await ref.read(ptContractViewModelProvider.notifier).requestScheduleChange(
        appointmentId: appointmentId,
        newStartTime: startTimeString,
        newEndTime: endTimeString,
      );
      
      // 변경 요청 후 스케줄 새로고침
      final currentMonth = DateTime.now();
      await loadMonthlySchedule(month: currentMonth, status: 'SCHEDULED');
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> approveScheduleChange({
    required int appointmentId,
  }) async {
    try {
      await ref.read(ptContractViewModelProvider.notifier).approveScheduleChange(
        appointmentId: appointmentId,
      );
      
      // 승인 후 스케줄 새로고침
      final currentMonth = DateTime.now();
      await loadMonthlySchedule(month: currentMonth, status: 'SCHEDULED');
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> rejectScheduleChange({
    required int appointmentId,
  }) async {
    try {
      await ref.read(ptContractViewModelProvider.notifier).rejectScheduleChange(
        appointmentId: appointmentId,
      );
      
      // 거절 후 스케줄 새로고침
      final currentMonth = DateTime.now();
      await loadMonthlySchedule(month: currentMonth, status: 'SCHEDULED');
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> trainerRequestScheduleChange({
    required int appointmentId,
    required DateTime newStartTime,
    required DateTime newEndTime,
  }) async {
    try {
      final startTimeString = newStartTime.toIso8601String();
      final endTimeString = newEndTime.toIso8601String();
      
      await ref.read(ptContractViewModelProvider.notifier).trainerRequestScheduleChange(
        appointmentId: appointmentId,
        newStartTime: startTimeString,
        newEndTime: endTimeString,
      );
      
      // 변경 요청 후 스케줄 새로고침
      final currentMonth = DateTime.now();
      await loadMonthlySchedule(month: currentMonth, status: 'SCHEDULED');
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> memberApproveScheduleChange({
    required int appointmentId,
  }) async {
    try {
      await ref.read(ptContractViewModelProvider.notifier).memberApproveScheduleChange(
        appointmentId: appointmentId,
      );
      
      // 승인 후 스케줄 새로고침
      final currentMonth = DateTime.now();
      await loadMonthlySchedule(month: currentMonth, status: 'SCHEDULED');
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
  
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}