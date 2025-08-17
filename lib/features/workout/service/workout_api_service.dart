import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../model/workout_log_models.dart';

class WorkoutApiService {
  final ApiService _apiService;

  WorkoutApiService(this._apiService);

  // 운동 기록 저장 API
  Future<Map<String, dynamic>> saveWorkoutLog(WorkoutLogRequest request) async {
    try {
      
      final response = await _apiService.post(
        '/workout-logs',
        data: request.toJson(),
      );
      
      
      // 서버가 문자열로 응답하는 경우 처리
      if (response.data is String) {
        return {'message': response.data, 'success': true};
      } else if (response.data is Map<String, dynamic>) {
        return response.data;
      } else {
        return {'message': '운동 기록이 성공적으로 저장되었습니다.', 'success': true};
      }
    } catch (e) {
      
      final errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (errorMessage.contains('403')) {
        throw Exception('운동 기록 저장 권한이 없습니다.');
      } else if (errorMessage.contains('400')) {
        throw Exception('잘못된 요청입니다. 입력 데이터를 확인해주세요.');
      } else {
        throw Exception('운동 기록 저장 실패: 서버 오류가 발생했습니다.');
      }
    }
  }

  // 운동 목록 조회 API (exerciseId를 위한 운동 목록)
  Future<List<Map<String, dynamic>>> getExerciseList() async {
    try {
      final response = await _apiService.get('/exercises');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw Exception('운동 목록 조회 실패: 서버 오류가 발생했습니다.');
    }
  }

  // 특정 날짜의 운동 기록 조회
  Future<Map<String, dynamic>> getWorkoutLogByDate(String date) async {
    try {
      final response = await _apiService.get(
        '/workout/log',
        queryParameters: {'date': date},
      );
      return response.data;
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('404')) {
        return {}; // 해당 날짜에 기록이 없는 경우
      }
      throw Exception('운동 기록 조회 실패: 서버 오류가 발생했습니다.');
    }
  }
}

// Provider for WorkoutApiService
final workoutApiServiceProvider = Provider<WorkoutApiService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return WorkoutApiService(apiService);
});