import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../model/workout_record_models.dart';
import '../viewmodel/workout_record_viewmodel.dart';
import 'workout_day_card.dart';

class CalendarView extends StatelessWidget {
  final WorkoutRecordViewmodel viewModel;

  const CalendarView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TableCalendar<WorkoutDayRecord>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: viewModel.focusedDate,
              selectedDayPredicate: (day) => isSameDay(viewModel.selectedDate, day),
              eventLoader: viewModel.getEventsForDay,
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
                viewModel.updateSelectedDate(selectedDay);
                viewModel.updateFocusedDate(focusedDay);
              },
              onPageChanged: (focusedDay) {
                viewModel.updateFocusedDate(focusedDay);
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

  Widget _buildSelectedDayWorkouts() {
    final events = viewModel.getEventsForDay(viewModel.selectedDate);
    
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${DateFormat('yyyy년 MM월 dd일').format(viewModel.selectedDate)}의 운동',
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