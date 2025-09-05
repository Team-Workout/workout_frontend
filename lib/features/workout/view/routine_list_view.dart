import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../model/routine_models.dart';
import '../viewmodel/routine_viewmodel.dart';
import '../../../core/theme/notion_colors.dart';

class RoutineListView extends ConsumerStatefulWidget {
  const RoutineListView({super.key});

  @override
  ConsumerState<RoutineListView> createState() => _RoutineListViewState();
}

class _RoutineListViewState extends ConsumerState<RoutineListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(routineProvider.notifier).loadRoutines();
    });
  }

  @override
  Widget build(BuildContext context) {
    final routinesAsync = ref.watch(routineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 루틴 목록'),
        elevation: 0,
        backgroundColor: NotionColors.white,
        foregroundColor: NotionColors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/workout-routine-create');
            },
          ),
        ],
      ),
      backgroundColor: NotionColors.gray50,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(routineProvider.notifier).loadRoutines();
        },
        child: routinesAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: NotionColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  '루틴 목록을 불러오는 중 오류가 발생했습니다',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: NotionColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(routineProvider.notifier).loadRoutines();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('다시 시도'),
                ),
              ],
            ),
          ),
          data: (routines) {
            if (routines.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: routines.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final routine = routines[index];
                return _buildRoutineCard(routine);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: NotionColors.gray100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.fitness_center,
              size: 80,
              color: NotionColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '저장된 루틴이 없습니다',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: NotionColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            '첫 번째 운동 루틴을 만들어보세요!',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: NotionColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.push('/workout-routine-create');
            },
            icon: const Icon(Icons.add),
            label: const Text('루틴 만들기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: NotionColors.black,
              foregroundColor: NotionColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildRoutineCard(RoutineResponse routine) {
    return Container(
      decoration: BoxDecoration(
        color: NotionColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: NotionColors.border,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.push('/workout-routine/${routine.id}');
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: NotionColors.gray100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.fitness_center,
                        color: NotionColors.black,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            routine.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: NotionColors.black,
                            ),
                          ),
                          if (routine.description != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              routine.description!,
                              style: TextStyle(
                                fontSize: 14,
                                color: NotionColors.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                          _showDeleteConfirmDialog(routine);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: NotionColors.error),
                              SizedBox(width: 8),
                              Text('삭제'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoChip(
                      icon: Icons.list_alt,
                      label: '운동 수',
                      value: routine.routineExercises?.length.toString() ?? '0',
                      color: NotionColors.black,
                    ),
                    const SizedBox(width: 12),
                    _buildInfoChip(
                      icon: Icons.calendar_today,
                      label: '생성일',
                      value: routine.createdAt != null
                          ? _formatDate(routine.createdAt!)
                          : '미정',
                      color: NotionColors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: NotionColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}';
  }

  void _showDeleteConfirmDialog(RoutineResponse routine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('루틴 삭제'),
        content: Text('\'${routine.name}\' 루틴을 삭제하시겠습니까?\n삭제된 루틴은 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref
                    .read(routineProvider.notifier)
                    .deleteRoutine(routine.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('루틴이 삭제되었습니다.')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              }
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: NotionColors.error),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
