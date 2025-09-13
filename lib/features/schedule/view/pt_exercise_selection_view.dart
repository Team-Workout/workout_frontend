import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/exercise_autocomplete_field.dart';
import '../../../features/sync/model/sync_models.dart';
import '../../../features/sync/viewmodel/sync_viewmodel.dart';
import '../../pt_contract/model/pt_session_models.dart';

class PtExerciseSelectionView extends ConsumerStatefulWidget {
  final List<WorkoutLogEntry> initialWorkoutLogs;
  
  const PtExerciseSelectionView({
    super.key,
    this.initialWorkoutLogs = const [],
  });

  @override
  ConsumerState<PtExerciseSelectionView> createState() => _PtExerciseSelectionViewState();
}

class _PtExerciseSelectionViewState extends ConsumerState<PtExerciseSelectionView> {
  final TextEditingController _searchController = TextEditingController();
  final List<PtExerciseEntry> _exercises = [];
  String _selectedCategory = '전체';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // 기존 운동 로그를 PtExerciseEntry로 변환
    for (var log in widget.initialWorkoutLogs) {
      _exercises.add(PtExerciseEntry.fromWorkoutLog(log));
    }
    // 운동 이름들을 비동기로 설정
    _loadExerciseNames();
  }

  Future<void> _loadExerciseNames() async {
    try {
      final cachedExercises = await ref.read(cachedExercisesProvider.future);
      setState(() {
        for (var exercise in _exercises) {
          if (exercise.exerciseName.isEmpty) {
            try {
              final foundExercise = cachedExercises.firstWhere(
                (e) => e.exerciseId == exercise.exerciseId,
              );
              exercise.exerciseName = foundExercise.name;
            } catch (e) {
              exercise.exerciseName = 'Exercise ID: ${exercise.exerciseId}';
            }
          }
        }
      });
    } catch (e) {
      // 운동 데이터를 불러올 수 없는 경우 기본값 사용
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    for (var exercise in _exercises) {
      exercise.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cachedExercisesAsync = ref.watch(cachedExercisesProvider);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'PT 운동 선택',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'IBMPlexSansKR',
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveAndClose,
            child: Text(
              '완료 (${_exercises.length})',
              style: const TextStyle(
                color: Color(0xFF10B981),
                fontWeight: FontWeight.w600,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색 및 필터 영역
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // 검색 필드
                ExerciseAutocompleteField(
                  controller: _searchController,
                  hintText: '운동 이름을 검색하거나 선택하세요',
                  onExerciseSelected: _addExercise,
                  onTextChanged: (text) {
                    setState(() {
                      _searchQuery = text;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // 카테고리 필터
                _buildCategoryFilter(),
              ],
            ),
          ),
          
          // 운동 목록 영역
          Expanded(
            child: _exercises.isEmpty
                ? (_searchQuery.isNotEmpty || _selectedCategory != '전체'
                    ? _buildExerciseSearchResults() 
                    : _buildAllExercises())
                : _buildExerciseList(),
          ),
          
          // 운동 추가 플로팅 버튼
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _addCustomExercise(),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      '직접 운동 추가',
                      style: TextStyle(
                        color: Colors.white,
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ['전체', '가슴', '등', '어깨', '팔', '복근', '하체', '유산소'];
    
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? category : '전체';
                  // 카테고리 변경 시에도 검색 결과를 업데이트하기 위해
                  // 검색어를 재설정 (빈 문자열이라도 상태 변경을 트리거)
                  if (_searchQuery.isEmpty) {
                    _searchQuery = '';
                  }
                });
              },
              selectedColor: const Color(0xFF10B981).withValues(alpha: 0.2),
              checkmarkColor: const Color(0xFF10B981),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF10B981) : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontFamily: 'IBMPlexSansKR',
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF10B981)
                      : Colors.grey.withValues(alpha: 0.3),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.fitness_center,
              size: 64,
              color: Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'PT 운동을 추가해주세요',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '위의 검색창에서 운동을 찾거나\n직접 운동을 추가할 수 있습니다',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllExercises() {
    final cachedExercisesAsync = ref.watch(cachedExercisesProvider);
    
    return cachedExercisesAsync.when(
      data: (exercises) {
        if (exercises.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fitness_center_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  '운동 데이터가 없습니다',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '설정에서 운동 데이터를 동기화해주세요',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // 상단 안내 메시지
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF10B981).withValues(alpha: 0.1),
                    const Color(0xFF34D399).withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '총 ${exercises.length}개의 운동이 있습니다. 아래에서 원하는 운동을 선택해주세요.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF10B981),
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 운동 목록
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return _buildExerciseSearchItem(exercises[index]);
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF10B981),
            ),
            SizedBox(height: 16),
            Text(
              '운동 데이터를 불러오는 중...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ],
        ),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            const Text(
              '운동 데이터를 불러올 수 없습니다',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseSearchResults() {
    final cachedExercisesAsync = ref.watch(cachedExercisesProvider);
    
    return cachedExercisesAsync.when(
      data: (exercises) {
        final filteredExercises = exercises.where((exercise) {
          // 검색어 매칭 (검색어가 비어있으면 모든 운동 포함)
          final matchesSearch = _searchQuery.isEmpty || 
              exercise.name.toLowerCase().contains(_searchQuery.toLowerCase());
          
          // 카테고리 매칭
          final matchesCategory = _selectedCategory == '전체' || 
              exercise.targetMuscles.any((muscle) => 
                  _getCategoryFromMuscle(muscle.name) == _selectedCategory);
          
          return matchesSearch && matchesCategory;
        }).toList();

        if (filteredExercises.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  '검색 결과가 없습니다',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '"$_searchQuery"에 대한 운동을 찾을 수 없습니다',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredExercises.length,
          itemBuilder: (context, index) {
            return _buildExerciseSearchItem(filteredExercises[index]);
          },
        );
      },
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF10B981),
            ),
            SizedBox(height: 16),
            Text(
              '운동 데이터를 불러오는 중...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ],
        ),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            const Text(
              '운동 데이터를 불러올 수 없습니다',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseSearchItem(Exercise exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _addExercise(exercise),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      color: Color(0xFF10B981),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                        if (exercise.targetMuscles.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            exercise.targetMuscles
                                .where((muscle) => muscle.role == MuscleRole.primary)
                                .take(3)
                                .map((muscle) => muscle.name)
                                .join(', '),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'IBMPlexSansKR',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '추가',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                  ),
                ],
              ),
              if (exercise.targetMuscles.length > 3) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: exercise.targetMuscles
                      .where((muscle) => muscle.role == MuscleRole.primary)
                      .skip(3)
                      .take(3)
                      .map((muscle) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF10B981).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              muscle.name,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF10B981),
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryFromMuscle(String muscleName) {
    // 근육 이름을 기준으로 카테고리를 매핑
    final String lowerMuscleName = muscleName.toLowerCase();
    
    // 가슴
    if (lowerMuscleName.contains('흉근') || lowerMuscleName.contains('가슴') || 
        lowerMuscleName.contains('chest') || lowerMuscleName.contains('pectoral')) {
      return '가슴';
    }
    
    // 등
    if (lowerMuscleName.contains('광배근') || lowerMuscleName.contains('승모근') || 
        lowerMuscleName.contains('능형근') || lowerMuscleName.contains('등') ||
        lowerMuscleName.contains('back') || lowerMuscleName.contains('latissimus') ||
        lowerMuscleName.contains('trapezius') || lowerMuscleName.contains('rhomboid')) {
      return '등';
    }
    
    // 어깨
    if (lowerMuscleName.contains('삼각근') || lowerMuscleName.contains('어깨') ||
        lowerMuscleName.contains('deltoid') || lowerMuscleName.contains('shoulder')) {
      return '어깨';
    }
    
    // 팔
    if (lowerMuscleName.contains('이두근') || lowerMuscleName.contains('삼두근') ||
        lowerMuscleName.contains('상완') || lowerMuscleName.contains('팔') ||
        lowerMuscleName.contains('bicep') || lowerMuscleName.contains('tricep') ||
        lowerMuscleName.contains('arm') || lowerMuscleName.contains('forearm')) {
      return '팔';
    }
    
    // 복근
    if (lowerMuscleName.contains('복') || lowerMuscleName.contains('코어') ||
        lowerMuscleName.contains('abs') || lowerMuscleName.contains('core') ||
        lowerMuscleName.contains('oblique')) {
      return '복근';
    }
    
    // 하체
    if (lowerMuscleName.contains('둔근') || lowerMuscleName.contains('대퇴') ||
        lowerMuscleName.contains('햄스트링') || lowerMuscleName.contains('종아리') ||
        lowerMuscleName.contains('하체') || lowerMuscleName.contains('다리') ||
        lowerMuscleName.contains('glute') || lowerMuscleName.contains('quad') ||
        lowerMuscleName.contains('hamstring') || lowerMuscleName.contains('calf') ||
        lowerMuscleName.contains('leg') || lowerMuscleName.contains('thigh')) {
      return '하체';
    }
    
    return '기타';
  }

  Widget _buildExerciseList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _exercises.length,
      itemBuilder: (context, index) {
        return _buildExerciseCard(_exercises[index], index);
      },
    );
  }

  Widget _buildExerciseCard(PtExerciseEntry exercise, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 헤더
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF10B981).withValues(alpha: 0.1),
                  const Color(0xFF34D399).withValues(alpha: 0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '운동 ${index + 1}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10B981),
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    exercise.exerciseName.isNotEmpty ? exercise.exerciseName : '운동 이름을 설정해주세요',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: exercise.exerciseName.isNotEmpty ? Colors.black87 : Colors.grey[400],
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _editExercise(exercise, index),
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF10B981),
                      size: 18,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _removeExercise(index),
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 세트 정보
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.repeat,
                      size: 16,
                      color: Color(0xFF10B981),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '세트 ${exercise.sets.length}개',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => _addSet(exercise),
                      icon: const Icon(
                        Icons.add,
                        size: 16,
                        color: Color(0xFF10B981),
                      ),
                      label: const Text(
                        '세트 추가',
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ),
                  ],
                ),
                if (exercise.sets.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ...exercise.sets.asMap().entries.map((entry) {
                    final setIndex = entry.key;
                    final set = entry.value;
                    return _buildSetRow(exercise, setIndex, set);
                  }),
                ] else ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.2),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '세트를 추가해주세요',
                          style: TextStyle(
                            color: Colors.grey[600],
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
        ],
      ),
    );
  }

  Widget _buildSetRow(PtExerciseEntry exercise, int setIndex, PtSetEntry set) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${setIndex + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: set.repsController,
                    decoration: const InputDecoration(
                      labelText: '횟수',
                      hintText: '12',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: set.weightController,
                    decoration: const InputDecoration(
                      labelText: '중량(kg)',
                      hintText: '60',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _removeSet(exercise, setIndex),
            icon: const Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  void _addExercise(Exercise exercise) {
    setState(() {
      _exercises.add(PtExerciseEntry(
        exerciseId: exercise.exerciseId,
        exerciseName: exercise.name,
      ));
    });
    _searchController.clear();
  }

  void _addCustomExercise() {
    setState(() {
      _exercises.add(PtExerciseEntry(
        exerciseId: DateTime.now().millisecondsSinceEpoch, // 임시 ID
        exerciseName: '',
      ));
    });
  }

  void _editExercise(PtExerciseEntry exercise, int index) {
    showDialog(
      context: context,
      builder: (context) => _ExerciseEditDialog(
        exercise: exercise,
        onSave: () {
          setState(() {});
        },
      ),
    );
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises[index].dispose();
      _exercises.removeAt(index);
    });
  }

  void _addSet(PtExerciseEntry exercise) {
    setState(() {
      exercise.sets.add(PtSetEntry());
    });
  }

  void _removeSet(PtExerciseEntry exercise, int setIndex) {
    setState(() {
      exercise.sets[setIndex].dispose();
      exercise.sets.removeAt(setIndex);
    });
  }

  void _saveAndClose() {
    // WorkoutLogEntry 리스트로 변환
    final workoutLogs = _exercises.map((exercise) => exercise.toWorkoutLogEntry()).toList();
    context.pop(workoutLogs);
  }
}

// PT 운동 항목 클래스
class PtExerciseEntry {
  final int exerciseId;
  String exerciseName;
  final List<PtSetEntry> sets;
  final TextEditingController notesController;

  PtExerciseEntry({
    required this.exerciseId,
    this.exerciseName = '',
    List<PtSetEntry>? sets,
  }) : sets = sets ?? [],
       notesController = TextEditingController();

  factory PtExerciseEntry.fromWorkoutLog(WorkoutLogEntry log) {
    return PtExerciseEntry(
      exerciseId: log.exerciseId,
      exerciseName: '', // 운동 이름은 initState에서 설정됨
      sets: log.sets.map((set) => PtSetEntry.fromWorkoutSet(set)).toList(),
    );
  }

  WorkoutLogEntry toWorkoutLogEntry() {
    return WorkoutLogEntry(
      exerciseId: exerciseId,
      sets: sets.map((set) => set.toWorkoutSet()).toList(),
      notes: notesController.text.isNotEmpty ? notesController.text : null,
    );
  }

  WorkoutExerciseCreate toWorkoutExerciseCreate(int order) {
    return WorkoutExerciseCreate(
      exerciseId: exerciseId,
      order: order,
      workoutSets: sets.asMap().entries.map((entry) {
        final setIndex = entry.key;
        final set = entry.value;
        return set.toWorkoutSetCreate(setIndex);
      }).toList(),
    );
  }

  void dispose() {
    notesController.dispose();
    for (var set in sets) {
      set.dispose();
    }
  }
}

// PT 세트 항목 클래스
class PtSetEntry {
  final TextEditingController repsController;
  final TextEditingController weightController;

  PtSetEntry()
      : repsController = TextEditingController(),
        weightController = TextEditingController();

  factory PtSetEntry.fromWorkoutSet(WorkoutSet set) {
    return PtSetEntry()
      ..repsController.text = set.reps.toString()
      ..weightController.text = set.weight > 0 ? set.weight.toString() : '';
  }

  WorkoutSet toWorkoutSet() {
    return WorkoutSet(
      reps: int.tryParse(repsController.text) ?? 0,
      weight: double.tryParse(weightController.text) ?? 0.0,
    );
  }

  WorkoutSetCreate toWorkoutSetCreate(int order) {
    return WorkoutSetCreate(
      order: order,
      weight: double.tryParse(weightController.text) ?? 0.0,
      reps: int.tryParse(repsController.text) ?? 0,
      feedback: null, // 피드백은 별도로 추가할 수 있음
    );
  }

  void dispose() {
    repsController.dispose();
    weightController.dispose();
  }
}

// 운동 편집 다이얼로그
class _ExerciseEditDialog extends StatefulWidget {
  final PtExerciseEntry exercise;
  final VoidCallback onSave;

  const _ExerciseEditDialog({
    required this.exercise,
    required this.onSave,
  });

  @override
  State<_ExerciseEditDialog> createState() => _ExerciseEditDialogState();
}

class _ExerciseEditDialogState extends State<_ExerciseEditDialog> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.exercise.exerciseName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        '운동 편집',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'IBMPlexSansKR',
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '운동 이름',
                hintText: '예: 벤치프레스',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: widget.exercise.notesController,
              decoration: const InputDecoration(
                labelText: '운동 메모',
                hintText: '폼 체크 포인트, 느낌 등',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.exercise.exerciseName = _nameController.text;
            widget.onSave();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
          ),
          child: const Text(
            '저장',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ),
      ],
    );
  }
}