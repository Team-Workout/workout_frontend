import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../model/workout_log_models.dart';
import '../model/routine_models.dart';
import '../model/workout_stats_models.dart';

class WorkoutApiService {
  final ApiService _apiService;

  WorkoutApiService(this._apiService);

  // 운동 기록 저장 API
  Future<Map<String, dynamic>> saveWorkoutLog(WorkoutLogRequest request) async {
    try {
      final response = await _apiService.post(
        '/workout/logs',
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

  // 운동 목록 조회 API (deprecated - 동기화된 마스터 데이터 사용)
  // Future<List<Map<String, dynamic>>> getExerciseList() async {
  //   try {
  //     final response = await _apiService.get('/exercises');
  //     return List<Map<String, dynamic>>.from(response.data);
  //   } catch (e) {
  //     throw Exception('운동 목록 조회 실패: 서버 오류가 발생했습니다.');
  //   }
  // }

  // 월별 운동 일지 목록 조회
  Future<List<Map<String, dynamic>>> getWorkoutLogsByMonth(
      int year, int month) async {
    try {
      final response = await _apiService.get(
        '/workout/me/logs/$year/$month',
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
        '/workout/logs/$logId',
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

      print('🔍 루틴 생성 응답 - statusCode: ${response.statusCode}, data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        // 201 Created with empty body and Location header
        if (response.statusCode == 201 && (response.data == null || response.data == '')) {
          // Location 헤더에서 ID 추출
          final location = response.headers.value('location');
          print('📍 Location 헤더: $location');
          
          if (location != null) {
            // "/api/workout/routine/16" 형식에서 ID 추출
            final routineId = int.tryParse(location.split('/').last);
            if (routineId != null) {
              print('✅ 루틴 생성 성공 - ID: $routineId (Location 헤더에서 추출)');
              
              // 생성된 루틴의 상세 정보를 가져오기
              try {
                return await getRoutineDetail(routineId);
              } catch (detailError) {
                print('⚠️ 루틴 상세 조회 실패, 기본 응답 반환: $detailError');
                // 상세 조회가 실패해도 루틴은 생성되었으므로 기본 응답 반환
                return RoutineResponse(
                  id: routineId,
                  name: request.name ?? '새 루틴',
                  description: request.description,
                  routineExercises: request.routineExercises,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
              }
            }
          }
          
          // Location 헤더가 없거나 파싱 실패시 기본 응답
          print('⚠️ Location 헤더에서 ID 추출 실패, 기본 응답 반환');
          return RoutineResponse(
            id: 0, // 임시 ID
            name: request.name ?? '새 루틴',
            description: request.description,
            routineExercises: request.routineExercises,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
        // 서버에서 ID만 반환하는 경우 처리
        else if (response.data is Map<String, dynamic> && response.data['data'] is int) {
          final routineId = response.data['data'] as int;
          print('✅ 루틴 생성 성공 - ID: $routineId');
          
          // 생성된 루틴의 상세 정보를 가져오기
          try {
            return await getRoutineDetail(routineId);
          } catch (detailError) {
            print('⚠️ 루틴 상세 조회 실패, 기본 응답 반환: $detailError');
            // 상세 조회가 실패해도 루틴은 생성되었으므로 기본 응답 반환
            return RoutineResponse(
              id: routineId,
              name: request.name ?? '새 루틴',
              description: request.description,
              routineExercises: request.routineExercises,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
          }
        } else if (response.data is Map<String, dynamic> && response.data['data'] is Map<String, dynamic>) {
          // data 필드 안에 전체 객체가 있는 경우
          return RoutineResponse.fromJson(response.data['data']);
        } else if (response.data is Map<String, dynamic>) {
          // 전체 객체가 바로 반환되는 경우
          return RoutineResponse.fromJson(response.data);
        } else {
          throw Exception('예상치 못한 응답 형식입니다: ${response.data}');
        }
      } else {
        throw Exception('루틴 생성에 실패했습니다. 상태 코드: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('🚨 DioException 발생: ${e.response?.statusCode}, ${e.response?.data}');
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        switch (statusCode) {
          case 401:
            throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
          case 403:
            throw Exception('루틴 생성 권한이 없습니다.');
          case 400:
            throw Exception('잘못된 요청입니다. 입력 데이터를 확인해주세요.');
          default:
            throw Exception('루틴 생성 실패: 서버 오류가 발생했습니다. (${statusCode})');
        }
      } else {
        throw Exception('네트워크 연결을 확인해주세요.');
      }
    } catch (e) {
      print('🚨 예상치 못한 에러: $e');
      // 이미 Exception인 경우 그대로 전달
      if (e is Exception) {
        rethrow;
      }
      // 그 외의 경우에만 새로운 Exception 생성
      throw Exception('루틴 생성 실패: $e');
    }
  }

  // 사용자 루틴 목록 조회 API
  Future<List<RoutineResponse>> getMyRoutines() async {
    try {
      final response = await _apiService.get('/workout/me/routines');

      // 응답 구조: {"data": [...]}
      if (response.data is Map<String, dynamic> &&
          response.data['data'] is List) {
        return (response.data['data'] as List)
            .map((json) => RoutineResponse.fromJson(json))
            .toList();
      } else if (response.data is List) {
        // 기존 방식도 호환 유지
        return (response.data as List)
            .map((json) => RoutineResponse.fromJson(json))
            .toList();
      } else {
        print('🚨 예상치 못한 응답 형식: ${response.data}');
        throw Exception('잘못된 응답 형식입니다.');
      }
    } catch (e) {
      print('🚨 getMyRoutines 에러: $e');
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

      // 응답 구조: {"data": {...}}
      if (response.data is Map<String, dynamic> &&
          response.data['data'] is Map<String, dynamic>) {
        return RoutineResponse.fromJson(response.data['data']);
      } else if (response.data is Map<String, dynamic>) {
        // 기존 방식도 호환 유지
        return RoutineResponse.fromJson(response.data);
      } else {
        print('🚨 예상치 못한 루틴 디테일 응답 형식: ${response.data}');
        throw Exception('잘못된 응답 형식입니다.');
      }
    } catch (e) {
      print('🚨 getRoutineDetail 에러: $e');
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

  // 운동 통계 조회 API
  Future<WorkoutStatsResponse> getWorkoutStats(WorkoutStatsRequest request) async {
    try {
      final response = await _apiService.get(
        '/workout/logs/stats',
        queryParameters: {
          'startDate': request.startDate,
          'endDate': request.endDate,
        },
      );

      if (response.data is Map<String, dynamic>) {
        return WorkoutStatsResponse.fromJson(response.data);
      } else {
        throw Exception('예상치 못한 응답 형식입니다.');
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (errorMessage.contains('400')) {
        throw Exception('잘못된 요청입니다. 날짜 형식을 확인해주세요.');
      } else {
        throw Exception('운동 통계 조회 실패: 서버 오류가 발생했습니다.');
      }
    }
  }

  // 기간별 운동 로그 조회 (로컬에서 통계 계산용)
  Future<List<Map<String, dynamic>>> getWorkoutLogsByPeriod(
      String startDate, String endDate) async {
    try {
      final response = await _apiService.get(
        '/workout/logs/period',
        queryParameters: {
          'startDate': startDate,
          'endDate': endDate,
        },
      );

      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else if (response.data is Map<String, dynamic> &&
          response.data['data'] is List) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        return [];
      }
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('401')) {
        throw Exception('인증이 필요합니다. 다시 로그인해주세요.');
      } else if (errorMessage.contains('404')) {
        return []; // 해당 기간에 기록이 없는 경우
      } else {
        throw Exception('기간별 운동 기록 조회 실패: 서버 오류가 발생했습니다.');
      }
    }
  }
}

// Provider for WorkoutApiService
final workoutApiServiceProvider = Provider<WorkoutApiService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return WorkoutApiService(apiService);
});
