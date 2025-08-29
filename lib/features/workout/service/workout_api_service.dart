import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../model/workout_log_models.dart';
import '../model/routine_models.dart';

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

      // 루틴 만들기 -> 루틴 불러오기 !!!

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

  // 월별 운동 일지 목록 조회
  Future<List<Map<String, dynamic>>> getWorkoutLogsByMonth(
      int year, int month) async {
    try {
      final response = await _apiService.get(
        '/api/workout/me/logs/$year/$month',
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (errorMessage.contains('400')) {
        throw Exception('유효하지 않은 연도 또는 월입니다.');
      }
      throw Exception('월별 운동 기록 조회 실패: 서버 오류가 발생했습니다.');
    }
  }

  // 운동 일지 상세 조회
  Future<Map<String, dynamic>> getWorkoutLogDetail(int logId) async {
    try {
      final response = await _apiService.get(
        '/api/workout/logs/$logId',
      );
      return response.data;
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (errorMessage.contains('404')) {
        throw Exception('해당 운동 일지를 찾을 수 없습니다.');
      }
      throw Exception('운동 일지 상세 조회 실패: 서버 오류가 발생했습니다.');
    }
  }

  // 특정 날짜의 운동 기록 조회 (기존 메서드 유지)
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

  // 루틴 생성 API
  Future<RoutineResponse> createRoutine(CreateRoutineRequest request) async {
    try {
      final response = await _apiService.post(
        '/workout/routine',
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        return RoutineResponse.fromJson(response.data);
      } else {
        throw Exception('루틴 생성에 실패했습니다.');
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (errorMessage.contains('403')) {
        throw Exception('루틴 생성 권한이 없습니다.');
      } else if (errorMessage.contains('400')) {
        throw Exception('잘못된 요청입니다. 입력 데이터를 확인해주세요.');
      } else {
        throw Exception('루틴 생성 실패: 서버 오류가 발생했습니다.');
      }
    }
  }

  // 사용자 루틴 목록 조회 API
  Future<List<RoutineResponse>> getMyRoutines() async {
    try {
      final response = await _apiService.get('/workout/me/routines');

      if (response.data is List) {
        return (response.data as List)
            .map((json) => RoutineResponse.fromJson(json))
            .toList();
      } else {
        throw Exception('잘못된 응답 형식입니다.');
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (errorMessage.contains('403')) {
        throw Exception('루틴 조회 권한이 없습니다.');
      } else {
        throw Exception('루틴 목록 조회 실패: 서버 오류가 발생했습니다.');
      }
    }
  }

  // 루틴 상세 조회 API
  Future<RoutineResponse> getRoutineDetail(int routineId) async {
    try {
      final response = await _apiService.get('/workout/routine/$routineId');
      return RoutineResponse.fromJson(response.data);
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (errorMessage.contains('404')) {
        throw Exception('해당 루틴을 찾을 수 없습니다.');
      } else if (errorMessage.contains('403')) {
        throw Exception('루틴 조회 권한이 없습니다.');
      } else {
        throw Exception('루틴 상세 조회 실패: 서버 오류가 발생했습니다.');
      }
    }
  }

  // 루틴 삭제 API
  Future<void> deleteRoutine(int routineId) async {
    try {
      await _apiService.delete('/workout/routine/$routineId');
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (errorMessage.contains('404')) {
        throw Exception('해당 루틴을 찾을 수 없습니다.');
      } else if (errorMessage.contains('403')) {
        throw Exception('루틴 삭제 권한이 없습니다.');
      } else {
        throw Exception('루틴 삭제 실패: 서버 오류가 발생했습니다.');
      }
    }
  }
}

// Provider for WorkoutApiService
final workoutApiServiceProvider = Provider<WorkoutApiService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return WorkoutApiService(apiService);
});
