import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../trainer_clients/view/trainer_clients_list_view.dart';
import '../../pt_contract/viewmodel/pt_contract_viewmodel.dart';
import '../../pt_offerings/viewmodel/pt_offering_viewmodel.dart';
import '../../pt_applications/viewmodel/pt_application_viewmodel.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/notion_dashboard_card.dart';

class TrainerPTMainView extends ConsumerStatefulWidget {
  const TrainerPTMainView({super.key});

  @override
  ConsumerState<TrainerPTMainView> createState() => _TrainerPTMainViewState();
}

class _TrainerPTMainViewState extends ConsumerState<TrainerPTMainView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider);
      if (user?.id != null) {
        final trainerId = int.parse(user!.id);
        ref.read(ptOfferingProvider.notifier).loadPtOfferings(trainerId);
        ref.read(ptApplicationProvider.notifier).loadPtApplications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ptOfferingsAsync = ref.watch(ptOfferingProvider);
    final ptApplicationsAsync = ref.watch(ptApplicationProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'PT 관리',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'IBMPlexSansKR',
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PT 현황 요약
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF10B981), Color(0xFF34D399)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.analytics,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PT 현황',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                            Text(
                              '현재 운영 중인 PT 상품과 신청 현황',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontFamily: 'IBMPlexSansKR',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'PT 상품',
                          value: ptOfferingsAsync.when(
                            data: (offerings) => offerings.length.toString(),
                            loading: () => '...',
                            error: (_, __) => '0',
                          ),
                          subtitle: '개',
                          color: const Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'PT 신청',
                          value: ptApplicationsAsync.when(
                            data: (applications) => applications.length.toString(),
                            loading: () => '...',
                            error: (_, __) => '0',
                          ),
                          subtitle: '건',
                          color: const Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // PT 관리 메뉴
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF34D399)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.dashboard_customize,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'PT 관리 메뉴',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: NotionDashboardCard(
                          title: '회원 관리',
                          value: '내 회원 보기',
                          icon: Icons.people,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TrainerClientsListView(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: NotionDashboardCard(
                          title: 'PT 상품 관리',
                          value: '상품 보기',
                          icon: Icons.shopping_bag,
                          onTap: () {
                            context.push('/pt-offerings');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: NotionDashboardCard(
                          title: 'PT 계약 관리',
                          value: '계약 현황',
                          icon: Icons.assignment_turned_in,
                          onTap: () {
                            context.push('/pt-contracts');
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: NotionDashboardCard(
                          title: 'PT 신청 관리',
                          value: '신청 현황',
                          icon: Icons.assignment,
                          onTap: () {
                            context.push('/pt-applications');
                          },
                        ),
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w600,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
              const SizedBox(width: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'IBMPlexSansKR',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}