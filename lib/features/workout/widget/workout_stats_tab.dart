import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../viewmodel/workout_stats_viewmodel.dart';
import '../service/workout_api_service.dart';
import '../service/local_storage_service.dart';
import '../model/workout_stats_models.dart';
import '../../dashboard/widgets/notion_button.dart';
import '../../../common/widgets/exercise_autocomplete_field.dart';
import '../../sync/model/sync_models.dart';

// 차트 유형 열거형
enum ChartType {
  maxWeight('최대 중량', Icons.trending_up, Color(0xFFEF4444)),
  oneRM('1RM 추정', Icons.whatshot, Color(0xFF8B5CF6)),
  volume('볼륨', Icons.fitness_center, Color(0xFF10B981));
  
  const ChartType(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

class WorkoutStatsTab extends ConsumerStatefulWidget {
  const WorkoutStatsTab({super.key});

  @override
  ConsumerState<WorkoutStatsTab> createState() => _WorkoutStatsTabState();
}

class _WorkoutStatsTabState extends ConsumerState<WorkoutStatsTab> {
  late WorkoutStatsViewmodel _viewModel;
  bool _isInitialized = false;
  
  // 검색 및 필터링 관련 상태
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedMuscleGroup;
  List<ExerciseStats> _filteredExercises = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
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
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _applyFilters();
    });
  }

  void _applyFilters() {
    print('🔍 [Member] _applyFilters() 호출됨 - 검색어: "$_searchQuery", 선택된 근육군: $_selectedMuscleGroup');
    
    if (_viewModel.statsData == null) {
      print('❌ [Member] _viewModel.statsData가 null입니다');
      _filteredExercises = [];
      return;
    }

    List<ExerciseStats> filtered = _viewModel.statsData!.exercises;
    print('📊 [Member] 전체 운동 개수: ${filtered.length}');
    
    // 운동 이름들 출력 (디버깅용)
    for (var exercise in filtered) {
      print('  - ${exercise.exerciseName}');
    }

    // 검색어 필터
    if (_searchQuery.isNotEmpty) {
      print('🔎 [Member] 검색어로 필터링 중: "$_searchQuery"');
      filtered = filtered.where((exercise) {
        final matches = exercise.exerciseName.toLowerCase().contains(_searchQuery.toLowerCase());
        print('  ${exercise.exerciseName} - 매치: $matches');
        return matches;
      }).toList();
      print('🎯 [Member] 검색 후 결과: ${filtered.length}개');
    }

    // 근육군 필터 (간단한 문자열 매칭으로 구현)
    if (_selectedMuscleGroup != null && _selectedMuscleGroup!.isNotEmpty) {
      print('💪 [Member] 근육군으로 필터링 중: "$_selectedMuscleGroup"');
      filtered = filtered.where((exercise) {
        // 운동명에 근육군 키워드가 포함되는지 확인 (간단한 구현)
        final exerciseName = exercise.exerciseName.toLowerCase();
        final muscleGroup = _selectedMuscleGroup!.toLowerCase();
        
        // 간단한 키워드 매핑
        bool matches = false;
        if (muscleGroup == '가슴' && (exerciseName.contains('벤치') || exerciseName.contains('체스트') || exerciseName.contains('푸시업'))) {
          matches = true;
        } else if (muscleGroup == '등' && (exerciseName.contains('풀업') || exerciseName.contains('데드') || exerciseName.contains('로우') || exerciseName.contains('랫풀'))) {
          matches = true;
        } else if (muscleGroup == '어깨' && (exerciseName.contains('숄더') || exerciseName.contains('프레스') || exerciseName.contains('레이즈'))) {
          matches = true;
        } else if (muscleGroup == '팔' && (exerciseName.contains('컬') || exerciseName.contains('트라이셉') || exerciseName.contains('딥스'))) {
          matches = true;
        } else if (muscleGroup == '하체' && (exerciseName.contains('스쿼트') || exerciseName.contains('레그') || exerciseName.contains('런지'))) {
          matches = true;
        } else if (muscleGroup == '코어' && (exerciseName.contains('플랭크') || exerciseName.contains('크런치') || exerciseName.contains('싯업'))) {
          matches = true;
        }
        
        print('  ${exercise.exerciseName} - 근육군 매치: $matches');
        return matches;
      }).toList();
      print('🎯 [Member] 근육군 필터 후 결과: ${filtered.length}개');
    }

    _filteredExercises = filtered;
    print('✅ [Member] 최종 필터링 결과: ${_filteredExercises.length}개');
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
          // 검색 및 필터 UI
          _buildSearchAndFilter(),
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

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // 검색 필드 - 자동완성 기능 추가
          ExerciseAutocompleteField(
            labelText: '운동 검색',
            hintText: '운동 이름을 입력하세요...',
            controller: _searchController,
            onTextChanged: (text) {
              setState(() {
                _searchQuery = text;
                _applyFilters();
              });
            },
            onExerciseSelected: (exercise) {
              setState(() {
                _searchQuery = exercise.name;
                _searchController.text = exercise.name;
                _applyFilters();
              });
            },
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xFF10B981),
              size: 20,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 근육군 필터 (현재는 간단한 칩들로 구현)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildMuscleGroupChip('전체', null),
                const SizedBox(width: 8),
                _buildMuscleGroupChip('가슴', '가슴'),
                const SizedBox(width: 8),
                _buildMuscleGroupChip('등', '등'),
                const SizedBox(width: 8),
                _buildMuscleGroupChip('어깨', '어깨'),
                const SizedBox(width: 8),
                _buildMuscleGroupChip('팔', '팔'),
                const SizedBox(width: 8),
                _buildMuscleGroupChip('하체', '하체'),
                const SizedBox(width: 8),
                _buildMuscleGroupChip('코어', '코어'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuscleGroupChip(String label, String? muscleGroup) {
    final isSelected = _selectedMuscleGroup == muscleGroup;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMuscleGroup = muscleGroup;
          _applyFilters();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF10B981).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF10B981)
                : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected 
                ? const Color(0xFF10B981)
                : Colors.grey[700],
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.15),
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
                color: const Color(0xFF10B981).withValues(alpha: 0.7),
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
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
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
    // 검색/필터가 적용된 운동 목록 사용
    print('🏗️ [Member] _buildDetailedExerciseStatsList 호출됨');
    print('   전체 exercises 개수: ${_viewModel.statsData?.exercises.length ?? 0}');
    print('   검색어: "$_searchQuery"');
    print('   선택된 근육군: $_selectedMuscleGroup');
    
    // build 메서드에서 직접 필터링 로직 실행 (setState 없이)
    List<ExerciseStats> exercises = _viewModel.statsData?.exercises ?? [];
    
    // 검색어 필터 적용
    if (_searchQuery.isNotEmpty) {
      exercises = exercises.where((exercise) {
        return exercise.exerciseName.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
      print('🔎 [Member] 검색 후 결과: ${exercises.length}개');
    }
    
    // 근육군 필터 적용
    if (_selectedMuscleGroup != null && _selectedMuscleGroup!.isNotEmpty) {
      exercises = exercises.where((exercise) {
        final exerciseName = exercise.exerciseName.toLowerCase();
        final muscleGroup = _selectedMuscleGroup!.toLowerCase();
        
        bool matches = false;
        if (muscleGroup == '가슴' && (exerciseName.contains('벤치') || exerciseName.contains('체스트') || exerciseName.contains('푸시업'))) {
          matches = true;
        } else if (muscleGroup == '등' && (exerciseName.contains('풀업') || exerciseName.contains('데드') || exerciseName.contains('로우') || exerciseName.contains('랫풀'))) {
          matches = true;
        } else if (muscleGroup == '어깨' && (exerciseName.contains('숄더') || exerciseName.contains('프레스') || exerciseName.contains('레이즈'))) {
          matches = true;
        } else if (muscleGroup == '팔' && (exerciseName.contains('컬') || exerciseName.contains('트라이셉') || exerciseName.contains('딥스'))) {
          matches = true;
        } else if (muscleGroup == '하체' && (exerciseName.contains('스쿼트') || exerciseName.contains('레그') || exerciseName.contains('런지'))) {
          matches = true;
        } else if (muscleGroup == '코어' && (exerciseName.contains('플랭크') || exerciseName.contains('크런치') || exerciseName.contains('싯업'))) {
          matches = true;
        }
        return matches;
      }).toList();
      print('💪 [Member] 근육군 필터 후 결과: ${exercises.length}개');
    }
    
    print('   최종 사용할 exercises 개수: ${exercises.length}');
    
    if (exercises.isEmpty) {
      // 검색 결과가 없는 경우와 전체 데이터가 없는 경우 구분
      final hasSearchOrFilter = _searchQuery.isNotEmpty || _selectedMuscleGroup != null;
      
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
        child: Center(
          child: Column(
            children: [
              Icon(
                hasSearchOrFilter ? Icons.search_off : Icons.fitness_center_outlined,
                size: 64,
                color: const Color(0xFF10B981).withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                hasSearchOrFilter 
                    ? '검색 결과가 없습니다'
                    : '운동 데이터가 없습니다',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
              if (hasSearchOrFilter) ...[
                const SizedBox(height: 8),
                Text(
                  '다른 검색어나 필터를 시도해보세요',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ],
            ],
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
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
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
                color: Colors.grey[600],
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
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
          height: 120,
          child: _buildAdvancedChart(exercise, _selectedChartType),
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
  
  
  ChartType _selectedChartType = ChartType.maxWeight;
  
  Widget _buildChartTabs(ExerciseStats exercise) {
    return Column(
      children: [
        // 탭 메뉴
        Row(
          children: ChartType.values.map((type) {
            final isSelected = _selectedChartType == type;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedChartType = type),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? type.color.withOpacity(0.1) : Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? type.color : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        type.icon,
                        size: 14,
                        color: isSelected ? type.color : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        type.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? type.color : Colors.grey[600],
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        // 차트
        Container(
          height: 120,
          child: _buildAdvancedChart(exercise, _selectedChartType),
        ),
      ],
    );
  }
  
  Widget _buildAdvancedChart(ExerciseStats exercise, ChartType chartType) {
    if (exercise.progressData.isEmpty) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                chartType.icon,
                size: 32,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                '데이터 없음',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 데이터 준비
    late List<FlSpot> spots;
    late String unit;
    
    switch (chartType) {
      case ChartType.maxWeight:
        spots = exercise.progressData.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.maxWeight);
        }).toList();
        unit = 'kg';
        break;
      case ChartType.oneRM:
        spots = exercise.progressData.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.estimatedOneRM);
        }).toList();
        unit = 'kg';
        break;
      case ChartType.volume:
        spots = exercise.progressData.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.volume / 1000); // K단위로 변환
        }).toList();
        unit = 'K';
        break;
    }
    
    if (spots.isEmpty || spots.every((spot) => spot.y == 0)) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '${chartType.label} 데이터 없음',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ),
      );
    }

    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;
    
    // 패딩 계산 및 음수 방지
    final padding = range > 0 ? range * 0.1 : 1.0; // 최소 1.0 패딩
    final calculatedMinY = minY - padding;
    final safeMinY = calculatedMinY < 0 ? 0.0 : calculatedMinY; // 음수 방지
    final safeMaxY = maxY + padding;

    return Container(
      height: 120,
      padding: const EdgeInsets.all(8),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            horizontalInterval: range > 0 ? (safeMaxY - safeMinY) / 3 : 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey[300]!,
                strokeWidth: 0.5,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                interval: range > 0 ? (safeMaxY - safeMinY) / 3 : 1,
                getTitlesWidget: (value, meta) {
                  // 음수 값은 표시하지 않음
                  if (value < 0) return const SizedBox.shrink();
                  return Text(
                    '${value.toStringAsFixed(0)}$unit',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(color: Colors.grey[300]!, width: 1),
              bottom: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
          minX: 0,
          maxX: spots.length > 1 ? (spots.length - 1).toDouble() : 1,
          minY: safeMinY,
          maxY: safeMaxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: chartType.color,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: chartType.color,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: chartType.color.withOpacity(0.1),
              ),
            ),
          ],
          // 점 위에 값 표시
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => chartType.color.withOpacity(0.9),
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  return LineTooltipItem(
                    '${barSpot.y.toStringAsFixed(1)}$unit',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  );
                }).toList();
              },
            ),
          ),
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
            
            // 주간 요약 - 간단하게 총 운동 횟수만 표시
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                  const SizedBox(width: 8),
                  Text(
                    '주간 총 운동',
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