import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../model/body_composition_model.dart';
import '../model/body_image_model.dart';
import '../../../core/config/api_config.dart';

class WeightChart extends StatelessWidget {
  final List<BodyComposition> compositions;
  final List<BodyImageResponse>? bodyImages;

  const WeightChart({
    Key? key,
    required this.compositions,
    this.bodyImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    
    // Set Y-axis range for better visibility with smart padding
    double weightRange = maxWeight - minWeight;
    double padding = weightRange > 5 ? weightRange * 0.1 : 2; // 10% padding or minimum 2kg
    
    double minY = (minWeight - padding).floorToDouble();
    double maxY = (maxWeight + padding).ceilToDouble();
    
    // Ensure minimum range for very stable weights
    if (maxY - minY < 3) {
      double center = (minY + maxY) / 2;
      minY = center - 1.5;
      maxY = center + 1.5;
    }
    
    // Ensure minY is not negative (weights can't be negative)
    minY = minY < 0 ? 0 : minY;

    // Map dates to body images
    final Map<String, List<BodyImageResponse>> imagesByDate = {};
    if (bodyImages != null) {
      print('WeightChart: bodyImages count = ${bodyImages!.length}');
      for (var image in bodyImages!) {
        final date = image.recordDate.split('T')[0];
        imagesByDate[date] = (imagesByDate[date] ?? [])..add(image);
        print('WeightChart: mapped image for date $date');
      }
    } else {
      print('WeightChart: bodyImages is null');
    }

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: false,
          touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
            if (event is FlTapUpEvent && touchResponse != null) {
              final spot = touchResponse.lineBarSpots?.firstOrNull;
              if (spot != null) {
                final index = spot.x.toInt();
                if (index >= 0 && index < sortedData.length) {
                  final date = sortedData[index].measurementDate.split('T')[0];
                  final images = imagesByDate[date];
                  if (images != null && images.isNotEmpty) {
                    try {
                      _showPhotoDialog(context, images, date);
                    } catch (e) {
                      // Handle dialog show error gracefully
                    }
                  }
                }
              }
            }
          },
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
            gradient: const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF34D399), Color(0xFF6EE7B7)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final date = sortedData[spot.x.toInt()].measurementDate.split('T')[0];
                final hasPhoto = imagesByDate.containsKey(date);
                return FlDotCirclePainter(
                  radius: hasPhoto ? 8 : 6,
                  color: hasPhoto ? const Color(0xFF10B981) : Colors.white,
                  strokeWidth: 3,
                  strokeColor: hasPhoto ? Colors.white : const Color(0xFF10B981),
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF10B981).withValues(alpha: 0.3),
                  const Color(0xFF34D399).withValues(alpha: 0.2),
                  const Color(0xFF6EE7B7).withValues(alpha: 0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPhotoDialog(BuildContext context, List<BodyImageResponse> images, String date) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF34D399)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(date)),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: PageView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          images[index].fileUrl.startsWith('http') 
                            ? images[index].fileUrl 
                            : '${ApiConfig.imageBaseUrl}${images[index].fileUrl}',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (images.length > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    '${images.length}장의 사진',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}