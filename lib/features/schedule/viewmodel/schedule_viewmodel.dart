import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/features/schedule/model/pt_schedule_model.dart';
import 'package:pt_service/features/schedule/repository/schedule_repository.dart';
import 'package:pt_service/core/providers/auth_provider.dart';

class ScheduleViewModel extends StateNotifier<AsyncValue<void>> {
  final ScheduleRepository _repository;
  
  ScheduleViewModel(this._repository) : super(const AsyncValue.data(null));
  
  Future<void> addSchedule({
    required String trainerId,
    required String trainerName,
    required String memberName,
    required DateTime dateTime,
    required int durationMinutes,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      await _repository.addSchedule(
        trainerId: trainerId,
        trainerName: trainerName,
        memberId: '1', // Mock member ID
        memberName: memberName,
        dateTime: dateTime,
        durationMinutes: durationMinutes,
        notes: notes,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> updateSchedule(PTSchedule schedule) async {
    state = const AsyncValue.loading();
    
    try {
      await _repository.updateSchedule(schedule);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> updateScheduleStatus(String scheduleId, PTScheduleStatus status) async {
    state = const AsyncValue.loading();
    
    try {
      await _repository.updateScheduleStatus(scheduleId, status);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> deleteSchedule(String scheduleId) async {
    state = const AsyncValue.loading();
    
    try {
      await _repository.deleteSchedule(scheduleId);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final scheduleViewModelProvider = StateNotifierProvider<ScheduleViewModel, AsyncValue<void>>((ref) {
  final repository = ref.watch(scheduleRepositoryProvider);
  return ScheduleViewModel(repository);
});

final ptScheduleListProvider = FutureProvider<List<PTSchedule>>((ref) async {
  final repository = ref.watch(scheduleRepositoryProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return [];
  }
  return repository.getSchedules(user.id, user.userType.name);
});