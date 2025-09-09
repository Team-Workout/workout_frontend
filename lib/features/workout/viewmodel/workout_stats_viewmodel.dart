import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/workout_stats_models.dart';
import '../service/workout_api_service.dart';
import '../service/local_storage_service.dart';

class WorkoutStatsViewmodel extends ChangeNotifier {
  final WorkoutApiService _apiService;
  final LocalStorageService _localStorageService;

  WorkoutStatsViewmodel(this._apiService, this._localStorageService);

  // 현재 선택된 기간
  StatsPeriod _selectedPeriod = StatsPeriod.threeMonths;
  StatsPeriod get selectedPeriod => _selectedPeriod;

  // 로딩 상태
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 통계 데이터
  WorkoutStatsResponse? _statsData;
  WorkoutStatsResponse? get statsData => _statsData;

  // 에러 메시지
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // 선택된 운동 (필터링용)
  String? _selectedExercise;
  String? get selectedExercise => _selectedExercise;

  // 사용 가능한 운동 목록
  List<String> _availableExercises = [];
  List<String> get availableExercises => _availableExercises;

  void selectPeriod(StatsPeriod period) {
    if (_selectedPeriod != period) {
      _selectedPeriod = period;
      notifyListeners();
      loadWorkoutStats();
    }
  }

  void selectExercise(String? exerciseName) {
    _selectedExercise = exerciseName;
    notifyListeners();
  }

  // 현재 선택된 기간의 시작일과 종료일 계산
  DateRange getCurrentDateRange() {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: _selectedPeriod.days));
    
    return DateRange(
      startDate: DateFormat('yyyy-MM-dd').format(startDate),
      endDate: DateFormat('yyyy-MM-dd').format(endDate),
    );
  }

  // 운동 통계 로드
  Future<void> loadWorkoutStats() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final dateRange = getCurrentDateRange();
      
      // 서버에 통계 API가 있다면 서버에서 가져오고,
      // 없다면 로컬에서 계산
      try {
        final request = WorkoutStatsRequest(
          startDate: dateRange.startDate,
          endDate: dateRange.endDate,
        );
        _statsData = await _apiService.getWorkoutStats(request);
      } catch (serverError) {
        print('서버 통계 API 호출 실패, 로컬에서 계산: $serverError');
        _statsData = await _calculateStatsLocally(dateRange);
      }

      _updateAvailableExercises();
    } catch (e) {
      _errorMessage = e.toString();
      print('운동 통계 로드 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 로컬 데이터로부터 통계 계산
  Future<WorkoutStatsResponse> _calculateStatsLocally(DateRange dateRange) async {
    // SQLite에서 기간별 운동 기록 가져오기
    final workoutLogs = await _localStorageService.getWorkoutLogsByDateRange(
      dateRange.startDate, 
      dateRange.endDate
    );

    return _processWorkoutLogsToStats(workoutLogs, dateRange);
  }

  // 운동 로그를 통계 데이터로 변환
  WorkoutStatsResponse _processWorkoutLogsToStats(
    List<Map<String, dynamic>> workoutLogs,
    DateRange dateRange,
  ) {
    // 운동별로 데이터 그룹화
    Map<String, List<ExerciseSetData>> exerciseGroups = {};
    Set<String> workoutDates = {};
    int totalSets = 0;
    double totalVolume = 0;

    for (var log in workoutLogs) {
      final logDate = log['workout_date'] as String;
      workoutDates.add(logDate);
      
      final exercises = log['exercises'] as List<dynamic>;
      
      for (var exerciseData in exercises) {
        final exerciseName = exerciseData['exercise_name'] as String;
        final sets = exerciseData['sets'] as List<dynamic>;
        
        // 운동 이름 필터링 - 실제 운동 종류만 포함
        if (!_isValidExerciseName(exerciseName)) {
          continue;
        }
        
        if (!exerciseGroups.containsKey(exerciseName)) {
          exerciseGroups[exerciseName] = [];
        }
        
        for (var setData in sets) {
          final weight = (setData['weight'] as num).toDouble();
          final reps = setData['reps'] as int;
          final setVolume = weight * reps;
          
          totalSets++;
          totalVolume += setVolume;
          
          exerciseGroups[exerciseName]!.add(ExerciseSetData(
            date: logDate,
            setNumber: setData['set_number'] as int,
            weight: weight,
            reps: reps,
            feedback: setData['memo'] as String?,
          ));
        }
      }
    }

    // 운동별 통계 계산
    List<ExerciseStats> exerciseStatsList = [];
    Map<String, int> exerciseFrequency = {};
    
    for (var entry in exerciseGroups.entries) {
      final exerciseName = entry.key;
      final sets = entry.value;
      
      exerciseFrequency[exerciseName] = sets.length;
      
      // 기본 통계 계산
      final weights = sets.map((s) => s.weight).toList();
      final maxWeight = weights.isNotEmpty ? weights.reduce((a, b) => a > b ? a : b) : 0.0;
      final avgWeight = weights.isNotEmpty ? weights.reduce((a, b) => a + b) / weights.length : 0.0;
      
      final volume = sets.fold<double>(0, (sum, set) => sum + (set.weight * set.reps));
      final estimatedOneRM = OneRMCalculator.calculateMax(sets);
      
      // 진행도 데이터 생성 (날짜별)
      final progressData = _calculateProgressData(sets);
      
      exerciseStatsList.add(ExerciseStats(
        exerciseId: 0, // 로컬 계산시에는 ID 없음
        exerciseName: exerciseName,
        sets: sets,
        maxWeight: maxWeight,
        avgWeight: avgWeight,
        totalSets: sets.length,
        totalReps: sets.fold(0, (sum, set) => sum + set.reps),
        totalVolume: volume,
        estimatedOneRM: estimatedOneRM,
        progressData: progressData,
      ));
    }

    // 요약 정보 생성
    final summary = WorkoutSummary(
      totalWorkoutDays: workoutDates.length,
      totalExercises: exerciseGroups.length,
      totalSets: totalSets,
      totalVolume: totalVolume,
      exerciseFrequency: exerciseFrequency,
    );

    return WorkoutStatsResponse(
      startDate: dateRange.startDate,
      endDate: dateRange.endDate,
      exercises: exerciseStatsList,
      summary: summary,
    );
  }

  // 진행도 데이터 계산 (날짜별)
  List<WorkoutProgress> _calculateProgressData(List<ExerciseSetData> sets) {
    // 날짜별로 세트 그룹화
    Map<String, List<ExerciseSetData>> dateGroups = {};
    
    for (var set in sets) {
      if (!dateGroups.containsKey(set.date)) {
        dateGroups[set.date] = [];
      }
      dateGroups[set.date]!.add(set);
    }

    // 날짜별 통계 계산
    List<WorkoutProgress> progressList = [];
    
    for (var entry in dateGroups.entries) {
      final date = entry.key;
      final dateSets = entry.value;
      
      final weights = dateSets.map((s) => s.weight).toList();
      final maxWeight = weights.reduce((a, b) => a > b ? a : b);
      final avgWeight = weights.reduce((a, b) => a + b) / weights.length;
      final volume = dateSets.fold<double>(0, (sum, set) => sum + (set.weight * set.reps));
      final estimatedOneRM = OneRMCalculator.calculateMax(dateSets);
      
      progressList.add(WorkoutProgress(
        date: date,
        maxWeight: maxWeight,
        avgWeight: avgWeight,
        volume: volume,
        estimatedOneRM: estimatedOneRM,
      ));
    }

    // 날짜순 정렬
    progressList.sort((a, b) => a.date.compareTo(b.date));
    
    return progressList;
  }

  // 사용 가능한 운동 목록 업데이트
  void _updateAvailableExercises() {
    if (_statsData != null) {
      _availableExercises = _statsData!.exercises
          .map((e) => e.exerciseName)
          .toList()
        ..sort();
    }
  }

  // 필터링된 운동 데이터 가져오기
  List<ExerciseStats> getFilteredExercises() {
    if (_statsData == null) return [];
    
    if (_selectedExercise == null) {
      return _statsData!.exercises;
    }
    
    return _statsData!.exercises
        .where((e) => e.exerciseName == _selectedExercise)
        .toList();
  }

  // 특정 운동의 통계 가져오기
  ExerciseStats? getExerciseStats(String exerciseName) {
    if (_statsData == null) return null;
    
    try {
      return _statsData!.exercises
          .firstWhere((e) => e.exerciseName == exerciseName);
    } catch (e) {
      return null;
    }
  }

  // 초기화
  Future<void> initialize() async {
    await loadWorkoutStats();
  }

  // 유효한 운동 이름인지 확인 (루틴 이름이나 기타 필터링)
  bool _isValidExerciseName(String exerciseName) {
    if (exerciseName.trim().isEmpty) return false;
    
    final trimmedName = exerciseName.trim();
    final lowerName = trimmedName.toLowerCase();
    
    // 루틴 이름으로 보이는 패턴 필터링
    final routinePatterns = [
      '루틴',
      'routine',
      '운동 프로그램',
      '프로그램',
      '세트',
      '일정',
      '스케줄',
      '계획',
      'plan',
      'program',
      '주차',
      'week',
      'day',
      '일차',
    ];
    
    // 루틴 관련 키워드가 포함된 경우 제외
    for (var pattern in routinePatterns) {
      if (lowerName.contains(pattern.toLowerCase())) {
        return false;
      }
    }
    
    // 숫자로만 구성된 경우 제외 (ID 같은 값)
    if (RegExp(r'^\d+$').hasMatch(trimmedName)) {
      return false;
    }
    
    // 너무 긴 이름은 제외 (루틴 설명일 가능성)
    if (trimmedName.length > 50) {
      return false;
    }
    
    // Exercise로 시작하는 기본 패턴 제외 (Exercise 1, Exercise 123 등)
    if (RegExp(r'^exercise\s*\d+$', caseSensitive: false).hasMatch(trimmedName)) {
      return false;
    }
    
    // 일반적인 운동 종류인지 확인 (선택적 - 너무 제한적일 수 있음)
    final commonExercisePatterns = [
      'squat', '스쿼트',
      'deadlift', '데드리프트',
      'bench', '벤치',
      'press', '프레스',
      'curl', '컬',
      'row', '로우',
      'pull', '풀',
      'push', '푸시',
      'fly', '플라이',
      'raise', '레이즈',
      'extension', '익스텐션',
      'crunch', '크런치',
      'plank', '플랭크',
      'lunge', '런지',
      'dip', '딥',
      '턱걸이', '팔굽혀펜기',
    ];
    
    // 일반적인 운동 패턴이 포함되어 있으면 허용
    for (var pattern in commonExercisePatterns) {
      if (lowerName.contains(pattern.toLowerCase())) {
        return true;
      }
    }
    
    // 한글이나 영어로만 구성되고 적절한 길이면 허용 (보수적 접근)
    if (RegExp(r'^[가-힣a-zA-Z\s\-()]+$').hasMatch(trimmedName) && 
        trimmedName.length >= 2 && trimmedName.length <= 30) {
      return true;
    }
    
    return false;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// 날짜 범위 클래스
class DateRange {
  final String startDate;
  final String endDate;

  DateRange({required this.startDate, required this.endDate});
}