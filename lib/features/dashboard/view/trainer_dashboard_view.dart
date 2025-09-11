import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pt_service/core/providers/auth_provider.dart';
import 'package:pt_service/shared/widgets/notion_dashboard_card.dart';
import 'package:pt_service/features/pt_offerings/viewmodel/pt_offering_viewmodel.dart';
import 'package:pt_service/features/pt_applications/viewmodel/pt_application_viewmodel.dart';
import 'package:pt_service/features/pt_contract/viewmodel/pt_contract_viewmodel.dart';
import 'package:pt_service/features/settings/viewmodel/settings_viewmodel.dart';
import '../../../core/theme/notion_colors.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../widgets/today_pt_schedule_card.dart';
import 'package:intl/intl.dart';
import '../../../features/schedule/widget/everytime_timetable_widget.dart';
import '../../../features/pt_schedule/model/pt_schedule_models.dart';
import '../../../features/pt_contract/model/pt_appointment_models.dart';
import '../../../features/pt_contract/repository/pt_contract_repository.dart';

part 'trainer_dashboard_view.g.dart';

// 이번 달 PT 개수 조회
@riverpod
Future<int> monthlyPtCount(Ref ref) async {
  final now = DateTime.now();
  final monthStart = DateTime(now.year, now.month, 1);
  final monthEnd = DateTime(now.year, now.month + 1, 0);

  print('📊 이번 달 PT 개수 조회 시작: ${now.year}-${now.month}');

  try {
    final response = await ref
        .read(ptContractViewModelProvider.notifier)
        .getMyScheduledAppointments(
          startDate: DateFormat('yyyy-MM-dd').format(monthStart),
          endDate: DateFormat('yyyy-MM-dd').format(monthEnd),
          status: 'SCHEDULED',
        );

    final count = response.data.length;
    print('📊 이번 달 PT 개수: $count건');
    return count;
  } catch (e) {
    print('❌ 이번 달 PT 개수 조회 오류: $e');
    return 0;
  }
}

// 이번 주 일별 PT 통계 조회
@riverpod
Future<List<int>> weeklyPtStats(Ref ref) async {
  final now = DateTime.now();

  // 이번 주의 월요일을 구함
  final mondayOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final weeklyStats = <int>[];

  print('📊 주간 PT 통계 조회 시작');

  try {
    for (int i = 0; i < 7; i++) {
      final targetDate = mondayOfWeek.add(Duration(days: i));
      final dayStart =
          DateTime(targetDate.year, targetDate.month, targetDate.day);
      final dayDateString = DateFormat('yyyy-MM-dd').format(dayStart);

      final response = await ref
          .read(ptContractViewModelProvider.notifier)
          .getMyScheduledAppointments(
            startDate: dayDateString,
            endDate: dayDateString,
            status: 'SCHEDULED',
          );

      final dayCount = response.data.length;
      weeklyStats.add(dayCount);
      print('📊 ${_getWeekdayName(i)}: $dayCount건');
    }

    return weeklyStats;
  } catch (e) {
    print('❌ 주간 PT 통계 조회 오류: $e');
    return [0, 0, 0, 0, 0, 0, 0];
  }
}

String _getWeekdayName(int index) {
  const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  return weekdays[index];
}

// 이번 주 시간표용 PT 스케줄 조회
@riverpod
Future<List<PtSchedule>> weeklyTimetableSchedules(Ref ref) async {
  try {
    final repository = ref.read(ptContractRepositoryProvider);

    // 시간표에는 예정됨과 변경요청 스케줄만 로드
    final timetableStatuses = [
      'SCHEDULED',
      'CHANGE_REQUESTED',
      'TRAINER_CHANGE_REQUESTED'
    ];
    final futures = timetableStatuses.map((status) {
      return repository.getMyScheduledAppointments(status: status);
    }).toList();

    final responses = await Future.wait(futures);

    // 모든 응답을 하나로 합치기
    final allAppointments = <PtAppointment>[];
    for (final response in responses) {
      allAppointments.addAll(response.data);
    }

    // 중복 제거 (appointmentId 기준)
    final uniqueAppointments = <int, PtAppointment>{};
    for (final appointment in allAppointments) {
      uniqueAppointments[appointment.appointmentId] = appointment;
    }

    // PtAppointment를 PtSchedule로 변환
    final schedules = uniqueAppointments.values.map((appointment) {
      return PtSchedule(
        appointmentId: appointment.appointmentId,
        contractId: appointment.contractId,
        trainerName: appointment.trainerName,
        memberName: appointment.memberName,
        startTime: appointment.startTime,
        endTime: appointment.endTime,
        status: appointment.status ?? 'SCHEDULED',
        hasChangeRequest: appointment.changeRequestStartTime != null,
        changeRequestBy: appointment.changeRequestBy,
        requestedStartTime: appointment.changeRequestStartTime,
        requestedEndTime: appointment.changeRequestEndTime,
      );
    }).toList();

    print('📅 시간표용 스케줄 로드 완료: ${schedules.length}개');
    return schedules;
  } catch (e) {
    print('❌ 시간표용 스케줄 로드 오류: $e');
    return [];
  }
}

class TrainerDashboardView extends ConsumerStatefulWidget {
  const TrainerDashboardView({super.key});

  @override
  ConsumerState<TrainerDashboardView> createState() =>
      _TrainerDashboardViewState();
}

class _TrainerDashboardViewState extends ConsumerState<TrainerDashboardView> {
  @override
  void initState() {
    super.initState();

    // 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider);
      if (user?.id != null) {
        final trainerId = int.parse(user!.id);
        ref.read(ptOfferingProvider.notifier).loadPtOfferings(trainerId);
        ref.read(ptApplicationProvider.notifier).loadPtApplications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthlyPtCountAsync = ref.watch(monthlyPtCountProvider);
    final weeklyStatsAsync = ref.watch(weeklyPtStatsProvider);

    // 이번 달 PT 개수 계산
    final monthlyPtCount = monthlyPtCountAsync.whenOrNull(
          data: (count) => count,
        ) ??
        0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          '${ref.watch(currentUserProvider)?.name ?? '트레이너'} 님',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'IBMPlexSansKR',
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                context.push('/trainer-profile-edit');
              },
              child: Consumer(
                builder: (context, ref, child) {
                  final user = ref.watch(currentUserProvider);
                  final profileImageAsync = ref.watch(profileImageProvider);
                  
                  return profileImageAsync.maybeWhen(
                    data: (profileImage) {
                      final profileUrl = profileImage?.profileImageUrl;
                      print('🔍 Dashboard profile check: profileUrl=$profileUrl');

                      return Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.5),
                          border: Border.all(
                            color: const Color(0xFF10B981).withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.5),
                          child: profileUrl != null && profileUrl.isNotEmpty
                              ? Image.network(
                                  profileUrl.startsWith('/') 
                                    ? 'http://211.220.34.173$profileUrl' 
                                    : profileUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print('🚫 Image load error for URL: $profileUrl, error: $error');
                                    return _buildDefaultAvatar(user?.name);
                                  },
                                )
                              : _buildDefaultAvatar(user?.name),
                        ),
                      );
                    },
                    orElse: () => Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.5),
                        border: Border.all(
                          color: const Color(0xFF10B981).withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.5),
                        child: _buildDefaultAvatar(user?.name),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📊 이번 주 PT 현황 차트 (맨 위로 이동)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF10B981), Color(0xFF34D399)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.bar_chart,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '이번 주 PT 현황',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                              ),
                              Text(
                                '일별 수업 스케줄 분석',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 280,
                      child: weeklyStatsAsync.when(
                        data: (weeklyStats) {
                          final maxY = weeklyStats.isEmpty
                              ? 10.0
                              : (weeklyStats.reduce((a, b) => a > b ? a : b) +
                                      2)
                                  .toDouble();

                          return BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: maxY,
                              minY: 0,
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipColor: (group) =>
                                      const Color(0xFF10B981),
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                    const days = [
                                      '월',
                                      '화',
                                      '수',
                                      '목',
                                      '금',
                                      '토',
                                      '일'
                                    ];
                                    return BarTooltipItem(
                                      '${days[groupIndex]}\n${rod.toY.toInt()}건',
                                      const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'IBMPlexSansKR',
                                      ),
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    interval: maxY > 10
                                        ? (maxY / 3).ceilToDouble()
                                        : (maxY > 5 ? 2 : 1),
                                    getTitlesWidget: (value, meta) {
                                      // 0도 포함하여 표시
                                      final intValue = value.toInt();
                                      if (intValue <= maxY.toInt() && value == intValue) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Text(
                                            intValue.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: NotionColors.textSecondary,
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 32,
                                    getTitlesWidget: (value, meta) {
                                      const days = [
                                        '월',
                                        '화',
                                        '수',
                                        '목',
                                        '금',
                                        '토',
                                        '일'
                                      ];
                                      if (value.toInt() >= 0 &&
                                          value.toInt() < days.length) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: Text(
                                            days[value.toInt()],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: maxY > 10
                                    ? (maxY / 3).ceilToDouble()
                                    : (maxY > 5 ? 2 : 1),
                                getDrawingHorizontalLine: (value) {
                                  return const FlLine(
                                    color: NotionColors.border,
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups:
                                  weeklyStats.asMap().entries.map((entry) {
                                return BarChartGroupData(
                                  x: entry.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY: entry.value.toDouble(),
                                      gradient: const LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Color(0xFF10B981),
                                          Color(0xFF34D399)
                                        ],
                                      ),
                                      width: 24,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6),
                                      ),
                                    )
                                  ],
                                );
                              }).toList(),
                            ),
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                          ),
                        ),
                        error: (error, stack) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline,
                                  color: NotionColors.error, size: 32),
                              const SizedBox(height: 8),
                              Text(
                                '차트를 불러올 수 없습니다',
                                style: TextStyle(
                                    color: NotionColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 📅 이번 주 PT 시간표
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF10B981), Color(0xFF34D399)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.calendar_view_week,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '이번 주 PT 시간표',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                              ),
                              Text(
                                '예정된 수업과 변경요청 현황',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 480,
                      child: Consumer(
                        builder: (context, ref, child) {
                          final timetableAsync =
                              ref.watch(weeklyTimetableSchedulesProvider);

                          return timetableAsync.when(
                            data: (schedules) {
                              return EverytimeTimetableWidget(
                                schedules: schedules,
                                selectedWeek: DateTime.now(),
                                onScheduleTap: (schedule) {
                                  // 스케줄 클릭 시 PT 일정 관리 페이지로 이동
                                  context.push('/pt-schedule');
                                },
                                onScheduleAction: (schedule, action) {
                                  // 액션 처리는 여기서 간단하게 처리하거나 PT 일정 페이지로 이동
                                  context.push('/pt-schedule');
                                },
                              );
                            },
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
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.grey[400],
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    '시간표를 불러올 수 없습니다',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                      fontFamily: 'IBMPlexSansKR',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      ref.invalidate(
                                          weeklyTimetableSchedulesProvider);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: const Color(0xFF10B981)
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                      child: const Text(
                                        '다시 시도',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'IBMPlexSansKR',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 📅 오늘의 PT 일정
            const SizedBox(height: 32),
            const TodayPTScheduleCard(),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(String? name) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF34D399)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.5),
      ),
      child: Center(
        child: Text(
          name?.substring(0, 1).toUpperCase() ?? 'T',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
      ),
    );
  }
}
