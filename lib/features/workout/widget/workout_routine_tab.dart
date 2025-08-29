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
      _routineExercises.add(
        RoutineExercise(
          exerciseId: _availableExercises.first['id'],
          order: _routineExercises.length + 1,
          routineSets: [
            RoutineSet(
              order: 1,
              weight: 0,
              reps: 0,
            ),
          ],
        ),
      );
    });
  }

  void _removeExercise(int index) {
    setState(() {
      _routineExercises.removeAt(index);
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

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: exercise.exerciseId,
                    decoration: const InputDecoration(
                      labelText: '운동 선택',
                      border: OutlineInputBorder(),
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
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _removeExercise(exerciseIndex),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '세트',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _addSet(exerciseIndex),
                  icon: const Icon(Icons.add),
                  label: const Text('세트 추가'),
                ),
              ],
            ),
            ...List.generate(
              exercise.routineSets.length,
              (setIndex) => _buildSetRow(exerciseIndex, setIndex),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetRow(int exerciseIndex, int setIndex) {
    final set = _routineExercises[exerciseIndex].routineSets[setIndex];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              '${set.order}세트',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              initialValue: set.weight.toString(),
              decoration: const InputDecoration(
                labelText: '무게(kg)',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              initialValue: set.reps.toString(),
              decoration: const InputDecoration(
                labelText: '횟수',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _routineExercises[exerciseIndex].routineSets.length > 1
                ? () => _removeSet(exerciseIndex, setIndex)
                : null,
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
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