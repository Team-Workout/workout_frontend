import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/notion_colors.dart';
import '../model/pt_session_model.dart';
import '../provider/pt_session_provider.dart';
import '../repository/pt_session_repository.dart';

class PtSessionListView extends ConsumerStatefulWidget {
  const PtSessionListView({super.key});

  @override
  ConsumerState<PtSessionListView> createState() => _PtSessionListViewState();
}

class _PtSessionListViewState extends ConsumerState<PtSessionListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(ptSessionNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(ptSessionNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          '내 PT 세션',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(ptSessionNotifierProvider.notifier).loadSessions(refresh: true);
        },
        color: const Color(0xFF10B981),
        child: sessionsAsync.when(
          data: (sessionData) {
            if (sessionData.data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'PT 세션 기록이 없습니다',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'PT를 진행하면 여기에 기록이 표시됩니다',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: sessionData.data.length + 1,
              itemBuilder: (context, index) {
                if (index == sessionData.data.length) {
                  final notifier = ref.read(ptSessionNotifierProvider.notifier);
                  if (notifier.hasMore) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF10B981),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }

                final session = sessionData.data[index];
                return _buildSessionCard(session);
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF10B981),
            ),
          ),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  '데이터를 불러올 수 없습니다',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'IBMPlexSansKR',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(ptSessionNotifierProvider.notifier).loadSessions(refresh: true);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('다시 시도'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionCard(PtSessionResponse session) {
    if (session.workoutLogResponse == null) {
      return const SizedBox.shrink();
    }

    final workoutLog = session.workoutLogResponse!;
    final date = DateTime.parse(workoutLog.workoutDate);
    final formattedDate = DateFormat('yyyy년 MM월 dd일').format(date);
    final dayOfWeek = DateFormat('EEEE', 'ko_KR').format(date);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                      Text(
                        dayOfWeek,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '운동 ${workoutLog.workoutExercises.length}종목',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _showDeleteDialog(session.id),
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      iconSize: 20,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 운동 내용
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...workoutLog.workoutExercises.map((exercise) {
                  return _buildExerciseItem(exercise);
                }),
                if (workoutLog.feedbacks.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.comment,
                              size: 16,
                              color: Colors.blue[700],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '트레이너 피드백',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...workoutLog.feedbacks.map((feedback) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '${feedback.authorName}: ${feedback.content}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseItem(WorkoutExerciseResponse exercise) {
    final totalSets = exercise.workoutSets.length;
    final totalWeight = exercise.workoutSets.fold<double>(
      0,
      (sum, set) => sum + (set.weight * set.reps),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${exercise.order}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  exercise.exerciseName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ),
              Text(
                '${totalSets}세트 • ${totalWeight.toStringAsFixed(0)}kg',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: exercise.workoutSets.map((set) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  '${set.weight}kg × ${set.reps}회',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              );
            }).toList(),
          ),
          if (exercise.feedbacks.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: exercise.feedbacks.map((feedback) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.tips_and_updates,
                        size: 14,
                        color: Colors.orange[700],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${feedback.authorName}: ${feedback.content}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[900],
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showDeleteDialog(int sessionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'PT 세션 삭제',
          style: TextStyle(fontFamily: 'IBMPlexSansKR'),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이 PT 세션 기록을 삭제하시겠습니까?',
              style: TextStyle(fontFamily: 'IBMPlexSansKR'),
            ),
            SizedBox(height: 12),
            Text(
              '⚠️ 주의사항',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
            SizedBox(height: 4),
            Text(
              '• 연관된 운동일지도 함께 삭제됩니다\n• 차감되었던 PT 횟수가 복구됩니다\n• 삭제된 데이터는 복구할 수 없습니다',
              style: TextStyle(
                fontSize: 13,
                color: Colors.orange,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              '취소',
              style: TextStyle(fontFamily: 'IBMPlexSansKR'),
            ),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deletePtSession(sessionId);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              '삭제',
              style: TextStyle(fontFamily: 'IBMPlexSansKR'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePtSession(int sessionId) async {
    try {
      // 기존 provider를 사용하여 삭제
      final repository = ref.read(ptSessionRepositoryProvider);
      await repository.deletePtSession(sessionId);
      
      // 목록 새로고침
      await ref.read(ptSessionNotifierProvider.notifier).loadSessions(refresh: true);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'PT 세션이 성공적으로 삭제되었습니다.',
              style: TextStyle(fontFamily: 'IBMPlexSansKR'),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '삭제 실패: $error',
              style: const TextStyle(fontFamily: 'IBMPlexSansKR'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}