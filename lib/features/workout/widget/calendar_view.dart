import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../model/workout_record_models.dart';
import '../viewmodel/workout_record_viewmodel.dart';
import '../../../core/theme/notion_colors.dart';
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
  bool _isCalendarExpanded = true; // 캘린더 펼침/접힘 상태

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR', null); // 한국어 초기화
    _loadWorkoutDates();
    // ViewModel의 변경사항을 감지하여 달력 데이터 새로고침
    widget.viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    // 운동기록 변경 시 달력 데이터 새로고침
    _loadWorkoutDates();
  }

  Future<void> _loadWorkoutDates() async {
    try {
      final dates = await widget.viewModel
          .getWorkoutDatesInMonth(widget.viewModel.focusedDate);
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
      final localWorkouts = await widget.viewModel.localStorageService
          .getWorkoutLogsByDate(dateString);
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
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'IBMPlexSansKR',
            ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // 캘린더 섹션
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  // 캘린더 헤더 (항상 표시)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                      bottom: _isCalendarExpanded ? 8 : 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 이전 달 버튼
                        IconButton(
                          onPressed: () {
                            final newDate = DateTime(
                              widget.viewModel.focusedDate.year,
                              widget.viewModel.focusedDate.month - 1,
                            );
                            widget.viewModel.updateFocusedDate(newDate);
                            _workoutDataCache.clear();
                            _loadWorkoutDates();
                          },
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Color(0xFF10B981),
                          ),
                        ),
                        // 날짜 표시
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isCalendarExpanded = !_isCalendarExpanded;
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                DateFormat('yyyy년 M월')
                                    .format(widget.viewModel.focusedDate),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedRotation(
                                turns: _isCalendarExpanded ? 0 : 0.5,
                                duration: const Duration(milliseconds: 300),
                                child: const Icon(
                                  Icons.expand_less,
                                  color: Color(0xFF10B981),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 다음 달 버튼
                        IconButton(
                          onPressed: () {
                            final newDate = DateTime(
                              widget.viewModel.focusedDate.year,
                              widget.viewModel.focusedDate.month + 1,
                            );
                            widget.viewModel.updateFocusedDate(newDate);
                            _workoutDataCache.clear();
                            _loadWorkoutDates();
                          },
                          icon: const Icon(
                            Icons.chevron_right,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 캘린더 본체
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Container(
                      height: _isCalendarExpanded ? 350 : 0,
                      padding: _isCalendarExpanded
                          ? const EdgeInsets.symmetric(horizontal: 16)
                          : EdgeInsets.zero,
                      child: _isCalendarExpanded
                          ? TableCalendar<WorkoutDayRecord>(
                              firstDay: DateTime.utc(1900, 1, 1),
                              lastDay: DateTime.utc(2030, 12, 31),
                              focusedDay: widget.viewModel.focusedDate,
                              selectedDayPredicate: (day) =>
                                  isSameDay(widget.viewModel.selectedDate, day),
                              eventLoader: (day) => _getEventsForDay(day),
                              calendarFormat: CalendarFormat.month,
                              locale: 'ko_KR',
                              headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                headerMargin: EdgeInsets.zero,
                                headerPadding: EdgeInsets.zero,
                                leftChevronVisible: false,
                                rightChevronVisible: false,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                titleTextStyle: TextStyle(
                                  fontSize: 0, // 텍스트 크기를 0으로 설정하여 숨김
                                  height: 0,
                                ),
                              ),
                              daysOfWeekStyle: const DaysOfWeekStyle(
                                weekendStyle: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'IBMPlexSansKR',
                                  fontSize: 13,
                                ),
                                weekdayStyle: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'IBMPlexSansKR',
                                  fontSize: 13,
                                ),
                              ),
                              calendarStyle: const CalendarStyle(
                                cellMargin: EdgeInsets.all(4),
                                cellPadding: EdgeInsets.all(0),
                                todayDecoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                                markerDecoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF10B981),
                                      Color(0xFF34D399),
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)),
                                  border: Border.fromBorderSide(BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  )),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF10B981),
                                      blurRadius: 3,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                weekendTextStyle: TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                                defaultTextStyle: TextStyle(
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                                selectedTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                                todayTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                                markerSize: 10,
                                markersMaxCount: 1,
                                markerMargin:
                                    EdgeInsets.symmetric(horizontal: 0.5),
                              ),
                              onDaySelected: (selectedDay, focusedDay) {
                                widget.viewModel
                                    .updateSelectedDate(selectedDay);
                                widget.viewModel.updateFocusedDate(focusedDay);
                                // 선택된 날짜의 운동 기록이 캐시에 없다면 로드
                                final dateString = DateFormat('yyyy-MM-dd')
                                    .format(selectedDay);
                                if (!_workoutDataCache
                                    .containsKey(dateString)) {
                                  _loadWorkoutDataForDate(dateString);
                                }
                              },
                              onPageChanged: (focusedDay) {
                                widget.viewModel.updateFocusedDate(focusedDay);
                                // 달 변경 시 운동 날짜 새로고침
                                _workoutDataCache.clear(); // 캐시 클리어
                                _loadWorkoutDates();
                              },
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 운동 정보 섹션
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSelectedDayWorkouts(),
            ),
            const SizedBox(height: 100), // 하단 여백
          ],
        ),
      ),
    );
  }

  // 서버/로컬 데이터 기반 이벤트 로더
  List<WorkoutDayRecord> _getEventsForDay(DateTime day) {
    final dateString = DateFormat('yyyy-MM-dd').format(day);
    if (_workoutDataCache.containsKey(dateString)) {
      return _workoutDataCache[dateString]!.map((workoutData) {
        // 서버 데이터인지 로컬 데이터인지 판단
        if (workoutData.containsKey('workoutLogId')) {
          return _convertServerDataToWorkoutDayRecord(workoutData, day);
        } else {
          return _convertLocalDataToWorkoutDayRecord(workoutData, day);
        }
      }).toList();
    }
    return [];
  }

  // 서버 데이터를 WorkoutDayRecord로 변환
  WorkoutDayRecord _convertServerDataToWorkoutDayRecord(
      Map<String, dynamic> serverData, DateTime day) {
    final workoutExercises =
        (serverData['workoutExercises'] as List<dynamic>).map((exerciseData) {
      final workoutSets =
          (exerciseData['workoutSets'] as List<dynamic>).map((setData) {
        return SetRecord(
          reps: setData['reps'] as int,
          weight: setData['weight'] != null
              ? (setData['weight'] as num).toDouble()
              : null,
          memo: null, // 서버 데이터에서는 세트별 메모가 feedbacks에 있음
        );
      }).toList();

      return ExerciseRecord(
        name: exerciseData['exerciseName']?.toString() ?? 'Unknown Exercise',
        sets: workoutSets,
        memo: null, // 운동별 피드백은 feedbacks에 있음
      );
    }).toList();

    // 전체 운동 로그의 피드백을 diaryMemo로 사용
    final feedbacks = serverData['feedbacks'] as List<dynamic>;
    final diaryMemo = feedbacks.isNotEmpty
        ? feedbacks.map((f) => '${f['authorName']}: ${f['content']}').join('\n')
        : null;

    return WorkoutDayRecord(
      date: day,
      title: workoutExercises.isNotEmpty
          ? '${workoutExercises.length}개 운동 완료'
          : '운동 완료',
      diaryMemo: diaryMemo,
      exercises: workoutExercises,
    );
  }

  // 로컬 저장소 데이터를 WorkoutDayRecord로 변환
  WorkoutDayRecord _convertLocalDataToWorkoutDayRecord(
      Map<String, dynamic> workoutData, DateTime day) {
    final exercises =
        (workoutData['exercises'] as List<dynamic>).map((exerciseData) {
      final sets = (exerciseData['sets'] as List<dynamic>).map((setData) {
        return SetRecord(
          reps: setData['reps'] as int,
          weight: setData['weight'] != null
              ? (setData['weight'] as num).toDouble()
              : null,
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
      title: exercises.isNotEmpty ? '${exercises.length}개 운동 완료' : '운동 완료',
      diaryMemo: null, // 로컬 데이터에 일반 메모가 없으므로 null
      exercises: exercises,
    );
  }

  Widget _buildSelectedDayWorkouts() {
    final events = _getEventsForDay(widget.viewModel.selectedDate);

    return Container(
      color: NotionColors.white,
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
                color: NotionColors.black,
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
                      color: NotionColors.textSecondary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '운동 기록이 없습니다',
                      style: TextStyle(
                          color: NotionColors.textSecondary, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            )
          else
            ...events.map((event) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: WorkoutDayCard(
                    dayRecord: event,
                    onExpansionChanged: (isExpanded) {
                      // 운동 카드가 펼쳐질 때 캘린더 접기
                      if (isExpanded && _isCalendarExpanded) {
                        setState(() {
                          _isCalendarExpanded = false;
                        });
                      }
                    },
                  ),
                )),
        ],
      ),
    );
  }
}
