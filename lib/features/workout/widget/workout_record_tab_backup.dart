import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../viewmodel/workout_record_viewmodel.dart';
import 'exercise_input_card.dart';
import '../../dashboard/widgets/notion_button.dart';

class WorkoutRecordTabBackup extends StatelessWidget {
  final WorkoutRecordViewmodel viewModel;

  const WorkoutRecordTabBackup({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDateCard(context),
          const SizedBox(height: 16),
          _buildTitleCard(),
          const SizedBox(height: 16),
          _buildExerciseListCard(),
          const SizedBox(height: 16),
          _buildDiaryCard(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDateCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📅 운동 날짜',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF2C3E50)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('yyyy년 MM월 dd일 (E)', 'ko')
                          .format(viewModel.selectedDate),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(Icons.calendar_today, color: Color(0xFF2C3E50)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📝 운동 제목',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: viewModel.titleController,
              decoration: const InputDecoration(
                hintText: '예: 상체 근력 운동, 하체 데이 등',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseListCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '🏋️ 운동 목록',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                NotionButton(
                  text: '운동 추가',
                  icon: Icons.add,
                  onPressed: viewModel.addExercise,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (viewModel.exercises.isEmpty)
              _buildEmptyExerciseState()
            else
              _buildExerciseList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyExerciseState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const Column(
        children: [
          Icon(Icons.fitness_center_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            '아직 추가된 운동이 없습니다',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            '운동 추가 버튼을 눌러 운동을 기록해보세요!',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseList() {
    return Column(
      children: viewModel.exercises.asMap().entries.map((entry) {
        final index = entry.key;
        final exercise = entry.value;
        return ExerciseInputCard(
          exercise: exercise,
          index: index,
          onRemove: () => viewModel.removeExercise(index),
        );
      }).toList(),
    );
  }

  Widget _buildDiaryCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📖 오늘의 운동 일지',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: viewModel.diaryMemoController,
              decoration: const InputDecoration(
                hintText: '오늘의 컨디션, 운동 후 느낌, 특이사항 등을 자유롭게 기록해보세요',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: viewModel.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      viewModel.updateSelectedDate(picked);
      viewModel.loadWorkoutForDate(picked);
    }
  }
}
