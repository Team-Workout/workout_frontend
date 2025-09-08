class WorkoutLogRequest {
  final String workoutDate;
  final String? logFeedback;
  final List<WorkoutExercise> workoutExercises;

  WorkoutLogRequest({
    required this.workoutDate,
    this.logFeedback,
    required this.workoutExercises,
  });

  Map<String, dynamic> toJson() => {
    'workoutDate': workoutDate,
    if (logFeedback != null && logFeedback!.isNotEmpty) 
      'logFeedback': logFeedback,
    'workoutExercises': workoutExercises.map((e) => e.toJson()).toList(),
  };
}

class WorkoutExercise {
  final int exerciseId;
  final String? exerciseName; // 로컬 저장을 위한 운동 이름 추가
  final String? exerciseMemo; // 운동 메모 추가
  final int logOrder;
  final List<WorkoutSetData> workoutSets;

  WorkoutExercise({
    required this.exerciseId,
    this.exerciseName,
    this.exerciseMemo,
    required this.logOrder,
    required this.workoutSets,
  });

  Map<String, dynamic> toJson() => {
    'exerciseId': exerciseId,
    'logOrder': logOrder,
    'workoutSets': workoutSets.map((s) => s.toJson()).toList(),
    if (exerciseMemo != null && exerciseMemo!.isNotEmpty)
      'memo': exerciseMemo,
  };
}

class WorkoutSetData {
  final int setNumber;
  final double weight;
  final int reps;
  final String? feedback;

  WorkoutSetData({
    required this.setNumber,
    required this.weight,
    required this.reps,
    this.feedback,
  });

  Map<String, dynamic> toJson() => {
    'setNumber': setNumber,
    'weight': weight.toInt(),
    'reps': reps,
    if (feedback != null && feedback!.isNotEmpty) 
      'feedback': feedback,
  };
}