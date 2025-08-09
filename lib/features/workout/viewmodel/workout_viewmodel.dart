import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/features/workout/model/workout_model.dart';
import 'package:pt_service/features/workout/repository/workout_repository.dart';
import 'package:pt_service/core/providers/auth_provider.dart';

class WorkoutViewModel extends StateNotifier<AsyncValue<void>> {
  final WorkoutRepository _repository;
  final String _userId;
  
  WorkoutViewModel(this._repository, this._userId) : super(const AsyncValue.data(null));
  
  Future<void> addWorkout({
    required String title,
    required DateTime date,
    required WorkoutType type,
    required int duration,
    String? description,
    List<Exercise>? exercises,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      await _repository.addWorkout(
        userId: _userId,
        title: title,
        date: date,
        type: type,
        duration: duration,
        description: description,
        exercises: exercises ?? [],
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> updateWorkout(WorkoutRecord workout) async {
    state = const AsyncValue.loading();
    
    try {
      await _repository.updateWorkout(workout);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> deleteWorkout(String workoutId) async {
    state = const AsyncValue.loading();
    
    try {
      await _repository.deleteWorkout(workoutId);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final workoutViewModelProvider = StateNotifierProvider<WorkoutViewModel, AsyncValue<void>>((ref) {
  final repository = ref.watch(workoutRepositoryProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    throw Exception('User not logged in');
  }
  return WorkoutViewModel(repository, user.id);
});

final workoutListProvider = FutureProvider<List<WorkoutRecord>>((ref) async {
  final repository = ref.watch(workoutRepositoryProvider);
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return [];
  }
  return repository.getWorkouts(user.id);
});