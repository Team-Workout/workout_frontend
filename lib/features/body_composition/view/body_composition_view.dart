import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/body_composition_model.dart';
import '../viewmodel/body_composition_viewmodel.dart';

class BodyCompositionView extends ConsumerStatefulWidget {
  const BodyCompositionView({super.key});

  @override
  ConsumerState<BodyCompositionView> createState() =>
      _BodyCompositionViewState();
}

class _BodyCompositionViewState extends ConsumerState<BodyCompositionView> {
  String selectedPeriod = '1M';
  DateTime? customStartDate;
  DateTime? customEndDate;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final dateRange = ref.read(dateRangeProvider);
      ref.read(bodyCompositionNotifierProvider.notifier).loadBodyCompositions(
            startDate: dateRange.startDate.toIso8601String().split('T')[0],
            endDate: dateRange.endDate.toIso8601String().split('T')[0],
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bodyStats = ref.watch(bodyStatsProvider);
    final bodyCompositions = ref.watch(bodyCompositionListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        title: const Text(
          '체성분 분석',
          style: TextStyle(
            color: const Color(0xFF1A1F36),
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.calendar_today,
                  color: Color(0xFF6366F1), size: 20),
            ),
            onPressed: () => _showDateRangePickerDialog(),
          ),
        ],
      ),
      body: bodyCompositions.when(
        data: (compositions) {
          if (compositions.isEmpty) {
            return const Center(
              child: Text('체성분 데이터가 없습니다'),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateRangeDisplay(),
                  const SizedBox(height: 16),
                  _buildProfileSection(compositions),
                  const SizedBox(height: 20),
                  _buildStatsCards(bodyStats),
                  const SizedBox(height: 20),
                  _buildGoalProgress(bodyStats),
                  const SizedBox(height: 24),
                  _buildWeightTrendSection(compositions),
                  const SizedBox(height: 24),
                  _buildBodyCompositionChart(compositions),
                  const SizedBox(height: 24),
                  _buildKeyMeasurements(),
                  const SizedBox(height: 24),
                  _buildTrainerFeedback(),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _showAddDataDialog(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add_circle_outline, size: 24),
          label: const Text(
            '데이터 추가',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(List<BodyComposition> compositions) {
    if (compositions.isEmpty) return const SizedBox.shrink();

    final latestData = compositions.first;
    final dateFormat = DateFormat('MMM d, yyyy');

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: Icon(Icons.person, size: 35, color: Colors.grey[600]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '회원 프로필',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '최근 업데이트: ${dateFormat.format(DateTime.parse(latestData.measurementDate))}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(BodyStats? stats) {
    if (stats == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '체중',
            '${stats.currentWeight.toStringAsFixed(1)} kg',
            stats.weightChange > 0
                ? '+${stats.weightChange.toStringAsFixed(1)} kg'
                : '${stats.weightChange.toStringAsFixed(1)} kg',
            stats.weightChange < 0 ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '체지방',
            '${stats.bodyFatPercentage.toStringAsFixed(1)}%',
            stats.fatChange > 0
                ? '+${stats.fatChange.toStringAsFixed(1)}%'
                : '${stats.fatChange.toStringAsFixed(1)}%',
            stats.fatChange < 0 ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'BMI',
            stats.bmi.toStringAsFixed(1),
            stats.bmiChange > 0
                ? '+${stats.bmiChange.toStringAsFixed(1)}'
                : '${stats.bmiChange.toStringAsFixed(1)}',
            stats.bmiChange < 0 ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, String change, Color changeColor) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1F36),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                change.startsWith('+')
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                size: 16,
                color: changeColor,
              ),
              Text(
                change,
                style: TextStyle(
                  fontSize: 12,
                  color: changeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalProgress(BodyStats? stats) {
    // Remove this section as it uses hardcoded goal data
    return const SizedBox.shrink();
  }

  Widget _buildWeightTrendSection(List<BodyComposition> compositions) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '체중 변화 추이',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: _buildWeightChart(compositions),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeriod = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C3E50) : Colors.grey[200],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildWeightChart(List<BodyComposition> compositions) {
    if (compositions.isEmpty) {
      return const Center(
        child: Text('이 기간에 데이터가 없습니다'),
      );
    }

    final sortedData = List<BodyComposition>.from(compositions)
      ..sort((a, b) => a.measurementDate.compareTo(b.measurementDate));

    final spots = sortedData.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.weightKg,
      );
    }).toList();

    // Calculate dynamic min/max values based on actual data
    double minWeight =
        sortedData.map((e) => e.weightKg).reduce((a, b) => a < b ? a : b);
    double maxWeight =
        sortedData.map((e) => e.weightKg).reduce((a, b) => a > b ? a : b);
    
    // Set Y-axis range for better visibility
    double minY = 0; // Always start from 0kg
    double maxY = (maxWeight * 1.1).ceilToDouble(); // 10% padding on top, rounded up

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
                final date = DateTime.parse(sortedData[flSpot.x.toInt()].measurementDate);
                return LineTooltipItem(
                  '${DateFormat('MM/dd').format(date)}\n${flSpot.y.toStringAsFixed(1)}kg',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval:
              (maxY - minY) / 5 > 0 ? (maxY - minY) / 5 : 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[300]!,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < sortedData.length) {
                  final date =
                      DateTime.parse(sortedData[value.toInt()].measurementDate);
                  return Text(
                    DateFormat('MM/dd').format(date),
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
              interval: sortedData.length > 7
                  ? (sortedData.length / 7).ceil().toDouble()
                  : 1,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toStringAsFixed(1)}kg',
                  style: const TextStyle(fontSize: 10),
                );
              },
              interval: (maxY - minY) / 5 > 0
                  ? (maxY - minY) / 5
                  : 1,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (sortedData.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFF6366F1),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
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

  Widget _buildBodyCompositionChart(List<BodyComposition> compositions) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '체성분 구성',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180, // Increased height for better display
            child: _buildCompositionBars(compositions),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('근육', const Color(0xFF6366F1)),
              const SizedBox(width: 24),
              _buildLegendItem('지방', Colors.grey[400]!),
              const SizedBox(width: 24),
              _buildLegendItem('기타', Colors.grey[600]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompositionBars(List<BodyComposition> compositions) {
    if (compositions.isEmpty) {
      return const Center(
        child: Text('데이터가 없습니다'),
      );
    }

    // Sort by date
    final sortedCompositions = List<BodyComposition>.from(compositions)
      ..sort((a, b) => a.measurementDate.compareTo(b.measurementDate));

    // If more than 8 items, make it scrollable
    if (sortedCompositions.length > 8) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
              sortedCompositions.map((comp) => _buildSingleBar(comp)).toList(),
        ),
      );
    }

    // If 8 or fewer items, show all with Expanded
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: sortedCompositions.map((comp) {
        return Expanded(
          child: _buildSingleBar(comp),
        );
      }).toList(),
    );
  }

  Widget _buildSingleBar(BodyComposition comp) {
    final total = comp.weightKg;
    final musclePercent = total > 0 ? (comp.muscleMassKg / total) * 100 : 0;
    final fatPercent = total > 0 ? (comp.fatKg / total) * 100 : 0;
    final otherPercent = 100 - musclePercent - fatPercent;

    return Container(
      width: 60, // Fixed width for each bar
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[200],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (otherPercent > 0)
                    Flexible(
                      flex: otherPercent.round(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  if (fatPercent > 0)
                    Flexible(
                      flex: fatPercent.round(),
                      child: Container(
                        color: Colors.grey[400],
                      ),
                    ),
                  if (musclePercent > 0)
                    Flexible(
                      flex: musclePercent.round(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1),
                          borderRadius: BorderRadius.only(
                            bottomLeft: const Radius.circular(4),
                            bottomRight: const Radius.circular(4),
                            topLeft: otherPercent == 0 && fatPercent == 0
                                ? const Radius.circular(4)
                                : Radius.zero,
                            topRight: otherPercent == 0 && fatPercent == 0
                                ? const Radius.circular(4)
                                : Radius.zero,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 30,
            child: Column(
              children: [
                Text(
                  DateFormat('MM/dd')
                      .format(DateTime.parse(comp.measurementDate)),
                  style: const TextStyle(fontSize: 9),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${comp.weightKg.toStringAsFixed(1)}kg',
                  style: const TextStyle(fontSize: 8, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildKeyMeasurements() {
    // Remove this section as it uses hardcoded measurement data
    return const SizedBox.shrink();
  }

  Widget _buildMeasurementItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            widthFactor: 0.7,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrainerFeedback() {
    // Remove this section as it uses hardcoded feedback data
    return const SizedBox.shrink();
  }

  Widget _buildFeedbackItem(String trainerName, String date, String feedback) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 18, color: Colors.grey[600]),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trainerName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            feedback,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeDisplay() {
    final dateRange = ref.watch(dateRangeProvider);
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF6366F1).withOpacity(0.08),
                const Color(0xFF8B5CF6).withOpacity(0.05),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.date_range,
                    color: Color(0xFF6366F1), size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${dateFormat.format(dateRange.startDate)} - ${dateFormat.format(dateRange.endDate)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1A1F36),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _showDateRangePickerDialog(),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF6366F1),
                ),
                child: const Text(
                  '변경',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildQuickDateButton('최근 7일', () {
                final endDate = DateTime.now();
                final startDate = endDate.subtract(const Duration(days: 7));
                _updateDateRange(startDate, endDate);
              }),
              const SizedBox(width: 8),
              _buildQuickDateButton('최근 30일', () {
                final endDate = DateTime.now();
                final startDate = endDate.subtract(const Duration(days: 30));
                _updateDateRange(startDate, endDate);
              }),
              const SizedBox(width: 8),
              _buildQuickDateButton('최근 3개월', () {
                final endDate = DateTime.now();
                final startDate =
                    DateTime(endDate.year, endDate.month - 3, endDate.day);
                _updateDateRange(startDate, endDate);
              }),
              const SizedBox(width: 8),
              _buildQuickDateButton('최근 6개월', () {
                final endDate = DateTime.now();
                final startDate =
                    DateTime(endDate.year, endDate.month - 6, endDate.day);
                _updateDateRange(startDate, endDate);
              }),
              const SizedBox(width: 8),
              _buildQuickDateButton('최근 1년', () {
                final endDate = DateTime.now();
                final startDate =
                    DateTime(endDate.year - 1, endDate.month, endDate.day);
                _updateDateRange(startDate, endDate);
              }),
              const SizedBox(width: 8),
              _buildQuickDateButton('전체 기간', () {
                final endDate = DateTime.now();
                final startDate = DateTime(2020, 1, 1);
                _updateDateRange(startDate, endDate);
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickDateButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6366F1),
          ),
        ),
      ),
    );
  }

  void _updateDateRange(DateTime startDate, DateTime endDate) {
    ref.read(dateRangeProvider.notifier).updateDateRange(startDate, endDate);

    ref.read(bodyCompositionNotifierProvider.notifier).loadBodyCompositions(
          startDate: startDate.toIso8601String().split('T')[0],
          endDate: endDate.toIso8601String().split('T')[0],
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '날짜 범위 업데이트: ${DateFormat('MM/dd').format(startDate)} - ${DateFormat('MM/dd').format(endDate)}',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDateRangePickerDialog() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: ref.read(dateRangeProvider).startDate,
        end: ref.read(dateRangeProvider).endDate,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2C3E50),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(dateRangeProvider.notifier).updateDateRange(
            picked.start,
            picked.end,
          );

      ref.read(bodyCompositionNotifierProvider.notifier).loadBodyCompositions(
            startDate: picked.start.toIso8601String().split('T')[0],
            endDate: picked.end.toIso8601String().split('T')[0],
          );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '날짜 범위 업데이트: ${DateFormat('MM/dd').format(picked.start)} - ${DateFormat('MM/dd').format(picked.end)}',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showAddDataDialog(BuildContext context) {
    final weightController = TextEditingController();
    final fatController = TextEditingController();
    final muscleController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('체성분 데이터 추가'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '체중 (kg)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: fatController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '체지방 (kg)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: muscleController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '근육량 (kg)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('측정 날짜'),
                    subtitle:
                        Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (weightController.text.isNotEmpty &&
                      fatController.text.isNotEmpty &&
                      muscleController.text.isNotEmpty) {
                    try {
                      await ref
                          .read(bodyCompositionNotifierProvider.notifier)
                          .addBodyComposition(
                            weightKg: double.parse(weightController.text),
                            fatKg: double.parse(fatController.text),
                            muscleMassKg: double.parse(muscleController.text),
                            measurementDate:
                                DateFormat('yyyy-MM-dd').format(selectedDate),
                          );

                      // Refresh the data with current date range
                      final dateRange = ref.read(dateRangeProvider);
                      await ref
                          .read(bodyCompositionNotifierProvider.notifier)
                          .loadBodyCompositions(
                            startDate: dateRange.startDate
                                .toIso8601String()
                                .split('T')[0],
                            endDate: dateRange.endDate
                                .toIso8601String()
                                .split('T')[0],
                          );

                      // Also invalidate the FutureProvider to refresh the data
                      ref.invalidate(bodyCompositionListProvider);

                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('데이터가 성공적으로 추가되었습니다'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('오류 발생: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text('추가'),
              ),
            ],
          );
        },
      ),
    );
  }
}
