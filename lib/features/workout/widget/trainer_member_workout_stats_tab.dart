import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../viewmodel/workout_stats_viewmodel.dart';
import '../service/workout_api_service.dart';
import '../service/local_storage_service.dart';
import '../model/workout_stats_models.dart';

class TrainerMemberWorkoutStatsTab extends ConsumerStatefulWidget {
  final int memberId;
  final String memberName;

  const TrainerMemberWorkoutStatsTab({
    super.key,
    required this.memberId,
    required this.memberName,
  });

  @override
  ConsumerState<TrainerMemberWorkoutStatsTab> createState() =>
      _TrainerMemberWorkoutStatsTabState();
}

class _TrainerMemberWorkoutStatsTabState
    extends ConsumerState<TrainerMemberWorkoutStatsTab> {
  StatsPeriod _selectedPeriod = StatsPeriod.threeMonths;
  bool _isLoading = false;
  WorkoutStatsResponse? _statsData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMemberWorkoutStats();
  }

  Future<void> _loadMemberWorkoutStats() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final now = DateTime.now();
      final startDate = now.subtract(Duration(days: _selectedPeriod.days));
      final endDate = now;

      final apiService = ref.read(workoutApiServiceProvider);

      // 먼저 서버 API 시도
      try {
        print('🔍 트레이너가 회원 ${widget.memberId}의 운동 통계 조회 시도');
        final stats = await apiService.getMemberWorkoutStats(
          memberId: widget.memberId,
          startDate: DateFormat('yyyy-MM-dd').format(startDate),
          endDate: DateFormat('yyyy-MM-dd').format(endDate),
        );
        setState(() {
          _statsData = stats;
          _isLoading = false;
        });
        print('✅ 서버에서 통계 조회 성공');
        return;
      } catch (e) {
        print('❌ 서버 통계 API 호출 실패, 로컬에서 계산: $e');
        
        // 서버 실패시 로컬 데이터 사용 시도
        try {
          final workoutLogs = await apiService.getMemberWorkoutLogsByPeriod(
            memberId: widget.memberId,
            startDate: DateFormat('yyyy-MM-dd').format(startDate),
            endDate: DateFormat('yyyy-MM-dd').format(endDate),
          );

          final processedStats = _processWorkoutLogsToStats(workoutLogs, _selectedPeriod);
          setState(() {
            _statsData = processedStats;
            _isLoading = false;
          });
          print('✅ 로컬에서 통계 계산 성공');
          return;
        } catch (localError) {
          print('❌ 로컬 통계 계산도 실패: $localError');
          throw localError;
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      print('❌ 전체 통계 로드 실패: $e');
    }
  }

  // 운동 로그를 통계 데이터로 변환 (기존 로직과 동일)
  WorkoutStatsResponse _processWorkoutLogsToStats(
    List<Map<String, dynamic>> workoutLogs,
    StatsPeriod dateRange,
  ) {
    print('📊 통계 계산 시작 - 운동 로그 수: ${workoutLogs.length}');
    
    // 운동별로 데이터 그룹화
    Map<String, List<ExerciseSetData>> exerciseGroups = {};
    Set<String> workoutDates = {};
    int totalSets = 0;
    double totalVolume = 0;

    for (var log in workoutLogs) {
      final logDate = log['workout_date'] as String;
      workoutDates.add(logDate);
      print('📊 처리 중인 날짜: $logDate');
      
      final exercises = log['exercises'] as List<dynamic>;
      print('📊 해당 날짜 운동 수: ${exercises.length}');
      
      for (var exerciseData in exercises) {
        final exerciseName = exerciseData['exercise_name'] as String;
        final sets = exerciseData['sets'] as List<dynamic>;
        
        print('📊 운동: $exerciseName, 세트 수: ${sets.length}');
        
        // 운동 이름 필터링 - 실제 운동 종류만 포함
        if (!_isValidExerciseName(exerciseName)) {
          print('📊 필터링된 운동: $exerciseName');
          continue;
        }
        
        if (!exerciseGroups.containsKey(exerciseName)) {
          exerciseGroups[exerciseName] = [];
        }
        
        for (var setData in sets) {
          final weight = (setData['weight'] as num).toDouble();
          final reps = setData['reps'] as int;
          final setVolume = weight * reps;
          
          print('📊 세트 - 중량: ${weight}kg, 횟수: ${reps}회, 볼륨: ${setVolume}');
          
          totalSets++;
          totalVolume += setVolume;
          
          exerciseGroups[exerciseName]!.add(ExerciseSetData(
            date: logDate,
            setNumber: setData['set_number'] as int,
            weight: weight,
            reps: reps,
            feedback: setData['memo'] as String?,
          ));
        }
      }
    }
    
    print('📊 처리 완료 - 총 세트: $totalSets, 총 볼륨: $totalVolume, 운동 종류: ${exerciseGroups.length}');

    // 운동별 통계 계산
    List<ExerciseStats> exerciseStatsList = [];
    Map<String, int> exerciseFrequency = {};

    for (var entry in exerciseGroups.entries) {
      final exerciseName = entry.key;
      final setDataList = entry.value;

      // 기본 통계 계산
      final weights = setDataList.map((s) => s.weight).toList();
      final reps = setDataList.map((s) => s.reps).toList();
      final totalReps = reps.fold(0, (sum, r) => sum + r);

      final maxWeight = weights.reduce((a, b) => a > b ? a : b);
      final avgWeight = weights.reduce((a, b) => a + b) / weights.length;
      final exerciseVolume = setDataList.fold(0.0, (sum, s) => sum + (s.weight * s.reps));

      // 1RM 추정 계산
      double estimatedOneRM = 0;
      for (var setData in setDataList) {
        final estimated = _calculateOneRM(setData.weight, setData.reps);
        if (estimated > estimatedOneRM) {
          estimatedOneRM = estimated;
        }
      }

      // 진행도 데이터 생성
      final progressData = _generateProgressData(setDataList);

      exerciseStatsList.add(ExerciseStats(
        exerciseId: 0,
        exerciseName: exerciseName,
        totalSets: setDataList.length,
        totalReps: totalReps,
        maxWeight: maxWeight,
        avgWeight: avgWeight,
        totalVolume: exerciseVolume,
        estimatedOneRM: estimatedOneRM,
        sets: setDataList,
        progressData: progressData,
      ));

      // 운동 빈도 계산
      final uniqueDates = setDataList.map((s) => s.date).toSet();
      exerciseFrequency[exerciseName] = uniqueDates.length;
    }

    // 요약 통계
    final summary = WorkoutSummary(
      totalWorkoutDays: workoutDates.length,
      totalExercises: exerciseStatsList.length,
      totalSets: totalSets,
      totalVolume: totalVolume,
      exerciseFrequency: exerciseFrequency,
    );

    return WorkoutStatsResponse(
      startDate: DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: dateRange.days))),
      endDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      exercises: exerciseStatsList,
      summary: summary,
    );
  }

  bool _isValidExerciseName(String name) {
    if (name.isEmpty) return false;
    if (name.contains('Exercise')) return false;
    if (name.length < 2) return false;
    return true;
  }

  double _calculateOneRM(double weight, int reps) {
    if (reps == 1) return weight;
    if (reps > 15) return weight;
    return weight * (1 + (reps / 30.0));
  }

  List<WorkoutProgress> _generateProgressData(List<ExerciseSetData> setDataList) {
    Map<String, double> dailyMaxWeights = {};
    
    for (var setData in setDataList) {
      final date = setData.date;
      if (!dailyMaxWeights.containsKey(date) || 
          setData.weight > dailyMaxWeights[date]!) {
        dailyMaxWeights[date] = setData.weight;
      }
    }

    var sortedDates = dailyMaxWeights.keys.toList()..sort();
    return sortedDates.map((date) => WorkoutProgress(
      date: date,
      maxWeight: dailyMaxWeights[date]!,
      avgWeight: dailyMaxWeights[date]!,
      volume: 0,
      estimatedOneRM: _calculateOneRM(dailyMaxWeights[date]!, 1),
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // 기간 선택
          _buildPeriodSelector(),
          // 통계 내용
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '${widget.memberName}님의 운동 분석',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<StatsPeriod>(
                value: _selectedPeriod,
                items: StatsPeriod.values.map((range) {
                  return DropdownMenuItem(
                    value: range,
                    child: Text(
                      range.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (StatsPeriod? newValue) {
                  if (newValue != null && newValue != _selectedPeriod) {
                    setState(() {
                      _selectedPeriod = newValue;
                    });
                    _loadMemberWorkoutStats();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[400],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '데이터를 불러올 수 없습니다',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'IBMPlexSansKR',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadMemberWorkoutStats,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                ),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    if (_statsData == null) {
      return const Center(
        child: Text(
          '데이터가 없습니다',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
      );
    }

    return _buildStatsView();
  }

  Widget _buildStatsView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 기간 선택 및 필터
          const SizedBox(height: 16),
          // 전체 요약 통계 카드
          _buildDetailedSummaryCard(),
          const SizedBox(height: 20),
          // 운동별 상세 통계 리스트
          _buildDetailedExerciseStatsList(),
          const SizedBox(height: 100), // 하단 여백
        ],
      ),
    );
  }

  Widget _buildDetailedSummaryCard() {
    final summary = _statsData!.summary;
    final totalReps = _statsData!.exercises.fold(0, (sum, ex) => sum + ex.totalReps);
    
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
                          '${_selectedPeriod.label} 운동 요약',
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
                        DateFormat('yyyy.MM.dd').format(DateTime.now().subtract(Duration(days: _selectedPeriod.days))) + 
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
    final exercises = _statsData!.exercises;
    
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
}