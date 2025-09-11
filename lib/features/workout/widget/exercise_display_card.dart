import 'package:flutter/material.dart';
import '../model/workout_record_models.dart';
import '../../../core/theme/notion_colors.dart';

class ExerciseDisplayCard extends StatelessWidget {
  final ExerciseRecord exercise;
  final int index;

  const ExerciseDisplayCard({
    super.key,
    required this.exercise,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: NotionColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: NotionColors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: NotionColors.gray100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${exercise.sets.length}세트',
                            style: const TextStyle(
                              color: NotionColors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: NotionColors.gray100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '총 ${exercise.sets.fold<int>(0, (sum, set) => sum + set.reps)}회',
                            style: const TextStyle(
                              color: NotionColors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // 최고 중량 표시
                        if (exercise.sets.any((set) => set.weight != null)) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: NotionColors.gray100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '최고 ${exercise.sets.where((set) => set.weight != null).map((set) => set.weight!).reduce((a, b) => a > b ? a : b)}kg',
                              style: const TextStyle(
                                color: NotionColors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${exercise.sets.length}세트',
                style: TextStyle(
                  color: NotionColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              ...exercise.sets.asMap().entries.map((entry) {
                final setIndex = entry.key;
                final set = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: NotionColors.gray100,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: NotionColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: NotionColors.black,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                '${setIndex + 1}',
                                style: const TextStyle(
                                  color: NotionColors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${set.reps}회',
                            style: const TextStyle(
                              color: NotionColors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (set.weight != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: NotionColors.gray100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${set.weight}kg',
                                style: const TextStyle(
                                  color: NotionColors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      // 세트별 메모 표시
                      if (set.memo != null && set.memo!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: NotionColors.gray100,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: NotionColors.border),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.note_alt_outlined,
                                size: 12,
                                color: NotionColors.black,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  set.memo!,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: NotionColors.black,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ],
          ),
          if (exercise.memo != null && exercise.memo!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
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
                      const Icon(
                        Icons.edit_note_outlined,
                        size: 14,
                        color: NotionColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '운동 메모',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: NotionColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exercise.memo!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: NotionColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
