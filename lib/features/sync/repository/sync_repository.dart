import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../model/sync_models.dart';

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return SyncRepository(dio);
});

class SyncRepository {
  final Dio _dio;

  SyncRepository(this._dio);

  /// 버전 확인 API
  Future<List<String>> checkVersion(Map<String, int> currentVersions) async {
    try {
      print('=== Version Check Debug ===');
      print('Current versions: $currentVersions');

      final request = VersionCheckRequest(versions: currentVersions);
      
      final response = await _dio.post(
        '/sync/check-version',
        data: request.toJson(),
      );

      print('Version check response: ${response.data}');

      if (response.data is List) {
        return (response.data as List<dynamic>)
            .map((e) => e.toString())
            .toList();
      }

      return [];
    } catch (e) {
      print('=== Version Check Error ===');
      if (e is DioException) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      print('Version check error: $e');
      throw Exception('버전 확인 실패: $e');
    }
  }

  /// 운동 데이터 동기화
  Future<List<Exercise>> syncExercises() async {
    try {
      print('=== Sync Exercises Debug ===');

      final response = await _dio.get('/sync/EXERCISE');

      print('Sync exercises response: ${response.data}');

      if (response.data is List) {
        return (response.data as List<dynamic>)
            .map((json) => Exercise.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      print('=== Sync Exercises Error ===');
      if (e is DioException) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      print('Sync exercises error: $e');
      throw Exception('운동 데이터 동기화 실패: $e');
    }
  }

  /// 근육 데이터 동기화
  Future<List<Muscle>> syncMuscles() async {
    try {
      print('=== Sync Muscles Debug ===');

      final response = await _dio.get('/sync/MUSCLE');

      print('Sync muscles response: ${response.data}');

      if (response.data is List) {
        return (response.data as List<dynamic>)
            .map((json) => Muscle.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      print('=== Sync Muscles Error ===');
      if (e is DioException) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      print('Sync muscles error: $e');
      throw Exception('근육 데이터 동기화 실패: $e');
    }
  }

  /// 운동-근육 매핑 데이터 동기화
  Future<List<ExerciseTargetMuscleMapping>> syncExerciseTargetMuscles() async {
    try {
      print('=== Sync Exercise Target Muscles Debug ===');

      final response = await _dio.get('/sync/EXERCISE_TARGET_MUSCLE');

      print('Sync exercise target muscles response: ${response.data}');

      if (response.data is List) {
        return (response.data as List<dynamic>)
            .map((json) => ExerciseTargetMuscleMapping.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      print('=== Sync Exercise Target Muscles Error ===');
      if (e is DioException) {
        print('Status code: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      print('Sync exercise target muscles error: $e');
      throw Exception('운동-근육 매핑 데이터 동기화 실패: $e');
    }
  }

  /// 특정 카테고리 데이터 동기화 (제네릭)
  Future<T> syncCategory<T>(DataCategory category) async {
    switch (category) {
      case DataCategory.exercise:
        return await syncExercises() as T;
      case DataCategory.muscle:
        return await syncMuscles() as T;
      case DataCategory.exerciseTargetMuscle:
        return await syncExerciseTargetMuscles() as T;
    }
  }
}