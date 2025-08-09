import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/features/schedule/model/pt_schedule_model.dart';

abstract class ScheduleRepository {
  Future<List<PTSchedule>> getSchedules(String userId, String userType);
  Future<PTSchedule> addSchedule({
    required String trainerId,
    required String trainerName,
    required String memberId,
    required String memberName,
    required DateTime dateTime,
    required int durationMinutes,
    String? notes,
  });
  Future<void> updateSchedule(PTSchedule schedule);
  Future<void> updateScheduleStatus(String scheduleId, PTScheduleStatus status);
  Future<void> deleteSchedule(String scheduleId);
}

class MockScheduleRepository implements ScheduleRepository {
  final List<PTSchedule> _schedules = [
    PTSchedule(
      id: '1',
      trainerId: '1',
      trainerName: '김트레이너',
      memberId: '2',
      memberName: '이회원',
      dateTime: DateTime.now().add(const Duration(hours: 2)),
      durationMinutes: 60,
      notes: '상체 운동 중심',
    ),
    PTSchedule(
      id: '2',
      trainerId: '1',
      trainerName: '김트레이너',
      memberId: '3',
      memberName: '박민수',
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 10)),
      durationMinutes: 45,
      status: PTScheduleStatus.scheduled,
    ),
    PTSchedule(
      id: '3',
      trainerId: '1',
      trainerName: '김트레이너',
      memberId: '2',
      memberName: '이회원',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      durationMinutes: 60,
      status: PTScheduleStatus.completed,
      notes: '하체 운동 완료',
    ),
    PTSchedule(
      id: '4',
      trainerId: '1',
      trainerName: '김트레이너',
      memberId: '2',
      memberName: '이회원',
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 14)),
      durationMinutes: 90,
      status: PTScheduleStatus.scheduled,
    ),
  ];
  
  @override
  Future<List<PTSchedule>> getSchedules(String userId, String userType) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (userType == 'trainer') {
      return _schedules.where((s) => s.trainerId == userId).toList()
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    } else {
      return _schedules.where((s) => s.memberId == userId).toList()
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    }
  }
  
  @override
  Future<PTSchedule> addSchedule({
    required String trainerId,
    required String trainerName,
    required String memberId,
    required String memberName,
    required DateTime dateTime,
    required int durationMinutes,
    String? notes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final schedule = PTSchedule(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      trainerId: trainerId,
      trainerName: trainerName,
      memberId: memberId,
      memberName: memberName,
      dateTime: dateTime,
      durationMinutes: durationMinutes,
      notes: notes,
      createdAt: DateTime.now(),
    );
    
    _schedules.add(schedule);
    return schedule;
  }
  
  @override
  Future<void> updateSchedule(PTSchedule schedule) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _schedules.indexWhere((s) => s.id == schedule.id);
    if (index != -1) {
      _schedules[index] = schedule.copyWith(updatedAt: DateTime.now());
    }
  }
  
  @override
  Future<void> updateScheduleStatus(String scheduleId, PTScheduleStatus status) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _schedules.indexWhere((s) => s.id == scheduleId);
    if (index != -1) {
      _schedules[index] = _schedules[index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
    }
  }
  
  @override
  Future<void> deleteSchedule(String scheduleId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _schedules.removeWhere((s) => s.id == scheduleId);
  }
}

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return MockScheduleRepository();
});