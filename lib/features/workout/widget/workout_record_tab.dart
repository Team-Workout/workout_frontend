import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/workout_record_viewmodel.dart';
import '../model/workout_record_models.dart';
import '../model/routine_models.dart';
import '../../../common/widgets/exercise_autocomplete_field.dart';
import '../../../features/sync/model/sync_models.dart';
import '../../../core/theme/notion_colors.dart';
import '../../dashboard/widgets/notion_button.dart';
import 'workout_exercise_card.dart';
import 'workout_set_input.dart';

class WorkoutRecordTab extends ConsumerStatefulWidget {
  final WorkoutRecordViewmodel viewModel;

  const WorkoutRecordTab({super.key, required this.viewModel});

  @override
  ConsumerState<WorkoutRecordTab> createState() => _WorkoutRecordTabState();
}

class _WorkoutRecordTabState extends ConsumerState<WorkoutRecordTab> {
  bool _isFormExpanded = false;
  final _exerciseNameController = TextEditingController();
  final _memoController = TextEditingController();
  final List<WorkoutSet> _currentSets = [];

  Map<int, bool> _expandedStates = {}; // 운동 카드 펼침/접힘 상태

  @override
  void dispose() {
    _exerciseNameController.dispose();
    _memoController.dispose();
    for (var set in _currentSets) {
      set.dispose();
    }
    _currentSets.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'IBMPlexSansKR',
            ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 운동 섹션 헤더
              _buildHeader(),
              const SizedBox(height: 20),
              // 운동 목록 카드
              _buildExerciseList(),
              const SizedBox(height: 20),
              // 운동 추가 버튼 (목록 아래)
              _buildAddExerciseSection(),
              const SizedBox(height: 24),
              // 저장 버튼
              if (widget.viewModel.exercises.isNotEmpty) _buildSaveButton(),
              const SizedBox(height: 50), // 하단 여백
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '오늘의 운동',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        // 루틴 불러오기 버튼
        ElevatedButton.icon(
          onPressed: _showRoutineSelector,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          icon: const Icon(Icons.playlist_add, size: 18),
          label: const Text(
            '루틴 불러오기',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseList() {
    if (widget.viewModel.exercises.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fitness_center_outlined,
                    size: 48,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '운동을 추가해주세요',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'IBMPlexSansKR',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: List.generate(
        widget.viewModel.exercises.length,
        (index) {
          // 정순으로 표시 (1, 2, 3번 순서)
          final exercise = widget.viewModel.exercises[index];
          return WorkoutExerciseCard(
            exercise: exercise,
            index: index,
            isExpanded: _expandedStates[index] ?? false,
            onToggleExpanded: () => _toggleCardExpansion(index),
            onRemove: () => _removeExercise(index),
            onRemoveSet: (ex, setIndex) {
              setState(() {
                ex.removeSet(setIndex);
              });
            },
            onAddSet: (ex) {
              setState(() {
                ex.addSet();
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildAddExerciseSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFormExpanded ? const Color(0xFF4CAF50) : Colors.grey[200]!,
          width: _isFormExpanded ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 추가 버튼 헤더
          InkWell(
            onTap: () {
              setState(() {
                _isFormExpanded = !_isFormExpanded;
                if (!_isFormExpanded) {
                  // 폼을 닫을 때 초기화
                  _exerciseNameController.clear();
                  _memoController.clear();
                  for (var set in _currentSets) {
                    set.dispose();
                  }
                  _currentSets.clear();
                } else {
                  // 폼을 열 때 기본 세트 추가
                  if (_currentSets.isEmpty) {
                    _addSet();
                  }
                }
              });
            },
            borderRadius: _isFormExpanded
                ? const BorderRadius.vertical(top: Radius.circular(16))
                : BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _isFormExpanded
                    ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
                    : Colors.white,
                borderRadius: _isFormExpanded
                    ? const BorderRadius.vertical(top: Radius.circular(16))
                    : BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _isFormExpanded
                          ? Colors.grey[300]
                          : const Color(0xFF4CAF50).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isFormExpanded ? Icons.close : Icons.add,
                      color: _isFormExpanded
                          ? Colors.grey
                          : const Color(0xFF4CAF50),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _isFormExpanded ? '취소' : '운동 추가하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _isFormExpanded ? Colors.grey : Colors.black,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 입력 폼 (펼쳤을 때만 보임)
          if (_isFormExpanded)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _buildInputForm(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 운동 이름
        ExerciseAutocompleteField(
          controller: _exerciseNameController,
          labelText: '운동 이름',
          hintText: '운동 이름을 입력하세요',
          onExerciseSelected: (selectedExercise) {
            // 운동이 선택되었을 때 추가 처리가 필요하면 여기에
            print('Selected exercise: ${selectedExercise.name}');
          },
        ),
        const SizedBox(height: 16),

        // 세트 섹션
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '세트 정보',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addSet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text(
                      '세트 추가',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_currentSets.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '세트를 추가해주세요',
                    style: TextStyle(color: NotionColors.textSecondary),
                  ),
                )
              else
                ...List.generate(
                  _currentSets.length,
                  (index) => _buildSetInputRow(index),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 메모
        TextField(
          controller: _memoController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: '🏋️ 운동 메모',
            hintText: '운동에 대한 메모를 입력하세요',
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
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 20),

        // 추가 버튼
        SizedBox(
          width: double.infinity,
          child: NotionButton(
            onPressed: _submitExercise,
            text: '운동 추가',
            icon: Icons.check,
          ),
        ),
      ],
    );
  }

  Widget _buildSetInputRow(int index) {
    final set = _currentSets[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 세트 레이블과 삭제 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${index + 1}세트',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ),
              if (_currentSets.length > 1)
                GestureDetector(
                  onTap: () => _removeSet(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD32F2F).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Color(0xFFD32F2F),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // 입력 필드들
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                // 무게 입력
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '무게 (kg)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: set.weightController,
                        decoration: InputDecoration(
                          hintText: '0',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xFF4CAF50), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          suffixText: 'kg',
                          suffixStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*')),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // 횟수 입력
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '횟수',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: set.repsController,
                        decoration: InputDecoration(
                          hintText: '0',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xFF4CAF50), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          suffixText: '회',
                          suffixStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 세트별 메모 입력 필드
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.note_alt_outlined,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '세트 메모',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                    ),
                  ),
                  child: TextField(
                    controller: set.memoController,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'IBMPlexSansKR',
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: '💡 이 세트에 대한 메모를 입력하세요',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFF10B981).withValues(alpha: 0.7),
                        fontFamily: 'IBMPlexSansKR',
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addSet() {
    setState(() {
      final newSet = WorkoutSet();
      newSet.weightController.text = '0';
      newSet.repsController.text = '0';
      _currentSets.add(newSet);
    });
  }

  void _removeSet(int index) {
    setState(() {
      _currentSets[index].dispose();
      _currentSets.removeAt(index);
    });
  }

  void _submitExercise() {
    // 유효성 검사
    if (_exerciseNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('운동 이름을 입력해주세요'),
          backgroundColor: NotionColors.error,
        ),
      );
      return;
    }

    if (_currentSets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('최소 1개 이상의 세트를 추가해주세요'),
          backgroundColor: NotionColors.error,
        ),
      );
      return;
    }

    // 새 운동 추가
    widget.viewModel.addExercise();
    final newExercise = widget.viewModel.exercises.last;

    // 입력된 정보 설정
    newExercise.nameController.text = _exerciseNameController.text;
    newExercise.memoController.text = _memoController.text;

    // 세트 정보 복사
    for (var set in _currentSets) {
      newExercise.addSet();
      final newSet = newExercise.sets.last;
      newSet.weightController.text = set.weightController.text;
      newSet.repsController.text = set.repsController.text;
      newSet.memoController.text = set.memoController.text;
    }

    // 입력 폼 초기화 및 닫기
    setState(() {
      _exerciseNameController.clear();
      _memoController.clear();
      for (var set in _currentSets) {
        set.dispose();
      }
      _currentSets.clear();
      _isFormExpanded = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '운동이 추가되었습니다',
          style: TextStyle(
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        backgroundColor: Color(0xFF4CAF50),
        duration: Duration(seconds: 1),
      ),
    );
  }




  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          try {
            await widget.viewModel.saveWorkoutToAPI();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '운동 기록이 저장되었습니다!',
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xFF4CAF50),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '저장 실패: ${e.toString()}',
                          style: const TextStyle(
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          '운동 기록 저장',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
      ),
    );
  }

  void _toggleCardExpansion(int index) {
    setState(() {
      _expandedStates[index] = !(_expandedStates[index] ?? false);
    });
  }

  void _removeExercise(int index) {
    // 펼침 상태 정리
    _expandedStates.remove(index);

    // 인덱스가 변경되므로 뒷 인덱스들을 앞으로 이동
    final newExpandedStates = <int, bool>{};

    for (var entry in _expandedStates.entries) {
      if (entry.key > index) {
        newExpandedStates[entry.key - 1] = entry.value;
      } else if (entry.key < index) {
        newExpandedStates[entry.key] = entry.value;
      }
    }

    _expandedStates = newExpandedStates;

    // ViewModel에서 실제 운동 삭제
    widget.viewModel.removeExercise(index);

    // UI 업데이트
    setState(() {});
  }

  // 루틴 선택 다이얼로그 표시
  void _showRoutineSelector() async {
    try {
      // 내 루틴 목록 불러오기
      final routines = await widget.viewModel.getMyRoutines();

      if (!mounted) return;

      if (routines.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '저장된 루틴이 없습니다. 루틴을 먼저 만들어주세요.',
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF4CAF50),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        return;
      }

      // 루틴 선택 다이얼로그 표시
      showDialog(
        context: context,
        builder: (context) => _buildRoutineSelectionDialog(routines),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: NotionColors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text('루틴을 불러오는데 실패했습니다: ${e.toString()}')),
              ],
            ),
            backgroundColor: NotionColors.error,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  // 루틴 선택 다이얼로그 위젯
  Widget _buildRoutineSelectionDialog(List<RoutineResponse> routines) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Row(
        children: [
          Icon(Icons.playlist_play, color: Color(0xFF4CAF50)),
          SizedBox(width: 8),
          Text(
            '루틴 선택',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ],
      ),
      content: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxHeight: 400),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: routines.length,
          itemBuilder: (context, index) {
            final routine = routines[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.fitness_center,
                      color: Color(0xFF4CAF50), size: 20),
                ),
                title: Text(
                  routine.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (routine.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        routine.description!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    if (routine.routineExercises != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${routine.routineExercises!.length}개 운동',
                          style: const TextStyle(
                            color: Color(0xFF4CAF50),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ),
                  ],
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: () {
                  Navigator.of(context).pop(); // 선택 다이얼로그 먼저 닫기
                  _selectRoutineAsTemplate(routine);
                },
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('취소'),
        ),
      ],
    );
  }

  // 루틴을 템플릿으로 선택
  void _selectRoutineAsTemplate(RoutineResponse routine) async {
    // 이미 onTap에서 다이얼로그가 닫혔으므로 여기서는 추가 처리 없음
    if (!mounted) return;

    try {
      // 확인 다이얼로그 표시
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            '루틴 적용',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '선택한 루틴: ${routine.name}',
                style: const TextStyle(
                  fontFamily: 'IBMPlexSansKR',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '현재 작성 중인 운동 기록이 모두 지워지고 루틴이 적용됩니다. 계속하시겠습니까?',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              child: const Text(
                '취소',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '적용',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        // 루틴을 운동기록으로 변환
        await widget.viewModel.loadRoutineAsTemplate(routine);

        // 성공 메시지
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: NotionColors.white, size: 20),
                  const SizedBox(width: 8),
                  Text('루틴 "${routine.name}"이 적용되었습니다!'),
                ],
              ),
              backgroundColor: NotionColors.black,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: NotionColors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text('루틴 적용 실패: ${e.toString()}')),
              ],
            ),
            backgroundColor: NotionColors.error,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }
}
