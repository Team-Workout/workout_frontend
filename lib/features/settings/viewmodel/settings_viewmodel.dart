import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/settings_repository.dart';

final workoutLogAccessProvider = StateNotifierProvider<WorkoutLogAccessNotifier, AsyncValue<bool>>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return WorkoutLogAccessNotifier(repository);
});

class WorkoutLogAccessNotifier extends StateNotifier<AsyncValue<bool>> {
  final SettingsRepository _repository;

  WorkoutLogAccessNotifier(this._repository) : super(const AsyncValue.data(false));

  Future<void> toggleWorkoutLogAccess(bool isOpen) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateWorkoutLogAccess(isOpen: isOpen);
      state = AsyncValue.data(isOpen);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}