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
                height: 190, // 150 + 40 for timeline
                child: WeightChart(
                  compositions: compositions, 
                  bodyImages: bodyImages,
                  sortedAllDates: localSortedAllDates,
                  imagesByDate: localImagesByDate,
                ),
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
                  compositions: compositions, 
                  bodyImages: bodyImages,
                  sortedAllDates: localSortedAllDates,
                  imagesByDate: localImagesByDate,
                ),
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

    final sortedData = List<BodyComposition>.from(compositions)
      ..sort((a, b) => a.measurementDate.compareTo(b.measurementDate));

    // Use provided unified data or create fallback
    final Map<String, List<BodyImageResponse>> localImagesByDate = imagesByDate ?? {};
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
    
    // Create spots for muscle data only
    final spots = <FlSpot>[];
    final List<int> photoDates = []; // Store indices of dates with photos
    
    for (int i = 0; i < localSortedAllDates.length; i++) {
      final date = localSortedAllDates[i];
      
      // Check if there's muscle data for this date
      final muscleData = sortedData.where((comp) => 
        comp.measurementDate.split('T')[0] == date).firstOrNull;
      
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

    if (maxY - minY < 2) {
      double center = (minY + maxY) / 2;
      minY = center - 1;
      maxY = center + 1;
    }

    return Container(
      width: MediaQuery.of(context).size.width - 48, // 24 padding * 2
      height: 150,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
            if (event is FlTapUpEvent && touchResponse != null && touchResponse.lineBarSpots != null) {
              for (var spot in touchResponse.lineBarSpots!) {
                if (spot.x.toInt() >= 0 && spot.x.toInt() < localSortedAllDates.length) {
                  final dateString = localSortedAllDates[spot.x.toInt()];
                  // Show photo dialog if photos exist (regardless of whether it's muscle or photo point)
                  if (localImagesByDate.containsKey(dateString)) {
                    _showPhotoDialog(context, localImagesByDate[dateString]!, dateString);
                    break;
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
              reservedSize: 35,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < localSortedAllDates.length) {
                  final date = DateTime.parse(localSortedAllDates[value.toInt()]);
                  return Text(
                    DateFormat('MM/dd').format(date),
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
              interval: localSortedAllDates.length > 7
                  ? (localSortedAllDates.length / 7).ceil().toDouble()
                  : 1,
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
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: const Color(0xFF3B82F6),
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

  void _showPhotoTooltip(BuildContext context, List<BodyImageResponse> images, String date, double xPosition) {
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

    final sortedData = List<BodyComposition>.from(compositions)
      ..sort((a, b) => a.measurementDate.compareTo(b.measurementDate));

    // Use provided unified data or create fallback
    final Map<String, List<BodyImageResponse>> localImagesByDate = imagesByDate ?? {};
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
    
    // Create spots for fat data only
    final spots = <FlSpot>[];
    
    for (int i = 0; i < localSortedAllDates.length; i++) {
      final date = localSortedAllDates[i];
      
      // Check if there's fat data for this date
      final fatData = sortedData.where((comp) => 
        comp.measurementDate.split('T')[0] == date).firstOrNull;
      
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

    if (maxY - minY < 1) {
      double center = (minY + maxY) / 2;
      minY = center - 0.5;
      maxY = center + 0.5;
    }
    

    return Container(
      width: MediaQuery.of(context).size.width - 48, // 24 padding * 2
      height: 150,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
              if (event is FlTapUpEvent && touchResponse != null && touchResponse.lineBarSpots != null) {
                for (var spot in touchResponse.lineBarSpots!) {
                  if (spot.x.toInt() >= 0 && spot.x.toInt() < localSortedAllDates.length) {
                    final dateString = localSortedAllDates[spot.x.toInt()];
                    // Show photo dialog if photos exist (regardless of whether it's fat or photo point)
                    if (localImagesByDate.containsKey(dateString)) {
                    _showPhotoDialog(context, localImagesByDate[dateString]!, dateString);
                    break;
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
                if (flSpot.x.toInt() >= 0 && flSpot.x.toInt() < localSortedAllDates.length) {
                  final dateString = localSortedAllDates[flSpot.x.toInt()];
                  final date = DateTime.parse(dateString);
                  
                  // Check which bar was touched (0 = fat, 1 = photo)
                  if (barSpot.barIndex == 0) {
                    // Fat point touched
                    return LineTooltipItem(
                      '${DateFormat('MM/dd').format(date)}\n${flSpot.y.toStringAsFixed(1)}kg',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    );
                  } else if (barSpot.barIndex == 1 && localImagesByDate.containsKey(dateString)) {
                    // Photo point touched
                    return LineTooltipItem(
                      '${DateFormat('MM/dd').format(date)}\n사진 ${localImagesByDate[dateString]!.length}장',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    );
                  }
                }
                return null;
              }).whereType<LineTooltipItem>().toList();
            },
          ),
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
              reservedSize: 35,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < localSortedAllDates.length) {
                  final date = DateTime.parse(localSortedAllDates[value.toInt()]);
                  return Text(
                    DateFormat('MM/dd').format(date),
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
              interval: localSortedAllDates.length > 7
                  ? (localSortedAllDates.length / 7).ceil().toDouble()
                  : 1,
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
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: const Color(0xFFEF4444),
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

  void _showPhotoTooltip(BuildContext context, List<BodyImageResponse> images, String date, double xPosition) {
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
                                        errorBuilder: (context, error, stackTrace) =>
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
                                  if (images.length > 1) const SizedBox(width: 4),
                                  if (images.length > 1)
                                    Expanded(
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(8),
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