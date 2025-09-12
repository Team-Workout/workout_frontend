import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../pt_contract/model/pt_appointment_models.dart';
import '../../pt_contract/viewmodel/pt_contract_viewmodel.dart';
import '../../../core/providers/auth_provider.dart';
import '../../auth/model/user_model.dart';
import '../../pt_contract/widget/pt_session_create_dialog.dart';

class TodayPTScheduleCard extends ConsumerStatefulWidget {
  const TodayPTScheduleCard({super.key});

  @override
  ConsumerState<TodayPTScheduleCard> createState() =>
      _TodayPTScheduleCardState();
}

class _TodayPTScheduleCardState extends ConsumerState<TodayPTScheduleCard> {
  PtAppointmentsResponse? _todayAppointments;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTodayAppointments();
    });
  }

  Future<void> _loadTodayAppointments() async {
    setState(() => _isLoading = true);

    try {
      // 오늘 날짜만 조회
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final response = await ref
          .read(ptContractViewModelProvider.notifier)
          .getMyScheduledAppointments(
            startDate: today,
            endDate: today,
            status: 'SCHEDULED',
          );

      setState(() {
        _todayAppointments = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('오늘의 PT 조회 실패: $e');
    }
  }

  void _onScheduleItemTap(PtAppointment appointment) {
    final user = ref.read(currentUserProvider);

    // 트레이너이고 예정된 상태가 아닌 경우에만 일반 상세 정보 표시
    if (user?.userType == UserType.trainer &&
        (appointment.status != 'SCHEDULED' && appointment.status != null)) {
      _showAppointmentDetails(appointment);
    }
    // 회원인 경우 항상 상세 정보 표시
    else if (user?.userType != UserType.trainer) {
      _showAppointmentDetails(appointment);
    }
    // 트레이너이고 예정된 상태인 경우는 세션 작성 버튼을 통해서만 처리
  }

  void _showAppointmentDetails(PtAppointment appointment) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.1), // 아주 연한 검은색 오버레이
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
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
                      'PT 일정 상세',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBMPlexSansKR',
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('회원', appointment.memberName, Icons.person),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                        '트레이너', appointment.trainerName, Icons.fitness_center),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                        '시간', _formatAppointmentTime(appointment), Icons.schedule),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                        '상태',
                        _getStatusText(appointment.status ?? 'SCHEDULED'),
                        Icons.info_outline),
                    if (appointment.changeRequestStartTime != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.orange.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.schedule_outlined,
                                size: 16, color: Colors.orange),
                            const SizedBox(width: 8),
                            const Text(
                              '일정 변경 요청이 있습니다',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Actions
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF10B981),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ),
      ],
    );
  }

  void _showSessionCreateDialog(PtAppointment appointment) {
    final sessionDate = DateTime.parse(appointment.startTime);

    showDialog(
      context: context,
      builder: (context) => PtSessionCreateDialog(
        appointmentId: appointment.appointmentId,
        trainerName: appointment.trainerName,
        memberName: appointment.memberName,
        sessionDate: sessionDate,
      ),
    ).then((result) {
      // 세션 생성 성공 시 일정 새로고침
      if (result == true) {
        _loadTodayAppointments();
      }
    });
  }

  String _formatAppointmentTime(PtAppointment appointment) {
    try {
      final start = DateTime.parse(appointment.startTime);
      final end = DateTime.parse(appointment.endTime);
      final startTime = DateFormat('HH:mm').format(start);
      final endTime = DateFormat('HH:mm').format(end);
      return '$startTime - $endTime';
    } catch (e) {
      return '시간 정보 없음';
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'SCHEDULED':
        return '예정';
      case 'COMPLETED':
        return '완료';
      case 'CANCELLED':
        return '취소';
      case 'MEMBER_REQUESTED':
        return '요청됨';
      default:
        return '예정';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '오늘의 PT 일정',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
              GestureDetector(
                onTap: _loadTodayAppointments,
                child: Icon(
                  Icons.refresh,
                  size: 20,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            _buildLoadingState()
          else if (_todayAppointments == null)
            _buildErrorState()
          else
            _buildScheduleList(_todayAppointments!.data),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 80,
      child: Center(
        child: CircularProgressIndicator(
          color: const Color(0xFF10B981),
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          const Text(
            '일정을 불러올 수 없습니다',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleList(List<PtAppointment> appointments) {
    // 시간순으로 정렬
    final sortedAppointments = List<PtAppointment>.from(appointments);
    sortedAppointments.sort((a, b) {
      try {
        final timeA = DateTime.parse(a.startTime);
        final timeB = DateTime.parse(b.startTime);
        return timeA.compareTo(timeB);
      } catch (e) {
        return 0;
      }
    });

    if (sortedAppointments.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        ...sortedAppointments
            .map((appointment) => _buildScheduleItem(appointment)),
        if (sortedAppointments.length > 1) const SizedBox(height: 8),
        if (sortedAppointments.length > 1)
          _buildScheduleSummary(sortedAppointments.length),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.event_available,
              size: 32,
              color: const Color(0xFF10B981).withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '오늘 예정된 PT가 없어요',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '휴식을 취하거나 자유 운동을 해보세요!',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontFamily: 'IBMPlexSansKR',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(PtAppointment appointment) {
    String startTime = '';
    String endTime = '';
    String duration = '';

    try {
      final start = DateTime.parse(appointment.startTime);
      final end = DateTime.parse(appointment.endTime);
      startTime = DateFormat('HH:mm').format(start);
      endTime = DateFormat('HH:mm').format(end);
      final diff = end.difference(start).inMinutes;
      duration = '${diff}분';
    } catch (e) {
      startTime = '시간 미정';
      duration = '-';
    }

    final user = ref.watch(currentUserProvider);
    final displayName = user?.userType == UserType.trainer
        ? appointment.memberName
        : appointment.trainerName;
    final roleText = user?.userType == UserType.trainer ? '회원' : '트레이너';

    return GestureDetector(
      onTap: () => _onScheduleItemTap(appointment),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF10B981).withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$startTime - $endTime',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF065F46),
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        duration,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ),
                  ],
                ),
                _buildStatusBadge(appointment.status ?? 'SCHEDULED'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  user?.userType == UserType.trainer
                      ? Icons.person
                      : Icons.fitness_center,
                  size: 16,
                  color: const Color(0xFF10B981),
                ),
                const SizedBox(width: 6),
                Text(
                  '$displayName $roleText',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ],
            ),
            // 트레이너이고 예정된 상태일 때 세션 작성 버튼 표시
            if (user?.userType == UserType.trainer &&
                (appointment.status == 'SCHEDULED' ||
                    appointment.status == null)) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showSessionCreateDialog(appointment),
                  icon: const Icon(Icons.edit_note, size: 18),
                  label: const Text(
                    '세션 작성',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
            // 변경 요청이 있는 경우 표시
            if (appointment.changeRequestStartTime != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.schedule_outlined,
                      size: 14,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '일정 변경 요청이 있습니다',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[700],
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
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case 'SCHEDULED':
        backgroundColor = const Color(0xFF10B981).withValues(alpha: 0.1);
        textColor = const Color(0xFF065F46);
        text = '예정';
        icon = Icons.schedule;
        break;
      case 'COMPLETED':
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green[700]!;
        text = '완료';
        icon = Icons.check_circle;
        break;
      case 'CANCELLED':
        backgroundColor = Colors.red.withValues(alpha: 0.1);
        textColor = Colors.red[700]!;
        text = '취소';
        icon = Icons.cancel;
        break;
      case 'MEMBER_REQUESTED':
        backgroundColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue[700]!;
        text = '요청됨';
        icon = Icons.pending;
        break;
      default:
        backgroundColor = const Color(0xFF10B981).withValues(alpha: 0.1);
        textColor = const Color(0xFF065F46);
        text = '예정';
        icon = Icons.schedule;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSummary(int count) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.today,
            size: 16,
            color: const Color(0xFF10B981),
          ),
          const SizedBox(width: 6),
          Text(
            '총 ${count}개의 PT 세션이 예정되어 있습니다',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF065F46),
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ],
      ),
    );
  }
}
