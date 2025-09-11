import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../pt_contract/model/pt_appointment_models.dart';
import '../../pt_contract/viewmodel/pt_contract_viewmodel.dart';
import '../../../core/providers/auth_provider.dart';
import '../../auth/model/user_model.dart';

class TodayPTScheduleCard extends ConsumerStatefulWidget {
  const TodayPTScheduleCard({super.key});

  @override
  ConsumerState<TodayPTScheduleCard> createState() => _TodayPTScheduleCardState();
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
      
      final response = await ref.read(ptContractViewModelProvider.notifier).getMyScheduledAppointments(
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
          color: Colors.grey.shade600,
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
        ...sortedAppointments.map((appointment) => _buildScheduleItem(appointment)),
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
              color: const Color(0xFF6B7280).withOpacity(0.7),
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

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade700,
            Colors.grey.shade800,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$startTime - $endTime',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      duration,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
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
                user?.userType == UserType.trainer ? Icons.person : Icons.fitness_center,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                '$displayName $roleText',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ],
          ),
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
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '일정 변경 요청이 있습니다',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
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
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    String text;
    IconData icon;

    switch (status) {
      case 'SCHEDULED':
        backgroundColor = Colors.white.withOpacity(0.2);
        text = '예정';
        icon = Icons.schedule;
        break;
      case 'COMPLETED':
        backgroundColor = Colors.white.withOpacity(0.2);
        text = '완료';
        icon = Icons.check_circle;
        break;
      case 'CANCELLED':
        backgroundColor = Colors.red.withOpacity(0.2);
        text = '취소';
        icon = Icons.cancel;
        break;
      case 'MEMBER_REQUESTED':
        backgroundColor = Colors.blue.withOpacity(0.2);
        text = '요청됨';
        icon = Icons.pending;
        break;
      default:
        backgroundColor = Colors.white.withOpacity(0.2);
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
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
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
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.today,
            size: 16,
            color: Colors.grey.shade700,
          ),
          const SizedBox(width: 6),
          Text(
            '총 ${count}개의 PT 세션이 예정되어 있습니다',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ],
      ),
    );
  }
}
