import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  const PTScheduleView({super.key});

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('PT 일정 시간표'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWeeklySchedule,
          ),
        ],
      ),
      body: Column(
        children: [
          // 주 선택 컨트롤
          Container(
            padding: const EdgeInsets.all(16),
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
                  icon: const Icon(Icons.chevron_left),
                ),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedWeek,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedWeek = picked;
                      });
                      _loadWeeklySchedule();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${DateFormat('yyyy년 M월').format(_selectedWeek)} ${(_selectedWeek.day / 7).ceil()}주차',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          // 오늘로 돌아가기 버튼
          if (_selectedWeek.difference(DateTime.now()).inDays.abs() > 7)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: NotionButton(
                onPressed: () {
                  setState(() {
                    _selectedWeek = DateTime.now();
                  });
                  _loadWeeklySchedule();
                },
                text: '오늘로 돌아가기',
                icon: Icons.today,
              ),
            ),
          const SizedBox(height: 8),
          // 시간표 위젯
          Expanded(
            child: schedulesAsync.when(
              data: (schedules) => WeeklyTimetableWidget(
                schedules: schedules,
                selectedWeek: _selectedWeek,
                onScheduleTap: (schedule) => _showScheduleDetail(context, schedule),
                onScheduleAction: (schedule, action) => _handleScheduleAction(context, schedule, action),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('오류가 발생했습니다: $error'),
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
      ),
    );
  }

  Widget _buildTrailingWidget(PtSchedule schedule) {
    final userType = ref.watch(currentUserProvider)?.userType.name;

    if (userType == 'trainer') {
      // 트레이너용 메뉴
      return PopupMenuButton<String>(
        onSelected: (value) async {
          await _handleScheduleAction(context, schedule, value);
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'detail',
            child: Text('상세보기'),
          ),
          if (schedule.hasChangeRequest == true &&
              schedule.changeRequestBy == 'member') ...[
            const PopupMenuItem(
              value: 'approve_change',
              child: Text('시간 변경 승인'),
            ),
            const PopupMenuItem(
              value: 'reject_change',
              child: Text('시간 변경 거절'),
            ),
          ],
          if (schedule.status == 'SCHEDULED' &&
              schedule.hasChangeRequest != true) ...[
            const PopupMenuItem(
              value: 'trainer_request_change',
              child: Text('시간 변경 요청'),
            ),
            const PopupMenuItem(
              value: 'complete',
              child: Text('수업 완료'),
            ),
            const PopupMenuItem(
              value: 'cancel',
              child: Text('수업 취소'),
            ),
          ],
        ],
      );
    } else if (userType == 'member') {
      // 회원용 메뉴
      return PopupMenuButton<String>(
        onSelected: (value) async {
          await _handleScheduleAction(context, schedule, value);
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'detail',
            child: Text('상세보기'),
          ),
          if (schedule.hasChangeRequest == true &&
              schedule.changeRequestBy == 'trainer') ...[
            const PopupMenuItem(
              value: 'member_approve_change',
              child: Text('시간 변경 승인'),
            ),
            const PopupMenuItem(
              value: 'member_reject_change',
              child: Text('시간 변경 거절'),
            ),
          ],
          if (schedule.status == 'SCHEDULED' &&
              schedule.hasChangeRequest != true) ...[
            const PopupMenuItem(
              value: 'request_change',
              child: Text('시간 변경 요청'),
            ),
          ],
        ],
      );
    }

    return const Icon(Icons.arrow_forward_ios, size: 16);
  }

  Future<void> _handleScheduleAction(
      BuildContext context, PtSchedule schedule, String action) async {
    switch (action) {
      case 'detail':
        _showScheduleDetail(context, schedule);
        break;
      case 'complete':
        await _showPtSessionCreateDialog(context, schedule);
        break;
      case 'cancel':
        await _updateScheduleStatus(
            context, schedule, 'CANCELLED', '수업을 취소로 표시하시겠습니까?');
        break;
      case 'request_change':
        _showScheduleChangeRequestDialog(context, schedule, isTrainer: false);
        break;
      case 'trainer_request_change':
        print('🔄 [UI] 트레이너 시간 변경 요청 다이얼로그 호출');
        _showScheduleChangeRequestDialog(context, schedule, isTrainer: true);
        break;
      case 'approve_change':
        await _approveScheduleChange(context, schedule);
        break;
      case 'reject_change':
        await _rejectScheduleChange(context, schedule);
        break;
      case 'member_approve_change':
        await _memberApproveScheduleChange(context, schedule);
        break;
      case 'member_reject_change':
        await _memberRejectScheduleChange(context, schedule);
        break;
    }
  }

  Future<void> _updateScheduleStatus(BuildContext context, PtSchedule schedule,
      String status, String confirmMessage) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('상태 변경'),
        content: Text(confirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('확인'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref
            .read(ptScheduleViewModelProvider.notifier)
            .updateAppointmentStatus(
              appointmentId: schedule.appointmentId,
              status: status,
            );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '수업 상태가 ${status == 'COMPLETED' ? '완료' : '취소'}로 변경되었습니다.'),
              backgroundColor:
                  status == 'COMPLETED' ? Colors.green : Colors.orange,
            ),
          );
          // 시간표 새로고침
          _loadWeeklySchedule();
        }
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('상태 변경 실패: $error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showScheduleChangeRequestDialog(
      BuildContext context, PtSchedule schedule,
      {required bool isTrainer}) {
    print('🔄 [UI] showDialog 호출 시작');
    showDialog(
      context: context,
      builder: (context) {
        print('🔄 [UI] ScheduleChangeRequestDialog 생성');
        return ScheduleChangeRequestDialog(
          schedule: schedule,
          isTrainerRequest: isTrainer,
        );
      },
    );
  }

  Future<void> _memberApproveScheduleChange(
      BuildContext context, PtSchedule schedule) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('시간 변경 승인'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${schedule.trainerName} 트레이너의 시간 변경 요청을 승인하시겠습니까?'),
            if (schedule.requestedStartTime != null &&
                schedule.requestedEndTime != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '변경 요청 시간',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('yyyy년 M월 d일')
                          .format(DateTime.parse(schedule.requestedStartTime!)),
                    ),
                    Text(
                      '${DateFormat('HH:mm').format(DateTime.parse(schedule.requestedStartTime!))} - ${DateFormat('HH:mm').format(DateTime.parse(schedule.requestedEndTime!))}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('승인'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref
            .read(ptScheduleViewModelProvider.notifier)
            .memberApproveScheduleChange(
              appointmentId: schedule.appointmentId,
            );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('시간 변경 요청이 승인되었습니다.'),
              backgroundColor: Colors.green,
            ),
          );
          _loadWeeklySchedule();
        }
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('승인 실패: $error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _memberRejectScheduleChange(
      BuildContext context, PtSchedule schedule) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('시간 변경 거절'),
        content: Text('${schedule.trainerName} 트레이너의 시간 변경 요청을 거절하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('거절'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // 회원의 거절은 기존 reject API를 재사용
      try {
        await ref
            .read(ptScheduleViewModelProvider.notifier)
            .rejectScheduleChange(
              appointmentId: schedule.appointmentId,
            );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('시간 변경 요청이 거절되었습니다.'),
              backgroundColor: Colors.orange,
            ),
          );
          _loadWeeklySchedule();
        }
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('거절 실패: $error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _approveScheduleChange(
      BuildContext context, PtSchedule schedule) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('시간 변경 승인'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${schedule.memberName}님의 시간 변경 요청을 승인하시겠습니까?'),
            if (schedule.requestedStartTime != null &&
                schedule.requestedEndTime != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '변경 요청 시간',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${DateFormat('yyyy년 M월 d일').format(DateTime.parse(schedule.requestedStartTime!))}',
                    ),
                    Text(
                      '${DateFormat('HH:mm').format(DateTime.parse(schedule.requestedStartTime!))} - ${DateFormat('HH:mm').format(DateTime.parse(schedule.requestedEndTime!))}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('승인'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref
            .read(ptScheduleViewModelProvider.notifier)
            .approveScheduleChange(
              appointmentId: schedule.appointmentId,
            );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('시간 변경 요청이 승인되었습니다.'),
              backgroundColor: Colors.green,
            ),
          );
          _loadWeeklySchedule();
        }
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('승인 실패: $error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _rejectScheduleChange(
      BuildContext context, PtSchedule schedule) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('시간 변경 거절'),
        content: Text('${schedule.memberName}님의 시간 변경 요청을 거절하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('거절'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref
            .read(ptScheduleViewModelProvider.notifier)
            .rejectScheduleChange(
              appointmentId: schedule.appointmentId,
            );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('시간 변경 요청이 거절되었습니다.'),
              backgroundColor: Colors.orange,
            ),
          );
          _loadWeeklySchedule();
        }
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('거절 실패: $error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _showPtSessionCreateDialog(
      BuildContext context, PtSchedule schedule) async {
    final user = ref.read(currentUserProvider);

    // Only trainers can create PT sessions
    if (user?.userType != UserType.trainer) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PT 세션 기록은 트레이너만 가능합니다.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final sessionCreated = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PtSessionCreateDialog(
        appointmentId: schedule.appointmentId,
        trainerName: schedule.trainerName,
        memberName: schedule.memberName,
        sessionDate: DateTime.parse(schedule.startTime),
      ),
    );

    if (sessionCreated == true) {
      // After creating the session, mark the appointment as completed
      try {
        await ref
            .read(ptScheduleViewModelProvider.notifier)
            .updateAppointmentStatus(
              appointmentId: schedule.appointmentId,
              status: 'COMPLETED',
            );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('수업이 완료되었습니다.'),
              backgroundColor: Colors.green,
            ),
          );
          _loadWeeklySchedule();
        }
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('상태 업데이트 실패: $error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showScheduleDetail(BuildContext context, PtSchedule schedule) {
    final startTime = DateTime.parse(schedule.startTime);
    final endTime = DateTime.parse(schedule.endTime);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('일정 상세'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('트레이너', schedule.trainerName),
            _buildDetailRow('회원', schedule.memberName),
            _buildDetailRow('날짜', DateFormat('yyyy년 M월 d일').format(startTime)),
            _buildDetailRow('시간',
                '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}'),
            _buildDetailRow('상태', _getStatusText(schedule.status)),
            if (schedule.hasChangeRequest == true) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: Colors.orange[700]),
                    const SizedBox(width: 8),
                    Text(
                      '시간 변경 요청 대기 중',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            _buildDetailRow('예약 ID', schedule.appointmentId.toString()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'SCHEDULED':
        return '예약됨';
      case 'COMPLETED':
        return '완료';
      case 'CANCELLED':
        return '취소';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'SCHEDULED':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'SCHEDULED':
        return Icons.schedule;
      case 'COMPLETED':
        return Icons.check_circle;
      case 'CANCELLED':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }
}
