import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../model/workout_record_models.dart';
import '../model/workout_log_models.dart';
import '../service/workout_api_service.dart';
import '../service/local_storage_service.dart';
import '../../../core/providers/auth_provider.dart';

class WorkoutRecordViewmodel extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController diaryMemoController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  bool _disposed = false;

  // 실시간 운동 기록 관리
  final List<WorkoutExerciseDetail> _exercises = [];

  // API 서비스
  final WorkoutApiService _apiService;
  final LocalStorageService _localStorageService;
  final AuthState _authState;

  WorkoutRecordViewmodel(
      this._apiService, this._localStorageService, this._authState);

  // 운동 목록 (exerciseId를 위한)
  List<Map<String, dynamic>> _availableExercises = [];
  List<Map<String, dynamic>> get availableExercises => _availableExercises;

  // 로딩 상태
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Mock data - 실제로는 API에서 가져올 데이터
  final Map<DateTime, WorkoutDayRecord> _workoutEvents = {
    DateTime(2025, 8, 10): WorkoutDayRecord(
      date: DateTime(2025, 8, 10),
      title: '상체 집중 운동',
      diaryMemo: '오늘 컨디션이 좋았고, 벤치프레스에서 중량을 늘릴 수 있었다.',
      exercises: [
        ExerciseRecord(
          name: '벤치프레스',
          sets: [
            SetRecord(reps: 12, weight: 60),
            SetRecord(reps: 10, weight: 60),
            SetRecord(reps: 8, weight: 65),
            SetRecord(reps: 6, weight: 70),
          ],
          memo: '마지막 세트에서 힘들었지만 완주',
        ),
        ExerciseRecord(
          name: '덤벨플라이',
          sets: [
            SetRecord(reps: 15, weight: 15),
            SetRecord(reps: 12, weight: 15),
            SetRecord(reps: 10, weight: 15),
          ],
          memo: '가슴 수축에 집중',
        ),
      ],
    ),
    DateTime(2025, 8, 8): WorkoutDayRecord(
      date: DateTime(2025, 8, 8),
      title: '하체 데이',
      diaryMemo: '스쿼트 폼을 개선하는데 집중했다.',
      exercises: [
        ExerciseRecord(
          name: '스쿼트',
          sets: [
            SetRecord(reps: 12, weight: 70),
            SetRecord(reps: 10, weight: 80),
            SetRecord(reps: 8, weight: 80),
            SetRecord(reps: 6, weight: 85),
            SetRecord(reps: 4, weight: 90),
          ],
          memo: '깊이 내려가기에 집중',
        ),
        ExerciseRecord(
          name: '레그프레스',
          sets: [
            SetRecord(reps: 15, weight: 100),
            SetRecord(reps: 12, weight: 120),
            SetRecord(reps: 10, weight: 120),
            SetRecord(reps: 8, weight: 130),
          ],
          memo: '무릎이 약간 아팠음',
        ),
      ],
    ),
  };

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
  }

  Future<void> _loadAvailableExercises() async {
    try {
      _availableExercises = await _apiService.getExerciseList();
      notifyListeners();
    } catch (e) {
      // API가 없거나 실패한 경우 기본 운동 목록 제공
      _availableExercises = [
        {'id': 1, 'name': '벤치프레스'},
        {'id': 2, 'name': '스쿼트'},
        {'id': 3, 'name': '데드리프트'},
        {'id': 4, 'name': '풀업'},
        {'id': 5, 'name': '딥스'},
      ];
    }
  }

  void initializeListeners() {
    titleController.addListener(saveCurrentWorkout);
    diaryMemoController.addListener(saveCurrentWorkout);
  }

  List<WorkoutDayRecord> getEventsForDay(DateTime day) {
    final record = _workoutEvents[DateTime(day.year, day.month, day.day)];
    return record != null ? [record] : [];
  }

  void updateSelectedDate(DateTime date) {
    if (_selectedDate != date && !_disposed) {
      _selectedDate = date;
      notifyListeners();
    }
  }

  void updateFocusedDate(DateTime date) {
    if (_focusedDate != date && !_disposed) {
      _focusedDate = date;
      notifyListeners();
    }
  }

  void loadWorkoutForDate(DateTime date) {
    if (_disposed) return;

    final dateKey = DateTime(date.year, date.month, date.day);
    final existingRecord = _workoutEvents[dateKey];

    if (existingRecord != null) {
      titleController.text = existingRecord.title;
      diaryMemoController.text = existingRecord.diaryMemo ?? '';

      // 기존 운동들을 정리하고 새로 로드
      for (var exercise in _exercises) {
        exercise.dispose();
      }
      _exercises.clear();

      for (var exerciseRecord in existingRecord.exercises) {
        final exercise = WorkoutExerciseDetail();
        exercise.nameController.text = exerciseRecord.name;
        exercise.memoController.text = exerciseRecord.memo ?? '';

        // 기존 세트 데이터 로드
        for (var setRecord in exerciseRecord.sets) {
          exercise.addSet();
          final workoutSet = exercise.sets.last;
          workoutSet.repsController.text = setRecord.reps?.toString() ?? '0';
          workoutSet.weightController.text = setRecord.weight?.toString() ?? '';
          workoutSet.memoController.text = setRecord.memo ?? '';
        }

        // 실시간 저장을 위한 리스너 추가
        _addExerciseListeners(exercise);

        _exercises.add(exercise);
      }
    } else {
      titleController.clear();
      diaryMemoController.clear();
      for (var exercise in _exercises) {
        exercise.dispose();
      }
      _exercises.clear();
    }

    if (!_disposed) {
      notifyListeners();
    }
  }

  void saveCurrentWorkout() {
    if (_disposed) return;

    final dateKey =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

    final exercises = _exercises
        .where((e) => e.nameController.text.trim().isNotEmpty)
        .map((e) {
      final sets = e.sets
          .map((set) => SetRecord(
                reps: int.tryParse(set.repsController.text) ?? 0,
                weight: set.weightController.text.isNotEmpty
                    ? double.tryParse(set.weightController.text)
                    : null,
                memo: set.memoController.text.trim().isNotEmpty
                    ? set.memoController.text.trim()
                    : null,
              ))
          .toList();

      return ExerciseRecord(
        name: e.nameController.text.trim(),
        sets: sets,
        memo: e.memoController.text.trim().isNotEmpty
            ? e.memoController.text.trim()
            : null,
      );
    }).toList();

    if (titleController.text.trim().isNotEmpty ||
        diaryMemoController.text.trim().isNotEmpty ||
        exercises.isNotEmpty) {
      _workoutEvents[dateKey] = WorkoutDayRecord(
        date: _selectedDate,
        title: titleController.text.trim().isNotEmpty
            ? titleController.text.trim()
            : '${DateFormat('MM월 dd일').format(_selectedDate)} 운동',
        diaryMemo: diaryMemoController.text.trim().isNotEmpty
            ? diaryMemoController.text.trim()
            : null,
        exercises: exercises,
      );
    } else {
      _workoutEvents.remove(dateKey);
    }

    if (!_disposed) {
      notifyListeners();
    }
  }

  void addExercise() {
    if (_disposed) return;

    final exercise = WorkoutExerciseDetail();
    _addExerciseListeners(exercise);
    _exercises.add(exercise);

    if (!_disposed) {
      notifyListeners();
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

  // 로컬 저장소 동기화 (삭제 후 재저장)
  Future<void> _syncLocalStorage() async {
    try {
      final dateString = DateFormat('yyyy-MM-dd').format(_selectedDate);
      
      // 기존 데이터 삭제
      await _localStorageService.deleteWorkoutLogsByDate(dateString);
      
      // 현재 운동이 있다면 다시 저장
      if (_exercises.isNotEmpty) {
        await saveWorkoutToAPI();
      }
    } catch (e) {
      // 로컬 동기화 실패해도 UI는 업데이트됨
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

    if (!_disposed) {
      notifyListeners();
    }
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
              logOrder: exerciseIndex + 1,
              workoutSets: workoutSets,
            ));
          } catch (e, stackTrace) {
            rethrow;
          }
        }
      }

      if (workoutExercises.isEmpty) {
        throw Exception('저장할 운동 데이터가 없습니다.');
      }

      // API 요청 객체 생성
      final WorkoutLogRequest request;
      try {
        request = WorkoutLogRequest(
          workoutDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
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
        final response = await _apiService.saveWorkoutLog(request);

        // 3. 서버 저장 성공 시 동기화 상태 업데이트
        await _localStorageService.markAsSynced(localWorkoutLogId);
      } catch (serverError) {
        // 서버 저장 실패해도 로컬은 저장되었으므로 계속 진행
        // 나중에 동기화할 수 있도록 unsync 상태로 유지
      }

      // 로컬 데이터 새로고침
      saveCurrentWorkout();
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
    // 기존 운동 데이터 클리어
    for (var exercise in _exercises) {
      exercise.dispose();
    }
    _exercises.clear();

    // 로컬 데이터를 WorkoutExerciseDetail로 변환
    for (var workout in localWorkouts) {
      final exercises = workout['exercises'] as List<dynamic>;

      for (var exerciseData in exercises) {
        final exerciseDetail = WorkoutExerciseDetail();
        exerciseDetail.nameController.text =
            exerciseData['exercise_name'] ?? '';

        // 세트 정보 추가
        final sets = exerciseData['sets'] as List<dynamic>;
        for (var setData in sets) {
          exerciseDetail.addSet();
          final workoutSet = exerciseDetail.sets.last;
          workoutSet.repsController.text = setData['reps']?.toString() ?? '0';
          workoutSet.weightController.text = setData['weight']?.toString() ?? '0';
          workoutSet.memoController.text = setData['memo']?.toString() ?? '';
        }

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
}
