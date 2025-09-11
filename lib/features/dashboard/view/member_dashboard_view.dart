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
  ConsumerState<MemberDashboardView> createState() =>
      _MemberDashboardViewState();
}

class _MemberDashboardViewState extends ConsumerState<MemberDashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 체성분 데이터 로드
      ref.read(bodyCompositionNotifierProvider.notifier).loadBodyCompositions(
            startDate: DateTime.now()
                .subtract(const Duration(days: 30))
                .toIso8601String()
                .split('T')[0],
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
        body: SafeArea(
          child: SingleChildScrollView(
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
                    _buildStatItem('체중',
                        bodyStats.currentWeight.toStringAsFixed(1), ' kg'),
                    _buildStatItem(
                        '근육량', bodyStats.muscleMass.toStringAsFixed(1), ' kg'),
                    _buildStatItem('체지방률',
                        bodyStats.bodyFatPercentage.toStringAsFixed(1), ' %'),
                    _buildStatItem('BMI', bodyStats.bmi.toStringAsFixed(1), ''),
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
                  loading: () =>
                      const Center(child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                      )),
                  error: (error, _) =>
                      const Center(child: Text('데이터를 불러올 수 없습니다')),
                  data: (compositions) =>
                      DashboardWeightChart(compositions: compositions),
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
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  fontFamily: 'IBMPlexSansKR',
                  height: 1.0, // 라인 높이 통일
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
                    height: 1.0, // 같은 높이로 정렬
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
