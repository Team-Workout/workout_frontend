import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/trainer_client_model.dart';
import '../viewmodel/trainer_client_viewmodel.dart';
import '../../../services/image_cache_manager.dart';

class TrainerClientDetailView extends ConsumerStatefulWidget {
  final TrainerClient client;

  const TrainerClientDetailView({
    super.key,
    required this.client,
  });

  @override
  ConsumerState<TrainerClientDetailView> createState() => _TrainerClientDetailViewState();
}

class _TrainerClientDetailViewState extends ConsumerState<TrainerClientDetailView> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _startDate = '';
  String _endDate = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
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
    ref.read(memberBodyCompositionsProvider(widget.client.memberId).notifier)
        .loadBodyCompositions(
          startDate: _startDate,
          endDate: _endDate,
        );
    
    // 몸 사진 데이터 로드
    ref.read(memberBodyImagesProvider(widget.client.memberId).notifier)
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
                Tab(text: '체성분 분석'),
                Tab(text: '몸 사진'),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberHeader() {
    return FutureBuilder<String?>(
      future: widget.client.profileImageUrl != null && widget.client.profileImageUrl!.isNotEmpty
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
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'ACTIVE MEMBER',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                        ),
                      ),
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
    final compositionsState = ref.watch(memberBodyCompositionsProvider(widget.client.memberId));

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

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 체중 변화 차트
              _buildWeightChart(compositions),
              const SizedBox(height: 24),
              
              // 체성분 목록
              _buildCompositionList(compositions),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              '체성분 데이터를 불러오는데 실패했습니다',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightChart(List<MemberBodyComposition> compositions) {
    // null이 아닌 체중 데이터만 필터링
    final validCompositions = compositions
        .where((comp) => comp.weightKg != null)
        .toList();
    
    if (validCompositions.length < 2) {
      return const SizedBox.shrink();
    }

    final sortedCompositions = [...validCompositions]
      ..sort((a, b) => DateTime.parse(a.measurementDate).compareTo(DateTime.parse(b.measurementDate)));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '체중 변화 추이',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
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
                            '${value.toInt()}kg',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < sortedCompositions.length) {
                            final date = DateTime.parse(sortedCompositions[value.toInt()].measurementDate);
                            return Text(
                              '${date.month}/${date.day}',
                              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: sortedCompositions.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.weightKg!);
                      }).toList(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [Colors.blue[300]!, Colors.blue[600]!],
                      ),
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.blue[600]!,
                            strokeColor: Colors.white,
                            strokeWidth: 2,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue[200]!.withOpacity(0.3),
                            Colors.blue[100]!.withOpacity(0.1),
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
    );
  }

  Widget _buildCompositionList(List<MemberBodyComposition> compositions) {
    final sortedCompositions = [...compositions]
      ..sort((a, b) => DateTime.parse(b.measurementDate).compareTo(DateTime.parse(a.measurementDate)));

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              '체성분 기록',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedCompositions.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final composition = sortedCompositions[index];
              final date = DateTime.parse(composition.measurementDate);
              
              return ListTile(
                title: Text(
                  '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Row(
                  children: [
                    Text('체중: ${composition.weightKg?.toStringAsFixed(1) ?? '-'}kg'),
                    const SizedBox(width: 16),
                    Text('체지방: ${composition.fatKg?.toStringAsFixed(1) ?? '-'}kg'),
                    const SizedBox(width: 16),
                    Text('근육량: ${composition.muscleMassKg?.toStringAsFixed(1) ?? '-'}kg'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBodyImagesTab() {
    final imagesState = ref.watch(memberBodyImagesProvider(widget.client.memberId));

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

        final sortedImages = [...images]
          ..sort((a, b) => DateTime.parse(b.recordDate).compareTo(DateTime.parse(a.recordDate)));

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
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              '몸 사진을 불러오는데 실패했습니다',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(MemberBodyImage image) {
    final date = DateTime.parse(image.recordDate);
    
    return FutureBuilder<String?>(
      future: ImageCacheManager().getCachedImage(
        imageUrl: image.fileUrl,
        cacheKey: 'body_${image.fileId}',
        type: ImageType.body,
      ),
      builder: (context, snapshot) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
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
                          ? const Center(child: CircularProgressIndicator())
                          : _buildImagePlaceholder(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      image.originalFileName ?? '이미지',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
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
      color: Colors.grey[200],
      child: Icon(
        Icons.image_outlined,
        size: 48,
        color: Colors.grey[400],
      ),
    );
  }
}