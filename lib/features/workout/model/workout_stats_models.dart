import 'dart:math' as math;

// 운동 통계 요청 모델
class WorkoutStatsRequest {
  final String startDate;
  final String endDate;

  const WorkoutStatsRequest({
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() => {
        'startDate': startDate,
        'endDate': endDate,
      };

  factory WorkoutStatsRequest.fromJson(Map<String, dynamic> json) =>
      WorkoutStatsRequest(
        startDate: json['startDate'] as String,
        endDate: json['endDate'] as String,
      );
}

// 운동별 세트 데이터 모델
class ExerciseSetData {
  final String date;
  final int setNumber;
  final double weight;
  final int reps;
  final String? feedback;

  const ExerciseSetData({
    required this.date,
    required this.setNumber,
    required this.weight,
    required this.reps,
    this.feedback,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'setNumber': setNumber,
        'weight': weight,
        'reps': reps,
        if (feedback != null) 'feedback': feedback,
      };

  factory ExerciseSetData.fromJson(Map<String, dynamic> json) =>
      ExerciseSetData(
        date: json['date'] as String,
        setNumber: json['setNumber'] as int,
        weight: (json['weight'] as num).toDouble(),
        reps: json['reps'] as int,
        feedback: json['feedback'] as String?,
      );
}

// 진행도 데이터 모델 (차트용)
class WorkoutProgress {
  final String date;
  final double maxWeight;
  final double avgWeight;
  final double volume;
  final double estimatedOneRM;

  const WorkoutProgress({
    required this.date,
    required this.maxWeight,
    required this.avgWeight,
    required this.volume,
    required this.estimatedOneRM,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'maxWeight': maxWeight,
        'avgWeight': avgWeight,
        'volume': volume,
        'estimatedOneRM': estimatedOneRM,
      };

  factory WorkoutProgress.fromJson(Map<String, dynamic> json) =>
      WorkoutProgress(
        date: json['date'] as String,
        maxWeight: (json['maxWeight'] as num).toDouble(),
        avgWeight: (json['avgWeight'] as num).toDouble(),
        volume: (json['volume'] as num).toDouble(),
        estimatedOneRM: (json['estimatedOneRM'] as num).toDouble(),
      );
}

// 운동별 통계 데이터 모델
class ExerciseStats {
  final int exerciseId;
  final String exerciseName;
  final List<ExerciseSetData> sets;
  final double maxWeight;
  final double avgWeight;
  final int totalSets;
  final int totalReps;
  final double totalVolume;
  final double estimatedOneRM;
  final List<WorkoutProgress> progressData;

  const ExerciseStats({
    required this.exerciseId,
    required this.exerciseName,
    required this.sets,
    required this.maxWeight,
    required this.avgWeight,
    required this.totalSets,
    required this.totalReps,
    required this.totalVolume,
    required this.estimatedOneRM,
    required this.progressData,
  });

  Map<String, dynamic> toJson() => {
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'sets': sets.map((s) => s.toJson()).toList(),
        'maxWeight': maxWeight,
        'avgWeight': avgWeight,
        'totalSets': totalSets,
        'totalReps': totalReps,
        'totalVolume': totalVolume,
        'estimatedOneRM': estimatedOneRM,
        'progressData': progressData.map((p) => p.toJson()).toList(),
      };

  factory ExerciseStats.fromJson(Map<String, dynamic> json) => ExerciseStats(
        exerciseId: json['exerciseId'] as int,
        exerciseName: json['exerciseName'] as String,
        sets: (json['sets'] as List)
            .map((s) => ExerciseSetData.fromJson(s as Map<String, dynamic>))
            .toList(),
        maxWeight: (json['maxWeight'] as num).toDouble(),
        avgWeight: (json['avgWeight'] as num).toDouble(),
        totalSets: json['totalSets'] as int,
        totalReps: json['totalReps'] as int,
        totalVolume: (json['totalVolume'] as num).toDouble(),
        estimatedOneRM: (json['estimatedOneRM'] as num).toDouble(),
        progressData: (json['progressData'] as List)
            .map((p) => WorkoutProgress.fromJson(p as Map<String, dynamic>))
            .toList(),
      );
}

// 운동 요약 정보
class WorkoutSummary {
  final int totalWorkoutDays;
  final int totalExercises;
  final int totalSets;
  final double totalVolume;
  final Map<String, int> exerciseFrequency;

  const WorkoutSummary({
    required this.totalWorkoutDays,
    required this.totalExercises,
    required this.totalSets,
    required this.totalVolume,
    required this.exerciseFrequency,
  });

  Map<String, dynamic> toJson() => {
        'totalWorkoutDays': totalWorkoutDays,
        'totalExercises': totalExercises,
        'totalSets': totalSets,
        'totalVolume': totalVolume,
        'exerciseFrequency': exerciseFrequency,
      };

  factory WorkoutSummary.fromJson(Map<String, dynamic> json) => WorkoutSummary(
        totalWorkoutDays: json['totalWorkoutDays'] as int,
        totalExercises: json['totalExercises'] as int,
        totalSets: json['totalSets'] as int,
        totalVolume: (json['totalVolume'] as num).toDouble(),
        exerciseFrequency: Map<String, int>.from(json['exerciseFrequency'] as Map),
      );
}

// 전체 통계 응답 모델
class WorkoutStatsResponse {
  final String startDate;
  final String endDate;
  final List<ExerciseStats> exercises;
  final WorkoutSummary summary;

  const WorkoutStatsResponse({
    required this.startDate,
    required this.endDate,
    required this.exercises,
    required this.summary,
  });

  Map<String, dynamic> toJson() => {
        'startDate': startDate,
        'endDate': endDate,
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'summary': summary.toJson(),
      };

  factory WorkoutStatsResponse.fromJson(Map<String, dynamic> json) =>
      WorkoutStatsResponse(
        startDate: json['startDate'] as String,
        endDate: json['endDate'] as String,
        exercises: (json['exercises'] as List)
            .map((e) => ExerciseStats.fromJson(e as Map<String, dynamic>))
            .toList(),
        summary: WorkoutSummary.fromJson(json['summary'] as Map<String, dynamic>),
      );
}

// 기간 필터 열거형
enum StatsPeriod {
  oneMonth('1개월', 30),
  threeMonths('3개월', 90),
  sixMonths('6개월', 180),
  oneYear('1년', 365);

  const StatsPeriod(this.label, this.days);
  final String label;
  final int days;
}

// 1RM 계산 공식 열거형
enum OneRMFormula {
  epley('Epley'),
  brzycki('Brzycki'),
  lander('Lander'),
  lombardi('Lombardi');

  const OneRMFormula(this.label);
  final String label;
}

// 1RM 계산 유틸리티 클래스
class OneRMCalculator {
  // Epley 공식: 1RM = weight * (1 + reps/30)
  static double epley(double weight, int reps) {
    if (reps <= 1) return weight;
    return weight * (1 + reps / 30);
  }

  // Brzycki 공식: 1RM = weight / (1.0278 - 0.0278 * reps)
  static double brzycki(double weight, int reps) {
    if (reps <= 1) return weight;
    return weight / (1.0278 - 0.0278 * reps);
  }

  // Lander 공식: 1RM = (100 * weight) / (101.3 - 2.67123 * reps)
  static double lander(double weight, int reps) {
    if (reps <= 1) return weight;
    return (100 * weight) / (101.3 - 2.67123 * reps);
  }

  // Lombardi 공식: 1RM = weight * reps^0.10
  static double lombardi(double weight, int reps) {
    if (reps <= 1) return weight;
    return weight * math.pow(reps, 0.10);
  }

  // 기본 공식 (Epley 사용)
  static double calculate(double weight, int reps,
      {OneRMFormula formula = OneRMFormula.epley}) {
    switch (formula) {
      case OneRMFormula.epley:
        return epley(weight, reps);
      case OneRMFormula.brzycki:
        return brzycki(weight, reps);
      case OneRMFormula.lander:
        return lander(weight, reps);
      case OneRMFormula.lombardi:
        return lombardi(weight, reps);
    }
  }

  // 여러 세트의 평균 1RM 계산
  static double calculateAverage(List<ExerciseSetData> sets,
      {OneRMFormula formula = OneRMFormula.epley}) {
    if (sets.isEmpty) return 0.0;

    double totalOneRM = 0.0;
    for (var set in sets) {
      totalOneRM += calculate(set.weight, set.reps, formula: formula);
    }

    return totalOneRM / sets.length;
  }

  // 최대 1RM 계산
  static double calculateMax(List<ExerciseSetData> sets,
      {OneRMFormula formula = OneRMFormula.epley}) {
    if (sets.isEmpty) return 0.0;

    double maxOneRM = 0.0;
    for (var set in sets) {
      final oneRM = calculate(set.weight, set.reps, formula: formula);
      if (oneRM > maxOneRM) {
        maxOneRM = oneRM;
      }
    }

    return maxOneRM;
  }
}