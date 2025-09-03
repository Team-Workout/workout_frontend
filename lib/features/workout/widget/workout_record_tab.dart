import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/workout_record_viewmodel.dart';
import '../model/workout_record_models.dart';
import '../model/routine_models.dart';
import '../../../common/widgets/exercise_autocomplete_field.dart';
import '../../../features/sync/model/sync_models.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 운동 섹션 헤더
            _buildHeader(),
            const SizedBox(height: 16),
            // 운동 목록 카드
            _buildExerciseList(),
            const SizedBox(height: 16),
            // 운동 추가 버튼 (목록 아래)
            _buildAddExerciseSection(),
            const SizedBox(height: 24),
            // 저장 버튼
            if (widget.viewModel.exercises.isNotEmpty) _buildSaveButton(),
            const SizedBox(height: 50), // 하단 여백
          ],
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
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        // 루틴 불러오기 버튼
        Material(
          color: const Color(0xFF28A745),
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: _showRoutineSelector,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.playlist_add, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    '루틴 불러오기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseList() {
    if (widget.viewModel.exercises.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.fitness_center_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  '운동을 추가해주세요',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
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
          // 역순으로 표시 (최신 운동이 위에)
          final reversedIndex = widget.viewModel.exercises.length - 1 - index;
          return _buildExerciseCard(
            widget.viewModel.exercises[reversedIndex],
            reversedIndex,
          );
        },
      ),
    );
  }

  Widget _buildAddExerciseSection() {
    return Card(
      elevation: _isFormExpanded ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:
              _isFormExpanded ? const Color(0xFF2C3E50) : Colors.grey.shade200,
          width: _isFormExpanded ? 2 : 1,
        ),
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
                ? const BorderRadius.vertical(top: Radius.circular(12))
                : BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isFormExpanded ? Colors.grey.shade50 : Colors.white,
                borderRadius: _isFormExpanded
                    ? const BorderRadius.vertical(top: Radius.circular(12))
                    : BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isFormExpanded ? Icons.close : Icons.add_circle,
                    color:
                        _isFormExpanded ? Colors.grey : const Color(0xFF2C3E50),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _isFormExpanded ? '취소' : '운동 추가하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _isFormExpanded
                          ? Colors.grey
                          : const Color(0xFF2C3E50),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 입력 폼 (펼쳤을 때만 보임)
          if (_isFormExpanded)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.all(16),
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '세트 정보',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _addSet,
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    label: const Text('세트 추가'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2C3E50),
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
                    style: TextStyle(color: Colors.grey),
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
          decoration: const InputDecoration(
            labelText: '메모 (선택)',
            hintText: '운동에 대한 메모를 입력하세요',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 20),

        // 추가 버튼
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _submitExercise,
            icon: const Icon(Icons.check),
            label: const Text('운동 추가'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C3E50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSetInputRow(int index) {
    final set = _currentSets[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // 세트 번호
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 무게 입력
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '무게 (kg)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: set.weightController,
                  decoration: InputDecoration(
                    hintText: '0',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
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
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: set.repsController,
                  decoration: InputDecoration(
                    hintText: '10',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // 삭제 버튼
          IconButton(
            onPressed: _currentSets.length > 1 ? () => _removeSet(index) : null,
            icon: Icon(
              Icons.remove_circle_outline,
              color: _currentSets.length > 1
                  ? Colors.red.shade400
                  : Colors.grey.shade300,
              size: 20,
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
      newSet.repsController.text = '10';
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
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_currentSets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('최소 1개 이상의 세트를 추가해주세요'),
          backgroundColor: Colors.orange,
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
        content: Text('운동이 추가되었습니다'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  Widget _buildExerciseCard(exercise, int index) {
    final isExpanded = _expandedStates[index] ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // 헤더 부분 (항상 보이는 부분)
          InkWell(
            onTap: () => _toggleCardExpansion(index),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isExpanded ? Colors.grey.shade50 : Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(12),
                  bottom: isExpanded
                      ? Radius.zero
                      : const Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  // 순서 표시
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C3E50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.viewModel.exercises.length - index}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 운동명 - 직접 편집 가능
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // 운동명을 바로 편집하기 위해 펼침
                            if (!isExpanded) {
                              setState(() {
                                _expandedStates[index] = true;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.transparent),
                            ),
                            child: Text(
                              exercise.nameController.text.isNotEmpty
                                  ? exercise.nameController.text
                                  : '운동 ${index + 1}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                          ),
                        ),
                        if (!isExpanded && exercise.sets.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${exercise.sets.length}세트',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // 삭제 버튼
                  IconButton(
                    onPressed: () => _removeExercise(index),
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.red),
                  ),
                  // 펼치기/접기 아이콘
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
          // 세부 내용 (펼쳐졌을 때만 보이는 부분)
          if (isExpanded)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _buildExpandedContent(exercise),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 운동명 편집 필드
        ExerciseAutocompleteField(
          controller: exercise.nameController,
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
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '세트 정보',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        exercise.addSet();
                        final newSet = exercise.sets.last;
                        newSet.weightController.text = '0';
                        newSet.repsController.text = '10';
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    label: const Text('세트 추가'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2C3E50),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (exercise.sets.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '세트를 추가해주세요',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ...List.generate(
                  exercise.sets.length,
                  (setIndex) => _buildEditableSetRow(exercise, setIndex),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // 메모 편집 필드
        TextField(
          controller: exercise.memoController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: '메모 (선택)',
            hintText: '운동에 대한 메모를 입력하세요',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          onChanged: (value) {
            setState(() {}); // UI 업데이트
          },
        ),
      ],
    );
  }

  Widget _buildEditableSetRow(exercise, int setIndex) {
    final set = exercise.sets[setIndex];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // 세트 번호
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${setIndex + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 무게 입력
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '무게 (kg)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: set.weightController,
                  decoration: InputDecoration(
                    hintText: '0',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
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
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: set.repsController,
                  decoration: InputDecoration(
                    hintText: '10',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // 삭제 버튼
          IconButton(
            onPressed: exercise.sets.length > 1
                ? () {
                    setState(() {
                      exercise.removeSet(setIndex);
                    });
                  }
                : null,
            icon: Icon(
              Icons.remove_circle_outline,
              color: exercise.sets.length > 1
                  ? Colors.red.shade400
                  : Colors.grey.shade300,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () async {
          try {
            await widget.viewModel.saveWorkoutToAPI();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text('운동 기록이 저장되었습니다!'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
                        child: Text('저장 실패: ${e.toString()}'),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF34495E), Color(0xFF2C3E50)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2C3E50).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '운동 기록 저장',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
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
                Text('저장된 루틴이 없습니다. 루틴을 먼저 만들어주세요.'),
              ],
            ),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
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
                const Icon(Icons.error, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text('루틴을 불러오는데 실패했습니다: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red,
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
      title: const Row(
        children: [
          Icon(Icons.playlist_play, color: Color(0xFF28A745)),
          SizedBox(width: 8),
          Text(
            '루틴 선택',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
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
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF28A745),
                  child:
                      Icon(Icons.fitness_center, color: Colors.white, size: 18),
                ),
                title: Text(
                  routine.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (routine.description != null) ...[
                      Text(
                        routine.description!,
                        style: const TextStyle(
                          color: Color(0xFF6C757D),
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (routine.routineExercises != null)
                      Text(
                        '${routine.routineExercises!.length}개 운동',
                        style: const TextStyle(
                          color: Color(0xFF28A745),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _selectRoutineAsTemplate(routine),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
      ],
    );
  }

  // 루틴을 템플릿으로 선택
  void _selectRoutineAsTemplate(RoutineResponse routine) async {
    Navigator.of(context).pop(); // 다이얼로그 닫기

    try {
      // 확인 다이얼로그 표시
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('루틴 적용'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('선택한 루틴: ${routine.name}'),
              const SizedBox(height: 8),
              const Text(
                '현재 작성 중인 운동 기록이 모두 지워지고 루틴이 적용됩니다. 계속하시겠습니까?',
                style: TextStyle(color: Color(0xFF6C757D)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF28A745),
                foregroundColor: Colors.white,
              ),
              child: const Text('적용'),
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
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text('루틴 "${routine.name}"이 적용되었습니다!'),
                ],
              ),
              backgroundColor: const Color(0xFF28A745),
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
                const Icon(Icons.error, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text('루틴 적용 실패: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red,
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
