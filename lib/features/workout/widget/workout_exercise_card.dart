import 'package:flutter/material.dart';
import '../model/workout_record_models.dart';
import '../../../core/theme/notion_colors.dart';
import '../../../common/widgets/exercise_autocomplete_field.dart';
import 'workout_set_input.dart';

class WorkoutExerciseCard extends StatefulWidget {
  final WorkoutExerciseDetail exercise;
  final int index;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final VoidCallback onRemove;
  final Function(WorkoutExerciseDetail, int) onRemoveSet;
  final Function(WorkoutExerciseDetail) onAddSet;

  const WorkoutExerciseCard({
    Key? key,
    required this.exercise,
    required this.index,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onRemove,
    required this.onRemoveSet,
    required this.onAddSet,
  }) : super(key: key);

  @override
  State<WorkoutExerciseCard> createState() => _WorkoutExerciseCardState();
}

class _WorkoutExerciseCardState extends State<WorkoutExerciseCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: NotionColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // 헤더 부분 (항상 보이는 부분)
          _buildHeader(),
          
          // 펼쳐진 내용
          if (widget.isExpanded) _buildExpandedContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: widget.onToggleExpanded,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isExpanded ? NotionColors.gray100 : NotionColors.white,
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(12),
            bottom: widget.isExpanded ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Row(
          children: [
            // 순서 표시
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${widget.index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // 운동명
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (!widget.isExpanded) {
                    widget.onToggleExpanded();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        color: NotionColors.border.withValues(alpha: 0.0)),
                  ),
                  child: Text(
                    widget.exercise.nameController.text.isNotEmpty
                        ? widget.exercise.nameController.text
                        : '운동 ${widget.index + 1}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: NotionColors.black,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
              ),
            ),
            
            // 펼침/접힘 아이콘
            Icon(
              widget.isExpanded ? Icons.expand_less : Icons.expand_more,
              color: NotionColors.gray600,
            ),
            
            // 삭제 버튼
            const SizedBox(width: 8),
            GestureDetector(
              onTap: widget.onRemove,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFD32F2F).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Color(0xFFD32F2F),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 운동명 편집 필드
          ExerciseAutocompleteField(
            controller: widget.exercise.nameController,
            labelText: '운동 이름',
            hintText: '운동 이름을 입력하세요',
            onExerciseSelected: (selectedExercise) {
              print('Selected exercise for workout record: ${selectedExercise.name}');
            },
            onTextChanged: (value) {
              setState(() {}); // UI 업데이트
            },
          ),
          const SizedBox(height: 16),

          // 세트 섹션
          _buildSetsSection(),
          const SizedBox(height: 16),

          // 운동별 메모 편집 필드
          TextField(
            controller: widget.exercise.memoController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: '운동 메모 (선택)',
              hintText: '이 운동에 대한 전체 메모를 입력하세요',
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetsSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: NotionColors.gray100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: NotionColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 세트 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '세트',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: NotionColors.black,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => widget.onAddSet(widget.exercise),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text(
                  '세트 추가',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // 세트 목록
          ...List.generate(
            widget.exercise.sets.length,
            (setIndex) {
              print('🔧 WorkoutExerciseCard generating WorkoutSetInput for setIndex: $setIndex');
              return WorkoutSetInput(
                exercise: widget.exercise,
                setIndex: setIndex,
                onRemove: () => widget.onRemoveSet(widget.exercise, setIndex),
              );
            },
          ),
        ],
      ),
    );
  }
}