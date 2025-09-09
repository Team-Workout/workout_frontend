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
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: Container(),
      ),
      body: trainersState.when(
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

                return _buildSwipeableTrainerView(displayTrainers);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
    );
  }

  Widget _buildSwipeableTrainerView(List<TrainerProfile> trainers) {
    return PageView.builder(
      itemCount: trainers.length,
      itemBuilder: (context, index) {
        return _buildFullScreenTrainerCard(trainers[index], index, trainers.length);
      },
    );
  }

  Widget _buildFullScreenTrainerCard(TrainerProfile trainer, int currentIndex, int totalCount) {
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
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // 전체 화면 배경 이미지
            trainer.profileImageUrl != null && trainer.profileImageUrl!.isNotEmpty
                ? Builder(
                    builder: (context) {
                      final imageUrl = trainer.profileImageUrl!.startsWith('http')
                          ? trainer.profileImageUrl!
                          : trainer.profileImageUrl!.startsWith('/')
                              ? '${ApiConfig.imageBaseUrl}${trainer.profileImageUrl!}'
                              : '${ApiConfig.imageBaseUrl}/images/${trainer.profileImageUrl!}';
                      return Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF10B981),
                                  Color(0xFF34D399),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.person,
                                size: 120,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF10B981),
                          Color(0xFF34D399),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size: 120,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
            
            // 그라디언트 오버레이
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            
            // 페이지 인디케이터
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${currentIndex + 1} / $totalCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            // 트레이너 정보 카드 (하단) - 높이 줄임
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85), // 반투명 흰색
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 이름
                    Text(
                      trainer.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'IBMPlexSansKR',
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // 해시태그 스타일 전문 분야
                    if (trainer.specialties.isNotEmpty)
                      Text(
                        trainer.specialties.map((specialty) => '#$specialty').join(' '),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'IBMPlexSansKR',
                          height: 1.4,
                        ),
                      ),
                    
                    const SizedBox(height: 12),
                    
                    // 소개 (한 줄로 제한)
                    if (trainer.introduction != null && trainer.introduction!.isNotEmpty)
                      Text(
                        trainer.introduction!,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14,
                          fontFamily: 'IBMPlexSansKR',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    
                    const SizedBox(height: 16),
                    
                    // 액션 버튼 (높이 줄임)
                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF34D399)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
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
                          borderRadius: BorderRadius.circular(24),
                          child: const Center(
                            child: Text(
                              '프로필 보기',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          ),
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
}