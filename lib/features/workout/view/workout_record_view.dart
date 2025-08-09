import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/features/workout/model/workout_model.dart';
import 'package:pt_service/features/workout/viewmodel/workout_viewmodel.dart';
import 'package:pt_service/shared/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';

class WorkoutRecordView extends ConsumerStatefulWidget {
  const WorkoutRecordView({super.key});

  @override
  ConsumerState<WorkoutRecordView> createState() => _WorkoutRecordViewState();
}

class _WorkoutRecordViewState extends ConsumerState<WorkoutRecordView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  WorkoutType _selectedType = WorkoutType.fullBody;
  int _duration = 60;
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workouts = ref.watch(workoutListProvider);
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('운동 기록'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '기록 목록'),
              Tab(text: '새 기록'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRecordList(workouts),
            _buildNewRecord(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRecordList(AsyncValue<List<WorkoutRecord>> workouts) {
    return workouts.when(
      data: (records) {
        if (records.isEmpty) {
          return const Center(
            child: Text('아직 운동 기록이 없습니다'),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: _getTypeColor(record.type).withOpacity(0.2),
                  child: Icon(
                    _getTypeIcon(record.type),
                    color: _getTypeColor(record.type),
                  ),
                ),
                title: Text(record.title),
                subtitle: Text(
                  '${DateFormat('yyyy.MM.dd').format(record.date)} • ${record.duration}분',
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.category, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              _getTypeLabel(record.type),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        if (record.description != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            record.description!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                        if (record.exercises.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text(
                            '운동 상세',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...record.exercises.map((exercise) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(exercise.name),
                                ),
                                Text(
                                  '${exercise.sets}세트 × ${exercise.reps}회',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                if (exercise.weight != null) ...[
                                  Text(
                                    ' (${exercise.weight}kg)',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          )),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('오류가 발생했습니다: $error'),
      ),
    );
  }
  
  Widget _buildNewRecord() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '기본 정보',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _titleController,
                    labelText: '운동 제목',
                    hintText: '예: 오전 상체 운동',
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: '운동 날짜',
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('yyyy년 MM월 dd일').format(_selectedDate),
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<WorkoutType>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: '운동 유형',
                      border: OutlineInputBorder(),
                    ),
                    items: WorkoutType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Row(
                          children: [
                            Icon(_getTypeIcon(type), size: 20),
                            const SizedBox(width: 8),
                            Text(_getTypeLabel(type)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedType = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '운동 시간: $_duration분',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      IconButton(
                        onPressed: _duration > 15 ? () {
                          setState(() {
                            _duration -= 15;
                          });
                        } : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _duration += 15;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '상세 내용',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _descriptionController,
                    labelText: '메모 (선택)',
                    hintText: '오늘의 컨디션, 특이사항 등',
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              if (_titleController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('운동 제목을 입력해주세요'),
                  ),
                );
                return;
              }
              
              ref.read(workoutViewModelProvider.notifier).addWorkout(
                title: _titleController.text,
                date: _selectedDate,
                type: _selectedType,
                duration: _duration,
                description: _descriptionController.text.isNotEmpty
                    ? _descriptionController.text
                    : null,
              );
              
              _titleController.clear();
              _descriptionController.clear();
              setState(() {
                _selectedDate = DateTime.now();
                _selectedType = WorkoutType.fullBody;
                _duration = 60;
              });
              
              DefaultTabController.of(context).animateTo(0);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('운동 기록이 저장되었습니다'),
                ),
              );
            },
            icon: const Icon(Icons.save),
            label: const Text('기록 저장'),
          ),
        ],
      ),
    );
  }
  
  Color _getTypeColor(WorkoutType type) {
    switch (type) {
      case WorkoutType.fullBody:
        return Colors.blue;
      case WorkoutType.upperBody:
        return Colors.green;
      case WorkoutType.lowerBody:
        return Colors.orange;
      case WorkoutType.cardio:
        return Colors.red;
      case WorkoutType.flexibility:
        return Colors.purple;
    }
  }
  
  IconData _getTypeIcon(WorkoutType type) {
    switch (type) {
      case WorkoutType.fullBody:
        return Icons.fitness_center;
      case WorkoutType.upperBody:
        return Icons.sports_gymnastics;
      case WorkoutType.lowerBody:
        return Icons.directions_run;
      case WorkoutType.cardio:
        return Icons.favorite;
      case WorkoutType.flexibility:
        return Icons.self_improvement;
    }
  }
  
  String _getTypeLabel(WorkoutType type) {
    switch (type) {
      case WorkoutType.fullBody:
        return '전신 운동';
      case WorkoutType.upperBody:
        return '상체 운동';
      case WorkoutType.lowerBody:
        return '하체 운동';
      case WorkoutType.cardio:
        return '유산소 운동';
      case WorkoutType.flexibility:
        return '유연성 운동';
    }
  }
}