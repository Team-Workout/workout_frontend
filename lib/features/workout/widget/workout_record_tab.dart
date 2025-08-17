import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../viewmodel/workout_record_viewmodel.dart';
import '../model/workout_record_models.dart';

class WorkoutRecordTab extends StatefulWidget {
  final WorkoutRecordViewmodel viewModel;

  const WorkoutRecordTab({super.key, required this.viewModel});

  @override
  State<WorkoutRecordTab> createState() => _WorkoutRecordTabState();
}

class _WorkoutRecordTabState extends State<WorkoutRecordTab> {
  bool _isFormExpanded = false;
  final _exerciseNameController = TextEditingController();
  final _memoController = TextEditingController();
  final List<WorkoutSet> _currentSets = [];
  
  Map<int, bool> _editingStates = {};
  Map<int, Map<String, TextEditingController>> _editControllers = {};
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
    return Container(
      color: const Color(0xFFF8F9FA),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 운동 기록하기 섹션
          const Text(
            '운동 기록하기',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212529),
            ),
          ),
          const SizedBox(height: 24),
          
          // 접기/펼치기 가능한 입력 폼
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // 폼 헤더 (항상 보임)
                InkWell(
                  onTap: () {
                    setState(() {
                      _isFormExpanded = !_isFormExpanded;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _isFormExpanded ? const Color(0xFFF8F9FA) : Colors.transparent,
                      borderRadius: _isFormExpanded 
                          ? const BorderRadius.vertical(top: Radius.circular(12))
                          : BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isFormExpanded 
                              ? Icons.keyboard_arrow_up 
                              : Icons.keyboard_arrow_down,
                          color: const Color(0xFF6C757D),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '운동 추가하기',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF212529),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // 입력 폼 (펼쳤을 때만 보임)
                if (_isFormExpanded) _buildInputForm(),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // 오늘의 운동 섹션
          const Text(
            "오늘의 운동",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212529),
            ),
          ),
          const SizedBox(height: 16),
          
          // 운동 목록
          if (widget.viewModel.exercises.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE9ECEF)),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.fitness_center_outlined,
                    size: 48,
                    color: Color(0xFFADB5BD),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '아직 기록된 운동이 없습니다',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6C757D),
                    ),
                  ),
                ],
              ),
            )
          else
            ...widget.viewModel.exercises.asMap().entries.map((entry) {
              final index = entry.key;
              final exercise = entry.value;
              return _buildExerciseCard(exercise, index);
            }),
        ],
      ),
    );
  }

  Widget _buildInputForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 운동 이름
          const Text(
            '운동 이름',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF495057),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _exerciseNameController,
            decoration: InputDecoration(
              hintText: '예: 벤치프레스, 스쿼트 등',
              hintStyle: const TextStyle(color: Color(0xFFADB5BD)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0D6EFD)),
              ),
              contentPadding: const EdgeInsets.all(16),
              suffixIcon: const Icon(Icons.fitness_center, color: Color(0xFFADB5BD)),
            ),
          ),
          const SizedBox(height: 20),
          
          // 세트 목록
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '세트',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF495057),
                ),
              ),
              GestureDetector(
                onTap: _addSet,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D6EFD),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '세트 추가',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // 개별 세트들
          if (_currentSets.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFDEE2E6)),
              ),
              child: const Center(
                child: Text(
                  '세트 추가 버튼을 눌러 세트를 추가하세요',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C757D),
                  ),
                ),
              ),
            )
          else
            ...List.generate(_currentSets.length, (index) => _buildSetRow(index)),
          const SizedBox(height: 20),
          
          // 메모 필드
          const Text(
            '메모 (선택사항)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF495057),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _memoController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '세트별 느낌, 폼 체크 포인트 등을 기록하세요',
              hintStyle: const TextStyle(color: Color(0xFFADB5BD)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0D6EFD)),
              ),
              contentPadding: const EdgeInsets.all(16),
              suffixIcon: const Icon(Icons.note_alt_outlined, color: Color(0xFFADB5BD)),
            ),
          ),
          const SizedBox(height: 24),
          
          // Add Exercise Button (ElevatedButton 대신 Container 사용!)
          GestureDetector(
            onTap: () async {
              await _addExercise();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF212529),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    '운동 추가',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(exercise, int index) {
    final isEditing = _editingStates[index] ?? false;
    final isExpanded = _expandedStates[index] ?? true; // 기본적으로 펼쳐진 상태
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: isEditing ? _buildEditForm(exercise, index) : _buildViewCard(exercise, index, isExpanded),
    );
  }
  
  Widget _buildViewCard(exercise, int index, bool isExpanded) {
    return Column(
      children: [
        // 항상 보이는 헤더 부분 (접기/펼치기 가능)
        InkWell(
          onTap: () => _toggleCardExpansion(index),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isExpanded ? const Color(0xFFF8F9FA) : Colors.transparent,
              borderRadius: isExpanded 
                  ? const BorderRadius.vertical(top: Radius.circular(12))
                  : BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // 펼침/접힘 아이콘
                    Icon(
                      isExpanded 
                          ? Icons.keyboard_arrow_up 
                          : Icons.keyboard_arrow_down,
                      color: const Color(0xFF6C757D),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    // 운동 이름
                    Expanded(
                      child: Text(
                        exercise.nameController.text.isNotEmpty 
                            ? exercise.nameController.text 
                            : '운동 ${index + 1}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212529),
                        ),
                      ),
                    ),
                    // 세트 수 요약 (접힌 상태에서만 표시)
                    if (!isExpanded && exercise.sets.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D6EFD).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${exercise.sets.length}세트',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0D6EFD),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    // 액션 버튼들
                    GestureDetector(
                      onTap: () => _startEditing(exercise, index),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _removeExercise(index),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // 펼쳐진 상태에서만 보이는 상세 정보 (애니메이션 적용)
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: isExpanded 
              ? CrossFadeState.showSecond 
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: _buildExpandedContent(exercise),
        ),
      ],
    );
  }
  
  Widget _buildExpandedContent(exercise) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (exercise.sets.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFE9ECEF)),
              ),
              child: const Center(
                child: Text(
                  '세트가 없습니다',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C757D),
                  ),
                ),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '세트 기록',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF495057),
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(exercise.sets.length, (index) {
                  final set = exercise.sets[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE9ECEF)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${index + 1}세트:',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF495057),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${set.repsController.text}회',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF212529),
                              ),
                            ),
                            if (set.weightController.text.isNotEmpty) ...[
                              const SizedBox(width: 12),
                              Text(
                                '@ ${set.weightController.text}kg',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6C757D),
                                ),
                              ),
                            ],
                          ],
                        ),
                        // 세트별 메모 표시
                        if (set.memoController.text.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFFBBDEFB)),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.note_alt_outlined,
                                  size: 14,
                                  color: Color(0xFF1976D2),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    set.memoController.text,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF1976D2),
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
          if (exercise.memoController.text.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '메모',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0369A1),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exercise.memoController.text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0369A1),
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
  
  Widget _buildEditForm(exercise, int index) {
    final controllers = _editControllers[index]!;
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '운동 수정하기',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212529),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _cancelEditing(index),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xFF6C757D),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _saveEditing(exercise, index),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.check,
                        size: 20,
                        color: Color(0xFF28A745),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 운동 이름
          const Text(
            '운동 이름',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF495057),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controllers['name']!,
            decoration: InputDecoration(
              hintText: '예: 벤치프레스, 스쿼트 등',
              hintStyle: const TextStyle(color: Color(0xFFADB5BD)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0D6EFD)),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 16),
          
          // 세트 편집
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '세트',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF495057),
                ),
              ),
              GestureDetector(
                onTap: () => _addEditSet(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D6EFD),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '세트 추가',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // 편집 중인 세트들
          if (exercise.sets.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFDEE2E6)),
              ),
              child: const Center(
                child: Text(
                  '세트 추가 버튼을 눌러 세트를 추가하세요',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C757D),
                  ),
                ),
              ),
            )
          else
            ...List.generate(exercise.sets.length, (setIndex) => _buildEditSetRow(exercise, setIndex)),
          const SizedBox(height: 16),
          
          // 메모 필드
          const Text(
            '메모 (선택사항)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF495057),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controllers['memo']!,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '세트별 느낌, 폼 체크 포인트 등을 기록하세요',
              hintStyle: const TextStyle(color: Color(0xFFADB5BD)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0D6EFD)),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }


  // 유효성 검사 함수
  String? _validateExercise() {
    // 운동명 검사
    if (_exerciseNameController.text.trim().isEmpty) {
      return '운동명을 입력해주세요.';
    }
    
    // 세트 개수 검사
    if (_currentSets.isEmpty) {
      return '최소 1개 이상의 세트를 추가해주세요.';
    }
    
    // 각 세트의 무게/횟수 검사
    for (int i = 0; i < _currentSets.length; i++) {
      final set = _currentSets[i];
      
      // 횟수 검사
      if (set.repsController.text.trim().isEmpty) {
        return '${i + 1}번째 세트의 횟수를 입력해주세요.';
      }
      
      final reps = int.tryParse(set.repsController.text.trim());
      if (reps == null || reps <= 0) {
        return '${i + 1}번째 세트의 횟수는 1 이상의 숫자여야 합니다.';
      }
      
      if (reps > 1000) {
        return '${i + 1}번째 세트의 횟수는 1000 이하여야 합니다.';
      }
      
      // 무게 검사
      if (set.weightController.text.trim().isEmpty) {
        return '${i + 1}번째 세트의 무게를 입력해주세요.';
      }
      
      final weight = double.tryParse(set.weightController.text.trim());
      if (weight == null || weight < 0) {
        return '${i + 1}번째 세트의 무게는 0 이상의 숫자여야 합니다.';
      }
      
      if (weight > 1000) {
        return '${i + 1}번째 세트의 무게는 1000kg 이하여야 합니다.';
      }
    }
    
    return null; // 유효성 검사 통과
  }
  
  Future<void> _addExercise() async {
    // 유효성 검사 수행
    final validationError = _validateExercise();
    if (validationError != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.warning, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(validationError)),
              ],
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
      return;
    }
    
    // 유효성 검사 통과 시 운동 추가
    try {
      // 새 운동을 ViewModel에 추가
      widget.viewModel.addExercise();
      
      // 방금 추가된 운동에 입력된 정보 설정
      final lastExercise = widget.viewModel.exercises.last;
      lastExercise.nameController.text = _exerciseNameController.text;
      lastExercise.memoController.text = _memoController.text;
      
      // 세트 정보 복사
      for (var set in _currentSets) {
        lastExercise.addSet();
        final newSet = lastExercise.sets.last;
        newSet.repsController.text = set.repsController.text;
        newSet.weightController.text = set.weightController.text;
        newSet.memoController.text = set.memoController.text;
      }
      
      // API로 운동 기록 저장
      await widget.viewModel.saveWorkoutToAPI();
      
      // 성공 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('운동 기록이 성공적으로 저장되었습니다!'),
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
      
      // 입력 필드 초기화
      _exerciseNameController.clear();
      _memoController.clear();
      for (var set in _currentSets) {
        set.dispose();
      }
      _currentSets.clear();
      
      // 폼 접기
      setState(() {
        _isFormExpanded = false;
      });
    } catch (e) {
      // API 에러 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '저장 실패: ${e is Exception ? e.toString().replaceAll('Exception: ', '') : '서버 오류가 발생했습니다'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            action: SnackBarAction(
              label: '다시시도',
              textColor: Colors.white,
              onPressed: () => _addExercise(),
            ),
          ),
        );
      }
    }
  }

  void _startEditing(exercise, int index) {
    // 편집용 컨트롤러 생성
    _editControllers[index] = {
      'name': TextEditingController(text: exercise.nameController.text),
      'memo': TextEditingController(text: exercise.memoController.text),
    };
    
    setState(() {
      _editingStates[index] = true;
    });
  }
  
  void _cancelEditing(int index) {
    // 컨트롤러 정리
    final controllers = _editControllers[index];
    if (controllers != null) {
      controllers.values.forEach((controller) => controller.dispose());
      _editControllers.remove(index);
    }
    
    setState(() {
      _editingStates[index] = false;
    });
  }
  
  void _saveEditing(exercise, int index) {
    final controllers = _editControllers[index]!;
    
    // 실제 운동 데이터에 변경사항 적용
    exercise.nameController.text = controllers['name']!.text;
    exercise.memoController.text = controllers['memo']!.text;
    
    // 컨트롤러 정리
    controllers.values.forEach((controller) => controller.dispose());
    _editControllers.remove(index);
    
    setState(() {
      _editingStates[index] = false;
    });
  }
  
  void _addSet() {
    setState(() {
      _currentSets.add(WorkoutSet());
    });
  }
  
  Widget _buildSetRow(int index) {
    final set = _currentSets[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${index + 1}세트',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212529),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _removeSet(index),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: Color(0xFF6C757D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '횟수',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF495057),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: set.repsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '횟수',
                        hintStyle: const TextStyle(color: Color(0xFFADB5BD)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFF0D6EFD)),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '중량 (kg)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF495057),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: set.weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // 숫자와 소수점만 허용
                        LengthLimitingTextInputFormatter(6), // 최대 6자리 (999.99)
                      ],
                      decoration: InputDecoration(
                        hintText: '무게 (0-1000kg)',
                        hintStyle: const TextStyle(color: Color(0xFFADB5BD)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFF0D6EFD)),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        suffixText: 'kg',
                        suffixStyle: const TextStyle(
                          color: Color(0xFFADB5BD),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 세트별 메모 필드 추가
          const Text(
            '세트 메모 (선택사항)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF495057),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: set.memoController,
            decoration: InputDecoration(
              hintText: '세트에 대한 느낌이나 메모를 입력하세요',
              hintStyle: const TextStyle(color: Color(0xFFADB5BD)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFF0D6EFD)),
              ),
              contentPadding: const EdgeInsets.all(12),
              suffixIcon: const Icon(Icons.note_alt_outlined, 
                color: Color(0xFFADB5BD), size: 18),
            ),
          ),
        ],
      ),
    );
  }
  
  void _removeSet(int index) {
    setState(() {
      _currentSets[index].dispose();
      _currentSets.removeAt(index);
    });
  }
  
  void _addEditSet(int exerciseIndex) {
    final exercise = widget.viewModel.exercises[exerciseIndex];
    setState(() {
      exercise.addSet();
    });
  }
  
  Widget _buildEditSetRow(exercise, int setIndex) {
    final set = exercise.sets[setIndex];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${setIndex + 1}세트',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212529),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _removeEditSet(exercise, setIndex),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: Color(0xFF6C757D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '횟수',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF495057),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: set.repsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '횟수',
                        hintStyle: const TextStyle(color: Color(0xFFADB5BD)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFF0D6EFD)),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '중량 (kg)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF495057),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: set.weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // 숫자와 소수점만 허용
                        LengthLimitingTextInputFormatter(6), // 최대 6자리 (999.99)
                      ],
                      decoration: InputDecoration(
                        hintText: '무게 (0-1000kg)',
                        hintStyle: const TextStyle(color: Color(0xFFADB5BD)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Color(0xFF0D6EFD)),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                        suffixText: 'kg',
                        suffixStyle: const TextStyle(
                          color: Color(0xFFADB5BD),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 편집 모드에서도 세트별 메모 필드 추가
          const Text(
            '세트 메모 (선택사항)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF495057),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: set.memoController,
            decoration: InputDecoration(
              hintText: '세트에 대한 느낌이나 메모를 입력하세요',
              hintStyle: const TextStyle(color: Color(0xFFADB5BD)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFF0D6EFD)),
              ),
              contentPadding: const EdgeInsets.all(12),
              suffixIcon: const Icon(Icons.note_alt_outlined, 
                color: Color(0xFFADB5BD), size: 18),
            ),
          ),
        ],
      ),
    );
  }
  
  void _removeEditSet(exercise, int setIndex) {
    setState(() {
      exercise.removeSet(setIndex);
    });
  }
  
  void _toggleCardExpansion(int index) {
    setState(() {
      _expandedStates[index] = !(_expandedStates[index] ?? true); // 기본값이 true이므로 동일하게
    });
  }

  void _removeExercise(int index) {
    // 편집 관련 상태 정리
    final controllers = _editControllers[index];
    if (controllers != null) {
      controllers.values.forEach((controller) => controller.dispose());
      _editControllers.remove(index);
    }
    _editingStates.remove(index);
    _expandedStates.remove(index);

    // 인덱스가 변경되므로 뒷 인덱스들을 앞으로 이동
    final newEditControllers = <int, Map<String, TextEditingController>>{};
    final newEditingStates = <int, bool>{};
    final newExpandedStates = <int, bool>{};

    for (var entry in _editControllers.entries) {
      if (entry.key > index) {
        newEditControllers[entry.key - 1] = entry.value;
      } else if (entry.key < index) {
        newEditControllers[entry.key] = entry.value;
      }
    }

    for (var entry in _editingStates.entries) {
      if (entry.key > index) {
        newEditingStates[entry.key - 1] = entry.value;
      } else if (entry.key < index) {
        newEditingStates[entry.key] = entry.value;
      }
    }

    for (var entry in _expandedStates.entries) {
      if (entry.key > index) {
        newExpandedStates[entry.key - 1] = entry.value;
      } else if (entry.key < index) {
        newExpandedStates[entry.key] = entry.value;
      }
    }

    _editControllers = newEditControllers;
    _editingStates = newEditingStates;
    _expandedStates = newExpandedStates;

    // ViewModel에서 실제 운동 삭제
    widget.viewModel.removeExercise(index);

    // UI 업데이트
    setState(() {});
  }
}
