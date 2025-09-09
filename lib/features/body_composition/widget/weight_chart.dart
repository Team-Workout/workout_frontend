import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../model/body_composition_model.dart';
import '../model/body_image_model.dart';
import '../../../core/config/api_config.dart';

class WeightChart extends StatelessWidget {
  final List<BodyComposition> compositions;
  final List<BodyImageResponse>? bodyImages;
  final List<String>? sortedAllDates;
  final Map<String, List<BodyImageResponse>>? imagesByDate;

  const WeightChart({
    Key? key,
    required this.compositions,
    this.bodyImages,
    this.sortedAllDates,
    this.imagesByDate,
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

    // Use provided unified data or create fallback
    final Map<String, List<BodyImageResponse>> finalImagesByDate = imagesByDate ?? {};
    if (finalImagesByDate.isEmpty && bodyImages != null) {
      for (var image in bodyImages!) {
        final date = image.recordDate.split('T')[0];
        finalImagesByDate[date] = (finalImagesByDate[date] ?? [])..add(image);
      }
    }

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
    
    // Add space at top for photo points if photos exist
    if (finalImagesByDate.isNotEmpty) {
      maxY = maxY + (maxY - minY) * 0.2; // Add 20% more space at top
    }

    // Use provided unified dates or create fallback
    final List<String> finalSortedAllDates = sortedAllDates ?? [];
    if (finalSortedAllDates.isEmpty) {
      final Set<String> allDates = <String>{};
      // Add weight dates
      for (var comp in sortedData) {
        allDates.add(comp.measurementDate.split('T')[0]);
      }
      // Add photo dates
      finalImagesByDate.keys.forEach(allDates.add);
      finalSortedAllDates.addAll(allDates.toList()..sort());
    }
    print('📅 Final sorted dates: $finalSortedAllDates');
    print('📸 Images by date: ${finalImagesByDate.keys.toList()}');
    
    // Create spots for weight data only
    final spots = <FlSpot>[];
    final List<int> photoDates = []; // Store indices of dates with photos
    
    for (int i = 0; i < finalSortedAllDates.length; i++) {
      final date = finalSortedAllDates[i];
      
      // Check if there's weight data for this date
      final weightData = sortedData.where((comp) => 
        comp.measurementDate.split('T')[0] == date).firstOrNull;
      
      if (weightData != null) {
        // Has weight data - add normal spot
        spots.add(FlSpot(i.toDouble(), weightData.weightKg));
      }
      
      // Track dates with photos for indicator display
      if (finalImagesByDate.containsKey(date)) {
        photoDates.add(i);
        print('📸 Photo found for date $date at index $i');
      }
    }

    return Column(
      children: [
        // Photo indicators at the top
        if (photoDates.isNotEmpty)
          Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const SizedBox(width: 60), // Match Y-axis reserved space
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final availableWidth = constraints.maxWidth;
                      return Stack(
                        children: photoDates.map((index) {
                          final date = finalSortedAllDates[index];
                          // Calculate position to match fl_chart's X-axis positioning exactly
                          final position = finalSortedAllDates.length == 1 
                              ? 0.5 
                              : index / (finalSortedAllDates.length - 1);
                          // Calculate exact pixel position, leaving space for icon width (24px)
                          final leftPosition = (position * (availableWidth - 24)).clamp(0.0, availableWidth - 24);
                          return Positioned(
                            left: leftPosition,
                        child: GestureDetector(
                          onTap: () {
                            if (finalImagesByDate.containsKey(date)) {
                              _showPhotoDialog(context, finalImagesByDate[date]!, date);
                            }
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        // Weight chart
        Expanded(
          child: LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchCallback: null, // Photos are handled by camera icons above
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => const Color(0xFF1A1F36),
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                if (flSpot.x.toInt() >= 0 && flSpot.x.toInt() < finalSortedAllDates.length) {
                  final dateString = finalSortedAllDates[flSpot.x.toInt()];
                  final date = DateTime.parse(dateString);
                  
                  return LineTooltipItem(
                    '${DateFormat('MM/dd').format(date)}\n${flSpot.y.toStringAsFixed(1)}kg',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  );
                }
                return null;
              }).whereType<LineTooltipItem>().toList();
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 4, // 정확히 4개 간격 = 5개 라벨
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
              reservedSize: 35,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < finalSortedAllDates.length) {
                  final date = DateTime.parse(finalSortedAllDates[value.toInt()]);
                  return Text(
                    DateFormat('MM/dd').format(date),
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
              interval: finalSortedAllDates.length > 7
                  ? (finalSortedAllDates.length / 7).ceil().toDouble()
                  : 1,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toStringAsFixed(1)}kg',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
              interval: (maxY - minY) / 4, // 정확히 4개 간격 = 5개 라벨
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (finalSortedAllDates.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          // Weight data line
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
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: const Color(0xFF10B981),
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
          ),
        ),
      ],
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

class _CameraIconDotPainter extends FlDotPainter {
  final Color color;
  
  _CameraIconDotPainter({required this.color});
  
  @override
  Color get mainColor => color;
  
  @override
  List<Object?> get props => [color];
  
  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    if (a is _CameraIconDotPainter && b is _CameraIconDotPainter) {
      return _CameraIconDotPainter(
        color: Color.lerp(a.color, b.color, t) ?? color,
      );
    }
    return this;
  }
  
  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    // Draw background circle
    Paint backgroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    Paint strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(offsetInCanvas, 10, backgroundPaint);
    canvas.drawCircle(offsetInCanvas, 10, strokePaint);
    
    // Draw camera icon
    Paint iconPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    // Simple camera rectangle
    Rect cameraBody = Rect.fromCenter(
      center: offsetInCanvas,
      width: 12,
      height: 8,
    );
    
    // Camera lens circle
    canvas.drawRRect(
      RRect.fromRectAndRadius(cameraBody, const Radius.circular(2)),
      iconPaint,
    );
    
    Paint lensPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(offsetInCanvas.dx, offsetInCanvas.dy - 1),
      3,
      lensPaint,
    );
    
    // Small viewfinder
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(offsetInCanvas.dx, offsetInCanvas.dy - 5),
        width: 4,
        height: 2,
      ),
      iconPaint,
    );
  }
  
  @override
  Size getSize(FlSpot spot) {
    return const Size(20, 20);
  }
}

// Y축 간격을 정확히 5개로 고정하는 함수
double _calculateOptimalInterval(double range) {
  if (range <= 0) return 1.0;
  
  // 정확히 5개의 간격으로 나누기 (6개의 라벨)
  return range / 5.0;
}