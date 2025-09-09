import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/workout_record_viewmodel.dart';
import '../service/workout_api_service.dart';
import '../service/local_storage_service.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/notion_colors.dart';
import '../widget/calendar_view.dart';
import '../widget/workout_record_tab.dart';
import '../widget/workout_routine_tab.dart';
import '../widget/workout_stats_tab.dart';
import 'routine_list_view.dart';

class WorkoutRecordView extends ConsumerStatefulWidget {
  const WorkoutRecordView({super.key});

  @override
  ConsumerState<WorkoutRecordView> createState() => _WorkoutRecordViewState();
}

class _WorkoutRecordViewState extends ConsumerState<WorkoutRecordView> {
  late WorkoutRecordViewmodel _viewModel;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Provider를 통해 서비스들을 주입받아 ViewModel 생성
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final workoutApiService = ref.read(workoutApiServiceProvider);
      final localStorageService = ref.read(localStorageServiceProvider);
      final authState = ref.read(authStateProvider);
      _viewModel = WorkoutRecordViewmodel(
          workoutApiService, localStorageService, authState);
      _initializeViewModel();
    });
  }

  Future<void> _initializeViewModel() async {
    await _viewModel.initializeLocale();
    // SQLite에서 오늘 날짜의 운동 기록 불러오기
    _viewModel.loadWorkoutForDate(_viewModel.selectedDate);
    _viewModel.initializeListeners();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.apply(
                fontFamily: 'IBMPlexSansKR',
              ),
        ),
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: SafeArea(
            child: Column(
              children: [
                // 탭바만 유지
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const TabBar(
                    labelColor: Color(0xFF10B981),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Color(0xFF10B981),
                    indicatorWeight: 3,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: 'IBMPlexSansKR',
                    ),
                    tabs: [
                      Tab(text: '운동 기록'),
                      Tab(text: '캘린더'),
                      Tab(text: '루틴'),
                      Tab(text: '분석'),
                    ],
                  ),
                ),
                // 탭바 뷰
                Expanded(
                  child: _isInitialized
                      ? ListenableBuilder(
                          listenable: _viewModel,
                          builder: (context, child) {
                            return TabBarView(
                              children: [
                                WorkoutRecordTab(viewModel: _viewModel),
                                CalendarView(viewModel: _viewModel),
                                const RoutineListView(),
                                const WorkoutStatsTab(),
                              ],
                            );
                          },
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
