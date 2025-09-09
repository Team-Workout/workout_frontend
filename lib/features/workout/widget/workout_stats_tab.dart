import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
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
    return Column(
      children: [
        // 기간 선택 및 필터
        _buildPeriodSelector(),
        // 요약 카드
        _buildSummaryCards(),
        // 운동별 통계 리스트
        Expanded(
          child: _buildExerciseStatsList(),
        ),
      ],
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

  Widget _buildSummaryCards() {
    final summary = _viewModel.statsData!.summary;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              '🗓️',
              '운동 일수',
              '${summary.totalWorkoutDays}일',
              const Color(0xFF3B82F6),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCard(
              '💪',
              '총 세트',
              '${summary.totalSets}세트',
              const Color(0xFF10B981),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCard(
              '📈',
              '총 볼륨',
              '${(summary.totalVolume / 1000).toStringAsFixed(1)}K',
              const Color(0xFF8B5CF6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String emoji, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseStatsList() {
    final exercises = _viewModel.getFilteredExercises();
    
    if (exercises.isEmpty) {
      return const Center(
        child: Text(
          '운동 데이터가 없습니다',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        return _buildExerciseStatsCard(exercises[index]);
      },
    );
  }

  Widget _buildExerciseStatsCard(ExerciseStats exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
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
          // 운동 이름 헤더
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
              children: [
                const Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    exercise.exerciseName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 통계 정보
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem('최대 중량', '${exercise.maxWeight.toStringAsFixed(1)}kg'),
                    ),
                    Expanded(
                      child: _buildStatItem('평균 중량', '${exercise.avgWeight.toStringAsFixed(1)}kg'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem('총 세트', '${exercise.totalSets}세트'),
                    ),
                    Expanded(
                      child: _buildStatItem('총 볼륨', '${(exercise.totalVolume / 1000).toStringAsFixed(1)}K'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildStatItem('예상 1RM', '${exercise.estimatedOneRM.toStringAsFixed(1)}kg'),
                const SizedBox(height: 16),
                // 간단한 진행도 차트
                _buildMiniChart(exercise),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
      ],
    );
  }

  Widget _buildMiniChart(ExerciseStats exercise) {
    if (exercise.progressData.isEmpty) {
      return const SizedBox.shrink();
    }

    final spots = exercise.progressData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.maxWeight);
    }).toList();

    return Container(
      height: 120,
      padding: const EdgeInsets.all(8),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: spots.length > 1 ? (spots.length - 1).toDouble() : 1,
          minY: spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) * 0.9,
          maxY: spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.1,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: const Color(0xFF10B981),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
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
}