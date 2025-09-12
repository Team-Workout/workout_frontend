import 'package:flutter/material.dart';
import 'dart:ui' as ui;
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
    // Create unified date timeline for all charts
    final sortedData = List<BodyComposition>.from(compositions)
      ..sort((a, b) => a.measurementDate.compareTo(b.measurementDate));

    // Map images by date
    final Map<String, List<BodyImageResponse>> localImagesByDate = {};
    if (bodyImages != null) {
      for (var image in bodyImages!) {
        final date = image.recordDate.split('T')[0];
        localImagesByDate[date] = (localImagesByDate[date] ?? [])..add(image);
      }
    }

    // Create unified date timeline combining both composition and photo dates
    final Set<String> allDates = <String>{};

    // Add composition data dates
    for (var comp in sortedData) {
      allDates.add(comp.measurementDate.split('T')[0]);
    }

    // Add photo dates
    localImagesByDate.keys.forEach(allDates.add);

    final localSortedAllDates = allDates.toList()..sort();

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
                  Text(
                    '변화 추이',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      letterSpacing: -0.5,
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
                height: 300, // 높이 증가
                child: WeightChart(
                  compositions: compositions,
                  bodyImages: bodyImages,
                  sortedAllDates: localSortedAllDates,
                  imagesByDate: localImagesByDate,
                ),
              ),
              const SizedBox(height: 30), // 간격 늘림
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
              Container(
                height: 300, // 높이 고정
                clipBehavior: Clip.none, // 툴팁 자르기 방지
                child: MuscleChart(
                  compositions: compositions,
                  bodyImages: bodyImages,
                  sortedAllDates: localSortedAllDates,
                  imagesByDate: localImagesByDate,
                ),
              ),
              const SizedBox(height: 30), // 간격 늘림
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
              Container(
                height: 300, // 높이 고정
                clipBehavior: Clip.none, // 툴팁 자르기 방지
                child: FatChart(
                  compositions: compositions,
                  bodyImages: bodyImages,
                  sortedAllDates: localSortedAllDates,
                  imagesByDate: localImagesByDate,
                ),
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
  final List<String>? sortedAllDates;
  final Map<String, List<BodyImageResponse>>? imagesByDate;

  const MuscleChart({
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
    
    // 스크롤 가능한 차트를 위한 설정
    final screenWidth = MediaQuery.of(context).size.width;
    const pointSpacing = 60.0; // 각 데이터 포인트 간의 간격

    final sortedData = List<BodyComposition>.from(compositions)
      ..sort((a, b) => a.measurementDate.compareTo(b.measurementDate));

    // Use provided unified data or create fallback
    final Map<String, List<BodyImageResponse>> localImagesByDate =
        imagesByDate ?? {};
    if (localImagesByDate.isEmpty && bodyImages != null) {
      for (var image in bodyImages!) {
        final date = image.recordDate.split('T')[0];
        localImagesByDate[date] = (localImagesByDate[date] ?? [])..add(image);
      }
    }

    // Use provided unified dates or create fallback
    final List<String> localSortedAllDates = sortedAllDates ?? [];
    if (localSortedAllDates.isEmpty) {
      final Set<String> allDates = <String>{};
      // Add muscle data dates
      for (var comp in sortedData) {
        allDates.add(comp.measurementDate.split('T')[0]);
      }
      // Add photo dates
      localImagesByDate.keys.forEach(allDates.add);
      localSortedAllDates.addAll(allDates.toList()..sort());
    }
    
    // 차트 너비 계산
    final dataPointCount = localSortedAllDates.length;
    final calculatedWidth = dataPointCount * pointSpacing;
    final chartWidth = calculatedWidth < screenWidth ? screenWidth : calculatedWidth;
    
    // 스마트한 날짜 간격 계산
    int calculateDateInterval() {
      const maxLabels = 8;
      if (dataPointCount <= maxLabels) return 1;
      
      int interval = (dataPointCount / maxLabels).ceil();
      
      if (interval <= 3) return 3;
      else if (interval <= 7) return 7;
      else if (interval <= 14) return 14;
      else if (interval <= 30) return 30;
      else return (interval / 30).ceil() * 30;
    }
    
    final dateInterval = calculateDateInterval();

    // Create spots for muscle data only
    final spots = <FlSpot>[];
    final List<int> photoDates = []; // Store indices of dates with photos

    for (int i = 0; i < localSortedAllDates.length; i++) {
      final date = localSortedAllDates[i];

      // Check if there's muscle data for this date
      final muscleData = sortedData
          .where((comp) => comp.measurementDate.split('T')[0] == date)
          .firstOrNull;

      if (muscleData != null) {
        // Has muscle data - add normal spot
        spots.add(FlSpot(i.toDouble(), muscleData.muscleMassKg));
      }

      // Track dates with photos for indicator display
      if (localImagesByDate.containsKey(date)) {
        photoDates.add(i);
      }
    }

    double minMuscle =
        sortedData.map((e) => e.muscleMassKg).reduce((a, b) => a < b ? a : b);
    double maxMuscle =
        sortedData.map((e) => e.muscleMassKg).reduce((a, b) => a > b ? a : b);

    double muscleRange = maxMuscle - minMuscle;
    double padding = muscleRange > 3 ? muscleRange * 0.1 : 1;

    double minY = (minMuscle - padding).floorToDouble();
    double maxY = (maxMuscle + padding).ceilToDouble();

    // 근육량은 0 이하가 될 수 없으므로 최소값을 0으로 제한
    minY = minY < 0 ? 0 : minY;

    if (maxY - minY < 2) {
      double center = (minY + maxY) / 2;
      minY = center - 1;
      maxY = center + 1;
      // 다시 한번 최소값 체크
      minY = minY < 0 ? 0 : minY;
    }

    return SizedBox(
      height: 300, // 차트 높이 고정 (더 높게)
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none, // 툴팁 자르기 방지
        physics: chartWidth > screenWidth ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
        child: Container(
          width: chartWidth + 80, // 좌우 패딩 공간 추가
          padding: const EdgeInsets.symmetric(horizontal: 40), // 좌우 40px 패딩
          child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchCallback: null,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => const Color(0xFF1A1F36),
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.all(8),
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final flSpot = barSpot;
                  final date =
                      DateTime.parse(localSortedAllDates[flSpot.x.toInt()]);
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
            horizontalInterval: (maxY - minY) / 3, // 정확히 3개 간격 = 4개 라벨
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: Color(0xFFE5E7EB),
                strokeWidth: 0.5,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false), // Y축 범례 완전 제거
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  
                  if (value != index.toDouble() || index < 0 || index >= localSortedAllDates.length) {
                    return const SizedBox.shrink();
                  }
                  
                  bool shouldShowDate = false;
                  
                  if (dataPointCount <= 8) {
                    shouldShowDate = true;
                  } else {
                    if (index == 0 || index == localSortedAllDates.length - 1) {
                      shouldShowDate = true;
                    }
                    else if (index % dateInterval == 0) {
                      shouldShowDate = true;
                    }
                  }
                  
                  if (shouldShowDate) {
                    final date = DateTime.parse(localSortedAllDates[index]);
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
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (localSortedAllDates.length - 1).toDouble(),
          minY: minY,
          maxY: maxY,
          lineBarsData: [
            // Muscle data line
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
                  return _ValueDotPainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: const Color(0xFF3B82F6),
                    value: spot.y,
                    textColor: const Color(0xFF3B82F6),
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
            ),
          ),
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

  void _showPhotoTooltip(BuildContext context, List<BodyImageResponse> images,
      String date, double xPosition) {
    final overlay = Overlay.of(context);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _PhotoTooltip(
        images: images,
        date: date,
        xPosition: xPosition,
        onClose: () => overlayEntry?.remove(),
      ),
    );

    overlay.insert(overlayEntry);
  }

  // COMMENTED OUT - Original MuscleChart modal
  /*
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
  */
}

// 체지방량 차트
class FatChart extends StatelessWidget {
  final List<BodyComposition> compositions;
  final List<BodyImageResponse>? bodyImages;
  final List<String>? sortedAllDates;
  final Map<String, List<BodyImageResponse>>? imagesByDate;

  const FatChart({
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
    
    // 스크롤 가능한 차트를 위한 설정
    final screenWidth = MediaQuery.of(context).size.width;
    const pointSpacing = 60.0;

    final sortedData = List<BodyComposition>.from(compositions)
      ..sort((a, b) => a.measurementDate.compareTo(b.measurementDate));

    // Use provided unified data or create fallback
    final Map<String, List<BodyImageResponse>> localImagesByDate =
        imagesByDate ?? {};
    if (localImagesByDate.isEmpty && bodyImages != null) {
      for (var image in bodyImages!) {
        final date = image.recordDate.split('T')[0];
        localImagesByDate[date] = (localImagesByDate[date] ?? [])..add(image);
      }
    }

    // Use provided unified dates or create fallback
    final List<String> localSortedAllDates = sortedAllDates ?? [];
    if (localSortedAllDates.isEmpty) {
      final Set<String> allDates = <String>{};
      // Add fat data dates
      for (var comp in sortedData) {
        allDates.add(comp.measurementDate.split('T')[0]);
      }
      // Add photo dates
      localImagesByDate.keys.forEach(allDates.add);
      localSortedAllDates.addAll(allDates.toList()..sort());
    }
    
    // 차트 너비 계산
    final dataPointCount = localSortedAllDates.length;
    final calculatedWidth = dataPointCount * pointSpacing;
    final chartWidth = calculatedWidth < screenWidth ? screenWidth : calculatedWidth;
    
    // 스마트한 날짜 간격 계산
    int calculateDateInterval() {
      const maxLabels = 8;
      if (dataPointCount <= maxLabels) return 1;
      
      int interval = (dataPointCount / maxLabels).ceil();
      
      if (interval <= 3) return 3;
      else if (interval <= 7) return 7;
      else if (interval <= 14) return 14;
      else if (interval <= 30) return 30;
      else return (interval / 30).ceil() * 30;
    }
    
    final dateInterval = calculateDateInterval();

    // Create spots for fat data only
    final spots = <FlSpot>[];

    for (int i = 0; i < localSortedAllDates.length; i++) {
      final date = localSortedAllDates[i];

      // Check if there's fat data for this date
      final fatData = sortedData
          .where((comp) => comp.measurementDate.split('T')[0] == date)
          .firstOrNull;

      if (fatData != null) {
        // Has fat data - add normal spot
        spots.add(FlSpot(i.toDouble(), fatData.fatKg));
      }
    }

    double minFat =
        sortedData.map((e) => e.fatKg).reduce((a, b) => a < b ? a : b);
    double maxFat =
        sortedData.map((e) => e.fatKg).reduce((a, b) => a > b ? a : b);

    double fatRange = maxFat - minFat;
    double padding = fatRange > 2 ? fatRange * 0.1 : 0.5;

    double minY = (minFat - padding).floorToDouble();
    double maxY = (maxFat + padding).ceilToDouble();

    // 체지방량은 0 이하가 될 수 없으므로 최소값을 0으로 제한
    minY = minY < 0 ? 0 : minY;

    if (maxY - minY < 1) {
      double center = (minY + maxY) / 2;
      minY = center - 0.5;
      maxY = center + 0.5;
      // 다시 한번 최소값 체크
      minY = minY < 0 ? 0 : minY;
    }

    return SizedBox(
      height: 300, // 차트 높이 고정 (더 높게)
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none, // 툴팁 자르기 방지
        physics: chartWidth > screenWidth ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
        child: Container(
          width: chartWidth + 80, // 좌우 패딩 공간 추가
          padding: const EdgeInsets.symmetric(horizontal: 40), // 좌우 40px 패딩
          child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              enabled: true,
              handleBuiltInTouches: true,
              touchCallback: null,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => const Color(0xFF1A1F36),
                tooltipRoundedRadius: 8,
                tooltipPadding: const EdgeInsets.all(8),
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                  return touchedBarSpots.map((barSpot) {
                    final flSpot = barSpot;
                    final date =
                        DateTime.parse(localSortedAllDates[flSpot.x.toInt()]);
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
              horizontalInterval: (maxY - minY) / 4, // 정확히 4개 간격 = 5개 라벨
              getDrawingHorizontalLine: (value) {
                return const FlLine(
                  color: Color(0xFFE5E7EB),
                  strokeWidth: 0.5,
                );
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false), // Y축 범례 완전 제거
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 35,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    
                    if (value != index.toDouble() || index < 0 || index >= localSortedAllDates.length) {
                      return const SizedBox.shrink();
                    }
                    
                    bool shouldShowDate = false;
                    
                    if (dataPointCount <= 8) {
                      shouldShowDate = true;
                    } else {
                      if (index == 0 || index == localSortedAllDates.length - 1) {
                        shouldShowDate = true;
                      }
                      else if (index % dateInterval == 0) {
                        shouldShowDate = true;
                      }
                    }
                    
                    if (shouldShowDate) {
                      final date = DateTime.parse(localSortedAllDates[index]);
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
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: (localSortedAllDates.length - 1).toDouble(),
            minY: minY,
            maxY: maxY,
            lineBarsData: [
              // Fat data line
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
                    return _ValueDotPainter(
                      radius: 4,
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeColor: const Color(0xFFEF4444),
                      value: spot.y,
                      textColor: const Color(0xFFEF4444),
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
            ),
          ),
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

  void _showPhotoTooltip(BuildContext context, List<BodyImageResponse> images,
      String date, double xPosition) {
    final overlay = Overlay.of(context);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _PhotoTooltip(
        images: images,
        date: date,
        xPosition: xPosition,
        onClose: () => overlayEntry?.remove(),
      ),
    );

    overlay.insert(overlayEntry);
  }

  // COMMENTED OUT - Original FatChart modal
  /*
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
  */
}

class _PhotoTooltip extends StatelessWidget {
  final List<BodyImageResponse> images;
  final String date;
  final double xPosition;
  final VoidCallback onClose;

  const _PhotoTooltip({
    required this.images,
    required this.date,
    required this.xPosition,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onClose,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Arrow pointing up to chart point
            Positioned(
              left: xPosition - 10,
              top: 150,
              child: CustomPaint(
                painter: _ArrowPainter(pointsUp: false, showOnLeft: false),
                size: const Size(20, 10),
              ),
            ),
            // Tooltip content centered
            Positioned(
              left: (screenWidth - 240) / 2,
              top: 160,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 240,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 120,
                        child: images.length == 1
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  images[0].fileUrl.startsWith('http')
                                      ? images[0].fileUrl
                                      : '${ApiConfig.imageBaseUrl}${images[0].fileUrl}',
                                  width: double.infinity,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: Icon(Icons.broken_image,
                                          size: 24, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        images[0].fileUrl.startsWith('http')
                                            ? images[0].fileUrl
                                            : '${ApiConfig.imageBaseUrl}${images[0].fileUrl}',
                                        height: 120,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          color: Colors.grey[200],
                                          child: const Center(
                                            child: Icon(Icons.broken_image,
                                                size: 24, color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (images.length > 1)
                                    const SizedBox(width: 4),
                                  if (images.length > 1)
                                    Expanded(
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '+${images.length - 1}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          // TODO: Show full modal when tooltip is tapped
                        },
                        child: Text(
                          '탭하여 전체보기',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final bool pointsUp;
  final bool showOnLeft;

  _ArrowPainter({required this.pointsUp, required this.showOnLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Path path = Path();

    if (pointsUp) {
      if (showOnLeft) {
        path.moveTo(size.width - 10, size.height);
        path.lineTo(size.width, 0);
        path.lineTo(size.width - 20, size.height);
      } else {
        path.moveTo(10, size.height);
        path.lineTo(0, 0);
        path.lineTo(20, size.height);
      }
    } else {
      if (showOnLeft) {
        path.moveTo(size.width - 10, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(size.width - 20, 0);
      } else {
        path.moveTo(10, 0);
        path.lineTo(0, size.height);
        path.lineTo(20, 0);
      }
    }

    path.close();
    canvas.drawPath(path, paint);

    // Draw shadow
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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
