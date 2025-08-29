import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/workout_api_service.dart';
import '../model/routine_models.dart';

class RoutineRepository {
  final WorkoutApiService _apiService;

  RoutineRepository(this._apiService);

  Future<List<RoutineResponse>> getMyRoutines() async {
    return await _apiService.getMyRoutines();
  }

  Future<RoutineResponse> getRoutineDetail(int routineId) async {
    return await _apiService.getRoutineDetail(routineId);
  }

  Future<void> deleteRoutine(int routineId) async {
    await _apiService.deleteRoutine(routineId);
  }

  Future<RoutineResponse> createRoutine(CreateRoutineRequest request) async {
    return await _apiService.createRoutine(request);
  }
}

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  final apiService = ref.watch(workoutApiServiceProvider);
  return RoutineRepository(apiService);
});