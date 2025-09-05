import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/workout_record_models.dart';
import '../../../core/theme/notion_colors.dart';
import 'exercise_display_card.dart';

class WorkoutDayCard extends StatelessWidget {
  final WorkoutDayRecord dayRecord;

  const WorkoutDayCard({super.key, required this.dayRecord});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: NotionColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NotionColors.border),
      ),
      child: ExpansionTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: NotionColors.gray100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.fitness_center,
            color: NotionColors.black,
            size: 24,
          ),
        ),
        title: Text(
          dayRecord.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: NotionColors.black,
          ),
        ),
        subtitle: Text(
          '${dayRecord.exercises.length}개 운동 • ${DateFormat('MM월 dd일').format(dayRecord.date)}',
          style: TextStyle(color: NotionColors.textSecondary, fontSize: 13),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (dayRecord.diaryMemo != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: NotionColors.gray100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: NotionColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.edit_note, size: 16, color: NotionColors.black),
                            const SizedBox(width: 4),
                            Text(
                              '오늘의 일지',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: NotionColors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dayRecord.diaryMemo!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                const Text(
                  '운동 세부사항',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: NotionColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                ...dayRecord.exercises.asMap().entries.map((entry) {
                  final index = entry.key;
                  final exercise = entry.value;
                  return ExerciseDisplayCard(exercise: exercise, index: index);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}