import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/sync/model/sync_models.dart';
import '../../features/sync/viewmodel/sync_viewmodel.dart';
import '../constants/muscle_translations.dart';

class EnhancedExerciseSelector extends ConsumerStatefulWidget {
  final Function(Exercise)? onExerciseSelected;
  final String? initialCategory;
  final double? height;

  const EnhancedExerciseSelector({
    super.key,
    this.onExerciseSelected,
    this.initialCategory,
    this.height,
  });

  @override
  ConsumerState<EnhancedExerciseSelector> createState() => _EnhancedExerciseSelectorState();
}

class _EnhancedExerciseSelectorState extends ConsumerState<EnhancedExerciseSelector>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<Exercise> _filteredExercises = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final categories = MuscleTranslations.categories;
    _tabController = TabController(length: categories.length, vsync: this);
    
    // 초기 카테고리가 지정되어 있으면 해당 탭으로 이동
    if (widget.initialCategory != null) {
      final initialIndex = categories.indexOf(widget.initialCategory!);
      if (initialIndex != -1) {
        _tabController.index = initialIndex;
      }
    }

    _searchController.addListener(_onSearchChanged);
    _tabController.addListener(_onTabChanged);

    // 초기 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExercisesForCurrentTab();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    _loadExercisesForCurrentTab();
  }

  void _onTabChanged() {
    _loadExercisesForCurrentTab();
  }

  void _loadExercisesForCurrentTab() {
    final cachedExercisesAsync = ref.read(cachedExercisesProvider);
    cachedExercisesAsync.when(
      data: (exercises) {
        _filterExercises(exercises);
      },
      loading: () {
        // 로딩 중일 때는 아무것도 하지 않음
      },
      error: (error, stack) {
        // 에러일 때는 빈 리스트로 설정
        setState(() {
          _filteredExercises = [];
        });
      },
    );
  }

  void _filterExercises(List<Exercise> exercises) {
    final categories = MuscleTranslations.categories;
    final currentCategory = categories[_tabController.index];
    
    List<Exercise> filtered = exercises;

    // 카테고리별 필터링 (전신이 아닌 경우)
    if (currentCategory != '전신') {
      filtered = exercises.where((exercise) {
        final muscleNames = exercise.targetMuscles.map((m) => m.name.toLowerCase()).toList();
        return MuscleTranslations.exerciseBelongsToCategory(muscleNames, currentCategory);
      }).toList();
    }

    // 검색어 필터링
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((exercise) {
        final name = exercise.name.toLowerCase();
        final query = _searchQuery.toLowerCase();
        
        // 운동 이름으로 검색
        if (name.contains(query)) return true;
        
        // 한글 번역된 근육 이름으로 검색
        for (final muscle in exercise.targetMuscles) {
          final translatedMuscle = MuscleTranslations.translateMuscle(muscle.name);
          if (translatedMuscle.toLowerCase().contains(query)) return true;
        }
        
        return false;
      }).toList();
    }

    setState(() {
      _filteredExercises = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cachedExercisesAsync = ref.watch(cachedExercisesProvider);
    final categories = MuscleTranslations.categories;

    return Container(
      height: widget.height ?? MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 핸들
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // 헤더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    '운동 선택',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // 검색 필드
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '운동 이름 또는 부위 검색',
                hintStyle: const TextStyle(fontFamily: 'IBMPlexSansKR'),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 탭 바
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicator: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(8),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'IBMPlexSansKR',
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'IBMPlexSansKR',
                fontSize: 14,
              ),
              tabAlignment: TabAlignment.start,
              tabs: categories.map((category) => Tab(text: category)).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // 운동 목록
          Expanded(
            child: cachedExercisesAsync.when(
              data: (exercises) {
                // 데이터가 로드되면 자동으로 필터링 수행
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_filteredExercises.isEmpty && exercises.isNotEmpty) {
                    _filterExercises(exercises);
                  }
                });
                
                if (exercises.isEmpty) {
                  return _buildEmptyState('운동 데이터를 동기화해주세요', Icons.sync);
                }

                if (_filteredExercises.isEmpty && _searchQuery.isNotEmpty) {
                  return _buildEmptyState('검색 결과가 없습니다', Icons.search_off);
                }

                if (_filteredExercises.isEmpty) {
                  return _buildEmptyState('이 부위의 운동이 없습니다', Icons.fitness_center);
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _filteredExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = _filteredExercises[index];
                    return _buildExerciseCard(exercise);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF10B981),
                ),
              ),
              error: (error, _) => _buildEmptyState('데이터 로딩 실패', Icons.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    // 주요 타겟 근육들을 한글로 번역
    final primaryMuscles = exercise.targetMuscles
        .where((muscle) => muscle.role == MuscleRole.primary)
        .map((muscle) => MuscleTranslations.translateMuscle(muscle.name))
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            widget.onExerciseSelected?.call(exercise);
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                if (primaryMuscles.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: primaryMuscles.take(4).map((muscle) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        muscle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 운동 선택 다이얼로그를 표시하는 헬퍼 함수
void showEnhancedExerciseSelector(
  BuildContext context, {
  required Function(Exercise) onExerciseSelected,
  String? initialCategory,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => EnhancedExerciseSelector(
      onExerciseSelected: onExerciseSelected,
      initialCategory: initialCategory,
    ),
  );
}