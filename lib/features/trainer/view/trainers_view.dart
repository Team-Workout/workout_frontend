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

                return _buildGridTrainerView(displayTrainers);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
    );
  }

  Widget _buildGridTrainerView(List<TrainerProfile> trainers) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2x2 그리드
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7, // 세로가 긴 비율 (사람 몸사진용)
        ),
        itemCount: trainers.length,
        itemBuilder: (context, index) {
          return _buildGridTrainerCard(trainers[index]);
        },
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

  Widget _buildGridTrainerCard(TrainerProfile trainer) {
    return GestureDetector(
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // 배경 이미지
              Container(
                width: double.infinity,
                height: double.infinity,
                child: trainer.profileImageUrl != null && trainer.profileImageUrl!.isNotEmpty
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
                                    size: 40,
                                    color: Colors.white.withOpacity(0.7),
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
                            size: 40,
                            color: Colors.white.withOpacity(0.7),
                          ),
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
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.4),
                    ],
                  ),
                ),
              ),
              
              // 하단 정보 (고정 높이 바텀시트)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 80, // 고정 높이 설정
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2), // 매우 투명하게 설정
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                    children: [
                      // 이름 (가독성 높임)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7), // 텍스트 배경 추가
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          trainer.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // 흰색으로 대비 높임
                            fontFamily: 'IBMPlexSansKR',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // 전문 분야 (가독성 높임)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.9), // 배경 추가
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          trainer.specialties.isNotEmpty 
                              ? trainer.specialties.take(2).map((s) => '#$s').join(' ')
                              : '#전문분야 미등록', // 기본값
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
            
            // 트레이너 정보 카드 (고정 높이)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 200, // 고정 높이 설정 (이름, 설명, 전공, 버튼 모두 보일 정도)
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3), // 더 투명하게 조정
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // 공간 균등 분배
                  children: [
                    // 상단 정보 영역
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 이름 (가독성 높임)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              trainer.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // 해시태그 스타일 전문 분야 (가독성 높임)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              trainer.specialties.isNotEmpty 
                                  ? trainer.specialties.map((specialty) => '#$specialty').join(' ')
                                  : '#전문분야 미등록', // 기본값
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // 소개 (가독성 높임)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              trainer.introduction?.isNotEmpty == true 
                                  ? trainer.introduction!
                                  : '트레이너 소개가 등록되지 않았습니다.', // 기본값
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // 액션 버튼
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