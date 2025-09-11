import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../viewmodel/workout_stats_viewmodel.dart';
import '../service/workout_api_service.dart';
import '../service/local_storage_service.dart';
import '../model/workout_stats_models.dart';
import '../../dashboard/widgets/notion_button.dart';

class WorkoutStatsTab extends ConsumerStatefulWidget {
  const WorkoutStatsTab({super.key});

  @override
  ConsumerState<WorkoutStatsTab> createState() => _WorkoutStatsTabState();
}

class _WorkoutStatsTabState extends ConsumerState<WorkoutStatsTab> {
  late WorkoutStatsViewmodel _viewModel;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final workoutApiService = ref.read(workoutApiServiceProvider);
      final localStorageService = ref.read(localStorageServiceProvider);
      _viewModel = WorkoutStatsViewmodel(workoutApiService, localStorageService);
      _initializeViewModel();
    });
  }

  Future<void> _initializeViewModel() async {
    await _viewModel.initialize();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF10B981),
          strokeWidth: 3,
        ),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'IBMPlexSansKR',
            ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF10B981).withValues(alpha: 0.02),
              const Color(0xFF34D399).withValues(alpha: 0.03),
              const Color(0xFF6EE7B7).withValues(alpha: 0.02),
            ],
          ),
        ),
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            if (_viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF10B981),
                  strokeWidth: 3,
                ),
              );
            }

            if (_viewModel.errorMessage != null) {
              return _buildErrorView();
            }

            if (_viewModel.statsData == null) {
              return _buildEmptyView();
            }

            return _buildStatsView();
          },
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '통계를 불러오는데 실패했습니다',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              fontFamily: 'IBMPlexSansKR',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _viewModel.errorMessage ?? '알 수 없는 오류',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'IBMPlexSansKR',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          NotionButton(
            onPressed: () => _viewModel.loadWorkoutStats(),
            text: '다시 시도',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.bar_chart,
              size: 48,
              color: Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '운동 기록이 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              fontFamily: 'IBMPlexSansKR',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '운동 기록을 추가하고 통계를 확인해보세요!',
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

  Widget _buildStatsView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 기간 선택 및 필터
          _buildPeriodSelector(),
          const SizedBox(height: 16),
          // 전체 요약 통계 카드 (이미지와 유사한 스타일)
          _buildDetailedSummaryCard(),
          const SizedBox(height: 20),
          // 부위별 분석 차트
          _buildMuscleGroupAnalysisChart(),
          const SizedBox(height: 20),
          // 주간 운동 빈도 차트
          _buildWeeklyWorkoutFrequencyChart(),
          const SizedBox(height: 20),
          // 운동별 상세 통계 리스트
          _buildDetailedExerciseStatsList(),
          const SizedBox(height: 100), // 하단 여백
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 통계 기간',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: StatsPeriod.values.map((period) {
              final isSelected = _viewModel.selectedPeriod == period;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: GestureDetector(
                    onTap: () => _viewModel.selectPeriod(period),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF34D399)],
                              )
                            : null,
                        color: isSelected ? null : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        period.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedSummaryCard() {
    final summary = _viewModel.statsData!.summary;
    final totalReps = _viewModel.statsData!.exercises.fold(0, (sum, ex) => sum + ex.totalReps);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 섹션
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_viewModel.selectedPeriod.label} 운동 요약',
                          style: const TextStyle(
                            color: Color(0xFF1F2937),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        DateFormat('yyyy.MM.dd').format(DateTime.now().subtract(Duration(days: _viewModel.selectedPeriod.days))) + 
                        ' - ' + DateFormat('yyyy.MM.dd').format(DateTime.now()),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${summary.totalWorkoutDays}일 운동',
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // 메인 통계 그리드 (2x2)
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    '총 볼륨',
                    '${(summary.totalVolume / 1000).toStringAsFixed(1)}K',
                    'kg',
                    Icons.fitness_center,
                    const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    '총 세트',
                    '${summary.totalSets}',
                    '세트',
                    Icons.format_list_numbered,
                    const Color(0xFF3B82F6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    '총 횟수',
                    '$totalReps',
                    '회',
                    Icons.repeat,
                    const Color(0xFF8B5CF6),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    '운동 종류',
                    '${summary.totalExercises}',
                    '가지',
                    Icons.category,
                    const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String title, String value, String unit, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                TextSpan(
                  text: unit,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  


  Widget _buildDetailedExerciseStatsList() {
    final exercises = _viewModel.getFilteredExercises();
    
    if (exercises.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(32),
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
        child: const Center(
          child: Text(
            '운동 데이터가 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ),
      );
    }

    return Column(
      children: exercises.map((exercise) => _buildDetailedExerciseCard(exercise)).toList(),
    );
  }

  Widget _buildDetailedExerciseCard(ExerciseStats exercise) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 섹션 
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(0xFF10B981).withValues(alpha: 0.05),
                  const Color(0xFF10B981).withValues(alpha: 0.02),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                // 운동 아이콘
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getExerciseIcon(exercise.exerciseName),
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.exerciseName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '총 ${exercise.totalSets}세트 · ${exercise.totalReps}회',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 통계 정보 섹션
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 첫 번째 줄: 최대 중량, 평균 중량
                Row(
                  children: [
                    Expanded(
                      child: _buildStatInfo(
                        '최대 중량',
                        '${exercise.maxWeight.toStringAsFixed(1)}kg',
                        Icons.trending_up,
                        const Color(0xFFEF4444),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatInfo(
                        '평균 중량',
                        '${exercise.avgWeight.toStringAsFixed(1)}kg',
                        Icons.show_chart,
                        const Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // 두 번째 줄: 총 볼륨, 예상 1RM
                Row(
                  children: [
                    Expanded(
                      child: _buildStatInfo(
                        '총 볼륨',
                        '${(exercise.totalVolume / 1000).toStringAsFixed(1)}K',
                        Icons.fitness_center,
                        const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatInfo(
                        '예상 1RM',
                        '${exercise.estimatedOneRM.toStringAsFixed(1)}kg',
                        Icons.whatshot,
                        const Color(0xFF8B5CF6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // 진행도 차트
                _buildProgressSection(exercise),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatInfo(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 6),
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
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressSection(ExerciseStats exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.analytics,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              '진행도',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 60,
          child: _buildAdvancedMiniChart(exercise),
        ),
      ],
    );
  }
  
  
  IconData _getExerciseIcon(String exerciseName) {
    final name = exerciseName.toLowerCase();
    if (name.contains('bench') || name.contains('벤치')) return Icons.fitness_center;
    if (name.contains('squat') || name.contains('스쿼트')) return Icons.keyboard_arrow_down;
    if (name.contains('deadlift') || name.contains('데드')) return Icons.keyboard_arrow_up;
    if (name.contains('press') || name.contains('프레스')) return Icons.trending_up;
    if (name.contains('curl') || name.contains('컬')) return Icons.radio_button_unchecked;
    if (name.contains('fly') || name.contains('플라이')) return Icons.open_in_full;
    return Icons.fitness_center;
  }
  
  
  Widget _buildAdvancedMiniChart(ExerciseStats exercise) {
    if (exercise.progressData.isEmpty) {
      return Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '데이터 없음',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ),
      );
    }

    final spots = exercise.progressData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.maxWeight);
    }).toList();

    return Container(
      height: 60,
      padding: const EdgeInsets.all(4),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: spots.length > 1 ? (spots.length - 1).toDouble() : 1,
          minY: spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) * 0.95,
          maxY: spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.05,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: const Color(0xFF10B981),
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 3,
                  color: const Color(0xFF10B981),
                  strokeWidth: 0,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMuscleGroupAnalysisChart() {
    // 부위별 볼륨 계산 (예시 데이터)
    final muscleGroupData = _calculateMuscleGroupData();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '부위별 운동 분석',
                  style: TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    '볼륨 기준',
                    style: TextStyle(
                      color: Color(0xFF3B82F6),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // 부위별 진행률 바 차트
            ...muscleGroupData.entries.map((entry) {
              final percentage = entry.value['percentage'] as double;
              final volume = entry.value['volume'] as double;
              final color = entry.value['color'] as Color;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${(volume / 1000).toStringAsFixed(1)}K',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: color,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${percentage.toInt()}%',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: percentage / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [color, color.withValues(alpha: 0.7)],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyWorkoutFrequencyChart() {
    // 주간 운동 빈도 계산 (예시 데이터)
    final weeklyData = _calculateWeeklyFrequencyData();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '주간 운동 빈도',
                  style: TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    '최근 4주',
                    style: TextStyle(
                      color: Color(0xFF8B5CF6),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // 막대 그래프
            Container(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: weeklyData.entries.map((entry) {
                  final dayName = entry.key;
                  final count = entry.value;
                  final maxCount = weeklyData.values.reduce((a, b) => a > b ? a : b);
                  final height = maxCount > 0 ? (count / maxCount) * 140 : 0.0;
                  
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // 운동 횟수 표시
                      if (count > 0)
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'IBMPlexSansKR',
                            ),
                          ),
                        ),
                      
                      // 막대
                      Container(
                        width: 24,
                        height: height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              const Color(0xFF8B5CF6),
                              const Color(0xFF8B5CF6).withValues(alpha: 0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // 요일 라벨
                      Text(
                        dayName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 주간 요약
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '${weeklyData.values.reduce((a, b) => a + b)}회',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B5CF6),
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                      Text(
                        '주간 총 운동',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.grey[300],
                  ),
                  Column(
                    children: [
                      Text(
                        '${(weeklyData.values.reduce((a, b) => a + b) / 7).toStringAsFixed(1)}회',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B5CF6),
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                      Text(
                        '일평균 운동',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, Map<String, dynamic>> _calculateMuscleGroupData() {
    if (_viewModel.statsData == null) return {};
    
    // 부위별 볼륨 계산 (예시 - 실제로는 운동 이름을 바탕으로 부위를 매핑해야 함)
    final exercises = _viewModel.statsData!.exercises;
    final muscleGroups = <String, double>{};
    
    for (final exercise in exercises) {
      final muscleGroup = _getMuscleGroupFromExercise(exercise.exerciseName);
      muscleGroups[muscleGroup] = (muscleGroups[muscleGroup] ?? 0) + exercise.totalVolume;
    }
    
    final totalVolume = muscleGroups.values.fold(0.0, (sum, volume) => sum + volume);
    final colors = [
      const Color(0xFF10B981), // 가슴
      const Color(0xFF3B82F6), // 등
      const Color(0xFFEF4444), // 어깨
      const Color(0xFFF59E0B), // 팔
      const Color(0xFF8B5CF6), // 하체
      const Color(0xFF06B6D4), // 기타
    ];
    
    final result = <String, Map<String, dynamic>>{};
    final sortedEntries = muscleGroups.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    for (int i = 0; i < sortedEntries.length; i++) {
      final entry = sortedEntries[i];
      final percentage = totalVolume > 0 ? (entry.value / totalVolume) * 100 : 0.0;
      result[entry.key] = {
        'volume': entry.value,
        'percentage': percentage,
        'color': colors[i % colors.length],
      };
    }
    
    return result;
  }

  Map<String, int> _calculateWeeklyFrequencyData() {
    if (_viewModel.statsData == null) return {};
    
    final weekDays = ['월', '화', '수', '목', '금', '토', '일'];
    final weeklyData = <String, int>{};
    
    // 요일별 카운터 초기화
    for (final day in weekDays) {
      weeklyData[day] = 0;
    }
    
    // 실제 운동 데이터에서 요일별 운동 횟수 계산
    final exercises = _viewModel.statsData!.exercises;
    final workoutDates = <String>{};
    
    // 모든 운동의 모든 세트에서 날짜 추출
    for (final exercise in exercises) {
      for (final set in exercise.sets) {
        workoutDates.add(set.date);
      }
    }
    
    // 각 운동 날짜를 요일로 변환하여 카운트
    for (final dateString in workoutDates) {
      try {
        final date = DateTime.parse(dateString);
        final weekday = date.weekday; // 1(월) ~ 7(일)
        
        // weekday를 한국 요일 이름으로 변환
        final koreanDay = _getKoreanWeekday(weekday);
        weeklyData[koreanDay] = (weeklyData[koreanDay] ?? 0) + 1;
      } catch (e) {
        // 날짜 파싱 실패시 무시
        print('날짜 파싱 실패: $dateString');
      }
    }
    
    return weeklyData;
  }
  
  String _getKoreanWeekday(int weekday) {
    switch (weekday) {
      case 1: return '월';
      case 2: return '화';
      case 3: return '수';
      case 4: return '목';
      case 5: return '금';
      case 6: return '토';
      case 7: return '일';
      default: return '월';
    }
  }

  String _getMuscleGroupFromExercise(String exerciseName) {
    final name = exerciseName.toLowerCase();
    
    if (name.contains('bench') || name.contains('벤치') || 
        name.contains('chest') || name.contains('가슴') ||
        name.contains('push up') || name.contains('푸시업')) {
      return '가슴';
    } else if (name.contains('squat') || name.contains('스쿼트') ||
               name.contains('leg') || name.contains('다리') ||
               name.contains('deadlift') || name.contains('데드')) {
      return '하체';
    } else if (name.contains('pull') || name.contains('row') ||
               name.contains('lat') || name.contains('등') ||
               name.contains('back') || name.contains('풀업')) {
      return '등';
    } else if (name.contains('shoulder') || name.contains('press') ||
               name.contains('어깨') || name.contains('프레스')) {
      return '어깨';
    } else if (name.contains('curl') || name.contains('컬') ||
               name.contains('arm') || name.contains('팔') ||
               name.contains('tricep') || name.contains('bicep')) {
      return '팔';
    } else {
      return '기타';
    }
  }


}