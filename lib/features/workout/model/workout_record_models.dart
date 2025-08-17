import 'package:flutter/material.dart';

// 하루 운동 기록을 위한 데이터 모델
class WorkoutDayRecord {
  final DateTime date;
  final String title;
  final String? diaryMemo;
  final List<ExerciseRecord> exercises;

  WorkoutDayRecord({
    required this.date,
    required this.title,
    this.diaryMemo,
    required this.exercises,
  });
}

// 개별 세트 정보를 위한 데이터 모델
class SetRecord {
  final int reps;
  final double? weight;
  final String? memo;

  SetRecord({
    required this.reps,
    this.weight,
    this.memo,
  });
}

// 개별 운동 기록을 위한 데이터 모델
class ExerciseRecord {
  final String name;
  final List<SetRecord> sets;
  final String? memo;

  ExerciseRecord({
    required this.name,
    required this.sets,
    this.memo,
  });
}

// 개별 세트 입력을 위한 헬퍼 클래스
class WorkoutSet {
  final TextEditingController repsController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController memoController = TextEditingController();
  
  void dispose() {
    repsController.dispose();
    weightController.dispose();
    memoController.dispose();
  }
}

// 운동 입력을 위한 헬퍼 클래스
class WorkoutExerciseDetail {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController memoController = TextEditingController();
  final List<WorkoutSet> sets = [];
  
  void addSet() {
    sets.add(WorkoutSet());
  }
  
  void removeSet(int index) {
    if (index < sets.length) {
      sets[index].dispose();
      sets.removeAt(index);
    }
  }
  
  void dispose() {
    nameController.dispose();
    memoController.dispose();
    for (var set in sets) {
      set.dispose();
    }
    sets.clear();
  }
}