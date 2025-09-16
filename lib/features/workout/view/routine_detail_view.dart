import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../model/routine_models.dart';
import '../viewmodel/routine_viewmodel.dart';
import '../../dashboard/widgets/notion_button.dart';

class RoutineDetailView extends ConsumerStatefulWidget {
  final int routineId;

  const RoutineDetailView({super.key, required this.routineId});

  @override
  ConsumerState<RoutineDetailView> createState() => _RoutineDetailViewState();
}

class _RoutineDetailViewState extends ConsumerState<RoutineDetailView> {
  RoutineResponse? _routine;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRoutineDetail();
  }

  Future<void> _loadRoutineDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final routine = await ref
          .read(routineProvider.notifier)
          .getRoutineDetail(widget.routineId);
      setState(() {
        _routine = routine;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
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
        appBar: AppBar(
          title: Text(
            _routine?.name ?? '루틴 상세',
            style: const TextStyle(
              fontFamily: 'IBMPlexSansKR',
              fontWeight: FontWeight.w700,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          actions: [
            if (_routine != null)
              PopupMenuButton<String>(
                color: Colors.white,
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey[600],
                ),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteConfirmDialog();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.red[600],
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '삭제',
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansKR',
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
        backgroundColor: Colors.grey.shade50,
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
              ))
            : _errorMessage != null
                ? _buildErrorState()
                : _routine != null
                    ? _buildContent()
                    : const Center(child: Text('루틴을 찾을 수 없습니다')),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            '루틴을 불러오는 중 오류가 발생했습니다',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          NotionButton(
            onPressed: _loadRoutineDetail,
            text: '다시 시도',
            icon: Icons.refresh,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBasicInfoCard(),
          const SizedBox(height: 16),
          _buildExerciseListCard(),
        ],
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return Container(
      width: double.infinity,
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _routine!.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
              ],
            ),
            if (_routine!.description != null) ...[
              const SizedBox(height: 12),
              Text(
                _routine!.description!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatItem(
                  icon: Icons.list_alt, // 사용되지 않음
                  label: '운동 수',
                  value: '${_routine!.routineExercises?.length ?? 0}개',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseListCard() {
    final exercises = _routine!.routineExercises ?? [];

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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.list_alt, color: const Color(0xFF10B981)),
                const SizedBox(width: 8),
                Text(
                  '운동 목록',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (exercises.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    '운동이 없습니다',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
              )
            else
              ...List.generate(
                exercises.length,
                (index) => _buildExerciseCard(exercises[index], index + 1),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(RoutineExercise exercise, int exerciseNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      exerciseNumber.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    exercise.exerciseName ??
                        'Exercise ID: ${exercise.exerciseId}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '세트 정보',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(
              exercise.routineSets.length,
              (setIndex) =>
                  _buildSetInfo(exercise.routineSets[setIndex], setIndex + 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetInfo(RoutineSet set, int setNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${setNumber}세트',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${set.weight}kg × ${set.reps}회',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}';
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: const Color(0xFF10B981).withOpacity(0.3),
            width: 1.5,
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              '루틴 삭제',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'IBMPlexSansKR',
                color: Colors.black87,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                  fontFamily: 'IBMPlexSansKR',
                  height: 1.4,
                ),
                children: [
                  const TextSpan(text: '\''),
                  TextSpan(
                    text: _routine!.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const TextSpan(
                      text: '\' 루틴을 삭제하시겠습니까?\n\n삭제된 루틴은 복구할 수 없습니다.'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref
                    .read(routineProvider.notifier)
                    .deleteRoutine(_routine!.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        '루틴이 삭제되었습니다.',
                        style: TextStyle(fontFamily: 'IBMPlexSansKR'),
                      ),
                      backgroundColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                  context.pop();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString(),
                        style: const TextStyle(fontFamily: 'IBMPlexSansKR'),
                      ),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '삭제',
              style: TextStyle(
                fontFamily: 'IBMPlexSansKR',
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '취소',
              style: TextStyle(
                fontFamily: 'IBMPlexSansKR',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
