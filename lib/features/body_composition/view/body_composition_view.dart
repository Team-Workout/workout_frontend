import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/config/api_config.dart';
import '../../../core/services/api_service.dart';
import '../../../services/image_cache_manager.dart';
import '../model/body_composition_model.dart';
import '../model/body_image_model.dart';
import '../viewmodel/body_composition_viewmodel.dart';
import '../../../core/theme/notion_colors.dart';
import '../../dashboard/widgets/notion_button.dart';
import '../widget/body_stats_card.dart';
import '../widget/body_profile_section.dart';
import '../widget/combined_progress_section.dart';
import '../widget/date_range_display.dart';
import '../widget/date_range_selector.dart';
import '../widget/weight_trend_section.dart';
import '../widget/custom_date_picker.dart';

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
      final startDate = dateRange.startDate.toIso8601String().split('T')[0];
      final endDate = dateRange.endDate.toIso8601String().split('T')[0];

      // 체성분 데이터 로드
      ref.read(bodyCompositionNotifierProvider.notifier).loadBodyCompositions(
            startDate: startDate,
            endDate: endDate,
          );

      // 몸 사진 데이터 로드
      ref.read(bodyImageNotifierProvider.notifier).loadBodyImages(
            startDate: startDate,
            endDate: endDate,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bodyStats = ref.watch(bodyStatsProvider);
    final bodyCompositions = ref.watch(bodyCompositionListProvider);

    // dateRangeProvider 변경사항 실시간 감지
    ref.listen<DateRange>(dateRangeProvider, (previous, next) {
      if (previous?.startDate != next.startDate ||
          previous?.endDate != next.endDate) {
        final startDate = next.startDate.toIso8601String().split('T')[0];
        final endDate = next.endDate.toIso8601String().split('T')[0];

        // 체성분 데이터 재로드
        ref.read(bodyCompositionNotifierProvider.notifier).loadBodyCompositions(
              startDate: startDate,
              endDate: endDate,
            );

        // 몸 사진 데이터 재로드
        ref.read(bodyImageNotifierProvider.notifier).loadBodyImages(
              startDate: startDate,
              endDate: endDate,
            );
      }
    });

    return Scaffold(
      backgroundColor: NotionColors.gray50,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF10B981), Color(0xFF34D399), Color(0xFF6EE7B7)],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          '체성분 분석',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: Container(
          //     padding: const EdgeInsets.all(8),
          //     decoration: BoxDecoration(
          //       color: Colors.white.withOpacity(0.2),
          //       borderRadius: BorderRadius.circular(10),
          //       border: Border.all(color: Colors.white.withOpacity(0.3)),
          //     ),
          //     child: const Icon(Icons.calendar_today,
          //         color: Colors.white, size: 20),
          //   ),
          //   onPressed: () => _showDateRangePickerDialog(),
          // ),
        ],
      ),
      body: bodyCompositions.when(
        data: (compositions) {
          if (compositions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_available,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '체성분 데이터가 없습니다',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '하단의 데이터 추가 버튼을 눌러\n체성분을 기록해보세요!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'IBMPlexSansKR',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DateRangeDisplay(
                  //   onShowDatePicker: _showDateRangePickerDialog,
                  // ),
                  const DateRangeSelector(),
                  const SizedBox(height: 16),
                  // BodyProfileSection(compositions: compositions),
                  const SizedBox(height: 20),
                  BodyStatsCard(stats: bodyStats),
                  const SizedBox(height: 20),
                  // 체중변화 추이를 BMI 카드 바로 밑으로 이동
                  _buildWeightTrendWithImages(compositions),
                  const SizedBox(height: 24),
                  // CombinedProgressSection(compositions: compositions),
                  // 나의 변화 기록 관련 섹션들 주석 처리
                  // const SizedBox(height: 24),
                  // CombinedProgressSection(compositions: compositions),
                  // 체성분 구성 그래프 주석 처리
                  // const SizedBox(height: 24),
                  // _buildBodyCompositionChart(compositions),
                  // 체성분 데이터 목록 주석 처리
                  // const SizedBox(height: 24),
                  // BodyDataListSection(compositions: compositions),
                  const SizedBox(height: 24),
                  _buildBodyImagesSection(),
                  const SizedBox(height: 24),
                  // 더미 UI 제거
                  // const KeyMeasurementsSection(),
                  // const SizedBox(height: 24),
                  // const TrainerFeedbackSection(),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDataDialog(context),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: NotionColors.white,
        elevation: 2,
        icon: const Icon(Icons.add, size: 24),
        label: const Text(
          '데이터 추가',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
      ),
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

  Widget _buildWeightTrendWithImages(List<BodyComposition> compositions) {
    final bodyImagesAsync = ref.watch(bodyImagesProvider);

    return bodyImagesAsync.when(
      data: (bodyImages) {
        print(
            '_buildWeightTrendWithImages: bodyImages loaded, count = ${bodyImages.length}');
        return WeightTrendSection(
          compositions: compositions,
          bodyImages: bodyImages,
        );
      },
      loading: () {
        print('_buildWeightTrendWithImages: loading bodyImages');
        return WeightTrendSection(compositions: compositions);
      },
      error: (error, _) {
        print('_buildWeightTrendWithImages: error loading bodyImages: $error');
        return WeightTrendSection(compositions: compositions);
      },
    );
  }

  Widget _buildTimelineItem(Map<String, dynamic> item) {
    final date = item['date'] as DateTime;
    final type = item['type'] as String;
    final dateFormat = DateFormat('MM/dd');
    final timeFormat = DateFormat('HH:mm');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 날짜 및 시간
          SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFormat.format(date),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: NotionColors.black,
                  ),
                ),
                Text(
                  timeFormat.format(date),
                  style: TextStyle(
                    fontSize: 11,
                    color: NotionColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // 타임라인 라인
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: type == 'weight'
                      ? NotionColors.black
                      : NotionColors.gray500,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 40,
                color: NotionColors.border,
              ),
            ],
          ),
          const SizedBox(width: 12),
          // 내용
          Expanded(
            child: type == 'weight'
                ? _buildWeightTimelineCard(
                    item['data'] as BodyComposition, item['weight'] as double)
                : _buildPhotoTimelineCard(item['data'] as BodyImageResponse),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightTimelineCard(BodyComposition comp, double weight) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: NotionColors.gray100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: NotionColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.monitor_weight_outlined,
            color: NotionColors.black,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '체중 기록',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: NotionColors.black,
                  ),
                ),
                Text(
                  '${weight.toStringAsFixed(1)}kg',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: NotionColors.black,
                  ),
                ),
                Text(
                  '근육량: ${comp.muscleMassKg.toStringAsFixed(1)}kg',
                  style: TextStyle(
                    fontSize: 11,
                    color: NotionColors.gray500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoTimelineCard(BodyImageResponse image) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: NotionColors.gray100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: NotionColors.border,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 40,
              height: 40,
              color: NotionColors.gray200,
              child: FutureBuilder<Uint8List?>(
                future: _loadAuthenticatedBodyImage(image.fileUrl),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Image.memory(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return Icon(
                      Icons.photo_outlined,
                      color: NotionColors.gray500,
                      size: 20,
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '사진 기록',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: NotionColors.black,
                  ),
                ),
                Text(
                  image.originalFileName.isNotEmpty
                      ? image.originalFileName
                      : '몸 사진',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: NotionColors.black,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              final imageData =
                  await _loadAuthenticatedBodyImage(image.fileUrl);
              if (imageData != null) {
                _showBodyImageFullScreen(image, imageData);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.fullscreen,
                color: Color(0xFF6366F1),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniWeightChart(List<BodyComposition> compositions) {
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
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
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

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.timeline_outlined,
              color: Color(0xFF6366F1),
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '아직 기록이 없습니다',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '체중과 사진을 기록해서\n나의 변화를 확인해보세요!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showAllProgressHistory(List<Map<String, dynamic>> allData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '전체 변화 기록',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: allData.length,
                  itemBuilder: (context, index) =>
                      _buildTimelineItem(allData[index]),
                ),
              ),
            ],
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
                final date = DateTime.parse(
                    sortedData[flSpot.x.toInt()].measurementDate);
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
          horizontalInterval: (maxY - minY) / 5 > 0 ? (maxY - minY) / 5 : 1,
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
              interval: (maxY - minY) / 5 > 0 ? (maxY - minY) / 5 : 1,
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
                          color: const Color(0xFF6366F1),
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
                          color: const Color(0xFF10B981),
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

  Widget _buildDataListItem(BodyComposition composition) {
    final dateFormat = DateFormat('yyyy년 MM월 dd일');
    final bodyFatPercentage = (composition.fatKg / composition.weightKg) * 100;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFormat
                      .format(DateTime.parse(composition.measurementDate)),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1F36),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildDataPoint(
                        '체중',
                        '${composition.weightKg.toStringAsFixed(1)}kg',
                        Icons.monitor_weight,
                      ),
                    ),
                    Expanded(
                      child: _buildDataPoint(
                        '체지방',
                        '${bodyFatPercentage.toStringAsFixed(1)}%',
                        Icons.pie_chart,
                      ),
                    ),
                    Expanded(
                      child: _buildDataPoint(
                        '근육량',
                        '${composition.muscleMassKg.toStringAsFixed(1)}kg',
                        Icons.fitness_center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => _showDeleteConfirmDialog(composition),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 20,
              ),
            ),
            tooltip: '삭제',
          ),
        ],
      ),
    );
  }

  Widget _buildDataPoint(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1F36),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmDialog(BodyComposition composition) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('데이터 삭제'),
        content: Text(
          '${DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(composition.measurementDate))}의 체성분 데이터를 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없습니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          NotionButton(
            text: '삭제',
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref
                    .read(bodyCompositionNotifierProvider.notifier)
                    .deleteBodyComposition(composition.id);

                // Refresh the data
                final dateRange = ref.read(dateRangeProvider);
                await ref
                    .read(bodyCompositionNotifierProvider.notifier)
                    .loadBodyCompositions(
                      startDate:
                          dateRange.startDate.toIso8601String().split('T')[0],
                      endDate:
                          dateRange.endDate.toIso8601String().split('T')[0],
                    );

                ref.invalidate(bodyCompositionListProvider);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('데이터가 성공적으로 삭제되었습니다'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('삭제 중 오류 발생: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  // void _showDateRangePickerDialog() async {
  //   final DateTimeRange? picked = await showDateRangePicker(
  //     context: context,
  //     firstDate: DateTime(2020),
  //     lastDate: DateTime.now(),
  //     initialDateRange: DateTimeRange(
  //       start: ref.read(dateRangeProvider).startDate,
  //       end: ref.read(dateRangeProvider).endDate,
  //     ),
  //     locale: const Locale('ko', 'KR'),
  //     builder: (context, child) {
  //       return Theme(
  //         data: Theme.of(context).copyWith(
  //           colorScheme: const ColorScheme.light(
  //             primary: Color(0xFF10B981),
  //             onPrimary: Colors.white,
  //             surface: Colors.white,
  //             onSurface: Colors.black,
  //             secondary: Color(0xFF34D399),
  //             onSecondary: Colors.white,
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );

  //   if (picked != null) {
  //     ref.read(dateRangeProvider.notifier).updateDateRange(
  //           picked.start,
  //           picked.end,
  //         );

  //     final startDate = picked.start.toIso8601String().split('T')[0];
  //     final endDate = picked.end.toIso8601String().split('T')[0];

  //     // 체성분 데이터 새로고침
  //     ref.read(bodyCompositionNotifierProvider.notifier).loadBodyCompositions(
  //           startDate: startDate,
  //           endDate: endDate,
  //         );

  //     // 몸 사진 데이터 새로고침
  //     ref.read(bodyImageNotifierProvider.notifier).loadBodyImages(
  //           startDate: startDate,
  //           endDate: endDate,
  //         );

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           '날짜 범위 업데이트: ${DateFormat('MM/dd').format(picked.start)} - ${DateFormat('MM/dd').format(picked.end)}',
  //         ),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   }
  // }

  void _showAddDataDialog(BuildContext context) {
    final weightController = TextEditingController();
    final fatController = TextEditingController();
    final muscleController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with gradient background
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF34D399)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.add_chart,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            '체성분 데이터 추가',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content section
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF10B981).withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: const Color(0xFF10B981)
                                    .withValues(alpha: 0.2)),
                          ),
                          child: TextField(
                            controller: weightController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: '체중 (kg)',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(20),
                              labelStyle: TextStyle(
                                  color: Color(0xFF10B981),
                                  fontWeight: FontWeight.w600),
                              prefixIcon: Icon(Icons.monitor_weight,
                                  color: Color(0xFF10B981)),
                              hintText: '예: 70.5',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF10B981).withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: const Color(0xFF10B981)
                                    .withValues(alpha: 0.2)),
                          ),
                          child: TextField(
                            controller: fatController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: '체지방 (kg)',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(20),
                              labelStyle: TextStyle(
                                  color: Color(0xFF10B981),
                                  fontWeight: FontWeight.w600),
                              prefixIcon: Icon(Icons.fitness_center,
                                  color: Color(0xFF10B981)),
                              hintText: '예: 15.2',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF10B981).withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: const Color(0xFF10B981)
                                    .withValues(alpha: 0.2)),
                          ),
                          child: TextField(
                            controller: muscleController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: '근육량 (kg)',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(20),
                              labelStyle: TextStyle(
                                  color: Color(0xFF10B981),
                                  fontWeight: FontWeight.w600),
                              prefixIcon: Icon(Icons.health_and_safety,
                                  color: Color(0xFF10B981)),
                              hintText: '예: 50.3',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            final picked = await showCustomDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981)
                                  .withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: const Color(0xFF10B981)
                                      .withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    color: Color(0xFF10B981)),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '측정 날짜',
                                        style: TextStyle(
                                          color: Color(0xFF10B981),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat('yyyy년 MM월 dd일')
                                            .format(selectedDate),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right,
                                    color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Save button
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF34D399)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10B981)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () async {
                                  if (weightController.text.isNotEmpty &&
                                      fatController.text.isNotEmpty &&
                                      muscleController.text.isNotEmpty) {
                                    try {
                                      await ref
                                          .read(bodyCompositionNotifierProvider
                                              .notifier)
                                          .addBodyComposition(
                                            weightKg: double.parse(
                                                weightController.text),
                                            fatKg: double.parse(
                                                fatController.text),
                                            muscleMassKg: double.parse(
                                                muscleController.text),
                                            measurementDate:
                                                DateFormat('yyyy-MM-dd')
                                                    .format(selectedDate),
                                          );

                                      // Refresh the data with current date range
                                      final dateRange =
                                          ref.read(dateRangeProvider);
                                      await ref
                                          .read(bodyCompositionNotifierProvider
                                              .notifier)
                                          .loadBodyCompositions(
                                            startDate: dateRange.startDate
                                                .toIso8601String()
                                                .split('T')[0],
                                            endDate: dateRange.endDate
                                                .toIso8601String()
                                                .split('T')[0],
                                          );

                                      // Also invalidate the FutureProvider to refresh the data
                                      ref.invalidate(
                                          bodyCompositionListProvider);

                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              '데이터가 성공적으로 추가되었습니다',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            backgroundColor:
                                                const Color(0xFF10B981),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            margin: const EdgeInsets.all(16),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('오류가 발생했습니다: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('모든 필드를 입력해주세요'),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 18),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.save,
                                          color: Colors.white, size: 24),
                                      SizedBox(width: 12),
                                      Text(
                                        '데이터 저장',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
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

  Widget _buildBodyImagesSection() {
    final bodyImagesAsync = ref.watch(bodyImagesProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
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
                '몸사진 기록',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1F36),
                  letterSpacing: -0.5,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF34D399)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _showBodyImageUploadDialog(),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            '사진 추가',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          bodyImagesAsync.when(
            data: (images) {
              if (images.isEmpty) {
                return Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_camera_outlined,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '아직 등록된 몸사진이 없습니다',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              // 날짜별로 그룹화
              final groupedImages = <String, List<BodyImageResponse>>{};
              for (final image in images) {
                groupedImages
                    .putIfAbsent(image.recordDate, () => [])
                    .add(image);
              }

              final sortedDates = groupedImages.keys.toList()
                ..sort((a, b) => b.compareTo(a)); // 최신 날짜부터

              return Column(
                children: sortedDates.map((date) {
                  final imagesForDate = groupedImages[date]!;
                  return _buildDateImageGroup(date, imagesForDate);
                }).toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                '몸사진을 불러오는데 실패했습니다: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateImageGroup(String date, List<BodyImageResponse> images) {
    final formattedDate =
        DateFormat('yyyy년 M월 d일').format(DateTime.parse(date));

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formattedDate,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return _buildBodyImageItem(images[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyImageItem(BodyImageResponse image) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FutureBuilder<String?>(
              future: ImageCacheManager().getCachedImage(
                imageUrl: image.fileUrl,
                cacheKey: 'body_${image.fileId}',
                type: ImageType.body,
              ),
              builder: (context, cacheSnapshot) {
                if (cacheSnapshot.hasData && cacheSnapshot.data != null) {
                  // 캐시된 이미지가 있으면 파일로 로드
                  return GestureDetector(
                    onTap: () {
                      final cachedFile = File(cacheSnapshot.data!);
                      cachedFile.readAsBytes().then((bytes) {
                        _showBodyImageFullScreen(image, bytes);
                      });
                    },
                    child: Image.file(
                      File(cacheSnapshot.data!),
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  );
                }
                // 캐시가 없으면 기존 방식으로 로드
                return FutureBuilder<Uint8List?>(
                  future: _loadAuthenticatedBodyImage(image.fileUrl),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }

                    if (snapshot.hasData && snapshot.data != null) {
                      // 이미지를 캐시에 저장
                      ImageCacheManager().updateCachedImage(
                        imageUrl: image.fileUrl,
                        cacheKey: 'body_${image.fileId}',
                        type: ImageType.body,
                      );
                      return GestureDetector(
                        onTap: () =>
                            _showBodyImageFullScreen(image, snapshot.data!),
                        child: Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      );
                    }

                    return Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // 삭제 버튼
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _showDeleteImageDialog(image),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List?> _loadAuthenticatedBodyImage(String imageUrl) async {
    try {
      // 상대 경로인 경우 baseUrl을 붙여서 완전한 URL로 만들기
      String fullImageUrl = imageUrl;
      if (!imageUrl.startsWith('http')) {
        final baseUrl = ApiConfig.baseUrl.replaceAll('/api', '');
        fullImageUrl =
            '$baseUrl${imageUrl.startsWith('/') ? '' : '/'}$imageUrl';
      }

      final dio = ref.read(dioProvider);
      final response = await dio.get(
        fullImageUrl,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      return Uint8List.fromList(response.data);
    } catch (e) {
      print('Failed to load body image: $e');

      // 인증 실패 시 일반 HTTP 클라이언트로 시도
      try {
        String fullImageUrl = imageUrl;
        if (!imageUrl.startsWith('http')) {
          final baseUrl = ApiConfig.baseUrl.replaceAll('/api', '');
          fullImageUrl =
              '$baseUrl${imageUrl.startsWith('/') ? '' : '/'}$imageUrl';
        }

        final response = await HttpClient().getUrl(Uri.parse(fullImageUrl));
        final httpResponse = await response.close();
        if (httpResponse.statusCode == 200) {
          final bytes = await consolidateHttpClientResponseBytes(httpResponse);
          return bytes;
        }
      } catch (fallbackError) {
        print('Fallback body image loading also failed: $fallbackError');
      }

      return null;
    }
  }

  void _showBodyImageUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => _BodyImageUploadDialog(),
    );
  }

  void _showBodyImageFullScreen(BodyImageResponse image, Uint8List imageData) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    imageData,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '촬영일: ${DateFormat('yyyy년 M월 d일').format(DateTime.parse(image.recordDate))}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (image.originalFileName.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '파일명: ${image.originalFileName}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteImageDialog(BodyImageResponse image) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 320,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          '사진 삭제',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        '정말로 이 사진을 삭제하시겠습니까?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '삭제된 사진은 복구할 수 없습니다.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // Buttons
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                  color: Colors.grey.withValues(alpha: 0.3)),
                            ),
                          ),
                          child: Text(
                            '취소',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.red, Color(0xFFDC2626)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () async {
                                Navigator.of(context).pop();
                                await _deleteBodyImage(image);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.delete,
                                        color: Colors.white, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      '삭제',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteBodyImage(BodyImageResponse image) async {
    try {
      // 캐시에서도 이미지 삭제
      await ImageCacheManager().clearCachedImage(
        cacheKey: 'body_${image.fileId}',
        type: ImageType.body,
      );
      await ref
          .read(bodyImageNotifierProvider.notifier)
          .deleteBodyImage(image.fileId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('사진이 성공적으로 삭제되었습니다.'),
            backgroundColor: Colors.green,
          ),
        );

        // 목록 새로고침
        ref.invalidate(bodyImagesProvider);
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = '사진 삭제에 실패했습니다';

        if (e.toString().contains('인증되지 않은')) {
          errorMessage = '로그인이 필요합니다.';
        } else if (e.toString().contains('권한이 없습니다')) {
          errorMessage = '해당 사진을 삭제할 권한이 없습니다.';
        } else if (e.toString().contains('존재하지 않는')) {
          errorMessage = '존재하지 않는 사진입니다.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _BodyImageUploadDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<_BodyImageUploadDialog> createState() =>
      _BodyImageUploadDialogState();
}

class _BodyImageUploadDialogState
    extends ConsumerState<_BodyImageUploadDialog> {
  List<XFile> selectedImages = [];
  DateTime selectedDate = DateTime.now();
  final ImagePicker _picker = ImagePicker();
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(maxWidth: 450),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with gradient background
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF34D399)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          '몸사진 업로드',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content section
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 날짜 선택
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF10B981).withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: const Color(0xFF10B981)
                                  .withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    color: Color(0xFF10B981)),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    '촬영 날짜',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF374151),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    DateFormat('yyyy년 M월 d일')
                                        .format(selectedDate),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF10B981), Color(0xFF34D399)],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF10B981).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () async {
                                        final date = await showCustomDatePicker(
                                          context: context,
                                          initialDate: selectedDate,
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                        );
                                        if (date != null) {
                                          setState(() {
                                            selectedDate = date;
                                          });
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.edit, color: Colors.white, size: 16),
                                            SizedBox(width: 4),
                                            Text(
                                              '변경',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 이미지 선택 버튼들
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF10B981), Color(0xFF34D399)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF10B981).withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () => _pickImages(ImageSource.camera),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.camera_alt,
                                              color: Color(0xFF10B981), size: 20),
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          '카메라',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6366F1).withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () => _pickImages(ImageSource.gallery),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.photo_library,
                                              color: Color(0xFF6366F1), size: 20),
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          '갤러리',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 선택된 이미지 미리보기
                      if (selectedImages.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '선택된 이미지',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            FutureBuilder<double>(
                              future: _calculateTotalSize(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final totalMB = snapshot.data!;
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: totalMB > 20
                                          ? Colors.red.withOpacity(0.1)
                                          : totalMB > 10
                                              ? Colors.orange.withOpacity(0.1)
                                              : Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '총 ${totalMB.toStringAsFixed(1)}MB',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: totalMB > 20
                                            ? Colors.red
                                            : totalMB > 10
                                                ? Colors.orange
                                                : Colors.green,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: selectedImages.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 80,
                                margin: const EdgeInsets.only(right: 8),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              File(selectedImages[index].path),
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedImages
                                                      .removeAt(index);
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    FutureBuilder<double>(
                                      future:
                                          _getImageSize(selectedImages[index]),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            '${snapshot.data!.toStringAsFixed(1)}MB',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey[600],
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // 액션 버튼들
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: isUploading
                                ? null
                                : () => Navigator.of(context).pop(),
                            child: const Text('취소'),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              gradient: isUploading || selectedImages.isEmpty
                                  ? null
                                  : const LinearGradient(
                                      colors: [
                                        Color(0xFF10B981),
                                        Color(0xFF059669)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                              color: isUploading || selectedImages.isEmpty
                                  ? Colors.grey[300]
                                  : null,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: isUploading || selectedImages.isEmpty
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: const Color(0xFF10B981)
                                            .withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: isUploading || selectedImages.isEmpty
                                    ? null
                                    : _uploadImages,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (isUploading) ...[
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          '업로드 중...',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ] else ...[
                                        Icon(
                                          Icons.add,
                                          color: selectedImages.isEmpty
                                              ? Colors.grey[600]
                                              : Colors.white,
                                          size: 22,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '추가',
                                          style: TextStyle(
                                            color: selectedImages.isEmpty
                                                ? Colors.grey[600]
                                                : Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }

  Future<void> _pickImages(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        // 갤러리에서 여러 이미지 선택 (더 강한 압축)
        final images = await _picker.pickMultiImage(
          imageQuality: 40, // 이미지 품질을 40%로 강력 압축
        );
        if (images.isNotEmpty) {
          // 파일 크기 확인 및 필터링
          final validImages = <XFile>[];
          for (final image in images) {
            final file = File(image.path);
            final fileSizeInMB = await file.length() / (1024 * 1024); // MB 단위

            print(
                'Gallery image: ${image.name}, Size: ${fileSizeInMB.toStringAsFixed(2)}MB');

            if (fileSizeInMB > 1) {
              // 1MB 제한으로 더욱 강화
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          '${image.name}은(는) 크기가 1MB를 초과합니다 (${fileSizeInMB.toStringAsFixed(1)}MB)')),
                );
              }
            } else {
              validImages.add(image);
            }
          }

          if (validImages.isNotEmpty) {
            setState(() {
              selectedImages.addAll(validImages);
            });
          }
        }
      } else {
        // 카메라에서 한 장 촬영 (매우 강한 압축 적용)
        final image = await _picker.pickImage(
          source: source,
          imageQuality: 30, // 카메라 이미지는 30% 품질로 매우 강력 압축
          maxWidth: 1024, // 최대 너비 1024px로 축소
          maxHeight: 1024, // 최대 높이 1024px로 축소
        );
        if (image != null) {
          final file = File(image.path);
          final fileSizeInMB = await file.length() / (1024 * 1024);

          print(
              'Camera image: ${image.name}, Size: ${fileSizeInMB.toStringAsFixed(2)}MB');

          if (fileSizeInMB > 1) {
            // 1MB 제한
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        '촬영된 이미지가 1MB를 초과합니다 (${fileSizeInMB.toStringAsFixed(1)}MB)')),
              );
            }
          } else {
            setState(() {
              selectedImages.add(image);
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미지 선택에 실패했습니다: $e')),
        );
      }
    }
  }

  Future<void> _uploadImages() async {
    if (selectedImages.isEmpty) return;

    // 업로드 전 전체 크기 체크
    double totalSizeInMB = 0;
    for (final image in selectedImages) {
      final file = File(image.path);
      final sizeInMB = await file.length() / (1024 * 1024);
      totalSizeInMB += sizeInMB;
    }

    // 총 크기가 20MB를 초과하면 경고
    if (totalSizeInMB > 20) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '선택된 이미지들의 총 크기가 ${totalSizeInMB.toStringAsFixed(1)}MB입니다. 20MB 이하로 줄여주세요.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      final dateString = selectedDate.toIso8601String().split('T')[0];

      // 개별 이미지 크기 확인 및 로그
      for (int i = 0; i < selectedImages.length; i++) {
        final file = File(selectedImages[i].path);
        final sizeInMB = await file.length() / (1024 * 1024);
        print(
            'Image ${i + 1}: ${selectedImages[i].name}, Size: ${sizeInMB.toStringAsFixed(2)}MB');
      }

      print('Total upload size: ${totalSizeInMB.toStringAsFixed(2)}MB');

      await ref.read(bodyImageNotifierProvider.notifier).uploadBodyImages(
            images: selectedImages,
            date: dateString,
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('몸사진이 성공적으로 업로드되었습니다!'),
            backgroundColor: Colors.green,
          ),
        );

        // 목록 새로고침
        ref.invalidate(bodyImagesProvider);
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = '업로드에 실패했습니다';

        if (e.toString().contains('413')) {
          errorMessage = '파일 크기가 너무 큽니다. 더 작은 이미지를 선택하거나 압축해주세요.';
        } else if (e.toString().contains('Maximum upload size exceeded')) {
          errorMessage = '서버의 최대 업로드 크기를 초과했습니다. 이미지를 더 압축해주세요.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  Future<double> _getImageSize(XFile image) async {
    final file = File(image.path);
    final sizeInBytes = await file.length();
    return sizeInBytes / (1024 * 1024); // MB 단위로 변환
  }

  Future<double> _calculateTotalSize() async {
    double totalSize = 0;
    for (final image in selectedImages) {
      totalSize += await _getImageSize(image);
    }
    return totalSize;
  }
}
