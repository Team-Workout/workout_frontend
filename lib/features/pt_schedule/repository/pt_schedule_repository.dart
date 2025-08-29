import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../model/pt_schedule_models.dart';

class PtScheduleRepository {
  final ApiService _apiService;

  PtScheduleRepository(this._apiService);

  Future<List<PtSchedule>> getScheduledAppointments({
    required String startDate,
    required String endDate,
    String? status,
  }) async {
    print('📅 PT 스케줄 조회 요청: $startDate ~ $endDate${status != null ? ', 상태: $status' : ''}');
    
    final queryParams = {
      'startDate': startDate,
      'endDate': endDate,
    };
    
    if (status != null) {
      queryParams['status'] = status;
    }
    
    final response = await _apiService.get(
      '/pt-appointments/me/scheduled',
      queryParameters: queryParams,
    );

    print('📅 API 응답: ${response.data}');

    if (response.data is List) {
      final schedules = <PtSchedule>[];
      for (final item in response.data as List) {
        try {
          final itemMap = item as Map<String, dynamic>;
          
          // status 필드가 없거나 빈 값이면 요청한 status로 설정
          if ((!itemMap.containsKey('status') || itemMap['status'] == null || itemMap['status'] == '') && status != null) {
            itemMap['status'] = status;
            print('📋 status 필드 수동 설정: $status');
          }
          
          print('📋 파싱 전 데이터: $itemMap');
          final schedule = PtSchedule.fromJson(itemMap);
          print('📋 파싱 후 상태: ${schedule.status}');
          schedules.add(schedule);
        } catch (e) {
          print('⚠️ 스케줄 파싱 오류: $e');
          print('⚠️ 문제 데이터: $item');
        }
      }
      print('📅 파싱된 스케줄 개수: ${schedules.length}');
      return schedules;
    }
    
    return [];
  }

  Future<List<PtSchedule>> getMonthlySchedule({
    required DateTime month,
    String? status,
  }) async {
    final List<PtSchedule> allAppointments = [];
    
    final monthStart = DateTime(month.year, month.month, 1);
    final monthEnd = DateTime(month.year, month.month + 1, 0);
    
    print('📅 월간 스케줄 조회 시작: ${_formatDate(monthStart)} ~ ${_formatDate(monthEnd)}${status != null ? ', 상태: $status' : ''}');
    
    DateTime currentStart = monthStart;
    int weekCount = 0;
    
    while (currentStart.isBefore(monthEnd) || currentStart.isAtSameMomentAs(monthEnd)) {
      DateTime currentEnd = currentStart.add(const Duration(days: 6));
      if (currentEnd.isAfter(monthEnd)) {
        currentEnd = monthEnd;
      }
      
      weekCount++;
      print('📅 ${weekCount}주차 조회: ${_formatDate(currentStart)} ~ ${_formatDate(currentEnd)}');
      
      final weeklyAppointments = await getScheduledAppointments(
        startDate: _formatDate(currentStart),
        endDate: _formatDate(currentEnd),
        status: status,
      );
      
      allAppointments.addAll(weeklyAppointments);
      
      currentStart = currentEnd.add(const Duration(days: 1));
    }
    
    print('📅 월간 총 ${allAppointments.length}개의 스케줄 조회 완료');
    return allAppointments;
  }
  
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

final ptScheduleRepositoryProvider = Provider<PtScheduleRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PtScheduleRepository(apiService);
});