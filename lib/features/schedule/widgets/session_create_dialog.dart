import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../pt_contract/model/pt_session_models.dart';

class SessionCreateDialog extends StatefulWidget {
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
  State<SessionCreateDialog> createState() => _SessionCreateDialogState();
}

class _SessionCreateDialogState extends State<SessionCreateDialog> {
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
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PT 세션 작성',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.memberName} 회원님',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 폼
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 세션 날짜
                      _buildSectionTitle('세션 날짜'),
                      TextFormField(
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
                      const SizedBox(height: 20),

                      // 운동 목록
                      _buildSectionTitle('운동 목록'),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // 운동 추가 버튼
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: _addExercise,
                                      icon: const Icon(Icons.add, color: Color(0xFF10B981)),
                                      label: const Text(
                                        '운동 추가',
                                        style: TextStyle(
                                          color: Color(0xFF10B981),
                                          fontFamily: 'IBMPlexSansKR',
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Color(0xFF10B981)),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // 운동 목록
                            if (_workoutLogs.isNotEmpty)
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _workoutLogs.length,
                                separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  color: Colors.grey[300],
                                ),
                                itemBuilder: (context, index) {
                                  return _buildWorkoutLogItem(index);
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 트레이너 노트
                      _buildSectionTitle('트레이너 노트'),
                      TextFormField(
                        controller: _notesController,
                        decoration: _buildInputDecoration('오늘 세션에 대한 전반적인 내용을 기록해주세요'),
                        maxLines: 3,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return '트레이너 노트를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),

            // 버튼들
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFF10B981)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitSession,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'IBMPlexSansKR',
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildWorkoutLogItem(int index) {
    final workoutLog = _workoutLogs[index];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '운동 ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _removeWorkoutLog(index),
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Exercise ID: ${workoutLog.exerciseId}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '세트 ${workoutLog.sets.length}개',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ],
      ),
    );
  }

  void _addExercise() {
    setState(() {
      _workoutLogs.add(const WorkoutLogEntry(
        exerciseId: 1, // 임시 ID
        sets: [
          WorkoutSet(reps: 10, weight: 50.0),
        ],
        notes: null,
      ));
    });
  }

  void _removeWorkoutLog(int index) {
    setState(() {
      _workoutLogs.removeAt(index);
    });
  }

  void _submitSession() {
    if (_formKey.currentState?.validate() ?? false) {
      final sessionData = PtSessionCreate(
        appointmentId: widget.appointmentId,
        sessionDate: _sessionDateController.text,
        notes: _notesController.text,
        workoutLogs: _workoutLogs,
      );

      widget.onSubmit(sessionData);
    }
  }
}