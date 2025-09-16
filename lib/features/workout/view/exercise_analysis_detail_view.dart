import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../model/workout_stats_models.dart';

class ExerciseAnalysisDetailView extends StatefulWidget {
  final ExerciseStats exercise;

  const ExerciseAnalysisDetailView({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  State<ExerciseAnalysisDetailView> createState() => _ExerciseAnalysisDetailViewState();
}

class _ExerciseAnalysisDetailViewState extends State<ExerciseAnalysisDetailView> {
  int _selectedChartIndex = 0;
  
  final List<ChartInfo> _chartTypes = [
    ChartInfo('1RM 추정', Icons.whatshot, Color(0xFF374151), 'kg'),
    ChartInfo('최대 중량', Icons.trending_up, Color(0xFF4B5563), 'kg'),
    ChartInfo('세트 수', Icons.repeat, Color(0xFF6B7280), '세트'),
    ChartInfo('볼륨', Icons.fitness_center, Color(0xFF9CA3AF), 'kg'),
    ChartInfo('평균 중량', Icons.timeline, Color(0xFF374151), 'kg'),
    ChartInfo('총 횟수', Icons.confirmation_number, Color(0xFF4B5563), '회'),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'IBMPlexSansKR',
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            widget.exercise.exerciseName,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 운동 정보 헤더
              _buildExerciseHeader(),
              const SizedBox(height: 20),
              
              // 차트 탭 선택
              _buildChartTabs(),
              const SizedBox(height: 20),
              
              // 선택된 차트 표시
              _buildSelectedChart(),
              const SizedBox(height: 20),
              
              // 통계 요약 카드들
              _buildStatsGrid(),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF34D399)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              _getExerciseIcon(widget.exercise.exerciseName),
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.exercise.exerciseName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildQuickStat('총 ${widget.exercise.totalSets}세트', Icons.repeat),
                    const SizedBox(width: 16),
                    _buildQuickStat('${widget.exercise.totalReps}회', Icons.confirmation_number),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String text, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
      ],
    );
  }

  Widget _buildChartTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.5,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: _chartTypes.length,
        itemBuilder: (context, index) {
          final chartInfo = _chartTypes[index];
          final isSelected = _selectedChartIndex == index;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedChartIndex = index;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF10B981).withValues(alpha: 0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? const Color(0xFF10B981) : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    chartInfo.icon,
                    size: 20,
                    color: isSelected ? const Color(0xFF10B981) : Colors.grey[600],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chartInfo.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? const Color(0xFF10B981) : Colors.grey[600],
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: _chartTypes[_selectedChartIndex].color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _chartTypes[_selectedChartIndex].color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _chartTypes[_selectedChartIndex].icon,
                  size: 20,
                  color: _chartTypes[_selectedChartIndex].color,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${_chartTypes[_selectedChartIndex].name} 추이',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: _buildChart(_selectedChartIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(int chartIndex) {
    if (widget.exercise.progressData.isEmpty) {
      return _buildEmptyChart();
    }

    List<FlSpot> spots = [];
    String unit = _chartTypes[chartIndex].unit;
    
    switch (chartIndex) {
      case 0: // 1RM 추정
        spots = widget.exercise.progressData.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.estimatedOneRM);
        }).toList();
        break;
      case 1: // 최대 중량
        spots = widget.exercise.progressData.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.maxWeight);
        }).toList();
        break;
      case 2: // 세트 수 - 날짜별 세트 수 계산
        spots = widget.exercise.progressData.asMap().entries.map((entry) {
          // 해당 날짜의 세트 수 계산
          final date = entry.value.date;
          final setsForDate = widget.exercise.sets
              .where((set) => set.date == date)
              .length;
          return FlSpot(entry.key.toDouble(), setsForDate.toDouble());
        }).toList();
        break;
      case 3: // 볼륨
        spots = widget.exercise.progressData.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.volume / 1000); // K단위
        }).toList();
        unit = 'K';
        break;
      case 4: // 평균 중량
        spots = widget.exercise.progressData.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.avgWeight);
        }).toList();
        break;
      case 5: // 총 횟수 - 날짜별 총 횟수 계산
        spots = widget.exercise.progressData.asMap().entries.map((entry) {
          // 해당 날짜의 총 횟수 계산
          final date = entry.value.date;
          final repsForDate = widget.exercise.sets
              .where((set) => set.date == date)
              .fold<int>(0, (sum, set) => sum + set.reps);
          return FlSpot(entry.key.toDouble(), repsForDate.toDouble());
        }).toList();
        break;
    }

    if (spots.isEmpty || spots.every((spot) => spot.y == 0)) {
      return _buildEmptyChart();
    }

    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;
    final padding = range > 0 ? range * 0.1 : 1.0;
    final safeMinY = (minY - padding) < 0 ? 0.0 : (minY - padding);
    final safeMaxY = maxY + padding;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: range > 0 ? (safeMaxY - safeMinY) / 4 : 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[400]!,
              strokeWidth: 1.0,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              interval: spots.length > 10 ? (spots.length / 5).ceil().toDouble() : 1,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value >= spots.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${value.toInt() + 1}회차',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: range > 0 ? (safeMaxY - safeMinY) / 4 : 1,
              getTitlesWidget: (value, meta) {
                if (value < 0) return const SizedBox.shrink();
                return Text(
                  '${value.toStringAsFixed(0)}$unit',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontFamily: 'IBMPlexSansKR',
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(color: Colors.grey[300]!, width: 1),
            bottom: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
        ),
        minX: 0,
        maxX: spots.length > 1 ? (spots.length - 1).toDouble() : 1,
        minY: safeMinY,
        maxY: safeMaxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: _chartTypes[chartIndex].color,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: Colors.white,
                  strokeWidth: 3,
                  strokeColor: _chartTypes[chartIndex].color,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  _chartTypes[chartIndex].color.withOpacity(0.2),
                  _chartTypes[chartIndex].color.withOpacity(0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => _chartTypes[chartIndex].color.withOpacity(0.9),
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                return LineTooltipItem(
                  '${(barSpot.x.toInt() + 1)}회차\n${barSpot.y.toStringAsFixed(1)}$unit',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyChart() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _chartTypes[_selectedChartIndex].icon,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '${_chartTypes[_selectedChartIndex].name} 데이터 없음',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 120,
                  child: _buildStatCard(
                    '최대 중량',
                    '${widget.exercise.maxWeight.toStringAsFixed(1)}kg',
                    const Color(0xFF374151),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 120,
                  child: _buildStatCard(
                    '평균 중량',
                    '${widget.exercise.avgWeight.toStringAsFixed(1)}kg',
                    const Color(0xFF4B5563),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 120,
                  child: _buildStatCard(
                    '총 볼륨',
                    '${(widget.exercise.totalVolume / 1000).toStringAsFixed(1)}K',
                    const Color(0xFF6B7280),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 120,
                  child: _buildStatCard(
                    '예상 1RM',
                    '${widget.exercise.estimatedOneRM.toStringAsFixed(1)}kg',
                    const Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'IBMPlexSansKR',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ],
      ),
    );
  }

  IconData _getExerciseIcon(String exerciseName) {
    final name = exerciseName.toLowerCase();
    if (name.contains('bench') || name.contains('벤치')) return Icons.fitness_center;
    if (name.contains('squat') || name.contains('스쿼트')) return Icons.keyboard_arrow_down;
    if (name.contains('deadlift') || name.contains('데드')) return Icons.keyboard_arrow_up;
    if (name.contains('press') || name.contains('프레스')) return Icons.trending_up;
    if (name.contains('curl') || name.contains('컬')) return Icons.radio_button_unchecked;
    if (name.contains('fly') || name.contains('플라이')) return Icons.open_in_full;
    return Icons.fitness_center;
  }
}

class ChartInfo {
  final String name;
  final IconData icon;
  final Color color;
  final String unit;

  ChartInfo(this.name, this.icon, this.color, this.unit);
}