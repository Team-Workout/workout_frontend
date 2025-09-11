// 회원 루틴 조회 관련 모델들

// 루틴 내 세트 정보
class RoutineSet {
  final int workoutSetId;
  final int order;
  final double weight;
  final int reps;

  const RoutineSet({
    required this.workoutSetId,
    required this.order,
    required this.weight,
    required this.reps,
  });

  Map<String, dynamic> toJson() => {
        'workoutSetId': workoutSetId,
        'order': order,
        'weight': weight,
        'reps': reps,
      };

  factory RoutineSet.fromJson(Map<String, dynamic> json) => RoutineSet(
        workoutSetId: json['workoutSetId'] as int,
        order: json['order'] as int,
        weight: (json['weight'] as num).toDouble(),
        reps: json['reps'] as int,
      );
}

// 루틴 내 운동 정보
class RoutineExercise {
  final int routineExerciseId;
  final String exerciseName;
  final int order;
  final List<RoutineSet> routineSets;

  const RoutineExercise({
    required this.routineExerciseId,
    required this.exerciseName,
    required this.order,
    required this.routineSets,
  });

  Map<String, dynamic> toJson() => {
        'routineExerciseId': routineExerciseId,
        'exerciseName': exerciseName,
        'order': order,
        'routineSets': routineSets.map((s) => s.toJson()).toList(),
      };

  factory RoutineExercise.fromJson(Map<String, dynamic> json) =>
      RoutineExercise(
        routineExerciseId: json['routineExerciseId'] as int,
        exerciseName: json['exerciseName'] as String,
        order: json['order'] as int,
        routineSets: (json['routineSets'] as List)
            .map((s) => RoutineSet.fromJson(s as Map<String, dynamic>))
            .toList(),
      );
}

// 루틴 정보
class MemberRoutine {
  final int routineId;
  final String routineName;
  final String description;
  final List<RoutineExercise> routineExercises;

  const MemberRoutine({
    required this.routineId,
    required this.routineName,
    required this.description,
    required this.routineExercises,
  });

  Map<String, dynamic> toJson() => {
        'routineId': routineId,
        'routineName': routineName,
        'description': description,
        'routineExercises': routineExercises.map((e) => e.toJson()).toList(),
      };

  factory MemberRoutine.fromJson(Map<String, dynamic> json) => MemberRoutine(
        routineId: json['routineId'] as int,
        routineName: json['routineName'] as String,
        description: json['description'] as String,
        routineExercises: (json['routineExercises'] as List)
            .map((e) => RoutineExercise.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  // 총 운동 수 계산
  int get totalExercises => routineExercises.length;

  // 총 세트 수 계산
  int get totalSets =>
      routineExercises.fold(0, (sum, exercise) => sum + exercise.routineSets.length);

  // 예상 소요시간 계산 (운동당 3분, 세트당 1.5분 기준)
  int get estimatedDurationMinutes => (totalExercises * 3) + (totalSets * 1.5).round();
}

// 페이지 정보
class PageInfo {
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool last;

  const PageInfo({
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.last,
  });

  Map<String, dynamic> toJson() => {
        'page': page,
        'size': size,
        'totalElements': totalElements,
        'totalPages': totalPages,
        'last': last,
      };

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
        page: json['page'] as int,
        size: json['size'] as int,
        totalElements: json['totalElements'] as int,
        totalPages: json['totalPages'] as int,
        last: json['last'] as bool,
      );
}

// 회원 루틴 조회 응답
class MemberRoutineResponse {
  final List<MemberRoutine> data;
  final PageInfo? pageInfo;

  const MemberRoutineResponse({
    required this.data,
    this.pageInfo,
  });

  Map<String, dynamic> toJson() => {
        'data': data.map((r) => r.toJson()).toList(),
        if (pageInfo != null) 'pageInfo': pageInfo!.toJson(),
      };

  factory MemberRoutineResponse.fromJson(Map<String, dynamic> json) =>
      MemberRoutineResponse(
        data: (json['data'] as List)
            .map((r) => MemberRoutine.fromJson(r as Map<String, dynamic>))
            .toList(),
        pageInfo: json['pageInfo'] != null 
            ? PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>)
            : null,
      );
}