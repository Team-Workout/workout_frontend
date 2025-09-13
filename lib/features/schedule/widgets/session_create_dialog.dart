import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../pt_contract/model/pt_session_models.dart';
import '../view/pt_exercise_selection_view.dart';
import '../../sync/viewmodel/sync_viewmodel.dart';

class SessionCreateDialog extends ConsumerStatefulWidget {
  final int appointmentId;
  final String memberName;
  final DateTime appointmentDate;
  final Function(PtSessionCreate) onSubmit;

  const SessionCreateDialog({
    super.key,
    required this.appointmentId,
    required this.memberName,
    required this.appointmentDate,
    required this.onSubmit,
  });

  @override
  ConsumerState<SessionCreateDialog> createState() => _SessionCreateDialogState();
}

class _SessionCreateDialogState extends ConsumerState<SessionCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _sessionDateController = TextEditingController();
  final _notesController = TextEditingController();

  final List<WorkoutLogEntry> _workoutLogs = [];

  @override
  void initState() {
    super.initState();
    _sessionDateController.text = DateFormat('yyyy-MM-dd').format(widget.appointmentDate);
  }

  @override
  void dispose() {
    _sessionDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF0FDF4), // 매우 연한 초록
              Color(0xFFFEFFFE), // 거의 흰색
              Color(0xFFF0FDF4), // 매우 연한 초록
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF10B981),
                    Color(0xFF34D399),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PT 세션 작성',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${widget.memberName} 회원님',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // 폼
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 세션 날짜
                      _buildSectionCard(
                        title: '세션 날짜',
                        icon: Icons.calendar_today,
                        child: TextFormField(
                          controller: _sessionDateController,
                          decoration: _buildInputDecoration('세션 날짜'),
                          readOnly: true,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return '세션 날짜를 입력해주세요';
                            }
                            return null;
                          },
                        ),
                      ),

                      // 운동 목록
                      _buildSectionCard(
                        title: '운동 목록',
                        icon: Icons.fitness_center,
                        child: Column(
                          children: [
                            // 운동 추가 버튼
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ElevatedButton.icon(
                                onPressed: _navigateToExerciseSelection,
                                icon: const Icon(Icons.fitness_center, color: Colors.white),
                                label: const Text(
                                  '운동 추가 / 편집',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'IBMPlexSansKR',
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.8),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                            // 운동 목록
                            if (_workoutLogs.isNotEmpty)
                              Column(
                                children: _workoutLogs.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final workout = entry.value;
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981).withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFF10B981).withValues(alpha: 0.2),
                                      ),
                                    ),
                                    child: _buildWorkoutLogItem(index, workout),
                                  );
                                }).toList(),
                              ),
                            if (_workoutLogs.isEmpty)
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.fitness_center_outlined,
                                      size: 48,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '운동을 추가해주세요',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontFamily: 'IBMPlexSansKR',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      // 트레이너 노트
                      _buildSectionCard(
                        title: '트레이너 노트',
                        icon: Icons.edit_note,
                        child: TextFormField(
                          controller: _notesController,
                          decoration: _buildInputDecoration('오늘 세션에 대한 전반적인 내용을 기록해주세요'),
                          maxLines: 4,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return '트레이너 노트를 입력해주세요';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 버튼들
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: const Color(0xFF10B981).withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981).withValues(alpha: 0.8),
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitSession,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        shadowColor: const Color(0xFF10B981).withValues(alpha: 0.3),
                      ),
                      child: const Text(
                        '세션 완료',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey[400],
        fontFamily: 'IBMPlexSansKR',
      ),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: const Color(0xFF10B981).withValues(alpha: 0.2),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: const Color(0xFF10B981).withValues(alpha: 0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF10B981),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF10B981).withValues(alpha: 0.1),
                  const Color(0xFF34D399).withValues(alpha: 0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF10B981),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutLogItem(int index, WorkoutLogEntry workoutLog) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '운동 ${index + 1}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B981),
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => _removeWorkoutLog(index),
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String>(
                future: _getExerciseName(workoutLog.exerciseId),
                builder: (context, snapshot) {
                  final exerciseName = snapshot.data ?? '운동 ${index + 1}';
                  return Row(
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          exerciseName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.repeat,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '세트 ${workoutLog.sets.length}개',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ],
              ),
              if (workoutLog.sets.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),
                ...workoutLog.sets.asMap().entries.map((setEntry) {
                  final setIndex = setEntry.key;
                  final set = setEntry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '${setIndex + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${set.reps}회',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                        if (set.weight != null) ...[
                          Text(
                            ' @ ${set.weight}kg',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'IBMPlexSansKR',
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ],
              if (workoutLog.notes != null && workoutLog.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.note_alt_outlined,
                        size: 14,
                        color: Color(0xFF10B981),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          workoutLog.notes!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF10B981),
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToExerciseSelection() async {
    final result = await showDialog<List<WorkoutLogEntry>>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: PtExerciseSelectionView(
          initialWorkoutLogs: _workoutLogs,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _workoutLogs.clear();
        _workoutLogs.addAll(result);
      });
    }
  }

  void _removeWorkoutLog(int index) {
    setState(() {
      _workoutLogs.removeAt(index);
    });
  }

  Future<String> _getExerciseName(int exerciseId) async {
    try {
      final cachedExercises = await ref.read(cachedExercisesProvider.future);
      final exercise = cachedExercises.firstWhere(
        (e) => e.exerciseId == exerciseId,
        orElse: () => throw Exception('Exercise not found'),
      );
      return exercise.name;
    } catch (e) {
      return 'Exercise ID: $exerciseId';
    }
  }

  void _submitSession() {
    if (_formKey.currentState?.validate() ?? false) {
      // 새로운 API 구조에 맞게 데이터 변환
      final workoutExercises = _workoutLogs.asMap().entries.map((entry) {
        final exerciseIndex = entry.key;
        final workoutLog = entry.value;
        
        return WorkoutExerciseCreate(
          exerciseId: workoutLog.exerciseId,
          order: exerciseIndex,
          workoutSets: workoutLog.sets.asMap().entries.map((setEntry) {
            final setIndex = setEntry.key;
            final set = setEntry.value;
            
            return WorkoutSetCreate(
              order: setIndex,
              weight: set.weight ?? 0.0,
              reps: set.reps,
              feedback: workoutLog.notes,
            );
          }).toList(),
        );
      }).toList();

      final sessionData = PtSessionCreate(
        appointmentId: widget.appointmentId,
        workoutLog: WorkoutLogCreate(
          workoutDate: _sessionDateController.text,
          logFeedback: _notesController.text,
          workoutExercises: workoutExercises,
        ),
      );

      widget.onSubmit(sessionData);
    }
  }
}