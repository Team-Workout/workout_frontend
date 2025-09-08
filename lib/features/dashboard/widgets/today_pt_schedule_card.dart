import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../schedule/model/pt_schedule_model.dart';
import '../../schedule/viewmodel/schedule_viewmodel.dart';

class TodayPTScheduleCard extends ConsumerWidget {
  const TodayPTScheduleCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(ptScheduleListProvider);

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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '오늘의 PT 일정',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          schedulesAsync.when(
            loading: () => _buildLoadingState(),
            error: (error, _) => _buildErrorState(),
            data: (schedules) => _buildScheduleList(schedules),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 80,
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF10B981),
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

  Widget _buildScheduleList(List<PTSchedule> schedules) {
    final today = DateTime.now();
    final todaySchedules = schedules.where((schedule) {
      return schedule.dateTime.day == today.day &&
          schedule.dateTime.month == today.month &&
          schedule.dateTime.year == today.year;
    }).toList();

    // 오늘 일정을 시간순으로 정렬
    todaySchedules.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    if (todaySchedules.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        ...todaySchedules.map((schedule) => _buildScheduleItem(schedule)),
        if (todaySchedules.length > 1) const SizedBox(height: 8),
        if (todaySchedules.length > 1)
          _buildScheduleSummary(todaySchedules.length),
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

  Widget _buildScheduleItem(PTSchedule schedule) {
    final timeFormat = DateFormat('HH:mm');
    final time = timeFormat.format(schedule.dateTime);
    final duration = '${schedule.durationMinutes}분';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF10B981),
            Color(0xFF34D399),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      time,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              _buildStatusBadge(schedule.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                schedule.trainerName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ],
          ),
          if (schedule.notes != null && schedule.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.note,
                    size: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      schedule.notes!,
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

  Widget _buildStatusBadge(PTScheduleStatus status) {
    Color backgroundColor;
    String text;
    IconData icon;

    switch (status) {
      case PTScheduleStatus.scheduled:
        backgroundColor = Colors.white.withOpacity(0.2);
        text = '예정';
        icon = Icons.schedule;
        break;
      case PTScheduleStatus.completed:
        backgroundColor = Colors.white.withOpacity(0.2);
        text = '완료';
        icon = Icons.check_circle;
        break;
      case PTScheduleStatus.cancelled:
        backgroundColor = Colors.red.withOpacity(0.2);
        text = '취소';
        icon = Icons.cancel;
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
        color: const Color(0xFF10B981).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.today,
            size: 16,
            color: Color(0xFF10B981),
          ),
          const SizedBox(width: 6),
          Text(
            '총 ${count}개의 PT 세션이 예정되어 있습니다',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF10B981),
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ],
      ),
    );
  }
}
