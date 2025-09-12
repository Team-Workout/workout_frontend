import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../model/workout_record_models.dart';
import '../model/workout_log_models.dart';
import '../model/routine_models.dart';
import '../service/workout_api_service.dart';
import '../service/local_storage_service.dart';
import '../../../core/providers/auth_provider.dart';

class WorkoutRecordViewmodel extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController diaryMemoController = TextEditingController();
  late final DateTime _today;
  late DateTime _selectedDate;
  late DateTime _focusedDate;
  bool _disposed = false;

  // 실시간 운동 기록 관리
  final List<WorkoutExerciseDetail> _exercises = [];
  
  // 변경사항 추적
  bool _hasChanges = false;
  bool get hasChanges => _hasChanges;
  
  // 초기 상태 저장 (변경사항 감지용)
  String _initialState = '';

  // API 서비스
  final WorkoutApiService _apiService;
  WorkoutApiService get workoutApiService => _apiService;
  final LocalStorageService _localStorageService;
  final AuthState _authState;

  WorkoutRecordViewmodel(
      this._apiService, this._localStorageService, this._authState) {
    // 오늘 날짜를 시간 정보 없이 정규화
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _selectedDate = _today;
    _focusedDate = _today;
  }

  // 운동 목록 (exerciseId를 위한)
  List<Map<String, dynamic>> _availableExercises = [];
  List<Map<String, dynamic>> get availableExercises => _availableExercises;

  // 로딩 상태
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 현재 로드된 운동기록 (SQLite 기반)
  final Map<DateTime, WorkoutDayRecord> _workoutEvents = {};

  // Getters
  DateTime get selectedDate => _selectedDate;
  DateTime get focusedDate => _focusedDate;
  List<WorkoutExerciseDetail> get exercises => List.unmodifiable(_exercises);
  Map<DateTime, WorkoutDayRecord> get workoutEvents =>
      Map.unmodifiable(_workoutEvents);
  LocalStorageService get localStorageService => _localStorageService;

  @override
  void dispose() {
    _disposed = true;
    titleController.dispose();
    diaryMemoController.dispose();
    for (var exercise in _exercises) {
      exercise.dispose();
    }
    super.dispose();
  }

  Future<void> initializeLocale() async {
    await initializeDateFormatting('ko');
    await _loadAvailableExercises();
    
    // 디버깅: 데이터베이스 상태 확인
    await _localStorageService.checkDatabaseStatus();
    
    // 필요시 데이터 초기화 (개발 중에만 사용)
    // await _localStorageService.clearAllData(); // 데이터 보존을 위해 주석 처리
  }

  Future<void> _loadAvailableExercises() async {
    // 더 이상 API를 직접 호출하지 않고, 자동완성 필드가 동기화된 데이터를 사용함
    _availableExercises = []; // 빈 배열로 설정 (자동완성 필드에서 동기화된 데이터 사용)
    notifyListeners();
  }

  void initializeListeners() {
    titleController.addListener(saveCurrentWorkout);
    diaryMemoController.addListener(saveCurrentWorkout);
  }

  List<WorkoutDayRecord> getEventsForDay(DateTime day) {
    // 이제 달력에서는 CalendarView의 캐시된 데이터를 사용
    // 이 메서드는 이전 버전과의 호환성을 위해 유지
    final record = _workoutEvents[DateTime(day.year, day.month, day.day)];
    return record != null ? [record] : [];
  }

  void updateSelectedDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    if (_selectedDate != normalizedDate && !_disposed) {
      _selectedDate = normalizedDate;
      notifyListeners();
    }
  }

  void updateFocusedDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    if (_focusedDate != normalizedDate && !_disposed) {
      _focusedDate = normalizedDate;
      notifyListeners();
    }
  }

  void loadWorkoutForDate(DateTime date) {
    if (_disposed) return;

    // SQLite에서 해당 날짜의 운동기록을 비동기로 로드
    _loadWorkoutFromSQLite(date);
  }
  
  Future<void> _loadWorkoutFromSQLite(DateTime date) async {
    if (_disposed) return;
    
    try {
      final dateString = DateFormat('yyyy-MM-dd').format(date);
      final localWorkouts = await _localStorageService.getWorkoutLogsByDate(dateString);
      
      // UI 컨트롤러 초기화
      titleController.clear();
      diaryMemoController.clear();
      
      // 기존 운동들 정리
      for (var exercise in _exercises) {
        exercise.dispose();
      }
      _exercises.clear();
      
      if (localWorkouts.isNotEmpty) {
        // SQLite 데이터를 UI 모델로 변환
        _loadWorkoutDataFromLocal(localWorkouts);
      }
      
      // 로드 완료 후 초기 상태 설정
      _setInitialState();
      
      if (!_disposed) {
        notifyListeners();
      }
    } catch (e) {
      print('❌ 날짜별 운동기록 로드 실패: $e');
    }
  }

  void saveCurrentWorkout() {
    // 이 메서드는 이제 UI 업데이트만 담당 (실제 저장은 saveWorkoutToAPI에서)
    if (_disposed) return;
    
    _checkForChanges();
    
    if (!_disposed) {
      notifyListeners();
    }
  }
  
  // 변경사항 감지
  void _checkForChanges() {
    final currentState = _getCurrentWorkoutState();
    final hasChanges = currentState != _initialState;
    
    if (_hasChanges != hasChanges) {
      _hasChanges = hasChanges;
    }
  }
  
  // 현재 운동 상태를 문자열로 변환 (변경사항 감지용)
  String _getCurrentWorkoutState() {
    final buffer = StringBuffer();
    buffer.write(titleController.text);
    buffer.write('|');
    buffer.write(diaryMemoController.text);
    buffer.write('|');
    
    for (var exercise in _exercises) {
      buffer.write(exercise.nameController.text);
      buffer.write('|');
      buffer.write(exercise.memoController.text);
      buffer.write('|');
      
      for (var set in exercise.sets) {
        buffer.write(set.weightController.text);
        buffer.write('-');
        buffer.write(set.repsController.text);
        buffer.write('-');
        buffer.write(set.memoController.text);
        buffer.write('|');
      }
    }
    
    return buffer.toString();
  }
  
  // 초기 상태 설정
  void _setInitialState() {
    _initialState = _getCurrentWorkoutState();
    _hasChanges = false;
  }

  void addExercise() {
    if (_disposed) return;

    final exercise = WorkoutExerciseDetail();
    _addExerciseListeners(exercise);
    _exercises.add(exercise);

    if (!_disposed) {
      saveCurrentWorkout();
    }
  }

  void removeExercise(int index) {
    if (_disposed || index < 0 || index >= _exercises.length) return;

    _exercises[index].dispose();
    _exercises.removeAt(index);

    if (!_disposed) {
      notifyListeners();
      saveCurrentWorkout();
      // 로컬 저장소에서도 해당 날짜의 데이터 삭제 후 재저장
      _syncLocalStorage();
    }
  }

  // 로컬 저장소 동기화 (운동 삭제/추가시 서버와 즉시 동기화)
  Future<void> _syncLocalStorage() async {
    try {
      // 운동이 있든 없든 항상 현재 상태를 서버에 동기화
      print('🔄 서버와 동기화 시작 - 현재 운동 개수: ${_exercises.length}');
      await saveWorkoutToAPI();
      print('🔄 서버 동기화 완료');
    } catch (e) {
      // 로컬 동기화 실패해도 UI는 업데이트됨
      print('⚠️ 서버 동기화 실패: $e');
    }
  }

  void _addExerciseListeners(WorkoutExerciseDetail exercise) {
    exercise.nameController.addListener(saveCurrentWorkout);
    exercise.memoController.addListener(saveCurrentWorkout);

    // 기존 세트들에 리스너 추가
    _addSetListeners(exercise);
  }

  void _addSetListeners(WorkoutExerciseDetail exercise) {
    for (var set in exercise.sets) {
      set.repsController.addListener(saveCurrentWorkout);
      set.weightController.addListener(saveCurrentWorkout);
      set.memoController.addListener(saveCurrentWorkout);
    }
  }

  // 세트가 추가될 때 호출할 메서드
  void addSetToExercise(int exerciseIndex) {
    if (_disposed || exerciseIndex < 0 || exerciseIndex >= _exercises.length)
      return;

    final exercise = _exercises[exerciseIndex];
    exercise.addSet();

    // 새로 추가된 세트에 리스너 추가
    final newSet = exercise.sets.last;
    newSet.repsController.addListener(saveCurrentWorkout);
    newSet.weightController.addListener(saveCurrentWorkout);
    newSet.memoController.addListener(saveCurrentWorkout);

    // 변경사항 추적
    saveCurrentWorkout();
  }

  // API를 통한 운동 기록 저장
  Future<void> saveWorkoutToAPI() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      // 운동 데이터 준비
      final workoutExercises = <WorkoutExercise>[];


      for (int exerciseIndex = 0;
          exerciseIndex < _exercises.length;
          exerciseIndex++) {
        final exercise = _exercises[exerciseIndex];

        // 운동 이름이 있는 경우만 처리
        if (exercise.nameController.text.trim().isEmpty) continue;

        // 운동 이름으로 exerciseId 찾기
        final exerciseName = exercise.nameController.text.trim();

        int? exerciseId;

        // availableExercises에서 이름으로 매칭하여 ID 찾기
        for (var availableExercise in _availableExercises) {

          if (availableExercise['name'] == exerciseName ||
              availableExercise['exerciseName'] == exerciseName) {
            // ID가 String이나 int로 올 수 있으므로 타입 체크 후 변환
            final idValue =
                availableExercise['id'] ?? availableExercise['exerciseId'];

            if (idValue != null) {
              if (idValue is int) {
                exerciseId = idValue;
              } else if (idValue is String) {
                exerciseId = int.tryParse(idValue);
              }
            }
            break;
          }
        }

        // ID를 찾지 못한 경우 임시 ID 사용 (서버에서 처리하도록)
        if (exerciseId == null) {
          exerciseId = exerciseIndex + 1;
        }

        // 세트 데이터 준비
        final workoutSets = <WorkoutSetData>[];

        for (int setIndex = 0; setIndex < exercise.sets.length; setIndex++) {

          try {
            final set = exercise.sets[setIndex];

            final repsText = set.repsController.text;
            final weightText = set.weightController.text;

            final reps = int.tryParse(repsText);
            final weight = double.tryParse(weightText) ?? 0.0;

            if (reps != null && reps > 0) {
              workoutSets.add(WorkoutSetData(
                setNumber: setIndex + 1,
                weight: weight,
                reps: reps,
                feedback: set.memoController.text.trim().isNotEmpty
                    ? set.memoController.text.trim()
                    : null,
              ));
            }
          } catch (e, stackTrace) {
            rethrow;
          }
        }

        if (workoutSets.isNotEmpty) {
          try {
            workoutExercises.add(WorkoutExercise(
              exerciseId: exerciseId,
              exerciseName: exerciseName, // 실제 운동 이름 전달
              exerciseMemo: exercise.memoController.text.trim().isNotEmpty 
                  ? exercise.memoController.text.trim() 
                  : null, // 운동 메모 전달
              logOrder: exerciseIndex + 1,
              workoutSets: workoutSets,
            ));
          } catch (e, stackTrace) {
            rethrow;
          }
        }
      }

      if (workoutExercises.isEmpty) {
        // 빈 운동 데이터인 경우 서버에서 해당 날짜 데이터 삭제를 위해 빈 배열로 요청
        print('🗑️ 빈 운동 데이터 - 서버에 삭제 요청을 보냅니다');
      }

      // API 요청 객체 생성
      final WorkoutLogRequest request;
      try {
        final workoutDateString = DateFormat('yyyy-MM-dd').format(_selectedDate);
        print('💾 운동기록 저장 날짜: $workoutDateString (선택된 날짜: $_selectedDate)');
        
        request = WorkoutLogRequest(
          workoutDate: workoutDateString,
          logFeedback: diaryMemoController.text.trim().isNotEmpty
              ? diaryMemoController.text.trim()
              : null,
          workoutExercises: workoutExercises,
        );
      } catch (e, stackTrace) {
        rethrow;
      }

      // 1. 로컬에 먼저 저장
      final userId = _authState.value?.id ?? '0';
      int localWorkoutLogId;
      try {
        print('💾 로컬 저장 시작 - userId: $userId');
        print('💾 저장할 데이터 개수: ${workoutExercises.length}개 운동');
        
        // 데이터베이스 상태 확인
        await _localStorageService.checkDatabaseStatus();
        
        localWorkoutLogId = await _localStorageService.saveWorkoutLog(request, userId);
        print('💾 로컬 저장 성공 - ID: $localWorkoutLogId');
      } catch (localError, stackTrace) {
        print('❌ 로컬 저장 실패: $localError');
        print('❌ 스택트레이스: $stackTrace');
        rethrow; // 로컬 저장 실패 시 전체 작업 중단
      }

      // 2. 서버에 저장 시도
      try {
        print('💾 서버 저장 시작...');
        final response = await _apiService.saveWorkoutLog(request);
        print('💾 서버 저장 성공');

        // 3. 서버 저장 성공 시 동기화 상태 업데이트
        await _localStorageService.markAsSynced(localWorkoutLogId);
        print('💾 동기화 상태 업데이트 완료');
      } catch (serverError) {
        print('⚠️ 서버 저장 실패: $serverError');
        print('💾 로컬 저장은 완료되었습니다. 나중에 동기화됩니다.');
        // 서버 저장 실패해도 로컬은 저장되었으므로 계속 진행
        // 나중에 동기화할 수 있도록 unsync 상태로 유지
      }

      // 저장 후 초기 상태 업데이트 (변경사항 리셋)
      _setInitialState();
      
      // 로컬 데이터 새로고침
      saveCurrentWorkout();
      
      // UI 새로고침을 위해 notifyListeners 호출
      if (!_disposed) {
        notifyListeners();
      }
    } catch (e, stackTrace) {
      rethrow; // 에러를 상위로 전달하여 UI에서 처리할 수 있도록
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 특정 날짜의 운동 기록 불러오기 (로컬 우선)
  Future<void> loadWorkoutFromStorage(DateTime date) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      final dateString = DateFormat('yyyy-MM-dd').format(date);

      // 1. 로컬에서 먼저 조회
      final localWorkouts =
          await _localStorageService.getWorkoutLogsByDate(dateString);

      if (localWorkouts.isNotEmpty) {
        // 로컬 데이터가 있으면 사용
        _loadWorkoutDataFromLocal(localWorkouts);
        _setInitialState(); // 로드 후 초기 상태 설정
      } else {
        // 로컬에 없으면 서버에서 시도
        try {
          final response = await _apiService.getWorkoutLogByDate(dateString);
          if (response.isNotEmpty) {
            // 서버 데이터를 로컬 형식으로 변환하여 표시
            // 필요시 서버 데이터도 로컬에 저장
          }
        } catch (e) {
        }
      }
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 로컬 데이터를 UI 모델로 변환
  void _loadWorkoutDataFromLocal(List<Map<String, dynamic>> localWorkouts) {
    // 로컬 데이터를 WorkoutExerciseDetail로 변환
    for (var workout in localWorkouts) {
      // 제목 설정 (첫 번째 운동기록에서만)
      if (titleController.text.isEmpty && workout['log_feedback'] != null) {
        titleController.text = workout['log_feedback'];
      }
      
      final exercises = workout['exercises'] as List<dynamic>;

      for (var exerciseData in exercises) {
        final exerciseDetail = WorkoutExerciseDetail();
        exerciseDetail.nameController.text =
            exerciseData['exercise_name'] ?? '';
        
        // 운동 메모 설정
        if (exerciseData['memo'] != null) {
          exerciseDetail.memoController.text = exerciseData['memo'];
        }

        // 세트 정보 추가
        final sets = exerciseData['sets'] as List<dynamic>;
        for (var setData in sets) {
          exerciseDetail.addSet();
          final workoutSet = exerciseDetail.sets.last;
          workoutSet.repsController.text = setData['reps']?.toString() ?? '0';
          workoutSet.weightController.text = setData['weight']?.toString() ?? '0';
          workoutSet.memoController.text = setData['memo']?.toString() ?? '';
          
          // 각 세트에 리스너 추가 (로드된 데이터에도 변경 감지 필요)
          workoutSet.repsController.addListener(saveCurrentWorkout);
          workoutSet.weightController.addListener(saveCurrentWorkout);
          workoutSet.memoController.addListener(saveCurrentWorkout);
        }

        // 운동 레벨 리스너 추가
        _addExerciseListeners(exerciseDetail);
        _exercises.add(exerciseDetail);
      }
    }
  }

  // 특정 월의 운동 기록이 있는 날짜들 조회 (달력용)
  Future<List<String>> getWorkoutDatesInMonth(DateTime month) async {
    try {
      final year = month.year.toString();
      final monthStr = month.month.toString();
      return await _localStorageService.getWorkoutDatesInMonth(year, monthStr);
    } catch (e) {
      return [];
    }
  }

  // 루틴 템플릿 기능 - 루틴을 선택해서 운동기록으로 변환
  Future<void> loadRoutineAsTemplate(RoutineResponse routine) async {
    if (_disposed) return;

    // 기존 운동 데이터 클리어
    for (var exercise in _exercises) {
      exercise.dispose();
    }
    _exercises.clear();

    // 루틴 이름을 제목으로 설정
    titleController.text = routine.name;

    // 루틴의 운동들을 WorkoutExerciseDetail로 변환
    if (routine.routineExercises != null) {
      for (var routineExercise in routine.routineExercises!) {
        final exerciseDetail = WorkoutExerciseDetail();
        
        // 운동 이름 설정 (exerciseName이 있으면 사용, 없으면 ID로 검색)
        if (routineExercise.exerciseName != null) {
          exerciseDetail.nameController.text = routineExercise.exerciseName!;
        } else if (routineExercise.exerciseId != null) {
          // availableExercises에서 ID로 이름 찾기
          final exercise = _availableExercises.firstWhere(
            (ex) => (ex['id'] ?? ex['exerciseId']) == routineExercise.exerciseId,
            orElse: () => {'name': '운동 ${routineExercise.exerciseId}'},
          );
          exerciseDetail.nameController.text = exercise['name'] ?? exercise['exerciseName'] ?? '';
        }

        // 루틴 세트를 운동 세트로 변환
        for (var routineSet in routineExercise.routineSets) {
          exerciseDetail.addSet();
          final workoutSet = exerciseDetail.sets.last;
          workoutSet.repsController.text = routineSet.reps.toString();
          workoutSet.weightController.text = routineSet.weight.toString();
          
          // 각 세트에 리스너 추가 (루틴에서 로드된 세트도 변경 감지 필요)
          workoutSet.repsController.addListener(saveCurrentWorkout);
          workoutSet.weightController.addListener(saveCurrentWorkout);
          workoutSet.memoController.addListener(saveCurrentWorkout);
        }

        // 운동 레벨 리스너 추가
        _addExerciseListeners(exerciseDetail);
        _exercises.add(exerciseDetail);
      }
    }

    // 루틴 로드 완료 후 초기 상태 설정
    _setInitialState();
    
    // UI 업데이트
    if (!_disposed) {
      notifyListeners();
    }
  }

  // 내 루틴 목록 조회 (운동기록 화면에서 사용)
  Future<List<RoutineResponse>> getMyRoutines() async {
    try {
      return await _apiService.getMyRoutines();
    } catch (e) {
      return [];
    }
  }
}
