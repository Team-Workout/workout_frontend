import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/sync_service.dart';
import '../model/sync_models.dart';

/// 동기화 상태를 나타내는 클래스
class SyncState {
  final bool isLoading;
  final bool isCompleted;
  final String? error;
  final String? message;
  final List<String> updatedCategories;

  SyncState({
    this.isLoading = false,
    this.isCompleted = false,
    this.error,
    this.message,
    this.updatedCategories = const [],
  });

  SyncState copyWith({
    bool? isLoading,
    bool? isCompleted,
    String? error,
    String? message,
    List<String>? updatedCategories,
  }) {
    return SyncState(
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
      error: error ?? this.error,
      message: message ?? this.message,
      updatedCategories: updatedCategories ?? this.updatedCategories,
    );
  }
}

/// 동기화 상태 관리 Notifier
class SyncNotifier extends StateNotifier<SyncState> {
  final SyncService _syncService;

  SyncNotifier(this._syncService) : super(SyncState());

  /// 마스터 데이터 동기화 수행
  Future<void> performSync() async {
    state = state.copyWith(isLoading: true, error: null, message: null);

    try {
      final result = await _syncService.performSync();

      if (result.success) {
        state = state.copyWith(
          isLoading: false,
          isCompleted: true,
          message: result.message,
          updatedCategories: result.updatedCategories,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '동기화 중 오류가 발생했습니다: $e',
      );
    }
  }

  /// 동기화 상태 초기화
  void resetState() {
    state = SyncState();
  }

  /// 캐시 초기화 (개발용)
  Future<void> clearCache() async {
    try {
      await _syncService.clearCache();
      state = state.copyWith(
        message: '캐시가 초기화되었습니다',
        isCompleted: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: '캐시 초기화 실패: $e',
      );
    }
  }
}

/// 동기화 상태 Provider
final syncNotifierProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  final syncService = ref.watch(syncServiceProvider);
  return SyncNotifier(syncService);
});

/// 캐시된 운동 데이터 Provider
final cachedExercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final syncService = ref.watch(syncServiceProvider);
  return await syncService.getCachedExercises();
});

/// 캐시된 근육 데이터 Provider
final cachedMusclesProvider = FutureProvider<List<Muscle>>((ref) async {
  final syncService = ref.watch(syncServiceProvider);
  return await syncService.getCachedMuscles();
});

/// 캐시된 운동-근육 매핑 데이터 Provider
final cachedExerciseTargetMusclesProvider = FutureProvider<List<ExerciseTargetMuscleMapping>>((ref) async {
  final syncService = ref.watch(syncServiceProvider);
  return await syncService.getCachedExerciseTargetMuscles();
});

/// 앱 초기화 완료 상태 Provider
final appInitializationProvider = FutureProvider<bool>((ref) async {
  // 단순히 앱이 초기화되었음을 알리는 Provider
  await Future.delayed(const Duration(milliseconds: 100));
  return true;
});