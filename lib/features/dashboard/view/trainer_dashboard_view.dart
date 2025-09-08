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
      backgroundColor: Colors.grey[50],
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          '트레이너 대시보드',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('알림 기능은 준비 중입니다')),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onPressed: () {
                context.push('/settings');
              },
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context, ref),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎉 Welcome Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF10B981), Color(0xFF34D399)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.waving_hand,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '안녕하세요!',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                            Text(
                              '${user?.name ?? '트레이너'}님',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '오늘도 회원들과 함께 건강한 하루를 만들어가세요! 💪',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '오늘 일정: $todayPtCount건',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF10B981), Color(0xFF34D399)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '이번 달: ${monthlyPtCount}건',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
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
                                  getTooltipColor: (group) => const Color(0xFF10B981),
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    const days = ['월', '화', '수', '목', '금', '토', '일'];
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
                                      gradient: const LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [Color(0xFF10B981), Color(0xFF34D399)],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
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
                            Icons.schedule,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '오늘의 PT 일정',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                              ),
                              Text(
                                '예정된 PT 수업 $todayPtCount건',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontFamily: 'IBMPlexSansKR',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextButton(
                            onPressed: () {
                              context.push('/pt-schedule');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF10B981),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            child: const Text(
                              '전체보기',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          ),
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
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF34D399)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.dashboard_customize,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '관리 메뉴',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // 탭 바
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
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey[600],
                      indicator: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF34D399)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.calendar_today, size: 18),
                          text: '일정 관리',
                        ),
                        Tab(
                          icon: Icon(Icons.people, size: 18),
                          text: '회원 관리',
                        ),
                        Tab(
                          icon: Icon(Icons.fitness_center, size: 18),
                          text: 'PT 운영',
                        ),
                      ],
                    ),
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF10B981), Color(0xFF34D399), Color(0xFF6EE7B7)],
              ),
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
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                Text(
                  ref.watch(currentUserProvider)?.email ?? '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontFamily: 'IBMPlexSansKR',
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