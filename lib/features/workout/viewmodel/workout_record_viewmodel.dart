import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../model/workout_record_models.dart';

class WorkoutRecordViewmodel extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController diaryMemoController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  bool _disposed = false;
  
  // 실시간 운동 기록 관리
  final List<WorkoutExerciseDetail> _exercises = [];
  
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
  Map<DateTime, WorkoutDayRecord> get workoutEvents => Map.unmodifiable(_workoutEvents);

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
          workoutSet.repsController.text = setRecord.reps.toString();
          workoutSet.weightController.text = setRecord.weight?.toString() ?? '';
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
    
    final dateKey = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    
    final exercises = _exercises
        .where((e) => e.nameController.text.trim().isNotEmpty)
        .map((e) {
          final sets = e.sets.map((set) => SetRecord(
            reps: int.tryParse(set.repsController.text) ?? 0,
            weight: set.weightController.text.isNotEmpty 
                ? double.tryParse(set.weightController.text) 
                : null,
          )).toList();
          
          return ExerciseRecord(
            name: e.nameController.text.trim(),
            sets: sets,
            memo: e.memoController.text.trim().isNotEmpty ? e.memoController.text.trim() : null,
          );
        })
        .toList();
    
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
    if (_disposed || exerciseIndex < 0 || exerciseIndex >= _exercises.length) return;
    
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
}