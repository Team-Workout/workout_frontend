import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/pt_application_model.dart';
import '../viewmodel/pt_application_viewmodel.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../features/auth/model/user_model.dart';
import '../../../core/theme/notion_colors.dart';

class PtApplicationsListView extends ConsumerStatefulWidget {
  final bool? isTrainerView; // null이면 userType으로 자동 판별
  
  const PtApplicationsListView({super.key, this.isTrainerView});

  @override
  ConsumerState<PtApplicationsListView> createState() => _PtApplicationsListViewState();
}

class _PtApplicationsListViewState extends ConsumerState<PtApplicationsListView> {
  late bool _isTrainer;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ptApplicationProvider.notifier).loadPtApplications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final applicationsAsync = ref.watch(ptApplicationProvider);
    final user = ref.watch(currentUserProvider);
    
    // 사용자 타입 확인
    _isTrainer = widget.isTrainerView ?? (user?.userType == UserType.trainer);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_isTrainer ? 'PT 신청 관리' : 'PT 신청 내역'),
        elevation: 0,
        backgroundColor: NotionColors.white,
        foregroundColor: NotionColors.black,
      ),
      backgroundColor: NotionColors.gray50,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(ptApplicationProvider.notifier).loadPtApplications();
        },
        child: applicationsAsync.when(
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
                  'PT 신청 내역을 불러오는 중 오류가 발생했습니다',
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
                    ref.read(ptApplicationProvider.notifier).loadPtApplications();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('다시 시도'),
                ),
              ],
            ),
          ),
          data: (applications) {
            if (applications.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: applications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final application = applications[index];
                return _buildApplicationCard(application);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
              Icons.assignment_outlined,
              size: 80,
              color: NotionColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _isTrainer ? '대기 중인 PT 신청이 없습니다' : 'PT 신청 내역이 없습니다',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: NotionColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _isTrainer 
                ? '회원들의 PT 신청을 기다려주세요!'
                : '트레이너의 PT 상품을 확인하고\n신청해보세요!',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: NotionColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(PtApplication application) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            NotionColors.white,
            NotionColors.gray100,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: NotionColors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: NotionColors.border,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    NotionColors.black,
                    NotionColors.black,
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: NotionColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.pending_actions,
                      color: NotionColors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application.offeringTitle ?? 'PT 신청 #${application.applicationId}',
                          style: const TextStyle(
                            color: NotionColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '승인 대기 중',
                          style: TextStyle(
                            color: NotionColors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: NotionColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'PENDING',
                      style: TextStyle(
                        color: NotionColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Member/Trainer info
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: NotionColors.gray100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.person,
                          color: NotionColors.black,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isTrainer ? '신청자' : '트레이너',
                              style: TextStyle(
                                color: NotionColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              _isTrainer 
                                  ? application.memberName 
                                  : (application.trainerName ?? '미정'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Session and date info
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          icon: Icons.fitness_center,
                          label: '총 세션 수',
                          value: application.totalSessions != null 
                              ? '${application.totalSessions}회' 
                              : '미정',
                          color: NotionColors.black,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoItem(
                          icon: Icons.calendar_today,
                          label: '신청일',
                          value: _formatDate(application.appliedAt),
                          color: NotionColors.black,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action buttons based on user type
                  if (_isTrainer) ...[  // 트레이너용 버튼
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            label: '승인',
                            icon: Icons.check,
                            color: NotionColors.black,
                            onPressed: () => _approveApplication(application),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            label: '거절',
                            icon: Icons.close,
                            color: NotionColors.error,
                            onPressed: () => _rejectApplication(application),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[  // 회원용 버튼
                    SizedBox(
                      width: double.infinity,
                      child: _buildActionButton(
                        label: '신청 취소',
                        icon: Icons.cancel_outlined,
                        color: NotionColors.error,
                        onPressed: () => _cancelApplication(application),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: NotionColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: NotionColors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: NotionColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  void _approveApplication(PtApplication application) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PT 신청 승인'),
        content: Text('${application.memberName}님의 PT 신청을 승인하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(ptApplicationProvider.notifier)
                    .acceptPtApplication(application.applicationId);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PT 신청을 승인했습니다.')),
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
            style: ElevatedButton.styleFrom(backgroundColor: NotionColors.black),
            child: const Text('승인'),
          ),
        ],
      ),
    );
  }

  void _rejectApplication(PtApplication application) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PT 신청 거절'),
        content: Text('${application.memberName}님의 PT 신청을 거절하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(ptApplicationProvider.notifier)
                    .rejectPtApplication(application.applicationId);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PT 신청을 거절했습니다.')),
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
            style: ElevatedButton.styleFrom(backgroundColor: NotionColors.error),
            child: const Text('거절'),
          ),
        ],
      ),
    );
  }

  void _cancelApplication(PtApplication application) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PT 신청 취소'),
        content: const Text('PT 신청을 취소하시겠습니까?\n취소된 신청은 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('돌아가기'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(ptApplicationProvider.notifier)
                    .cancelPtApplication(application.applicationId);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PT 신청을 취소했습니다.')),
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
            style: ElevatedButton.styleFrom(backgroundColor: NotionColors.error),
            child: const Text('취소하기'),
          ),
        ],
      ),
    );
  }
}