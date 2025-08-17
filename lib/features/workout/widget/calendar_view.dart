import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../model/workout_record_models.dart';
import '../viewmodel/workout_record_viewmodel.dart';
import 'workout_day_card.dart';

class CalendarView extends StatefulWidget {
  final WorkoutRecordViewmodel viewModel;

  const CalendarView({super.key, required this.viewModel});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  List<String> _workoutDates = [];
  Map<String, List<Map<String, dynamic>>> _workoutDataCache = {};

  @override
  void initState() {
    super.initState();
    _loadWorkoutDates();
  }
  
  Future<void> _loadWorkoutDates() async {
    try {
      final dates = await widget.viewModel.getWorkoutDatesInMonth(widget.viewModel.focusedDate);
      setState(() {
        _workoutDates = dates;
      });
      
      // 각 날짜의 운동 데이터도 미리 로드
      for (final dateString in dates) {
        await _loadWorkoutDataForDate(dateString);
      }
    } catch (e) {
      print('❌ 달력 데이터 로드 실패: $e');
    }
  }

  Future<void> _loadWorkoutDataForDate(String dateString) async {
    try {
      final localWorkouts = await widget.viewModel.localStorageService.getWorkoutLogsByDate(dateString);
      if (localWorkouts.isNotEmpty) {
        setState(() {
          _workoutDataCache[dateString] = localWorkouts;
        });
      }
    } catch (e) {
      print('❌ 날짜별 운동 데이터 로드 실패 ($dateString): $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TableCalendar<WorkoutDayRecord>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: widget.viewModel.focusedDate,
              selectedDayPredicate: (day) => isSameDay(widget.viewModel.selectedDate, day),
              eventLoader: (day) => _getEventsForDay(day),
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF2C3E50)),
                rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF2C3E50)),
              ),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Color(0xFF2C3E50),
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: TextStyle(color: Colors.red),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                widget.viewModel.updateSelectedDate(selectedDay);
                widget.viewModel.updateFocusedDate(focusedDay);
                // 선택된 날짜의 운동 기록이 캐시에 없다면 로드
                final dateString = DateFormat('yyyy-MM-dd').format(selectedDay);
                if (!_workoutDataCache.containsKey(dateString)) {
                  _loadWorkoutDataForDate(dateString);
                }
              },
              onPageChanged: (focusedDay) {
                widget.viewModel.updateFocusedDate(focusedDay);
                // 달 변경 시 운동 날짜 새로고침
                _workoutDataCache.clear(); // 캐시 클리어
                _loadWorkoutDates();
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: _buildSelectedDayWorkouts(),
            ),
          ),
        ],
    );
  }

  // 로컬 데이터 기반 이벤트 로더
  List<WorkoutDayRecord> _getEventsForDay(DateTime day) {
    final dateString = DateFormat('yyyy-MM-dd').format(day);
    if (_workoutDataCache.containsKey(dateString)) {
      return _workoutDataCache[dateString]!.map((workoutData) {
        return _convertToWorkoutDayRecord(workoutData, day);
      }).toList();
    }
    return [];
  }

  // 로컬 저장소 데이터를 WorkoutDayRecord로 변환
  WorkoutDayRecord _convertToWorkoutDayRecord(Map<String, dynamic> workoutData, DateTime day) {
    final exercises = (workoutData['exercises'] as List<dynamic>).map((exerciseData) {
      final sets = (exerciseData['sets'] as List<dynamic>).map((setData) {
        return SetRecord(
          reps: setData['reps'] as int,
          weight: setData['weight'] != null ? (setData['weight'] as num).toDouble() : null,
          memo: setData['memo']?.toString(),
        );
      }).toList();

      return ExerciseRecord(
        name: exerciseData['exercise_name']?.toString() ?? 'Unknown Exercise',
        sets: sets,
        memo: exerciseData['memo']?.toString(),
      );
    }).toList();

    return WorkoutDayRecord(
      date: day,
      title: exercises.isNotEmpty 
          ? '${exercises.length}개 운동 완료'
          : '운동 완료',
      diaryMemo: null, // 로컬 데이터에 일반 메모가 없으므로 null
      exercises: exercises,
    );
  }

  Widget _buildSelectedDayWorkouts() {
    final events = _getEventsForDay(widget.viewModel.selectedDate);
    
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${DateFormat('yyyy년 MM월 dd일').format(widget.viewModel.selectedDate)}의 운동',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
          ),
          if (events.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fitness_center_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '이 날에는 운동 기록이 없습니다',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '운동 기록 탭에서 새로운 기록을 작성해보세요!',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          else
            ...events.map((event) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: WorkoutDayCard(dayRecord: event),
            )),
        ],
      ),
    );
  }
}