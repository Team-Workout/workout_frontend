import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/workout_record_viewmodel.dart';
import '../viewmodel/routine_viewmodel.dart';
import '../model/routine_models.dart';
import '../../../common/widgets/enhanced_exercise_selector.dart';
import '../../../common/constants/muscle_translations.dart';
import '../../../features/sync/model/sync_models.dart';
import '../../../core/theme/notion_colors.dart';

class WorkoutRoutineTab extends ConsumerStatefulWidget {
  final WorkoutRecordViewmodel viewModel;

  const WorkoutRoutineTab({super.key, required this.viewModel});

  @override
  ConsumerState<WorkoutRoutineTab> createState() => _WorkoutRoutineTabState();
}

class _WorkoutRoutineTabState extends ConsumerState<WorkoutRoutineTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<RoutineExercise> _routineExercises = [];
  List<Map<String, dynamic>> _availableExercises = [];
  bool _isLoading = false;
  final Map<int, bool> _expandedCards = {};
  bool _basicInfoExpanded = false;

  // 각 운동별 자동완성 컨트롤러와 선택된 운동 정보
  final Map<int, TextEditingController> _exerciseControllers = {};
  final Map<int, Exercise?> _selectedExercises = {};

  @override
  void initState() {
    super.initState();
    _loadAvailableExercises();
    // 이름 변경시 UI 업데이트를 위한 리스너 추가
    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    // 모든 운동 컨트롤러 해제
    for (final controller in _exerciseControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadAvailableExercises() async {
    setState(() => _isLoading = true);
    // 더 이상 API를 직접 호출하지 않고, 자동완성 필드가 동기화된 데이터를 사용함
    _availableExercises = []; // 빈 배열로 설정 (자동완성 필드에서 동기화된 데이터 사용)
    setState(() => _isLoading = false);
  }

  void _addExercise() {
    setState(() {
      final newIndex = _routineExercises.length;

      // 새로운 운동용 컨트롤러 생성
      _exerciseControllers[newIndex] = TextEditingController();
      _selectedExercises[newIndex] = null;

      _routineExercises.add(
        RoutineExercise(
          exerciseId: 0, // 선택되지 않은 상태
          order: newIndex + 1,
          routineSets: [
            RoutineSet(
              order: 1,
              weight: 0,
              reps: 0,
            ),
          ],
        ),
      );
      _expandedCards[newIndex] = true; // 새로 추가된 카드는 기본적으로 펼쳐진 상태
    });
  }

  void _removeExercise(int index) {
    setState(() {
      _routineExercises.removeAt(index);
      _expandedCards.remove(index);

      // 컨트롤러 정리
      _exerciseControllers[index]?.dispose();
      _exerciseControllers.remove(index);
      _selectedExercises.remove(index);

      // 인덱스 재정렬
      final newExpandedCards = <int, bool>{};
      final newControllers = <int, TextEditingController>{};
      final newSelectedExercises = <int, Exercise?>{};

      _expandedCards.forEach((key, value) {
        if (key > index) {
          newExpandedCards[key - 1] = value;
        } else if (key < index) {
          newExpandedCards[key] = value;
        }
      });

      _exerciseControllers.forEach((key, value) {
        if (key > index) {
          newControllers[key - 1] = value;
        } else if (key < index) {
          newControllers[key] = value;
        }
      });

      _selectedExercises.forEach((key, value) {
        if (key > index) {
          newSelectedExercises[key - 1] = value;
        } else if (key < index) {
          newSelectedExercises[key] = value;
        }
      });

      _expandedCards.clear();
      _expandedCards.addAll(newExpandedCards);
      _exerciseControllers.clear();
      _exerciseControllers.addAll(newControllers);
      _selectedExercises.clear();
      _selectedExercises.addAll(newSelectedExercises);

      for (int i = 0; i < _routineExercises.length; i++) {
        _routineExercises[i] = _routineExercises[i].copyWith(order: i + 1);
      }
    });
  }

  void _addSet(int exerciseIndex) {
    setState(() {
      final exercise = _routineExercises[exerciseIndex];
      final newSets = List<RoutineSet>.from(exercise.routineSets);
      newSets.add(
        RoutineSet(
          order: newSets.length + 1,
          weight: 0,
          reps: 0,
        ),
      );
      _routineExercises[exerciseIndex] =
          exercise.copyWith(routineSets: newSets);
    });
  }

  void _removeSet(int exerciseIndex, int setIndex) {
    setState(() {
      final exercise = _routineExercises[exerciseIndex];
      final newSets = List<RoutineSet>.from(exercise.routineSets);
      newSets.removeAt(setIndex);
      for (int i = 0; i < newSets.length; i++) {
        newSets[i] = newSets[i].copyWith(order: i + 1);
      }
      _routineExercises[exerciseIndex] =
          exercise.copyWith(routineSets: newSets);
    });
  }

  Future<void> _saveRoutine() async {
    if (_routineExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('최소 하나의 운동을 추가해주세요')),
      );
      return;
    }

    // 각 운동의 선택 및 세트 검증
    for (int i = 0; i < _routineExercises.length; i++) {
      final exercise = _routineExercises[i];

      // 운동이 선택되었는지 확인
      if (_selectedExercises[i] == null || exercise.exerciseId == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${i + 1}번째 운동을 선택해주세요')),
        );
        return;
      }

      if (exercise.routineSets.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${i + 1}번째 운동에 최소 하나의 세트를 추가해주세요')),
        );
        return;
      }

      for (int j = 0; j < exercise.routineSets.length; j++) {
        final set = exercise.routineSets[j];

        if (set.weight < 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('${i + 1}번째 운동 ${j + 1}세트: 무게는 0 이상이어야 합니다')),
          );
          return;
        }

        if (set.reps <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('${i + 1}번째 운동 ${j + 1}세트: 횟수는 1 이상이어야 합니다')),
          );
          return;
        }
      }
    }

    setState(() => _isLoading = true);

    try {
      final request = CreateRoutineRequest(
        name: _nameController.text.trim().isEmpty
            ? null
            : _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        routineExercises: _routineExercises,
      );

      final response =
          await widget.viewModel.workoutApiService.createRoutine(request);

      // 루틴 리스트 새로고침
      await ref.read(routineProvider.notifier).loadRoutines();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('루틴이 성공적으로 저장되었습니다'),
          backgroundColor: Color(0xFF10B981),
        ),
      );

      _resetForm();

      // 이전 화면으로 돌아가기 (보통 루틴 리스트 화면)
      // Navigator.canPop() 확인 후 pop 실행
      if (Navigator.canPop(context)) {
        Navigator.pop(context, true); // true를 전달하여 새로고침 필요함을 알림
      } else {
        // 독립 실행된 경우 탭 전환 시도
        try {
          final TabController? tabController = DefaultTabController.maybeOf(context);
          if (tabController != null) {
            tabController.animateTo(0); // 루틴 리스트 탭으로 이동
          }
        } catch (e) {
          // TabController를 찾을 수 없는 경우 무시
          debugPrint('TabController를 찾을 수 없습니다: $e');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('루틴 저장 실패: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _descriptionController.clear();
      _routineExercises.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NotionColors.gray50,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicInfoSection(),
                  const SizedBox(height: 24),
                  _buildExerciseSection(),
                  const SizedBox(height: 32),
                  _buildSaveButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with collapse/expand functionality
          InkWell(
            onTap: () {
              setState(() {
                _basicInfoExpanded = !_basicInfoExpanded;
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Text(
                    _nameController.text.trim().isEmpty ? '새 루틴' : _nameController.text.trim(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _basicInfoExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: const Color(0xFF10B981),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Collapsible content
          if (_basicInfoExpanded)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    _buildModernTextField(
                      controller: _nameController,
                      label: '이름',
                      hint: '예: 가슴/삼두 루틴',
                      icon: Icons.label_outline,
                    ),
                    const SizedBox(height: 20),
                    _buildModernTextField(
                      controller: _descriptionController,
                      label: '설명',
                      hint: '루틴에 대한 간단한 설명을 입력하세요',
                      icon: Icons.description_outlined,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
              fontFamily: 'IBMPlexSansKR',
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade500,
                fontFamily: 'IBMPlexSansKR',
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF4CAF50),
                  size: 18,
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF4CAF50),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '운동 목록',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: NotionColors.black,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: _addExercise,
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Color(0xFF10B981)),
                            SizedBox(width: 8),
                            Text(
                              '운동 추가',
                              style: TextStyle(
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_routineExercises.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    '운동을 추가해주세요',
                    style: TextStyle(
                      color: NotionColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            else
              ...List.generate(
                _routineExercises.length,
                (exerciseIndex) => _buildExerciseCard(exerciseIndex),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(int exerciseIndex) {
    final exercise = _routineExercises[exerciseIndex];
    final selectedExercise = _selectedExercises[exerciseIndex];
    final exerciseName = selectedExercise?.name ?? '운동을 선택해주세요';

    final isExpanded = _expandedCards[exerciseIndex] ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: const Color(0xFF10B981).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // 헤더 부분 (항상 보이는 부분)
          InkWell(
            onTap: () {
              setState(() {
                _expandedCards[exerciseIndex] = !isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(12),
                  bottom: isExpanded ? Radius.zero : const Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  // 순서 표시 - 모던한 원형 배지
                  Container(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Text(
                        '${exerciseIndex + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 운동명 - 개선된 타이포그래피
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exerciseName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                            fontFamily: 'IBMPlexSansKR',
                            height: 1.2,
                          ),
                        ),
                        if (!isExpanded) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${exercise.routineSets.length}세트',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // 삭제 버튼 - 모던한 원형 버튼
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD32F2F).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFD32F2F).withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () => _removeExercise(exerciseIndex),
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFD32F2F),
                        size: 20,
                      ),
                    ),
                  ),
                  // 펼치기/접기 아이콘 - 애니메이션 효과
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: const Color(0xFF10B981),
                        size: 24,
                      ),
                    ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 운동 선택 버튼
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedExercise == null 
                            ? Colors.grey[300]! 
                            : const Color(0xFF10B981),
                          width: selectedExercise == null ? 1 : 2,
                        ),
                        color: selectedExercise == null 
                          ? Colors.grey[50] 
                          : const Color(0xFF10B981).withValues(alpha: 0.05),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            showEnhancedExerciseSelector(
                              context,
                              onExerciseSelected: (selectedExercise) {
                                setState(() {
                                  _selectedExercises[exerciseIndex] = selectedExercise;
                                  _exerciseControllers[exerciseIndex]!.text = selectedExercise.name;
                                  _routineExercises[exerciseIndex] = exercise.copyWith(
                                    exerciseId: selectedExercise.exerciseId,
                                  );
                                });
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  selectedExercise == null 
                                    ? Icons.add_circle_outline 
                                    : Icons.fitness_center,
                                  color: selectedExercise == null 
                                    ? Colors.grey[600] 
                                    : const Color(0xFF10B981),
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedExercise?.name ?? '운동을 선택해주세요',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: selectedExercise == null 
                                            ? Colors.grey[600] 
                                            : const Color(0xFF111827),
                                          fontFamily: 'IBMPlexSansKR',
                                        ),
                                      ),
                                      if (selectedExercise != null && selectedExercise.targetMuscles.isNotEmpty)
                                        const SizedBox(height: 4),
                                      if (selectedExercise != null && selectedExercise.targetMuscles.isNotEmpty)
                                        Text(
                                          selectedExercise.targetMuscles
                                            .where((muscle) => muscle.role == MuscleRole.primary)
                                            .map((muscle) => MuscleTranslations.translateMuscle(muscle.name))
                                            .join(', '),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                            fontFamily: 'IBMPlexSansKR',
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey[400],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 세트 섹션 - 미니멀 디자인
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
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
                                  color: NotionColors.black,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextButton.icon(
                                  onPressed: () => _addSet(exerciseIndex),
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text(
                                    '세트 추가',
                                    style: TextStyle(
                                      fontFamily: 'IBMPlexSansKR',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF10B981),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...List.generate(
                            exercise.routineSets.length,
                            (setIndex) => _buildSetRow(exerciseIndex, setIndex),
                          ),
                        ],
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

  Widget _buildSetRow(int exerciseIndex, int setIndex) {
    final set = _routineExercises[exerciseIndex].routineSets[setIndex];

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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${set.order}세트',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ),
              if (_routineExercises[exerciseIndex].routineSets.length > 1)
                GestureDetector(
                  onTap: () => _removeSet(exerciseIndex, setIndex),
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
                        initialValue: set.weight.toString(),
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
                            borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          suffixText: 'kg',
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
                        onChanged: (value) {
                          final weight = double.tryParse(value) ?? 0;
                          setState(() {
                            final exercise = _routineExercises[exerciseIndex];
                            final sets = List<RoutineSet>.from(exercise.routineSets);
                            sets[setIndex] = sets[setIndex].copyWith(weight: weight);
                            _routineExercises[exerciseIndex] =
                                exercise.copyWith(routineSets: sets);
                          });
                        },
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
                        initialValue: set.reps.toString(),
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
                            borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                        onChanged: (value) {
                          final reps = int.tryParse(value) ?? 0;
                          setState(() {
                            final exercise = _routineExercises[exerciseIndex];
                            final sets = List<RoutineSet>.from(exercise.routineSets);
                            sets[setIndex] = sets[setIndex].copyWith(reps: reps);
                            _routineExercises[exerciseIndex] =
                                exercise.copyWith(routineSets: sets);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveRoutine,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF10B981),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                '루틴 저장',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
      ),
    );
  }
}
