import 'package:flutter/material.dart';
import '../model/workout_record_models.dart';

class ExerciseInputCard extends StatelessWidget {
  final WorkoutExerciseDetail exercise;
  final int index;
  final VoidCallback onRemove;

  const ExerciseInputCard({
    super.key,
    required this.exercise,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 헤더: 운동 이름과 액션 버튼들
              Row(
                children: [
                  Expanded(
                    child: exercise.nameController.text.isEmpty
                        ? Text(
                            '운동 ${index + 1}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7280),
                            ),
                          )
                        : Text(
                            exercise.nameController.text,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                  ),
                  // 수정 버튼
                  GestureDetector(
                    onTap: () => _showEditDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 삭제 버튼
                  GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ],
              ),
              // 운동 정보 요약 표시
              if (exercise.nameController.text.isNotEmpty ||
                  exercise.sets.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (exercise.sets.isNotEmpty) ...[
                        Text(
                          '${exercise.sets.length}세트',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 4),
                        ...exercise.sets.asMap().entries.map((entry) {
                          final setIndex = entry.key;
                          final set = entry.value;
                          return Text(
                            '${setIndex + 1}세트: ${set.repsController.text}회${set.weightController.text.isNotEmpty ? ' @ ${set.weightController.text}kg' : ''}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ],
              if (exercise.memoController.text.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFBAE6FD)),
                  ),
                  child: Text(
                    exercise.memoController.text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0369A1),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('운동 ${index + 1} 수정'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: exercise.nameController,
                decoration: const InputDecoration(
                  labelText: '운동 이름',
                  hintText: '예: 벤치프레스',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('세트 목록 (${exercise.sets.length}세트)'),
                  const SizedBox(height: 8),
                  if (exercise.sets.isEmpty)
                    const Text(
                      '세트가 없습니다',
                      style: TextStyle(color: Color(0xFF6B7280)),
                    )
                  else
                    ...exercise.sets.asMap().entries.map((entry) {
                      final setIndex = entry.key;
                      final set = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '${setIndex + 1}세트: ${set.repsController.text}회${set.weightController.text.isNotEmpty ? ' @ ${set.weightController.text}kg' : ''}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: exercise.memoController,
                decoration: InputDecoration(
                  labelText: '운동 메모',
                  hintText: '세트별 느낌, 폼 체크 포인트 등',
                  labelStyle: const TextStyle(
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                  hintStyle: TextStyle(
                    color: const Color(0xFF10B981).withValues(alpha: 0.6),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF10B981),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF10B981),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF10B981).withValues(alpha: 0.05),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // setState를 호출하여 UI 업데이트 (부모에서 관리)
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              '저장',
              style: TextStyle(
                fontFamily: 'IBMPlexSansKR',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
