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
  final int logOrder;
  final List<WorkoutSetData> workoutSets;

  WorkoutExercise({
    required this.exerciseId,
    required this.logOrder,
    required this.workoutSets,
  });

  Map<String, dynamic> toJson() => {
    'exerciseId': exerciseId,
    'logOrder': logOrder,
    'workoutSets': workoutSets.map((s) => s.toJson()).toList(),
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