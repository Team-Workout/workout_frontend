import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/trainer_viewmodel.dart';
import '../model/trainer_model.dart';
import '../../../core/config/api_config.dart';
import '../../../services/image_cache_manager.dart';
import 'trainer_detail_view.dart';
import '../../dashboard/widgets/notion_button.dart';

class TrainersView extends ConsumerStatefulWidget {
  const TrainersView({super.key});

  @override
  ConsumerState<TrainersView> createState() => _TrainersViewState();
}

class _TrainersViewState extends ConsumerState<TrainersView> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = '전체 트레이너';
  List<TrainerProfile> filteredTrainers = [];

  final Map<String, List<String>> categorySpecialties = {
    '전체 트레이너': [],
    '다이어트': ['Weight Loss', '체중감량', '다이어트'],
    '근력강화': ['Muscle Gain', '근력강화', '웨이트트레이닝'],
    '재활운동': ['Rehabilitation', '재활', '물리치료'],
  };

  final List<String> categories = [
    '전체 트레이너',
    '다이어트',
    '근력강화',
    '재활운동',
  ];

  @override
  void initState() {
    super.initState();
    // 헬스장 ID 1로 트레이너 목록 로드 (실제로는 로그인한 사용자의 헬스장 ID를 사용해야 함)
    Future.microtask(() {
      ref.read(trainerProfileViewModelProvider.notifier).loadTrainersByGymId(1);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TrainerProfile> _filterTrainersByCategory(List<TrainerProfile> trainers, String category) {
    if (category == '전체 트레이너') {
      return trainers;
    }

    final specialtiesToMatch = categorySpecialties[category] ?? [];
    if (specialtiesToMatch.isEmpty) {
      return trainers;
    }

    return trainers.where((trainer) {
      return trainer.specialties.any((specialty) =>
          specialtiesToMatch.any((match) =>
              specialty.toLowerCase().contains(match.toLowerCase())));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final trainersState = ref.watch(trainerProfileViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
        automaticallyImplyLeading: false, // 뒤로가기 버튼 제거 (네비게이션 바 사용)
        title: const Text(
          'PT 트레이너 선택',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBMPlexSansKR',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      fontFamily: 'IBMPlexSansKR',
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: '트레이너를 검색하세요...',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontFamily: 'IBMPlexSansKR',
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF10B981)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                    onChanged: (value) {
                      ref.read(trainerProfileViewModelProvider.notifier).searchTrainers(value);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 44, // 높이를 36에서 44로 증가
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: isSelected 
                                  ? const LinearGradient(
                                      colors: [Color(0xFF10B981), Color(0xFF34D399), Color(0xFF6EE7B7)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              color: isSelected ? null : const Color(0xFF10B981).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF10B981).withValues(alpha: isSelected ? 0.8 : 0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? Colors.white : const Color(0xFF10B981),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'IBMPlexSansKR',
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: trainersState.when(
              data: (trainers) {
                // 카테고리 필터링 적용
                final displayTrainers = _filterTrainersByCategory(trainers, selectedCategory);
                
                if (displayTrainers.isEmpty) {
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
                          selectedCategory == '전체 트레이너' 
                              ? '트레이너를 찾을 수 없습니다'
                              : '$selectedCategory 전문 트레이너를 찾을 수 없습니다',
                          style: const TextStyle(
                            fontSize: 16, 
                            color: Colors.grey,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        selectedCategory == '전체 트레이너' 
                            ? '이용 가능한 트레이너 (${displayTrainers.length}명)'
                            : '$selectedCategory 전문 트레이너 (${displayTrainers.length}명)',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                    ),
                    ...displayTrainers.map((trainer) => _buildTrainerCard(trainer)),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerCard(TrainerProfile trainer) {
    return GestureDetector(
      onTap: () {
        // 트레이너 상세 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrainerDetailView(
              trainerId: trainer.trainerId,
              trainer: trainer,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  // 배경 이미지 또는 그라디언트
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: trainer.profileImageUrl != null && trainer.profileImageUrl!.isNotEmpty
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              Builder(
                                builder: (context) {
                                  final imageUrl = trainer.profileImageUrl!.startsWith('http')
                                      ? trainer.profileImageUrl!
                                      : trainer.profileImageUrl!.startsWith('/')
                                          ? '${ApiConfig.imageBaseUrl}${trainer.profileImageUrl!}'
                                          : '${ApiConfig.imageBaseUrl}/images/${trainer.profileImageUrl!}';
                                  print('🔍 Loading trainer image: $imageUrl (original: ${trainer.profileImageUrl})');
                                  return Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      print('❌ Failed to load trainer image: $imageUrl');
                                      print('Error: $error');
                                      
                                      // 404 에러인 경우 default-profile.png로 fallback 시도
                                      if (error.toString().contains('404') && !imageUrl.contains('default-profile.png')) {
                                        final defaultImageUrl = '${ApiConfig.imageBaseUrl}/images/default-profile.png';
                                        print('🔄 Trying fallback to default image: $defaultImageUrl');
                                        return Image.network(
                                          defaultImageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            print('❌ Even default image failed: $defaultImageUrl');
                                            return Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    const Color(0xFF10B981).withOpacity(0.8),
                                                    const Color(0xFF34D399).withOpacity(0.9),
                                                  ],
                                                ),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.person,
                                                  size: 60,
                                                  color: Colors.white.withOpacity(0.5),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                      
                                      // 다른 에러이거나 이미 default인 경우 그라디언트 표시
                                      return Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              const Color(0xFF10B981).withOpacity(0.8),
                                              const Color(0xFF34D399).withOpacity(0.9),
                                            ],
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                      );
                                    },
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              const Color(0xFF10B981).withOpacity(0.8),
                                              const Color(0xFF34D399).withOpacity(0.9),
                                            ],
                                          ),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              // 어두운 그라디언트 오버레이
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFF10B981).withOpacity(0.8),
                                  const Color(0xFF34D399).withOpacity(0.9),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                  ),
                  // 트레이너 정보 (원형 아바타 제거)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          trainer.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          trainer.specialties.isNotEmpty 
                              ? trainer.specialties.take(2).join(', ')
                              : '시니어 퍼스널 트레이너',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 전문 분야 표시 - 해시태그 스타일
                  if (trainer.specialties.isNotEmpty)
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: trainer.specialties.map((specialty) {
                        return Text(
                          '#$specialty',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 12),
                  if (trainer.introduction != null && trainer.introduction!.isNotEmpty)
                    Text(
                      trainer.introduction!,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      NotionButton(
                        onPressed: () {
                          // 트레이너 상세 페이지로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrainerDetailView(
                                trainerId: trainer.trainerId,
                                trainer: trainer,
                              ),
                            ),
                          );
                        },
                        text: '프로필 보기',
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
}