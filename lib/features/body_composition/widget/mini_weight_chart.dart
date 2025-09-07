import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/body_composition_model.dart';
import '../../../core/theme/notion_colors.dart';

class MiniWeightChart extends StatelessWidget {
  final List<BodyComposition> compositions;

  const MiniWeightChart({
    Key? key,
    required this.compositions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (compositions.length < 2) {
      return const Center(
        child: Text(
          '차트를 표시하려면 최소 2개의 체중 기록이 필요합니다',
          style: TextStyle(color: Color(0xFF6B7280)),
        ),
      );
    }
    
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: compositions.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.weightKg);
            }).toList(),
            isCurved: true,
            color: NotionColors.black,
            barWidth: 2,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 3,
                color: NotionColors.black,
                strokeColor: NotionColors.white,
                strokeWidth: 2,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: NotionColors.gray100,
            ),
          ),
        ],
      ),
    );
  }
}