import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/sync_models.dart';
import '../repository/sync_repository.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  final syncRepository = ref.watch(syncRepositoryProvider);
  return SyncService(syncRepository);
});

class SyncService {
  final SyncRepository _syncRepository;
  
  // SharedPreferences keys for version storage
  static const String _versionKey = 'master_data_versions';
  static const String _exerciseDataKey = 'cached_exercises';
  static const String _muscleDataKey = 'cached_muscles';
  static const String _exerciseTargetMuscleDataKey = 'cached_exercise_target_muscles';

  SyncService(this._syncRepository);

  /// 현재 저장된 버전 정보 가져오기
  Future<Map<String, int>> getCurrentVersions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final versionsJson = prefs.getString(_versionKey);
      
      if (versionsJson != null) {
        final Map<String, dynamic> decoded = json.decode(versionsJson);
        return decoded.map((key, value) => MapEntry(key, value as int));
      }

      // 초기값: 모든 버전을 0으로 설정
      return {
        'EXERCISE': 0,
        'MUSCLE': 0,
        'EXERCISE_TARGET_MUSCLE': 0,
      };
    } catch (e) {
      print('getCurrentVersions error: $e');
      // 에러 발생 시 초기값 반환
      return {
        'EXERCISE': 0,
        'MUSCLE': 0,
        'EXERCISE_TARGET_MUSCLE': 0,
      };
    }
  }

  /// 버전 정보 저장
  Future<void> saveVersions(Map<String, int> versions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final versionsJson = json.encode(versions);
      await prefs.setString(_versionKey, versionsJson);
      print('Versions saved: $versions');
    } catch (e) {
      print('saveVersions error: $e');
      throw Exception('버전 정보 저장 실패: $e');
    }
  }

  /// 마스터 데이터 전체 동기화 수행
  Future<SyncResult> performSync() async {
    try {
      print('=== Master Data Sync Started ===');

      // 1. 현재 버전 정보 가져오기
      final currentVersions = await getCurrentVersions();
      print('Current versions: $currentVersions');

      // 2. 서버와 버전 비교
      final outdatedCategories = await _syncRepository.checkVersion(currentVersions);
      print('Outdated categories: $outdatedCategories');

      if (outdatedCategories.isEmpty) {
        print('All data is up to date');
        return SyncResult.success(
          message: '모든 데이터가 최신 버전입니다',
          updatedCategories: [],
        );
      }

      // 3. 필요한 카테고리 데이터 동기화
      final List<String> syncedCategories = [];
      Map<String, int> newVersions = Map.from(currentVersions);

      for (final category in outdatedCategories) {
        switch (category) {
          case 'EXERCISE':
            final exercises = await _syncRepository.syncExercises();
            await _cacheExercises(exercises);
            newVersions['EXERCISE'] = newVersions['EXERCISE']! + 1;
            syncedCategories.add('EXERCISE');
            break;
            
          case 'MUSCLE':
            final muscles = await _syncRepository.syncMuscles();
            await _cacheMuscles(muscles);
            newVersions['MUSCLE'] = newVersions['MUSCLE']! + 1;
            syncedCategories.add('MUSCLE');
            break;
            
          case 'EXERCISE_TARGET_MUSCLE':
            final mappings = await _syncRepository.syncExerciseTargetMuscles();
            await _cacheExerciseTargetMuscles(mappings);
            newVersions['EXERCISE_TARGET_MUSCLE'] = newVersions['EXERCISE_TARGET_MUSCLE']! + 1;
            syncedCategories.add('EXERCISE_TARGET_MUSCLE');
            break;
        }
      }

      // 4. 새 버전 정보 저장
      await saveVersions(newVersions);

      print('=== Master Data Sync Completed ===');
      print('Synced categories: $syncedCategories');
      
      return SyncResult.success(
        message: '마스터 데이터 동기화가 완료되었습니다',
        updatedCategories: syncedCategories,
      );

    } catch (e) {
      print('=== Master Data Sync Failed ===');
      print('Sync error: $e');
      return SyncResult.failure(
        error: '마스터 데이터 동기화 실패: $e',
      );
    }
  }

  /// 캐시된 운동 데이터 저장
  Future<void> _cacheExercises(List<Exercise> exercises) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final exercisesJson = json.encode(exercises.map((e) => e.toJson()).toList());
      await prefs.setString(_exerciseDataKey, exercisesJson);
      print('Cached ${exercises.length} exercises');
    } catch (e) {
      print('_cacheExercises error: $e');
    }
  }

  /// 캐시된 근육 데이터 저장
  Future<void> _cacheMuscles(List<Muscle> muscles) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final musclesJson = json.encode(muscles.map((m) => m.toJson()).toList());
      await prefs.setString(_muscleDataKey, musclesJson);
      print('Cached ${muscles.length} muscles');
    } catch (e) {
      print('_cacheMuscles error: $e');
    }
  }

  /// 캐시된 운동-근육 매핑 데이터 저장
  Future<void> _cacheExerciseTargetMuscles(List<ExerciseTargetMuscleMapping> mappings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final mappingsJson = json.encode(mappings.map((m) => m.toJson()).toList());
      await prefs.setString(_exerciseTargetMuscleDataKey, mappingsJson);
      print('Cached ${mappings.length} exercise target muscle mappings');
    } catch (e) {
      print('_cacheExerciseTargetMuscles error: $e');
    }
  }

  /// 캐시된 운동 데이터 가져오기
  Future<List<Exercise>> getCachedExercises() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final exercisesJson = prefs.getString(_exerciseDataKey);
      
      if (exercisesJson != null) {
        final List<dynamic> decoded = json.decode(exercisesJson);
        return decoded.map((json) => Exercise.fromJson(json as Map<String, dynamic>)).toList();
      }
      
      return [];
    } catch (e) {
      print('getCachedExercises error: $e');
      return [];
    }
  }

  /// 캐시된 근육 데이터 가져오기
  Future<List<Muscle>> getCachedMuscles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final musclesJson = prefs.getString(_muscleDataKey);
      
      if (musclesJson != null) {
        final List<dynamic> decoded = json.decode(musclesJson);
        return decoded.map((json) => Muscle.fromJson(json as Map<String, dynamic>)).toList();
      }
      
      return [];
    } catch (e) {
      print('getCachedMuscles error: $e');
      return [];
    }
  }

  /// 캐시된 운동-근육 매핑 데이터 가져오기
  Future<List<ExerciseTargetMuscleMapping>> getCachedExerciseTargetMuscles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final mappingsJson = prefs.getString(_exerciseTargetMuscleDataKey);
      
      if (mappingsJson != null) {
        final List<dynamic> decoded = json.decode(mappingsJson);
        return decoded.map((json) => ExerciseTargetMuscleMapping.fromJson(json as Map<String, dynamic>)).toList();
      }
      
      return [];
    } catch (e) {
      print('getCachedExerciseTargetMuscles error: $e');
      return [];
    }
  }

  /// 캐시 초기화 (개발/디버깅용)
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_versionKey);
      await prefs.remove(_exerciseDataKey);
      await prefs.remove(_muscleDataKey);
      await prefs.remove(_exerciseTargetMuscleDataKey);
      print('Master data cache cleared');
    } catch (e) {
      print('clearCache error: $e');
    }
  }
}

/// 동기화 결과를 나타내는 클래스
class SyncResult {
  final bool success;
  final String? message;
  final String? error;
  final List<String> updatedCategories;

  SyncResult._({
    required this.success,
    this.message,
    this.error,
    required this.updatedCategories,
  });

  factory SyncResult.success({
    required String message,
    required List<String> updatedCategories,
  }) {
    return SyncResult._(
      success: true,
      message: message,
      updatedCategories: updatedCategories,
    );
  }

  factory SyncResult.failure({
    required String error,
  }) {
    return SyncResult._(
      success: false,
      error: error,
      updatedCategories: [],
    );
  }
}