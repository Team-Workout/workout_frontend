import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../body_composition/model/body_composition_model.dart';

class DashboardWeightChart extends StatelessWidget {
  final List<BodyComposition> compositions;

  const DashboardWeightChart({
    super.key,
    required this.compositions,
  });

  @override
  Widget build(BuildContext context) {
    if (compositions.isEmpty) {
      return const Center(
        child: Text(
          '데이터가 없습니다', 
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'IBMPlexSansKR',
            fontWeight: FontWeight.w400,
          ),
        ),
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
            getTooltipColor: (touchedSpot) => const Color(0xFF4CAF50),
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
                    fontFamily: 'IBMPlexSansKR',
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
                      value.toStringAsFixed(0),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'IBMPlexSansKR',
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
            color: const Color(0xFF4CAF50),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: const Color(0xFF4CAF50),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}