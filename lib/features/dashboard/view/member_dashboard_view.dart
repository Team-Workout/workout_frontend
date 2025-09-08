import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../body_composition/viewmodel/body_composition_viewmodel.dart';
import '../../settings/viewmodel/settings_viewmodel.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/config/api_config.dart';
import '../widgets/dashboard_weight_chart.dart';
import '../widgets/today_pt_schedule_card.dart';

class MemberDashboardView extends ConsumerStatefulWidget {
  const MemberDashboardView({super.key});

  @override
  ConsumerState<MemberDashboardView> createState() => _MemberDashboardViewState();
}

class _MemberDashboardViewState extends ConsumerState<MemberDashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 체성분 데이터 로드  
      ref.read(bodyCompositionNotifierProvider.notifier).loadBodyCompositions(
            startDate: DateTime.now().subtract(const Duration(days: 30)).toIso8601String().split('T')[0],
            endDate: DateTime.now().toIso8601String().split('T')[0],
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'IBMPlexSansKR',
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 오늘의 PT 일정 카드
              const TodayPTScheduleCard(),
              const SizedBox(height: 20),

              // 실제 체성분 데이터 카드 (기존 데이터 유지)
              _buildRealBodyStatsCard(),
              const SizedBox(height: 20),

              // 실제 체중 차트 카드 (기존 데이터 유지)
              _buildRealWeightChartCard(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
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
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            '피트프로',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
        GestureDetector(
          onTap: () => context.push('/settings'),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: _buildProfileAvatar(context),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final profileImageAsync = ref.watch(profileImageProvider);
        final user = ref.watch(currentUserProvider);

        return profileImageAsync.when(
          data: (profileImage) {
            if (profileImage?.profileImageUrl != null && profileImage!.profileImageUrl.isNotEmpty) {
              return _buildProfileImageAvatar(profileImage.profileImageUrl, user?.name);
            } else {
              return _buildProfileImageAvatar('/images/default-profile.png', user?.name);
            }
          },
          loading: () => CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF4CAF50),
            child: const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ),
          error: (_, __) => _buildProfileImageAvatar('/images/default-profile.png', user?.name),
        );
      },
    );
  }

  Widget _buildProfileImageAvatar(String imageUrl, String? userName) {
    // 상대 경로인 경우 baseUrl을 붙여서 완전한 URL로 만들기
    String fullImageUrl = imageUrl;
    if (!imageUrl.startsWith('http')) {
      final baseUrl = ApiConfig.baseUrl.replaceAll('/api', '');
      fullImageUrl = '$baseUrl${imageUrl.startsWith('/') ? '' : '/'}$imageUrl';
    }

    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.grey[200],
      child: ClipOval(
        child: Image.network(
          fullImageUrl,
          width: 32,
          height: 32,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: ClipOval(
                  child: Image.network(
                    '${ApiConfig.baseUrl.replaceAll('/api', '')}/images/default-profile.png',
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 16,
                      );
                    },
                  ),
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRealBodyStatsCard() {
    return Consumer(
      builder: (context, ref, child) {
        final bodyStats = ref.watch(bodyStatsProvider);

        if (bodyStats == null) {
          return Container(
            padding: const EdgeInsets.all(20),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '나의 통계',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'IBMPlexSansKR',
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.analytics_outlined,
                          size: 48,
                          color: const Color(0xFF10B981).withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '체성분 데이터가 없어요',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                          fontFamily: 'IBMPlexSansKR',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '체성분 페이지에서 첫 번째 기록을 추가해보세요!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'IBMPlexSansKR',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(20),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '나의 통계',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('현재 체중', bodyStats.currentWeight.toStringAsFixed(1), 'kg'),
                    _buildStatItem('체중 변화', '${bodyStats.weightChange >= 0 ? '+' : ''}${bodyStats.weightChange.toStringAsFixed(1)}', 'kg'),
                    _buildStatItem('BMI', bodyStats.bmi.toStringAsFixed(1), ''),
                    _buildStatItem('근육량', bodyStats.muscleMass.toStringAsFixed(1), 'kg'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRealWeightChartCard() {
    return Consumer(
      builder: (context, ref, child) {
        final compositionsAsync = ref.watch(bodyCompositionListProvider);

        return Container(
          padding: const EdgeInsets.all(20),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '체중 변화',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: compositionsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => const Center(child: Text('데이터를 불러올 수 없습니다')),
                  data: (compositions) => DashboardWeightChart(compositions: compositions),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, String unit) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontFamily: 'IBMPlexSansKR',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
              if (unit.isNotEmpty)
                TextSpan(
                  text: unit,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'IBMPlexSansKR',
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}