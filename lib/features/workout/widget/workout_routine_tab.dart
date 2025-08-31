import 'package:flutter/material.dart';
import '../viewmodel/workout_record_viewmodel.dart';
import '../model/routine_models.dart';

class WorkoutRoutineTab extends StatefulWidget {
  final WorkoutRecordViewmodel viewModel;

  const WorkoutRoutineTab({super.key, required this.viewModel});

  @override
  State<WorkoutRoutineTab> createState() => _WorkoutRoutineTabState();
}

class _WorkoutRoutineTabState extends State<WorkoutRoutineTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<RoutineExercise> _routineExercises = [];
  List<Map<String, dynamic>> _availableExercises = [];
  bool _isLoading = false;
  final Map<int, bool> _expandedCards = {};

  @override
  void initState() {
    super.initState();
    _loadAvailableExercises();
  }

  Future<void> _loadAvailableExercises() async {
    setState(() => _isLoading = true);
    try {
      final exercises = await widget.viewModel.workoutApiService.getExerciseList();
      _availableExercises = exercises;
    } catch (e) {
      _availableExercises = [
        {'id': 1, 'name': '벤치프레스'},
        {'id': 2, 'name': '스쿼트'},
        {'id': 3, 'name': '데드리프트'},
        {'id': 4, 'name': '덤벨 플라이'},
      ];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('운동 목록 로드 실패: $e')),
      );
    }
    setState(() => _isLoading = false);
  }

  void _addExercise() {
    if (_availableExercises.isEmpty) return;

    setState(() {
      final newIndex = _routineExercises.length;
      _routineExercises.add(
        RoutineExercise(
          exerciseId: _availableExercises.first['id'],
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
      // 인덱스 재정렬
      final newExpandedCards = <int, bool>{};
      _expandedCards.forEach((key, value) {
        if (key > index) {
          newExpandedCards[key - 1] = value;
        } else if (key < index) {
          newExpandedCards[key] = value;
        }
      });
      _expandedCards.clear();
      _expandedCards.addAll(newExpandedCards);
      
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
      _routineExercises[exerciseIndex] = exercise.copyWith(routineSets: newSets);
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
      _routineExercises[exerciseIndex] = exercise.copyWith(routineSets: newSets);
    });
  }

  Future<void> _saveRoutine() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('루틴 이름을 입력해주세요')),
      );
      return;
    }

    if (_routineExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('최소 하나의 운동을 추가해주세요')),
      );
      return;
    }

    // 각 운동의 세트 검증
    for (int i = 0; i < _routineExercises.length; i++) {
      final exercise = _routineExercises[i];
      
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
            SnackBar(content: Text('${i + 1}번째 운동 ${j + 1}세트: 무게는 0 이상이어야 합니다')),
          );
          return;
        }
        
        if (set.reps <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${i + 1}번째 운동 ${j + 1}세트: 횟수는 1 이상이어야 합니다')),
          );
          return;
        }
      }
    }

    setState(() => _isLoading = true);

    try {
      final request = CreateRoutineRequest(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        routineExercises: _routineExercises,
      );

      final response = await widget.viewModel.workoutApiService.createRoutine(request);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('루틴이 성공적으로 저장되었습니다')),
      );

      _resetForm();
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
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '루틴 기본 정보',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '루틴 이름 *',
                hintText: '예: 가슴/삼두 루틴',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '루틴 설명',
                hintText: '루틴에 대한 간단한 설명을 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseSection() {
    return Card(
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
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C3E50),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: _addExercise,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              '운동 추가',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
                      color: Colors.grey,
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
    final exerciseName = _availableExercises
        .firstWhere(
          (e) => e['id'] == exercise.exerciseId,
          orElse: () => {'name': '알 수 없는 운동'},
        )['name'];
    
    final isExpanded = _expandedCards[exerciseIndex] ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
            onTap: () {
              setState(() {
                _expandedCards[exerciseIndex] = !isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isExpanded ? Colors.grey.shade50 : Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(12),
                  bottom: isExpanded ? Radius.zero : const Radius.circular(12),
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
                        '${exerciseIndex + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 운동명
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exerciseName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        if (!isExpanded) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${exercise.routineSets.length}세트',
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
                    onPressed: () => _removeExercise(exerciseIndex),
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 운동 선택 드롭다운
                    DropdownButtonFormField<int>(
                      value: exercise.exerciseId,
                      decoration: const InputDecoration(
                        labelText: '운동 선택',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _availableExercises
                          .map(
                            (e) => DropdownMenuItem<int>(
                              value: e['id'],
                              child: Text(e['name']),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _routineExercises[exerciseIndex] =
                                exercise.copyWith(exerciseId: value);
                          });
                        }
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
                                onPressed: () => _addSet(exerciseIndex),
                                icon: const Icon(Icons.add_circle_outline, size: 20),
                                label: const Text('세트 추가'),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF2C3E50),
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
                '${set.order}',
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
                  initialValue: set.weight.toString(),
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
                  keyboardType: TextInputType.number,
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
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  initialValue: set.reps.toString(),
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
                  keyboardType: TextInputType.number,
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
          const SizedBox(width: 8),
          // 삭제 버튼
          IconButton(
            onPressed: _routineExercises[exerciseIndex].routineSets.length > 1
                ? () => _removeSet(exerciseIndex, setIndex)
                : null,
            icon: Icon(
              Icons.remove_circle_outline,
              color: _routineExercises[exerciseIndex].routineSets.length > 1
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
        onTap: _isLoading ? null : _saveRoutine,
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
                color: _isLoading ? Colors.grey.withOpacity(0.3) : const Color(0xFF2C3E50).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child:
            _isLoading
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
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}