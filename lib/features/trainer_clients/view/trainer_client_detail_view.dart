import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/trainer_client_model.dart';
import '../viewmodel/trainer_client_viewmodel.dart';
import '../../../services/image_cache_manager.dart';
import '../../body_composition/widget/weight_chart.dart';
import '../../body_composition/widget/mini_weight_chart.dart';
import '../../body_composition/widget/combined_progress_section.dart';
import '../../body_composition/model/body_composition_model.dart';
import '../../body_composition/viewmodel/body_composition_viewmodel.dart';
import '../../workout/widget/trainer_member_workout_stats_tab.dart';
import '../../workout/view/trainer_routine_create_view.dart';

class TrainerClientDetailView extends ConsumerStatefulWidget {
  final TrainerClient client;

  const TrainerClientDetailView({
    super.key,
    required this.client,
  });

  @override
  ConsumerState<TrainerClientDetailView> createState() =>
      _TrainerClientDetailViewState();
}

class _TrainerClientDetailViewState
    extends ConsumerState<TrainerClientDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _startDate = '';
  String _endDate = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // 기본적으로 최근 3개월 데이터를 조회
    final now = DateTime.now();
    final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
    _startDate = _formatDate(threeMonthsAgo);
    _endDate = _formatDate(now);

    // 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _loadData() {
    // 체성분 데이터 로드
    ref
        .read(memberBodyCompositionsProvider(widget.client.memberId).notifier)
        .loadBodyCompositions(
          startDate: _startDate,
          endDate: _endDate,
        );

    // 몸 사진 데이터 로드
    ref
        .read(memberBodyImagesProvider(widget.client.memberId).notifier)
        .loadBodyImages(
          startDate: _startDate,
          endDate: _endDate,
        );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.parse(_startDate),
        end: DateTime.parse(_endDate),
      ),
    );

    if (picked != null) {
      setState(() {
        _startDate = _formatDate(picked.start);
        _endDate = _formatDate(picked.end);
      });
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.client.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range, color: Colors.black),
            onPressed: _selectDateRange,
            tooltip: '기간 선택',
          ),
        ],
      ),
      body: Column(
        children: [
          // 회원 정보 헤더
          _buildMemberHeader(),

          // 탭 바
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.black,
              tabs: const [
                Tab(text: '체성분'),
                Tab(text: '사진'),
                Tab(text: '분석'),
                Tab(text: '루틴'),
              ],
            ),
          ),

          // 탭 뷰
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBodyCompositionTab(),
                _buildBodyImagesTab(),
                _buildWorkoutAnalysisTab(),
                _buildRoutineTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberHeader() {
    return FutureBuilder<String?>(
      future: widget.client.profileImageUrl != null &&
              widget.client.profileImageUrl!.isNotEmpty
          ? ImageCacheManager().getCachedImage(
              imageUrl: widget.client.profileImageUrl!,
              cacheKey: 'member_${widget.client.memberId}',
              type: ImageType.profile,
            )
          : Future.value(null),
      builder: (context, snapshot) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue[100],
                backgroundImage: snapshot.hasData && snapshot.data != null
                    ? FileImage(File(snapshot.data!))
                    : null,
                child: snapshot.hasData && snapshot.data != null
                    ? null
                    : Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.blue[600],
                      ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.client.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.client.email ?? '이메일 정보 없음',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: widget.client.gender == 'MALE'
                                ? Colors.blue[100]
                                : Colors.pink[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.client.gender == 'MALE' ? '남성' : '여성',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: widget.client.gender == 'MALE'
                                  ? Colors.blue[700]
                                  : Colors.pink[700],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.client.gymName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '$_startDate\n~\n$_endDate',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBodyCompositionTab() {
    final compositionsState =
        ref.watch(memberBodyCompositionsProvider(widget.client.memberId));

    return compositionsState.when(
      data: (compositionsResponse) {
        final compositions = compositionsResponse.data;

        if (compositions.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  '선택한 기간에 체성분 데이터가 없습니다',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // BodyComposition 타입으로 변환
        final bodyCompositions = compositions
            .map((comp) => BodyComposition(
                  id: comp.id,
                  member: {
                    'id': widget.client.memberId,
                    'name': widget.client.name,
                    'email': widget.client.email,
                  },
                  measurementDate: comp.measurementDate,
                  weightKg: comp.weightKg ?? 0.0,
                  fatKg: comp.fatKg ?? 0.0,
                  muscleMassKg: comp.muscleMassKg ?? 0.0,
                ))
            .toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 체중 변화 그래프
              _buildSingleChart(
                title: '체중 변화 추이',
                data: bodyCompositions.map((comp) => comp.weightKg).toList(),
                unit: 'kg',
                color: const Color(0xFF10B981),
                dates: bodyCompositions
                    .map((comp) => DateTime.parse(comp.measurementDate))
                    .toList(),
              ),
              const SizedBox(height: 24),

              // 근육량 변화 그래프
              _buildSingleChart(
                title: '근육량 변화 추이',
                data:
                    bodyCompositions.map((comp) => comp.muscleMassKg).toList(),
                unit: 'kg',
                color: const Color(0xFF3B82F6),
                dates: bodyCompositions
                    .map((comp) => DateTime.parse(comp.measurementDate))
                    .toList(),
              ),
              const SizedBox(height: 24),

              // 체지방량 변화 그래프
              _buildSingleChart(
                title: '체지방량 변화 추이',
                data: bodyCompositions.map((comp) => comp.fatKg).toList(),
                unit: 'kg',
                color: const Color(0xFFF59E0B),
                dates: bodyCompositions
                    .map((comp) => DateTime.parse(comp.measurementDate))
                    .toList(),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildPrivacyErrorView(
        icon: Icons.analytics_outlined,
        title: '체성분 데이터를 확인할 수 없습니다',
        message: '${widget.client.name}님이 체성분 데이터 공개를 허용하지 않았습니다',
        error: error,
      ),
    );
  }

  Widget _buildSingleChart({
    required String title,
    required List<double> data,
    required String unit,
    required Color color,
    required List<DateTime> dates,
  }) {
    if (data.length < 2) {
      return Container(
        height: 250,
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: Center(
                child: Text(
                  '데이터가 부족합니다',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final spots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();

    final minValue = data.reduce((a, b) => a < b ? a : b);
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;
    final padding = range * 0.1;

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey[200]!,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}$unit',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'IBMPlexSansKR'),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < dates.length) {
                          final date = dates[value.toInt()];
                          return Text(
                            '${date.month}/${date.day}',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                                fontFamily: 'IBMPlexSansKR'),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minY: minValue - padding,
                maxY: maxValue + padding,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: color,
                          strokeColor: Colors.white,
                          strokeWidth: 2,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyImagesTab() {
    final imagesState =
        ref.watch(memberBodyImagesProvider(widget.client.memberId));

    return imagesState.when(
      data: (imagesResponse) {
        final images = imagesResponse.data;

        if (images.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  '선택한 기간에 몸 사진이 없습니다',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final sortedImages = [...images]..sort((a, b) =>
            DateTime.parse(b.recordDate)
                .compareTo(DateTime.parse(a.recordDate)));

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: sortedImages.length,
          itemBuilder: (context, index) {
            final image = sortedImages[index];
            return _buildImageCard(image);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildPrivacyErrorView(
        icon: Icons.photo_outlined,
        title: '몸 사진을 확인할 수 없습니다',
        message: '${widget.client.name}님이 몸 사진 공개를 허용하지 않았습니다',
        error: error,
      ),
    );
  }

  Widget _buildImageCard(MemberBodyImage image) {
    final date = DateTime.parse(image.recordDate);

    // 상대 경로를 절대 경로로 변환
    final fullImageUrl = image.fileUrl.startsWith('http')
        ? image.fileUrl
        : 'http://211.220.34.173${image.fileUrl}';

    return FutureBuilder<String?>(
      future: ImageCacheManager().getCachedImage(
        imageUrl: fullImageUrl,
        cacheKey: 'body_${image.fileId}',
        type: ImageType.body,
      ),
      builder: (context, snapshot) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: snapshot.hasData && snapshot.data != null
                        ? Image.file(
                            File(snapshot.data!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildImagePlaceholder();
                            },
                          )
                        : snapshot.connectionState == ConnectionState.waiting
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    const Color(0xFF10B981),
                                  ),
                                  strokeWidth: 2,
                                ),
                              )
                            : _buildImagePlaceholder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Color(0xFF10B981),
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      image.originalFileName ?? '몸 사진',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'IBMPlexSansKR',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.photo_camera_outlined,
                size: 32,
                color: const Color(0xFF10B981).withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '사진 없음',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyErrorView({
    required IconData icon,
    required String title,
    required String message,
    required Object error,
  }) {
    // 403 에러인지 확인
    final isPrivacyError = error.toString().contains('접근히 허용되지 않습니다') ||
        error.toString().contains('NOT_ALLOWED') ||
        error.toString().contains('403');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isPrivacyError
                    ? const Color(0xFFF59E0B).withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                isPrivacyError ? Icons.lock_outline : Icons.error_outline,
                size: 64,
                color:
                    isPrivacyError ? const Color(0xFFF59E0B) : Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isPrivacyError ? title : '데이터를 불러오는데 실패했습니다',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: 'IBMPlexSansKR',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isPrivacyError ? message : '네트워크 연결을 확인하고 다시 시도해주세요',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'IBMPlexSansKR',
              ),
              textAlign: TextAlign.center,
            ),
            if (isPrivacyError) ...[
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: const Color(0xFF10B981),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '개인정보 보호 설정에 의해 제한됩니다',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF10B981),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutAnalysisTab() {
    return TrainerMemberWorkoutStatsTab(
      memberId: widget.client.memberId,
      memberName: widget.client.name,
    );
  }

  Widget _buildRoutineTab() {
    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          // 루틴 생성 버튼
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: ElevatedButton.icon(
              onPressed: () {
                _navigateToCreateRoutine();
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                '새 루틴 만들기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          // 기존 루틴 목록 (향후 구현 가능)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.fitness_center_outlined,
                      size: 64,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '${widget.client.name}님을 위한 루틴',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '위의 버튼을 눌러 새로운 루틴을 만들어보세요',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'IBMPlexSansKR',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCreateRoutine() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainerRoutineCreateView(
          memberId: widget.client.memberId,
          memberName: widget.client.name,
        ),
      ),
    );
  }

  Widget _buildWorkoutStatsCard() {
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '운동 통계',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '이번 주 운동',
                  '4회',
                  Icons.fitness_center,
                  const Color(0xFF10B981),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '평균 운동시간',
                  '75분',
                  Icons.timer,
                  const Color(0xFF3B82F6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '총 운동일수',
                  '42일',
                  Icons.calendar_today,
                  const Color(0xFFF59E0B),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '달성률',
                  '85%',
                  Icons.trending_up,
                  const Color(0xFFEC4899),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutFrequencyChart() {
    return Container(
      height: 250,
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '주간 운동 빈도',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBarChart('월', 3, const Color(0xFF10B981)),
                _buildBarChart('화', 2, const Color(0xFF3B82F6)),
                _buildBarChart('수', 4, const Color(0xFFF59E0B)),
                _buildBarChart('목', 1, const Color(0xFFEC4899)),
                _buildBarChart('금', 3, const Color(0xFF8B5CF6)),
                _buildBarChart('토', 2, const Color(0xFF06B6D4)),
                _buildBarChart('일', 1, const Color(0xFFEF4444)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(String day, int count, Color color) {
    const maxHeight = 120.0;
    final height = (count / 5) * maxHeight;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 24,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
      ],
    );
  }

  Widget _buildMuscleGroupAnalysis() {
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '운동 부위별 분석',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          const SizedBox(height: 20),
          _buildMuscleProgressItem('가슴', 0.8, const Color(0xFF10B981)),
          const SizedBox(height: 12),
          _buildMuscleProgressItem('등', 0.6, const Color(0xFF3B82F6)),
          const SizedBox(height: 12),
          _buildMuscleProgressItem('어깨', 0.7, const Color(0xFFF59E0B)),
          const SizedBox(height: 12),
          _buildMuscleProgressItem('팔', 0.5, const Color(0xFFEC4899)),
          const SizedBox(height: 12),
          _buildMuscleProgressItem('하체', 0.9, const Color(0xFF8B5CF6)),
        ],
      ),
    );
  }

  Widget _buildMuscleProgressItem(
      String muscleName, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              muscleName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildRecentWorkouts() {
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '최근 운동 기록',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          const SizedBox(height: 20),
          _buildWorkoutItem('벤치프레스', '80kg × 10회 × 3세트', '2024.09.10'),
          const Divider(height: 20),
          _buildWorkoutItem('스쿼트', '100kg × 8회 × 4세트', '2024.09.09'),
          const Divider(height: 20),
          _buildWorkoutItem('데드리프트', '120kg × 6회 × 3세트', '2024.09.08'),
          const Divider(height: 20),
          _buildWorkoutItem('풀업', '자중 × 12회 × 3세트', '2024.09.07'),
        ],
      ),
    );
  }

  Widget _buildWorkoutItem(String exercise, String details, String date) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.fitness_center,
            color: Color(0xFF10B981),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exercise,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                details,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ],
          ),
        ),
        Text(
          date,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
      ],
    );
  }
}
