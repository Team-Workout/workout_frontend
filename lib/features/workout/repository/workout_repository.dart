import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/features/workout/model/workout_model.dart';

abstract class WorkoutRepository {
  Future<List<WorkoutRecord>> getWorkouts(String userId);
  Future<WorkoutRecord> addWorkout({
    required String userId,
    required String title,
    required DateTime date,
    required WorkoutType type,
    required int duration,
    String? description,
    required List<Exercise> exercises,
  });
  Future<void> updateWorkout(WorkoutRecord workout);
  Future<void> deleteWorkout(String workoutId);
}

class MockWorkoutRepository implements WorkoutRepository {
  final List<WorkoutRecord> _workouts = [
    WorkoutRecord(
      id: '1',
      userId: '2',
      title: '오전 상체 운동',
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: WorkoutType.upperBody,
      duration: 60,
      description: '좋은 컨디션으로 운동 완료',
      trainerId: '1',
      exercises: [
        const Exercise(
          name: '벤치 프레스',
          sets: 4,
          reps: 12,
          weight: 60,
        ),
        const Exercise(
          name: '덤벨 플라이',
          sets: 3,
          reps: 15,
          weight: 10,
        ),
        const Exercise(
          name: '랫 풀다운',
          sets: 4,
          reps: 12,
          weight: 40,
        ),
      ],
    ),
    WorkoutRecord(
      id: '2',
      userId: '2',
      title: '하체 운동',
      date: DateTime.now().subtract(const Duration(days: 4)),
      type: WorkoutType.lowerBody,
      duration: 45,
      trainerId: '1',
      exercises: [
        const Exercise(
          name: '스쿼트',
          sets: 4,
          reps: 15,
          weight: 80,
        ),
        const Exercise(
          name: '런지',
          sets: 3,
          reps: 12,
        ),
        const Exercise(
          name: '레그 컴',
          sets: 3,
          reps: 15,
          weight: 60,
        ),
      ],
    ),
  ];
  
  @override
  Future<List<WorkoutRecord>> getWorkouts(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _workouts.where((w) => w.userId == userId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
  
  @override
  Future<WorkoutRecord> addWorkout({
    required String userId,
    required String title,
    required DateTime date,
    required WorkoutType type,
    required int duration,
    String? description,
    required List<Exercise> exercises,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final workout = WorkoutRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      title: title,
      date: date,
      type: type,
      duration: duration,
      description: description,
      exercises: exercises,
      createdAt: DateTime.now(),
    );
    
    _workouts.add(workout);
    return workout;
  }
  
  @override
  Future<void> updateWorkout(WorkoutRecord workout) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _workouts.indexWhere((w) => w.id == workout.id);
    if (index != -1) {
      _workouts[index] = workout.copyWith(updatedAt: DateTime.now());
    }
  }
  
  @override
  Future<void> deleteWorkout(String workoutId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _workouts.removeWhere((w) => w.id == workoutId);
  }
}

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return MockWorkoutRepository();
});