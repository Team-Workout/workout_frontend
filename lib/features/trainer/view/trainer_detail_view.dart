import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../model/trainer_model.dart';
import '../repository/trainer_repository.dart';
import '../viewmodel/trainer_viewmodel.dart';
import '../../../core/config/api_config.dart';
import '../../../services/image_cache_manager.dart';
import '../../pt_offerings/view/pt_offerings_list_view.dart';

class TrainerDetailView extends ConsumerStatefulWidget {
  final int trainerId;
  final TrainerProfile? trainer; // optional fallback data

  const TrainerDetailView({
    super.key,
    required this.trainerId,
    this.trainer,
  });

  @override
  ConsumerState<TrainerDetailView> createState() => _TrainerDetailViewState();
}

class _TrainerDetailViewState extends ConsumerState<TrainerDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TrainerProfile? _trainerProfile;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadTrainerProfile();
  }

  Future<void> _loadTrainerProfile() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Use fallback data if available, otherwise load from API
      if (widget.trainer != null) {
        _trainerProfile = widget.trainer;
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 먼저 캐시된 데이터 확인
      final viewModel = ref.read(trainerProfileViewModelProvider.notifier);
      final cachedProfile = viewModel.getCachedTrainerById(widget.trainerId);

      if (cachedProfile != null) {
        _trainerProfile = cachedProfile;
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 캐시에 없으면 API 호출
      final repository = ref.read(trainerRepositoryProvider);
      final profile = await repository.getTrainerProfileById(widget.trainerId);

      setState(() {
        _trainerProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Stack(
          children: [
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '트레이너 정보를 불러오는 중...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ],
              ),
            ),
            // 플로팅 백 버튼
            Positioned(
              top: 60,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null || _trainerProfile == null) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to load trainer profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _error ?? 'Unknown error occurred',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _loadTrainerProfile,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3498DB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 플로팅 백 버튼
            Positioned(
              top: 60,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Safe access to trainer profile
    final trainer = _trainerProfile;
    if (trainer == null) {
      return Scaffold(
        body: const Center(
          child: Text('Trainer data not available'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          // 메인 컨텐츠 - 전체 화면 스크롤 가능
          SingleChildScrollView(
            child: Column(
              children: [
                // Trainer Profile Header with Image Background (전체 화면 활용)
                Container(
                  height: 380, // 더 큰 높이로 상품이 더 강조되도록
                  width: double.infinity,
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
                  child: Stack(
                    children: [
                      // 배경 이미지
                      if (trainer.profileImageUrl != null &&
                          trainer.profileImageUrl!.isNotEmpty)
                        Positioned.fill(
                          child: Image.network(
                            trainer.profileImageUrl!.startsWith('http')
                                ? trainer.profileImageUrl!
                                : trainer.profileImageUrl!.startsWith('/')
                                    ? '${ApiConfig.imageBaseUrl}${trainer.profileImageUrl!}'
                                    : '${ApiConfig.imageBaseUrl}/images/${trainer.profileImageUrl!}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              final imageUrl = trainer.profileImageUrl!
                                      .startsWith('http')
                                  ? trainer.profileImageUrl!
                                  : trainer.profileImageUrl!.startsWith('/')
                                      ? '${ApiConfig.imageBaseUrl}${trainer.profileImageUrl!}'
                                      : '${ApiConfig.imageBaseUrl}/images/${trainer.profileImageUrl!}';

                              print(
                                  '❌ Failed to load trainer detail image: $imageUrl');
                              print('Error: $error');

                              // 404 에러인 경우 default-profile.png로 fallback 시도
                              if (error.toString().contains('404') &&
                                  !imageUrl.contains('default-profile.png')) {
                                final defaultImageUrl =
                                    '${ApiConfig.imageBaseUrl}/images/default-profile.png';
                                print(
                                    '🔄 Trying fallback to default image: $defaultImageUrl');
                                return Image.network(
                                  defaultImageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print(
                                        '❌ Even default image failed in detail: $defaultImageUrl');
                                    return Container();
                                  },
                                );
                              }

                              return Container();
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
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
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
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      // 트레이너 정보 (프로필 아바타 제거)
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
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              trainer.specialties.isNotEmpty
                                  ? trainer.specialties.take(2).join(', ')
                                  : '시니어 퍼스널 트레이너',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Specialties Section - 해시태그 스타일
                if (trainer.specialties.isNotEmpty) ...[
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '전문 분야',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            fontFamily: 'IBMPlexSansKR',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: trainer.specialties
                              .map((specialty) => Text(
                                    '#$specialty',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF10B981),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'IBMPlexSansKR',
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],

                // Tab Bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.black,
                    indicatorWeight: 2,
                    onTap: (index) {
                      // 탭 클릭 시 상태 업데이트를 위해 강제로 리빌드
                      setState(() {});
                    },
                    tabs: const [
                      Tab(text: '자격증'),
                      Tab(text: '수상'),
                      Tab(text: '경력'),
                      Tab(text: 'PT 상품'),
                    ],
                  ),
                ),

                // Tab Content - 동적 높이로 콘텐츠에 맞게 조절
                AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, child) {
                    Widget currentTab;
                    switch (_tabController.index) {
                      case 0:
                        currentTab = _buildCertificationsTab();
                        break;
                      case 1:
                        currentTab = _buildAwardsTab();
                        break;
                      case 2:
                        currentTab = _buildExperienceTab();
                        break;
                      case 3:
                        currentTab = _buildPtOfferingsTab();
                        break;
                      default:
                        currentTab = _buildCertificationsTab();
                    }
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        key: ValueKey(_tabController.index),
                        child: currentTab,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 100), // 하단 여백
              ],
            ),
          ),
          // 플로팅 백 버튼 (상태바 영역 고려)
          Positioned(
            top: 60,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationsTab() {
    final trainer = _trainerProfile!;

    // Use real API data
    if (trainer.certifications.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 60, 20, 20), // 상단 패딩 증가
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_outlined,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '자격증 정보가 등록되지 않았습니다',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
            SizedBox(height: 8),
            Text(
              '자격증 정보가 여기에 표시됩니다',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20), // 상단 패딩 복원
      physics: const NeverScrollableScrollPhysics(), // 부모 스크롤과 통합
      shrinkWrap: true, // 콘텐츠 크기에 맞춤
      itemCount: trainer.certifications.length,
      itemBuilder: (context, index) {
        final cert = trainer.certifications[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200] ?? Colors.grey.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.verified,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cert.certificationName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cert.issuingOrganization,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600] ?? Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Acquired: ${cert.acquisitionDate}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500] ?? Colors.grey,
                      ),
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

  Widget _buildAwardsTab() {
    final trainer = _trainerProfile!;

    if (trainer.awards.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '수상 정보가 등록되지 않았습니다',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
            SizedBox(height: 8),
            Text(
              '수상 및 성과가 여기에 표시됩니다',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20), // 상단 패딩 복원
      physics: const NeverScrollableScrollPhysics(), // 부모 스크롤과 통합
      shrinkWrap: true, // 콘텐츠 크기에 맞춤
      itemCount: trainer.awards.length,
      itemBuilder: (context, index) {
        final award = trainer.awards[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200] ?? Colors.grey.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      award.awardName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${award.awardPlace} • ${award.awardDate}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600] ?? Colors.grey,
                      ),
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

  Widget _buildExperienceTab() {
    final trainer = _trainerProfile!;

    // 경력과 학력이 모두 비어있고, 소개도 없는 경우 빈 상태 표시
    if (trainer.workExperiences.isEmpty && 
        trainer.educations.isEmpty && 
        (trainer.introduction == null || trainer.introduction!.isEmpty)) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_outline,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '경력 정보가 등록되지 않았습니다',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'IBMPlexSansKR',
              ),
            ),
          ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20), // 상단 패딩 복원
      physics: const NeverScrollableScrollPhysics(), // 부모 스크롤과 통합
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Work Experience Section
          if (trainer.workExperiences.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[300] ?? Colors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.work_outline, color: Colors.black87),
                      SizedBox(width: 8),
                      Text(
                        '경력 사항',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...trainer.workExperiences.map((experience) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ${experience.workName}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '  ${experience.workPosition} - ${experience.workPlace}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600] ?? Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '  ${experience.workStart} ~ ${experience.workEnd ?? '현재'}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500] ?? Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],

          // Education Section
          if (trainer.educations.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[300] ?? Colors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.school_outlined, color: Colors.black87),
                      SizedBox(width: 8),
                      Text(
                        '학력',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...trainer.educations.map((education) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ${education.schoolName}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '  ${education.educationName} ${education.degree}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600] ?? Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '  ${education.startDate} ~ ${education.endDate ?? '재학중'}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500] ?? Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (trainer.introduction != null &&
              trainer.introduction!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[300] ?? Colors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.person_outline, color: Colors.black87),
                      SizedBox(width: 8),
                      Text(
                        '자기소개',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    trainer.introduction!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700] ?? Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPtOfferingsTab() {
    return PtOfferingsListView(
      key: const ValueKey('pt_offerings'),
      trainerId: widget.trainerId,
      isTrainerView: false,
    );
  }
}
