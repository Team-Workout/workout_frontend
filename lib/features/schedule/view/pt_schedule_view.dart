import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pt_service/features/pt_schedule/model/pt_schedule_models.dart';
import 'package:pt_service/features/pt_schedule/viewmodel/pt_schedule_viewmodel.dart';
import 'package:pt_service/features/pt_schedule/widget/schedule_change_request_dialog.dart';
import 'package:pt_service/features/pt_contract/widget/pt_session_create_dialog.dart';
import 'package:pt_service/core/providers/auth_provider.dart';
import 'package:pt_service/features/auth/model/user_model.dart';
import 'package:intl/intl.dart';
import '../widget/weekly_timetable_widget.dart';
import '../../dashboard/widgets/notion_button.dart';

class PTScheduleView extends ConsumerStatefulWidget {
  final bool isDirectAccess;
  
  const PTScheduleView({
    super.key,
    this.isDirectAccess = false,
  });

  @override
  ConsumerState<PTScheduleView> createState() => _PTScheduleViewState();
}

class _PTScheduleViewState extends ConsumerState<PTScheduleView> {
  DateTime _selectedWeek = DateTime.now();

  @override
  void initState() {
    super.initState();
    // 현재 주의 스케줄 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWeeklySchedule();
    });
  }
  
  void _loadWeeklySchedule() {
    final mondayOfWeek = _selectedWeek.subtract(Duration(days: _selectedWeek.weekday - 1));
    final sundayOfWeek = mondayOfWeek.add(const Duration(days: 6));
    
    ref.read(ptScheduleViewModelProvider.notifier).loadWeeklySchedule(
      startDate: mondayOfWeek,
      endDate: sundayOfWeek,
      status: 'SCHEDULED',
    );
  }

  @override
  Widget build(BuildContext context) {
    final schedulesAsync = ref.watch(ptScheduleViewModelProvider);
    final user = ref.watch(currentUserProvider);

    // 직접 접근시 또는 트레이너일 때 Scaffold로 감싸고 AppBar 추가
    // widget.isDirectAccess가 true이거나 트레이너인 경우 AppBar 표시
    if (widget.isDirectAccess || user?.userType == UserType.trainer) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF10B981), Color(0xFF34D399), Color(0xFF6EE7B7)],
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'PT 시간표',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          centerTitle: true,
        ),
        body: _buildScheduleContent(schedulesAsync, user),
      );
    }

    // 탭 뷰에서 사용시 Container로 반환
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF10B981).withValues(alpha: 0.02),
            const Color(0xFF34D399).withValues(alpha: 0.03),
            const Color(0xFF6EE7B7).withValues(alpha: 0.02),
          ],
        ),
      ),
      child: _buildScheduleContent(schedulesAsync, user),
    );
  }

  Widget _buildScheduleContent(
    AsyncValue<List<PtSchedule>> schedulesAsync,
    User? user,
  ) {
    return Column(
      children: [
        // 주 선택 컨트롤 (간소화)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedWeek = _selectedWeek.subtract(const Duration(days: 7));
                  });
                  _loadWeeklySchedule();
                },
                icon: const Icon(
                          Icons.chevron_left,
                          color: Color(0xFF10B981),
                ),
              ),
              GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedWeek,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(0xFF10B981),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedWeek = picked;
                            });
                            _loadWeeklySchedule();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF10B981), Color(0xFF34D399)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${DateFormat('yyyy년 M월').format(_selectedWeek)} ${(_selectedWeek.day / 7).ceil()}주차',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'IBMPlexSansKR',
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                onPressed: () {
                  setState(() {
                    _selectedWeek = _selectedWeek.add(const Duration(days: 7));
                  });
                  _loadWeeklySchedule();
                },
                icon: const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF10B981),
                        ),
              ),
            ],
          ),
        ),
          // 오늘로 돌아가기 버튼 (더 작게)
          if (_selectedWeek.difference(DateTime.now()).inDays.abs() > 7)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedWeek = DateTime.now();
                  });
                  _loadWeeklySchedule();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.today,
                        size: 14,
                        color: const Color(0xFF10B981),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '오늘로 돌아가기',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF10B981),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // 시간표 위젯
          Expanded(
            child: schedulesAsync.when(
              data: (schedules) => WeeklyTimetableWidget(
                schedules: schedules,
                selectedWeek: _selectedWeek,
                onScheduleTap: (schedule) => _showScheduleDetail(context, schedule),
                onScheduleAction: (schedule, action) => _handleScheduleAction(context, schedule, action),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF10B981),
                  strokeWidth: 3,
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.error_outline, 
                        size: 48, 
                        color: Colors.red
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '일정을 불러오는데 실패했습니다',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                        fontFamily: 'IBMPlexSansKR',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '네트워크를 확인하고 다시 시도해주세요',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                    const SizedBox(height: 16),
                    NotionButton(
                      onPressed: _loadWeeklySchedule,
                      text: '다시 시도',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
  }

  void _showScheduleDetail(BuildContext context, PtSchedule schedule) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PT 세션 상세',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('트레이너', schedule.trainerName),
                      _buildDetailRow('회원', schedule.memberName),
                      _buildDetailRow('시간', '${schedule.startTime} - ${schedule.endTime}'),
                      _buildDetailRow('상태', _getStatusText(schedule.status)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'SCHEDULED':
        return '예정됨';
      case 'COMPLETED':
        return '완료됨';
      case 'CANCELLED':
        return '취소됨';
      default:
        return status;
    }
  }

  void _handleScheduleAction(BuildContext context, PtSchedule schedule, String action) {
    switch (action) {
      case 'change_request':
        _showChangeRequestDialog(context, schedule);
        break;
      case 'cancel':
        _showCancelConfirmDialog(context, schedule);
        break;
      case 'complete':
        _markAsCompleted(schedule);
        break;
    }
  }

  void _showChangeRequestDialog(BuildContext context, PtSchedule schedule) {
    showDialog(
      context: context,
      builder: (context) => ScheduleChangeRequestDialog(
        schedule: schedule,
      ),
    ).then((_) {
      _loadWeeklySchedule(); // 새로고침
    });
  }

  void _showCancelConfirmDialog(BuildContext context, PtSchedule schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('세션 취소'),
        content: const Text('정말로 이 세션을 취소하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // 취소 처리 로직
              _loadWeeklySchedule();
            },
            child: const Text('예'),
          ),
        ],
      ),
    );
  }

  void _markAsCompleted(PtSchedule schedule) {
    // 완료 처리 로직
    _loadWeeklySchedule();
  }
}