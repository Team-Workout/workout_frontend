import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../body_composition/viewmodel/body_composition_viewmodel.dart';
import '../../pt_schedule/viewmodel/pt_schedule_viewmodel.dart';

class MemberDashboardView extends ConsumerWidget {
  const MemberDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            '피트프로',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
              color: const Color(0xFF2C3E50),
            ),
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline),
              onPressed: () {},
              color: const Color(0xFF2C3E50),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  context.push('/settings');
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            labelColor: Color(0xFF2C3E50),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF2C3E50),
            tabs: [
              Tab(text: '피트프로'),
              Tab(text: '피트트랙'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _FitProTab(),
            _FitTrackTab(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              context.push('/workout-record');
            } else if (index == 2) {
              context.push('/pt-schedule');
            } else if (index == 3) {
              context.push('/pt-applications');
            } else if (index == 4) {
              context.push('/settings');
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF2C3E50),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: '운동'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: '일정'),
            BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'PT신청'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
          ],
        ),
      ),
    );
  }
}

class _FitProTab extends ConsumerStatefulWidget {
  const _FitProTab();

  @override
  ConsumerState<_FitProTab> createState() => _FitProTabState();
}

class _FitProTabState extends ConsumerState<_FitProTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ptScheduleViewModelProvider.notifier).loadTodaySchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bodyStats = ref.watch(bodyStatsProvider);
    final bodyCompositions = ref.watch(bodyCompositionListProvider);
    final todayScheduleAsync = ref.watch(ptScheduleViewModelProvider);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Body Composition Card
        GestureDetector(
          onTap: () => context.push('/body-composition'),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '체성분',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      Row(
                        children: [
                          bodyCompositions.when(
                            data: (compositions) {
                              if (compositions.isEmpty) {
                                return Text(
                                  '데이터 없음',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                );
                              }
                              final latest = compositions.first;
                              final date = DateTime.parse(latest.measurementDate);
                              return Text(
                                '최근 업데이트: ${DateFormat('MM월 dd일').format(date)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                            loading: () => Text(
                              '로딩 중...',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            error: (_, __) => Text(
                              '업데이트 불가',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  bodyCompositions.when(
                    data: (compositions) {
                      if (compositions.isEmpty) {
                        return Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              '체중 데이터가 없습니다',
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                        );
                      }
                      return Container(
                        height: 120,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _buildMiniWeightChart(compositions),
                      );
                    },
                    loading: () => Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, _) => Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '차트 로드 실패',
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  bodyStats != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStat('체중', '${bodyStats.currentWeight.toStringAsFixed(1)} kg'),
                            _buildStat('체지방률', '${bodyStats.bodyFatPercentage.toStringAsFixed(1)}%'),
                            _buildStat('근육량', '${bodyStats.muscleMass.toStringAsFixed(1)} kg'),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStat('체중', '- kg'),
                            _buildStat('체지방률', '-%'),
                            _buildStat('근육량', '- kg'),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // PT Booking Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3498DB), Color(0xFF5DADE2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.fitness_center,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PT 예약하기',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '전문 트레이너와 함께 운동하세요',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    // 헬스장 ID를 1로 가정 (나중에 사용자의 헬스장 ID로 변경 가능)
                    context.push('/gym-trainers/1');
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '트레이너 보기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3498DB),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Reservation Menu Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '예약 관리',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildReservationAction(
                      Icons.event_note,
                      'PT 약속 요청',
                      Colors.blue,
                      () => context.push('/reservation-requests'),
                    ),
                    _buildReservationAction(
                      Icons.fitness_center,
                      'PT 계약 목록',
                      Colors.green,
                      () => context.push('/pt-contracts'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildReservationAction(
                      Icons.history,
                      '나의 신청 내역',
                      Colors.purple,
                      () => context.push('/my-appointment-requests'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // PT Session Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '예정된 PT 세션',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '오늘',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                todayScheduleAsync.when(
                  data: (schedules) {
                    if (schedules.isEmpty) {
                      return const Column(
                        children: [
                          Text(
                            '오늘 예정된 PT가 없습니다',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '새로운 PT 세션을 예약해보세요!',
                            style: TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                        ],
                      );
                    }
                    
                    final nextSession = schedules.first;
                    final startTime = DateTime.parse(nextSession.startTime);
                    final endTime = DateTime.parse(nextSession.endTime);
                    final timeText = '${DateFormat('a h:mm', 'ko').format(startTime)} - ${DateFormat('h:mm').format(endTime)}';
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PT 세션',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white24,
                              child: Icon(Icons.person, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nextSession.trainerName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    timeText,
                                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.push('/pt-schedule');
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF2C3E50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: const Text('상세보기', style: TextStyle(fontSize: 13)),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  error: (error, stack) => const Column(
                    children: [
                      Text(
                        '일정을 불러올 수 없습니다',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '잠시 후 다시 시도해주세요',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }

  Widget _buildReservationAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniWeightChart(compositions) {
    if (compositions.isEmpty) {
      return const Center(
        child: Text('데이터가 없습니다', style: TextStyle(color: Colors.grey)),
      );
    }
    
    // Sort and take recent data points (max 7 for mini chart)
    final sortedData = List.from(compositions)
      ..sort((a, b) => a.measurementDate.compareTo(b.measurementDate));
    final recentData = sortedData.length > 7 
        ? sortedData.sublist(sortedData.length - 7)
        : sortedData;

    final spots = recentData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.weightKg);
    }).toList();

    double minWeight = recentData.map((e) => e.weightKg).reduce((a, b) => a < b ? a : b);
    double maxWeight = recentData.map((e) => e.weightKg).reduce((a, b) => a > b ? a : b);
    
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => const Color(0xFF1A1F36),
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                final date = DateTime.parse(recentData[flSpot.x.toInt()].measurementDate);
                return LineTooltipItem(
                  '${DateFormat('MM/dd').format(date)}\n${flSpot.y.toStringAsFixed(1)}kg',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                );
              }).toList();
            },
          ),
        ),
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (recentData.length - 1).toDouble(),
        minY: minWeight - 2,
        maxY: maxWeight + 2,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFF6366F1),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 2,
                  color: Colors.white,
                  strokeWidth: 1,
                  strokeColor: const Color(0xFF6366F1),
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF6366F1).withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}

class _FitTrackTab extends StatelessWidget {
  const _FitTrackTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Exercise Summary Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '운동 요약',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('2025년 7월', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Time frame buttons
                SizedBox(
                  height: 35,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildTimeButton('하루', true),
                      _buildTimeButton('주간', false),
                      _buildTimeButton('월간', false),
                      _buildTimeButton('연간', false),
                      _buildTimeButton('전체', false),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '오늘, 8월 3일',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    Text(
                      '목표대비 87%',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.87,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2C3E50)),
                  minHeight: 6,
                ),
                
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStat('운동시간', '52분'),
                    _buildStat('운동횟수', '8개'),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Today's Exercises
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '오늘의 운동',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list, size: 20),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '벤치프레스',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      Text(
                        '오전 8:30',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () => context.push('/workout-record'),
                    child: const Text('모든 운동 보기'),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Quick Actions
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '빠른 바로가기',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickAction(
                      Icons.calendar_month,
                      'PT\n예약',
                      () => context.push('/pt-schedule'),
                    ),
                    _buildQuickAction(
                      Icons.fitness_center,
                      '운동\n시작',
                      () => context.push('/workout-record'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickAction(Icons.bar_chart, '체성분\n기록', () {}),
                    _buildQuickAction(Icons.group, '커뮤니티', () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeButton(String text, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFF2C3E50) : Colors.grey[200],
          foregroundColor: isSelected ? Colors.white : Colors.grey[700],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          minimumSize: const Size(60, 35),
        ),
        child: Text(text, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 24, color: const Color(0xFF2C3E50)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Color(0xFF2C3E50)),
          ),
        ],
      ),
    );
  }
}