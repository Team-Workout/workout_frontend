import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/routine_models.dart';
import '../repository/routine_repository.dart';

class RoutineViewmodel extends StateNotifier<AsyncValue<List<RoutineResponse>>> {
  final RoutineRepository _repository;

  RoutineViewmodel(this._repository) : super(const AsyncValue.loading());

  Future<void> loadRoutines() async {
    state = const AsyncValue.loading();
    try {
      final routines = await _repository.getMyRoutines();
      state = AsyncValue.data(routines);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<RoutineResponse> getRoutineDetail(int routineId) async {
    try {
      return await _repository.getRoutineDetail(routineId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRoutine(int routineId) async {
    try {
      await _repository.deleteRoutine(routineId);
      await loadRoutines();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createRoutine(CreateRoutineRequest request) async {
    try {
      await _repository.createRoutine(request);
      await loadRoutines();
    } catch (e) {
      rethrow;
    }
  }
}

final routineProvider = StateNotifierProvider<RoutineViewmodel, AsyncValue<List<RoutineResponse>>>((ref) {
  final repository = ref.watch(routineRepositoryProvider);
  return RoutineViewmodel(repository);
});