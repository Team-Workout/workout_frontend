import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../model/pt_session_models.dart';
import '../viewmodel/pt_contract_viewmodel.dart';

class PtSessionCreateDialog extends ConsumerStatefulWidget {
  final int appointmentId;
  final String trainerName;
  final String memberName;
  final DateTime sessionDate;

  const PtSessionCreateDialog({
    super.key,
    required this.appointmentId,
    required this.trainerName,
    required this.memberName,
    required this.sessionDate,
  });

  @override
  ConsumerState<PtSessionCreateDialog> createState() =>
      _PtSessionCreateDialogState();
}

class _PtSessionCreateDialogState extends ConsumerState<PtSessionCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final List<WorkoutLogEntry> _workoutLogs = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('PT 세션 기록'),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '회원: ${widget.memberName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '날짜: ${DateFormat('yyyy년 M월 d일').format(widget.sessionDate)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '세션 노트',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    hintText: '오늘 세션에 대한 전반적인 내용을 기록해주세요',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '세션 노트를 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '운동 기록',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _addWorkoutLog,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('운동 추가'),
                    ),
                  ],
                ),
                if (_workoutLogs.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        '운동 기록을 추가해주세요',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ..._workoutLogs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final workout = entry.value;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '운동 ${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _removeWorkoutLog(index),
                                  icon: const Icon(Icons.close, size: 18),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                            Text('운동 ID: ${workout.exerciseId}'),
                            Text('세트 수: ${workout.sets.length}개'),
                            if (workout.notes?.isNotEmpty == true)
                              Text('메모: ${workout.notes}'),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _saveSession,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('저장'),
        ),
      ],
    );
  }

  void _addWorkoutLog() {
    showDialog(
      context: context,
      builder: (context) => _WorkoutLogDialog(
        onSave: (workoutLog) {
          setState(() {
            _workoutLogs.add(workoutLog);
          });
        },
      ),
    );
  }

  void _removeWorkoutLog(int index) {
    setState(() {
      _workoutLogs.removeAt(index);
    });
  }

  Future<void> _saveSession() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_workoutLogs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('최소 하나의 운동 기록을 추가해주세요'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Transform WorkoutLogEntry to WorkoutExerciseCreate
      final workoutExercises = _workoutLogs.asMap().entries.map((entry) {
        final index = entry.key;
        final workout = entry.value;
        
        return WorkoutExerciseCreate(
          exerciseId: workout.exerciseId,
          order: index + 1,
          workoutSets: workout.sets.asMap().entries.map((setEntry) {
            final setIndex = setEntry.key;
            final set = setEntry.value;
            
            return WorkoutSetCreate(
              order: setIndex + 1,
              weight: set.weight,
              reps: set.reps,
              feedback: set.duration != null ? 'Duration: ${set.duration}s' : null,
            );
          }).toList(),
        );
      }).toList();

      final workoutLog = WorkoutLogCreate(
        workoutDate: DateFormat('yyyy-MM-dd').format(widget.sessionDate),
        logFeedback: _notesController.text.trim(),
        workoutExercises: workoutExercises,
      );

      final sessionData = PtSessionCreate(
        appointmentId: widget.appointmentId,
        workoutLog: workoutLog,
      );

      // 1. PT 세션 생성
      await ref
          .read(ptContractViewModelProvider.notifier)
          .createPtSession(sessionData);

      // 2. PT 약속 상태를 COMPLETED로 변경
      await ref
          .read(ptContractViewModelProvider.notifier)
          .updateAppointmentStatus(
            appointmentId: widget.appointmentId,
            status: 'COMPLETED',
          );

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PT 세션이 성공적으로 완료되었습니다.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('세션 저장 실패: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class _WorkoutLogDialog extends StatefulWidget {
  final Function(WorkoutLogEntry) onSave;

  const _WorkoutLogDialog({required this.onSave});

  @override
  State<_WorkoutLogDialog> createState() => _WorkoutLogDialogState();
}

class _WorkoutLogDialogState extends State<_WorkoutLogDialog> {
  final _formKey = GlobalKey<FormState>();
  final _exerciseIdController = TextEditingController();
  final _notesController = TextEditingController();
  final List<WorkoutSet> _sets = [const WorkoutSet(reps: 0, weight: 0.0)];

  @override
  void dispose() {
    _exerciseIdController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('운동 기록 추가'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _exerciseIdController,
                decoration: const InputDecoration(
                  labelText: '운동 ID',
                  hintText: '운동 식별 번호를 입력하세요',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '운동 ID를 입력해주세요';
                  }
                  if (int.tryParse(value) == null) {
                    return '유효한 숫자를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('세트',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    onPressed: _addSet,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('세트 추가'),
                  ),
                ],
              ),
              ..._sets.asMap().entries.map((entry) {
                final index = entry.key;
                final set = entry.value;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: set.reps.toString(),
                            decoration: const InputDecoration(
                              labelText: '횟수',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              final reps = int.tryParse(value) ?? 0;
                              _updateSet(index, set.copyWith(reps: reps));
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            initialValue: set.weight.toString(),
                            decoration: const InputDecoration(
                              labelText: '무게(kg)',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              final weight = double.tryParse(value) ?? 0.0;
                              _updateSet(index, set.copyWith(weight: weight));
                            },
                          ),
                        ),
                        IconButton(
                          onPressed:
                              _sets.length > 1 ? () => _removeSet(index) : null,
                          icon: const Icon(Icons.close, size: 18),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: '운동 메모',
                  hintText: '이 운동에 대한 특별한 기록사항',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _saveWorkoutLog,
          child: const Text('추가'),
        ),
      ],
    );
  }

  void _addSet() {
    setState(() {
      _sets.add(const WorkoutSet(reps: 0, weight: 0.0));
    });
  }

  void _removeSet(int index) {
    setState(() {
      _sets.removeAt(index);
    });
  }

  void _updateSet(int index, WorkoutSet newSet) {
    setState(() {
      _sets[index] = newSet;
    });
  }

  void _saveWorkoutLog() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final exerciseId = int.parse(_exerciseIdController.text);
    final notes = _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim();

    if (_sets.any((set) => set.reps <= 0 || set.weight < 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('모든 세트의 횟수와 무게를 올바르게 입력해주세요'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final workoutLog = WorkoutLogEntry(
      exerciseId: exerciseId,
      sets: _sets,
      notes: notes,
    );

    widget.onSave(workoutLog);
    Navigator.of(context).pop();
  }
}
