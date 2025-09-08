import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../model/body_composition_model.dart';
import '../model/body_image_model.dart';
import 'weight_chart.dart';
import '../../../core/config/api_config.dart';

class WeightTrendSection extends StatelessWidget {
  final List<BodyComposition> compositions;
  final List<BodyImageResponse>? bodyImages;

  const WeightTrendSection({
    Key? key,
    required this.compositions,
    this.bodyImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: const Color(0xFF10B981).withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.15),
            spreadRadius: 2,
            blurRadius: 20,
            offset: const Offset(0, 8),
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
                child: const Icon(Icons.trending_up,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF34D399)],
                    ).createShader(bounds),
                    child: const Text(
                      '변화 추이',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 체중 그래프
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '체중',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 150,
                child: WeightChart(
                    compositions: compositions, bodyImages: bodyImages),
              ),
              const SizedBox(height: 20),
              // 근육량 그래프
              Text(
                '근육량',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 150,
                child: MuscleChart(
                    compositions: compositions, bodyImages: bodyImages),
              ),
              const SizedBox(height: 20),
              // 체지방량 그래프
              Text(
                '체지방량',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 150,
                child: FatChart(
                    compositions: compositions, bodyImages: bodyImages),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 근육량 차트
class MuscleChart extends StatelessWidget {
  final List<BodyComposition> compositions;
  final List<BodyImageResponse>? bodyImages;

  const MuscleChart({
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

    // Map dates to body images
    final Map<String, List<BodyImageResponse>> imagesByDate = {};
    if (bodyImages != null) {
      for (var image in bodyImages!) {
        final date = image.recordDate.split('T')[0];
        imagesByDate[date] = (imagesByDate[date] ?? [])..add(image);
      }
    }

    final spots = sortedData.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.muscleMassKg,
      );
    }).toList();

    double minMuscle =
        sortedData.map((e) => e.muscleMassKg).reduce((a, b) => a < b ? a : b);
    double maxMuscle =
        sortedData.map((e) => e.muscleMassKg).reduce((a, b) => a > b ? a : b);

    double muscleRange = maxMuscle - minMuscle;
    double padding = muscleRange > 3 ? muscleRange * 0.1 : 1;

    double minY = (minMuscle - padding).floorToDouble();
    double maxY = (maxMuscle + padding).ceilToDouble();

    if (maxY - minY < 2) {
      double center = (minY + maxY) / 2;
      minY = center - 1;
      maxY = center + 1;
    }

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: false,
          touchCallback:
              (FlTouchEvent event, LineTouchResponse? touchResponse) {
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
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 4,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Color(0xFFE5E7EB),
              strokeWidth: 0.5,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: (maxY - minY) / 4,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toStringAsFixed(1)}',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: (sortedData.length / 4).ceil().toDouble(),
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= sortedData.length) return const SizedBox();
                final date =
                    DateTime.parse(sortedData[value.toInt()].measurementDate);
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    DateFormat('MM/dd').format(date),
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
            curveSmoothness: 0.3,
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final date =
                    sortedData[spot.x.toInt()].measurementDate.split('T')[0];
                final hasPhoto = imagesByDate.containsKey(date);
                return FlDotCirclePainter(
                  radius: hasPhoto ? 6 : 4,
                  color: hasPhoto ? const Color(0xFF3B82F6) : Colors.white,
                  strokeWidth: 2,
                  strokeColor:
                      hasPhoto ? Colors.white : const Color(0xFF3B82F6),
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3B82F6).withOpacity(0.1),
                  const Color(0xFF3B82F6).withOpacity(0.05),
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

  void _showPhotoDialog(
      BuildContext context, List<BodyImageResponse> images, String date) {
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
                    colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
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
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.broken_image,
                                  size: 48, color: Colors.grey),
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

// 체지방량 차트
class FatChart extends StatelessWidget {
  final List<BodyComposition> compositions;
  final List<BodyImageResponse>? bodyImages;

  const FatChart({
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

    // Map dates to body images
    final Map<String, List<BodyImageResponse>> imagesByDate = {};
    if (bodyImages != null) {
      for (var image in bodyImages!) {
        final date = image.recordDate.split('T')[0];
        imagesByDate[date] = (imagesByDate[date] ?? [])..add(image);
      }
    }

    final spots = sortedData.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.fatKg,
      );
    }).toList();

    double minFat =
        sortedData.map((e) => e.fatKg).reduce((a, b) => a < b ? a : b);
    double maxFat =
        sortedData.map((e) => e.fatKg).reduce((a, b) => a > b ? a : b);

    double fatRange = maxFat - minFat;
    double padding = fatRange > 2 ? fatRange * 0.1 : 0.5;

    double minY = (minFat - padding).floorToDouble();
    double maxY = (maxFat + padding).ceilToDouble();

    if (maxY - minY < 1) {
      double center = (minY + maxY) / 2;
      minY = center - 0.5;
      maxY = center + 0.5;
    }

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: false,
          touchCallback:
              (FlTouchEvent event, LineTouchResponse? touchResponse) {
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
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 4,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Color(0xFFE5E7EB),
              strokeWidth: 0.5,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: (maxY - minY) / 4,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toStringAsFixed(1)}',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: (sortedData.length / 4).ceil().toDouble(),
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= sortedData.length) return const SizedBox();
                final date =
                    DateTime.parse(sortedData[value.toInt()].measurementDate);
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    DateFormat('MM/dd').format(date),
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
            curveSmoothness: 0.3,
            gradient: const LinearGradient(
              colors: [Color(0xFFEF4444), Color(0xFFF87171)],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final date =
                    sortedData[spot.x.toInt()].measurementDate.split('T')[0];
                final hasPhoto = imagesByDate.containsKey(date);
                return FlDotCirclePainter(
                  radius: hasPhoto ? 6 : 4,
                  color: hasPhoto ? const Color(0xFFEF4444) : Colors.white,
                  strokeWidth: 2,
                  strokeColor:
                      hasPhoto ? Colors.white : const Color(0xFFEF4444),
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFEF4444).withOpacity(0.1),
                  const Color(0xFFEF4444).withOpacity(0.05),
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

  void _showPhotoDialog(
      BuildContext context, List<BodyImageResponse> images, String date) {
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
                    colors: [Color(0xFFEF4444), Color(0xFFF87171)],
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
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.broken_image,
                                  size: 48, color: Colors.grey),
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
