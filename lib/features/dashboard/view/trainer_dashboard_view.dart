import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pt_service/core/providers/auth_provider.dart';
import 'package:pt_service/shared/widgets/notion_dashboard_card.dart';
import '../../../shared/widgets/dashboard_card.dart';
import 'package:pt_service/features/trainer_profile/view/trainer_profile_edit_view.dart';
import 'package:pt_service/features/pt_offerings/viewmodel/pt_offering_viewmodel.dart';
import 'package:pt_service/features/pt_applications/viewmodel/pt_application_viewmodel.dart';
import 'package:pt_service/features/pt_schedule/viewmodel/pt_schedule_viewmodel.dart';
import 'package:pt_service/features/pt_schedule/repository/pt_schedule_repository.dart';
import '../../../features/trainer_clients/view/trainer_clients_list_view.dart';
import '../../../core/theme/notion_colors.dart';
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

class _TrainerDashboardViewState extends ConsumerState<TrainerDashboardView> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider);
      if (user?.id != null) {
        final trainerId = int.parse(user!.id);
        ref.read(ptOfferingProvider.notifier).loadPtOfferings(trainerId);
        ref.read(ptApplicationProvider.notifier).loadPtApplications();
        ref.read(todayScheduleViewModelProvider.notifier).loadTodaySchedule();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final ptOfferingsAsync = ref.watch(ptOfferingProvider);
    final ptApplicationsAsync = ref.watch(ptApplicationProvider);
    final todayScheduleAsync = ref.watch(todayScheduleViewModelProvider);
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
      backgroundColor: NotionColors.gray50,
      appBar: AppBar(
        backgroundColor: NotionColors.white,
        title: const Text('트레이너 대시보드'),
        actions: [
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
              '이번 주 PT 일정을 한눈에 확인해보세요',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: NotionColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            
            // 📊 이번 주 PT 현황 차트 (맨 위로 이동)
            Container(
              decoration: BoxDecoration(
                color: NotionColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: NotionColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '이번 주 PT 현황',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '일별 수업 스케줄',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: NotionColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: NotionColors.gray100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '이번 달: ${monthlyPtCount}건',
                            style: const TextStyle(
                              color: NotionColors.textSecondary,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 240,
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
                                  getTooltipColor: (group) => NotionColors.black,
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    const days = ['월', '화', '수', '목', '금', '토', '일'];
                                    return BarTooltipItem(
                                      '${days[groupIndex]}\n${rod.toY.toInt()}건',
                                      const TextStyle(color: NotionColors.white),
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
                                    interval: maxY > 10 ? (maxY / 3).ceilToDouble() : (maxY > 5 ? 2 : 1),
                                    getTitlesWidget: (value, meta) {
                                      if (value == 0) return const SizedBox();
                                      // 실제 데이터 값만 표시
                                      final intValue = value.toInt();
                                      if (intValue <= maxY.toInt()) {
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 8),
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
                                      const days = ['월', '화', '수', '목', '금', '토', '일'];
                                      if (value.toInt() >= 0 && value.toInt() < days.length) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
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
                                horizontalInterval: maxY > 10 ? (maxY / 3).ceilToDouble() : (maxY > 5 ? 2 : 1),
                                getDrawingHorizontalLine: (value) {
                                  return const FlLine(
                                    color: NotionColors.border,
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: weeklyStats.asMap().entries.map((entry) {
                                return BarChartGroupData(
                                  x: entry.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY: entry.value.toDouble(),
                                      color: NotionColors.black,
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
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, color: NotionColors.error, size: 32),
                              const SizedBox(height: 8),
                              Text(
                                '차트를 불러올 수 없습니다',
                                style: TextStyle(color: NotionColors.textSecondary),
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
            
            // 📅 오늘의 PT 일정
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: NotionColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: NotionColors.border),
              ),
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
                          style: TextButton.styleFrom(
                            foregroundColor: NotionColors.textSecondary,
                          ),
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
                                color: NotionColors.textTertiary,
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
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: NotionColors.gray100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  timeText.substring(0, 2),
                                  style: const TextStyle(
                                    color: NotionColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(schedule.memberName),
                            subtitle: Text('$timeText - $durationText'),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.message_outlined,
                                color: NotionColors.textSecondary,
                              ),
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
                            color: NotionColors.error,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // 📋 카테고리별 관리 메뉴
            const SizedBox(height: 24),
            Text(
              '관리 메뉴',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // 탭 바
            Container(
              decoration: BoxDecoration(
                color: NotionColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: NotionColors.border),
              ),
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    labelColor: NotionColors.black,
                    unselectedLabelColor: NotionColors.textSecondary,
                    indicatorColor: NotionColors.black,
                    indicatorWeight: 2,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.calendar_today, size: 20),
                        text: '일정 관리',
                      ),
                      Tab(
                        icon: Icon(Icons.people, size: 20),
                        text: '회원 관리',
                      ),
                      Tab(
                        icon: Icon(Icons.fitness_center, size: 20),
                        text: 'PT 운영',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildScheduleManagementTab(),
                        _buildMemberManagementTab(),
                        _buildPtOperationTab(),
                      ],
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

  // 📅 일정 관리 탭
  Widget _buildScheduleManagementTab() {
    final todayPtCount = ref.watch(todayScheduleViewModelProvider).whenOrNull(
      data: (schedules) => schedules.length,
    ) ?? 0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.0,
        children: [
          NotionDashboardCard(
            title: '오늘의 PT',
            value: todayPtCount > 0 ? '$todayPtCount건' : '일정 없음',
            icon: Icons.calendar_today,
            isHighlighted: todayPtCount > 0,
            onTap: () {
              context.push('/pt-schedule');
            },
          ),
          NotionDashboardCard(
            title: 'PT 약속 생성',
            value: '새 약속 생성',
            icon: Icons.add_circle,
            onTap: () {
              context.push('/reservation-recommendations');
            },
          ),
          NotionDashboardCard(
            title: 'PT 약속 관리',
            value: '예약된 일정',
            icon: Icons.schedule,
            onTap: () {
              context.push('/pt-schedule');
            },
          ),
          NotionDashboardCard(
            title: '약속 승인',
            value: '회원 요청 승인',
            icon: Icons.check_circle,
            onTap: () {
              context.push('/appointment-confirmation');
            },
          ),
        ],
      ),
    );
  }

  // 👥 회원 관리 탭
  Widget _buildMemberManagementTab() {
    final pendingApplicationsCount = ref.watch(ptApplicationProvider).whenOrNull(
      data: (applications) => applications.length,
    ) ?? 0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.0,
        children: [
          NotionDashboardCard(
            title: '내 회원 관리',
            value: '회원 현황 확인',
            icon: Icons.people,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TrainerClientsListView(),
                ),
              );
            },
          ),
          NotionDashboardCard(
            title: 'PT 신청',
            value: pendingApplicationsCount > 0 
                ? '$pendingApplicationsCount건 대기' 
                : '대기 없음',
            icon: Icons.assignment,
            isHighlighted: pendingApplicationsCount > 0,
            onTap: () {
              context.push('/pt-applications');
            },
          ),
        ],
      ),
    );
  }

  // 📊 PT 운영 탭  
  Widget _buildPtOperationTab() {
    final monthlyPtCount = ref.watch(monthlyPtCountProvider).whenOrNull(
      data: (count) => count,
    ) ?? 0;
    
    final ptOfferingsCount = ref.watch(ptOfferingProvider).whenOrNull(
      data: (offerings) => offerings.length,
    ) ?? 0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.0,
        children: [
          NotionDashboardCard(
            title: 'PT 상품 관리',
            value: ptOfferingsCount > 0 
                ? '$ptOfferingsCount개 상품' 
                : '상품 없음',
            icon: Icons.shopping_bag,
            isHighlighted: ptOfferingsCount > 0,
            onTap: () {
              context.push('/pt-offerings');
            },
          ),
          NotionDashboardCard(
            title: 'PT 계약',
            value: '계약 관리',
            icon: Icons.assignment_turned_in,
            onTap: () {
              context.push('/pt-contracts');
            },
          ),
          NotionDashboardCard(
            title: '이번 달 수업',
            value: monthlyPtCount > 0 ? '${monthlyPtCount}건' : '수업 없음',
            icon: Icons.fitness_center,
            isHighlighted: monthlyPtCount > 0,
            onTap: () {
              context.push('/my-appointment-requests');
            },
          ),
          NotionDashboardCard(
            title: 'PT 신청 내역',
            value: '전체 신청 관리',
            icon: Icons.history,
            onTap: () {
              context.push('/my-appointment-requests');
            },
          ),
        ],
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