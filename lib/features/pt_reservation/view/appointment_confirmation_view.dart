import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../pt_contract/viewmodel/pt_contract_viewmodel.dart';
import '../../pt_schedule/viewmodel/pt_schedule_viewmodel.dart';
import '../../pt_schedule/model/pt_schedule_models.dart';
import '../../../core/providers/auth_provider.dart';

class AppointmentConfirmationView extends ConsumerStatefulWidget {
  const AppointmentConfirmationView({super.key});

  @override
  ConsumerState<AppointmentConfirmationView> createState() => _AppointmentConfirmationViewState();
}

class _AppointmentConfirmationViewState extends ConsumerState<AppointmentConfirmationView> {
  @override
  void initState() {
    super.initState();
    // MEMBER_REQUESTED 상태의 스케줄만 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🔍 [APPOINTMENT_CONFIRMATION] 약속 승인 페이지 - MEMBER_REQUESTED 상태 로드 시작');
      ref.read(ptScheduleViewModelProvider.notifier).loadMonthlySchedule(
        month: DateTime.now(),
        status: 'MEMBER_REQUESTED',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final schedulesAsync = ref.watch(ptScheduleViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          '약속 요청 승인',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(ptScheduleViewModelProvider.notifier).loadMonthlySchedule(
                month: DateTime.now(),
                status: 'MEMBER_REQUESTED',
              );
            },
          ),
        ],
      ),
      body: user?.userType.name != 'trainer' 
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.block, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  '트레이너만 약속을 승인할 수 있습니다',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          )
        : schedulesAsync.when(
            data: (schedules) {
              print('🔍 [APPOINTMENT_CONFIRMATION] 받아온 스케줄 개수: ${schedules.length}');
              for (int i = 0; i < schedules.length; i++) {
                final schedule = schedules[i];
                print('🔍 [APPOINTMENT_CONFIRMATION] 스케줄 $i: ${schedule.memberName} - ${schedule.status} - ID: ${schedule.appointmentId}');
              }
              
              // 이미 MEMBER_REQUESTED 상태만 받아왔으므로 추가 필터링 불필요
              if (schedules.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '승인 대기 중인 약속이 없습니다',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () {
                          ref.read(ptScheduleViewModelProvider.notifier).loadMonthlySchedule(
                            month: DateTime.now(),
                            status: 'MEMBER_REQUESTED',
                          );
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('새로고침'),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final appointment = schedules[index];
                  return _buildAppointmentCard(appointment);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
            )),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '데이터를 불러올 수 없습니다',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {
                      ref.read(ptScheduleViewModelProvider.notifier).loadMonthlySchedule(
                        month: DateTime.now(),
                        status: 'MEMBER_REQUESTED',
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildAppointmentCard(PtSchedule appointment) {
    final startTime = DateTime.parse(appointment.startTime);
    final endTime = DateTime.parse(appointment.endTime);
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showConfirmationDialog(appointment),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.memberName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${appointment.appointmentId}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(appointment.status),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('yyyy년 MM월 dd일').format(startTime),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              if (appointment.hasChangeRequest == true) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.schedule, size: 16, color: Colors.orange[700]),
                      const SizedBox(width: 8),
                      Text(
                        '시간 변경 요청이 있습니다',
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _showDetailsDialog(appointment),
                    child: const Text('상세보기'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: appointment.status == 'SCHEDULED' 
                      ? null 
                      : () {
                          print('🔍 [APPOINTMENT_CONFIRMATION] 승인 버튼 클릭 - ${appointment.memberName}, 상태: ${appointment.status}');
                          _showConfirmationDialog(appointment);
                        },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.check, size: 18),
                    label: Text(
                      appointment.status == 'SCHEDULED' ? '승인됨' : '승인하기'
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;
    
    switch (status) {
      case 'SCHEDULED':
        color = Colors.green;
        text = '예약확정';
        break;
      case 'PENDING':
        color = Colors.orange;
        text = '대기중';
        break;
      case 'COMPLETED':
        color = Colors.blue;
        text = '완료';
        break;
      case 'CANCELLED':
        color = Colors.red;
        text = '취소';
        break;
      default:
        color = Colors.grey;
        text = status;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showDetailsDialog(PtSchedule appointment) {
    final startTime = DateTime.parse(appointment.startTime);
    final endTime = DateTime.parse(appointment.endTime);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('약속 상세 정보'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('회원명', appointment.memberName),
            _buildDetailRow('트레이너', appointment.trainerName),
            _buildDetailRow('약속 ID', appointment.appointmentId.toString()),
            _buildDetailRow('계약 ID', appointment.contractId.toString()),
            _buildDetailRow('날짜', DateFormat('yyyy년 MM월 dd일').format(startTime)),
            _buildDetailRow('시간', '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}'),
            _buildDetailRow('상태', appointment.status),
            if (appointment.requestedStartTime != null && appointment.requestedEndTime != null) ...[
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                '변경 요청 시간',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(appointment.requestedStartTime!))} - ${DateFormat('HH:mm').format(DateTime.parse(appointment.requestedEndTime!))}',
              ),
            ],
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
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(PtSchedule appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('약속 승인'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${appointment.memberName}님의 PT 약속을 승인하시겠습니까?'),
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
                  Text(
                    '약속 정보',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '날짜: ${DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(appointment.startTime))}',
                    style: TextStyle(color: Colors.blue[800]),
                  ),
                  Text(
                    '시간: ${DateFormat('HH:mm').format(DateTime.parse(appointment.startTime))} - ${DateFormat('HH:mm').format(DateTime.parse(appointment.endTime))}',
                    style: TextStyle(color: Colors.blue[800]),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _confirmAppointment(appointment.appointmentId);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('승인'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAppointment(int appointmentId) async {
    try {
      await ref.read(ptContractViewModelProvider.notifier).confirmAppointment(
        appointmentId: appointmentId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PT 약속이 승인되었습니다.'),
            backgroundColor: Colors.green,
          ),
        );
        
        // 목록 새로고침
        ref.read(ptScheduleViewModelProvider.notifier).loadMonthlySchedule(
          month: DateTime.now(),
          status: 'MEMBER_REQUESTED',
        );
      }
    } catch (error) {
      if (mounted) {
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