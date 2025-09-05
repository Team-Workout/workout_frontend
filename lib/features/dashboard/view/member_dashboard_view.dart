import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../body_composition/viewmodel/body_composition_viewmodel.dart';
import '../../pt_schedule/viewmodel/pt_schedule_viewmodel.dart';
import '../../pt_contracts/viewmodel/pt_contract_viewmodel.dart';
import '../../pt_contracts/model/pt_contract_model.dart';
import '../../../core/theme/notion_colors.dart';
import '../../../shared/widgets/notion_dashboard_card.dart';

class MemberDashboardView extends ConsumerWidget {
  const MemberDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: NotionColors.gray50,
      appBar: AppBar(
        backgroundColor: NotionColors.white,
        elevation: 0,
        title: const Text(
          '피트프로',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: NotionColors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
            color: NotionColors.black,
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {},
            color: NotionColors.black,
          ),
        ],
      ),
      body: const _FitProTab(),
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
        selectedItemColor: NotionColors.black,
        unselectedItemColor: NotionColors.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: '운동'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: '일정'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'PT신청'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        ],
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          color: NotionColors.black,
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
                              final date =
                                  DateTime.parse(latest.measurementDate);
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                        );
                      }
                      return Container(
                        height: 120,
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  bodyStats != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStat('체중',
                                '${bodyStats.currentWeight.toStringAsFixed(1)} kg'),
                            _buildStat('체지방률',
                                '${bodyStats.bodyFatPercentage.toStringAsFixed(1)}%'),
                            _buildStat('근육량',
                                '${bodyStats.muscleMass.toStringAsFixed(1)} kg'),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              color: NotionColors.black,
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

        // Reservation Menu Card - 가로로 1:1:1 비율로 배치
        Container(
          height: 120,
          child: Row(
            children: [
              Expanded(
                child: _buildLargeReservationButton(
                  context,
                  Icons.calendar_today,
                  'PT 약속목록',
                  const Color(0xFF3498DB),
                  () => context.push('/reservation-requests'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildLargeReservationButton(
                  context,
                  Icons.history,
                  '예약신청현황',
                  const Color(0xFF8E44AD),
                  () => context.push('/my-appointment-requests'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildLargeReservationButton(
                  context,
                  Icons.settings_outlined,
                  '마이페이지',
                  const Color(0xFF27AE60),
                  () => context.push('/settings'),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // PT Session Card
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              color: NotionColors.black,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '새로운 PT 세션을 예약해보세요!',
                            style:
                                TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                        ],
                      );
                    }

                    final nextSession = schedules.first;
                    final startTime = DateTime.parse(nextSession.startTime);
                    final endTime = DateTime.parse(nextSession.endTime);
                    final timeText =
                        '${DateFormat('a h:mm', 'ko_KR').format(startTime)} - ${DateFormat('h:mm', 'ko_KR').format(endTime)}';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PT 세션',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
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
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.push('/pt-schedule');
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: NotionColors.white,
                                foregroundColor: const Color(0xFF2C3E50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                              child: const Text('상세보기',
                                  style: TextStyle(fontSize: 13)),
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

        const SizedBox(height: 16),

        // PT Contract Summary Card
        _buildPtContractSummaryCard(context),
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
            color: NotionColors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildLargeReservationButton(BuildContext context, IconData icon,
      String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: NotionColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: NotionColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: NotionColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: NotionColors.textPrimary,
              ),
            ),
          ],
        ),
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

    double minWeight =
        recentData.map((e) => e.weightKg).reduce((a, b) => a < b ? a : b);
    double maxWeight =
        recentData.map((e) => e.weightKg).reduce((a, b) => a > b ? a : b);

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
                final date = DateTime.parse(
                    recentData[flSpot.x.toInt()].measurementDate);
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
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxWeight - minWeight) <= 0 ? 1.0 : (maxWeight - minWeight) / 2,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Colors.grey,
              strokeWidth: 0.3,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: (value, meta) {
                // 최소, 중간, 최대 값만 표시
                if (value == minWeight - 2 ||
                    value == maxWeight + 2 ||
                    (value >= (minWeight + maxWeight) / 2 - 1 &&
                        value <= (minWeight + maxWeight) / 2 + 1)) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      '${value.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (recentData.length - 1).toDouble(),
        minY: minWeight - 2,
        maxY: maxWeight + 2,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: NotionColors.black,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 2,
                  color: Colors.white,
                  strokeWidth: 1,
                  strokeColor: NotionColors.black,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: NotionColors.black.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPtContractSummaryCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/pt-contracts'),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey[50]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF27AE60).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.description_outlined,
                          color: const Color(0xFF27AE60),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '현재 PT 계약',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: NotionColors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '자세히 보기',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 실제 PT 계약 정보
              _buildContractInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContractInfo(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final contractAsync = ref.watch(latestActiveContractProvider);

        return contractAsync.when(
          loading: () => Container(
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF27AE60),
              ),
            ),
          ),
          error: (error, stack) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red[600],
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  '계약 정보를 불러올 수 없습니다',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          data: (contract) {
            if (contract == null) {
              return _buildNoContractState();
            }
            return _buildActiveContractState(contract);
          },
        );
      },
    );
  }

  Widget _buildNoContractState() {
    return Container(
      width: double.infinity, // 전체 너비 사용
      padding: const EdgeInsets.all(24), // 패딩 증가
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12), // 더 둥글게
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.grey[600],
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            '진행 중인 PT 계약이 없습니다',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '새로운 PT를 시작해보세요!',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveContractState(PtContract contract) {
    final paymentDate = DateTime.parse(contract.paymentDate);
    final formattedDate = DateFormat('MM월 dd일').format(paymentDate);

    return Container(
      width: double.infinity, // 전체 너비 사용
      padding: const EdgeInsets.all(20), // 패딩 약간 증가
      decoration: BoxDecoration(
        color: const Color(0xFF27AE60).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12), // 더 둥글게
        border: Border.all(color: const Color(0xFF27AE60).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // 전체 너비 사용
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contract.trainerName,
                      style: const TextStyle(
                        fontSize: 16, // 폰트 크기 증가
                        fontWeight: FontWeight.w700,
                        color: NotionColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${contract.totalSessions}회권 (${contract.remainingSessions}회 남음)',
                      style: TextStyle(
                        fontSize: 14, // 폰트 크기 증가
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF27AE60),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  contract.statusDisplayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20), // 간격 증가
          // 하단 정보
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildContractStat('계약일', formattedDate),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: _buildContractStat('계약금액', contract.formattedPrice),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContractStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: NotionColors.black,
          ),
        ),
      ],
    );
  }
}
