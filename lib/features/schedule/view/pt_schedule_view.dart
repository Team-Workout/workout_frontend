import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pt_service/features/pt_schedule/model/pt_schedule_models.dart';
import 'package:pt_service/features/pt_schedule/viewmodel/pt_schedule_viewmodel.dart';
import 'package:pt_service/features/pt_schedule/widget/schedule_change_request_dialog.dart';
import 'package:pt_service/features/pt_contract/widget/pt_session_create_dialog.dart';
import 'package:pt_service/core/providers/auth_provider.dart';
import 'package:pt_service/features/auth/model/user_model.dart';
import 'package:intl/intl.dart';

class PTScheduleView extends ConsumerStatefulWidget {
  const PTScheduleView({super.key});

  @override
  ConsumerState<PTScheduleView> createState() => _PTScheduleViewState();
}

class _PTScheduleViewState extends ConsumerState<PTScheduleView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    // 현재 달의 스케줄 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(ptScheduleViewModelProvider.notifier)
          .loadMonthlySchedule(month: _focusedDay, status: 'SCHEDULED');
    });
  }

  @override
  Widget build(BuildContext context) {
    final schedulesAsync = ref.watch(ptScheduleViewModelProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PT 일정 관리'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref
                  .read(ptScheduleViewModelProvider.notifier)
                  .loadMonthlySchedule(month: _focusedDay, status: 'SCHEDULED');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: TableCalendar<PtSchedule>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              eventLoader: (day) {
                return schedulesAsync.when(
                  data: (schedules) {
                    final eventsForDay = schedules.where((schedule) {
                      final scheduleDate = DateTime.parse(schedule.startTime);
                      return isSameDay(scheduleDate, day);
                    }).toList();

                    if (eventsForDay.isNotEmpty) {
                      print(
                          '📅 ${day.toString().substring(0, 10)}에 ${eventsForDay.length}개 일정 있음');
                    }

                    return eventsForDay;
                  },
                  loading: () => [],
                  error: (_, __) => [],
                );
              },
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                markerDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
                // 달 변경 시 새로운 달의 스케줄 로드
                ref
                    .read(ptScheduleViewModelProvider.notifier)
                    .loadMonthlySchedule(month: focusedDay, status: 'SCHEDULED');
              },
            ),
          ),
          Expanded(
            child: schedulesAsync.when(
              data: (schedules) => _buildScheduleList(schedules),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('오류가 발생했습니다: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleList(List<PtSchedule> allSchedules) {
    final selectedSchedules = allSchedules.where((schedule) {
      if (_selectedDay == null) return false;
      final scheduleDate = DateTime.parse(schedule.startTime);
      return isSameDay(scheduleDate, _selectedDay!);
    }).toList();

    selectedSchedules.sort((a, b) =>
        DateTime.parse(a.startTime).compareTo(DateTime.parse(b.startTime)));

    if (selectedSchedules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _selectedDay != null
                  ? '${DateFormat('M월 d일').format(_selectedDay!)}에 예약된 PT가 없습니다'
                  : '날짜를 선택해주세요',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: selectedSchedules.length,
      itemBuilder: (context, index) {
        final schedule = selectedSchedules[index];
        final startTime = DateTime.parse(schedule.startTime);
        final endTime = DateTime.parse(schedule.endTime);
        final timeText =
            '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  _getStatusColor(schedule.status).withOpacity(0.2),
              child: Icon(
                _getStatusIcon(schedule.status),
                color: _getStatusColor(schedule.status),
              ),
            ),
            title: Text(
              ref.watch(currentUserProvider)?.userType.name == 'trainer'
                  ? schedule.memberName
                  : schedule.trainerName,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(timeText),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _getStatusText(schedule.status),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getStatusColor(schedule.status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (schedule.hasChangeRequest == true) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: schedule.changeRequestBy == 'member'
                              ? Colors.blue
                              : schedule.changeRequestBy == 'trainer'
                                  ? Colors.purple
                                  : Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          schedule.changeRequestBy == 'member'
                              ? '회원 요청'
                              : schedule.changeRequestBy == 'trainer'
                                  ? '트레이너 요청'
                                  : '변경요청',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            trailing: _buildTrailingWidget(schedule),
            onTap: () {
              _showScheduleDetail(context, schedule);
            },
          ),
        );
      },
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
    showDialog(
      context: context,
      builder: (context) => ScheduleChangeRequestDialog(
        schedule: schedule,
        isTrainerRequest: isTrainer,
      ),
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

          // Refresh the schedule list
          ref
              .read(ptScheduleViewModelProvider.notifier)
              .loadMonthlySchedule(month: _focusedDay, status: 'SCHEDULED');
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
