import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../trainer/view/trainers_view.dart';
import '../../pt_contract/view/pt_contract_list_view.dart';
import '../../schedule/view/pt_schedule_view.dart';
import '../../pt_applications/view/pt_applications_list_view.dart';
import '../../pt_applications/viewmodel/pt_application_viewmodel.dart';

class PTMainView extends ConsumerStatefulWidget {
  const PTMainView({super.key});

  @override
  ConsumerState<PTMainView> createState() => _PTMainViewState();
}

class _PTMainViewState extends ConsumerState<PTMainView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          automaticallyImplyLeading: false,
          title: const Text(
            'PT 관리',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBMPlexSansKR',
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // 서브탭 바
            Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                indicator: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF34D399)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  fontFamily: 'IBMPlexSansKR',
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  fontFamily: 'IBMPlexSansKR',
                ),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.person_search, size: 14),
                    text: '트레이너',
                  ),
                  Tab(
                    icon: Icon(Icons.assignment, size: 14),
                    text: '계약 목록',
                  ),
                  Tab(
                    icon: Icon(Icons.schedule, size: 14),
                    text: '시간표',
                  ),
                  Tab(
                    icon: Icon(Icons.pending_actions, size: 14),
                    text: 'PT 요청',
                  ),
                ],
              ),
            ),
            // 탭 뷰 콘텐츠
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _TrainersViewWrapper(),
                  _ContractListViewWrapper(),
                  _ScheduleViewWrapper(),
                  _ApplicationsViewWrapper(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 트레이너 목록을 AppBar 없이 표시하는 래퍼
class _TrainersViewWrapper extends StatelessWidget {
  const _TrainersViewWrapper();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: const TrainersView(),
    );
  }
}

// 계약 목록을 AppBar 없이 표시하는 래퍼
class _ContractListViewWrapper extends StatelessWidget {
  const _ContractListViewWrapper();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: const PtContractListView(),
    );
  }
}

// 시간표를 AppBar 없이 표시하는 래퍼  
class _ScheduleViewWrapper extends StatelessWidget {
  const _ScheduleViewWrapper();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: const PTScheduleView(),
    );
  }
}

// PT 신청을 AppBar 없이 표시하는 래퍼
class _ApplicationsViewWrapper extends StatelessWidget {
  const _ApplicationsViewWrapper();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FA),
      child: const _PtApplicationsContent(),
    );
  }
}

// PT 신청 내용만 표시하는 위젯 (AppBar 제외)
class _PtApplicationsContent extends ConsumerStatefulWidget {
  const _PtApplicationsContent();

  @override
  ConsumerState<_PtApplicationsContent> createState() => _PtApplicationsContentState();
}

class _PtApplicationsContentState extends ConsumerState<_PtApplicationsContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // PT applications provider 사용
      if (mounted) {
        try {
          ref.read(ptApplicationProvider.notifier).loadPtApplications();
        } catch (e) {
          // Provider가 없으면 에러 처리
          debugPrint('PT applications provider not available');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FA),
      child: Column(
        children: [
          // 헤더 영역
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Text(
                'PT 신청 내역',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IBMPlexSansKR',
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
          ),
          // 컨텐츠 영역
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildEmptyState(),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.pending_actions,
              size: 48,
              color: const Color(0xFF10B981).withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'PT 신청 내역이 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              fontFamily: 'IBMPlexSansKR',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '트레이너에게 PT를 신청해보세요!',
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
}