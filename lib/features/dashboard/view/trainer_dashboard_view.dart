import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pt_service/core/providers/auth_provider.dart';
import 'package:pt_service/shared/widgets/dashboard_card.dart';
import 'package:pt_service/features/trainer_profile/view/trainer_profile_edit_view.dart';
import 'package:pt_service/features/pt_offerings/viewmodel/pt_offering_viewmodel.dart';
import 'package:pt_service/features/pt_applications/viewmodel/pt_application_viewmodel.dart';
import 'package:pt_service/features/pt_schedule/viewmodel/pt_schedule_viewmodel.dart';
import 'package:pt_service/features/pt_schedule/repository/pt_schedule_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trainer_dashboard_view.g.dart';

// 이번 달 PT 개수 조회
@riverpod
Future<int> monthlyPtCount(MonthlyPtCountRef ref) async {
  final repository = ref.read(ptScheduleRepositoryProvider);
  final now = DateTime.now();
  
  print('📊 이번 달 PT 개수 조회 시작: ${now.year}-${now.month}');
  
  try {
    final schedules = await repository.getMonthlySchedule(
      month: now,
      status: 'SCHEDULED',
    );
    
    print('📊 이번 달 PT 개수: ${schedules.length}건');
    return schedules.length;
  } catch (e) {
    print('❌ 이번 달 PT 개수 조회 오류: $e');
    return 0;
  }
}

// 이번 주 일별 PT 통계 조회
@riverpod
Future<List<int>> weeklyPtStats(WeeklyPtStatsRef ref) async {
  final repository = ref.read(ptScheduleRepositoryProvider);
  final now = DateTime.now();
  
  // 이번 주의 월요일을 구함
  final mondayOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final weeklyStats = <int>[];
  
  print('📊 주간 PT 통계 조회 시작');
  
  try {
    for (int i = 0; i < 7; i++) {
      final targetDate = mondayOfWeek.add(Duration(days: i));
      final dayStart = DateTime(targetDate.year, targetDate.month, targetDate.day);
      
      final daySchedules = await repository.getScheduledAppointments(
        startDate: _formatDate(dayStart),
        endDate: _formatDate(dayStart),
        status: 'SCHEDULED',
      );
      
      weeklyStats.add(daySchedules.length);
      print('📊 ${_getWeekdayName(i)}: ${daySchedules.length}건');
    }
    
    return weeklyStats;
  } catch (e) {
    print('❌ 주간 PT 통계 조회 오류: $e');
    return [0, 0, 0, 0, 0, 0, 0];
  }
}

String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String _getWeekdayName(int index) {
  const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  return weekdays[index];
}

class TrainerDashboardView extends ConsumerStatefulWidget {
  const TrainerDashboardView({super.key});

  @override
  ConsumerState<TrainerDashboardView> createState() => _TrainerDashboardViewState();
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
        ref.read(ptScheduleViewModelProvider.notifier).loadTodaySchedule();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final ptOfferingsAsync = ref.watch(ptOfferingProvider);
    final ptApplicationsAsync = ref.watch(ptApplicationProvider);
    final todayScheduleAsync = ref.watch(ptScheduleViewModelProvider);
    final monthlyPtCountAsync = ref.watch(monthlyPtCountProvider);
    final weeklyStatsAsync = ref.watch(weeklyPtStatsProvider);
    
    // PT 상품 개수 계산
    final ptOfferingsCount = ptOfferingsAsync.whenOrNull(
      data: (offerings) => offerings.length,
    ) ?? 0;
    
    // PT 신청 대기 건수 계산
    final pendingApplicationsCount = ptApplicationsAsync.whenOrNull(
      data: (applications) => applications.length,
    ) ?? 0;
    
    // 오늘의 PT 일정 개수 계산
    final todayPtCount = todayScheduleAsync.whenOrNull(
      data: (schedules) => schedules.length,
    ) ?? 0;
    
    // 이번 달 PT 개수 계산
    final monthlyPtCount = monthlyPtCountAsync.whenOrNull(
      data: (count) => count,
    ) ?? 0;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('트레이너 대시보드'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TrainerProfileEditView(),
                ),
              );
            },
            tooltip: '프로필 수정',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context, ref),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '안녕하세요, ${user?.name ?? '트레이너'}님!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '오늘의 PT 일정과 회원 관리 현황입니다',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.95,
              children: [
                DashboardCard(
                  title: '오늘의 PT',
                  value: todayPtCount > 0 ? '$todayPtCount건' : '일정 없음',
                  icon: Icons.calendar_today,
                  color: Colors.blue,
                  onTap: () {
                    context.push('/pt-schedule');
                  },
                ),
                DashboardCard(
                  title: 'PT 신청',
                  value: pendingApplicationsCount > 0 
                      ? '$pendingApplicationsCount건 대기' 
                      : '대기 없음',
                  icon: Icons.assignment,
                  color: Colors.green,
                  onTap: () {
                    context.push('/pt-applications');
                  },
                ),
                DashboardCard(
                  title: '이번 달 수업',
                  value: monthlyPtCount > 0 ? '${monthlyPtCount}건' : '수업 없음',
                  icon: Icons.fitness_center,
                  color: Colors.orange,
                  onTap: () {
                    context.push('/my-appointment-requests');
                  },
                ),
                DashboardCard(
                  title: 'PT 상품 관리',
                  value: ptOfferingsCount > 0 
                      ? '$ptOfferingsCount개 상품' 
                      : '상품 없음',
                  icon: Icons.shopping_bag,
                  color: Colors.purple,
                  onTap: () {
                    context.push('/pt-offerings');
                  },
                ),
                DashboardCard(
                  title: 'PT 약속 생성',
                  value: '회원 약속 생성',
                  icon: Icons.add_circle,
                  color: Colors.orange,
                  onTap: () {
                    context.push('/reservation-recommendations');
                  },
                ),
                DashboardCard(
                  title: 'PT 약속 관리',
                  value: '예약된 일정',
                  icon: Icons.schedule,
                  color: Colors.purple,
                  onTap: () {
                    context.push('/pt-schedule');
                  },
                ),
                DashboardCard(
                  title: 'PT 계약',
                  value: '계약 관리',
                  icon: Icons.assignment_turned_in,
                  color: Colors.teal,
                  onTap: () {
                    context.push('/pt-contracts');
                  },
                ),
                DashboardCard(
                  title: '약속 승인',
                  value: '회원 요청 승인',
                  icon: Icons.check_circle,
                  color: Colors.green,
                  onTap: () {
                    context.push('/appointment-confirmation');
                  },
                ),
                DashboardCard(
                  title: 'PT 신청 내역',
                  value: '전체 신청 관리',
                  icon: Icons.history,
                  color: Colors.deepPurple,
                  onTap: () {
                    context.push('/my-appointment-requests');
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '이번 주 PT 현황',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: weeklyStatsAsync.when(
                        data: (weeklyStats) {
                          final maxY = weeklyStats.isEmpty ? 10.0 : (weeklyStats.reduce((a, b) => a > b ? a : b) + 2).toDouble();
                          
                          return BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: maxY,
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipColor: (group) => Colors.blueGrey,
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    const days = ['월', '화', '수', '목', '금', '토', '일'];
                                    return BarTooltipItem(
                                      '${days[groupIndex]}\n${rod.toY.toInt()}건',
                                      const TextStyle(color: Colors.white),
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      const days = ['월', '화', '수', '목', '금', '토', '일'];
                                      if (value.toInt() >= 0 && value.toInt() < days.length) {
                                        return Text(
                                          days[value.toInt()],
                                          style: const TextStyle(fontSize: 14),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: maxY > 10 ? (maxY / 5).ceilToDouble() : 2,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: const TextStyle(fontSize: 12),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              barGroups: weeklyStats.asMap().entries.map((entry) {
                                return BarChartGroupData(
                                  x: entry.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY: entry.value.toDouble(),
                                      color: Colors.blue,
                                      width: 20,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                    )
                                  ],
                                );
                              }).toList(),
                            ),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red),
                              const SizedBox(height: 8),
                              Text(
                                '차트를 불러올 수 없습니다',
                                style: TextStyle(color: Colors.grey[600]),
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
            const SizedBox(height: 24),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '오늘의 PT 일정',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            context.push('/pt-schedule');
                          },
                          child: const Text('전체보기'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  todayScheduleAsync.when(
                    data: (schedules) {
                      if (schedules.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              '오늘 예정된 PT가 없습니다',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }
                      
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: schedules.length > 3 ? 3 : schedules.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final schedule = schedules[index];
                          final startTime = DateTime.parse(schedule.startTime);
                          final endTime = DateTime.parse(schedule.endTime);
                          final timeText = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
                          final durationText = '${endTime.difference(startTime).inMinutes}분';
                          
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                timeText.substring(0, 2),
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(schedule.memberName),
                            subtitle: Text('$timeText - $durationText'),
                            trailing: IconButton(
                              icon: const Icon(Icons.message_outlined),
                              onPressed: () {},
                            ),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('PT 상세 페이지는 준비 중입니다')),
                              );
                            },
                          );
                        },
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stack) => Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          '일정을 불러올 수 없습니다',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDrawer(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 30),
                ),
                const SizedBox(height: 12),
                Text(
                  ref.watch(currentUserProvider)?.name ?? '트레이너',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ref.watch(currentUserProvider)?.email ?? '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('대시보드'),
            selected: true,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text('PT 신청 관리'),
            onTap: () {
              Navigator.pop(context);
              context.push('/pt-applications');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('PT 일정'),
            onTap: () {
              Navigator.pop(context);
              context.push('/pt-schedule');
            },
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('운동 루틴 관리'),
            onTap: () {
              Navigator.pop(context);
              context.push('/workout-routines');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('PT 상품 관리'),
            onTap: () {
              Navigator.pop(context);
              context.push('/pt-offerings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('분석 리포트'),
            onTap: () {
              Navigator.pop(context);
              context.push('/analysis-report');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('설정'),
            onTap: () {
              Navigator.pop(context);
              context.push('/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('로그아웃'),
            onTap: () {
              ref.read(authStateProvider).logout();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}