import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/workout_record_models.dart';
import 'exercise_display_card.dart';

class WorkoutDayCard extends StatelessWidget {
  final WorkoutDayRecord dayRecord;

  const WorkoutDayCard({super.key, required this.dayRecord});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF2C3E50).withAlpha(51),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.fitness_center,
            color: Color(0xFF2C3E50),
            size: 24,
          ),
        ),
        title: Text(
          dayRecord.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        subtitle: Text(
          '${dayRecord.exercises.length}개 운동 • ${DateFormat('MM월 dd일').format(dayRecord.date)}',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
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
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.edit_note, size: 16, color: Colors.blue[700]),
                            const SizedBox(width: 4),
                            Text(
                              '오늘의 일지',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[700],
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
                    color: Color(0xFF2C3E50),
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