import 'package:flutter/material.dart';
import 'dart:ui' as ui;
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

    // 스크롤 가능한 차트 설정
    final screenWidth = MediaQuery.of(context).size.width;
    const pointSpacing = 60.0;

    final sortedData = List<BodyComposition>.from(compositions)
      ..sort((a, b) => a.measurementDate.compareTo(b.measurementDate));

    // Use provided unified data or create fallback
    final Map<String, List<BodyImageResponse>> finalImagesByDate =
        imagesByDate ?? {};
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
    double padding =
        weightRange > 5 ? weightRange * 0.1 : 2; // 10% padding or minimum 2kg

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

    // 차트 너비 계산
    final dataPointCount = finalSortedAllDates.length;
    final calculatedWidth = dataPointCount * pointSpacing;
    final chartWidth =
        calculatedWidth < screenWidth ? screenWidth : calculatedWidth;

    // 스마트한 날짜 간격 계산
    int calculateDateInterval() {
      const maxLabels = 8; // 최대 8개 라벨로 제한
      if (dataPointCount <= maxLabels) return 1; // 데이터가 적으면 모든 날짜 표시

      // 적절한 간격 계산 (겹치지 않도록)
      int interval = (dataPointCount / maxLabels).ceil();

      // 깔끔한 간격으로 조정 (7, 14, 30일 등)
      if (interval <= 3)
        return 3; // 3일 간격
      else if (interval <= 7)
        return 7; // 1주일 간격
      else if (interval <= 14)
        return 14; // 2주일 간격
      else if (interval <= 30)
        return 30; // 1개월 간격
      else
        return (interval / 30).ceil() * 30; // 월 단위 간격
    }

    final dateInterval = calculateDateInterval();

    // Create spots for weight data only
    final spots = <FlSpot>[];
    final List<int> photoDates = []; // Store indices of dates with photos

    for (int i = 0; i < finalSortedAllDates.length; i++) {
      final date = finalSortedAllDates[i];

      // Check if there's weight data for this date
      final weightData = sortedData
          .where((comp) => comp.measurementDate.split('T')[0] == date)
          .firstOrNull;

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

    return SizedBox(
        height: 300, // 차트 높이 고정 (기존보다 높게)
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none, // 툴팁 자르기 방지
          physics: chartWidth > screenWidth
              ? const BouncingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          child: Container(
            width: chartWidth + 80, // 좌우 패딩 공간 추가
            padding: const EdgeInsets.symmetric(horizontal: 40), // 좌우 40px 패딩
            clipBehavior: Clip.none, // 툴팁 자르기 방지
            child: Column(
              children: [
                // Photo indicators at the top
                if (photoDates.isNotEmpty)
                  Container(
                    height: 40,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const SizedBox(
                            width: 60), // Match Y-axis reserved space
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final availableWidth = constraints.maxWidth;
                              return Stack(
                                children: photoDates.map((index) {
                                  final date = finalSortedAllDates[index];
                                  // Calculate position to match fl_chart's X-axis positioning exactly
                                  final position =
                                      finalSortedAllDates.length == 1
                                          ? 0.5
                                          : index /
                                              (finalSortedAllDates.length - 1);
                                  // Calculate exact pixel position, leaving space for icon width (24px)
                                  final leftPosition =
                                      (position * (availableWidth - 24))
                                          .clamp(0.0, availableWidth - 24);
                                  return Positioned(
                                    left: leftPosition,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (finalImagesByDate
                                            .containsKey(date)) {
                                          _showPhotoDialog(context,
                                              finalImagesByDate[date]!, date);
                                        }
                                      },
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.2),
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
                        touchCallback:
                            null, // Photos are handled by camera icons above
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (touchedSpot) =>
                              const Color(0xFF1A1F36),
                          tooltipRoundedRadius: 8,
                          tooltipPadding: const EdgeInsets.all(8),
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots
                                .map((barSpot) {
                                  final flSpot = barSpot;
                                  if (flSpot.x.toInt() >= 0 &&
                                      flSpot.x.toInt() <
                                          finalSortedAllDates.length) {
                                    final dateString =
                                        finalSortedAllDates[flSpot.x.toInt()];
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
                                })
                                .whereType<LineTooltipItem>()
                                .toList();
                          },
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval:
                            (maxY - minY) / 4, // 정확히 4개 간격 = 5개 라벨
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
                            interval: 1, // 모든 포인트에서 호출되도록
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();

                              // 유효한 인덱스 체크 및 정수가 아닌 값 필터링
                              if (value != index.toDouble() ||
                                  index < 0 ||
                                  index >= finalSortedAllDates.length) {
                                return const SizedBox.shrink();
                              }

                              // 스마트한 날짜 표시 로직
                              bool shouldShowDate = false;

                              if (dataPointCount <= 8) {
                                // 데이터가 적으면 모두 표시
                                shouldShowDate = true;
                              } else {
                                // 시작과 끝은 항상 표시
                                if (index == 0 ||
                                    index == finalSortedAllDates.length - 1) {
                                  shouldShowDate = true;
                                }
                                // 간격에 맞는 중간 날짜들 표시
                                else if (index % dateInterval == 0) {
                                  shouldShowDate = true;
                                }
                              }

                              if (shouldShowDate) {
                                final date =
                                    DateTime.parse(finalSortedAllDates[index]);
                                final dateText = dataPointCount > 30
                                    ? DateFormat('M/d').format(date)
                                    : DateFormat('MM/dd').format(date);

                                return Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    dateText,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: false), // Y축 범례 완전 제거
                        ),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
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
                            colors: [
                              Color(0xFF10B981),
                              Color(0xFF34D399),
                              Color(0xFF6EE7B7)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return _ValueDotPainter(
                                radius: 4,
                                color: Colors.white,
                                strokeWidth: 2,
                                strokeColor: const Color(0xFF10B981),
                                value: spot.y,
                                textColor: const Color(0xFF10B981),
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
            ),
          ),
        ));
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

// 값을 표시하는 커스텀 Dot Painter
class _ValueDotPainter extends FlDotPainter {
  final double radius;
  final Color color;
  final double strokeWidth;
  final Color strokeColor;
  final double value;
  final Color textColor;

  _ValueDotPainter({
    required this.radius,
    required this.color,
    required this.strokeWidth,
    required this.strokeColor,
    required this.value,
    required this.textColor,
  });

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    // Draw dot
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(offsetInCanvas, radius, dotPaint);
    canvas.drawCircle(offsetInCanvas, radius, strokePaint);

    // Draw value text above dot
    final textSpan = TextSpan(
      text: value.toStringAsFixed(1),
      style: TextStyle(
        color: textColor,
        fontSize: 11, // 9 → 11로 키움
        fontWeight: FontWeight.w600,
        fontFamily: 'IBMPlexSansKR',
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: ui.TextDirection.ltr,
    );

    textPainter.layout();

    // Position text above the dot
    final textOffset = Offset(
      offsetInCanvas.dx - textPainter.width / 2,
      offsetInCanvas.dy - radius - strokeWidth - textPainter.height - 4,
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  Size getSize(FlSpot spot) {
    return Size(radius * 2, radius * 2);
  }

  @override
  Color get mainColor => color;

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    if (a is _ValueDotPainter && b is _ValueDotPainter) {
      return _ValueDotPainter(
        radius: ui.lerpDouble(a.radius, b.radius, t) ?? radius,
        color: Color.lerp(a.color, b.color, t) ?? color,
        strokeWidth:
            ui.lerpDouble(a.strokeWidth, b.strokeWidth, t) ?? strokeWidth,
        strokeColor: Color.lerp(a.strokeColor, b.strokeColor, t) ?? strokeColor,
        value: ui.lerpDouble(a.value, b.value, t) ?? value,
        textColor: Color.lerp(a.textColor, b.textColor, t) ?? textColor,
      );
    }
    return this;
  }

  @override
  List<Object?> get props =>
      [radius, color, strokeWidth, strokeColor, value, textColor];
}
